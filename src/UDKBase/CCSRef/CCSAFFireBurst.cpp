// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSAFModifiers.cpp"

// @retail 0x83327D90
CCSAFFireBurst::CCSAFFireBurst() {}

// @retail 0x8331E848
void CCSAFFireBurst::SetObjective(const CCSAOFireBurst &Objective)
{
    m_objective = Objective;
}

// @retail 0x833360A0
void CCSAFFireBurst::PostCreate()
{
    if (m_pMeatPuppet != 0)
    {
        m_pCCSCtrl = static_cast<CCSMeatPuppet *>(m_pMeatPuppet)->m_pCCSCtrl;
        m_modifiers.AddItem(new CCSAFAlertnessModifier(m_pMeatPuppet, CCS::AlertnessState_Alert));
    }
}

// @retail 0x83328BF0
void CCSAFFireBurst::OnActivate()
{
    GripAFAction::OnActivate();
    fAbort = 5.0f;
    if (m_pCCSCtrl->Pawn->IsA(AVehicle::StaticClass()) || m_pCCSCtrl->Pawn->IsA(AUDKWeaponPawn::StaticClass()))
    {
        m_pCCSCtrl->SetFocalPoint(m_objective.target.GetPosition(), 1);
    }
    if (m_objective.target.m_gameCharacter.m_actor != 0)
    {
        m_pCCSCtrl->eventStartFireBurstObj(m_objective.target.m_gameCharacter.m_actor);
    }
    else
    {
        m_pCCSCtrl->eventStartFireBurst(m_objective.target.m_gameCharacter.m_pawn);
    }
}

// @retail 0x8331E868
bool CCSAFFireBurst::TransitionTo(GripAFAction *pNext)
{
    m_pCCSCtrl->eventActionStopFiring();
    return GripAFAction::TransitionTo(pNext);
}

// @retail 0x83328D40
void CCSAFFireBurst::Tick(float DeltaTime)
{
    if (m_pCCSCtrl->FireBurstCount > 0)
    {
        m_pCCSCtrl->eventStopFireBurst();
        m_status = AS_DONE;
    }
    else if (!m_pCCSCtrl->eventFireWeapon(rand() * (1.0f / 32767) < m_objective.chargeChance, m_objective.isLastShot, m_objective.alwaysFire))
    {
        m_status = AS_FAILURE;
        m_pCCSCtrl->eventActionStopFiring();
    }
    if (m_pCCSCtrl->Pawn->IsA(AVehicle::StaticClass()))
    {
        m_pCCSCtrl->SetFocalPoint(m_objective.target.GetPosition(), 1);
    }
    fAbort -= DeltaTime;
    if (m_status != AS_DONE && fAbort <= 0.0f)
    {
        m_status = AS_FAILURE;
        m_pCCSCtrl->eventActionStopFiring();
    }
}

// @retail 0x83327E00
// CCSAFFireBurst::~CCSAFFireBurst
// @retail 0x83327E08
// CCSAFFireBurst::`scalar deleting destructor'
