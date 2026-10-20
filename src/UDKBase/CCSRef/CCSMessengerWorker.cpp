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

// near: retail loads the four flags before storing any and builds the
// message string in the data's frame slot (aggregate init, a scope and a
// flag pointer tried)
// @retail 0x83344648
void CCSMessengerWorker::SendDebugOptions()
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    if (pOptions == 0)
    {
        return;
    }
    CCSDebugOptionsData Data;
    Data.m_cover = pOptions->m_options[CCSDebugOptions::COVER];
    Data.m_movement = pOptions->m_options[CCSDebugOptions::MOVEMENT];
    Data.m_actionScheduler = pOptions->m_options[CCSDebugOptions::ACTION_SCHEDULER];
    Data.m_animationFlags = pOptions->m_options[CCSDebugOptions::ANIM_FLAGS];
    GripSerializer Serializer;
    Serializer.Initialize();
    Serializer.Write("ccsdebugoptionsdata", &Data);
    m_pMessenger->AddOutgoingMessage(msgCCSDebugOptionsData, Serializer.GetStringRepresentation());
}

// Remembers the options the console found when it connected...
// @retail 0x8333C428
void CCSMessengerWorker::SaveDebugOptions()
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    if (pOptions == 0)
    {
        return;
    }
    m_CCSDebugOptionsMemento.m_CCSShowCover = pOptions->m_options[CCSDebugOptions::COVER];
    m_CCSDebugOptionsMemento.m_CCSShowMovement = pOptions->m_options[CCSDebugOptions::MOVEMENT];
    m_CCSDebugOptionsMemento.m_CCSShowActionScheduler = pOptions->m_options[CCSDebugOptions::ACTION_SCHEDULER];
    m_CCSDebugOptionsMemento.m_CCSAnimationFlags = pOptions->m_options[CCSDebugOptions::ANIM_FLAGS];
}

// ...and puts them back when it disconnects.
// @retail 0x8333C4B0
void CCSMessengerWorker::LoadDebugOptions()
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    if (pOptions == 0)
    {
        return;
    }
    pOptions->m_options[CCSDebugOptions::COVER] = m_CCSDebugOptionsMemento.m_CCSShowCover;
    pOptions->m_options[CCSDebugOptions::MOVEMENT] = m_CCSDebugOptionsMemento.m_CCSShowMovement;
    pOptions->m_options[CCSDebugOptions::ACTION_SCHEDULER] = m_CCSDebugOptionsMemento.m_CCSShowActionScheduler;
    pOptions->m_options[CCSDebugOptions::ANIM_FLAGS] = m_CCSDebugOptionsMemento.m_CCSAnimationFlags;
}

// The console sends options as comma-separated "name.yes" or "name.no".
// @retail 0x83344728
void CCSMessengerWorker::SetDebugOptions(const Grip::String &Options)
{
    const char *pOptions = Options.ToCStr();
    unsigned int Remaining = Options.GetSize();
    do
    {
        unsigned int Length = 0;
        while (Length < Remaining && pOptions[Length] != 0 && pOptions[Length] != ',')
        {
            Length++;
        }
        unsigned int Skip = Remaining >= Length + 1 ? Length + 1 : Remaining;
        const char *pOption = pOptions;
        pOptions += Skip;
        Remaining -= Skip;
        Grip::String Option(pOption, Length);
        SetDebugOption(Option);
    } while (Remaining != 0);
}

// near: retail keeps the name in r31 and the value in r30, ours the other
// way round (declaration orders and value forms tried)
// @retail 0x8333C538
void CCSMessengerWorker::SetDebugOption(const Grip::String &Option)
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    if (pOptions == 0)
    {
        return;
    }
    const char *pName = Option.ToCStr();
    unsigned int Size = Option.GetSize();
    int Dot = -1;
    for (unsigned int i = 0; i < Size; i++)
    {
        if (pName[i] == '.')
        {
            Dot = i;
            break;
        }
    }
    if (Dot == -1)
    {
        return;
    }
    unsigned int Value = Size >= (unsigned int)Dot + 1 ? Dot + 1 : Size;
    bool bValue = strncmp(pName + Value, "yes", 3) == 0;
    if (strncmp(pName, "cover", 5) == 0)
    {
        pOptions->m_options[CCSDebugOptions::COVER] = bValue;
    }
    else if (strncmp(pName, "movement", 8) == 0)
    {
        pOptions->m_options[CCSDebugOptions::MOVEMENT] = bValue;
    }
    else if (strncmp(pName, "actionscheduler", 15) == 0)
    {
        pOptions->m_options[CCSDebugOptions::ACTION_SCHEDULER] = bValue;
    }
    else if (strncmp(pName, "animationflags", 14) == 0)
    {
        pOptions->m_options[CCSDebugOptions::ANIM_FLAGS] = bValue;
    }
}

// @retail 0x833245F8
void CCSDebugOptionsData::Serialize(GripSerializer *pSerializer)
{
    pSerializer->Write("cover", &m_cover);
    pSerializer->Write("movement", &m_movement);
    pSerializer->Write("actionscheduler", &m_actionScheduler);
    pSerializer->Write("animationflags", &m_animationFlags);
}
