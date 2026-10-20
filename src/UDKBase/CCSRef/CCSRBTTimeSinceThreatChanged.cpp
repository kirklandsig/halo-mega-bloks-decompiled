// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincethreatchanged.cpp: the behaviour-tree condition on the blackboard's timeSinceThreatTargetChanged.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325098
void CCSRBTTimeSinceThreatChanged::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceThreatTargetChanged.FlagAsUsed();
}

// @retail 0x83333420
bool CCSRBTTimeSinceThreatChanged::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceThreatTargetChanged.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
