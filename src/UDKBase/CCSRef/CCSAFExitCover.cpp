// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSCover.cpp"

// @retail 0x83322BA0
CCSAFExitCover::CCSAFExitCover() : m_pCSCover(0) {}

// @retail 0x8332C508
void CCSAFExitCover::PostCreate()
{
    m_pCSCover = m_pAFInterface->GetSystem<CCSCSCover>();
}

// @retail 0x83322C00
void CCSAFExitCover::OnActivate()
{
    if (m_pCSCover == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    GripAFAction::OnActivate();
}

// @retail 0x8332C550
bool CCSAFExitCover::TransitionTo(GripAFAction *)
{
    if (m_pCSCover != 0)
    {
        m_pCSCover->InitiateExitCover();
        m_status = AS_DONE;
    }
    return true;
}

// @retail 0x83322C20
void CCSAFExitCover::Tick(float)
{
    m_status = AS_DONE;
}

// @retail 0x83322BF8
// CCSAFExitCover::~CCSAFExitCover
// @retail 0x8332C4A0
// CCSAFExitCover::`scalar deleting destructor'

// ccsafexitcover.h's inline SetObjective, out of line as in retail
#pragma inline_depth(0)
extern void (CCSAFExitCover::*const EmitExitCoverSetObjective)(const CCSAOExitCover &) = &CCSAFExitCover::SetObjective;
#pragma inline_depth()

// @retail 0x8331DF18
// CCSAFExitCover::SetObjective (in the header)
