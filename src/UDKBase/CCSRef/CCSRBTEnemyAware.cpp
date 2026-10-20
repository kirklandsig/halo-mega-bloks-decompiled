// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtenemyaware.cpp: the behaviour-tree condition on the blackboard's bHasBecomeAware.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83324820
void CCSRBTEnemyAware::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_bHasBecomeAware.FlagAsUsed();
}

// Todo (88 bytes vs 116): retail returns from each branch with its own
// epilogue and an extra bool conversion (tried a result variable, reading
// the property in each branch, == false).
// @retail 0x83331080
bool CCSRBTEnemyAware::TestPreCondition(IGripBTInterface *pInterface)
{
    const bool bValue = pInterface->GetBlackboard<CCSBlackboard>()->m_bHasBecomeAware.Get();
    if (m_negate)
    {
        return !bValue;
    }
    return bValue;
}
