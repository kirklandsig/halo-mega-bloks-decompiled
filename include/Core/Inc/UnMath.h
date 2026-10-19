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
inline float FVector::Size() const { return appSqrt(X * X + Y * Y + Z * Z); }
inline FVector FVector::operator/(float Scale) const
{
    const float RScale = 1.0f / Scale;
    return FVector(X * RScale, Y * RScale, Z * RScale);
}
inline FRotator FRotator::operator-(const FRotator &R) const { return FRotator(Pitch - R.Pitch, Yaw - R.Yaw, Roll - R.Roll); }
inline int FRotator::NormalizeAxis(int Angle)
{
    Angle &= 0xFFFF;
    if (Angle > 32767)
    {
        Angle -= 0x10000;
    }
    return Angle;
}
inline float FVector::Size2D() const { return appSqrt(X * X + Y * Y); }
inline FVector FVector::operator*=(float Scale)
{
    X *= Scale;
    Y *= Scale;
    Z *= Scale;
    return *this;
}
inline unsigned int FVector::IsZero() const { return X == 0.0f && Y == 0.0f && Z == 0.0f; }
inline FRotator FRotator::GetNormalized() const
{
    FRotator Rot = *this;
    Rot.Pitch = NormalizeAxis(Rot.Pitch);
    Rot.Roll = NormalizeAxis(Rot.Roll);
    Rot.Yaw = NormalizeAxis(Rot.Yaw);
    return Rot;
}
