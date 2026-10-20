// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesinceaimedat.cpp: the behaviour-tree condition on the blackboard's timeSinceAimedAt.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325010
void CCSRBTTimeSinceAimedAt::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceAimedAt.FlagAsUsed();
}

// @retail 0x83333068
bool CCSRBTTimeSinceAimedAt::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceAimedAt.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
