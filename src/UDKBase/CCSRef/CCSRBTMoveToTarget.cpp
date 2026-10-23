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

// score 31 (was 36): the objective still gets a slot of its own at 0x80 (the
// frame is 0xf0 instead of 0xd0), the constant 0 is rematerialised instead of
// living in a callee-saved register, the target's two stores are merged into
// one (4 bytes short of retail) and alwaysFire is stored as a byte instead of
// a word
// tried: member assignments in the retail's store order (52), the same with an
// explicit NULL check (49), an explicit character == NONE test (75), a
// one-element aggregate so the tail is zeroed (38), the position assigned
// after the aggregate (36), a named CCSCharacter local (33) and the permuter
// (no improvement)
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
    CCSAOMoveToActor moveToObjective = {pBB->GetCurrentTarget()->character.GetActor(), m_movementType, m_alertness, pointOfOrigin, false};
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
