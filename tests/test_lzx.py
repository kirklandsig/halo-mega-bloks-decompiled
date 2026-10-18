import struct

import pytest

import lzx


class BitWriter:
    """LZX bit order: 16-bit little-endian words, filled from the top bit."""

    def __init__(self):
        self.words = []
        self.acc = 0
        self.n = 0

    def bits(self, value, count):
        for i in range(count - 1, -1, -1):
            self.acc = (self.acc << 1) | ((value >> i) & 1)
            self.n += 1
            if self.n == 16:
                self.words.append(self.acc)
                self.acc, self.n = 0, 0

    def align(self):
        """Pad to a word boundary; an aligned stream gets a whole padding word,
        as LZX's uncompressed block header wants."""
        self.bits(0, 16 - self.n)

    def data(self):
        return b''.join(struct.pack('<H', w) for w in self.words)


def uncompressed_stream(payload):
    w = BitWriter()
    w.bits(0, 1)                 # no E8 translation
    w.bits(3, 3)                 # uncompressed block
    w.bits(len(payload) >> 8, 16)
    w.bits(len(payload) & 0xFF, 8)
    w.align()
    raw = struct.pack('<III', 1, 1, 1) + payload
    if len(payload) & 1:
        raw += b'\0'
    return w.data() + raw


def test_lzx_uncompressed_block():
    payload = b'Project Haggar, n-Space 2013.'
    assert lzx.decompress(uncompressed_stream(payload), 15, len(payload)) == payload


def test_lzx_uncompressed_two_frames():
    payload = bytes(i * 7 % 256 for i in range(0x8000 + 100))
    assert lzx.decompress(uncompressed_stream(payload), 15, len(payload)) == payload


def test_lzx_stops_at_out_size():
    payload = b'abcdefgh' * 10
    assert lzx.decompress(uncompressed_stream(payload), 15, 8) == b'abcdefgh'


def test_lzx_bad_block_type():
    w = BitWriter()
    w.bits(0, 1)
    w.bits(7, 3)
    w.bits(0, 24)
    w.align()
    with pytest.raises(ValueError):
        lzx.decompress(w.data() + b'\0' * 32, 15, 16)
