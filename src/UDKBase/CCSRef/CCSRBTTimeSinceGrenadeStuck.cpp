// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincegrenadestuck.cpp: the behaviour-tree condition on the blackboard's timeSinceGrenadeStuck.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325058
void CCSRBTTimeSinceGrenadeStuck::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceGrenadeStuck.FlagAsUsed();
}

// @retail 0x833332A0
bool CCSRBTTimeSinceGrenadeStuck::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceGrenadeStuck.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
