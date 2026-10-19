// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"

// Runtime nodes whose constructors only call their base's
inline CCSRBTWaitInCover::CCSRBTWaitInCover() {}
inline CCSRBTMoveToClosestCover::CCSRBTMoveToClosestCover() {}

// griprbtcondition.h: a numeric condition starts with no operator and zeroes
inline GripRBTNumericCondition<float>::GripRBTNumericCondition()
    : m_operator(BTConditionOperator_MAX), m_threshold(0.0f), m_value(0.0f)
{
}
inline GripRBTNumericCondition<int>::GripRBTNumericCondition()
    : m_operator(BTConditionOperator_MAX), m_threshold(0), m_value(0)
{
}

// @retail 0x83329128
GripRBTNode *UCCSBTStrafeTarget::CreateRuntime()
{
    return new CCSRBTStrafeTarget;
}

// @retail 0x83329308
GripRBTNode *UCCSBTShoot::CreateRuntime()
{
    return new CCSRBTShoot;
}

// @retail 0x83329388
GripRBTNode *UCCSBTShootFromCover::CreateRuntime()
{
    return new CCSRBTShootFromCover;
}

// @retail 0x833295B8
GripRBTNode *UCCSBTWaitInCover::CreateRuntime()
{
    return new CCSRBTWaitInCover;
}

// @retail 0x83336550
GripRBTNode *UCCSBTEncircleTarget::CreateRuntime()
{
    return new CCSRBTEncircleTarget;
}

// @retail 0x83336720
GripRBTNode *UCCSBTMoveToTether::CreateRuntime()
{
    return new CCSRBTMoveToTether;
}

// @retail 0x833368F8
GripRBTNode *UCCSBTTargetShootable::CreateRuntime()
{
    return new CCSRBTTargetShootable;
}

// @retail 0x83336A10
GripRBTNode *UCCSBTTargetClear::CreateRuntime()
{
    return new CCSRBTTargetClear;
}

// @retail 0x83336B28
GripRBTNode *UCCSBTTargetVisible::CreateRuntime()
{
    return new CCSRBTTargetVisible;
}

// @retail 0x83336C40
GripRBTNode *UCCSBTTargetKnockedDown::CreateRuntime()
{
    return new CCSRBTTargetKnockedDown;
}

// @retail 0x83336D58
GripRBTNode *UCCSBTTargetInCover::CreateRuntime()
{
    return new CCSRBTTargetInCover;
}

// @retail 0x83336F48
GripRBTNode *UCCSBTVisibleToPlayerCamera::CreateRuntime()
{
    return new CCSRBTVisibleToPlayerCamera;
}

// @retail 0x83337720
GripRBTNode *UCCSBTTargetAngle::CreateRuntime()
{
    return new CCSRBTTargetAngle;
}

// @retail 0x83337910
GripRBTNode *UHaloBTKamikaze::CreateRuntime()
{
    return new HaloRBTKamikaze;
}

// @retail 0x833425C8
GripRBTNode *UCCSBTEnemyAware::CreateRuntime()
{
    return new CCSRBTEnemyAware;
}

// @retail 0x83342890
GripRBTNode *UCCSBTMoveIntoClosestCover::CreateRuntime()
{
    return new CCSRBTMoveToClosestCover;
}

// @retail 0x8334B038
GripRBTNode *UCCSBTMoveIntoInitialCover::CreateRuntime()
{
    return new CCSRBTMoveToInitialCover;
}

// @retail 0x83354928
GripRBTNode *UCCSBTSearch::CreateRuntime()
{
    return new CCSRBTSearch;
}

// @retail 0x83342668
GripRBTNode *UCCSBTEnemyClosestRange::CreateRuntime()
{
    return new CCSRBTEnemyClosestRange;
}

// @retail 0x83342720
GripRBTNode *UCCSBTEnemyLowestLKPAge::CreateRuntime()
{
    return new CCSRBTEnemyLowestLKPAge;
}

// @retail 0x833427D8
GripRBTNode *UCCSBTMoveIntoBestCover::CreateRuntime()
{
    return new CCSRBTMoveToBestCover;
}

// @retail 0x833429F0
GripRBTNode *UCCSBTSelectTarget::CreateRuntime()
{
    return new CCSRBTSelectTarget;
}

// @retail 0x83342AA8
GripRBTNode *UCCSBTTargetRange::CreateRuntime()
{
    return new CCSRBTTargetRange;
}

// @retail 0x83342B60
GripRBTNode *UCCSBTTimeSinceDamage::CreateRuntime()
{
    return new CCSRBTTimeSinceDamage;
}

// @retail 0x83342C18
GripRBTNode *UCCSBTTimeSinceAimedAt::CreateRuntime()
{
    return new CCSRBTTimeSinceAimedAt;
}

// @retail 0x83342CD0
GripRBTNode *UCCSBTTimeSinceThreatChanged::CreateRuntime()
{
    return new CCSRBTTimeSinceThreatChanged;
}

// @retail 0x83342D88
GripRBTNode *UCCSBTTimeSinceThreatened::CreateRuntime()
{
    return new CCSRBTTimeSinceThreatened;
}

// @retail 0x83342E40
GripRBTNode *UCCSBTTimeSinceTargetCamoed::CreateRuntime()
{
    return new CCSRBTTimeSinceTargetCamoed;
}

// @retail 0x83342EF8
GripRBTNode *UCCSBTTimeSinceBecameAware::CreateRuntime()
{
    return new CCSRBTTimeSinceBecameAware;
}

// @retail 0x83342FB0
GripRBTNode *UCCSBTTimeSinceGrenadeStuck::CreateRuntime()
{
    return new CCSRBTTimeSinceGrenadeStuck;
}

// @retail 0x83343068
GripRBTNode *UCCSBTTimeSinceStaggered::CreateRuntime()
{
    return new CCSRBTTimeSinceStaggered;
}

// @retail 0x83343120
GripRBTNode *UCCSBTTimeSinceSuccessfulAttack::CreateRuntime()
{
    return new CCSRBTTimeSinceSuccessfulAttack;
}

// @retail 0x833431D8
GripRBTNode *UCCSBTTimeSinceEvent::CreateRuntime()
{
    return new CCSRBTTimeSinceEvent;
}

// Not matched yet: UCCSBTMoveIntoBestCover::CreateRuntime and
// UCCSBTSelectTarget::CreateRuntime (their runtime nodes' constructors set
// members; not written), and the CreateRuntime functions of UCCSBTIdle,
// UCCSBTOrientTowardTarget, UCCSBTFlee and UCCSBTMoveTo{Actor,Target,Vehicle}
// for the same reason. Not attempted yet (todo): the InitializeRuntime
// functions and the rest of this file.
