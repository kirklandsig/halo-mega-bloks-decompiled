// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetotarget.cpp: the behaviour-tree node that moves the pawn to the
// current target.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSRBTMoveTo.cpp"

// @retail 0x83324B88
void CCSRBTMoveToTarget::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83331E78
bool CCSRBTMoveToTarget::TestPreCondition(IGripBTInterface *pInterface)
{
    if (pInterface->GetBlackboard<CCSBlackboard>()->GetCurrentTarget() == 0)
    {
        return false;
    }
    return true;
}

// score 12 (was 31): only the stack layout is left - retail keeps the
// objective in the slot the GetCharacter() return buffer used (0x60) so the
// frame is 0xd0, while the objective gets a slot of its own at 0x80 here and
// the frame grows to 0xf0. Every instruction, its size and its order match;
// the twelve differences are all the slot immediates.
// tried: member assignments in the retail's store order (52), the same with an
// explicit NULL check (49), an explicit character == NONE test (75), a
// one-element aggregate so the tail is zeroed (38), the position assigned
// after the aggregate (36), a named CCSCharacter local (33), the natural
// character.GetActor() in the aggregate (36), the objective declared before
// the position test (37), the position copied through a named local (36) and
// the permuter (no improvement)
// tried for the layout: the objective declared first (37), declared before the
// position test with member assignments (37) or with the position member
// written field by field (103), its address taken early (37), the position
// read through a named CCSCharacter (14) or a named Grip_Vector (12), the
// objective built by a helper that returns it by value (55), a named
// character local outside the test (29) - the objective keeps the slot at
// 0x80 and the frame at 0xf0 in every one of them, so MSVC does not share
// the return buffer's slot with the objective here
// tried again: an explicit fifth aggregate element (alwaysFire = false, 21 -
// the tail zero then becomes a plain store and the function loses four
// bytes), the same with the target fetched inline in the aggregate (81, and
// 67 without the fifth element - the two GetCurrentTarget() calls change
// the register allocation), the position read through a named Grip_Vector or
// a named CCSCharacter with the fifth element (21, 23) and pointOfOrigin
// declared after the brain block (21) - the objective still lands at 0x80
// and the frame at 0xf0
// note: retail's line table puts the GetCurrentTarget() fetch and the whole
// aggregate initializer on one source line (line 68) and the sunk stores on
// the next (line 69), so the original had them together; the permuter run
// was made against a modified copy of this file, so it never covered this
// version of the source
// tried this session: the matched twin CCSRBTSearch::MoveToRandomLocation
// has the same shape (position at 0x50, character temporary at 0x60, the
// objective reusing 0x60), so the difference is in this function's extra
// code, not the shape: a named CCSCharacter local for the position (14, the
// objective keeps 0x80), dropping the early target check (21, the objective
// keeps 0x80), and fetching the target inline in the aggregate (the two
// GetCurrentTarget() loads change the register allocation) - in every case
// MSVC gives the objective its own slot at 0x80 and the frame 0xf0, so the
// reuse of the character temporary's slot is what is missing here
// @retail 0x8333F270
GripRBTNode::EBTExecutionResult CCSRBTMoveToTarget::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
{
    CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget()->character.GetActor() == 0)
    {
        return ER_FAILURE;
    }
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    Grip_Vector pointOfOrigin;
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    if (pBrain != 0)
    {
        pointOfOrigin = pBrain->m_meatPuppet->GetCharacter().GetPosition();
    }
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    CCSAOMoveToActor moveToObjective = {(pTarget->character != CCSCharacter::NONE) ? pTarget->character.m_gameCharacter.GetActor() : 0, m_movementType, m_alertness, pointOfOrigin};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveToActor, CCSAFMoveToActor>(moveToObjective);
    pScheduler->Execute(m_actionHandle);
    return ER_INPROGRESS;
}

// @retail 0x8333F488
GripRBTNode::EBTExecutionResult CCSRBTMoveToTarget::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *pStack, bool bInterrupt)
{
    CCSRBTMoveTo::ExecuteInternal(pInterface, pStack, bInterrupt);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_FAILURE)
    {
        return ER_FAILURE;
    }
    return pBB->GetCurrentTarget() != 0 ? ER_INPROGRESS : ER_FAILURE;
}
