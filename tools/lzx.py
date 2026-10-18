"""An LZX decompressor (the CAB and XEX flavour, as in libmspack's lzxd.c):
verbatim, aligned-offset and uncompressed blocks, 32 KB frames with the
bitstream realigned after each, and the Intel E8 call translation.

    decompress(data, window_bits, out_size) -> bytes

A corrupt stream raises ValueError.
"""
import struct

FRAME = 0x8000
MIN_MATCH = 2
NUM_CHARS = 256
PRETREE = 20
SECONDARY_LENGTHS = 249
TABLE_BITS = 11

POSITION_SLOTS = {15: 30, 16: 32, 17: 34, 18: 36, 19: 38, 20: 42, 21: 50}
EXTRA_BITS = [0, 0, 0, 0] + [min((i - 2) // 2, 17) for i in range(4, 52)]
POSITION_BASE = [0]
for _e in EXTRA_BITS[:-1]:
    POSITION_BASE.append(POSITION_BASE[-1] + (1 << _e))


class _Bits:
    """16-bit little-endian words, read from the top bit down."""

    __slots__ = ('data', 'pos', 'buf', 'n')

    def __init__(self, data):
        self.data = data
        self.pos = 0
        self.buf = 0
        self.n = 0

    def _fill(self, want):
        data, pos = self.data, self.pos
        while self.n < want:
            word = data[pos] | (data[pos + 1] << 8) if pos + 1 < len(data) else 0
            pos += 2
            self.buf = (self.buf << 16) | word
            self.n += 16
        self.pos = pos

    def read(self, count):
        if count == 0:
            return 0
        if self.n < count:
            self._fill(count)
        self.n -= count
        value = self.buf >> self.n
        self.buf &= (1 << self.n) - 1
        return value

    def align(self):
        """Drop what is left of the current word (realigning after a frame)."""
        self.n -= self.n & 15
        self.buf &= (1 << self.n) - 1

    def byte_align_for_raw(self):
        """The uncompressed block header: 1 to 16 bits up to the next word,
        then raw bytes. Returns the byte position of the raw data."""
        if self.n == 0:
            self.pos += 2  # a whole padding word
        start = self.pos - 2 * (self.n // 16)
        self.n = 0
        self.buf = 0
        self.pos = start
        return start


class _Huffman:
    """Canonical Huffman decoding: a TABLE_BITS lookup, then longer codes."""

    __slots__ = ('table', 'long', 'empty')

    def __init__(self, lengths):
        self.table = [-1] * (1 << TABLE_BITS)
        self.long = {}
        self.empty = not any(lengths)
        code = 0
        for length in range(1, 17):
            for sym, l in enumerate(lengths):
                if l != length:
                    continue
                if length <= TABLE_BITS:
                    shift = TABLE_BITS - length
                    start = code << shift
                    self.table[start:start + (1 << shift)] = [(sym << 5) | length] * (1 << shift)
                else:
                    self.long[(length, code)] = sym
                code += 1
            code <<= 1
        if not self.empty and code > (1 << 17):
            raise ValueError('LZX: over-subscribed Huffman table')

    def decode(self, bits):
        if bits.n < 16:
            bits._fill(16)
        n = bits.n
        entry = self.table[(bits.buf >> (n - TABLE_BITS)) & ((1 << TABLE_BITS) - 1)]
        if entry >= 0:
            length = entry & 31
            bits.n = n - length
            bits.buf &= (1 << bits.n) - 1
            return entry >> 5
        for length in range(TABLE_BITS + 1, 17):
            sym = self.long.get((length, (bits.buf >> (n - length)) & ((1 << length) - 1)))
            if sym is not None:
                bits.n = n - length
                bits.buf &= (1 << bits.n) - 1
                return sym
        raise ValueError('LZX: bad Huffman code')


def _read_lengths(bits, lengths, first, last):
    pre = _Huffman([bits.read(4) for _ in range(PRETREE)])
    size = len(lengths)
    x = first
    while x < last:
        z = pre.decode(bits)
        if z == 17:
            run = bits.read(4) + 4
            lengths[x:x + run] = [0] * run
            x += run
        elif z == 18:
            run = bits.read(5) + 20
            lengths[x:x + run] = [0] * run
            x += run
        elif z == 19:
            run = bits.read(1) + 4
            z = pre.decode(bits)
            value = (lengths[x] - z) % 17
            lengths[x:x + run] = [value] * run
            x += run
        else:
            lengths[x] = (lengths[x] - z) % 17
            x += 1
    del lengths[size:]  # a run may overshoot `last`; the overshoot is dropped


def _e8(frame, offset, filesize):
    data = bytearray(frame)
    i, end = 0, len(data) - 10
    while i < end:
        if data[i] != 0xE8:
            i += 1
            continue
        curpos = offset + i
        absolute, = struct.unpack_from('<i', data, i + 1)
        if -curpos <= absolute < filesize:
            relative = absolute - curpos if absolute >= 0 else absolute + filesize
            struct.pack_into('<i', data, i + 1, relative)
        i += 5
    return bytes(data)


def decompress(data, window_bits, out_size):
    if window_bits not in POSITION_SLOTS:
        raise ValueError(f'LZX: unsupported window of {window_bits} bits')
    window_size = 1 << window_bits
    main_size = NUM_CHARS + POSITION_SLOTS[window_bits] * 8
    window = bytearray(window_size)
    bits = _Bits(data)
    main_len = [0] * main_size
    length_len = [0] * SECONDARY_LENGTHS
    main = length_tree = aligned = None
    r0 = r1 = r2 = 1
    block_type = block_remaining = block_length = 0
    intel_started = False
    intel_filesize = (bits.read(16) << 16 | bits.read(16)) if bits.read(1) else 0

    out = bytearray()
    posn = 0
    while len(out) < out_size:
        frame_size = min(FRAME, out_size - len(out))
        frame_start = posn
        todo = frame_size
        while todo > 0:
            if block_remaining == 0:
                if block_type == 3 and block_length & 1:
                    bits.pos += 1
                block_type = bits.read(3)
                block_remaining = block_length = (bits.read(16) << 8) | bits.read(8)
                if block_type == 2:
                    aligned = _Huffman([bits.read(3) for _ in range(8)])
                if block_type in (1, 2):
                    _read_lengths(bits, main_len, 0, NUM_CHARS)
                    _read_lengths(bits, main_len, NUM_CHARS, main_size)
                    main = _Huffman(main_len)
                    if main_len[0xE8]:
                        intel_started = True
                    _read_lengths(bits, length_len, 0, SECONDARY_LENGTHS)
                    length_tree = _Huffman(length_len)
                elif block_type == 3:
                    intel_started = True
                    p = bits.byte_align_for_raw()
                    r0, r1, r2 = struct.unpack_from('<III', data, p)
                    bits.pos = p + 12
                else:
                    raise ValueError(f'LZX: bad block type {block_type}')
                if block_remaining == 0:
                    raise ValueError('LZX: empty block')

            run = min(block_remaining, todo)
            todo -= run
            block_remaining -= run
            if block_type == 3:
                p = bits.pos
                chunk = data[p:p + run]
                if len(chunk) != run:
                    raise ValueError('LZX: truncated uncompressed block')
                window[posn:posn + run] = chunk
                posn += run
                bits.pos = p + run
                run = 0
            else:
                is_aligned = block_type == 2
                while run > 0:
                    sym = main.decode(bits)
                    if sym < NUM_CHARS:
                        window[posn] = sym
                        posn += 1
                        run -= 1
                        continue
                    sym -= NUM_CHARS
                    length = sym & 7
                    if length == 7:
                        if length_tree.empty:
                            raise ValueError('LZX: length tree is empty')
                        length += length_tree.decode(bits)
                    length += MIN_MATCH
                    slot = sym >> 3
                    if slot == 0:
                        offset = r0
                    elif slot == 1:
                        offset = r1
                        r1 = r0
                        r0 = offset
                    elif slot == 2:
                        offset = r2
                        r2 = r0
                        r0 = offset
                    elif slot == 3:
                        offset = 1
                        r2, r1, r0 = r1, r0, 1
                    else:
                        extra = EXTRA_BITS[slot]
                        offset = POSITION_BASE[slot] - 2
                        if not is_aligned:
                            offset += bits.read(extra)
                        elif extra > 3:
                            offset += (bits.read(extra - 3) << 3) + aligned.decode(bits)
                        elif extra == 3:
                            offset += aligned.decode(bits)
                        else:
                            offset += bits.read(extra)
                        r2, r1, r0 = r1, r0, offset
                    if posn + length > window_size:
                        raise ValueError('LZX: match runs past the window')
                    src = (posn - offset) & (window_size - 1)
                    if src + length <= posn or (src >= posn + length and src + length <= window_size):
                        window[posn:posn + length] = window[src:src + length]
                    else:  # overlapping, or wrapping round the window's end
                        mask = window_size - 1
                        for i in range(length):
                            window[posn + i] = window[(src + i) & mask]
                    posn += length
                    run -= length
            if run < 0:
                if -run > block_remaining:
                    raise ValueError('LZX: match runs past the block')
                block_remaining += run

        if posn - frame_start != frame_size:
            raise ValueError('LZX: frame overrun')
        bits.align()
        frame = bytes(window[frame_start:posn])
        if intel_started and intel_filesize and frame_size > 10:
            frame = _e8(frame, len(out), intel_filesize)
        out += frame
        if posn == window_size:
            posn = 0
    return bytes(out)
