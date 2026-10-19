// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscscover.cpp: the cover control system. Other files of the unity
// include this one for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

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
