import pytest

import msf
from msfbuild import build_msf


def test_msf_roundtrip():
    streams = [b'', bytes(range(256)) * 2 + b'x' * 188, bytes(i % 251 for i in range(2000))]
    m = msf.Msf(build_msf(streams))
    assert m.num_streams == 3
    for i, s in enumerate(streams):
        assert m.stream_size(i) == len(s)
        assert m.stream(i) == s


def test_nil_stream_is_empty():
    m = msf.Msf(build_msf([b'abc', None]))
    assert m.stream_size(1) == 0
    assert m.stream(1) == b''


def test_bad_magic_raises():
    data = bytearray(build_msf([b'abc']))
    data[0] ^= 0xFF
    with pytest.raises(ValueError):
        msf.Msf(bytes(data))


def test_open_msf(tmp_path):
    p = tmp_path / 'a b.pdb'
    p.write_bytes(build_msf([b'hello', b'world' * 300]))
    m = msf.open_msf(p)
    assert m.stream(1) == b'world' * 300


@pytest.mark.orig
def test_orig_msf_shape(orig_pdb):
    m = msf.open_msf(orig_pdb)
    assert m.num_streams > 4
    assert m.stream_size(3) > 0
