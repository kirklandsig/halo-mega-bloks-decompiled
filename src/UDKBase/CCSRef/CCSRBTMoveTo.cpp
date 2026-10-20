// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmoveto.cpp: the base of the behaviour-tree nodes that move the pawn;
// while it moves, it picks a target and fires bursts at it.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83324928
CCSRBTMoveTo::CCSRBTMoveTo()
    : m_speed(CCS::MovementSpeed_Walk), m_alertness(CCS::AlertnessState_Relax), m_movementType(CCS::MovementType_Walk), m_fireChance(1.0f),
      m_chargeChance(0.0f), m_fireBurstPerShot(3), m_delayBetweenBursts(0.25f), m_SquaredPrimaryAttackRange(25000000000.0f),
      m_SquaredSecondaryAttackRange(25000000000.0f), m_PrimaryTargetWeight(0.5f), m_PlayerSecondaryWeight(0.5f), m_ObjectiveSecondaryWeight(0.5f),
      m_ReactiveSecondaryWeight(0.5f), m_state(EBTMoveToShootState_Init), m_fireBurstCount(0), m_delayTimer(0.0f)
{
}
#endif

// @retail 0x833249D8
void CCSRBTMoveTo::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->FlagCurrentTarget();
}

// @retail 0x83331540
GripRBTNode::EBTExecutionResult CCSRBTMoveTo::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    switch (m_speed)
    {
    case CCS::MovementSpeed_Walk:
        m_movementType = CCS::MovementType_Walk;
        break;
    case CCS::MovementSpeed_Run:
        m_movementType = CCS::MovementType_Run;
        break;
    }
    pInterface->GetBlackboard<CCSBlackboard>()->SetSecondaryTarget(0);
    m_fireBurstCount = 0;
    m_state = EBTMoveToShootState_Init;
    m_delayTimer = 0.0f;
    return ER_INPROGRESS;
}

// near: the node, the interface and the brain get their saved registers in
// another order (r27/r28/r29); declaration orders tried
// @retail 0x8333E5E8
GripRBTNode::EBTExecutionResult CCSRBTMoveTo::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    ACCSController *pController = static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet)->m_pCCSCtrl;
    CCSTarget *pTarget = pBB->GetSecondaryTarget();
    switch (m_state)
    {
    case EBTMoveToShootState_Init:
        if (pBB->GetCurrentTarget() != 0 && rand() * (1.0f / 32767.0f) < m_PrimaryTargetWeight * m_fireChance)
        {
            Grip_Vector Delta = pBrain->m_meatPuppet->GetCharacter().GetPosition() - pBB->GetCurrentTarget()->LKP;
            if ((Delta | Delta) < m_SquaredPrimaryAttackRange)
            {
                pBB->SetSecondaryTarget(pBB->GetCurrentTarget());
            }
        }
        if (pBB->GetSecondaryTarget() == 0 && m_SquaredSecondaryAttackRange > 0.0f)
        {
            pBB->SetSecondaryTarget(GetSecondaryTarget(pInterface));
        }
        if (pBB->GetSecondaryTarget() != 0)
        {
            m_fireBurstCount = 0;
            m_state = EBTMoveToShootState_Shooting;
        }
        break;
    case EBTMoveToShootState_Shooting:
        if (pController->FireBurstCount > 0)
        {
            pController->eventStopFireBurst();
        }
        else
        {
            if (!pController->eventFireWeapon(rand() * (1.0f / 32767.0f) < m_chargeChance, m_fireBurstCount >= m_fireBurstPerShot,
                                              pTarget != 0 && pTarget->character != CCSCharacter::NONE ? pTarget->isBehindCover : false))
            {
                pController->eventActionStopFiring();
            }
        }
        m_state = EBTMoveToShootState_Delay;
        m_delayTimer = 0.0f;
        break;
    case EBTMoveToShootState_Delay:
        m_delayTimer = pInterface->GetDeltaTime() + m_delayTimer;
        if (m_delayTimer > m_delayBetweenBursts)
        {
            if (pTarget == 0 || pTarget->character.GetActor() == 0)
            {
                m_state = EBTMoveToShootState_Init;
                break;
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
                    if (pBB->GetSecondaryTarget()->character.m_gameCharacter.m_actor != 0)
                    {
                        pController->eventStartFireBurstObj(pTarget->character.m_gameCharacter.m_actor);
                    }
                    else
                    {
                        pController->eventStartFireBurst(pTarget->character.m_gameCharacter.m_pawn);
                    }
                    m_state = EBTMoveToShootState_Shooting;
                    m_fireBurstCount++;
                    return ER_INPROGRESS;
                }
            }
            pBB->SetSecondaryTarget(0);
            m_state = EBTMoveToShootState_Init;
        }
        break;
    }
    return ER_INPROGRESS;
}

// @retail 0x833249E8
void CCSRBTMoveTo::ExecutePostInternal(IGripBTInterface *pInterface, bool bAborted)
{
    GripRBTNode::ExecutePostInternal(pInterface, bAborted);
    ACCSController *pController = static_cast<CCSMeatPuppet *>(static_cast<CCSBrain *>(pInterface)->m_meatPuppet)->m_pCCSCtrl;
    pController->eventStopFireBurst();
    pController->eventActionStopFiring();
}

// @retail 0x833315D0
CCSTarget *CCSRBTMoveTo::GetSecondaryTarget(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    const float PlayerRoll = (float)(pBB->GetClosestEnemy() != 0 ? rand() * (1.0f / 32767.0f) : 100000.0);
    const float ObjectiveRoll = (float)(pBB->GetClosestObjective() != 0 ? rand() * (1.0f / 32767.0f) : 100000.0);
    const float ReactiveRoll = (float)(pBB->GetReactiveTarget() != 0 ? rand() * (1.0f / 32767.0f) : 10000.0);
    CCSTarget *pTarget;
    if (pBB->GetReactiveTarget() != 0 && pBB->GetReactiveTarget()->character.GetActor() != this && pBB->GetReactiveTarget()->canShoot
        && (pBB->GetCurrentTarget() == 0 || pBB->GetReactiveTarget()->character.GetActor() != pBB->GetCurrentTarget()->character.GetActor())
        && ReactiveRoll < m_ReactiveSecondaryWeight * m_fireChance)
    {
        pTarget = pBB->GetReactiveTarget();
    }
    else if (pBB->GetClosestObjective() != 0 && pBB->GetClosestObjective()->character.GetActor() != this && pBB->GetClosestObjective()->canShoot
             && (pBB->GetCurrentTarget() == 0 || pBB->GetClosestObjective()->character.GetActor() != pBB->GetCurrentTarget()->character.GetActor())
             && ObjectiveRoll < m_ObjectiveSecondaryWeight * m_fireChance)
    {
        pTarget = pBB->GetClosestObjective();
    }
    else if (pBB->GetClosestEnemy() != 0 && pBB->GetClosestEnemy()->character.GetActor() != this && pBB->GetClosestEnemy()->canShoot
             && (pBB->GetCurrentTarget() == 0 || pBB->GetClosestEnemy()->character.GetActor() != pBB->GetCurrentTarget()->character.GetActor())
             && PlayerRoll < m_PlayerSecondaryWeight * m_fireChance)
    {
        pTarget = pBB->GetClosestEnemy();
    }
    else
    {
        return 0;
    }
    if (pTarget == 0)
    {
        return 0;
    }
    Grip_Vector Delta = static_cast<CCSBrain *>(pInterface)->m_meatPuppet->GetCharacter().GetPosition() - pTarget->position;
    if ((Delta | Delta) > m_SquaredSecondaryAttackRange)
    {
        return 0;
    }
    return pTarget;
}

// ccsrbtmoveto.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTMoveTo::*const EmitMoveToSetSpeed)(CCS::EMovementSpeed) = &CCSRBTMoveTo::SetSpeed;
extern void (CCSRBTMoveTo::*const EmitMoveToSetAlertness)(CCS::EAlertnessState) = &CCSRBTMoveTo::SetAlertness;
extern void (CCSRBTMoveTo::*const EmitMoveToSetMovementType)(CCS::EMovementType) = &CCSRBTMoveTo::SetMovementType;
extern void (CCSRBTMoveTo::*const EmitMoveToSetFireChance)(float) = &CCSRBTMoveTo::SetFireChance;
extern void (CCSRBTMoveTo::*const EmitMoveToSetChargedShotChance)(float) = &CCSRBTMoveTo::SetChargedShotChance;
extern void (CCSRBTMoveTo::*const EmitMoveToSetFireBurstPerShot)(int) = &CCSRBTMoveTo::SetFireBurstPerShot;
extern void (CCSRBTMoveTo::*const EmitMoveToSetDelayBetweenBursts)(float) = &CCSRBTMoveTo::SetDelayBetweenBursts;
extern void (CCSRBTMoveTo::*const EmitMoveToSetPrimaryAttackRange)(float) = &CCSRBTMoveTo::SetPrimaryAttackRange;
extern void (CCSRBTMoveTo::*const EmitMoveToSetSecondaryAttackRange)(float) = &CCSRBTMoveTo::SetSecondaryAttackRange;
extern void (CCSRBTMoveTo::*const EmitMoveToSetPrimaryTargetWeight)(float) = &CCSRBTMoveTo::SetPrimaryTargetWeight;
extern void (CCSRBTMoveTo::*const EmitMoveToSetPlayerTargetWeight)(float) = &CCSRBTMoveTo::SetPlayerTargetWeight;
extern void (CCSRBTMoveTo::*const EmitMoveToSetReactiveTargetWeight)(float) = &CCSRBTMoveTo::SetReactiveTargetWeight;
extern void (CCSRBTMoveTo::*const EmitMoveToSetObjectiveTargetWeight)(float) = &CCSRBTMoveTo::SetObjectiveTargetWeight;
#pragma inline_depth()

// @retail 0x8331EC00
// CCSRBTMoveTo::SetSpeed (in the header)
// @retail 0x8331EC08
// CCSRBTMoveTo::SetAlertness (in the header)
// @retail 0x8331EC10
// CCSRBTMoveTo::SetMovementType (in the header)
// @retail 0x8331EC18
// CCSRBTMoveTo::SetFireChance (in the header)
// @retail 0x8331EC20
// CCSRBTMoveTo::SetChargedShotChance (in the header)
// @retail 0x8331EC28
// CCSRBTMoveTo::SetFireBurstPerShot (in the header)
// @retail 0x8331EC30
// CCSRBTMoveTo::SetDelayBetweenBursts (in the header)
// @retail 0x8331EC38
// CCSRBTMoveTo::SetPrimaryAttackRange (in the header)
// @retail 0x8331EC48
// CCSRBTMoveTo::SetSecondaryAttackRange (in the header)
// @retail 0x8331EC58
// CCSRBTMoveTo::SetPrimaryTargetWeight (in the header)
// @retail 0x8331EC60
// CCSRBTMoveTo::SetPlayerTargetWeight (in the header)
// @retail 0x8331EC68
// CCSRBTMoveTo::SetReactiveTargetWeight (in the header)
// @retail 0x8331EC70
// CCSRBTMoveTo::SetObjectiveTargetWeight (in the header)
