// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscsinterface.cpp: what a control system sees of its brain: the meat
// puppet and the debug renderers.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833240F0
CCSCSInterface::CCSCSInterface(CCSBrain *pBrain) : m_pBrain(pBrain)
{
}
#endif

// @retail 0x83324108
CCSCSInterface::~CCSCSInterface()
{
}

// @retail 0x83324178
ICCSMeatPuppet *CCSCSInterface::GetMeatPuppet() const
{
    return m_pBrain->m_meatPuppet;
}

// @retail 0x83344450
void CCSCSInterface::AddDebugRenderer(IGripSRComponent *pComponent)
{
    m_pBrain->AddDebugRenderer(pComponent);
}

// @retail 0x8334C330
void CCSCSInterface::RemoveDebugRenderer(IGripSRComponent *pComponent)
{
    m_pBrain->RemoveDebugRenderer(pComponent);
}
