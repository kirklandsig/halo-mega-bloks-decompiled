import csv

import pytest

import imports
import paths


@pytest.mark.orig
def test_imports_csv(orig_xex):
    found = imports.imports(orig_xex)
    libraries = {i.library for i in found}
    with open(paths.CONFIG / 'imports.csv', newline='') as f:
        rows = list(csv.DictReader(f))
    assert rows
    assert {r['library'] for r in rows} <= libraries
    thunks = [int(r['thunk'], 16) for r in rows]
    assert len(set(thunks)) == len(thunks)
    assert any(r['library'] == 'xboxkrnl.exe' for r in rows)
    assert {r['kind'] for r in rows} <= {'function', 'variable'}
    assert len(rows) == len(found)


def test_parse_table_line():
    line = 'XE_EXPORT(xboxkrnl, 0x00000003, DbgPrint,   kFunction),'
    assert imports.parse_table(line) == {3: 'DbgPrint'}
