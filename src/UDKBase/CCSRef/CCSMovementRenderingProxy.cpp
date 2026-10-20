// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsmovementrenderingproxy.h: draws the movement system's destinations as
// cones: the current and final destinations, the objective's target and the
// next move location.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x8332B180
void CCSMovementRenderingProxy::Render(IGripSceneRenderer *pRenderer)
{
    Grip_Color CurrDestColor(102, 255, 255);
    Grip_Color FinalDestColor(255, 255, 255);
    Grip_Color NextMoveColor(255, 102, 0);
    Grip_Color ObjectiveColor(20, 255, 20);
    pRenderer->AddCone(Grip_Vector(m_currDest.X, m_currDest.Y, m_currDest.Z + 15.0f), m_currDest, 10.0f, CurrDestColor);
    pRenderer->AddCone(Grip_Vector(m_finalDest.X, m_finalDest.Y, m_finalDest.Z + 15.0f), m_finalDest, 10.0f, FinalDestColor);
    pRenderer->AddCone(Grip_Vector(m_objectiveTarget.X, m_objectiveTarget.Y, m_objectiveTarget.Z + 15.0f), m_objectiveTarget, 10.0f, ObjectiveColor);
    pRenderer->AddCone(Grip_Vector(m_nextMoveLocation.X, m_nextMoveLocation.Y, m_nextMoveLocation.Z + 5.0f), m_nextMoveLocation, 5.0f, NextMoveColor);
}
