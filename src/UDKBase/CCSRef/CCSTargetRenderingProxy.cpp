// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccstargetrenderingproxy.cpp: draws a marker over a brain's current target
// in the debug scene view.
#pragma once
#include "../CCSRefUE3/CCSGameCharacter.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833252C0
CCSTargetRenderingProxy::CCSTargetRenderingProxy() : m_targetHeight(0.0f), m_targetValid(false)
{
}
#endif

// score 53 (was 58): raising the tip in a separate float (tipZ) and writing
// it back at the end reproduces retail's copy schedule - the position is
// copied as Y, Z, X and every member is reloaded right after its word copy,
// which only happens when the Z member is not modified in place. What is
// left is scheduling alone: retail keeps tipZ in f12 with 8.0 in f11 and
// 10.0 in f10, stores arrowTip.Z before the tip's X copy, reloads X right
// after it and stores the two base vectors as X, Y, Z; ours keeps tipZ in
// f10, reuses f0 for 20.0 and 8.0, reloads X late and stores the bases as
// Y, Z, X. Tried: raising the tip in place (168), building the body base
// from the tip base, declaring the body base first with its Z as tip.Z + 18
// (48, but MSVC folds 8 + 10 into 18, so the body Z is no longer retail's
// (tipZ + 8) + 10 - not kept), constructors instead of member assignments,
// storing arrowTip.Z right after tipZ, hoisting the tip's X and Y into float
// locals, stepwise arithmetic with float temps, reading the height from
// m_targetPos, and every statement, member and declaration order - MSVC
// canonicalises them all to byte-identical code (53, or 168 when an extra
// local moves the frame); the permuter over this spelling found nothing
// below 53.
// Still 53 after: splitting tipZ into two statements, separate baseZ and
// bodyZ locals, sharing one base height between the two vectors (168),
// raising the tip in place with the bases reading the member back (168),
// constructor-built bases, and all 96 permutations of the tipZ, base and
// body expressions, the member order and the write-back position - MSVC
// compiles every one of them to the same code. Retail's line table puts
// the whole body in one block (AddCone at L+22, AddCylinder at L+28, so
// its source ran about 19 lines of setup) and names the same four locals
// we have, so the shape is right and only MSVC's float allocation differs:
// retail keeps tipZ in f12 with 8.0 in f11 and 10.0 in f10, reloads the
// tip's X right after its word copy and stores the base vectors as X, Y,
// Z, while ours keeps tipZ in f10, reuses f0 for 8.0, reloads X late and
// stores them Y, Z, X.
// @retail 0x83325328
void CCSTargetRenderingProxy::Render(IGripSceneRenderer *pRenderer)
{
    if (m_targetValid)
    {
        Grip_Vector arrowTip = m_targetPos;
        float tipZ = m_targetHeight + arrowTip.Z + 20.0f;
        Grip_Color arrowColor(255, 0, 0);
        Grip_Vector arrowTipBase;
        arrowTipBase.X = arrowTip.X;
        arrowTipBase.Y = arrowTip.Y;
        arrowTipBase.Z = tipZ + 8.0f;
        Grip_Vector arrowBodyBase;
        arrowBodyBase.X = arrowTip.X;
        arrowBodyBase.Y = arrowTip.Y;
        arrowBodyBase.Z = arrowTipBase.Z + 10.0f;
        arrowTip.Z = tipZ;
        pRenderer->AddCone(arrowTipBase, arrowTip, 5.0f, arrowColor);
        pRenderer->AddCylinder(arrowTipBase, arrowBodyBase, 2.0f, arrowColor);
    }
}

// @retail 0x833338B0
void CCSTargetRenderingProxy::SetTarget(const CCSTarget *pTarget)
{
    m_targetValid = pTarget == 0 ? false : pTarget->character != CCSCharacter::NONE;
    if (m_targetValid)
    {
        m_targetPos = pTarget->position;
        m_targetHeight = pTarget->character.GetHeight();
    }
}
