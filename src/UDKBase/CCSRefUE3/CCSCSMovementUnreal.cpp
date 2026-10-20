// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscsmovementunreal.cpp: the movement system that drives a UE3 pawn.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// The invalid movement location: a big negative Z, so a path request to it
// always fails.
const FVector CCSCSMovementUnreal::INVALID_LOCATION = FVector(0.0f, 0.0f, -1.7014118346046923e+38F);

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

// Todo(0x8332ADD0): CCSCSMovementUnreal::DoMove walks the pawn to the next
// move location; the retail's path queries and its pawn movement calls are
// not reconstructed yet.
//
// Todo(0x8332AFE8): CCSCSMovementUnreal::OrientationReached compares the
// character's facing with the movement's target direction; the retail rotates
// the difference with Grip_Vector::Rotation and reads the character's
// rotation, which is not reconstructed yet.
//
// Todo(0x83338628): CCSCSMovementUnreal::CreateRenderingProxy makes the
// pawn's debug proxy; the retail's proxy factory call is not reconstructed
// yet.
//
// Todo(0x833434D0): CCSCSMovementUnreal::GetNextMoveLocation picks the next
// point of the movement; the retail's path and projection calls are not
// reconstructed yet.
//
// Todo(0x8334B7C8): CCSCSMovementUnreal::MoveToDestination sends the pawn to
// the final destination; the retail's scheduler calls and its handling of an
// unreachable destination are not reconstructed yet.
