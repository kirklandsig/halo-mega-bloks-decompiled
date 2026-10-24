// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscsmovementgwnav.cpp: the movement control system's Gameware Navigation
// side: it moves the pawn's navigation bot and asks the nav mesh for paths.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSGameCharacter.cpp"

// How close (in rotator units) the pawn's yaw must be to the objective's
static int s_orientationTolerance = 2000;

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833381F8
CCSCSMovementGwNav::CCSCSMovementGwNav(CCSCSInterface *pInterface) : CCSCSMovement(pInterface), m_firstMoveTick(false)
{
    m_workingMemory = new Kaim::WorkingMemory(0x400000, 0x1400);
    CCSMeatPuppet *pMeatPuppet = static_cast<CCSMeatPuppet *>(m_pMeatPuppet);
    m_pCCSCtrl = pMeatPuppet->m_pCCSCtrl;
    m_pBasePawn = pMeatPuppet->m_pUnPawn;
    m_pGwNavBotHandle = 0;
    for (int i = 0; i < m_pBasePawn->Components.Num(); i++)
    {
        UActorComponent *Component = m_pBasePawn->Components(i);
        if (Component && Component->IsA(UGwNavBotHandle::StaticClass()))
        {
            m_pGwNavBotHandle = (UGwNavBotHandle *)Component;
            break;
        }
    }
}

// @retail 0x83320A88
CCSCSMovementGwNav::~CCSCSMovementGwNav()
{
    Kaim::Memory::pGlobalHeap->Free(m_workingMemory);
}
#endif

// @retail 0x83320B58
bool CCSCSMovementGwNav::DoMove()
{
    if (m_state != MS_STRAFE)
    {
        m_pCCSCtrl->Focus = 0;
        m_pCCSCtrl->SetFocalPoint(m_moveObj.target, 0);
    }
    if (m_moveObj.movementType == CCS::MovementType_Walk)
    {
        m_pBasePawn->bIsWalking = 1;
    }
    else
    {
        m_pBasePawn->bIsWalking = 0;
    }
    if (m_pGwNavBotHandle == 0)
    {
        return false;
    }
    m_pGwNavBotHandle->BotPointer->MoveToPosition(m_moveObj.target);
    m_firstMoveTick = true;
    return true;
}

// @retail 0x8332AA90
bool CCSCSMovementGwNav::DoMoving()
{
    if (!m_firstMoveTick && DestinationReached())
    {
        return true;
    }
    m_firstMoveTick = false;
    m_pMeatPuppet->SetMovementType(m_moveObj.movementType);
    return false;
}

// @retail 0x83320C50
bool CCSCSMovementGwNav::DoOrient()
{
    m_pCCSCtrl->Focus = 0;
    m_pCCSCtrl->SetFocalPoint(m_orientObj.target, 0);
    return true;
}

// @retail 0x83338348
bool CCSCSMovementGwNav::DoOrienting()
{
    bool bResult = false;
    if (OrientationReached())
    {
        bResult = true;
    }
    return bResult;
}

// @retail 0x83320CB0
bool CCSCSMovementGwNav::DoStrafe()
{
    m_pCCSCtrl->Focus = 0;
    m_pCCSCtrl->SetFocalPoint(m_orientObj.target, 0);
    m_pMeatPuppet->SetMovementType(CCS::MovementType_Strafe);
    return DoMove();
}

// @retail 0x83320D40
bool CCSCSMovementGwNav::DoStrafing()
{
    return DoMoving();
}

// @retail 0x8332AB38
void CCSCSMovementGwNav::DoStop()
{
    m_pMeatPuppet->SetMovementSpeedDefault();
    m_pMeatPuppet->Stop();
    if (m_pGwNavBotHandle != 0 && m_pGwNavBotHandle->BotPointer != 0)
    {
        m_pGwNavBotHandle->BotPointer->m_kaimbot->ClearFollowedPath();
    }
}

// score 8 (was 12): retail interleaves the destination's FVector store with
// the bot position's loads (stfs, lwz, stfs, lwz, stfs, lwz) while ours emits
// the three stores first and the three loads after them. Binding the position
// and the destination to const references before the two copies moves our
// stores ahead of the loads, which leaves only the interleaving itself. A
// named FVector, const locals, an explicit FVector cast, casting the position
// copy, swapping the two statements and a permuter run all leave the order
// alone; so do copying the destination into a named FVector, converting it
// in place, taking the position or the destination by value, a memcpy of the
// position and an explicit Vec3f constructor.
// Copying the destination into a named FVector is the only shape that makes
// the compiler interleave a float store with a word load (the retail shape),
// but it copies the FVector twice and moves every slot with it (score 82);
// taking the position by value, or binding the destination to a named
// reference, only swaps the two copies' order (score 12 and 17).
// Both copies are now known: the destination's FVector is copied into 0x50,
// the conversion is called with that copy and writes 0x70, and the bot
// position is copied into 0x60, so only the order of the six memory
// operations is open. A matrix of 36 shapes (the position taken by value, by
// reference or through a named copy, the destination taken by value, by
// reference or in place, and the two copies in one statement or in two)
// shows that the scheduler keeps the copies apart whenever they are in
// separate statements, and hoists all six loads instead of interleaving them
// when they share one statement; the shapes that do interleave a float store
// with a word load copy the FVector twice and move every slot with them
// (72 and 82).
// This session: retail's three temporaries are now known - the destination's
// FVector is built by the implicit Grip_Vector::operator FVector() into 0x50,
// the bot position's word copy into 0x60 and the converted destination into
// 0x70, which the PDB names botPos and targetPosition - so only the order of
// the six memory operations is open. Building that FVector by hand (three
// member assignments), building it with the three-float constructor, copying
// the position straight into the start instead of through a reference,
// dropping the reference to the FVector and passing the destination to the
// conversion directly all leave the two copies grouped: the three stores of
// one and the three loads of the other are never interleaved, in either
// order (12, 17 and 33). A 600 s permuter run on the restored source found
// nothing below 8.
// @retail 0x8334B5B8
bool CCSCSMovementGwNav::FindNavMeshPath(Grip_Vector Destination) const
{
    if (m_pGwNavBotHandle == 0)
    {
        return false;
    }
    Kaim::Bot *pBot = m_pGwNavBotHandle->BotPointer->m_kaimbot;
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > Query = *new Kaim::AStarQuery<Kaim::DefaultTraverseLogic>;
    Query->BindToDatabase(pBot->m_database);
    const Kaim::Vec3f &RefStart = pBot->GetPosition();
    const FVector &V = Destination;
    Kaim::Vec3f Start = RefStart;
    Kaim::Vec3f Dest = UnrealToGwNavVector(V);
    Query->Initialize(Start, Dest);
    Query->PerformQueryBlocking(m_workingMemory);
    if (Query->m_result != Kaim::ASTAR_DONE_PATH_FOUND)
    {
        return false;
    }
    return true;
}

// score 8 (was 12): the same interleaving of the destination store with the
// position loads as FindNavMeshPath, and the same attempts (a named FVector
// interleaves the copies but wrecks the slots, score 82; a by-value position
// swaps the copies' order, score 12).
// The matrix of 36 shapes from FindNavMeshPath leaves the order alone here
// too: the copies stay apart in separate statements and all six loads are
// hoisted when they share one.
// This session: the same shapes as FindNavMeshPath (the destination's FVector
// built by hand or with the constructor, the position copied straight into
// the start, the conversion taking the destination directly, both copies in
// one declaration) leave the copies grouped here as well. A permuter run
// found nothing below 8.
// @retail 0x8334B6B8
bool CCSCSMovementGwNav::FindNavMeshDistance(Grip_Vector Destination, float &Distance, float) const
{
    if (m_pGwNavBotHandle == 0)
    {
        return false;
    }
    Kaim::Bot *pBot = m_pGwNavBotHandle->BotPointer->m_kaimbot;
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > Query = *new Kaim::AStarQuery<Kaim::DefaultTraverseLogic>;
    Query->BindToDatabase(pBot->m_database);
    const Kaim::Vec3f &RefStart = pBot->GetPosition();
    const FVector &V = Destination;
    Kaim::Vec3f Start = RefStart;
    Kaim::Vec3f Dest = UnrealToGwNavVector(V);
    Query->Initialize(Start, Dest);
    Query->PerformQueryBlocking(m_workingMemory);
    if (Query->m_result != Kaim::ASTAR_DONE_PATH_FOUND)
    {
        return false;
    }
    Distance = Query->m_path->m_pathDistance;
    return true;
}

// score 11 (was 20): the shape is retail's: the position is a named
// Grip_Vector, the target rotation is a named FRotator whose Yaw is read back
// with lwz r31, 4(r9), and the character is used straight from the temporary
// the virtual call returns (mr r4, r3). What is left is the stack layout:
// retail puts the second Character in the position's slot (0x50), the
// character's own rotator in the delta's slot (0x68) and the first Character
// alone at the top (0x90), while ours puts the second Character at 0x90, the
// rotator in the position's slot (0x50) and the first Character in the
// rotation's slot (0x70). The frame size now matches (0xc0).
// Retrying the shapes that failed before (a by-value position, the three- and
// four-statement forms, the sibling file's shape, the character used through a
// named local) all land at 11 or worse, and a 540 s permuter run found
// nothing below 11: the slot pairing is not reachable from the source.
// Also tried here: a named Grip_Rotation for the orientation, the same with a
// named character, the position bound to a const reference, a named delta and
// a named tolerance: all 11. What is left is that retail puts the second
// character's twenty bytes on the position's twelve byte slot at 0x50 while
// ours allocates the rotator there first and gives the second character a
// fresh slot at 0x90.
// This session: the copy at 0x94 is the inlined CCSGameCharacter::GetOrientation()
// - it takes the pawn's or the actor's rotation (the yaw at +0x74) and keeps
// the yaw in a register - and the PDB lists no stack local but `this`, so
// retail's position, delta and rotation are compiler temporaries and its
// named locals (the yaw and the difference) live in registers. Merging the
// position into the rotation and the yaw and the difference into one
// statement (13 and 13), naming the difference and inlining everything else
// (55: the rotation call moves before the second character) and taking the
// orientation through CCSCharacter::GetOrientation() instead of
// m_gameCharacter.GetOrientation() (11) all fail to reach retail's layout.
// Including CCSCharacter.cpp in this file changes nothing.
// @retail 0x8332ABA8
bool CCSCSMovementGwNav::OrientationReached() const
{
    const Grip_Vector Position = m_pMeatPuppet->GetCharacter().GetPosition();
    const FRotator TargetRotation = (m_orientObj.target - Position).Rotation();
    const int TargetYaw = TargetRotation.Yaw;
    const int Yaw = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetOrientation().Yaw;
    const int Difference = Abs((TargetYaw & 0xFFFF) - (Yaw & 0xFFFF));
    return Difference < s_orientationTolerance || Difference > 0xFFFF - s_orientationTolerance;
}

// @retail 0x83320D50
bool CCSCSMovementGwNav::DestinationReached() const
{
    UGwNavBotHandle *pHandle = m_pGwNavBotHandle;
    if (pHandle == 0)
    {
        return false;
    }
    return pHandle->BotPointer->IsArrived();
}

// The two Kaim::Ptr tests are boolean operands, not comparisons with 0: that
// is what makes the compiler test them with a signed compare (cmpwi) and
// without the extra copy (slwi) that a != 0 comparison costs.
// @retail 0x8332ACE0
bool CCSCSMovementGwNav::PathFailed() const
{
    return m_pGwNavBotHandle != 0 && m_pGwNavBotHandle->BotPointer != 0 && m_pGwNavBotHandle->BotPointer->m_kaimbot
        && m_pGwNavBotHandle->BotPointer->m_kaimbot->m_pathFinderQuery
        && m_pGwNavBotHandle->BotPointer->m_kaimbot->m_pathFinderQuery->GetPathFinderResult() == Kaim::IPathFinderQuery::PathFinderFailure;
}

// @retail 0x83338388
void CCSCSMovementGwNav::DrawHUD(GripHUDRenderer *pRenderer, int &Y)
{
    GripAIManager *pManager = GripEngineServices::GetAIManager();
    if (pManager == 0)
    {
        return;
    }
    CCSDebugOptions *pOptions = static_cast<CCSDebugOptions *>(pManager->GetSystem(GripAIManager::SYSTEM_CCS_DEBUG_OPTIONS));
    if (pOptions == 0 || !pOptions->IsOptionEnabled(CCSDebugOptions::MOVEMENT))
    {
        return;
    }
    const Grip_Color TitleColor(255, 102, 0);
    const Grip_Color Color(0, 255, 0);
    pRenderer->DrawString(10, Y, "Movement System", TitleColor);
    Y += pRenderer->endl;
    const char *State = "Invalid";
    Kaim::IPathFinderQuery *pQuery = m_pGwNavBotHandle->BotPointer->m_kaimbot->m_pathFinderQuery;
    if (pQuery != 0)
    {
        switch (pQuery->GetPathFinderResult())
        {
        case Kaim::IPathFinderQuery::PathFinderNotInitialized:
            State = "not yet initialized";
            break;
        case Kaim::IPathFinderQuery::PathFinderNotComputed:
            State = "Path is initialized but has not been processed";
            break;
        case Kaim::IPathFinderQuery::PathFinderUnderProcess:
            State = "Path is currently under process";
            break;
        case Kaim::IPathFinderQuery::PathFinderSuccess:
            State = "Path has been completed and a Path has been found";
            break;
        case Kaim::IPathFinderQuery::PathFinderFailure:
            State = "Path has been completed but no Path has been found";
            break;
        }
    }
    pRenderer->DrawString(18, Y, "Pathfinder State:", Color);
    pRenderer->DrawString(255, Y, State, Color);
    Y += pRenderer->endl;
    Y += pRenderer->endl;
}
