// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccspsselfawareness.cpp: the sensor that keeps a brain's view of its own
// pawn on the blackboard: team, health, and the time since it was damaged,
// aimed at, threatened, staggered and so on.
#pragma once
#include "CCSSensorSystem.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833305B0
CCSPSSelfAwareness::CCSPSSelfAwareness(CCSBrain *pBrain) : CCSSensorSystem(pBrain)
{
}
#endif

// @retail 0x833703C0
void CCSPSSelfAwareness::Tick(float DeltaTime)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    pBB->m_team.Set(m_pBrain->m_meatPuppet->GetTeam());
    pBB->m_visibleToPlayerCamera.Set(m_pBrain->m_meatPuppet->CanPlayerSeeMe() != 0);
    UpdateTimePassed(DeltaTime);
    if (pBB->m_health.Get() == 0x7FFFFFFF)
    {
        pBB->m_health.Set(m_pBrain->m_meatPuppet->GetHealth());
    }
    if (m_pBrain->m_meatPuppet->GetHealth() < pBB->m_health.Get())
    {
        OnTookDamage();
    }
    pBB->m_health.Set(m_pBrain->m_meatPuppet->GetHealth());
    if (m_pBrain->m_meatPuppet->AimedAt())
    {
        OnAimedAt();
    }
    if (m_pBrain->m_meatPuppet->Threatened())
    {
        OnThreatened();
    }
    if (m_pBrain->m_meatPuppet->GrenadeStuck())
    {
        OnGrenadeStuck();
    }
    if (m_pBrain->m_meatPuppet->Staggered())
    {
        OnStaggered();
    }
    if (m_pBrain->m_meatPuppet->SuccessfulAttack())
    {
        OnSuccessfulAttack();
    }
    if (m_pBrain->m_meatPuppet->HeardNoise())
    {
        OnHeardNoise();
    }
    if (m_pBrain->m_meatPuppet->Event())
    {
        OnEvent();
    }
}

// @retail 0x8336F530
void CCSPSSelfAwareness::OnTookDamage()
{
    m_pBrain->GetBlackboard<CCSBlackboard>()->m_timeSinceDamage.Set(0.0f);
    BecomeAware(true);
}

// @retail 0x83330678
void CCSPSSelfAwareness::OnAimedAt()
{
    m_pBrain->GetBlackboard<CCSBlackboard>()->m_timeSinceAimedAt.Set(0.0f);
}

// @retail 0x833306C0
void CCSPSSelfAwareness::OnThreatened()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    pBB->m_timeSinceThreatened.Set(0.0f);
    pBB->m_threatLocation.Set(m_pBrain->m_meatPuppet->GetThreatLocation());
    pBB->m_threatDirection.Set(m_pBrain->m_meatPuppet->GetThreatDirection());
    pBB->m_threatType.Set(m_pBrain->m_meatPuppet->GetThreatType());
}

// @retail 0x833307B0
void CCSPSSelfAwareness::OnGrenadeStuck()
{
    m_pBrain->GetBlackboard<CCSBlackboard>()->m_timeSinceGrenadeStuck.Set(0.0f);
}

// @retail 0x833307F8
void CCSPSSelfAwareness::OnStaggered()
{
    m_pBrain->GetBlackboard<CCSBlackboard>()->m_timeSinceStaggered.Set(0.0f);
}

// @retail 0x83330840
void CCSPSSelfAwareness::OnSuccessfulAttack()
{
    m_pBrain->GetBlackboard<CCSBlackboard>()->m_timeSinceSuccessfulAttack.Set(0.0f);
}

// @retail 0x8336F590
void CCSPSSelfAwareness::OnHeardNoise()
{
    m_pBrain->GetBlackboard<CCSBlackboard>();
    BecomeAware(false);
}

// @retail 0x83330888
void CCSPSSelfAwareness::OnEvent()
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    pBB->m_eventType.Set(m_pBrain->m_meatPuppet->GetEventType());
    pBB->m_timeSinceEvent.Set(0.0f);
    pBB->m_eventLocation.Set(m_pBrain->m_meatPuppet->GetEventLocation());
    pBB->m_eventSenderClass.Set(m_pBrain->m_meatPuppet->GetEventClass());
}

// @retail 0x83330960
void CCSPSSelfAwareness::UpdateTimePassed(float DeltaTime)
{
    CCSBlackboard *pBB = m_pBrain->GetBlackboard<CCSBlackboard>();
    if (pBB->m_timeSinceDamage.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceDamage.Set(pBB->m_timeSinceDamage.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceAimedAt.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceAimedAt.Set(pBB->m_timeSinceAimedAt.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceThreatened.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceThreatened.Set(pBB->m_timeSinceThreatened.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceGrenadeStuck.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceGrenadeStuck.Set(pBB->m_timeSinceGrenadeStuck.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceStaggered.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceStaggered.Set(pBB->m_timeSinceStaggered.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceSuccessfulAttack.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceSuccessfulAttack.Set(pBB->m_timeSinceSuccessfulAttack.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceEvent.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceEvent.Set(pBB->m_timeSinceEvent.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceThreatTargetChanged.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceThreatTargetChanged.Set(pBB->m_timeSinceThreatTargetChanged.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceTargetCamoed.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceTargetCamoed.Set(pBB->m_timeSinceTargetCamoed.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceBecameAware.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceBecameAware.Set(pBB->m_timeSinceBecameAware.Get() + DeltaTime);
    }
    if (pBB->m_timeSinceLostAware.Get() < 3.402823466e+38F)
    {
        pBB->m_timeSinceLostAware.Set(pBB->m_timeSinceLostAware.Get() + DeltaTime);
    }
}
