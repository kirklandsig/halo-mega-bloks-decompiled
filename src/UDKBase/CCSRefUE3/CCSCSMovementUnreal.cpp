// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscsmovementunreal.cpp: the movement system that drives a UE3 pawn.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSGameCharacter.cpp"

// The invalid movement location: a big negative Z, so a path request to it
// always fails.
const FVector CCSCSMovementUnreal::INVALID_LOCATION = FVector(0.0f, 0.0f, -1.7014118346046923e+38F);

// How close (in rotator units) the pawn's yaw must be to the objective's.
// The retail keeps its own copy of the value in the data section, where it
// reads as a number larger than a full turn.
static int s_orientationTolerance = 2000;

// Near: retail keeps the meat puppet's base pointer (the -4) and loads the
// invalid location through it; ours folds the offset into the accesses and
// loads the meat puppet after the invalid location instead of before it.
// @retail 0x83338540
CCSCSMovementUnreal::CCSCSMovementUnreal(CCSCSInterface *pCSInterface)
    : CCSCSMovement(pCSInterface)
    , m_pCCSCtrl(0)
    , m_pBasePawn(0)
    , m_nextMoveLocation(INVALID_LOCATION)
    , m_overridenMovementType(CCS::MovementType_MAX)
{
    if (m_pMeatPuppet != 0)
    {
        ICCSMeatPuppet *pPuppet = m_pMeatPuppet;
        m_pCCSCtrl = static_cast<CCSMeatPuppet *>(pPuppet)->m_pCCSCtrl;
        m_pBasePawn = static_cast<CCSMeatPuppet *>(pPuppet)->m_pUnPawn;
    }
}

// @retail 0x83320D78
CCSCSMovementUnreal::~CCSCSMovementUnreal()
{
}

// @retail 0x83320DB0
bool CCSCSMovementUnreal::DoOrient()
{
    m_pCCSCtrl->Focus = 0;
    m_pCCSCtrl->SetFocalPoint(m_orientObj.target, 0);
    return true;
}

// @retail 0x83320E10
void CCSCSMovementUnreal::DoStop()
{
    if (m_pMeatPuppet != 0)
    {
        m_pMeatPuppet->SetMovementSpeedDefault();
    }
    m_pMeatPuppet->Stop();
    m_pCCSCtrl->SetFocalPoint(FVector(0.0f, 0.0f, 0.0f), 0);
}

// @retail 0x83320E98
void CCSCSMovementUnreal::OverrideMovementType(CCS::EMovementType MovementType)
{
    if (m_overridenMovementType < CCS::MovementType_MAX)
    {
        return;
    }
    m_overridenMovementType = m_pMeatPuppet->GetMovementType();
    m_pMeatPuppet->SetMovementType(MovementType);
}

// @retail 0x83320F08
void CCSCSMovementUnreal::RestoreMovementType()
{
    m_pMeatPuppet->SetMovementType(m_overridenMovementType);
    m_overridenMovementType = CCS::MovementType_MAX;
}

// @retail 0x83320F50
bool CCSCSMovementUnreal::FindNavMeshPath(Grip_Vector Target) const
{
    if (m_pCCSCtrl->SecondaryNavigationHandle == 0)
    {
        return false;
    }
    return m_pCCSCtrl->eventFindNavMeshPath(Target) != 0;
}

// @retail 0x83320FC8
bool CCSCSMovementUnreal::FindNavMeshDistance(Grip_Vector Target, float &Distance, float) const
{
    if (m_pCCSCtrl->SecondaryNavigationHandle == 0)
    {
        return false;
    }
    return m_pCCSCtrl->eventFindNavMeshDistance(Target, Distance) != 0;
}

// @retail 0x833385E8
bool CCSCSMovementUnreal::DoOrienting()
{
    bool bReached = false;
    if (OrientationReached())
    {
        bReached = true;
    }
    return bReached;
}

// @retail 0x83354E00
// Near: retail sets the pawn's argument up after the two "li"s; ours sets it
// up first.
bool CCSCSMovementUnreal::DoMoving()
{
    bool bReached = false;
    Grip_Vector Position = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
    if (m_pBasePawn->ReachedDestination(Position, m_validFinalDestination, 0, 0) != 0)
    {
        bReached = true;
    }
    else
    {
        MoveToDestination();
    }
    return bReached;
}

// @retail 0x8332ADD0
bool CCSCSMovementUnreal::DoMove()
{
    m_nextMoveLocation = INVALID_LOCATION;
    m_validFinalDestination = m_moveObj.target;
    if (m_moveObj.target != INVALID_LOCATION)
    {
        m_validFinalDestination = m_moveObj.target;
        if (m_pCCSCtrl->NavigationHandle->ComputeValidFinalDestination(m_validFinalDestination) == 0)
        {
            m_validFinalDestination = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
        }
    }
    else
    {
        m_validFinalDestination = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
    }
    if (m_overridenMovementType < CCS::MovementType_MAX)
    {
        m_overridenMovementType = m_moveObj.movementType;
    }
    if (m_moveObj.movementType == CCS::MovementType_Walk)
    {
        m_pMeatPuppet->SetSpeed(CCS::MovementSpeed_Walk);
    }
    else if (m_moveObj.movementType == CCS::MovementType_Run)
    {
        m_pMeatPuppet->SetSpeed(CCS::MovementSpeed_Run);
    }
    return true;
}

// score 20 (was 30): the retail keeps four stack slots (the character's
// result at 0x90, the position at 0x78, the difference at 0x68 and the
// orientation at 0x50 in a 0xc0 frame) where ours puts the difference at
// 0x60 and the rotation at 0x70, and it copies the rotation's pointer
// into r9 before the second character call where ours reads it from r3.
// @retail 0x8332AFE8
bool CCSCSMovementUnreal::OrientationReached() const
{
    const CCSCharacter Character = m_pMeatPuppet->GetCharacter();
    const Grip_Vector Position = Character.m_gameCharacter.GetPosition();
    const int TargetYaw = (m_orientObj.target - Position).Rotation().Yaw;
    const int Yaw = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetOrientation().Yaw;
    const int Delta = Abs((TargetYaw & 0xFFFF) - (Yaw & 0xFFFF));
    return Delta < s_orientationTolerance || Delta > 0xFFFF - s_orientationTolerance;
}

// Todo(0x833434D0): CCSCSMovementUnreal::GetNextMoveLocation picks the next
// point of the movement; the retail's path and projection calls are not
// reconstructed yet.
//
// Todo(0x8334B7C8): CCSCSMovementUnreal::MoveToDestination sends the pawn to
// the final destination; the retail's scheduler calls and its handling of an
// unreachable destination are not reconstructed yet.

// The debug proxy: where the controller is heading, the final destination,
// the next move location and the objective's target.
// @retail 0x83338628
IGripSRProxy *CCSCSMovementUnreal::CreateRenderingProxy()
{
    CCSMovementRenderingProxy *pProxy = new CCSMovementRenderingProxy;
    pProxy->m_finalDest = m_validFinalDestination;
    pProxy->m_currDest = m_pCCSCtrl->bAdjusting ? m_pCCSCtrl->GetAdjustLocation() : m_pCCSCtrl->GetDestinationPosition();
    pProxy->m_nextMoveLocation = m_nextMoveLocation;
    pProxy->m_objectiveTarget = m_moveObj.target;
    return pProxy;
}
