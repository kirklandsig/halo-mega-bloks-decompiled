"""Export a map's actor placements to JSON, from your own copy of the game.

    python tools/map_export.py --packages <unpacked folder> --out <folder> [map ...]

<unpacked folder> holds the game's cooked packages unpacked with Gildor's
Unreal Package Decompressor (`decompress -lzx`), the script packages
(Core.xxx ... MegaHaloGame.xxx) among them: they give the class hierarchy,
property types and class defaults. With no map named, every package with a
level in the folder is exported. Each map becomes <out>/<map>.json:

    {"package", "engine", "actors": [...], "streaming_levels": [...]}

An actor is {"name", "class", "archetype", "location" [x, y, z],
"rotation" {"pitch", "yaw", "roll"} in Unreal units (65536 a turn),
"rotation_degrees", "scale" (DrawScale), "scale_3d", "properties" (its own
values, decoded), "components" [{"name", "class", "properties"}], "assets"
[Class'Package.Group.Name']}. Cooking merges static mesh actors into
StaticMeshCollectionActors; each of their components comes out as its own
"StaticMeshActor" entry, with "collection" naming the actor it was merged
into; lights merged into StaticLightCollectionActors come out the same way,
placed by their matrix. Asset references are object paths (package, groups,
name): export the meshes and textures themselves with umodel
(`umodel -export -out=<dir> <map package>`; seek-free maps carry copies of
what they use) and match its files by those paths.

The output stays out of the repository: --out has to be outside it.
"""
import argparse
import json
import math
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import paths  # noqa: E402
import upk  # noqa: E402

TURN = 65536
ROTATOR = ('Pitch', 'Yaw', 'Roll')


def units(rotation):
    return {k.lower(): rotation.get(k, 0) for k in ROTATOR}


def degrees(rotation):
    return {k.lower(): round(rotation.get(k, 0) * 360.0 / TURN, 4) for k in ROTATOR}


def vec(v, default):
    return [v.get(k, d) for k, d in zip(('X', 'Y', 'Z'), default)] if isinstance(v, dict) else list(default)


class AssetDecoder(upk.Properties):
    """Properties that also note every asset (an object outside the level) they refer to."""

    def __init__(self, pkg, schema, level):
        super().__init__(pkg, schema)
        self.level = level
        self.assets = set()

    def ref(self, value):
        path = super().ref(value)
        if path is not None and not self._in_level(value):
            self.assets.add(f"{self.pkg.class_name(value)}'{path}'")
        return path

    def _in_level(self, ref):
        while ref > 0:
            if ref == self.level:
                return True
            ref = self.pkg.exports[ref - 1].outer
        return False


def export_map(pkg, schema):
    """{'package', 'engine', 'actors', 'streaming_levels'} for one map package."""
    levels = [i for i in range(1, len(pkg.exports) + 1) if pkg.class_name(i) == 'Level']
    out = {'package': pkg.path.stem, 'engine': pkg.engine, 'actors': [], 'streaming_levels': []}
    children = {}
    for i, e in enumerate(pkg.exports, 1):
        children.setdefault(e.outer, []).append(i)
    for level in levels:
        for ref in children.get(level, []):
            cls = pkg.class_name(ref)
            if not schema.is_a(cls, 'Actor'):
                continue
            if cls in ('StaticMeshCollectionActor', 'StaticLightCollectionActor'):
                out['actors'] += collection_entries(pkg, schema, level, ref, children)
            else:
                out['actors'].append(actor_entry(pkg, schema, level, ref, children))
    for ref in range(1, len(pkg.exports) + 1):
        cls = pkg.class_name(ref)
        if schema.is_a(cls, 'LevelStreaming'):
            props = safe_properties(pkg, ref, schema)
            out['streaming_levels'].append({'name': pkg.object_name(ref), 'class': cls,
                                            'package': props.get('PackageName'), 'properties': props})
    return out


def safe_properties(pkg, ref, schema, decoder=None):
    try:
        return pkg.properties(ref, schema, decoder)
    except (EOFError, ValueError, IndexError, struct.error):
        return {}


def actor_entry(pkg, schema, level, ref, children):
    cls = pkg.class_name(ref)
    decoder = AssetDecoder(pkg, schema, level)
    props = safe_properties(pkg, ref, schema, decoder)
    defaults = schema.defaults(cls)
    rotation = props.get('Rotation') or defaults.get('Rotation') or {}
    components = []
    for child in children.get(ref, []):
        if schema.is_a(pkg.class_name(child), 'Component'):
            components.append({'name': pkg.object_name(child), 'class': pkg.class_name(child),
                               'properties': safe_properties(pkg, child, schema, decoder)})
    archetype = pkg.exports[ref - 1].archetype
    return {
        'name': pkg.object_name(ref),
        'class': cls,
        'archetype': pkg.full_path(archetype) if archetype else None,
        'location': vec(props.get('Location'), (0.0, 0.0, 0.0)),
        'rotation': units(rotation),
        'rotation_degrees': degrees(rotation),
        'scale': props.get('DrawScale', defaults.get('DrawScale', 1.0)),
        'scale_3d': vec(props.get('DrawScale3D') or defaults.get('DrawScale3D'), (1.0, 1.0, 1.0)),
        'properties': props,
        'components': components,
        'assets': sorted(decoder.assets),
    }


def matrix_transform(m):
    """(location, rotation in Unreal units, scale 3D) of a cooked LocalToWorld-style matrix."""
    rows = [[m[p].get(k, 0.0) for k in ('X', 'Y', 'Z')] for p in ('XPlane', 'YPlane', 'ZPlane', 'WPlane')]
    scale = [round(math.sqrt(sum(v * v for v in row)), 6) or 1.0 for row in rows[:3]]
    x, y, z = ([v / s for v in row] for row, s in zip(rows[:3], scale))
    to_units = TURN / (2 * math.pi)
    pitch = math.atan2(x[2], math.hypot(x[0], x[1]))
    yaw = math.atan2(x[1], x[0])
    side = (-math.sin(yaw), math.cos(yaw), 0.0)  # the Y axis of (pitch, yaw, 0)
    roll = math.atan2(sum(a * b for a, b in zip(z, side)), sum(a * b for a, b in zip(y, side)))
    rotation = {'Pitch': round(pitch * to_units), 'Yaw': round(yaw * to_units), 'Roll': round(roll * to_units)}
    return rows[3], rotation, scale


def collection_entries(pkg, schema, level, ref, children):
    """One actor per component the cooker merged into a StaticMeshCollectionActor
    (a StaticMeshActor, placed by the component's Translation, Rotation and
    Scale3D) or a StaticLightCollectionActor (a light, placed by its matrix)."""
    entries = []
    lights = pkg.class_name(ref) == 'StaticLightCollectionActor'
    for child in children.get(ref, []):
        cls = pkg.class_name(child)
        if not schema.is_a(cls, 'LightComponent' if lights else 'StaticMeshComponent'):
            continue
        decoder = AssetDecoder(pkg, schema, level)
        props = safe_properties(pkg, child, schema, decoder)
        name = pkg.object_name(child)
        if lights:
            matrix = props.get('CachedParentToWorld')
            location, rotation, scale_3d = matrix_transform(matrix) if isinstance(matrix, dict) else ([0.0] * 3, {}, [1.0] * 3)
            actor_class, actor_name = cls.replace('Component', ''), name[:-3] if name.endswith('_LC') else name
        else:
            location = vec(props.get('Translation'), (0.0, 0.0, 0.0))
            rotation = props.get('Rotation') or {}
            scale_3d = vec(props.get('Scale3D'), (1.0, 1.0, 1.0))
            actor_class, actor_name = 'StaticMeshActor', name.replace('_SMC_', '_')
        entries.append({
            'name': actor_name,
            'class': actor_class,
            'collection': pkg.object_name(ref),
            'archetype': None,
            'location': location,
            'rotation': units(rotation),
            'rotation_degrees': degrees(rotation),
            'scale': props.get('Scale', 1.0),
            'scale_3d': scale_3d,
            'properties': {},
            'components': [{'name': name, 'class': cls, 'properties': props}],
            'assets': sorted(decoder.assets),
        })
    return entries


def open_map(path):
    """The package at `path` if it holds a level, else None."""
    try:
        pkg = upk.Package.open(path)
    except (ValueError, OSError, EOFError):
        return None
    return pkg if any(pkg.class_name(i) == 'Level' for i in range(1, len(pkg.exports) + 1)) else None


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--packages', type=Path, required=True, help='folder of unpacked packages (with the script packages)')
    ap.add_argument('--out', type=Path, required=True, help='output folder, outside the repository')
    ap.add_argument('maps', nargs='*', help='map package names (default: every package with a level)')
    args = ap.parse_args(argv)
    out = args.out.resolve()
    if out == paths.ROOT or paths.ROOT in out.parents:
        ap.error('--out must be outside the repository: what it writes comes from the game files')
    paths.require(args.packages)
    schema = upk.Schema.load(args.packages)
    if not schema.supers:
        ap.error(f'no script packages (Core.xxx, Engine.xxx, ...) in {args.packages}')
    names = args.maps or sorted(p.stem for p in args.packages.glob('*.xxx') if p.stem not in upk.SCRIPT_PACKAGES)
    out.mkdir(parents=True, exist_ok=True)
    written = 0
    for name in names:
        path = args.packages / (name if name.endswith('.xxx') else f'{name}.xxx')
        pkg = open_map(path)
        if pkg is None:
            if args.maps:
                print(f'{path.name}: no level in it', file=sys.stderr)
            continue
        result = export_map(pkg, schema)
        (out / f'{pkg.path.stem}.json').write_text(json.dumps(result, indent=1), encoding='utf-8')
        print(f'{pkg.path.stem}: {len(result["actors"])} actors')
        written += 1
    print(f'{written} maps written to {out}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
