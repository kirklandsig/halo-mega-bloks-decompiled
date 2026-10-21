// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsgamecover.cpp, and the out-of-line copies of ccsgamecover.h's inline
// functions that retail keeps. Other files of the unity include this one
// for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83338BF8
bool CCSGameCover::IsEnabled() const
{
    if (m_coverInfo.Link == 0 || m_coverInfo.Link->bDisabled)
    {
        return false;
    }
    return m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).bEnabled;
}

// Where to stand to shoot past the cover's side: beside the slot, a body
// half-width plus 68 units out, square to the slot's facing.
// @retail 0x83321468
Grip_Vector CCSGameCover::GetShootPosition(const CCS::ECoverShootConfig Config, const float Offset) const
{
    ACoverLink *pLink = m_coverInfo.Link;
    Grip_Rotation Rotation = pLink->GetSlotRotation(m_coverInfo.SlotIdx, 0);
    if (Config == CCS::CoverShootConfig_Right)
    {
        Rotation.Yaw += 0x4000;
    }
    else if (Config == CCS::CoverShootConfig_Left)
    {
        Rotation.Yaw -= 0x4000;
    }
    else
    {
        return Grip_Vector(pLink->GetSlotLocation(m_coverInfo.SlotIdx, 0));
    }
    Rotation.Normalize();
    float Distance = Offset + 68.0f;
    Grip_Vector Side = static_cast<const Grip_Vector &>(Rotation.Vector2D()) * Distance;
    Grip_Vector Loc = Grip_Vector(pLink->GetSlotLocation(m_coverInfo.SlotIdx, 0));
    Grip_Vector Position = Side + Loc;
    Position.X = Side.X + Loc.X;
    return Position;
}

// @retail 0x83338C38
CCS::ECoverShootConfig CCSGameCover::GetShootConfig() const
{
    if (m_coverInfo.Link == 0)
    {
        return CCS::CoverShootConfig_None;
    }
    CCS::ECoverShootConfig Config = CCS::CoverShootConfig_None;
    FCoverSlot &Slot = m_coverInfo.Link->Slots(m_coverInfo.SlotIdx);
    switch (Slot.CoverType)
    {
    case CT_Standing:
        if (Slot.bLeanRight && Slot.bLeanLeft)
        {
            Config = CCS::CoverShootConfig_LeftOrRight;
        }
        else if (Slot.bLeanLeft)
        {
            Config = CCS::CoverShootConfig_Left;
        }
        else if (Slot.bLeanRight)
        {
            Config = CCS::CoverShootConfig_Right;
        }
        break;
    case CT_MidLevel:
        Config = CCS::CoverShootConfig_All;
        break;
    }
    return Config;
}

// @retail 0x83338CC8
CCS::ECoverType CCSGameCover::GetType() const
{
    if (m_coverInfo.Link == 0)
    {
        return CCS::CoverType_None;
    }
    CCS::ECoverType Type = CCS::CoverType_None;
    switch (m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).CoverType)
    {
    case CT_Standing:
        Type = CCS::CoverType_Stand;
        break;
    case CT_MidLevel:
        Type = CCS::CoverType_Crouch;
        break;
    }
    return Type;
}

// ccsgamecover.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern bool (CCSGameCover::*const EmitGameCoverEquals)(const CCSGameCover &) const = &CCSGameCover::operator==;
extern Grip_Vector (CCSGameCover::*const EmitGameCoverGetPosition)() const = &CCSGameCover::GetPosition;
extern Grip_Rotation (CCSGameCover::*const EmitGameCoverGetOrientation)() const = &CCSGameCover::GetOrientation;
extern bool (CCSGameCover::*const EmitGameCoverIsLocked)() const = &CCSGameCover::IsLocked;
extern bool (CCSGameCover::*const EmitGameCoverIsLockedBy)(CCSCharacter) const = &CCSGameCover::IsLockedBy;
extern bool (CCSGameCover::*const EmitGameCoverLockCover)(CCSCharacter) = &CCSGameCover::LockCover;
extern bool (CCSGameCover::*const EmitGameCoverUnlockCover)(CCSCharacter) = &CCSGameCover::UnlockCover;
extern bool (CCSGameCover::*const EmitGameCoverIsOccupied)() const = &CCSGameCover::IsOccupied;
extern bool (CCSGameCover::*const EmitGameCoverIsOccupiedBy)(CCSCharacter) const = &CCSGameCover::IsOccupiedBy;
extern bool (CCSGameCover::*const EmitGameCoverOccupyCover)(CCSCharacter) = &CCSGameCover::OccupyCover;
extern bool (CCSGameCover::*const EmitGameCoverVacateCover)(CCSCharacter) = &CCSGameCover::VacateCover;
#pragma inline_depth()

// @retail 0x8331DB78
// CCSGameCover::operator==
// @retail 0x8331DBB0
// CCSGameCover::GetPosition
// @retail 0x8331DC08
// CCSGameCover::GetOrientation
// @retail 0x833357B8
// CCSGameCover::IsLocked
// @retail 0x83335830
// CCSGameCover::IsLockedBy
// @retail 0x83341D78
// CCSGameCover::LockCover
// @retail 0x833358C8
// CCSGameCover::UnlockCover
// @retail 0x83335918
// CCSGameCover::IsOccupied
// @retail 0x83335998
// CCSGameCover::IsOccupiedBy
// @retail 0x83335A38
// CCSGameCover::OccupyCover
// @retail 0x83335B20
// CCSGameCover::VacateCover
