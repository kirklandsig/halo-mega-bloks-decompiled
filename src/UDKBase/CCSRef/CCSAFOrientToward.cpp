// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// @retail 0x8332D728
CCSAFOrientToward::CCSAFOrientToward() : m_pMovementCS(0) {}

// @retail 0x83323228
void CCSAFOrientToward::SetObjective(const CCSAOOrientToward &Objective)
{
    m_objective = Objective;
}

// @retail 0x8333A570
void CCSAFOrientToward::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
    }
}

// @retail 0x8332D808
void CCSAFOrientToward::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovement>();
    m_pMovementCS->SetObjective(m_objective);
    m_pMovementCS->Activate();
}

// @retail 0x83323248
bool CCSAFOrientToward::TransitionTo(GripAFAction *)
{
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x8332D888
void CCSAFOrientToward::Tick(float)
{
    if (m_pMovementCS->ObjectiveReached())
    {
        m_status = AS_DONE;
    }
}

// @retail 0x8332D798
// CCSAFOrientToward::~CCSAFOrientToward
// @retail 0x8332D7A0
// CCSAFOrientToward::`scalar deleting destructor'
