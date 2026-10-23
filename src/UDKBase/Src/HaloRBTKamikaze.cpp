// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// emitted out of line in retail too
template CCSBlackboard *IGripBTInterface::GetBlackboard<CCSBlackboard>();
bool (CCSCharacter::*const EmitCharacterEquals)(const CCSCharacter &) const = &CCSCharacter::operator==;

// @retail 0x83327088
// IGripBTInterface::GetBlackboard<CCSBlackboard> (in the header)
// @retail 0x8331DB10
// CCSCharacter::operator== (in the header)

// @retail 0x8332E718
CCSTarget *CCSBlackboard::GetCurrentTarget()
{
    CCSTarget *pTarget = m_currentTarget.m_value;
    if (pTarget != 0 && !(pTarget->character == CCSCharacter::NONE))
    {
        return pTarget;
    }
    return 0;
}

// The inline setters are emitted where they are used; these uses emit them.
void EmitKamikazeSetters(HaloRBTKamikaze *k, FName a, FName b)
{
    k->SetDetonationDistance(1.0f);
    k->SetArmKamikazeAnimName(a);
    k->SetDetonateKamikazeAnimName(b);
    k->SetBlendTimes(1.0f, 2.0f);
}

// @retail 0x8331ED40
// HaloRBTKamikaze::SetDetonationDistance (inline, in the header)
// @retail 0x8331ED48
// HaloRBTKamikaze::SetArmKamikazeAnimName (inline, in the header)
// @retail 0x8331ED50
// HaloRBTKamikaze::SetDetonateKamikazeAnimName (inline, in the header)
// @retail 0x8331ED58
// HaloRBTKamikaze::SetBlendTimes (inline, in the header)

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83333A10
HaloRBTKamikaze::HaloRBTKamikaze()
    : m_actionHandle(-1)
    , m_detonationDistance(200.0f)
    , m_kamikazeState(Initialize)
    , m_FullBodyAnimSlot(0)
    , m_BlendInTime(0.0f)
    , m_BlendOutTime(0.0f)
    , kamikazeTarget(0)
{
}
#endif

// @retail 0x83333B58
GripRBTNode::EBTExecutionResult HaloRBTKamikaze::ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime)
{
    CCSRBTMoveTo::ExecutePreInternal(pInterface, bFirstTime);
    m_kamikazeState = Initialize;
    return ER_INPROGRESS;
}

// @retail 0x83333A88
bool HaloRBTKamikaze::TestPreCondition(IGripBTInterface *pInterface)
{
    CCSBlackboard *pBlackboard = pInterface->GetBlackboard<CCSBlackboard>();
    m_FullBodyAnimSlot = static_cast<CCSBrain *>(pInterface)->m_meatPuppet->GetFullBodyAnimSlot();
    if (pBlackboard->GetCurrentTarget() != 0 && m_FullBodyAnimSlot != 0)
    {
        kamikazeTarget = pBlackboard->GetCurrentTarget();
        return true;
    }
    return false;
}

// score 14 (was 23): the retail zeroes the origin before the test on the
// brain and lets CCSGameCharacter::GetPosition write straight into it (the
// origin is at 0x60), so both arms of the test read the same three words
// and the frame holds one vector. Ours still calls GetPosition into a
// second slot and keeps a separate else arm, so the frame is 0x10 bigger
// and the objective sits 0x10 higher. Still tried this session: the
// character bound to a reference (14, kept), the character taken by value
// (25), the chained GetCharacter().GetPosition() (23 - that one does give
// retail's `mr r4, r3`, the temporary's address reused through the
// returned pointer, but the call still writes into its own slot), the
// character declared before the origin (78) and the origin after the test
// (92). A scratch build shows the same call writing straight into the
// origin slot when the whole pattern sits in one small function, so
// something in this function's shape stops the copy from being elided.
// This session: a scratch file with the same pattern in a small function
// shows MSVC does unify the GetPosition result with the origin's slot
// (0x50) when the origin is read once, but not when it is read twice
// (then the result gets its own slot right above the origin, and the
// character temporary lands above that, as retail's 0x60/0x70 layout
// does). Still tried here: the character taken by value (25, its local
// at 0x80), the same with const or auto (25 each), a named Grip_Vector
// temporary for the position (25), and the chained
// GetCharacter().GetPosition() (23, kept earlier but it gives the
// GetPosition result a slot of its own at 0x70 instead of the origin's
// 0x60), so the reference to the character (14) stays the best.
// @retail 0x83340B78
GripRBTNode::EBTExecutionResult HaloRBTKamikaze::ExecuteInternal(IGripBTInterface *pInterface, GripBTStack *pStack, bool bInterrupt)
{
    EBTExecutionResult Result = ER_INPROGRESS;
    pInterface->GetBlackboard<CCSBlackboard>();
    if (kamikazeTarget == 0)
    {
        return ER_FAILURE;
    }
    GripAFScheduler *pScheduler = pInterface->GetActionScheduler();
    switch (m_kamikazeState)
    {
    case Initialize:
        m_FullBodyAnimSlot->PlayCustomAnim(m_ArmKamikazeAnimName, 1.0f, m_BlendInTime, m_BlendOutTime, 0, 0, 0.0f, 0.0f);
        m_kamikazeState = Arming;
        break;
    case Arming:
        if (!m_FullBodyAnimSlot->bIsPlayingCustomAnim)
        {
            if (kamikazeTarget->character.GetActor() == 0)
            {
                return ER_FAILURE;
            }
            pInterface->GetBlackboard<CCSBlackboard>();
            CCSAFFactory *pFactory = pInterface->GetActionFactory<CCSAFFactory>();
            CCSBrain *pBrain = static_cast<CCSBrain *>(pInterface);
            Grip_Vector Origin;
            if (pBrain != 0)
            {
                const CCSCharacter &Character = pBrain->m_meatPuppet->GetCharacter();
                Origin = Character.GetPosition();
            }
            CCSAOMoveToActor Objective = {kamikazeTarget->character.GetActor(), CCS::MovementType_Run, CCS::AlertnessState_Alert, Origin};
            m_actionHandle = pFactory->CreateActionInternal<CCSAOMoveToActor, CCSAFMoveToActor>(Objective);
            pBrain->m_meatPuppet->SetIsPanicking(1);
            pScheduler->Execute(m_actionHandle);
            m_kamikazeState = Chasing;
        }
        break;
    case Chasing:
        Result = CCSRBTMoveTo::ExecuteInternal(pInterface, pStack, bInterrupt);
        if (kamikazeTarget->range2D < m_detonationDistance || pScheduler->GetStatus(m_actionHandle) == GripAFAction::AS_DONE)
        {
            pScheduler->Abort(m_actionHandle);
            m_FullBodyAnimSlot->PlayCustomAnim(m_DetonateKamikazeAnimName, 1.0f, m_BlendInTime, m_BlendOutTime, 0, 0, 0.0f, 0.0f);
            m_kamikazeState = Detonating;
        }
        break;
    }
    if (bInterrupt)
    {
        Result = ER_SUCCESSFULLY_INTERRUPTED;
    }
    return Result;
}
