// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// One named constant for the two 1.0f of Tick (the Camo test and the update
// timer): retail keeps the constant's address in a register and reloads the
// value around the call in GetNavAdjustedLocation, which a literal does not.
static const float kOne = 1.0f;

// @retail 0x8332D348
CCSAFMoveToActor::CCSAFMoveToActor() : m_pMovementCS(0), m_updateTimer(1.0f) {}

// @retail 0x83323070
void CCSAFMoveToActor::SetObjective(const CCSAOMoveToActor &Objective)
{
    m_objective = Objective;
    m_moveToObjective.target = m_objective.pTarget != 0 ? GripEngineServices::GetActorPosition(m_objective.pTarget) : Grip_Vector();
    if (Objective.pTarget != 0)
    {
        m_moveToObjective.target = ((AActor *)Objective.pTarget)->GetNavAdjustedLocation(Objective.pointOfOrigin, 1.1f);
    }
    m_moveToObjective.alertness = m_objective.alertness;
    m_moveToObjective.movementType = m_objective.movementType;
}

// @retail 0x8333A470
void CCSAFMoveToActor::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
        m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    }
}

// @retail 0x8332D440
void CCSAFMoveToActor::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovementGwNav>();
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    m_pMovementCS->SetObjective(m_moveToObjective);
    m_pMovementCS->Activate();
    m_targetPawn = 0;
}

// @retail 0x833231B0
bool CCSAFMoveToActor::TransitionTo(GripAFAction *)
{
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x8332D4E0
void CCSAFMoveToActor::Tick(float DeltaTime)
{
    m_updateTimer -= DeltaTime;
    AActor *pTarget = (AActor *)m_objective.pTarget;
    // the null test reads the member, so retail keeps the target in a copy
    // of its own register for the calls that follow
    if (m_objective.pTarget == 0 || m_pMovementCS->PathFailed() || !pTarget->IsValid() || pTarget->bDeleteMe)
    {
        m_status = AS_FAILURE;
        return;
    }
    if (m_targetPawn != m_objective.pTarget)
    {
        m_targetPawn = (AUDKPawn *)m_objective.pTarget;
    }
    FVector Destination;
    if (m_targetPawn != 0 && m_targetPawn->Camo == kOne)
    {
        Destination = m_targetPawn->CamoVanishingPoint;
    }
    else
    {
        Destination = pTarget->GetNavAdjustedLocation(m_objective.pointOfOrigin, 1.1f);
    }
    if (m_pMovementCS->ObjectiveReached() && m_moveToObjective.target == Destination)
    {
        m_status = AS_DONE;
        return;
    }
    if (m_moveToObjective.target != Destination && m_updateTimer < 0.0f)
    {
        m_updateTimer = kOne;
        m_moveToObjective.target = Destination;
        m_pMovementCS->SetObjective(m_moveToObjective);
        m_pMovementCS->Activate();
    }
}

// @retail 0x8332D3D0
// CCSAFMoveToActor::~CCSAFMoveToActor
// @retail 0x8332D3D8
// CCSAFMoveToActor::`scalar deleting destructor'
