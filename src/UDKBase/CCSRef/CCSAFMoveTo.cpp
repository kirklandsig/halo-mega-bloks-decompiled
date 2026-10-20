// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// @retail 0x8332D158
CCSAFMoveTo::CCSAFMoveTo() : m_pMovementCS(0) {}

// @retail 0x83322FD8
void CCSAFMoveTo::SetObjective(const CCSAOMoveTo &Objective)
{
    m_objective = Objective;
}

// @retail 0x8333A370
void CCSAFMoveTo::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
        m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    }
}

// @retail 0x8332D238
void CCSAFMoveTo::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovementGwNav>();
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    m_pMovementCS->SetObjective(m_objective);
    m_pMovementCS->Activate();
}

// @retail 0x83322FF8
bool CCSAFMoveTo::TransitionTo(GripAFAction *)
{
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x8332D2E0
void CCSAFMoveTo::Tick(float)
{
    if (m_pMovementCS->ObjectiveReached())
    {
        m_status = AS_DONE;
    }
    if (m_pMovementCS->PathFailed())
    {
        m_status = AS_FAILURE;
    }
}

// @retail 0x8332D1C8
// CCSAFMoveTo::~CCSAFMoveTo
// @retail 0x8332D1D0
// CCSAFMoveTo::`scalar deleting destructor'
