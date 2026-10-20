// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtstrafetarget.cpp: the behaviour-tree node that strafes around the
// current target, firing bursts at it.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83324EE8
CCSRBTStrafeTarget::CCSRBTStrafeTarget()
    : m_fireChance(1.0f), m_chargeChance(0.0f), m_fireBurstPerShot(3), m_delayBetweenBursts(0.25f), m_state(EBTStrafeTargetShootState_Init),
      m_fireBurstCount(0), m_delayTimer(0.0f), m_actionHandle(-1)
{
}
#endif

// @retail 0x83324F70
void CCSRBTStrafeTarget::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagMoveCommandAsUsed();
    pBB->FlagCurrentTarget();
}

// @retail 0x83332428
bool CCSRBTStrafeTarget::TestPreCondition(IGripBTInterface *pInterface)
{
    if (pInterface->GetBlackboard<CCSBlackboard>()->GetCurrentTarget() == 0)
    {
        return false;
    }
    return true;
}

// near: the node and the blackboard get their saved registers the other way
// round (r28/r29), and the objective's zeroing is scheduled around the
// target test differently (split tests, a named target and an earlier
// objective tried)
// @retail 0x83340438
GripRBTNode::EBTExecutionResult CCSRBTStrafeTarget::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    m_actionHandle = -1;
    m_fireBurstCount = 0;
    m_delayTimer = 0.0f;
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSAOStrafeTarget Objective;
    if (pBB->GetCurrentTarget() == 0 || pBB->GetCurrentTarget()->character.GetActor() == 0)
    {
        return ER_FAILURE;
    }
    Objective.pTarget = pBB->GetCurrentTarget()->character.GetActor();
    Objective.chargeChance = m_chargeChance;
    Objective.moveLeft = m_canStrafeLeft;
    Objective.moveRight = m_canStrafeRight;
    Objective.moveBack = m_canStrafeBack;
    Objective.moveForward = m_canStrafeForward;
    Objective.alertness = CCS::AlertnessState_Alert;
    Objective.alwaysFire = pTarget != 0 && pTarget->character != CCSCharacter::NONE ? pTarget->isBehindCover : false;
    m_actionHandle = pFactory->CreateActionInternal<CCSAOStrafeTarget, CCSAFStrafeTarget>(Objective);
    pScheduler->Execute(m_actionHandle);
    if (rand() * (1.0f / 32767.0f) < m_fireChance)
    {
        m_state = EBTStrafeTargetShootState_Shooting;
    }
    else
    {
        m_state = EBTStrafeTargetShootState_Done;
    }
    return ER_INPROGRESS;
}

// @retail 0x833324B8
GripRBTNode::EBTExecutionResult CCSRBTStrafeTarget::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    ACCSController *pController = static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet)->m_pCCSCtrl;
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (pTarget == 0)
    {
        return ER_FAILURE;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
    {
        pBB->ClearMoveCommand();
        return ER_SUCCESS;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_FAILURE)
    {
        pBB->ClearMoveCommand();
        return ER_FAILURE;
    }
    switch (m_state)
    {
    case EBTStrafeTargetShootState_Shooting:
        if (m_fireBurstCount < m_fireBurstPerShot)
        {
            m_state = EBTStrafeTargetShootState_Delay;
            m_delayTimer = 0.0f;
        }
        break;
    case EBTStrafeTargetShootState_Delay:
    {
        m_delayTimer = pInterface->GetDeltaTime() + m_delayTimer;
        if (m_delayTimer <= m_delayBetweenBursts)
        {
            break;
        }
        if (pTarget->character.GetActor() == 0)
        {
            return ER_FAILURE;
        }
        AActor *pActor = (AActor *)pTarget->character.GetActor();
        UUDKTargetableComponent *pTargetable = Cast<UUDKTargetableComponent>(pActor->GetComponentOfType(UUDKTargetableComponent::StaticClass()));
        if (pTargetable != 0)
        {
            if (pTargetable->MaxAIHeat - pTargetable->CurAIHeat <= pBB->m_heatGenerated.Get())
            {
                break;
            }
            pTargetable->CurAIHeat = pBB->GetHeatGenerated() + pTargetable->CurAIHeat;
            if (m_fireBurstCount < m_fireBurstPerShot)
            {
                if (pTarget->character.m_gameCharacter.m_actor != 0)
                {
                    pController->eventStartFireBurstObj(pTarget->character.m_gameCharacter.m_actor);
                }
                else
                {
                    pController->eventStartFireBurst(pTarget->character.m_gameCharacter.m_pawn);
                }
                m_state = EBTStrafeTargetShootState_Shooting;
                return ER_INPROGRESS;
            }
            break;
        }
        m_state = EBTStrafeTargetShootState_Done;
        break;
    }
    }
    return ER_INPROGRESS;
}

// @retail 0x83332728
void CCSRBTStrafeTarget::ExecutePostInternal(IGripBTInterface *pInterface, bool)
{
    pInterface->GetBlackboard<CCSBlackboard>();
    APawn *pPawn = static_cast<CCSBrain *>(pInterface)->m_meatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    if (pPawn->IsA(AUDKVehicle::StaticClass()))
    {
        // through a member pointer: retail calls the event thunk rather than inlining it
        void (AGwNavVehicle::*const ExecuteVehicleCommand)(unsigned char) = &AGwNavVehicle::eventExecuteVehicleCommand;
        (((AGwNavVehicle *)pPawn)->*ExecuteVehicleCommand)(1);
        (((AGwNavVehicle *)pPawn)->*ExecuteVehicleCommand)(3);
    }
}

// ccsrbtstrafetarget.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTStrafeTarget::*const EmitStrafeSetFireChance)(float) = &CCSRBTStrafeTarget::SetFireChance;
extern void (CCSRBTStrafeTarget::*const EmitStrafeSetChargedShotChance)(float) = &CCSRBTStrafeTarget::SetChargedShotChance;
extern void (CCSRBTStrafeTarget::*const EmitStrafeSetFireBurstPerShot)(int) = &CCSRBTStrafeTarget::SetFireBurstPerShot;
extern void (CCSRBTStrafeTarget::*const EmitStrafeSetDelayBetweenBursts)(float) = &CCSRBTStrafeTarget::SetDelayBetweenBursts;
extern void (CCSRBTStrafeTarget::*const EmitStrafeSetDirectionFlags)(bool, bool, bool, bool) = &CCSRBTStrafeTarget::SetDirectionFlags;
#pragma inline_depth()

// @retail 0x8331ECD8
// CCSRBTStrafeTarget::SetFireChance (in the header)
// @retail 0x8331ECE0
// CCSRBTStrafeTarget::SetChargedShotChance (in the header)
// @retail 0x8331ECE8
// CCSRBTStrafeTarget::SetFireBurstPerShot (in the header)
// @retail 0x8331ECF0
// CCSRBTStrafeTarget::SetDelayBetweenBursts (in the header)
// @retail 0x8331ECF8
// CCSRBTStrafeTarget::SetDirectionFlags (in the header)
