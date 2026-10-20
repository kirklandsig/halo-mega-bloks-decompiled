// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// @retail 0x8332C688
CCSAFFlee::CCSAFFlee() : m_pMovementCS(0), m_updateTimer(0.75f) {}

// @retail 0x83339D98
void CCSAFFlee::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
        m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    }
}

// @retail 0x83322CD0
void CCSAFFlee::SetObjective(const CCSAOFlee &Objective)
{
    m_objective = Objective;
}

// @retail 0x83339E98
void CCSAFFlee::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovement>();
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    m_pMovementCS->m_pMeatPuppet->SetIsPanicking(1);
    m_initialRotation = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn->Rotation;
    UpdateMoveTarget();
    m_pMovementCS->Activate();
}

// Todo: the logic is retail's, but retail builds the rotations from members
// it stores and reloads, and copies the trace vectors through more stack
// temporaries (a larger frame); not yet found.
// @retail 0x8332C770
void CCSAFFlee::UpdateMoveTarget()
{
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    m_fleeRotation = m_initialRotation;
    m_fleeRotation.Yaw = (int)(m_fleeRotation.Yaw + 180 * 182.0444);
    Grip_Vector Target;
    FCheckResult Hit;
    float BestTime = 0.0f;
    FRotator Rotations[3] = {
        FRotator(m_fleeRotation.Pitch, (int)(m_fleeRotation.Yaw - 45 * 182.0444), m_fleeRotation.Roll),
        m_fleeRotation,
        FRotator(m_fleeRotation.Pitch, (int)(m_fleeRotation.Yaw + 45 * 182.0444), m_fleeRotation.Roll),
    };
    int Index = rand() % 3;
    for (int i = 0; i < 3; i++)
    {
        FRotator &Rotation = Rotations[Index];
        FVector Direction = Rotation.Vector();
        FVector Start = pPawn->Location;
        FVector End = Start + Direction * 1000.0f;
        if (GWorld->SingleLineCheck(Hit, (AActor *)m_pMeatPuppet->GetCharacter().GetActor(), End, Start, 0x209F, FVector(0, 0, 0), 0))
        {
            Target = End;
            m_fleeRotation = Rotation;
            break;
        }
        if (BestTime < Hit.Time)
        {
            BestTime = Hit.Time;
            Target = Hit.Location;
        }
        Index = (Index + 1) % 3;
    }
    m_objective.moveTarget = Target;
    m_objective.movementType = CCS::MovementType_Run;
    m_objective.alertness = CCS::AlertnessState_Alert;
    m_pMovementCS->SetObjective(m_objective);
}

// @retail 0x83322CF0
bool CCSAFFlee::TransitionTo(GripAFAction *)
{
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    m_pMovementCS->m_pMeatPuppet->SetIsPanicking(0);
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x8332CB60
void CCSAFFlee::Tick(float DeltaTime)
{
    m_updateTimer -= DeltaTime;
    m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn->SetDesiredRotation(m_fleeRotation, 0, 0, -1.0f, 1);
    if (m_updateTimer < 0.0f)
    {
        m_updateTimer = 0.75f;
        UpdateMoveTarget();
    }
}

// @retail 0x8332C700
// CCSAFFlee::~CCSAFFlee
// @retail 0x8332C708
// CCSAFFlee::`scalar deleting destructor'
