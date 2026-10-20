// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtshootfromcover.cpp: the behaviour node that shoots from cover.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSAFFactory.cpp"

// @retail 0x83324DC8
CCSRBTShootFromCover::CCSRBTShootFromCover()
    : m_delayBetweenBursts(0.4f)
{
    m_delayTimer = 0.0f;
    m_state = CCSRBTShootFromCover::BTCoverShootState_Init;
    m_chargeChance = 0.0f;
    m_fireBurstPerShot = 2;
    m_fireBurstCount = 0;
    m_actionHandle = -1;
}

// @retail 0x83324E48
void CCSRBTShootFromCover::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83324E58
GripRBTNode::EBTExecutionResult CCSRBTShootFromCover::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    m_actionHandle = -1;
    m_state = CCSRBTShootFromCover::BTCoverShootState_Init;
    m_behaviorResult = GripRBTNode::ER_SUCCESS;
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSMeatPuppet *pMeatPuppet = static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet);
    ACCSController *pCtrl = pMeatPuppet->m_pCCSCtrl;
    pCtrl->Pawn->Mesh->RootMotionMode = 0;
    return GripRBTNode::ER_INPROGRESS;
}

// @retail 0x83324EA8
void CCSRBTShootFromCover::ExecutePostInternal(IGripBTInterface *pInterface, bool)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSMeatPuppet *pMeatPuppet = static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet);
    ACCSController *pCtrl = pMeatPuppet->m_pCCSCtrl;
    pCtrl->Pawn->Mesh->RootMotionMode = 2;
}

// @retail 0x83332348
// Near: retail saves the "this" pointer before it clears the objective's
// flag; ours clears the flag first and saves "this" after it.
int CCSRBTShootFromCover::ExitCover(CCSAFFactory *pFactory, GripAFScheduler *pScheduler)
{
    CCSAOExitCover Objective = {};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOExitCover, CCSAFExitCover>(Objective);
    pScheduler->Execute(m_actionHandle);
    return m_actionHandle;
}

// @retail 0x83345E10
// Near: retail keeps the shared "return false" block between the character test
// and the cover code; ours merges the two early exits into one block that the
// compiler sinks to the end of the function.
bool CCSRBTShootFromCover::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSMeatPuppetQuery *pQuery = pInterface->GetMeatPuppetQuery<CCSMeatPuppetQuery>();
    CCSTarget *pTarget = pBB->m_currentTarget.Get();
    if (pTarget == 0 || pTarget->character == CCSCharacter::NONE)
    {
        return false;
    }
    CCSCover Cover = pQuery->GetCurrentCover();
    if (Cover == CCSCover::NONE)
    {
        return false;
    }
    return Cover.GetShootConfig() != 0;
}

// @retail 0x833403E0
int CCSRBTShootFromCover::FireBurst(CCSAOFireBurst &Objective, CCSAFFactory *pFactory, GripAFScheduler *pScheduler)
{
    m_actionHandle = pFactory->CreateActionInternal<CCSAOFireBurst, CCSAFFireBurst>(Objective);
    pScheduler->Execute(m_actionHandle);
    return m_actionHandle;
}

// @retail 0x83345F10
int CCSRBTShootFromCover::GetInCover(CCSTarget *pTarget, CCSCover *pCover, CCSAFFactory *pFactory, GripAFScheduler *pScheduler)
{
    if (pTarget == 0)
    {
        pTarget = (CCSTarget *)&CCSCharacter::NONE;
    }
    CCSAOGetInCover Objective = {*pCover, pTarget->character};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOGetInCover, CCSAFGetInCover>(Objective);
    pScheduler->Execute(m_actionHandle);
    return m_actionHandle;
}

// @retail 0x8334C928
// Near: retail calls CCSCharacter::GetActor out of line here (its inline copy
// was not expanded at this call site) and keeps the meat puppet query in r24
// where ours uses r25; ours is 56 bytes short.
GripRBTNode::EBTExecutionResult CCSRBTShootFromCover::ExecuteInternal(IGripBTInterface *pInterface, bool bInterrupt)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSMeatPuppetQuery *pQuery = pInterface->GetMeatPuppetQuery<CCSMeatPuppetQuery>();
    CCSTarget *pRawTarget = pBB->m_currentTarget.Get();
    CCSTarget *pTarget = (pRawTarget == 0 || pRawTarget->character == CCSCharacter::NONE) ? 0 : pRawTarget;
    if (bInterrupt && m_state != CCSRBTShootFromCover::BTCoverShootState_ExitingCover)
    {
        m_actionHandle = ExitCover(pFactory, pScheduler);
        m_state = CCSRBTShootFromCover::BTCoverShootState_ExitingCover;
    }
    switch (m_state)
    {
    case CCSRBTShootFromCover::BTCoverShootState_Init:
        m_state = CCSRBTShootFromCover::BTCoverShootState_Hiding;
        m_delayTimer = 0.0f;
        return GripRBTNode::ER_INPROGRESS;
    case CCSRBTShootFromCover::BTCoverShootState_Hiding:
        m_delayTimer += pInterface->GetDeltaTime();
        if (m_delayTimer >= 2.0f)
        {
            CCSCover Cover = pQuery->GetCurrentCover();
            m_actionHandle = GetOutCover(pTarget, &Cover, pFactory, pScheduler);
            m_state = CCSRBTShootFromCover::BTCoverShootState_GettingOutCover;
            return GripRBTNode::ER_INPROGRESS;
        }
        break;
    case CCSRBTShootFromCover::BTCoverShootState_GettingOutCover:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            if (pTarget != 0)
            {
                CCSAOFireBurst Objective = {pTarget->character, m_chargeChance, true, pTarget->character != CCSCharacter::NONE ? pTarget->isBehindCover : false};
                m_actionHandle = FireBurst(Objective, pFactory, pScheduler);
                m_fireBurstCount = 0;
                m_state = CCSRBTShootFromCover::BTCoverShootState_Shooting;
                return GripRBTNode::ER_INPROGRESS;
            }
            m_actionHandle = ExitCover(pFactory, pScheduler);
            m_state = CCSRBTShootFromCover::BTCoverShootState_ExitingCover;
            return GripRBTNode::ER_INPROGRESS;
        }
        break;
    case CCSRBTShootFromCover::BTCoverShootState_Shooting:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            m_fireBurstCount++;
            if (m_fireBurstCount >= m_fireBurstPerShot)
            {
                CCSCover Cover = pQuery->GetCurrentCover();
                m_actionHandle = GetInCover(pTarget, &Cover, pFactory, pScheduler);
                m_state = CCSRBTShootFromCover::BTCoverShootState_ReturningToCover;
            }
            else
            {
                m_state = CCSRBTShootFromCover::BTCoverShootState_ShootingDelay;
                m_delayTimer = 0.0f;
            }
            return GripRBTNode::ER_INPROGRESS;
        }
        break;
    case CCSRBTShootFromCover::BTCoverShootState_ShootingDelay:
        m_delayTimer += pInterface->GetDeltaTime();
        if (m_delayTimer > m_delayBetweenBursts)
        {
            AActor *pActor = (AActor *)pTarget->character.GetActor();
            if (pActor == 0)
            {
                return GripRBTNode::ER_FAILURE;
            }
            UUDKTargetableComponent *pTargetable = Cast<UUDKTargetableComponent>(pActor->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
            if (pTarget == 0 || pTargetable == 0)
            {
                m_actionHandle = ExitCover(pFactory, pScheduler);
                m_state = CCSRBTShootFromCover::BTCoverShootState_ExitingCover;
                return GripRBTNode::ER_INPROGRESS;
            }
            float fHeat = pBB->m_heatGenerated.Get();
            if (pTargetable->MaxAIHeat - pTargetable->CurAIHeat <= fHeat)
            {
                m_actionHandle = ExitCover(pFactory, pScheduler);
                m_state = CCSRBTShootFromCover::BTCoverShootState_ExitingCover;
                return GripRBTNode::ER_INPROGRESS;
            }
            pTargetable->CurAIHeat += fHeat;
            CCSAOFireBurst Objective = {pTarget->character, m_chargeChance, true, pTarget->character != CCSCharacter::NONE ? pTarget->isBehindCover : false};
            m_actionHandle = FireBurst(Objective, pFactory, pScheduler);
            m_state = CCSRBTShootFromCover::BTCoverShootState_Shooting;
            return GripRBTNode::ER_INPROGRESS;
        }
        break;
    case CCSRBTShootFromCover::BTCoverShootState_ReturningToCover:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            m_actionHandle = ExitCover(pFactory, pScheduler);
            m_state = CCSRBTShootFromCover::BTCoverShootState_ExitingCover;
            return GripRBTNode::ER_INPROGRESS;
        }
        break;
    case CCSRBTShootFromCover::BTCoverShootState_ExitingCover:
        if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            if (bInterrupt)
            {
                return GripRBTNode::ER_SUCCESSFULLY_INTERRUPTED;
            }
            return m_behaviorResult;
        }
        break;
    }
    return GripRBTNode::ER_INPROGRESS;
}

// @retail 0x83345FB0
int CCSRBTShootFromCover::GetOutCover(CCSTarget *pTarget, CCSCover *pCover, CCSAFFactory *pFactory, GripAFScheduler *pScheduler)
{
    if (pTarget == 0)
    {
        pTarget = (CCSTarget *)&CCSCharacter::NONE;
    }
    CCSAOGetOutCover Objective = {*pCover, pTarget->character};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOGetOutCover, CCSAFGetOutCover>(Objective);
    pScheduler->Execute(m_actionHandle);
    return m_actionHandle;
}

// ccsrbtshootfromcover.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTShootFromCover::*const EmitShootFromCoverSetFireBurstPerShot)(int) = &CCSRBTShootFromCover::SetFireBurstPerShot;
extern void (CCSRBTShootFromCover::*const EmitShootFromCoverSetDelayBetweenBursts)(float) = &CCSRBTShootFromCover::SetDelayBetweenBursts;
#pragma inline_depth()

// @retail 0x8331ECB0
// CCSRBTShootFromCover::SetFireBurstPerShot (in the header)
// @retail 0x8331ECB8
// CCSRBTShootFromCover::SetDelayBetweenBursts (in the header)
