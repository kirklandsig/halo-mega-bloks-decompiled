import struct

import pytest

import paths
import pdbfile as pdb


def record(kind, payload):
    return struct.pack('<HH', len(payload) + 2, kind) + payload


def proc_payload(name, offset, seg, size):
    return struct.pack('<IIIIIIIIHB', 0, 0, 0, size, 0, 0, 0x1000, offset, seg, 0) + name.encode() + b'\0'


def test_iter_symbols_skips_unknown():
    data = b'\4\0\0\0' + record(0x1110, b'ab') + record(0x9999, b'\1\2\3\4\5\6') + record(0x1110, b'cd')
    assert list(pdb.iter_symbols(data)) == [(0x1110, b'ab'), (0x9999, b'\1\2\3\4\5\6'), (0x1110, b'cd')]


def test_iter_symbols_stops_at_padding():
    data = b'\4\0\0\0' + record(0x1110, b'ab') + b'\0\0\0\0'
    assert list(pdb.iter_symbols(data)) == [(0x1110, b'ab')]


def test_parse_proc_fields():
    name, offset, seg, size = pdb.parse_proc(proc_payload('UUDKWeapon::Tick', 0x1234, 1, 0x40))
    assert (name, offset, seg, size) == ('UUDKWeapon::Tick', 0x1234, 1, 0x40)


def test_env_strings():
    payload = struct.pack('<IH6H', 0, 0x1F2, 16, 0, 11886, 16, 0, 11886)
    payload += b'Microsoft (R) Optimizing Compiler\0'
    payload += b'cwd\0C:\\build\0cl\0C:\\cl.exe\0cmd\0-nologo -Ox\0\0'
    assert pdb.parse_env(0x1116, payload) == {'cwd': r'C:\build', 'cl': r'C:\cl.exe', 'cmd': '-nologo -Ox'}


def test_envblock_strings():
    payload = b'\0' + b'src\0a.cpp\0pdb\0x.pdb\0\0'
    assert pdb.parse_env(0x113D, payload) == {'src': 'a.cpp', 'pdb': 'x.pdb'}


@pytest.fixture(scope='module')
def real(request):
    path = paths.pdb()
    if not path.exists():
        pytest.skip(f'{path} not present')
    return pdb.Pdb(path)


@pytest.mark.orig
def test_census(real):
    assert real.machine == 0x1F2
    assert real.type_count == 759808
    assert len(real.modules) == 2363
    assert sum(1 for _ in real.procedures()) == 215944


@pytest.mark.orig
def test_env_udkweapon(real):
    mod = next(m for m in real.modules if m.name.endswith('Unity_UDKWeaponEtAl.cpp.obj'))
    env = real.env(mod)
    assert env['cmd'].startswith('-nologo -Oi -Zp4 -Gy -fp:fast -c -Zm400 -bigobj -wd4819 -Ox -Ot -Ob2 -GF -Z7 -MT')
    assert env['cl'] == r'C:\Program Files (x86)\Microsoft Xbox 360 SDK\bin\win32\cl.exe'


@pytest.mark.orig
def test_first_line_has_original_cpp(real):
    mod = next(m for m in real.modules if r'\UDKBase\Unity_' in m.name)
    # inlines from headers come first; the module's own code maps to the .cpp
    # files the unity file includes, never to the unity file itself
    lines = [real.first_line(mod, p.rva) for p in real.procedures() if p.module == mod.index]
    cpp = [(s, n) for s, n in filter(None, lines) if s.lower().endswith('.cpp')]
    assert cpp
    assert all('unity_' not in s.lower() and n > 0 for s, n in cpp)


def lines_subsection(offset, size, blocks):
    body = b''
    for file_id, entries in blocks:
        body += struct.pack('<III', file_id, len(entries), 12 + 8 * len(entries))
        body += b''.join(struct.pack('<II', off, line | 0x80000000) for off, line in entries)
    return struct.pack('<IHHI', offset, 1, 0, size) + body


def test_parse_lines_blocks_and_flags():
    sub = lines_subsection(0x40, 0x30, [(0, [(0, 10), (8, 11)]), (24, [(16, 3)])])
    # the statement flag in the top bits is dropped
    assert pdb.parse_lines(sub) == (0x40, 1, 0x30, [(0, [(0, 10), (8, 11)]), (24, [(16, 3)])])


def test_c13_subsections_align_and_report_positions():
    a, b = b'abcde', b'xyz'
    data = struct.pack('<II', 0xF2, len(a)) + a + b'\0\0\0' + struct.pack('<II', 0xF4, len(b)) + b
    assert list(pdb.c13_subsections(data)) == [(0xF2, a, 8), (0xF4, b, 24)]


def test_records_give_positions():
    data = b'\4\0\0\0' + record(0x1106, b'\x01') + record(0x1111, b'\x02\x03')
    assert [(pos, kind) for pos, kind, _ in pdb.records(data)] == [(4, 0x1106), (9, 0x1111)]
    assert pdb.register_name(4) == 'r3' and pdb.register_name(100) == 'reg100'


@pytest.mark.orig
def test_line_table_starts_at_first_line(real):
    mod = next(m for m in real.modules if r'\UDKBase\Unity_' in m.name)
    procs = [p for p in real.procedures() if p.module == mod.index][:50]
    checked = 0
    for p in procs:
        table = real.line_table(mod, p.rva)
        if not table:
            continue
        assert table == sorted(table) and table[0][0] == 0
        assert table[0][1] == real.first_line(mod, p.rva)[1]
        assert all(0 <= off < max(p.size, 1) for off, _ in table)
        checked += 1
    assert checked
