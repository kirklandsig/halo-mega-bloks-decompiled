// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCover.cpp"
#include "CCSCSCover.cpp"

// @retail 0x8333A080
CCSAFGetOutCover::CCSAFGetOutCover() : m_pCSCover(0) {}

// @retail 0x83322D70
void CCSAFGetOutCover::SetObjective(const CCSAOGetOutCover &Objective)
{
    m_objective = Objective;
}

// @retail 0x8332CDC8
void CCSAFGetOutCover::PostCreate()
{
    m_pCSCover = m_pAFInterface->GetSystem<CCSCSCover>();
}

// @retail 0x8332CE10
void CCSAFGetOutCover::OnActivate()
{
    if (m_pCSCover == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    if (m_pCSCover->InitiateGetOutCover(m_objective.target))
    {
        m_pCSCover->Activate();
        GripAFAction::OnActivate();
    }
}

// @retail 0x8332CEA0
bool CCSAFGetOutCover::TransitionTo(GripAFAction *)
{
    if (m_pCSCover == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    bool bInCover = m_pCSCover->m_coverState == CCSCSCover::CS_OUTCOVER;
    if (bInCover)
    {
        m_status = AS_DONE;
    }
    return bInCover;
}

// @retail 0x8332CEE8
void CCSAFGetOutCover::Tick(float)
{
    if (m_pCSCover->m_coverState == CCSCSCover::CS_OUTCOVER)
    {
        m_status = AS_DONE;
    }
}

// @retail 0x8333A120
// CCSAFGetOutCover::~CCSAFGetOutCover
// @retail 0x8333A128
// CCSAFGetOutCover::`scalar deleting destructor'
