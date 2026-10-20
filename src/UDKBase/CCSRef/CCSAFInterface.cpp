// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsafinterface.cpp: what an action sees of its brain: the clock and the
// brain's systems.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332CF70
CCSAFInterface::CCSAFInterface(CCSBrain *pBrain) : m_pBrain(pBrain)
{
}
#endif

// @retail 0x83322E10
float CCSAFInterface::GetDeltaTime()
{
    return m_pBrain->GetDeltaTime();
}

// @retail 0x83322E28
float CCSAFInterface::GetTime()
{
    return m_pBrain->GetTime();
}

// @retail 0x83322E40
GripBrainSystem *CCSAFInterface::GetSystemInternal(int Family, int Id) const
{
    return m_pBrain->GetSystems().GetSystem(Family, Id);
}
