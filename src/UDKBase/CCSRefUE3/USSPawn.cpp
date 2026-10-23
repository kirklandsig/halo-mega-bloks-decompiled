// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"

// Brings a rotator component into -32768..32768. Both overloads are file
// statics with no decorated name in the PDB; check.py pairs them with ours by
// address order.
// @retail 0x83322568
static int UnwindRot(int Rot)
{
    while (Rot > 32768)
    {
        Rot -= 65536;
    }
    while (Rot < -32768)
    {
        Rot += 65536;
    }
    return Rot;
}

// @retail 0x833225B8
static __forceinline FRotator UnwindRot(FRotator Rot)
{
    FRotator Result = Rot;
    Result.Yaw = UnwindRot(Rot.Yaw);
    Result.Pitch = UnwindRot(Rot.Pitch);
    return Result;
}

// TickSpecial's own unwinding helper: the same wrap as UnwindRot, forced
// inline so the pawn's aim delta can be unwound in place.
static __forceinline FRotator UnwindRotCopy(FRotator Rot)
{
    Rot.Pitch = UnwindRot(Rot.Pitch);
    Rot.Yaw = UnwindRot(Rot.Yaw);
    return Rot;
}
#pragma inline_depth(0)
extern int (*const EmitUnwindRotInt)(int) = &UnwindRot;
extern FRotator (*const EmitUnwindRot)(FRotator) = &UnwindRot;
#pragma inline_depth()

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

// @retail 0x83322758
unsigned int AUSSPawn::CanAim(FRotator Rotation)
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

// @retail 0x83322810
void AUSSPawn::MoveToInCover(FVector Destination)
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

// score 50 (was 65): the rotator difference is unwound by a private copy of
// UnwindRot (the shared FRotator overload is a matched retail function and
// must stay as it is); retail unwinds yaw first and pitch second and keeps
// the difference in a stack copy (pitch at 0x50, yaw at 0x54, roll at 0x58,
// the unwound pitch written back) while holding the pawn's Roll in r30; ours
// unwinds pitch first, stores only the pitch and the roll and loads Roll
// early. Helpers that take the rotator by reference or keep it in an array
// slot do keep it in memory, but they score 64-150 (the yaw first order
// alone gives 60).
// Retried this round: a by-value helper that unwinds the yaw first scores 60,
// a by-reference helper that writes the unwound pitch back scores 122, a
// member-wise delta assignment scores 150 and plain UnwindRot calls leave the
// wrap out of line (150). Our compiler scalarizes a local FRotator in every
// shape (plain, by reference, through a pointer), while retail keeps
// DeltaRot in a stack slot at r1+0x50 (pitch, yaw, roll) and writes the
// unwound pitch back into it.
// Retried this round: unwinding the yaw first in the by-value helper is a
// regression (60, reverted); the shared FRotator UnwindRot on the difference
// gives retail's forward pitch/yaw/roll subtraction and the 0x50/0x54 stores
// but drops the roll (65); separate AimRot/PawnRot locals give 59; forcing
// UnwindRot(int) inline and unwinding the members in place still lets the
// roll die (65); member-wise int differences give 109-148.
// @retail 0x8336D540
void AUSSPawn::TickSpecial(float DeltaTime)
{
    Super::TickSpecial(DeltaTime);
    ACCSController *pController = Cast<ACCSController>(Controller);
    if (pController == 0 || pController->AimingFocus == 0)
    {
        return;
    }
    const FRotator Diff = pController->AimingRot - pController->Pawn->Rotation;
    const FRotator Delta = UnwindRotCopy(Diff);
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

// UDKBaseClasses.h: the interface's way back to its object
UObject *AUSSPawn::GetUObjectInterfaceCCSPawn()
{
    return this;
}
// @retail 0x8335BDD0
// AUSSPawn::GetUObjectInterfaceCCSPawn

// @retail 0x8335BDD0
// AUSSPawn::GetUObjectInterfaceCCSPawn

