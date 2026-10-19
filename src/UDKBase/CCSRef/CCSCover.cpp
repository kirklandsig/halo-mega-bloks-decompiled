// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscover.cpp. Other files of the unity include this one for the
// definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83323CB0
CCSCover::CCSCover()
    : m_state(CCS::CoverState_NotSet), m_inUseByMe(false), m_targetDist(0.0f), m_directDistance(0.0f), m_validPath(false),
      m_validDefense(false), m_pathDistance(0.0f)
{
}
