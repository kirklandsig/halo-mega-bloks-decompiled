// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscover.cpp. Other files of the unity include this one for the
// definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../CCSRefUE3/CCSGameCover.cpp"

// @retail 0x83323CB0
CCSCover::CCSCover()
    : m_state(CCS::CoverState_NotSet), m_inUseByMe(false), m_targetDist(0.0f), m_directDistance(0.0f), m_validPath(false),
      m_validDefense(false), m_pathDistance(0.0f)
{
}

// ccscover.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern bool (CCSCover::*const EmitCoverEquals)(const CCSCover &) const = &CCSCover::operator==;
extern bool (CCSCover::*const EmitCoverNotEquals)(const CCSCover &) const = &CCSCover::operator!=;
extern bool (CCSCover::*const EmitCoverIsEnabled)() const = &CCSCover::IsEnabled;
extern bool (CCSCover::*const EmitCoverIsOccupied)() const = &CCSCover::IsOccupied;
extern bool (CCSCover::*const EmitCoverIsOccupiedBy)(CCSCharacter) = &CCSCover::IsOccupiedBy;
extern bool (CCSCover::*const EmitCoverOccupyCover)(CCSCharacter) = &CCSCover::OccupyCover;
extern bool (CCSCover::*const EmitCoverVacateCover)(CCSCharacter) = &CCSCover::VacateCover;
extern bool (CCSCover::*const EmitCoverIsValid)() const = &CCSCover::IsValid;
extern Grip_Vector (CCSCover::*const EmitCoverGetPosition)() const = &CCSCover::GetPosition;
extern Grip_Rotation (CCSCover::*const EmitCoverGetOrientation)() const = &CCSCover::GetOrientation;
extern bool (CCSCover::*const EmitCoverIsLocked)() const = &CCSCover::IsLocked;
extern bool (CCSCover::*const EmitCoverIsLockedBy)(CCSCharacter) const = &CCSCover::IsLockedBy;
extern bool (CCSCover::*const EmitCoverLockCover)(CCSCharacter) = &CCSCover::LockCover;
extern bool (CCSCover::*const EmitCoverUnlockCover)(CCSCharacter) = &CCSCover::UnlockCover;
extern CCS::ECoverShootConfig (CCSCover::*const EmitCoverGetShootConfig)() const = &CCSCover::GetShootConfig;
extern CCS::ECoverType (CCSCover::*const EmitCoverGetType)() const = &CCSCover::GetType;
extern Grip_Vector (CCSCover::*const EmitCoverGetShootPosition)(const CCS::ECoverShootConfig, const float) const = &CCSCover::GetShootPosition;
#pragma inline_depth()

// @retail 0x8331DC60
// CCSCover::operator==
// @retail 0x8331DC98
// CCSCover::operator!=
// @retail 0x83341E28
// CCSCover::IsEnabled
// @retail 0x83335BD0
// CCSCover::IsOccupied
// @retail 0x83335BD8
// CCSCover::IsOccupiedBy
// @retail 0x83335C08
// CCSCover::OccupyCover
// @retail 0x83335C38
// CCSCover::VacateCover
// @retail 0x8331DCD0
// CCSCover::IsValid
// @retail 0x8331DCF8
// CCSCover::GetPosition
// @retail 0x8331DD50
// CCSCover::GetOrientation
// @retail 0x83335C68
// CCSCover::IsLocked
// @retail 0x83335C70
// CCSCover::IsLockedBy
// @retail 0x83341E68
// CCSCover::LockCover
// @retail 0x83335CA0
// CCSCover::UnlockCover
// @retail 0x83341E98
// CCSCover::GetShootConfig
// @retail 0x83341EA0
// CCSCover::GetType
// @retail 0x83327CF0
// CCSCover::GetShootPosition
