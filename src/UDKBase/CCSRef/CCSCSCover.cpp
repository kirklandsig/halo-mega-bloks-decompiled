// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscscover.cpp: the cover control system. Other files of the unity
// include this one for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSControlSystem.cpp"
#include "CCSCover.cpp"

// @retail 0x83323EE8
bool CCSCSCover::InitiateExitCover()
{
    bool bResult = false;
    if (m_coverState == CS_NOT_IN_COVER || m_coverState == CS_EXIT_COVER)
    {
        bResult = true;
    }
    else if (m_coverState == CS_INCOVER || m_coverState == CS_OUTCOVER)
    {
        m_coverState = CS_EXIT_COVER;
        bResult = true;
    }
    return bResult;
}

// @retail 0x83323EA8
bool CCSCSCover::InitiateGetInCover(CCSCharacter Target)
{
    return InitiateEnterCover(m_currentCover, Target);
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332F380
CCSCSCover::CCSCSCover(CCSCSInterface *pCSInterface)
    : CCSControlSystem(pCSInterface), m_currentCover(CCSCover::NONE), m_target(CCSCharacter::NONE), m_coverState(CS_NOT_IN_COVER)
{
}
#endif

// @retail 0x83323D18
void CCSCSCover::Activate()
{
    m_activationState = AS_ACTIVE;
}

// @retail 0x83323D28
void CCSCSCover::Deactivate()
{
    m_coverState = CS_EXIT_COVER;
}

// @retail 0x83323D38
bool CCSCSCover::InitiateEnterCover(CCSCover &Cover, CCSCharacter Target)
{
    m_target = Target;
    OnNewTarget(Target);
    bool bResult = false;
    if (m_coverState == CS_EXIT_COVER || m_coverState == CS_NOT_IN_COVER || m_coverState == CS_OUTCOVER)
    {
        m_coverState = CS_GET_IN_COVER;
        m_currentCover = Cover;
        bResult = true;
    }
    else if (m_coverState == CS_INCOVER || m_coverState == CS_GET_IN_COVER || m_coverState == CS_GETTING_IN_COVER)
    {
        bResult = true;
    }
    return bResult;
}

// @retail 0x83323E18
bool CCSCSCover::InitiateGetOutCover(CCSCharacter Target)
{
    m_target = Target;
    OnNewTarget(Target);
    if (m_coverState == CS_INCOVER || m_coverState == CS_EXIT_COVER)
    {
        m_coverState = CS_GET_OUT_COVER;
    }
    return true;
}

// @retail 0x83323F28
bool CCSCSCover::GetOutCoverCompleted()
{
    return m_coverState == CS_OUTCOVER;
}

// @retail 0x83323F40
bool CCSCSCover::GetInCoverCompleted()
{
    return m_coverState == CS_INCOVER;
}

// @retail 0x83323F58
CCSCover CCSCSCover::GetCurrentCover() const
{
    return m_currentCover;
}

// @retail 0x83323F78
void CCSCSCover::Tick(float)
{
    switch (m_coverState)
    {
    case CS_GET_IN_COVER:
        if (!DoGetInCover())
        {
            m_coverState = CS_NOT_IN_COVER;
            return;
        }
        m_coverState = CS_GETTING_IN_COVER;
        // fall through
    case CS_GETTING_IN_COVER:
        if (DoGettingInCover())
        {
            m_coverState = CS_INCOVER;
        }
        break;
    case CS_GET_OUT_COVER:
        DoGetOutCover();
        m_coverState = CS_GETTING_OUT_COVER;
        // fall through
    case CS_GETTING_OUT_COVER:
        if (DoGettingOutCover())
        {
            m_coverState = CS_OUTCOVER;
        }
        break;
    case CS_EXIT_COVER:
        DoExitCover();
        m_coverState = CS_EXITING_COVER;
        // fall through
    case CS_EXITING_COVER:
        if (DoExitingCover())
        {
            m_coverState = CS_NOT_IN_COVER;
        }
        break;
    case CS_NOT_IN_COVER:
        m_activationState = AS_INACTIVE;
        break;
    }
}

// near: the zeroing stores and the two position temporaries are laid out
// differently (a 0x10 bigger frame; zeroing orders and a named target
// position tried)
// @retail 0x8332F4B0
Grip_Rotation CCSCSCover::GetCrouchCoverRot()
{
    Grip_Rotation Rotation;  // zeroed again below, in the order retail stores it
    Rotation.Roll = 0;
    Rotation.Yaw = 0;
    Rotation.Pitch = 0;
    Grip_Vector TargetPosition = m_target.GetPosition();
    Rotation = (TargetPosition - m_pMeatPuppet->GetCharacter().GetPosition()).Rotation();
    Rotation = Rotation - m_currentCover.GetOrientation();
    Rotation.Normalize();
    if (Rotation.Yaw > 0)
    {
        Rotation = m_currentCover.GetOrientation();
        Rotation.Yaw += 0x4000;
    }
    else
    {
        Rotation = m_currentCover.GetOrientation();
        Rotation.Yaw -= 0x4000;
    }
    return Rotation;
}

// @retail 0x833443C8
CCSCSCover::ELeaningSide CCSCSCover::GetLeaningSide()
{
    if (m_currentCover.GetShootConfig() == CCS::CoverShootConfig_LeftOrRight)
    {
        return (ELeaningSide)(Grip::Alg::Random::NextRandom() & 1);
    }
    if (m_currentCover.GetShootConfig() == CCS::CoverShootConfig_Right)
    {
        return LS_RIGHT;
    }
    return m_currentCover.GetShootConfig() == CCS::CoverShootConfig_Left ? LS_LEFT : LS_INVALID;
}

// ccscscover.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitCSCoverSGetId)() = &CCSCSCover::SGetId;
extern int (CCSCSCover::*const EmitCSCoverGetId)() const = &CCSCSCover::GetId;
#pragma inline_depth()

// @retail 0x833207A8
// CCSCSCover::SGetId (in the header)
// @retail 0x8332F440
// CCSCSCover::GetId (in the header)
