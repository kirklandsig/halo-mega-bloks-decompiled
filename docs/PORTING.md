# Porting

Track 1: getting Project Haggar to run natively, first on PC, then on an
Anbernic handheld.

**Status:** the recompiled build runs on Windows x86-64, from boot to the
first level, at 11 to 16 fps on an integrated GPU. On Linux it builds, and it
starts UE3 under WSL2 on a software Vulkan device. Details are in
`docs/specs/phase2-baseline.md`.

## The approach

1. **Static recompilation with the ReXGlue SDK.** ReXGlue's codegen (an
   ahead-of-time translator whose analysis and instruction translations
   follow XenonRecomp) turns every PowerPC function of the executable into
   C++. Our inputs:
   - the PDB's function list (`config/functions.csv`);
   - this compiler's jump tables (`tools/switch_tables.py`, 345 tables);
   - the build's imports (`config/imports.csv`).
   The output compiles with no unimplemented instruction.
2. **A Xenia-hosted runtime.** ReXGlue's runtime is Xenia's (BSD) kernel,
   XAM, `xbdm`, file system, memory, Xenos GPU emulation (D3D12 or Vulkan),
   XMA audio and input, with the JIT taken out. `runtime/` is our host: an
   SDK app that loads the build's XEX and runs the recompiled code.
   - Our fork, `kirklandsig/rexglue-sdk` (branch `haggar`), adds what this
     build needs: `xbdm` return values, two analysis speed-ups for 237k
     functions, instruction tests, and a frame-rate log.
3. **A native renderer for handhelds.** Replace the 360 Direct3D library or
   the UE3 Xenon renderer layer (`XenonD3DDrv`) with a host renderer (GLES or
   Vulkan), and translate shaders with XenosRecomp or Xenia's translator.
   Xenia's GPU emulation is too heavy for mobile chips.
4. **ARM64 from the start.** The recompiled output uses SIMDe rather than
   x86-only intrinsics.
5. **Targets:** Windows x86-64, then Linux and Steam Deck, then an Anbernic
   handheld chosen by profiling the PC build. Low-end devices use UE3's own
   scalability settings.

## Build and run the PC port

### What you need

- **Your own copy of the build:** its folder (the XEX next to `MegaHaloGame\`
  and `Engine\`), with the PDB. The repository ships none of it.
- Python 3.10 or newer, with `pip install -r requirements-dev.txt`.
- About 15 GB free outside synced folders (OneDrive, Dropbox): the generated
  C++ is about 550 MB, and the objects about 500 MB.
- **Windows:**
  - Visual Studio 2022 Build Tools, with the C++ workload (for the Windows SDK
    and libraries, and its bundled CMake and Ninja);
  - LLVM clang 18 or newer (19.1.7 is tested). The official LLVM installer
    works, as does its archive unpacked anywhere.
- **Linux:**
  - clang 19 or newer. clang 18 can't build the SDK: libstdc++ 13's
    `std::expected` needs clang 19;
  - CMake 3.25 or newer, Ninja and `pkg-config`;
  - the X11 and Wayland development packages. On Debian or Ubuntu:
    `libx11-dev libx11-xcb-dev libxext-dev libxi-dev libxfixes-dev
    libwayland-dev libvulkan-dev`;
  - for sound, the ALSA, PulseAudio or PipeWire development packages.

### 1. Clone, with the SDK

```
git clone https://github.com/kirklandsig/halo-mega-bloks-decompiled.git
cd halo-mega-bloks-decompiled
git submodule update --init third_party/rexglue
git -C third_party/rexglue submodule update --init --recursive --depth 1
```

`third_party/xenia` is only needed to regenerate `config/imports.csv`, so you
can leave it out.

On Windows, unless symlinks are enabled (Developer Mode), git checks the
SDK's symlinks out as small text files. Replace them with copies:

```
python tools/fix_symlinks.py third_party/rexglue
```

### 2. Supply the build's files

Copy the XEX and the PDB into `orig/`, under these names:

```
orig/MegaHaloGame.xex
orig/MegaHaloGame.pdb
```

`orig/` is git-ignored. Then write the basefile (the XEX's PE image) and
check the inputs:

```
python tools/xex.py -o orig/MegaHaloGame.exe
python -m pytest -q
```

### 3. Generate the inputs to the recompiler

```
python tools/switch_tables.py      # optional: recomp/switch_tables.toml is committed
python tools/recomp_config.py      # writes build/recomp/haggar_manifest.toml and functions.toml
```

Everything generated goes under `build/`, or `$HAGGAR_BUILD_DIR` if you set
it. Point it outside synced folders.

### 4. Build the SDK

From a Developer Command Prompt (Windows) or a shell (Linux), with clang on
`PATH`:

```
cd third_party/rexglue
cmake --preset win-amd64 -DREXGLUE_BUILD_TESTS=OFF        # Linux: --preset linux-amd64
cmake --build out/build/win-amd64 --config Release --target install
cd ../..
```

On Linux, `.github/workflows/port-linux.yml` has the SDL options that build
without the optional X11 extras.

### 5. Build the game

```
cmake -S runtime -B build/runtime -G Ninja -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_CXX_FLAGS=-march=x86-64-v2
cmake --build build/runtime --target haggar_codegen   # the codegen (about a minute)
cmake -S runtime -B build/runtime                      # picks up the generated file list
cmake --build build/runtime                            # the 506 generated files (6 to 11 minutes)
```

On Linux, the line continuation is `\`, not `^`. The codegen writes the list
of generated sources, so configure again after it, then build. `runtime/`
uses this clone's SDK (`third_party/rexglue/out/install/`) before any other
ReXGlue registered with CMake.

### 6. Run

```
build\runtime\haggar.exe --game "<the build's folder>"
```

The game folder stays read-only. The game's own logs and profiling files go
to `DEVKIT:\`, which `haggar` maps to `<user data>\devkit` (by default, your
platform's user folder under `haggar`; change it with `--user_data_root`).

- **Controls:** an XInput or SDL controller. For the keyboard,
  `--mnk_mode=true` maps it: Space is A, Backspace is B, WASD is the left
  stick, the arrow keys are the right stick.
- **The briefing screen** waits for A once the level has loaded.
- **The dev menu** opens with Back (Select).
- **Known issues** (the build's own, as in Xenia):
  - If you can't move after loading in, toggle Ghost / Walk on and off in
    the dev menu.
  - If you're stuck "perma-running", use the dev menu's Suicide.
  - Spawning the Warthog crashes the game, and so does auto-building
    structures from the dev menu.
  - The winch objective needs the dev menu's Complete Objective.
- **Options for testing:**
  - `--capture_every=N --capture_dir=<folder>` saves the guest frame every N
    seconds;
  - `--press="A@40,LS_UP@60-70"` scripts a controller;
  - `--audio=nop` runs without an audio device;
  - `--log_file=<file>` writes the log. It includes the game's own log lines
    and a `VdSwap` frame-rate line every 300 frames.

### Steam Deck (a user step, untested)

The Linux build is untested on real GPUs. Build it on a Linux machine (or in
a distrobox on the Deck), using steps 1 to 5 with the Linux preset. Copy
`build/runtime/` (`haggar`, `librexruntime.so`, `librexgpu-xenos.so`,
`libTracyClient.so`) and the game folder to the Deck, and run
`./haggar --game <folder>` from desktop mode. The Deck's GPU goes through
Vulkan. Please report how far it gets, and the `VdSwap` frame-rate lines.

### Without the build's files

`python tools/stub_recomp.py` writes a stand-in for the generated code. With
`-DHAGGAR_SKIP_CODEGEN=ON`, `runtime/` then builds and links with no `orig/`.
CI uses this to catch host and Linux build breakage. The result runs no game.

Matched C++ from Track 2 replaces recompiled functions one at a time, which
is how the decomp becomes the moddable layer.

## Named seams

The PDB names the places a port replaces: the 360 Direct3D library (2,485
functions), the UE3 Xenon renderer (`XenonD3DDrv`, 1,065 functions), XAudio2,
the kernel and XAM imports, and the PowerPC register save and restore
helpers.
