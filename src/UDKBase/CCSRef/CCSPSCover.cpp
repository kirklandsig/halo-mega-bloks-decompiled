// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccspscover.cpp: the sensor that keeps a brain's cover on the blackboard:
// it culls the cover slots that are disabled, taken, too far away or badly
// placed against the targets, and spreads the costly checks over frames.
#pragma once
#include "CCSSensorSystem.cpp"
#include "CCSCover.cpp"
#include "CCSBlackboard.cpp"
#include "CCSGlobalDataScheduler.cpp"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSCoverRenderingComponent.cpp"

extern FFeedbackContext *GWarn;

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83330470
CCSPSCover::CCSPSCover(CCSBrain *pBrain) : CCSSensorSystem(pBrain), m_coverIdx(0), m_pDebugComponent(0)
{
}
#endif

// @retail 0x8334C518
CCSPSCover::~CCSPSCover()
{
    if (m_pDebugComponent != 0)
    {
        m_pBrain->RemoveDebugRenderer(m_pDebugComponent);
        delete m_pDebugComponent;
        m_pDebugComponent = 0;
    }
}

// @retail 0x83344810
void CCSPSCover::Initialize(const GripSystemConfig *pConfig)
{
    CCSSensorSystem::Initialize(pConfig);
    m_config = *static_cast<const CCSSystemsConfig *>(pConfig);
    CCSBrain *pBrain = m_pBrain;
    m_pDebugComponent = new CCSCoverRenderingComponent(pBrain);
    m_pBrain->AddDebugRenderer(m_pDebugComponent);
    CCSAISystem *pAISystem = GripEngineServices::GetAIManagerSystem<CCSAISystem>();
    if (pAISystem != 0)
    {
        pAISystem->GetGlobalDataScheduler()->RegisterSensor(0);
    }
    CCSNorman::getInstance()->AddCoverSeeker(this);
}

// near: adds the element offset to the array base the other way round (the
// same add-order difference as elsewhere; several accessors tried)
// @retail 0x8333C698
void CCSPSCover::Finalize()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    CCSCharacter Self = m_pBrain->m_meatPuppet->GetCharacter();
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        pBB->m_covers[i].VacateCover(Self);
    }
    CCSNorman::getInstance()->RemoveCoverSeeker(this);
    CCSAISystem *pAISystem = GripEngineServices::GetAIManagerSystem<CCSAISystem>();
    if (pAISystem != 0)
    {
        pAISystem->GetGlobalDataScheduler()->UnregisterSensor(0);
    }
}

// @retail 0x8335F4C0
void CCSPSCover::Tick(float)
{
    LowCostPerception();
}

// @retail 0x8334C5A8
bool CCSPSCover::TickBudget(float, int &Budget)
{
    const bool bDone = HighCostPerception(Budget);
    if (bDone)
    {
        m_coverIdx = 0;
    }
    return bDone;
}

// near: the loop's two counters are incremented in the other order (i++,
// ++i and i += 1 tried)
// @retail 0x83356F20
void CCSPSCover::LowCostPerception()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ResetCoverForLowCostPerception();
    ComputeDistanceToTarget();
    for (int i = 0; i < pBB->m_covers.Num();)
    {
        CCSCover &Cover = pBB->m_covers[i];
        if (!DisabledCulling(Cover))
        {
            Cover.m_validPath = false;
            pBB->m_invalidcovers.AddItem(Cover);
            pBB->m_covers.RemoveItemSwap(i);
            continue;
        }
        if (!OccupiedCulling(Cover))
        {
            Cover.m_validPath = false;
            pBB->m_invalidcovers.AddItem(Cover);
            pBB->m_covers.RemoveItemSwap(i);
            continue;
        }
        if (!DistanceCulling(Cover))
        {
            Cover.m_validPath = false;
            pBB->m_invalidcovers.AddItem(Cover);
            pBB->m_covers.RemoveItemSwap(i);
            continue;
        }
        if (!DefensiveAngleCulling(Cover))
        {
            Cover.m_validPath = false;
        }
        else
        {
            AttackAngleCulling(Cover);
        }
        i++;
    }
}

// @retail 0x83344970
void CCSPSCover::ResetCoverForLowCostPerception()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        CCSCover &Cover = pBB->m_covers[i];
        Cover.m_state = CCS::CoverState_Valid;
        Cover.m_inUseByMe = false;
    }
    for (int i = 0; i < pBB->m_invalidcovers.Num(); i++)
    {
        CCSCover &Cover = pBB->m_invalidcovers[i];
        Cover.m_state = CCS::CoverState_Valid;
        Cover.m_inUseByMe = false;
        pBB->m_covers.AddItem(Cover);
    }
    pBB->m_invalidcovers.Reset();
}

// @retail 0x8333C788
void CCSPSCover::ComputeDistanceToTarget()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        CCSCover &Cover = pBB->m_covers[i];
        Cover.m_targetDist = pTarget == 0 ? 0.0f : (Cover.GetPosition() - pTarget->position).Size();
    }
}

// @retail 0x83344AE8
bool CCSPSCover::DisabledCulling(CCSCover &Cover)
{
    if (!Cover.IsEnabled())
    {
        Cover.m_state = CCS::CoverState_Disabled;
        return false;
    }
    return true;
}

// @retail 0x8333C8A8
bool CCSPSCover::OccupiedCulling(CCSCover &Cover)
{
    CCSCharacter Self = m_pBrain->m_meatPuppet->GetCharacter();
    if (Cover.IsOccupied())
    {
        if (!Cover.IsOccupiedBy(Self))
        {
            Cover.m_state = CCS::CoverState_Occupied;
            return false;
        }
        Cover.m_inUseByMe = true;
    }
    else if (Cover.IsLocked())
    {
        if (!Cover.IsLockedBy(Self))
        {
            Cover.m_state = CCS::CoverState_Reserved;
            return false;
        }
        Cover.m_inUseByMe = true;
    }
    Grip_Vector Delta = Cover.GetPosition() - m_pBrain->m_meatPuppet->GetCharacter().GetPosition();
    if ((Delta | Delta) < 6400.0f)
    {
        Cover.OccupyCover(Self);
        Cover.m_inUseByMe = true;
    }
    else
    {
        Cover.VacateCover(Self);
        Cover.m_inUseByMe = false;
    }
    return true;
}

// @retail 0x833304E8
bool CCSPSCover::DistanceCulling(CCSCover &Cover)
{
    Grip_Vector Delta = Cover.GetPosition() - m_pBrain->m_meatPuppet->GetCharacter().GetPosition();
    Cover.m_directDistance = Delta | Delta;
    if (Cover.m_directDistance > m_config.coverQueryRadius * m_config.coverQueryRadius)
    {
        Cover.m_state = CCS::CoverState_OutsideRange;
        return false;
    }
    return true;
}

// @retail 0x833246C8
bool CCSPSCover::DefensiveAngleCulling(CCSCover &Cover)
{
    if (!Cover.m_validDefense)
    {
        Cover.m_state = CCS::CoverState_BadDefensiveAngle;
        return false;
    }
    return true;
}

// @retail 0x8334C5F0
bool CCSPSCover::AttackAngleCulling(CCSCover &Cover)
{
    Grip_Rotation Orientation = Cover.GetOrientation();
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    if (!HasValidAttackAngle(m_pBrain->m_meatPuppet, Cover, Orientation, pBB->GetCurrentTarget()))
    {
        Cover.m_state = CCS::CoverState_BadAttackAngle;
        return false;
    }
    return true;
}

// @retail 0x833246F0
bool CCSPSCover::PathCulling(CCSCover &Cover)
{
    if (!Cover.m_validPath)
    {
        Cover.m_state = CCS::CoverState_NoPath;
        return false;
    }
    return true;
}

// todo: 4 bytes long; ours reads the first Rotation() through the pointer it
// returns, retail from its stack slot (and its frame is 16 bytes smaller);
// a named location, a named delta and FVector arithmetic tried
// @retail 0x8333CA38
bool CCSPSCover::HasValidDefensiveAngle(const float MinYaw, const float MaxYaw, const Grip_Vector Position, const Grip_Rotation &Orientation,
                                        const CCSTarget *pTarget)
{
    if (pTarget == 0)
    {
        return true;
    }
    if (pTarget->character.GetActor() == 0)
    {
        return true;
    }
    AActor *pActor = (AActor *)pTarget->character.GetActor();
    Grip_Rotation Rotation = (Grip_Vector(pActor->Location) - Position).Rotation() - Orientation;
    Rotation.Normalize();
    if (Rotation.Yaw >= MaxYaw || Rotation.Yaw <= MinYaw)
    {
        return false;
    }
    Rotation = (pTarget->character.GetEyesPosition() - Position).Rotation() - Orientation;
    Rotation.Normalize();
    return Rotation.Yaw < MaxYaw && Rotation.Yaw > MinYaw;
}

// todo: 24 bytes long; ours keeps the first test's rotation in its own
// frame slot (a bigger frame) and masks the and of the two yaw/pitch tests
// (one shared rotation, per-block rotations and a branchless & tried)
// @retail 0x83344B48
bool CCSPSCover::HasValidAttackAngle(ICCSMeatPuppet *pMeatPuppet, const CCSCover &Cover, const Grip_Rotation &Orientation, const CCSTarget *pTarget)
{
    if (Cover.m_gameCover == CCSCover::NONE.m_gameCover)
    {
        return false;
    }
    if (pTarget == 0)
    {
        return true;
    }
    bool bValid = false;
    const CCS::ECoverShootConfig Config = Cover.m_gameCover.GetShootConfig();
    if (Config == CCS::CoverShootConfig_All)
    {
        Grip_Rotation Rotation = (pTarget->character.GetEyesPosition() - Cover.GetPosition()).Rotation() - Orientation;
        Rotation.Normalize();
        bValid = (Abs(Rotation.Yaw) < 0x4000) & (Rotation.Pitch < 0x2000);
    }
    CCSCharacter Self = pMeatPuppet->GetCharacter();
    if (Config == CCS::CoverShootConfig_Left || Config == CCS::CoverShootConfig_LeftOrRight)
    {
        Grip_Rotation Rotation = (pTarget->position - Cover.m_gameCover.GetShootPosition(CCS::CoverShootConfig_Left, Self.GetSize())).Rotation() - Orientation;
        Rotation.Normalize();
        bValid = Rotation.Yaw < 0 && Rotation.Yaw > -0x2000;
    }
    if (Config == CCS::CoverShootConfig_Right || (Config == CCS::CoverShootConfig_LeftOrRight && !bValid))
    {
        Grip_Rotation Rotation = (pTarget->position - Cover.m_gameCover.GetShootPosition(CCS::CoverShootConfig_Right, Self.GetSize())).Rotation() - Orientation;
        Rotation.Normalize();
        bValid = Rotation.Yaw > 0 && Rotation.Yaw < 0x2000;
    }
    return bValid;
}

// near: saved registers hold 0 and 1 the other way round (r22/r21), the
// zero vector is stored before the slot's location is loaded, and the cone
// test squares the two vectors in the other order (operand orders tried)
// @retail 0x83344EB8
bool CCSPSCover::HighCostPerception(int &Budget)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    m_pBrain->GetMeatPuppetQuery<IGripMeatPuppetQuery>();
    for (; m_coverIdx < pBB->m_covers.Num() && Budget > 0; m_coverIdx++)
    {
        bool bSpent = false;
        CCSCover &Cover = pBB->m_covers[m_coverIdx];
        if (Cover.IsValid() || Cover.m_state == CCS::CoverState_NoPath)
        {
            Cover.m_validPath = true;
            Cover.m_pathDistance = appSqrt(Cover.m_directDistance);
        }
        if (Cover.IsValid() || Cover.m_state == CCS::CoverState_BadDefensiveAngle)
        {
            bSpent = true;
            Grip_Rotation Orientation = Cover.GetOrientation();
            Grip_Vector Position = Cover.GetPosition();
            Grip_RotationTranslationMatrix Matrix(Orientation, Grip_Vector(0.0f, 0.0f, 0.0f));
            Grip_Vector ShootPosition = Position + Matrix.TransformNormal(Grip_Vector(128.0f, 0.0f, 0.0f));
            const CCS::ECoverShootConfig Config = Cover.m_gameCover.GetShootConfig();
            float MaxYaw = 16384.0f;
            float MinYaw = -16384.0f;
            if (Config == CCS::CoverShootConfig_Left)
            {
                MinYaw = -8192.0f;
            }
            else if (Config == CCS::CoverShootConfig_Right)
            {
                MaxYaw = 8192.0f;
            }
            else if (Config == CCS::CoverShootConfig_LeftOrRight || Config == CCS::CoverShootConfig_All)
            {
                MaxYaw = 8192.0f;
                MinYaw = -8192.0f;
            }
            Cover.m_validDefense = true;
            for (int i = 0; i < pBB->m_targets.Num(); i++)
            {
                CCSTarget &Target = pBB->m_targets[i];
                if (Target.m_aiTargetType == AITargetType_PassiveObjective || Target.m_aiTargetType == AITargetType_PassiveSecondary)
                {
                    continue;
                }
                Grip_Vector Eyes = Target.character.GetEyesPosition();
                Grip_Vector ToCover = Position - Eyes;
                Grip_Vector ToMe = m_pBrain->m_meatPuppet->GetCharacter().GetPosition() - Eyes;
                const float Dot = ToMe | ToCover;
                if (Dot <= 0.0f || Dot * Dot / ((ToCover | ToCover) * (ToMe | ToMe)) <= 0.49999997f
                    || !HasValidDefensiveAngle(MinYaw, MaxYaw, ShootPosition, Orientation, &Target))
                {
                    Cover.m_validDefense = false;
                    break;
                }
            }
        }
        if (bSpent)
        {
            Budget--;
        }
    }
    return m_coverIdx >= pBB->m_covers.Num();
}

// @retail 0x83345280
void CCSPSCover::AddCover(CCSGameCover &GameCover)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        if (pBB->m_covers[i].m_gameCover == GameCover)
        {
            return;
        }
    }
    CCSCover Cover;
    Cover.m_gameCover = GameCover;
    pBB->OnNewCover(Cover);
}

// @retail 0x833455A0
void CCSPSCover::AddCover(ACoverLink *pLink)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        if (pBB->m_covers[i].m_gameCover.m_coverInfo.Link == pLink)
        {
            return;
        }
    }
    for (int i = 0; i < pLink->Slots.Num(); i++)
    {
        CCSCover Cover;
        Cover.m_gameCover.m_coverInfo.Link = pLink;
        Cover.m_gameCover.m_coverInfo.SlotIdx = i;
        pBB->OnNewCover(Cover);
    }
}

// @retail 0x833453F0
void CCSPSCover::RemoveCover(CCSGameCover &GameCover)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    int Index = 0;
    for (int i = 0; i < pBB->m_covers.Num(); i++, Index++)
    {
        if (pBB->m_covers[i].m_gameCover == GameCover)
        {
            pBB->OnCoverDestroyed(Index);
            return;
        }
    }
    for (int i = 0; i < pBB->m_invalidcovers.Num(); i++, Index++)
    {
        if (pBB->m_invalidcovers[i].m_gameCover == GameCover)
        {
            pBB->OnCoverDestroyed(Index);
            return;
        }
    }
}

// @retail 0x83345720
void CCSPSCover::RemoveCover(ACoverLink *pLink)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    int Remaining = pLink->Slots.Num();
    int Index = 0;
    while (Index < pBB->m_covers.Num())
    {
        if (pBB->m_covers[Index].m_gameCover.m_coverInfo.Link == pLink)
        {
            pBB->OnCoverDestroyed(Index);
            if (--Remaining == 0)
            {
                return;
            }
        }
        else
        {
            Index++;
        }
    }
    for (int i = 0; i < pBB->m_invalidcovers.Num();)
    {
        if (pBB->m_invalidcovers[i].m_gameCover.m_coverInfo.Link == pLink)
        {
            pBB->OnCoverDestroyed(Index);
            if (--Remaining == 0)
            {
                return;
            }
        }
        else
        {
            i++;
            Index++;
        }
    }
    GWarn->Logf__VA(L"%i SLOTS FROM %s WERE NOT FOUND FOR REMOVAL!", Remaining, *pLink->GetName());
}
