// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsblackboard.cpp, and the out-of-line copies of ccsblackboard.h's (and
// gripblackboard.h's) inline functions that retail keeps.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#pragma inline_depth(0)
extern Grip_Array<Grip::String, Grip::AllocatorGH<Grip::String, 2> > &(GripBlackboard::*const EmitGetStates)() = &GripBlackboard::GetStates;
extern void (CCSBlackboard::*const EmitFlagHighestThreatTarget)() = &CCSBlackboard::FlagHighestThreatTarget;
extern void (CCSBlackboard::*const EmitFlagClosestEnemy)() = &CCSBlackboard::FlagClosestEnemy;
extern void (CCSBlackboard::*const EmitFlagClosestVisibleEnemy)() = &CCSBlackboard::FlagClosestVisibleEnemy;
extern void (CCSBlackboard::*const EmitFlagCurrentTarget)() = &CCSBlackboard::FlagCurrentTarget;
extern void (CCSBlackboard::*const EmitFlagLowestLKPAgeEnemy)() = &CCSBlackboard::FlagLowestLKPAgeEnemy;
extern void (CCSBlackboard::*const EmitFlagClosestObjective)() = &CCSBlackboard::FlagClosestObjective;
extern void (CCSBlackboard::*const EmitFlagReactiveTarget)() = &CCSBlackboard::FlagReactiveTarget;
extern void (CCSBlackboard::*const EmitFlagHasBecomeAware)() = &CCSBlackboard::FlagHasBecomeAware;
extern void (CCSBlackboard::*const EmitSetHeatGenerated)(float) = &CCSBlackboard::SetHeatGenerated;
extern float (CCSBlackboard::*const EmitGetHeatGenerated)() const = &CCSBlackboard::GetHeatGenerated;
extern void (CCSBlackboard::*const EmitClearMoveCommand)() = &CCSBlackboard::ClearMoveCommand;
extern void (CCSBlackboard::*const EmitFlagMoveCommandAsUsed)() = &CCSBlackboard::FlagMoveCommandAsUsed;
extern CCSBlackboard::EMoveCmd (CCSBlackboard::*const EmitGetMoveCommand)() const = &CCSBlackboard::GetMoveCommand;
extern Grip_Vector (CCSBlackboard::*const EmitGetMovePosition)() const = &CCSBlackboard::GetMovePosition;
#pragma inline_depth()

// @retail 0x83329700
// GripBlackboard::GetStates
// @retail 0x83320488
// CCSBlackboard::FlagHighestThreatTarget
// @retail 0x83320498
// CCSBlackboard::FlagClosestEnemy
// @retail 0x833204A8
// CCSBlackboard::FlagClosestVisibleEnemy
// @retail 0x833204B8
// CCSBlackboard::FlagCurrentTarget
// @retail 0x833204C8
// CCSBlackboard::FlagLowestLKPAgeEnemy
// @retail 0x833204D8
// CCSBlackboard::FlagClosestObjective
// @retail 0x833204E8
// CCSBlackboard::FlagReactiveTarget
// @retail 0x833204F8
// CCSBlackboard::FlagHasBecomeAware
// @retail 0x83329708
// CCSBlackboard::SetHeatGenerated
// @retail 0x83329718
// CCSBlackboard::GetHeatGenerated
// @retail 0x83329720
// CCSBlackboard::ClearMoveCommand
// @retail 0x83320508
// CCSBlackboard::FlagMoveCommandAsUsed
// @retail 0x83329738
// CCSBlackboard::GetMoveCommand
// @retail 0x83329740
// CCSBlackboard::GetMovePosition
