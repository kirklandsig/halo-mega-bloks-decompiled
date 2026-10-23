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

// score 58 (was 168): making the cone's base a copy of the tip (then raising
// its Z) reproduces retail's schedule; ours still copies the position in
// X, Y, Z order where retail reads Y, Z, X, and stores the base's members as
// words where retail stores floats. Tried this session: building both bases
// from float members or from constructors (168), copying the body base from
// the tip or from the tip base (79/88/61/76), copying the tip before raising
// it (118) and moving the colour around (168); MSVC canonicalises statement
// and member order, and the permuter found nothing below 58 from either the
// 58 or the 168 spelling.
// @retail 0x83325328
void CCSTargetRenderingProxy::Render(IGripSceneRenderer *pRenderer)
{
    if (m_targetValid)
    {
        Grip_Vector arrowTip = m_targetPos;
        arrowTip.Z = m_targetHeight + arrowTip.Z + 20.0f;
        Grip_Color arrowColor(255, 0, 0);
        Grip_Vector arrowTipBase = arrowTip;
        arrowTipBase.Z = arrowTip.Z + 8.0f;
        Grip_Vector arrowBodyBase(arrowTip.X, arrowTip.Y, arrowTipBase.Z + 10.0f);
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
