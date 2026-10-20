// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsgamecharacter.cpp: the CCS character backed by a UE3 pawn or actor.
// Only what n-Space's code inlines is written so far.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833212A0
Grip_Vector CCSGameCharacter::GetPosition() const
{
    Grip_Vector Position;
    if (m_pawn != 0)
    {
        Position = m_pawn->Location;
    }
    if (m_actor != 0)
    {
        Position = m_actor->Location;
    }
    return Position;
}

// @retail 0x83321220
float CCSGameCharacter::GetHeight() const
{
    float Height = 0.0f;
    if (m_actor != 0)
    {
        Height = 1.0f;
    }
    return Height;
}

// @retail 0x83321240
Grip_Rotation CCSGameCharacter::GetOrientation() const
{
    Grip_Rotation Orientation;
    if (m_pawn != 0)
    {
        Orientation = m_pawn->Rotation;
    }
    if (m_actor != 0)
    {
        Orientation = m_actor->Rotation;
    }
    return Orientation;
}
