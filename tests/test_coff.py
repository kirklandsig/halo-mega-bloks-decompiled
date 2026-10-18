import struct

import coff

# mflr r12 ; bl h ; $M label ; lis r11,x@ha ; lfs f1,x@l(r11) ; blr
CODE = bytes.fromhex('7d8802a6' '48000001' '3d600000' 'c02b0000' '4e800020')


def symbol(name, value, section, storage, bigobj):
    raw = name.encode().ljust(8, b'\0')
    if bigobj:
        return raw + struct.pack('<IiHBB', value, section, 0x20, storage, 0)
    return raw + struct.pack('<IhHBB', value, section, 0x20, storage, 0)


def build(bigobj=False):
    syms = [symbol('.text', 0, 1, 3, bigobj), symbol('?f@@YAX', 0, 1, 2, bigobj),
            symbol('$M1', 8, 1, 6, bigobj), symbol('?h@@YAX', 0, 0, 2, bigobj),
            symbol('x', 0, 0, 2, bigobj)]
    relocs = [(4, 3, 0x0006), (8, 4, 0x0010), (8, 0, 0x0012), (12, 4, 0x0011), (12, 0, 0x0012)]
    head = 56 if bigobj else 20
    code_at = head + 40
    reloc_at = code_at + len(CODE)
    sym_at = reloc_at + 10 * len(relocs)
    if bigobj:
        header = struct.pack('<HHHHI', 0, 0xFFFF, 2, 0x1F2, 0) + coff.BIGOBJ_CLASSID + struct.pack(
            '<IIIIIII', 0, 0, 0, 0, 1, sym_at, len(syms))
    else:
        header = struct.pack('<HHIIIHH', 0x1F2, 1, 0, sym_at, len(syms), 0, 0)
    section = b'.text\0\0\0' + struct.pack('<IIIIIIHHI', 0, 0, len(CODE), code_at, reloc_at, 0, len(relocs), 0,
                                           0x60500020)
    body = b''.join(struct.pack('<IIH', *r) for r in relocs)
    return header + section + CODE + body + b''.join(syms) + struct.pack('<I', 4)


def test_coff_parse():
    for bigobj in (False, True):
        c = coff.parse(build(bigobj))
        assert c.machine == 0x1F2
        assert [s.name for s in c.sections] == ['.text']
        assert [(off, s.name, kind) for off, s, kind in c.relocations(1)][:2] == [(4, '?h@@YAX', 6), (8, 'x', 0x10)]


def test_function_bytes_masks_relocated_words():
    data, masks = coff.function_bytes(coff.parse(build()), '?f@@YAX')
    assert data == CODE  # the $M label does not end the function
    assert masks == [(4, 0x03FFFFFC), (8, 0x0000FFFF), (12, 0x0000FFFF)]
