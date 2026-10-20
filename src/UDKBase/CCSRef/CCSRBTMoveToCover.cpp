// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetocover.cpp: the behaviour-tree node that picks a cover, locks
// it, moves the pawn there and takes cover.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSCover.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83331CE8
CCSRBTMoveToCover::CCSRBTMoveToCover()
    : m_actionHandle(-1)
    , m_state(MoveToCover_Moving)
    , m_coverCacheTime(-5.0f)
    , m_coverCacheValid(true)
{
    m_alertness = CCS::AlertnessState_Alert;
    m_movementType = CCS::MovementType_Run;
}
#endif

// @retail 0x83324AD0
void CCSRBTMoveToCover::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->m_currentTarget.FlagAsUsed();
    pBB->m_covers.FlagAsUsed();
}

// @retail 0x83324AE0
bool CCSRBTMoveToCover::TestPreCondition(IGripBTInterface *pInterface)
{
    if (pInterface->GetTime() - m_coverCacheTime < 5.0f)
    {
        return m_coverCacheValid;
    }
    return true;
}

// @retail 0x83331D88
GripRBTNode::EBTExecutionResult CCSRBTMoveToCover::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
{
    CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
    m_state = MoveToCover_Waiting;
    return ER_INPROGRESS;
}

// @retail 0x833582B8
GripRBTNode::EBTExecutionResult CCSRBTMoveToCover::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    if (bInterrupt)
    {
        if (m_state == MoveToCover_TakingCover)
        {
            ExitCover(pFactory, pScheduler);
        }
        else if (m_state != MoveToCover_ExitingCover)
        {
            return ER_SUCCESSFULLY_INTERRUPTED;
        }
    }
    switch (m_state)
    {
    case MoveToCover_Waiting:
        if (StartMoveToCover(pInterface) == ER_FAILURE)
        {
            return ER_FAILURE;
        }
        break;
    case MoveToCover_Moving:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            EnterCover(pBB, pFactory, pScheduler);
        }
        else if (!MovingToCover(pBB))
        {
            return ER_FAILURE;
        }
        break;
    case MoveToCover_TakingCover:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            ExitCover(pFactory, pScheduler);
        }
        break;
    case MoveToCover_ExitingCover:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            return bInterrupt ? ER_SUCCESSFULLY_INTERRUPTED : ER_SUCCESS;
        }
        return bInterrupt ? ER_INTERRUPTING : ER_INPROGRESS;
    }
    return pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_FAILURE ? ER_FAILURE : ER_INPROGRESS;
}

// @retail 0x8333F028
void CCSRBTMoveToCover::ExecutePostInternal(IGripBTInterface *pInterface, bool)
{
    pInterface->GetMeatPuppetQuery<CCSMeatPuppetQuery>()->UnlockCover(m_lockedCover);
    m_lockedCover = CCSCover::NONE;
}

// @retail 0x83324B50
CCSCover CCSRBTMoveToCover::FindBestCover(IGripBTInterface *) const
{
    return CCSCover::NONE;
}

// Near: retail builds the move objective in the slot the character temporary
// used; ours gives it its own (a 0x20 larger frame). Tried named slot
// locations.
// @retail 0x8334C6F8
GripRBTNode::EBTExecutionResult CCSRBTMoveToCover::StartMoveToCover(IGripBTInterface *pInterface)
{
    CCSMeatPuppetQuery *pQuery = pInterface->GetMeatPuppetQuery<CCSMeatPuppetQuery>();
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSCover Cover = FindBestCover(pInterface);
    m_coverCacheValid = Cover.IsValid();
    m_coverCacheTime = pInterface->GetTime();
    if (!Cover.IsValid())
    {
        return ER_FAILURE;
    }
    m_lockedCover = Cover;
    m_lockedCover.m_gameCover.LockCover(pQuery->m_pBrain->m_meatPuppet->GetCharacter());
    if (pQuery->m_pBrain->m_meatPuppet->ReachedPoint(Grip_Vector(m_lockedCover.m_gameCover.m_coverInfo.Link->GetSlotLocation(m_lockedCover.m_gameCover.m_coverInfo.SlotIdx, 0))))
    {
        EnterCover(pBB, pFactory, pScheduler);
        return ER_INPROGRESS;
    }
    CCSAOMoveTo Objective = {m_lockedCover.GetPosition(), m_movementType, m_alertness};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveTo, CCSAFMoveTo>(Objective);
    pScheduler->Execute(m_actionHandle);
    m_state = MoveToCover_Moving;
    return ER_INPROGRESS;
}

// Near: retail sets up the objective's address before saving this.
// @retail 0x83331DC0
void CCSRBTMoveToCover::ExitCover(CCSAFFactory *pFactory, GripAFScheduler *pScheduler)
{
    CCSAOExitCover Objective = {};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOExitCover, CCSAFExitCover>(Objective);
    pScheduler->Execute(m_actionHandle);
    m_state = MoveToCover_ExitingCover;
}

// @retail 0x83345CB0
void CCSRBTMoveToCover::EnterCover(CCSBlackboard *pBB, CCSAFFactory *pFactory, GripAFScheduler *pScheduler)
{
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    const CCSCharacter &Target = pTarget != 0 ? pTarget->character : CCSCharacter::NONE;
    CCSAOEnterCover Objective = {m_lockedCover, Target};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOEnterCover, CCSAFEnterCover>(Objective);
    pScheduler->Execute(m_actionHandle);
    m_state = MoveToCover_TakingCover;
}

// @retail 0x8333F0A8
bool CCSRBTMoveToCover::MovingToCover(CCSBlackboard *pBB)
{
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        if (m_lockedCover == pBB->m_covers.GetArray()[i])
        {
            return pBB->m_covers.GetArray()[i].IsValid();
        }
    }
    return false;
}
