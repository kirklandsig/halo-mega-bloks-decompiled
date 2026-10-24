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
// it back at the end reproduces retail's copy schedule - retail copies the
// position as Y, Z, X and reloads every member right after its word copy,
// which only happens when the Z member is not modified in place. Still
// differs: retail reloads X early and stores the two base vectors as
// X, Y, Z, ours reloads X late and stores them as Y, Z, X. Tried this
// session: raising the tip in place with the bases built from float members
// or from constructors (168), building the body base from the tip base (53),
// declaring the body base first with its Z as tip.Z + 18 (48, but MSVC folds
// 8 + 10 into 18 so the body Z is no longer the (tipZ + 8) + 10 of retail -
// not kept), reading the height from m_targetPos, locals for the tip X and
// Y, and every statement and member order permutation (all 53 or worse:
// MSVC canonicalises them). The permuter over this spelling found nothing
// below 53.
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
