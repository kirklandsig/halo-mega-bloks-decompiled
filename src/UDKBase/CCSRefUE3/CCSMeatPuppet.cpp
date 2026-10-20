// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsmeatpuppet.cpp: the CCS layer's view of a UE3 pawn and its controller:
// each call forwards to the pawn, its ICCSPawn interface or the controller.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83321668
CCS::EMovementType CCSMeatPuppet::GetMovementType()
{
    return (CCS::EMovementType)m_pCCSPawn->GetMovementType();
}

// @retail 0x833216A0
void CCSMeatPuppet::SetMovementType(CCS::EMovementType MovementType)
{
    m_pCCSPawn->SetMovementType((unsigned char)MovementType);
}

// @retail 0x833216B8
void CCSMeatPuppet::SetMovementTypeDefault()
{
    m_pCCSPawn->SetMovementTypeDefault();
}

// @retail 0x833216D0
void CCSMeatPuppet::SetMovementSpeedDefault()
{
    m_pCCSPawn->SetMovementSpeedDefault();
}

// @retail 0x833216E8
CCS::EAlertnessState CCSMeatPuppet::GetAlertness()
{
    return (CCS::EAlertnessState)m_pCCSPawn->GetAlertness();
}

// @retail 0x83321720
void CCSMeatPuppet::SetAlertness(CCS::EAlertnessState Alertness)
{
    m_pCCSPawn->SetAlertness((unsigned char)Alertness);
}

// @retail 0x83321738
void CCSMeatPuppet::SetAlertnessDefault()
{
    m_pCCSPawn->SetAlertnessDefault();
}

// @retail 0x83321750
CCS::EMovementSpeed CCSMeatPuppet::GetSpeed()
{
    return (CCS::EMovementSpeed)m_pCCSPawn->GetSpeed();
}

// @retail 0x83321788
void CCSMeatPuppet::SetSpeed(CCS::EMovementSpeed Speed)
{
    m_pCCSPawn->SetSpeed((unsigned char)Speed);
}

// @retail 0x833217A0
bool CCSMeatPuppet::IsMoving()
{
    return !m_pUnPawn->Velocity.IsNearlyZero(0.0001f);
}

// @retail 0x833217F0
bool CCSMeatPuppet::ReachedPoint(Grip_Vector Point)
{
    return m_pUnPawn->ReachThresholdTest(m_pUnPawn->Location, Point, 0, 0.0f, 0.0f, 16.0f) != 0;
}

// @retail 0x83321868
void CCSMeatPuppet::Stop()
{
    m_pUnPawn->Velocity = FVector(0.0f, 0.0f, 0.0f);
    m_pUnPawn->Acceleration = FVector(0.0f, 0.0f, 0.0f);
}

// @retail 0x833218C8
bool CCSMeatPuppet::IsCrouched()
{
    return m_pCCSPawn->IsCrouched() != 0;
}

// @retail 0x83321900
void CCSMeatPuppet::SetCrouched(bool bCrouched)
{
    m_pCCSPawn->SetCrouched(bCrouched);
}

// @retail 0x83321918
void CCSMeatPuppet::SetPostureDefault()
{
    m_pCCSPawn->SetPostureDefault();
}

// @retail 0x83321930
bool CCSMeatPuppet::PostureTransitionOver()
{
    return m_pCCSPawn->PostureTransitionOver() != 0;
}

// @retail 0x83321968
bool CCSMeatPuppet::CanAim(Grip_Rotation Rotation)
{
    return m_pCCSPawn->CanAim(Rotation) != 0;
}

// near: as HasLineOfSightTo below
// @retail 0x833219C8
bool CCSMeatPuppet::CanFireAt(CCSCharacter Character)
{
    // through a member pointer: retail calls the event thunk here rather than inlining it
    return (m_pCCSCtrl->*(&ACCSController::eventCanFireAt))(Character.m_gameCharacter.m_actor != 0 ? Character.m_gameCharacter.m_actor
                                                                                                     : Character.m_gameCharacter.m_pawn)
        != 0;
}

// @retail 0x83321A10
Grip_Vector CCSMeatPuppet::GetWeaponStartPosition()
{
    return Grip_Vector(m_pUnPawn->eventGetWeaponStartTraceLocation(0));
}

// near: retail loads the controller and its vtable entry before it picks
// the actor; ours picks it first (named locals, an if and the ternary tried)
// @retail 0x83321A68
bool CCSMeatPuppet::HasLineOfSightTo(CCSCharacter Character)
{
    return m_pCCSCtrl->LineOfSightTo(Character.m_gameCharacter.m_actor != 0 ? Character.m_gameCharacter.m_actor : Character.m_gameCharacter.m_pawn, 0, 0, 0)
        != 0;
}

// @retail 0x83321AC8
int CCSMeatPuppet::GetTeam()
{
    return m_pUnPawn->GetTeamNum();
}

// @retail 0x83321B00
bool CCSMeatPuppet::CanPlayerSeeMe()
{
    return m_pUnPawn->PlayerCanSeeMe(0) != 0;
}

// @retail 0x83321B30
int CCSMeatPuppet::GetHealth()
{
    return m_pUnPawn->Health;
}

// @retail 0x833436D8
bool CCSMeatPuppet::HasHeardCharacter(CCSCharacter Character)
{
    const int Index = m_pCCSCtrl->NoiseMakers.FindItemIndex(Character.m_gameCharacter.m_pawn);
    if (Index != INDEX_NONE)
    {
        m_pCCSCtrl->NoiseMakers.Remove(Index);
    }
    return Index != INDEX_NONE;
}

// @retail 0x83321B40
CCSCharacter CCSMeatPuppet::GetCharacter()
{
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = m_pUnPawn;
    return Character;
}

// @retail 0x83321B68
void CCSMeatPuppet::NotifyAIMoveToActorCompleted()
{
    m_pCCSCtrl->eventNotifyAIMoveToActorCompleted();
}

// @retail 0x83321BD0
void CCSMeatPuppet::SetCoverPose(CCS::ECoverPose Pose, float BlendTime)
{
    m_pCCSPawn->SetCoverPose((unsigned char)Pose, BlendTime);
}

// @retail 0x83321BE8
void CCSMeatPuppet::SetNoCoverPose()
{
    m_pCCSPawn->SetNoCoverPose();
}

// @retail 0x83321C00
void CCSMeatPuppet::MoveToInCover(Grip_Vector Position)
{
    m_pCCSPawn->MoveToInCover(Position);
}

// @retail 0x83321C60
bool CCSMeatPuppet::CoverPoseTransitionOver()
{
    return m_pCCSPawn->CoverPoseTransitionOver() != 0;
}

// @retail 0x83321C98
bool CCSMeatPuppet::AimedAt()
{
    if (m_pCCSCtrl->AimedAt)
    {
        m_pCCSCtrl->AimedAt = 0;
        return true;
    }
    return false;
}

// @retail 0x83321CD0
bool CCSMeatPuppet::Threatened()
{
    if (m_pCCSCtrl->NewThreat)
    {
        m_pCCSCtrl->NewThreat = 0;
        return true;
    }
    return false;
}

// @retail 0x83321D08
bool CCSMeatPuppet::GrenadeStuck()
{
    if (m_pCCSCtrl->GrenadeStuck)
    {
        m_pCCSCtrl->GrenadeStuck = 0;
        return true;
    }
    return false;
}

// @retail 0x83321D40
bool CCSMeatPuppet::Staggered()
{
    if (m_pCCSCtrl->Staggered)
    {
        m_pCCSCtrl->Staggered = 0;
        return true;
    }
    return false;
}

// @retail 0x83321D78
bool CCSMeatPuppet::SuccessfulAttack()
{
    if (m_pCCSCtrl->SuccessfulAttack)
    {
        m_pCCSCtrl->SuccessfulAttack = 0;
        return true;
    }
    return false;
}

// @retail 0x83321DB0
bool CCSMeatPuppet::HeardNoise()
{
    return m_pCCSCtrl->HasHeardNoise;
}

// @retail 0x83321DC0
bool CCSMeatPuppet::Event()
{
    if (m_pCCSCtrl->NewEvent)
    {
        m_pCCSCtrl->NewEvent = 0;
        return true;
    }
    return false;
}

// @retail 0x83321DF8
EEventType CCSMeatPuppet::GetEventType()
{
    return (EEventType)m_pCCSCtrl->EventType;
}

// @retail 0x83321E08
Grip_Vector CCSMeatPuppet::GetThreatLocation()
{
    return m_pCCSCtrl->ThreatLocation;
}

// @retail 0x83321E28
Grip_Vector CCSMeatPuppet::GetThreatDirection()
{
    return m_pCCSCtrl->ThreatDirection;
}

// @retail 0x83321E48
Grip_Vector CCSMeatPuppet::GetEventLocation()
{
    return m_pCCSCtrl->EventLocation;
}

// @retail 0x83321E68
EThreatType CCSMeatPuppet::GetThreatType()
{
    return (EThreatType)m_pCCSCtrl->ThreatType;
}

// @retail 0x83321E78
UClass *CCSMeatPuppet::GetEventClass()
{
    return m_pCCSCtrl->EventClass;
}

// @retail 0x83321E88
bool CCSMeatPuppet::GetIsPanicking()
{
    return m_pCCSPawn->GetIsPanicking() != 0;
}

// @retail 0x83321EC0
void CCSMeatPuppet::SetIsPanicking(bool bPanicking)
{
    m_pCCSPawn->SetIsPanicking(bPanicking);
}

// @retail 0x83321ED8
UAnimNodeSlot *CCSMeatPuppet::GetFullBodyAnimSlot()
{
    return (UAnimNodeSlot *)m_pUnPawn->Mesh->FindAnimNode(FName("FullBodySlot", FNAME_Add));
}

// @retail 0x83321F28
UAnimNodeSlot *CCSMeatPuppet::GetTopHalfAnimSlot()
{
    return (UAnimNodeSlot *)m_pUnPawn->Mesh->FindAnimNode(FName("TopHalfSlot", FNAME_Add));
}

// @retail 0x83321F78
void CCSMeatPuppet::DrawHUD(GripHUDRenderer *pRenderer, int &Y)
{
    m_pCCSCtrl->DrawHUD(pRenderer, Y);
}

// iccsmeatpuppet.h's destructor, out of line as in retail
// @retail 0x8331E7F0
// ICCSMeatPuppet::~ICCSMeatPuppet (in the header)
#pragma inline_depth(0)
#ifndef HAGGAR_HOST
void EmitMeatPuppetInterfaceDestructor(ICCSMeatPuppet *pMeatPuppet)
{
    pMeatPuppet->ICCSMeatPuppet::~ICCSMeatPuppet();
}
#endif
#pragma inline_depth()
