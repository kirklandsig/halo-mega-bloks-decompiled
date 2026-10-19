# Phase 3 spike: matched source in the port

Status: done, within the time-box (2026-10-18). The question was whether one
source file can build both for the XDK (to match retail) and for the PC port
(as a `REX_HOOK` that replaces the recompiled function), without two copies of
the code. **It can.** The spike also showed what that costs.

## The form

One generated header serves both builds. `tools/gen_header.py` writes its
classes with a few macros from `include/Core/Inc/HostGuest.h`:

| In the header | XDK build | Host build (`HAGGAR_HOST`) |
| --- | --- | --- |
| `HG_VIRTUAL`, `HG_PURE` | `virtual`, `= 0` | nothing: an ordinary member function |
| `HG_VFPTR` (a class that starts a vtable) | nothing (the compiler adds it) | `hg::be<unsigned int> __vfptr;` |
| `HG_PRIVATE`, `HG_PROTECTED` | `private`, `protected` | `public`, so hooks can call any member |
| `HG_XDK(...)` (destructors) | the declaration | nothing |
| data members | plain members | an `#else` block: `hg::be<T>` for values, `hg::gptr<T>` for pointers, at the same offsets |
| static members | `static T x;` | `static T (&x);`, bound to the guest address from the PDB's public symbols |

On the host, a class describes guest memory: a host pointer to it is
`base + guest address`, and members read and write big-endian values in
place. The XDK build expands the macros to the plain C++ it had before, so
nothing changes there: all 877 matched functions still match, and
`tests/test_sources.py` checks that on every run.

`gen_header.py --host-thunks <file>` also writes the host build's **weak
bodies** for the header's methods:

- a method with a retail address calls the recompiled function by address
  (`hg::call`), marshalling `this` and the arguments into a `PPCContext`;
- a pure virtual calls through the guest vtable (`hg::vcall(slot, ...)`), at
  the slot the PDB gives;
- static members are bound to their guest addresses.

A decompiled definition in `src/` is strong, so at link time it replaces the
weak thunk of the same function. A hook is then a few lines
(`runtime/src/decomp/hooks.cpp`): take `this` and the arguments from the
registers, call the decompiled member, put the result in `r3`.

The generated functions in ReXGlue's output are weak aliases (`sub_<addr>`),
so a hook's strong `sub_<addr>` replaces the recompiled one everywhere,
including in the dispatch table for indirect calls. `-DHAGGAR_DECOMP_HOOKS=ON`
builds `runtime/src/decomp/` into `haggar.exe`; it is OFF by default.

## What was tried

The three functions are matched ones from
`src/UDKBase/Src/HaloRBTKamikaze.cpp`, compiled unchanged for the host:

| Function | Kind | What it exercises |
| --- | --- | --- |
| `CCSBlackboard::GetCurrentTarget` (`0x8332E718`) | leaf | member reads through a guest pointer, an inlined `operator==` against a static (`CCSCharacter::NONE`, bound to its guest address) |
| `HaloRBTKamikaze::ExecutePreInternal` (`0x83333B58`) | calls another game function | `CCSRBTMoveTo::ExecutePreInternal` through its weak thunk, by address; a member write |
| `HaloRBTKamikaze::TestPreCondition` (`0x83333A88`) | virtual calls | two pure virtuals through guest vtables (slots 8 and 41, as in the XDK build), and the leaf |

For the leaf, the hook also runs the recompiled original on the same input
(it only reads) and logs any difference in the result.

## Results

| Check | Result |
| --- | --- |
| XDK build | unchanged: 877 matched, 4 near |
| Host build of the header and the source file | compiles with the port's clang (C++23); `tests/test_gen_header.py::test_host_layout_matches_pdb` asserts every member offset and size on the host |
| Link | `haggar.exe` links with the three hooks and the weak thunks |
| Run (Windows, D3D12, scripted controller, guest frames captured) | **reaches M5**: the jungle level with the full HUD, at the usual 12 to 14 fps |
| Hook override in effect | yes: a pass-through control hook on `UObject::ProcessEvent` logged more than 200,000 calls in four minutes |
| The three decompiled functions | **not called** in the runs (150 s and 250 s): the player can't move until Ghost / Walk is toggled in the dev menu (the build's known issue), so no CCS AI ran. The leaf's comparison therefore has no data yet |

## What it costs

Per function, once the header form exists:

- **Nothing in the source.** The matched `.cpp` compiles for the host as it
  is, with one exception: constructors (below).
- **A hook wrapper**, about five lines, which a script could generate from
  the declaration (the same marshalling the thunks do).
- **The header's host thunks**, generated, about 350 lines for this header.

The limits found:

1. **Constructors and destructors stay recompiled.** Host C++ can't write a
   constructor without constructing its bases and members on the host side,
   and the host never creates or destroys guest objects. The one decompiled
   constructor in the file is wrapped in `#ifndef HAGGAR_HOST`.
2. **A non-pure virtual called without qualification** (`p->Tick()`) is
   ambiguous on the host. Its thunk calls the declaring class's function by
   address, which is right for `Super::Tick()` but wrong when the object
   overrides it. Fixing that means either a vtable call with a "not from my
   own override" check, or writing qualified base calls with a macro. Pure
   virtuals have no such problem.
3. **Marshalling covers scalars, enums and pointers to guest objects.** A
   reference, or a pointer to a scalar, could point at host memory (a local)
   or hand guest memory over as a native value, so such methods get no
   thunk. Records by value (`FVector`, `FString`), varargs and struct returns
   aren't marshalled either. A call to any of them fails at link time.
4. **The float convention follows rex's.** Floats take FPRs and count
   separately from the GPRs, as ReXGlue's own marshalling does; no function
   tried here mixes them, so that is untested too.
5. **Static members are defined once per header.** Two headers declaring the
   same static would need one shared definition.
6. **Every call into recompiled code copies the `PPCContext`.** That's fine
   for a few functions, and slower than the recompiled code for hot ones.

## Recommendation

**Adopt it only for code worth modding, and keep the port fully recompiled
otherwise.**

The recompiled port already runs. Swapping in matched code gains nothing for
a player, and every swapped function adds a host-side risk (the limits above)
and a little call overhead. The value is for modders: a matched function they
want to change can be edited in readable C++ and dropped into the port with a
generated hook, instead of patching PowerPC. The pieces for that are here
(`HostGuest.h`, `--host-thunks`, `HAGGAR_DECOMP_HOOKS`).

Before using it beyond the spike:

- run the three hooks where CCS AI is active (after Ghost / Walk, or in a
  later level), and confirm the leaf's comparison stays at zero mismatches;
- generate the hook wrappers;
- settle limit 2 for the functions being modded.
