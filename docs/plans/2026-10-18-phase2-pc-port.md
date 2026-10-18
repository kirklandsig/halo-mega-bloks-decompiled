# Phase 2: PC port implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans
> to implement this plan task by task. Steps use checkbox (`- [ ]`) syntax for
> tracking.

**Goal:** a Windows x86-64 build of Project Haggar that runs the recompiled
game on a Xenia-hosted runtime, from boot to gameplay, built from this repo
plus the user's own copy of the build's files. Then Linux.

**Architecture:**
- **Recompiler:** a XenonRecomp fork turns the XEX into C++, using the PDB's
  function list and our own jump-table detector. The output compiles into one
  static library.
- **Runtime:** a Xenia Canary fork whose CPU backend calls the recompiled
  functions instead of JIT-compiling guest code. Xenia keeps its kernel, XAM,
  GPU (Xenos over D3D12 or Vulkan), XMA audio and input.
- **This repo** holds the glue (CC0) and the two forks as submodules. The
  build's files, the generated C++ and all build output stay on the user's
  machine.

**Tech Stack:** Python 3 and pytest; C++20 and clang-cl 19 (LLVM 19.1.7);
CMake and Ninja; VS 2022 Build Tools; Xenia Canary's own build (`xb`); `gh`.

**Spec:** `docs/specs/2026-10-18-design.md` ("Track 1" and "Phases"). Phase 0
facts, including the XenonRecomp findings, are in
`docs/specs/phase0-results.md`.

## Global Constraints

- **Where to work:** in a git worktree outside OneDrive, on branch `phase2`
  from `main`: `git worktree add "%USERPROFILE%\haggar-tools\wt" -b phase2 main`.
  - Copy `orig/` into the worktree (it is git-ignored).
  - Submodules, generated C++ and build output live there, never in the
    OneDrive checkout.
  - Tools take an output directory from `HAGGAR_BUILD_DIR`, defaulting to
    `build/`.
- **Commits:** as the configured author (the noreply address), ending with
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- **Pushing:** after each task, run `pytest` and `python tools/prepublish.py`
  (0 problems), then fast-forward `main` to `phase2` and push `main`. Never
  push `phase0` or `history-phase0`.
- **Forks:** create `kirklandsig/XenonRecomp` (MIT) and
  `kirklandsig/xenia-canary` (BSD) on GitHub, each with a `haggar` branch.
  - Add them as submodules at `third_party/XenonRecomp` and
    `third_party/xenia`.
  - Keep their licenses and notices.
  - Copy no GPL code (UnleashedRecomp and others). Use it for ideas only.
- **Never committed:** game files, the XDK, generated recomp C++, build
  output, or any Xenia binary (including the packaged Xenia build that comes
  with the game files).
- **No links** to sources for the game files, the XDK or that packaged Xenia
  build.
- **No local paths, usernames or non-noreply emails** in committed files.
- **Never elevate.** If a step needs admin rights (installing WSL, running
  Xenia as administrator), skip it and list it as a user step in the report.
- **Low priority:** do the minimum each task names. If a runtime milestone is
  blocked after about a day of lane work, stop and report what was tried.

## Review Focus

1. **A contributor with their own copy of the build** follows `PORTING.md`
   from a clean clone to a running game. Task 7 runs the steps in a fresh
   worktree.
2. **A false jump table.** A `bctr` through a function pointer that is read as
   a table would send the code somewhere wrong. Every table's entry count must
   come from its bounds check, and every label must lie inside its function.
   Tested in Task 2.
3. **Update-form loads and stores where `rA` equals `rD` or `rA` is `r0`.**
   These are invalid forms on PowerPC, and the translation must not quietly
   produce different results. Tested in Task 3.
4. **Physical-address mirrors.** D3D and GPU code use the guest's physical
   ranges (`0xA0000000` and up). The recompiled code must use Xenia's guest
   memory mapping, not a copy of the image. Exercised by milestone M3 in Task 5.
5. **Generated code reaching git or OneDrive.** Caught by `HAGGAR_BUILD_DIR`,
   `.gitignore` and the pre-publish scan.

---

### Task 1: Xenia baselines

**Files:**
- Create: `docs/specs/phase2-baseline.md`
- Create: `tools/imports.py`
- Test: `tests/test_imports.py`

**Interfaces:**
- Produces: `imports(xex_path) -> list[Import]`, where `Import` has `library`,
  `ordinal`, `name` (or `''`), `thunk` (VA) and `kind` (`function` or
  `variable`). Also `config/imports.csv`
  (`library,ordinal,name,thunk,kind`). Tasks 4 and 5 rely on both.

- [x] Write `test_imports_csv`: marked `orig`. It asserts that every row of
  `config/imports.csv` has a library in `{xboxkrnl.exe, xam.xex, xbdm.xex, ...}`
  as found in the XEX, that the thunk VAs are unique, and that there is at
  least one row from `xboxkrnl.exe`. Run it and see it fail.
- [x] Implement `tools/imports.py`. It reads the XEX import libraries through
  `tools/xex.py`. Names come from Xenia's export tables (BSD), which may be
  copied in with their notice. Run the tests and see them pass.
- [x] **Packaged-build baseline.** Run the packaged Xenia build that comes
  with the game files on the build's XEX, without admin rights. Its readme
  reports that it reaches gameplay, with workarounds through the dev menu.
  - Record how far it gets (boot, title, menu, first level) and how long
    each stage takes.
  - Record the kernel, XAM and `xbdm` exports it logs as unimplemented.
  - Check the readme's known issues.
- [x] **Source baseline.** Build upstream Xenia Canary from source at a
  recent commit, and record that commit. Run the same XEX and record the same
  facts. List what the packaged build has that upstream lacks (devkit XEX
  loading, `xbdm` stubs, keyboard passthrough).
- [x] **Prior art (time-box: about an hour).** Look for an existing host that
  runs XenonRecomp output on Xenia's kernel and GPU, with an MIT- or
  BSD-compatible license. If one fits, Task 5 builds on it instead of starting
  from scratch. Record what was found.
- [x] Write `docs/specs/phase2-baseline.md` with all of the above and a
  recommendation for Task 5's starting point. Commit, then push.

### Task 2: jump tables

**Files:**
- Create: `tools/switch_tables.py`
- Modify: `recomp/switch_tables.toml` (generated, committed: it is derived
  data, not game code)
- Test: `tests/test_switch_tables.py`

**Interfaces:**
- Consumes: the basefile image (`tools/xex.py`), `config/functions.csv`.
- Produces: `find(image: bytes, funcs: list[tuple[int, int]]) -> list[Switch]`,
  where `Switch` has `base` (VA of the `bctr`), `r` (index register),
  `default` (VA) and `labels` (list of VAs). Also `render(switches) -> str`,
  in the TOML format that XenonRecomp's `switch_table_file_path` reads (the
  format XenonAnalyse writes).

- [x] Write the tests on hand-assembled big-endian words, with no `orig/`:
  - `test_slwi_absolute_table`: `cmplwi cr6, r11, 3; bgt cr6, D;
    lis r12, H; slwi r11, r11, 2; addi r12, r12, L; lwzx r0, r12, r11;
    mtctr r0; bctr`, with a 4-entry table, gives one `Switch` with
    `r == 11`, `default == D` and the 4 labels.
  - `test_upstream_order_still_found`: XenonAnalyse's
    `lis; addi; rlwinm; lwzx` order is found too.
  - `test_function_pointer_bctr_rejected`: `lwz r11, 0(r3); mtctr r11; bctr`
    gives no `Switch`.
  - `test_label_outside_function_rejected`: a table entry beyond the
    function's end rejects the table.
  Run them and see them fail.
- [x] Implement `find` and `render`. Then survey the real image: classify
  every `bctr` in it as a table (absolute, or the byte- or halfword-offset
  forms if this compiler emits them), a pointer call or tail call, or
  unexplained.
- [x] `test_every_bctr_classified` (marked `orig`): the unexplained count is
  0, and there are at least 300 tables. Run all the tests and see them pass.
- [x] Write `recomp/switch_tables.toml`, update `PORTING.md`'s run steps
  (this tool replaces XenonAnalyse), commit, then push.

### Task 3: XenonRecomp fork, missing instructions

**Files:**
- Fork: `kirklandsig/XenonRecomp`, branch `haggar`, submodule
  `third_party/XenonRecomp`. Base it on the Phase 0 commit (`ddd128b`) or a
  newer upstream commit, and record which.
- Modify: the recompiler's instruction switch, and its tests.

- [x] Write a test for each missing mnemonic: the 52 from
  `docs/specs/phase0-results.md` (`bdzf`, `stfsu`, `vsrah`, `lfsu`, `vslh`,
  `vsel128`, `sthu`, `lhzu`, `dcbst`, `eqv`, `vsubshs`, `lfsux`,
  `vpkswss128`, `subfze`, ...), plus `vcmpbfp128.` updating CR6.
  - Each test translates hand-encoded words, runs them, and checks the
    registers, memory and CR against the PowerPC ISA. For VMX128, check
    against Xenia's implementation of the same instruction.
  - Use the fork's own test harness if it builds with LLVM 19. Otherwise add
    a small one in the fork.
  - Update-form cases include `rA == rD` (Review Focus 3).
  Run them and see them fail.
- [x] Implement each instruction. Xenia's PowerPC frontend (BSD) is the
  semantic reference. Treat the 9 undecodable words as invalid instructions
  in the config, or as data, after checking where they sit.
- [x] Run XenonRecomp on `tools/recomp_config.py`'s config, with the Task 2
  switch tables, into `HAGGAR_BUILD_DIR`. It must give **0 unrecognized
  instruction warnings**. Commit the fork, bump the submodule, then push.

### Task 4: full compile and a smoke host

**Files:**
- Create: `runtime/CMakeLists.txt`, `runtime/recomp/` (the build of the
  generated code into a static library), `runtime/smoke/` (a test host)
- Modify: `tools/recomp_config.py` (output under `HAGGAR_BUILD_DIR`),
  `.gitignore` if needed

**Interfaces:**
- Produces: CMake target `haggar_recomp` (a static library of every
  `ppc_recomp.*.cpp`, with XenonRecomp's function-mapping table), built with
  SIMDe so the same sources build for ARM64 later. Task 5 links it.

- [x] **The smoke host.** It reserves the 4 GB guest space, loads the
  basefile image at `0x82000000`, and stubs every import from
  `config/imports.csv` so that it traps with the import's name. Then it calls
  recompiled functions directly:
  - `smoke_leaf`: a pure leaf function with no imports or globals (the lane
    picks one, for example `strlen` from the CRT), on a guest buffer. The
    result is checked.
  - `smoke_switch`: a function with one of Task 2's tables returns the right
    case for each index.
  - `smoke_indirect`: a call through the guest function table reaches the
    right host function.
- [x] Build every generated file with clang-cl (`/std:c++20 /O2`), link
  `haggar_recomp`, and run the smoke tests. Record the build time and the
  library's size in `docs/specs/phase2-baseline.md`. Also check the Phase 1
  open problem: compare the sizes of the public-only functions with
  XenonRecomp's function boundaries, and fix `config/functions.csv` if they
  differ.
- [x] Commit, then push.

### Task 5: the Xenia-hosted runtime

**Files:**
- Fork: `kirklandsig/xenia-canary`, branch `haggar`, submodule
  `third_party/xenia`, at the commit from Task 1's source baseline. Carry the
  changes over from the packaged build that upstream lacks: devkit XEX
  loading and `xbdm` stubs, written fresh from what the game calls.
- Create: `runtime/host/` (the `haggar` executable, CC0 glue)

**Interfaces:**
- Consumes: `haggar_recomp` (Task 4), `config/imports.csv` (Task 1).
- Produces: `haggar.exe --game <folder holding MegaHaloGame.xex and its content>`.

The integration points, which Task 1's prior-art result may already cover:
- **Functions:** a Xenia CPU backend that, for a guest function address,
  returns a thunk into the matching recompiled host function, in place of
  JIT-compiled code.
- **Registers and memory:** one guest context shared by Xenia and the
  recompiled code (map one layout onto the other), and Xenia's guest memory
  base, mirrors included (Review Focus 4).
- **Imports:** XenonRecomp's import thunks (`__imp__<name>`) call Xenia's
  export resolver, for every row of `config/imports.csv`.
- **Threads and callbacks:** guest threads, APCs and DPCs, and kernel
  callbacks into game code all enter through the same backend.

Milestones, each committed and pushed, with a `PROGRESS.md` line. Evidence
goes in `docs/specs/phase2-baseline.md`: log lines, and a screenshot that is
not committed.
- [x] **M1:** the recompiled entry point runs to its first kernel call.
- [x] **M2:** UE3's engine starts (its startup lines appear in the log).
- [x] **M3:** the first frame is presented.
- [x] **M4:** the title screen or main menu.
- [x] **M5:** the first level is playable, as far as the Task 1 baseline
  gets (its known issues are acceptable), and the frame rate is recorded.

### Task 6: Linux

- [ ] Build `haggar_recomp` and the host on Linux with clang: under WSL2 if
  it is installed, or else record it as a user step. Run to M3 if the GPU
  path allows it.
- [ ] Add a CI job that builds the host glue with the generated code stubbed
  out, so Linux build breakage shows up without `orig/`. Steam Deck testing
  is a user step, written up in `PORTING.md`. Commit, then push.

### Task 7: docs and the clean-clone check

- [ ] `PORTING.md`: "Build and run the PC port". It covers prerequisites,
  supplying your own copy of the build, cloning with submodules, each tool
  in order, the CMake build and running `haggar.exe`. Keep no links to game,
  XDK or emulator sources.
- [ ] Follow those steps in a fresh worktree from `main` and fix anything that
  differs.
- [ ] Update `PROGRESS.md`, the README's status line, `llms.txt`, the Pages
  site's status, and the design's "Phases" (Phase 2 done, with what was left
  over). Commit, then push.
