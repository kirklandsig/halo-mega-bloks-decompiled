// @object Unity_UDKWeaponEtAl.cpp.obj
// n-Space's additions to UDK's udkvehicle.cpp: AUDKVehicle's and
// AUDKWeaponPawn's side of the CCS pawn interface (ICCSPawn), and the
// vehicle's Gameware Navigation steering.
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnMath.h"

// ---- AUDKWeaponPawn (udkvehicle.cpp, line 998)

// @retail 0x83386720
void AUDKWeaponPawn::SetDefaultBehaviorTree(UCCSBTTree *NewDefaultBehaviorTree)
{
    DefaultBehaviorTree = NewDefaultBehaviorTree;
}

// @retail 0x83386728
UCCSBTTree *AUDKWeaponPawn::GetDefaultBehaviorTree()
{
    return DefaultBehaviorTree;
}

// @retail 0x83386730
float AUDKWeaponPawn::GetYellingDistance()
{
    return YellingDistance;
}

// ---- AUDKVehicle

// @retail 0x83386A10
void AUDKVehicle::SetDefaultBehaviorTree(UCCSBTTree *NewDefaultBehaviorTree)
{
    DefaultBehaviorTree = NewDefaultBehaviorTree;
}

// @retail 0x83386A18
UCCSBTTree *AUDKVehicle::GetDefaultBehaviorTree()
{
    return DefaultBehaviorTree;
}

// @retail 0x83386A20
float AUDKVehicle::GetYellingDistance()
{
    return YellingDistance;
}

// @retail 0x83386A28
unsigned char AUDKVehicle::GetMovementType()
{
    return MovementType;
}

// @retail 0x83386A30
void AUDKVehicle::SetMovementType(unsigned char NewMovementType)
{
    MovementType = NewMovementType;
}

// @retail 0x83386A38
void AUDKVehicle::SetMovementTypeDefault()
{
    SetMovementType(CCS::MovementType_Idle);
}

// @retail 0x83387370
void AUDKVehicle::SetPostureDefault()
{
    SetCrouched(0);
}

// @retail 0x83387390
void AUDKVehicle::SetIsPanicking(unsigned int bNewIsPanicking)
{
    bIsPanicking = bNewIsPanicking;
}

// @retail 0x833873A0
unsigned int AUDKVehicle::GetIsPanicking()
{
    return bIsPanicking;
}

// @retail 0x833873B0
unsigned char AUDKVehicle::GetAlertness()
{
    return AlertnessState;
}

// @retail 0x833873B8
void AUDKVehicle::SetAlertness(unsigned char NewAlertness)
{
    AlertnessState = NewAlertness;
}

// @retail 0x833873C0
void AUDKVehicle::SetAlertnessDefault()
{
    SetAlertness(CCS::AlertnessState_Relax);
}

// @retail 0x833873D8
void AUDKVehicle::SetCoverPose(unsigned char NewCoverPose, float BlendTime)
{
    WantedCoverPose = NewCoverPose;
    CoverPoseBlendTimeOverride = BlendTime;
    bShouldCover = 1;
}

// @retail 0x833873F0
void AUDKVehicle::SetNoCoverPose()
{
    WantedCoverPose = 0;
    bShouldCover = 0;
}

// @retail 0x83387408
unsigned int AUDKVehicle::CoverPoseTransitionOver()
{
    return CurrentCoverPose == WantedCoverPose;
}

// @retail 0x83387420
unsigned int AUDKVehicle::CanAim(FRotator Rotation)
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

// @retail 0x833874D8
void AUDKVehicle::MoveToInCover(FVector Destination)
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

// @retail 0x833876A8
unsigned int AUDKVehicle::IsInCover()
{
    return bInCover;
}

// @retail 0x833876B8
unsigned char AUDKVehicle::GetSpeed()
{
    return (unsigned char)(bIsWalking ? CCS::MovementSpeed_Walk : CCS::MovementSpeed_Run);
}

// @retail 0x833876C8
void AUDKVehicle::SetSpeed(unsigned char NewSpeed)
{
    bIsWalking = NewSpeed == CCS::MovementSpeed_Walk;
}

// @retail 0x833876E8
void AUDKVehicle::SetMovementSpeedDefault()
{
    SetSpeed(CCS::MovementSpeed_Walk);
}

// ---- AUDKWeaponPawn

// @retail 0x83387700
unsigned char AUDKWeaponPawn::GetMovementType()
{
    return MovementType;
}

// @retail 0x83387708
void AUDKWeaponPawn::SetMovementType(unsigned char NewMovementType)
{
    MovementType = NewMovementType;
}

// @retail 0x83387710
void AUDKWeaponPawn::SetMovementTypeDefault()
{
    SetMovementType(CCS::MovementType_Idle);
}

// @retail 0x83387758
unsigned char AUDKWeaponPawn::GetAlertness()
{
    return AlertnessState;
}

// @retail 0x83387760
void AUDKWeaponPawn::SetAlertness(unsigned char NewAlertness)
{
    AlertnessState = NewAlertness;
}

// @retail 0x83387768
void AUDKWeaponPawn::SetAlertnessDefault()
{
    SetAlertness(CCS::AlertnessState_Relax);
}

// @retail 0x83387798
unsigned int AUDKWeaponPawn::CanAim(FRotator Rotation)
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

// The interface's object (cpptext, in the header): out-of-line copies
// through non-virtual calls.
// @retail 0x833A63A0
// AUDKWeaponPawn::GetUObjectInterfaceCCSPawn
// @retail 0x833B7CD0
// AUDKVehicle::GetUObjectInterfaceCCSPawn
#pragma inline_depth(0)
UObject *EmitAUDKWeaponPawnGetUObjectInterfaceCCSPawn(AUDKWeaponPawn *Pawn)
{
    return Pawn->AUDKWeaponPawn::GetUObjectInterfaceCCSPawn();
}
UObject *EmitAUDKVehicleGetUObjectInterfaceCCSPawn(AUDKVehicle *Vehicle)
{
    return Vehicle->AUDKVehicle::GetUObjectInterfaceCCSPawn();
}
#pragma inline_depth()
