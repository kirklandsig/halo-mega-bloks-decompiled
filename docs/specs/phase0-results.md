# Phase 0 results

Status: done (2026-10-18). Phase 0 ran locally; nothing was public at the time.
Phase 1 later added the public-only functions to the inventory with a stricter
definition (21,224, see `tools/pdbfile.py`), giving 237,168 rows in 2,295 objects.

## Summary

| Gate | Result | Numbers |
| --- | --- | --- |
| A, match spike | **passed** | 10 of 10 game functions of `Unity_HaloRBTKamikazeEtAl.cpp.obj` match byte for byte with XDK 21076 `cl` 16.00.11886 and the PDB's flags (5 needed) |
| B, recomp spike | **translation and compile pass; the count criterion fails as written** | XenonRecomp translates the whole XEX: 239,193 functions, all 215,944 PDB functions among them (+10.8%; +0.76% against PDB procedures plus public-only functions). 20 of 20 sampled output files compile with clang-cl. 8,665 unsupported-instruction warnings in 2,419 functions; no jump tables found |
| C, script spike | **passed** | 2,571 of 2,597 classes (99.0%) in the 13 script packages export without error markers; MegaHaloGame 354 of 360 (98.3%). A weapon, a game info and a UI class read as plausible UnrealScript |

Also found:

- The XEX is **devkit-signed** (only the zero key decrypts it).
- The engine is exactly **UDK July 2012 BETA 2** (engine 10246, changelist
  1340247).
- **Owner** of the game tier after the UDK comparison: `nspace` 1,258
  functions, `epic` 5,808. Track 2 targets the `nspace` rows.

`python -m pytest -q` with `orig/` present: `59 passed in 4.00s`. Without it:
`50 passed, 9 skipped in 0.27s`.

## Open problems

1. **Jump tables.** XenonAnalyse matches `lis; addi; rlwinm; lwzx; mtctr; bctr`,
   but this compiler schedules about 320 tables as `lis; slwi; addi; lwzx; mtctr;
   bctr`, so `recomp/switch_tables.toml` is empty. Until they are found, those
   `bctr`s are indirect jumps the runtime can't follow.
2. **Unsupported instructions.** 52 mnemonics, 8,665 sites in 2,419 functions
   (26 of them game tier). Most are simple: update-form loads and stores
   (`stfsu`, `lfsu`, `sthu`, `lhzu`, `lfsux`, ...), `bdzf`, `eqv`, `subfze`,
   `addme`, and VMX shifts and packs (`vsrah`, `vslh`, `vsel128`, `vpkswss128`,
   ...). Plus 325 `vcmpbfp128.` without the CR6 update.
3. **Function count.** The PDB has procedure records for 215,944 functions,
   but 21,455 more have only public symbols (libraries without private
   symbols). The inventory and the recomp config should include them, with
   sizes from `.pdata`.
4. **Devkit key.** XenonRecomp knows only the retail key, so it reads the
   decrypted copy that `tools/xex.py --decrypted` writes. Either keep that step
   or teach it the devkit key.
5. **Script errors.** 26 classes keep a UELib marker (`/* ERROR`,
   `!MISMATCHING`); six of them are in MegaHaloGame.
6. **Owner is heuristic.** The UDK comparison is structural, so "modified"
   (197 classes) is an upper bound. The game-tier rows that match no script
   class keep the first-pass rule.
7. **No VMX128 in the match spike.** The object had no vector code, so
   matching vector code is untested.
8. **Generated output size.** The recomp output is 538 MB of C++ and stays
   outside OneDrive (`%USERPROFILE%\haggar-tools\recomp-run\out`).

## Recommended Phase 1 scope

Go ahead with all three tracks as designed. In Phase 1, alongside the public
launch:

- Publish the repo with the tools, inventory, recomp config, and
  `script/MegaHaloGame/`. Add the public-only functions to the inventory.
- Port prep (the main work for Phase 2): add a jump-table pattern for this
  compiler (an upstream XenonAnalyse change, or a detector of our own using
  PDB function bounds), and implement the 52 missing instructions in a
  XenonRecomp fork (MIT). Measure again: zero warnings, and every
  `ppc_recomp.*.cpp` compiling.
- Track 2 starts on the 1,258 `nspace` rows, one object at a time, with
  headers rebuilt from `tools/pdbtype.py`. Spike one vector-code function
  early.
- Track 3: commit the other script packages' exports. Decide whether to keep
  UDK-identical classes (1,839) out of the repo, since UDK's own source covers
  them.

## Inputs

| | |
| --- | --- |
| PDB | 2,363 modules, 215,944 procedures (deduplicated by address), 759,808 TPI types, machine `0x1F2`. No two procedures share an address, so `aliases` is empty |
| Basefile | `orig/MegaHaloGame.exe` from `tools/xex.py`: `0x24C0000` bytes, devkit key (see Gate B), LZX window 32 KB. SHA-256 `af5c3002e4877cd9b92735e8c70e72997bf5f4eea5f44b51a79956ab57940e0b`. 111,135 of the procedures (51%) begin with `mflr r12` |
| Inventory | `config/functions.csv`, `config/objects.csv` (2,100 objects with code). Tiers: game 7,066, engine 92,662, platform 18,324, lib 97,892 |
| XDK | XDK 21076.11, supplied locally (the project does not distribute it). Unpacked with 7-Zip (the installer was not run) into `%USERPROFILE%\xdk\21076\XDK`. `bin\win32\cl.exe` prints `Version 16.00.11886.00 for PowerPC`, the PDB's version. Tools find it through `XDK_DIR` |

### Owner of the game tier

First pass (Task 3):

`owner` is `nspace` when the package is MegaHaloGame or Cognition, or the
function's source file name starts with `Halo`; otherwise `epic`.

| Package | nspace | epic |
| --- | ---: | ---: |
| udkbase | 37 | 5,105 |
| gameframework | 0 | 1,865 |
| megahalogame | 34 | 0 |
| cognition | 25 | 0 |
| **total** | **96** | **6,970** |

The first pass undercounts n-Space's code: most Halo classes live in UDKBase,
and their functions' first lines are often in shared headers
(`udkbaseclasses.h`) or in files whose names don't start with `Halo` (the
CCS AI code, for example).

Refined by `tools/script_compare.py` (Task 8): a function of a native class
whose script class is identical to UDK's, or modified from it, is `epic`; one
whose script class has no UDK counterpart is `nspace`. Other rows keep the
first pass. **Track 2 targets the 1,258 `nspace` rows.**

| Package | nspace | epic |
| --- | ---: | ---: |
| udkbase | 1,199 | 3,943 |
| gameframework | 0 | 1,865 |
| megahalogame | 34 | 0 |
| cognition | 25 | 0 |
| **total** | **1,258** | **5,808** |

## Gate A: match spike — passed

Object `Unity_HaloRBTKamikazeEtAl.cpp.obj` (UDKBase), compiled by
`tools/check.py` with its PDB command line (`-Ox -Ot -Ob2 -Gy -Zp4 -fp:fast
-W4 -WX -GR- -bigobj ...`), only the `-I` and `-Fo` options replaced. Source:
`src/UDKBase/Src/HaloRBTKamikaze.cpp`, header
`include/UDKBase/Inc/HaloRBTKamikaze.h`. **10 of 10 functions matched**, each
on the first or second try.

| Address | Function | Kind | Status |
| --- | --- | --- | --- |
| `0x8331ED40` | `HaloRBTKamikaze::SetDetonationDistance` | leaf, float argument | matched |
| `0x8331ED48` | `HaloRBTKamikaze::SetArmKamikazeAnimName` | leaf, `FName` by value | matched |
| `0x8331ED50` | `HaloRBTKamikaze::SetDetonateKamikazeAnimName` | leaf, `FName` by value | matched |
| `0x8331ED58` | `HaloRBTKamikaze::SetBlendTimes` | leaf, two floats | matched |
| `0x83333A10` | `HaloRBTKamikaze::HaloRBTKamikaze` | call (base constructor), vtable, float constants | matched |
| `0x83333B58` | `HaloRBTKamikaze::ExecutePreInternal` | virtual method, qualified base call | matched |
| `0x83333A88` | `HaloRBTKamikaze::TestPreCondition` | virtual method, two virtual calls, inlined callee, interface-to-class cast | matched |
| `0x8332E718` | `CCSBlackboard::GetCurrentTarget` | branches, inlined `operator==` against a static | matched |
| `0x8331DB10` | `CCSCharacter::operator==` | inline, emitted out of line | matched |
| `0x83327088` | `IGripBTInterface::GetBlackboard<CCSBlackboard>` | template, virtual tail call (`bctr`) | matched |

No game-tier function in this object uses VMX128, so vector code is untested.

A negative control (changing `-1` to `-2` in the constructor, and the return
value of `ExecutePreInternal`) turns exactly those two functions `near`.

### Idioms learned

- Headers can be minimal: a base class is an opaque `char` array of the
  PDB's size behind a vtable pointer. Only the slot index of each virtual
  that is called matters, so unknown slots are `ReservedSlotN` placeholders.
- An 8-byte class (`FName`) passed by value arrives in one 64-bit GPR and is
  stored with `std`.
- Unity builds matter: a `.cpp` function of the same unity object
  (`CCSBlackboard::GetCurrentTarget`) is inlined into one call site and
  called at another, exactly as in retail, once it is defined in the same
  file.
- `static_cast` from an interface at offset 4 (`IGripBTInterface` in
  `GripBrain`) followed by a member access emits no null check: the offsets
  fold (`0x9C - 4 = 0x98`).
- Out-of-line copies of inline functions and templates are forced with an
  explicit instantiation or by taking the function's address.
- `-W4 -WX` is kept, so hand-written headers have to compile without
  warnings.
- Float constants (`200.0f`, `0.0f`) are loaded from `.rdata` through
  `REFHI`/`REFLO` relocations, which the comparison masks.

## Gate B: recomp spike — translation and compile pass, the 1% count criterion fails as written

Tools, outside the repo and OneDrive:

- **XenonRecomp** `hedge-dev/XenonRecomp` at `ddd128b` (MIT; its `thirdparty/`
  holds fmt, tomlplusplus, xxHash, TinySHA1, tiny-AES-c, libmspack, SIMDe and
  a PowerPC disassembler, each under its own license), built with clang-cl and
  Ninja in `%USERPROFILE%\haggar-tools\XenonRecomp\build`.
- **LLVM 19.1.7**: the official `LLVM-19.1.7-win64.exe`, unpacked with 7-Zip
  into `%USERPROFILE%\haggar-tools\llvm\x` (no install, no elevation).
  **CMake 3.31 and Ninja** are the copies bundled with VS 2022 Build Tools.

Inputs: `tools/recomp_config.py` writes `recomp/MegaHaloGame.toml` with the
ten helper addresses found by PDB name (all match the byte patterns
XenonRecomp's README gives) and 215,938 function boundaries (the PDB's, less
6 that are empty or inside the helper blocks).

**The XEX is devkit-signed**: only the devkit key (zeros) decrypts it.
XenonRecomp knows only the retail key and fails its block SHA-1 check, then
crashes (`.pdata` not found). `tools/xex.py --decrypted` writes
`orig/MegaHaloGame.dec.xex` (payload decrypted, encryption type 0), which
XenonRecomp loads unmodified. (`tools/xex.py` itself tries both keys, which
is why Task 4 never noticed.)

| Check | Result |
| --- | --- |
| Translation | completes: 933 `ppc_recomp.*.cpp` files, 538 MB, about two minutes |
| XenonRecomp's image vs our basefile | identical instructions (count, mnemonics, operands) at six PDB functions: `0x8331ED40`, `0x83333B58`, `0x83333A88`, `0x8332E718`, `0x82410000`, `0x83340B78` |
| Sample compile | **20 of 20** files compile (`ppc_recomp.0, 49, 98, ... 931.cpp`; clang-cl 19.1.7, `/std:c++20 /O2 -march=sandybridge`, SIMDe headers) |
| Functions translated | **239,193**. All 215,944 PDB functions are among them; 23,249 more. That is +10.8% over 215,944, so the "within 1%" criterion **fails as written** |
| Why more | 21,455 of the extra functions have an `S_PUB32` name but no procedure record (libraries built without private symbols), 230 are the register helpers' other entry points, 1,794 have no name (stubs, thunks, analyser splits). Against the PDB's procedures plus its public-only functions (237,399), 239,193 is +0.76% |
| Unsupported instructions | 8,665 "unrecognized instruction" warnings, 52 mnemonics: `bdzf` 2,712, `stfsu` 927, `vsrah` 743, `lfsu` 548, `vslh` 528, `vsel128` 474, `sthu` 381, `lhzu` 355, `dcbst` 258, `eqv` 233, `vsubshs` 157, `lfsux` 156, `vpkswss128` 128, `subfze` 97, ... They fall in 2,419 functions: game 26, engine 525, platform 110, lib 1,313, not in the PDB 445. Also 325 `vcmpbfp128.` with no CR6 update generated, and 9 words that don't decode |
| Jump tables | **XenonAnalyse finds none.** This compiler schedules a table as `lis; slwi; addi; lwzx; mtctr; bctr` (about 320 sites), not the `lis; addi; rlwinm; lwzx` order XenonAnalyse matches. `recomp/switch_tables.toml` is therefore empty, and those `bctr`s are not yet real switches |

XenonRecomp was run on a copy of the config whose output goes to
`%USERPROFILE%\haggar-tools\recomp-run\out`, to keep 538 MB of generated C++
out of OneDrive; the committed config points at `../build/recomp`.

## Gate C: script spike — passed

Tools, outside the repo and OneDrive: Gildor's Unreal Package Decompressor
(`decompress.exe`, gildor.org, 2020-09-30) in `%USERPROFILE%\haggar-tools\umodel`;
the .NET 8 SDK 8.0.426 (Microsoft's zip, SHA-512 checked) in
`%USERPROFILE%\haggar-tools\dotnet`; NuGet `Eliot.UELib` 1.13.3 (MIT).

The 13 script packages in `CookedXbox360` are fully compressed (LZX), version
863/0, engine 10246, cooker 136, big-endian. `decompress -lzx` unpacks them into
`build/packages/`. `tools/script_export` needed three things on top of plain
UELib to read them:

1. **Console-cooked mode** (`UnrealConfig.Platform = Console`): Xbox cooking
   strips each property's category and array enum, and without the flag UELib
   misreads every property (15,150 deserialization failures in MegaHaloGame,
   class bodies empty).
2. **Array element types** from the other packages in the folder
   (`UnrealConfig.VariableTypes`), for default properties of arrays declared in
   another package.
3. **Native function tokens** from all packages, set before loading, with the
   operators' symbols restored from their internal names (cooking drops the
   friendly name): `Instigator != none` instead of
   `__NFUN_119__(Instigator, none)` or `NotEqual_ObjectObject`.

| Package | Classes | With an error marker | Clean |
| --- | ---: | ---: | ---: |
| Core | 9 | 0 | 100% |
| Engine | 1,346 | 7 | 99.5% |
| GameFramework | 105 | 3 | 97.1% |
| UDKBase | 221 | 0 | 100% |
| UTGame | 406 | 10 | 97.5% |
| **MegaHaloGame** | **360** | **6** | **98.3%** |
| Cognition, Grip, GwNavEngine, GFxUI, IpDrv, OnlineSubsystemLive, AkAudio | 150 | 0 | 100% |
| **all** | **2,597** | **26** | **99.0%** |

Error markers are UELib's `/* ERROR`, `!MISMATCHING` (control flow it could
not rebuild) and `Array type was not detected`, plus our own for a class that
throws. The six MegaHaloGame classes are HaloObjective,
HaloAIFlightController, HaloConstructionObject, HaloProfileSettings,
HaloScout and HaloVehicleFactory_BansheeAI.

Three classes read as plausible UnrealScript:

- **Weapon:** `HaloWeapon.SpawnProjectile` asks the game's actor pool
  (`Game.TheRAM.RequestActor`) for a projectile, falls back to `Spawn`, and
  calls `HaloPawn(Instigator).OnWeaponFire()` and `InitForAI` for AI owners.
- **Game info:** `HaloGameConquest extends HaloGameDefault implements(HaloSaveInterface)`;
  `InitGame` reads a `StartingPawnClass` option and sets `DefaultPawnClass`
  through `HaloSaveGame.GetArchetypeFromName`.
- **UI:** `GFxHaloMainMenu extends GFxHaloMoviePlayer`; `Start` plays
  `AkEvent'Music.Play_PrototypeMenu'`, sets the title-screen flags and gets
  the online subsystem.

The MegaHaloGame export is committed under `script/MegaHaloGame/Classes/`
(360 files). Function bodies carry UELib's `// End:0x..` jump comments.

### Comparison with UDK

**The game's engine is UDK July 2012 BETA 2**: its `Binaries/build.properties`
says `engineVersion=10246`, `changelistBuiltFrom=1340247`, the game's own
values (the PDB's and the packages'). UDK 2013-02 BETA 2 is engine 10900. The
installer (UDK July 2012 BETA 2, supplied locally) was not run;
7-Zip took only `Development/Src/*/Classes/*.uc` (2,309 files) into
`%USERPROFILE%\haggar-tools\udk\2012-07-BETA2`.

`tools/script_compare.py` writes `config/script_classes.csv`. The comparison is
structural, because a decompiled class never reads like its source: comments,
`cpptext`, macros and default properties are ignored, as are editor-only
variables (not cooked), constants and enum values (decompiled as numbers) and
the casts the decompiler spells out. Two classes are identical when parent,
members and each function's set of identifiers agree.

| Package | identical | modified | no UDK counterpart |
| --- | ---: | ---: | ---: |
| Core | 5 | 4 | 0 |
| Engine | 1,240 | 93 | 13 |
| GameFramework | 90 | 15 | 0 |
| UDKBase | 106 | 14 | 101 |
| UTGame | 353 | 53 | 0 |
| GFxUI | 15 | 2 | 0 |
| IpDrv | 30 | 16 | 0 |
| MegaHaloGame | 0 | 0 | 360 |
| Cognition, Grip, GwNavEngine, OnlineSubsystemLive, AkAudio | 0 | 0 | 87 |
| **all** | **1,839** | **197** | **561** |

The status column says `nspace-only` for "no UDK counterpart". For Grip,
GwNavEngine, OnlineSubsystemLive and AkAudio that means middleware or Xbox
code that UDK doesn't ship, not n-Space's. "modified" is an upper bound: some
of it is real (`Actor` gains `NEXT_ACTOR`-style variables, for example), some
is residual noise from interface casts and macros.
