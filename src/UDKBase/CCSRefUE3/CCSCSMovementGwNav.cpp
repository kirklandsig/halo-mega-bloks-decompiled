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
// alone.
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
// position loads as FindNavMeshPath.
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

// score 20 (was 21): retail keeps the rotation live across the second
// GetCharacter call and gives that call the position's stack slot, so the
// delta and the rotation sit eight bytes higher (0x68 and 0x78 against our
// 0x60 and 0x70) and the second Character lands in the position's slot.
// @retail 0x8332ABA8
bool CCSCSMovementGwNav::OrientationReached() const
{
    const CCSCharacter Character = m_pMeatPuppet->GetCharacter();
    const int TargetYaw = (m_orientObj.target - Character.GetPosition()).Rotation().Yaw;
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
