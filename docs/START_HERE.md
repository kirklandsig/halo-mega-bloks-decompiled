# Start here

Want to help rebuild Project Haggar, the cancelled Halo Mega Bloks game? This
page gets you from nothing to your first pull request. Most of it is a
one-time setup. After that you can work by hand, or paste the prompt below
into an AI coding agent (Claude Code, Codex, Cursor or similar) and review
what it does.

No decompilation experience is needed. Some C++ helps.

This is a community project. You'll be working alongside other contributors,
many with AI agents of their own, and alongside the maintainer's automated
lanes. The claims issue in step 2 keeps everyone out of each other's way, and
everyone whose work is merged is credited in the README's
[community list](../README.md#the-community).

## 1. Set up (once)

- [ ] **Your own copy of the build's files**, which you supply yourself: put
  `MegaHaloGame.xex` and `MegaHaloGame.pdb` in `orig/`, or point `HAGGAR_XEX`
  and `HAGGAR_PDB` at them. The project does not distribute them.
- [ ] **Unpack the executable:**

  ```
  python tools/xex.py -o orig/MegaHaloGame.exe
  ```

  It prints the basefile's SHA-256, which must be
  `af5c3002e4877cd9b92735e8c70e72997bf5f4eea5f44b51a79956ab57940e0b`.
- [ ] **The compiler:** XDK 21076, whose `bin\win32\cl.exe` prints
  `Version 16.00.11886.00 for PowerPC`. Point `XDK_DIR` at the folder that
  holds `bin` and `include`. The project does not distribute it and can't
  help you obtain it. Script review, analysis and documentation don't need it.
- [ ] **Python 3**, then `pip install -r requirements-dev.txt`.
- [ ] **Windows** (the compiler is a Win32 program).
- [ ] **Check it works:**

  ```
  python tools/check.py src/UDKBase/Src/HaloRBTKamikaze.cpp
  ```

  It should print `matched` ten times.

`orig/`, `sdk/` and `build/` are git-ignored. Never commit anything from them.

## 2. Claim some work

The decomp's scope is n-Space's own C++: the rows of `config/functions.csv`
whose `owner` is `nspace`. They are grouped by object (one unity `.cpp` of
the original build); [PROGRESS.md](PROGRESS.md) lists the objects and how
much of each is matched.

1. Read the pinned
   [Active claims](https://github.com/kirklandsig/halo-mega-bloks-decompiled/issues/1)
   issue. You may claim one object, or a group of related functions in one,
   that nobody else holds. The maintainer's automated lanes make way for
   you.
2. Check the [open pull requests](https://github.com/kirklandsig/halo-mega-bloks-decompiled/pulls)
   too, in case someone claimed something a moment ago.
3. Open a **draft pull request** that names what you are taking, for example
   "Claimed: `Unity_UDKWeaponEtAl.cpp.obj`, the `UHaloAnimBlend*` functions".
   That is your claim; the maintainer adds it to the issue. A claim with no
   activity for two weeks lapses.

Script work (reviewing, naming and commenting the classes in `script/`) can
be claimed the same way, by class.

## 3. Decompile

To work by hand, follow [DECOMPILING.md](DECOMPILING.md). To work with an AI
agent, open it in your clone of the repository and paste this prompt. If you
have already claimed something, replace the claim line with it.

```text
You are helping with a matching decompilation of n-Space's C++ code in Project Haggar, the cancelled Halo Mega Bloks game for the Xbox 360, in this repository. A function counts as done only when the original compiler (XDK 21076, cl 16.00.11886), run with the flags the PDB records for its object, turns our C++ back into the retail executable's exact bytes; `python tools/check.py` decides that.

My claim: none yet.

First read docs/START_HERE.md, README.md (Build and check), CONTRIBUTING.md and docs/DECOMPILING.md, and follow them.

Setup check. Stop and tell me if any step fails:
1. `orig/MegaHaloGame.pdb` exists (or `HAGGAR_PDB` points to it), and `orig/MegaHaloGame.exe` exists with SHA-256 af5c3002e4877cd9b92735e8c70e72997bf5f4eea5f44b51a79956ab57940e0b (`python tools/xex.py -o orig/MegaHaloGame.exe` writes it).
2. `XDK_DIR` points to a folder whose `bin/win32/cl.exe` prints version 16.00.11886.
3. `python tools/check.py src/UDKBase/Src/HaloRBTKamikaze.cpp` prints `matched` ten times. Copy `config/status.csv` to `build/baseline.csv`.

Finding work, if my claim above is "none yet": read docs/PROGRESS.md and `config/functions.csv` (rows with owner `nspace`), and show me three good starts: small objects, or groups of small leaf functions in one object that nobody holds on issue #1. When I pick one, give me a claim line for a draft pull request. Don't start until the claim is up.

Work only on the functions my claim covers.

Work loop:
1. For each function, read its row in `config/functions.csv` (address, size, name, decorated symbol, object, original source file and line), its types with `python tools/pdbtype.py <Type>`, and retail's code by disassembling the basefile at its address (for example with capstone, PowerPC 32-bit big-endian).
2. Write the C++ in `src/<Package>/Src/<File>.cpp`, with `// @object <obj>` once at the top of the file and `// @retail 0x<va>` on the line above each function. Put the declarations it needs in `include/<Package>/Inc/`, rebuilt from the PDB's types: base classes may be opaque, sized byte arrays behind a vtable pointer, and unknown virtual slots placeholders.
3. Run `python tools/check.py <file>` after each change. It compiles with the object's own flags (including -W4 -WX, so headers must compile cleanly) and prints matched, near or todo per function.
4. Time-box: if a function isn't matched after a few distinct attempts, leave it `near`, note the suspected cause in a comment, and move on.
5. Never keep a change that makes a function that matched before stop matching.

Rules:
- Use the PDB's names, types and source paths directly. Never use leaked Unreal Engine source.
- Stay inside my claim. Outside it, change only shared declarations, and list every such change.
- No false matches: the bytes can match while a call passes the wrong values. Keep signatures true to the PDB's types.
- Never commit anything from `orig/`, `sdk/` or `build/`, or any game, SDK or UDK file. Commit with my GitHub no-reply email address.

Finish:
1. Run `python tools/check.py` on every file I touched.
2. Compare `config/status.csv` with `build/baseline.csv`. List every function that went from `matched` to anything else (there must be none) and every new match.
3. Write a summary for my pull request: what matches, what is near and why, and every change outside my claim.
```

Read what the agent did before you push. Matching bytes are checked
automatically, but whether the code reads like the original is up to you.

## 4. Open the pull request

- Push your branch and mark the draft pull request ready.
- Say what matched, what is near, and any change outside your claim.
- Commit with your GitHub no-reply email address
  (`<id>+<username>@users.noreply.github.com`).
- Commit `config/status.csv` with your matches. Don't commit
  `config/functions.csv` unless you changed the inventory tool.

We check every pull request against the current `main` and merge it with a
merge commit, so your authorship stays in the history. Questions are welcome
as issues.
