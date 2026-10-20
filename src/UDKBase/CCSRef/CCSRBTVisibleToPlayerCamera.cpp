// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtvisibletoplayercamera.cpp: the behaviour-tree condition on the blackboard's visibleToPlayerCamera.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833250B8
void CCSRBTVisibleToPlayerCamera::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_visibleToPlayerCamera.FlagAsUsed();
}

// @retail 0x833334E0
bool CCSRBTVisibleToPlayerCamera::TestPreCondition(IGripBTInterface *pInterface)
{
    const bool bValue = pInterface->GetBlackboard<CCSBlackboard>()->m_visibleToPlayerCamera.Get();
    return m_negate ? !bValue : (bool)bValue;
}
