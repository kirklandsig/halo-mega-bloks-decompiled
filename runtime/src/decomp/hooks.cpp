// Matched source in the port (Phase 3, Task 4). Each hook replaces a
// recompiled function with the decompiled C++ of src/, built for the host
// (HAGGAR_HOST; see include/Core/Inc/HostGuest.h). Built only with
// -DHAGGAR_DECOMP_HOOKS=ON.
#include <atomic>

#include <rex/hook.h>
#include <rex/logging.h>

#include "UDKBase/Inc/HaloRBTKamikaze.h"

// The recompiled originals, kept under their __imp__ names.
extern "C" REX_FUNC(__imp__sub_8332E718);

namespace {
std::atomic<unsigned> g_leaf_calls{0}, g_leaf_mismatches{0}, g_call_calls{0}, g_virtual_calls{0};

void Report(const char *what, unsigned n) {
  if (n == 1 || n % 10000 == 0)
    REXLOG_INFO("decomp: {} called {} times (leaf: {} compared, {} mismatches)", what, n, g_leaf_calls.load(),
                g_leaf_mismatches.load());
}
}  // namespace

// A leaf: CCSBlackboard::GetCurrentTarget reads two members and a static.
// It only reads, so the recompiled original runs on the same input too, and
// the two results are compared.
REX_HOOK_RAW(sub_8332E718) {
  hg::Scope scope(ctx, base);
  CCSTarget *ours = hg::host<CCSBlackboard>(ctx.r3.u32)->GetCurrentTarget();
  PPCContext theirs = ctx;
  __imp__sub_8332E718(theirs, base);
  unsigned n = ++g_leaf_calls;
  if (theirs.r3.u32 != hg::guest_address(ours)) {
    ++g_leaf_mismatches;
    REXLOG_WARN("decomp: GetCurrentTarget(0x{:08X}) = 0x{:08X}, recompiled 0x{:08X}", ctx.r3.u32,
                hg::guest_address(ours), theirs.r3.u32);
  }
  Report("CCSBlackboard::GetCurrentTarget", n);
  ctx.r3.u64 = hg::guest_address(ours);
}

// A call to another game function: HaloRBTKamikaze::ExecutePreInternal
// calls CCSRBTMoveTo::ExecutePreInternal (recompiled, by address).
REX_HOOK_RAW(sub_83333B58) {
  hg::Scope scope(ctx, base);
  auto *self = hg::host<HaloRBTKamikaze>(ctx.r3.u32);
  GripRBTNode::EBTExecutionResult r =
      self->ExecutePreInternal(hg::host<IGripBTInterface>(ctx.r4.u32), (ctx.r5.u32 & 0xFF) != 0);
  Report("HaloRBTKamikaze::ExecutePreInternal", ++g_call_calls);
  ctx.r3.u64 = static_cast<uint32_t>(r);
}

// Virtual calls: HaloRBTKamikaze::TestPreCondition calls two pure virtuals
// through guest vtables.
REX_HOOK_RAW(sub_83333A88) {
  hg::Scope scope(ctx, base);
  auto *self = hg::host<HaloRBTKamikaze>(ctx.r3.u32);
  bool r = self->TestPreCondition(hg::host<IGripBTInterface>(ctx.r4.u32));
  Report("HaloRBTKamikaze::TestPreCondition", ++g_virtual_calls);
  ctx.r3.u64 = r ? 1 : 0;
}

// A control: UObject::ProcessEvent passes straight through to the
// recompiled original, counting calls, to show the override is in effect.
extern "C" REX_FUNC(__imp__sub_8254F710);
REX_HOOK_RAW(sub_8254F710) {
  static std::atomic<unsigned> calls{0};
  unsigned n = ++calls;
  if (n == 1 || n % 100000 == 0)
    REXLOG_INFO("decomp: control hook UObject::ProcessEvent called {} times", n);
  __imp__sub_8254F710(ctx, base);
}
