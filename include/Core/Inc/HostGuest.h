// One source, two builds. Generated headers spell their classes with these
// macros. Built with the XDK, they are plain C++, and the code matches
// retail. Built for the PC port (HAGGAR_HOST), the same classes describe
// guest memory: members are big-endian values at the PDB's offsets,
// pointers are 32-bit guest addresses, virtual functions are ordinary
// members whose bodies (generated, weak) call the recompiled code by address
// or through the guest vtable. A matched function compiled this way can
// replace its recompiled version with REX_HOOK.
#pragma once

#ifndef HAGGAR_HOST

#define HG_VIRTUAL virtual
#define HG_PURE = 0
#define HG_VFPTR
#define HG_PRIVATE private
#define HG_PROTECTED protected
#define HG_XDK(decl) decl

#else

#include <bit>
#include <cstdint>
#include <cstring>
#include <type_traits>

#include <rex/types.h>
#include <rex/ppc/context.h>
#include <rex/ppc/func.h>

#define HG_VIRTUAL
#define HG_PURE
#define HG_PRIVATE public  // hooks call any member
#define HG_PROTECTED public
#define HG_XDK(decl)  // constructors and destructors stay recompiled
#define HG_VFPTR \
  public:        \
    hg::be<unsigned int> __vfptr;

namespace hg {

// Guest memory's host address (the runtime maps it at a fixed base).
inline uint8_t *const kGuestBase = reinterpret_cast<uint8_t *>(0x100000000ull);

inline uint32_t guest_address(const void *host) {
  return host ? static_cast<uint32_t>(static_cast<const uint8_t *>(host) - kGuestBase) : 0;
}
template <class T> inline T *host(uint32_t guest) {
  return guest ? reinterpret_cast<T *>(kGuestBase + guest) : nullptr;
}

// A big-endian value in guest memory: ReXGlue's own.
template <class T> using be = rex::be<T>;

// A 32-bit guest pointer to T.
template <class T> struct gptr {
  be<uint32_t> addr;
  gptr() = default;
  gptr(T *p) { addr = guest_address(p); }
  gptr(int null) { addr = static_cast<uint32_t>(null); }  // 0
  operator T *() const { return host<T>(addr); }
  T *operator->() const { return host<T>(addr); }
  gptr &operator=(T *p) {
    addr = guest_address(p);
    return *this;
  }
};

// The context of the hook running on this thread, for calls back into
// recompiled code.
struct Scope {
  static inline thread_local PPCContext *ctx = nullptr;
  static inline thread_local uint8_t *base = nullptr;
  PPCContext *saved_ctx;
  uint8_t *saved_base;
  Scope(PPCContext &c, uint8_t *b) : saved_ctx(ctx), saved_base(base) {
    ctx = &c;
    base = b;
  }
  ~Scope() {
    ctx = saved_ctx;
    base = saved_base;
  }
};

namespace detail {
struct Args {
  PPCContext &c;
  int gpr = 3, fpr = 1;
  void put(uint64_t v) { (&c.r3)[gpr++ - 3].u64 = v; }
  template <class T> void add(T v) {
    if constexpr (std::is_floating_point_v<T>) {
      (&c.f1)[fpr++ - 1].f64 = v;  // floats count separately, as rex's own marshalling does
    } else if constexpr (std::is_pointer_v<T>) {
      put(guest_address(v));
    } else if constexpr (std::is_reference_v<T>) {
      put(guest_address(&v));
    } else {
      put(static_cast<uint64_t>(static_cast<int64_t>(v)));
    }
  }
};

template <class R> R result(PPCContext &c) {
  if constexpr (std::is_void_v<R>) {
    return;
  } else if constexpr (std::is_floating_point_v<R>) {
    return static_cast<R>(c.f1.f64);
  } else if constexpr (std::is_pointer_v<R>) {
    return host<std::remove_pointer_t<R>>(c.r3.u32);
  } else if constexpr (std::is_reference_v<R>) {
    return *host<std::remove_reference_t<R>>(c.r3.u32);
  } else if constexpr (std::is_same_v<R, bool>) {
    return (c.r3.u32 & 0xFF) != 0;
  } else {
    return static_cast<R>(c.r3.u64);
  }
}
}  // namespace detail

// Call the recompiled static or free function at `guest`.
template <class R, class... A> R scall(uint32_t guest, A... args) {
  PPCContext c = *Scope::ctx;
  detail::Args a{c};
  (a.add(args), ...);
  rex::runtime::ResolveIndirectFunction(guest)(c, Scope::base);
  Scope::ctx->fpscr = c.fpscr;
  return detail::result<R>(c);
}

// Call the recompiled function at `guest` with `self` as r3.
template <class R, class... A> R call(uint32_t guest, const void *self, A... args) {
  return scall<R>(guest, self, args...);
}

// Call slot `slot` of `self`'s guest vtable.
template <class R, class... A> R vcall(unsigned slot, const void *self, A... args) {
  uint32_t vtable = *reinterpret_cast<const be<uint32_t> *>(self);
  uint32_t fn = *host<be<uint32_t>>(vtable + 4 * slot);
  return call<R>(fn, self, args...);
}

}  // namespace hg

#endif
