// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetrange.cpp: the behaviour-tree condition on the current target's 2D range.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324FE0
void CCSRBTTargetRange::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_currentTarget.FlagAsUsed();
}

// @retail 0x83332D08
bool CCSRBTTargetRange::TestPreCondition(IGripBTInterface *pInterface)
{
    bool bResult = false;
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() != 0)
    {
        m_value = (int)pBB->GetCurrentTarget()->range2D;
        bResult = GripRBTNumericCondition<int>::TestPreCondition(pInterface);
    }
    return bResult;
}
