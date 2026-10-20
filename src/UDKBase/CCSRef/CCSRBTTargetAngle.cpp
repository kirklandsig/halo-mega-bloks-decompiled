// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttargetangle.cpp: the behaviour-tree condition on which quadrant
// (front, right, behind, left) the current target is in.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324F88
void CCSRBTTargetAngle::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// todo: 20 bytes short; retail builds each quadrant flag in r11 and copies it
// masked into its own register (as an inlined helper's result would be);
// ours computes each in place (if/else forms, negated tests and a result
// variable tried)
// @retail 0x833327F8
bool CCSRBTTargetAngle::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (pBB->GetCurrentTarget() == 0)
    {
        return false;
    }
    const float Forward = pBB->GetCurrentTarget()->forwardDot;
    const float Right = pBB->GetCurrentTarget()->rightDot;
    const bool bFront = Forward >= 0.0f && Right <= 0.0f;
    const bool bRight = Forward >= 0.0f && Right >= 0.0f;
    const bool bBehind = Forward <= 0.0f && Right >= 0.0f;
    const bool bLeft = Forward <= 0.0f && Right <= 0.0f;
    const bool bValue = (checkFront && bFront) || (checkRight && bRight) || (checkBehind && bBehind) || (checkLeft && bLeft);
    return m_negate ? !bValue : (bool)bValue;
}

// ccsrbttargetangle.h's inline setter, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTTargetAngle::*const EmitTargetAngleSetActiveZones)(bool, bool, bool, bool) = &CCSRBTTargetAngle::SetActiveZones;
#pragma inline_depth()

// @retail 0x83324F98
// CCSRBTTargetAngle::SetActiveZones (in the header)
