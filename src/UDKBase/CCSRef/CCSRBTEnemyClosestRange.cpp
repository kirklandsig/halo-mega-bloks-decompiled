// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtenemyclosestrange.cpp: the behaviour-tree condition on the closest visible enemy's 2D range.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324830
void CCSRBTEnemyClosestRange::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_closestVisibleEnemy.FlagAsUsed();
}

// @retail 0x833310F8
bool CCSRBTEnemyClosestRange::TestPreCondition(IGripBTInterface *pInterface)
{
    bool bResult = false;
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetClosestVisibleEnemy() != 0)
    {
        m_value = (int)pBB->GetClosestVisibleEnemy()->range2D;
        bResult = GripRBTNumericCondition<int>::TestPreCondition(pInterface);
    }
    return bResult;
}
