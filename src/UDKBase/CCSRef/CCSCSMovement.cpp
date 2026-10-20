// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscsmovement.cpp: the movement control system. Other files of the unity
// include this one for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSControlSystem.cpp"
#include "CCSCSInterface.cpp"

// @retail 0x833241B0
void CCSCSMovement::SetObjective(const CCSAOMoveTo &Objective)
{
    m_state = MS_MOVE;
    m_moveObj = Objective;
}

// @retail 0x833241D8
void CCSCSMovement::SetObjective(const CCSAOOrientToward &Objective)
{
    m_state = MS_ORIENT;
    m_orientObj = Objective;
}

// @retail 0x83324200
void CCSCSMovement::SetObjective(const CCSAOStrafeTarget &Objective)
{
    m_state = MS_STRAFE;
    m_moveObj.target = Objective.moveTarget;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
    m_orientObj.target = Objective.orientTarget;
    m_orientObj.alertness = Objective.alertness;
    m_orientObj.alwaysFire = Objective.alwaysFire;
}

// @retail 0x83324260
void CCSCSMovement::SetObjective(const CCSAOStrafeTo &Objective)
{
    m_state = MS_STRAFE;
    m_moveObj.target = Objective.target;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
}

// @retail 0x83324298
void CCSCSMovement::SetObjective(const CCSAOEncircleTarget &Objective)
{
    m_state = MS_STRAFE;
    m_moveObj.target = Objective.moveTarget;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
    m_orientObj.target = Objective.orientTarget;
    m_orientObj.alertness = Objective.alertness;
    m_orientObj.alwaysFire = Objective.alwaysFire;
}

// @retail 0x833242F8
void CCSCSMovement::SetObjective(const CCSAOFlee &Objective)
{
    m_state = MS_MOVE;
    m_moveObj.target = Objective.moveTarget;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
}

// @retail 0x83324330
bool CCSCSMovement::ObjectiveReached() const
{
    return m_state == MS_IDLE;
}

// @retail 0x83324348
bool CCSCSMovement::PathFailed() const
{
    return false;
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332F680
CCSCSMovement::CCSCSMovement(CCSCSInterface *pCSInterface) : CCSControlSystem(pCSInterface), m_state(MS_IDLE)
{
}
#endif

// @retail 0x83344458
void CCSCSMovement::Initialize(const GripSystemConfig *)
{
    m_pCSInterface->AddDebugRenderer(this);
}

// @retail 0x8334C360
void CCSCSMovement::Finalize()
{
    m_pCSInterface->RemoveDebugRenderer(this);
}

// @retail 0x83324188
void CCSCSMovement::Activate()
{
    m_activationState = AS_ACTIVE;
}

// @retail 0x83324198
void CCSCSMovement::Deactivate()
{
    if (m_activationState == AS_ACTIVE)
    {
        m_state = MS_IDLE;
    }
}

// @retail 0x8332F8C8
void CCSCSMovement::Tick(float)
{
    switch (m_state)
    {
    case MS_MOVE:
        DoStop();
        if (!DoMove())
        {
            break;
        }
        m_state = MS_MOVING;
        // fall through
    case MS_MOVING:
        if (!DoMoving() && !IsVehicleAndCloseEnough())
        {
            return;
        }
        break;
    case MS_ORIENT:
        DoStop();
        if (!DoOrient())
        {
            break;
        }
        m_state = MS_ORIENTING;
        // fall through
    case MS_ORIENTING:
        if (!DoOrienting())
        {
            return;
        }
        break;
    case MS_IDLE:
        DoStop();
        m_activationState = AS_INACTIVE;
        return;
    case MS_STRAFE:
        DoStop();
        if (!DoStrafe())
        {
            break;
        }
        m_state = MS_STRAFING;
        // fall through
    case MS_STRAFING:
        if (!DoStrafing())
        {
            return;
        }
        break;
    default:
        return;
    }
    m_state = MS_IDLE;
}

// near: retail loads the move target before the pawn's location
// @retail 0x8332F7A8
bool CCSCSMovement::IsVehicleAndCloseEnough()
{
    if (m_pMeatPuppet == 0 || m_pMeatPuppet->GetCharacter() == CCSCharacter::NONE)
    {
        return false;
    }
    APawn *pPawn = m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    if (!pPawn->IsA(AUDKVehicle::StaticClass()))
    {
        return false;
    }
    AUDKVehicle *pVehicle = Cast<AUDKVehicle>(pPawn);
    const float DeltaX = pPawn->Location.X - m_moveObj.target.X;
    const float DeltaY = pPawn->Location.Y - m_moveObj.target.Y;
    if (appSqrt(DeltaX * DeltaX + DeltaY * DeltaY) < pVehicle->MoveToRadius)
    {
        return true;
    }
    return false;
}

// todo: 8 bytes short; retail's inlined system lookup keeps a separate
// null result for each failed test (a written-out lookup tried)
// @retail 0x8333BE98
bool CCSCSMovement::IsProxyVisible()
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    return m_activationState == AS_ACTIVE && pOptions != 0 && pOptions->IsOptionEnabled(CCSDebugOptions::MOVEMENT);
}

// ccscsmovement.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitMovementSGetId)() = &CCSCSMovement::SGetId;
extern int (CCSCSMovement::*const EmitMovementGetId)() const = &CCSCSMovement::GetId;
extern void (CCSCSMovement::*const EmitMovementSetIsPanicking)(bool) = &CCSCSMovement::SetIsPanicking;
#pragma inline_depth()

// @retail 0x833203D0
// CCSCSMovement::SGetId (in the header)
// @retail 0x83320B48
// CCSCSMovement::GetId (in the header)
// @retail 0x833203D8
// CCSCSMovement::SetIsPanicking (in the header)
