"""Writes the function and object inventory from the PDB:
config/functions.csv (one row per function address: every procedure, then
the library functions that have only a public symbol) and config/objects.csv
(one row per object file that holds code). Both are static: match status
lives in config/status.csv, which tools/check.py writes and this tool leaves
alone. Source paths drop the build machine's source root. The decorated
name (symbol) is kept for the game tier, which tools/check.py matches, and
for the functions that have no other name.

    python tools/inventory.py [--pdb PDB]

A module under Intermediate\\MegaHaloGame\\Xbox360\\Release\\<Package>\\ belongs
to UE3 package <Package>: UDKBase, GameFramework, MegaHaloGame and Cognition
are the game tier, Core and Engine the engine tier, every other package the
platform tier. Everything else is lib.

Game-tier rows carry an owner: nspace for MegaHaloGame and Cognition and for
source files whose name starts with Halo, epic for the rest (Epic's UDK code).
"""
import argparse
import bisect
import csv
import ntpath
import re

import paths
from pdbfile import IMAGE_BASE, Pdb

FUNCTION_COLUMNS = ['address', 'size', 'name', 'symbol', 'object', 'package', 'tier', 'owner', 'source', 'line']
OBJECT_COLUMNS = ['object', 'package', 'tier', 'functions', 'bytes', 'src', 'cmd']

GAME = {'udkbase', 'gameframework', 'megahalogame', 'cognition'}
ENGINE = {'core', 'engine'}
NSPACE_PACKAGES = {'megahalogame', 'cognition'}
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
    if package in NSPACE_PACKAGES or ntpath.basename(source).lower().startswith('halo'):
        return 'nspace'
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


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write config/functions.csv and config/objects.csv from the PDB.')
    ap.add_argument('--pdb', default=None)
    args = ap.parse_args(argv)
    functions, objects = build(Pdb(args.pdb or paths.pdb()))
    if (paths.CONFIG / 'script_classes.csv').exists():  # owners refined by tools/script_compare.py
        import script_compare
        status = {}
        for r in read_csv(paths.CONFIG / 'script_classes.csv'):
            status.setdefault(r['class'].lower(), r['status'])
        script_compare.refine_owner(functions, status)
    write_csv(paths.CONFIG / 'functions.csv', FUNCTION_COLUMNS, functions)
    write_csv(paths.CONFIG / 'objects.csv', OBJECT_COLUMNS, objects)
    tiers = {}
    for r in functions:
        tiers[r['tier']] = tiers.get(r['tier'], 0) + 1
    print(f'{len(functions)} functions, {len(objects)} objects; ' + ', '.join(f'{k} {v}' for k, v in sorted(tiers.items())))


if __name__ == '__main__':
    main()
