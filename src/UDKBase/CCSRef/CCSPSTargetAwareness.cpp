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
    CCSBlackboard &BB = *pBB;
    APawn *pPawn = static_cast<CCSMeatPuppet *>(m_pBrain->m_meatPuppet)->m_pUnPawn;
    if (pPawn == 0)
    {
        return;
    }
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        CCSTarget &Target = BB.m_targets[i];
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
    const float DeltaX = pTarget->position.X - Position.X;
    const float DeltaY = pTarget->position.Y - Position.Y;
    Grip_Vector Delta(DeltaX, DeltaY, 0.0f);
    pTarget->forwardDot = Rotation.Vector2D() | Delta;
    Rotation.Yaw = (int)(Rotation.Yaw + 16383.996f);
    pTarget->rightDot = Rotation.Vector2D() | Delta;
    if (pTarget->isVisible || pTarget->isHeard)
    {
        pTarget->LKP = pTarget->position;
        pTarget->LKPAge = 0.0f;
    }
}

// score 2 (was 2): the CNTAge sum has its operands the other way round
// (retail fadds f13, f31, f0; ours f13, f0, f31); the float constant is a
// relocation and masked. The XDK puts the operand loaded from memory first in
// every spelling tried (the member read directly, in a local or a temporary,
// read and stored in one expression, +=, a cast, x * 1, a helper, the
// statement moved), and retail has the age second; only a load through a
// global pointer keeps the parameter first. Reading and storing the age
// through a pointer or a reference turns the sum but also turns the six array
// index adds of the damage loop (7 or 8): they are one decision of the XDK's
// commutative ordering. Also worse: volatile (29), a pointer to member (44),
// the loop index in a local (331).
// This session: re-checked at the baseline (2), no spelling of the sum moves
// the operand order; the shared operator[] spellings that would change it
// break the other functions (see below), so the two words stay.
// @retail 0x8333D9D0
#line 319
int CCSPSTargetAwareness::ComputeTotalThreat(CCSTarget &Target, float DeltaTime)
{
    CCSBlackboard * pBB = m_pBrain->GetBlackboard < CCSBlackboard >();
    float CamoScale;
    const CCSTarget * pCurrentTarget;
    CamoScale = (float)(1.0f);
    const ACCSController * pController;
    int TotalThreat;
    TotalThreat = 0;
    pController = (ACCSController *)(static_cast < CCSMeatPuppet * >(m_pBrain->m_meatPuppet)->m_pCCSCtrl);
    auto permTemp11 = pBB->GetCurrentTarget();
    pCurrentTarget = permTemp11;
    if (Target.character == CCSCharacter::NONE)
    {
        return 0;
    }
    auto permTemp14 = Target.character.GetActor();
    AActor * const pActor = (AActor *) permTemp14;
    if ((pActor == 0))
    {
        return 0;
    }
    const UUDKTargetableComponent * const pTargetable = (UUDKTargetableComponent *)(((Target.character.GetTargetableComponent())));
    if ((bool)(Target.teamNum == - 1))
    {
        Target.teamNum = pActor->GetTeamNum();
    }
    Target.position = (Target.character.GetPosition());
    auto permTemp4 = Grip_Vector(pController->Pawn->Location);
    Target.range2D = ((Target.position - permTemp4).Size2D());
    auto permTemp18 = (Target.CNTAge) + DeltaTime;
    Target.CNTAge = ((permTemp18));
    Target.UpdateDestinationReachable();
    if ((pActor->IsValid()) && 0 != pTargetable && pController->Pawn != 0)
    {
        int TargetTeamNum = Target.teamNum;
        if (TargetTeamNum != pController->Pawn->GetTeamNum())
        {
            const float OuterRadiusSq = pTargetable->OutterThreatRadius * pTargetable->OutterThreatRadius;
            float InnerRadiusSq = pTargetable->InnerThreatRadius * pTargetable->InnerThreatRadius;
            const Grip_Vector Delta = (Grip_Vector)(((((m_pBrain->m_meatPuppet->GetCharacter().GetPosition()) - Target.position))));
            float DistanceSq;
            DistanceSq = Delta.SizeSquared2D();
            if (DistanceSq < OuterRadiusSq)
            {
                float BaseThreat;
                BaseThreat = (float) pTargetable->BaseThreatVal;
                float ModifiableThreat = pTargetable->ModifiableThreatPct * BaseThreat;
                float Threat;
                auto permTemp17 = Delta.Z * Delta.Z;
                const auto permTemp9 = (OuterRadiusSq - Abs(permTemp17)) / OuterRadiusSq;
                float Camo;
                Threat = (float)((Max(0.1f, permTemp9)) * (BaseThreat - ModifiableThreat + ((pTargetable->MaxAIHeat - pTargetable->CurAIHeat) / pTargetable->MaxAIHeat) * ModifiableThreat));
                Camo = (float)((((Target.CurrentCamo()))));
                if (pCurrentTarget != 0 && pCurrentTarget != & Target && Camo > 0.0f)
                {
                    auto permTemp16 = (((1.0f))) - (((Camo)));
                    CamoScale = permTemp16;
                }
                float ScaledThreat = CamoScale * Threat;
                if (((((((((((((DistanceSq < InnerRadiusSq)))))))))))))
                {
                    TotalThreat = (((((((((((((int) ScaledThreat))))))))))));
                }
                else
                {
                    const auto permTemp12 = 1.0f - (DistanceSq - InnerRadiusSq) / ((OuterRadiusSq - InnerRadiusSq));
                    TotalThreat = (((((((((((((int)(ScaledThreat * (permTemp12))))))))))))));
                }
            }
            {
                {
                    {
                        {
                            {
                                int i;
                                {
                                    {
                                        i = 0;
                                        while (i < pController->TotalEnemyThreat.Num())
                                        {
                                            const AController * const pInstigator = (AController *)((pController->TotalEnemyThreat(i).DamageInstigator));
                                            const AActor * pDamager = pController->TotalEnemyThreat(i).DamagingActor;
                                            if ((0 != pInstigator && pInstigator->Pawn == pActor) || (0 != pDamager && pDamager == pActor))
                                            {
                                                TotalThreat = (((int)((pController->TotalEnemyThreat(i).TotalDamageAmount * CamoScale)))) + TotalThreat;
                                            }
                                            i += 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return TotalThreat;
}
#line 388

// @retail 0x83357230
void CCSPSTargetAwareness::UpdateTargetList()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    m_vehicles.Reset();
    if (TargetPlayers())
    {
        CCSEngineServices::FindAllVehicles(m_vehicles);
    }
    for (int i = 0; i < pBB->m_Vehicles.Num(); i++)
    {
        CCSCharacter Vehicle = pBB->m_Vehicles[i].character;
        bool bFound = false;
        for (int j = m_vehicles.Num() - 1; j >= 0; j--)
        {
            if (Vehicle == m_vehicles[j])
            {
                m_vehicles[j] = CCSCharacter::NONE;
                bFound = true;
                break;
            }
        }
        if (!bFound && !(Vehicle == pMeatPuppet->GetCharacter()))
        {
            pBB->OnVehicleDestroyed(i);
        }
    }
    for (int i = 0; i < m_vehicles.Num(); i++)
    {
        if (m_vehicles[i] == CCSCharacter::NONE)
        {
            continue;
        }
        if (m_vehicles[i].GetTeam() == pBB->m_team.Get())
        {
            CCSTarget Target(m_pBrain);
            Target.character = m_vehicles[i];
            pBB->OnNewVehicle(Target);
        }
    }
}

// @retail 0x83357608
void CCSPSTargetAwareness::AddThreatTarget(AActor *pActor)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    if (pActor == pMeatPuppet->GetCharacter().m_gameCharacter.GetActor())
    {
        return;
    }
    for (int i = 0; i < pBB->m_OutRangeThreatTargets.Num(); i++)
    {
        CCSCharacter Character = pBB->m_OutRangeThreatTargets[i].character;
        if (Character.m_gameCharacter.m_actor == pActor)
        {
            return;
        }
    }
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        CCSCharacter Character = pBB->m_targets[i].character;
        if (Character.m_gameCharacter.m_actor == pActor)
        {
            return;
        }
    }
    for (int i = 0; i < pBB->m_friendlies.Num(); i++)
    {
        CCSCharacter Character = pBB->m_friendlies[i].character;
        if (Character.m_gameCharacter.m_actor == pActor)
        {
            return;
        }
    }
    CCSCharacter Character;
    Character.m_gameCharacter.m_actor = pActor;
    UUDKTargetableComponent *pTargetable = Cast<UUDKTargetableComponent>(pActor->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
    if (pTargetable == 0 || !pActor->IsValid() || pActor->IsPendingKill())
    {
        return;
    }
    CCSTarget Target(m_pBrain);
    Target.character = Character;
    switch (pTargetable->AITargetType)
    {
    case 1:
        Target.m_aiTargetType = AITargetType_PassiveObjective;
        break;
    case 2:
        Target.m_aiTargetType = AITargetType_PassiveSecondary;
        break;
    case 3:
        Target.m_aiTargetType = AITargetType_AggressiveStationary;
        break;
    case 4:
        Target.m_aiTargetType = AITargetType_AggressiveMobile;
        break;
    }
    if (pBB->m_team.Get() != pActor->GetTeamNum())
    {
        pBB->OnNewThreatTarget(Target);
    }
    else if (pActor != pMeatPuppet->GetCharacter().m_gameCharacter.GetActor())
    {
        pBB->OnNewFriendly(Target);
    }
}

// score 1 (was 1): retail adds the element's offset to the array's base (add
// r11, r11, r31) and ours the base to the offset, in the inlined
// Grip_Array::DestructItems of the removal; the standalone DestructItems and
// RemoveItemSwap and the other inlined copies match, and the move of the last
// friendly has the other order in both. Tried by both lanes, none changes the
// order: operator[], GetData()[i], GetData() + i, a typed or char* pointer,
// the offset or index in a local (some change the code), unsigned or
// hand-scaled indexes, the element read directly or through a reference or a
// pointer, the blackboard or the array through a reference, the shared
// DestructItems, operator[] and AddItem in many spellings, and a ten-minute
// permuter run. (UCCSBlackboard::GetCovers matched the same kind of add by
// reading the blackboard through a reference in its loop.)
// This session: the difference is in the copy of Grip_Array::DestructItems
// inlined from CCSBlackboard::OnFriendlyDestroyed (the two copies inlined
// from OnThreatTargetDestroyed keep the other order and match); the add uses
// the same registers in both, so it is the XDK's commutative ordering of the
// inline expansion, not the spelling of the address. Calling the removal in
// this file instead (m_friendlies.RemoveItemSwap plus UpdateTargetPointers)
// does not compile: UpdateTargetPointers is private. The shared operator[]
// as pointer arithmetic (both const and non-const) leaves this at 1 but
// breaks ComputeTotalThreat (2 to 8), UpdateTargetList (matched to 3) and
// ComputeLowCostAwareness (5 to 11), so the header stays as it is.
// @retail 0x833579B8
void CCSPSTargetAwareness::RemoveThreatTarget(AActor *pActor)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    if (pActor == m_pBrain->m_meatPuppet->GetCharacter().m_gameCharacter.GetActor())
    {
        return;
    }
    bool bRemoved = false;
    if (pBB->GetHighestThreatTarget() != 0
        && (pBB->GetHighestThreatTarget()->character.m_gameCharacter.m_actor == pActor || pBB->GetHighestThreatTarget()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetHighestThreatTarget(0);
    }
    if (pBB->GetClosestEnemy() != 0
        && (pBB->GetClosestEnemy()->character.m_gameCharacter.m_actor == pActor || pBB->GetClosestEnemy()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetClosestEnemy(0);
    }
    if (pBB->GetClosestVisibleEnemy() != 0
        && (pBB->GetClosestVisibleEnemy()->character.m_gameCharacter.m_actor == pActor
            || pBB->GetClosestVisibleEnemy()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetClosestVisibleEnemy(0);
    }
    if (pBB->GetCurrentTarget() != 0
        && (pBB->GetCurrentTarget()->character.m_gameCharacter.m_actor == pActor || pBB->GetCurrentTarget()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetCurrentTarget(0);
    }
    if (pBB->GetLowestLKPAgeEnemy() != 0
        && (pBB->GetLowestLKPAgeEnemy()->character.m_gameCharacter.m_actor == pActor || pBB->GetLowestLKPAgeEnemy()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetLowestLKPAgeEnemy(0);
    }
    if (pBB->GetClosestObjective() != 0
        && (pBB->GetClosestObjective()->character.m_gameCharacter.m_actor == pActor || pBB->GetClosestObjective()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetClosestObjective(0);
    }
    if (pBB->GetReactiveTarget() != 0
        && (pBB->GetReactiveTarget()->character.m_gameCharacter.m_actor == pActor || pBB->GetReactiveTarget()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetReactiveTarget(0);
    }
    if (pBB->GetSecondaryTarget() != 0
        && (pBB->GetSecondaryTarget()->character.m_gameCharacter.m_actor == pActor || pBB->GetSecondaryTarget()->character.m_gameCharacter.m_pawn == pActor))
    {
        pBB->SetSecondaryTarget(0);
    }
    for (int i = 0; i < pBB->m_OutRangeThreatTargets.Num(); i++)
    {
        CCSCharacter Character = pBB->m_OutRangeThreatTargets[i].character;
        if (Character.m_gameCharacter.m_actor == pActor || Character.m_gameCharacter.m_pawn == pActor)
        {
            pBB->OnThreatTargetDestroyed(i);
            bRemoved = true;
            break;
        }
    }
    if (!bRemoved)
    {
        for (int i = 0; i < pBB->m_targets.Num(); i++)
        {
            CCSCharacter Character = pBB->m_targets[i].character;
            if (Character.m_gameCharacter.m_actor == pActor || Character.m_gameCharacter.m_pawn == pActor)
            {
                pBB->OnThreatTargetDestroyed(pBB->m_OutRangeThreatTargets.Num() + i);
                bRemoved = true;
                break;
            }
        }
    }
    if (!bRemoved)
    {
        for (int i = 0; i < pBB->m_friendlies.Num(); i++)
        {
            CCSCharacter Character = pBB->m_friendlies[i].character;
            if (Character.m_gameCharacter.m_actor == pActor || Character.m_gameCharacter.m_pawn == pActor)
            {
                pBB->OnFriendlyDestroyed(i);
                bRemoved = true;
                break;
            }
        }
    }
    if (bRemoved && pBB->m_targets.Num() == 0)
    {
        pBB->SetHasBecomeAware(false);
        pBB->m_timeSinceLostAware.Set(0.0f);
    }
}

// near: saved registers are assigned in another order (the meat puppet in
// r30, zero in r28), the trace distance squares X first, and isAware's or
// takes bAware without masking it (the comparison's operand order, a
// distance written out and an int flag tried; a direct assignment shifts the
// code, and | keeps the same code)
// This session: the permuter ran for ten minutes over the whole function and
// helped nothing (base score 51); the pragma that silences the bool/int
// warning with an int flag gives 54, and the reorderings of the team test,
// the pawn, the query and the heard/visible calls all keep 51.
// @retail 0x8336F5E0
void CCSPSTargetAwareness::ComputeHighCostAwareness(float, CCSTarget &Target)
{
    if (Target.character.GetActor() == 0)
    {
        return;
    }
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    m_pBrain->GetMeatPuppetQuery<IGripMeatPuppetQuery>();
    Target.isBehindCover = false;
    const bool bWasVisible = Target.isVisible;
    Target.isHeard = IsTargetHeard(Target, pMeatPuppet);
    Target.isVisible = IsTargetVisible(Target, pMeatPuppet);
    if (!Target.isVisible)
    {
        APawn *pPawn = pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn;
        AActor *pTargetActor = (AActor *)Target.character.GetActor();
        if (pPawn != 0 && pTargetActor != 0 && rand() * (1.0f / 32767.0f) < pPawn->ChanceToFireAtTargetsBehindCover)
        {
            const float EyeHeight = pPawn->BaseEyeHeight;
            FVector Start(pPawn->Location.X, pPawn->Location.Y, pPawn->Location.Z + EyeHeight);
            FVector End(pTargetActor->Location.X, pTargetActor->Location.Y, pTargetActor->Location.Z + EyeHeight);
            FCheckResult Hit;
            GWorld->SingleLineCheck(Hit, pPawn, End, Start, 0x209F, FVector(0, 0, 0), 0);
            if (Hit.Actor != 0 && Cast<UUDKTargetableComponent>(Hit.Actor->GetComponentOfType(UUDKTargetableComponent::StaticClass())) != 0)
            {
                const float Distance = (Start - End).Size();
                const float HitDistance = Hit.Time * Distance;
                if (Distance - HitDistance < HitDistance)
                {
                    Target.isBehindCover = true;
                }
            }
        }
    }
    if (!bWasVisible && Target.isVisible)
    {
        NotifyTargetBecameVisible(Target);
    }
    bool bAware = false;
    if (Target.isVisible || Target.isHeard)
    {
        if (pMeatPuppet->GetTeam() != Target.character.GetTeam())
        {
            bAware = true;
        }
    }
    Target.isAware |= bAware;
    if (!pBB->m_bHasBecomeAware.Get() && Target.isAware)
    {
        BecomeAware(true);
    }
    AActor *pActor = Target.character.m_gameCharacter.m_pawn != 0 ? Target.character.m_gameCharacter.m_pawn : Target.character.m_gameCharacter.m_actor;
    if (pActor != 0)
    {
        Target.character.m_gameCharacter.m_cachedTeamNum = pActor->GetTeamNum();
    }
    if (Target.currentThreat > 0.0f && Target.CNTAge > 4.0f && Target.character.GetActor() != 0)
    {
        Grip_Vector Destination = Target.position;
        APawn *pTargetPawn = (APawn *)Target.character.GetActor();
        if (pTargetPawn != 0)
        {
            Destination = pTargetPawn->GetNavAdjustedLocation(m_pBrain->m_meatPuppet->GetCharacter().GetPosition(), 1.1f);
        }
        Target.FindDestinationReachable(Destination);
    }
}

// score 5 (was 6): the friendly limit's comparison (retail fcmpu f8, f7 with
// bge; ours fcmpu f7, f8 with ble) and three masked pre-link displacements.
// The limit's sum matches since RadiusSq is named before the distance. The
// comparison keeps its operands' order and only the branch follows the
// operator: retail's compare wants the ratio first with >=, which moves the
// stores of the threat position copy (Z before Y in retail) and costs 6 to 9
// more. Tried by both lanes: the comparison negated, reversed, in
// parentheses, through temporaries or locals, the tests nested or reordered,
// '>', the dot test last, the flags swapped, the copy through a local, by
// fields (134) or read earlier, the range through a local or without
// parentheses, the subtraction and the threshold's division and
// multiplication reversed, and a ten-minute permuter run.
// This session: re-checked at the baseline (5); the comparison cannot be
// turned without moving the three stores of the position copy, and the
// shared operator[] spellings that touch the addresses only make it worse
// (5 to 11), so the source stays as it is.
// @retail 0x8333CD70
void CCSPSTargetAwareness::ComputeLowCostAwareness(float DeltaTime)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    int i = 0;
    while (i < pBB->m_targets.Num())
    {
        CCSTarget &Target = pBB->m_targets[i];
        const Grip_Vector Position = Target.character.GetPosition();
        Target.position = Position;
        Target.range2D = (Target.position - pMeatPuppet->GetCharacter().GetPosition()).Size2D();
        if (!Target.isVisible)
        {
            Target.LKPAge = DeltaTime + Target.LKPAge;
        }
        if (Target.isVisible || Target.isHeard)
        {
            Target.LKPAge = 0.0f;
            Target.LKP = Target.position;
        }
        Target.canShoot = Target.isVisible;
        Target.ClearOfFriendlies = true;
        if (pBB->m_friendlies.Num() > 0)
        {
            Grip_Vector Eyes = Target.character.GetEyesPosition();
            const Grip_Vector Weapon = pMeatPuppet->GetWeaponStartPosition();
            Grip_Vector Direction = Eyes - Weapon;
            const float Radius = pMeatPuppet->GetCharacter().GetSize() * 2.0f;
            const float RadiusSq = Radius * Radius;
            const float DistanceSq = Direction.SizeSquared2D();
            if (DistanceSq > RadiusSq)
            {
                const float Limit = DistanceSq + RadiusSq;
                const float Ratio = DistanceSq / Limit;
                for (int j = 0; j < pBB->m_friendlies.Num(); j++)
                {
                    Grip_Vector FriendDirection = pBB->m_friendlies[j].character.GetEyesPosition() - Weapon;
                    const float FriendDistanceSq = (float)(FriendDirection.SizeSquared2D());
                    if (FriendDistanceSq >= Limit)
                    {
                        continue;
                    }
                    const float Dot = FriendDirection | Direction;
                    if (0.0f < Dot && 0.75f + (Ratio - 0.75f) / DistanceSq * FriendDistanceSq <= Dot * Dot / (FriendDistanceSq * DistanceSq))
                    {
                        Target.canShoot = false;
                        Target.ClearOfFriendlies = false;
                        break;
                    }
                }
            }
        }
        i += 1;
    }
    for (int i = 0; i < pBB->m_Vehicles.Num(); i++)
    {
        CCSTarget &Vehicle = pBB->m_Vehicles[i];
        AUDKVehicle *pVehicle = 0;
        if (Vehicle.character.GetActor() == 0)
        {
            continue;
        }
        if (((AActor *)Vehicle.character.GetActor())->IsA(AUDKVehicle::StaticClass()))
        {
            pVehicle = (AUDKVehicle *)Vehicle.character.GetActor();
        }
        Vehicle.position = Vehicle.character.GetPosition();
        Vehicle.range2D = ((Vehicle.position - pMeatPuppet->GetCharacter().GetPosition()).Size2D());
        if (pVehicle != 0)
        {
            Vehicle.isAvailableVehicle = pVehicle->Seats(0).SeatPawn == 0 || pVehicle->Seats(0).SeatPawn->Controller == 0;
        }
        if (!Vehicle.isVisible)
        {
            Vehicle.LKPAge = DeltaTime + Vehicle.LKPAge;
        }
    }
    if (pBB->GetHighestThreatTarget() != 0)
    {
        CCSTarget *pTarget = pBB->GetHighestThreatTarget();
        if (pTarget->character != CCSCharacter::NONE)
        {
            const Grip_Vector ThreatPosition = pTarget->character.GetPosition();
            pTarget->position = ThreatPosition;
            const Grip_Vector Position = pMeatPuppet->GetCharacter().GetPosition();
            const float DeltaX = pTarget->position.X - Position.X;
            const float DeltaY = (float)((pTarget->position.Y - Position.Y));
            pTarget->range2D = appSqrt(DeltaX * DeltaX + DeltaY * DeltaY);
        }
        if ((bool)(!pTarget->isVisible))
        {
            pTarget->LKPAge = DeltaTime + pTarget->LKPAge;
        }
    }
}
