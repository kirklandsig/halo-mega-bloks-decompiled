class PhysicsAssetInstance extends Object
	native;

var const transient Actor Owner;
var const transient int RootBodyIndex;
var const export editinline array<export editinline RB_BodyInstance> Bodies;
var const export editinline array<export editinline RB_ConstraintInstance> Constraints;
var native const Map_Mirror CollisionDisableTable;
var const float LinearSpringScale;
var const float LinearDampingScale;
var const float LinearForceLimitScale;
var const float AngularSpringScale;
var const float AngularDampingScale;
var const float AngularForceLimitScale;
var const bool bInitBodies;

// Export UPhysicsAssetInstance::execSetLinearDriveScale(FFrame&, void* const)
native final function SetLinearDriveScale(float InLinearSpringScale, float InLinearDampingScale, float InLinearForceLimitScale);

// Export UPhysicsAssetInstance::execSetAngularDriveScale(FFrame&, void* const)
native final function SetAngularDriveScale(float InAngularSpringScale, float InAngularDampingScale, float InAngularForceLimitScale);

// Export UPhysicsAssetInstance::execGetTotalMassBelowBone(FFrame&, void* const)
native final function float GetTotalMassBelowBone(name InBoneName, PhysicsAsset InAsset, SkeletalMesh InSkelMesh);

// Export UPhysicsAssetInstance::execSetAllBodiesFixed(FFrame&, void* const)
native final function SetAllBodiesFixed(bool bNewFixed);

// Export UPhysicsAssetInstance::execSetNamedBodiesFixed(FFrame&, void* const)
native final function SetNamedBodiesFixed(bool bNewFixed, array<name> BoneNames, SkeletalMeshComponent SkelMesh, optional bool bSetOtherBodiesToComplement, optional bool bSkipFullAnimWeightBodies);

// Export UPhysicsAssetInstance::execForceAllBodiesBelowUnfixed(FFrame&, void* const)
native final function ForceAllBodiesBelowUnfixed(const out name InBoneName, PhysicsAsset InAsset, SkeletalMeshComponent InSkelMesh, bool InbInstanceAlwaysFullAnimWeight);

// Export UPhysicsAssetInstance::execSetAllMotorsAngularPositionDrive(FFrame&, void* const)
native final function SetAllMotorsAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, optional SkeletalMeshComponent SkelMesh, optional bool bSkipFullAnimWeightBodies);

// Export UPhysicsAssetInstance::execSetAllMotorsAngularVelocityDrive(FFrame&, void* const)
native final function SetAllMotorsAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, SkeletalMeshComponent SkelMeshComp, optional bool bSkipFullAnimWeightBodies);

// Export UPhysicsAssetInstance::execSetAllMotorsAngularDriveParams(FFrame&, void* const)
native final function SetAllMotorsAngularDriveParams(float InSpring, float InDamping, float InForceLimit, optional SkeletalMeshComponent SkelMesh, optional bool bSkipFullAnimWeightBodies);

// Export UPhysicsAssetInstance::execSetNamedMotorsAngularPositionDrive(FFrame&, void* const)
native final function SetNamedMotorsAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, array<name> BoneNames, SkeletalMeshComponent SkelMeshComp, optional bool bSetOtherBodiesToComplement);

// Export UPhysicsAssetInstance::execSetNamedMotorsAngularVelocityDrive(FFrame&, void* const)
native final function SetNamedMotorsAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, array<name> BoneNames, SkeletalMeshComponent SkelMeshComp, optional bool bSetOtherBodiesToComplement);

// Export UPhysicsAssetInstance::execSetNamedRBBoneSprings(FFrame&, void* const)
native final function SetNamedRBBoneSprings(bool bEnable, array<name> BoneNames, float InBoneLinearSpring, float InBoneAngularSpring, SkeletalMeshComponent SkelMeshComp);

// Export UPhysicsAssetInstance::execSetNamedBodiesBlockRigidBody(FFrame&, void* const)
native final function SetNamedBodiesBlockRigidBody(bool bNewBlockRigidBody, array<name> BoneNames, SkeletalMeshComponent SkelMesh);

// Export UPhysicsAssetInstance::execSetFullAnimWeightBlockRigidBody(FFrame&, void* const)
native final function SetFullAnimWeightBlockRigidBody(bool bNewBlockRigidBody, SkeletalMeshComponent SkelMesh);

// Export UPhysicsAssetInstance::execSetFullAnimWeightBonesFixed(FFrame&, void* const)
native final function SetFullAnimWeightBonesFixed(bool bNewFixed, SkeletalMeshComponent SkelMesh);

// Export UPhysicsAssetInstance::execFindBodyInstance(FFrame&, void* const)
native final function RB_BodyInstance FindBodyInstance(name BodyName, PhysicsAsset InAsset);

// Export UPhysicsAssetInstance::execFindConstraintInstance(FFrame&, void* const)
native final function RB_ConstraintInstance FindConstraintInstance(name ConName, PhysicsAsset InAsset);

// Export UPhysicsAssetInstance::execAddRandomSpinToEachBody(FFrame&, void* const)
native final function AddRandomSpinToEachBody(float minSpin, float maxSpin);

defaultproperties
{
	LinearSpringScale=1.0000000
	LinearDampingScale=1.0000000
	LinearForceLimitScale=1.0000000
	AngularSpringScale=1.0000000
	AngularDampingScale=1.0000000
	AngularForceLimitScale=1.0000000
	bInitBodies=true
}