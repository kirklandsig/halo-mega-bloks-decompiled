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

// ccsdebugoptions.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitDebugOptionsSGetId)() = &CCSDebugOptions::SGetId;
extern bool (CCSDebugOptions::*const EmitIsOptionEnabled)(CCSDebugOptions::EOptions) const = &CCSDebugOptions::IsOptionEnabled;
#pragma inline_depth()

// @retail 0x8331EAB8
// CCSDebugOptions::SGetId (in the header)
// @retail 0x833243D8
// CCSDebugOptions::IsOptionEnabled (in the header)
