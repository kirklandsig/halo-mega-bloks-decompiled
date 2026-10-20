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
