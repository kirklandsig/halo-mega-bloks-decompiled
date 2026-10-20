// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsmessengerworker.cpp: the CCS layer's side of the AI console link: it
// sends, saves and restores the CCS debug options.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833245A8
CCSMessengerWorker::CCSMessengerWorker(GripAIConsoleMessenger *pMessenger) : GripMessengerWorker(pMessenger)
{
}
#endif

// @retail 0x8334C468
void CCSMessengerWorker::Tick()
{
    SendDebugOptions();
}

// @retail 0x8334C470
void CCSMessengerWorker::OnMessage(EGripConsoleMessageID Id, Grip::String Message)
{
    if (Id == msgConsoleConnected)
    {
        SaveDebugOptions();
    }
    else if (Id == msgConsoleDisconnected)
    {
        LoadDebugOptions();
    }
    else if (Id == msgCCSDebugOptionsData)
    {
        SetDebugOptions(Message);
    }
}
