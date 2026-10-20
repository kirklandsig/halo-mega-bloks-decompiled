// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetotether.cpp: the behaviour-tree node that strafes back to the
// pawn's tether point, facing the current target.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSRBTMoveTo.cpp"
#include "CCSCSMovement.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83331F08
CCSRBTMoveToTether::CCSRBTMoveToTether() : m_actionHandle(-1), m_pMovementCS(0)
{
}
#endif

// @retail 0x83324B98
void CCSRBTMoveToTether::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagCurrentTarget();
    pBB->m_currentTether.FlagAsUsed();
}

// @retail 0x83331F80
bool CCSRBTMoveToTether::TestPreCondition(IGripBTInterface *pInterface)
{
    return pInterface->GetBlackboard<CCSBlackboard>() != 0;
}

// near: the objective gets its own frame slot where retail reuses the
// character temporary's (a 0x10 bigger frame)
// @retail 0x8333F598
GripRBTNode::EBTExecutionResult CCSRBTMoveToTether::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
{
    CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
    CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    m_pMovementCS = static_cast<CCSCSMovement *>(pBrain->m_systems.GetSystem(CCSCSMovement::SGetFamily(), CCSCSMovement::SGetId()));
    tetherStartedInVehicle = false;
    m_actionHandle = -1;
    if (pBB == 0 || pBrain == 0)
    {
        return ER_FAILURE;
    }
    Cast<AUDKWeaponPawn>(static_cast<CCSMeatPuppet *>(pBrain->m_meatPuppet)->m_pUnPawn);
    CCSTarget *pTarget = pBB->GetCurrentTarget();
    tetherStartedInVehicle = false;
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
    if (tetherStartedInVehicle)
    {
        StartMoveToSeat(pInterface);
        return ER_INPROGRESS;
    }
    pBrain->m_meatPuppet->GetCharacter();
    CCSAOStrafeTo Objective = {Grip_Vector(pBB->GetCurrentTether()), CCS::MovementType_Strafe, m_alertness};
    m_actionHandle = pFactory->CreateActionInternal<CCSAOStrafeTo, CCSAFStrafeTo>(Objective);
    pScheduler->Execute(m_actionHandle);
    m_objective.movementType = CCS::MovementType_Strafe;
    m_objective.alertness = CCS::AlertnessState_Alert;
    m_objective.moveTarget = Grip_Vector(pBB->GetCurrentTether());
    if (pTarget != 0)
    {
        m_objective.pTarget = pTarget->character.GetActor();
    }
    else
    {
        m_objective.pTarget = 0;
    }
    m_objective.orientTarget =
        m_objective.pTarget != 0 ? GripEngineServices::GetActorPosition(m_objective.pTarget) : Grip_Vector(pBB->GetCurrentTether());
    m_pMovementCS->SetObjective(m_objective);
    m_pMovementCS->Activate();
    return ER_INPROGRESS;
}

// @retail 0x8333F878
GripRBTNode::EBTExecutionResult CCSRBTMoveToTether::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *pStack, bool bInterrupt)
{
    CCSRBTMoveTo::ExecuteInternal(pInterface, pStack, bInterrupt);
    pInterface->GetBlackboard<CCSBlackboard>();
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (tetherStartedInVehicle || pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_FAILURE)
    {
        return ER_FAILURE;
    }
    Cast<AUDKWeaponPawn>(static_cast<CCSMeatPuppet *>(static_cast<CCSBrain *>(pInterface)->m_meatPuppet)->m_pUnPawn);
    pInterface->GetBlackboard<CCSBlackboard>();
    return pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE ? ER_SUCCESS : ER_INPROGRESS;
}

// todo: 4 bytes short; retail keeps the blackboard pointer in r11 for
// ClearMoveCommand's store where ours stores through the member's address
// (a named blackboard and Set written out tried)
// @retail 0x83331FB8
void CCSRBTMoveToTether::ExecutePostInternal(IGripBTInterface *pInterface, bool bAborted)
{
    CCSRBTMoveTo::ExecutePostInternal(pInterface, bAborted);
    pInterface->GetBlackboard<CCSBlackboard>()->ClearMoveCommand();
    static_cast<CCSBrain *>(pInterface)->m_meatPuppet->NotifyAIMoveToActorCompleted();
}

// @retail 0x83332020
void CCSRBTMoveToTether::StartMoveToSeat(IGripBTInterface *pInterface)
{
    pInterface->GetActionScheduler();
    pInterface->GetActionFactory<CCSAFFactory>();
}
