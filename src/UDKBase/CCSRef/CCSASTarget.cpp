// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsastarget.cpp: the analysis system that keeps the blackboard's closest
// enemy, objective, reactive target and entry vehicle up to date.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../CCSRef/CCSTarget.cpp"
#include "../CCSRefUE3/CCSGameCharacter.cpp"

// ccsastarget.h: the fraction of the range a new target must gain to
// replace the one the blackboard holds.
extern const float CCSAnalysisTargetRangeFraction;

// @retail 0x833234B0
CCSASTarget::CCSASTarget(CCSBrain *pBrain)
    : CCSAnalysisSystem(pBrain)
{
}

// @retail 0x83323518
void CCSASTarget::Initialize(const GripSystemConfig *pConfig)
{
    m_config = static_cast<const CCSSystemsConfig *>(pConfig)->targetSelection;
}

// @retail 0x83323528
bool CCSASTarget::IsReactiveTarget(CCSBlackboard *, CCSCharacter &Character)
{
    return Character.m_gameCharacter.m_actor != 0;
}

// @retail 0x8332E348
bool CCSASTarget::IsEnemy(CCSBlackboard *pBB, CCSCharacter &Character)
{
    if (m_config != CCS::TargetPlayer)
    {
        return pBB->m_team.Get() != Character.GetTeam();
    }
    return Character.IsPlayer();
}

// @retail 0x8332E3B0
bool CCSASTarget::IsObjective(CCSBlackboard *, CCSCharacter &Character)
{
    if (m_config == CCS::TargetObjective)
    {
        Character.GetTeam();
    }
    return Character.m_gameCharacter.m_actor != 0;
}

// @retail 0x8333A988
CCSTarget *CCSASTarget::GetClosestEnemy(CCSBlackboard *pBB)
{
    if (pBB->m_targets.Num() < 1)
    {
        return 0;
    }
    CCSTarget Closest;
    Closest.range2D = 3.402823466e+38F;
    CCSTarget *pClosest = &Closest;
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        if (IsEnemy(pBB, pBB->m_targets[i].character) && pBB->m_targets[i].range2D < pClosest->range2D)
        {
            pClosest = &pBB->m_targets[i];
        }
    }
    return pClosest == &Closest ? 0 : pClosest;
}

// @retail 0x8333AAC0
CCSTarget *CCSASTarget::GetClosestObjective(CCSBlackboard *pBB)
{
    if (pBB->m_targets.Num() < 1)
    {
        return 0;
    }
    CCSTarget Closest;
    Closest.range2D = 3.402823466e+38F;
    CCSTarget *pClosest = &Closest;
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        if (IsObjective(pBB, pBB->m_targets[i].character) && pBB->m_targets[i].range2D < pClosest->range2D)
        {
            pClosest = &pBB->m_targets[i];
        }
    }
    return pClosest == &Closest ? 0 : pClosest;
}

// @retail 0x8333ABD8
CCSTarget *CCSASTarget::GetReactiveTarget(CCSBlackboard *pBB)
{
    if (pBB->m_targets.Num() < 1)
    {
        return 0;
    }
    CCSTarget Closest;
    Closest.range2D = 3.402823466e+38F;
    CCSTarget *pClosest = &Closest;
    for (int i = 0; i < pBB->m_targets.Num(); i++)
    {
        if (IsReactiveTarget(pBB, pBB->m_targets[i].character) && pBB->m_targets[i].range2D < pClosest->range2D)
        {
            pClosest = &pBB->m_targets[i];
        }
    }
    return pClosest == &Closest ? 0 : pClosest;
}

// @retail 0x8333AD60
CCSTarget *CCSASTarget::GetClosestEntryVehicle(CCSBlackboard *pBB)
{
    if (pBB->m_Vehicles.Num() < 1)
    {
        return 0;
    }
    CCSTarget Closest;
    Closest.range2D = 3.402823466e+38F;
    CCSTarget *pClosest = &Closest;
    for (int i = 0; i < pBB->m_Vehicles.Num(); i++)
    {
        if (pBB->m_Vehicles[i].isAvailableVehicle && pBB->m_Vehicles[i].range2D < pClosest->range2D)
        {
            pClosest = &pBB->m_Vehicles[i];
        }
    }
    return pClosest == &Closest ? 0 : pClosest;
}

// Near: retail copies each new target into a register of its own before it
// stores it, so the four blocks are a register copy longer than ours; the
// rest of the blocks matches.
// @retail 0x83343D60
void CCSASTarget::Tick(float)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();

    CCSTarget *pRawEnemy = pBB->m_closestEnemy.Get();
    CCSTarget *pEnemy = (pRawEnemy == 0 || pRawEnemy->character == CCSCharacter::NONE) ? 0 : pRawEnemy;
    CCSTarget *pClosestEnemy = GetClosestEnemy(pBB);
    if (pEnemy == 0 || pClosestEnemy == 0 || (pEnemy->range2D - pClosestEnemy->range2D) / pEnemy->range2D > CCSAnalysisTargetRangeFraction)
    {
        pBB->m_closestEnemy.Set(pClosestEnemy);
    }

    CCSTarget *pRawObjective = pBB->m_closestObjective.Get();
    CCSTarget *pObjective = (pRawObjective == 0 || pRawObjective->character == CCSCharacter::NONE) ? 0 : pRawObjective;
    CCSTarget *pClosestObjective = GetClosestObjective(pBB);
    if (pObjective == 0 || pClosestObjective == 0 || (pObjective->range2D - pClosestObjective->range2D) / pObjective->range2D > CCSAnalysisTargetRangeFraction)
    {
        pBB->m_closestObjective.Set(pClosestObjective);
    }

    CCSTarget *pRawReactive = pBB->m_closestReactiveTarget.Get();
    CCSTarget *pReactive = (pRawReactive == 0 || pRawReactive->character == CCSCharacter::NONE) ? 0 : pRawReactive;
    CCSTarget *pClosestReactive = GetReactiveTarget(pBB);
    if (pReactive == 0 || pClosestReactive == 0 || (pReactive->range2D - pClosestReactive->range2D) / pReactive->range2D > CCSAnalysisTargetRangeFraction)
    {
        pBB->m_closestReactiveTarget.Set(pClosestReactive);
    }

    CCSTarget *pVehicle = pBB->m_closestEntryVehicle.Get();
    CCSTarget *pClosestVehicle = GetClosestEntryVehicle(pBB);
    if (pVehicle == 0 || pClosestVehicle == 0 || (pVehicle->range2D - pClosestVehicle->range2D) / pVehicle->range2D > CCSAnalysisTargetRangeFraction)
    {
        pBB->m_closestEntryVehicle.Set(pClosestVehicle);
    }
}
