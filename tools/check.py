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
import csv
import difflib
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


D_FORM = {14, 24, 25, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 48, 49, 50, 51, 52, 53, 54, 55, 58, 62}


def words(data):
    return [int.from_bytes(data[i:i + 4], 'big') for i in range(0, len(data) - 3, 4)]


def normalize(ws):
    """Instruction words with the fields that relocations or layout fill in
    cleared: branch displacements, lis immediates, and the low half of a
    D-form instruction addressing through a register a recent lis set."""
    out, hot = [], {}
    for w in ws:
        op = w >> 26
        ra = (w >> 16) & 31
        if op == 18:
            k = w & 0xFC000003
        elif op == 16:
            k = w & 0xFFFF0003
        elif op == 15 and ra == 0:
            k = w & 0xFFFF0000
            hot[(w >> 21) & 31] = 9
        elif op in D_FORM and hot.get(ra):
            k = w & 0xFFFF0000
        else:
            k = w
        hot = {r: n - 1 for r, n in hot.items() if n > 1}
        out.append(k)
    return out


def same_instruction(a, b):
    """Same opcode (and extended opcode where there is one)."""
    if a >> 26 != b >> 26:
        return False
    if a >> 26 in (19, 31, 59, 63, 4):
        return (a >> 1) & 0x3FF == (b >> 1) & 0x3FF
    return True


def diff_score(ours, retail):
    """Cost of turning our instruction words into retail's."""
    a, b = normalize(words(ours)), normalize(words(retail))
    cost = 0
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes():
        if tag == 'equal':
            continue
        n = min(i2 - i1, j2 - j1) if tag == 'replace' else 0
        cost += sum(1 if same_instruction(x, y) else 2 for x, y in zip(a[i1:i1 + n], b[j1:j1 + n]))
        cost += 2 * (max(i2 - i1, j2 - j1) - n)
    return cost


def score(status, data, retail):
    """0 for a match; otherwise diff_score, at least 1. `data` is None when our
    object lacks the function: every retail word counts as missing."""
    if status == 'matched':
        return 0
    return max(1, diff_score(data or b'', retail))


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
    """(status, our bytes, score) of a row's function in our parsed object;
    KeyError if the object has no (unique) symbol for it."""
    data, masks = coff.function_bytes(ours, find_symbol(ours, row, same_name))
    status = compare(data, masks, retail)
    return status, data, score(status, data, retail)


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


SCORE_COLUMNS = ['address', 'name', 'status', 'score']


def check_file(ctx, src):
    """{va: (row, status, score, note)} of a source file's marked functions."""
    obj_name, addresses = parse_markers(src)
    cmd = ctx.cmd(obj_name, f'{src}: ')
    obj = paths.BUILD / 'obj' / src.relative_to(paths.ROOT).with_suffix('.obj')
    obj.parent.mkdir(parents=True, exist_ok=True)
    r = compile_file(ctx.cl, cmd, ctx.includes, src, obj)
    if r.returncode:
        print(r.stdout + r.stderr)
        raise SystemExit(f'{src}: cl failed')
    ours = coff.parse(obj.read_bytes())
    out = {}
    for va in addresses:
        row = ctx.row(va, f'{src}: ')
        retail = ctx.retail(row)
        try:
            status, data, sc = function_status(ours, row, retail, ctx.same_name)
            note = '' if status == 'matched' else f' ({len(data)} bytes vs {len(retail)}, score {sc})'
        except KeyError:
            status, sc = 'todo', score('todo', None, retail)
            note = (' (not in our object' if row['symbol'] else ' (no unique symbol of that name in our object') + f', score {sc})'
        out[va] = (row, status, sc, note)
    return out


def all_sources():
    return sorted((paths.ROOT / 'src').rglob('*.cpp'))


def main(argv=None):
    ap = argparse.ArgumentParser(description='Compile sources and compare marked functions with retail.')
    ap.add_argument('sources', nargs='*', help='source files (with --scores, default: every file under src/)')
    ap.add_argument('--scores', action='store_true',
                    help='print address,name,status,score of each near or todo function instead; without sources, '
                         "of every near or todo nspace function, written or not")
    args = ap.parse_args(argv)
    if not args.sources and not args.scores:
        ap.error('name the source files to check')
    ctx = Context()
    checked = {}
    for src in args.sources or all_sources():
        for va, (row, status, sc, note) in check_file(ctx, paths.require(Path(src).resolve())).items():
            checked[va] = (row, status, sc)
            if not args.scores:
                print(f'{status:8} 0x{va:08X} {row["name"] or row["symbol"]}{note}')
    save({va: status for va, (_, status, _) in checked.items()})
    if args.scores:
        rows = {va: v for va, v in checked.items() if v[1] != 'matched'}
        if not args.sources:  # every nspace function: the unwritten ones score as missing
            rows = {va: v for va, v in rows.items() if v[0]['owner'] == 'nspace'}
            for va, row in ctx.by_address.items():
                if row['owner'] == 'nspace' and va not in checked:
                    rows[va] = (row, 'todo', score('todo', None, ctx.retail(row)))
        writer = csv.writer(sys.stdout, lineterminator='\n')
        writer.writerow(SCORE_COLUMNS)
        for va, (row, status, sc) in sorted(rows.items()):
            writer.writerow([f'0x{va:08X}', row['name'] or row['symbol'], status, sc])
    return 1 if any(status != 'matched' for _, status, _ in checked.values()) else 0


if __name__ == '__main__':
    sys.exit(main())
