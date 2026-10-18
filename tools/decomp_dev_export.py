"""Writes the objdiff-format progress report that ByteMatch charts, from
config/functions.csv and config/status.csv. It needs neither the build's
files nor the SDK. See docs/BYTEMATCH.md. (The name
predates ByteMatch, which succeeded decomp.dev.)

    python tools/decomp_dev_export.py [-o build/report.json]

The target is n-Space's code: the top-level measures and the `nspace`
category count the game-tier rows whose owner is nspace, one unit per object.
The `game` category counts every game-tier row; Epic's rows of an object go
in a second unit, "<object> [epic]". A function counts as matched code when
config/status.csv says `matched`; data is not compared.
"""
import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path

import inventory
import paths

REPORT_VERSION = 2
CATEGORY_NAMES = {'nspace': "n-Space's code (the target)", 'game': 'Game tier (n-Space and Epic)'}


def _pct(part, whole):
    """Percent, with an empty total as 0% (objdiff's 0/0 is 100%)."""
    return 0.0 if whole == 0 else 100.0 * part / whole


def _measures(functions):
    total = sum(f['size'] for f in functions)
    matched = sum(f['size'] for f in functions if f['status'] == 'matched')
    n = len(functions)
    n_matched = sum(1 for f in functions if f['status'] == 'matched')
    complete = bool(functions) and n_matched == n
    return {
        'fuzzy_match_percent': _pct(matched, total),
        'total_code': str(total), 'matched_code': str(matched), 'matched_code_percent': _pct(matched, total),
        'total_data': '0', 'matched_data': '0', 'matched_data_percent': 0.0,
        'total_functions': n, 'matched_functions': n_matched, 'matched_functions_percent': _pct(n_matched, n),
        'complete_code': str(total if complete else 0), 'complete_code_percent': 100.0 if complete else 0.0,
        'complete_data': '0', 'complete_data_percent': 0.0,
        'total_units': 1, 'complete_units': 1 if complete else 0,
    }


def _sum(units):
    out = _measures([f for u in units for f in u])
    out['total_units'] = len(units)
    out['complete_units'] = sum(1 for u in units if u and all(f['status'] == 'matched' for f in u))
    complete = sum(f['size'] for u in units if u and all(f['status'] == 'matched' for f in u) for f in u)
    out['complete_code'] = str(complete)
    out['complete_code_percent'] = _pct(complete, int(out['total_code']))
    return out


def build_report(functions_csv, status_csv):
    """The objdiff report (version 2) as a dict."""
    status = {}
    if Path(status_csv).exists():
        status = {int(r['address'], 16): r['status'] for r in inventory.read_csv(status_csv)}
    groups = defaultdict(list)
    for r in inventory.read_csv(functions_csv):
        if r['tier'] != 'game':
            continue
        va = int(r['address'], 16)
        fn = {'va': va, 'size': int(r['size']), 'status': status.get(va, 'todo'), 'source': r['source']}
        groups[(r['object'], r['owner'] == 'nspace')].append(fn)

    units, nspace_units, game_units = [], [], []
    for (obj, is_nspace), fns in sorted(groups.items(), key=lambda kv: (kv[0][0].lower(), not kv[0][1])):
        fns.sort(key=lambda f: f['va'])
        categories = ['nspace', 'game'] if is_nspace else ['game']
        game_units.append(fns)
        if is_nspace:
            nspace_units.append(fns)
        metadata = {'complete': all(f['status'] == 'matched' for f in fns), 'progress_categories': categories}
        source = next((f['source'].replace('\\', '/') for f in fns if f['source']), '')
        if source:
            metadata['source_path'] = source
        units.append({
            'name': obj if is_nspace else f'{obj} [epic]',
            'measures': _measures(fns),
            'functions': [{'name': f'function_{f["va"]:x}', 'size': str(f['size']),
                           'fuzzy_match_percent': 100.0 if f['status'] == 'matched' else 0.0,
                           'metadata': {'virtual_address': str(f['va'])}} for f in fns],
            'metadata': metadata,
        })
    return {
        'measures': _sum(nspace_units),
        'units': units,
        'version': REPORT_VERSION,
        'categories': [{'id': 'game', 'name': CATEGORY_NAMES['game'], 'measures': _sum(game_units)},
                       {'id': 'nspace', 'name': CATEGORY_NAMES['nspace'], 'measures': _sum(nspace_units)}],
    }


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the ByteMatch (objdiff) progress report.')
    ap.add_argument('-o', '--output', default='-', help='report path, or - for stdout (default)')
    args = ap.parse_args(argv)
    report = build_report(paths.require(paths.CONFIG / 'functions.csv'), paths.CONFIG / 'status.csv')
    text = json.dumps(report, indent=2) + '\n'
    if args.output == '-':
        sys.stdout.write(text)
    else:
        out = Path(args.output)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text, encoding='utf-8')
    m = report['measures']
    print(f"nspace: matched {m['matched_functions']} of {m['total_functions']} functions, "
          f"{m['matched_code']} of {m['total_code']} bytes", file=sys.stderr)
    return 0


if __name__ == '__main__':
    sys.exit(main())
