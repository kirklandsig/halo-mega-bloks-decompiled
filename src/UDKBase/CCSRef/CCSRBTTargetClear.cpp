// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetclear.cpp: the behaviour-tree condition on whether no friend stands between the brain and its current target.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324FB0
void CCSRBTTargetClear::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_currentTarget.FlagAsUsed();
}

// @retail 0x83332A18
bool CCSRBTTargetClear::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() == 0)
    {
        return false;
    }
    const bool bValue = pBB->GetCurrentTarget()->ClearOfFriendlies;
    return m_negate ? !bValue : (bool)bValue;
}
