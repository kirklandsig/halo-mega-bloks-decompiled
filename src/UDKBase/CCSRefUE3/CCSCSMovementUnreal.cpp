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

// score 0 (was 64): the constructor now matches the retail. The shape that
// matches is the one CCSCSMovementGwNav uses: the meat puppet is cast into a
// named CCSMeatPuppet local and read without a null test, so the compiler
// keeps the base adjustment (-4) in a register and reads both members through
// it. With the "if (m_pMeatPuppet != 0)" guard the compiler folds the
// adjustment into the displacements and drops the branch.
// @retail 0x83338540
CCSCSMovementUnreal::CCSCSMovementUnreal(CCSCSInterface *pCSInterface)
    : CCSCSMovement(pCSInterface)
    , m_pCCSCtrl(0)
    , m_pBasePawn(0)
    , m_nextMoveLocation(INVALID_LOCATION)
    , m_overridenMovementType(CCS::MovementType_MAX)
{
    CCSMeatPuppet *pMeatPuppet = static_cast<CCSMeatPuppet *>(m_pMeatPuppet);
    m_pCCSCtrl = pMeatPuppet->m_pCCSCtrl;
    m_pBasePawn = pMeatPuppet->m_pUnPawn;
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
            const Grip_Vector Position = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
            m_validFinalDestination = Position;
        }
    }
    else
    {
        const Grip_Vector Position = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
        m_validFinalDestination = Position;
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
// Also tried here: a named Grip_Rotation for the orientation (11), the
// second character named (23: the character is then read back from the
// stack instead of the returned pointer), the whole body and the yaw part
// in nested blocks (11), the difference in the Grip_Vector domain with and
// without a converted target (44, 44) and in the FVector domain (58). The
// retail's layout needs the second character's 20 byte slot to land on the
// position's 12 byte slot at 0x50, which the compiler only does when that
// slot is wide enough: the frame is the compiler's decision and the source
// cannot reach it from here.
// Also tried here: both characters named (27), the character named and the
// second one unnamed with the rotation after it (15) and the permuter over
// the whole body (11, it found nothing).
// The slot pairs are what differ, and only they: retail pairs the position
// with the second character (0x50), the difference with the character's own
// rotator (0x68) and keeps the rotation (0x78) and the first character
// (0x90) to themselves, while ours pairs the position with the rotator
// (0x50), the rotation with the first character (0x70) and gives the
// second character a slot of its own (0x90). Tried again for the pairs: the
// whole body, the yaw part and the whole function in nested blocks (11, the
// slots do not move at all), a named difference (11), a reference to the
// position (11) and a reference to the rotation (11). The sibling file's
// CCSCSMovementGwNav::OrientationReached has the retail layout and ours
// has the same wrong one, so the pairing follows the code shape and not the
// source: the code is fixed, so the layout is fixed too.
// This session: the shape that matched GetNextMoveLocation (a pointer to the
// game character of the struct the call returns, so the members are read
// through the address the call hands back) was tried here too: for both
// characters (11, the layout does not move at all), for the first one only
// (11), a reference to the game character (30), the character named (15) and
// both characters named (27). The retail keeps the first character's slot to
// itself, so that character is still alive when the rotation is made, but no
// spelling of the source keeps it alive without changing the code.
// This session (lane A): the frame was compared slot by slot. The retail
// holds the position at 0x50, the difference at 0x68, the rotation at 0x78
// and the first character at 0x90, with the second character taking over
// the position's slot at 0x50 and the orientation copy taking over the
// difference's slot at 0x68; ours holds the difference at 0x60 and the
// rotation at 0x70, with the orientation copy taking over the position's
// slot at 0x50 and the second character at 0x90. The variants that keep
// the code the same do not move a single slot: the orientation in a named
// Grip_Rotation or FRotator, the difference named, an extra named vector
// (all 11). The ones that do move the slots change the code: the position
// as an FVector (28), the difference in the FVector domain (58), the
// rotation as a Grip_Rotation (36) and the position inline (31). All
// eleven points are the frame offsets; the constants are masked.
// This session (lane A): the character copy that the previous session left
// in the tree was reverted (23, the character is then read back from the
// stack) and nothing else was found: the source decides which locals share
// a slot, and the slot order itself is the compiler's (11).
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

// score 0 (was 43): the function matches the retail. Two shapes were needed
// and each of them alone changes nothing: the location is taken by reference
// (so the Y and Z comparisons go through the address the compiler keeps in
// r29 instead of folding onto this), and the character is read through a
// pointer to the game character of the struct the call returns (so the pawn
// and the actor are read through the address the call hands back in r3, the
// form CCSCSMovement::IsVehicleAndCloseEnough gets from a direct
// expression). The pointer is to a member of the temporary, so the rvalue
// warning is off around it.
// The tail of the function (the character, the radius and the move) is in a
// block of its own: that block is a sibling of the block that logs the
// failed path, so the character shares the log string's stack slot (0x60)
// and the frame is 0xa0 bytes, as in the retail. The retail keeps the
// navigation handle in a local, so it is loaded once and stays in r30 across
// the calls.
// @retail 0x833434D0
bool CCSCSMovementUnreal::GetNextMoveLocation()
{
    const FVector &NextMoveLocation = m_nextMoveLocation;
    if (NextMoveLocation.X == INVALID_LOCATION.X &&
        NextMoveLocation.Y == INVALID_LOCATION.Y &&
        NextMoveLocation.Z == INVALID_LOCATION.Z)
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
    {
        UNavigationHandle *pNavigationHandle = m_pCCSCtrl->NavigationHandle;
#pragma warning(disable : 4238)
        const CCSGameCharacter *pGameCharacter = &m_pMeatPuppet->GetCharacter().m_gameCharacter;
#pragma warning(default : 4238)
        float Radius = 0.0f;
        if (pGameCharacter->m_pawn != 0)
        {
            Radius = pGameCharacter->m_pawn->CylinderComponent->CollisionRadius;
        }
        if (pGameCharacter->m_actor != 0)
        {
            Radius = 1.0f;
        }
        if (pNavigationHandle->GetNextMoveLocation(m_nextMoveLocation, Radius) != 0)
        {
            return true;
        }
        GLog->Logf__VA(L"Controller: Unable to follow Path");
        pNavigationHandle->SetFinalDestination(m_validFinalDestination);
        m_nextMoveLocation = m_validFinalDestination;
        return true;
    }
}

// score 10 (was 67): the code, its order and the block layout now match the
// retail; what is left is the register allocation (the retail keeps the flag
// in r28 and the invalid location in r29, ours the other way round) and the
// displacement of the 0.0f constant. The shape that matches: the condition is
// the conjunction of the three equalities (so the retail's "not the invalid
// location" arm is the fallthrough), a bool flag that holds the result of
// GetNextMoveLocation (so the two calls merge into one block), and a named
// reference for the next move location (so the loads go through r30).
// Still tried: the condition as the negated conjunction (67), the arms
// swapped with the location in a reference (67), the "||" form with the
// position computed in the second operand (75), a flag that holds the
// result of GetNextMoveLocation (125), the same flag with the arms swapped
// (130), a goto around the move code (104), the "||" form with the flag
// (27), the flag declared before the reference (10).
// Also tried here: a named reference and a pointer to the invalid location
// (10, the address of the constant stays in the same register), the flag
// and the reference declared in every order (10), the flag left out of its
// initializer (does not compile: C4701) and no reference at all (12); the
// permuter over the whole body found nothing (10).
// Only the r28/r29 swap stands between this and a match: the 0.0f constant's
// displacement is a relocated field, so it is masked in the comparison and
// costs a point in the score only. The two candidates are the flag and the
// address of the invalid location; both live across the calls, so both need
// a non-volatile register, and the retail gives r28 to the flag while ours
// gives it to the address. Tried again for the swap: a pointer for the
// location (10), a non const reference (10), a const pointer (10), the flag
// as a char (17), as an unsigned char (10) and compared with != 0 (10),
// the invalid location through a helper function (10), the assignment, the
// else branch and the move in nested blocks (10) and a second permuter run
// over the whole body (10, 2972 rewrites, nothing).
// This session: the flag assigned on both paths instead of initialised (21),
// the test written as "== false" (10), the assignment normalised to "!= 0"
// (17), a named reference and a named pointer to the invalid location
// declared first (10, the address of the constant stays in the same
// register), the flag as an unsigned char (10), the comparisons negated (10),
// the flag declared before the reference (10) and the permuter over the
// whole body again (10, 600s, nothing).
// This session (lane A): the swap was hunted with the instruction level
// diff, so a variant that only moves the allocation shows up even when the
// score does not. A named reference and a named pointer to the invalid
// location keep the code and the allocation (10), the flag as an int or an
// unsigned int (27, 25), the flag tested against true (12), the flag
// assigned from a conditional expression (17), the comparisons duplicated
// or taken through a reference (10, the duplicate is folded away), the
// copy through a temporary (10), the position inline in the call (38) and
// the position as a reference (10) all keep the address of the constant
// in the same register. Only the copy written field by field moves it:
// that puts the address in r29 and the flag in r28, as the retail has it,
// but the copy then stores the three floats instead of the three words
// (13). The one point left is the displacement of the second 0.0f, which
// the constant pool of the whole game puts out of reach of the mask.
// This session (lane A, again): the flag is now set to true after the call
// has been checked instead of holding the result of the call. That gives the
// retail's register allocation (r28 for the flag, r29 for the address of the
// invalid location) and drops the score from 10 to 5. What is left is the
// store of the call's result: the retail keeps it in the flag with "mr r28,
// r3" before the test, ours sets the flag with "li r28, 1" after the branch
// that skips the return. Writing the comparison against a literal 0.0f
// instead of the constant (51, the literal spills into f31 and the frame
// grows), the flag as a char (17), the flag holding the result again (10),
// the flag tested as "== false" (10) and an extra read of the flag (10)
// all keep the old allocation.
// @retail 0x8334B7C8
void CCSCSMovementUnreal::MoveToDestination()
{
    const FVector &NextMoveLocation = m_nextMoveLocation;
    bool bMoving = false;
    if (NextMoveLocation.X == INVALID_LOCATION.X &&
        NextMoveLocation.Y == INVALID_LOCATION.Y &&
        NextMoveLocation.Z == INVALID_LOCATION.Z)
    {
        if (!GetNextMoveLocation())
        {
            return;
        }
        bMoving = true;
    }
    else
    {
        const Grip_Vector Position = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetPosition();
        if (m_pBasePawn->ReachedDestination(Position, m_nextMoveLocation, 0, 1) != 0)
        {
            if (!GetNextMoveLocation())
            {
                return;
            }
            bMoving = true;
        }
    }
    if (bMoving)
    {
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
