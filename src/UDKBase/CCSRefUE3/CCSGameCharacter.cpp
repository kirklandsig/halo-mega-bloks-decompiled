// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsgamecharacter.cpp: the CCS character backed by a UE3 pawn or actor.
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
    Grip_Rotation Orientation;  // zeroed again below, in the order retail stores it
    Orientation.Roll = 0;
    Orientation.Yaw = 0;
    Orientation.Pitch = 0;
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

// @retail 0x83321050
void *CCSGameCharacter::GetActor() const
{
    if (m_actor != 0 && !m_actor->bDeleteMe && m_actor->IsValid())
    {
        return m_actor;
    }
    if (m_pawn != 0 && !m_pawn->bDeleteMe && m_pawn->IsValid())
    {
        return m_pawn;
    }
    return 0;
}

// @retail 0x8332B3B0
UUDKTargetableComponent *CCSGameCharacter::GetTargetableComponent()
{
    if (!m_targetableComponentCheck)
    {
        if (m_actor != 0)
        {
            m_targetableComponent = Cast<UUDKTargetableComponent>(m_actor->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
        }
        else if (m_pawn != 0)
        {
            m_targetableComponent = Cast<UUDKTargetableComponent>(m_pawn->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
        }
        m_targetableComponentCheck = true;
    }
    return m_targetableComponent;
}

// score 45 (was 159): the register allocation and the order of the word
// stores still differ from retail
// @retail 0x83321100
Grip_Vector CCSGameCharacter::GetEyesPosition() const
{
    Grip_Vector Position;
    if (m_pawn != 0)
    {
        Position = m_pawn->GetPawnViewLocation();
        return Position;
    }
    if (m_actor != 0)
    {
        if (m_targetableComponent != 0)
        {
            FVector Loc;
            Loc.X = m_actor->Location.X;
            Loc.Y = m_actor->Location.Y;
            Loc.Z = m_actor->Location.Z + m_targetableComponent->fAITargetHeight;
            Position = Loc;
        }
        else
        {
            Position = m_actor->Location;
        }
    }
    return Position;
}

// @retail 0x83321330
float CCSGameCharacter::GetSize() const
{
    float Size = 0.0f;
    if (m_pawn != 0)
    {
        Size = m_pawn->CylinderComponent->CollisionRadius;
    }
    if (m_actor != 0)
    {
        Size = 1.0f;
    }
    return Size;
}

// @retail 0x83321368
int CCSGameCharacter::GetTeam()
{
    if (m_cachedTeamNum == -1)
    {
        AActor *pActor = m_pawn != 0 ? m_pawn : m_actor;
        if (pActor != 0)
        {
            m_cachedTeamNum = pActor->GetTeamNum();
        }
    }
    return m_cachedTeamNum;
}

// @retail 0x833213D0
bool CCSGameCharacter::IsPlayer() const
{
    if (m_actor != 0 && m_actor->Owner != 0)
    {
        return true;
    }
    if (m_pawn != 0 && m_pawn->Controller != 0 && m_pawn->Controller->IsPlayerOwner())
    {
        return true;
    }
    return false;
}
