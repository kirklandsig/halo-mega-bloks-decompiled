// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtidle.cpp: the behaviour-tree node that idles at an alertness.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83331448
GripRBTNode::EBTExecutionResult CCSRBTIdle::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    m_actionHandle = -1;
    CCSAOIdle Objective = {CCS::MovementType_Idle, m_alertness};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOIdle, CCSAFIdle>(Objective);
    pScheduler->Execute(m_actionHandle);
    return ER_INPROGRESS;
}

// @retail 0x83324910
GripRBTNode::EBTExecutionResult CCSRBTIdle::ExecuteInternal(IGripBTInterface *, bool bInterrupt)
{
    return bInterrupt ? ER_SUCCESSFULLY_INTERRUPTED : ER_INPROGRESS;
}

// ccsrbtidle.h's inline setter, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTIdle::*const EmitIdleSetAlertness)(CCS::EAlertnessState) = &CCSRBTIdle::SetAlertness;
#pragma inline_depth()

// @retail 0x8331EBF8
// CCSRBTIdle::SetAlertness (in the header)
