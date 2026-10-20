// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsdebugoptions.cpp: the CCS layer's debug options (which overlays to
// draw), set from the AI console and drawn on the HUD.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332FA68
CCSDebugOptions::CCSDebugOptions(GripAIManager *pAIMgr) : GripDebugOptions(pAIMgr)
{
    for (int i = 0; i < NUM_OF; i++)
    {
        m_options[i] = false;
    }
}
#endif

// @retail 0x83324360
CCSDebugOptions::~CCSDebugOptions()
{
}

// @retail 0x83324388
void CCSDebugOptions::Initialize(bool)
{
    m_pAIMgr->AddHUDRenderer(this);
}

// @retail 0x833243A0
void CCSDebugOptions::Finalize()
{
    m_pAIMgr->RemoveHUDRenderer(this);
}

// @retail 0x8333BF30
void CCSDebugOptions::SetDebugOptions(const Grip_ArrayPOD<int, 2> &Options)
{
    for (int i = 0; i < NUM_OF; i++)
    {
        m_options[i] = false;
    }
    if (Options.Num() == 0)
    {
        m_options[HELP] = true;
    }
    else
    {
        for (int i = 0; i < Options.Num(); i++)
        {
            const int Option = Options[i];
            if (Option > OFF && Option < NUM_OF)
            {
                m_options[Option] = true;
            }
        }
    }
    GripBrainDebugOptions *pBrainOptions = GripEngineServices::GetAIManagerSystem<GripBrainDebugOptions>();
    if (pBrainOptions != 0)
    {
        pBrainOptions->SetDebugOptions(Options);
    }
}

// @retail 0x833243B8
void CCSDebugOptions::SetOption(CCSDebugOptions::EOptions Option, bool bEnable)
{
    if (Option >= OFF && Option < NUM_OF)
    {
        m_options[Option] = bEnable;
    }
}

namespace Grip
{
unsigned int SFsprintf(char *pDest, unsigned int DestSize, const char *pFormat, ...);
}

// The options the console's help lists, by number
struct CCSDebugOptionName
{
    int option;
    const char *name;
};
static CCSDebugOptionName s_optionNames[] = {
    {CCSDebugOptions::OFF, "Turn off visualization"},
    {CCSDebugOptions::HELP, "Help"},
    {2, "Behavior Tree / Blackboard"},
    {3, "Step Mode"},
    {CCSDebugOptions::COVER, "Cover"},
    {CCSDebugOptions::MOVEMENT, "Movement"},
    {CCSDebugOptions::ACTION_SCHEDULER, "Action Scheduler"},
    {CCSDebugOptions::ANIM_FLAGS, "Animation Flags"},
};

// The help screen: the options and the debugging keys.
// todo: 8 bytes short; ours keeps the doubled line height in a saved
// register where retail doubles it again for each use
// @retail 0x8332FB68
void CCSDebugOptions::DrawHUD(GripHUDRenderer *pRenderer, int &Y)
{
    if (!GripDebug::ms_debugEnabled)
    {
        return;
    }
    Grip_Color Title(255, 102, 0);
    Grip_Color Text(0, 255, 0);
    const int Line = pRenderer->endl;
    if (!m_options[HELP])
    {
        return;
    }
    pRenderer->DrawString(100, Y, "CCSDebugOptions", Title);
    Y += Line;
    for (int i = 0; i < 8; i++)
    {
        char Buffer[64];
        Grip::SFsprintf(Buffer, sizeof(Buffer), "%2d", s_optionNames[i].option);
        Grip::String Option(Buffer);
        Option.AppendString(" - ", -1);
        Option.AppendString(s_optionNames[i].name, -1);
        pRenderer->DrawString(100, Y, Option, Text);
        Y += Line;
    }
    Y += Line;
    pRenderer->DrawString(100, Y, "Use the plus symbol <+> to create combinations e.g. CCSDebugOptions 2+3", Text);
    Y += Line * 2;
    pRenderer->DrawString(100, Y, "Stat CSS", Text);
    Y += Line * 2;
    pRenderer->DrawString(100, Y, "StartGripDebug", Text);
    Y += Line;
    pRenderer->DrawString(100, Y, "StopGripDebug", Text);
    Y += Line * 2;
    Grip::String Help("Select NPC to debug or advance simulation.");
    pRenderer->DrawString(100, Y, "<F1>", Text);
    pRenderer->DrawString(250, Y, Help, Text);
    Y += Line;
    Help = Grip::String("Toggle between BlackBoard and Behavior Tree display.");
    pRenderer->DrawString(100, Y, "<F2>", Text);
    pRenderer->DrawString(250, Y, Help, Text);
    Y += Line;
    Help = Grip::String("Advance simulation. Pause again upon release.");
    pRenderer->DrawString(100, Y, "<F3>", Text);
    pRenderer->DrawString(250, Y, Help, Text);
    Y += Line;
    Help = Grip::String("Pause.");
    pRenderer->DrawString(100, Y, "<F4>", Text);
    pRenderer->DrawString(250, Y, Help, Text);
    Y += Line;
}

// ccsdebugoptions.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitDebugOptionsSGetId)() = &CCSDebugOptions::SGetId;
extern bool (CCSDebugOptions::*const EmitIsOptionEnabled)(CCSDebugOptions::EOptions) const = &CCSDebugOptions::IsOptionEnabled;
#pragma inline_depth()

// @retail 0x8331EAB8
// CCSDebugOptions::SGetId (in the header)
// @retail 0x833243D8
// CCSDebugOptions::IsOptionEnabled (in the header)
