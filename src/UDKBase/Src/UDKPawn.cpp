// @object Unity_UDKWeaponEtAl.cpp.obj
// n-Space's additions to UDK's udkpawn.cpp: AUDKPawn's side of the CCS pawn
// interface (ICCSPawn), which Cognition's AI drives the pawn through.
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnMath.h"

// @retail 0x833830B8
unsigned char AUDKPawn::GetMovementType()
{
    return MovementType;
}

// @retail 0x833830C0
void AUDKPawn::SetMovementType(unsigned char NewMovementType)
{
    MovementType = NewMovementType;
}

// @retail 0x833830C8
void AUDKPawn::SetMovementTypeDefault()
{
    SetMovementType(CCS::MovementType_Idle);
}

// @retail 0x833830F0
void AUDKPawn::SetPostureDefault()
{
    SetCrouched(0);
}

// @retail 0x83383110
void AUDKPawn::SetIsPanicking(unsigned int bNewIsPanicking)
{
    bIsPanicking = bNewIsPanicking;
}

// @retail 0x83383120
unsigned int AUDKPawn::GetIsPanicking()
{
    return bIsPanicking;
}

// @retail 0x83383130
unsigned char AUDKPawn::GetAlertness()
{
    return AlertnessState;
}

// @retail 0x83383138
void AUDKPawn::SetAlertness(unsigned char NewAlertness)
{
    AlertnessState = NewAlertness;
    if (Controller && NewAlertness == CCS::AlertnessState_Relax)
    {
        ACCSController *CCSController = (ACCSController *)Controller;
        CCSController->Focus = 0;
        CCSController->AimingFocus = 0;
        Controller->SetFocalPoint(Location + Rotation.Vector() * 512.0f, 1);
    }
}

// @retail 0x833831F0
void AUDKPawn::SetAlertnessDefault()
{
    SetAlertness(CCS::AlertnessState_Relax);
}

// @retail 0x83383208
void AUDKPawn::SetCoverPose(unsigned char NewCoverPose, float BlendTime)
{
    WantedCoverPose = NewCoverPose;
    CoverPoseBlendTimeOverride = BlendTime;
    bShouldCover = 1;
}

// @retail 0x83383220
void AUDKPawn::SetNoCoverPose()
{
    WantedCoverPose = 0;
    bShouldCover = 0;
}

// @retail 0x83383238
unsigned int AUDKPawn::CoverPoseTransitionOver()
{
    return CurrentCoverPose == WantedCoverPose;
}

// @retail 0x83383250
unsigned int AUDKPawn::CanAim(FRotator Rotation)
{
    FRotator Aim = Rotation;
    Aim = Aim.GetNormalized();
    const float Yaw = Aim.Yaw / 16384.0f;
    const float Pitch = Aim.Pitch / 16384.0f;
    bool bCanAim = true;
    if (Yaw < AimYawRange.X || Yaw > AimYawRange.Y || Pitch < AimPitchRange.X || Pitch > AimPitchRange.Y)
    {
        bCanAim = false;
    }
    return bCanAim;
}

// @retail 0x83383308
void AUDKPawn::MoveToInCover(FVector Destination)
{
    FVector Direction = Destination - Location;
    Direction.Z = 0.0f;
    const float Distance = Direction.Size2D();
    if (ReachedDestination(Location, Destination, 0, 0))
    {
        Acceleration = FVector(0.0f, 0.0f, 0.0f);
        return;
    }
    if (Distance > 0.0f)
    {
        Direction = Direction / Distance;
    }
    Acceleration = Direction * AccelRate;
    const float Speed = Velocity.Size();
    if (Distance < AvgPhysicsTime * Speed * 1.4f)
    {
        if (!bReducedSpeed)
        {
            bReducedSpeed = 1;
            DesiredSpeed *= 0.51f;
        }
        if (Speed > 0.0f)
        {
            DesiredSpeed = Min(DesiredSpeed, 200.0f / Speed);
        }
    }
}

// @retail 0x833834D8
unsigned int AUDKPawn::IsInCover()
{
    return bInCover;
}

// @retail 0x833834E8
unsigned char AUDKPawn::GetSpeed()
{
    return (unsigned char)(bIsWalking ? CCS::MovementSpeed_Walk : CCS::MovementSpeed_Run);
}

// @retail 0x833834F8
void AUDKPawn::SetSpeed(unsigned char NewSpeed)
{
    bIsWalking = NewSpeed == CCS::MovementSpeed_Walk;
}

// @retail 0x83383518
void AUDKPawn::SetMovementSpeedDefault()
{
    SetSpeed(CCS::MovementSpeed_Walk);
}

// @retail 0x83383530
void AUDKPawn::SetDefaultBehaviorTree(UCCSBTTree *NewDefaultBehaviorTree)
{
    DefaultBehaviorTree = NewDefaultBehaviorTree;
}

// @retail 0x83383538
UCCSBTTree *AUDKPawn::GetDefaultBehaviorTree()
{
    return DefaultBehaviorTree;
}

// @retail 0x83383540
float AUDKPawn::GetYellingDistance()
{
    return YellingDistance;
}

// @retail 0x833A5B90
// AUDKPawn::GetUObjectInterfaceCCSPawn (cpptext, in the header). Its
// out-of-line copy, through a non-virtual call (taking a virtual's address
// would give a vcall thunk instead).
#pragma inline_depth(0)
UObject *EmitAUDKPawnGetUObjectInterfaceCCSPawn(AUDKPawn *Pawn)
{
    return Pawn->AUDKPawn::GetUObjectInterfaceCCSPawn();
}
#pragma inline_depth()
