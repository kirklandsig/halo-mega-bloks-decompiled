// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccspstargetawareness.cpp: the sensor that keeps a brain's targets on the
// blackboard: who is in range, visible or heard, how threatening each is,
// and which one to attack.
#pragma once
#include "CCSSensorSystem.cpp"
#include "CCSTargetRenderingComponent.cpp"
#include "CCSBlackboard.cpp"
#include "CCSTarget.cpp"

static const char *s_enemyBecameVisible = "EnemyBecameVisible";

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8333CC80
CCSPSTargetAwareness::CCSPSTargetAwareness(CCSBrain *pBrain)
    : CCSSensorSystem(pBrain), m_targetIdx(0), m_vehicleIdx(0), m_curTargetIsCamoed(false)
{
}

// @retail 0x83323450
CCSPSTargetAwareness::Config::Config()
    : m_targetSelection(CCS::TargetEnemy), m_maxAwareRadius(0.0f), m_maxSightRadius(0.0f), m_maxBehindSightRadius(0.0f),
      m_maxHearingRadius(0.0f), m_visionCosineLimit(0.0f), m_passiveObjectiveThreatWeight(0.0f), m_passiveSecondaryThreatWeight(0.0f),
      m_aggressiveMobileThreatWeight(0.0f), m_aggressiveStationaryThreatWeight(0.0f)
{
}
#endif

// @retail 0x8335F4C8
void CCSPSTargetAwareness::Initialize(const GripSystemConfig *pConfig)
{
    CCSSensorSystem::Initialize(pConfig);
    const CCSSystemsConfig *pSystemsConfig = static_cast<const CCSSystemsConfig *>(pConfig);
    m_config.m_targetSelection = pSystemsConfig->targetSelection;
    m_config.m_maxAwareRadius = pSystemsConfig->maxAwareRadius;
    m_config.m_maxSightRadius = pSystemsConfig->maxSightRadius;
    m_config.m_maxBehindSightRadius = pSystemsConfig->maxBehindSightRadius;
    m_config.m_maxHearingRadius = pSystemsConfig->maxHearingRadius;
    m_config.m_visionCosineLimit = (float)cos(pSystemsConfig->visionCone * 0.5f * 0.017453292519943295);
    m_config.m_passiveObjectiveThreatWeight = pSystemsConfig->PassiveObjectiveWeight;
    m_config.m_passiveSecondaryThreatWeight = pSystemsConfig->PassiveSecondaryWeight;
    m_config.m_aggressiveMobileThreatWeight = pSystemsConfig->AggressiveMobileWeight;
    m_config.m_aggressiveStationaryThreatWeight = pSystemsConfig->AggressiveStationaryWeight;
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    m_pDebugComponent = new CCSTargetRenderingComponent(pBB);
    m_pBrain->AddDebugRenderer(m_pDebugComponent);
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    pMeatPuppet->GetCharacter();
    ACCSController *pController = static_cast<CCSMeatPuppet *>(pMeatPuppet)->m_pCCSCtrl;
    pBB->m_team.Set(pMeatPuppet->GetTeam());
    pBB->SetHeatGenerated((float)pController->AIHeatValue);
    CCSNorman::getInstance()->AddTargeter(this);
    UpdateTargetListsByRange();
}

// @retail 0x83324718
void CCSPSTargetAwareness::Finalize()
{
    CCSNorman::getInstance()->RemoveTargeter(this);
    if (m_pDebugComponent)
    {
        delete m_pDebugComponent;
    }
}

// @retail 0x8335F660
void CCSPSTargetAwareness::Tick(float DeltaTime)
{
    m_pBrain->m_meatPuppet->GetCharacter();
    UpdateTargetListsByRange();
    UpdateTargetList();
    ComputeLowCostAwareness(DeltaTime);
    UpdateHighestThreatTarget(DeltaTime);
    UpdateCurrentTarget();
}

// @retail 0x833706C0
bool CCSPSTargetAwareness::TickBudget(float DeltaTime, int &Budget)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    int NumTargets = pBB->m_targets.Num();
    while (m_targetIdx < NumTargets && Budget > 0)
    {
        ComputeHighCostAwareness(DeltaTime, pBB->m_targets[m_targetIdx]);
        Budget--;
        m_targetIdx++;
    }
    while (m_vehicleIdx < pBB->m_Vehicles.Num() && Budget > 0)
    {
        ComputeHighCostAwareness(DeltaTime, pBB->m_Vehicles[m_vehicleIdx]);
        Budget--;
        m_vehicleIdx++;
    }
    UpdateLowestLKPAgeEnemy();
    UpdateClosestVisibleEnemy();
    if (m_targetIdx >= pBB->m_targets.Num() && m_vehicleIdx >= pBB->m_Vehicles.Num())
    {
        m_targetIdx = 0;
        m_vehicleIdx = 0;
    }
    return m_targetIdx == 0 && m_vehicleIdx == 0;
}

// @retail 0x83323488
bool CCSPSTargetAwareness::TargetPlayers()
{
    return m_config.m_targetSelection == CCS::TargetPlayer || m_config.m_targetSelection == CCS::TargetPlayerOrEnemy;
}

// @retail 0x83330AF0
bool CCSPSTargetAwareness::IsEnemy(CCSBlackboard *pBB, ICCSMeatPuppet *pMeatPuppet)
{
    return pBB->m_team.Get() != pMeatPuppet->GetTeam();
}

// @retail 0x83324770
bool CCSPSTargetAwareness::IsTargetHeard(const CCSTarget &Target, ICCSMeatPuppet *pMeatPuppet)
{
    return pMeatPuppet->HasHeardCharacter(Target.character);
}

// @retail 0x83324798
void CCSPSTargetAwareness::NotifyTargetBecameVisible(CCSTarget &)
{
    GripEvent Event;
    Event.type = s_enemyBecameVisible;
    Event.triggerTime = GripEngineServices::GetTimeSeconds();
    m_pBrain->OnGameEvent(Event);
}

// @retail 0x8333D7E0
void CCSPSTargetAwareness::UpdateClosestVisibleEnemy()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    CCSTarget *pClosest = 0;
    float ClosestRange = 3.402823466e+38F;
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        CCSTarget &Target = pBB->m_targets[i];
        if (Target.range2D < ClosestRange && Target.isVisible && Target.CurrentCamo() == 0.0f)
        {
            pClosest = &pBB->m_targets[i];
            ClosestRange = pClosest->range2D;
        }
    }
    pBB->SetClosestVisibleEnemy(pClosest);
}

// @retail 0x8333D8A0
void CCSPSTargetAwareness::UpdateLowestLKPAgeEnemy()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    CCSTarget *pLowest = 0;
    float LowestAge = 3.402823466e+38F;
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        CCSTarget &Target = pBB->m_targets[i];
        if (Target.LKPAge < LowestAge)
        {
            LowestAge = pBB->m_targets[i].LKPAge;
            pLowest = &pBB->m_targets[i];
        }
    }
    pBB->SetLowestLKPAgeEnemy(pLowest);
}

// @retail 0x83358178
void CCSPSTargetAwareness::UpdateTargetListsByRange()
{
    CCSMeatPuppet *pMeatPuppet = static_cast<CCSMeatPuppet *>(m_pBrain->m_meatPuppet);
    if (pMeatPuppet == 0)
    {
        return;
    }
    CCSCharacter Self = pMeatPuppet->GetCharacter();
    if (Self.GetActor() == 0)
    {
        return;
    }
    (void)Self.GetActor();  // an assertion's argument, evaluated in release builds too
    const float Radius = m_config.m_maxAwareRadius;
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    pBB->UpdateTargetListsByRange(Self.GetPosition(), Radius, (float)(Radius * 1.05));
}

// @retail 0x8333D5F0
bool CCSPSTargetAwareness::IsTargetVisible(const CCSTarget &Target, ICCSMeatPuppet *pMeatPuppet)
{
    if (Target.CurrentCamo() == 1.0f)
    {
        return false;
    }
    Grip_Vector Dir = Target.position - pMeatPuppet->GetCharacter().GetPosition();
    if (m_config.m_maxSightRadius > 0.0f && (Dir | Dir) > m_config.m_maxSightRadius * m_config.m_maxSightRadius)
    {
        return false;
    }
    Dir.Normalize();
    Grip_Vector Facing = pMeatPuppet->GetCharacter().m_gameCharacter.GetOrientation().Vector2D();
    const float Dot = Dir | Facing;
    const float BehindRadius = m_config.m_maxBehindSightRadius;
    return (Dot > m_config.m_visionCosineLimit || BehindRadius < 0.0f || Target.range2D < BehindRadius)
        && pMeatPuppet->HasLineOfSightTo(Target.character);
}

// near: retail adds the element offset to the array's base (add r31, r29,
// r11), ours the base to the offset; operator[], GetData()[i], the content
// pointer and a late reference all give ours
// @retail 0x833459A0
void CCSPSTargetAwareness::UpdateHighestThreatTarget(float DeltaTime)
{
    CCSTarget *pHighest = 0;
    int HighestThreat = 0;
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    if (pBB == 0)
    {
        return;
    }
    APawn *pPawn = static_cast<CCSMeatPuppet *>(m_pBrain->m_meatPuppet)->m_pUnPawn;
    if (pPawn == 0)
    {
        return;
    }
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        CCSTarget &Target = pBB->m_targets[i];
        float Weight;
        switch (Target.m_aiTargetType)
        {
        case AITargetType_PassiveObjective:
            Weight = pPawn->PassiveObjectiveWeight;
            break;
        case AITargetType_PassiveSecondary:
            Weight = pPawn->PassiveSecondaryWeight;
            break;
        case AITargetType_AggressiveMobile:
            Weight = pPawn->AggressiveMobileWeight;
            break;
        case AITargetType_AggressiveStationary:
            Weight = pPawn->AggressiveStationaryWeight;
            break;
        default:
            continue;
        }
        if (Weight <= 0.0f)
        {
            continue;
        }
        Target.currentThreat = ComputeTotalThreat(Target, DeltaTime) * Weight;
        if (Target.currentThreat > HighestThreat)
        {
            if (pBB->m_bHasBecomeAware.Get() || (Target.CurrentCamo() > 0.0f && pBB->GetHighestThreatTarget() == &Target)
                || ((Target.m_aiTargetType == AITargetType_PassiveObjective || Target.m_aiTargetType == AITargetType_PassiveSecondary)
                    && Target.pathResult == Kaim::ASTAR_DONE_PATH_FOUND))
            {
                pHighest = &Target;
                HighestThreat = (int)Target.currentThreat;
            }
        }
    }
    CCSTarget *pCurrent = pBB->GetHighestThreatTarget();
    if (pCurrent == 0 || pCurrent != pHighest)
    {
        pBB->SetHighestThreatTarget(pHighest);
        pBB->m_timeSinceThreatTargetChanged.Set(0.0f);
    }
}

// near: the forward dot product's first fmuls has its operands swapped
// (either operand order of operator|, a named Forward vector tried)
// @retail 0x8333DF70
void CCSPSTargetAwareness::UpdateCurrentTarget()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    if (pBB == 0 || pBB->m_currentTarget.Get() == 0 || pBB->m_currentTarget.Get()->character == CCSCharacter::NONE)
    {
        return;
    }
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    if (pTarget->CurrentCamo() > 0.0f && !m_curTargetIsCamoed)
    {
        m_curTargetIsCamoed = true;
        pBB->m_timeSinceTargetCamoed.Set(0.0f);
        pTarget->ResetAwareness();
    }
    else if (pTarget->CurrentCamo() == 0.0f)
    {
        m_curTargetIsCamoed = false;
    }
    Grip_Rotation Rotation = pMeatPuppet->GetCharacter().GetOrientation();
    Rotation.Yaw = (int)(Rotation.Yaw + 8191.998f);
    pTarget->position = pTarget->character.GetPosition();
    Grip_Vector Position = pMeatPuppet->GetCharacter().GetPosition();
    Grip_Vector Delta(pTarget->position.X - Position.X, pTarget->position.Y - Position.Y, 0.0f);
    pTarget->forwardDot = Rotation.Vector2D() | Delta;
    Rotation.Yaw = (int)(Rotation.Yaw + 16383.996f);
    pTarget->rightDot = Rotation.Vector2D() | Delta;
    if (pTarget->isVisible || pTarget->isHeard)
    {
        pTarget->LKP = pTarget->position;
        pTarget->LKPAge = 0.0f;
    }
}

// near: retail keeps the target's team in a saved register across
// GetTeamNum (r23, a bigger frame), stores CNTAge later, and adds the threat
// array's offset to its base when it rereads TotalDamageAmount (either
// operand order of the comparison and several accessors tried)
// @retail 0x8333D9D0
int CCSPSTargetAwareness::ComputeTotalThreat(CCSTarget &Target, float DeltaTime)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    int TotalThreat = 0;
    float CamoScale = 1.0f;
    ACCSController *pController = static_cast<CCSMeatPuppet *>(m_pBrain->m_meatPuppet)->m_pCCSCtrl;
    CCSTarget *pCurrentTarget = pBB->GetCurrentTarget();
    if (Target.character == CCSCharacter::NONE)
    {
        return 0;
    }
    AActor *pActor = (AActor *)Target.character.GetActor();
    if (pActor == 0)
    {
        return 0;
    }
    UUDKTargetableComponent *pTargetable = Target.character.GetTargetableComponent();
    if (Target.teamNum == -1)
    {
        Target.teamNum = pActor->GetTeamNum();
    }
    Target.position = Target.character.GetPosition();
    Target.CNTAge = DeltaTime + Target.CNTAge;
    Target.range2D = (Target.position - Grip_Vector(pController->Pawn->Location)).Size2D();
    Target.UpdateDestinationReachable();
    if (pActor->IsValid() && pTargetable != 0 && pController->Pawn != 0 && Target.teamNum != pController->Pawn->GetTeamNum())
    {
        const float OuterRadiusSq = pTargetable->OutterThreatRadius * pTargetable->OutterThreatRadius;
        const float InnerRadiusSq = pTargetable->InnerThreatRadius * pTargetable->InnerThreatRadius;
        Grip_Vector Delta = m_pBrain->m_meatPuppet->GetCharacter().GetPosition() - Target.position;
        const float DistanceSq = Delta.SizeSquared2D();
        if (DistanceSq < OuterRadiusSq)
        {
            const float BaseThreat = (float)pTargetable->BaseThreatVal;
            const float ModifiableThreat = pTargetable->ModifiableThreatPct * BaseThreat;
            const float HeatScale = (pTargetable->MaxAIHeat - pTargetable->CurAIHeat) / pTargetable->MaxAIHeat;
            const float HeightScale = Max(0.1f, (OuterRadiusSq - Abs(Delta.Z * Delta.Z)) / OuterRadiusSq);
            const float Threat = (BaseThreat - ModifiableThreat + HeatScale * ModifiableThreat) * HeightScale;
            const float Camo = Target.CurrentCamo();
            if (pCurrentTarget != 0 && pCurrentTarget != &Target && Camo > 0.0f)
            {
                CamoScale = 1.0f - Camo;
            }
            const float ScaledThreat = Threat * CamoScale;
            if (DistanceSq < InnerRadiusSq)
            {
                TotalThreat = (int)ScaledThreat;
            }
            else
            {
                TotalThreat = (int)((1.0f - (DistanceSq - InnerRadiusSq) / (OuterRadiusSq - InnerRadiusSq)) * ScaledThreat);
            }
        }
        for (int i = 0; i < pController->TotalEnemyThreat.Num(); i++)
        {
            AController *pInstigator = pController->TotalEnemyThreat(i).DamageInstigator;
            AActor *pDamager = pController->TotalEnemyThreat(i).DamagingActor;
            if ((pInstigator != 0 && pInstigator->Pawn == pActor) || (pDamager != 0 && pDamager == pActor))
            {
                TotalThreat += (int)(pController->TotalEnemyThreat(i).TotalDamageAmount * CamoScale);
            }
        }
    }
    return TotalThreat;
}
