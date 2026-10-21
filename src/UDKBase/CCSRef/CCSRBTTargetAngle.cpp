// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetangle.cpp: the behaviour-tree condition on which quadrant
// (front, right, behind, left) the current target is in.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

static __forceinline bool FrontZone(float Forward, float Right)
{
    return Forward >= 0.0f && Right <= 0.0f;
}
static __forceinline bool RightZone(float Forward, float Right)
{
    return Forward >= 0.0f && Right >= 0.0f;
}
static __forceinline bool BehindZone(float Forward, float Right)
{
    return Forward <= 0.0f && Right >= 0.0f;
}
static __forceinline bool LeftZone(float Forward, float Right)
{
    return Forward <= 0.0f && Right <= 0.0f;
}

// @retail 0x83324F88
void CCSRBTTargetAngle::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// each quadrant flag comes from an inlined bool helper, so it is masked
// twice: once where it is built and once where it is used
// @retail 0x833327F8
bool CCSRBTTargetAngle::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() != 0)
    {
        const float Forward = pBB->GetCurrentTarget()->forwardDot;
        const float Right = pBB->GetCurrentTarget()->rightDot;
        const bool bFront = FrontZone(Forward, Right);
        const bool bRight = RightZone(Forward, Right);
        const bool bBehind = BehindZone(Forward, Right);
        const bool bLeft = LeftZone(Forward, Right);
        bool bValue = (checkFront && bFront) || (checkRight && bRight) || (checkBehind && bBehind) || (checkLeft && bLeft);
        bool bResult = m_negate ? !bValue : bValue;
        return bResult;
    }
    return false;
}

// ccsrbttargetangle.h's inline setter, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTTargetAngle::*const EmitTargetAngleSetActiveZones)(bool, bool, bool, bool) = &CCSRBTTargetAngle::SetActiveZones;
#pragma inline_depth()

// @retail 0x83324F98
// CCSRBTTargetAngle::SetActiveZones (in the header)
