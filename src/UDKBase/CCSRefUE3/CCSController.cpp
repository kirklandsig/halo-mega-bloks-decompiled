// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscontroller.cpp: the controller that runs a brain for its pawn.
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "../CCSRef/CCSCover.cpp"
#include "../CCSRef/CCSBlackboard.cpp"

// @retail 0x84289210
// `dynamic initializer for 's_brainFinderCCS''
// @retail 0x842C6548
// `dynamic atexit destructor for 's_brainFinderCCS''
static CCSBrainFinder s_brainFinderCCS;

// Todo (and RemoveState): retail constructs the string argument before it
// fetches the blackboard; ours fetches it first.
// @retail 0x83329C50
void ACCSController::SetState(const FString &State)
{
    Brain->GetBlackboard<CCSBlackboard>()->AddState(*State);
}

// @retail 0x83337990
void ACCSController::RemoveState(const FString &State)
{
    if (State == FString(""))
    {
        Brain->GetBlackboard<CCSBlackboard>()->ClearAllState();
        return;
    }
    Brain->GetBlackboard<CCSBlackboard>()->RemoveState(*State);
}

// @retail 0x83329CC0
void ACCSController::SetInitialCover(AActor *Cover)
{
    ACoverLink *Link = Cast<ACoverLink>(Cover);
    if (Brain != 0 && Link != 0 && Link->Slots.Num() != 0)
    {
        CCSCover InitialCover;
        InitialCover.m_state = CCS::CoverState_Valid;
        InitialCover.m_gameCover.m_coverInfo.Link = Link;
        Brain->GetBlackboard<CCSBlackboard>()->m_initialCover.Set(InitialCover);
    }
}

// @retail 0x83337A80
void ACCSController::SetDesiredPosition(AActor *Destination)
{
    if (Brain != 0 && Destination != 0)
    {
        CCSBlackboard *pBB = Brain->GetBlackboard<CCSBlackboard>();
        pBB->SetMoveCommand(Destination->Location);
    }
}

// @retail 0x83337B00
void ACCSController::ActuallySetDesiredPosition(FVector Destination)
{
    if (Brain != 0)
    {
        CCSBlackboard *pBB = Brain->GetBlackboard<CCSBlackboard>();
        pBB->SetMoveCommand(Destination);
    }
}

// @retail 0x833206E0
unsigned char ACCSController::GetTeamNum()
{
    return CCSTeam;
}

// @retail 0x833206F0
void ACCSController::HearNoise(AActor *NoiseMaker, float Loudness, FName NoiseType)
{
    if (HasHeardNoiseTimer <= 0.0f)
    {
        Super::HearNoise(NoiseMaker, Loudness, NoiseType);
        if (CanHear(NoiseMaker->Location, Loudness, NoiseMaker))
        {
            HasHeardNoise = 1;
            HasHeardNoiseTimer = 1.0f;
        }
    }
}

// @retail 0x83354D90
void ACCSController::BeginDestroy()
{
    DestroyBrain();
    Super::BeginDestroy();
}

// @retail 0x83354DC8
void ACCSController::PostScriptDestroyed()
{
    DestroyBrain();
    Super::PostScriptDestroyed();
}

// @retail 0x8334B1E0
void ACCSController::DestroyBrain()
{
    if (Brain != 0)
    {
        CCSBlackboard *pBB = Brain->GetBlackboard<CCSBlackboard>();
        if (pBB->GetHighestThreatTarget() != 0 && pBB->GetHighestThreatTarget()->character != CCSCharacter::NONE)
        {
            pBB->SetHighestThreatTarget(0);
        }
        Brain->Finalize();
        delete Brain;
        Brain = 0;
    }
    if (Pawn != 0)
    {
        Pawn->SetTickIsDisabled(0);
    }
    if (MeatPuppet != 0)
    {
        delete MeatPuppet;
        MeatPuppet = 0;
    }
    if (ScriptNodeCache != 0)
    {
        ScriptNodeCache->ScriptNodes.Reset();
    }
}

// @retail 0x83320788
void ACCSController::DisableBrain(unsigned int bDisable)
{
    if (Brain != 0)
    {
        Brain->Disable(bDisable != 0);
    }
}

// Near: retail zero-extends the collision component pointer (slwi 0) where
// ours computes the unused address of its bounds (a named reference to the
// bounds gets the length right; a reference to the extent loses 4 bytes).
// @retail 0x83329F30
void ACCSController::CalcAccuracyAngles(AActor *Target)
{
    if (Target == 0)
    {
        return;
    }
    UCylinderComponent *pCylinder = Cast<UCylinderComponent>(Target->CollisionComponent);
    float Height;
    float Radius;
    if (pCylinder != 0)
    {
        Radius = pCylinder->CollisionRadius;
        Height = pCylinder->CollisionHeight * 0.5f;
    }
    else if (Target->CollisionComponent != 0)
    {
        const FBoxSphereBounds &B = Target->CollisionComponent->Bounds;
        Radius = B.BoxExtent.Size2D();
        Height = B.BoxExtent.Z;
    }
    else
    {
        Height = 0.0f;
        Radius = 0.0f;
    }
    const float Distance = (Target->Location - Pawn->Location).Size2D();
    if (Distance > 0.0f)
    {
        const float InvDistance = 1.0f / Distance;
        const float RadiusRatio = InvDistance * Radius;
        AccuracyYaw = appAtan(HorizontalInaccuracy * RadiusRatio) * 114.591560f;
        DeadZoneYaw = appAtan(HorizontalAccurateZone * RadiusRatio) * 114.591560f;
        const float HeightRatio = InvDistance * Height;
        AccuracyPitch = appAtan(VerticalInaccuracy * HeightRatio) * 114.591560f;
        DeadZonePitch = appAtan(VerticalAccurateZone * HeightRatio) * 114.591560f;
    }
    else
    {
        AccuracyYaw = 0.0f;
        DeadZoneYaw = 0.0f;
        AccuracyPitch = 0.0f;
        DeadZonePitch = 0.0f;
    }
}

// @retail 0x8332A0A8
void ACCSController::AdjustFromWall(FVector HitNormal, AActor *HitActor)
{
    if (!bAdjustFromWalls)
    {
        return;
    }
    if (Pawn != 0 && MoveTarget != 0)
    {
        AInterpActor *pMover = Cast<AInterpActor>(HitActor);
        if (pMover != 0 && MoveTarget->HasAssociatedLevelGeometry(pMover))
        {
            ANavigationPoint *pNav = Cast<ANavigationPoint>(MoveTarget);
            if (pNav != 0 && pNav->bSpecialMove)
            {
                pNav->eventSuggestMovePreparation(Pawn);
            }
            return;
        }
    }
    if (!bAdjusting)
    {
        Pawn->SerpentineDir *= -1.0f;
        if (Pawn->PickWallAdjust(HitNormal, HitActor))
        {
            return;
        }
    }
    FailMove();
    FailedMoveTarget = MoveTarget;
}

// @retail 0x83329D80
void ACCSController::TriggerEvent(const FString &EventName)
{
    GripEvent Event;
    {
        Grip::String Type(*EventName);
        Event.type = Type;
    }
    Event.triggerTime = GWorld->GetTimeSeconds();
    Brain->OnGameEvent(Event);
}

// @retail 0x8332A1D8
void ACCSController::UpdatePawnRotation()
{
    if (Pawn == 0 || Pawn->Physics != PHYS_Walking)
    {
        return;
    }
    if (AimingFocus == 0)
    {
        UpdateOnlyPawnRotation();
        AimingRot = Rotation;
        return;
    }
    FVector AimLocation = AimingFocus->GetPawnViewLocation();
    AUDKPawn *pTarget = Cast<AUDKPawn>(AimingFocus);
    if (pTarget != 0 && pTarget->Camo == 1.0f)
    {
        AimLocation = pTarget->CamoVanishingPoint;
    }
    AimingRot = (AimLocation - Pawn->eventGetWeaponStartTraceLocation(0)).Rotation();
    AimingRot.Roll = 0;
    const FRotator AimDelta = AimingRot - Pawn->Rotation;
    if (!CCSPawn->CanAim(AimDelta))
    {
        Focus = AimingFocus;
        UpdateOnlyPawnRotation();
    }
}

// @retail 0x8332A3A0
void ACCSController::UpdateOnlyPawnRotation()
{
    if (Focus != 0)
    {
        ANavigationPoint *pNav = Cast<ANavigationPoint>(Focus);
        if (pNav != 0 && CurrentPath != 0 && CurrentPath->Start != 0 && MoveTarget == pNav && !Pawn->Velocity.IsZero())
        {
            if (Pawn->IsGlider())
            {
                const unsigned int bOffsetFromBase = bAdjusting || Focus->Base == Pawn->Base;
                SetFocalPoint(bAdjusting ? GetAdjustLocation() : Focus->Location, bOffsetFromBase);
            }
            else
            {
                SetFocalPoint(Pawn->Location + (Focus->Location - CurrentPath->Start->Location), Focus->Base == Pawn->Base);
            }
        }
        else
        {
            AUDKPawn *pTarget = Cast<AUDKPawn>(Focus);
            if (pTarget != 0 && pTarget->Camo == 1.0f)
            {
                SetFocalPoint(pTarget->CamoVanishingPoint, Focus->Base == Pawn->Base);
            }
            else
            {
                SetFocalPoint(Focus->Location, Focus->Base == Pawn->Base);
            }
        }
    }
    const FVector FocalPoint = GetFocalPoint();
    if (!FocalPoint.IsZero())
    {
        Pawn->rotateToward(FocalPoint);
    }
}

// @retail 0x8332A628
void ACCSController::DrawHUD(GripHUDRenderer *pRenderer, int &Y)
{
    const Grip_Color TitleColor(255, 102, 0);
    const Grip_Color Color(0, 255, 0);
    pRenderer->DrawString(10, Y, "Animation Flags", TitleColor);
    Y += pRenderer->endl;
    const char *MovementTypeNames[] = {"Idle", "Walk", "Run"};
    pRenderer->DrawString(18, Y, "Movement Type:", Color);
    pRenderer->DrawString(255, Y, MovementTypeNames[CCSPawn->GetMovementType()], Color);
    Y += pRenderer->endl;
    const char *AlertnessNames[] = {"Relax", "Alert"};
    pRenderer->DrawString(18, Y, "Alertness:", Color);
    pRenderer->DrawString(255, Y, AlertnessNames[CCSPawn->GetAlertness()], Color);
    Y += pRenderer->endl;
    const char *PostureNames[] = {"Stand", "Crouch"};
    pRenderer->DrawString(18, Y, "Posture:", Color);
    pRenderer->DrawString(255, Y, PostureNames[CCSPawn->IsCrouched()], Color);
    Y += pRenderer->endl;
}

// @retail 0x83354AB8
void ACCSController::TakePossession()
{
    FVector Tether = Pawn->Location;
    if (Brain != 0)
    {
        Tether = Brain->GetBlackboard<CCSBlackboard>()->m_currentTether.Get();
    }
    DestroyBrain();
    if (CCSPawn->GetDefaultBehaviorTree() != 0)
    {
        BehaviorTreeTemplate = CCSPawn->GetDefaultBehaviorTree();
    }
    if (BehaviorTreeTemplate == 0)
    {
        return;
    }
    if (SystemConfig.MaxHearingRadius >= 0.0f)
    {
        Pawn->HearingThreshold = SystemConfig.MaxHearingRadius;
    }
    else
    {
        SystemConfig.MaxHearingRadius = Pawn->HearingThreshold;
    }
    if (SystemConfig.MaxSightRadius >= 0.0f)
    {
        Pawn->SightRadius = SystemConfig.MaxSightRadius;
    }
    else
    {
        SystemConfig.MaxSightRadius = Pawn->SightRadius;
    }
    if (SystemConfig.MaxAwareRadius >= 0.0f)
    {
        Pawn->AwareRadius = SystemConfig.MaxAwareRadius;
    }
    else
    {
        SystemConfig.MaxAwareRadius = Pawn->AwareRadius;
    }
    MeatPuppet = new CCSMeatPuppet;
    MeatPuppet->m_pUnPawn = Pawn;
    MeatPuppet->m_pCCSPawn = (ICCSPawn *)CCSPawn.GetInterface();
    MeatPuppet->m_pCCSCtrl = this;
    BTInterface->Blackboard = ConstructObject<UCCSBlackboard>(UCCSBlackboard::StaticClass(), BTInterface);
    USSBrainBuilder Builder;
    Builder.ConstructBrain(this, BehaviorTreeTemplate, MeatPuppet, &SystemConfig, BTInterface, ScriptNodeCache);
    Brain = Builder.CookBrain();
    if (Brain != 0)
    {
        Brain->GetBlackboard<CCSBlackboard>()->m_currentTether.Set(Tether);
    }
    GripEngineServices::GetAIManager()->AddBrainFinder(&s_brainFinderCCS);
}

// Todo (1,328 bytes vs 1,376): the code is retail's, but retail inlines both
// FVector::Normalize calls, which ours calls out of line (CCSAFStrafeTarget
// calls it out of line in retail, so it isn't FORCEINLINE). With it forced
// inline, the eye position still lands in another stack slot (retail reuses
// it for the facing copy, which it takes from FRotator::Vector's result).
// @retail 0x83337BB0
unsigned int ACCSController::Tick(float DeltaTime, ELevelTick TickType)
{
    Super::Tick(DeltaTime, TickType);
    static float ThreatDecayTimer = 0.0f;
    ThreatDecayTimer += DeltaTime;
    if (ThreatDecayTimer > ThreatDecayTime)
    {
        ThreatDecayTimer -= ThreatDecayTime;
        for (int i = 0; i < TotalEnemyThreat.Num(); i++)
        {
            if (TotalEnemyThreat(i).TotalDamageAmount > 0)
            {
                TotalEnemyThreat(i).TotalDamageAmount -= ThreatDecayAmount;
                if (TotalEnemyThreat(i).TotalDamageAmount < 0)
                {
                    TotalEnemyThreat(i).TotalDamageAmount = 0;
                }
            }
        }
    }
    if (HasHeardNoiseTimer > 0.0f)
    {
        HasHeardNoiseTimer -= DeltaTime;
        if (HasHeardNoiseTimer <= 0.0f)
        {
            HasHeardNoiseTimer = 0.0f;
            HasHeardNoise = 0;
        }
    }
    if (Brain == 0)
    {
        return 1;
    }
    if (Pawn != 0)
    {
        if (Brain->GetBlackboard<CCSBlackboard>()->GetCurrentTarget() != 0)
        {
            const FVector LKP = Brain->GetBlackboard<CCSBlackboard>()->GetCurrentTarget()->LKP;
            const Grip_Vector Position = Brain->GetBlackboard<CCSBlackboard>()->GetCurrentTarget()->character.GetPosition();
            const Grip_Vector Eyes = Brain->GetBlackboard<CCSBlackboard>()->GetCurrentTarget()->character.GetEyesPosition();
            const FVector AimPoint = FVector(Eyes - Position) + LKP;
            const FVector AimDir = AimPoint - Pawn->GetPawnViewLocation();
            if (Pawn->IsA(AGwNavPawn::StaticClass()))
            {
                FVector Dir = AimDir;
                FVector Facing = Pawn->Rotation.Vector();
                FVector Facing2D(Facing.X, Facing.Y, 0.0f);
                Facing2D.Normalize(1.e-8f);
                FVector Dir2D(Dir.X, Dir.Y, 0.0f);
                Dir2D.Normalize(1.e-8f);
                if ((Dir2D | Facing2D) >= 0.5f)
                {
                    DesiredRot = AimDir.Rotation();
                }
                else
                {
                    DesiredRot = Pawn->Rotation;
                }
            }
        }
        else
        {
            DesiredRot = Pawn->Rotation;
        }
        DesiredRot.Roll = 0;
        SetRotation(RInterpTo(Rotation, DesiredRot, DeltaTime, (float)RotationRate.Yaw, 1));
        if (TickType == LEVELTICK_All && !Brain->IsDisabled())
        {
            Brain->Tick(DeltaTime);
        }
    }
    if (Brain->IsDebug())
    {
        if (DebugVizComponent == 0)
        {
            eventCreateDebugVizComponent();
        }
        DebugVizComponent->bNeedsReattach = 1;
    }
    else if (DebugVizComponent != 0)
    {
        DetachComponent(DebugVizComponent);
        DebugVizComponent = 0;
    }
    return 1;
}
