"""Read an Unreal Engine 3 package of this build (version 863/0, engine 10246).

    python tools/upk.py <package> [--exports] [--object <path>] [--scripts <dir>]

Reads uncompressed packages: the cooked .xxx files are fully LZX-compressed,
so unpack them first with Gildor's Unreal Package Decompressor
(`decompress -lzx -out=<dir> <package>`). docs/FORMATS.md describes the
layout this reader follows: the header, the name, import and export tables,
object paths, and the tagged properties of an object. What a property holds
when its tag doesn't say (an array's elements, a struct serialized as raw
data) comes from a Schema built from the script packages (Core.xxx,
Engine.xxx, ..., MegaHaloGame.xxx) of the same unpacked folder.

--object prints one export's properties as JSON.
"""
import argparse
import json
import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path

TAG = 0x9E2A83C1
RF_HAS_STACK = 0x0200000000000000  # the object carries a state frame (an actor that can run state code)
CPF_NET = 0x20
CPF_NATIVE = 0x1000
CPF_TRANSIENT = 0x2000
SCRIPT_PACKAGES = ('Core', 'Engine', 'GameFramework', 'IpDrv', 'GFxUI', 'OnlineSubsystemLive', 'AkAudio', 'Grip',
                   'GwNavEngine', 'Cognition', 'UDKBase', 'UTGame', 'MegaHaloGame')


class Reader:
    """A cursor over bytes in the package's byte order."""

    def __init__(self, data, big_endian, pos=0):
        self.data = data
        self.pos = pos
        self.big = big_endian
        self.e = '>' if big_endian else '<'

    def take(self, n):
        if n < 0 or self.pos + n > len(self.data):
            raise EOFError(f'read of {n} bytes past the end at {self.pos:#x}')
        b = self.data[self.pos:self.pos + n]
        self.pos += n
        return b

    def unpack(self, fmt):
        return struct.unpack(self.e + fmt, self.take(struct.calcsize(self.e + fmt)))

    def i32(self):
        return self.unpack('i')[0]

    def u32(self):
        return self.unpack('I')[0]

    def u64(self):
        return self.unpack('Q')[0]

    def u16(self):
        return self.unpack('H')[0]

    def u8(self):
        return self.take(1)[0]

    def f32(self):
        return self.unpack('f')[0]

    def fstring(self):
        n = self.i32()
        if n == 0:
            return ''
        if n > 0:
            return self.take(n)[:-1].decode('latin-1')
        return self.take(-2 * n)[:-2].decode('utf-16-be' if self.big else 'utf-16-le')


@dataclass
class Import:
    class_package: str
    class_name: str
    outer: int
    name: str


@dataclass
class Export:
    class_index: int
    super_index: int
    outer: int
    name: str
    archetype: int
    flags: int
    size: int
    offset: int


@dataclass
class Package:
    path: Path
    data: bytes
    big_endian: bool
    version: int
    licensee: int
    engine: int
    flags: int
    names: list = field(default_factory=list)
    imports: list = field(default_factory=list)
    exports: list = field(default_factory=list)

    @classmethod
    def open(cls, path):
        path = Path(path)
        return cls.parse(path.read_bytes(), path)

    @classmethod
    def parse(cls, data, path=Path('package')):
        if len(data) < 4:
            raise ValueError(f'{path}: not a package')
        if struct.unpack('>I', data[:4])[0] == TAG:
            big = True
        elif struct.unpack('<I', data[:4])[0] == TAG:
            big = False
        else:
            raise ValueError(f'{path}: not an Unreal package')
        r = Reader(data, big, 4)
        version = r.u32()
        file_version, licensee = version & 0xFFFF, version >> 16
        r.i32()  # total header size
        r.fstring()  # folder name
        flags = r.u32()
        name_count, name_offset = r.i32(), r.i32()
        export_count, export_offset = r.i32(), r.i32()
        import_count, import_offset = r.i32(), r.i32()
        r.i32()  # depends offset
        if file_version >= 623:
            r.i32(), r.i32(), r.i32()  # import/export guids
        if file_version >= 584:
            r.i32()  # thumbnail table
        r.take(16)  # guid
        r.take(12 * r.i32())  # generations: exports, names, net objects
        engine = r.i32()
        r.i32()  # cooker version
        compression = r.u32()
        if compression and r.i32():
            raise ValueError(f'{path}: compressed; unpack it first (decompress -lzx)')
        pkg = cls(path, data, big, file_version, licensee, engine, flags)
        r.pos = name_offset
        for _ in range(name_count):
            pkg.names.append(r.fstring())
            r.u64()  # flags
        r.pos = import_offset
        for _ in range(import_count):
            class_package, class_name = pkg.read_name(r), pkg.read_name(r)
            outer = r.i32()
            pkg.imports.append(Import(class_package, class_name, outer, pkg.read_name(r)))
        r.pos = export_offset
        for _ in range(export_count):
            class_index, super_index, outer = r.i32(), r.i32(), r.i32()
            name = pkg.read_name(r)
            archetype = r.i32()
            obj_flags = r.u64()
            size, offset = r.i32(), r.i32()
            r.u32()  # export flags
            r.take(4 * r.i32())  # net object counts per generation
            r.take(16 + 4)  # package guid, package flags
            pkg.exports.append(Export(class_index, super_index, outer, name, archetype, obj_flags, size, offset))
        return pkg

    def read_name(self, r):
        index, number = r.i32(), r.i32()
        return self.name(index, number)

    def name(self, index, number=0):
        base = self.names[index] if 0 <= index < len(self.names) else f'<name {index}>'
        return f'{base}_{number - 1}' if number else base

    def valid_ref(self, ref):
        return -len(self.imports) <= ref <= len(self.exports)

    # Object references: 0 is none, > 0 an export (1-based), < 0 an import.
    def object_name(self, ref):
        if ref > 0:
            return self.exports[ref - 1].name
        if ref < 0:
            return self.imports[-ref - 1].name
        return 'None'

    def outer_of(self, ref):
        if ref > 0:
            return self.exports[ref - 1].outer
        if ref < 0:
            return self.imports[-ref - 1].outer
        return 0

    def path_of(self, ref):
        """Outer.Object: an import's path starts with its package's name."""
        parts = []
        while ref and self.valid_ref(ref):
            parts.append(self.object_name(ref))
            ref = self.outer_of(ref)
        return '.'.join(reversed(parts))

    def full_path(self, ref):
        """The object's path with this package's name in front for an export."""
        return f'{self.path.stem}.{self.path_of(ref)}' if ref > 0 else self.path_of(ref)

    def class_name(self, ref):
        """The name of the class of an object (or 'Class' for a class)."""
        if ref > 0:
            index = self.exports[ref - 1].class_index
            return self.object_name(index) if index else 'Class'
        if ref < 0:
            return self.imports[-ref - 1].class_name
        return 'None'

    def export_data(self, ref):
        e = self.exports[ref - 1]
        return self.data[e.offset:e.offset + e.size]

    def find(self, path, class_name=None):
        """Export references whose name or path is `path`, of class `class_name` if given."""
        return [i for i, e in enumerate(self.exports, 1)
                if (e.name == path or self.path_of(i) == path) and (class_name is None or self.class_name(i) == class_name)]

    def properties(self, ref, schema=None):
        """An export's tagged properties, as {name: value} (see Properties)."""
        e = self.exports[ref - 1]
        r = Reader(self.data, self.big_endian, e.offset)
        if e.flags & RF_HAS_STACK:
            skip_state_frame(r)
        r.i32()  # net index
        return Properties(self, schema).read_tagged(r, self.class_name(ref), e.offset + e.size)


def skip_state_frame(r):
    """An actor's state frame: node, state node, probe mask, latent action, the
    stack of pushed states and, with a node, its code offset."""
    node = r.i32()
    r.i32()  # state node
    r.u32()  # probe mask
    r.u16()  # latent action
    r.take(8 * r.i32())  # pushed states: (state, node)
    if node:
        r.i32()  # code offset


@dataclass
class PropDef:
    """A script property: its kind (IntProperty, ...), what it refers to (the
    struct, class or enum's name), its inner element for an array, its flags."""
    name: str
    kind: str
    target: str = ''
    inner: 'PropDef' = None
    flags: int = 0


class Schema:
    """Classes, structs and their properties, read from the script packages."""

    def __init__(self):
        self.supers = {}  # class or struct name (lower) -> super name
        self.props = {}  # (owner lower, property lower) -> PropDef
        self.layouts = {}  # struct name (lower) -> [PropDef] in declaration order

    @classmethod
    def load(cls, folder):
        schema = cls()
        for name in SCRIPT_PACKAGES:
            path = Path(folder) / f'{name}.xxx'
            if path.exists():
                schema.add(Package.open(path))
        return schema

    def add(self, pkg):
        defs = {}
        for i, e in enumerate(pkg.exports, 1):
            kind = pkg.class_name(i)
            if kind.endswith('Property'):
                defs[i] = self._property(pkg, i, kind)
        for i, e in enumerate(pkg.exports, 1):
            kind = pkg.class_name(i)
            if kind in ('Class', 'ScriptStruct'):
                r = Reader(pkg.data, pkg.big_endian, e.offset)
                r.i32()  # net index
                if kind == 'ScriptStruct':
                    r.take(8)  # its (empty) tagged properties
                r.i32()  # next field
                super_ref, child = r.i32(), r.i32()
                self.supers[e.name.lower()] = pkg.object_name(super_ref).lower() if super_ref else ''
                if kind == 'ScriptStruct':
                    layout = []
                    while child > 0 and child in defs or (child > 0 and pkg.class_name(child) in ('Function', 'Const', 'Enum', 'ScriptStruct')):
                        if child in defs:
                            layout.append(defs[child])
                        child = self._next_field(pkg, child)
                    self.layouts[e.name.lower()] = layout
        for i, d in defs.items():
            owner = pkg.exports[i - 1].outer
            owner_kind = pkg.class_name(owner) if owner else ''
            if owner_kind in ('Class', 'ScriptStruct'):
                self.props.setdefault((pkg.object_name(owner).lower(), d.name.lower()), d)
            elif owner_kind == 'ArrayProperty' and owner in defs:
                defs[owner].inner = d

    @staticmethod
    def _next_field(pkg, ref):
        e = pkg.exports[ref - 1]
        r = Reader(pkg.data, pkg.big_endian, e.offset)
        r.i32()  # net index
        if pkg.class_name(ref) != 'Class':
            r.take(8)  # tagged properties: None
        return r.i32()

    @staticmethod
    def _property(pkg, ref, kind):
        e = pkg.exports[ref - 1]
        r = Reader(pkg.data, pkg.big_endian, e.offset)
        r.i32()  # net index
        r.take(8)  # tagged properties: None
        r.i32()  # next field
        r.i32()  # array dimension
        flags = r.u64()
        if flags & CPF_NET:
            r.u16()  # replication offset
        target = ''
        if kind in ('ByteProperty', 'ObjectProperty', 'ComponentProperty', 'ClassProperty', 'StructProperty',
                    'InterfaceProperty'):
            ref_to = r.i32()
            if kind == 'ClassProperty':
                ref_to = r.i32()  # the meta class
            target = pkg.object_name(ref_to) if ref_to and pkg.valid_ref(ref_to) else ''
        return PropDef(e.name, kind, target, None, flags)

    def find(self, owner, name):
        """The definition of property `name` of class or struct `owner` or its supers."""
        owner, name = owner.lower(), name.lower()
        seen = set()
        while owner and owner not in seen:
            seen.add(owner)
            d = self.props.get((owner, name))
            if d:
                return d
            owner = self.supers.get(owner, '')
        return None

    def is_a(self, class_name, base):
        class_name, base = class_name.lower(), base.lower()
        seen = set()
        while class_name and class_name not in seen:
            if class_name == base:
                return True
            seen.add(class_name)
            class_name = self.supers.get(class_name, '')
        return False


# Structs serialized as raw values rather than tagged properties.
NATIVE_STRUCTS = {
    'vector': ('fff', ('X', 'Y', 'Z')),
    'rotator': ('iii', ('Pitch', 'Yaw', 'Roll')),
    'vector2d': ('ff', ('X', 'Y')),
    'vector4': ('ffff', ('X', 'Y', 'Z', 'W')),
    'plane': ('ffff', ('X', 'Y', 'Z', 'W')),
    'quat': ('ffff', ('X', 'Y', 'Z', 'W')),
    'linearcolor': ('ffff', ('R', 'G', 'B', 'A')),
    'guid': ('IIII', ('A', 'B', 'C', 'D')),
    'intpoint': ('ii', ('X', 'Y')),
    'sphere': ('ffff', ('X', 'Y', 'Z', 'W')),
}


class Properties:
    """Decodes tagged properties. Values: numbers, strings, names, object
    references as path strings ('Package.Group.Name', or None), structs as
    dicts, arrays as lists; what can't be decoded stays as {'hex': ...}."""

    def __init__(self, pkg, schema=None):
        self.pkg = pkg
        self.schema = schema or Schema()

    def ref(self, value):
        if value == 0 or not self.pkg.valid_ref(value):
            return None
        return self.pkg.full_path(value)

    def read_tagged(self, r, owner, end):
        out = {}
        while r.pos < end:
            name = self.pkg.read_name(r)
            if name == 'None':
                break
            kind = self.pkg.read_name(r)
            size, index = r.i32(), r.i32()
            extra = ''
            if kind == 'StructProperty':
                extra = self.pkg.read_name(r)
            elif kind == 'BoolProperty':
                value = bool(r.u8())
            elif kind == 'ByteProperty':
                extra = self.pkg.read_name(r)
            if kind != 'BoolProperty':
                start = r.pos
                try:
                    value = self.value(Reader(r.data, r.big, start), kind, size, owner, name, extra)
                except (EOFError, ValueError, IndexError, UnicodeDecodeError):
                    value = {'hex': r.data[start:start + size].hex()}
                r.pos = start + size
            key = name if index == 0 else f'{name}[{index}]'
            if index and name in out and not isinstance(out.get(f'{name}[0]'), type(None)):
                out.setdefault(f'{name}[0]', out[name])
            out[key] = value
        return out

    def value(self, r, kind, size, owner, name, extra=''):
        if kind == 'IntProperty':
            return r.i32()
        if kind == 'FloatProperty':
            return round(r.f32(), 6)
        if kind == 'NameProperty':
            return self.pkg.read_name(r)
        if kind == 'StrProperty':
            return r.fstring()
        if kind in ('ObjectProperty', 'ClassProperty', 'ComponentProperty', 'InterfaceProperty'):
            return self.ref(r.i32())
        if kind == 'ByteProperty':
            return self.pkg.read_name(r) if size == 8 else r.u8()
        if kind == 'DelegateProperty':
            return {'object': self.ref(r.i32()), 'function': self.pkg.read_name(r)}
        if kind == 'StructProperty':
            return self.struct(r, extra, r.pos + size)
        if kind == 'ArrayProperty':
            d = self.schema.find(owner, name)
            return self.array(r, d.inner if d else None, r.pos + size)
        return {'hex': r.take(size).hex()}

    def struct(self, r, struct_name, end):
        native = NATIVE_STRUCTS.get(struct_name.lower())
        if native:
            return dict(zip(native[1], (round(v, 6) if isinstance(v, float) else v for v in r.unpack(native[0]))))
        if struct_name.lower() == 'color':
            b, g, red, a = r.take(4)
            return {'R': red, 'G': g, 'B': b, 'A': a}
        if self._looks_tagged(r):
            return self.read_tagged(r, struct_name, end)
        return self.raw_struct(r, struct_name, end)

    def _looks_tagged(self, r):
        """A tagged property list starts with a name, then (unless it's None) a *Property type."""
        if r.pos + 8 > len(r.data):
            return False
        index, number = struct.unpack_from(r.e + 'ii', r.data, r.pos)
        if not 0 <= index < len(self.pkg.names) or number < 0:
            return False
        if self.pkg.names[index] == 'None':
            return True
        if r.pos + 16 > len(r.data):
            return False
        kind = struct.unpack_from(r.e + 'i', r.data, r.pos + 8)[0]
        return 0 <= kind < len(self.pkg.names) and self.pkg.names[kind].endswith('Property')

    def raw_struct(self, r, struct_name, end):
        """A struct cooked as its members' raw values, in declaration order."""
        layout = self._layout(struct_name)
        if not layout:
            return {'hex': r.take(max(end - r.pos, 0)).hex()}
        out = {}
        for d in layout:
            if d.flags & (CPF_NATIVE | CPF_TRANSIENT):
                continue
            out[d.name] = self.item(r, d, end)
        return out

    def _layout(self, struct_name):
        layout, name, seen = [], struct_name.lower(), set()
        chain = []
        while name and name not in seen:
            seen.add(name)
            chain.append(name)
            name = self.schema.supers.get(name, '')
        for name in reversed(chain):
            layout += self.schema.layouts.get(name, [])
        return layout

    def item(self, r, d, end):
        """One value of property definition `d` without a tag (array elements, raw struct members)."""
        if d.kind == 'BoolProperty':
            return bool(r.u8())
        if d.kind == 'ByteProperty':
            return r.u8()
        if d.kind == 'StructProperty':
            return self.struct(r, d.target, end)
        if d.kind == 'ArrayProperty':
            return self.array(r, d.inner, end)
        return self.value(r, d.kind, 0, '', d.name)

    def array(self, r, inner, end):
        count = r.i32()
        if count < 0 or count > 1_000_000:
            raise ValueError('bad array count')
        if inner is None:
            return {'count': count, 'hex': r.take(max(end - r.pos, 0)).hex()}
        return [self.item(r, inner, end) for _ in range(count)]


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('package', type=Path)
    ap.add_argument('--exports', action='store_true', help='list every export with its class')
    ap.add_argument('--object', help="print an export's properties (its name or path) as JSON")
    ap.add_argument('--scripts', type=Path, help='folder of the unpacked script packages (default: the package\'s own)')
    args = ap.parse_args(argv)
    pkg = Package.open(args.package)
    print(f'{args.package.name}: version {pkg.version}/{pkg.licensee}, engine {pkg.engine}, '
          f'{"big" if pkg.big_endian else "little"}-endian, {len(pkg.names)} names, '
          f'{len(pkg.imports)} imports, {len(pkg.exports)} exports')
    if args.exports:
        for i in range(1, len(pkg.exports) + 1):
            print(f'{i:6} {pkg.class_name(i):32} {pkg.path_of(i)}')
    if args.object:
        schema = Schema.load(args.scripts or args.package.parent)
        for ref in pkg.find(args.object):
            print(json.dumps({'object': pkg.full_path(ref), 'class': pkg.class_name(ref),
                              'properties': pkg.properties(ref, schema)}, indent=1))
    return 0


if __name__ == '__main__':
    sys.exit(main())
