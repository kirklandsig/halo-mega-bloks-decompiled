// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetoactor.cpp: the behaviour-tree node that moves the pawn to the
// position a move command put on the blackboard.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSRBTMoveTo.cpp"

// @retail 0x83324AB8
void CCSRBTMoveToActor::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagCurrentTarget();
    pBB->FlagMoveCommandAsUsed();
}

// @retail 0x83331B98
bool CCSRBTMoveToActor::TestPreCondition(IGripBTInterface *pInterface)
{
    return pInterface->GetBlackboard<CCSBlackboard>()->GetMoveCommand() != CCSBlackboard::MOVE_CMD_NONE;
}

// near: retail loads the movement type and alertness before the position
// (as in CCSRBTSearch::MoveToLKP)
// @retail 0x8333EA58
GripRBTNode::EBTExecutionResult CCSRBTMoveToActor::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
{
    CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSAOMoveTo Objective = {pBB->GetMovePosition(), m_movementType, m_alertness};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveTo, CCSAFMoveTo>(Objective);
    pScheduler->Execute(m_actionHandle);
    return ER_INPROGRESS;
}

// @retail 0x83331BD8
GripRBTNode::EBTExecutionResult CCSRBTMoveToActor::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
    {
        pBB->ClearMoveCommand();
        pBrain->m_meatPuppet->NotifyAIMoveToActorCompleted();
        return ER_SUCCESS;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_FAILURE)
    {
        pBB->ClearMoveCommand();
        return ER_FAILURE;
    }
    return ER_INPROGRESS;
}
