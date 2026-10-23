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

// @retail 0x83386A50
void AUDKVehicle::moveTowardGwNav(const FVector &Direction)
{
    FVector Dir = Direction;
    if (bLookSteerOnAllPlatforms)
    {
        bTurnInPlace = 1;
        moveTowardGwNavLookSteer(Direction);
        return;
    }
    switch (GetMovementType())
    {
    case CCS::MovementType_Strafe:
    {
        FRotationMatrix R(Rotation);
        FVector Right = R.GetAxis(1);
        FVector Forward = Rotation.Vector();
        Right.Z = 0.0f;
        Forward.Z = 0.0f;
        Dir.Normalize(SMALL_NUMBER);
        Right.Normalize(SMALL_NUMBER);
        Forward.Normalize(SMALL_NUMBER);
        Steering = Dir.X * Right.X + Right.Y * Dir.Y + Right.Z * Dir.Z;
        Throttle = Forward.X * Dir.X + Forward.Y * Dir.Y + Forward.Z * Dir.Z;
        if (Throttle > 0.01)
        {
            Throttle = Min(1.0f, Throttle);
        }
        else if (Throttle < -0.01)
        {
            Throttle = Max(-1.0f, Throttle);
        }
        else
        {
            Throttle = 0.0f;
        }
        if (Steering > 0.01)
        {
            Steering = 1.0f;
        }
        else if (Steering < -0.01)
        {
            Steering = -1.0f;
        }
        else
        {
            Steering = 0.0f;
        }
        break;
    }
    case CCS::MovementType_Encircle:
    {
        Steering = CircleLeft ? 0.75f : -0.75f;
        const float Distance = (Controller->GetFocalPoint() - Location).Size2D();
        const float RangeError = (Distance - CircleDistance) / CircleDistance;
        if (RangeError > 0.01)
        {
            Throttle = Min(1.0f, RangeError);
        }
        else if (RangeError < -0.01)
        {
            Throttle = Max(-1.0f, RangeError);
        }
        else
        {
            Throttle = 0.0f;
        }
        break;
    }
    default:
    {
        float Radius, Height;
        GetBoundingCylinder(Radius, Height);
        const float Distance = Dir.Size2D() - Radius;
        if (Distance != 0.0f)
        {
            if (Throttle == 0.0f)
            {
                Throttle = 1.0f;
            }
            VehicleMovingTime = WorldInfo->TimeSeconds;
            AdjustThrottle(Distance);
        }
        else
        {
            Throttle = 0.0f;
        }
        break;
    }
    }
}

// The look-steer modes: the controller's movement type picks how the
// vehicle steers toward its next path point.
// @retail 0x83386D88
void AUDKVehicle::moveTowardGwNavLookSteer(const FVector &Direction)
{
    switch (GetMovementType())
    {
    case CCS::MovementType_Strafe:
        moveTowardGwNavLSStrafe(Direction);
        break;
    case CCS::MovementType_Encircle:
        moveTowardGwNavLSEncircle(Direction);
        break;
    default:
        moveTowardGwNavLSDefault(Direction);
        break;
    }
}

// score 37 (was 42): both dot products now compile to retail's shape, and
// only the register allocation is left. The steering sum is written out as
// -(Dir.Y * Right.Y + (Right.X * Dir.X + Right.Z * Dir.Z)): MSVC
// reassociates a three term float sum, and only this term order gives
// retail's tree - the negated Y term outside, the X and Z terms inside -
// together with retail's operand order in the two multiply-adds. The forward
// dot is written out in the X, Y, Z order, which is the order that fuses
// Forward.X * Dir.X into the sum and keeps Forward.Y * Dir.Y as the addend,
// as retail does; the pipe form (Forward | Dir) gives the same tree but
// scores worse. Dir is normalized with FVector::Normalize from UnMath.h
// instead of a hand written block: the inline squares X, Z, Y and scales
// the three components the way retail does.
// What is left is the register the two constants get: retail keeps 0.0f in
// f8 and SMALL_NUMBER in f7, ours keeps them the other way round, and that
// swap cascades into the fmr copies (f4 before f5 against f5 before f4),
// the three fcmpu operands, the register the sqrt and the division use, the
// register the Forward scale lands in (f4 against f5), the register the
// Right/Forward Z times scale product lands in and the three stores of 0.0f
// - 18 of the 27 differing lines. The other five are the operand order of
// the scaling multiplies: retail multiplies the value by the scale
// (fmuls f0, f0, f6), ours multiplies the scale by the value
// (fmuls f0, f6, f0) in the Dir and the Right normalization, while the
// Forward normalization matches.
// Tried and rejected: the permuter (base 42, best 42), the steering sum
// written out in nine term and operand orders, the forward dot in five term
// orders and as (Forward | Dir) and (Dir | Forward), the pipe and the
// written out form of each dot in all combinations, the Dir normalization as
// a hand written block in four spellings (42, 58, 42, 103) and as
// FVector::Normalize with the old dots (61), the two Normalize calls in the
// other order (86), the Z zeroing before and after the Dir normalization
// (79, 83), the zeroing written as 0.0f, 0, 0.0, as a chained assignment
// and as -0.0f, the SMALL_NUMBER comparison hoisted into a bool in front of
// the zeroing (68), and the body wrapped in if (bCanStrafe) instead of the
// early return (466). Still to no effect: the zeroing and the vector
// declarations in every interleaving (72, 87), the zero literal as 0, 0.0,
// -0.0f and as a local (37 each), the hand written Dir normalization with all
// eight operand orders of the three scaling multiplies and three square sum
// spellings (43 at best), every order of the zeroing and the three Normalize
// calls (37 at best, the order above), Dir.Normalize before the zeroing or
// after the other two (169, 189, 209), the two dots swapped (49), the
// steering and the forward dot in 48 term and operand orders (37 at best),
// the shared Normalize inline with the components scaled in other orders (51,
// 71, and Encircle down to 15), and the permuter on this base (best 37).
// @retail 0x83386E18
void AUDKVehicle::moveTowardGwNavLSStrafe(const FVector &Direction)
{
    if (!bCanStrafe)
    {
        return;
    }
    FVector Dir = Direction;
    FRotationMatrix R(Rotation);
    FVector Right = R.GetAxis(1);
    FVector Forward = Rotation.Vector();
    Right.Z = 0.0f;
    Forward.Z = 0.0f;
    Dir.Normalize(SMALL_NUMBER);
    Right.Normalize(SMALL_NUMBER);
    Forward.Normalize(SMALL_NUMBER);
    Steering = -(Dir.Y * Right.Y + (Right.X * Dir.X + Right.Z * Dir.Z));
    const float ForwardDot = Forward.X * Dir.X + Forward.Y * Dir.Y + Forward.Z * Dir.Z;
    if (Steering > 0.1)
    {
        Steering = 1.0f;
    }
    else if (Steering < -0.1)
    {
        Steering = -1.0f;
    }
    else
    {
        if (ForwardDot > 0.01)
        {
            Throttle = Min(1.0f, ForwardDot);
        }
        else if (ForwardDot < -0.01)
        {
            Throttle = Max(-1.0f, ForwardDot);
        }
        else
        {
            Throttle = 0.0f;
        }
        Steering = 0.0f;
        if (ForwardDot > 0.0f)
        {
            eventExecuteVehicleCommand(0);  // HVC_BOOST
            eventExecuteVehicleCommand(2);  // HVC_FORCEFIRE
        }
    }
}

// @retail 0x83387040
void AUDKVehicle::moveTowardGwNavLSDefault(const FVector &Direction)
{
    FVector Dir = Direction;
    float Radius, Height;
    GetBoundingCylinder(Radius, Height);
    // the size is written out: retail squares Dir.X first
    const float Distance = appSqrt(Dir.X * Dir.X + Dir.Y * Dir.Y) - Radius;
    if (Distance != 0.0f)
    {
        if (Throttle == 0.0f)
        {
            Throttle = 1.0f;
        }
        VehicleMovingTime = WorldInfo->TimeSeconds;
        AdjustThrottle(Distance);
    }
    else
    {
        Throttle = 0.0f;
    }
    if (Throttle != 0.0f)
    {
        Controller->SetFocalPoint(FVector(Location.X + Dir.X, Location.Y + Dir.Y, Location.Z), 0);
    }
}

// @retail 0x83387168
void AUDKVehicle::moveTowardGwNavLSEncircle(const FVector &Direction)
{
    FVector Dir = Direction;
    FRotationMatrix R(Rotation);
    FVector Forward = Rotation.Vector();
    Dir.Normalize(SMALL_NUMBER);
    FVector Right = R.GetAxis(1);
    Right.Z = 0.0f;
    Steering = -(Right | Dir);
    const float Distance = (Controller->GetFocalPoint() - Location).Size2D();
    const float ForwardDot = Forward | Dir;
    const float RangeError = (Distance - CircleDistance) / CircleDistance;
    if (Steering > 0.1)
    {
        Steering = 1.0f;
    }
    else if (Steering < -0.1)
    {
        Steering = -1.0f;
    }
    else
    {
        Steering = 0.0f;
    }
    if (ForwardDot > 0.75f)
    {
        Throttle = Min(1.0f, ForwardDot);
    }
    else if (ForwardDot < -0.75f)
    {
        Throttle = Max(-1.0f, ForwardDot);
    }
    else if (RangeError > 0.1)
    {
        Throttle = Min(1.0f, RangeError);
    }
    else if (RangeError < -0.1)
    {
        Throttle = Max(-1.0f, RangeError);
    }
    else
    {
        Throttle = 0.0f;
    }
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
