// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtenemylowestlkpage.cpp: the behaviour-tree condition on the age of the freshest last-known position of an enemy.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324840
void CCSRBTEnemyLowestLKPAge::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_lowestLKPAgeEnemy.FlagAsUsed();
}

// @retail 0x833311D8
bool CCSRBTEnemyLowestLKPAge::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetLowestLKPAgeEnemy() == 0)
    {
        return false;
    }
    m_value = pBB->GetLowestLKPAgeEnemy()->LKPAge;
    return GripRBTNumericCondition<float>::TestPreCondition(pInterface);
}
