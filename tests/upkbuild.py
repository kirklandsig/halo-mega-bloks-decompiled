"""Builds tiny synthetic UE3 packages (big-endian, version 863) for the tests,
in the layout tools/upk.py reads. Nothing here comes from the game."""
import struct


class Builder:
    def __init__(self):
        self.names = ['None']
        self.imports = []  # (class package, class name, outer, name)
        self.exports = []  # [class, super, outer, name, flags, data]
        self.compressed = False  # mark the header as LZX-compressed (one chunk)

    def name(self, text):
        base, number = text, 0
        if text not in self.names:
            self.names.append(text)
        return self.names.index(base), number

    def fname(self, text):
        index, number = self.name(text)
        return struct.pack('>ii', index, number)

    def add_import(self, class_package, class_name, outer, name):
        for n in (class_package, class_name, name):
            self.name(n)
        self.imports.append((class_package, class_name, outer, name))
        return -len(self.imports)

    def add_export(self, class_ref, outer, name, data=b'', flags=0, super_ref=0):
        self.name(name)
        self.exports.append([class_ref, super_ref, outer, name, flags, data])
        return len(self.exports)

    def set_data(self, ref, data):
        self.exports[ref - 1][5] = data

    # tagged properties
    def tag(self, name, kind, value, struct_name=None, index=0):
        out = self.fname(name) + self.fname(kind) + struct.pack('>ii', len(value), index)
        if kind == 'StructProperty':
            out += self.fname(struct_name)
        elif kind == 'ByteProperty':
            out += self.fname('None')
        return out + value

    def bool_tag(self, name, value):
        return self.fname(name) + self.fname('BoolProperty') + struct.pack('>ii', 0, 0) + bytes([1 if value else 0])

    def end(self):
        return self.fname('None')

    def build(self):
        names = b''.join(_fstring(n) + struct.pack('>Q', 0) for n in self.names)
        imports = b''.join(self.fname(cp) + self.fname(cn) + struct.pack('>i', outer) + self.fname(n)
                           for cp, cn, outer, n in self.imports)

        def header(name_off, exp_off, imp_off):
            return (struct.pack('>IIi', 0x9E2A83C1, 863, 0) + _fstring('None') + struct.pack('>I', 0)
                    + struct.pack('>ii', len(self.names), name_off) + struct.pack('>ii', len(self.exports), exp_off)
                    + struct.pack('>ii', len(self.imports), imp_off) + struct.pack('>i', 0)
                    + struct.pack('>iii', 0, 0, 0) + struct.pack('>i', 0) + bytes(16)
                    + struct.pack('>i', 1) + struct.pack('>iii', len(self.exports), len(self.names), 0)
                    + struct.pack('>ii', 10246, 136) + struct.pack('>Ii', *((4, 1) if self.compressed else (0, 0))))

        export_size = 4 * 3 + 8 + 4 + 8 + 8 + 4 + 4 + 16 + 4
        size = len(header(0, 0, 0))
        name_off = size
        imp_off = name_off + len(names)
        exp_off = imp_off + len(imports)
        data_off = exp_off + export_size * len(self.exports)
        table, blobs = b'', b''
        for class_ref, super_ref, outer, name, flags, data in self.exports:
            table += (struct.pack('>iii', class_ref, super_ref, outer) + self.fname(name) + struct.pack('>i', 0)
                      + struct.pack('>Q', flags) + struct.pack('>ii', len(data), data_off + len(blobs))
                      + struct.pack('>Ii', 0, 0) + bytes(16) + struct.pack('>I', 0))
            blobs += data
        return header(name_off, exp_off, imp_off) + names + imports + table + blobs


def _fstring(text):
    raw = text.encode('latin-1') + b'\0'
    return struct.pack('>i', len(raw)) + raw
