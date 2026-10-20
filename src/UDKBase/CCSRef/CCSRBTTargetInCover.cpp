// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetincover.cpp: the behaviour-tree condition on whether the current target is in cover.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324FC0
void CCSRBTTargetInCover::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_currentTarget.FlagAsUsed();
}

// @retail 0x83332B10
bool CCSRBTTargetInCover::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB == 0)
    {
        return false;
    }
    bool bValue = false;
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    if (pTarget != 0 && pTarget->character.GetActor() != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>((UObject *)pTarget->character.GetActor());
        if (pPawn != 0)
        {
            bValue = pPawn->OccupiedCoverCount > 0;
        }
    }
    return m_negate ? !bValue : (bool)bValue;
}
