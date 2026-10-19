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

// The runtime nodes' constructors (their own files come first in the unity,
// so CreateRuntime inlines them)
#ifndef HAGGAR_HOST
// @retail 0x83324850
CCSRBTFlee::CCSRBTFlee() : m_actionHandle(-1) {}

// @retail 0x833248B8
CCSRBTIdle::CCSRBTIdle() : m_alertness(CCS::AlertnessState_Relax), m_actionHandle(-1) {}

// @retail 0x83324BB8
CCSRBTOrientTowardTarget::CCSRBTOrientTowardTarget() : m_alertness(CCS::AlertnessState_Relax), m_actionHandle(-1) {}

// @retail 0x83331B48
CCSRBTMoveToActor::CCSRBTMoveToActor() : m_actionHandle(-1) {}

// @retail 0x83331E28
CCSRBTMoveToTarget::CCSRBTMoveToTarget() : m_actionHandle(-1) {}

// @retail 0x83332070
CCSRBTMoveToVehicle::CCSRBTMoveToVehicle() {}

// @retail 0x8333EB08
CCSRBTMoveToBestCover::CCSRBTMoveToBestCover() : m_idealShootingDistance(0.0f), m_excludeCurrentCover(false) {}

// @retail 0x8333FC48
CCSRBTSelectTarget::CCSRBTSelectTarget() : m_selectionAlgo((EAlgorithm)0) {}
#endif

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

// @retail 0x83329078
GripRBTNode *UCCSBTIdle::CreateRuntime()
{
    return new CCSRBTIdle;
}

// @retail 0x833291A8
GripRBTNode *UCCSBTFlee::CreateRuntime()
{
    return new CCSRBTFlee;
}

// @retail 0x83329258
GripRBTNode *UCCSBTOrientTowardTarget::CreateRuntime()
{
    return new CCSRBTOrientTowardTarget;
}

// @retail 0x833364A8
GripRBTNode *UCCSBTMoveToActor::CreateRuntime()
{
    return new CCSRBTMoveToActor;
}

// @retail 0x833365D0
GripRBTNode *UCCSBTMoveToTarget::CreateRuntime()
{
    return new CCSRBTMoveToTarget;
}

// @retail 0x83336678
GripRBTNode *UCCSBTMoveToVehicle::CreateRuntime()
{
    return new CCSRBTMoveToVehicle;
}

// @retail 0x8331FFF8
void UCCSBTIdle::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    static_cast<CCSRBTIdle *>(pNode)->SetAlertness((CCS::EAlertnessState)Alertness);
}

// @retail 0x83320038
void UCCSBTMoveTo::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTMoveTo *pMoveTo = static_cast<CCSRBTMoveTo *>(pNode);
    pMoveTo->SetAlertness((CCS::EAlertnessState)Alertness);
    pMoveTo->SetMovementType((CCS::EMovementType)MovementType);
    pMoveTo->SetSpeed((CCS::EMovementSpeed)Speed);
    pMoveTo->SetFireChance(ShootChance);
    pMoveTo->SetChargedShotChance(ChargedShotChance);
    pMoveTo->SetDelayBetweenBursts(DelayBetweenBursts);
    pMoveTo->SetFireBurstPerShot(FireBurstPerShot);
    pMoveTo->SetPrimaryAttackRange(PrimaryAttackRange);
    pMoveTo->SetSecondaryAttackRange(SecondaryAttackRange);
    pMoveTo->SetPrimaryTargetWeight(PrimaryTargetWeight);
    pMoveTo->SetPlayerTargetWeight(PlayerSecondaryWeight);
    pMoveTo->SetReactiveTargetWeight(ReactiveSecondaryWeight);
    pMoveTo->SetObjectiveTargetWeight(ObjectiveSecondaryWeight);
}

// @retail 0x833200E0
void UCCSBTMoveIntoBestCover::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTMoveToBestCover *pCover = static_cast<CCSRBTMoveToBestCover *>(pNode);
    pCover->SetIdealShootingDistance(IdealShootingDistance);
    pCover->SetExcludeCurrentCover(ExcludeCurrentCover != 0);
}

// @retail 0x83320130
void UCCSBTStrafeTarget::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTStrafeTarget *pStrafe = static_cast<CCSRBTStrafeTarget *>(pNode);
    pStrafe->SetFireChance(ShootChance);
    pStrafe->SetChargedShotChance(ChargedShotChance);
    pStrafe->SetDelayBetweenBursts(DelayBetweenBursts);
    pStrafe->SetFireBurstPerShot(FireBurstPerShot);
    pStrafe->SetDirectionFlags(CanStrafe_Left != 0, CanStrafe_Right != 0, CanStrafe_Back != 0, CanStrafe_Forward != 0);
}

// @retail 0x833201B0
void UCCSBTEncircleTarget::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTEncircleTarget *pEncircle = static_cast<CCSRBTEncircleTarget *>(pNode);
    pEncircle->SetFireChance(ShootChance);
    pEncircle->SetDelayBetweenBursts(DelayBetweenBursts);
    pEncircle->SetFireBurstPerShot(FireBurstPerShot);
    pEncircle->SetDirectionFlags(CanCircle_Left != 0, CanCircle_Right != 0);
    pEncircle->SetForceFire(ForceFire != 0);
}

// @retail 0x83320220
void UCCSBTOrientTowardTarget::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    static_cast<CCSRBTOrientTowardTarget *>(pNode)->SetAlertness((CCS::EAlertnessState)Alertness);
}

// @retail 0x833367A8
void UCCSBTSelectTarget::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTSelectTarget *pSelect = static_cast<CCSRBTSelectTarget *>(pNode);
    pSelect->SetSelectionAlgo((CCSRBTSelectTarget::EAlgorithm)TargetSelectionAlgorithm);
    pSelect->SetTargetName(SpecificTargetName);
}

// @retail 0x83320260
void UCCSBTShoot::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTShoot *pShoot = static_cast<CCSRBTShoot *>(pNode);
    pShoot->SetDelayBetweenBursts(DelayBetweenBursts);
    pShoot->SetFireBurstPerShot(FireBurstPerShot);
    pShoot->SetChargedShotChance(ChargedShotChance);
}

// @retail 0x833202B0
void UCCSBTShootFromCover::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTShootFromCover *pShoot = static_cast<CCSRBTShootFromCover *>(pNode);
    pShoot->SetDelayBetweenBursts(DelayBetweenBursts);
    pShoot->SetFireBurstPerShot(FireBurstPerShot);
}

// @retail 0x833296A0
void UCCSBTTargetAngle::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    static_cast<CCSRBTTargetAngle *>(pNode)->SetActiveZones(Front != 0, Right != 0, Behind != 0, Left != 0);
}

// @retail 0x833202F8
void UCCSBTTimeSinceEvent::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    CCSRBTTimeSinceEvent *pEvent = static_cast<CCSRBTTimeSinceEvent *>(pNode);
    pEvent->SetEventType((EEventType)RelevantEvent);
    pEvent->SetActorClass(RelevantActorClass);
    pEvent->SetMaxDistance(MaxDistance);
}

// @retail 0x83320348
void UHaloBTKamikaze::InitializeRuntime(GripRBTNode *pNode)
{
    Super::InitializeRuntime(pNode);
    HaloRBTKamikaze *pKamikaze = static_cast<HaloRBTKamikaze *>(pNode);
    pKamikaze->SetFireChance(0.0f);
    pKamikaze->SetDetonationDistance(DetonationDistance);
    pKamikaze->SetArmKamikazeAnimName(ArmKamikazeAnimName);
    pKamikaze->SetDetonateKamikazeAnimName(DetonateKamikazeAnimName);
    pKamikaze->SetBlendTimes(BlendInTime, BlendOutTime);
}
