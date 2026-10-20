// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtshoot.cpp: the behaviour-tree node that fires bursts at the current
// target while standing.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83324D38
CCSRBTShoot::CCSRBTShoot()
    : m_fireBurstPerShot(1), m_delayBetweenBursts(0.4f), m_state(BTShootState_Init), m_fireBurstCount(0), m_delayTimer(0.0f), m_actionHandle(-1),
      m_chargeChance(0.0f)
{
}
#endif

// @retail 0x83324DB8
void CCSRBTShoot::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83332240
bool CCSRBTShoot::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    unsigned char bHasTarget = 1;
    if (pBB->GetCurrentTarget() == 0)
    {
        bHasTarget = 0;
    }
    return bHasTarget != 0;
}

// near: one load of the target's pawn is scheduled after the last-shot
// compare instead of before it
// @retail 0x8333FFD0
GripRBTNode::EBTExecutionResult CCSRBTShoot::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    m_fireBurstCount = 0;
    m_delayTimer = 0.0f;
    m_actionHandle = -1;
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    CCSAOFireBurst Objective = {pTarget->character, m_chargeChance, 1 >= m_fireBurstCount,
                                pTarget->character != CCSCharacter::NONE ? pTarget->isBehindCover : false};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOFireBurst, CCSAFFireBurst>(Objective);
    pScheduler->Execute(m_actionHandle);
    m_state = BTShootState_Shooting;
    return ER_INPROGRESS;
}

// @retail 0x83340148
GripRBTNode::EBTExecutionResult CCSRBTShoot::ExecuteInternal(IGripBTInterface *pInterface, bool bInterrupt)
{
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    switch (m_state)
    {
    case BTShootState_Shooting:
    {
        const GripAFAction::EGripAFActionStatus Status = pScheduler->GetStatus(m_actionHandle);
        if (Status == GripAFAction::AS_DONE)
        {
            if (++m_fireBurstCount < m_fireBurstPerShot)
            {
                m_state = BTShootState_Delay;
                m_delayTimer = 0.0f;
                return ER_INPROGRESS;
            }
            return ER_SUCCESS;
        }
        if (Status == GripAFAction::AS_FAILURE)
        {
            return ER_FAILURE;
        }
        break;
    }
    case BTShootState_Delay:
        m_delayTimer = pInterface->GetDeltaTime() + m_delayTimer;
        if (m_delayTimer > m_delayBetweenBursts)
        {
            if (pTarget == 0 || pTarget->character.GetActor() == 0)
            {
                return ER_FAILURE;
            }
            AActor *pActor = (AActor *)pTarget->character.GetActor();
            UUDKTargetableComponent *pTargetable = Cast<UUDKTargetableComponent>(pActor->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
            if (pTargetable != 0)
            {
                if (pTargetable->MaxAIHeat - pTargetable->CurAIHeat <= pBB->m_heatGenerated.Get())
                {
                    return ER_FAILURE;
                }
                pTargetable->CurAIHeat = pBB->GetHeatGenerated() + pTargetable->CurAIHeat;
                CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
                CCSAOFireBurst Objective = {pTarget->character, m_chargeChance, m_fireBurstCount + 1 >= m_fireBurstPerShot,
                                            pTarget->character != CCSCharacter::NONE ? pTarget->isBehindCover : false};
                m_actionHandle = pFactory->CreateActionInternal<CCSAOFireBurst, CCSAFFireBurst>(Objective);
                pScheduler->Execute(m_actionHandle);
                m_state = BTShootState_Shooting;
            }
        }
        break;
    }
    return ER_INPROGRESS;
}

// ccsrbtshoot.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTShoot::*const EmitShootSetFireBurstPerShot)(int) = &CCSRBTShoot::SetFireBurstPerShot;
extern void (CCSRBTShoot::*const EmitShootSetDelayBetweenBursts)(float) = &CCSRBTShoot::SetDelayBetweenBursts;
extern void (CCSRBTShoot::*const EmitShootSetChargedShotChance)(float) = &CCSRBTShoot::SetChargedShotChance;
#pragma inline_depth()

// @retail 0x8331EC98
// CCSRBTShoot::SetFireBurstPerShot (in the header)
// @retail 0x8331ECA0
// CCSRBTShoot::SetDelayBetweenBursts (in the header)
// @retail 0x8331ECA8
// CCSRBTShoot::SetChargedShotChance (in the header)
