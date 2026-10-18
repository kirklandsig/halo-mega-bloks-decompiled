"""Reads Microsoft MSF 7.00 containers (the PDB file format): the superblock,
the block map, the stream directory, then the streams themselves.

A nil stream (size 0xFFFFFFFF) reads as empty. A bad magic, or a block index
past the end of the file, raises ValueError.
"""
import mmap
import struct

MAGIC = b'Microsoft C/C++ MSF 7.00\r\n\x1aDS\x00\x00\x00'
NIL = 0xFFFFFFFF


class Msf:
    def __init__(self, data):
        if data[:len(MAGIC)] != MAGIC:
            raise ValueError('not an MSF 7.00 file')
        self._data = data
        bs, _fpm, nblocks, dir_bytes, _unknown, map_block = struct.unpack_from('<6I', data, len(MAGIC))
        if bs not in (512, 1024, 2048, 4096) or nblocks * bs > len(data):
            raise ValueError(f'bad MSF superblock (block size {bs}, {nblocks} blocks)')
        self._bs = bs
        self._nblocks = nblocks
        dir_blocks = struct.unpack_from(f'<{self._count(dir_bytes)}I', data, self._offset(map_block))
        directory = self._read(dir_blocks, dir_bytes)
        n, = struct.unpack_from('<I', directory, 0)
        self._sizes = struct.unpack_from(f'<{n}I', directory, 4)
        pos = 4 + 4 * n
        self._blocks = []
        for size in self._sizes:
            k = 0 if size == NIL else self._count(size)
            self._blocks.append(struct.unpack_from(f'<{k}I', directory, pos))
            pos += 4 * k

    def _count(self, nbytes):
        return (nbytes + self._bs - 1) // self._bs

    def _offset(self, block):
        if block >= self._nblocks:
            raise ValueError(f'MSF block {block} past the end ({self._nblocks} blocks)')
        return block * self._bs

    def _read(self, blocks, size):
        bs = self._bs
        return b''.join(self._data[self._offset(b):self._offset(b) + bs] for b in blocks)[:size]

    @property
    def num_streams(self):
        return len(self._sizes)

    def stream_size(self, i):
        size = self._sizes[i]
        return 0 if size == NIL else size

    def stream(self, i):
        return self._read(self._blocks[i], self.stream_size(i))


def open_msf(path):
    """An Msf over the file at `path`, memory-mapped read-only."""
    with open(path, 'rb') as f:
        return Msf(mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ))
