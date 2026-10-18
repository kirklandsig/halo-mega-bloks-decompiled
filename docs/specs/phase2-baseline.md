# Phase 2 baseline and results

Status: Tasks 1 to 5 done, M5 reached (2026-10-18). This file collects the Phase 2 facts: the
Xenia baselines, the prior-art search, the build numbers and the runtime
milestones. Screenshots stay on the lane's machine; the log lines are quoted
here.

Test machine: Windows 11, AMD Ryzen AI 7 350 with Radeon 860M (integrated),
64 GB. The game's files are the build's own folder (the XEX next to
`MegaHaloGame/` and `Engine/`), the user's copy.

## Imports

`tools/imports.py` reads the XEX's import libraries and writes
`config/imports.csv`: **421 imports**, all named from Xenia's export tables
(`third_party/xenia`, read in place).

| Library | Functions | Variables |
| --- | ---: | ---: |
| `xboxkrnl.exe` | 188 | 15 |
| `xam.xex` | 195 | 0 |
| `xbdm.xex` | 23 | 0 |

## Packaged-build baseline: not run

The packaged Xenia build that comes with the game files could not be run.
The user's antivirus quarantined its executable as soon as a copy of it was
launched (the copy disappeared and the launch failed). Running the original
in place would have risked the user's only copy, so it was not tried. Its
readme's known issues are recorded for comparison:

- a black screen for about 10 seconds before the game loads;
- the player may not move until Ghost Walk is toggled through the dev menu
  (Back/Select on a controller);
- a "perma-running" state, fixed by the dev menu's Suicide;
- spawning the Warthog crashes the game, and so does auto-building structures
  through the dev menu;
- the winch objective needs the dev menu's Complete Objective, and a barrier
  may need Ghost Walk.

**User step:** to compare against the packaged build, allow it in the
antivirus and run it once (no admin rights needed for this comparison).

## Source baseline: upstream Xenia Canary reaches gameplay

Upstream Xenia Canary at **`4c8482b63`** (`canary_experimental`, 2026-10-18),
built from source in Release with the project's own CMake/Ninja build, and run
on the build's XEX without admin rights.

| Run | Result |
| --- | --- |
| defaults (`console_type = -1`, retail) | boots, then crashes in `main` (XeLaunch) at `0x832C5AFC` |
| `--console_type=0` (development kit) | **gameplay**: in a level with the HUD (Master Chief, health bar, ammo `32/224`, radar) |

With the defaults, `xbdm` isn't loaded, so its 23 imports are unresolved
(`__xbdm_01E` and others). `main` calls `DmRegisterCommandProcessor`, which
returns garbage. The game asserts, then deliberately writes to address 3:

```
!> undefined extern call to 842C8974 __xbdm_01E
!> ==== CRASH DUMP ====
PC: 0x832C5AFC
Access Violation: write at 0x0000000100000003
```

`console_type = 0` loads Xenia's `xbdm` module, whose stubs return success,
and the game runs.

| Stage | Time |
| --- | --- |
| window and log | under 5 s |
| black screen | until about 15 s |
| title or menu | none: the build loads straight into a level |
| first level, HUD drawn | by 30 s |

What the log reports:

- The XEX loads only with the devkit key: `XEX load failed with code 2,
  trying with devkit encryption key...`.
- Xenia's own import table counts: `xboxkrnl` 180 of 203 implemented, `xam`
  133 of 195, `xbdm` 13 of 23. With `console_type = 0`, none of the
  unimplemented ones is called in the first 4 minutes (no `unimplemented!`
  line).
  - The unimplemented `xboxkrnl` exports are `RtlUnwind`,
    `RtlCaptureContext`, `XexUnloadImageAndExitThread`, the `Io*` share and
    request functions, `NtWriteFileGather`, `ObIsTitleObject`,
    `StfsControlDevice`, `StfsCreateDevice`,
    `XeKeysConsoleSignatureVerification`, `IoDismountVolume*`,
    `VdQuerySystemCommandBuffer`, `VdSetSystemCommandBuffer`,
    `XAudioGetDucker*` and `__C_specific_handler`.
  - The unimplemented `xam` exports are 62 network (`NetDll_*`) and system UI
    (`XamShow*UI`) exports.
  - The unimplemented `xbdm` exports are the performance counters, `DmReboot`
    and the `DmTrace*` functions.
- `XamVoiceSetMicArrayIdleUsers` (xam ordinal 1164) is looked up by ordinal
  and is missing (4 times). `XFileSectorInformation` is a stub (45 calls).
- The game tries to write `MegaHaloGame\Logs` and `Profiling\`. Xenia keeps
  the game folder read-only, so nothing is written there.

The packaged build's additions are therefore all upstream now: devkit-key
XEX loading, the `xbdm` stubs (behind `console_type = 0`) and keyboard input
(Xenia's HID keyboard). The Phase 2 runtime needs no Xenia patch to boot this
build.

The frame rate was not measured here: Xenia's title bar shows none. Task 5
measures it for M5.

## Prior art: ReXGlue SDK

**ReXGlue SDK** (`rexglue/rexglue-sdk`, BSD 3-Clause, v0.10.0, 2026-08-21) is
an Xbox 360 recompilation runtime and toolkit. It is Xenia's runtime (kernel,
XAM, `xbdm`, VFS, memory with its physical mirrors, threads, D3D12 and
Vulkan Xenos GPU, XMA audio, SDL input) with the JIT taken out, plus an
ahead-of-time code generator whose analysis and instruction translations
follow XenonRecomp (MIT).

- Its codegen config takes our inputs directly: function boundaries
  (`[functions]`, with `CONFIG` authority), jump tables (`[[switch_tables]]`
  with `address`, `register` and `labels`), invalid instructions and
  `setjmp`/`longjmp`.
- It reads the XEX through Xenia's loader, which tries the devkit key, so no
  decrypted copy is needed.
- Its instruction table covers the mnemonics XenonRecomp lacked in Phase 0
  (`bdzf`, `stfsu`, `lfsu`, `lfsux`, `sthu`, `lhzu`, `dcbst`, `eqv`,
  `subfze`, `addme`, `vsrah`, `vslh`, `vsel128`, `vsubshs`, `vpkswss128`,
  `vcmpbfp128`, and others).
- A project is a CMake app (`rexglue init`) whose `ReXApp` subclass owns the
  window, the runtime and the main guest thread.
- It requires Clang 18 or newer and C++23. LLVM 19.1.7 builds it.
- Recompiled alpha ports of other titles exist.

**Recommendation for Task 5: build on ReXGlue.** It is the Xenia-hosted
recompiled runtime the plan describes, already written. Our fork is
`kirklandsig/rexglue-sdk` (branch `haggar`, submodule `third_party/rexglue`),
in place of a Xenia CPU backend of our own. Its codegen also replaces the
XenonRecomp fork for Task 3. The plan's own inputs carry over: the PDB's
function list, Task 2's jump tables and Task 1's imports.

## Task 3: codegen with no unimplemented instructions

Task 3 runs on the ReXGlue fork (`kirklandsig/rexglue-sdk`, branch `haggar`,
based on v0.10.0 `c94f5eb`) in place of a XenonRecomp fork, per Task 1's
recommendation.

| Check | Result |
| --- | --- |
| Codegen input | 237,162 function boundaries from the PDB (helpers left to ReXGlue's signature scan), `setjmp`/`longjmp`, Task 2's 345 tables |
| Codegen time | **55 s** (after the two fixes below; before them, Register alone ran for more than 10 minutes) |
| Output | 506 `haggar_recomp.*.cpp` files plus headers, 546 MB, 379 `switch` statements |
| Unimplemented instructions | **0** (`PPC_UNIMPLEMENTED` appears nowhere) |
| Undecodable words | 4, all in two `xbdm` import thunks (ordinals 70 and 71) that the import table doesn't list, so they are never patched or called |

The fork's changes:

- **Scaling.** Adding a function notified every function in the graph, and
  the config boundary check scanned every function per config entry. Both
  were O(n²) at 237k functions. The first now indexes unresolved jumps by
  target, and the second uses the sorted base map.
- **`xbdm`.** ReXGlue's `xbdm` stubs leave `r3` untouched. The game's `main`
  asserts when `DmRegisterCommandProcessor` fails, which is the crash
  upstream Xenia shows with `console_type = -1`. So the 23 `xbdm` imports
  the game uses now return Xenia's values: success for the calls Xenia
  implements, with the same buffer writes, and failure for the performance
  counters, `DmReboot` and `DmTrace*`.
- **Instruction tests.** ReXGlue already tests 20 of Phase 0's 52 missing
  mnemonics. The fork adds tests for 31 more, in its own `tests/ppc/asm`
  format: the update-form loads and stores, `bdzf`, `bdnzt`, `dcbst`,
  `subfze.`, `fnmadd`, `vaddsws`, `vsubsbs`, `vcmpgtsb`, `vcmpgtsh`,
  `vcmpgtsw`, `vnor128`, `vsel128` and `vcfpuxws128`. The whole suite
  passes, 1,495 cases (37 of them new). A deliberately wrong expectation
  fails, as a negative control.
  - The 52nd, `mulchw.`, isn't a Xenon instruction. Its sites are VMX128
    words that XenonRecomp's disassembler misread.
- **Review Focus 3 (invalid update forms).** The image has none. None of its
  136,000 update-form loads and stores has `rA = 0`, or `rA = rD` on a load.
  So no translation choice for the invalid forms can change this build's
  behaviour.

## Task 4: full compile

`runtime/` is the ReXGlue project (CC0 glue): `runtime/CMakeLists.txt`
follows the SDK's generated `rexglue.cmake`, with the generated code read
from `$HAGGAR_BUILD_DIR/recomp/generated`. Its targets:

- `haggar_codegen` runs `rexglue codegen` when the manifest, the function
  list, the jump tables or the XEX change.
- `haggar_recomp` is an object library of all 506 generated files plus
  `haggar_init.cpp` and `haggar_register.cpp`, built with SIMDe.
- `haggar` is the executable.

| Check | Result |
| --- | --- |
| Compiler | clang++ 19.1.7 (`-march=x86-64-v2`, C++23, `-fasync-exceptions`, `-O3`), Ninja, VS 2022 Build Tools libraries |
| Build time | **6 min 12 s** for the 497 recompiled sources on 8 cores (Ryzen AI 7 350); the codegen adds about a minute |
| Size | objects 471 MB; `haggar.exe` 187 MB, plus `rexruntime.dll` (10 MB) and `rexgpu-xenos.dll` (2.8 MB) |
| Link | clean, after one fix: `tools/recomp_config.py` leaves the 406 import thunks the PDB lists as functions out of `[functions]`. Before that, ReXGlue renamed each such thunk `sub_<address>` in place of `__imp__<export>`, and the calls to the kernel didn't link |

**Phase 1's open problem (function boundaries).** ReXGlue keeps every PDB
boundary, except where it finds an entry point inside one. That happens 50
times, all in the lib tier (43 with private symbols, 7 public-only), for
example the CRT's `_write`, `fgets` and `RtlFreeHeap`. In each case code
branches into the middle of the PDB function. These are genuine second entry
points, not wrong sizes, so `config/functions.csv` is unchanged.

**The smoke host was not built.** ReXGlue's own instruction suite (Task 3)
covers the per-instruction checks. The real host's first run covers the rest
(an entry point, a jump table and indirect calls through the function table),
since it reaches M1 to M5 below.

## Task 5: the recompiled game runs, M1 to M5

`haggar.exe --game <folder>` runs the recompiled build on ReXGlue's runtime,
which is Xenia's kernel, XAM, `xbdm`, VFS, D3D12 Xenos GPU, XMA audio and SDL
input. The host (`runtime/src/haggar_app.h`, CC0) adds:

- `--game`, an alias for `--game_data_root`;
- loading the build's XEX under whichever name it has in the folder;
- the Xenos GPU plugin by default (ReXApp turns the GPU off unless one is
  named);
- `DEVKIT:\` (and `e:`) mapped to `<user data>/devkit`. `DmMapDevkitDrive`
  succeeds, and the game then writes its profiling and log files there.
  Without a drive behind it, the game asserts and deliberately writes to
  address 3, as upstream Xenia's crash does;
- for unattended runs, `--capture_every=N` (the guest frame read back from
  the GPU, as PPM, whatever is on screen) and `--press=<script>` (a scripted
  controller, `runtime/src/scripted_pad.h`).

Runs on the test machine, at default settings, D3D12:

| Milestone | Evidence |
| --- | --- |
| **M1**: the entry point runs to its first kernel calls | guest thread `F8000028` runs the recompiled `main`: `SetInterruptCallback(83F19158, 40009780)`, audio client registration, then `NtCreateFile` calls (first run, before the `DEVKIT:` mapping) |
| **M2**: UE3 starts | the engine's own log through `DbgPrint`: `Log: Finished loading level: 0.569361 seconds`, `Log: Initializing Engine Completed`, `Log: >>>>>>>>>>>>>> Initial startup: 11.96s <<<<<<<<<<<<<<<`, `Log: Applying property bLevelLoadComplete for object GFxHaloLoadingScreen_0` |
| **M3**: first frame presented | 1280x720 guest frames from about 15 s: the mission briefing ("Due to reports of increased Covenant forces in the area... Navigate the jungle on-foot and reach the base!") with its A prompt |
| **M4**: title screen or menu | this build has neither (upstream Xenia goes straight into a level too); its screens are the briefing, which waits for A, and the dev menu (Back: Build Vehicle, Get Weapon, ..., Ghost / Walk Toggle, ..., Toggle UI Visibility), both drawn and working |
| **M5**: the first level is playable | after A, the jungle level with the full HUD (health, ammo `32/224`, grenades, radar). As the readme warns, the player can't move at first; Ghost / Walk toggled on and off through the dev menu fixes it. The left stick then walks Master Chief through the jungle: the blok counter goes from 0 to 6, and an objective marker (`119.9m`) appears |

**Frame rate: 11 to 16 fps in the level** (`VdSwap` log, per 300 frames:
16.1, 16.1, 15.4 standing; 12.8, 14.4, 11.1 while walking) on the Radeon 860M
integrated GPU. The readme's minimum is a discrete GPU of GTX 980 Ti class,
and Xenia's GPU emulation is the heavy part.

Review Focus 4 (physical-address mirrors): the recompiled code uses the
runtime's guest memory (virtual base `0x100000000`, physical base
`0x200000000`, Xenia's mapping) and no copy of the image. The D3D and GPU
code that uses the `0xA0000000` and higher ranges draws correctly: the HUD,
the Scaleform UI and the level.

Compared with the upstream Xenia baseline: both reach the first level.
Xenia's frame showed the player under a sky above a dark plane, while the
recompiled build shows the jungle. The likely cause is this run's A press
and wait on the briefing, not a difference in the engine.

## Decisions

- **ReXGlue in place of a XenonRecomp fork and a Xenia CPU backend.** The
  plan prefers building on prior art when it fits, and ReXGlue covers Tasks 3
  to 5's integration points. `third_party/xenia` (`kirklandsig/xenia-canary`,
  branch `haggar`, at `4c8482b63`) stays as the source baseline and the home
  of the export tables. The XenonRecomp fork (`kirklandsig/XenonRecomp`)
  is not used.
- **`recomp/switch_tables.toml` uses ReXGlue's `[[switch_tables]]` form**
  (`address`, `register`, `labels`), not XenonAnalyse's.
- **Tables whose index is bounded by a mask and an offset** (`clrlwi` then
  `addi`, in the decompressor) list every entry from 0. The entries below the
  lowest reachable index repeat its label, since they are never taken.
- **The packaged build was not run** (see above).
