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

// near: a 0x20 bigger frame (the objective's own slot) and the zero register
// set later
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
    Grip_Vector Position;
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    if (pBrain != 0)
    {
        Position = pBrain->m_meatPuppet->GetCharacter().GetPosition();
    }
    CCSAOMoveToActor Objective = {pBB->GetCurrentTarget()->character.GetActor(), m_movementType, m_alertness, Position};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveToActor, CCSAFMoveToActor>(Objective);
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
