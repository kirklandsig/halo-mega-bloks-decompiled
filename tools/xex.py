"""Unpacks an Xbox 360 XEX2 into its PE image (the basefile): parses the
header, derives the session key, AES-CBC-decrypts the payload and
LZX-decompresses it. Xenia's xex_module.cc (BSD) is the reference.

    python tools/xex.py [xex] -o orig/MegaHaloGame.exe [--decrypted orig/MegaHaloGame.dec.xex]

The normal-compression payload is a chain of blocks. Each block starts with
the next block's size and SHA-1, then holds chunks (a big-endian u16 size,
then data) up to a chunk of size 0. The chunks, concatenated, are one LZX
stream of 32 KB frames.
"""
import argparse
import hashlib
import struct
import sys
from dataclasses import dataclass, field

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

import lzx
import paths

RETAIL_KEY = bytes.fromhex('20B185A59D28FDC340583FBB0896BF91')
DEVKIT_KEY = bytes(16)

FILE_FORMAT_INFO = 0x000003FF
ENTRY_POINT = 0x00010100
IMAGE_BASE_ADDRESS = 0x00010201


@dataclass
class XexHeader:
    module_flags: int
    pe_offset: int
    security_offset: int
    optional: dict = field(default_factory=dict)
    image_base: int = 0
    entry_point: int = 0
    image_size: int = 0
    encryption: int = 0
    compression: int = 0
    window_size: int = 0
    first_block: tuple = (0, b'')  # (size, SHA-1) for normal compression
    basic_blocks: list = field(default_factory=list)  # (data size, zero size)
    file_key: bytes = b''


def parse_header(data):
    if data[:4] != b'XEX2':
        raise ValueError('not an XEX2 file')
    module_flags, pe_offset, _reserved, sec, count = struct.unpack_from('>IIIII', data, 4)
    optional = dict(struct.unpack_from('>II', data, 0x18 + 8 * i) for i in range(count))
    image_size, = struct.unpack_from('>I', data, sec + 4)
    load_address, = struct.unpack_from('>I', data, sec + 0x110)
    h = XexHeader(module_flags, pe_offset, sec, optional, image_base=optional.get(IMAGE_BASE_ADDRESS, load_address),
                  entry_point=optional.get(ENTRY_POINT, 0), image_size=image_size,
                  file_key=bytes(data[sec + 0x150:sec + 0x160]))
    if FILE_FORMAT_INFO in optional:
        off = optional[FILE_FORMAT_INFO]
        info_size, h.encryption, h.compression = struct.unpack_from('>IHH', data, off)
        if h.compression == 1:
            h.basic_blocks = [struct.unpack_from('>II', data, p) for p in range(off + 8, off + info_size, 8)]
        elif h.compression == 2:
            h.window_size, size = struct.unpack_from('>II', data, off + 8)
            h.first_block = (size, bytes(data[off + 16:off + 36]))
    return h


def session_key(file_key, devkit):
    dec = Cipher(algorithms.AES(DEVKIT_KEY if devkit else RETAIL_KEY), modes.ECB()).decryptor()
    return dec.update(file_key) + dec.finalize()


def _decrypt(payload, key):
    payload = payload[:len(payload) - len(payload) % 16]
    dec = Cipher(algorithms.AES(key), modes.CBC(bytes(16))).decryptor()
    return dec.update(payload) + dec.finalize()


def _chunks(payload, first_block):
    """The LZX stream of a normal-compression payload; each block's SHA-1 is checked."""
    out = []
    size, digest = first_block
    pos = 0
    while size:
        block = payload[pos:pos + size]
        if len(block) != size or hashlib.sha1(block).digest() != digest:
            raise ValueError(f'XEX: block at 0x{pos:X} fails its SHA-1')
        size, = struct.unpack_from('>I', block, 0)
        digest = block[4:24]
        p = 24
        while True:
            n, = struct.unpack_from('>H', block, p)
            p += 2
            if n == 0:
                break
            out.append(block[p:p + n])
            p += n
        pos += len(block)
    return b''.join(out)


def _unpack(h, payload):
    if h.compression == 0:
        return payload[:h.image_size]
    if h.compression == 1:
        out, pos = bytearray(), 0
        for size, zeros in h.basic_blocks:
            out += payload[pos:pos + size] + bytes(zeros)
            pos += size
        return bytes(out[:h.image_size])
    if h.compression == 2:
        stream = _chunks(payload, h.first_block)
        return lzx.decompress(stream, h.window_size.bit_length() - 1, h.image_size)
    raise ValueError(f'XEX: unsupported compression {h.compression}')


def _plain(data):
    """(header, decrypted payload, image). The payload is decrypted with the
    retail key, then the devkit key; the one whose blocks check out and whose
    image starts with MZ wins."""
    h = parse_header(data)
    payload = data[h.pe_offset:]
    if h.encryption == 0:
        return h, payload, _unpack(h, payload)
    errors = []
    for devkit in (False, True):
        plain = _decrypt(payload, session_key(h.file_key, devkit))
        try:
            image = _unpack(h, plain)
        except (ValueError, struct.error, IndexError) as e:
            errors.append(f'{"devkit" if devkit else "retail"}: {e}')
            continue
        if image[:2] == b'MZ':
            return h, plain + payload[len(plain):], image
        errors.append(f'{"devkit" if devkit else "retail"}: no MZ')
    raise ValueError('XEX: no key gives a PE image (' + '; '.join(errors) + ')')


def extract_basefile(data):
    """The PE image."""
    return _plain(data)[2]


def decrypted_xex(data):
    """The XEX with its payload decrypted and its encryption type set to 0
    (for tools such as XenonRecomp that know only the retail key)."""
    h, plain, _ = _plain(data)
    header = bytearray(data[:h.pe_offset])
    if FILE_FORMAT_INFO in h.optional:
        struct.pack_into('>H', header, h.optional[FILE_FORMAT_INFO] + 4, 0)
    return bytes(header) + plain


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the PE image (basefile) of an XEX2.')
    ap.add_argument('xex', nargs='?', default=None)
    ap.add_argument('-o', '--out', default=None, help='default: orig/MegaHaloGame.exe')
    ap.add_argument('--decrypted', default=None, help='also write a decrypted copy of the XEX here')
    args = ap.parse_args(argv)
    src = paths.require(args.xex or paths.xex())
    data = src.read_bytes()
    h = parse_header(data)
    print(f'image base 0x{h.image_base:08X}  size 0x{h.image_size:X}  entry 0x{h.entry_point:08X}  '
          f'{len(h.optional)} optional headers  encryption {h.encryption}  compression {h.compression}')
    image = extract_basefile(data)
    out = paths.Path(args.out) if args.out else paths.basefile()
    out.write_bytes(image)
    print(f'wrote {out}: {len(image)} bytes, sha256 {hashlib.sha256(image).hexdigest()}')
    if args.decrypted:
        paths.Path(args.decrypted).write_bytes(decrypted_xex(data))
        print(f'wrote {args.decrypted}')


if __name__ == '__main__':
    sys.exit(main())
