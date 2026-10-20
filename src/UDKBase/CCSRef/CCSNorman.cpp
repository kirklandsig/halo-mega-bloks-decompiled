// @object Unity_UDKCoverEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnMath.h"

// ccsaimanagerfactory.h's register object: each file that includes the
// header has its own, and here the constructor is called, not inlined
static CCSAIManagerFactoryRegister s_AIManagerFactoryRegister;
// @retail 0x8428CAE8
// `dynamic initializer for 's_AIManagerFactoryRegister''

// The next ActorWrapper's ID (a file static: no public symbol)
static int s_NextActorID;

// A file-scope constant: retail loads it from this object's .rdata (no
// literal symbol), and doesn't hoist the load out of the loop.
static const float BrainlessCoverDistanceSquared = 16384.0f;

// @retail 0x833C9700
void UUDKTargetableComponent::Tick(float DeltaTime)
{
    if (CurAIHeat > 0.0f)
    {
        CurAIHeat -= ReduceHeatPerSecond * DeltaTime;
        if (CurAIHeat < 0.0f)
        {
            CurAIHeat = 0.0f;
        }
    }
    AUDKPawn *pPawn = Cast<AUDKPawn>(Owner);
    if (pPawn != 0 && Cast<AUDKPlayerController>(pPawn->Controller) != 0)
    {
        CCSNorman::getInstance()->CountBrainlessCover(pPawn);
    }
}

// @retail 0x833C9780
void UUDKTargetableComponent::BeginPlay()
{
    Super::BeginPlay();
    myOwner = Owner;
    if (bAITargetable == 1)
    {
        CCSNorman::getInstance()->AddTarget(myOwner);
    }
    if (bIsVehicle && GWorld != 0)
    {
        GWorld->AddVehicle(myOwner);
    }
}

// @retail 0x833C9808
void UUDKTargetableComponent::BeginDestroy()
{
    if (myOwner != 0)
    {
        CCSNorman::getInstance()->RemoveTarget(myOwner);
        if (GWorld != 0)
        {
            GWorld->RemoveVehicle(myOwner);
        }
        AUDKPawn *pPawn = Cast<AUDKPawn>(myOwner);
        if (pPawn != 0 && Cast<AUDKPlayerController>(pPawn->Controller) != 0)
        {
            CCSNorman::getInstance()->VacateAllBrainlessCover(pPawn);
        }
    }
    Super::BeginDestroy();
}

// @retail 0x833C98A0
void UUDKTargetableComponent::BeginDeath()
{
    if (myOwner != 0)
    {
        CCSNorman::getInstance()->RemoveTarget(myOwner);
        GWorld->RemoveVehicle(myOwner);
        AUDKPawn *pPawn = Cast<AUDKPawn>(myOwner);
        if (pPawn != 0 && Cast<AUDKPlayerController>(pPawn->Controller) != 0)
        {
            CCSNorman::getInstance()->VacateAllBrainlessCover(pPawn);
        }
    }
}

// @retail 0x833C7F48
AActor *UUDKTargetableComponent::GetOwner()
{
    return myOwner;
}

// @retail 0x833C7F50
ActorWrapper::ActorWrapper(AActor *pActor)
{
    myActor = pActor;
    myActorID = s_NextActorID++;
}

// @retail 0x833C9420
CCSNorman::CCSNorman()
{
    reset();
}

// @retail 0x833C9470
CCSNorman *CCSNorman::getInstance()
{
    if (instance == 0)
    {
        instance = new CCSNorman();
    }
    return instance;
}

// @retail 0x833C91F8
void CCSNorman::reset()
{
    pFirstTargeter = 0;
    pFirstCoverSeeker = 0;
    m_ThreatTargetsMasterListRefCount = 0;
    m_CoverMasterListRefCount = 0;
    m_ThreatTargetsMasterList.Reset();
    m_CoverMasterList.Reset();
    FirstCoverLink = 0;
}

// @retail 0x833C86D0
void CCSNorman::AddTarget(AActor *pActor)
{
    for (int i = 0; i < m_ThreatTargetsMasterList.Num(); i++)
    {
        if (m_ThreatTargetsMasterList(i)->myActor == pActor)
        {
            return;
        }
    }
    m_ThreatTargetsMasterList.AddItem(new ActorWrapper(pActor));
    m_ThreatTargetsMasterListRefCount++;
    for (CCSPSTargetAwareness *pTargeter = pFirstTargeter; pTargeter != 0; pTargeter = pTargeter->pNextTargeter)
    {
        pTargeter->AddThreatTarget(pActor);
    }
}

// @retail 0x833C94F8
void CCSNorman::RemoveTarget(AActor *pActor)
{
    for (CCSPSTargetAwareness *pTargeter = pFirstTargeter; pTargeter != 0; pTargeter = pTargeter->pNextTargeter)
    {
        pTargeter->RemoveThreatTarget(pActor);
    }
    for (int i = 0; i < m_ThreatTargetsMasterList.Num(); i++)
    {
        ActorWrapper *pWrapper = m_ThreatTargetsMasterList(i);
        if (pWrapper->myActor == pActor)
        {
            m_ThreatTargetsMasterList.RemoveSwap(i);
            m_ThreatTargetsMasterListRefCount--;
            delete pWrapper;
            break;
        }
    }
    if (m_ThreatTargetsMasterListRefCount <= 0 && pFirstTargeter == 0 && m_CoverMasterListRefCount <= 0 && pFirstCoverSeeker == 0)
    {
        delete instance;
        instance = 0;
    }
}

// @retail 0x833C87F8
void CCSNorman::AddTargeter(CCSPSTargetAwareness *pTargeter)
{
    pTargeter->pNextTargeter = pFirstTargeter;
    pFirstTargeter = pTargeter;
    for (int i = 0; i < m_ThreatTargetsMasterList.Num(); i++)
    {
        pTargeter->AddThreatTarget(m_ThreatTargetsMasterList(i)->myActor);
    }
}

// @retail 0x833C7F70
void CCSNorman::RemoveTargeter(CCSPSTargetAwareness *pTargeter)
{
    CCSPSTargetAwareness *pCur = pFirstTargeter;
    if (pCur == pTargeter)
    {
        pFirstTargeter = pTargeter->pNextTargeter;
        return;
    }
    for (; pCur->pNextTargeter != 0; pCur = pCur->pNextTargeter)
    {
        if (pCur->pNextTargeter == pTargeter)
        {
            pCur->pNextTargeter = pTargeter->pNextTargeter;
            return;
        }
    }
}

// @retail 0x833C9AB8
void CCSNorman::AddCover(ACoverLink *pLink)
{
    for (int i = 0; i < m_CoverMasterList.Num(); i++)
    {
        if (m_CoverMasterList(i).m_coverInfo.Link == pLink)
        {
            return;
        }
    }
    AUDKCover *pCover = Cast<AUDKCover>(pLink->DestructibleCoverActor);
    if (pCover != 0)
    {
        pCover->AddCoverLink(pLink);
    }
    else
    {
        pLink->NextDestructibleCoverLink = FirstCoverLink;
        FirstCoverLink = pLink;
    }
    for (int i = 0; i < pLink->Slots.Num(); i++)
    {
        CCSGameCover Cover;
        Cover.m_coverInfo.Link = pLink;
        Cover.m_coverInfo.SlotIdx = i;
        m_CoverMasterList.AddItem(Cover);
        pLink->Slots(i).SlotOwner = 0;
        pLink->Slots(i).SlotOccupier = 0;
    }
    for (CCSPSCover *pSeeker = pFirstCoverSeeker; pSeeker != 0; pSeeker = pSeeker->pNextCoverSeeker)
    {
        pSeeker->AddCover(pLink);
    }
    m_CoverMasterListRefCount++;
}

static void RemoveFromList(ACoverLink *&pFirst, ACoverLink *pLink)
{
    ACoverLink *pPrev = 0;
    for (ACoverLink *pCur = pFirst; pCur != 0; pCur = pCur->NextDestructibleCoverLink)
    {
        if (pCur == pLink)
        {
            if (pPrev != 0)
            {
                pPrev->NextDestructibleCoverLink = pCur->NextDestructibleCoverLink;
            }
            else
            {
                pFirst = pCur->NextDestructibleCoverLink;
            }
            pCur->NextDestructibleCoverLink = 0;
            return;
        }
        pPrev = pCur;
    }
}

// @retail 0x833C9C20
void CCSNorman::RemoveCover(ACoverLink *pLink)
{
    AUDKCover *pCover = Cast<AUDKCover>(pLink->DestructibleCoverActor);
    if (pCover != 0)
    {
        pCover->RemoveCoverLink(pLink);
    }
    else
    {
        RemoveFromList(FirstCoverLink, pLink);
    }
    int NumSlots = pLink->Slots.Num();
    for (int i = 0; i < m_CoverMasterList.Num();)
    {
        if (m_CoverMasterList(i).m_coverInfo.Link == pLink)
        {
            m_CoverMasterList.RemoveSwap(i);
            if (--NumSlots == 0)
            {
                m_CoverMasterListRefCount--;
                break;
            }
        }
        else
        {
            i++;
        }
    }
    for (CCSPSCover *pSeeker = pFirstCoverSeeker; pSeeker != 0; pSeeker = pSeeker->pNextCoverSeeker)
    {
        pSeeker->RemoveCover(pLink);
    }
    if (m_ThreatTargetsMasterListRefCount <= 0 && pFirstTargeter == 0 && m_CoverMasterListRefCount <= 0 && pFirstCoverSeeker == 0)
    {
        delete instance;
        instance = 0;
    }
}

// @retail 0x833C88B8
void CCSNorman::AddCoverSeeker(CCSPSCover *pSeeker)
{
    pSeeker->pNextCoverSeeker = pFirstCoverSeeker;
    pFirstCoverSeeker = pSeeker;
    for (int i = 0; i < m_CoverMasterList.Num(); i++)
    {
        pSeeker->AddCover(m_CoverMasterList(i));
    }
}

// @retail 0x833C7FC8
void CCSNorman::RemoveCoverSeeker(CCSPSCover *pSeeker)
{
    CCSPSCover *pCur = pFirstCoverSeeker;
    if (pCur == pSeeker)
    {
        pFirstCoverSeeker = pSeeker->pNextCoverSeeker;
        return;
    }
    for (; pCur->pNextCoverSeeker != 0; pCur = pCur->pNextCoverSeeker)
    {
        if (pCur->pNextCoverSeeker == pSeeker)
        {
            pCur->pNextCoverSeeker = pSeeker->pNextCoverSeeker;
            return;
        }
    }
}

// @retail 0x833C8020
ACoverLink *CCSNorman::GetDestructibleCoverList(AUDKCover *pCover)
{
    ACoverLink *pList = 0;
    while (FirstCoverLink != 0 && FirstCoverLink->DestructibleCoverActor == pCover)
    {
        ACoverLink *pLink = FirstCoverLink;
        FirstCoverLink = pLink->NextDestructibleCoverLink;
        pLink->NextDestructibleCoverLink = pList;
        pList = pLink;
    }
    if (FirstCoverLink != 0)
    {
        ACoverLink *pPrev = FirstCoverLink;
        for (ACoverLink *pCur = pPrev->NextDestructibleCoverLink; pCur != 0; pCur = pPrev->NextDestructibleCoverLink)
        {
            if (pCur->DestructibleCoverActor == pCover)
            {
                pPrev->NextDestructibleCoverLink = pCur->NextDestructibleCoverLink;
                pCur->NextDestructibleCoverLink = pList;
                pList = pCur;
            }
            else
            {
                pPrev = pCur;
            }
        }
    }
    return pList;
}

// @retail 0x833C8918
void CCSNorman::CountBrainlessCover(AUDKPawn *pPawn)
{
    if (pPawn == 0)
    {
        return;
    }
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = pPawn;
    for (int i = 0; i < m_CoverMasterList.Num(); i++)
    {
        CCSGameCover &Cover = m_CoverMasterList(i);
        Cover.VacateCover(Character);
        if (Cover.IsEnabled())
        {
            Grip_Vector PawnLocation = pPawn->Location;
            Grip_Vector SlotLocation = Cover.m_coverInfo.Link->GetSlotLocation(Cover.m_coverInfo.SlotIdx, 0);
            if ((SlotLocation - PawnLocation).SizeSquared() < BrainlessCoverDistanceSquared)
            {
                Cover.OccupyCover(Character);
            }
        }
    }
}

// @retail 0x833C8A38
void CCSNorman::VacateAllBrainlessCover(AUDKPawn *pPawn)
{
    if (pPawn == 0)
    {
        return;
    }
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = pPawn;
    for (int i = 0; i < m_CoverMasterList.Num(); i++)
    {
        m_CoverMasterList(i).VacateCover(Character);
    }
}

// @retail 0x833C8AB8
bool CCSNorman::IsAlertedEnemyInRange(AActor *pActor, float Range)
{
    float RangeSquared = Range * Range;
    int Team = pActor->GetTeamNum();
    if (Team >= 0 && Team < 255)
    {
        for (int i = 0; i < m_ThreatTargetsMasterList.Num(); i++)
        {
            APawn *pPawn = Cast<APawn>(m_ThreatTargetsMasterList(i)->myActor);
            if (pPawn == 0)
            {
                continue;
            }
            int OtherTeam = pPawn->GetTeamNum();
            if (OtherTeam >= 0 && OtherTeam < 255 && OtherTeam != Team
                && (pPawn->Location - pActor->Location).SizeSquared() < RangeSquared)
            {
                ACCSController *pController = Cast<ACCSController>(pPawn->Controller);
                if (pController != 0 && pController->Brain != 0)
                {
                    CCSBlackboard *pBlackboard = pController->Brain->GetBlackboard<CCSBlackboard>();
                    if (pBlackboard != 0 && pBlackboard->GetHasBecomeAware())
                    {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

// The implicit destructor (it destroys the two arrays), out of line where
// RemoveCover deletes the instance.
// @retail 0x833C9090
// CCSNorman::~CCSNorman
// @retail 0x833C9290
// CCSNorman::`scalar deleting destructor'
