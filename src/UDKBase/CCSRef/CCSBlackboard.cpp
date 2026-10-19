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

// Todo: the members are built as retail's, but registers and schedule
// differ across the 1.8 KB of stores.
// @retail 0x833627C8
CCSBlackboard::CCSBlackboard()
{
    Reset();
    m_currentTether.Set(FVector(0.0f, 0.0f, 0.0f));
    m_vis.SetBlackboard(this);
}

// @retail 0x83356340
void CCSBlackboard::Reset()
{
    GripBlackboard::Reset();
    m_team.Set(255);
    m_visibleToPlayerCamera.Set(false);
    m_timeSinceDamage.Set(3.402823466e+38F);
    m_health.Set(0x7FFFFFFF);
    m_targets.Reset();
    m_bHasBecomeAware.Set(false);
    m_closestEnemy.Set(0);
    m_closestVisibleEnemy.Set(0);
    m_currentTarget.Set(0);
    m_lowestLKPAgeEnemy.Set(0);
    m_closestObjective.Set(0);
    m_closestReactiveTarget.Set(0);
    m_closestEntryVehicle.Set(0);
    m_covers.Reset();
    m_initialCover.Set(CCSCover::NONE);
    m_moveCommand.Set(MOVE_CMD_NONE);
    m_movePosition.Set(Grip_Vector(0.0f, 0.0f, 0.0f));
    m_secondaryTarget.Set(0);
    m_pHighestThreatTarget.Set(0);
    m_OutRangeThreatTargets.Reset();
    m_friendlies.Reset();
    m_timeSinceThreatTargetChanged.Set(3.402823466e+38F);
    m_timeSinceAimedAt.Set(3.402823466e+38F);
    m_timeSinceThreatened.Set(3.402823466e+38F);
    m_timeSinceGrenadeStuck.Set(3.402823466e+38F);
    m_timeSinceStaggered.Set(3.402823466e+38F);
    m_timeSinceSuccessfulAttack.Set(3.402823466e+38F);
    m_timeSinceTargetCamoed.Set(3.402823466e+38F);
    m_timeSinceBecameAware.Set(3.402823466e+38F);
    m_timeSinceLostAware.Set(3.402823466e+38F);
    m_eventType.Set(HALO_EVENT_NONE);
    m_timeSinceEvent.Set(3.402823466e+38F);
    m_eventSenderClass.Set(0);
    m_eventLocation.Set(Grip_Vector(0.0f, 0.0f, 0.0f));
    m_threatLocation.Set(Grip_Vector(0.0f, 0.0f, 0.0f));
    m_threatDirection.Set(Grip_Vector(0.0f, 0.0f, 0.0f));
}

// @retail 0x83323AE0
GripBBVisualization *CCSBlackboard::GetVisualizer()
{
    return &m_vis;
}

// @retail 0x8332E588
void CCSBlackboard::SetMoveCommand(Grip_Vector Position)
{
    m_moveCommand.Set(MOVE_CMD_POS);
    m_movePosition.Set(Position);
}

// @retail 0x83356618
void CCSBlackboard::OnNewVehicle(const CCSTarget &Vehicle)
{
    m_Vehicles.AddItem(Vehicle);
    UpdateTargetPointers();
}

// @retail 0x83356668
void CCSBlackboard::OnNewThreatTarget(const CCSTarget &Target)
{
    m_OutRangeThreatTargets.AddItem(Target);
    UpdateTargetPointers();
}

// @retail 0x833566B8
void CCSBlackboard::OnNewFriendly(const CCSTarget &Friendly)
{
    m_friendlies.AddItem(Friendly);
    UpdateTargetPointers();
}

// @retail 0x83344128
void CCSBlackboard::OnNewCover(const CCSCover &Cover)
{
    m_covers.AddItem(Cover);
}

// @retail 0x83356708
void CCSBlackboard::OnVehicleDestroyed(int Index)
{
    m_Vehicles.RemoveItemSwap(Index);
    UpdateTargetPointers();
}

// @retail 0x83356778
void CCSBlackboard::OnThreatTargetDestroyed(int Index)
{
    if (Index < m_OutRangeThreatTargets.Num())
    {
        m_OutRangeThreatTargets.RemoveItemSwap(Index);
    }
    else
    {
        m_targets.RemoveItemSwap(Index - m_OutRangeThreatTargets.Num());
    }
    UpdateTargetPointers();
}

// @retail 0x833567C8
void CCSBlackboard::OnFriendlyDestroyed(int Index)
{
    m_friendlies.RemoveItemSwap(Index);
    UpdateTargetPointers();
}

// @retail 0x83344160
void CCSBlackboard::OnCoverDestroyed(int Index)
{
    if (Index < m_covers.Num())
    {
        m_covers.RemoveItemSwap(Index);
    }
    else
    {
        m_invalidcovers.RemoveItemSwap(Index - m_covers.Num());
    }
}

// @retail 0x8332E5E8
CCSTarget *CCSBlackboard::GetHighestThreatTarget()
{
    CCSTarget *pTarget = m_pHighestThreatTarget.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E638
void CCSBlackboard::SetHighestThreatTarget(CCSTarget *pTarget)
{
    if (m_pHighestThreatTarget.Get() != pTarget)
    {
        m_pHighestThreatTarget.Set(pTarget);
    }
}

// @retail 0x8332E658
CCSTarget *CCSBlackboard::GetClosestEnemy()
{
    CCSTarget *pTarget = m_closestEnemy.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E6A8
void CCSBlackboard::SetClosestEnemy(CCSTarget *pTarget)
{
    m_closestEnemy.Set(pTarget);
}

// @retail 0x8332E6B8
CCSTarget *CCSBlackboard::GetClosestVisibleEnemy()
{
    CCSTarget *pTarget = m_closestVisibleEnemy.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E708
void CCSBlackboard::SetClosestVisibleEnemy(CCSTarget *pTarget)
{
    m_closestVisibleEnemy.Set(pTarget);
}

// @retail 0x8332E768
void CCSBlackboard::SetCurrentTarget(CCSTarget *pTarget)
{
    if (m_currentTarget.Get() != pTarget)
    {
        m_currentTarget.Set(pTarget);
    }
}

// @retail 0x8332E788
CCSTarget *CCSBlackboard::GetLowestLKPAgeEnemy()
{
    CCSTarget *pTarget = m_lowestLKPAgeEnemy.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E7D8
void CCSBlackboard::SetLowestLKPAgeEnemy(CCSTarget *pTarget)
{
    m_lowestLKPAgeEnemy.Set(pTarget);
}

// @retail 0x8332E7E8
CCSTarget *CCSBlackboard::GetClosestObjective()
{
    CCSTarget *pTarget = m_closestObjective.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E838
void CCSBlackboard::SetClosestObjective(CCSTarget *pTarget)
{
    m_closestObjective.Set(pTarget);
}

// @retail 0x8332E848
CCSTarget *CCSBlackboard::GetReactiveTarget()
{
    CCSTarget *pTarget = m_closestReactiveTarget.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E898
void CCSBlackboard::SetReactiveTarget(CCSTarget *pTarget)
{
    m_closestReactiveTarget.Set(pTarget);
}

// @retail 0x8332E8A8
CCSTarget *CCSBlackboard::GetSecondaryTarget()
{
    CCSTarget *pTarget = m_secondaryTarget.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return 0;
    }
    return pTarget;
}

// @retail 0x8332E8F8
void CCSBlackboard::SetSecondaryTarget(CCSTarget *pTarget)
{
    m_secondaryTarget.Set(pTarget);
}

// @retail 0x8332E908
FVector CCSBlackboard::GetCurrentTether()
{
    return m_currentTether.Get();
}

// @retail 0x8332E928
bool CCSBlackboard::GetHasBecomeAware()
{
    return m_bHasBecomeAware.Get();
}

// @retail 0x8332E930
void CCSBlackboard::SetHasBecomeAware(bool bAware)
{
    if (m_bHasBecomeAware.Get() != bAware)
    {
        m_bHasBecomeAware.Set(bAware);
    }
}

// Todo (the three below): retail calls ~Grip_Array<Grip::String> where ours
// inlines it (and calls its DeleteContainerContent).
// @retail 0x8335F1E8
// GripBlackboard::~GripBlackboard
// @retail 0x83362F08
// CCSBlackboard::~CCSBlackboard
// @retail 0x833631B8
// CCSBlackboard::`scalar deleting destructor'

// Not attempted yet (todo): RegisterMembers (984 bytes; registers every
// member by name), GetSpecificTarget (944), UpdateTargetListsByRange (1,104)
// and UpdateTargetPointers (1,376), the target-list bookkeeping.
