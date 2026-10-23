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

// score 19 (was 21): the zeroing matches (retail's Grip_Rotation constructor
// zeroes Roll, Yaw, Pitch in that order, so the shared header's does too).
// Left: retail loads the target's three components, then the character's,
// and subtracts; ours interleaves the two vectors pair by pair. And the cover
// orientation goes to a fresh stack slot instead of the one the difference
// vector vacated. The load order is the compiler's: both lanes tried a named
// delta, the delta by components, explicit Grip_Vector temporaries, float
// locals for the components and the differences, a const reference, the
// character's position first, no position locals, the rotations in locals or
// in one expression, and the shared operator- rewritten three ways (swapping
// its operands changes the subtraction order, not the schedule); a ten-minute
// permuter run found nothing.
// This session: every spelling MSVC accepts compiles to the same interleaved
// schedule - named delta, delta by components, explicit Grip_Vector temporary,
// float locals, a const reference, the positions fetched inline, FVector
// arithmetic, an arg-first helper, the shared operator- reversed in the
// header (right values, same schedule): all score 19. A copy-then-subtract
// helper scores 79. Retail's shape is the one of the vendor's out-of-line
// Grip_Vector::operator* (0x8331B338): one vector's three components load as
// a group, the other's interleave with the arithmetic, so the vendor's
// operator- probably copies *this and subtracts into the copy.
// This session: the group is not the operator-'s doing. A scratch file built
// with the XDK's cl shows MSVC interleaving the two operands' loads for every
// spelling of the difference (A-B, the components one by one, the
// three-argument constructor, UE3's FVector operator-, the same source), while
// a copy-then-subtract does a bitwise struct copy into the result slot: the
// grouped loads of the first operand are not reachable from operator- at all.
// Tried here: a copy-then-subtract helper (79), the same helper with a
// memberwise copy (19), a named delta subtracted by components (79), a named
// delta (19), the three-argument constructor (19), float locals (19),
// memberwise into a local (19), the character position inlined in the
// expression (22), both positions inlined (38), the operands swapped (19) and
// the shared operator- rewritten as copy-then-subtract (19): 19 or worse.
// The two differences left are the frame slots: retail reuses the difference
// vector's slot for the cover orientation and the rotation's slot for the
// second cover orientation, ours reuses the character copy's slot for both.
// @retail 0x8332F4B0
Grip_Rotation CCSCSCover::GetCrouchCoverRot()
{
    Grip_Rotation Rotation;  // the constructor zeroes it
    Grip_Vector TargetPosition = m_target.GetPosition();
    Grip_Vector CharPosition = m_pMeatPuppet->GetCharacter().GetPosition();
    Rotation = (TargetPosition - CharPosition).Rotation();
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
