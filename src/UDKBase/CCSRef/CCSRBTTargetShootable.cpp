// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetshootable.cpp: the behaviour-tree condition on whether the
// current target can be shot (in the clear, and not too hot already).
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324FF0
void CCSRBTTargetShootable::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83332DE8
bool CCSRBTTargetShootable::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() == 0)
    {
        return false;
    }
    bool bValue = pBB->GetCurrentTarget()->canShoot;
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    if (bValue == true && pTarget != 0 && pTarget->character.GetActor() != 0)
    {
        AActor *pActor = (AActor *)pTarget->character.GetActor();
        UUDKTargetableComponent *pTargetable = Cast<UUDKTargetableComponent>(pActor->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
        if (pTargetable != 0)
        {
            bValue = true;
            if (pTargetable->MaxAIHeat - pTargetable->CurAIHeat <= pBB->m_heatGenerated.Get())
            {
                bValue = false;
            }
        }
    }
    return m_negate ? !bValue : (bool)bValue;
}
