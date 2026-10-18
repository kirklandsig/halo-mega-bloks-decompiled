# Phase 0: feasibility implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans
> to implement this plan task by task. Steps use checkbox (`- [ ]`) syntax for
> tracking.

**Goal:** Prove, locally, the three tracks of the design: function inventory
and image from the PDB and XEX, byte-matching game functions, static
recompilation of the whole XEX, and script decompilation. Record the result
of each gate.

**Architecture:** Python tools in `tools/` read the PDB (MSF, DBI, TPI,
symbols, C13 lines) and the XEX (AES plus LZX) with no third-party RE
framework. External tools (XDK 21076 `cl`, XenonRecomp, UModel's decompress,
UELib) are driven from small scripts. Every output goes to `config/`
(committed) or `build/` (ignored).

**Tech Stack:** Python 3.14, pytest, `cryptography` (AES), `pefile`,
`capstone` (PPC, for disassembly listings only); XDK 21076 `cl.exe`;
LLVM/clang, CMake and Ninja (for XenonRecomp); dotnet (for UELib).

**Spec:** `docs/specs/2026-10-18-design.md`

## Global Constraints

- **Repo:** `halo-mega-bloks-decompiled/`. Work on branch `phase0`. Commit
  after every task as `Kirk Lazarus <7864917+kirklandsig@users.noreply.github.com>`
  (already set in the repo config), ending with
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- **Never committed:** `orig/`, `sdk/`, `build/`, or any game, SDK or
  extracted file (see `.gitignore`).
- **No public actions in Phase 0:** no GitHub repo, no push, no issue or PR.
- **Inputs:** `orig/MegaHaloGame.xex` and `orig/MegaHaloGame.pdb`, which
  `HAGGAR_XEX` and `HAGGAR_PDB` override. The XDK is in `sdk/`, which
  `XDK_DIR` overrides. Tools resolve the repo root from `__file__`, never
  from the current directory.
- **Downloads and external tools** go outside the repo and outside OneDrive:
  the XDK in `%USERPROFILE%\xdk\21076\`, other tools each in their own
  folder under `%USERPROFILE%\haggar-tools\`. Pass downloaded files' paths
  as arguments, and never run an interpreter from inside a download folder.
- **Tests run without `orig/`.** Tests that need the real files carry
  `@pytest.mark.orig` and skip when the files are missing.
- **Python dependencies** are only `pytest`, `cryptography`, `pefile` and
  `capstone`, listed in `requirements-dev.txt`.
- **Verified values to reuse:**
  - modules 2,363; procedures 215,944 (deduplicated by address); TPI types
    759,808; DBI machine `0x1F2`
  - image base `0x82000000`, image size `0x24C0000`, entry point
    `0x83ECAA78`, 15 optional XEX headers, encryption 1, compression 2
  - tier totals: game 7,066, engine 92,662, platform 18,324, lib 97,892
- **Low priority:** do the minimum that answers each gate. Don't add
  features to the tools beyond what the tasks name.

## Review Focus

1. **Unknown or odd symbol records** (`S_THUNK32`, `S_SEPCODE`, trailing
   padding). The symbol walker must skip them and stay in sync. Tested in
   Task 2 (`test_iter_symbols_skips_unknown`).
2. **Code-folded addresses** (several names, one address). The inventory
   keeps one row, with the other names in `aliases`. Tested in Task 3
   (`test_folded_aliases`).
3. **Paths with spaces** (`Project Haggar`) passed through `HAGGAR_XEX` and
   `HAGGAR_PDB`. Tested in Task 1 (`test_env_path_with_space`).
4. **Missing inputs.** Every CLI exits with status 2 and a one-line message
   naming the missing file. Tested in Task 1 (`test_missing_input_message`).
5. **Running from another directory.** Tools find the repo root anyway.
   Tested in Task 1 (`test_root_independent_of_cwd`).

---

### Task 1: skeleton, paths and MSF reader

**Files:**
- Create: `tools/__init__.py`, `tools/paths.py`, `tools/msf.py`,
  `tests/conftest.py`, `tests/msfbuild.py`, `tests/test_paths.py`,
  `tests/test_msf.py`, `pytest.ini`, `requirements-dev.txt`, `README.md`
  (a three-line placeholder: the project name, "work in progress", and
  "no game files here")

**Interfaces:**
- Produces:
  - `paths.ROOT: Path`
  - `paths.xex() -> Path` and `paths.pdb() -> Path` (environment variable or
    `orig/`)
  - `paths.basefile() -> Path` (`orig/MegaHaloGame.exe`)
  - `paths.xdk() -> Path`
  - `paths.require(p: Path) -> Path`, which raises `SystemExit(2)` with
    `"missing input: <p>"`
  - `msf.Msf(data: bytes | mmap)` with `.num_streams: int`,
    `.stream_size(i) -> int` and `.stream(i) -> bytes`
  - `msf.open_msf(path) -> Msf` (memory-mapped)
  - `tests/msfbuild.build_msf(streams: list[bytes | None], block_size=512) -> bytes`
    (`None` means a nil stream)
  - pytest marker `orig`, plus the fixtures `orig_pdb` and `orig_xex`,
    which skip when the file is missing

- [x] Write `test_msf_roundtrip`: three streams (0, 700 and 2,000 bytes)
  read back exactly. Write `test_nil_stream_is_empty` and
  `test_bad_magic_raises` (`ValueError`). Write `test_env_path_with_space`
  (`HAGGAR_PDB=tmp/"a b"/x.pdb`), `test_missing_input_message` and
  `test_root_independent_of_cwd` (`chdir` to `tmp_path`, `ROOT` unchanged).
- [x] Run `python -m pytest -q`. Expect the new tests to fail.
- [x] Implement `paths.py` and `msf.py` (superblock, then the block map,
  then the directory, then streams).
- [x] Run `python -m pytest -q`. Expect a pass.
- [x] Add `test_orig_msf_shape` (`orig`): the real PDB opens and stream 3 is
  not empty. Expect a pass.
- [x] Commit `Phase 0 task 1: skeleton, paths, MSF reader`.

### Task 2: PDB reader

**Files:**
- Create: `tools/pdb.py`, `tests/test_pdb.py`

**Interfaces:**
- Consumes: `msf.Msf`, `msf.open_msf`
- Produces:
  - `pdb.iter_symbols(data: bytes, start: int = 4) -> Iterator[tuple[int, bytes]]`
    yields `(kind, payload)`.
  - `pdb.Module` (dataclass): `index`, `name`, `obj`, `sym_stream`,
    `sym_size`, `c11_size`, `c13_size`.
  - `pdb.Proc` (dataclass): `name`, `rva`, `size`, `module`, `is_global`.
  - `pdb.Pdb(path)` with:
    - `.machine: int`, `.type_count: int`, `.modules: list[Module]`
    - `.sections: list[tuple[str, int]]` (name and virtual address, from the
      section header stream in the DBI debug header)
    - `.procedures() -> Iterator[Proc]`, deduplicated by RVA, first one wins
    - `.aliases() -> dict[int, list[str]]`, the other names at each folded RVA
    - `.publics() -> dict[int, str]` (decorated `S_PUB32` names by RVA)
    - `.env(module) -> dict[str, str]` (the `S_COMPILE2` and `S_COMPILE3`
      environment strings: `cwd`, `cl`, `cmd`, `src`, `pdb`)
    - `.first_line(module, rva) -> tuple[str, int] | None` (C13
      `DEBUG_S_LINES` and `FILECHKSMS`, with names from `/names`)
  - VA = `0x82000000 + rva`.

- [x] Write unit tests on hand-built bytes: `test_iter_symbols_skips_unknown`
  (kinds `0x1110`, `0x9999` and `0x1110` yield three records in order),
  `test_parse_proc_fields` and `test_env_strings` (key and value pairs
  after the compiler name).
- [x] Run them. Expect a failure.
- [x] Implement `pdb.py`. Run the tests. Expect a pass.
- [x] Write the `orig` tests:
  - `test_census`: `machine == 0x1F2`, `type_count == 759808`,
    `len(modules) == 2363`, and 215,944 procedures.
  - `test_env_udkweapon`: the module whose name ends with
    `Unity_UDKWeaponEtAl.cpp.obj` has a `cmd` starting with
    `-nologo -Oi -Zp4 -Gy -fp:fast -c -Zm400 -bigobj -wd4819 -Ox -Ot -Ob2 -GF -Z7 -MT`
    and `cl == r"C:\Program Files (x86)\Microsoft Xbox 360 SDK\bin\win32\cl.exe"`.
  - `test_first_line_has_original_cpp`: for a UDKBase procedure, the file
    ends in `.cpp` and isn't a `Unity_` file.
- [x] Run them. Expect a pass.
- [x] Commit `Phase 0 task 2: PDB reader`.

### Task 3: inventory

**Files:**
- Create: `tools/inventory.py`, `tests/test_inventory.py`,
  `config/functions.csv`, `config/objects.csv`

**Interfaces:**
- Consumes: `pdb.Pdb`
- Produces:
  - `inventory.classify(module_name: str, obj_name: str) -> tuple[str, str]`
    returns `(tier, package)`. Tier is `game`, `engine`, `platform` or `lib`,
    following the design's rules. The package is lowercase, or `""` for lib.
  - `config/functions.csv` has the columns
    `address,size,name,symbol,aliases,object,package,tier,source,line,status`.
    `address` is hex `0x82…`, `symbol` is the decorated public name, and
    `status` is `todo`.
  - `config/objects.csv` has the columns
    `object,package,tier,functions,bytes,src,cmd`.
  - CLI: `python tools/inventory.py`, which writes both files.

- [x] Write unit tests:
  - `test_classify_rules` uses real paths from the census:
    `...\Release\UDKBase\Unity_UDKWeaponEtAl.cpp.obj` is
    `("game", "udkbase")`, `...\Release\Engine\Unity_WorldAttractorEtAl.cpp.obj`
    is `("engine", "engine")`, `...\Release\XenonD3DDrv\Unity_XeD3DViewportEtAl.cpp.obj` is
    `("platform", "xenond3ddrv")`, and `.\Xbox 360\PhysXCooking\release\ConvexHullBuilder.obj`
    is `("lib", "")`.
  - `test_folded_aliases`: two procedures at one RVA give one row, with the
    second name in `aliases`.
- [x] Run them. Expect a failure.
- [x] Implement `inventory.py`. Run the tests. Expect a pass.
- [x] Write the `orig` test `test_tier_totals`: game 7,066, engine 92,662,
  platform 18,324, lib 97,892.
- [x] Run `python tools/inventory.py`, then the tests. Expect a pass.
- [x] Commit `Phase 0 task 3: function and object inventory` (this includes
  both CSVs).

### Task 4: XEX unpacker

**Files:**
- Create: `tools/xex.py`, `tools/lzx.py`, `tests/test_xex.py`,
  `tests/test_lzx.py`

**Interfaces:**
- Produces:
  - `xex.XexHeader` (dataclass): `module_flags`, `pe_offset`,
    `security_offset`, `optional: dict[int, int]`, `image_base`,
    `entry_point`, `image_size`, `encryption`, `compression`,
    `window_size`, `file_key: bytes`.
  - `xex.parse_header(data: bytes) -> XexHeader`
  - `xex.session_key(file_key: bytes, devkit: bool) -> bytes` uses AES-ECB
    with the retail key `20B185A59D28FDC340583FBB0896BF91`, or with sixteen
    zero bytes for a devkit.
  - `xex.extract_basefile(data: bytes) -> bytes` tries the retail key, then
    the devkit key, and accepts the result whose first bytes are `MZ`.
  - `lzx.decompress(data: bytes, window_bits: int, out_size: int) -> bytes`
  - CLI: `python tools/xex.py [xex] -o orig/MegaHaloGame.exe`
- The XEX normal-compression block chain is a sequence of blocks. Each block
  starts with the next block's size and a 20-byte SHA-1, then holds chunks
  (a big-endian `u16` size, then data) until a chunk of size 0. The chunk
  data, concatenated, is one LZX stream. Xenia's `xex_module.cc` (BSD) is the
  reference.

- [x] Write unit tests:
  - `test_parse_header_fields` on a synthetic header that uses this XEX's
    values: 15 optional headers, `0x3FF` giving encryption 1 and
    compression 2, image base `0x82000000`, entry point `0x83ECAA78`, image
    size `0x24C0000`.
  - `test_lzx_uncompressed_block` on a hand-built LZX stream containing one
    uncompressed block.
- [x] Run them. Expect a failure.
- [x] Implement `xex.py` and `lzx.py`. Run the tests. Expect a pass.
- [x] Write the `orig` test `test_basefile`: the length is `0x24C0000`, the
  file starts with `MZ`, the PE `FileHeader.Machine` is `0x1F2`, and at least
  30% of PDB procedures begin with `0x7D8802A6` (`mflr r12`). If that fails,
  suspect the decryption or decompression before the threshold, and record
  what the real prologue mix is.
- [x] Run `python tools/xex.py -o orig/MegaHaloGame.exe`, then the tests.
  Expect a pass. Record the SHA-256 of the basefile in the commit message.
- [x] Commit `Phase 0 task 4: XEX unpacker`.

### Task 5: type dumper

**Files:**
- Create: `tools/pdbtype.py`, `tests/test_pdbtype.py`

**Interfaces:**
- Consumes: `msf`, and `pdb.Pdb` (TPI stream 2)
- Produces:
  - `pdbtype.Types(pdb)` with `.find(name) -> int` (the type index of a
    non-forward-reference record) and `.render(ti) -> str` (a C++
    declaration with `// 0xOFF` on each member, base classes, the vtable
    pointer, bitfields, arrays, pointers and enums)
  - CLI: `python tools/pdbtype.py <Name> [...]`

- [x] Write the unit test `test_render_struct` on hand-built TPI records:
  `LF_STRUCTURE` and `LF_FIELDLIST` with two `LF_MEMBER` entries (an `int`
  at 0 and a pointer at 4) render both members with their offsets, and
  `size 0x8`.
- [x] Run it. Expect a failure. Implement. Run it again. Expect a pass.
- [x] Write the `orig` tests: `FVector` renders `X`, `Y` and `Z` as floats
  at 0x0, 0x4 and 0x8, with size 0xC. `FString` has size 0xC.
- [x] Run them. Expect a pass.
- [x] Commit `Phase 0 task 5: PDB type dumper`.

### Task 6: the match spike (gate A)

**Files:**
- Create: `tools/coff.py`, `tools/check.py`, `tests/test_coff.py`,
  `tests/test_check.py`, `src/<Package>/Src/<File>.cpp` (the spike
  functions), `include/` (minimal hand-written headers made from
  `pdbtype.py` output), `docs/specs/phase0-results.md`

**Interfaces:**
- Consumes: `config/functions.csv`, `config/objects.csv`,
  `paths.basefile()`, `paths.xdk()`
- Produces:
  - `coff.parse(data: bytes) -> Coff`, with `.sections`, `.symbols` and
    `.relocations(section)`. This is big-endian PowerPC COFF, machine `0x1F2`.
  - `coff.function_bytes(c: Coff, symbol: str) -> tuple[bytes, list[tuple[int, int]]]`
    returns the bytes and the masked spans as `(offset, mask)` pairs.
  - `check.compare(ours: bytes, masks, retail: bytes) -> str` returns
    `matched`, `near` or `todo`.
  - CLI: `python tools/check.py [src files...]`. It compiles each file with
    its object's `cmd`. Flags are kept, but every `-I` is replaced with
    `include/` plus the XDK include folder, and `-Fo` points into `build/obj/`.
    It compares every `// @retail` function (resolved by symbol name) and
    updates `status` in `functions.csv`. It exits 1 if any function differs.
- Markers: put `// @object <obj file name>` once at the top of each file,
  and `// @retail 0x82xxxxxx` before each function.

- [x] Supply XDK 21076 locally, in `%USERPROFILE%\xdk\21076\`. Check
  that `cl` with no arguments prints `16.00.11886`. If that version isn't
  available, record the closest one and stop at this gate with a report.
- [x] Write unit tests: `test_compare_masked` (a byte differing only inside
  a masked span still gives `matched`, one outside gives `near`, a length
  mismatch gives `todo`) and `test_coff_parse` on a hand-built minimal
  big-endian COFF.
- [x] Run them. Expect a failure. Implement `coff.py` and `check.py`. Run
  them again. Expect a pass.
- [x] Choose 5 to 10 game-tier functions from one object: a leaf, a function
  with a call, a virtual method, one that uses floats, and one that uses
  vector (VMX128) code if any exists. Write them, and run
  `python tools/check.py src/...`.
- [x] **Gate A:** at least 5 functions `matched`. Record each function, its
  status and the idioms learned in `docs/specs/phase0-results.md`. If Gate A
  fails, record why (compiler version, flags, headers), and continue with
  Tasks 7 and 8.
- [x] Commit `Phase 0 task 6: match spike`.

### Task 7: the recomp spike (gate B)

**Files:**
- Create: `tools/recomp_config.py`, `tests/test_recomp_config.py`,
  `recomp/MegaHaloGame.toml` (generated, committed),
  `recomp/switch_tables.toml` (from XenonAnalyse, committed)

**Interfaces:**
- Consumes: `pdb.Pdb`, `config/functions.csv`
- Produces:
  - `recomp_config.helpers(pdb) -> dict[str, int]`, which maps the
    XenonRecomp config keys (`savegprlr_14_address`, `restgprlr_14_address`,
    `savefpr_14_address`, `restfpr_14_address`, `savevmx_14_address`,
    `restvmx_14_address`, `savevmx_64_address`, `restvmx_64_address`,
    `setjmp_address`, `longjmp_address`) to VAs, found by PDB name.
  - CLI: `python tools/recomp_config.py`, which writes
    `recomp/MegaHaloGame.toml`, with paths relative to the repo and output
    going to `build/recomp/`.

- [x] Install LLVM, CMake and Ninja with winget. Clone and build
  `hedge-dev/XenonRecomp` in `%USERPROFILE%\haggar-tools\XenonRecomp\`.
  Note its license in the results file.
- [x] Write `test_helpers_found` (`orig`): every key is present, and each
  address is inside the image.
- [x] Run it. Expect a failure. Implement. Run it again. Expect a pass.
- [x] Run XenonAnalyse to produce `recomp/switch_tables.toml`, then
  XenonRecomp to write into `build/recomp/`. Also check XenonRecomp's own
  image loading against our basefile (the bytes at five PDB functions should
  agree).
- [x] Compile a sample of 20 output files with clang-cl, against
  XenonRecomp's PPC headers.
- [x] **Gate B:** the translation completes, the sample compiles, and the
  number of functions translated is within 1% of the PDB's 215,944. Record
  the counts, the unsupported instructions and any analysis failures in
  `phase0-results.md`.
- [x] Commit `Phase 0 task 7: recomp spike`.

### Task 8: the script spike (gate C)

**Files:**
- Create: `tools/script_export/` (a dotnet console app that uses NuGet
  `Eliot.UELib`), `script/MegaHaloGame/Classes/*.uc` (only if the gate passes)

**Interfaces:**
- Produces: `dotnet run --project tools/script_export -- <package.upk> <outdir>`,
  which writes one `.uc` per class and prints `classes=<n> errors=<n>`.

- [x] Decompress `MegaHaloGame.xxx` with Gildor's Unreal package
  decompressor (from gildor.org, into `%USERPROFILE%\haggar-tools\umodel\`)
  into `build/packages/`.
- [x] Build and run `script_export` on it.
- [x] **Gate C:** at least 90% of classes export without decompiler error
  markers, and three classes read as plausible UnrealScript: one Halo pawn
  or weapon, one game info class and one UI class. Record this in
  `phase0-results.md`. If the gate passes, commit the export of the
  MegaHaloGame package.
- [x] Commit `Phase 0 task 8: script spike`.

### Task 9: results

**Files:**
- Modify: `docs/specs/phase0-results.md`, and
  `docs/specs/2026-10-18-design.md` (only where a gate changed the approach)

- [x] Summarize Gates A, B and C (each passed or failed, with numbers), list
  the open problems, and give the recommended Phase 1 scope. Run
  `python -m pytest -q` (with `orig/` present) and paste its final line.
- [x] Commit `Phase 0 task 9: results`.
