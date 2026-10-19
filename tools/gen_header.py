"""Writes C++ declarations from the PDB (the TPI stream, through pdbtype.py)
that compile under the PDB's -W4 -WX and keep the PDB's layout.

    python tools/gen_header.py <Class> [...] [--opaque <Class> ...] [-o <file>]

Each named class (a target) gets its data members at the PDB's offsets, with
explicit padding where the PDB has none. Everything a target needs comes
along: its bases, the types of its by-value members, and forward
declarations of the types it points at, each in its namespace. Classes that
are not targets are opaque: their own data is one char array of the PDB's
size. Every class keeps its vtable: its own virtuals (those that start a
slot) in slot order, with ReservedSlotN where a slot's method is unknown.
Methods are declared with the PDB's access, so their decorated names match;
compiler-generated ones are left out. Bodies (inline functions) are written
by hand, after the generated part.
"""
import argparse
import re
import struct
import sys
from pathlib import Path

import paths
import pdbtype as pt

LF_METHODLIST = 0x1206
COMPGEN = 0x100
ACCESS = {1: 'private', 2: 'protected', 3: 'public'}
BUILTIN = {'__vector4'}


def split_scope(name):
    """'A::B<C::D>::E' -> ['A', 'B<C::D>', 'E'] (top-level '::' only)."""
    parts, depth, cur, i = [], 0, '', 0
    while i < len(name):
        ch = name[i]
        if ch == '<':
            depth += 1
        elif ch == '>':
            depth -= 1
        if depth == 0 and name.startswith('::', i):
            parts.append(cur)
            cur, i = '', i + 2
            continue
        cur += ch
        i += 1
    return parts + [cur]


def template_args(name):
    """('Base', ['arg', ...]) of 'Base<arg,...>', or (name, None)."""
    if not name.endswith('>') or '<' not in name:
        return name, None
    base = name[:name.index('<')]
    inner, args, depth, cur = name[len(base) + 1:-1], [], 0, ''
    for ch in inner:
        if ch in '<(':
            depth += 1
        elif ch in '>)':
            depth -= 1
        if ch == ',' and depth == 0:
            args.append(cur.strip())
            cur = ''
        else:
            cur += ch
    return base, args + [cur.strip()]


def ident(name):
    return re.sub(r'\W', '_', name)


class Header:
    """Collects the classes, enums and forward declarations a set of target
    classes needs, and renders them in dependency order."""

    def __init__(self, types, targets=(), opaque=(), extra=None):
        self.t = types
        self.extra = extra or {}  # class -> member declarations the PDB lacks (member templates)
        self.targets = set(targets)
        self.classes = {}   # full name -> type index, everything rendered with a body
        self.forward = set()  # full names declared only
        self.enums = {}     # full name -> type index
        self.templates = {}  # qualified template name -> argument kinds
        self.deps = {}      # name -> classes that must be complete before it
        self._stack = []
        for name in list(targets) + list(opaque):
            self._need_class(self.t.find(name))

    # ---- type records -------------------------------------------------
    def _kind(self, ti):
        return self.t.record(ti)[0] if ti >= self.t.begin else None

    def _rname(self, ti):
        kind, p = self.t.record(ti)
        return self.t._record_name(kind, p)[1]

    def _is_record_name(self, name):
        try:
            return self._kind(self.t.find(name)) != pt.LF_ENUM
        except KeyError:
            return False

    def _scope_of(self, name):
        """The enclosing class of a nested name, or None for namespace scope."""
        parts = split_scope(name)
        for i in range(len(parts) - 1, 0, -1):
            outer = '::'.join(parts[:i])
            if self._is_record_name(outer):
                return outer
        return None

    # ---- collecting ---------------------------------------------------
    def _need_class(self, ti, dep=True):
        """A complete definition of record `ti` (opaque unless a target);
        with `dep`, the class being collected needs it complete."""
        ti = self.t._resolve(ti)
        name = self._rname(ti)
        if name in BUILTIN:
            return
        if dep and self._stack:
            self.deps[self._stack[-1]].add(name)
        if name in self.classes:
            return
        self.classes[name] = ti
        self.deps[name] = set()
        self._stack.append(name)
        self._note_name(name)
        outer = self._scope_of(name)
        if outer:
            self._need_class(self.t.find(outer), dep=False)
        for base, _off in self.bases(ti):
            self._need_class(base)
        for ti_m in self.nested(ti).values():
            if self._kind(ti_m) == pt.LF_ENUM:
                self._need(ti_m, complete=True)
        for m in self.members(ti) if name in self.targets else ():
            if not self.blob_member(m[1]):
                self._need(m[1], complete=True)
        for m in self.methods(ti):
            self._need(m['type'], complete=False)
        self._stack.pop()

    def _need(self, ti, complete):
        if ti < self.t.begin:
            return
        kind, p = self.t.record(ti)
        d = self.t.data
        if kind == pt.LF_POINTER:
            self._need(struct.unpack_from('<I', d, p)[0], False)
        elif kind == pt.LF_MODIFIER:
            self._need(struct.unpack_from('<I', d, p)[0], complete)
        elif kind == pt.LF_ARRAY:
            self._need(struct.unpack_from('<I', d, p)[0], complete)
        elif kind == pt.LF_BITFIELD:
            self._need(struct.unpack_from('<I', d, p)[0], complete)
        elif kind in (pt.LF_PROCEDURE, pt.LF_MFUNCTION):
            self._need(struct.unpack_from('<I', d, p)[0], False)
            args = struct.unpack_from('<I', d, p + (16 if kind == pt.LF_MFUNCTION else 8))[0]
            akind, ap = self.t.record(args)
            if akind == pt.LF_ARGLIST:
                count, = struct.unpack_from('<I', d, ap)
                for a in struct.unpack_from(f'<{count}I', d, ap + 4):
                    self._need(a, False)
        elif kind == pt.LF_ENUM:
            ti = self.t._resolve(ti)
            p = self.t.record(ti)[1]
            name = cstr_at(d, p + 12)
            if name not in self.enums:
                self.enums[name] = ti
                self._note_name(name)
                outer = self._scope_of(name)
                if outer:
                    self._need_class(self.t.find(outer), dep=True)
        elif kind in (pt.LF_CLASS, pt.LF_STRUCTURE, pt.LF_UNION):
            name = self._rname(ti)
            if name in BUILTIN:
                return
            if complete:
                self._need_class(ti)
            elif self._scope_of(name):
                self._need_class(self.t.find(self._scope_of(name)), dep=True)
                self.forward.add(name)
            else:
                self.forward.add(name)
                self._note_name(name)

    def _note_name(self, name):
        """Declare the templates a name uses, and the types in its arguments."""
        for part in split_scope(name):
            base, args = template_args(part)
            if args is None:
                continue
            kinds = ['int' if re.fullmatch(r'-?\d+', a) else 'class' for a in args]
            self.templates.setdefault(base if base in self.templates else self._qualify(name, part, base), kinds)
            for a in args:
                arg = re.sub(r'^(?:const |enum |class |struct |union )+', '', a.rstrip(' *&')).strip()
                if re.fullmatch(r'-?\d+', a):
                    continue
                if arg and arg not in pt_PRIMS and arg not in BUILTIN:
                    if arg in self.enums or self._enum_index(arg):
                        if arg not in self.enums:
                            self._need(self._enum_index(arg), True)
                    elif self._is_record_name(arg):
                        if a.rstrip().endswith(('*', '&')):
                            self._need(self.t.find(arg), False)
                        else:
                            self._need_class(self.t.find(arg))
                    elif not self._is_enum_name(arg):
                        self.forward.add(arg)
                        self._note_name(arg)

    def blob_member(self, mtype):
        """A by-value template whose arguments name a nested class: its
        specialization could need its own user complete, so it is a char array."""
        if mtype < self.t.begin or self._kind(mtype) not in (pt.LF_CLASS, pt.LF_STRUCTURE, pt.LF_UNION):
            return False
        name = self._rname(self.t._resolve(mtype))
        if name in self.targets:
            return False
        args = template_args(split_scope(name)[-1])[1] or []
        return any(self._scope_of(n) for a in args for n in re.findall(r'\w+(?:::\w+)+', a))

    def _is_enum_name(self, name):
        return name in self.enums

    def _enum_index(self, name):
        """The type index of the enum called `name`, or None."""
        try:
            ti = self.t.find(name)
        except KeyError:
            return None
        return ti if self._kind(ti) == pt.LF_ENUM else None

    def _qualify(self, full, part, base):
        parts = split_scope(full)
        return '::'.join(parts[:parts.index(part)] + [base])

    # ---- records' contents --------------------------------------------
    def fields(self, ti):
        kind, p = self.t.record(ti)
        field = struct.unpack_from('<I', self.t.data, p + 4)[0] if kind != pt.LF_ENUM else 0
        return self.t._fields(field) if field else iter(())

    def bases(self, ti):
        out = []
        for leaf, q in self.fields(ti):
            if leaf == pt.LF_BCLASS:
                _attr, base = struct.unpack_from('<HI', self.t.data, q)
                out.append((self.t._resolve(base), pt.numeric(self.t.data, q + 6)[0]))
        return out

    def has_vfptr(self, ti):
        return any(leaf == pt.LF_VFUNCTAB for leaf, _q in self.fields(ti))

    def nested(self, ti):
        out = {}
        for leaf, q in self.fields(ti):
            if leaf == pt.LF_NESTTYPE:
                _pad, idx = struct.unpack_from('<HI', self.t.data, q)
                out[cstr_at(self.t.data, q + 6)] = idx
        return out

    def members(self, ti):
        """(name, type, offset, access) of each data member, statics with offset None."""
        d, out = self.t.data, []
        for leaf, q in self.fields(ti):
            if leaf == pt.LF_MEMBER:
                attr, mtype = struct.unpack_from('<HI', d, q)
                off, r = pt.numeric(d, q + 6)
                out.append((cstr_at(d, r), mtype, off, attr & 3))
            elif leaf == pt.LF_STMEMBER:
                attr, mtype = struct.unpack_from('<HI', d, q)
                out.append((cstr_at(d, q + 6), mtype, None, attr & 3))
        return out

    def methods(self, ti):
        """Each method the source declared: name, type, access, mprop, slot."""
        d, out = self.t.data, []

        def add(name, attr, mtype, vbase):
            if not attr & COMPGEN and not name.startswith('__'):
                out.append({'name': name, 'type': mtype, 'access': attr & 3,
                            'mprop': (attr >> 2) & 7, 'slot': None if vbase is None else vbase // 4})

        for leaf, q in self.fields(ti):
            if leaf == pt.LF_ONEMETHOD:
                attr, mtype = struct.unpack_from('<HI', d, q)
                intro = ((attr >> 2) & 7) in (4, 6)
                vbase = struct.unpack_from('<I', d, q + 6)[0] if intro else None
                add(cstr_at(d, q + 6 + (4 if intro else 0)), attr, mtype, vbase)
            elif leaf == pt.LF_METHOD:
                count, mlist = struct.unpack_from('<HI', d, q)
                name = cstr_at(d, q + 6)
                kind, mp = self.t.record(mlist)
                end = self.t.offsets[mlist - self.t.begin] + struct.unpack_from(
                    '<H', d, self.t.offsets[mlist - self.t.begin] - 2)[0]
                while mp < end:
                    attr, _pad, mtype = struct.unpack_from('<HHI', d, mp)
                    mp += 8
                    vbase = None
                    if ((attr >> 2) & 7) in (4, 6):
                        vbase, = struct.unpack_from('<I', d, mp)
                        mp += 4
                    add(name, attr, mtype, vbase)
        return out

    # ---- rendering ----------------------------------------------------
    def method_decl(self, cls, m):
        d = self.t.data
        kind, p = self.t.record(m['type'])
        ret, _cls, this = struct.unpack_from('<III', d, p)
        args = struct.unpack_from('<I', d, p + 16)[0]
        short = split_scope(cls)[-1]
        base = template_args(short)[0]
        name = m['name']
        params = self.t._args(args)
        if params == 'void':
            params = ''
        tbase, targs = template_args(name)
        if tbase in (base, '~' + base):  # a constructor or destructor
            name, targs = tbase, None
        if targs is not None:  # an instantiated member template: declare the template
            if len(targs) != 1 or name.startswith('operator'):
                return None
            arg = re.compile(r'(?<![\w:])' + re.escape(targs[0]) + r'(?![\w<])')
            return 'template <class T0> ' + arg.sub('T0', self.t.decl(ret, f'{tbase}({params})')) + ';'
        const = ''
        if this >= self.t.begin and self._kind(this) == pt.LF_POINTER:
            under = struct.unpack_from('<I', d, self.t.record(this)[1])[0]
            if under >= self.t.begin and self._kind(under) == pt.LF_MODIFIER:
                if struct.unpack_from('<H', d, self.t.record(under)[1] + 4)[0] & 1:
                    const = ' const'
        if name.startswith('operator ') and name[9:10].isalpha() and not name.startswith(('operator new', 'operator delete')):
            head = f'{name}({params})'
        elif name in (short, base) or name == '~' + base or name == '~' + short:
            head = f'{name.replace(short, base)}({params})'
        else:
            head = self.t.decl(ret, f'{name}({params})')
        prefix = {2: 'static ', 1: 'virtual ', 4: 'virtual ', 5: 'virtual ', 6: 'virtual '}.get(m['mprop'], '')
        pure = ' = 0' if m['mprop'] in (5, 6) else ''
        return f'{prefix}{head}{const}{pure};'

    def body(self, name):
        ti = self.classes[name]
        target = name in self.targets
        d = self.t.data
        lines, access = [], [None]

        def emit(acc, text):
            if acc != access[0]:
                lines.append(f'{ACCESS.get(acc, "public")}:')
                access[0] = acc
            lines.append('    ' + text)

        for nname, nti in self.nested(ti).items():
            full = f'{name}::{nname}'
            if full in self.enums:
                emit(3, self.render_enum(self.enums.pop(full), nname).replace('\n', '\n    '))
            elif full in self.classes:
                emit(3, self.render_class(full)[0].replace('\n', '\n    '))
            elif full in self.forward:
                kind = 'struct' if self._kind(self.t._resolve(nti)) == pt.LF_STRUCTURE else 'class'
                emit(3, f'{kind} {nname};')
        methods = self.methods(ti)
        intro = sorted((m for m in methods if m['slot'] is not None), key=lambda m: m['slot'])
        first = self._first_slot(ti)
        slot = first
        for m in intro:
            while slot < m['slot']:
                emit(3, f'virtual void ReservedSlot{slot}();')
                slot += 1
            text = self.method_decl(name, m)
            emit(m['access'], text or f'virtual void ReservedSlot{slot}();')
            slot = m['slot'] + 1
        seen = set()
        for m in methods:
            if m['slot'] is None:
                text = self.method_decl(name, m)
                if text and text not in seen:
                    seen.add(text)
                    emit(m['access'], text)
        for text in self.extra.get(name, ()):
            emit(3, text)
        size = self.t.sizeof(ti)
        cur = max([off + self.t.sizeof(b) for b, off in self.bases(ti)] + [4 if self.has_vfptr(ti) and not self.bases(ti) else 0])
        if size == 1 and not any(off is not None for _n, _t, off, _a in self.members(ti)):
            size = cur  # an empty class stays empty, so empty-base layout holds
        if not self.bases(ti) and self.has_vfptr(ti) and not intro:
            emit(3, 'virtual ~' + template_args(split_scope(name)[-1])[0] + '();')
        pad = 0
        if target:
            prev_off = None
            for mname, mtype, off, acc in self.members(ti):
                if off is None:
                    emit(acc, 'static ' + self.t.decl(mtype, mname) + ';')
                    continue
                bit = self._kind(mtype) == pt.LF_BITFIELD
                if bit and off == prev_off:
                    emit(3, self.t.decl(mtype, mname) + ';')
                    continue
                if off > cur:
                    emit(3, f'char _pad{pad}[0x{off - cur:X}];')
                    pad += 1
                elif off < cur:  # overlaps a base's tail (empty base, union): keep going
                    pass
                if self.blob_member(mtype):
                    emit(3, f'char {mname}[0x{self.t.sizeof(mtype):X}];  // 0x{off:X} {self.t.name(mtype)}')
                else:
                    emit(3, self.t.decl(mtype, mname) + f';  // 0x{off:X}')
                cur = max(cur, off + self.t.sizeof(mtype))
                prev_off = off
            if size > cur:
                emit(3, f'char _pad{pad}[0x{size - cur:X}];')
        elif size > cur:
            emit(1, f'char {ident(template_args(split_scope(name)[-1])[0])}Data[0x{size - cur:X}];')
        return lines

    def _first_slot(self, ti):
        """The first vtable slot `ti` itself introduces (after its primary base's)."""
        bases = self.bases(ti)
        if not bases or bases[0][1] != 0:
            return 0
        return self._slot_count(bases[0][0])

    def _slot_count(self, ti):
        intro = [m['slot'] for m in self.methods(ti) if m['slot'] is not None]
        own = max(intro) + 1 if intro else 0
        return max(own, self._first_slot(ti) if self.bases(ti) else (1 if self.has_vfptr(ti) else 0))

    def render_enum(self, ti, short):
        d = self.t.data
        _count, _prop, utype, field = struct.unpack_from('<HHII', d, self.t.record(ti)[1])
        lines = ['enum' if 'unnamed-tag' in short else f'enum {short}', '{']
        for leaf, q in self.t._fields(field):
            if leaf == pt.LF_ENUMERATE:
                value, r = pt.numeric(d, q + 2)
                lines.append(f'    {cstr_at(d, r)} = {value},')
        return '\n'.join(lines + ['};'])

    def render_class(self, name):
        ti = self.classes[name]
        kind = self._kind(ti)
        keyword = {pt.LF_CLASS: 'class', pt.LF_STRUCTURE: 'struct', pt.LF_UNION: 'union'}[kind]
        parts = split_scope(name)
        outer = self._scope_of(name)
        short = parts[-1]
        spec = '' if template_args(short)[1] is None else 'template <> '
        head = f'{spec}{keyword} {short}'
        bases = self.bases(ti)
        if bases:
            head += ' : ' + ', '.join(f'public {self._rname(b)}' for b, _o in bases)
        head += f'  // size 0x{self.t.sizeof(ti):X}' + ('' if name in self.targets else ', opaque')
        text = '\n'.join([head, '{'] + self.body(name) + ['};'])
        return text, (None if outer else parts[:-1])

    def render(self):
        out = ['#pragma once', '']
        scoped = {}  # namespace tuple -> lines

        def put(ns, text):
            scoped.setdefault(tuple(ns), []).append(text)

        for tname, kinds in sorted(self.templates.items()):
            parts = split_scope(tname)
            if self._scope_of(tname):
                continue
            params = ', '.join(f'{k} T{i}' for i, k in enumerate(kinds))
            put(parts[:-1], f'template <{params}> {self._keyword(tname + "<")} {parts[-1]};')
        prefixes = {'::'.join(split_scope(n)[:i]) for n in self.forward | set(self.classes) | set(self.enums)
                    for i in range(1, len(split_scope(n)))}
        for fname in sorted((self.forward | set(self.classes)) - set(self.enums)):
            if fname in prefixes and not self._is_record_name(fname):
                continue
            if 'unnamed-tag' in fname or self._scope_of(fname) or template_args(split_scope(fname)[-1])[1] is not None or fname in self.templates:
                continue
            parts = split_scope(fname)
            put(parts[:-1], f'{self._keyword(fname)} {parts[-1]};')
        for ename, eti in sorted(self.enums.items()):
            if self._scope_of(ename):
                continue
            parts = split_scope(ename)
            put(parts[:-1], self.render_enum(eti, parts[-1]))
        for ns, lines in scoped.items():
            out += self._wrap(list(ns), lines) + ['']
        for name in self.order():
            text, ns = self.render_class(name)
            out += self._wrap(ns or [], [text]) + ['']
        return '\n'.join(out)

    def _keyword(self, name):
        """'struct', 'union' or 'class' for a record name, or for any
        instance of a template when `name` ends with '<'."""
        if not hasattr(self, '_kinds'):
            self._kinds = {}
            for i in range(len(self.t.offsets)):
                kind, p = self.t.record(self.t.begin + i)
                if kind in (pt.LF_CLASS, pt.LF_STRUCTURE, pt.LF_UNION):
                    n = self.t._record_name(kind, p)[1]
                    self._kinds.setdefault(n, kind)
                    if '<' in n:
                        self._kinds.setdefault(n[:n.index('<') + 1], kind)
        kind = self._kinds.get(name, pt.LF_CLASS)
        return {pt.LF_STRUCTURE: 'struct', pt.LF_UNION: 'union'}.get(kind, 'class')

    def _top(self, name):
        while self._scope_of(name) in self.classes:
            name = self._scope_of(name)
        return name

    def order(self):
        """Top-level classes, each after the classes it needs complete
        (a nested class's needs count as its outer class's)."""
        needs = {}
        for name, deps in self.deps.items():
            top = self._top(name)
            needs.setdefault(top, set()).update(self._top(d) for d in deps)
        out, seen = [], set()

        def visit(n):
            if n in seen:
                return
            seen.add(n)
            for d in sorted(needs.get(n, ())):
                if d != n:
                    visit(d)
            out.append(n)

        for n in sorted(needs):
            visit(n)
        return out

    @staticmethod
    def _wrap(ns, lines):
        if not ns:
            return lines
        return [' '.join(f'namespace {n} {{' for n in ns)] + lines + ['}' * len(ns)]


pt_PRIMS = {v[0] for v in pt.PRIMITIVES.values()} | {'bool', 'int', 'unsigned int', 'void'}


def cstr_at(data, pos):
    return pt.cstr(data, pos)[0]


def render_header(types, targets, opaque=(), extra=None):
    return Header(types, targets, opaque, extra).render()


def render_class(types, name, opaque_bases=True):
    """`name`'s declaration, with what it needs (bases opaque) when opaque_bases."""
    h = Header(types, [name])
    if opaque_bases:
        return h.render()
    return h.render_class(name)[0]


HAND = '// ---- written by hand below this line (gen_header.py keeps it) ----'


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write C++ declarations from the PDB.')
    ap.add_argument('names', nargs='+')
    ap.add_argument('--opaque', nargs='*', default=[])
    ap.add_argument('--add', action='append', default=[], metavar='CLASS=DECL',
                    help='a member declaration the PDB lacks, such as a member template')
    ap.add_argument('-o', '--output')
    ap.add_argument('--pdb', default=None)
    args = ap.parse_args(argv)
    from pdbfile import Pdb
    extra = {}
    for item in args.add:
        cls, decl = item.split('=', 1)
        extra.setdefault(cls, []).append(decl)
    text = render_header(pt.Types(Pdb(args.pdb or paths.pdb())), args.names, args.opaque, extra)
    command = ' '.join(['python tools/gen_header.py'] + [f'"{a}"' if set(a) & set(' <>*&=') else a for a in (argv or sys.argv[1:]) if a != args.output and a not in ('-o', '--output')])
    text = f'// Generated from the PDB by:\n//   {command} -o <this file>\n{text}'
    if args.output:
        out = Path(args.output)
        old = out.read_text(encoding='utf-8') if out.exists() else ''
        tail = old.split(HAND, 1)[1] if HAND in old else '\n'
        out.write_text(f'{text}\n{HAND}{tail}', encoding='utf-8', newline='\n')
    else:
        sys.stdout.write(text + '\n')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
