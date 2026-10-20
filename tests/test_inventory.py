import csv
import io

import pytest

import inventory
import paths
from pdbfile import Module, Proc

REL = r'F:\Projects\Halo_MegaBloks\Development\Intermediate\MegaHaloGame\Xbox360\Release'


def test_classify_rules():
    assert inventory.classify(REL + r'\UDKBase\Unity_UDKWeaponEtAl.cpp.obj') == ('game', 'udkbase')
    assert inventory.classify(REL + r'\Engine\Unity_WorldAttractorEtAl.cpp.obj') == ('engine', 'engine')
    assert inventory.classify(REL + r'\XenonD3DDrv\Unity_XeD3DViewportEtAl.cpp.obj') == ('platform', 'xenond3ddrv')
    assert inventory.classify(r'.\Xbox 360\PhysXCooking\release\ConvexHullBuilder.obj') == ('lib', '')


def test_object_name():
    assert inventory.object_name(REL + r'\UDKBase\Unity_UDKWeaponEtAl.cpp.obj', REL + r'\UDKBase\Unity_UDKWeaponEtAl.cpp.obj') \
        == 'Unity_UDKWeaponEtAl.cpp.obj'
    assert inventory.object_name(r'obj\xbox\common.obj', r'C:\SDK\lib\xbox\xhv2.lib') == 'xhv2.lib(common.obj)'


def test_owner():
    assert inventory.owner('game', 'megahalogame', 'x.cpp') == 'nspace'
    assert inventory.owner('game', 'udkbase', r'udkbase\src\halopawn.cpp') == 'nspace'
    assert inventory.owner('game', 'udkbase', r'udkbase\src\udkpawn.cpp') == 'epic'
    assert inventory.owner('engine', 'engine', r'engine\src\halo.cpp') == ''


class FakePdb:
    def __init__(self):
        name = REL + r'\Cognition\Unity_CogEtAl.cpp.obj'
        self.modules = [Module(0, name, name, 10, 100, 0, 0)]
        self._procs = [Proc('A::f', 0x100, 8, 0, True), Proc('A::g', 0x200, 4, 0, True)]

    def procedures(self):
        return iter(self._procs)

    def publics(self):
        return {0x100: '?f@A@@QAAXXZ'}

    def public_functions(self):
        return [(0x180, '?h@A@@QAAXXZ'), (0x300, '_memcpy')]

    def contribution_module(self, rva):
        return 0 if rva < 0x300 else None

    def code_end(self, rva):
        return 0x400

    def env(self, module):
        return {'src': 'Unity_CogEtAl.cpp', 'cmd': '-nologo -Ox'}

    def first_line(self, module, rva):
        if rva == 0x100:
            return r'f:\projects\halo_megabloks\development\src\cognition\src\cog.cpp', 12
        return None


def test_rows_and_public_only_functions():
    functions, objects = inventory.build(FakePdb())
    assert [r['address'] for r in functions] == ['0x82000100', '0x82000180', '0x82000200', '0x82000300']
    row = functions[0]
    assert row['name'] == 'A::f' and row['symbol'] == '?f@A@@QAAXXZ'
    assert (row['tier'], row['package'], row['owner'], row['line']) == ('game', 'cognition', 'nspace', 12)
    assert row['source'] == r'cognition\src\cog.cpp'
    assert functions[2]['source'] == ''
    pub, lib = functions[1], functions[3]
    assert (pub['name'], pub['symbol'], pub['size'], pub['object'], pub['tier']) == (
        '', '?h@A@@QAAXXZ', 0x80, 'Unity_CogEtAl.cpp.obj', 'game')
    assert (lib['name'], lib['size'], lib['object'], lib['tier'], lib['package']) == ('', 0x100, '', 'lib', '')
    assert objects == [{'object': 'Unity_CogEtAl.cpp.obj', 'package': 'cognition', 'tier': 'game', 'functions': 2,
                        'bytes': 12, 'src': 'Unity_CogEtAl.cpp', 'cmd': '-nologo -Ox'}]


def test_csv_columns(tmp_path):
    functions, objects = inventory.build(FakePdb())
    out = tmp_path / 'f.csv'
    inventory.write_csv(out, inventory.FUNCTION_COLUMNS, functions)
    header = out.read_text().splitlines()[0]
    assert header == 'address,size,name,symbol,object,package,tier,owner,source,line'
    assert list(csv.DictReader(io.StringIO(out.read_text())))[0]['size'] == '8'


def test_source_prefix_stripped():
    assert inventory.short_source(r'f:\projects\halo_megabloks\development\src\core\src\unobjgc.cpp') \
        == r'core\src\unobjgc.cpp'
    assert inventory.short_source(r'c:\program files (x86)\microsoft xbox 360 sdk\include\xbox\math.h') \
        == r'<xdk>\include\xbox\math.h'
    assert inventory.short_source(r'f:\projects\halo_megabloks\development\external\zlib\a.c') \
        == r'external\zlib\a.c'
    assert inventory.short_source(r'd:\branches\wwise\a.cpp') == r'd:\branches\wwise\a.cpp'


def test_inventory_keeps_status(tmp_path, monkeypatch):
    monkeypatch.setattr(paths, 'CONFIG', tmp_path)
    monkeypatch.setattr(inventory, 'Pdb', lambda path: FakePdb())
    status = tmp_path / 'status.csv'
    status.write_bytes(b'address,status\n0x82000100,matched\n')
    inventory.main(['--pdb', 'x.pdb'])
    assert status.read_bytes() == b'address,status\n0x82000100,matched\n'
    assert (tmp_path / 'functions' / 'game.csv').exists()


@pytest.mark.orig
def test_tier_totals(orig_pdb):
    rows = [r for r in inventory.read_functions() if r['name']]
    counts = {}
    for r in rows:
        counts[r['tier']] = counts.get(r['tier'], 0) + 1
    assert counts == {'game': 7066, 'engine': 92662, 'platform': 18324, 'lib': 97892}


@pytest.mark.orig
def test_public_only_rows(orig_pdb):
    from pdbfile import Pdb
    rows = inventory.read_functions()
    addresses = {int(r['address'], 16) for r in rows}
    assert all(0x82000000 + p.rva in addresses for p in Pdb(orig_pdb).procedures())
    assert sum(1 for r in rows if not r['name']) == 21224
    assert len(rows) == 215944 + 21224


def test_inventory_files_stay_small():
    # GitHub warns about files over 50 MB; the whole inventory is about 47 MB
    files = list(inventory.functions_dir().glob('*.csv'))
    assert files
    assert all(f.stat().st_size <= inventory.SHARD_BYTES for f in files)


def _row(address, tier, name='f'):
    return {'address': f'0x{address:08X}', 'size': '4', 'name': name, 'symbol': '', 'object': 'a.obj',
            'package': '', 'tier': tier, 'owner': '', 'source': '', 'line': ''}


def test_write_functions_shards_by_tier_and_size(tmp_path, monkeypatch):
    monkeypatch.setattr(inventory, 'SHARD_BYTES', 200)
    rows = [_row(0x82000000 + 4 * i, 'lib' if i % 3 else 'game', f'name{i:03}') for i in range(30)]
    (tmp_path / 'stale.csv').write_text('address\n')
    inventory.write_functions(rows, tmp_path)
    names = sorted(f.name for f in tmp_path.glob('*.csv'))
    assert 'stale.csv' not in names and 'game-1.csv' in names and 'lib-1.csv' in names
    assert all(f.stat().st_size <= 200 for f in tmp_path.glob('*.csv'))
    assert inventory.read_functions(tmp_path) == rows
    inventory.write_functions(rows[:1], tmp_path)
    assert sorted(f.name for f in tmp_path.glob('*.csv')) == ['game.csv']


def test_write_functions_rejects_unknown_tiers(tmp_path):
    with pytest.raises(ValueError):
        inventory.write_functions([_row(0x82000000, 'other')], tmp_path)
