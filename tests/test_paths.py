import os
import subprocess
import sys

import pytest

import paths

TOOLS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'tools')


def test_env_path_with_space(tmp_path, monkeypatch):
    target = tmp_path / 'a b' / 'x.pdb'
    monkeypatch.setenv('HAGGAR_PDB', str(target))
    assert paths.pdb() == target


def test_default_paths_under_orig(monkeypatch):
    monkeypatch.delenv('HAGGAR_XEX', raising=False)
    monkeypatch.delenv('HAGGAR_PDB', raising=False)
    assert paths.xex() == paths.ROOT / 'orig' / 'MegaHaloGame.xex'
    assert paths.pdb() == paths.ROOT / 'orig' / 'MegaHaloGame.pdb'
    assert paths.basefile() == paths.ROOT / 'orig' / 'MegaHaloGame.exe'


def test_missing_input_message(tmp_path, capsys):
    missing = tmp_path / 'nope.pdb'
    with pytest.raises(SystemExit) as e:
        paths.require(missing)
    assert e.value.code == 2
    assert capsys.readouterr().err == f'missing input: {missing}\n'


def test_require_present_returns_path(tmp_path):
    (tmp_path / 'x').write_bytes(b'')
    assert paths.require(tmp_path / 'x') == tmp_path / 'x'


def test_missing_input_exits_2(tmp_path):
    # a SystemExit with a message exits 1; the CLIs promise 2
    code = f'import sys; sys.path.insert(0, {TOOLS!r}); import paths; paths.require(paths.Path({str(tmp_path / "x")!r}))'
    r = subprocess.run([sys.executable, '-c', code], capture_output=True, text=True)
    assert r.returncode == 2
    assert r.stderr.strip() == f'missing input: {tmp_path / "x"}'


def test_root_independent_of_cwd(tmp_path, monkeypatch):
    before = paths.ROOT
    monkeypatch.chdir(tmp_path)
    import importlib
    assert importlib.reload(paths).ROOT == before
    assert (before / 'tools' / 'paths.py').exists()
