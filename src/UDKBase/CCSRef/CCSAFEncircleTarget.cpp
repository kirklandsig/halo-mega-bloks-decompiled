// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// @retail 0x8332BD08
CCSAFEncircleTarget::CCSAFEncircleTarget() : m_pCCSCtrl(0), m_pMovementCS(0), m_updateTimer(0.5f) {}

// @retail 0x833399C0
void CCSAFEncircleTarget::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_pCCSCtrl = static_cast<CCSMeatPuppet *>(m_pMeatPuppet)->m_pCCSCtrl;
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
        m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    }
}

// @retail 0x83322B20
void CCSAFEncircleTarget::SetObjective(const CCSAOEncircleTarget &Objective)
{
    m_objective = Objective;
}

// @retail 0x83339AC8
void CCSAFEncircleTarget::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovement>();
    if (m_pMovementCS == 0 || m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn == 0)
    {
        m_status = AS_FAILURE;
        return;
    }
    UpdateGoal();
    m_pMovementCS->Activate();
}

// Todo: as CCSAFStrafeTarget::UpdateGoal (retail has 0x20 more bytes of
// frame and reads the rotated direction from a fixed slot).
// @retail 0x8332BE08
void CCSAFEncircleTarget::UpdateGoal()
{
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    FVector ToTarget = GripEngineServices::GetActorPosition(m_objective.pTarget) - pPawn->Location;
    ToTarget.Z = 0.0f;
    ToTarget.Normalize(SMALL_NUMBER);
    bool Allowed[4] = {false, m_objective.moveRight, false, m_objective.moveLeft};
    FVector Goal = pPawn->Location;
    float BestTime = 0.0f;
    int Best = -1;
    FVector Points[4];
    FVector Direction;
    FVector Extent(0, 0, 0);
    for (int i = 0, Angle = 0; Angle < 360; Angle += 90, i++)
    {
        Points[i] = FVector(3.402823466e+38F, 3.402823466e+38F, 3.402823466e+38F);
        if (!Allowed[i])
        {
            continue;
        }
        Direction = ToTarget.RotateAngleAxis((int)(Angle * 182.0444f), FVector(0, 0, 1));
        FVector End = pPawn->GetPawnViewLocation() + Direction * 2000.0f;
        FCheckResult Hit;
        if (GWorld->SingleLineCheck(Hit, (AActor *)m_pMeatPuppet->GetCharacter().GetActor(), End, pPawn->GetPawnViewLocation(), 0x209F, Extent, 0))
        {
            Points[i] = End;
        }
        else
        {
            Points[i] = Hit.Location;
        }
        Points[i] = Points[i] - Direction * pPawn->CollisionComponent->Bounds.SphereRadius;
        if (BestTime < Hit.Time && (i == currentCircleDirection || rand() % 2 == 0))
        {
            BestTime = Hit.Time;
            Goal = Points[i];
            Best = i;
            currentCircleDirection = i;
        }
    }
    if (Best == 1)
    {
        m_objective.moveLeft = false;
    }
    else if (Best == 3)
    {
        m_objective.moveRight = false;
    }
    m_objective.moveTarget = Goal;
    m_objective.alertness = CCS::AlertnessState_Alert;
    m_objective.movementType = CCS::MovementType_Encircle;
    m_objective.orientTarget = GripEngineServices::GetActorPosition(m_objective.pTarget);
    m_pMovementCS->SetObjective(m_objective);
}

// @retail 0x83322B30
bool CCSAFEncircleTarget::TransitionTo(GripAFAction *)
{
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x83339B78
void CCSAFEncircleTarget::Tick(float DeltaTime)
{
    if (m_pMovementCS->m_state == CCSCSMovement::MS_IDLE)
    {
        UpdateGoal();
    }
    m_updateTimer -= DeltaTime;
    if (m_updateTimer <= 0.0f)
    {
        UpdateGoal();
        m_updateTimer = 0.5f;
    }
    if (m_pCCSCtrl->FireBurstCount > 0)
    {
        m_pCCSCtrl->eventStopFireBurst();
    }
    else if (!m_pCCSCtrl->eventFireWeapon(0, 0, 0))
    {
        m_pCCSCtrl->eventActionStopFiring();
    }
    if (m_objective.pTarget != 0)
    {
        m_pCCSCtrl->SetFocalPoint(((AActor *)m_objective.pTarget)->Location, 0);
        m_pCCSCtrl->eventAimAt((AActor *)m_objective.pTarget);
    }
}

// @retail 0x8332BD98
// CCSAFEncircleTarget::~CCSAFEncircleTarget
// @retail 0x8332BDA0
// CCSAFEncircleTarget::`scalar deleting destructor'
