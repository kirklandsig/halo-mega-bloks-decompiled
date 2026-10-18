import pytest

import paths
import recomp_config

BASE = 0x82000000
SIZE = 0x24C0000


def test_toml_paths_and_functions():
    text = recomp_config.render({'savegprlr_14_address': 0x83C0A800},
                                [(0x82410000, 0x24), (0x82410028, 0x24)])
    assert '[main]' in text
    assert 'file_path = "../../orig/MegaHaloGame.dec.xex"' in text
    assert 'out_directory_path = "ppc"' in text
    assert 'switch_table_file_path = "../../recomp/switch_tables.toml"' in text
    assert recomp_config.TOML == paths.BUILD / 'recomp' / 'MegaHaloGame.toml'
    assert 'savegprlr_14_address = 0x83C0A800' in text
    assert '{ address = 0x82410028, size = 0x24 },' in text


def test_functions_skip_empty_and_helpers():
    rows = [{'address': '0x82410000', 'size': '36'}, {'address': '0x82410024', 'size': '0'},
            {'address': '0x83C0A800', 'size': '4'}]
    assert recomp_config.functions(rows, {'savegprlr_14_address': 0x83C0A800}) == [(0x82410000, 36)]


@pytest.mark.orig
def test_helpers_found(orig_pdb):
    from pdbfile import Pdb
    helpers = recomp_config.helpers(Pdb(orig_pdb))
    assert set(helpers) == set(recomp_config.HELPERS)
    assert all(BASE <= va < BASE + SIZE for va in helpers.values())
