# Data formats

What the build's cooked content looks like, as far as the tools here read it,
and how to get placements and assets out of your own copy. Everything below
was checked against this build (Xbox 360, UE3 package version 863/0, engine
10246, cooker 136). Nothing extracted from the game is in this repository,
and the tools refuse to write into it.

## The cooked folder

`MegaHaloGame/CookedXbox360/` holds:

| Files | What they are |
| --- | --- |
| `*.xxx` (273) | Cooked packages: the 13 script packages (Core ... MegaHaloGame), `Startup`, the maps and their streaming sublevels, and a few content packages |
| `*.xxx.uncompressed_size` | The size of a fully compressed package once unpacked (script packages, Startup and their `_LOC_INT` localizations) |
| `Textures.tfc`, `CharTextures.tfc`, `Lighting.tfc` | Texture file caches: the mip data of textures, character textures and light/shadow maps, which packages point into |
| `*.bnk`, `*.wem`, `*.txt`, `SoundbanksInfo.xml`, `PluginInfo.xml` | Wwise 2012.1 sound banks, streamed sounds and their listings |
| `Coalesced_INT.bin` | The ini files and English localization, coalesced |
| `GlobalPersistentCookerData.upk`, `GuidCache.xxx`, `GlobalShaderCache-Xbox360.bin` | Cooker bookkeeping and the global shaders |

## Packages

Big-endian on this platform (the tag `9E 2A 83 C1` reads as 0x9E2A83C1). Two
kinds of compression, both LZX:

- **Fully compressed** (script packages, Startup): the whole file is a UE3
  compressed chunk, a header (tag, block size 0x20000, compressed and
  uncompressed sizes, then one size pair per block) followed by the blocks.
- **Chunked** (maps): the package header is plain; `CompressionFlags` is 4
  (LZX) and a list of chunks (uncompressed offset and size, compressed offset
  and size) covers the rest.

Gildor's Unreal Package Decompressor unpacks both:
`decompress -lzx -out=<dir> <package>`. `tools/upk.py` reads the unpacked
files only, and says so when given a compressed one.

### Header

In order, for version 863: tag (u32), version (u32: file version in the low
16 bits, licensee 0), total header size, folder name (FString), package flags
(u32; maps have 0x00020000, contains a map), name count and offset, export
count and offset, import count and offset, depends offset, import/export GUID
offset and counts (3 × i32), thumbnail table offset, GUID (16 bytes),
generations (count, then export count, name count, net object count each),
engine version (10246), cooker version (136), compression flags, compressed
chunks (count, then four i32 each), package source (u32), additional packages
to cook (array of FString).

Strings (FString): an i32 length counting the terminating zero, then the
characters; a negative length means UTF-16.

### Tables

- **Name:** FString, then u64 flags. An FName elsewhere is two i32: the
  index into this table and a number (n > 0 appends `_n-1`). `None` is not
  always index 0.
- **Import:** class package (FName), class name (FName), outer (i32), object
  name (FName).
- **Export:** class, super and outer (i32 each), object name (FName),
  archetype (i32), object flags (u64), serial size and offset (i32), export
  flags (u32), net object counts (i32 count, then one per generation),
  package GUID (16 bytes), package flags (u32).

An object reference (i32) is 0 for none, n > 0 for export n (1-based) and
n < 0 for import -n. An object's path follows its outers:
`TheWorld.PersistentLevel.HaloPlayerSpawnPoint_0`.

### Object data

An export's bytes (at its serial offset) start with:

1. a **state frame** when the object flags have 0x0200000000000000 (an actor
   that can run state code): node, state node (i32 each), probe mask (u32),
   latent action (u16), pushed states (i32 count, then two i32 each) and, if
   the node isn't none, a code offset (i32);
2. for a **component**: the template owner class (i32) and, for a template
   (inside a `Default__` object), the template name (FName);
3. the **net index** (i32);
4. the **tagged properties**, ending with the name `None`;
5. then whatever the class serializes natively (light maps, mesh data, ...).

Classes, structs and properties (in the script packages) are laid out as:

| Object | After the net index |
| --- | --- |
| Class | next field, super class, first child (i32 each), then the rest of UClass |
| ScriptStruct | tagged properties (`None`), next field, super struct, first child, ... |
| *Property | tagged properties (`None`), next field (i32), array dimension (i32), property flags (u64), the replication offset (u16) only with CPF_Net (0x20), then what the kind refers to: the enum (ByteProperty), the class (ObjectProperty, ComponentProperty, InterfaceProperty), the class then the meta class (ClassProperty), the struct (StructProperty) |

Console cooking strips each property's category and array enum, which PC
packages have between the flags and the replication offset. An array's
element is a property object whose outer is the ArrayProperty. A class's
default values live in `Default__<Class>` in its script package; only values
that differ from the super class's defaults are stored.

### Tagged properties

A tag is: name (FName), type (FName: `IntProperty`, ...), size (i32), array
index (i32), then by type: the struct's name (FName) for StructProperty, the
value itself (one byte) for BoolProperty, the enum's name (FName, `None` for a
plain byte) for ByteProperty. The value follows (size bytes; none for a
bool):

| Type | Value |
| --- | --- |
| Int, Float | i32, f32 |
| Name | FName |
| Str | FString |
| Object, Class, Component, Interface | object reference |
| Byte | u8, or an FName (an enum value) when the size is 8 |
| Delegate | object reference, function name (FName) |
| Array | i32 count, then the elements without tags; their type isn't in the tag, it comes from the property's definition |
| Struct | either tagged properties of the struct, or its raw members |

Raw structs: Vector (3 f32), Rotator (3 i32: pitch, yaw, roll; 65536 is a
turn), Vector2D, Vector4, Quat, LinearColor (f32 each), Guid (4 u32), IntPoint,
Color (4 bytes: B, G, R, A), Plane (4 f32, **W first** in this build), and
Matrix (four Planes; the fourth's X, Y, Z are the translation). Other
`immutablewhencooked` structs are their members in declaration order, each
serialized on its own (a bool as one byte), skipping native and transient
members. `tools/upk.py` tells the two struct forms apart by whether the data
starts like a tag.

## Maps

A map package has a World (`TheWorld`) with a `PersistentLevel`; the level's
actors are the exports whose outer is the level, and each actor's components
are the exports whose outer is the actor. Maps are seek-free: a map carries
copies of the meshes, materials and textures it uses, under Package objects
named after their source packages (`WhiteBoxJPM.SuperRocks.JungleRockA`),
with the mip data in the texture caches.

The game streams its levels: `VerticalSlicePersistent` (the persistent map)
holds LevelStreaming objects naming the sublevels (`2_1C_wb_Swamp`,
`2_2C_ai_PodA`, ...). The sublevel names carry a cluster (`1C`, `2C`, `3C`)
and a prefix for the designers' split of the work (`wb`, `ai`, `ds`, `mi`,
`ci`, `nav`, `au`, ...).

The cooker merges static geometry: StaticMeshActors become components of a
StaticMeshCollectionActor (each component keeps its world `Translation`,
`Rotation` and `Scale3D`, and is named `StaticMeshActor_SMC_<n>`), and static
lights become components of a StaticLightCollectionActor (placed by their
`CachedParentToWorld` matrix).

Not covered yet: BSP geometry (Model, Polys), landscape height data, navmesh
data (GwNavNavdata), light and shadow map contents, and Kismet sequences
(their objects are in the export table, under `Main_Sequence`).

## Tools

```
decompress -lzx -out=<unpacked> <CookedXbox360>/<package>.xxx    (each package)
python tools/upk.py <unpacked>/<package>.xxx --exports
python tools/upk.py <unpacked>/<package>.xxx --object <name or path>
python tools/map_export.py --packages <unpacked> --out <folder> [map ...]
umodel -export -out=<assets> <unpacked>/<map>.xxx
```

- `tools/upk.py` reads a package: the tables, object paths and any object's
  properties as JSON. Its Schema reads the script packages in the same folder
  for the class hierarchy, property types and class defaults.
- `tools/map_export.py` writes `<folder>/<map>.json` for every map (or the
  ones named): each actor's class, name, location, rotation (Unreal units and
  degrees), scale, its own properties, its components' properties and the
  assets it refers to (`StaticMesh'WhiteBoxJPM.SuperRocks.JungleRockA'`).
  Merged static meshes and lights come out as one actor each. The folder has
  to be outside the repository.
- [umodel](https://www.gildor.org/en/projects/umodel) exports the meshes,
  textures and animations themselves; match its files to the JSON's asset
  references by object path (package, groups, name).
