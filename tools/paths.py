"""Where the inputs and outputs live. The repo root comes from this file's
location, never from the current directory.

    HAGGAR_XEX   the retail XEX   (default orig/MegaHaloGame.xex)
    HAGGAR_PDB   its PDB          (default orig/MegaHaloGame.pdb)
    XDK_DIR      the Xbox 360 SDK (default sdk/)
    HAGGAR_BUILD_DIR  generated files and build output (default build/)
"""
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ORIG = ROOT / 'orig'
CONFIG = ROOT / 'config'


def _env(name, default):
    value = os.environ.get(name)
    return Path(value) if value else default


BUILD = _env('HAGGAR_BUILD_DIR', ROOT / 'build').resolve()


def xex():
    return _env('HAGGAR_XEX', ORIG / 'MegaHaloGame.xex')


def pdb():
    return _env('HAGGAR_PDB', ORIG / 'MegaHaloGame.pdb')


def basefile():
    """The XEX's decrypted, decompressed PE image (tools/xex.py writes it)."""
    return ORIG / 'MegaHaloGame.exe'


def xdk():
    return _env('XDK_DIR', ROOT / 'sdk')


def require(p):
    """`p`, or exit with status 2 and a one-line message naming it."""
    p = Path(p)
    if not p.exists():
        print(f'missing input: {p}', file=sys.stderr)
        raise SystemExit(2)
    return p
