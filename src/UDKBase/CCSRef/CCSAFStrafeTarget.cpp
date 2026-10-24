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

// score 251 (was 273): retail's PDB names the locals dirToPivot, canTest,
// bestStrafeLocation, potentialStrafeLocations, dirToTest, strafeTestEnd and
// traceResult, so the source uses those names; declaring the canTest flags
// inside the loop lets the compiler hoist their initialisation into the loop
// preheader, after the Normalize call, where retail has them (273 -> 251).
// Still 0x20 bytes of frame short: retail's slot order is canTest, best
// strafe location, strafe test end, direction to pivot, ... direction to
// test, while ours puts the direction to test first (the hidden return slot
// of RotateAngleAxis) and the direction to pivot after it. The permuter
// found no further rewrite (2658 iterations, no improvement).
// Tried this round: canTest at function scope in every position (277, all
// orders), canTest split into four assignments (251), a named axis local
// (251), function-scope dirToTest (307), component-wise copy of the rotation
// result (322/326). Retail initialises canTest in the loop preheader, ours
// keeps it in the loop body, which is what the score is mostly made of.
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
        potentialStrafeLocations[i] = potentialStrafeLocations[i] - dirToTest * 100.0f;
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
