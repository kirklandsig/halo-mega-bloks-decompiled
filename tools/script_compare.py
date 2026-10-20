"""Compares the exported script classes (build/script/<Package>/*.uc, from
tools/script_export) with a UDK build's Development/Src/*/Classes/*.uc, and
refines the owner column of config/functions.csv from the result.

    python tools/script_compare.py --udk %USERPROFILE%\\haggar-tools\\udk\\<build>

Each class is identical, modified or nspace-only (no UDK class of that
name). The comparison is structural, because a decompiled class never reads
like its source: comments, cpptext and default properties are ignored, and
two classes are identical when they have the same parent, the same members
(variables, functions, states, structs, enums, constants) and, function by
function, the same set of identifiers in the body.

Writes config/script_classes.csv (package,class,status,udk_file). A game-tier
function of a native class whose script class is identical or modified is
owned by epic; one whose script class is nspace-only by nspace.
"""
import argparse
import csv
import re
from dataclasses import dataclass, field
from pathlib import Path

import inventory
import paths

TOKEN = re.compile(r'"(?:\\.|[^"\\])*"|\'[^\'\n]*\'|/\*.*?\*/|//[^\n]*|[A-Za-z_][A-Za-z0-9_]*|\d+(?:\.\d*)?[fF]?|\S',
                   re.S)
SKIPPED_BLOCKS = {'cpptext', 'structcpptext', 'defaultproperties', 'structdefaultproperties', 'replication'}
FUNCTION_WORDS = {'function', 'event', 'delegate', 'operator', 'preoperator', 'postoperator'}
KEYWORDS = {'local', 'if', 'else', 'return', 'for', 'foreach', 'while', 'do', 'until', 'switch', 'case', 'default',
            'break', 'continue', 'none', 'self', 'true', 'false', 'super', 'new', 'goto', 'stop', 'assert', 'returnvalue',
            'static', 'property', 'outer', 'complementequal', 'editinline', 'boolproperty',
            # conversions the decompiler spells out
            'int', 'float', 'byte', 'string', 'name', 'bool',
            # what the source macros (`log, `location, `if(`notdefined(...))) bring in
            'getfuncname', 'getstatename', 'nameof', 'final_release', 'notdefined', 'isdefined'}
# operators without a native token keep their internal names (NotEqual_InterfaceInterface)
OPERATOR_NAMES = re.compile(r'^(not|equalequal|notequal|andand|xorxor|oror|multiplyequal|divideequal|addequal|'
                            r'subtractequal|addadd|subtractsubtract|complement|complementequal|subtract|add|multiply|'
                            r'divide|percent|less|greater|lessequal|greaterequal|equaltilde|concat|at)_|^j0x[0-9a-f]+$')
COLUMNS = ['package', 'class', 'status', 'udk_file']


@dataclass
class Script:
    parent: str = ''
    vars: set = field(default_factory=set)
    members: set = field(default_factory=set)  # states, structs, enums, constants
    functions: dict = field(default_factory=dict)  # [state.]name -> identifiers in the body
    constants: set = field(default_factory=set)  # names of constants and enum values, which decompile to numbers


# Source-only spellings: `log and `warn are macros for LogInternal and WarnInternal.
ALIASES = {'loginternal': 'log', 'warninternal': 'warn'}


def tokens(text):
    """Tokens without comments. In source, other `macros are dropped; in
    decompiled code, super(Class) is reduced to super."""
    out = []
    raw = [t for t in TOKEN.findall(text) if not t.startswith(('//', '/*'))]
    i = 0
    while i < len(raw):
        t = raw[i]
        if t == '`':
            if i + 1 < len(raw) and raw[i + 1].lower() in ('log', 'warn'):
                out.append(raw[i + 1])
            i += 2
            continue
        if t.lower() == 'super' and i + 3 < len(raw) and raw[i + 1] == '(' and raw[i + 3] == ')':
            out.append(t)
            i += 4
            continue
        out.append(t)
        i += 1
    return out


def _skip_block(toks, i):
    """Index after the {...} block that starts at or after i."""
    while i < len(toks) and toks[i] != '{':
        i += 1
    depth = 0
    for j in range(i, len(toks)):
        depth += {'{': 1, '}': -1}.get(toks[j], 0)
        if depth == 0:
            return j + 1
    return len(toks)


def _fingerprint(body):
    return frozenset(ALIASES.get(t.lower(), t.lower()) for t in body
                     if (t[0].isalpha() or t[0] == '_') and t.lower() not in KEYWORDS
                     and not OPERATOR_NAMES.match(t.lower()))


def parse(text):
    toks = tokens(text)
    s = Script()
    state = ''
    depth = 0
    i = 0
    while i < len(toks):
        t, low = toks[i], toks[i].lower()
        if low in SKIPPED_BLOCKS:
            i = _skip_block(toks, i)
            continue
        if low == 'class' and depth == 0 and not s.parent and i + 3 < len(toks) and toks[i + 2].lower() == 'extends':
            s.parent = toks[i + 3].lower()
            i += 4
            continue
        if low == 'var' and depth == 0:
            j = i + 1
            group = []
            while j < len(toks) and toks[j] != ';':
                if toks[j] == '(':
                    j = toks.index(')', j)
                elif toks[j] == '[':
                    j = toks.index(']', j)
                elif toks[j].lower() in ('enum', 'struct') and '{' in toks[j:j + 4]:
                    s.members.add(f'{toks[j].lower()}:{toks[j + 1].lower()}')
                    end = _skip_block(toks, j)
                    if toks[j].lower() == 'enum':
                        s.constants.update(x.lower() for x in toks[j + 2:end] if x[0].isalpha() or x[0] == '_')
                    j = end - 1
                elif toks[j] == '{':  # native type: pointer Name{FType}
                    j = _skip_block(toks, j) - 1
                elif toks[j] == '<' and not (group and group[-1].lower() in ('array', 'class')):
                    j = toks.index('>', j)  # metadata: <UIMin=0|UIMax=1>
                elif toks[j] == ',':
                    if group and 'editoronly' not in (x.lower() for x in toks[i:j]):
                        s.vars.add(group[-1].lower())
                    group = []
                elif toks[j][0].isalpha() or toks[j][0] == '_':
                    group.append(toks[j])
                j += 1
            # editoronly variables are not cooked into console packages
            if group and 'editoronly' not in (x.lower() for x in toks[i:j]):
                s.vars.add(group[-1].lower())
            i = j + 1
            continue
        if low in ('struct', 'enum') and i + 1 < len(toks):
            j = i + 1
            while j < len(toks) and toks[j] != '{' and toks[j] != ';':
                j += 1
            name = [x for x in toks[i + 1:j] if x[0].isalpha() and x.lower() not in ('native', 'immutable', 'transient')]
            s.members.add(f'{low}:{(name[-1] if name else "").lower()}')
            end = _skip_block(toks, i)
            if low == 'enum':
                s.constants.update(x.lower() for x in toks[j + 1:end] if x[0].isalpha() or x[0] == '_')
            i = end
            continue
        if low == 'const' and depth == 0 and toks[i + 2:i + 3] == ['=']:
            s.members.add(f'const:{toks[i + 1].lower()}')
            s.constants.add(toks[i + 1].lower())
        if low == 'state' and depth == 0:
            j = i + 1
            while j < len(toks) and toks[j] != '{':
                j += 1
            name = [x for x in toks[i + 1:j] if x[0].isalpha() and x.lower() != 'extends']
            if name:
                state = name[0].lower()
                s.members.add(f'state:{state}')
                depth = 1
                i = j + 1
                continue
        if low in FUNCTION_WORDS and '(' in toks[i:i + 12]:
            j = toks.index('(', i)
            name = toks[j - 1].lower()
            k = j
            parens = 0
            while k < len(toks):
                parens += {'(': 1, ')': -1}.get(toks[k], 0)
                k += 1
                if parens == 0:
                    break
            while k < len(toks) and toks[k] not in ('{', ';'):
                k += 1
            key = f'{state}.{name}' if state else name
            if k < len(toks) and toks[k] == '{':
                end = _skip_block(toks, k)
                s.functions[key] = _fingerprint(toks[k + 1:end - 1])
                i = end
            else:
                s.functions[key] = frozenset()
                i = k + 1
            continue
        if t == '{':
            depth += 1
        elif t == '}':
            depth -= 1
            if state and depth == 0:
                state = ''
        i += 1
    return s


def compare(ours, udk, constants=frozenset()):
    """identical or modified; `constants` (all known constant and enum value
    names) are left out of the bodies, as the decompiler shows their values."""
    if ours.parent != udk.parent or ours.vars != udk.vars or ours.members != udk.members:
        return 'modified'
    if set(ours.functions) != set(udk.functions):
        return 'modified'
    same = all(ours.functions[k] - constants == udk.functions[k] - constants for k in ours.functions)
    return 'identical' if same else 'modified'


def udk_classes(udk_root):
    """Lowercase class name -> path of its .uc, relative to the UDK folder."""
    out = {}
    for path in sorted(Path(udk_root).glob('Development/Src/*/Classes/*.uc')):
        out.setdefault(path.stem.lower(), path)
    return out


def classify(script_dir, udk_root):
    udk = {name: (path, parse(path.read_text(encoding='latin-1'))) for name, path in udk_classes(udk_root).items()}
    ours = {uc: parse(uc.read_text(encoding='utf-8', errors='replace'))
            for package in Path(script_dir).iterdir() if package.is_dir() for uc in package.glob('*.uc')}
    constants = frozenset().union(*(s.constants for _, s in udk.values()), *(s.constants for s in ours.values()))
    rows = []
    for uc in sorted(ours, key=lambda p: (p.parent.name, p.stem.lower())):
        theirs = udk.get(uc.stem.lower())
        if theirs is None:
            status, rel = 'nspace-only', ''
        else:
            status = compare(ours[uc], theirs[1], constants)
            rel = theirs[0].relative_to(udk_root).as_posix()
        rows.append({'package': uc.parent.name, 'class': uc.stem, 'status': status, 'udk_file': rel})
    return rows


# Classes of the middleware n-Space's AI is built on (Gameware Cognition, Grip,
# Navigation): their compiler-generated functions have no source line.
VENDOR_CLASS = re.compile(r'^(?:[IFAU]?(?:CCS|Grip|GwNav)|Kaim::)')


def nspace_additions():
    """(class, function) pairs n-Space added to Epic's native classes
    (config/nspace_additions.csv; see docs/specs/2026-10-18-design.md)."""
    path = paths.CONFIG / 'nspace_additions.csv'
    return {(r['class'], r['function']) for r in inventory.read_csv(path)} if path.exists() else set()


def refine_owner(rows, status):
    """Set the owner of game-tier functions from their source (inventory.owner),
    then by class: n-Space's additions to Epic classes and the classes of
    n-Space's own script are nspace, the rest of the classes of identical or
    modified script Epic's (unless middleware), the middleware's classes vendor."""
    additions = nspace_additions()
    for r in rows:
        if r['tier'] != 'game':
            continue
        r['owner'] = inventory.owner(r['tier'], r['package'], r['source'])
        if '::' not in r['name']:
            continue
        cls_name, function = r['name'].split('::', 1)
        if (cls_name, function) in additions:
            r['owner'] = 'nspace'
            continue
        cls = cls_name.lower()
        cls = cls[1:] if cls[:1] in ('a', 'u') and cls[1:] in status else cls
        st = status.get(cls)
        if st == 'nspace-only':
            r['owner'] = 'nspace'
        elif st in ('identical', 'modified') and r['owner'] != 'vendor':
            r['owner'] = 'epic'
        elif r['owner'] == 'epic' and VENDOR_CLASS.match(r['name']):
            r['owner'] = 'vendor'


def main(argv=None):
    ap = argparse.ArgumentParser(description='Compare exported script classes with UDK and refine owners.')
    ap.add_argument('--udk', help='a UDK build folder holding Development/Src')
    ap.add_argument('--script', default=str(paths.BUILD / 'script'))
    ap.add_argument('--owners', action='store_true', help='only refine the owners, from config/script_classes.csv')
    args = ap.parse_args(argv)
    if args.owners:
        rows = inventory.read_csv(paths.CONFIG / 'script_classes.csv')
    else:
        if not args.udk:
            ap.error('--udk is required unless --owners')
        paths.require(Path(args.udk) / 'Development' / 'Src')
        rows = classify(paths.require(Path(args.script)), Path(args.udk))
        inventory.write_csv(paths.CONFIG / 'script_classes.csv', COLUMNS, rows)
    counts = {}
    for r in rows:
        counts.setdefault(r['package'], {}).setdefault(r['status'], 0)
        counts[r['package']][r['status']] += 1
    for package, c in counts.items():
        print(f'{package:20} ' + '  '.join(f'{k} {v}' for k, v in sorted(c.items())))
    status = {}
    for r in rows:
        status.setdefault(r['class'].lower(), r['status'])
    functions_csv = paths.CONFIG / 'functions.csv'
    functions = inventory.read_csv(functions_csv)
    refine_owner(functions, status)
    inventory.write_csv(functions_csv, inventory.FUNCTION_COLUMNS, functions)
    owners = {}
    for r in functions:
        if r['tier'] == 'game':
            owners[(r['package'], r['owner'])] = owners.get((r['package'], r['owner']), 0) + 1
    print('game-tier owners: ' + ', '.join(f'{p} {o} {n}' for (p, o), n in sorted(owners.items())))


if __name__ == '__main__':
    main()
