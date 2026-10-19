"""Re-checks every committed source file, so that a change to a shared header
can't quietly demote a function that config/status.csv says is matched."""
import pytest

import check
import inventory
import paths

SOURCES = sorted((paths.ROOT / 'src').rglob('*.cpp'))


@pytest.mark.orig
@pytest.mark.parametrize('src', SOURCES, ids=lambda p: p.name)
def test_source_keeps_its_status(src, monkeypatch):
    if not (paths.xdk() / 'bin' / 'win32' / 'cl.exe').exists() or not paths.basefile().exists():
        pytest.skip('needs the XDK and orig/MegaHaloGame.exe')
    results = {}
    monkeypatch.setattr(check, 'save', results.update)
    check.main([str(src)])
    status = {int(r['address'], 16): r['status'] for r in inventory.read_csv(paths.CONFIG / 'status.csv')}
    demoted = {f'0x{va:08X}': st for va, st in results.items() if status.get(va) == 'matched' and st != 'matched'}
    assert not demoted
