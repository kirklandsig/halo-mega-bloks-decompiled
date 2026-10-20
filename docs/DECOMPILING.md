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

## Headers

`tools/gen_header.py` writes a header from the PDB:

```
python tools/gen_header.py HaloRBTKamikaze CCSBlackboard ... --opaque ICCSMeatPuppet -o include/UDKBase/Inc/HaloRBTKamikaze.h
```

- The named classes (targets) get their data members at the PDB's offsets,
  with explicit `_padN` arrays where the PDB has nothing.
- Everything else they need comes along: bases, the types of by-value
  members, forward declarations, enums and namespaces. Those classes are
  opaque (their data is one `char` array of the PDB's size) unless named.
  `--opaque` adds a class the code calls through but that nothing pulls in,
  such as the target of a pointer member.
- Every class keeps its vtable (its own virtuals in slot order) and its
  methods, with the PDB's access, so decorated names match.
- The PDB has no bodies. Inline functions go below the
  `// ---- written by hand below this line` marker as `inline` definitions
  outside the class; regenerating keeps that part. Member templates the PDB
  doesn't list are added with `--add 'Class=decl'`.
- The header's first lines record the command that wrote it.

## Generated code

`tools/gen_classes.py <Package>` writes what UE3's macros and its script
compiler expand to, for n-Space's native classes:
`include/<Package>/Inc/<Package>Classes.h` (declarations from gen_header.py,
then the inline bodies) and `src/<Package>/Src/<Object>Classes.cpp` (the
markers, and `IMPLEMENT_CLASS`'s two functions). Re-run it rather than
editing its output.

The 683 `nspace` rows whose source is a `*classes.h` header or that have no
source line, by shape (matched after Phase 3's Task 2):

| Group | Rows | Matched | What it is |
| --- | ---: | ---: | --- |
| `StaticClass` | 84 | 84 | `DECLARE_CLASS`: inline, builds the `UClass` on first use |
| `operator new(size_t, EInternal *)` | 84 | 84 | `DECLARE_CLASS`: returns its argument |
| `InternalConstructor` | 84 | 81 | `DECLARE_CLASS`: placement new of the class |
| constructor | 85 | 80 | `NO_DEFAULT_CONSTRUCTOR`, the bases' empty constructors inlined |
| destructor | 101 | 73 | `DECLARE_CLASS`: `ConditionalDestroy()`, then the base's destructor |
| scalar deleting destructor, other compiler thunks | 100 | 73 | compiler-generated from the virtual destructor |
| `event<Name>` thunk | 15 | 15 | script compiler: fill `_Parms`, `ProcessEvent` |
| `exec<Name>` thunk | 64 | 0 | script compiler: read `FFrame` parameters, call the native (n-Space's additions to Epic's classes add 74 more, 74 matched) |
| other (cpptext inlines such as `GetType`) | 66 | 0 | hand-written in the class's `cpptext` |

`IMPLEMENT_CLASS`'s `GetPrivateStaticClass<Class>` and
`InitializePrivateStaticClass<Class>` (in the `.cpp` files) are generated too.

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
   `symbol` column), or by its plain name when the PDB has no decorated one
   (several file statics of one name, such as USSPawn's two `UnwindRot`
   overloads, pair with ours in address order: the n-th in retail is the
   n-th our object defines);
4. compares its bytes with the basefile's, masking relocated fields, and
   prints `matched`, `near` (same length, other bytes) or `todo`;
5. merges the results into `config/status.csv`.

It exits 1 while any marked function differs. `config/functions/` is never
written by it.

## Reading the original

- `config/functions/`: address, size, name, decorated symbol, object,
  original source file and line of every function, one CSV file per tier
  (`game.csv` holds every `nspace`, `epic` and `vendor` row; the engine, lib
  and platform rows are cut into files of at most 8 MB). Tools load it with
  `inventory.read_functions()`; grep works on the folder.
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
- **A declared inline must be defined.** The generated header declares
  every method the original had, including inline ones such as
  `FName::FName()`. Left undefined, it becomes a call, and every function
  around it stops matching. Define it (often an empty body) in the hand part.
- **Empty classes stay empty** (`GripHeapObject`, size 1 in the PDB). Giving
  one a byte of data breaks the empty-base layout of everything that
  derives from it.
- **`check()` records `__LINE__`.** `IMPLEMENT_CLASS` expands on one
  line, so its `check` carries the macro's line (the PDB's `line` column).
  The generated code sets it with `#line`.
- **Base destructors are inlined only when they destroy nothing.** A base
  whose own members have destructors (`TArray`, `FString`) is called; one
  without is inlined into the derived destructor.
- **Opaque blobs keep the class's alignment** (`unsigned int` words for a
  4-byte-aligned class), so a struct copy stays a word copy.
- **`UBOOL` event parameters** are stored as `x ? FIRST_BITFIELD : 0`
  (`0x80000000` on this big-endian target).
- **Out-of-line copies under `#pragma inline_depth(0)`.** Taking a member's
  address there (`extern decltype(&C::f) const p = &C::f;`) emits the copy
  retail has, with the usual inlining inside it.
- **Overloaded virtuals in adjacent slots are declared in reverse.** MSVC
  lays a group of same-named virtuals out in reverse declaration order, so
  gen_header.py emits them that way to land on the PDB's slots.
- **A pointer parameter's own `const`** (`void *const Result`) is part of the
  decorated name; pdbtype.py keeps it.
- **The PDB's public symbols name vtables** (`??_7<Class>@@6B@`), which tells
  which class a `new` built when the constructor is inlined.
- **One header, two builds.** Generated headers spell virtuals, access and
  members with `HG_*` macros (`include/Core/Inc/HostGuest.h`): plain C++ for
  the XDK, guest-memory structs for the port (`docs/specs/phase3-port-swap.md`).
- **Vector (VMX128) constants** match: the dynamic initializers of UE3's
  `static const VectorRegister` globals (`include/Core/Inc/UnMathXe.h`).
  Other vector code is untested.

### From the AI code (2026-10-19)

- **Include the unity's other `.cpp` files** (`#include "CCSCover.cpp"`, each
  with `#pragma once`) so their functions inline where retail inlines them;
  `check.py` only reads the markers of the file it is given.
- **Inline layers are hand-written headers:** `Core/Inc/Core.h`, `Array.h`
  (`TArray`, with `#line` so each `check()` carries retail's line),
  `ScriptInterface.h`, `Grip/Inc/GripContainers.h`, `GwNav/Inc/RefCount.h`
  and `<Package>Inline.h`. gen_header.py skips the types they provide
  (`PROVIDED_*`; Grip's containers are included mid-header, once their bases
  are complete).
- **Callee bodies change the caller.** MSVC uses what it knows of an inline
  callee (what it reads and writes); a declared-only callee forces reloads.
- **The inlining budget is real.** Retail sometimes calls a function it
  inlines elsewhere (a second `GetHighestThreatTarget`, `StaticClass`,
  `CCSCharacter::GetActor`). Forced inlining (`__forceinline`) fixes the
  opposite case.
- **Natural padding stays implicit** in the XDK branch of generated headers,
  so an aggregate initializer (`CCSAOFlee Objective = {Target};`) zero-fills
  the tail in words, as retail does.
- **Named locals change evaluation order.** For `obj->f(arg)`, MSVC fetches
  `obj` first; retail's order (argument, then object) comes from a named
  local for the argument (`FRotator Delta = ...; CCSPawn->CanAim(Delta)`). A
  named temporary also makes a constructor's result come from its address
  (`addi`) rather than from `r3`.
- **`a == b` versus `b == a`** decides which register is subtracted from which
  (`subf`), and `x * s` versus `s * x` the operand order of `fmuls`.
- **Result variables:** `li r3,1` before the work, or a bool set to `false`
  in a branch, means the source kept a result variable.
- **Float `Min`/`Max` use `fsel`** (Xenon specializations), and
  `appInvSqrt` is `1.0 / __fsqrt(x)` in double; `appSqrt` is `__fsqrts`.
- **`slwi rX, rY, 0`** appears when a value is forwarded from a store to a
  later use (an `FRotator` written and then subtracted).
- **Interlocked operations** (`_InterlockedExchangeAdd`) compile to the
  `mfmsr`/`mtmsrd`/`lwarx`/`stwcx.` sequence of Grip's string release.
- **By-value class parameters are destroyed by the callee** (`FString`,
  `Grip::String`).

### From the last of the AI code (2026-10-19)

- **Assignment order inside a branch** decides which value lives in a saved
  register: `bResult = 1; if (...) { bResult = 0; OutErrorMsg = ...; }`
  (`UCCSActorFactory::CanCreateActor`) differs from the other order.
- **Declaration order is store order** for small locals: two `Grip_Color`s
  built at the top of `DrawHUD` store their bytes in the order they're
  declared.
- **Copies through a by-value return** keep a struct in a stack copy:
  `FRotator Aim = Rotation; Aim = Aim.GetNormalized();` stores the rotator
  where normalizing its members in place keeps it in registers
  (`AUSSPawn::CanAim`).
- **How a vector is built** changes later operand order:
  `FVector D = A - B; D.Z = 0.0f;` is not `FVector D(A.X - B.X, A.Y - B.Y, 0)`
  (`AUSSPawn::MoveToInCover`).
- **A named temporary** makes its address the argument (`addi`) and lets the
  slot be reused (`GetNodeTitle`'s `Printf` result); a named `FString` inside
  an `if` block gives each exit its own destructor, where a temporary in the
  condition needs a "constructed" flag (`CCSBlackboard::GetSpecificTarget`).
- **Default arguments are not the same as passing the default:**
  `ConstructObject<T>(Class, Outer)` keeps the default `FName` in a stack
  temporary held by address; `FName(NAME_None)` written out doesn't.
- **`GetData()[i]`** adds base + offset where `operator[]` adds offset + base
  (`UpdateTargetPointers`' out-of-range loop).
- **A file-scope static object** with an inlinable constructor has a dynamic
  initializer that only registers its atexit destructor; that destructor
  stores the base class's vtable, so the base's virtual destructor has to be
  defined inline (`s_brainFinderCCS`).
- **`FVector::Normalize` is plain inline:** retail inlines it in one function
  and calls it in another (`CCSAFStrafeTarget`); forcing it inline breaks the
  second.
- **`TMap::Set`** builds an `FPairInitializer` that holds a class key by
  reference and a pointer value by value, then calls `TSet::Add` out of line
  (`Core/Inc/Map.h`).

### From the Epic additions and the CCS layer (2026-10-20)

- **Dot products and sums written out** can fix the evaluation order: where
  `Right | Dir` computes Z first, `Dir.X * Right.X + Right.Y * Dir.Y +
  Right.Z * Dir.Z` gives retail's X-first order (`AUDKVehicle::moveTowardGwNav`).
- **Virtual inline functions** get their out-of-line copy from a non-virtual
  call under `#pragma inline_depth(0)` (`p->C::f()`); taking a virtual's
  address gives a vcall thunk instead.
- **A struct of 8 bytes or less returned by value** comes back in r3 only if
  it is complete where the method is declared; gen_header.py orders such
  return types first (`GripStatEntry` before `CCSStat`).
- **A result variable assigned in both paths** keeps its register:
  `bool b = false; if (...) b = Base::f(); return b;` where an early
  `return Base::f();` folds the false path to `li r3, 0`.
- **A negated boolean condition** in the CCS nodes is
  `return m_negate ? !bValue : (bool)bValue;`: the cast on the other arm is
  retail's final `clrlwi`.
- **Retail inlines other files' functions** of the unity, including a
  `.cpp`'s constructor into another file's function: include that `.cpp`
  (`#include "CCSGSCover.cpp"`) and define the header inlines it relies on
  (`operator new` of Kaim's classes goes to `Kaim::Memory::pGlobalHeap`).
- **A named local** can make a reload disappear: `UGwNavBotHandle *pHandle =
  m_pGwNavBotHandle;` where re-reading the member reloads it after a branch.
- **Zeroing order** of a local struct follows the statements: retail's
  `CCSGameCharacter::GetOrientation` stores Roll, Yaw, Pitch, so the
  assignments are written in that order.

### From the rest of the CCS layer (2026-10-20)

- **Include the callee's file** even when nothing of it inlines: the
  compiler then knows which registers the call leaves alone and keeps
  values in volatile registers across it, as retail does (`r7` or `r8`
  live across a `bl`). A dozen near and todo functions matched this way
  (`#include "CCSAFFactory.cpp"`, `"../CCSRefUE3/CCSGameCharacter.cpp"`).
  A scratch script that tries each callee's file in turn finds them.
- **Calls that must stay calls:** an event thunk or an inline the retail
  calls out of line goes through a member pointer,
  `(p->*(&C::eventX))(...)`.
- **Aggregate init of the action objectives** (`CCSAOFlee Objective =
  {Target};`) avoids the default constructor's zero stores; a trailing bool
  left out zero-fills a whole word.
- **`cond ? floatExpr : 100000.0`** with a double literal gives retail's
  `frsp` after the select.
- **If-chains and switches** decide the compare chains; a switch's case
  blocks are laid out in source order, so write the cases in the order of
  retail's targets (`CCSCoverRenderingProxy::Render`).
- **Inline budget:** the first use of a getter inlines and later ones are
  called, as in retail; `__forceinline` (the actor iterator's `operator*`)
  where UE3 has `FORCEINLINE`.
- **A function-static or file-static of a header** (`static
  CCSAIManagerFactoryRegister s_AIManagerFactoryRegister;`) gets its
  dynamic initializer per file; where the constructor is defined in the
  same unity it inlines.
- **A temporary returned by an out-of-line call** is reused through the
  returned pointer (`mr r4, r3`); retail's `addi r4, r1, N` means a named
  local, `Grip::String Printed(Buffer); Value = Printed;`.
- **A string's size and data:** `Grip::String::GetSize` reads its
  descriptor through a named local, or the mask is computed twice.
- **Unsolved so far:** add operand order (offset + base against base +
  offset), saved-register assignment order, retail loading `this` fields
  before a position in an objective's initializer, frame-slot reuse of
  temporaries (a 4-byte struct sharing a slot with a later string) and the
  operand order of a sum with `DeltaTime`.

## When it doesn't match

Try a few distinct ideas (member order, an inline helper, a different
expression shape, the original file's other functions being present). If it
still differs, leave the function `near`, say in a comment what you suspect,
and move on. Near misses often match once their callees or headers improve.
