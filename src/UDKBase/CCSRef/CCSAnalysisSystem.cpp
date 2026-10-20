// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsanalysissystem.cpp: the base of a brain's analysis systems, and the
// out-of-line constructor of the abstract CCSAFAction (ccsafaction.h).
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// Both constructors are inline in UDKBaseInline.h, so that every derived
// constructor inlines them as in retail; nothing calls them out of line.
// Retail still has a copy of each. MSVC's explicit constructor call (an
// extension), compiled under inline_depth(0), emits it.
#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
#pragma inline_depth(0)
void EmitAbstractConstructors(CCSAnalysisSystem *pSystem, CCSBrain *pBrain, CCSAFAction *pAction)
{
    pSystem->CCSAnalysisSystem::CCSAnalysisSystem(pBrain);
    pAction->CCSAFAction::CCSAFAction();
}
#pragma inline_depth()
#endif

// @retail 0x833233D0
// CCSAnalysisSystem::CCSAnalysisSystem
// @retail 0x8331DE98
// CCSAFAction::CCSAFAction (ccsafaction.h)
