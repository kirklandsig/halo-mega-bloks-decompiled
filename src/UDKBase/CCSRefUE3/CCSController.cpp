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

// Retail builds the Grip::String argument before it fetches the blackboard;
// returning the string by value from a helper makes the compiler do so.
static inline Grip::String MakeStateString(const wchar_t *Text)
{
    return Grip::String(Text);
}

// The empty state: returning it by value makes the compiler keep it in the
// frame instead of taking the constructor's returned pointer.
static inline FString MakeEmptyStateString()
{
    return FString("");
}

// The retail inlines FVector::Normalize; the header only marks it inline, so
// the compiler is free to leave it out of line. Force it in.
static __forceinline void NormalizeVector(FVector &V)
{
    V.Normalize(1.e-8f);
}

// @retail 0x83329C50
void ACCSController::SetState(const FString &State)
{
    Brain->GetBlackboard<CCSBlackboard>()->AddState(MakeStateString(*State));
}

// Todo (252 bytes vs 236): retail reads the temporary FString back from the
// frame and frees only its data (UE3's FString), ours inlines
// ~TArray/~ForAnyElementType, which also zeroes the fields, and takes the
// constructor's result from r3 instead of the frame.
// @retail 0x83337990
void ACCSController::RemoveState(const FString &State)
{
    if (State == MakeEmptyStateString())
    {
        Brain->GetBlackboard<CCSBlackboard>()->ClearAllState();
        return;
    }
    Brain->GetBlackboard<CCSBlackboard>()->RemoveState(MakeStateString(*State));
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
        // a reference to the member: retail forms the bounds address in 64 bits
        UPrimitiveComponent *&pComp = Target->CollisionComponent;
        Radius = pComp->Bounds.BoxExtent.Size2D();
        Height = pComp->Bounds.BoxExtent.Z;
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

// Retail copies the facing vector out of the pointer FRotator::Vector
// returns, so the copy is taken through the call's result and the slot the
// rotation call returns into is the one the vector came from. Assigning the
// vector in a separate statement from its declaration keeps the result in a
// register of its own, which is what makes the copy read it there.
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
                FVector Dir2D = AimDir;
                FVector Facing;
                Facing = Pawn->Rotation.Vector();
                FVector Facing2D = Facing;
                Facing2D.Z = 0.0f;
                Dir2D.Z = 0.0f;
                // The retail inlines FVector::Normalize here, so the two
                // vectors stay in registers instead of being passed by
                // address to the out-of-line normalizer.
                NormalizeVector(Facing2D);
                NormalizeVector(Dir2D);
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

// The brain finder: the engine's way to find the CCS brains of the world.
// @retail 0x8336D028
GripBrain *CCSBrainFinder::FindBrain(void *pActor) const
{
    GripBrain *pBrain = 0;
    APawn *pPawn = Cast<APawn>((UObject *)pActor);
    if (pPawn != 0)
    {
        ACCSController *pController = Cast<ACCSController>(pPawn->Controller);
        if (pController != 0)
        {
            pBrain = pController->Brain;
        }
    }
    return pBrain;
}

// The closest brain in 2D, its distance written to Distance (-1 if none).
// @retail 0x8336D090
GripBrain *CCSBrainFinder::FindClosestBrain(Grip_Vector Position, float &Distance) const
{
    if (GWorld == 0)
    {
        return 0;
    }
    GripBrain *pClosest = 0;
    bool bFound = false;
    Distance = -1.0f;
    for (AController *pController = GWorld->GetFirstController(); pController != 0; pController = pController->NextController)
    {
        ACCSController *pCCSController = Cast<ACCSController>(pController);
        if (pCCSController == 0)
        {
            continue;
        }
        GripBrain *pBrain = pCCSController->Brain;
        if (pBrain == 0)
        {
            continue;
        }
        APawn *pPawn = pCCSController->Pawn;
        if (pPawn != 0)
        {
            float DeltaX = pPawn->Location.X - Position.X;
            float DeltaY = pPawn->Location.Y - Position.Y;
            float BrainDistance = appSqrt(DeltaX * DeltaX + DeltaY * DeltaY);
            if (!bFound || BrainDistance < Distance)
            {
                Distance = BrainDistance;
                pClosest = pBrain;
                bFound = true;
            }
        }
    }
    return pClosest;
}

// @retail 0x8336D190
void CCSBrainFinder::FindAllBrains(Grip_ArrayPOD<GripBrain *, 2> &Brains) const
{
    if (GWorld == 0)
    {
        return;
    }
    for (AController *pController = GWorld->GetFirstController(); pController != 0; pController = pController->NextController)
    {
        ACCSController *pCCSController = Cast<ACCSController>(pController);
        if (pCCSController != 0 && pCCSController->Brain != 0)
        {
            Brains.AddItem(pCCSController->Brain);
        }
    }
}

// @retail 0x8336D218
bool CCSBrainFinder::FindLocationAndRotationFromBrainID(int BrainID, Grip_Vector &Location, Grip_Vector &Rotation) const
{
    if (GWorld == 0)
    {
        return false;
    }
    for (AController *pController = GWorld->GetFirstController(); pController != 0; pController = pController->NextController)
    {
        ACCSController *pCCSController = Cast<ACCSController>(pController);
        if (pCCSController != 0 && pCCSController->Brain != 0 && pCCSController->Brain->m_brainID == BrainID && pCCSController->Pawn != 0)
        {
            Location = pCCSController->Pawn->Location;
            Rotation = pCCSController->Pawn->Rotation.Vector();
            return true;
        }
    }
    return false;
}
