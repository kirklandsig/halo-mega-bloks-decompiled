// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsworldquery.cpp: the brain's questions about the world; the class only
// holds its brain.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83333948
CCSWorldQuery::CCSWorldQuery(CCSBrain *pBrain) : m_pBrain(pBrain)
{
}
#endif
