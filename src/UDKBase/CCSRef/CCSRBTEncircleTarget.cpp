// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtencircletarget.cpp: the behaviour-tree node that circles the current
// target, firing bursts at it; a GwNav vehicle circles by itself.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83330B40
CCSRBTEncircleTarget::CCSRBTEncircleTarget()
    : m_fireChance(1.0f), m_fireBurstPerShot(3), m_delayBetweenBursts(0.25f), m_state(EBTEncircleTargetShootState_Init), m_fireBurstCount(0),
      m_delayTimer(0.0f), m_canEncircleLeft(true), m_canEncircleRight(true), m_forceFire(false), m_actionHandle(-1)
{
}
#endif

// @retail 0x83324808
void CCSRBTEncircleTarget::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagMoveCommandAsUsed();
    pBB->FlagCurrentTarget();
}

// @retail 0x83330C50
bool CCSRBTEncircleTarget::TestPreCondition(IGripBTInterface *pInterface)
{
    if (pInterface->GetBlackboard<CCSBlackboard>()->GetCurrentTarget() == 0)
    {
        return false;
    }
    return true;
}

// near: saved registers differ as in CCSRBTStrafeTarget::ExecutePreInternal
// @retail 0x8333E1F8
GripRBTNode::EBTExecutionResult CCSRBTEncircleTarget::ExecutePreInternal(IGripBTInterface *pInterface, bool)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    m_fireBurstCount = 0;
    m_actionHandle = -1;
    m_delayTimer = 0.0f;
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    CCSAOEncircleTarget Objective;
    if (pBB->GetCurrentTarget() == 0 || pBB->GetCurrentTarget()->character.GetActor() == 0)
    {
        return ER_FAILURE;
    }
    Objective.pTarget = pBB->GetCurrentTarget()->character.GetActor();
    Objective.moveRight = m_canEncircleRight;
    Objective.moveLeft = m_canEncircleLeft;
    AActor *pActor = (AActor *)pBrain->m_meatPuppet->GetCharacter().GetActor();
    if (pActor->IsA(AGwNavVehicle::StaticClass()))
    {
        AGwNavVehicle *pVehicle = (AGwNavVehicle *)pActor;
        pVehicle->CircleDistance = pBB->GetCurrentTarget()->range2D;
        pVehicle->CircleLeft = m_canEncircleLeft;
        if (m_forceFire)
        {
            pVehicle->eventExecuteVehicleCommand(2);
        }
    }
    m_actionHandle = pFactory->CreateActionInternal<CCSAOEncircleTarget, CCSAFEncircleTarget>(Objective);
    pScheduler->Execute(m_actionHandle);
    m_state = rand() * (1.0f / 32767.0f) < m_fireChance ? EBTEncircleTargetShootState_Shooting : EBTEncircleTargetShootState_Done;
    return ER_INPROGRESS;
}

// todo: 4 bytes long; retail tests the meat puppet with a signed compare
// (cmpwi) and its saved registers differ (this, the interface, the brain)
// @retail 0x83330CE0
GripRBTNode::EBTExecutionResult CCSRBTEncircleTarget::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    if (pBrain->m_meatPuppet == 0 || pBrain->m_meatPuppet->GetCharacter().GetActor() == 0)
    {
        return ER_FAILURE;
    }
    AActor *pActor = (AActor *)pBrain->m_meatPuppet->GetCharacter().GetActor();
    if (pActor->IsA(AGwNavVehicle::StaticClass()) && m_forceFire)
    {
        ((AGwNavVehicle *)pActor)->eventExecuteVehicleCommand(2);
    }
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (pBB->GetCurrentTarget() == 0)
    {
        m_state = EBTEncircleTargetShootState_Done;
    }
    if (pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
    {
        pBB->ClearMoveCommand();
        return ER_SUCCESS;
    }
    switch (m_state)
    {
    case EBTEncircleTargetShootState_Shooting:
        if (m_fireBurstCount < m_fireBurstPerShot)
        {
            m_state = EBTEncircleTargetShootState_Delay;
            m_delayTimer = 0.0f;
        }
        else
        {
            m_state = EBTEncircleTargetShootState_Done;
        }
        break;
    case EBTEncircleTargetShootState_Delay:
        m_delayTimer = pInterface->GetDeltaTime() + m_delayTimer;
        if (m_delayTimer > m_delayBetweenBursts)
        {
            m_state = EBTEncircleTargetShootState_Shooting;
            ACCSController *pController = static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet)->m_pCCSCtrl;
            if (pBB->GetCurrentTarget()->character.m_gameCharacter.m_actor != 0)
            {
                pController->eventStartFireBurstObj(pBB->GetCurrentTarget()->character.m_gameCharacter.m_actor);
            }
            else
            {
                pController->eventStartFireBurst(pBB->GetCurrentTarget()->character.m_gameCharacter.m_pawn);
            }
            m_fireBurstCount++;
        }
        break;
    }
    return ER_INPROGRESS;
}

// @retail 0x83330FC0
void CCSRBTEncircleTarget::ExecutePostInternal(IGripBTInterface *pInterface, bool)
{
    pInterface->GetBlackboard<CCSBlackboard>();
    APawn *pPawn = static_cast<CCSBrain *>(pInterface)->m_meatPuppet->GetCharacter().m_gameCharacter.m_pawn;
    if (pPawn->IsA(AUDKVehicle::StaticClass()))
    {
        // through a member pointer: retail calls the event thunk rather than inlining it
        void (AGwNavVehicle::*const ExecuteVehicleCommand)(unsigned char) = &AGwNavVehicle::eventExecuteVehicleCommand;
        (((AGwNavVehicle *)pPawn)->*ExecuteVehicleCommand)(3);
    }
}

// ccsrbtencircletarget.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTEncircleTarget::*const EmitEncircleSetFireChance)(float) = &CCSRBTEncircleTarget::SetFireChance;
extern void (CCSRBTEncircleTarget::*const EmitEncircleSetFireBurstPerShot)(int) = &CCSRBTEncircleTarget::SetFireBurstPerShot;
extern void (CCSRBTEncircleTarget::*const EmitEncircleSetDelayBetweenBursts)(float) = &CCSRBTEncircleTarget::SetDelayBetweenBursts;
extern void (CCSRBTEncircleTarget::*const EmitEncircleSetDirectionFlags)(bool, bool) = &CCSRBTEncircleTarget::SetDirectionFlags;
extern void (CCSRBTEncircleTarget::*const EmitEncircleSetForceFire)(bool) = &CCSRBTEncircleTarget::SetForceFire;
#pragma inline_depth()

// @retail 0x8331ED10
// CCSRBTEncircleTarget::SetFireChance (in the header)
// @retail 0x8331ED18
// CCSRBTEncircleTarget::SetFireBurstPerShot (in the header)
// @retail 0x8331ED20
// CCSRBTEncircleTarget::SetDelayBetweenBursts (in the header)
// @retail 0x8331ED28
// CCSRBTEncircleTarget::SetDirectionFlags (in the header)
// @retail 0x8331ED38
// CCSRBTEncircleTarget::SetForceFire (in the header)
