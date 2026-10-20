// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetovehicle.cpp: the behaviour-tree node that moves the pawn to the
// current target, a vehicle, and gets in.
#pragma once
#include "CCSRBTMoveToTarget.cpp"
#include "CCSCSMovement.cpp"

extern FFeedbackContext *GWarn;

// near: retail places the in-progress return after the epilogue
// @retail 0x8333F9D0
GripRBTNode::EBTExecutionResult CCSRBTMoveToVehicle::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *pStack, bool bInterrupt)
{
    if (CCSRBTMoveToTarget::ExecuteInternal(pInterface, pStack, bInterrupt) == ER_FAILURE)
    {
        return ER_FAILURE;
    }
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    if (bInterrupt)
    {
        return ER_SUCCESSFULLY_INTERRUPTED;
    }
    if (pBB->GetCurrentTarget() == 0)
    {
        return ER_FAILURE;
    }
    AActor *pActor = pBB->GetCurrentTarget()->character.m_gameCharacter.m_actor;
    if (pActor != 0)
    {
        AUDKVehicle *pVehicle = Cast<AUDKVehicle>(pActor);
        if (pVehicle != 0)
        {
            APawn *pPawn = static_cast<CCSMeatPuppet *>(static_cast<CCSBrain *>(pInterface)->m_meatPuppet)->m_pUnPawn;
            if (pPawn != 0 && (pPawn->IsA(AUDKVehicle::StaticClass()) || pVehicle->eventGwNavBotEnterVehicle(pPawn)))
            {
                return ER_SUCCESS;
            }
        }
        else
        {
            GWarn->Logf__VA(L"@#@#@#@#@#@#@#@# MoveToVehicle Failed: Target was not a AGwNavVehicle @#@#@#@#@#@#@#@#@#@#");
            return ER_FAILURE;
        }
    }
    return ER_INPROGRESS;
}

// @retail 0x8333FAF8
void CCSRBTMoveToVehicle::ExecutePostInternal(IGripBTInterface *pInterface, bool)
{
    GripBrainSystem *pMovementCS = static_cast<CCSBrain *>(pInterface)->m_systems.GetSystem(CCSCSMovement::SGetFamily(), CCSCSMovement::SGetId());
    if (pMovementCS != 0)
    {
        pMovementCS->Deactivate();
    }
}
