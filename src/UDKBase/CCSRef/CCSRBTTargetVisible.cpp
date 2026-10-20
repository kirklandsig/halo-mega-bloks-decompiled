// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetvisible.cpp: the behaviour-tree condition on whether the current target is visible.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83325000
void CCSRBTTargetVisible::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_currentTarget.FlagAsUsed();
}

// @retail 0x83332F70
bool CCSRBTTargetVisible::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() == 0)
    {
        return false;
    }
    const bool bValue = pBB->GetCurrentTarget()->isVisible;
    return m_negate ? !bValue : (bool)bValue;
}
