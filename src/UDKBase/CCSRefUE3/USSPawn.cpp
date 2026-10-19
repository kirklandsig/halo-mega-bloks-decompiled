// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83322670
unsigned char AUSSPawn::GetMovementType()
{
    return MovementType;
}

// @retail 0x83322678
void AUSSPawn::SetMovementType(unsigned char NewMovementType)
{
    MovementType = NewMovementType;
}

// @retail 0x83322680
void AUSSPawn::SetMovementTypeDefault()
{
    SetMovementType(CCS::MovementType_Idle);
}

// @retail 0x83322698
unsigned int AUSSPawn::IsCrouched()
{
    return bInCrouchedPosture;
}

// @retail 0x833226A8
void AUSSPawn::SetCrouched(unsigned int bCrouched)
{
    bWantsToCrouch = bCrouched;
}

// @retail 0x833226B8
void AUSSPawn::SetPostureDefault()
{
    SetCrouched(0);
}

// @retail 0x833226D0
unsigned int AUSSPawn::PostureTransitionOver()
{
    return bInCrouchedPosture == bWantsToCrouch;
}

// @retail 0x833226E8
unsigned char AUSSPawn::GetAlertness()
{
    return AlertnessState;
}

// @retail 0x833226F0
void AUSSPawn::SetAlertness(unsigned char NewAlertness)
{
    AlertnessState = NewAlertness;
}

// @retail 0x833226F8
void AUSSPawn::SetAlertnessDefault()
{
    SetAlertness(CCS::AlertnessState_Relax);
}

// @retail 0x83322710
void AUSSPawn::SetCoverPose(unsigned char Pose, float BlendTime)
{
    CoverPoseBlendTimeOverride = BlendTime;
    WantedCoverPose = Pose;
    bShouldCover = 1;
}

// @retail 0x83322728
void AUSSPawn::SetNoCoverPose()
{
    WantedCoverPose = 0;
    bShouldCover = 0;
}

// @retail 0x83322740
unsigned int AUSSPawn::CoverPoseTransitionOver()
{
    return CurrentCoverPose == WantedCoverPose;
}

// Todo: retail keeps the normalized rotator in a stack copy (storing Pitch
// and Roll) where ours keeps it in registers; not yet found what forces that.
// @retail 0x83322758
unsigned int AUSSPawn::CanAim(FRotator Rotation)
{
    FRotator Aim = Rotation;
    Aim.Pitch = FRotator::NormalizeAxis(Aim.Pitch);
    Aim.Yaw = FRotator::NormalizeAxis(Aim.Yaw);
    const float Yaw = Aim.Yaw / 16384.0f;
    const float Pitch = Aim.Pitch / 16384.0f;
    bool bCanAim = true;
    if (Yaw < AimYawRange.X || Yaw > AimYawRange.Y || Pitch < AimPitchRange.X || Pitch > AimPitchRange.Y)
    {
        bCanAim = false;
    }
    return bCanAim;
}

// Near: retail multiplies the acceleration's X and Z with the operands
// swapped (as in the division just above); the code is otherwise the same.
// @retail 0x83322810
void AUSSPawn::MoveToInCover(FVector Destination)
{
    FVector Direction(Destination.X - Location.X, Destination.Y - Location.Y, 0.0f);
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

// @retail 0x833229E0
unsigned int AUSSPawn::IsInCover()
{
    return bInCover;
}

// @retail 0x833229F0
unsigned int AUSSPawn::GetIsPanicking()
{
    return bIsPanicking;
}

// @retail 0x83322A00
void AUSSPawn::SetIsPanicking(unsigned int bPanicking)
{
    bIsPanicking = bPanicking;
}

// @retail 0x83322A10
unsigned char AUSSPawn::GetSpeed()
{
    return (unsigned char)(bIsWalking ? CCS::MovementSpeed_Walk : CCS::MovementSpeed_Run);
}

// @retail 0x83322A20
void AUSSPawn::SetSpeed(unsigned char Speed)
{
    bIsWalking = Speed == CCS::MovementSpeed_Walk;
}

// @retail 0x83322A40
void AUSSPawn::SetMovementSpeedDefault()
{
    SetSpeed(CCS::MovementSpeed_Walk);
}

// Todo: as CanAim, retail keeps the rotator difference in a stack copy.
// @retail 0x8336D540
void AUSSPawn::TickSpecial(float DeltaTime)
{
    Super::TickSpecial(DeltaTime);
    ACCSController *pController = Cast<ACCSController>(Controller);
    if (pController == 0 || pController->AimingFocus == 0)
    {
        return;
    }
    FRotator Delta = pController->AimingRot - pController->Pawn->Rotation;
    while (Delta.Yaw > 32768)
    {
        Delta.Yaw -= 65536;
    }
    while (Delta.Yaw < -32768)
    {
        Delta.Yaw += 65536;
    }
    while (Delta.Pitch > 32768)
    {
        Delta.Pitch -= 65536;
    }
    while (Delta.Pitch < -32768)
    {
        Delta.Pitch += 65536;
    }
    if (!bNoWeaponFiring)
    {
        const float InvDeltaTime = 1.0f / DeltaTime;
        const float MaxPitch = MaxPitchSpeed * InvDeltaTime;
        const int Pitch = (int)Clamp((float)Delta.Pitch, -MaxPitch, MaxPitch);
        const float MaxYaw = MaxYawSpeed * InvDeltaTime;
        const int Yaw = (int)Clamp((float)Delta.Yaw, -MaxYaw, MaxYaw);
        AimCurrentSkel.X = Clamp(Yaw / 16384.0f, -1.0f, 1.0f);
        AimCurrentSkel.Y = Clamp(Pitch / 16384.0f, -1.0f, 1.0f);
    }
    for (int i = 0; i < AimNodes.Num(); i++)
    {
        AimNodes(i)->Aim = AimCurrentSkel;
    }
}

// @retail 0x83322A68
float AUSSPawn::GetYellingDistance()
{
    return 0.0f;
}

// @retail 0x83322A78
float AUSSPawn::MaxSpeedModifier()
{
    if (bInCover)
    {
        return CoverPct * MovementSpeedModifier;
    }
    return Super::MaxSpeedModifier();
}
