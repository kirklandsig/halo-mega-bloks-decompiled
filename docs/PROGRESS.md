# Progress

Updated 2026-10-19 (n-Space's C++: 1,237 of 1,258 functions matched). Matching progress is
charted on [ByteMatch](https://bytematch.dev/kirklandsig/halo-mega-bloks-decompiled).

## Scope and roadmap

The goal is a proper decomp of the game's own code and scripts (see the
README's Goal section): n-Space's native C++ matched byte for byte (measured
in bytes), the UnrealScript compiling cleanly with UDK's compiler, and
documented data formats and extraction tools (with a level-layout exporter
whose output is never committed). The engine, middleware, Xbox libraries and
Epic's UDKBase and GameFramework code are recompiled by the port, not
decompiled. Open scope checks: whether Grip (1,711 functions, 133 KB) is
n-Space's, and whether n-Space modified Epic-owned functions.

Order: remaining n-Space functions (now), then a clean script compile, then
formats and extraction tools, then the scope checks, then Phase 4 (handheld),
then Phase 5 (UDK rebuild, later).

## n-Space's C++ (matching)

1,258 functions (136,660 bytes) are in scope: the `nspace` rows of
`config/functions.csv`. `config/status.csv` records every function that isn't
`todo`. **1,237 are matched (121,312 bytes, 89%), 8 are near (3,864 bytes)
and 13 are todo (11,484 bytes)**; 1,296 functions match in all, counting the
Grip, CCS and Epic helpers that the same objects keep out of line.

| Object | `nspace` functions | Bytes | Matched | Near | Todo |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Unity_HaloRBTKamikazeEtAl.cpp.obj` | 962 | 108,304 | 943 | 6 | 13 |
| `Unity_UDKWeaponEtAl.cpp.obj` | 195 | 18,544 | 195 | 0 | 0 |
| `Unity_UDKCoverEtAl.cpp.obj` | 42 | 5,784 | 42 | 0 | 0 |
| `Unity_NullSurveysEtAl.cpp.obj` (MegaHaloGame) | 34 | 2,664 | 32 | 2 | 0 |
| `Unity_CCSMainEtAl.cpp.obj` (Cognition) | 25 | 1,364 | 25 | 0 | 0 |

Every function has now been written. Each one that doesn't match has a
comment in its source file saying why. In short:

- **Todo (13), the code is retail's but registers, stack slots or inlining
  differ:** `ACCSController::Tick` (retail inlines `FVector::Normalize`,
  which it calls out of line elsewhere), `SetState` and `RemoveState`
  (argument order), `AUSSController::PostPollMove`, `AUSSPawn::TickSpecial`
  (a rotator kept in a stack copy), the `CCSAF*` actions' `UpdateGoal`,
  `UpdateMoveTarget` and `Tick`, `CCSBlackboard`'s constructor and destructor,
  `UCCSActorFactory::CreateActor` (retail calls two `StaticClass` out of
  line) and `HaloRBTKamikaze::ExecuteInternal`.
- **Near (8):** `UHaloSaveGame::BasicSerializeObject` and
  `BasicDeserializeObject`, `CCSTarget::FindDestinationReachable`,
  `UCCSBlackboard::GetCovers` and `GetTargets`,
  `ACCSController::CalcAccuracyAngles`, `CCSBlackboard::GetSpecificTarget` and
  `UpdateTargetListsByRange`: a swapped register pair, operand order or
  schedule.

The inline layer they rest on is hand-written in `include/`: `Core/Inc/Core.h`
(memory, `check()`, `Min`/`Max` with `fsel`, `appSqrt`), `Core/Inc/Array.h`
(`TArray`), `Core/Inc/UnMath.h`, `Grip/Inc/GripContainers.h` (`Grip_Array`,
the blackboard members), `GwNav/Inc/RefCount.h` (`Kaim::Ptr`), and the
packages' `*Inline.h` files.

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

2,597 classes in 13 packages export; 2,571 without decompiler error markers, and
the 14 committed ones that had them are fixed (below).
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

### Decompiler errors

All 14 classes that kept a UELib error marker are fixed, from the bytecode
and the cooked data: the three control-flow misreads (`!MISMATCHING`, in
HaloAIFlightController, HaloConstructionObject and HaloObjective; plus
UTPlayerController's empty `else`) are rebuilt from the jump offsets the
decompiler prints; the nine default properties UELib couldn't read
(SupportedEvents, LockerPositions, EdgePathColors, ProfileMappings,
PropertyMappings) are written from the cooked class defaults, read with
`tools/upk.py`; CoverLink's and Pylon's struct defaults that failed were all
zero, as in UDK's source, and are dropped.

### Compiling with UDK's script compiler

UDK July 2012 BETA 2 has the game's engine version, so its compiler checks the
scripts. No UDK file is in the repository; the check runs on a copy of a local
install:

```
python tools/udk_compile.py --udk <UDK July 2012 BETA 2 install> [--nspace-only] [--fix]
```

It copies the install to `build/udk/`, lays the committed classes over it,
adds the n-Space packages to the EditPackages lists, runs `UDK.com make -full`
and prints each package's result and every error. `--fix` applies the known
fixes for decompiler artifacts where the compiler reports them, and compiles
again until none applies. `tests/test_udk_compile.py` runs the
`--nspace-only` check when `UDK_DIR` is set.

The compiler found these decompiler artifacts, now fixed in the 266 affected
classes: operator declarations under their internal names (`Not_PreBool`
for `!`), casts of literals (`int(0)`), `int()` around enum comparisons,
`ComplementEqual` for `~=`, `!A == B` for `!(A == B)`, lost `dependson()`
(Grip's GripAFActionStatus among them; a modified Epic class keeps UDK's
list), lost `coerce` and `.static`, interfaces written as classes, `abstract`
on interfaces, `atomicwhencooked`, `editinline` on locals, VfTable variables
the compiler declares itself, empty state functions turned into `ignores`
entries, enum values qualified in default properties, constants printed as
numbers (`Controller.503`), enum values from the wrong enum
(`NM_ListenServer` for `TRAVEL_Relative`), skipped optional arguments
counted twice, `else { if }` nesting past the compiler's limit, and loops in
state code written as labels and `goto`.

| Run | Result |
| --- | --- |
| All 758 committed classes | Core compiles. Engine passes parsing and code generation with 0 errors, then UDK.exe stops (a critical error) while setting up its own native classes |
| `--nspace-only` (UDK's own Epic classes) | Core to Cognition compile, with n-Space's OnlineSubsystemLive, AkAudio, Grip, GwNavEngine and Cognition; UDKBase stops on its first use of n-Space's changes to Epic classes (USSPawn's `PlayDying` has Pawn's extra `Killer` parameter) |

Why the rest can't be checked with stock UDK: n-Space added 80 members to
native Epic classes (Actor's `Next_Actor` lists, Pawn's AI weights, ...), and
the console build's property layout differs from UDK's PC one (editor-only
members stripped). UDK.exe has the C++ side of those classes compiled in, so
it can't load n-Space's versions. The tool lays them out in UDK's order in the
work tree, leaves n-Space's members out and stubs their uses (never in
`script/`), which gets Engine through the compiler but not past UDK's own
startup checks. Checking the packages after Engine needs either a UDK build
with n-Space's native classes, or the Epic packages rebuilt from UDK's
sources with n-Space's script-visible changes merged in (Phase 5's route).
