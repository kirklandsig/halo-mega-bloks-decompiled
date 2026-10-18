# Progress

Updated 2026-10-18.

## n-Space's C++ (matching)

1,258 functions (136,660 bytes) are in scope: the `nspace` rows of
`config/functions.csv`. `config/status.csv` records every function that isn't
`todo`. 10 functions are matched so far, 8 of them in scope (the other 2 are
Grip and CCS helpers of the same object, owned by `epic`).

| Object | `nspace` functions | Bytes | Matched |
| --- | ---: | ---: | ---: |
| `Unity_HaloRBTKamikazeEtAl.cpp.obj` | 962 | 108,304 | 8 |
| `Unity_UDKWeaponEtAl.cpp.obj` | 195 | 18,544 | 0 |
| `Unity_UDKCoverEtAl.cpp.obj` | 42 | 5,784 | 0 |
| `Unity_NullSurveysEtAl.cpp.obj` (MegaHaloGame) | 34 | 2,664 | 0 |
| `Unity_CCSMainEtAl.cpp.obj` (Cognition) | 25 | 1,364 | 0 |

`owner` is a heuristic (see the design, "Where the code is"). Corrections are
welcome.

## Port

| Step | State |
| --- | --- |
| Whole executable translated by XenonRecomp | done (239,193 functions) |
| Sample of the output compiles | 20 of 20 files |
| Jump tables (`lis; slwi; addi; lwzx; mtctr; bctr`) | not found yet (about 320 sites) |
| Missing instruction types | 52 (8,665 sites in 2,419 functions) |
| Xenia baseline | not tried |
| Boots natively | no |

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
