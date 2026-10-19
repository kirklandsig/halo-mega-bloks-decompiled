// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// uccsblackboard.cpp: script's view of a brain's blackboard.
#include "UDKBase/Inc/UDKBaseClasses.h"

extern FOutputDeviceRedirectorBase *GLog;

// a member read without being flagged as used logs a warning
#define CHECK_USED(Member, Name)                                                    \
    if (!(Member).IsUsed())                                                         \
    {                                                                               \
        FString Message("GripBlackboard: " Name " used but not flagged.");          \
        GLog->Log(Message);                                                         \
    }

// @retail 0x833222E8
void CCSTargetCopy(const CCSTarget &Target, FCCSTargetData &Data)
{
    Data.Pawn = Target.character.m_gameCharacter.m_pawn;
    Data.Actor = Target.character.m_gameCharacter.m_actor;
    Data.Position = Target.position;
    Data.LKP = Target.LKP;
    Data.LKPAge = Target.LKPAge;
    Data.Range2D = Target.range2D;
    Data.CanShoot = Target.canShoot;
    Data.ClearOfFriendlies = Target.ClearOfFriendlies;
    Data.IsAware = Target.isAware;
    Data.IsFiring = Target.isFiring;
    Data.IsVisible = Target.isVisible;
    Data.AITargetType = (unsigned char)Target.m_aiTargetType;
}

static inline CCSBlackboard *CCSBB(GripBlackboard *BB)
{
    return static_cast<CCSBlackboard *>(BB);
}

// @retail 0x833392E0
int UCCSBlackboard::GetHealth() const
{
    CCSBlackboard *pBB = CCSBB(BB);
    CHECK_USED(pBB->m_health, "Health");
    return pBB->m_health.Get();
}

// @retail 0x8332B820
void UCCSBlackboard::SetHealth(int Health)
{
    CCSBB(BB)->m_health.Set(Health);
}

// Near: retail adds the array base and the element offset the other way round.
// @retail 0x83339360
void UCCSBlackboard::GetCovers(TArray<FCCSCoverData> &Covers) const
{
    CCSBlackboard *pBB = CCSBB(BB);
    CHECK_USED(pBB->m_covers, "Covers");
    Covers.Reserve(pBB->m_covers.Num());
    FCCSCoverData Data;
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        const CCSCover &Cover = pBB->m_covers[i];
        Data.TargetDist = Cover.m_targetDist;
        Data.DirectDistance = Cover.m_directDistance;
        Data.ValidPath = Cover.m_validPath;
        Data.PathDistance = Cover.m_pathDistance;
        Data.IsValid = Cover.IsValid();
        Data.CoverLink = Cover.m_gameCover.m_coverInfo.Link;
        Data.SlotIdx = Cover.m_gameCover.m_coverInfo.SlotIdx;
        Covers.AddItem(Data);
    }
}

// @retail 0x833394A0
FCCSTargetData UCCSBlackboard::GetCurrentTarget() const
{
    CCSTarget *pBBTarget = CCSBB(BB)->m_currentTarget.Get();
    CCSTarget *pTarget = pBBTarget != 0 && pBBTarget->character != CCSCharacter::NONE ? pBBTarget : 0;
    FCCSTargetData Data;
    appMemzero(&Data, sizeof(Data));
    if (pTarget != 0)
    {
        CCSTargetCopy(*pTarget, Data);
    }
    return Data;
}

// @retail 0x8332B830
void UCCSBlackboard::SetCurrentTether(AActor *Tether)
{
    CCSBB(BB)->m_currentTether.Set(Tether->Location);
}

// @retail 0x8332B868
FVector UCCSBlackboard::GetCurrentTether() const
{
    return CCSBB(BB)->m_currentTether.Get();
}

// @retail 0x83339550
float UCCSBlackboard::GetHeatGenerated() const
{
    CCSBlackboard *pBB = CCSBB(BB);
    CHECK_USED(pBB->m_heatGenerated, "Heat Generated");
    return pBB->m_heatGenerated.Get();
}

// @retail 0x8332B858
void UCCSBlackboard::SetHeatGenerated(float Heat)
{
    CCSBB(BB)->SetHeatGenerated(Heat);
}

// @retail 0x833395D0
FCCSTargetData UCCSBlackboard::GetClosestVisibleEnemy() const
{
    CCSTarget *pBBTarget = CCSBB(BB)->m_closestVisibleEnemy.Get();
    CCSTarget *pTarget = pBBTarget != 0 && pBBTarget->character != CCSCharacter::NONE ? pBBTarget : 0;
    FCCSTargetData Data;
    appMemzero(&Data, sizeof(Data));
    if (pTarget != 0)
    {
        CCSTargetCopy(*pTarget, Data);
    }
    return Data;
}

// Near: retail adds the array base and the element offset the other way round.
// @retail 0x83339680
void UCCSBlackboard::GetTargets(TArray<FCCSTargetData> &Targets) const
{
    CCSBlackboard *pBB = CCSBB(BB);
    CHECK_USED(pBB->m_targets, "Targets");
    Targets.Reserve(pBB->m_targets.Num());
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        FCCSTargetData Data;
        CCSTargetCopy(pBB->m_targets[i], Data);
        Targets.AddItem(Data);
    }
}

// @retail 0x8332B888
FCCSMoveCmdData UCCSBlackboard::GetMoveCommand() const
{
    CCSBlackboard *pBB = CCSBB(BB);
    FCCSMoveCmdData Data;
    Data.MoveCmd = (unsigned char)pBB->GetMoveCommand();
    Data.Position = pBB->GetMovePosition();
    return Data;
}

// @retail 0x8332B8E8
void UCCSBlackboard::ClearMoveCommand()
{
    CCSBB(BB)->ClearMoveCommand();
}

// @retail 0x833223E8
void UCCSBlackboard::FlagThreatLocationAsUsed()
{
    CCSBB(BB)->FlagThreatLocationAsUsed();
}

// @retail 0x833223F8
void UCCSBlackboard::FlagThreatDirectionAsUsed()
{
    CCSBB(BB)->FlagThreatDirectionAsUsed();
}

// @retail 0x8332B900
FVector UCCSBlackboard::GetThreatLocation()
{
    return CCSBB(BB)->m_threatLocation.Get();
}

// @retail 0x8332B938
FVector UCCSBlackboard::GetThreatDirection()
{
    return CCSBB(BB)->m_threatDirection.Get();
}

// @retail 0x8332B970
unsigned char UCCSBlackboard::GetThreatType()
{
    return (unsigned char)CCSBB(BB)->GetThreatType();
}

// @retail 0x83322448
void UCCSBlackboard::FlagHeatGeneratedAsUsed()
{
    CCSBB(BB)->FlagHeatGeneratedAsUsed();
}

// @retail 0x833223C8
void UCCSBlackboard::FlagHealthAsUsed()
{
    CCSBB(BB)->m_health.FlagAsUsed();
}

// @retail 0x833223D8
void UCCSBlackboard::FlagCoversAsUsed()
{
    CCSBB(BB)->m_covers.FlagAsUsed();
}

// @retail 0x83322408
void UCCSBlackboard::FlagTargetsAsUsed()
{
    CCSBlackboard *pBB = CCSBB(BB);
    pBB->m_targets.FlagAsUsed();
    pBB->FlagCurrentTarget();
}

// @retail 0x83322420
void UCCSBlackboard::FlagTetherAsUsed()
{
    CCSBB(BB)->m_currentTether.FlagAsUsed();
}

// @retail 0x83322430
void UCCSBlackboard::FlagClosestVisibleEnemyAsUsed()
{
    CCSBlackboard *pBB = CCSBB(BB);
    pBB->m_targets.FlagAsUsed();
    pBB->FlagClosestVisibleEnemy();
}
