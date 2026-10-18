import struct

import pytest

import paths
import pdbtype

T_INT4 = 0x74
T_REAL32 = 0x40


def leaf(kind, body):
    body = struct.pack('<H', kind) + body
    body += bytes(-(len(body) + 2) % 4)
    return struct.pack('<H', len(body)) + body


def tpi(records):
    data = b''.join(records)
    header = struct.pack('<IIIII', 20040203, 56, 0x1000, 0x1000 + len(records), len(data)) + bytes(36)
    return header + data


def member(ti, offset, name):
    sub = struct.pack('<HHIH', 0x150D, 3, ti, offset) + name.encode() + b'\0'
    pad = -len(sub) % 4
    return sub + bytes(0xF0 + i for i in range(pad, 0, -1))  # LF_PAD3, LF_PAD2, LF_PAD1


def structure(field, size, name, prop=0):
    return leaf(0x1505, struct.pack('<HHIIIH', 2, prop, field, 0, 0, size) + name.encode() + b'\0')


def make_types():
    pointer = leaf(0x1002, struct.pack('<II', T_INT4, 0x0A | (4 << 13)))                       # 0x1000: int *
    fields = leaf(0x1203, member(T_INT4, 0, 'Count') + member(0x1000, 4, 'Data'))               # 0x1001
    forward = structure(0, 0, 'FPair', prop=0x80)                                                # 0x1002
    real = structure(0x1001, 8, 'FPair')                                                         # 0x1003
    return pdbtype.Types(tpi([pointer, fields, forward, real]))


def test_find_skips_forward_reference():
    assert make_types().find('FPair') == 0x1003


def test_render_struct():
    text = make_types().render(0x1003)
    assert 'struct FPair' in text
    assert 'size 0x8' in text
    assert 'int Count;  // 0x0' in text
    assert 'int *Data;  // 0x4' in text


def test_find_missing_raises():
    with pytest.raises(KeyError):
        make_types().find('FNope')


@pytest.fixture(scope='module')
def real():
    path = paths.pdb()
    if not path.exists():
        pytest.skip(f'{path} not present')
    from pdbfile import Pdb
    return pdbtype.Types(Pdb(path))


@pytest.mark.orig
def test_fvector(real):
    text = real.render(real.find('FVector'))
    assert 'size 0xC' in text
    for name, off in (('X', 0), ('Y', 4), ('Z', 8)):
        assert f'float {name};  // 0x{off:X}' in text


@pytest.mark.orig
def test_fstring_size(real):
    assert 'size 0xC' in real.render(real.find('FString')).splitlines()[0]
