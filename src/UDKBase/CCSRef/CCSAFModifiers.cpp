// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsafmodifiers.cpp: the action framework's modifiers. Other files of the
// unity include this one for the constructors they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83322E88
CCSAFAlertnessModifier::CCSAFAlertnessModifier(ICCSMeatPuppet *pMeatPuppet, CCS::EAlertnessState Alertness)
    : m_pMeatPuppet(pMeatPuppet), m_alertness(Alertness)
{
    m_id = 0;
}

// @retail 0x83322EB8
void CCSAFAlertnessModifier::Apply()
{
    m_pMeatPuppet->SetAlertness(m_alertness);
}

// @retail 0x83322ED8
void CCSAFAlertnessModifier::Revert()
{
    m_pMeatPuppet->SetAlertnessDefault();
}

// @retail 0x83322EF0
CCSAFMovementTypeModifier::CCSAFMovementTypeModifier(ICCSMeatPuppet *pMeatPuppet, CCS::EMovementType MovementType)
    : m_pMeatPuppet(pMeatPuppet), m_movementType(MovementType)
{
    m_id = 1;
}

// @retail 0x83322F20
void CCSAFMovementTypeModifier::Apply()
{
    m_pMeatPuppet->SetMovementType(m_movementType);
}

// @retail 0x83322F40
void CCSAFMovementTypeModifier::Revert()
{
    m_pMeatPuppet->SetMovementTypeDefault();
}

// @retail 0x83322F58
CCSAFPostureModifier::CCSAFPostureModifier(ICCSMeatPuppet *pMeatPuppet, bool bCrouched)
    : m_pMeatPuppet(pMeatPuppet), m_crouched(bCrouched)
{
    m_id = 2;
}

// @retail 0x83322F88
void CCSAFPostureModifier::Apply()
{
    m_pMeatPuppet->SetCrouched(m_crouched);
}

// @retail 0x83322FA8
void CCSAFPostureModifier::Revert()
{
    m_pMeatPuppet->SetPostureDefault();
}

// @retail 0x83322EA8
// CCSAFAlertnessModifier::~CCSAFAlertnessModifier
// @retail 0x83322F10
// CCSAFMovementTypeModifier::~CCSAFMovementTypeModifier
// @retail 0x83322F78
// CCSAFPostureModifier::~CCSAFPostureModifier
// @retail 0x8332D038
// CCSAFAlertnessModifier::`scalar deleting destructor'
// @retail 0x8332D098
// CCSAFMovementTypeModifier::`scalar deleting destructor'
// @retail 0x8332D0F8
// CCSAFPostureModifier::`scalar deleting destructor'
