// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSCSMovement.cpp"
#include "CCSAFModifiers.cpp"

// @retail 0x8332D8A8
CCSAFStrafeTarget::CCSAFStrafeTarget() : m_pCCSCtrl(0), m_pMovementCS(0), m_updateTimer(1.0f) {}

// @retail 0x8333A610
void CCSAFStrafeTarget::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_pCCSCtrl = static_cast<CCSMeatPuppet *>(m_pMeatPuppet)->m_pCCSCtrl;
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, m_objective.alertness));
        m_modifiers.AddItem(new CCSAFMovementTypeModifier(m_pMeatPuppet, m_objective.movementType));
    }
}

// @retail 0x833232A8
void CCSAFStrafeTarget::SetObjective(const CCSAOStrafeTarget &Objective)
{
    m_objective = Objective;
}

// @retail 0x8333A718
void CCSAFStrafeTarget::OnActivate()
{
    m_pMovementCS = m_pAFInterface->GetSystem<CCSCSMovement>();
    if (m_pMovementCS == 0 || m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn == 0 || !UpdateGoal())
    {
        m_status = AS_FAILURE;
        return;
    }
    m_pMovementCS->Activate();
}

// Todo: the code is retail's but retail has 0x20 more bytes of frame and
// reads the rotated direction from a fixed slot (another temporary somewhere;
// tried the direction as an FVector, a named axis and a named offset).
// @retail 0x8332DAD0
bool CCSAFStrafeTarget::UpdateGoal()
{
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    if (pPawn == 0 || m_objective.pTarget == 0)
    {
        return false;
    }
    FVector ToTarget = GripEngineServices::GetActorPosition(m_objective.pTarget) - pPawn->Location;
    ToTarget.Z = 0.0f;
    ToTarget.Normalize(SMALL_NUMBER);
    bool Allowed[4] = {m_objective.moveForward, m_objective.moveRight, m_objective.moveBack, m_objective.moveLeft};
    FVector Goal = pPawn->Location;
    float BestTime = 0.0f;
    FVector Points[4];
    for (int i = 0, Angle = 0; Angle < 360; Angle += 90, i++)
    {
        Points[i] = FVector(3.402823466e+38F, 3.402823466e+38F, 3.402823466e+38F);
        if (!Allowed[i])
        {
            continue;
        }
        const Grip_Vector Direction = ToTarget.RotateAngleAxis((int)(Angle * 182.0444f), FVector(0, 0, 1));
        FVector End = pPawn->Location + Direction * 2000.0f;
        FCheckResult Hit;
        if (GWorld->SingleLineCheck(Hit, (AActor *)m_pMeatPuppet->GetCharacter().GetActor(), End, pPawn->Location, 0x209F, FVector(0, 0, 0), 0))
        {
            Points[i] = End;
        }
        else
        {
            Points[i] = Hit.Location;
        }
        Points[i] = Points[i] - Direction * 100.0f;
        if (BestTime < Hit.Time || (BestTime == Hit.Time && rand() % 2 == 0))
        {
            Goal = Points[i];
            BestTime = Hit.Time;
        }
    }
    float Radius = pPawn->CollisionComponent->Bounds.SphereRadius * 2.0f;
    if ((pPawn->Location - Goal).SizeSquared() < Radius * Radius)
    {
        return false;
    }
    m_objective.moveTarget = Grip_Vector(Goal.X, Goal.Y, Goal.Z - pPawn->CollisionComponent->Bounds.SphereRadius * 0.5f);
    m_objective.alertness = CCS::AlertnessState_Alert;
    m_objective.movementType = CCS::MovementType_Strafe;
    m_objective.orientTarget = GripEngineServices::GetActorPosition(m_objective.pTarget);
    m_pMovementCS->SetObjective(m_objective);
    return true;
}

// @retail 0x833232B8
bool CCSAFStrafeTarget::TransitionTo(GripAFAction *)
{
    if (m_pMovementCS == 0)
    {
        m_status = AS_FAILURE;
        return true;
    }
    m_pMovementCS->Deactivate();
    return true;
}

// @retail 0x8332D9A8
void CCSAFStrafeTarget::Tick(float)
{
    if (m_pMovementCS->m_state == CCSCSMovement::MS_IDLE)
    {
        m_status = AS_DONE;
    }
    if (m_pMovementCS->PathFailed())
    {
        m_status = AS_FAILURE;
    }
    if (m_pCCSCtrl->FireBurstCount > 0)
    {
        m_pCCSCtrl->eventStopFireBurst();
    }
    else if (!m_pCCSCtrl->eventFireWeapon(rand() * (1.0f / 32767) < m_objective.chargeChance, 1, m_objective.alwaysFire))
    {
        m_pCCSCtrl->eventActionStopFiring();
    }
}

// @retail 0x8332D938
// CCSAFStrafeTarget::~CCSAFStrafeTarget
// @retail 0x8332D940
// CCSAFStrafeTarget::`scalar deleting destructor'
