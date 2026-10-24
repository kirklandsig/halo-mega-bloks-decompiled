// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetovehicle.cpp: the behaviour-tree node that moves the pawn to the
// current target, a vehicle, and gets in.
#pragma once
#include "CCSRBTMoveToTarget.cpp"
#include "CCSCSMovement.cpp"

extern FFeedbackContext *GWarn;

// score 8 (was 8), near: the block graph is ours, only the order of the
// last three blocks is not. Retail keeps the in-progress return after the
// shared epilogue (it branches back to it) and lets the failure return fall
// into the epilogue; we keep the in-progress return before the epilogue and
// branch the failure return over it. That is the compiler's block ordering,
// not the code: splitting the pawn test into its own early return, an else
// with its own in-progress return, an else on the outer test, moving the log
// out of the else, inverting the actor and the vehicle test, a local bool for
// the pawn condition, the inverted condition, the cast in a temporary, the
// result in a local and a permuter run (6.7k rewrites) all give the same
// near 8 code.
// This session: an else-branch in-progress return, a nested else, a no-brace
// else and an else-with-failure around the log all compile to the same tail
// (near 8); only a variant that lets the outer else fall into the final
// failure moves the in-progress block, and it changes the return value of
// the no-target path, so it is not kept.
// Lane B: reworked the tail the way retail's line order reads it (the log
// falls into the failure return, the in-progress returns are explicit
// branch returns) - still near 8, the compiler merges the three in-progress
// exits into one block and keeps it before the shared epilogue. Guard-clause
// forms give 9 (the failure falls into the epilogue, but the in-progress
// block lands early), an inverted vehicle test 31, a result variable 37. A
// lab with the same shape shows MSVC only pushes a block past the epilogue
// when it is a cold block with one predecessor (the ternary arm of the
// matched UUSSATBlendByPosture::TickAnim); no shape of this function puts
// the merged in-progress block there.
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
            GWarn->Logf__VA(L"@#@#@#@#@#@#@#@# MoveToVehicle Failed: Target was not a AGwNavVehicle @#@#@#@#@#@#@#@#@#@");
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
