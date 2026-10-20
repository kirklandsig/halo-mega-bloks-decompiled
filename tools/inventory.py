"""Writes the function and object inventory from the PDB:
config/functions/ (one row per function address: every procedure, then
the library functions that have only a public symbol) and config/objects.csv
(one row per object file that holds code). The function rows are split into
plain CSV files by tier (game.csv, platform.csv, engine-1.csv, ...), each
sorted by address and cut before it passes SHARD_BYTES, so no file nears
GitHub's size limits; read_functions() is the one way to load them. Both are static: match status
lives in config/status.csv, which tools/check.py writes and this tool leaves
alone. Source paths drop the build machine's source root. The decorated
name (symbol) is kept for the game tier, which tools/check.py matches, and
for the functions that have no other name.

    python tools/inventory.py [--pdb PDB]

A module under Intermediate\\MegaHaloGame\\Xbox360\\Release\\<Package>\\ belongs
to UE3 package <Package>: UDKBase, GameFramework, MegaHaloGame and Cognition
are the game tier, Core and Engine the engine tier, every other package the
platform tier. Everything else is lib.

Game-tier rows carry an owner: nspace for MegaHaloGame and Cognition, for
source files whose name starts with Halo and for the CCS layer (CCS_SOURCES),
vendor for middleware code (see VENDOR_SOURCES), epic for the rest (Epic's
UDK code). tools/script_compare.py refines it by script class
(refine_owner).
"""
import argparse
import bisect
import csv
import io
import ntpath
import re
from pathlib import Path

import paths
from pdbfile import IMAGE_BASE, Pdb

FUNCTION_COLUMNS = ['address', 'size', 'name', 'symbol', 'object', 'package', 'tier', 'owner', 'source', 'line']
OBJECT_COLUMNS = ['object', 'package', 'tier', 'functions', 'bytes', 'src', 'cmd']

GAME = {'udkbase', 'gameframework', 'megahalogame', 'cognition'}
ENGINE = {'core', 'engine'}
NSPACE_PACKAGES = {'megahalogame', 'cognition'}
# The CCS layer: Autodesk Gameware Cognition's reference integration with
# UE3, which n-Space extended into the game's AI (udkbase\ccsref*). In scope.
CCS_SOURCES = ('udkbase\\ccsref',)
# Game-tier code that is neither Epic's nor n-Space's: middleware headers
# inlined into the game's objects (Autodesk Gameware's Grip and Navigation).
VENDOR_SOURCES = ('external\\',)
PACKAGE = re.compile(r'\\intermediate\\megahalogame\\xbox360\\release\\([^\\]+)\\')
SOURCE_PREFIXES = [('f:\\projects\\halo_megabloks\\development\\src\\', ''),
                   ('f:\\projects\\halo_megabloks\\development\\', ''),
                   ('c:\\program files (x86)\\microsoft xbox 360 sdk\\', '<xdk>\\')]


def classify(module_name):
    """(tier, package) of a module; the package is lowercase, '' for lib."""
    m = PACKAGE.search(module_name.replace('/', '\\').lower())
    if not m:
        return 'lib', ''
    package = m.group(1)
    if package in GAME:
        return 'game', package
    if package in ENGINE:
        return 'engine', package
    return 'platform', package


def object_name(module_name, obj_name):
    """The module's object file name; a library member is '<lib>(<obj>)'."""
    obj = ntpath.basename(module_name)
    if obj_name.lower().endswith('.lib'):
        return f'{ntpath.basename(obj_name)}({obj})'
    return obj


def short_source(path):
    """A PDB source path without the build machine's source root; XDK paths as <xdk>\\..."""
    for prefix, replacement in SOURCE_PREFIXES:
        if path.lower().startswith(prefix):
            return replacement + path[len(prefix):]
    return path


def owner(tier, package, source):
    if tier != 'game':
        return ''
    source = source.lower()
    if package in NSPACE_PACKAGES or ntpath.basename(source).startswith('halo') or source.startswith(CCS_SOURCES):
        return 'nspace'
    if source.startswith(VENDOR_SOURCES):
        return 'vendor'
    return 'epic'


def build(pdb):
    """(function rows, object rows), both sorted by their key. Functions
    with only a public symbol get an empty name, the object of the section
    contribution holding them (lib when there is none), and a size that runs
    to the next function or the end of their contribution or section."""
    publics = pdb.publics()
    mods = {}

    def module_info(index):
        if index not in mods:
            mod = pdb.modules[index]
            tier, package = classify(mod.name)
            mods[index] = {'object': object_name(mod.name, mod.obj), 'package': package, 'tier': tier,
                           'functions': 0, 'bytes': 0}
        return mods[index]

    functions = []
    for proc in pdb.procedures():
        mod = pdb.modules[proc.module]
        info = module_info(proc.module)
        info['functions'] += 1
        info['bytes'] += proc.size
        source, line = pdb.first_line(mod, proc.rva) or ('', '')
        source = short_source(source)
        functions.append({
            'address': f'0x{IMAGE_BASE + proc.rva:08X}', 'size': proc.size, 'name': proc.name,
            # decorated names only where tools/check.py needs them, to keep the file small
            'symbol': publics.get(proc.rva, '') if info['tier'] == 'game' else '',
            'object': info['object'], 'package': info['package'],
            'tier': info['tier'], 'owner': owner(info['tier'], info['package'], source), 'source': source,
            'line': line})
    public_only = pdb.public_functions()
    starts = sorted([int(r['address'], 16) - IMAGE_BASE for r in functions] + [rva for rva, _ in public_only])
    lib = {'object': '', 'package': '', 'tier': 'lib'}
    for rva, symbol in public_only:
        index = pdb.contribution_module(rva)
        info = lib if index is None else module_info(index)
        nxt = starts[bisect.bisect_right(starts, rva)] if bisect.bisect_right(starts, rva) < len(starts) else None
        end = min(x for x in (nxt, pdb.code_end(rva)) if x is not None)
        functions.append({
            'address': f'0x{IMAGE_BASE + rva:08X}', 'size': end - rva, 'name': '', 'symbol': symbol,
            'object': info['object'], 'package': info['package'], 'tier': info['tier'],
            'owner': owner(info['tier'], info['package'], ''), 'source': '', 'line': ''})
    functions.sort(key=lambda r: int(r['address'], 16))
    objects = []
    for index, info in mods.items():
        env = pdb.env(pdb.modules[index])
        objects.append({**info, 'src': env.get('src', ''), 'cmd': env.get('cmd', '')})
    objects.sort(key=lambda r: r['object'].lower())
    return functions, objects


def write_csv(path, columns, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, columns, lineterminator='\n')
        w.writeheader()
        w.writerows(rows)


def read_csv(path):
    with open(paths.require(path), newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))


TIERS = ('game', 'platform', 'engine', 'lib')
SHARD_BYTES = 8 * 1024 * 1024


def functions_dir():
    """config/functions/, the inventory's function rows."""
    return paths.CONFIG / 'functions'


def read_functions(path=None):
    """Every function row, sorted by address, from config/functions/ (or
    `path`: such a folder, or one CSV file)."""
    path = paths.require(functions_dir() if path is None else path)
    files = sorted(path.glob('*.csv')) if path.is_dir() else [path]
    rows = [r for f in files for r in read_csv(f)]
    rows.sort(key=lambda r: int(r['address'], 16))
    return rows


def _line(columns, row):
    out = io.StringIO()
    csv.DictWriter(out, columns, lineterminator='\n').writerow(row)
    return out.getvalue()


def write_functions(rows, directory=None):
    """Writes the rows to `directory` (config/functions/) one tier at a time,
    a tier's rows by address, in files of at most SHARD_BYTES: <tier>.csv,
    or <tier>-1.csv, <tier>-2.csv, ... when one file can't hold them. Other
    CSV files there are removed."""
    directory = functions_dir() if directory is None else Path(directory)
    unknown = {r['tier'] for r in rows} - set(TIERS)
    if unknown:
        raise ValueError(f'rows of unknown tiers: {sorted(unknown)}')
    directory.mkdir(parents=True, exist_ok=True)
    header = _line(FUNCTION_COLUMNS, dict(zip(FUNCTION_COLUMNS, FUNCTION_COLUMNS)))
    written = set()
    for tier in TIERS:
        shards, size = [[]], len(header)
        for r in sorted((r for r in rows if r['tier'] == tier), key=lambda r: int(r['address'], 16)):
            line = _line(FUNCTION_COLUMNS, r)
            n = len(line.encode())
            if size + n > SHARD_BYTES and shards[-1]:
                shards.append([])
                size = len(header)
            shards[-1].append(line)
            size += n
        if not shards[0]:
            continue
        for i, lines in enumerate(shards, 1):
            name = f'{tier}.csv' if len(shards) == 1 else f'{tier}-{i}.csv'
            (directory / name).write_text(header + ''.join(lines), encoding='utf-8', newline='')
            written.add(name)
    for f in directory.glob('*.csv'):
        if f.name not in written:
            f.unlink()


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write config/functions/ and config/objects.csv from the PDB.')
    ap.add_argument('--pdb', default=None)
    args = ap.parse_args(argv)
    functions, objects = build(Pdb(args.pdb or paths.pdb()))
    if (paths.CONFIG / 'script_classes.csv').exists():  # owners refined by tools/script_compare.py
        import script_compare
        status = {}
        for r in read_csv(paths.CONFIG / 'script_classes.csv'):
            status.setdefault(r['class'].lower(), r['status'])
        script_compare.refine_owner(functions, status)
    write_functions(functions)
    write_csv(paths.CONFIG / 'objects.csv', OBJECT_COLUMNS, objects)
    tiers = {}
    for r in functions:
        tiers[r['tier']] = tiers.get(r['tier'], 0) + 1
    print(f'{len(functions)} functions, {len(objects)} objects; ' + ', '.join(f'{k} {v}' for k, v in sorted(tiers.items())))


if __name__ == '__main__':
    main()
