// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtsearch.cpp: the behaviour-tree node that searches for the current
// target: it moves to the target's last known position, then wanders
// between random navigation points until the target shows up again.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSRBTMoveTo.cpp"
#include "UDKBase/Inc/EngineUtils.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8334BA38
CCSRBTSearch::CCSRBTSearch() : m_bSetNewTarget(false), m_targetSetTimer(0.0f), m_actionHandle(-1), m_state(Search_MovingToLKP)
{
    FindNavigationPoints();
}
#endif

// @retail 0x8332B528
void CCSRBTSearch::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83338D18
bool CCSRBTSearch::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() != 0 && pBB->GetCurrentTarget()->isAware)
    {
        return true;
    }
    return false;
}

// @retail 0x83338DE0
GripRBTNode::EBTExecutionResult CCSRBTSearch::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
{
    CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
    pInterface->GetBlackboard<CCSBlackboard>();
    m_actionHandle = -1;
    m_state = Search_MovingToLKP;
    m_bSetNewTarget = true;
    return ER_INPROGRESS;
}

// @retail 0x83343780
GripRBTNode::EBTExecutionResult CCSRBTSearch::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    if (pBB->GetCurrentTarget() == 0)
    {
        return ER_FAILURE;
    }
    const bool bDone = pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE;
    switch (m_state)
    {
    case Search_MovingToLKP:
        if (m_bSetNewTarget || m_targetLKP != pBB->GetCurrentTarget()->LKP)
        {
            MoveToLKP(pInterface);
        }
        else if (bDone)
        {
            MoveToRandomLocation(pInterface);
            m_state = Search_MovingToRandomLocation;
        }
        break;
    case Search_MovingToRandomLocation:
        if (m_targetLKP != pBB->GetCurrentTarget()->LKP)
        {
            MoveToLKP(pInterface);
            m_state = Search_MovingToLKP;
        }
        else if (bDone)
        {
            MoveToRandomLocation(pInterface);
        }
        break;
    }
    return ER_INPROGRESS;
}

// near: retail loads the movement type and alertness before the position
// (assignments zero the vector first; the aggregate loads it first)
// @retail 0x83338E48
void CCSRBTSearch::MoveToLKP(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    m_bSetNewTarget = false;
    m_targetLKP = pBB->GetCurrentTarget()->LKP;
    CCSAOMoveTo Objective = {pBB->GetCurrentTarget()->LKP, m_movementType, m_alertness};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveTo, CCSAFMoveTo>(Objective);
    pScheduler->Execute(m_actionHandle);
}

// near: the objective gets its own frame slot (retail reuses the character
// temporary's), a 0x20 bigger frame
// @retail 0x83338FA0
void CCSRBTSearch::MoveToRandomLocation(IGripBTInterface *pInterface)
{
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    Grip_Vector Position;
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    if (pBrain != 0)
    {
        Position = pBrain->m_meatPuppet->GetCharacter().GetPosition();
    }
    CCSAOMoveToActor Objective = {m_navigationPoints[RandHelper(m_navigationPoints.Num())], m_movementType, m_alertness, Position};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveToActor, CCSAFMoveToActor>(Objective);
    pScheduler->Execute(m_actionHandle);
}

// todo: 4 bytes long, as CCSEngineServices::FindAllCovers (the actor
// iterator's checked actor)
// @retail 0x83339098
void CCSRBTSearch::FindNavigationPoints()
{
    for (FActorIterator It; It; ++It)
    {
        ANavigationPoint *pPoint = Cast<ANavigationPoint>(*It);
        if (pPoint != 0)
        {
            m_navigationPoints.AddItem(pPoint);
        }
    }
}
