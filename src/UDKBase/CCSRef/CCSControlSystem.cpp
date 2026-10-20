// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscontrolsystem.cpp: the base of a brain's control systems (movement,
// cover); it keeps the brain's meat puppet.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332EE78
CCSControlSystem::CCSControlSystem(CCSCSInterface *pCSInterface) : m_pCSInterface(pCSInterface)
{
    m_pMeatPuppet = pCSInterface->m_pBrain->m_meatPuppet;
    m_used = true;
}
#endif

// ccscontrolsystem.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitControlSystemSGetFamily)() = &CCSControlSystem::SGetFamily;
extern int (CCSControlSystem::*const EmitControlSystemGetFamily)() const = &CCSControlSystem::GetFamily;
#pragma inline_depth()

// @retail 0x833203C8
// CCSControlSystem::SGetFamily (in the header)
// @retail 0x83320B40
// CCSControlSystem::GetFamily (in the header)
