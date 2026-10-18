"""Reads what the inventory needs from a PDB: the DBI header and modules,
section headers, procedure and public symbols, each module's compiler
environment strings, and C13 line information.

Named pdbfile, not pdb, so that it never shadows the Python debugger.

    python tools/pdbfile.py [pdb]      print a census
"""
import argparse
import bisect
import struct
from dataclasses import dataclass
from functools import cached_property

import msf
import paths

IMAGE_BASE = 0x82000000

S_PUB32 = 0x110E
S_LPROC32 = 0x110F
S_GPROC32 = 0x1110
S_COMPILE2 = 0x1116
S_COMPILE3 = 0x113C
S_ENVBLOCK = 0x113D

DEBUG_S_LINES = 0xF2
DEBUG_S_FILECHKSMS = 0xF4

DBI_HEADER = '<iIIHHHHHHiiiiiIiiHHI'  # 64 bytes
SECTION_HEADER_STREAM = 5  # index into the optional debug header
SECTION_CONTRIB_V2 = 0xEFFE0000 + 20140516  # 32-byte entries; V1 entries are 28 bytes
CVPSF_FUNCTION = 2
IMAGE_SCN_CNT_CODE = 0x20


@dataclass
class Module:
    index: int
    name: str
    obj: str
    sym_stream: int
    sym_size: int
    c11_size: int
    c13_size: int


@dataclass
class Proc:
    name: str
    rva: int
    size: int
    module: int
    is_global: bool


def _cstr(data, pos):
    end = data.index(b'\0', pos)
    return bytes(data[pos:end]).decode('latin1'), end + 1


def iter_symbols(data, start=4):
    """(kind, payload) for each CodeView record from `start`. Unknown kinds
    are yielded too; the walk follows each record's length, so it stays in
    sync, and stops at trailing padding (a length under 2)."""
    pos = start
    while pos + 4 <= len(data):
        length, kind = struct.unpack_from('<HH', data, pos)
        if length < 2:
            break
        yield kind, bytes(data[pos + 4:pos + 2 + length])
        pos += 2 + length


def parse_proc(payload):
    """(name, offset, segment, code size) of an S_GPROC32/S_LPROC32 payload."""
    size, = struct.unpack_from('<I', payload, 12)
    offset, seg = struct.unpack_from('<IH', payload, 28)
    name, _ = _cstr(payload, 35)
    return name, offset, seg, size


def _pairs(data, pos):
    env = {}
    while pos < len(data):
        key, pos = _cstr(data, pos)
        if not key:
            break
        env[key], pos = _cstr(data, pos)
    return env


def parse_env(kind, payload):
    """The key and value strings of an S_COMPILE2 record (after the compiler
    name) or an S_ENVBLOCK record. Other kinds give {}."""
    if kind == S_COMPILE2:
        _, pos = _cstr(payload, 18)
        return _pairs(payload, pos)
    if kind == S_ENVBLOCK:
        return _pairs(payload, 1)
    return {}


class Pdb:
    def __init__(self, path):
        self.msf = msf.open_msf(paths.require(path))
        dbi = self.msf.stream(3)
        h = struct.unpack_from(DBI_HEADER, dbi, 0)
        self._symrec_stream = h[7]
        modinfo, seccontr, secmap, srcinfo, tsmap = h[9:14]
        dbghdr, ec = h[15], h[16]
        self.machine = h[18]
        self.modules = self._modules(dbi[64:64 + modinfo])
        dbg_at = 64 + modinfo + seccontr + secmap + srcinfo + tsmap + ec
        dbg = struct.unpack_from(f'<{dbghdr // 2}H', dbi, dbg_at)
        self.sections = self._sections(dbg[SECTION_HEADER_STREAM])
        self._contributions = self._section_contributions(dbi[64 + modinfo:64 + modinfo + seccontr])
        tpi = self.msf.stream(2)
        begin, end = struct.unpack_from('<II', tpi, 8)
        self.type_count = end - begin

    @staticmethod
    def _modules(data):
        mods, pos = [], 0
        while pos < len(data):
            sym_stream, sym_size, c11, c13 = struct.unpack_from('<HIII', data, pos + 34)
            name, q = _cstr(data, pos + 64)
            obj, q = _cstr(data, q)
            mods.append(Module(len(mods), name, obj, sym_stream, sym_size, c11, c13))
            pos = (q + 3) & ~3
        return mods

    def _sections(self, stream):
        """(name, virtual address) of each section; the sizes and flags go to
        self.code_ranges."""
        data = self.msf.stream(stream)
        out = []
        self.code_ranges = []
        for pos in range(0, len(data) - 39, 40):
            name = data[pos:pos + 8].rstrip(b'\0').decode('latin1')
            size, va = struct.unpack_from('<II', data, pos + 8)
            chars, = struct.unpack_from('<I', data, pos + 36)
            out.append((name, va))
            if chars & IMAGE_SCN_CNT_CODE:
                self.code_ranges.append((va, va + size))
        return out

    def _section_contributions(self, data):
        """Sorted (rva, end, module index) of the DBI section contributions."""
        if len(data) < 4:
            return []
        version, = struct.unpack_from('<I', data, 0)
        size = 32 if version == SECTION_CONTRIB_V2 else 28
        out = []
        for pos in range(4, len(data) - size + 1, size):
            seg, _pad, offset, length, _chars, module = struct.unpack_from('<HHiiIH', data, pos)
            if 1 <= seg <= len(self.sections) and length > 0:
                rva = self.rva(seg, offset)
                out.append((rva, rva + length, module))
        out.sort()
        return out

    def contribution_module(self, rva):
        """Index of the module whose section contribution holds `rva`, or None."""
        i = bisect.bisect_right(self._contributions, (rva, float('inf'), 0)) - 1
        if i >= 0 and self._contributions[i][0] <= rva < self._contributions[i][1]:
            return self._contributions[i][2]
        return None

    def code_end(self, rva):
        """End of the code section holding `rva` (or `rva` itself outside code)."""
        return next((end for start, end in self.code_ranges if start <= rva < end), rva)

    def rva(self, seg, offset):
        return self.sections[seg - 1][1] + offset

    def _module_stream(self, module):
        if module.sym_stream == 0xFFFF:
            return b''
        return self.msf.stream(module.sym_stream)

    def module_symbols(self, module):
        return iter_symbols(self._module_stream(module)[:module.sym_size])

    def _all_procs(self):
        for mod in self.modules:
            for kind, payload in self.module_symbols(mod):
                if kind in (S_GPROC32, S_LPROC32):
                    name, offset, seg, size = parse_proc(payload)
                    yield Proc(name, self.rva(seg, offset), size, mod.index, kind == S_GPROC32)

    @cached_property
    def _procs(self):
        first, aliases = {}, {}
        for p in self._all_procs():
            if p.rva in first:
                aliases.setdefault(p.rva, []).append(p.name)
            else:
                first[p.rva] = p
        return first, aliases

    def procedures(self):
        """Every procedure, deduplicated by RVA; the first one seen wins."""
        return iter(self._procs[0].values())

    def aliases(self):
        """The other names at each code-folded RVA."""
        return self._procs[1]

    def publics(self):
        """Decorated S_PUB32 names by RVA (the first one at each RVA)."""
        out = {}
        for kind, payload in iter_symbols(self.msf.stream(self._symrec_stream), 0):
            if kind == S_PUB32:
                offset, seg = struct.unpack_from('<IH', payload, 4)
                if 1 <= seg <= len(self.sections):
                    out.setdefault(self.rva(seg, offset), _cstr(payload, 10)[0])
        return out

    def public_functions(self):
        """(rva, decorated name) of each function that has only a public
        symbol: S_PUB32 marked as a function, in code, not inside a procedure.
        The first name at an address wins."""
        procs = sorted((p.rva, p.size) for p in self.procedures())
        starts = [rva for rva, _ in procs]
        out = {}
        for kind, payload in iter_symbols(self.msf.stream(self._symrec_stream), 0):
            if kind != S_PUB32:
                continue
            flags, offset, seg = struct.unpack_from('<IIH', payload, 0)
            if not flags & CVPSF_FUNCTION or not 1 <= seg <= len(self.sections):
                continue
            rva = self.rva(seg, offset)
            if self.code_end(rva) == rva:
                continue
            i = bisect.bisect_right(starts, rva) - 1
            if i >= 0 and starts[i] <= rva < starts[i] + max(procs[i][1], 1):
                continue
            out.setdefault(rva, _cstr(payload, 10)[0])
        return sorted(out.items())

    def env(self, module):
        env = {}
        for kind, payload in self.module_symbols(module):
            if kind in (S_COMPILE2, S_ENVBLOCK):
                env.update(parse_env(kind, payload))
        return env

    @cached_property
    def _names(self):
        """The /names string table, found through the named stream map in stream 1."""
        info = self.msf.stream(1)
        size, = struct.unpack_from('<I', info, 28)
        buf = info[32:32 + size]
        pos = 32 + size
        count, _capacity, present_words = struct.unpack_from('<III', info, pos)
        pos += 12 + 4 * present_words
        deleted_words, = struct.unpack_from('<I', info, pos)
        pos += 4 + 4 * deleted_words
        for i in range(count):
            key, stream = struct.unpack_from('<II', info, pos + 8 * i)
            if _cstr(buf, key)[0] == '/names':
                names = self.msf.stream(stream)
                length, = struct.unpack_from('<I', names, 8)
                return names[12:12 + length]
        return b''

    def _c13(self, module):
        data = self._module_stream(module)
        start = module.sym_size + module.c11_size
        data = data[start:start + module.c13_size]
        pos = 0
        while pos + 8 <= len(data):
            kind, length = struct.unpack_from('<II', data, pos)
            yield kind, data[pos + 8:pos + 8 + length]
            pos += 8 + ((length + 3) & ~3)

    def first_line(self, module, rva):
        """(source file, line) of the line block covering `rva`, or None."""
        checksums, hit = None, None
        for kind, sub in self._c13(module):
            if kind == DEBUG_S_FILECHKSMS:
                checksums = sub
            elif kind == DEBUG_S_LINES and hit is None and len(sub) >= 32:
                offset, seg, _flags, size = struct.unpack_from('<IHHI', sub, 0)
                start = self.rva(seg, offset)
                if start <= rva < start + max(size, 1):
                    file_id, nlines = struct.unpack_from('<II', sub, 12)
                    if nlines:
                        line, = struct.unpack_from('<I', sub, 28)
                        hit = file_id, line & 0xFFFFFF
        if hit is None or checksums is None:
            return None
        name_off, = struct.unpack_from('<I', checksums, hit[0])
        return _cstr(self._names, name_off)[0], hit[1]


def main(argv=None):
    ap = argparse.ArgumentParser(description='Print a census of a PDB.')
    ap.add_argument('pdb', nargs='?', default=None)
    args = ap.parse_args(argv)
    p = Pdb(args.pdb or paths.pdb())
    procs = list(p.procedures())
    print(f'machine 0x{p.machine:X}  types {p.type_count}  modules {len(p.modules)}  '
          f'procedures {len(procs)}  bytes {sum(x.size for x in procs)}')


if __name__ == '__main__':
    main()
