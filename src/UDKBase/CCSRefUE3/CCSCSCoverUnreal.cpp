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

// score 12 (was 94): the cover location is a Grip_Vector built straight from
// the slot query's FVector result, the cover is held in a reference so the
// slot query keeps the game cover's address, and the switch runs on a named
// cover type so the dispatch maps the type to a case index; the retail's
// frame is still 0x110 against our 0x140 and the direction, the rotator's
// temporary and the second character take slots of their own. Tried this
// session: an explicit FRotator temporary in front of the Grip_Rotation
// copy (score 29) and about twenty other source shapes (const qualifiers,
// references, declaration order, split or merged switch cases, named or
// unnamed facing rotation), all of which stayed at 12; the retail's layout
// wants the slot rotation's return buffer in the rotator's own slot at
// 0x60 and no named facing rotation, which none of them reproduced.
// @retail 0x833432A8
bool CCSCSCoverUnreal::DoGetInCover()
{
    OverrideFocus();
    const CCSGameCover &Cover = m_currentCover.m_gameCover;
    Grip_Vector CoverLoc = Cover.m_coverInfo.Link->GetSlotLocation(Cover.m_coverInfo.SlotIdx, 0);
    const CCS::ECoverType Type = Cover.GetType();
    switch (Type)
    {
    case CCS::CoverType_Stand:
    {
        Grip_Rotation Rot = Cover.m_coverInfo.Link->GetSlotRotation(Cover.m_coverInfo.SlotIdx, 0);
        m_pMeatPuppet->GetCharacter().m_gameCharacter.m_pawn->SetDesiredRotation(Rot, 1, 1, 0.1f, 0);
        if (!m_pMeatPuppet->ReachedPoint(CoverLoc))
        {
            CCSCharacter MPCharacter = m_pMeatPuppet->GetCharacter();
            Grip_Vector Direction = CoverLoc - MPCharacter.GetPosition();
            Direction.Z = 0.0f;
            Grip_Rotation Facing;
            Direction.Normalize();
            Facing = Direction.Rotation();
            m_pMeatPuppet->GetCharacter();
        }
        break;
    }
    case CCS::CoverType_Crouch:
        GetCrouchCoverRot();
        m_pMeatPuppet->SetCrouched(true);
        break;
    default:
        break;
    }
    return true;
}

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
    {
        CCSCSCover::ELeaningSide Side = GetLeaningSide();
        if (Side == LS_RIGHT)
        {
            TakeCoverPose(CCS::CoverPose_SideStepRight, Me.GetOrientation(), m_currentCover.GetShootPosition(CCS::CoverShootConfig_Right, Me.GetSize()));
        }
        else if (Side == LS_LEFT)
        {
            TakeCoverPose(CCS::CoverPose_SideStepLeft, Me.GetOrientation(), m_currentCover.GetShootPosition(CCS::CoverShootConfig_Left, Me.GetSize()));
        }
        else if (Side == LS_CENTER)
        {
            TakeCoverPose(CCS::CoverPose_ShootOver, Me.GetOrientation(), Me.GetPosition());
        }
        break;
    }
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

// @retail 0x833208F8
void CCSCSCoverUnreal::TakeCoverPose(CCS::ECoverPose Pose, Grip_Rotation Rotation, Grip_Vector Location)
{
    m_pUnMeatPuppet->SetCoverPose(Pose, -1.0f);
    Grip_Rotation Normalized = Rotation;
    Normalized.Normalize();
    m_pBasePawn->SetDesiredRotation(FRotator(Normalized), 0, 0, -1.0f, 1);
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
