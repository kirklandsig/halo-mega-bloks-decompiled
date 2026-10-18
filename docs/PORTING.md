# Porting

Track 1: getting Project Haggar to run natively, first on PC, then on an
Anbernic handheld.

## The approach

1. **Static recompilation with a XenonRecomp fork.** XenonRecomp translates
   every PowerPC function of the executable into C++. The function list comes
   from the PDB (`config/functions.csv`; `tools/recomp_config.py` writes the
   config into `build/recomp/`). Phase 0 translated the whole executable and
   20 of 20 sampled output files compiled. The fork adds what this compiler
   needs:
   - its jump-table pattern (`lis; slwi; addi; lwzx; mtctr; bctr`, about 320
     sites), which upstream XenonAnalyse doesn't recognise;
   - the 52 instruction types XenonRecomp doesn't translate yet (`bdzf`,
     update-form loads and stores such as `stfsu` and `lhzu`, VMX shifts and
     packs such as `vsrah` and `vsel128`, and others).
   The target is zero warnings and a full compile.
2. **A Xenia-hosted runtime first.** Reuse Xenia's (BSD) kernel and XAM, its
   GPU (Xenos emulation over D3D12 or Vulkan) and its XMA audio, and replace
   only its CPU JIT with the recompiled code. This is the quickest route to a
   running PC build. Its first step is a baseline: does the build boot in
   Xenia at all?
3. **A native renderer for handhelds.** Replace the 360 Direct3D library or
   the UE3 Xenon renderer layer (`XenonD3DDrv`) with a host renderer (GLES or
   Vulkan), and translate shaders with XenosRecomp or Xenia's translator.
   Xenia's GPU emulation is too heavy for mobile chips.
4. **ARM64 from the start.** The recompiled output uses SIMDe or NEON rather
   than x86-only intrinsics.
5. **Targets:** Windows x86-64, then Linux and Steam Deck, then an Anbernic
   handheld chosen by profiling the PC build. Low-end devices use UE3's own
   scalability settings.

## Running the recompiler today

```
python tools/xex.py -o orig/MegaHaloGame.exe --decrypted orig/MegaHaloGame.dec.xex
python tools/recomp_config.py
XenonAnalyse orig/MegaHaloGame.dec.xex recomp/switch_tables.toml
XenonRecomp build/recomp/MegaHaloGame.toml <XenonRecomp>/XenonUtils/ppc_context.h
```

The XEX is devkit-signed, and XenonRecomp knows only the retail key, so it
reads the decrypted copy. The output is about 540 MB of C++; keep it out of
synced folders.

## Phase 2 steps

1. Fork XenonRecomp: the jump-table pattern and the missing instructions,
   then a full compile of every output file.
2. The Xenia baseline: boot the build in Xenia and note how far it gets.
3. The Xenia-hosted recompiled build: boot, then the title screen, then
   gameplay.
4. Linux and Steam Deck.

Matched C++ from Track 2 replaces recompiled functions one at a time, which
is how the decomp becomes the moddable layer.

## Named seams

The PDB names the places a port replaces: the 360 Direct3D library (2,485
functions), the UE3 Xenon renderer (`XenonD3DDrv`, 1,065 functions), XAudio2,
the kernel and XAM imports, and the PowerPC register save and restore
helpers.
