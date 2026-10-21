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
import bisect
import collections
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


def align(ours, retail):
    """(our normalized words, retail's, SequenceMatcher opcodes aligning them)."""
    a, b = normalize(words(ours)), normalize(words(retail))
    return a, b, difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes()


def aligned_rows(opcodes):
    """(our index or None, retail index or None, equal) for each row of an
    alignment: a replaced block pairs its words in order, the longer side's
    rest pairs with nothing."""
    for tag, i1, i2, j1, j2 in opcodes:
        for k in range(max(i2 - i1, j2 - j1)):
            yield (i1 + k if i1 + k < i2 else None), (j1 + k if j1 + k < j2 else None), tag == 'equal'


def diff_score(ours, retail):
    """Cost of turning our instruction words into retail's."""
    a, b, opcodes = align(ours, retail)
    cost = 0
    for tag, i1, i2, j1, j2 in opcodes:
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

DEBUG_S_STRINGTABLE = 0xF3


def object_lines(c, symbol):
    """[(offset, line, file)] of `symbol`'s function in our object, from the
    C13 line tables cl -Z7 writes to .debug$S (the objects' own command
    lines already ask for them)."""
    import pdbfile
    checksums = strings = None
    found = []
    for sec in c.sections:
        if sec.name != '.debug$S' or sec.data[:4] != b'\x04\0\0\0':
            continue
        targets = {off: sym for off, sym, _ in c.relocations(sec) if sym is not None}
        for kind, sub, pos in pdbfile.c13_subsections(sec.data, 4):
            if kind == pdbfile.DEBUG_S_FILECHKSMS:
                checksums = sub
            elif kind == DEBUG_S_STRINGTABLE:
                strings = sub
            elif kind == pdbfile.DEBUG_S_LINES and getattr(targets.get(pos), 'name', None) == symbol:
                found.append(pdbfile.parse_lines(sub))
    out = []
    for offset, _seg, _size, blocks in found:
        for file_id, entries in blocks:
            name = pdbfile.file_name(checksums, file_id, strings)
            out += [(offset + off, line, name) for off, line in entries]
    return sorted(out)


def _line_at(table, offset):
    """The entry of an offset-sorted line table that covers `offset`."""
    i = bisect.bisect_right([e[0] for e in table], offset) - 1
    return table[max(i, 0)] if table else None


def line_report(ours, our_lines, retail, retail_lines, source_text=None):
    """Text lines comparing our function with retail's statement by
    statement: the aligned disassembly, each side annotated with its source
    lines (retail's as L+n from the function's first line, ours as L+n and
    the line itself), then a summary per retail line: its bytes and first
    offset, the line of ours its instructions align with, and where the
    byte counts or the order differ."""
    import capstone
    md = capstone.Cs(capstone.CS_ARCH_PPC, capstone.CS_MODE_32 | capstone.CS_MODE_BIG_ENDIAN)

    def text(data):
        out = []
        for i in range(0, len(data) - 3, 4):
            ins = next(md.disasm(data[i:i + 4], i), None)
            out.append(f'{ins.mnemonic} {ins.op_str}'.strip() if ins else f'.long 0x{data[i:i + 4].hex()}')
        return out

    r_base = retail_lines[0][1] if retail_lines else 0
    main_file = our_lines[0][2] if our_lines else None
    o_base = our_lines[0][1] if our_lines else 0
    r_key = lambda j: _line_at(retail_lines, 4 * j)[1] - r_base if retail_lines else None
    o_entry = lambda i: _line_at(our_lines, 4 * i)

    def o_key(i):
        e = o_entry(i)
        return None if e is None else (e[1] - o_base if e[2] == main_file else (e[2], e[1]))

    def o_name(key):
        if key is None:
            return '?'
        if isinstance(key, tuple):
            return f'{key[0].replace(chr(92), "/").split("/")[-1]}:{key[1]}'
        return f'L+{key}'

    def r_name(key):
        return '?' if key is None else f'L+{key}'

    a, b, opcodes = align(ours, retail)
    rows = list(aligned_rows(opcodes))
    ot, rt = text(ours), text(retail)
    out = [f'{"":2}{"retail":>5} {"":6} {"":34} | {"ours":>5} {"":6} {"":34} source of ours']
    shown = None
    for i, j, equal in rows:
        left = f'{4 * j:5x} {r_name(r_key(j)):>6} {rt[j]:34}' if j is not None else f'{"":5} {"":6} {"":34}'
        right = f'{4 * i:5x} {o_name(o_key(i)):>6} {ot[i]:34}' if i is not None else f'{"":5} {"":6} {"":34}'
        src = ''
        e = o_entry(i) if i is not None else None
        if e is not None and (e[2], e[1]) != shown:
            shown = (e[2], e[1])
            line = source_text(e[2], e[1]) if source_text else None
            src = f'{e[1]}: {line.strip()[:60]}' if line else f'{e[1]}'
        out.append(f'{"  " if equal else "* "}{left} | {right} {src}'.rstrip())

    # per statement: each line of ours belongs to the retail line most of its
    # aligned instructions come from
    r_bytes, r_first, o_bytes, o_first, votes, votes_r = {}, {}, {}, {}, {}, {}
    for j in range(len(rt)):
        r_bytes[r_key(j)] = r_bytes.get(r_key(j), 0) + 4
        r_first.setdefault(r_key(j), 4 * j)
    for i in range(len(ot)):
        o_bytes[o_key(i)] = o_bytes.get(o_key(i), 0) + 4
        o_first.setdefault(o_key(i), 4 * i)
    for i, j, _ in rows:
        if i is not None and j is not None:
            v = votes.setdefault(o_key(i), {})
            v[r_key(j)] = v.get(r_key(j), 0) + 1
            v = votes_r.setdefault(r_key(j), {})
            v[o_key(i)] = v.get(o_key(i), 0) + 1
    owner = {o: max(v, key=lambda k: (v[k], -r_first[k])) for o, v in votes.items()}
    # a statement moved elsewhere can't align (the alignment keeps order):
    # pair the leftovers of both sides by the instructions they share
    r_words, o_words = {}, {}
    for j, w in enumerate(b):
        r_words.setdefault(r_key(j), collections.Counter())[w] += 1
    for i, w in enumerate(a):
        o_words.setdefault(o_key(i), collections.Counter())[w] += 1
    lone_r = [k for k in r_first if k not in votes_r]
    lone_o = [o for o in o_first if o not in owner]
    for shared, k, o in sorted(((sum((r_words[k] & o_words[o]).values()), k, o) for k in lone_r for o in lone_o),
                               key=lambda t: (-t[0], r_first[t[1]], o_first[t[2]])):
        if k in lone_r and o in lone_o and 2 * shared >= min(sum(r_words[k].values()), sum(o_words[o].values())):
            owner[o] = k
            lone_r.remove(k)
            lone_o.remove(o)
    claimed = {}
    for o in sorted(owner, key=o_first.get):
        claimed.setdefault(owner[o], []).append(o)
    order = sorted(r_first, key=r_first.get)
    pos = {k: (o_first[claimed[k][0]] if k in claimed else
               o_first[max(votes_r[k], key=votes_r[k].get)] if k in votes_r else None) for k in order}
    out += ['', 'statements in retail order: retail line, its bytes @ first offset; the lines of ours whose code '
                'aligns with it (^ retail runs it after the line above it)']
    flagged = 0
    for n, k in enumerate(order):
        note = []
        if k in claimed:
            total = sum(o_bytes[o] for o in claimed[k])
            right = ', '.join(f'{o_name(o)} {o_bytes[o]} B' for o in claimed[k])
            if len(claimed[k]) > 1:
                right += f' (= {total} B)'
            if total != r_bytes[k]:
                note.append(f'ours {total - r_bytes[k]:+d} B')
        elif k in votes_r:
            right = f'inside {o_name(max(votes_r[k], key=votes_r[k].get))}'
        else:
            right = 'nothing aligned'
        if pos[k] is not None:
            early = [m for m in order[n + 1:] if pos[m] is not None and pos[m] < pos[k]]
            if early:
                note.append(f'ours runs it after {r_name(early[0])}')
        prev = order[n - 1] if n else None
        mark = '^' if isinstance(prev, int) and isinstance(k, int) and prev > k else ' '
        flagged += bool(note) or right == 'nothing aligned'
        out.append(f'  {mark}{r_name(k):>6} {r_bytes[k]:4d} B @{r_first[k]:<4x} {right}' + (f'   <- {"; ".join(note)}' if note else ''))
    extra = sorted((o for o in o_bytes if o not in owner), key=o_first.get)
    if extra:
        out.append('  ours only: ' + ', '.join(f'{o_name(o)} {o_bytes[o]} B @{o_first[o]:x}' for o in extra))
    if not flagged and not extra:
        out.append("  every statement has retail's size and order: what differs is registers, operands or "
                   'scheduling within statements')
    return out


def name_matches(want, row, va):
    """Does `want` (0x address, a full name, or its last ::part) name this row?"""
    if re.fullmatch(r'0x[0-9A-Fa-f]+', want):
        return int(want, 16) == va
    name = row['name'] or row['symbol']
    return want == name or name.endswith('::' + want)


def show_lines(ctx, names, sources):
    """Print line_report for each marked function `names` pick out."""
    import pdbfile
    hits = []
    for src in sources:
        src = Path(src).resolve()
        try:
            _, addresses = parse_markers(src)
        except SystemExit:
            continue
        hits += [(src, va) for va in addresses if va in ctx.by_address
                 and any(name_matches(n, ctx.by_address[va], va) for n in names)]
    if not hits:
        raise SystemExit(f'no marked function named {" or ".join(names)}')
    pdb = pdbfile.Pdb(paths.pdb())
    procs = {p.rva: p for p in pdb.procedures()}
    files = {}

    def source_text(path, line):
        if path not in files:
            try:
                files[path] = Path(path).read_text(encoding='utf-8', errors='replace').splitlines()
            except OSError:
                files[path] = []
        lines = files[path]
        return lines[line - 1] if 0 < line <= len(lines) else None

    for src in dict.fromkeys(s for s, _ in hits):
        ours = compile_source(ctx, src)
        for _, va in (h for h in hits if h[0] == src):
            row = ctx.row(va)
            retail = ctx.retail(row)
            proc = procs.get(va - IMAGE_BASE)
            module = pdb.modules[proc.module] if proc else None
            retail_lines = pdb.line_table(module, va - IMAGE_BASE) if module else []
            try:
                symbol = find_symbol(ours, row, ctx.same_name)
                data, masks = coff.function_bytes(ours, symbol)
                status = compare(data, masks, retail)
                our_lines = object_lines(ours, symbol)
            except KeyError:
                data, status, our_lines = b'', 'todo', []
            print(f'{row["name"] or row["symbol"]} 0x{va:08X} ({src.relative_to(paths.ROOT)}): {status}, '
                  f'score {score(status, data, retail)}, {len(data)} bytes vs {len(retail)}')
            if module:
                named = pdb.proc_locals(module, va - IMAGE_BASE)
                if named:
                    print('retail locals: ' + ', '.join(f'{n} {r}' + (f'{o:+d}' if o is not None else '') for n, r, o in named))
            for line in line_report(data, our_lines, retail, retail_lines, source_text):
                print(line)
            print()


def compile_source(ctx, src):
    """Our object for a source file, parsed."""
    obj_name, _ = parse_markers(src)
    cmd = ctx.cmd(obj_name, f'{src}: ')
    obj = paths.BUILD / 'obj' / src.relative_to(paths.ROOT).with_suffix('.obj')
    obj.parent.mkdir(parents=True, exist_ok=True)
    r = compile_file(ctx.cl, cmd, ctx.includes, src, obj)
    if r.returncode:
        print(r.stdout + r.stderr)
        raise SystemExit(f'{src}: cl failed')
    return coff.parse(obj.read_bytes())


def check_file(ctx, src):
    """{va: (row, status, score, note)} of a source file's marked functions."""
    _, addresses = parse_markers(src)
    ours = compile_source(ctx, src)
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
    ap.add_argument('--lines', nargs='+', metavar='NAME',
                    help='compare marked functions (0x address, full name or last ::part) with retail statement '
                         'by statement, using the PDB\'s line table and ours; searches every file under src/ '
                         'unless source files are named')
    args = ap.parse_args(argv)
    if args.lines:
        sources = args.sources + [n for n in args.lines if n.endswith('.cpp')]
        show_lines(Context(), [n for n in args.lines if not n.endswith('.cpp')], sources or all_sources())
        return 0
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
