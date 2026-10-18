# Phase 1: public launch implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans
> to implement this plan task by task. Steps use checkbox (`- [ ]`) syntax for
> tracking.

**Goal:** Publish `kirklandsig/halo-mega-bloks-decompiled` as a discoverable,
contributor-ready public repo with a slim inventory, the script export, CI,
and both tracker hooks, on one squashed commit.

**Architecture:** This builds on the Phase 0 tools (`tools/pdbfile.py`,
`inventory.py`, `check.py`, `recomp_config.py`, `script_export/`).
- **Static vs status:** the PDB-derived inventory becomes static. Match
  status moves to a small file that `check.py` writes.
- **Docs:** they follow the Halo 2 repo's set (`../../Halo2Decomp`), minus
  everything about provenance.
- **Publishing:** an orphan commit carries the final tree, so the 70 MB
  Phase 0 CSV blobs never reach GitHub.

**Tech Stack:** Python 3 and pytest, GitHub Actions, `gh` (logged in as
`kirklandsig`), GitHub Pages.

**Spec:** `docs/specs/2026-10-18-design.md` (read its "Repository" and
"Phases" sections first). Phase 0 facts are in `docs/specs/phase0-results.md`.

## Global Constraints

- **Branch:** work on `phase1`, branched from `main`. Commit after each task
  as the configured author, ending with
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- **Never committed:** `orig/`, `sdk/`, `build/`, or any game, SDK, UDK or
  extracted binary. No UDK-identical script classes are committed.
- **No links to sources for the game files or the XDK** in any committed
  file. Docs name what is needed (the build's files, "XDK 21076,
  `cl` 16.00.11886") and say users supply it themselves.
- **No local paths, usernames or non-noreply emails** in any committed file
  or commit message. In docs, write `%USERPROFILE%` or relative paths.
- **Public actions happen only in Task 6:** creating the repo, pushing,
  Pages, topics, the issue, and the recomp.fyi submission. Nothing else is
  pushed. Local branches holding Phase 0's history (`main` before Task 6,
  `phase0`) are never pushed.
- **Exact copy:**
  - The repo description and the README's first line are:
    `Decompilation and native PC port of Project Haggar, the cancelled Halo Mega Bloks game (n-Space, Xbox 360, Unreal Engine 3).`
  - The topics are:
    `halo mega-bloks project-haggar decompilation static-recompilation xbox-360 unreal-engine-3 reverse-engineering game-preservation`.
- **Low priority:** do the minimum the tasks name, and reuse Halo 2's files
  wherever they fit.

## Review Focus

1. **A contributor without `orig/`** clones the repo and runs `pytest`.
   Everything passes or skips, and nothing errors. Tested in Task 4 (CI runs
   without `orig/`).
2. **Re-running `inventory.py`** must not wipe match results, because status
   lives in `status.csv`. Tested in Task 1 (`test_inventory_keeps_status`).
3. **`check.py` on a matched function** writes `status.csv` and leaves
   `functions.csv` byte-identical. Tested in Task 1
   (`test_check_writes_status_only`).
4. **Leaks in the published tree:** paths, emails, files over 10 MB, or
   ignored file types. Caught by the Task 6 pre-publish scan, which blocks
   the push.
5. **A search engine or AI crawler reading the README or Pages site** learns
   what the project is, both spellings, and the codename from the first
   paragraph. Checked in Task 3 against the exact copy above.

---

### Task 1: slim inventory, status split, public-only functions

**Files:**
- Modify: `tools/inventory.py`, `tools/check.py`, `tools/recomp_config.py`,
  `tests/test_inventory.py`, `tests/test_check.py`, `.gitignore`
- Create: `config/status.csv` (header `address,status`, then rows for
  Phase 0's 10 matched functions)
- Remove from git: `recomp/MegaHaloGame.toml` (it is now generated into
  `build/recomp/`)

**Interfaces:**
- `functions.csv` columns become
  `address,size,name,symbol,object,package,tier,owner,source,line`.
  - The `aliases` column (always empty) and the `status` column are dropped.
  - `source` drops the prefix `f:\projects\halo_megabloks\development\src\`
    (for example `core\src\unobjgc.cpp`).
  - XDK paths become `<xdk>\...`.
  - Public-only functions (21,455) are added, with an empty `name`, the
    `symbol` filled in, and `object` taken from the DBI section
    contributions. Their tier comes from that object, and is `lib` when no
    object is found.
- `status.csv` uses the columns `address,status` and is sorted by address.
  It lists only rows whose status isn't `todo`.
- `check.update_status(path, results: dict[int, str]) -> None` merges results
  into `status.csv`.

- [x] Write the tests:
  - `test_source_prefix_stripped`
  - `test_inventory_keeps_status`: running the inventory leaves an existing
    `status.csv` untouched.
  - `test_check_writes_status_only`
  - `test_public_only_rows` (`orig`): 237,399 rows in total, and every PDB
    procedure is present.
  - `test_functions_csv_under_25mb`
- [x] Run them. Expect a failure. Implement the changes, regenerate both
  CSVs, and run `python tools/check.py src/UDKBase/Src/HaloRBTKamikaze.cpp`
  (expect 10 matched, in `status.csv`). Run `python -m pytest -q`. Expect a
  pass.
- [x] Commit `Phase 1 task 1: slim inventory, status.csv, public-only functions`.

### Task 2: script export

**Files:**
- Create: `script/<Package>/Classes/*.uc` (only the `nspace-only` and
  `modified` classes, for every package)
- Modify: `config/script_classes.csv`, and the `script/MegaHaloGame` export
  if it is regenerated

- [x] Export every script package with `tools/script_export`. Delete the
  identical classes from the output. Commit the rest.
- [x] Time-box the 26 classes that carry error markers: one pass, then list
  what remains in `docs/PROGRESS.md` (Task 3).
- [x] Commit `Phase 1 task 2: script export (n-Space and modified classes)`.

### Task 3: docs and discoverability

**Files:**
- Create: `README.md` (replacing the placeholder), `CONTRIBUTING.md`,
  `LICENSE` (copied from `../../Halo2Decomp/LICENSE`, with the names
  adjusted), `.recomp.json`, `llms.txt`, `docs/START_HERE.md`,
  `docs/DECOMPILING.md`, `docs/PORTING.md`, `docs/PROGRESS.md`,
  `.github/pull_request_template.md`, and a Pages site (follow
  `kirklandsig/halo-ce-anbernic-rg35xx`'s Pages setup)

The README, in this order:
1. The exact first line.
2. One paragraph naming Project Haggar, "Halo Mega Bloks" and "Halo Mega
   Blocks", n-Space, Xbox 360, Unreal Engine 3 (UDK July 2012), and
   343's cancellation.
3. What the repo is: the three tracks, and the handheld goal.
4. Status, with Phase 0 numbers.
5. What the repo doesn't contain.
6. What you need: your own copy of the build's files, and XDK 21076 for
   matching (no links).
7. Build and check, with the tool table.
8. How to help: claims via the pinned issue, and START_HERE.
9. A FAQ that starts with "Can I play the cancelled Halo Mega Bloks game?".
   Answer honestly: not natively yet, and the port is the goal.
10. Credits: the tools used and their licenses (XenonRecomp MIT, Xenia BSD,
    UELib, UModel), and the community section.
11. License: CC0, covering only the contributors' own work.

Other files:
- **`START_HERE.md`:** adapt Halo 2's, keeping its paste-in AI-agent
  prompt but rewritten for this repo's tools and markers.
- **`DECOMPILING.md`:** Phase 0's Gate A idioms, plus the marker format and
  the `check.py` workflow.
- **`PORTING.md`:** Track 1 and the Phase 2 steps from the design.
- **`.recomp.json`:** the same shape as Halo 2's. Use system `Xbox 360`, type
  `decomp`, project `halo-mega-bloks-decompiled`, status `in-progress`, and
  tags `matching`, `msvc`, `cpp`, `static-recompilation`, `unreal-engine-3`.
  Point the links at `START_HERE`, `PROGRESS`, the claims issue (use issue #1,
  which Task 6 creates first) and `PORTING`.
- **`llms.txt`:** the standard format, listing the project summary and links
  to the docs.

- [x] Write the files. Check that the README's first line equals the exact
  copy, and that no committed file contains `http` links to game or SDK
  downloads (`git grep -n -i -E "archive\.org|xdk.*(download|\.7z|\.exe)"`
  should print nothing).
- [x] Commit `Phase 1 task 3: docs, licence, discoverability`.

### Task 4: CI and decomp.dev report

**Files:**
- Create: `.github/workflows/tests.yml` (runs pytest on Ubuntu without
  `orig/`), `.github/workflows/decomp-dev.yml`, `tools/decomp_dev_export.py`,
  `tests/test_decomp_dev_export.py`, `docs/DECOMP_DEV.md`
  (adapt Halo 2's)

**Interfaces:**
- `decomp_dev_export.build_report(functions_csv, status_csv) -> dict` returns
  an objdiff-format report.
  - The units are the objects of the `nspace` rows.
  - It has two categories: `nspace` (the target) and `game` (all game-tier rows).
  - The workflow uploads it as the `report.json` artifact on `main`.

- [x] Write the test `test_report_counts`: a synthetic CSV with 3 `nspace`
  rows (1 matched) gives a matched code percentage of 1/3 by bytes. Run it.
  Expect a failure. Implement. Run it. Expect a pass.
- [x] Simulate CI locally: with `HAGGAR_PDB` and `HAGGAR_XEX` pointing at
  missing files, `python -m pytest -q` passes with skips and no errors.
- [x] Commit `Phase 1 task 4: CI and decomp.dev report`.

### Task 5: pre-publish scan

**Files:**
- Create: `tools/prepublish.py`, `tests/test_prepublish.py`

**Interfaces:**
- `prepublish.scan(tree_files: list[Path], private_patterns: list[str]) -> list[str]`
  returns a list of problems.
  - It flags `[A-Za-z]:\\Users\\`, `@gmail`, and any email that isn't
    `noreply`.
  - It flags every regex in `private_patterns`. The CLI reads those from the
    git-ignored `local/prepublish_patterns.txt`, which holds the username and
    similar, one regex per line. Create the file with the username from
    `%USERPROFILE%`'s last path component. Never write private patterns into
    a tracked file, the tests included: tests plant a made-up pattern.
  - It flags any file over 10 MB.
  - It flags any file type the `.gitignore` excludes.
  - It flags any `.uc` file whose class `config/script_classes.csv` marks as
    `identical`.
- CLI: `python tools/prepublish.py` scans `git ls-files` and exits 1 if it
  finds any problem.

- [x] Write `test_scan_flags`, which plants one of each problem in
  `tmp_path` and expects each to be reported. Run it. Expect a failure.
  Implement. Run it. Expect a pass.
- [x] Run `python tools/prepublish.py` on the tree. Expect it to exit 0. Fix
  anything it finds.
- [x] Commit `Phase 1 task 5: pre-publish scan`.

### Task 6: publish

- [x] Run `python -m pytest -q` and `python tools/prepublish.py`. Expect both
  to pass.
- [x] Create the squashed history: `git checkout --orphan publish`, commit
  the current tree as
  `Halo Mega Bloks (Project Haggar) decompilation: tools, inventory, scripts and docs`,
  then run `prepublish.py` on it again.
- [x] Create the repo and push:
  - `gh repo create kirklandsig/halo-mega-bloks-decompiled --public --description "<exact copy>"`
  - add the remote, push `publish:main`, and set `main` as the default branch
  - `gh repo edit --add-topic` for each topic
  - enable Pages
  - Locally, rename `publish` to `main`, and keep the old Phase 0 history as
    the local branch `history-phase0`. Never push it.
- [x] Create issue #1, "Active claims", with a claims table in the Halo 2
  format, and pin it.
- [x] Find out recomp.fyi's process for listing a new project. If it is a
  GitHub PR or issue, open it (the user asked for this listing). If it needs
  a web form or a login, write down the exact steps for the user.
- [x] Check the decomp.dev workflow's first run on `main`. Its artifact
  should be `report.json`.
- [x] Report back: the repo URL, the Pages URL, the issue URL, the recomp.fyi
  status, and the two decomp.dev steps the user has to take (registering at
  decomp.dev/manage/new and installing the GitHub app).
