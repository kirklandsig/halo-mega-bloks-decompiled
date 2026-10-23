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

// @retail 0x83344648
void CCSMessengerWorker::SendDebugOptions()
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    if (pOptions == 0)
    {
        return;
    }
    const bool bCover = pOptions->m_options[CCSDebugOptions::COVER];
    const bool bMovement = pOptions->m_options[CCSDebugOptions::MOVEMENT];
    const bool bScheduler = pOptions->m_options[CCSDebugOptions::ACTION_SCHEDULER];
    const bool bAnim = pOptions->m_options[CCSDebugOptions::ANIM_FLAGS];
    // The retail ends the data struct's scope before the write, so the frame
    // slot it lives in is free again for the string the serializer hands back.
    CCSDebugOptionsData *pData;
    {
        CCSDebugOptionsData Data;
        Data.m_cover = bCover;
        Data.m_movement = bMovement;
        Data.m_actionScheduler = bScheduler;
        Data.m_animationFlags = bAnim;
        pData = &Data;
    }
    GripSerializer Serializer;
    Serializer.Initialize();
    Serializer.Write("ccsdebugoptionsdata", pData);
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

// score 7 (was 11): retail forms the value pointer with one add of a clamped
// offset (the name plus the smaller of dot+1 and the size). Selecting the
// pointer itself (pName + Size vs pName + Offset) keeps the value in a
// register instead of letting the compiler fold it into the strncmp call,
// which restores retail's register plan (the string pointer in r31, the
// option in r30, the literals in r11 and r10). What is left: the compiler
// builds one pointer per arm (an extra add, hoisted above the compare) and
// picks the arm with a branch, where retail clamps the offset in a register
// (mr r11, r10) and adds once; the add's operands are swapped as well.
// Clamping the offset in a register instead (if (Size < Offset) Offset =
// Size; pValue = pName + Offset) does give retail's mr and its single add,
// but then the compiler folds the pointer into the strncmp argument, the
// offset stays live across the "yes" literal setup and every register
// shifts (score 33). Also tried this session, all score 7 or 33: the clamp
// as a ternary, the pointer through an inline helper, the pointer
// assigned in both arms of the clamp, &pName[Offset] and Offset + pName
// spellings, a non-const pointer, and a 10 minute permuter run (4147
// rewrites, no improvement).
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
    unsigned int Offset = (unsigned int)Dot + 1;
    const char *pValue = Size < Offset ? pName + Size : pName + Offset;
    bool bValue = strncmp(pValue, "yes", 3) == 0;
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
