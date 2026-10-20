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

// near: retail reads the copied position's Y before its Z and its X last;
// ours reads them in member order (tried the colour first and last, the
// cylinder's end from the cone's top or the base)
// @retail 0x83325328
void CCSTargetRenderingProxy::Render(IGripSceneRenderer *pRenderer)
{
    if (m_targetValid)
    {
        Grip_Vector Pos = m_targetPos;
        Pos.Z = m_targetHeight + Pos.Z + 20.0f;
        Grip_Color Red(255, 0, 0);
        Grip_Vector Top(Pos.X, Pos.Y, Pos.Z + 8.0f);
        Grip_Vector End(Top.X, Top.Y, Top.Z + 10.0f);
        pRenderer->AddCone(Top, Pos, 5.0f, Red);
        pRenderer->AddCylinder(Top, End, 2.0f, Red);
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
