from pathlib import Path

import pytest

import paths
import recomp_config

BASE = 0x82000000
SIZE = 0x24C0000


def test_functions_toml():
    text = recomp_config.render_functions({'setjmp': 0x83C0B000, 'longjmp': 0x83C0B100},
                                          [(0x82410000, 0x24), (0x82410028, 0x24)])
    assert 'setjmp_address = 0x83C0B000' in text
    assert 'longjmp_address = 0x83C0B100' in text
    assert '[functions]' in text
    assert '0x82410028 = { size = 0x24 }' in text


def test_manifest_paths_relative():
    base = Path('/r/build/recomp')
    text = recomp_config.render_manifest(base, Path('/r/orig/MegaHaloGame.xex'), Path('/r/recomp/switch_tables.toml'))
    assert 'file_path = "../../orig/MegaHaloGame.xex"' in text
    assert 'out_directory_path = "generated"' in text
    assert 'includes = ["functions.toml", "../../recomp/switch_tables.toml"]' in text
    assert recomp_config.recomp_dir() == paths.BUILD / 'recomp'


def test_functions_skip_empty_and_helpers():
    rows = [{'address': '0x82410000', 'size': '36'}, {'address': '0x82410024', 'size': '0'},
            {'address': '0x83C0A800', 'size': '4'}]
    assert recomp_config.functions(rows, {'__savegprlr_14': 0x83C0A800}) == [(0x82410000, 36)]


@pytest.mark.orig
def test_helpers_found(orig_pdb):
    from pdbfile import Pdb
    helpers = recomp_config.helpers(Pdb(orig_pdb))
    assert set(helpers) == set(recomp_config.HELPERS)
    assert all(BASE <= va < BASE + SIZE for va in helpers.values())
