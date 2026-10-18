"""Lists the XEX's imports (kernel, XAM, xbdm) and writes config/imports.csv.

    python tools/imports.py [xex] [-o config/imports.csv]

The import-libraries optional header (0x000103FF) holds a string table of
library names, then one record per library: a list of addresses of import
records in the image. Each record's word is (type << 24) | (library << 16) |
ordinal; type 0 is a variable slot, type 1 the thunk of a function (whose
variable slot precedes it). Names come from Xenia's export tables (BSD,
third_party/xenia), read in place. Xenia's xex_module.cc is the reference.
"""
import argparse
import csv
import re
import struct
import sys
from dataclasses import dataclass

import paths
import xex

IMPORT_LIBRARIES = 0x000103FF
TABLES = paths.ROOT / 'third_party' / 'xenia' / 'src' / 'xenia' / 'kernel'
TABLE_FILES = {
    'xboxkrnl.exe': 'xboxkrnl/xboxkrnl_table.inc',
    'xam.xex': 'xam/xam_table.inc',
    'xbdm.xex': 'xbdm/xbdm_table.inc',
}
_EXPORT = re.compile(r'XE_EXPORT\(\s*\w+\s*,\s*(0x[0-9A-Fa-f]+)\s*,\s*(\w+)\s*,')


@dataclass(frozen=True)
class Import:
    library: str
    ordinal: int
    name: str
    thunk: int
    kind: str


def parse_table(text):
    """{ordinal: name} from the text of a Xenia *_table.inc."""
    return {int(m.group(1), 16): m.group(2) for m in _EXPORT.finditer(text)}


def _names(library):
    rel = TABLE_FILES.get(library)
    p = TABLES / rel if rel else None
    return parse_table(p.read_text()) if p and p.exists() else {}


def _libraries(data, h):
    off = h.optional[IMPORT_LIBRARIES]
    _size, str_size, str_count = struct.unpack_from('>III', data, off)
    strings = data[off + 12:off + 12 + str_size].split(b'\0')
    names = [s.decode() for s in strings if s][:str_count]
    p, end = off + 12 + str_size, off + _size
    while p < end:
        size, = struct.unpack_from('>I', data, p)
        name_index, count = struct.unpack_from('>HH', data, p + 0x24)
        records = struct.unpack_from(f'>{count}I', data, p + 0x28)
        yield names[name_index], records
        p += size


def imports(xex_path):
    data = paths.Path(xex_path).read_bytes()
    h = xex.parse_header(data)
    image = xex.extract_basefile(data)
    out = []
    for library, records in _libraries(data, h):
        names = _names(library)
        for i, addr in enumerate(records):
            value, = struct.unpack_from('>I', image, addr - h.image_base)
            kind, ordinal = value >> 24, value & 0xFFFF
            if kind == 1:
                continue  # the thunk; its variable slot is the record before it
            nxt = records[i + 1] if i + 1 < len(records) else None
            is_func = False
            if nxt is not None:
                v2, = struct.unpack_from('>I', image, nxt - h.image_base)
                is_func = v2 >> 24 == 1 and v2 & 0xFFFF == ordinal
            out.append(Import(library, ordinal, names.get(ordinal, ''),
                              nxt if is_func else addr, 'function' if is_func else 'variable'))
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write config/imports.csv from the XEX.')
    ap.add_argument('xex', nargs='?', default=None)
    ap.add_argument('-o', '--out', default=str(paths.CONFIG / 'imports.csv'))
    args = ap.parse_args(argv)
    found = imports(paths.require(args.xex or paths.xex()))
    with open(args.out, 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['library', 'ordinal', 'name', 'thunk', 'kind'])
        for i in found:
            w.writerow([i.library, i.ordinal, i.name, f'0x{i.thunk:08X}', i.kind])
    by_lib = {}
    for i in found:
        by_lib[i.library] = by_lib.get(i.library, 0) + 1
    print(f'{len(found)} imports: ' + ', '.join(f'{k} {v}' for k, v in by_lib.items())
          + f'; {sum(1 for i in found if not i.name)} unnamed')


if __name__ == '__main__':
    sys.exit(main())
