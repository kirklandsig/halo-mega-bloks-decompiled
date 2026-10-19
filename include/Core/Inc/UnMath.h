// FVector's inline members, as UE3's UnMath.h defines them. Include it after
// a generated header that declares FVector with its members.
#pragma once

inline FVector::FVector(float InX, float InY, float InZ) : X(InX), Y(InY), Z(InZ) {}
inline FVector FVector::operator+(const FVector &V) const { return FVector(X + V.X, Y + V.Y, Z + V.Z); }
inline FVector FVector::operator*(float Scale) const { return FVector(X * Scale, Y * Scale, Z * Scale); }
inline FVector FVector::operator-(const FVector &V) const { return FVector(X - V.X, Y - V.Y, Z - V.Z); }
inline float FVector::SizeSquared() const { return X * X + Y * Y + Z * Z; }
inline float FVector::operator|(const FVector &V) const { return X * V.X + Y * V.Y + Z * V.Z; }
inline FRotator::FRotator(int InPitch, int InYaw, int InRoll) : Pitch(InPitch), Yaw(InYaw), Roll(InRoll) {}
inline unsigned int FVector::Normalize(float Tolerance)
{
    const float SquareSum = X * X + Y * Y + Z * Z;
    if (SquareSum > Tolerance)
    {
        const float Scale = appInvSqrt(SquareSum);
        X *= Scale;
        Y *= Scale;
        Z *= Scale;
        return 1;
    }
    return 0;
}
