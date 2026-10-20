// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincetargetcamoed.cpp: the behaviour-tree condition on the blackboard's timeSinceTargetCamoed.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325088
void CCSRBTTimeSinceTargetCamoed::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceTargetCamoed.FlagAsUsed();
}

// @retail 0x833333C0
bool CCSRBTTimeSinceTargetCamoed::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceTargetCamoed.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
