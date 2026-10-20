// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83322D80
CCSAFIdle::CCSAFIdle() {}

// Near: retail stores each new modifier's pointer to AddItem's temporary
// before the constructor's stores; ours after (tried a local, the unity
// order of ccsafmodifiers.cpp).
// @retail 0x8333A190
void CCSAFIdle::PostCreate()
{
    if (m_pMeatPuppet == 0)
    {
        return;
    }
    m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
    m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    AActor *pActor = (AActor *)m_pMeatPuppet->GetCharacter().GetActor();
    if (pActor->IsA(AVehicle::StaticClass()))
    {
        AVehicle *pVehicle = (AVehicle *)pActor;
        pVehicle->Velocity = FVector(0.0f, 0.0f, 0.0f);
        pVehicle->Throttle = 0.0f;
        pVehicle->Steering = 0.0f;
    }
}

// @retail 0x83322DE0
void CCSAFIdle::SetObjective(const CCSAOIdle &Objective)
{
    m_objective = Objective;
}

// @retail 0x83322DD8
// CCSAFIdle::~CCSAFIdle
// @retail 0x8332CF08
// CCSAFIdle::`scalar deleting destructor'

// ccsafmodifiers.cpp follows ccsafidle.cpp in the unity
#include "CCSAFModifiers.cpp"
