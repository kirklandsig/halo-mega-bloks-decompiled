"""Compile the committed UnrealScript with UDK's own compiler.

    python tools/udk_compile.py --udk <UDK July 2012 BETA 2 install> [--nspace-only] [--fix]

UDK July 2012 BETA 2 has the game's engine version (10246), so its compiler
(`UDK.com make`) can check the decompiled scripts. Each run:

1. copies the install into a fresh work tree (default build/udk/; about
   130 MB, nothing in it is ever committed);
2. lays the committed classes from script/<Package>/Classes/ over it: the
   n-Space packages are new, and the modified Epic classes replace UDK's
   (--nspace-only skips the modified ones);
3. adds the n-Space packages to the EditPackages lists;
4. runs `UDK.com make -full -unattended` and reads its log.

It prints each package's result and every error, and exits 1 if any package
failed. The compiler stops at the first package with errors. --fix applies
the known fixes for decompiler artifacts (FIXES) to script/ where the compiler
reports them, and compiles again until none applies. UDK_DIR can stand in for
--udk.
"""
import argparse
import csv
import functools
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import paths  # noqa: E402

UDK_SOURCE = None  # the install's Development/Src, set by main()

# Where each n-Space package goes in the compile order: before UDKBase, which
# uses them, and MegaHaloGame after UTGame. OnlineSubsystemLive is in UDK's
# base list already. (file, anchor line, packages, before the anchor?)
CONFIG_EDITS = [
    ('DefaultEngineUDK.ini', '+EditPackages=UDKBase', ['AkAudio', 'Grip', 'GwNavEngine', 'Cognition'], True),
    ('DefaultEngine.ini', '+EditPackages=UTGameContent', ['MegaHaloGame'], False),
]
# Edits made to the work tree only, never to script/: what stock UDK can't
# take from n-Space's classes because its own native classes are compiled into
# UDK.exe. n-Space added members to native Epic classes (Actor, Pawn, ...), so
# the script layout no longer matches UDK's C++ one; the default for Actor's
# Role is checked against that native layout.
SHIMS = {
    ('Engine', 'Actor'): [(r'^var const Actor Next_(?:Actor|Reactive|Vehicle|Target_Actor);\s*$\n?', '')],
}
PACKAGE_HEADING = re.compile(r'Heading: -+(\w+) - Release-+')
DIAGNOSTIC = re.compile(r'^\[[\d.]+\] (Error|Warning): (?:(.*?)\((\d+)\) : )?(?:Error|Warning), (.*)$')


def committed_classes(nspace_only):
    """(package, class file) for each committed class to lay over UDK."""
    status = {(r['package'], r['class']): r['status'] for r in csv.DictReader(open(paths.CONFIG / 'script_classes.csv'))}
    for path in sorted((paths.ROOT / 'script').glob('*/Classes/*.uc')):
        package = path.parent.parent.name
        if nspace_only and status.get((package, path.stem)) == 'modified':
            continue
        yield package, path


def _remove_tree(path):
    # a just-exited UDK.com, or a virus scanner, can hold a DLL for a moment
    for attempt in range(10):
        try:
            shutil.rmtree(path)
            return
        except FileNotFoundError:
            return
        except PermissionError:
            if attempt == 9:
                raise
            time.sleep(2)


def _class_var_names(text):
    """Names of a class's own variables, in declaration order (top level only)."""
    text = re.sub(r'/\*.*?\*/|//[^\n]*|<[^<>\n]*>', '', text, flags=re.S)
    names, depth, i = [], 0, 0
    for m in re.finditer(r'[{};]|\bvar\b', text):
        token = m.group(0)
        if token == '{':
            depth += 1
        elif token == '}':
            depth -= 1
        elif token == 'var' and depth == 0 and m.start() >= i:
            end = text.find(';', m.end())
            decl = text[m.end():end]
            decl = re.sub(r'\{[^{}]*\}', ' ', decl)  # an enum or struct declared in place
            decl = re.sub(r'^\s*\([^)]*\)', '', decl)
            for part in decl.split(','):
                words = re.findall(r'\w+', re.sub(r'\[.*?\]', '', part))
                if words:
                    names.append(words[-1].lower())
            i = end + 1
    return names


def udk_layout(text, udk_text):
    """The class with its top-level single-line var declarations in UDK's order
    (n-Space's own after them): stock UDK checks a native class's defaults
    against the layout compiled into UDK.exe."""
    order = {name: i for i, name in enumerate(_class_var_names(udk_text))}
    newline = '\r\n' if '\r\n' in text else '\n'
    lines = text.split(newline)
    slots = [i for i, line in enumerate(lines) if re.match(r'var\b[^;{]*;\s*$', line)]
    if not slots:
        return text
    # console cooking strips editoronly variables, which PC UDK's layout has
    ours = set(_class_var_names(text))
    for decl in re.findall(r'^var\b[^;{\n]*\beditoronly\b[^;{\n]*;', re.sub(r'\s*<[^<>\n]*>\s*;', ';', udk_text), re.M):
        if _class_var_names(decl)[0] not in ours:
            lines.insert(slots[-1] + 1, decl)
            slots.append(slots[-1] + 1)

    def key(line):
        words = re.findall(r'\w+', re.sub(r'<[^>]*>|\[.*?\]', '', line.split(';')[0]))
        return order.get(words[-1].lower(), len(order)) if words else len(order)
    ordered = sorted((lines[i] for i in slots), key=key)  # stable: n-Space's keep their order
    for i, line in zip(slots, ordered):
        if key(line) < len(order):
            lines[i] = line
            continue
        # n-Space's own members of a native class have no room in UDK.exe's layout
        lines[i] = f'// udk_compile: n-Space member left out: {line}'
        words = re.findall(r'[\w<>]+', re.sub(r'\[.*?\]', '', line.split(';')[0]))
        STUBBED[words[-1].lower()] = words[-2].lower() if len(words) >= 3 else ''
    return newline.join(lines)


# n-Space members left out of native classes in the work tree: name -> type.
STUBBED = {}
STUB_VALUES = {'bool': 'false', 'int': '0', 'float': '0.0', 'byte': '0', 'name': "''", 'string': '""'}


def stub_uses(work, errors):
    """Where the compiler reports a use of a member left out of a native class,
    write its type's default value instead (or drop an assignment to it), in the
    work tree only, so the rest of the code still gets compiled. The number of
    lines changed."""
    changed = 0
    for file, number, message in errors:
        path = work / file if file else None
        if path is None or not path.exists():
            continue
        text = path.read_bytes().decode('utf-8', errors='replace')
        newline = '\r\n' if '\r\n' in text else '\n'
        lines = text.split(newline)
        if not 0 < number <= len(lines):
            continue
        line = lines[number - 1]
        names = [n for n in re.findall(r'\b\w+\b', line) if n.lower() in STUBBED]
        if not names:
            continue
        alternatives = '|'.join(names)
        assigned = re.match(rf'\s*(?:\+\+|--)?\s*(?:[\w.\[\]()]*\.)?(?:{alternatives})\s*(?:=(?!=)|\+=|-=|\*=|/=|\+\+|--|;)', line, re.I)
        if assigned or re.search(r'\barray<', STUBBED[names[0].lower()]):
            new = '// udk_compile: ' + line
        else:
            new = line
            for name in names:
                kind = STUBBED[name.lower()]
                value = STUB_VALUES.get(kind) or ('0' if kind in source_index()[0] else 'none')
                new = re.sub(rf'(?:\b[\w]+(?:\(\))?\.)*\b{name}\b', value, new)
            new = new.replace('none != none', 'false').replace('none == none', 'true')
        if new != line:
            lines[number - 1] = new
            path.write_bytes(newline.join(lines).encode('utf-8'))
            changed += 1
    return changed


# Script packages with C++ classes compiled into UDK.exe.
NATIVE_PACKAGES = {'Core', 'Engine', 'GameFramework', 'GFxUI', 'IpDrv', 'UDKBase'}


def prepare(udk, work, nspace_only):
    _remove_tree(work)
    STUBBED.clear()
    for part in ('Binaries', 'Development', 'Engine', 'UDKGame'):
        shutil.copytree(udk / part, work / part, ignore=shutil.ignore_patterns('*.log', '*.u'))
    config = work / 'UDKGame' / 'Config'
    for generated in config.glob('UDK*.ini'):
        generated.unlink()  # regenerated from the Default*.ini files
    for name, anchor, packages, before in CONFIG_EDITS:
        ini = config / name
        text = ini.read_text(encoding='utf-8-sig').replace('\r\n', '\n')
        lines = ''.join(f'+EditPackages={p}\n' for p in packages)
        if anchor + '\n' not in text:
            raise SystemExit(f'{ini}: no "{anchor}" line to place the n-Space packages by')
        text = text.replace(anchor + '\n', lines + anchor + '\n' if before else anchor + '\n' + lines, 1)
        ini.write_text(text, encoding='utf-8')
    udk_files = {(r['package'], r['class']): r['udk_file'] for r in csv.DictReader(open(paths.CONFIG / 'script_classes.csv'))
                 if r['status'] == 'modified' and r['udk_file']}
    count = 0
    for package, path in committed_classes(nspace_only):
        target = work / 'Development' / 'Src' / package / 'Classes'
        target.mkdir(parents=True, exist_ok=True)
        text = path.read_bytes().decode('utf-8')
        for pattern, replacement in SHIMS.get((package, path.stem), []):
            text = re.sub(pattern, replacement, text, flags=re.M)
        if (package, path.stem) in udk_files and package in NATIVE_PACKAGES:
            text = udk_layout(text, (udk / udk_files[package, path.stem]).read_text(encoding='utf-8', errors='replace'))
        (target / path.name).write_bytes(text.encode('utf-8'))
        count += 1
    return count


def run(work):
    exe = work / 'Binaries' / 'Win32' / 'UDK.com'
    subprocess.run([str(exe), 'make', '-full', '-unattended', '-nopause', '-silent'], cwd=exe.parent,
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return parse_log((work / 'UDKGame' / 'Logs' / 'Launch.log').read_text(encoding='utf-8', errors='replace'), work)


def parse_log(text, work=None):
    """{'packages': [(name, ok)], 'errors': [...], 'warnings': [...]} from a make log.
    Diagnostics are (file relative to the work tree or '', line or 0, message)."""
    packages, errors, warnings = [], [], []
    seen = set()
    for line in text.splitlines():
        heading = PACKAGE_HEADING.search(line)
        if heading:
            packages.append([heading.group(1), True])
            continue
        if 'Compile aborted due to errors' in line and packages:
            packages[-1][1] = False
        if 'Critical error' in line:
            # UDK.exe itself failed, with no file to blame (see SHIMS)
            errors.append(('', 0, f'UDK crashed while compiling {packages[-1][0] if packages else "the scripts"}'))
            if packages:
                packages[-1][1] = False
        diag = DIAGNOSTIC.match(line)
        if diag:
            kind, file, number, message = diag.groups()
            file, number = file or '', int(number or 0)
            if kind == 'Error' and packages:
                packages[-1][1] = False
            if work is not None and file:
                try:
                    file = Path(file).resolve().relative_to(work.resolve()).as_posix()
                except ValueError:
                    pass
            key = (kind, file, number, message)
            if key not in seen:
                seen.add(key)
                (errors if kind == 'Error' else warnings).append((file, number, message.strip()))
    return {'packages': [tuple(p) for p in packages], 'errors': errors, 'warnings': warnings}


LITERAL = r"""(?:-?\d+(?:\.\d+)?|'[^']*'|"(?:\\.|[^"\\])*"|true|false|none)"""
CAST_NAMES = {'Int': 'int', 'Float': 'float', 'Byte': 'byte', 'Str': 'string', 'Name': 'name', 'Bool': 'bool'}


def _on_line(edit):
    """A fix that rewrites only the reported line."""
    def fix(lines, number, m):
        if 0 < number <= len(lines):
            lines[number - 1] = edit(lines[number - 1], m)
    return fix


def add_dependson(lines, other):
    """Cooking drops dependson(): add `other` to the class's dependson list."""
    start = next((i for i, line in enumerate(lines) if re.match(r'\s*(class|interface)\s+\w+', line, re.I)), None)
    if start is None:
        return
    for j in range(start, len(lines)):
        dep = re.search(r'dependson\(([^)]*)\)', lines[j], re.I)
        if dep:
            names = [n.strip() for n in dep.group(1).split(',')]
            if other.lower() not in (n.lower() for n in names):
                lines[j] = lines[j][:dep.start(1)] + ', '.join(names + [other]) + lines[j][dep.end(1):]
            return
        if ';' in lines[j]:
            k = lines[j].index(';')
            lines[j:j + 1] = [lines[j][:k], f'\tdependson({other}){lines[j][k:]}']
            return


@functools.cache
def declaring_classes():
    """Struct and enum name -> the committed class that declares it."""
    found = {}
    for _, path in committed_classes(False):
        for m in re.finditer(r'^\s*(?:struct|enum)\s+(?:\w+\s+)*?(\w+)\s*(?:extends\s+\w+\s*)?$',
                             path.read_text(encoding='utf-8'), re.M):
            found.setdefault(m.group(1).lower(), path.stem)
    return found


def _depend_on_declarer(type_name, lines):
    declarer = declaring_classes().get(type_name.lower())
    if declarer:
        add_dependson(lines, declarer)


def _depend_on_return_type(lines, number, m):
    """`native function CCSTargetData GetCurrentTarget();` before CCSTarget is compiled."""
    if 0 < number <= len(lines):
        ret = re.search(r'\b(?:function|event)\s+(\w+)\s+\w+\s*\(', lines[number - 1])
        if ret:
            _depend_on_declarer(ret.group(1), lines)


def _drop_interface_abstract(lines, number, m):
    """Interfaces carry CLASS_Abstract, which the decompiler spells out; the compiler refuses it."""
    for j in range(len(lines)):
        if re.match(r'\s*abstract\s*$', lines[j]):
            del lines[j]
            return
        if re.match(r'\s*abstract\s*;', lines[j]):  # the last modifier: the ';' moves up
            del lines[j]
            lines[j - 1] += ';'
            return
        if ';' in lines[j]:
            return


def _state_function_for_ignore(lines, number, m):
    """An empty state function that overrides nothing decompiles as an ignores
    entry, which needs an existing function: write it back as a function, with
    UDK's declaration of it where the class has one."""
    name = m.group(1)
    if not 0 < number <= len(lines):
        return
    line = lines[number - 1]
    new = re.sub(rf'\b{name}\s*,\s*|,\s*{name}\b', '', line, count=1)
    if new == line:
        return
    lines[number - 1] = new
    end = next((j for j in range(number - 1, len(lines)) if ';' in lines[j]), None)
    if end is not None:
        lines[end + 1:end + 1] = ['', f'\t{UDK_STATE_FUNCTIONS.get(name.lower(), f"function {name}() {{}}")}']


# Empty state-only functions of UDK's classes that the decompiler turns into ignores entries.
UDK_STATE_FUNCTIONS = {'playnextanimation': 'simulated function PlayNextAnimation() {}'}


def _class_to_interface(lines, number, m):
    for j, line in enumerate(lines):
        if re.match(r'\s*class\s+\w+', line):
            lines[j] = line.replace('class', 'interface', 1)
            _drop_interface_abstract(lines, number, m)
            return


def _closing(text, start):
    """Index of the ')' that closes the '(' at text[start]."""
    depth = 0
    for i in range(start, len(text)):
        if text[i] == '(':
            depth += 1
        elif text[i] == ')':
            depth -= 1
            if depth == 0:
                return i
    return -1


def _uncast_comparisons(line):
    """int(A) == int(B) -> A == B. Bytecode compares bytes (and enums) as ints; in
    source the enum side takes its type from the other one, which a cast hides
    (`int(NM_Client)` alone is an unknown name), and replication conditions
    take no conversions at all."""
    out, i = [], 0
    pattern = re.compile(r'\bint\(')
    while True:
        m = pattern.search(line, i)
        if not m:
            break
        close = _closing(line, m.end() - 1)
        op = re.match(r'\s*(==|!=|<=|>=|<|>)\s*int\(', line[close + 1:]) if close > 0 else None
        if not op:
            out.append(line[i:m.end()])
            i = m.end()
            continue
        second = close + 1 + op.end() - 1
        close2 = _closing(line, second)
        if close2 < 0:
            out.append(line[i:m.end()])
            i = m.end()
            continue
        out.append(line[i:m.start()] + line[m.end():close] + f' {op.group(1)} ' + line[second + 1:close2])
        i = close2 + 1
    out.append(line[i:])
    return ''.join(out)


def _sources():
    """Every class source the compile sees: UDK's, with the committed ones in front."""
    files = {}
    if UDK_SOURCE is not None:
        for path in UDK_SOURCE.glob('*/Classes/*.uc'):
            files[path.stem.lower()] = path
    for _, path in committed_classes(False):
        files[path.stem.lower()] = path
    return files


@functools.cache
def source_index():
    """(enums: name -> [values], enum_of: value -> enum name, consts: (class, value) -> name,
    params: function name -> [parameter types])."""
    enums, enum_of, consts, params = {}, {}, {}, {}
    for stem, path in _sources().items():
        text = re.sub(r'/\*.*?\*/|//[^\n]*', '', path.read_text(encoding='utf-8', errors='replace'), flags=re.S)
        for m in re.finditer(r'\benum\s+(\w+)\s*\{([^}]*)\}', text):
            values = [v.strip() for v in m.group(2).split(',') if v.strip()]
            values = [re.sub(r'\s.*', '', v) for v in values]
            enums[m.group(1).lower()] = values
            for v in values:
                enum_of.setdefault(v.lower(), m.group(1).lower())
        for m in re.finditer(r'\bconst\s+(\w+)\s*=\s*(-?\d+)\s*;', text):
            consts.setdefault((stem, m.group(2)), m.group(1))
        for m in re.finditer(r'\b(?:function|event)\s+(?:\w+\s+)*?(\w+)\s*\(([^)]*)\)', text):
            types = []
            for param in m.group(2).split(','):
                words = [w for w in re.findall(r'[\w<>.]+', param)
                         if w.lower() not in ('optional', 'out', 'coerce', 'const', 'skip', 'init')]
                if len(words) >= 2:
                    types.append(words[-2].split('.')[-1].lower())
            params.setdefault(m.group(1).lower(), types)
    return enums, enum_of, consts, params


def _call_arguments(line, name):
    """(start, end, [argument texts]) of the first call of `name` on the line."""
    m = re.search(rf'\b{name}\s*\(', line)
    if not m:
        return None
    close = _closing(line, m.end() - 1)
    if close < 0:
        return None
    args, depth, start = [], 0, m.end()
    for i in range(m.end(), close):
        c = line[i]
        if c in '([':
            depth += 1
        elif c in ')]':
            depth -= 1
        elif c == ',' and depth == 0:
            args.append(line[start:i])
            start = i + 1
    args.append(line[start:close])
    return m.end(), close, args


def _retype_argument(lines, number, m):
    """Type mismatch in a call's Nth argument: an enum value the decompiler took
    from another enum with the same number (NM_ListenServer for
    TRAVEL_Relative), a byte() cast where the parameter is an enum, or a
    skipped optional argument counted twice (F(,, true) for F(, true))."""
    if not 0 < number <= len(lines):
        return
    name, index = m.group(1), int(m.group(2)) - 1
    line = lines[number - 1]
    call = _call_arguments(line, name)
    enums, enum_of, _, params = source_index()
    types = params.get(name.lower(), [])
    if call is None or index >= len(call[2]):
        return
    start, close, args = call
    arg = args[index].strip()
    wanted = types[index] if index < len(types) else None
    if wanted in enums and arg.lower() in enum_of:
        values = enums[enum_of[arg.lower()]]
        position = [v.lower() for v in values].index(arg.lower())
        if position < len(enums[wanted]):
            args[index] = args[index].replace(arg, enums[wanted][position])
    elif wanted in enums and re.fullmatch(r'byte\((.*)\)', arg):
        args[index] = args[index].replace(arg, f'{wanted_name(wanted)}({arg[5:-1]})')
    elif arg in ('true', 'false') and index > 0 and not args[index - 1].strip():
        del args[index - 1]
    else:
        return
    lines[number - 1] = line[:start] + ','.join(args) + line[close:]


def wanted_name(enum_lower):
    """An enum's name as declared."""
    for path in _sources().values():
        m = re.search(rf'\benum\s+({enum_lower})\b', path.read_text(encoding='utf-8', errors='replace'), re.I)
        if m:
            return m.group(1)
    return enum_lower


def _const_for_number(lines, number, m):
    """Controller.503 -> Controller.LATENT_MOVETOWARD: a constant printed as its value."""
    value, cls = m.group(1), m.group(2)
    name = source_index()[2].get((cls.lower(), value))
    if name and 0 < number <= len(lines):
        lines[number - 1] = re.sub(rf'\.{value}\b', f'.{name}', lines[number - 1])


def _negate_comparisons(line):
    """!A == B -> !(A == B): the decompiler drops the parentheses a negated
    comparison needs (A may be a call)."""
    out, i = [], 0
    while True:
        m = re.search(r'!(?=[\w(])', line[i:])
        if not m:
            break
        at = i + m.start()
        j = at + 1
        word = re.match(r'[\w.]+', line[j:])
        if not word:
            out.append(line[i:at + 1])
            i = at + 1
            continue
        j += word.end()
        while j < len(line) and line[j] in '([':  # a call or an index, maybe followed by .member
            close = _closing(line.replace('[', '(').replace(']', ')'), j)
            if close < 0:
                break
            j = close + 1
            member = re.match(r'\.[\w.]+', line[j:])
            if member:
                j += member.end()
        op = re.match(r'\s*(==|~=|!=)\s*("[^"]*"|\'[^\']*\'|[\w.]+(?:\([^()]*\))?)', line[j:])
        if not op:
            out.append(line[i:at + 1])
            i = at + 1
            continue
        end = j + op.end()
        out.append(line[i:at] + '!(' + line[at + 1:end] + ')')
        i = end
    out.append(line[i:])
    return ''.join(out)


def _flatten_else_if(lines, number, m):
    """else { if (...) ... } -> else if (...) ...: the decompiler nests every
    else-if, which runs into the compiler's nesting limit."""
    changed = True
    while changed:
        changed = False
        for j in range(len(lines) - 2):
            if lines[j].strip() != 'else' or lines[j + 1].strip() != '{':
                continue
            k = j + 2
            while k < len(lines) and lines[k].strip().startswith('//'):
                k += 1
            if k >= len(lines) or not re.match(r'\s*if\s*\(', lines[k]):
                continue
            end = _block_end(lines, j + 1)
            if end is None or _statement_end(lines, k) != end - 1:
                continue
            indent = lines[j][:len(lines[j]) - len(lines[j].lstrip())]
            body = [line[1:] if line.startswith('\t') else line for line in lines[k:end]]
            body[0] = indent + 'else ' + body[0].lstrip()
            lines[j:end + 1] = body
            changed = True
            break


def _block_end(lines, open_line):
    """Line index of the '}' that closes the '{' on lines[open_line]."""
    depth = 0
    for i in range(open_line, len(lines)):
        stripped = re.sub(r'"(?:\\.|[^"\\])*"|//.*', '', lines[i])
        depth += stripped.count('{') - stripped.count('}')
        if depth == 0:
            return i
    return None


def _statement_end(lines, start):
    """Last line index of the if statement (with its else chain) starting at lines[start]."""
    i = start
    while True:
        if i + 1 < len(lines) and lines[i + 1].strip() == '{':
            end = _block_end(lines, i + 1)
        else:
            end = i + 1 if not lines[i].rstrip().endswith(';') else i
            while end < len(lines) and lines[end].strip().startswith('//'):
                end += 1
        if end is None:
            return None
        nxt = end + 1
        while nxt < len(lines) and lines[nxt].strip().startswith('//'):
            nxt += 1
        if nxt < len(lines) and re.match(r'\s*else\b', lines[nxt]):
            if lines[nxt].strip() == 'else':
                if nxt + 1 < len(lines) and lines[nxt + 1].strip() == '{':
                    return _block_end(lines, nxt + 1)
                return nxt + 1
            i = nxt
            continue
        return end


LABEL = re.compile(r'^(\s*)(J0x[0-9A-Fa-f]+):\s*$')


def _gotos(lines, label):
    return [i for i, line in enumerate(lines) if re.match(rf'\s*goto {label};', line)]


def _next_code(lines, i):
    """Index of the first line after i that isn't blank or a comment."""
    i += 1
    while i < len(lines) and (not lines[i].strip() or lines[i].strip().startswith('//')):
        i += 1
    return i


def _rebuild_loops(lines, number, m):
    """State code takes no `goto label`, which is how the decompiler writes the
    loops it couldn't rebuild: turn label + if + `goto label` back into a while
    loop (with break for a goto past its end), and label + `if(!(X)) goto label`
    into do ... until(X). A code label at offset 0 is the state's Begin."""
    lines[:] = [re.sub(r'^\{\s*J0x00:\s*$', '{\n\tJ0x00:', line) for line in lines]
    lines[:] = '\n'.join(lines).split('\n')
    changed = True
    while changed:
        changed = False
        for i, line in enumerate(lines):
            label = LABEL.match(line)
            if not label:
                continue
            name = label.group(2)
            k = _next_code(lines, i)
            if k + 1 < len(lines) and re.match(r'\s*if\s*\(', lines[k]) and lines[k + 1].strip() == '{':
                end = _block_end(lines, k + 1)
                if end is not None and re.match(rf'\s*goto {name};', lines[end - 1]):
                    after = _next_code(lines, end)
                    after_label = LABEL.match(lines[after]) if after < len(lines) else None
                    lines[k] = lines[k].replace('if', 'while', 1)
                    cut = end - 2 if lines[end - 2].strip() == '// [Loop Continue]' else end - 1
                    del lines[cut:end]
                    end -= end - cut
                    if after_label:
                        stop = after_label.group(2)
                        for j in range(k, end):
                            if re.match(rf'\s*goto {stop};', lines[j]):
                                lines[j] = lines[j].replace(f'goto {stop};', 'break;')
                                if lines[j - 1].strip() == '// [Explicit Break]':
                                    del lines[j - 1]
                                    end -= 1
                                break
                    changed = True
                    break
            loop_end = next((j for j in range(i + 1, len(lines) - 1)
                             if re.match(rf'\s*goto {name};', lines[j + 1]) and re.match(r'\s*if\s*\(!\(', lines[j])), None)
            if loop_end is not None:
                cond = re.match(r'(\s*)if\s*\(!\((.*)\)\)\s*$', lines[loop_end])
                if cond and cond.group(1) == label.group(1):
                    indent = label.group(1)
                    body = ['\t' + l if l.strip() else l for l in lines[i + 1:loop_end]]
                    begin = [indent + 'Begin:'] if name.lower() == 'j0x00' else []
                    lines[i:loop_end + 2] = begin + [indent + 'do', indent + '{'] + body + [indent + '}', indent + f'until({cond.group(2)});']
                    changed = True
                    break
        # drop labels nothing jumps to any more
        for i in range(len(lines) - 1, -1, -1):
            label = LABEL.match(lines[i])
            if label and not _gotos(lines, label.group(2)):
                del lines[i]


def _drop_line(lines, number, m):
    if 0 < number <= len(lines):
        del lines[number - 1]


# Fixes for decompiler artifacts the compiler names: (message pattern,
# function(lines, line number, match) that edits the file's lines in place).
FIXES = [
    # int(0), float(1.0), string("x"): a cast of a literal to its own type
    (re.compile(r"No need to cast '(\w+)Property' to itself"),
     _on_line(lambda line, m: re.sub(rf'\b{CAST_NAMES.get(m.group(1), m.group(1).lower())}\(({LITERAL})\)', r'\1',
                                     line, flags=re.I))),
    # OnlinePlayerInterface(none)
    (re.compile(r"Cast from 'None' to '(\w+)' is unnecessary"),
     _on_line(lambda line, m: re.sub(rf'\b{m.group(1)}\(none\)', 'none', line, flags=re.I))),
    # a struct or enum of another class of the package
    (re.compile(r"Unrecognized type '\w+' within '(\w+)'"), lambda lines, number, m: add_dependson(lines, m.group(1))),
    (re.compile(r"Unrecognized type '(\w+)'$"), lambda lines, number, m: _depend_on_declarer(m.group(1), lines)),
    (re.compile(r'Bad function definition'), _depend_on_return_type),
    (re.compile(r"Missing ';' in 'interface'"), _drop_interface_abstract),
    # `local editinline SkeletalMeshComponent Mesh;`: a property flag the decompiler spells out
    (re.compile(r'Specified type modifiers not allowed here'),
     _on_line(lambda line, m: re.sub(r'^(\s*local\s+)(?:editinline\s+|export\s+)+', r'\1', line))),
    # implements(CCSPawn) declares VfTable_ICCSPawn itself
    (re.compile(r"Variable declaration: 'VfTable_I\w+' already defined"), _drop_line),
    # immutablewhencooked sets STRUCT_AtomicWhenCooked too; the keyword doesn't exist
    (re.compile(r"Missing '\{' in 'struct'"), _on_line(lambda line, m: re.sub(r'\batomicwhencooked\s+', '', line))),
    # an interface extending an interface decompiles as a class
    (re.compile(r"Class '\w+' cannot extend interface '\w+', use 'implements'"), _class_to_interface),
    (re.compile(r"'Ignores': '(\w+)' is not a function"), _state_function_for_ignore),
    (re.compile(r"'Int' conversion: Bad or missing expression"), _on_line(lambda line, m: _uncast_comparisons(line))),
    # a static function as a delegate loses its `.static`
    (re.compile(r"Delegate assignment failed \(\w+\): Invalid or unknown function '(\w+)'"),
     _on_line(lambda line, m: re.sub(rf"'\.{m.group(1)}\b", f"'.static.{m.group(1)}", line))),
    # !(A == B) decompiles as !A == B
    (re.compile(r"Types are incompatible with '!'"), _on_line(lambda line, m: _negate_comparisons(line))),
    (re.compile(r"Type mismatch in Call to '(\w+)', parameter (\d+)"), _retype_argument),
    (re.compile(r"Unrecognized member '(\d+)' in class '(\w+)'"), _const_for_number),
    (re.compile(r'Maximum nesting limit exceeded'), _flatten_else_if),
    (re.compile(r"Bad or missing expression for token: J0x\w+, in 'Goto'"), _rebuild_loops),
]
# Missing types also follow from other errors (a class that didn't parse), so
# these fixes wait until they are the only errors left.
DEPENDENCY_MESSAGES = re.compile(r"Unrecognized type|Bad function definition")


def script_file(work_file):
    """The committed file a work-tree path (Development/Src/<Pkg>/Classes/<x>.uc) came from."""
    parts = Path(work_file).parts
    if len(parts) >= 5 and parts[:2] == ('Development', 'Src') and parts[3].lower() == 'classes':
        path = paths.ROOT / 'script' / parts[2] / 'Classes' / parts[4]
        if path.exists():
            return path
    return None


def apply_fixes(errors):
    """Apply FIXES to the committed scripts; the number of files changed."""
    if not all(DEPENDENCY_MESSAGES.search(message) for _, _, message in errors):
        errors = [e for e in errors if not DEPENDENCY_MESSAGES.search(e[2])]
    by_file = {}
    for file, number, message in errors:
        by_file.setdefault(file, []).append((number, message))
    changed = 0
    for file, items in by_file.items():
        path = script_file(file)
        if path is None:
            continue
        text = path.read_bytes().decode('utf-8')
        newline = '\r\n' if '\r\n' in text else '\n'
        lines = text.split(newline)
        # bottom up, so a fix that inserts a line leaves the others' numbers valid
        for number, message in sorted(items, reverse=True):
            for pattern, fix in FIXES:
                m = pattern.search(message)
                if m:
                    fix(lines, number, m)
                    break
        new = newline.join(lines)
        if new != text:
            path.write_bytes(new.encode('utf-8'))
            changed += 1
    return changed


def _edit_committed(edit):
    """Run edit(text) -> text over every committed class; the number changed."""
    changed = 0
    for _, path in committed_classes(False):
        text = path.read_bytes().decode('utf-8')
        new = edit(text)
        if new != text:
            path.write_bytes(new.encode('utf-8'))
            changed += 1
    return changed


def coerced_returns(udk):
    """Function name -> return type for UDK's `function coerce <type> <name>(`:
    the decompiler loses a return value's coerce."""
    found = {}
    for path in (udk / 'Development' / 'Src').glob('*/Classes/*.uc'):
        for m in re.finditer(r'\bfunction\s+coerce\s+(\w+)\s+(\w+)\s*\(', path.read_text(encoding='utf-8', errors='replace'), re.I):
            found[m.group(2)] = m.group(1)
    return found


def normalize(udk):
    """Whole-file fixes for decompiler artifacts the compiler can't point at
    precisely; the number of files changed."""
    coerced = coerced_returns(udk)

    def edit(text):
        # UELib has no friendly name for ~= (ComplementEqual_StrStr)
        text = re.sub(r'\s+ComplementEqual\s+', ' ~= ', text)
        # a final function called on another object reads as Other.super(Class).F()
        text = re.sub(r'(?<=[\w\)\]])\.super\(\w+\)\.', '.', text)
        for name, type_name in coerced.items():
            text = re.sub(rf'\bfunction\s+(?!coerce\b)({type_name})\s+({name})\s*\(', r'function coerce \1 \2(', text, flags=re.I)
        # default properties take enum values bare: Physics=PHYS_Falling, not EPhysics.PHYS_Falling
        return re.sub(r'(?ms)^(\s*(?:struct)?defaultproperties\s*\{.*?^\s*\})', _bare_enum_values, text)
    return _edit_committed(edit)


def _bare_enum_values(block):
    enums = source_index()[0]
    return re.sub(r'(?<=[=(,])(\w+)\.(\w+)\b',
                  lambda m: m.group(2) if m.group(1).lower() in enums else m.group(0), block.group(1))


def restore_epic_dependson(udk):
    """A modified Epic class keeps UDK's dependson() list: the original's, which
    cooking drops. The number of files changed."""
    changed = 0
    for row in csv.DictReader(open(paths.CONFIG / 'script_classes.csv')):
        path = paths.ROOT / 'script' / row['package'] / 'Classes' / f"{row['class']}.uc"
        if row['status'] != 'modified' or not path.exists() or not row['udk_file']:
            continue
        source = (udk / row['udk_file']).read_text(encoding='utf-8', errors='replace')
        header = re.search(r'^\s*(?:class|interface)\s+\w+[^;]*;', re.sub(r'/\*.*?\*/|//[^\n]*', '', source, flags=re.S), re.M | re.S)
        names = [n.strip() for d in re.findall(r'dependson\s*\(([^)]*)\)', header.group(0) if header else '', re.I)
                 for n in d.split(',') if n.strip()]
        if not names:
            continue
        text = path.read_bytes().decode('utf-8')
        newline = '\r\n' if '\r\n' in text else '\n'
        lines = text.split(newline)
        for name in names:
            add_dependson(lines, name)
        new = newline.join(lines)
        if new != text:
            path.write_bytes(new.encode('utf-8'))
            changed += 1
    return changed


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--udk', type=Path, default=os.environ.get('UDK_DIR'), help='UDK July 2012 BETA 2 install (or UDK_DIR)')
    ap.add_argument('--work', type=Path, default=paths.BUILD / 'udk', help='work tree (default build/udk)')
    ap.add_argument('--nspace-only', action='store_true', help="leave UDK's own version of the modified Epic classes")
    ap.add_argument('--fix', action='store_true', help='apply the known decompiler-artifact fixes to script/ and recompile')
    args = ap.parse_args(argv)
    if args.udk is None:
        ap.error('give --udk or set UDK_DIR')
    udk = paths.require(Path(args.udk))
    paths.require(udk / 'Binaries' / 'Win32' / 'UDK.com')
    global UDK_SOURCE
    UDK_SOURCE = udk / 'Development' / 'Src'
    if args.fix:
        restore_epic_dependson(udk)
        normalize(udk)
    while True:
        count = prepare(udk, args.work, args.nspace_only)
        result = run(args.work)
        if not (args.fix and result['errors'] and apply_fixes(result['errors'])):
            break
    stubs = 0
    while result['errors'] and STUBBED:
        changed = stub_uses(args.work, result['errors'])
        if not changed:
            break
        stubs += changed
        result = run(args.work)
    print(f'{count} committed classes laid over UDK; {len(STUBBED)} n-Space members of native classes left out, '
          f'{stubs} uses of them stubbed in the work tree')
    for name, ok in result['packages']:
        print(f'  {name}: {"ok" if ok else "FAILED"}')
    committed = {p.name.lower() for _, p in committed_classes(False)}
    ours = [w for w in result['warnings'] if Path(w[0]).name.lower() in committed]
    print(f'{len(result["errors"])} errors, {len(result["warnings"])} warnings ({len(ours)} in committed classes)')
    for file, line, message in result['errors']:
        print(f'{file}({line}): {message}' if file else message)
    failed = result['errors'] or not result['packages'] or not all(ok for _, ok in result['packages'])
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
