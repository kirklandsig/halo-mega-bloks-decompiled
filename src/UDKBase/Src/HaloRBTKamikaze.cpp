// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
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

// Todo: retail zeroes the origin and has CCSGameCharacter::GetPosition write
// straight into it; ours goes through a temporary (and a larger frame).
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
            Grip_Vector Origin = pBrain != 0 ? pBrain->m_meatPuppet->GetCharacter().GetPosition() : Grip_Vector();
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
