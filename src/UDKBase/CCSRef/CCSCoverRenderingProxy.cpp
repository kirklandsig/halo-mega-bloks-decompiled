// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscoverrenderingproxy.cpp: draws a brain's cover slots, coloured by
// state, in the debug scene view.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83344330
CCSCoverRenderingProxy::CCSCoverRenderingProxy()
{
}
#endif

// @retail 0x8334C310
void CCSCoverRenderingProxy::SetCovers(Grip_Array<CCSCover, Grip::AllocatorGH<CCSCover, 2> > &Covers)
{
    m_covers.Clone(Covers);
}

// Each slot gets a 60-unit circle in its state's colour (cyan when this
// brain uses it) and an arrow 100 units along its facing.
// @retail 0x8332EFE8
void CCSCoverRenderingProxy::Render(IGripSceneRenderer *pRenderer)
{
    static Grip_Color s_valid(0, 255, 0);
    static Grip_Color s_invalid(255, 0, 0);
    static Grip_Color s_taken(0, 0, 255);
    static Grip_Color s_outsideRange(128, 128, 128);
    static Grip_Color s_inUse(102, 255, 255);
    static Grip_Color s_badAttackAngle(128, 128, 0);
    for (int i = 0; i < m_covers.Num(); i++)
    {
        const CCSCover &Cover = m_covers[i];
        Grip_Color Color = s_valid;
        switch (Cover.m_state)
        {
        case CCS::CoverState_Valid:
            Color = s_valid;
            break;
        case CCS::CoverState_Occupied:
        case CCS::CoverState_Reserved:
            Color = s_taken;
            break;
        case CCS::CoverState_OutsideRange:
            Color = s_outsideRange;
            break;
        case CCS::CoverState_BadAttackAngle:
            Color = s_badAttackAngle;
            break;
        default:
            Color = s_invalid;
            break;
        }
        if (Cover.m_inUseByMe)
        {
            Color = s_inUse;
        }
        pRenderer->AddCircle(Cover.GetPosition(), 60.0f, Color);
        Grip_Vector Offset = static_cast<const Grip_Vector &>(Cover.GetOrientation().Vector2D()) * 100.0f;
        Grip_Vector End = Offset + Cover.GetPosition();
        pRenderer->AddArrow(Cover.GetPosition(), End, Color);
    }
}
