// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincesuccessfulattack.cpp: the behaviour-tree condition on the blackboard's timeSinceSuccessfulAttack.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325078
void CCSRBTTimeSinceSuccessfulAttack::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceSuccessfulAttack.FlagAsUsed();
}

// @retail 0x83333360
bool CCSRBTTimeSinceSuccessfulAttack::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceSuccessfulAttack.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
