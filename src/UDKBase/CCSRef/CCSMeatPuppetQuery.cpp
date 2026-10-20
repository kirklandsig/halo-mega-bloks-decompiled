// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsmeatpuppetquery.cpp: the brain's read-only questions about its pawn
// (cover, reached points, navmesh paths), answered through the meat puppet
// and the cover and movement control systems.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSCSCover.cpp"

// @retail 0x83324558
bool CCSMeatPuppetQuery::ReachedPoint(Grip_Vector Point)
{
    return m_pBrain->m_meatPuppet->ReachedPoint(Point) != 0;
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83330348
CCSMeatPuppetQuery::CCSMeatPuppetQuery(CCSBrain *pBrain)
    : m_pBrain(pBrain)
{
}
#endif

// @retail 0x8333C178
bool CCSMeatPuppetQuery::IsInCover()
{
    CCSCSCover *pCover = static_cast<CCSCSCover *>(m_pBrain->m_systems.GetSystem(CCSCSCover::SGetFamily(), CCSCSCover::SGetId()));
    if (pCover == 0)
    {
        return false;
    }
    return pCover->GetCurrentCover() != CCSCover::NONE;
}

// @retail 0x8333C218
CCSCover CCSMeatPuppetQuery::GetCurrentCover()
{
    CCSCSCover *pCover = static_cast<CCSCSCover *>(m_pBrain->m_systems.GetSystem(CCSCSCover::SGetFamily(), CCSCSCover::SGetId()));
    if (pCover == 0)
    {
        return CCSCover::NONE;
    }
    return pCover->GetCurrentCover();
}

// @retail 0x833445E8
bool CCSMeatPuppetQuery::LockCover(CCSCover &Cover)
{
    return Cover.LockCover(m_pBrain->m_meatPuppet->GetCharacter());
}

// @retail 0x8333C298
bool CCSMeatPuppetQuery::UnlockCover(CCSCover &Cover)
{
    return Cover.UnlockCover(m_pBrain->m_meatPuppet->GetCharacter());
}

// @retail 0x8333C348
bool CCSMeatPuppetQuery::FindNavMeshPath(Grip_Vector Point)
{
    CCSCSMovement *pMovement = static_cast<CCSCSMovement *>(m_pBrain->m_systems.GetSystem(CCSCSMovement::SGetFamily(), CCSCSMovement::SGetId()));
    return pMovement->FindNavMeshPath(Point);
}

// @retail 0x8333C3A8
bool CCSMeatPuppetQuery::FindNavMeshDistance(Grip_Vector Point, float &Distance, float MaxDistance)
{
    CCSCSMovement *pMovement = static_cast<CCSCSMovement *>(m_pBrain->m_systems.GetSystem(CCSCSMovement::SGetFamily(), CCSCSMovement::SGetId()));
    return pMovement->FindNavMeshDistance(Point, Distance, MaxDistance);
}
