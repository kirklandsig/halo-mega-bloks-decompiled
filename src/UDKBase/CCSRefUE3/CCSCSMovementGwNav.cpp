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

// score 12 (was 12), near: retail interleaves converting the destination
// with copying the bot's position; ours copies first. A named FVector, const
// locals, the conversion inline in the call, swapping the two statements and
// copying the position through a reference all leave it alone.
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
    Kaim::Vec3f Start = pBot->GetPosition();
    Kaim::Vec3f Dest = UnrealToGwNavVector(Destination);
    Query->Initialize(Start, Dest);
    Query->PerformQueryBlocking(m_workingMemory);
    if (Query->m_result != Kaim::ASTAR_DONE_PATH_FOUND)
    {
        return false;
    }
    return true;
}

// score 12 (was 12), near: the same interleaving as FindNavMeshPath.
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
    Kaim::Vec3f Start = pBot->GetPosition();
    Kaim::Vec3f Dest = UnrealToGwNavVector(Destination);
    Query->Initialize(Start, Dest);
    Query->PerformQueryBlocking(m_workingMemory);
    if (Query->m_result != Kaim::ASTAR_DONE_PATH_FOUND)
    {
        return false;
    }
    Distance = Query->m_path->m_pathDistance;
    return true;
}

// score 21 (was 21), todo: retail's frame is 16 bytes larger and it reuses
// the position's stack slot for the second Character temporary, keeping the
// first one separate (named locals for each step do not move it).
// @retail 0x8332ABA8
bool CCSCSMovementGwNav::OrientationReached() const
{
    const int TargetYaw = (m_orientObj.target - m_pMeatPuppet->GetCharacter().GetPosition()).Rotation().Yaw;
    const int Yaw = m_pMeatPuppet->GetCharacter().m_gameCharacter.GetOrientation().Yaw;
    const int Delta = Abs((TargetYaw & 0xFFFF) - (Yaw & 0xFFFF));
    return Delta < s_orientationTolerance || Delta > 0xFFFF - s_orientationTolerance;
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
