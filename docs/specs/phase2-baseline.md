# Phase 2 baseline and results

Status: in progress (2026-10-18). This file collects the Phase 2 facts: the
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
