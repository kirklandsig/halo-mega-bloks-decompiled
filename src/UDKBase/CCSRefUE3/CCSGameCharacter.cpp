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
