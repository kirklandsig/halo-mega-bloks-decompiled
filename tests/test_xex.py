import hashlib
import struct

import pytest
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

import paths
import xex

ENTRY = 0x83ECAA78
BASE = 0x82000000
SIZE = 0x24C0000


def synthetic_header(file_key=b'\x11' * 16):
    """An XEX2 header with this XEX's values: 15 optional headers, normal
    compression (window 0x8000) and AES encryption."""
    keys = [0x2FF, 0x3FF, 0x10100, 0x10201, 0x103FF, 0x18002, 0x18102, 0x183FF, 0x200FF, 0x20104,
            0x20200, 0x30000, 0x40006, 0x40201, 0x40404]
    sec_off = 0x110
    ffi_off = 0x400
    pe_off = 0x1000
    data = bytearray(pe_off)
    struct.pack_into('>4sIIIII', data, 0, b'XEX2', 1, pe_off, 0, sec_off, len(keys))
    for i, k in enumerate(keys):
        value = {0x3FF: ffi_off, 0x10100: ENTRY, 0x10201: BASE}.get(k, 0x800)
        struct.pack_into('>II', data, 0x18 + 8 * i, k, value)
    struct.pack_into('>IHHI', data, ffi_off, 0x24, 1, 2, 0x8000)
    struct.pack_into('>II', data, sec_off, 0x3000, SIZE)
    struct.pack_into('>I', data, sec_off + 0x110, BASE)
    data[sec_off + 0x150:sec_off + 0x160] = file_key
    return bytes(data)


def test_parse_header_fields():
    h = xex.parse_header(synthetic_header())
    assert len(h.optional) == 15
    assert (h.encryption, h.compression, h.window_size) == (1, 2, 0x8000)
    assert (h.image_base, h.entry_point, h.image_size) == (BASE, ENTRY, SIZE)
    assert (h.pe_offset, h.security_offset, h.module_flags) == (0x1000, 0x110, 1)
    assert h.file_key == b'\x11' * 16


def test_parse_header_bad_magic():
    with pytest.raises(ValueError):
        xex.parse_header(b'XEX1' + synthetic_header()[4:])


def test_session_key_devkit_and_retail_differ():
    k = bytes(range(16))
    assert xex.session_key(k, devkit=False) != xex.session_key(k, devkit=True)
    dec = Cipher(algorithms.AES(bytes(16)), modes.ECB()).decryptor()
    assert xex.session_key(k, devkit=True) == dec.update(k) + dec.finalize()


def test_extract_basefile_normal_compression():
    """A devkit-keyed XEX whose payload is one block of one LZX chunk."""
    from test_lzx import uncompressed_stream
    image = b'MZ' + bytes(range(256)) * 4
    chunk = uncompressed_stream(image)
    block = struct.pack('>I', 0) + bytes(20) + struct.pack('>H', len(chunk)) + chunk + b'\0\0'
    block += bytes(-len(block) % 16)
    header = bytearray(synthetic_header(file_key=b'\x22' * 16))
    struct.pack_into('>II', header, 0x110, 0x3000, len(image))
    struct.pack_into('>I', header, 0x400 + 12, len(block))  # first block size; hash follows
    header[0x400 + 16:0x400 + 36] = hashlib.sha1(block).digest()
    key = xex.session_key(b'\x22' * 16, devkit=True)
    enc = Cipher(algorithms.AES(key), modes.CBC(bytes(16))).encryptor()
    data = bytes(header) + enc.update(block) + enc.finalize()
    assert xex.extract_basefile(data) == image


@pytest.mark.orig
def test_basefile(orig_xex, orig_pdb):
    import pefile
    from pdbfile import Pdb
    path = paths.basefile()
    if not path.exists():
        pytest.skip(f'{path} not present (run tools/xex.py)')
    image = path.read_bytes()
    assert len(image) == SIZE
    assert image[:2] == b'MZ'
    pe = pefile.PE(data=image, fast_load=True)
    assert pe.FILE_HEADER.Machine == 0x1F2
    procs = list(Pdb(orig_pdb).procedures())
    mflr = sum(1 for p in procs if image[p.rva:p.rva + 4] == bytes.fromhex('7D8802A6'))
    assert mflr / len(procs) >= 0.30


def test_decrypted_xex_roundtrip():
    """XenonRecomp only knows the retail key; this XEX is devkit-signed, so it is fed a decrypted copy."""
    from test_lzx import uncompressed_stream
    image = b'MZ' + bytes(range(256)) * 4
    chunk = uncompressed_stream(image)
    block = struct.pack('>I', 0) + bytes(20) + struct.pack('>H', len(chunk)) + chunk + b'\0\0'
    block += bytes(-len(block) % 16)
    header = bytearray(synthetic_header(file_key=b'\x22' * 16))
    struct.pack_into('>II', header, 0x110, 0x3000, len(image))
    struct.pack_into('>I', header, 0x400 + 12, len(block))
    header[0x400 + 16:0x400 + 36] = hashlib.sha1(block).digest()
    enc = Cipher(algorithms.AES(xex.session_key(b'\x22' * 16, devkit=True)), modes.CBC(bytes(16))).encryptor()
    data = bytes(header) + enc.update(block) + enc.finalize()
    plain = xex.decrypted_xex(data)
    assert xex.parse_header(plain).encryption == 0
    assert plain[0x1000:] == block
    assert xex.extract_basefile(plain) == image
