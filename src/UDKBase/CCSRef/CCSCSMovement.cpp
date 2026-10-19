// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscsmovement.cpp: the movement control system. Other files of the unity
// include this one for the definitions they inline.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833241B0
void CCSCSMovement::SetObjective(const CCSAOMoveTo &Objective)
{
    m_state = MS_MOVE;
    m_moveObj = Objective;
}

// @retail 0x833241D8
void CCSCSMovement::SetObjective(const CCSAOOrientToward &Objective)
{
    m_state = MS_ORIENT;
    m_orientObj = Objective;
}

// @retail 0x83324200
void CCSCSMovement::SetObjective(const CCSAOStrafeTarget &Objective)
{
    m_state = MS_STRAFE;
    m_moveObj.target = Objective.moveTarget;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
    m_orientObj.target = Objective.orientTarget;
    m_orientObj.alertness = Objective.alertness;
    m_orientObj.alwaysFire = Objective.alwaysFire;
}

// @retail 0x83324260
void CCSCSMovement::SetObjective(const CCSAOStrafeTo &Objective)
{
    m_state = MS_STRAFE;
    m_moveObj.target = Objective.target;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
}

// @retail 0x83324298
void CCSCSMovement::SetObjective(const CCSAOEncircleTarget &Objective)
{
    m_state = MS_STRAFE;
    m_moveObj.target = Objective.moveTarget;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
    m_orientObj.target = Objective.orientTarget;
    m_orientObj.alertness = Objective.alertness;
    m_orientObj.alwaysFire = Objective.alwaysFire;
}

// @retail 0x833242F8
void CCSCSMovement::SetObjective(const CCSAOFlee &Objective)
{
    m_state = MS_MOVE;
    m_moveObj.target = Objective.moveTarget;
    m_moveObj.alertness = Objective.alertness;
    m_moveObj.movementType = Objective.movementType;
}

// @retail 0x83324330
bool CCSCSMovement::ObjectiveReached() const
{
    return m_state == MS_IDLE;
}

// @retail 0x83324348
bool CCSCSMovement::PathFailed() const
{
    return false;
}
