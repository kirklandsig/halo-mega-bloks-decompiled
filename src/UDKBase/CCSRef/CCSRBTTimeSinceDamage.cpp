// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesincedamage.cpp: the behaviour-tree condition on the blackboard's timeSinceDamage.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83325030
void CCSRBTTimeSinceDamage::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_timeSinceDamage.FlagAsUsed();
}

// @retail 0x83333128
bool CCSRBTTimeSinceDamage::TestPreCondition(IGripBTInterface *pInterface)
{
    m_value = pInterface->GetBlackboard<CCSBlackboard>()->m_timeSinceDamage.Get();
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
