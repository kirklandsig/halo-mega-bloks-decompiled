Decompilation and native PC port of Project Haggar, the cancelled Halo Mega Bloks game (n-Space, Xbox 360, Unreal Engine 3).

# Halo Mega Bloks (Project Haggar) decompilation

**Project Haggar** is the Halo Mega Bloks game (also spelled "Halo Mega
Blocks") that n-Space developed for the Xbox 360 on Unreal Engine 3 (the UDK
July 2012 BETA 2 engine) until 343 Industries cancelled it in 2013. This
project studies a development build of it and rebuilds it from source, so it
can run natively on PC and, eventually, on an Anbernic handheld. It is an
independent, non-commercial preservation project, not affiliated with or
endorsed by Microsoft, 343 Industries, n-Space, Mega Brands or Epic Games.

## Goal

A proper decomp of the game's own code and scripts, as the foundation for
people to read and mod the game, play it natively (a PC port, later an
Anbernic handheld), and eventually finish it or keep building it: a rebuild
as a UDK July 2012 BETA 2 project with an editor (Phase 5), and possibly a
remake in a modern Unreal Engine by others. The repository ships no assets;
everyone uses their own copy of the build.

"Proper" covers three things:

1. **n-Space's native C++:** the `nspace` rows, 2,061 functions and 248,492
   bytes, matched byte for byte. Progress is measured in bytes. They include
   the CCS layer: Autodesk Gameware Cognition's reference integration with
   UE3, which n-Space extended into the game's AI.
2. **The UnrealScript classes,** compiling with UDK's compiler: every
   decompiler error is fixed, and the compiler checks the scripts as far as
   stock UDK can load n-Space's changes to its native classes
   ([docs/PROGRESS.md](docs/PROGRESS.md)).
3. **Documented data formats and extraction tools**
   ([docs/FORMATS.md](docs/FORMATS.md)), including a level-layout (actor
   placement) exporter that runs on your own copy; its output is never
   committed.

It doesn't cover the engine (UDK supplies it; a remake would use UE5's),
middleware and Xbox libraries (third-party, not game-specific), or Epic's
UDKBase and GameFramework code (UDK ships the same). The PC port statically
recompiles all of that, so it runs without being decompiled.

The scope checks are done: Grip, the behaviour-tree system n-Space's AI uses,
is Autodesk Gameware's middleware and stays out; the 159 functions n-Space
added to Epic's classes (the CCS pawn interface on UDKPawn and its kin) are in,
and so is the whole CCS layer (644 more functions, 99,024 bytes).

Now: the leftover near and todo functions. Then Phase 4 (the handheld) and Phase 5 (the UDK rebuild).

## What this is

Three tracks, one goal: the game running natively.

1. **Native port (the deliverable).** A static recompilation of the whole
   executable (the ReXGlue SDK's codegen) plus its runtime, which is Xenia's
   kernel, GPU and audio without the JIT; later, a native renderer for
   handhelds. See [docs/PORTING.md](docs/PORTING.md).
2. **n-Space's C++, decompiled to match.** Each function is rebuilt with the
   original compiler (XDK 21076, `cl` 16.00.11886) and the build's own flags,
   and must produce the same bytes. Matched functions can replace their
   recompiled versions in the port. Epic's engine code is not hand-decompiled.
3. **UnrealScript.** The game's script classes, decompiled from its cooked
   packages, in [script/](script/).

The handheld goal: an Anbernic device, chosen by profiling the PC build.

## Status

**2,016 of n-Space's 2,061 functions match** byte for byte (87% of the
bytes). Phase 3 finished the original scope; the CCS layer, brought in since
(644 functions), is all written (613 of its 644 match), and
matched code can replace its recompiled version in the port. Phase 2
made **the recompiled build run natively on Windows x86-64, from boot to the
first level** (11 to 16 fps on an integrated GPU), and it builds on Linux.
The results are in `docs/specs/phase2-baseline.md`,
`docs/specs/phase3-port-swap.md` and `docs/specs/phase0-results.md`.

| | |
| --- | --- |
| Inventory | 237,168 functions (215,944 from the PDB's procedures, 21,224 library functions with only a public symbol), 2,295 objects |
| n-Space's C++ | 2,061 functions (248,492 bytes) in scope: **2,016 matched** (218,180 bytes, 87%), 30 near, 15 todo |
| Native port | Windows: boots to the first level, playable with the build's own known issues. Linux: builds, and starts UE3 on a software Vulkan device |
| Recompilation | 237,162 functions, 345 jump tables, no unimplemented instruction; 506 files compile in about 6 minutes |
| UnrealScript | 2,597 classes export; the 758 that are n-Space's own or modified from UDK are committed, with every decompiler error fixed, and UDK's compiler checks them as far as stock UDK allows |
| Data formats | Package and map formats documented; `tools/map_export.py` exports every map's actor placements (250 maps on this build) from your own copy |

Details: [docs/PROGRESS.md](docs/PROGRESS.md). Matching progress is charted on
[ByteMatch](https://bytematch.dev/kirklandsig/halo-mega-bloks-decompiled).

## What this repository does not contain

No game files: no executable, no symbols, no cooked packages, audio or
movies. No Xbox 360 SDK files. No UDK files, and none of the 1,839 script
classes that are identical to UDK July 2012 BETA 2's. Nothing extracted from
any of them. What is here is the contributors' own work plus facts derived
from the build (names, types, addresses, compiler flags).

## What you need

- **Your own copy of the build's files**, which you supply yourself:
  `MegaHaloGame.xex` and `MegaHaloGame.pdb` in `orig/` (or point `HAGGAR_XEX`
  and `HAGGAR_PDB` at them), and the cooked packages for the script tools.
- **For matching:** XDK 21076, whose `bin\win32\cl.exe` is version
  16.00.11886. Point `XDK_DIR` at it. The project does not distribute it.
- **Python 3**, then `pip install -r requirements-dev.txt`. The script
  exporter also needs the .NET 8 SDK.
- **For the script compile check:** a UDK July 2012 BETA 2 install, used in
  place (`python tools/udk_compile.py --udk <install>`). **For the format
  tools:** the cooked packages unpacked with Gildor's decompressor
  (`decompress -lzx`).

Analysis, documentation, script review and the tests don't need any of it:
tests that need the build's files skip without them.

## Build and check

```
python tools/xex.py -o orig/MegaHaloGame.exe --decrypted orig/MegaHaloGame.dec.xex
python tools/check.py src/UDKBase/Src/HaloRBTKamikaze.cpp
python -m pytest -q
```

| Tool | What it does |
| --- | --- |
| `tools/inventory.py` | Writes `config/functions/` and `config/objects.csv` from the PDB; `read_functions()` loads the inventory for every tool |
| `tools/xex.py` | Unpacks the XEX into its PE image (the basefile), and a decrypted copy for XenonRecomp |
| `tools/pdbtype.py <Name>` | Prints a type from the PDB as a C++ declaration with member offsets |
| `tools/check.py <src...>` | Compiles sources with their object's flags and compares every `// @retail` function with retail; writes `config/status.csv` |
| `tools/recomp_config.py` | Writes the XenonRecomp config into `build/recomp/` |
| `tools/script_export` | Exports a cooked package's script classes as `.uc` (dotnet) |
| `tools/script_compare.py` | Compares exported classes with UDK's, writes `config/script_classes.csv` |
| `tools/udk_compile.py` | Compiles the committed scripts with a local UDK July 2012 BETA 2 and fixes the decompiler artifacts it reports (`--fix`) |
| `tools/upk.py` | Reads an unpacked cooked package: tables, object paths, any object's properties as JSON |
| `tools/map_export.py` | Writes each map's actor placements (class, transform, properties, assets) to JSON, outside the repository |
| `tools/decomp_dev_export.py` | Writes the [ByteMatch](https://bytematch.dev/kirklandsig/halo-mega-bloks-decompiled) progress report (docs/BYTEMATCH.md) |
| `tools/prepublish.py` | Checks the tree for leaks before anything is pushed |

## How to help

Start with [docs/START_HERE.md](docs/START_HERE.md): setup, claiming work on
the pinned [Active claims](https://github.com/kirklandsig/halo-mega-bloks-decompiled/issues/1)
issue, and a prompt you can paste into an AI coding agent. Then
[CONTRIBUTING.md](CONTRIBUTING.md) and [docs/DECOMPILING.md](docs/DECOMPILING.md).
Script review, naming and documenting game systems need no SDK.

## FAQ

**Can I play the cancelled Halo Mega Bloks game?**
On Windows, yes, if you have your own copy of the build's files (this
repository contains none): build the port with
[docs/PORTING.md](docs/PORTING.md). It reaches the first level, with the
build's own known issues (it is a development build).

**Is this the Halo Mega Blocks game I've heard about?**
Yes: Project Haggar, the Mega Bloks Halo game n-Space made for the Xbox 360.

**Why decompile instead of just recompiling?**
The recompilation is what makes it run. The decompiled C++ and the scripts
are the readable, moddable layer on top.

**Does it use leaked Unreal Engine source?**
No. The engine is not hand-decompiled; it is recompiled from the build.

## Credits

Tools used, each under its own license:
- [ReXGlue SDK](https://github.com/rexglue/rexglue-sdk) (BSD), the
  recompiler and runtime the port is built on.
- [XenonRecomp](https://github.com/hedge-dev/XenonRecomp) (MIT), for the
  Phase 0 recompilation, and the basis of ReXGlue's translations.
- [Xenia](https://github.com/xenia-project/xenia) (BSD), the reference for the
  XEX format, and the source of ReXGlue's runtime.
- [UELib](https://github.com/EliotVU/Unreal-Library) (MIT), for the script
  export.
- [UModel / UE Viewer](https://github.com/gildor2/UEViewer) and its package
  decompressor, by Gildor, for unpacking cooked packages.

### The community

Everyone whose work is merged is listed here.

- kirklandsig (maintainer)

## License

[CC0 1.0](LICENSE). It covers only the contributors' own work in this
repository. The game, the engine, the SDK and the tools above belong to their
owners.
