// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincebecameaware.cpp: the behaviour-tree condition on the blackboard's timeSinceBecameAware.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325020
void CCSRBTTimeSinceBecameAware::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceBecameAware.FlagAsUsed();
}

// @retail 0x833330C8
bool CCSRBTTimeSinceBecameAware::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceBecameAware.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
