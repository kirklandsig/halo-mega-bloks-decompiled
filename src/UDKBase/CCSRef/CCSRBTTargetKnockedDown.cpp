// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetknockeddown.cpp: the behaviour-tree condition on whether the current target is knocked down.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324FD0
void CCSRBTTargetKnockedDown::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_currentTarget.FlagAsUsed();
}

// @retail 0x83332C10
bool CCSRBTTargetKnockedDown::TestPreCondition(IGripBTInterface *pInterface)
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
            bValue = pPawn->bIsKnockedDown;
        }
    }
    return m_negate ? !bValue : (bool)bValue;
}
