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

// score 11 (was 20): the code now matches, only the frame slots are left.
// The retail keeps the character's result at 0x90, the position at 0x50, the
// difference at 0x68, the rotation at 0x78 and the second character's result
// at 0x50 (the position's slot, free by then), while ours puts the first
// character at 0x70, the difference at 0x60, the rotation at 0x70 and the
// second character at 0x90. The shape that matches the code is to take the
// position from the character the first GetCharacter() returns (so the
// address comes back in r3) and to read the rotation after the second
// character call. Still tried for the slots: a named character (the address
// comes back as addi instead of mr), a reference to the character, a named
// difference, a named position, a named orientation, the locals declared
// first and the rotation as a Grip_Rotation (22). The other lane also tried
// the character by pointer (15), the position or the target as an FVector
// (30, 22), the difference in the FVector domain (22) or the other way round
// (12), the rotation unnamed (21), the yaw read before the position (123) and
// the position kept alive by a use of its own (11): the slot order is the
// compiler's, and the source only decides which slots the values share.
// @retail 0x8332AFE8
bool CCSCSMovementUnreal::OrientationReached() const
{
    const Grip_Vector Position = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
    const FRotator TargetRotation = (m_orientObj.target - Position).Rotation();
    const int Yaw = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetOrientation().Yaw;
    const int Delta = Abs((TargetRotation.Yaw & 0xFFFF) - (Yaw & 0xFFFF));
    return Delta < s_orientationTolerance || Delta > 0xFFFF - s_orientationTolerance;
}

// The log the retail writes when the path search fails.
extern FOutputDeviceRedirectorBase *GLog;

// score 43 (was 258, the function was not written): the code and its order
// now match the retail; what is left is the register allocation and the
// stack slots. The retail keeps the address of the next move location in
// r29 and reads its Y and Z through that register, ours reads them through
// r3; the retail's frame is 0xa0 bytes and reuses the slot of the log
// string for the character, ours is 0xb0 and puts the character above it.
// Still tried: a reference for the next move location (59), the character
// read before the path request (78), the actor's radius tested before the
// pawn's (63), the two radius tests as an if/else (46), the log argument
// without a copy of the destination (71), the log argument as a temporary
// (43), the path request spelled as "!" (43), the two "!= 0" tests
// without the comparison (43), the character and the copy not const (43).
// @retail 0x833434D0
bool CCSCSMovementUnreal::GetNextMoveLocation()
{
    if (m_nextMoveLocation.X == INVALID_LOCATION.X &&
        m_nextMoveLocation.Y == INVALID_LOCATION.Y &&
        m_nextMoveLocation.Z == INVALID_LOCATION.Z)
    {
        if (m_pCCSCtrl->eventFindNavMeshPath(m_validFinalDestination) == 0)
        {
            const FVector Location = m_validFinalDestination;
            GLog->Logf__VA(L"FindNavMeshPath failed to find a path to %s", *Location.ToString());
            if (m_pCCSCtrl->NavigationHandle->IsAnchorInescapable() != 0)
            {
                GLog->Logf__VA(L"   FindNavMeshPath failed due to inescapable anchor.");
            }
            m_pCCSCtrl->NavigationHandle->SetFinalDestination(m_validFinalDestination);
            m_nextMoveLocation = m_validFinalDestination;
            return true;
        }
    }
    const CCSCharacter Character = m_pMeatPuppet->GetCharacter();
    float Radius = 0.0f;
    if (Character.m_gameCharacter.m_pawn != 0)
    {
        Radius = Character.m_gameCharacter.m_pawn->CylinderComponent->CollisionRadius;
    }
    if (Character.m_gameCharacter.m_actor != 0)
    {
        Radius = 1.0f;
    }
    if (m_pCCSCtrl->NavigationHandle->GetNextMoveLocation(m_nextMoveLocation, Radius) != 0)
    {
        return true;
    }
    GLog->Logf__VA(L"Controller: Unable to follow Path");
    m_pCCSCtrl->NavigationHandle->SetFinalDestination(m_validFinalDestination);
    m_nextMoveLocation = m_validFinalDestination;
    return true;
}

// score 67 (was 312, the function was not written): the code and its order
// match the retail; what is left is the block layout and the register
// allocation. The retail puts the "not the invalid location" arm inline and
// the "the invalid location" arm out of line, and it keeps the result of
// GetNextMoveLocation in a register across the two arms; ours does the
// opposite. The retail passes the pawn's bIsWalking to MoveTo and stores the
// negated result of moveToward in bAdjusting.
// Still tried: the condition as the negated conjunction (67), the arms
// swapped with the location in a reference (67), the "||" form with the
// position computed in the second operand (75), a flag that holds the
// result of GetNextMoveLocation (125), the same flag with the arms swapped
// (130), a goto around the move code (104).
// @retail 0x8334B7C8
void CCSCSMovementUnreal::MoveToDestination()
{
    const FVector &NextMoveLocation = m_nextMoveLocation;
    if (NextMoveLocation.X != INVALID_LOCATION.X ||
        NextMoveLocation.Y != INVALID_LOCATION.Y ||
        NextMoveLocation.Z != INVALID_LOCATION.Z)
    {
        const Grip_Vector Position = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
        if (m_pBasePawn->ReachedDestination(Position, m_nextMoveLocation, 0, 1) != 0)
        {
            if (!GetNextMoveLocation())
            {
                return;
            }
            m_pCCSCtrl->MoveTo(m_nextMoveLocation, 0, 0.0f, m_pBasePawn->bIsWalking);
            m_pCCSCtrl->StateFrame->LatentAction = 0;
        }
        else
        {
            if (m_pCCSCtrl->MoveTimer < 0.0f && m_pBasePawn->Physics != PHYS_Falling)
            {
                m_nextMoveLocation = INVALID_LOCATION;
                return;
            }
            if (m_pCCSCtrl->bAdjusting)
            {
                m_pCCSCtrl->bAdjusting = !m_pBasePawn->moveToward(m_pCCSCtrl->GetAdjustLocation(), 0);
            }
            if (!m_pCCSCtrl->bAdjusting)
            {
                m_pCCSCtrl->PrePollMove();
                if (m_pBasePawn->moveToward(m_pCCSCtrl->GetDestinationPosition(), 0) == 0)
                {
                    m_pCCSCtrl->PostPollMove();
                }
            }
        }
    }
    else
    {
        if (!GetNextMoveLocation())
        {
            return;
        }
        m_pCCSCtrl->MoveTo(m_nextMoveLocation, 0, 0.0f, m_pBasePawn->bIsWalking);
        m_pCCSCtrl->StateFrame->LatentAction = 0;
    }
    if (!m_pMeatPuppet->IsMoving())
    {
        OverrideMovementType(CCS::MovementType_Idle);
        return;
    }
    if (m_overridenMovementType < CCS::MovementType_MAX)
    {
        RestoreMovementType();
    }
}

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
