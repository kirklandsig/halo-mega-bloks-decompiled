// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
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

// score 251 (was 251): retail's PDB gives the frame offsets of the named
// locals - canTest 0x50, bestStrafeLocation 0x58, strafeTestEnd 0x78,
// dirToPivot 0x88, dirToTest 0xf8, traceResult 0x110, potentialStrafeLocations
// 0x190 - and every one of them but the direction to test sits where retail
// puts it. Ours allocates the direction to test at 0x88 and the direction to
// pivot at 0x98, one 12 byte slot too early, so every slot after them sits
// 0x10 higher than retail's and the frame is 0x20 smaller. The rest of the
// difference is the order the compiler issues the four canTest byte stores
// and the constant loads in; ours keeps them together, retail interleaves
// them with the address computations.
// The back-off constant is now retail's: 0.0789438 (the float at 0x82235cb4),
// not 100. That is the only change to the source this round, the score is
// unchanged because the constant is masked.
// Tried this round: all sixteen scope combinations of the four loop locals
// (best 291, none reproduces retail's slot order), the direction to test
// declared apart from its assignment (307), const-qualified locals (251),
// a named axis vector (251/260), the loop body declarations in every order
// (251, the layout does not move), the loop body in an extra block (251),
// canTest at function scope (277). The permuter found no rewrite (251).
// @retail 0x8332DAD0
bool CCSAFStrafeTarget::UpdateGoal()
{
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    if (pPawn == 0 || m_objective.pTarget == 0)
    {
        return false;
    }
    FVector dirToPivot = GripEngineServices::GetActorPosition(m_objective.pTarget) - pPawn->Location;
    dirToPivot.Z = 0.0f;
    dirToPivot.Normalize(SMALL_NUMBER);
    FVector bestStrafeLocation = pPawn->Location;
    float BestTime = 0.0f;
    FVector potentialStrafeLocations[4];
    for (int i = 0, Angle = 0; Angle < 360; Angle += 90, i++)
    {
        bool canTest[4] = {m_objective.moveForward, m_objective.moveRight, m_objective.moveBack, m_objective.moveLeft};
        potentialStrafeLocations[i] = FVector(3.402823466e+38F, 3.402823466e+38F, 3.402823466e+38F);
        if (!canTest[i])
        {
            continue;
        }
        FVector dirToTest = dirToPivot.RotateAngleAxis((int)(Angle * 182.0444f), FVector(0, 0, 1));
        FVector strafeTestEnd = pPawn->Location + dirToTest * 2000.0f;
        FCheckResult traceResult;
        if (GWorld->SingleLineCheck(traceResult, (AActor *)m_pMeatPuppet->GetCharacter().GetActor(), strafeTestEnd, pPawn->Location, 0x209F, FVector(0, 0, 0), 0))
        {
            potentialStrafeLocations[i] = strafeTestEnd;
        }
        else
        {
            potentialStrafeLocations[i] = traceResult.Location;
        }
        potentialStrafeLocations[i] = potentialStrafeLocations[i] - dirToTest * 0.0789438f;
        if (BestTime < traceResult.Time || (BestTime <= traceResult.Time && rand() % 2 == 0))
        {
            bestStrafeLocation = potentialStrafeLocations[i];
            BestTime = traceResult.Time;
        }
    }
    float Radius = pPawn->CollisionComponent->Bounds.SphereRadius * 2.0f;
    if ((pPawn->Location - bestStrafeLocation).SizeSquared() < Radius * Radius)
    {
        return false;
    }
    m_objective.alertness = CCS::AlertnessState_Alert;
    m_objective.movementType = CCS::MovementType_Strafe;
    m_objective.moveTarget = Grip_Vector(bestStrafeLocation.X, bestStrafeLocation.Y, bestStrafeLocation.Z - pPawn->CollisionComponent->Bounds.SphereRadius * 0.5f);
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
