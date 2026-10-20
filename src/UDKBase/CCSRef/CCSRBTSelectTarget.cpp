// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtselecttarget.cpp: the behaviour-tree node that makes one of the
// blackboard's candidates (closest enemy, objective, reactive target, a
// tagged actor, the highest threat or a vehicle) the current target.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

// @retail 0x83324CC8
void CCSRBTSelectTarget::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagCurrentTarget();
    if (m_selectionAlgo == Algorithm_Closest)
    {
        pBB->FlagClosestEnemy();
    }
    else if (m_selectionAlgo == Algorithm_Closest_Objective)
    {
        pBB->FlagClosestObjective();
    }
    else if (m_selectionAlgo == Algorithm_Closest_Reactive_Target)
    {
        pBB->FlagReactiveTarget();
    }
    else if (m_selectionAlgo == Algorithm_Specific_Tag)
    {
        pBB->m_targets.FlagAsUsed();
    }
    else if (m_selectionAlgo == Algorithm_Highest_Threat)
    {
        pBB->FlagHighestThreatTarget();
    }
    else if (m_selectionAlgo == Algorithm_Closest_Entry_Vehicle)
    {
        pBB->m_closestEntryVehicle.FlagAsUsed();
    }
}

// @retail 0x8333FCF0
bool CCSRBTSelectTarget::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (m_selectionAlgo == Algorithm_Closest)
    {
        return pBB->GetClosestEnemy() != 0;
    }
    if (m_selectionAlgo == Algorithm_Closest_Objective)
    {
        return pBB->GetClosestObjective() != 0;
    }
    if (m_selectionAlgo == Algorithm_Closest_Reactive_Target)
    {
        return pBB->GetReactiveTarget() != 0;
    }
    if (m_selectionAlgo == Algorithm_Specific_Tag)
    {
        return pBB->GetSpecificTarget(TargetName) != 0;
    }
    if (m_selectionAlgo == Algorithm_Highest_Threat)
    {
        return pBB->GetHighestThreatTarget() != 0;
    }
    if (m_selectionAlgo == Algorithm_Closest_Entry_Vehicle)
    {
        return pBB->m_closestEntryVehicle.Get() != 0;
    }
    return true;
}

// @retail 0x8333FE38
GripRBTNode::EBTExecutionResult CCSRBTSelectTarget::ExecuteInternal(IGripBTInterface *pInterface, bool)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (m_selectionAlgo == Algorithm_Closest)
    {
        pBB->SetCurrentTarget(pBB->GetClosestEnemy());
    }
    else if (m_selectionAlgo == Algorithm_Closest_Objective)
    {
        pBB->SetCurrentTarget(pBB->GetClosestObjective());
    }
    else if (m_selectionAlgo == Algorithm_Closest_Reactive_Target)
    {
        pBB->SetCurrentTarget(pBB->GetReactiveTarget());
    }
    else if (m_selectionAlgo == Algorithm_Specific_Tag)
    {
        pBB->SetCurrentTarget(pBB->GetSpecificTarget(TargetName));
    }
    else if (m_selectionAlgo == Algorithm_Highest_Threat)
    {
        pBB->SetCurrentTarget(pBB->GetHighestThreatTarget());
    }
    else if (m_selectionAlgo == Algorithm_Closest_Entry_Vehicle)
    {
        pBB->SetCurrentTarget(pBB->m_closestEntryVehicle.Get());
    }
    else if (m_selectionAlgo == Algorithm_None)
    {
        pBB->SetCurrentTarget(0);
    }
    return ER_SUCCESS;
}

// ccsrbtselecttarget.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTSelectTarget::*const EmitSelectTargetSetSelectionAlgo)(CCSRBTSelectTarget::EAlgorithm) = &CCSRBTSelectTarget::SetSelectionAlgo;
extern void (CCSRBTSelectTarget::*const EmitSelectTargetSetTargetName)(FString) = &CCSRBTSelectTarget::SetTargetName;
#pragma inline_depth()

// @retail 0x8331EC90
// CCSRBTSelectTarget::SetSelectionAlgo (in the header)
// @retail 0x833361E8
// CCSRBTSelectTarget::SetTargetName (in the header)
