# Decompiling

How to turn one of n-Space's functions back into matching C++.

## The rule

A function is done when XDK 21076 `cl` (16.00.11886), run with the command
line the PDB records for its object, produces the same bytes as the retail
executable, apart from the fields relocations fill in (branch targets,
addresses of globals and constants). `tools/check.py` decides that.

The build has no link-time code generation, so each object is compiled and
compared on its own. Objects are unity files (`Unity_<First>EtAl.cpp`) that
include several `.cpp` files; the PDB's line information names each
function's original file and line (the `source` and `line` columns).

## Files and markers

- C++ goes in `src/<Package>/Src/<File>.cpp`, mirroring the original tree.
- Declarations go in `include/<Package>/Inc/`, and are included with paths
  relative to `include/` (for example `#include "UDKBase/Inc/HaloRBTKamikaze.h"`).
- Each source file names its object once, at the top:

  ```cpp
  // @object Unity_HaloRBTKamikazeEtAl.cpp.obj
  ```

- Each function gets its retail address on the line above it:

  ```cpp
  // @retail 0x83333B58
  GripRBTNode::EBTExecutionResult HaloRBTKamikaze::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
  {
      CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
      m_kamikazeState = Initialize;
      return ER_INPROGRESS;
  }
  ```

  An inline function defined in a header gets its marker in the `.cpp` too,
  as a comment, so the checker knows to compare it.

`src/UDKBase/Src/HaloRBTKamikaze.cpp` is the worked example: ten functions,
all matched.

## The check

```
python tools/check.py src/UDKBase/Src/HaloRBTKamikaze.cpp
```

For each file, `check.py`:
1. reads `// @object` and finds the object's command line in
   `config/objects.csv`;
2. compiles the file with that command line, with every `-I` replaced by
   `include/` and the XDK's `include/xbox`, into `build/obj/`;
3. finds each `// @retail` function in our object by its decorated name (the
   `symbol` column), or by its plain name when the PDB has no decorated one;
4. compares its bytes with the basefile's, masking relocated fields, and
   prints `matched`, `near` (same length, other bytes) or `todo`;
5. merges the results into `config/status.csv`.

It exits 1 while any marked function differs. `config/functions.csv` is
never written by it.

## Reading the original

- `config/functions.csv`: address, size, name, decorated symbol, object,
  original source file and line of every function.
- `python tools/pdbtype.py <Type>`: a class, struct or enum from the PDB, with
  member offsets, base classes, the vtable pointer and bitfields.
- Disassemble the basefile (`orig/MegaHaloGame.exe`, image base
  `0x82000000`) at the function's address, for example with capstone in
  PowerPC 32-bit big-endian mode.
- `script/<Package>/Classes/`: the UnrealScript side of a native class.

## Idioms learned so far

- **Headers can be minimal.** A base class can be an opaque `char` array of
  the PDB's size behind a vtable pointer. Only the slot index of each virtual
  that is called matters, so unknown slots can be `ReservedSlotN`
  placeholders.
- **An 8-byte class passed by value** (`FName`) arrives in one 64-bit GPR and
  is stored with `std`.
- **Unity builds matter.** A `.cpp` function of the same unity object can be
  inlined into one call site and called at another, as in retail, once it is
  defined in the same file.
- **`static_cast` from an interface at a non-zero offset**, followed by a
  member access, emits no null check: the offsets fold.
- **Out-of-line copies** of inline functions and templates are forced with an
  explicit instantiation or by taking the function's address.
- **`-W4 -WX` is kept**, so hand-written headers have to compile without
  warnings.
- **Float constants** are loaded from `.rdata` through `REFHI`/`REFLO`
  relocations, which the comparison masks.
- **Vector (VMX128) code** hasn't been matched yet. If you match some, add
  what you learn here.

## When it doesn't match

Try a few distinct ideas (member order, an inline helper, a different
expression shape, the original file's other functions being present). If it
still differs, leave the function `near`, say in a comment what you suspect,
and move on. Near misses often match once their callees or headers improve.
