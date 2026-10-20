// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsgscover.cpp: the global data system that tracks the world's covers and
// who occupies them. Other files of the unity include this one for the
// definitions they inline.
#pragma once
#include "CCSGlobalDataSystem.cpp"
#include "../CCSRefUE3/CCSGameCharacter.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83356D68
CCSGSCover::CCSGSCover(CCSGlobalBlackboard *pGlobalBB) : CCSGlobalDataSystem(pGlobalBB)
{
}
#endif

// A brain also occupies the cover it is in.
// @retail 0x833444C0
bool CCSGSCover::IsOccupyingCover(const CCSCover &Cover, CCSBrain *pBrain)
{
    bool bOccupying = (Cover.GetPosition() - pBrain->m_meatPuppet->GetCharacter().GetPosition()).SizeSquared() < 6400.0f;
    return bOccupying | (pBrain->GetMeatPuppetQuery<CCSMeatPuppetQuery>()->GetCurrentCover() == Cover);
}

// A character occupies a cover within 80 units of its slot.
// @retail 0x833302B8
bool CCSGSCover::IsOccupyingCover(const CCSCover &Cover, const CCSCharacter &Character)
{
    Grip_Vector Position = Character.GetPosition();
    return (Cover.GetPosition() - Position).SizeSquared() < 6400.0f;
}
