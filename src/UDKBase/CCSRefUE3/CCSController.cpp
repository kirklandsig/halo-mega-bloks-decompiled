// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscontroller.cpp: the controller that runs a brain for its pawn.
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../CCSRef/CCSCover.cpp"
#include "../CCSRef/CCSBlackboard.cpp"

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

// Not attempted yet (todo): Tick (1,376 bytes), TakePossession (728; builds
// a USSBrainBuilder on the stack, whose classes aren't rendered yet) and
// DrawHUD (616; the GripHUDRenderer text calls).
