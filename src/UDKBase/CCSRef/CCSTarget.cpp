// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccstarget.cpp. Other files of the unity include this one for the
// definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833335D0
CCSTarget::CCSTarget()
    : character(CCSCharacter::NONE), teamNum(-1), LKPAge(0.0f), CNTAge(999.9f), range2D(0.0f), rangeNavMesh(0.0f),
      currentThreat(0.0f), canShoot(false), ClearOfFriendlies(false), isAware(false), isFiring(false), isVisible(false),
      isHeard(false), isAvailableVehicle(false), isBehindCover(false), m_pGwNavBotHandle(0),
      pathResult(Kaim::ASTAR_NOT_INITIALIZED)
{
}

// @retail 0x83340820
CCSTarget::CCSTarget(CCSBrain *pBrain)
    : character(CCSCharacter::NONE), teamNum(-1), LKPAge(0.0f), CNTAge(999.9f), range2D(0.0f), rangeNavMesh(0.0f),
      currentThreat(0.0f), canShoot(false), ClearOfFriendlies(false), isAware(false), isFiring(false), isVisible(false),
      isHeard(false), isAvailableVehicle(false), isBehindCover(false), m_pGwNavBotHandle(0),
      pathResult(Kaim::ASTAR_NOT_INITIALIZED)
{
    CCSMeatPuppet *pMeatPuppet = static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet);
    APawn *pPawn = pMeatPuppet->m_pUnPawn;
    m_pGwNavBotHandle = 0;
    for (int i = 0; i < pPawn->Components.Num(); i++)
    {
        UActorComponent *pComponent = pPawn->Components(i);
        if (pComponent != 0 && pComponent->IsA(UGwNavBotHandle::StaticClass()))
        {
            m_pGwNavBotHandle = (UGwNavBotHandle *)pComponent;
            break;
        }
    }
}

// @retail 0x83333720
Grip_Vector CCSTarget::GetDefaultShootLocation() const
{
    return character.GetEyesPosition();
}

// @retail 0x833251F8
bool CCSTarget::IsValid() const
{
    return character != CCSCharacter::NONE;
}

// @retail 0x83325238
void CCSTarget::ResetAwareness()
{
    ClearOfFriendlies = false;
    canShoot = false;
    isHeard = false;
    isAware = false;
    isVisible = false;
}

// @retail 0x83333670
float CCSTarget::CurrentCamo() const
{
    float Camo = 0.0f;
    AActor *pActor = (AActor *)character.GetActor();
    if (pActor != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>(pActor->GetAPawn());
        if (pPawn != 0)
        {
            Camo = pPawn->Camo;
        }
    }
    return Camo;
}

// @retail 0x83333750
void CCSTarget::UpdateDestinationReachable()
{
    if (m_asyncAStarQuery != 0 && m_asyncAStarQuery->m_processStatus == Kaim::QueryDone)
    {
        pathResult = m_asyncAStarQuery->m_result;
        m_asyncAStarQuery = (Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *)0;
        m_asyncAStarQuery.Clear();
    }
}

// @retail 0x83325258
bool CCSTarget::CanFindPath()
{
    return pathResult == Kaim::ASTAR_DONE_PATH_FOUND;
}

// The implicit copy constructor, destructor and scalar deleting destructor,
// out of line where retail calls them.
// (A first use outside the pragma defines them with the usual inlining.)
void DefineTargetMembers(void *pMem, const CCSTarget &Target, CCSTarget *pTarget)
{
    new (pMem) CCSTarget(Target);
    delete pTarget;
}
#pragma inline_depth(0)
void EmitTargetMembers(void *pMem, const CCSTarget &Target, CCSTarget *pTarget)
{
    new (pMem) CCSTarget(Target);
    delete pTarget;
}
#pragma inline_depth()
// @retail 0x83334D70
// CCSTarget::CCSTarget (copy)
// @retail 0x8332E330
// CCSTarget::~CCSTarget
// @retail 0x83334D00
// CCSTarget::`scalar deleting destructor'

// score 12 (was 12), near: the two FVector temporaries' loads and stores
// interleave in ours; retail builds one, then the other. Named locals, named
// FVector conversions, explicit conversions and both at once all regress to
// todo.
// @retail 0x8334D020
void CCSTarget::FindDestinationReachable(Grip_Vector Destination)
{
    if (m_pGwNavBotHandle == 0 || m_pGwNavBotHandle->BotPointer == 0)
    {
        return;
    }
    if (m_asyncAStarQuery == 0)
    {
        m_asyncAStarQuery = *new Kaim::AStarQuery<Kaim::DefaultTraverseLogic>;
        m_asyncAStarQuery->BindToDatabase(m_pGwNavBotHandle->BotPointer->m_kaimbot->m_database);
    }
    if (m_asyncAStarQuery->m_processStatus == Kaim::QueryNotStarted)
    {
        Kaim::World *pWorld = GwNavEngineServices::GetWorld();
        if (m_asyncAStarQuery->m_inQueueStatus == Kaim::QueryNotInQueue)
        {
            m_asyncAStarQuery->Initialize(UnrealToGwNavVector(Destination), UnrealToGwNavVector(position));
            pWorld->PushAsyncQuery(m_asyncAStarQuery, Kaim::AsyncQueryDispatchId_Default, 0);
        }
    }
}
