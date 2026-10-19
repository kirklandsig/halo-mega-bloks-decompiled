// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCover.cpp"

// @retail 0x83339C88
CCSAFEnterCover::CCSAFEnterCover() : m_pCSCover(0) {}

// @retail 0x83322B90
void CCSAFEnterCover::SetObjective(const CCSAOEnterCover &Objective)
{
    m_objective = Objective;
}

// @retail 0x8332C360
void CCSAFEnterCover::PostCreate()
{
    m_pCSCover = m_pAFInterface->GetSystem<CCSCSCover>();
}

// @retail 0x8332C3A8
void CCSAFEnterCover::OnActivate()
{
    if (m_pCSCover == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    if (m_pCSCover->InitiateEnterCover(m_objective.cover, m_objective.target))
    {
        m_pCSCover->Activate();
        GripAFAction::OnActivate();
    }
}

// @retail 0x8332C438
bool CCSAFEnterCover::TransitionTo(GripAFAction *)
{
    if (m_pCSCover == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    bool bInCover = m_pCSCover->m_coverState == CCSCSCover::CS_INCOVER;
    if (bInCover)
    {
        m_status = AS_DONE;
    }
    return bInCover;
}

// @retail 0x8332C480
void CCSAFEnterCover::Tick(float)
{
    if (m_pCSCover->m_coverState == CCSCSCover::CS_INCOVER)
    {
        m_status = AS_DONE;
    }
}

// @retail 0x83339D28
// CCSAFEnterCover::~CCSAFEnterCover
// @retail 0x83339D30
// CCSAFEnterCover::`scalar deleting destructor'
