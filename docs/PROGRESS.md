# Progress

Updated 2026-10-18 (Phase 3 done: n-Space's C++). Matching progress is
charted on [ByteMatch](https://bytematch.dev/kirklandsig/halo-mega-bloks-decompiled).

## n-Space's C++ (matching)

1,258 functions (136,660 bytes) are in scope: the `nspace` rows of
`config/functions.csv`. `config/status.csv` records every function that isn't
`todo`. **875 are matched, 4 are near and 379 are todo** (877 matched in all,
counting 2 Grip and CCS helpers owned by `epic`). Most come from
`tools/gen_classes.py`: what UE3's class macros and the script compiler's
event and exec thunks expand to, and the one-instruction functions.

| Object | `nspace` functions | Bytes | Matched | Near | Todo |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Unity_HaloRBTKamikazeEtAl.cpp.obj` | 962 | 108,304 | 646 | 4 | 312 |
| `Unity_UDKWeaponEtAl.cpp.obj` | 195 | 18,544 | 157 | 0 | 38 |
| `Unity_UDKCoverEtAl.cpp.obj` | 42 | 5,784 | 21 | 0 | 21 |
| `Unity_NullSurveysEtAl.cpp.obj` (MegaHaloGame) | 34 | 2,664 | 26 | 0 | 8 |
| `Unity_CCSMainEtAl.cpp.obj` (Cognition) | 25 | 1,364 | 25 | 0 | 0 |

Why the 379 are still `todo` (Phase 3 did the generated and mechanical code
and stopped there; the rest is open for anyone):

- **Most inline UE3 or Grip templates that aren't written yet:** `TArray`
  (`Num`, `operator()`, `Empty`, `AddItem`, its destructor), `TMap`,
  `FMemoryWriter`, `Grip_Array`. Writing those inline bodies once (in the
  style of `include/Core/Inc/UnMath.h`) unlocks most of CCSNorman, the
  blackboards and the BT nodes' runtime code.
- **Destructors and constructors of classes with members** need the class
  rendered with its members (a `TARGETS` entry in `gen_classes.py`) and the
  members' inline constructors and destructors.
- **n-Space's AI code itself** (`ccsbtnodes.cpp`, `ccsactions.cpp`,
  `ccsblackboard.cpp`, `usspawn.cpp`, `ccscontroller.cpp`, the `CCSAF*` action
  frameworks, the Halo anim nodes) was not attempted. The source files that
  were started list what's left in a closing comment.
- **9 exec thunks** take parameter kinds the generator doesn't read yet
  (`FName`, `FString`, arrays, references), and the 4 `near` are two
  controllers' constructors (their interfaces' vtable pointers).

The port can run matched code in place of the recompiled code; see
`docs/specs/phase3-port-swap.md` (recommendation: only for code worth
modding).

`owner` is a heuristic (see the design, "Where the code is"). Corrections are
welcome.

## Port

| Step | State |
| --- | --- |
| Recompiler | ReXGlue SDK codegen (fork `kirklandsig/rexglue-sdk`): 237,162 PDB functions, 55 s |
| Jump tables | 345 found (`tools/switch_tables.py`); every `bctr` classified |
| Unimplemented instructions | 0 |
| Full compile | done: 506 files, about 6 minutes, `haggar.exe` |
| Xenia baseline | upstream Xenia Canary reaches gameplay with `console_type = 0` |
| Boots natively | **yes, Windows x86-64: M5**, the first level is playable (with the build's known Ghost Walk workaround), 11 to 16 fps on an integrated GPU |
| Linux | builds (WSL2, clang 19); runs to UE3 startup on a software Vulkan device, no frame yet; CI builds the host |

## UnrealScript

2,597 classes in 13 packages export; 2,571 without decompiler error markers.
Committed: the 758 classes that are n-Space's own (no UDK counterpart, 561)
or modified from UDK July 2012 BETA 2 (197). The 1,839 identical classes
stay out; `config/script_classes.csv` lists every class with its status.

| Package | Committed |
| --- | ---: |
| MegaHaloGame | 360 |
| UDKBase | 115 |
| Engine | 106 |
| UTGame | 53 |
| Grip | 42 |
| GwNavEngine | 22 |
| AkAudio | 16 |
| IpDrv | 16 |
| GameFramework | 15 |
| OnlineSubsystemLive | 6 |
| Core | 4 |
| GFxUI | 2 |
| Cognition | 1 |

### Classes with decompiler errors

These committed classes keep a UELib marker: `/* ERROR ... */` (a default
property it couldn't read) or `!MISMATCHING` (control flow it couldn't
rebuild). One pass found nothing to fix in the exporter; they need fixing by
hand or in UELib.

- Engine: `CoverLink`, `Pylon`
- GameFramework: `GameCrowdAgent`, `GameCrowdDestination`
- MegaHaloGame: `HaloAIFlightController`, `HaloConstructionObject`,
  `HaloObjective`, `HaloProfileSettings`, `HaloScout`,
  `HaloVehicleFactory_BansheeAI`
- UTGame: `UTGameSettingsCommon`, `UTPlayerController`, `UTVehicleFactory`,
  `UTWeaponLocker`

These 14 are still unfixed (Phase 3 time-boxed the script work to the
compiler test below).

### Recompiling with UDK's script compiler

UDK July 2012 BETA 2 has the game's engine version, so its compiler
(`UDK.com make -full`, from the installer, run locally) was tried on the
committed scripts. No UDK file is in the repository.

| Input | Result |
| --- | --- |
| UDK's own packages | compile: 0 errors |
| plus the committed "modified" Epic classes in place of UDK's | fails in `Core`: decompiled operator declarations (`Object.uc`) don't compile |
| UDK's Epic packages, plus n-Space's 13 new Engine classes, the 101 new UDKBase classes, and AkAudio, Grip, GwNavEngine, Cognition, MegaHaloGame | Core to AkAudio compile; **Grip stops** on a struct declared in another class (`GripAFActionStatus`), which needs the `dependson()` that cooking drops |

The compiler found an exporter bug on the way: prefix operators came out as
postfix (`IsAdmin(C)!`, `MaxDelta-`). `tools/script_export` now takes the
side from the operator's internal name (`Not_PreBool`), and the committed
scripts are re-exported (232 classes, 1,926 lines; the error-marker counts
are unchanged).

Next steps for anyone: add the missing `dependson()` lines, then work
through the next package's errors; the modified Epic classes need their UDK
originals with n-Space's changes merged in, rather than the decompiled text.
