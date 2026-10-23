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
