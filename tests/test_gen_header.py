import re
import struct

import pytest

import check
import gen_header
import inventory
import paths
import pdbtype
from test_pdbtype import T_INT4, T_REAL32, leaf, member, structure, tpi


def base_class(ti, offset):
    sub = struct.pack('<HHIH', 0x1400, 3, ti, offset)
    return sub + bytes(0xF0 + i for i in range(-len(sub) % 4, 0, -1))


def vfunctab():
    return struct.pack('<HHI', 0x1409, 0, T_INT4)


def make_types():
    base_fields = leaf(0x1203, vfunctab() + member(T_INT4, 4, 'Count'))       # 0x1000
    base = structure(0x1000, 8, 'FBase')                                       # 0x1001
    fields = leaf(0x1203, base_class(0x1001, 0) + member(T_REAL32, 8, 'Weight'))  # 0x1002
    derived = structure(0x1002, 0x10, 'FDerived')                              # 0x1003
    return pdbtype.Types(tpi([base_fields, base, fields, derived]))


def test_render_opaque_base():
    text = gen_header.Header(make_types(), ['FDerived']).render()
    assert 'struct FBase  // size 0x8, opaque' in text
    assert 'HG_XDK(HG_VIRTUAL ~FBase();)' in text
    assert 'unsigned int FBaseData[0x1];' in text  # the blob keeps the vtable's 4-byte alignment
    assert 'Count' not in text
    assert 'struct FDerived : public FBase  // size 0x10' in text
    assert 'float Weight;  // 0x8' in text
    assert 'char _pad0[0x4];' in text
    assert text.index('struct FBase ') < text.index('struct FDerived ')


def test_split_scope_and_template_args():
    assert gen_header.split_scope('A::B<C::D>::E') == ['A', 'B<C::D>', 'E']
    assert gen_header.template_args('P<Q<int,2>,R *>') == ('P', ['Q<int,2>', 'R *'])
    assert gen_header.template_args('Plain') == ('Plain', None)


@pytest.fixture(scope='module')
def real():
    path = paths.pdb()
    if not path.exists():
        pytest.skip(f'{path} not present')
    from pdbfile import Pdb
    return pdbtype.Types(Pdb(path))


@pytest.mark.orig
def test_offsets_match_pdb(real, tmp_path):
    cl = paths.xdk() / 'bin' / 'win32' / 'cl.exe'
    if not cl.exists():
        pytest.skip(f'{cl} not present')
    targets = ['HaloRBTKamikaze', 'CCSRBTMoveTo']
    header = gen_header.Header(real, targets)
    (tmp_path / 'gen.h').write_text(header.render(), encoding='utf-8')
    lines = ['#include "gen.h"',
             '#define OFFSET(s, m) ((unsigned)&reinterpret_cast<const volatile char &>(((s *)0)->m))']
    for name in targets:
        ti = real.find(name)
        lines.append(f'static_assert(sizeof({name}) == {real.sizeof(ti)}, "{name}");')
        for mname, mtype, off, _acc in header.members(ti):
            if off is not None and header._kind(mtype) != pdbtype.LF_BITFIELD:
                lines.append(f'static_assert(OFFSET({name}, {mname}) == {off}, "{name}::{mname}");')
    src = tmp_path / 'offsets.cpp'
    src.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    objects = {r['object']: r for r in inventory.read_csv(paths.CONFIG / 'objects.csv')}
    r = check.compile_file(cl, objects['Unity_HaloRBTKamikazeEtAl.cpp.obj']['cmd'],
                           [tmp_path, paths.ROOT / 'include', paths.xdk() / 'include' / 'xbox'], src, tmp_path / 'offsets.obj')
    assert r.returncode == 0, r.stdout + r.stderr
    assert len(lines) > 20


def host_compiler():
    """The port's clang++ and the ReXGlue SDK's headers, or skip."""
    import os
    import shutil
    sdk = paths.ROOT / 'third_party' / 'rexglue' / 'out' / 'install' / 'win-amd64' / 'include'
    clang = os.environ.get('HAGGAR_CLANG') or shutil.which('clang++')
    if clang is None or not sdk.exists():
        pytest.skip('needs clang++ and the installed ReXGlue SDK')
    return clang, sdk


@pytest.mark.orig
def test_host_layout_matches_pdb(real, tmp_path):
    clang, sdk = host_compiler()
    targets = ['HaloRBTKamikaze', 'CCSBlackboard']
    header = gen_header.Header(real, targets)
    (tmp_path / 'gen.h').write_text(header.render(), encoding='utf-8')
    lines = ['#include "gen.h"', '#include <cstddef>']
    for name in targets:
        ti = real.find(name)
        lines.append(f'static_assert(sizeof({name}) == {real.sizeof(ti)}, "{name}");')
        for mname, mtype, off, _acc in header.members(ti):
            if off is not None and header._kind(mtype) != pdbtype.LF_BITFIELD and not header.blob_member(mtype):
                lines.append(f'static_assert(offsetof({name}, {mname}) == {off}, "{name}::{mname}");')
    src = tmp_path / 'host.cpp'
    src.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    import subprocess
    r = subprocess.run([clang, '-std=c++23', '-fsyntax-only', '-DHAGGAR_HOST', '-fms-extensions', '-Wno-everything',
                        f'-I{tmp_path}', f'-I{paths.ROOT / "include"}', f'-I{sdk}', str(src)], capture_output=True, text=True)
    assert r.returncode == 0, r.stdout + r.stderr


def committed_header_targets():
    """The targets the committed Kamikaze header was generated with."""
    import shlex
    text = (paths.ROOT / 'include' / 'UDKBase' / 'Inc' / 'HaloRBTKamikaze.h').read_text(encoding='utf-8')
    command = text.splitlines()[1].lstrip('/ ').split(' -o ')[0]
    args = shlex.split(command)[2:]
    names = []
    for a in args:
        if a.startswith('--'):
            break
        names.append(a)
    return names


@pytest.mark.orig
def test_host_layout_of_the_committed_header(real, tmp_path):
    clang, sdk = host_compiler()
    targets = committed_header_targets()
    header = gen_header.Header(real, targets)
    (tmp_path / 'gen.h').write_text(header.render(), encoding='utf-8')
    lines = ['#include "gen.h"', '#include <cstddef>']
    for name in targets:
        ti = real.find(name)
        lines.append(f'static_assert(sizeof({name}) == {real.sizeof(ti)}, "{name}");')
        for mname, mtype, off, _acc in header.members(ti):
            if off is not None and header._kind(mtype) != pdbtype.LF_BITFIELD and not header.blob_member(mtype):
                lines.append(f'static_assert(offsetof({name}, {mname}) == {off}, "{name}::{mname}");')
    src = tmp_path / 'host.cpp'
    src.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    import subprocess
    r = subprocess.run([clang, '-std=c++23', '-fsyntax-only', '-DHAGGAR_HOST', '-fms-extensions', '-Wno-everything',
                        f'-I{tmp_path}', f'-I{paths.ROOT / "include"}', f'-I{sdk}', str(src)], capture_output=True, text=True)
    assert r.returncode == 0, (r.stdout + r.stderr)[:3000]


@pytest.mark.orig
def test_host_thunks_marshal_no_host_references(real):
    header = gen_header.Header(real, committed_header_targets())
    header.render()
    text = gen_header.host_thunks(header, 'UDKBase/Inc/HaloRBTKamikaze.h')
    thunks = [line for line in text.splitlines() if line.startswith('__attribute__((weak))')]
    assert thunks
    # a reference, or a pointer to a scalar, would hand guest memory to host code as a native value
    assert not [t for t in thunks if re.search(r'&a\d|&\)|& |(int|float|bool|char) \*', t.split('{')[0])]
