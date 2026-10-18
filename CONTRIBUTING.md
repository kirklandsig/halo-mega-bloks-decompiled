# Contributing to the Halo Mega Bloks (Project Haggar) decompilation

Thanks for helping. New here? Start with [docs/START_HERE.md](docs/START_HERE.md).

## What you can work on

- **n-Space's C++** (matching): the `nspace` rows of `config/functions.csv`.
  Epic's engine and UDK code is recompiled, not hand-decompiled.
- **UnrealScript**: reviewing, naming and commenting the classes in
  `script/`, and cross-linking them with the native functions they declare.
- **The port**: see [docs/PORTING.md](docs/PORTING.md).
- **Tools, docs and the inventory** (for example the owner column, which is
  a heuristic: corrections welcome).

## What you need

Your own copy of the build's files, and XDK 21076 (`cl` 16.00.11886) for
matching. The project distributes neither and can't help you obtain them.
Script and documentation work need neither.

## Claim before you start

1. Check the pinned
   [Active claims](https://github.com/kirklandsig/halo-mega-bloks-decompiled/issues/1)
   issue and the open pull requests.
2. Claim one object, or a group of functions or script classes nobody else
   holds. The maintainer's automated lanes make way for contributors. A claim
   with no activity for two weeks lapses.
3. Open a **draft pull request** early that names your claim.

## Working

- Follow [docs/DECOMPILING.md](docs/DECOMPILING.md): the `// @object` and
  `// @retail` markers, minimal headers, and the known compiler idioms.
- Run `python tools/check.py <your files>` before you push. A function that
  matched before must still match.
- Near misses are fine to commit with their markers and a note on the
  suspected cause.
- Run `python -m pytest -q`. It passes without the build's files.

## Pull requests

- Say what matched, what is near, and every change outside your claim.
- Never commit anything from `orig/`, `sdk/` or `build/`, game or SDK files,
  or UDK's own script classes.
- Commit with your GitHub no-reply address.

## Licence

By contributing you agree that your contribution is released under
[CC0 1.0](LICENSE), like the rest of the project's own work.
