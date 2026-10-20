// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// @retail 0x8332DFC0
CCSAFStrafeTo::CCSAFStrafeTo() : m_pMovementCS(0) {}

// @retail 0x83323330
void CCSAFStrafeTo::SetObjective(const CCSAOStrafeTo &Objective)
{
    m_objective = Objective;
}

// @retail 0x8333A7D0
void CCSAFStrafeTo::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
        m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    }
}

// @retail 0x8332E0A0
void CCSAFStrafeTo::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovement>();
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    m_objective.movementType = CCS::MovementType_Strafe;
    m_pMovementCS->SetObjective(m_objective);
    m_pMovementCS->Activate();
}

// @retail 0x83323350
bool CCSAFStrafeTo::TransitionTo(GripAFAction *)
{
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x8332E158
void CCSAFStrafeTo::Tick(float)
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

// @retail 0x8332E030
// CCSAFStrafeTo::~CCSAFStrafeTo
// @retail 0x8332E038
// CCSAFStrafeTo::`scalar deleting destructor'
