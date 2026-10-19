// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCover.cpp"
#include "CCSCSCover.cpp"

// @retail 0x83339F70
CCSAFGetInCover::CCSAFGetInCover() : m_pCSCover(0) {}

// @retail 0x83322D60
void CCSAFGetInCover::SetObjective(const CCSAOGetInCover &Objective)
{
    m_objective = Objective;
}

// @retail 0x8332CC50
void CCSAFGetInCover::PostCreate()
{
    m_pCSCover = m_pAFInterface->GetSystem<CCSCSCover>();
}

// @retail 0x8332CC98
void CCSAFGetInCover::OnActivate()
{
    if (m_pCSCover == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    if (m_pCSCover->InitiateGetInCover(m_objective.target))
    {
        m_pCSCover->Activate();
        GripAFAction::OnActivate();
    }
}

// @retail 0x8332CD28
bool CCSAFGetInCover::TransitionTo(GripAFAction *)
{
    bool bInCover = m_pCSCover->m_coverState == CCSCSCover::CS_INCOVER;
    if (bInCover)
    {
        m_status = AS_DONE;
    }
    return bInCover;
}

// @retail 0x8332CD58
void CCSAFGetInCover::Tick(float)
{
    if (m_pCSCover->m_coverState == CCSCSCover::CS_INCOVER)
    {
        m_status = AS_DONE;
    }
}

// @retail 0x8333A010
// CCSAFGetInCover::~CCSAFGetInCover
// @retail 0x8333A018
// CCSAFGetInCover::`scalar deleting destructor'
