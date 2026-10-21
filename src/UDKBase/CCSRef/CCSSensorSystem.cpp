// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccssensorsystem.cpp: the base of a brain's sensor systems. Other files of
// the unity include this one for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSBlackboard.cpp"
#include "../Src/HaloRBTKamikaze.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83325128
CCSSensorSystem::CCSSensorSystem(CCSBrain *pBrain) : m_pBrain(pBrain)
{
}
#endif

// @retail 0x833251E8
void CCSSensorSystem::Initialize(const GripSystemConfig *)
{
    m_inStasis = true;
}

// @retail 0x8336EB80
void CCSSensorSystem::BecomeAware(bool bForce)
{
    if (m_pBrain == 0)
    {
        return;
    }
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    if (pBB == 0 || pBB->GetHasBecomeAware())
    {
        return;
    }
    if (bForce || pBB->m_timeSinceLostAware.Get() > 3.0f)
    {
        pBB->m_timeSinceBecameAware.Set(0.0f);
        AlertFriends();
        pBB->SetHasBecomeAware(true);
        APawn *pPawn = static_cast<CCSMeatPuppet *>(m_pBrain->m_meatPuppet)->m_pUnPawn;
        if (pPawn != 0)
        {
            pPawn->eventNotifyBecameThreatened();
        }
    }
}

// Wakes the friendlies within yelling distance (plus their hearing range) and
// hands an idle one this brain's current target.
// @retail 0x8336D820
void CCSSensorSystem::AlertFriends()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    ICCSMeatPuppet *pMeatPuppet = m_pBrain->m_meatPuppet;
    ACCSController *pController = static_cast<CCSMeatPuppet *>(pMeatPuppet)->m_pCCSCtrl;
    if (pBB == 0 || pController == 0 || pMeatPuppet == 0)
    {
        return;
    }
    Grip_Vector Position = pMeatPuppet->GetCharacter().GetPosition();
    float YellingDistance = pController->CCSPawn->GetYellingDistance();
    for (int i = 0; i < pBB->m_friendlies.Num(); i++)
    {
        APawn *pPawn = Cast<APawn>(pBB->m_friendlies[i].character.m_gameCharacter.m_actor);
        if (pPawn == 0)
        {
            continue;
        }
        float Range = pPawn->HearingThreshold + YellingDistance;
        Grip_Vector Location = *(const Grip_Vector *)&pPawn->Location;
        Grip_Vector Delta = Location - Position;
        if (Delta.Y * Delta.Y + Delta.Z * Delta.Z + Delta.X * Delta.X > Range * Range)
        {
            continue;
        }
        ACCSController *pFriend = Cast<ACCSController>(pPawn->Controller);
        if (pFriend == 0 || pFriend->Brain == 0)
        {
            continue;
        }
        CCSBlackboard *pFriendBB = pFriend->Brain->GetBlackboard<CCSBlackboard>();
        if (pFriendBB == 0 || pFriendBB->GetHasBecomeAware())
        {
            continue;
        }
        pFriendBB->m_bHasBecomeAware.Set(true);
        pFriendBB->m_timeSinceBecameAware.Set(0.0f);
        if (pFriendBB->GetCurrentTarget() != 0 || pBB->GetCurrentTarget() == 0)
        {
            continue;
        }
        for (int j = 0; j < pFriendBB->m_targets.Num(); j++)
        {
            CCSTarget *pTarget = &pFriendBB->m_targets[j];
            if (pTarget->character == pBB->GetCurrentTarget()->character)
            {
                pFriendBB->SetCurrentTarget(pTarget);
            }
        }
    }
}

// ccssensorsystem.h's inline family, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitSensorSystemSGetFamily)() = &CCSSensorSystem::SGetFamily;
#pragma inline_depth()

// @retail 0x83323448
// CCSSensorSystem::SGetFamily (in the header)
