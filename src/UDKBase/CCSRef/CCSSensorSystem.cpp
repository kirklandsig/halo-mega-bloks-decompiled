// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccssensorsystem.cpp: the base of a brain's sensor systems. Other files of
// the unity include this one for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83325128
CCSSensorSystem::CCSSensorSystem(CCSBrain *pBrain) : m_pBrain(pBrain)
{
}
#endif

// @retail 0x833251E8
void CCSSensorSystem::Initialize(const GripSystemConfig *)
{
    m_inStasis = true;
}
