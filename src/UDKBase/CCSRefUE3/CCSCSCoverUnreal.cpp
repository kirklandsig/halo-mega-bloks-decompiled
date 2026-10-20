// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscscoverunreal.cpp: the cover control system's UE3 side, which moves
// the pawn into and out of cover through its controller and meat puppet.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnMath.h"
#include "CCSGameCharacter.cpp"
#include "CCSGameCover.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83338110
CCSCSCoverUnreal::CCSCSCoverUnreal(CCSCSInterface *pInterface)
    : CCSCSCover(pInterface)
    , m_pCCSController(0)
    , m_pBasePawn(0)
{
    m_pUnMeatPuppet = static_cast<CCSMeatPuppet *>(m_pMeatPuppet);
    m_pCCSController = m_pUnMeatPuppet->m_pCCSCtrl;
    m_pBasePawn = m_pUnMeatPuppet->m_pUnPawn;
}
#endif

// Todo (520 bytes vs 548): the calls are retail's, but retail keeps the
// slot position and the unused results in other stack slots.
// @retail 0x833432A8
bool CCSCSCoverUnreal::DoGetInCover()
{
    OverrideFocus();
    Grip_Vector Position = m_currentCover.m_gameCover.m_coverInfo.Link->GetSlotLocation(m_currentCover.m_gameCover.m_coverInfo.SlotIdx, 0);
    switch (m_currentCover.GetType())
    {
    case CCS::CoverType_Stand:
    {
        FRotator Rotation = m_currentCover.m_gameCover.m_coverInfo.Link->GetSlotRotation(m_currentCover.m_gameCover.m_coverInfo.SlotIdx, 0);
        m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn->SetDesiredRotation(Rotation, 1, 1, 0.1f, 0);
        if (!m_pMeatPuppet->ReachedPoint(Position))
        {
            Grip_Vector Direction = Position - m_pMeatPuppet->GetCharacter().GetPosition();
            Direction.Z = 0.0f;
            Direction.Normalize();
            Grip_Rotation Facing = Direction.Rotation();
            m_pMeatPuppet->GetCharacter();
        }
        break;
    }
    case CCS::CoverType_Crouch:
        GetCrouchCoverRot();
        m_pMeatPuppet->SetCrouched(true);
        break;
    }
    return true;
}

// Todo (512 bytes vs 580): retail shares one TakeCoverPose call between the
// cases and keeps the character copy in another slot; inlined there,
// CCSGameCharacter::GetHeight also reads the pawn's cylinder first (its
// out-of-line copy doesn't), which ours doesn't reproduce.
// @retail 0x8334B370
void CCSCSCoverUnreal::DoGetOutCover()
{
    m_pCCSController->AimingFocus = m_pCCSController->Enemy;
    CCSCharacter Me = m_pMeatPuppet->GetCharacter();
    switch (m_currentCover.GetType())
    {
    case CCS::CoverType_Crouch:
        TakeCoverPose(CCS::CoverPose_ShootOver, m_pMeatPuppet->GetCharacter().GetOrientation(), m_pMeatPuppet->GetCharacter().GetPosition());
        break;
    case CCS::CoverType_Stand:
        switch (GetLeaningSide())
        {
        case LS_RIGHT:
            TakeCoverPose(CCS::CoverPose_SideStepRight, Me.GetOrientation(), m_currentCover.GetShootPosition(CCS::CoverShootConfig_Right, Me.GetHeight()));
            break;
        case LS_LEFT:
            TakeCoverPose(CCS::CoverPose_SideStepLeft, Me.GetOrientation(), m_currentCover.GetShootPosition(CCS::CoverShootConfig_Left, Me.GetHeight()));
            break;
        case LS_CENTER:
            TakeCoverPose(CCS::CoverPose_ShootOver, Me.GetOrientation(), Me.GetPosition());
            break;
        }
        break;
    }
}

// @retail 0x8332A898
bool CCSCSCoverUnreal::DoGettingInCover()
{
    bool bResult = false;
    if (CoverPoseReached() && m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn->ReachedDesiredRotation())
    {
        m_pMeatPuppet->Stop();
        bResult = true;
    }
    else
    {
        m_pUnMeatPuppet->MoveToInCover(m_pCCSController->GetDestinationPosition());
    }
    return bResult;
}

// @retail 0x8332A968
bool CCSCSCoverUnreal::DoGettingOutCover()
{
    bool bResult = false;
    if (CoverPoseReached())
    {
        m_pMeatPuppet->Stop();
        m_pUnMeatPuppet->SetCoverPose(CCS::CoverPose_ShootOver, 0.0f);
        bResult = true;
    }
    else
    {
        m_pUnMeatPuppet->MoveToInCover(m_pCCSController->GetDestinationPosition());
    }
    return bResult;
}

// @retail 0x833207B8
void CCSCSCoverUnreal::DoExitCover()
{
    m_currentCover = CCSCover::NONE;
    m_pCCSController->AimingFocus = 0;
    m_pMeatPuppet->Stop();
    m_pMeatPuppet->SetPostureDefault();
    m_pUnMeatPuppet->SetNoCoverPose();
}

// @retail 0x83320850
void CCSCSCoverUnreal::OnNewTarget(CCSCharacter Target)
{
    m_pCCSController->Enemy = Target.m_gameCharacter.m_pawn;
}

// @retail 0x83320870
bool CCSCSCoverUnreal::CoverPoseReached()
{
    bool bResult = false;
    m_pCCSController->GetDestinationPosition();
    if (m_pMeatPuppet->PostureTransitionOver() && m_pUnMeatPuppet->CoverPoseTransitionOver())
    {
        bResult = true;
    }
    return bResult;
}

// Todo (296 bytes vs 292): retail normalizes the rotation straight from the
// parameter's stack slots; ours stores a copy first (tried a named rotator,
// normalizing in place, and NormalizeAxis on each component).
// @retail 0x833208F8
void CCSCSCoverUnreal::TakeCoverPose(CCS::ECoverPose Pose, Grip_Rotation Rotation, Grip_Vector Location)
{
    m_pUnMeatPuppet->SetCoverPose(Pose, -1.0f);
    m_pBasePawn->SetDesiredRotation(FRotator(Rotation).GetNormalized(), 0, 0, -1.0f, 1);
    m_pBasePawn->bReducedSpeed = 0;
    m_pBasePawn->DesiredSpeed = m_pBasePawn->MaxDesiredSpeed;
    m_pBasePawn->DestinationOffset = 0.0f;
    m_pCCSController->SetDestinationPosition(Location, 0);
}

// @retail 0x83320A20
void CCSCSCoverUnreal::OverrideFocus()
{
    m_pCCSController->Focus = 0;
    m_pCCSController->SetFocalPoint(FVector(0.0f, 0.0f, 0.0f), 0);
}
