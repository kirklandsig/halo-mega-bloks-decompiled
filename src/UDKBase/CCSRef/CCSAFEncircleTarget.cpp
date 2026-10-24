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
// score 30 (was 115): copying the rotation result through a temporary
// FVector makes MSVC pick retail's fmuls operand order in the radius
// subtraction; what is left is three fmr's (the result is loaded into
// volatile f0/f13/f12 and copied into f29/f28/f27, retail loads it
// straight into those) and the register order of the objective copy at
// the end.  The permuter (1241 rewrites) and the loop-local/assignment
// forms of the rotation all score worse: they lose the frame layout.
// Also tried this round: the rotation result declared in the loop as
// dirToTest (143, the hidden return slot moves to 0x98 and the frame
// shrinks to 0x2b0), assigned to the function-scope dirToTest (92, the
// call needs a separate temp plus a memory copy) and feeding the post
// call radius multiply from the rotation result instead of the copy
// (143) - retail loads 0xf8 straight into f29/f28/f27, so the value must
// stay one node across the call, which none of these forms gives us.
// @retail 0x8332BE08
void CCSAFEncircleTarget::UpdateGoal()
{
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    FVector dirToPivot = GripEngineServices::GetActorPosition(m_objective.pTarget) - pPawn->Location;
    dirToPivot.Z = 0.0f;
    dirToPivot.Normalize(SMALL_NUMBER);
    FVector potentialStrafeLocations[4];
    FVector bestStrafeLocation = pPawn->Location;
    float BestTime = 0.0f;
    int Best = -1;
    FVector dirToTest;
    bool canTest[4] = {false, m_objective.moveRight, false, m_objective.moveLeft};
    for (int i = 0, Angle = 0; Angle < 360; Angle += 90, i++)
    {
        potentialStrafeLocations[i] = FVector(3.402823466e+38F, 3.402823466e+38F, 3.402823466e+38F);
        if (!canTest[i])
        {
            continue;
        }
        FVector rotTemp = dirToPivot.RotateAngleAxis((int)(Angle * 182.0444f), FVector(0, 0, 1));
        dirToTest = FVector(rotTemp.X, rotTemp.Y, rotTemp.Z);

        FVector strafeTestEnd = pPawn->GetPawnViewLocation() + dirToTest * 2000.0f;
        FCheckResult traceResult;
        if (GWorld->SingleLineCheck(traceResult, (AActor *)m_pMeatPuppet->GetCharacter().GetActor(), strafeTestEnd, pPawn->GetPawnViewLocation(), 0x209F, FVector(0, 0, 0), 0))
        {
            potentialStrafeLocations[i] = strafeTestEnd;
        }
        else
        {
            potentialStrafeLocations[i] = traceResult.Location;
        }
        potentialStrafeLocations[i] = potentialStrafeLocations[i] - dirToTest * pPawn->CollisionComponent->Bounds.SphereRadius;
        if (BestTime < traceResult.Time && (i == currentCircleDirection || rand() % 2 == 0))
        {
            BestTime = traceResult.Time;
            bestStrafeLocation = potentialStrafeLocations[i];
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
    m_objective.moveTarget = bestStrafeLocation;
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
