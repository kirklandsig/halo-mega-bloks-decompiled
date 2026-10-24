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

// score 130 (was 178): the loop is a do/while with the counter bumped before
// the time test, and the declarations and the tail stores have to sit in the
// order MSVC schedules them in - the yaw assignment after BestTime = 0.0f
// (130), the objective's movementType, moveTarget and alertness in that order
// (161), the FCheckResult after the rotator candidates (134) and the rotator
// candidates built from separate assignments (233).  The permuter (600s, 4
// jobs) found the same 130, and a second run (1200s, 4 jobs, seed 7) did not
// beat it either.
// What is left is the order in which MSVC schedules the setup and the trace.
// Retail stores the new yaw with stfiwx and reloads it from the member, ours
// materialises the int in a GPR first, and retail computes the trace vectors
// in Y,Z,X order where ours does X,Z,Y.  Tried, all 130 or worse: the yaw as
// a named int, an explicit (double) cast, End = Offset + Start, End = Start +
// Direction * 1000.0f, the vector written out component by component, the
// candidates built from m_initialRotation, the Direction declared outside the
// loop, and the members of the initial rotation copied one by one.
// More of the same: for/while loop headers instead of the do/while, the
// candidates assigned slot by slot, the candidates read from
// m_initialRotation, a local FRotator copied after the yaw flip, a
// reference to m_fleeRotation, the pawn location through a reference, the
// target built with the Grip_Vector constructors, and the FCheckResult
// without SourceComponent(0) in the shared inline constructor (179, so the
// header is left alone - retail does store 0 at 0xe4).
// The retail PDB puts the whole setup on one source line (86) and the loop
// header on 88, so the source is a for loop whose increment is
// Index = (Index + 1) % 3 while i is bumped inside the body (line 105);
// the do/while above compiles to the same code.  Swapping the two +-45
// candidates scores 127 but then index 0 holds the +45 rotation where
// retail stores the -45 one at 0x104, so it is not retail's behaviour and
// is not kept.
// @retail 0x8332C770
void CCSAFFlee::UpdateMoveTarget()
{
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    m_fleeRotation = m_initialRotation;
    float BestTime;
    BestTime = 0.0f;
    m_fleeRotation.Yaw = (int)(m_fleeRotation.Yaw + 180 * 182.0444);
    FRotator Rotations[3] = {
        FRotator(m_fleeRotation.Pitch, (int)(m_fleeRotation.Yaw - 45 * 182.0444), m_fleeRotation.Roll),
        m_fleeRotation,
        FRotator(m_fleeRotation.Pitch, (int)(m_fleeRotation.Yaw + 45 * 182.0444), m_fleeRotation.Roll),
    };
    FCheckResult Hit;
    int i = 0;
    Grip_Vector Target;
    int Index;
    const int Random = rand();
    Index = Random % 3;
    {
        do
        {
            FVector Direction;
            FRotator &Rotation = Rotations[Index];
            Direction = Rotation.Vector();
            FVector Start = pPawn->Location;
            FVector End;
            End = Start + Direction * 1000.0f;
            FVector Extent = FVector(0, 0, 0);
            if (GWorld->SingleLineCheck(Hit, (AActor *)m_pMeatPuppet->GetCharacter().GetActor(), End, Start, 0x209F, Extent, 0))
            {
                m_fleeRotation = Rotation;
                Target = End;
                break;
            }
            i++;
            if (BestTime < Hit.Time)
            {
                BestTime = Hit.Time;
                Target = Hit.Location;
            }
            Index = (Index + 1) % 3;
        } while (i < 3);
    }
    m_objective.movementType = CCS::MovementType_Run;
    m_objective.moveTarget = Target;
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
