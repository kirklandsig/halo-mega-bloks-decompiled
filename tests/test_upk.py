import json
import os
import struct
from pathlib import Path

import pytest

import map_export
import upk
from upkbuild import Builder

PROP_FLAGS = 1  # CPF_Edit


def class_data(super_ref, child=0):
    return struct.pack('>iiii', 0, 0, super_ref, child)


def prop_data(b, extra=b''):
    return struct.pack('>i', 0) + b.fname('None') + struct.pack('>iiQ', 0, 1, PROP_FLAGS) + extra


def script_package():
    """Core.xxx: Object > Actor > StaticMeshActor, Object > Component > StaticMeshComponent,
    and Actor's `array<name> Layers` (so an array's element type has to come from here)."""
    b = Builder()
    b.add_import('Core', 'Class', 0, 'Class')
    obj = b.add_export(0, 0, 'Object')
    actor = b.add_export(0, 0, 'Actor')
    sma = b.add_export(0, 0, 'StaticMeshActor')
    comp = b.add_export(0, 0, 'Component')
    smc = b.add_export(0, 0, 'StaticMeshComponent')
    array_class = b.add_import('Core', 'Class', 0, 'ArrayProperty')
    name_class = b.add_import('Core', 'Class', 0, 'NameProperty')
    layers = b.add_export(array_class, actor, 'Layers', prop_data(b))
    b.add_export(name_class, layers, 'Layers', prop_data(b))
    b.set_data(obj, class_data(0))
    b.set_data(actor, class_data(obj, layers))
    b.set_data(sma, class_data(actor))
    b.set_data(comp, class_data(obj))
    b.set_data(smc, class_data(comp))
    b.add_export(actor, 0, 'Default__Actor', struct.pack('>i', 0) + b.tag('DrawScale', 'FloatProperty', struct.pack('>f', 1.0)) + b.end())
    return b.build()


def map_package():
    b = Builder()
    core = b.add_import('Core', 'Package', 0, 'Core')
    engine = b.add_import('Core', 'Package', 0, 'Engine')
    world_class = b.add_import('Core', 'Class', engine, 'World')
    level_class = b.add_import('Core', 'Class', engine, 'Level')
    actor_class = b.add_import('Core', 'Class', core, 'StaticMeshActor')
    comp_class = b.add_import('Core', 'Class', core, 'StaticMeshComponent')
    package_class = b.add_import('Core', 'Class', core, 'Package')
    mesh_class = b.add_import('Core', 'Class', engine, 'StaticMesh')
    world = b.add_export(world_class, 0, 'TheWorld')
    level = b.add_export(level_class, world, 'PersistentLevel')
    meshes = b.add_export(package_class, 0, 'Meshes')
    rock = b.add_export(mesh_class, meshes, 'Rock')
    actor = b.add_export(actor_class, level, 'StaticMeshActor_0')
    component = b.add_export(comp_class, actor, 'StaticMeshComponent_0')
    b.set_data(actor, struct.pack('>i', 7)
               + b.tag('Location', 'StructProperty', struct.pack('>fff', 1.5, -2.0, 3.0), 'Vector')
               + b.tag('Rotation', 'StructProperty', struct.pack('>iii', 0, 16384, 0), 'Rotator')
               + b.tag('DrawScale', 'FloatProperty', struct.pack('>f', 2.0))
               + b.tag('Tag', 'NameProperty', b.fname('Boulder'))
               + b.tag('Layers', 'ArrayProperty', struct.pack('>i', 2) + b.fname('Rocks') + b.fname('Jungle'))
               + b.bool_tag('bHidden', True)
               + b.tag('StaticMeshComponent', 'ObjectProperty', struct.pack('>i', component))
               + b.end())
    b.set_data(component, struct.pack('>ii', 0, 8) + b.tag('StaticMesh', 'ObjectProperty', struct.pack('>i', rock)) + b.end())
    return b.build()


@pytest.fixture
def folder(tmp_path):
    (tmp_path / 'Core.xxx').write_bytes(script_package())
    (tmp_path / 'TestMap.xxx').write_bytes(map_package())
    return tmp_path


def test_tables(folder):
    pkg = upk.Package.open(folder / 'TestMap.xxx')
    assert (pkg.version, pkg.engine, pkg.big_endian) == (863, 10246, True)
    actor = pkg.find('StaticMeshActor_0')[0]
    assert pkg.class_name(actor) == 'StaticMeshActor'
    assert pkg.path_of(actor) == 'TheWorld.PersistentLevel.StaticMeshActor_0'
    assert pkg.full_path(actor) == 'TestMap.TheWorld.PersistentLevel.StaticMeshActor_0'
    assert pkg.full_path(pkg.find('Rock')[0]) == 'Meshes.Rock'  # a seek-free copy keeps its own path


def test_schema_and_properties(folder):
    schema = upk.Schema.load(folder)
    assert schema.is_a('StaticMeshActor', 'Actor') and schema.is_a('StaticMeshComponent', 'Component')
    assert schema.find('StaticMeshActor', 'Layers').inner.kind == 'NameProperty'
    assert schema.defaults('StaticMeshActor')['DrawScale'] == 1.0
    pkg = upk.Package.open(folder / 'TestMap.xxx')
    props = pkg.properties(pkg.find('StaticMeshActor_0')[0], schema)
    assert props['Location'] == {'X': 1.5, 'Y': -2.0, 'Z': 3.0}
    assert props['Rotation'] == {'Pitch': 0, 'Yaw': 16384, 'Roll': 0}
    assert props['Tag'] == 'Boulder' and props['bHidden'] is True
    assert props['Layers'] == ['Rocks', 'Jungle']


def test_map_export(folder, tmp_path_factory):
    out = tmp_path_factory.mktemp('maps')
    assert map_export.main(['--packages', str(folder), '--out', str(out)]) == 0
    result = json.loads((out / 'TestMap.json').read_text())
    (actor,) = result['actors']
    assert actor['class'] == 'StaticMeshActor' and actor['location'] == [1.5, -2.0, 3.0]
    assert actor['rotation_degrees'] == {'pitch': 0.0, 'yaw': 90.0, 'roll': 0.0}
    assert actor['scale'] == 2.0 and actor['scale_3d'] == [1.0, 1.0, 1.0]
    assert actor['assets'] == ["StaticMesh'Meshes.Rock'"]
    assert actor['components'][0]['properties'] == {'StaticMesh': 'Meshes.Rock'}


def test_matrix_transform():
    m = {'XPlane': {'X': 0.0, 'Y': 2.0, 'Z': 0.0}, 'YPlane': {'X': -2.0, 'Y': 0.0, 'Z': 0.0},
         'ZPlane': {'X': 0.0, 'Y': 0.0, 'Z': 2.0}, 'WPlane': {'X': 1.0, 'Y': 2.0, 'Z': 3.0}}
    location, rotation, scale = map_export.matrix_transform(m)
    assert location == [1.0, 2.0, 3.0] and rotation == {'Pitch': 0, 'Yaw': 16384, 'Roll': 0} and scale == [2.0] * 3


def test_out_inside_repo_refused(folder):
    with pytest.raises(SystemExit):
        map_export.main(['--packages', str(folder), '--out', str(Path(map_export.paths.ROOT) / 'build' / 'maps')])


def test_compressed_package_refused():
    b = Builder()
    b.compressed = True
    with pytest.raises(ValueError, match='decompress'):
        upk.Package.parse(b.build())


@pytest.mark.skipif(not os.environ.get('HAGGAR_PACKAGES'), reason='needs the unpacked cooked packages (HAGGAR_PACKAGES)')
def test_real_maps(tmp_path):
    """Every map of your own copy exports, and every actor has a placement."""
    assert map_export.main(['--packages', os.environ['HAGGAR_PACKAGES'], '--out', str(tmp_path)]) == 0
    maps = list(tmp_path.glob('*.json'))
    assert maps
    for path in maps:
        for actor in json.loads(path.read_text())['actors']:
            assert len(actor['location']) == 3 and set(actor['rotation']) == {'pitch', 'yaw', 'roll'}
