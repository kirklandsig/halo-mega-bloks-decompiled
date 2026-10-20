// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincestaggered.cpp: the behaviour-tree condition on the blackboard's timeSinceStaggered.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325068
void CCSRBTTimeSinceStaggered::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceStaggered.FlagAsUsed();
}

// @retail 0x83333300
bool CCSRBTTimeSinceStaggered::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceStaggered.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
