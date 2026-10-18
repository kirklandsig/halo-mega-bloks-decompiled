"""Builds small MSF 7.00 files in memory, for tests."""
import struct

MAGIC = b'Microsoft C/C++ MSF 7.00\r\n\x1aDS\x00\x00\x00'


def build_msf(streams, block_size=512):
    """An MSF file holding `streams` (bytes, or None for a nil stream).
    Block 0 is the superblock, 1 and 2 the free block maps, then the stream
    data, the directory, and the block holding the directory's block list."""
    blocks = [b'', b'', b'']

    def place(data):
        first = len(blocks)
        for i in range(0, len(data), block_size):
            blocks.append(data[i:i + block_size])
        return list(range(first, len(blocks)))

    sizes, lists = [], []
    for s in streams:
        if s is None:
            sizes.append(0xFFFFFFFF)
            lists.append([])
        else:
            sizes.append(len(s))
            lists.append(place(s))
    directory = struct.pack('<I', len(streams)) + struct.pack(f'<{len(sizes)}I', *sizes)
    for blist in lists:
        directory += struct.pack(f'<{len(blist)}I', *blist)
    dir_blocks = place(directory)
    block_map = len(blocks)
    blocks.append(struct.pack(f'<{len(dir_blocks)}I', *dir_blocks))
    blocks[0] = MAGIC + struct.pack('<6I', block_size, 1, len(blocks), len(directory), 0, block_map)
    return b''.join(b.ljust(block_size, b'\0') for b in blocks)
