// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsaimanagerfactory.cpp: hooks the CCS layer into the Grip engine: the
// engine calls InitializeCognition, which registers the factory that adds
// the CCS AI system and debug options to each AI manager.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// ccsaimanagerfactory.h: each file that includes the header registers the
// factory through its own static object
extern void (*InitializeCognitionFunction)(GripEngine *);
#line 33
static CCSAIManagerFactoryRegister s_AIManagerFactoryRegister;

// @retail 0x842891F8
// `dynamic initializer for 's_AIManagerFactoryRegister''

// @retail 0x83336148
void InitializeCognition(GripEngine *pEngine)
{
    pEngine->AddAIManagerFactory(new CCSAIManagerFactory);
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833361D0
CCSAIManagerFactoryRegister::CCSAIManagerFactoryRegister()
{
    InitializeCognitionFunction = &InitializeCognition;
}
#endif

// @retail 0x8335BED0
void CCSAIManagerFactory::Initialize(GripAIManager *pManager)
{
    pManager->AddSystem(new CCSAISystem(pManager));
    pManager->AddSystem(new CCSDebugOptions(pManager));
}
