// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtvisibletoplayercamera.cpp: the behaviour-tree condition on the blackboard's visibleToPlayerCamera.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833250B8
void CCSRBTVisibleToPlayerCamera::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_visibleToPlayerCamera.FlagAsUsed();
}

// Todo (88 bytes vs 116): retail returns from each branch with its own
// epilogue and an extra bool conversion (tried a result variable, reading
// the property in each branch, == false).
// @retail 0x833334E0
bool CCSRBTVisibleToPlayerCamera::TestPreCondition(IGripBTInterface *pInterface)
{
    const bool bValue = pInterface->GetBlackboard<CCSBlackboard>()->m_visibleToPlayerCamera.Get();
    if (m_negate)
    {
        return !bValue;
    }
    return bValue;
}
