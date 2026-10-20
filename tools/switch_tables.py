"""Finds the jump tables behind `bctr` instructions and writes
recomp/switch_tables.toml, in the [[switch_tables]] form the ReXGlue codegen
config reads (it replaces XenonAnalyse, which misses this compiler's order).

    python tools/switch_tables.py [--survey]

A table is `mtctr rX; bctr`, where rX comes from `lwzx rX, rBase, rOff`,
rBase is a constant (`lis` + `addi`/`ori`), rOff is `slwi rOff, rI, 2`, and
`cmplwi crN, rI, K; bgt crN, default` bounds rI. The compiler schedules these
in any order (XenonAnalyse expects lis; addi; rlwinm; lwzx; this one mostly
emits lis; slwi; addi; lwzx). The entry count is K + 1, and every label must
lie inside the function. Anything else is a pointer call or tail call.
"""
import argparse
import struct
import sys
from collections import Counter
from dataclasses import dataclass

import inventory
import paths

BASE = 0x82000000
BCTR = 0x4E800420
WINDOW = 512  # instructions to look back from a bctr

# X-form (opcode 31) extended opcodes whose target is rA, not rD
_XO_WRITES_RA = {28, 60, 124, 284, 316, 412, 444, 476, 24, 536, 792, 824, 26, 954, 922, 986, 27, 539, 794, 58}
# ... and those that write no GPR: mtspr, mtcrf, stores, compares, cache ops
_XO_WRITES_NONE = {467, 144, 151, 183, 215, 247, 407, 439, 150, 662, 918, 0, 32, 86, 54, 278, 246, 1014, 470, 982}
_LOADS_D = {32, 33, 34, 35, 40, 41, 42, 43, 58}  # lwz lwzu lbz lbzu lhz lhzu lha lhau ld
_LOADS_X = {23, 55, 87, 119, 279, 311, 343, 375, 21, 53}  # lwzx lwzux lbzx lbzux lhzx lhzux lhax lhaux ldx ldux


@dataclass
class Switch:
    base: int      # VA of the bctr
    r: int         # index register
    default: int   # VA taken when the index is out of range
    labels: list   # VA of each case


def _fields(w):
    return w >> 26, (w >> 21) & 31, (w >> 16) & 31, (w >> 11) & 31, (w >> 1) & 0x3FF


def _simm(w):
    """The low 16 bits of `w`, sign-extended."""
    v = w & 0xFFFF
    return v - 0x10000 if v & 0x8000 else v


def _writes(w):
    """The GPR an instruction writes, or None (only the forms that matter here)."""
    op, d, a, _b, xo = _fields(w)
    if op in (14, 15, 7, 8, 12, 13) or op in _LOADS_D:
        return d
    if op in (20, 21, 23, 24, 25, 26, 27, 28, 29, 30):
        return a
    if op == 31:
        if xo in _XO_WRITES_RA:
            return a
        return None if xo in _XO_WRITES_NONE else d
    return None


class _Code:
    def __init__(self, image, lo, hi):
        self.image, self.lo, self.hi = image, lo, hi

    def word(self, va):
        return struct.unpack_from('>I', self.image, va - BASE)[0]

    def defn(self, reg, before, stop):
        """(VA, word) of the last write of `reg` before `before`, not below `stop`."""
        p = before - 4
        while p >= stop:
            w = self.word(p)
            if _writes(w) == reg:
                return p, w
            p -= 4
        return None, None


def _const(code, reg, before, stop):
    """The constant `reg` holds at `before` (lis followed by addi/ori), or None."""
    p, w = code.defn(reg, before, stop)
    if w is None:
        return None
    op, d, a, _b, _xo = _fields(w)
    imm = w & 0xFFFF
    if op == 15 and a == 0:
        return (imm << 16) & 0xFFFFFFFF
    if op == 14 and a != 0:
        hi = _const(code, a, p, stop)
        return None if hi is None else (hi + _simm(w)) & 0xFFFFFFFF
    if op == 24:  # ori rA, rS, imm
        hi = _const(code, d, p, stop)
        return None if hi is None else hi | imm
    return None


def _scaled_index(code, reg, before, stop):
    """rI when `reg` = rI << 2 (slwi / rlwinm rA, rI, 2, 0, 29), else None."""
    p, w = code.defn(reg, before, stop)
    if w is None or w >> 26 != 21:
        return None, None
    rs, sh, mb, me = (w >> 21) & 31, (w >> 11) & 31, (w >> 6) & 31, (w >> 1) & 31
    if sh == 2 and mb == 0 and me == 29:
        return rs, p
    return None, None


def _copy_of(code, reg, before, stop):
    """rS when `reg` was last set by `mr reg, rS` before `before`."""
    _p, w = code.defn(reg, before, stop)
    if w is not None and w >> 26 == 31 and (w >> 1) & 0x3FF == 444 and (w >> 21) & 31 == (w >> 11) & 31:
        return (w >> 21) & 31
    return None


def _bound(code, reg, before, stop):
    """(lowest, highest index, default VA or 0) for `reg`: from `cmplwi crN,
    reg, K` with `bgt crN, D` (or `bgtlr crN`: default 0, a return), or from a
    `clrlwi` mask, through `mr` copies and `addi` offsets."""
    p = before - 4
    bgt = None
    offset = 0
    while p >= stop:
        w = code.word(p)
        op, rs, ra, rb, xo = _fields(w)
        if bgt is None and (w >> 21) & 31 == 12 and (w >> 16) & 3 == 1 and (op == 16 or (op == 19 and xo == 16)):
            target = p + _simm(w & 0xFFFC) if op == 16 else 0
            bgt = ((w >> 18) & 7, target)
        elif op == 10 and bgt and (w >> 23) & 7 == bgt[0] and (  # cmplwi or cmpldi
                ra == reg or _copy_of(code, reg, p, stop) == ra):
            return offset, (w & 0xFFFF) + offset, bgt[1]
        elif _writes(w) == reg:
            if op == 31 and xo == 444 and rs == rb:      # mr
                reg = rs
            elif op == 14 and ra:                         # addi reg, rA, k
                offset += _simm(w)
                reg = ra
            elif op == 21 and rb == 0 and (w >> 1) & 31 == 31 and bgt is None:  # clrlwi
                return offset, (1 << (32 - ((w >> 6) & 31))) - 1 + offset, 0
            else:
                return None
        p -= 4
    return None


def classify(code, bctr):
    """('table', Switch), ('pointer', None), or ('unexplained' or 'rejected', reason)."""
    stop = max(code.lo, bctr - 4 * WINDOW)
    p = bctr - 4
    while p >= stop:
        w = code.word(p)
        if w >> 26 == 31 and (w >> 1) & 0x3FF == 467 and ((w >> 16) & 31) | (((w >> 11) & 31) << 5) == 9:
            break
        p -= 4
    else:
        return 'unexplained', 'no mtctr'
    src = (code.word(p) >> 21) & 31
    lp, lw = code.defn(src, p, stop)
    if lw is None or lw >> 26 != 31 or (lw >> 1) & 0x3FF not in _LOADS_X:
        return 'pointer', None  # loaded from memory, an argument, or computed
    op, _d, ra, rb, xo = _fields(lw)
    if xo != 23:
        return 'unexplained', f'indexed load xo {xo}'
    for base_reg, off_reg in ((ra, rb), (rb, ra)):
        table = _const(code, base_reg, lp, stop) if base_reg else None
        if table is None:
            continue
        idx, sp = _scaled_index(code, off_reg, lp, stop)
        if idx is None:
            continue
        b = _bound(code, idx, sp, stop)
        if not b:
            return 'unexplained', 'no bounds check'
        lo, hi, default = b
        off = table - BASE
        if lo < 0 or hi > 0xFFFF or not 0 <= off <= len(code.image) - 4 * (hi + 1):
            return 'unexplained', 'index range or table outside the image'
        labels = list(struct.unpack_from(f'>{hi + 1}I', code.image, off))
        labels[:lo] = [labels[lo]] * lo  # indices below the range never occur
        if not all(code.lo <= v < code.hi and v % 4 == 0 for v in labels + ([default] if default else [])):
            return 'rejected', 'label outside the function'
        return 'table', Switch(bctr, idx, default, labels)
    return 'pointer', None  # an array of function pointers at a computed address


def _bctrs(image, funcs):
    """(function VA, its code, VA) of every bctr in `funcs`."""
    for va, size in funcs:
        code = _Code(image, va, va + size)
        for p in range(code.lo, code.hi, 4):
            if code.word(p) == BCTR:
                yield va, code, p


def find(image, funcs):
    """Every jump table in `funcs` ((VA, size) pairs) of the image at BASE."""
    out = []
    for _va, code, p in _bctrs(image, funcs):
        kind, s = classify(code, p)
        if kind == 'table':
            out.append(s)
    return out


def survey(image, funcs, verbose=False):
    counts = Counter()
    for va, code, p in _bctrs(image, funcs):
        kind, why = classify(code, p)
        counts[kind] += 1
        if verbose and kind in ('unexplained', 'rejected'):
            print(f'{kind} 0x{p:08X} in 0x{va:08X}: {why}')
    return counts


def functions():
    rows = inventory.read_functions()
    return sorted({(int(r['address'], 16), int(r['size'])) for r in rows if int(r['size'])})


def render(switches):
    lines = ['# Generated by tools/switch_tables.py from the basefile and config/functions/.', '']
    for s in switches:
        lines += ['[[switch_tables]]', f'address = 0x{s.base:08X}', f'register = {s.r}',
                  f'# default = 0x{s.default:08X}',
                  'labels = [' + ', '.join(f'0x{v:08X}' for v in s.labels) + ']', '']
    return '\n'.join(lines)


def main(argv=None):
    ap = argparse.ArgumentParser(description='Find jump tables; write recomp/switch_tables.toml.')
    ap.add_argument('--survey', action='store_true', help='classify every bctr and print the counts')
    args = ap.parse_args(argv)
    image = paths.require(paths.basefile()).read_bytes()
    funcs = functions()
    if args.survey:
        print(dict(survey(image, funcs, verbose=True)))
        return
    found = find(image, funcs)
    out = paths.ROOT / 'recomp' / 'switch_tables.toml'
    out.write_text(render(found), encoding='utf-8', newline='\n')
    print(f'wrote {out}: {len(found)} tables')


if __name__ == '__main__':
    sys.exit(main())
