"""Compiles source files with XDK 21076 cl, as their object was compiled,
and compares every function marked "// @retail 0x82..." with the retail
basefile, byte for byte apart from the fields relocations fill in.

    python tools/check.py src/<Package>/Src/<File>.cpp [...]

Each file names its object once, as "// @object <obj file name>". The
object's command line (config/objects.csv) is kept, except that every -I is
replaced with include/ and the XDK's include/xbox, and -Fo points into
build/obj/. A marked function is found in our object by its decorated name
(the symbol column of config/functions/), or, without one, by its plain
name; several statics of one name pair with ours by address order. Its
status becomes matched, near (same length, different bytes) or todo
(different length or missing), and is merged into config/status.csv (address,status; only rows that are not
todo). config/functions/ is never written. Exits 1 if any function is not
matched.
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

import coff
import inventory
import paths

IMAGE_BASE = 0x82000000
OBJECT = re.compile(r'^\s*//\s*@object\s+(\S+)', re.M)
RETAIL = re.compile(r'^\s*//\s*@retail\s+(0x[0-9A-Fa-f]+)', re.M)


def compare(ours, masks, retail):
    """matched, near (same length, other bytes) or todo (other length)."""
    if len(ours) != len(retail):
        return 'todo'
    a, b = bytearray(ours), bytearray(retail)
    for off, mask in masks:
        for i in range(4):
            keep = ~(mask >> (24 - 8 * i)) & 0xFF
            if off + i < len(a):
                a[off + i] &= keep
                b[off + i] &= keep
    return 'matched' if a == b else 'near'


def parse_markers(path):
    text = Path(path).read_text(encoding='utf-8')
    obj = OBJECT.search(text)
    if not obj:
        raise SystemExit(f'{path}: no // @object marker')
    return obj.group(1), [int(m, 16) for m in RETAIL.findall(text)]


def split_cmd(cmd):
    """Split a cl command line by the MSVC rules: spaces outside double quotes
    separate arguments, quotes are dropped, and 2n backslashes before a quote
    are n backslashes, 2n+1 are n and a literal quote."""
    out, cur, quoted, any_ = [], [], False, False
    i = 0
    while i < len(cmd):
        ch = cmd[i]
        if ch == '\\':
            n = len(cmd[i:]) - len(cmd[i:].lstrip('\\'))
            i += n
            if i < len(cmd) and cmd[i] == '"':
                cur.append('\\' * (n // 2))
                if n % 2:
                    cur.append('"')
                    i += 1
            else:
                cur.append('\\' * n)
            continue
        if ch == '"':
            quoted = not quoted
            any_ = True
        elif ch == ' ' and not quoted:
            if cur or any_:
                out.append(''.join(cur))
            cur, any_ = [], False
        else:
            cur.append(ch)
        i += 1
    if cur or any_:
        out.append(''.join(cur))
    return out


def plain_name(symbol):
    """'Class::Name' of a simple decorated name ('?Name@Class@@...'); other
    names unchanged. Templates and operators are not handled, except a
    dynamic initializer ('??__E<Var>@<Scope>@@YAXXZ')."""
    if symbol.startswith('??__E'):
        var, *scope = symbol[5:].split('@@', 1)[0].split('@')
        return '::'.join(list(reversed(scope)) + [f"`dynamic initializer for '{var}''"])
    if not symbol.startswith('?') or symbol.startswith('??'):
        return symbol
    return '::'.join(reversed(symbol[1:].split('@@', 1)[0].split('@')))


def find_symbol(c, row, same_name=None):
    """Our symbol for an inventory row: its decorated name, or, when the
    PDB has none (statics, inlines), the one symbol whose plain name is the row's.
    `same_name` is namesakes() of the inventory: when the row's object has
    several rows of its name with no decorated name and our object as many
    symbols of it, the n-th by retail address is the n-th in our object."""
    if row['symbol'] and '?A0x' not in row['symbol']:
        return row['symbol']
    if row['symbol']:  # an anonymous namespace: its '?A0x<hash>@' differs per translation unit
        anon = re.compile(r'\?A0x[0-9a-f]+@')
        want = anon.sub('?A0x@', row['symbol'])
        hits = {s.name for s in c.symbols.values() if s.section > 0 and anon.sub('?A0x@', s.name) == want}
        if len(hits) != 1:
            raise KeyError(row['name'])
        return hits.pop()
    atexit = re.search(r"`dynamic atexit destructor for '(\w+)''$", row['name'])
    if atexit:  # '??__F<Var>@<scope>@@YAXXZ': the scope of a function's static is hard to spell
        hits = {s.name for s in c.symbols.values() if s.section > 0 and s.name.startswith(f'??__F{atexit.group(1)}@')}
    else:
        hits = {s.name for s in c.symbols.values() if s.section > 0 and plain_name(s.name) == row['name']}
    peers = (same_name or {}).get((row['object'], row['name']), ())
    if len(hits) > 1 and len(hits) == len(peers):
        return in_object_order(c, hits)[peers.index(int(row['address'], 16))]
    if len(hits) != 1:
        raise KeyError(row['name'])
    return hits.pop()


def in_object_order(c, names):
    """`names` sorted by where our object defines them (section, then offset):
    cl emits functions in source order, as the linker lays out retail's."""
    where = {s.name: (s.section, s.value) for s in c.symbols.values() if s.section > 0 and s.name in names}
    return sorted(names, key=where.get)


def namesakes(rows):
    """{(object, name): sorted addresses} of the rows with no decorated name."""
    out = {}
    for r in rows:
        if not r['symbol']:
            out.setdefault((r['object'], r['name']), []).append(int(r['address'], 16))
    return {k: sorted(v) for k, v in out.items()}


class Context:
    """What checking needs: cl, the basefile, the objects' command lines, the
    inventory, and the include directories that replace the original -I."""

    def __init__(self):
        xdk = paths.xdk()
        self.cl = paths.require(xdk / 'bin' / 'win32' / 'cl.exe')
        self.image = paths.require(paths.basefile()).read_bytes()
        self.objects = {r['object']: r for r in inventory.read_csv(paths.CONFIG / 'objects.csv')}
        rows = inventory.read_functions()
        self.by_address = {int(r['address'], 16): r for r in rows}
        self.same_name = namesakes(rows)
        self.includes = [paths.ROOT / 'include', xdk / 'include' / 'xbox']

    def row(self, va, where=''):
        row = self.by_address.get(va)
        if row is None:
            raise SystemExit(f'{where}0x{va:08X} is not a function start')
        return row

    def retail(self, row):
        va = int(row['address'], 16)
        return self.image[va - IMAGE_BASE:va - IMAGE_BASE + int(row['size'])]

    def cmd(self, obj_name, where=''):
        if obj_name not in self.objects:
            raise SystemExit(f'{where}unknown object {obj_name}')
        return self.objects[obj_name]['cmd']


def function_status(ours, row, retail, same_name=None):
    """(status, our bytes) of a row's function in our parsed object; KeyError
    if the object has no (unique) symbol for it."""
    data, masks = coff.function_bytes(ours, find_symbol(ours, row, same_name))
    return compare(data, masks, retail), data


STATUS_COLUMNS = ['address', 'status']


def update_status(path, results):
    """Merge {va: status} into the status file; todo rows are dropped."""
    status = {}
    if Path(path).exists():
        status = {int(r['address'], 16): r['status'] for r in inventory.read_csv(path)}
    status.update(results)
    rows = [{'address': f'0x{va:08X}', 'status': st} for va, st in sorted(status.items()) if st != 'todo']
    inventory.write_csv(Path(path), STATUS_COLUMNS, rows)


def save(results):
    update_status(paths.CONFIG / 'status.csv', results)


def compile_args(cmd, includes, obj):
    args = [a for a in split_cmd(cmd) if not a.startswith(('-I', '/I', '-Fo', '/Fo'))]
    return args + [f'-I{p}' for p in includes] + [f'-Fo{obj}']


def compile_file(cl, cmd, includes, src, obj):
    """Run cl on `src` with an object's command line; the CompletedProcess."""
    return subprocess.run([str(cl), *compile_args(cmd, includes, obj), str(src)],
                          capture_output=True, text=True, cwd=paths.ROOT)


def main(argv=None):
    ap = argparse.ArgumentParser(description='Compile sources and compare marked functions with retail.')
    ap.add_argument('sources', nargs='+')
    args = ap.parse_args(argv)
    ctx = Context()
    results = {}
    failed = 0
    for src in args.sources:
        src = paths.require(Path(src).resolve())
        obj_name, addresses = parse_markers(src)
        cmd = ctx.cmd(obj_name, f'{src}: ')
        obj = paths.BUILD / 'obj' / src.relative_to(paths.ROOT).with_suffix('.obj')
        obj.parent.mkdir(parents=True, exist_ok=True)
        r = compile_file(ctx.cl, cmd, ctx.includes, src, obj)
        if r.returncode:
            print(r.stdout + r.stderr)
            raise SystemExit(f'{src}: cl failed')
        ours = coff.parse(obj.read_bytes())
        for va in addresses:
            row = ctx.row(va, f'{src}: ')
            size = int(row['size'])
            try:
                status, data = function_status(ours, row, ctx.retail(row), ctx.same_name)
                note = '' if status == 'matched' else f' ({len(data)} bytes vs {size})'
            except KeyError:
                status = 'todo'
                note = ' (not in our object)' if row['symbol'] else ' (no unique symbol of that name in our object)'
            results[va] = status
            failed += status != 'matched'
            print(f'{status:8} 0x{va:08X} {row["name"] or row["symbol"]}{note}')
    save(results)
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
