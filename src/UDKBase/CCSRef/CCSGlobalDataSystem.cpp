// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsglobaldatasystem.cpp: the base of the systems that keep the AI's
// shared world data. Other files of the unity include this one for the
// definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83324478
CCSGlobalDataSystem::CCSGlobalDataSystem(CCSGlobalBlackboard *pGlobalBB) : m_pGlobalBB(pGlobalBB)
{
    FlagAsUsed();
}
#endif

// @retail 0x833244E8
void CCSGlobalDataSystem::Initialize(const GripSystemConfig *)
{
    m_inStasis = true;
}

// @retail 0x833244F8
void CCSGlobalDataSystem::Deactivate()
{
    GripBrainSystem::Deactivate();
    m_inStasis = true;
}
