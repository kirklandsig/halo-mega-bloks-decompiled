// FVector's inline members, as UE3's UnMath.h defines them. Include it after
// a generated header that declares FVector with its members.
#pragma once

inline FVector::FVector(float InX, float InY, float InZ) : X(InX), Y(InY), Z(InZ) {}
inline FVector FVector::operator+(const FVector &V) const { return FVector(X + V.X, Y + V.Y, Z + V.Z); }
inline FVector FVector::operator*(float Scale) const { return FVector(X * Scale, Y * Scale, Z * Scale); }
inline FVector FVector::operator-(const FVector &V) const { return FVector(X - V.X, Y - V.Y, Z - V.Z); }
inline float FVector::SizeSquared() const { return X * X + Y * Y + Z * Z; }
inline float FVector::operator|(const FVector &V) const { return X * V.X + Y * V.Y + Z * V.Z; }
