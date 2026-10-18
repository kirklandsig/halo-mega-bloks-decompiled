Decompilation and native PC port of Project Haggar, the cancelled Halo Mega Bloks game (n-Space, Xbox 360, Unreal Engine 3).

# Halo Mega Bloks (Project Haggar) decompilation

**Project Haggar** is the Halo Mega Bloks game (also spelled "Halo Mega
Blocks") that n-Space developed for the Xbox 360 on Unreal Engine 3 (the UDK
July 2012 BETA 2 engine) until 343 Industries cancelled it in 2013. This
project studies a development build of it and rebuilds it from source, so it
can run natively on PC and, eventually, on an Anbernic handheld. It is an
independent, non-commercial preservation project, not affiliated with or
endorsed by Microsoft, 343 Industries, n-Space, Mega Brands or Epic Games.

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

Phase 2 is done: **the recompiled build runs natively on Windows x86-64, from
boot to the first level** (11 to 16 fps on an integrated GPU), and it builds
on Linux. Phase 2's results are in `docs/specs/phase2-baseline.md`, and
Phase 0's in `docs/specs/phase0-results.md`.

| | |
| --- | --- |
| Inventory | 237,168 functions (215,944 from the PDB's procedures, 21,224 library functions with only a public symbol), 2,295 objects |
| n-Space's C++ | 1,258 functions in scope, **8 matched** (10 matched in total: Gate A matched 10 of 10) |
| Native port | Windows: boots to the first level, playable with the build's own known issues. Linux: builds, and starts UE3 on a software Vulkan device |
| Recompilation | 237,162 functions, 345 jump tables, no unimplemented instruction; 506 files compile in about 6 minutes |
| UnrealScript | 2,571 of 2,597 classes export cleanly; the 758 that are n-Space's own or modified from UDK are committed |

Details: [docs/PROGRESS.md](docs/PROGRESS.md).

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
| `tools/inventory.py` | Writes `config/functions.csv` and `config/objects.csv` from the PDB |
| `tools/xex.py` | Unpacks the XEX into its PE image (the basefile), and a decrypted copy for XenonRecomp |
| `tools/pdbtype.py <Name>` | Prints a type from the PDB as a C++ declaration with member offsets |
| `tools/check.py <src...>` | Compiles sources with their object's flags and compares every `// @retail` function with retail; writes `config/status.csv` |
| `tools/recomp_config.py` | Writes the XenonRecomp config into `build/recomp/` |
| `tools/script_export` | Exports a cooked package's script classes as `.uc` (dotnet) |
| `tools/script_compare.py` | Compares exported classes with UDK's, writes `config/script_classes.csv` |
| `tools/decomp_dev_export.py` | Writes the decomp.dev progress report |
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
