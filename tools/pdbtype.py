"""Renders PDB types (the TPI stream) as C++ declarations, with the offset of
each member, base classes, the vtable pointer, bitfields, arrays, pointers
and enums.

    python tools/pdbtype.py <Name> [...]
"""
import argparse
import struct

import paths

LF_MODIFIER = 0x1001
LF_POINTER = 0x1002
LF_PROCEDURE = 0x1008
LF_MFUNCTION = 0x1009
LF_ARGLIST = 0x1201
LF_FIELDLIST = 0x1203
LF_BITFIELD = 0x1205
LF_BCLASS = 0x1400
LF_VBCLASS = 0x1401
LF_IVBCLASS = 0x1402
LF_INDEX = 0x1404
LF_VFUNCTAB = 0x1409
LF_ENUMERATE = 0x1502
LF_ARRAY = 0x1503
LF_CLASS = 0x1504
LF_STRUCTURE = 0x1505
LF_UNION = 0x1506
LF_ENUM = 0x1507
LF_MEMBER = 0x150D
LF_STMEMBER = 0x150E
LF_METHOD = 0x150F
LF_NESTTYPE = 0x1510
LF_ONEMETHOD = 0x1511

FORWARD_REF = 0x80
RECORDS = (LF_CLASS, LF_STRUCTURE, LF_UNION, LF_ENUM)

PRIMITIVES = {
    0x03: ('void', 0), 0x08: ('HRESULT', 4), 0x10: ('signed char', 1), 0x20: ('unsigned char', 1),
    0x11: ('short', 2), 0x21: ('unsigned short', 2), 0x12: ('long', 4), 0x22: ('unsigned long', 4),
    0x13: ('__int64', 8), 0x23: ('unsigned __int64', 8), 0x30: ('bool', 1), 0x40: ('float', 4),
    0x41: ('double', 8), 0x68: ('__int8', 1), 0x69: ('unsigned __int8', 1), 0x70: ('char', 1),
    0x71: ('wchar_t', 2), 0x72: ('__int16', 2), 0x73: ('unsigned __int16', 2), 0x74: ('int', 4),
    0x75: ('unsigned int', 4), 0x76: ('__int64', 8), 0x77: ('unsigned __int64', 8), 0x7A: ('char16_t', 2),
    0x7B: ('char32_t', 4),
}
NUMERIC = {0x8000: '<b', 0x8001: '<h', 0x8002: '<H', 0x8003: '<i', 0x8004: '<I', 0x8009: '<q', 0x800A: '<Q'}


def numeric(data, pos):
    """(value, next position) of a numeric leaf."""
    v, = struct.unpack_from('<H', data, pos)
    if v < 0x8000:
        return v, pos + 2
    fmt = NUMERIC.get(v)
    if fmt is None:
        raise ValueError(f'unsupported numeric leaf 0x{v:X}')
    return struct.unpack_from(fmt, data, pos + 2)[0], pos + 2 + struct.calcsize(fmt)


def cstr(data, pos):
    end = data.index(b'\0', pos)
    return bytes(data[pos:end]).decode('latin1'), end + 1


class Types:
    """`source` is a Pdb (its TPI stream 2 is read) or the TPI stream's bytes."""

    def __init__(self, source):
        data = source if isinstance(source, (bytes, bytearray)) else source.msf.stream(2)
        header_size, self.begin, end = struct.unpack_from('<III', data, 4)
        self.data = data
        self.offsets = []
        pos = header_size
        for _ in range(end - self.begin):
            length, = struct.unpack_from('<H', data, pos)
            self.offsets.append(pos + 2)
            pos += 2 + length
        self._by_name = None

    def record(self, ti):
        """(kind, payload position) of type index `ti`."""
        pos = self.offsets[ti - self.begin]
        return struct.unpack_from('<H', self.data, pos)[0], pos + 2

    def _record_name(self, kind, p):
        d = self.data
        if kind in (LF_CLASS, LF_STRUCTURE):
            prop, = struct.unpack_from('<H', d, p + 2)
            _, q = numeric(d, p + 16)
        elif kind == LF_UNION:
            prop, = struct.unpack_from('<H', d, p + 2)
            _, q = numeric(d, p + 8)
        else:
            prop, = struct.unpack_from('<H', d, p + 2)
            q = p + 12
        return prop, cstr(d, q)[0]

    def find(self, name):
        """The type index of the non-forward-reference record called `name`."""
        if self._by_name is None:
            self._by_name = {}
            for i in range(len(self.offsets)):
                kind, p = self.record(self.begin + i)
                if kind in RECORDS:
                    prop, n = self._record_name(kind, p)
                    if not prop & FORWARD_REF:
                        self._by_name.setdefault(n, self.begin + i)
        return self._by_name[name]

    def _resolve(self, ti):
        """A forward reference's full definition, when there is one."""
        if ti < self.begin:
            return ti
        kind, p = self.record(ti)
        if kind in RECORDS:
            prop, name = self._record_name(kind, p)
            if prop & FORWARD_REF:
                if self._by_name is None:
                    try:
                        self.find(name)
                    except KeyError:
                        pass
                return self._by_name.get(name, ti)
        return ti

    def sizeof(self, ti):
        if ti < self.begin:
            if ti & 0xF00:
                return 8 if (ti & 0xF00) == 0x600 else 4
            return PRIMITIVES.get(ti & 0xFF, ('?', 0))[1]
        ti = self._resolve(ti)
        kind, p = self.record(ti)
        d = self.data
        if kind == LF_POINTER:
            return (struct.unpack_from('<I', d, p + 4)[0] >> 13) & 0x3F
        if kind == LF_MODIFIER:
            return self.sizeof(struct.unpack_from('<I', d, p)[0])
        if kind in (LF_CLASS, LF_STRUCTURE):
            return numeric(d, p + 16)[0]
        if kind == LF_UNION:
            return numeric(d, p + 8)[0]
        if kind == LF_ARRAY:
            return numeric(d, p + 8)[0]
        if kind == LF_ENUM:
            return self.sizeof(struct.unpack_from('<I', d, p + 4)[0])
        if kind == LF_BITFIELD:
            return self.sizeof(struct.unpack_from('<I', d, p)[0])
        return 0

    def name(self, ti):
        return self.decl(ti, '').strip()

    def decl(self, ti, name):
        """A declarator for `name` with type `ti`."""
        if ti < self.begin:
            base = PRIMITIVES.get(ti & 0xFF, (f'<0x{ti:X}>', 0))[0]
            if ti & 0xF00:
                return f'{base} *{name}'
            return f'{base} {name}'.rstrip() if name else base
        kind, p = self.record(ti)
        d = self.data
        if kind == LF_POINTER:
            utype, attr = struct.unpack_from('<II', d, p)
            mode = (attr >> 5) & 7
            star = '&' if mode in (1, 4) else '*'
            if mode in (2, 3):  # pointer to member: the class follows the attributes
                star = f'{self.name(struct.unpack_from("<I", d, p + 8)[0])}::*'
            if attr & 0x400:  # the pointer itself is const
                star += 'const' + (' ' if name else '')
            inner = star + name
            ukind = self.record(utype)[0] if utype >= self.begin else None
            if ukind in (LF_ARRAY, LF_PROCEDURE, LF_MFUNCTION):
                inner = f'({inner})'
            return self.decl(utype, inner)
        if kind == LF_MODIFIER:
            utype, attr = struct.unpack_from('<IH', d, p)
            quals = ('const ' if attr & 1 else '') + ('volatile ' if attr & 2 else '')
            return quals + self.decl(utype, name)
        if kind == LF_ARRAY:
            elem, _index = struct.unpack_from('<II', d, p)
            size, _ = numeric(d, p + 8)
            esize = self.sizeof(elem)
            count = size // esize if esize else 0
            return self.decl(elem, f'{name}[{count}]')
        if kind in RECORDS:
            return f'{self._record_name(kind, p)[1]} {name}'.rstrip()
        if kind in (LF_PROCEDURE, LF_MFUNCTION):
            ret, = struct.unpack_from('<I', d, p)
            args = struct.unpack_from('<I', d, p + (16 if kind == LF_MFUNCTION else 8))[0]
            return self.decl(ret, f'{name}({self._args(args)})')
        if kind == LF_BITFIELD:
            utype, length, _position = struct.unpack_from('<IBB', d, p)
            return f'{self.decl(utype, name)} : {length}'
        return f'<leaf 0x{kind:X}> {name}'

    def _args(self, ti):
        kind, p = self.record(ti)
        if kind != LF_ARGLIST:
            return '...'
        count, = struct.unpack_from('<I', self.data, p)
        return ', '.join(self.name(t) if t else '...' for t in struct.unpack_from(f'<{count}I', self.data, p + 4))

    def _fields(self, ti):
        """(leaf, position) of each subrecord of a field list, following LF_INDEX."""
        while ti:
            kind, p = self.record(ti)
            end = self.offsets[ti - self.begin] + struct.unpack_from('<H', self.data, self.offsets[ti - self.begin] - 2)[0]
            ti = 0
            d = self.data
            while p < end:
                if d[p] >= 0xF0:
                    p += d[p] & 0x0F
                    continue
                leaf, = struct.unpack_from('<H', d, p)
                yield leaf, p + 2
                p = self._skip(leaf, p + 2)
                if leaf == LF_INDEX:
                    ti = struct.unpack_from('<I', d, p - 4)[0]

    def _skip(self, leaf, p):
        d = self.data
        if leaf in (LF_MEMBER, LF_BCLASS):
            _, q = numeric(d, p + 6)
            return cstr(d, q)[1] if leaf == LF_MEMBER else q
        if leaf in (LF_VBCLASS, LF_IVBCLASS):
            _, q = numeric(d, p + 10)
            return numeric(d, q)[1]
        if leaf == LF_ENUMERATE:
            _, q = numeric(d, p + 2)
            return cstr(d, q)[1]
        if leaf in (LF_STMEMBER, LF_NESTTYPE):
            return cstr(d, p + 6)[1]
        if leaf == LF_METHOD:
            return cstr(d, p + 6)[1]
        if leaf == LF_ONEMETHOD:
            attr, = struct.unpack_from('<H', d, p)
            q = p + 6 + (4 if ((attr >> 2) & 7) in (4, 6) else 0)
            return cstr(d, q)[1]
        if leaf in (LF_VFUNCTAB, LF_INDEX):
            return p + 6
        raise ValueError(f'unknown field leaf 0x{leaf:X}')

    def render(self, ti):
        ti = self._resolve(ti)
        kind, p = self.record(ti)
        d = self.data
        if kind == LF_ENUM:
            _count, _prop, utype, field = struct.unpack_from('<HHII', d, p)
            lines = [f'enum {cstr(d, p + 12)[0]} : {self.name(utype)}  // size 0x{self.sizeof(utype):X}', '{']
            for leaf, q in self._fields(field):
                if leaf == LF_ENUMERATE:
                    value, r = numeric(d, q + 2)
                    lines.append(f'    {cstr(d, r)[0]} = {value},')
            return '\n'.join(lines + ['};'])
        if kind not in (LF_CLASS, LF_STRUCTURE, LF_UNION):
            return self.name(ti)
        _count, _prop, field = struct.unpack_from('<HHI', d, p)
        size, _ = numeric(d, p + (16 if kind != LF_UNION else 8))
        keyword = {LF_CLASS: 'class', LF_STRUCTURE: 'struct', LF_UNION: 'union'}[kind]
        bases, body = [], []
        for leaf, q in self._fields(field):
            if leaf == LF_BCLASS:
                _attr, base = struct.unpack_from('<HI', d, q)
                offset, _ = numeric(d, q + 6)
                bases.append(f'public {self.name(base)}')
                body.append(f'    // base {self.name(base)} at 0x{offset:X}')
            elif leaf in (LF_VBCLASS, LF_IVBCLASS):
                _attr, base = struct.unpack_from('<HI', d, q)
                bases.append(f'virtual public {self.name(base)}')
            elif leaf == LF_VFUNCTAB:
                body.append('    void **__vfptr;  // 0x0')
            elif leaf == LF_MEMBER:
                _attr, mtype = struct.unpack_from('<HI', d, q)
                offset, r = numeric(d, q + 6)
                mname = cstr(d, r)[0]
                note = ''
                if mtype >= self.begin and self.record(mtype)[0] == LF_BITFIELD:
                    note = f' bit {struct.unpack_from("<IBB", d, self.record(mtype)[1])[2]}'
                body.append(f'    {self.decl(mtype, mname)};  // 0x{offset:X}{note}')
            elif leaf == LF_STMEMBER:
                _attr, mtype = struct.unpack_from('<HI', d, q)
                body.append(f'    static {self.decl(mtype, cstr(d, q + 6)[0])};')
        head = f'{keyword} {cstr(d, self._name_pos(kind, p))[0]}'
        if bases:
            head += ' : ' + ', '.join(bases)
        return '\n'.join([f'{head}  // size 0x{size:X}', '{'] + body + ['};'])

    def _name_pos(self, kind, p):
        return numeric(self.data, p + (16 if kind != LF_UNION else 8))[1]


def main(argv=None):
    ap = argparse.ArgumentParser(description='Render PDB types as C++ declarations.')
    ap.add_argument('names', nargs='+')
    ap.add_argument('--pdb', default=None)
    args = ap.parse_args(argv)
    from pdbfile import Pdb
    types = Types(Pdb(args.pdb or paths.pdb()))
    status = 0
    for name in args.names:
        try:
            print(types.render(types.find(name)))
        except KeyError:
            print(f'// {name}: not found')
            status = 1
        print()
    return status


if __name__ == '__main__':
    raise SystemExit(main())
