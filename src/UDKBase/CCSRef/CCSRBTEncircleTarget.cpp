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

// score 29 (was 97): the objective's target comes from a local with the
// explicit `character != NONE` test retail uses, which gives the compiler the
// shared zero constant it keeps in r29 -- and with it retail's r28..r25
// locals, the -0x48(r1) frame slot and the 0x100 frame. Left is scheduling:
// retail loads the blackboard's current target (0x108(r27)) before the
// objective's six stores and copies the factory in the middle of them, its
// two objective flags are stored in the other order, and it loads the
// circle-left slot before storing the circle distance. Tried since: a
// Grip_Vector default-constructor form in the shared header and tracing the
// 0x108 load to m_currentTarget's value slot (no change); swapping the two
// objective flags (no change - the compiler orders that pair by address);
// the actor statement between or before the flags (36 / 29); an early target
// local ahead of the objective declaration (720 bytes - the six float stores
// die as dead stores, but that form does put the load first, the two flags
// in retail's order and the circle-left load before the circle distance);
// the objective declared after the condition (37 - the load lands first but
// the stores sink past the branch); two separate ifs instead of the || (46);
// a 600 s permuter run (base 29, best 29).
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
    CCSTarget *pCurTarget = pBB->GetCurrentTarget();
    Objective.pTarget = (pCurTarget->character != CCSCharacter::NONE) ? pCurTarget->character.GetActor() : 0;
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

// score 8 (was 36): the meat puppet is read into a local and tested with an
// integer compare (retail's cmpwi); what is left is the blackboard and the
// scheduler ending up in swapped registers (r26/r27) against retail's choice.
// Tried: declaring the scheduler first, deferring its assignment, making it
// const, taking the blackboard by reference, a named status local, swapping
// the two accessor calls, dropping the pPuppet local, a 480 s permuter run
// (base 8, best 8) - none of them flips the allocation. Swapping the two
// accessor calls shows the choice follows the variables and not the
// positions (the blackboard lands in r26 and the scheduler in r27 either
// way, and the same two locals take r27/r26 in ExecutePreInternal), so it is
// the allocator's own preference, not the source order. Tried since: the
// switch rewritten as if/else if (73), a pointer compare instead of the
// integer one (10) and a 600 s permuter run (base 8, best 8).
// @retail 0x83330CE0
GripRBTNode::EBTExecutionResult CCSRBTEncircleTarget::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *, bool bInterrupt)
{
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    // The puppet is compared as an integer, as retail does.
    ICCSMeatPuppet *pPuppet = pBrain->m_meatPuppet;
    if (reinterpret_cast<int>(pPuppet) == 0 || pPuppet->GetCharacter().GetActor() == 0)
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
