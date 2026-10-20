// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsgscover.cpp: the global data system that tracks the world's covers and
// who occupies them. Other files of the unity include this one for the
// definitions they inline.
#pragma once
#include "CCSGlobalDataSystem.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83356D68
CCSGSCover::CCSGSCover(CCSGlobalBlackboard *pGlobalBB) : CCSGlobalDataSystem(pGlobalBB)
{
}
#endif
