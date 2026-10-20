// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincethreatened.cpp: the behaviour-tree condition on the blackboard's timeSinceThreatened.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833250A8
void CCSRBTTimeSinceThreatened::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceThreatened.FlagAsUsed();
}

// @retail 0x83333480
bool CCSRBTTimeSinceThreatened::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceThreatened.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
