// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtflee.cpp: the behaviour-tree node that flees from the current target.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x833248A0
void CCSRBTFlee::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagMoveCommandAsUsed();
}

// @retail 0x8333E4F8
GripRBTNode::EBTExecutionResult CCSRBTFlee::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSAOFlee Objective = {pBB->GetCurrentTarget()};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOFlee, CCSAFFlee>(Objective);
    pScheduler->Execute(m_actionHandle);
    return ER_INPROGRESS;
}

// @retail 0x83331338
GripRBTNode::EBTExecutionResult CCSRBTFlee::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
    {
        pBB->ClearMoveCommand();
        return ER_SUCCESS;
    }
    return ER_INPROGRESS;
}
