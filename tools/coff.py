"""Reads Xbox 360 object files: COFF with little-endian headers (regular or
-bigobj), machine 0x1F2, holding big-endian PowerPC code.

    parse(data) -> Coff
    function_bytes(coff, symbol) -> (bytes, [(offset, mask), ...])

Each mask covers the 32-bit instruction word at `offset` that a relocation
fills in, so that a comparison ignores the address fields only.
"""
import struct
from dataclasses import dataclass, field

MACHINE_PPCBE = 0x1F2
BIGOBJ_CLASSID = bytes.fromhex('c7a1bad1eeba a94baf20faf66aa4dcb8'.replace(' ', ''))

# IMAGE_REL_PPC_* type -> mask of the instruction word it patches
REL_MASKS = {
    0x0001: None,          # ADDR64: two words
    0x0002: 0xFFFFFFFF,    # ADDR32
    0x0003: 0x03FFFFFC,    # ADDR24
    0x0004: 0x0000FFFF,    # ADDR16
    0x0005: 0x0000FFFC,    # ADDR14
    0x0006: 0x03FFFFFC,    # REL24 (bl)
    0x0007: 0x0000FFFC,    # REL14
    0x000A: 0xFFFFFFFF,    # ADDR32NB
    0x000B: 0xFFFFFFFF,    # SECREL
    0x000C: 0x0000FFFF,    # SECTION
    0x000F: 0x0000FFFF,    # SECREL16
    0x0010: 0x0000FFFF,    # REFHI
    0x0011: 0x0000FFFF,    # REFLO
    0x0013: 0x0000FFFF,    # SECRELLO
    0x0014: 0x0000FFFF,    # SECRELHI
    0x0015: 0x0000FFFF,    # GPREL
}
REL_PAIR = 0x0012  # carries a displacement, not a location
REL_TYPE = 0x00FF  # the rest are flags (NEG, BRTAKEN, BRNTAKEN, TOCDEFN)


@dataclass
class Section:
    name: str
    data: bytes
    relocs: list = field(default_factory=list)  # (offset, symbol index, type)
    characteristics: int = 0


@dataclass
class Symbol:
    name: str
    value: int
    section: int  # 1-based; 0 undefined, negative special
    storage: int


@dataclass
class Coff:
    machine: int
    sections: list
    symbols: dict  # index -> Symbol

    def relocations(self, section):
        """(offset, symbol, type) of each relocation in `section` (a 1-based index or a Section)."""
        sec = self.sections[section - 1] if isinstance(section, int) else section
        return [(off, self.symbols.get(idx), kind) for off, idx, kind in sec.relocs]


def parse(data):
    sig1, sig2 = struct.unpack_from('<HH', data, 0)
    if sig1 == 0 and sig2 == 0xFFFF:
        version, machine = struct.unpack_from('<HH', data, 4)
        if data[12:28] != BIGOBJ_CLASSID:
            raise ValueError('not a bigobj COFF (import object or unknown class)')
        nsec, symptr, nsym = struct.unpack_from('<III', data, 44)
        sec_at, sym_size = 56, 20
    else:
        machine, nsec, _ts, symptr, nsym, opt, _chars = struct.unpack_from('<HHIIIHH', data, 0)
        sec_at, sym_size = 20 + opt, 18
    strings_at = symptr + nsym * sym_size

    def long_name(raw):
        if raw[:4] == b'\0\0\0\0':
            off, = struct.unpack_from('<I', raw, 4)
            return _cstr(data, strings_at + off)
        return raw.rstrip(b'\0').decode('latin1')

    sections = []
    for i in range(nsec):
        p = sec_at + 40 * i
        raw_name = data[p:p + 8]
        _vsize, _va, size, ptr, rptr, _lptr, nrel, _nlin, chars = struct.unpack_from('<IIIIIIHHI', data, p + 8)
        name = raw_name.rstrip(b'\0').decode('latin1')
        if name.startswith('/'):
            name = _cstr(data, strings_at + int(name[1:]))
        relocs = [struct.unpack_from('<IIH', data, rptr + 10 * j) for j in range(nrel)]
        sections.append(Section(name, bytes(data[ptr:ptr + size]) if ptr else bytes(size), relocs, chars))

    symbols = {}
    i = 0
    while i < nsym:
        p = symptr + sym_size * i
        raw = data[p:p + 8]
        if sym_size == 20:
            value, sec, _type, storage, naux = struct.unpack_from('<IiHBB', data, p + 8)
        else:
            value, sec, _type, storage, naux = struct.unpack_from('<IhHBB', data, p + 8)
        symbols[i] = Symbol(long_name(raw), value, sec, storage)
        i += 1 + naux
    return Coff(machine, sections, symbols)


def _cstr(data, pos):
    end = data.index(b'\0', pos)
    return bytes(data[pos:end]).decode('latin1')


def function_bytes(c, symbol):
    """The bytes of `symbol`'s function, from its value to the next symbol in
    its section (or the section's end), and the masks of its relocated words."""
    sym = next((s for s in c.symbols.values() if s.name == symbol and s.section > 0), None)
    if sym is None:
        raise KeyError(symbol)
    sec = c.sections[sym.section - 1]
    ends = [s.value for s in c.symbols.values()
            if s.section == sym.section and s.value > sym.value and s.storage in (2, 3)
            and not s.name.startswith('$')]  # $M labels mark prologue ends inside a function
    end = min(ends, default=len(sec.data))
    masks = []
    for off, _idx, kind in sec.relocs:
        kind &= REL_TYPE
        if kind == REL_PAIR or kind == 0 or not sym.value <= off < end:
            continue
        mask = REL_MASKS.get(kind)
        word = (off - sym.value) & ~3
        if mask is None:  # ADDR64
            masks += [(word, 0xFFFFFFFF), (word + 4, 0xFFFFFFFF)]
        else:
            masks.append((word, mask))
    return sec.data[sym.value:end], masks
