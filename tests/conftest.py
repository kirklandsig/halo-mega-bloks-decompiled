import os
import sys

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'tools'))

import paths  # noqa: E402


@pytest.fixture
def orig_pdb():
    path = paths.pdb()
    if not path.exists():
        pytest.skip(f'{path} not present')
    return path


@pytest.fixture
def orig_xex():
    path = paths.xex()
    if not path.exists():
        pytest.skip(f'{path} not present')
    return path
