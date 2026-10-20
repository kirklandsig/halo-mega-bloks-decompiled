// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtorienttowardtarget.cpp: the behaviour-tree node that turns the pawn
// toward the current target.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSAFFactory.cpp"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324C10
void CCSRBTOrientTowardTarget::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83332138
bool CCSRBTOrientTowardTarget::TestPreCondition(IGripBTInterface *pInterface)
{
    if (pInterface->GetBlackboard<CCSBlackboard>()->GetCurrentTarget() == 0)
    {
        return false;
    }
    return true;
}

// @retail 0x8333FB50
GripRBTNode::EBTExecutionResult CCSRBTOrientTowardTarget::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSAOOrientToward Objective = {pBB->GetCurrentTarget()->position, m_alertness};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOOrientToward, CCSAFOrientToward>(Objective);
    pScheduler->Execute(m_actionHandle);
    return ER_INPROGRESS;
}

// @retail 0x83324C20
GripRBTNode::EBTExecutionResult CCSRBTOrientTowardTarget::ExecuteInternal(IGripBTInterface *pInterface, bool bInterrupt)
{
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    switch (pScheduler->GetStatus(m_actionHandle))
    {
    case GripAFAction::AS_DONE:
        return ER_SUCCESS;
    case GripAFAction::AS_FAILURE:
        return ER_FAILURE;
    }
    return ER_INPROGRESS;
}

// ccsrbtorienttowardtarget.h's inline setter, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTOrientTowardTarget::*const EmitOrientSetAlertness)(CCS::EAlertnessState) = &CCSRBTOrientTowardTarget::SetAlertness;
#pragma inline_depth()

// @retail 0x8331EC88
// CCSRBTOrientTowardTarget::SetAlertness (in the header)
