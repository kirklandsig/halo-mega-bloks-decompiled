# Progress

Updated 2026-10-19 (n-Space's C++: 1,226 of 1,258 functions matched). Matching progress is
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
`todo`. **1,226 are matched (115,044 bytes, 84%), 6 are near (1,904 bytes)
and 26 are todo (19,712 bytes)**; 1,278 functions match in all, counting the
Grip, CCS and Epic helpers that the same objects keep out of line.

| Object | `nspace` functions | Bytes | Matched | Near | Todo |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Unity_HaloRBTKamikazeEtAl.cpp.obj` | 962 | 108,304 | 933 | 4 | 25 |
| `Unity_UDKWeaponEtAl.cpp.obj` | 195 | 18,544 | 195 | 0 | 0 |
| `Unity_UDKCoverEtAl.cpp.obj` | 42 | 5,784 | 42 | 0 | 0 |
| `Unity_NullSurveysEtAl.cpp.obj` (MegaHaloGame) | 34 | 2,664 | 31 | 2 | 1 |
| `Unity_CCSMainEtAl.cpp.obj` (Cognition) | 25 | 1,364 | 25 | 0 | 0 |

Each remaining function has a comment in its source file saying why it
isn't matched. In short:

- **Not attempted yet** (large): `ACCSController::Tick`, `TakePossession` and
  `DrawHUD`; `AUSSController::DrawHUD` and `PostPollMove`; `CCSBlackboard`'s
  `RegisterMembers`, `GetSpecificTarget`, `UpdateTargetListsByRange` and
  `UpdateTargetPointers`; two `GetNodeTitle` cpptext functions;
  `AutoInitializeRegistrantsMegaHaloGame` (needs `TMap`/`TSet`).
- **Written, not matched:** the code is retail's but registers, stack slots or
  inlining differ: the `CCSAF*` actions' `UpdateGoal`/`UpdateMoveTarget`/`Tick`,
  `CCSBlackboard`'s constructor and destructor, `UCCSActorFactory::CreateActor`
  (retail calls two `StaticClass` out of line), `AUSSPawn::CanAim` and
  `TickSpecial` (a rotator kept in a stack copy), `ACCSController::SetState`
  and `RemoveState`, `HaloRBTKamikaze::ExecuteInternal`.
- **Near (6):** `UHaloSaveGame::BasicSerializeObject` and
  `BasicDeserializeObject`, `CCSTarget::FindDestinationReachable`,
  `UCCSBlackboard::GetCovers` and `GetTargets`, `AUSSPawn::MoveToInCover`: a
  swapped register pair or operand order.

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
