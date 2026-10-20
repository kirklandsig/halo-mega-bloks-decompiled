// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtenemyaware.cpp: the behaviour-tree condition on the blackboard's bHasBecomeAware.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83324820
void CCSRBTEnemyAware::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_bHasBecomeAware.FlagAsUsed();
}

// @retail 0x83331080
bool CCSRBTEnemyAware::TestPreCondition(IGripBTInterface *pInterface)
{
    const bool bValue = pInterface->GetBlackboard<CCSBlackboard>()->m_bHasBecomeAware.Get();
    return m_negate ? !bValue : (bool)bValue;
}
