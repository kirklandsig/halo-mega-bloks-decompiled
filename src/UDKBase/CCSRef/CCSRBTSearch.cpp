// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtsearch.cpp: the behaviour-tree node that searches for the current
// target: it moves to the target's last known position, then wanders
// between random navigation points until the target shows up again.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSAFFactory.cpp"
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

// near, score 3 (was 8): the indexed store of the inlined Grip_Array::AddItem
// has base and offset swapped (retail stwx r28, r9, r10; ours stwx r28, r10,
// r9); the two loads of Grip::Memory::pGlobalHeap differ only by the linker's
// anchor, which the comparison masks. Retail itself emits both orders (69 of
// its 90 indexed stores offset first; CCSBrain's CreateDebugRenderingProxies,
// the same shape, matches). Tried by both lanes, none changes the store: the
// shared AddItem in many spellings (pointer or char* arithmetic, the address
// or index in a local, a void pointer, a direct assignment), the item in an
// if-initializer or read again, a pointer local, the array through a
// reference (60), a while loop, the condition folded, the actor in a local or
// a reference, the checks moved out of operator* or into a helper, and a
// ten-minute permuter run.
// This session: the two pGlobalHeap loads carry REFLO relocations in our
// object, so the comparison masks them and only the stwx stands between us
// and a match; the store's operand order is the last difference. Spelling the
// store as `m_ContainerContent[i] = Item` (direct assignment) or through the
// member operator[] instead of `&m_ContainerContent[i]` leaves it stwx r28,
// r10, r9 (still score 3). The matched twin CCSBrain::CreateDebugRenderingProxies
// gets retail's order from the same AddItem, and differs only in the array
// being a reference parameter with the resize left out of line.
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
