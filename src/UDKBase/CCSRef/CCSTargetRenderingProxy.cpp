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
// words where retail stores floats
// @retail 0x83325328
void CCSTargetRenderingProxy::Render(IGripSceneRenderer *pRenderer)
{
    if (m_targetValid)
    {
        Grip_Vector arrowTip = m_targetPos;
        arrowTip.Z = m_targetHeight + arrowTip.Z + 20.0f;
        Grip_Color arrowColor(255, 0, 0);
        Grip_Vector arrowTipBase = arrowTip;
        arrowTipBase.Z = arrowTipBase.Z + 8.0f;
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
