# Phase 3: n-Space's C++ implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans
> to implement this plan task by task. Steps use checkbox (`- [ ]`) syntax for
> tracking.

**Goal:** turn n-Space's 1,258 native functions (the `nspace` rows) into
matching C++, as cheaply as possible, and prove that matched source can
replace its recompiled version in the PC port.

**Architecture:**
- Most of the work is mechanical, so generators come first:
  - 447 functions come from `udkbase\inc\udkbaseclasses.h`, the header the
    UnrealScript compiler generates (`event` thunks, `DECLARE_CLASS`
    boilerplate).
  - 191 have no source line (compiler-generated: constructors, destructors,
    `StaticClass`-style members).
  - 243 are 16 bytes or less.
- The rest is n-Space's own AI code (`CCSRef`, `CCSRefUE3`: behaviour-tree
  nodes, actions, blackboard, spawn and cover), written by hand one object at
  a time.
- Then a spike checks whether one source file can build for both the XDK (to
  match) and the host (to hook into the port through ReXGlue's `REX_HOOK`).

**Tech Stack:** Python 3 and pytest; XDK 21076 `cl` through `tools/check.py`;
`tools/pdbtype.py`; capstone (PowerPC 32-bit BE) for disassembly; the
ReXGlue SDK (`third_party/rexglue`) for the spike.

**Spec:** `docs/specs/2026-10-18-design.md` ("Track 2"). The method and the
idioms are in `docs/DECOMPILING.md`; the worked example is
`src/UDKBase/Src/HaloRBTKamikaze.cpp`.

## Global Constraints

- **Where to work:** in the worktree `%USERPROFILE%\haggar-tools\wt`, on a
  new branch `phase3` from `main` (`856f94f`). Never in the OneDrive checkout.
- **Commits** are made as the configured author and end with
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- **Pushing:**
  - At least once per object, and after each task: run `pytest` and
    `python tools/prepublish.py` (0 problems), then fast-forward `main` and
    push it.
  - ByteMatch picks up progress from each push.
  - Never push `phase0` or `history-phase0`.
- **Claims:**
  - Before starting an object, read issue #1 and comment there to claim it.
    Skip any object someone else has claimed.
  - Don't merge or review other people's pull requests; list them in the
    report.
- **Matching bar** (from the design):
  - Match where it comes cheaply.
  - After a few distinct attempts, mark the function `near` with a comment
    giving the suspected cause, and move on.
  - Never edit `status.csv` by hand; `check.py` writes it.
- **Never committed:** game files, the XDK, disassembly listings, or
  generated build output. Generated C++ that is source (headers, thunks) is
  committed like hand-written code.
- **No local paths, usernames or non-noreply emails** in committed files.
- **Low priority:** do the minimum each task names. Update `DECOMPILING.md`'s
  idioms whenever something new is learned.

## Review Focus

1. **A generator that matches only the cases it was tested on.**
   - Every generated function goes through `check.py` like hand-written
     code.
   - Its tests cover a thunk with no parameters, one with a return value,
     one with an out parameter, and one with a struct, string or array
     parameter.
2. **Headers that compile but have the wrong layout.** A wrong member offset
   still compiles, and only shows up as `near`. The header generator takes
   its offsets from the PDB, and a test asserts `offsetof` for a few
   members, compiled with the XDK.
3. **Re-running `check.py` on old files.** It must not demote matched
   functions when a shared header changes. `pytest` re-checks every source
   file (marked `orig`).
4. **The host build of matched source** (Task 4) reading guest memory in host
   byte order. The spike's test compares the hooked function's effect in the
   port with the recompiled one's.
5. **A contributor without the XDK or `orig/`.** The new tests skip cleanly,
   and CI stays green.

---

### Task 1: headers from the PDB

**Files:**
- Create: `tools/gen_header.py`
- Test: `tests/test_gen_header.py`
- Create: headers under `include/<Package>/Inc/` as objects need them

**Interfaces:**
- Produces:
  - `render_class(pdb, name, opaque_bases=True) -> str`: a declaration that
    compiles under `-W4 -WX`.
  - Members at the PDB's offsets, with explicit padding where members are
    unknown.
  - Bases outside the target set become opaque `char` arrays of the PDB's
    size behind a vtable pointer.
  - Virtuals keep their slot index, with `ReservedSlotN` for slots that are
    never called.

- [x] **Write the tests.**
  - `test_offsets_match_pdb` (marked `orig`): it renders `HaloRBTKamikaze`
    and a CCS behaviour-tree node, compiles a translation unit of
    `static_assert(offsetof(...) == N)` lines with the XDK, and checks that
    it succeeds.
  - `test_render_opaque_base`: no `orig/` needed. It feeds in a type record
    captured as a fixture.

  Run them and see them fail.
- [x] **Implement it on top of `tools/pdbtype.py`.** Then regenerate the
  Phase 0 example's header, `include/UDKBase/Inc/HaloRBTKamikaze.h`. Its 10
  functions must still match. Commit, then push.

### Task 2: generated code in bulk

**Files:**
- Create: `tools/gen_classes.py`
- Test: `tests/test_gen_classes.py`
- Create: `include/UDKBase/Inc/UDKBaseClasses.h` (the `nspace` classes'
  part), plus `src/` files for the compiler-generated members

**Interfaces:**
- Produces:
  - `event_thunk(func) -> str`, the UE3 script compiler's `event<Name>`
    pattern: fill a `<Class>_event<Name>_Parms` struct, then call
    `ProcessEvent(FindFunctionChecked(<PKG>_<Name>), &Parms)`, then copy the
    out parameters and the return value back.
  - The boilerplate that `DECLARE_CLASS` and its relatives expand to.
  - The parameter types and order come from the PDB's `*_Parms` types, with
    `script/` as a cross-check.

- [x] **Survey the 447 header rows and the 191 rows with no source.** Group
  them by shape: event thunk, `exec` thunk, constructor, destructor, class
  registration, other.
  - Disassemble one of each.
  - Record the groups and their counts in `docs/DECOMPILING.md`.
- [x] **Write the tests.** `test_event_thunk_shapes` renders one thunk of
  each kind (no parameters, a return value, an out parameter, and a struct,
  string or array parameter) and compares it with expected text written
  from the disassembly. Run them and see them fail.
- [x] **Implement it, generate the code, and run `check.py`** over every
  generated file.
  - Fix the generator until every group matches, or until what is left is a
    known `near` cause.
  - Expect most of the 638 to match.
- [x] **Write the matched count into `docs/PROGRESS.md`.** Commit, then
  push.

### Task 3: n-Space's AI code, object by object

Five objects hold the `nspace` rows. Work them smallest first:
- `Unity_CCSMainEtAl.cpp.obj` (25)
- `Unity_NullSurveysEtAl.cpp.obj` (34)
- `Unity_UDKCoverEtAl.cpp.obj` (42)
- `Unity_UDKWeaponEtAl.cpp.obj` (195)
- `Unity_HaloRBTKamikazeEtAl.cpp.obj` (962)

The 962 already include whatever Task 2 matched.

For each object:
- [x] **Claim it** on issue #1.
- [x] **List its remaining `todo` functions,** from `config/functions.csv`
  and `config/status.csv`, grouped by source file (the `source` column).
- [x] **Write each source file:** `src/<Package>/Src/<File>.cpp`, with
  `// @object` and `// @retail` markers. Use headers from Task 1. Work
  smallest functions first within a file, and define the functions of a
  unity object together so that inlining matches retail.
- [x] **Run `check.py`** on the file. Iterate within the matching bar, and
  mark the leftovers `near` with a comment.
- [x] **Commit and push** once the object is done, and at least every 50
  functions. Then post a one-line status on issue #1: matched, near, todo.

Done for the task: every `nspace` row is `matched`, `near`, or `todo` with a
comment saying why it was skipped (for example VMX128 code not yet
understood).

### Task 4: spike: matched source in the port (time-box: about two days)

**Files:**
- Create: `runtime/src/decomp/` (the host build of matched source)
- Create: `docs/specs/phase3-port-swap.md`

The question: can one source file build for both the XDK (to match) and the
host (as a `REX_HOOK` in place of the recompiled function), without two
copies of the code?

- [x] **Pick 3 matched functions:** a leaf that only reads and writes
  members, one that calls another game function, and a virtual call.
- [x] **Find a host-mode header form,** for example a macro or template layer
  in which, when building for the host:
  - members become big-endian guest-memory accessors at the PDB's offsets;
  - pointers become 32-bit guest pointers;
  - calls go through the recompiled function table or the guest vtable.

  When building with the XDK, the same headers expand to plain members, and
  the 3 functions must still match.
- [x] **Hook the 3 functions** into `haggar.exe` with `REX_HOOK`.
  - Test: the game reaches the jungle level (M5) with the hooks in place.
  - For the leaf, a log comparison shows the same member writes as with the
    recompiled version, for the same input.
- [x] **Write `docs/specs/phase3-port-swap.md`:** the chosen form, what it
  costs per function, and a recommendation. The options are to adopt it for
  all matched code, to adopt it only for code worth modding, or to keep the
  port fully recompiled.
- [x] **Commit, then push.** If the time-box runs out, write up what was
  learned instead.

### Task 5: scripts (time-box: about a day)

- [ ] **Try UDK July 2012 BETA 2's script compiler** (local copy in
  `%USERPROFILE%\haggar-tools\udk`) on the committed n-Space scripts, with the
  UDK-identical classes from UDK itself.
  - Record whether it compiles, and what fails, in `docs/PROGRESS.md`.
  - Never commit UDK files.
- [ ] **Fix the 14 classes that still contain decompiler errors,** where the
  bytecode makes the original clear. List the rest.
- [ ] **Commit, then push.**

### Task 6: wrap-up

- [ ] **Update the docs:**
  - `docs/PROGRESS.md`, the README's status line, `llms.txt`, the Pages
    site's status, and the design's "Phases".
  - Phase 3 is done, with the matched, near and todo counts and the Task 4
    recommendation.
- [ ] **Run the global simplify pass** over the new tools.
- [ ] **Commit, then push.**
