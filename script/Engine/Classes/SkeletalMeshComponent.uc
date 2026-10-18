class SkeletalMeshComponent extends MeshComponent
	native
	config(Engine)
	editinlinenew
	noexport;

enum EMaxDistanceScaleMode
{
	MDSM_Multiply,                  // 0
	MDSM_Substract,                 // 1
	MDSM_MAX                        // 2
};

enum EInstanceWeightUsage
{
	IWU_PartialSwap,                // 0
	IWU_FullSwap,                   // 1
	IWU_MAX                         // 2
};

enum ERootMotionMode
{
	RMM_Translate,                  // 0
	RMM_Velocity,                   // 1
	RMM_Ignore,                     // 2
	RMM_Accel,                      // 3
	RMM_Relative,                   // 4
	RMM_MAX                         // 5
};

enum ERootMotionRotationMode
{
	RMRM_Ignore,                    // 0
	RMRM_RotateActor,               // 1
	RMRM_MAX                        // 2
};

enum EAnimRotationOnly
{
	EARO_AnimSet,                   // 0
	EARO_ForceEnabled,              // 1
	EARO_ForceDisabled,             // 2
	EARO_MAX                        // 3
};

enum EFaceFXBlendMode
{
	FXBM_Overwrite,                 // 0
	FXBM_Additive,                  // 1
	FXBM_MAX                        // 2
};

enum EFaceFXRegOp
{
	FXRO_Add,                       // 0
	FXRO_Multiply,                  // 1
	FXRO_Replace,                   // 2
	FXRO_MAX                        // 3
};

enum EBoneVisibilityStatus
{
	BVS_HiddenByParent,             // 0
	BVS_Visible,                    // 1
	BVS_ExplicitlyHidden,           // 2
	BVS_MAX                         // 3
};

enum EPhysBodyOp
{
	PBO_None,                       // 0
	PBO_Term,                       // 1
	PBO_Disable,                    // 2
	PBO_MAX                         // 3
};

struct ActiveMorph
{
	var MorphTarget Target;
	var float Weight;

	structdefaultproperties
	{
		Target=none
		Weight=0.0000000
	}
};

struct Attachment
{
	var export editinline ActorComponent Component;
	var name BoneName;
	var Vector RelativeLocation;
	var Rotator RelativeRotation;
	var Vector RelativeScale;

	structdefaultproperties
	{
		Component=none
		BoneName="None"
		RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
		RelativeScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	}
};

struct BonePair
{
	var name Bones[2];

	structdefaultproperties
	{
		Bones[0]="None"
		Bones[1]="None"
	}
};

struct SkelMeshComponentLODInfo
{
	var const array<bool> HiddenMaterials;
	var const bool bNeedsInstanceWeightUpdate;
	var const bool bAlwaysUseInstanceWeights;
	var const transient SkeletalMeshComponent.EInstanceWeightUsage InstanceWeightUsage;
	var const transient int InstanceWeightIdx;

	structdefaultproperties
	{
		HiddenMaterials=none
		bNeedsInstanceWeightUpdate=false
		bAlwaysUseInstanceWeights=false
		InstanceWeightUsage=EInstanceWeightUsage.IWU_PartialSwap
		InstanceWeightIdx=0
	}
};

var SkeletalMesh SkeletalMesh;
var export editinline SkeletalMeshComponent AttachedToSkelComponent;
var const AnimTree AnimTreeTemplate;
var const export editinline AnimNode Animations;
var const transient array<AnimNode> AnimTickArray;
var const transient array<AnimNode> AnimAlwaysTickArray;
var const transient array<int> AnimTickRelevancyArray;
var const transient array<float> AnimTickWeightsArray;
var const transient array<SkelControlBase> SkelControlTickArray;
var const PhysicsAsset PhysicsAsset;
var const export editinline transient PhysicsAssetInstance PhysicsAssetInstance;
var native const transient Pointer ApexClothing;
var interp float PhysicsWeight;
var float GlobalAnimRateScale;
var float StreamingDistanceMultiplier;
var native const transient Pointer MeshObject;
var Color WireframeColor;
var native const transient array<BoneAtom> SpaceBases;
var native const transient array<BoneAtom> LocalAtoms;
var native const transient array<BoneAtom> CachedLocalAtoms;
var native const transient array<BoneAtom> CachedSpaceBases;
var const globalconfig int LowUpdateFrameRate;
var native const transient array<byte> RequiredBones;
var native const transient array<byte> ComposeOrderedRequiredBones;
var const export editinline SkeletalMeshComponent ParentAnimComponent;
var native const transient array<int> ParentBoneMap;
var array<AnimSet> AnimSets;
var native const transient array<AnimSet> TemporarySavedAnimSets;
var array<MorphTargetSet> MorphSets;
var transient array<ActiveMorph> ActiveMorphs;
var transient array<ActiveMorph> ActiveCurveMorphs;
var native const map{VOID,VOID} MorphTargetIndexMap;
var duplicatetransient const array<Attachment> Attachments;
var const transient array<byte> SkelControlIndex;
var const transient array<byte> PostPhysSkelControlIndex;
var int ForcedLodModel;
var int MinLodModel;
var int PredictedLODLevel;
var int OldPredictedLODLevel;
var float AnimationLODDistanceFactor;
var int AnimationLODFrameRate;
var const float MaxDistanceFactor;
var int bForceWireframe;
var int bForceRefpose;
var int bOldForceRefPose;
var bool bNoSkeletonUpdate;
var int bDisplayBones;
var int bShowPrePhysBones;
var int bHideSkin;
var int bForceRawOffset;
var int bIgnoreControllers;
var int bTransformFromAnimParent;
var const transient int TickTag;
var const transient int InitTag;
var const transient int CachedAtomsTag;
var const int bUseSingleBodyPhysics;
var int bUseHaloDestructibleActorPhysics;
var transient int bRequiredBonesUpToDate;
var float MinDistFactorForKinematicUpdate;
var transient int FramesPhysicsAsleep;
var const transient bool bHasValidBodies;
var bool bSkipAllUpdateWhenPhysicsAsleep;
var bool bComponentUseFixedSkelBounds;
var bool bUseBoundsFromParentAnimComponent;
var bool bConsiderAllBodiesForBounds;
var bool bUpdateSkelWhenNotRendered;
var bool bIgnoreControllersWhenNotRendered;
var bool bTickAnimNodesWhenNotRendered;
var const bool bNotUpdatingKinematicDueToDistance;
var bool bForceDiscardRootMotion;
var bool bNotifyRootMotionProcessed;
var bool bRootMotionModeChangeNotify;
var bool bRootMotionExtractedNotify;
var transient bool bProcessingRootMotion;
var bool bDisableFaceFXMaterialInstanceCreation;
var bool bDisableFaceFX;
var const transient bool bAnimTreeInitialised;
var private transient bool bForceMeshObjectUpdate;
var const bool bHasPhysicsAssetInstance;
var bool bUpdateKinematicBonesFromAnimation;
var bool bUpdateJointsFromAnimation;
var const bool bSkelCompFixed;
var const bool bHasHadPhysicsBlendedIn;
var bool bForceUpdateAttachmentsInTick;
var transient bool bEnableFullAnimWeightBodies;
var bool bPerBoneVolumeEffects;
var bool bPerBoneMotionBlur;
var bool bSyncActorLocationToRootRigidBody;
var const bool bUseRawData;
var bool bDisableWarningWhenAnimNotFound;
var bool bOverrideAttachmentOwnerVisibility;
var const transient bool bNeedsToDeleteHitMask;
var bool bPauseAnims;
var bool bChartDistanceFactor;
var bool bEnableLineCheckWithBounds;
var transient bool bCanHighlightSelectedSections;
var bool bUpdateMorphWhenParentAnimComponentExists;
var Vector LineCheckBoundsScale;
var const bool bEnableClothSimulation;
var const bool bDisableClothCollision;
var const bool bClothFrozen;
var bool bAutoFreezeClothWhenNotRendered;
var bool bClothAwakeOnStartup;
var bool bClothBaseVelClamp;
var bool bClothBaseVelInterp;
var bool bAttachClothVertsToBaseBody;
var bool bIsClothOnStaticObject;
var bool bUpdatedFixedClothVerts;
var bool bClothPositionalDampening;
var bool bClothWindRelativeToOwner;
var transient bool bRecentlyRendered;
var bool bCacheAnimSequenceNodes;
var const transient bool bNeedsInstanceWeightUpdate;
var const transient bool bAlwaysUseInstanceWeights;
var const transient bool bUpdateComposeSkeletonPasses;
var native const transient bool bValidTemporarySavedAnimSets;
var native const transient array<BonePair> InstanceVertexWeightBones;
var const transient array<SkelMeshComponentLODInfo> LODInfo;
var const Vector FrozenLocalToWorldPos;
var const Rotator FrozenLocalToWorldRot;
var const Vector ClothExternalForce;
var Vector ClothWind;
var Vector ClothBaseVelClampRange;
var float ClothBlendWeight;
var float ClothDynamicBlendWeight;
var float ClothBlendMinDistanceFactor;
var float ClothBlendMaxDistanceFactor;
var Vector MinPosDampRange;
var Vector MaxPosDampRange;
var Vector MinPosDampScale;
var Vector MaxPosDampScale;
var native const transient Pointer ClothSim;
var native const transient int SceneIndex;
var const array<Vector> ClothMeshPosData;
var const array<Vector> ClothMeshNormalData;
var const array<int> ClothMeshIndexData;
var int NumClothMeshVerts;
var int NumClothMeshIndices;
var const array<int> ClothMeshParentData;
var int NumClothMeshParentIndices;
var native const transient array<Vector> ClothMeshWeldedPosData;
var native const transient array<Vector> ClothMeshWeldedNormalData;
var native const transient array<int> ClothMeshWeldedIndexData;
var int ClothDirtyBufferFlag;
var const PrimitiveComponent.ERBCollisionChannel ClothRBChannel;
var const RBCollisionChannelContainer ClothRBCollideWithChannels;
var const float ClothForceScale;
var float ClothImpulseScale;
var const float ClothAttachmentTearFactor;
var const bool bClothUseCompartment;
var const float MinDistanceForClothReset;
var const transient Vector LastClothLocation;
var const PrimitiveComponent.ERBCollisionChannel ApexClothingRBChannel;
var const RBCollisionChannelContainer ApexClothingRBCollideWithChannels;
var const PrimitiveComponent.ERBCollisionChannel ApexClothingCollisionRBChannel;
var bool bAutoFreezeApexClothingWhenNotRendered;
var bool bLocalSpaceWind;
var interp Vector WindVelocity;
var interp float WindVelocityBlendTime;
var const transient bool bSkipInitClothing;
var native const transient Pointer SoftBodySim;
var native const transient int SoftBodySceneIndex;
var const bool bEnableSoftBodySimulation;
var const array<Vector> SoftBodyTetraPosData;
var const array<int> SoftBodyTetraIndexData;
var int NumSoftBodyTetraVerts;
var int NumSoftBodyTetraIndices;
var float SoftBodyImpulseScale;
var const bool bSoftBodyFrozen;
var bool bAutoFreezeSoftBodyWhenNotRendered;
var bool bSoftBodyAwakeOnStartup;
var const bool bSoftBodyUseCompartment;
var const PrimitiveComponent.ERBCollisionChannel SoftBodyRBChannel;
var const RBCollisionChannelContainer SoftBodyRBCollideWithChannels;
var native const transient Pointer SoftBodyASVPlane;
var Material LimitMaterial;
var transient BoneAtom RootMotionDelta;
var transient Vector RootMotionVelocity;
var const transient Vector RootBoneTranslation;
var Vector RootMotionAccelScale;
var SkeletalMeshComponent.ERootMotionMode RootMotionMode;
var const SkeletalMeshComponent.ERootMotionMode PreviousRMM;
var SkeletalMeshComponent.ERootMotionMode PendingRMM;
var SkeletalMeshComponent.ERootMotionMode OldPendingRMM;
var const int bRMMOneFrameDelay;
var SkeletalMeshComponent.ERootMotionRotationMode RootMotionRotationMode;
var SkeletalMeshComponent.EAnimRotationOnly AnimRotationOnly;
var SkeletalMeshComponent.EFaceFXBlendMode FaceFXBlendMode;
var native transient Pointer FaceFXActorInstance;
var export editinline AudioComponent CachedFaceFXAudioComp;
var const transient array<byte> BoneVisibilityStates;
var AkEvent CachedFaceFxAkEvent;
var const transient BoneAtom LocalToWorldBoneAtom;
var transient float ProgressiveDrawingFraction;
var transient byte CustomSortAlternateIndexMode;
var transient array<name> MorphTargetsQueried;

// Export USkeletalMeshComponent::execAttachComponent(FFrame&, void* const)
native final function AttachComponent(ActorComponent Component, name BoneName, optional Vector RelativeLocation, optional Rotator RelativeRotation, optional Vector RelativeScale);

// Export USkeletalMeshComponent::execDetachComponent(FFrame&, void* const)
native final function DetachComponent(ActorComponent Component);

// Export USkeletalMeshComponent::execAttachComponentToSocket(FFrame&, void* const)
native final function AttachComponentToSocket(ActorComponent Component, name SocketName);

// Export USkeletalMeshComponent::execGetSocketWorldLocationAndRotation(FFrame&, void* const)
native final function bool GetSocketWorldLocationAndRotation(name InSocketName, out Vector OutLocation, optional out Rotator OutRotation, optional int Space);

// Export USkeletalMeshComponent::execGetSocketByName(FFrame&, void* const)
native final function SkeletalMeshSocket GetSocketByName(name InSocketName);

// Export USkeletalMeshComponent::execGetSocketBoneName(FFrame&, void* const)
native final function name GetSocketBoneName(name InSocketName);

// Export USkeletalMeshComponent::execFindComponentAttachedToBone(FFrame&, void* const)
native final function ActorComponent FindComponentAttachedToBone(name InBoneName);

// Export USkeletalMeshComponent::execIsComponentAttached(FFrame&, void* const)
native final function bool IsComponentAttached(ActorComponent Component, optional name BoneName);

// Export USkeletalMeshComponent::execAttachedComponents(FFrame&, void* const)
native final iterator function AttachedComponents(Class<ActorComponent> BaseClass, out ActorComponent OutComponent);

// Export USkeletalMeshComponent::execGetTransformMatrix(FFrame&, void* const)
native final function Matrix GetTransformMatrix();

// Export USkeletalMeshComponent::execSetSkeletalMesh(FFrame&, void* const)
native final simulated function SetSkeletalMesh(SkeletalMesh NewMesh, optional bool bKeepSpaceBases);

// Export USkeletalMeshComponent::execSetPhysicsAsset(FFrame&, void* const)
native final simulated function SetPhysicsAsset(PhysicsAsset NewPhysicsAsset, optional bool bForceReInit);

// Export USkeletalMeshComponent::execSetForceRefPose(FFrame&, void* const)
native final simulated function SetForceRefPose(bool bNewForceRefPose);

// Export USkeletalMeshComponent::execSetEnableClothSimulation(FFrame&, void* const)
native final simulated function SetEnableClothSimulation(bool bInEnable);

// Export USkeletalMeshComponent::execSetClothFrozen(FFrame&, void* const)
native final simulated function SetClothFrozen(bool bNewFrozen);

// Export USkeletalMeshComponent::execSetEnableClothingSimulation(FFrame&, void* const)
native final simulated function SetEnableClothingSimulation(bool bInEnable);

// Export USkeletalMeshComponent::execUpdateClothParams(FFrame&, void* const)
native final simulated function UpdateClothParams();

// Export USkeletalMeshComponent::execSetClothExternalForce(FFrame&, void* const)
native final simulated function SetClothExternalForce(Vector InForce);

// Export USkeletalMeshComponent::execSetAttachClothVertsToBaseBody(FFrame&, void* const)
native final simulated function SetAttachClothVertsToBaseBody(bool bAttachVerts);

// Export USkeletalMeshComponent::execResetClothVertsToRefPose(FFrame&, void* const)
native final simulated function ResetClothVertsToRefPose();

// Export USkeletalMeshComponent::execForceApexClothingTeleportAndReset(FFrame&, void* const)
native final simulated function ForceApexClothingTeleportAndReset();

// Export USkeletalMeshComponent::execForceApexClothingTeleport(FFrame&, void* const)
native final simulated function ForceApexClothingTeleport();

// Export USkeletalMeshComponent::execGetClothAttachmentResponseCoefficient(FFrame&, void* const)
native final simulated function float GetClothAttachmentResponseCoefficient();

// Export USkeletalMeshComponent::execGetClothAttachmentTearFactor(FFrame&, void* const)
native final simulated function float GetClothAttachmentTearFactor();

// Export USkeletalMeshComponent::execGetClothBendingStiffness(FFrame&, void* const)
native final simulated function float GetClothBendingStiffness();

// Export USkeletalMeshComponent::execGetClothCollisionResponseCoefficient(FFrame&, void* const)
native final simulated function float GetClothCollisionResponseCoefficient();

// Export USkeletalMeshComponent::execGetClothDampingCoefficient(FFrame&, void* const)
native final simulated function float GetClothDampingCoefficient();

// Export USkeletalMeshComponent::execGetClothFlags(FFrame&, void* const)
native final simulated function int GetClothFlags();

// Export USkeletalMeshComponent::execGetClothFriction(FFrame&, void* const)
native final simulated function float GetClothFriction();

// Export USkeletalMeshComponent::execGetClothPressure(FFrame&, void* const)
native final simulated function float GetClothPressure();

// Export USkeletalMeshComponent::execGetClothSleepLinearVelocity(FFrame&, void* const)
native final simulated function float GetClothSleepLinearVelocity();

// Export USkeletalMeshComponent::execGetClothSolverIterations(FFrame&, void* const)
native final simulated function int GetClothSolverIterations();

// Export USkeletalMeshComponent::execGetClothStretchingStiffness(FFrame&, void* const)
native final simulated function float GetClothStretchingStiffness();

// Export USkeletalMeshComponent::execGetClothTearFactor(FFrame&, void* const)
native final simulated function float GetClothTearFactor();

// Export USkeletalMeshComponent::execGetClothThickness(FFrame&, void* const)
native final simulated function float GetClothThickness();

// Export USkeletalMeshComponent::execSetClothAttachmentResponseCoefficient(FFrame&, void* const)
native final simulated function SetClothAttachmentResponseCoefficient(float ClothAttachmentResponseCoefficient);

// Export USkeletalMeshComponent::execSetClothAttachmentTearFactor(FFrame&, void* const)
native final simulated function SetClothAttachmentTearFactor(float ClothAttachTearFactor);

// Export USkeletalMeshComponent::execSetClothBendingStiffness(FFrame&, void* const)
native final simulated function SetClothBendingStiffness(float ClothBendingStiffness);

// Export USkeletalMeshComponent::execSetClothCollisionResponseCoefficient(FFrame&, void* const)
native final simulated function SetClothCollisionResponseCoefficient(float ClothCollisionResponseCoefficient);

// Export USkeletalMeshComponent::execSetClothDampingCoefficient(FFrame&, void* const)
native final simulated function SetClothDampingCoefficient(float ClothDampingCoefficient);

// Export USkeletalMeshComponent::execSetClothFlags(FFrame&, void* const)
native final simulated function SetClothFlags(int ClothFlags);

// Export USkeletalMeshComponent::execSetClothFriction(FFrame&, void* const)
native final simulated function SetClothFriction(float ClothFriction);

// Export USkeletalMeshComponent::execSetClothPressure(FFrame&, void* const)
native final simulated function SetClothPressure(float ClothPressure);

// Export USkeletalMeshComponent::execSetClothSleepLinearVelocity(FFrame&, void* const)
native final simulated function SetClothSleepLinearVelocity(float ClothSleepLinearVelocity);

// Export USkeletalMeshComponent::execSetClothSolverIterations(FFrame&, void* const)
native final simulated function SetClothSolverIterations(int ClothSolverIterations);

// Export USkeletalMeshComponent::execSetClothStretchingStiffness(FFrame&, void* const)
native final simulated function SetClothStretchingStiffness(float ClothStretchingStiffness);

// Export USkeletalMeshComponent::execSetClothTearFactor(FFrame&, void* const)
native final simulated function SetClothTearFactor(float ClothTearFactor);

// Export USkeletalMeshComponent::execSetClothThickness(FFrame&, void* const)
native final simulated function SetClothThickness(float ClothThickness);

// Export USkeletalMeshComponent::execSetClothSleep(FFrame&, void* const)
native final simulated function SetClothSleep(bool IfClothSleep);

// Export USkeletalMeshComponent::execSetClothPosition(FFrame&, void* const)
native final simulated function SetClothPosition(Vector ClothOffSet);

// Export USkeletalMeshComponent::execSetClothVelocity(FFrame&, void* const)
native final simulated function SetClothVelocity(Vector VelocityOffSet);

// Export USkeletalMeshComponent::execAttachClothToCollidingShapes(FFrame&, void* const)
native final simulated function AttachClothToCollidingShapes(bool AttatchTwoWay, bool AttachTearable);

// Export USkeletalMeshComponent::execEnableClothValidBounds(FFrame&, void* const)
native final simulated function EnableClothValidBounds(bool IfEnableClothValidBounds);

// Export USkeletalMeshComponent::execSetClothValidBounds(FFrame&, void* const)
native final simulated function SetClothValidBounds(Vector ClothValidBoundsMin, Vector ClothValidBoundsMax);

// Export USkeletalMeshComponent::execUpdateSoftBodyParams(FFrame&, void* const)
native final simulated function UpdateSoftBodyParams();

// Export USkeletalMeshComponent::execSetSoftBodyFrozen(FFrame&, void* const)
native final simulated function SetSoftBodyFrozen(bool bNewFrozen);

// Export USkeletalMeshComponent::execWakeSoftBody(FFrame&, void* const)
native final simulated function WakeSoftBody();

// Export USkeletalMeshComponent::execFindAnimSequence(FFrame&, void* const)
native final function AnimSequence FindAnimSequence(name AnimSeqName);

// Export USkeletalMeshComponent::execSaveAnimSets(FFrame&, void* const)
native final function SaveAnimSets();

// Export USkeletalMeshComponent::execRestoreSavedAnimSets(FFrame&, void* const)
native final function RestoreSavedAnimSets();

final function float GetAnimRateByDuration(name AnimSeqName, float Duration)
{
	local AnimSequence AnimSeq;

	AnimSeq = FindAnimSequence(AnimSeqName);
	// End:0x5C
	if((AnimSeq == none) || AnimSeq.RateScale <= 0.0000000)
	{
		return 1.0000000;
	}
	return AnimSeq.SequenceLength / (Duration * AnimSeq.RateScale);
	//return ReturnValue;	
}

final function float GetAnimLength(name AnimSeqName)
{
	local AnimSequence AnimSeq;

	AnimSeq = FindAnimSequence(AnimSeqName);
	// End:0x5C
	if((AnimSeq == none) || AnimSeq.RateScale <= 0.0000000)
	{
		return 0.0000000;
	}
	return AnimSeq.SequenceLength / AnimSeq.RateScale;
	//return ReturnValue;	
}

// Export USkeletalMeshComponent::execFindMorphTarget(FFrame&, void* const)
native final function MorphTarget FindMorphTarget(name MorphTargetName);

// Export USkeletalMeshComponent::execFindAnimNode(FFrame&, void* const)
native final function AnimNode FindAnimNode(name InNodeName);

// Export USkeletalMeshComponent::execAllAnimNodes(FFrame&, void* const)
native final iterator function AllAnimNodes(Class<AnimNode> BaseClass, out AnimNode Node);

// Export USkeletalMeshComponent::execFindSkelControl(FFrame&, void* const)
native final function SkelControlBase FindSkelControl(name InControlName);

// Export USkeletalMeshComponent::execFindMorphNode(FFrame&, void* const)
native final function MorphNodeBase FindMorphNode(name InNodeName);

// Export USkeletalMeshComponent::execGetBoneQuaternion(FFrame&, void* const)
native final function Quat GetBoneQuaternion(name BoneName, optional int Space);

// Export USkeletalMeshComponent::execGetBoneLocation(FFrame&, void* const)
native final function Vector GetBoneLocation(name BoneName, optional int Space);

// Export USkeletalMeshComponent::execMatchRefBone(FFrame&, void* const)
native final function int MatchRefBone(name BoneName);

// Export USkeletalMeshComponent::execGetBoneName(FFrame&, void* const)
native final function name GetBoneName(int BoneIndex);

// Export USkeletalMeshComponent::execGetBoneMatrix(FFrame&, void* const)
native final function Matrix GetBoneMatrix(int BoneIndex);

// Export USkeletalMeshComponent::execGetParentBone(FFrame&, void* const)
native final function name GetParentBone(name BoneName);

// Export USkeletalMeshComponent::execGetBoneNames(FFrame&, void* const)
native final function GetBoneNames(out array<name> BoneNames);

// Export USkeletalMeshComponent::execBoneIsChildOf(FFrame&, void* const)
native final function bool BoneIsChildOf(name BoneName, name ParentBoneName);

// Export USkeletalMeshComponent::execGetRefPosePosition(FFrame&, void* const)
native final function Vector GetRefPosePosition(int BoneIndex);

// Export USkeletalMeshComponent::execGetBoneAxis(FFrame&, void* const)
native final function Vector GetBoneAxis(name BoneName, Object.EAxis Axis);

// Export USkeletalMeshComponent::execTransformToBoneSpace(FFrame&, void* const)
native final function TransformToBoneSpace(name BoneName, Vector InPosition, Rotator InRotation, out Vector OutPosition, out Rotator OutRotation);

// Export USkeletalMeshComponent::execTransformFromBoneSpace(FFrame&, void* const)
native final function TransformFromBoneSpace(name BoneName, Vector InPosition, Rotator InRotation, out Vector OutPosition, out Rotator OutRotation);

// Export USkeletalMeshComponent::execFindClosestBone(FFrame&, void* const)
native final function name FindClosestBone(Vector TestLocation, optional out Vector BoneLocation, optional float IgnoreScale);

// Export USkeletalMeshComponent::execGetClosestCollidingBoneLocation(FFrame&, void* const)
native final function Vector GetClosestCollidingBoneLocation(Vector TestLocation, bool bCheckZeroExtent, bool bCheckNonZeroExtent);

// Export USkeletalMeshComponent::execSetAnimTreeTemplate(FFrame&, void* const)
native final function SetAnimTreeTemplate(AnimTree NewTemplate);

// Export USkeletalMeshComponent::execSetParentAnimComponent(FFrame&, void* const)
native final function SetParentAnimComponent(SkeletalMeshComponent NewParentAnimComp);

// Export USkeletalMeshComponent::execUpdateParentBoneMap(FFrame&, void* const)
native final function UpdateParentBoneMap();

// Export USkeletalMeshComponent::execInitSkelControls(FFrame&, void* const)
native final function InitSkelControls();

// Export USkeletalMeshComponent::execInitMorphTargets(FFrame&, void* const)
native final function InitMorphTargets();

// Export USkeletalMeshComponent::execFindConstraintIndex(FFrame&, void* const)
native final function int FindConstraintIndex(name ConstraintName);

// Export USkeletalMeshComponent::execFindConstraintBoneName(FFrame&, void* const)
native final function name FindConstraintBoneName(int ConstraintIndex);

// Export USkeletalMeshComponent::execFindBodyInstanceNamed(FFrame&, void* const)
native final function RB_BodyInstance FindBodyInstanceNamed(name BoneName);

// Export USkeletalMeshComponent::execSetHasPhysicsAssetInstance(FFrame&, void* const)
native final function SetHasPhysicsAssetInstance(bool bHasInstance, optional bool bUseCurrentPosition);

// Export USkeletalMeshComponent::execUpdateRBBonesFromSpaceBases(FFrame&, void* const)
native final function UpdateRBBonesFromSpaceBases(bool bMoveUnfixedBodies, bool bTeleport);

// Export USkeletalMeshComponent::execForceSkelUpdate(FFrame&, void* const)
native final function ForceSkelUpdate();

// Export USkeletalMeshComponent::execUpdateAnimations(FFrame&, void* const)
native final function UpdateAnimations();

// Export USkeletalMeshComponent::execGetBonesWithinRadius(FFrame&, void* const)
native final function bool GetBonesWithinRadius(Vector Origin, float Radius, int TraceFlags, out array<name> out_Bones);

// Export USkeletalMeshComponent::execAddInstanceVertexWeightBoneParented(FFrame&, void* const)
native final function AddInstanceVertexWeightBoneParented(name BoneName, optional bool bPairWithParent = true);

// Export USkeletalMeshComponent::execRemoveInstanceVertexWeightBoneParented(FFrame&, void* const)
native final function RemoveInstanceVertexWeightBoneParented(name BoneName);

// Export USkeletalMeshComponent::execFindInstanceVertexweightBonePair(FFrame&, void* const)
native final function int FindInstanceVertexweightBonePair(BonePair Bones);

// Export USkeletalMeshComponent::execUpdateInstanceVertexWeightBones(FFrame&, void* const)
native final function UpdateInstanceVertexWeightBones(array<BonePair> BonePairs);

// Export USkeletalMeshComponent::execToggleInstanceVertexWeights(FFrame&, void* const)
native final function ToggleInstanceVertexWeights(bool bEnable, int LODIdx);

// Export USkeletalMeshComponent::execPlayFaceFXAnim(FFrame&, void* const)
native final function bool PlayFaceFXAnim(FaceFXAnimSet FaceFXAnimSetRef, string AnimName, string GroupName, SoundCue SoundCueToPlay, AkEvent AkEventToPlay);

// Export USkeletalMeshComponent::execStopFaceFXAnim(FFrame&, void* const)
native final function StopFaceFXAnim();

// Export USkeletalMeshComponent::execIsPlayingFaceFXAnim(FFrame&, void* const)
native final function bool IsPlayingFaceFXAnim();

// Export USkeletalMeshComponent::execDeclareFaceFXRegister(FFrame&, void* const)
native final function DeclareFaceFXRegister(string RegName);

// Export USkeletalMeshComponent::execGetFaceFXRegister(FFrame&, void* const)
native final function float GetFaceFXRegister(string RegName);

// Export USkeletalMeshComponent::execSetFaceFXRegister(FFrame&, void* const)
native final function SetFaceFXRegister(string RegName, float RegVal, SkeletalMeshComponent.EFaceFXRegOp RegOp, optional float InterpDuration);

// Export USkeletalMeshComponent::execSetFaceFXRegisterEx(FFrame&, void* const)
native final function SetFaceFXRegisterEx(string RegName, SkeletalMeshComponent.EFaceFXRegOp RegOp, float FirstValue, float FirstInterpDuration, float NextValue, float NextInterpDuration);

// Export USkeletalMeshComponent::execHideBone(FFrame&, void* const)
native final function HideBone(int BoneIndex, SkeletalMeshComponent.EPhysBodyOp PhysBodyOption);

// Export USkeletalMeshComponent::execUnHideBone(FFrame&, void* const)
native final function UnHideBone(int BoneIndex);

// Export USkeletalMeshComponent::execIsBoneHidden(FFrame&, void* const)
native final function bool IsBoneHidden(int BoneIndex);

// Export USkeletalMeshComponent::execHideBoneByName(FFrame&, void* const)
native final function HideBoneByName(name BoneName, SkeletalMeshComponent.EPhysBodyOp PhysBodyOption);

// Export USkeletalMeshComponent::execUnHideBoneByName(FFrame&, void* const)
native final function UnHideBoneByName(name BoneName);

// Export USkeletalMeshComponent::execUpdateMeshForBrokenConstraints(FFrame&, void* const)
native final simulated function UpdateMeshForBrokenConstraints();

// Export USkeletalMeshComponent::execShowMaterialSection(FFrame&, void* const)
native final simulated function ShowMaterialSection(int MaterialID, bool bShow, int LODIndex);

function PlayAnim(name AnimName, optional float Duration, optional bool bLoop, optional bool bRestartIfAlreadyPlaying = true, optional float StartTime = 0.0000000, optional bool bPlayBackwards = false)
{
	local AnimNodeSequence AnimNode;
	local float DesiredRate;

	AnimNode = AnimNodeSequence(Animations);
	// End:0xB4
	if((AnimNode == none) && Animations.IsA('AnimTree'))
	{
		AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
	}
	// End:0x112
	if(AnimNode == none)
	{
		WarnInternal(("Base animation node is not an AnimNodeSequence (Owner:" @ string(Owner)) $ ")");		
	}
	else
	{
		// End:0x303
		if((AnimNode.AnimSeq != none) && AnimNode.AnimSeq.SequenceName == AnimName)
		{
			DesiredRate = ((Duration > 0.0000000) ? AnimNode.AnimSeq.SequenceLength / (Duration * AnimNode.AnimSeq.RateScale) : 1.0000000);
			DesiredRate = ((bPlayBackwards) ? DesiredRate- : DesiredRate);
			// End:0x2AE
			if(bRestartIfAlreadyPlaying || AnimNode.bPlaying!)
			{
				AnimNode.PlayAnim(bLoop, DesiredRate, StartTime);				
			}
			else
			{
				AnimNode.Rate = DesiredRate;
				AnimNode.bLooping = bLoop;
			}			
		}
		else
		{
			AnimNode.SetAnim(AnimName);
			// End:0x44E
			if(AnimNode.AnimSeq != none)
			{
				DesiredRate = ((Duration > 0.0000000) ? AnimNode.AnimSeq.SequenceLength / (Duration * AnimNode.AnimSeq.RateScale) : 1.0000000);
				DesiredRate = ((bPlayBackwards) ? DesiredRate- : DesiredRate);
				AnimNode.PlayAnim(bLoop, DesiredRate, StartTime);
			}
		}
	}
	//return;	
}

function StopAnim()
{
	local AnimNodeSequence AnimNode;

	AnimNode = AnimNodeSequence(Animations);
	// End:0x9F
	if((AnimNode == none) && Animations.IsA('AnimTree'))
	{
		AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
	}
	// End:0xFD
	if(AnimNode == none)
	{
		WarnInternal(("Base animation node is not an AnimNodeSequence (Owner:" @ string(Owner)) $ ")");		
	}
	else
	{
		AnimNode.StopAnim();
	}
	//return;	
}

event bool CreateForceField(const AnimNotify_ForceField AnimNotifyData)
{
	local editinline NxForceFieldComponent NewForceFieldComponent;

	NewForceFieldComponent = new (self) AnimNotifyData.ForceFieldComponent.Class (AnimNotifyData.ForceFieldComponent);
	NewForceFieldComponent.DoInitRBPhys();
	// End:0xDE
	if(AnimNotifyData.SocketName != 'None')
	{
		AttachComponentToSocket(NewForceFieldComponent, AnimNotifyData.SocketName);		
	}
	else
	{
		// End:0x13E
		if(AnimNotifyData.BoneName != 'None')
		{
			AttachComponent(NewForceFieldComponent, AnimNotifyData.BoneName);
		}
	}
	return true;
	//return ReturnValue;	
}

event bool PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
	local Vector Loc;
	local Rotator Rot;
	local WorldInfo WI;
	local editinline ParticleSystemComponent PSC;
	local bool bPlayNonExtreme;

	WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x99
	if(int(WI.NetMode) == int(NM_DedicatedServer))
	{
		LogInternal("(SkeletalMeshComponent): PlayParticleEffect on dedicated server!");
		return true;
	}
	// End:0xBF
	if(AnimNotifyData.PSTemplate == none)
	{
		return false;
	}
	bPlayNonExtreme = (AnimNotifyData.bIsExtremeContent && Class'Engine.Engine'.static.IsGame()) && WI.GRI.ShouldShowGore()!;
	// End:0x17D
	if(bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate == none)
	{
		return false;
	}
	// End:0x354
	if(AnimNotifyData.bAttach)
	{
		PSC = new (self) Class'Engine.ParticleSystemComponent';
		// End:0x204
		if(bPlayNonExtreme)
		{
			PSC.SetTemplate(AnimNotifyData.PSNonExtremeContentTemplate);			
		}
		else
		{
			PSC.SetTemplate(AnimNotifyData.PSTemplate);
		}
		// End:0x2A1
		if(AnimNotifyData.SocketName != 'None')
		{
			AttachComponentToSocket(PSC, AnimNotifyData.SocketName);			
		}
		else
		{
			// End:0x301
			if(AnimNotifyData.BoneName != 'None')
			{
				AttachComponent(PSC, AnimNotifyData.BoneName);
			}
		}
		PSC.ActivateSystem(true);
		PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;		
	}
	else
	{
		// End:0x3BE
		if(AnimNotifyData.SocketName != 'None')
		{
			GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);			
		}
		else
		{
			// End:0x437
			if(AnimNotifyData.BoneName != 'None')
			{
				Loc = GetBoneLocation(AnimNotifyData.BoneName);
				Rot = rot(0, 0, 1);				
			}
			else
			{
				Loc = GetPosition();
				Rot = rot(0, 0, 1);
			}
		}
		// End:0x5DF
		if(((Owner != none) && Owner.WorldInfo != none) && Owner.WorldInfo.MyEmitterPool != none)
		{
			// End:0x55F
			if(bPlayNonExtreme)
			{
				Owner.WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSNonExtremeContentTemplate, Loc, Rot);				
			}
			else
			{
				Owner.WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, Rot);
			}			
		}
		else
		{
			// End:0x71B
			if(Class'Engine.Engine'.static.IsGame())
			{
				PSC = new (self) Class'Engine.ParticleSystemComponent';
				PSC.SetTemplate(AnimNotifyData.PSTemplate);
				PSC.SetAbsolute(true, true, true);
				PSC.SetTranslation(Loc);
				PSC.SetRotation(Rot);
				PSC.ActivateSystem(true);
				PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;				
			}
			else
			{
				// End:0x917
				if(Class'Engine.Engine'.static.IsEditor())
				{
					PSC = new (self) Class'Engine.ParticleSystemComponent';
					PSC.SetTemplate(AnimNotifyData.PSTemplate);
					PSC.SetAbsolute(true, true, true);
					PSC.SetTranslation(Loc);
					PSC.SetRotation(Rot);
					// End:0x864
					if(AnimNotifyData.SocketName != 'None')
					{
						AttachComponentToSocket(PSC, AnimNotifyData.SocketName);						
					}
					else
					{
						// End:0x8C4
						if(AnimNotifyData.BoneName != 'None')
						{
							AttachComponent(PSC, AnimNotifyData.BoneName);
						}
					}
					PSC.ActivateSystem(true);
					PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;					
				}
				else
				{
					return false;
				}
			}
		}
	}
	// End:0x9AD
	if(((PSC != none) && AnimNotifyData.BoneSocketModuleActorName != 'None') && Owner != none)
	{
		PSC.SetActorParameter(AnimNotifyData.BoneSocketModuleActorName, Owner);
	}
	return true;
	//return ReturnValue;	
}

simulated function SkelMeshCompOnParticleSystemFinished(ParticleSystemComponent PSC)
{
	DetachComponent(PSC);
	//return;	
}

final simulated function BreakConstraint(Vector Impulse, Vector HitLocation, name InBoneName, optional bool bVelChange)
{
	local int ConstraintIndex, LODIdx;
	local RB_ConstraintInstance Constraint;
	local RB_ConstraintSetup ConstraintSetup;
	local RB_BodyInstance Body;

	ConstraintIndex = FindConstraintIndex(InBoneName);
	// End:0x33
	if(ConstraintIndex == -1)
	{
		return;
	}
	Constraint = PhysicsAssetInstance.Constraints[ConstraintIndex];
	// End:0x89
	if(Constraint.bTerminated)
	{
		return;
	}
	LODIdx = 0;
	J0x94:

	// End:0xFF [Loop If]
	if(LODIdx < LODInfo.Length)
	{
		// End:0xF1
		if(int(LODInfo[LODIdx].InstanceWeightUsage) == int(0))
		{
			ToggleInstanceVertexWeights(true, LODIdx);
		}
		LODIdx++;
		// [Loop Continue]
		goto J0x94;
	}
	AddInstanceVertexWeightBoneParented(InBoneName);
	ConstraintSetup = PhysicsAsset.ConstraintSetup[Constraint.ConstraintIndex];
	Body = FindBodyInstanceNamed(ConstraintSetup.JointName);
	// End:0x1DF
	if((Body != none) && Body.IsFixed())
	{
		Body.SetFixed(false);
	}
	Constraint.TermConstraint();
	UpdateMeshForBrokenConstraints();
	AddImpulse(Impulse, HitLocation, InBoneName, bVelChange);
	//return;	
}

// Export USkeletalMeshComponent::execGetPosition(FFrame&, void* const)
native function Vector GetPosition();

// Export USkeletalMeshComponent::execGetRotation(FFrame&, void* const)
native function Rotator GetRotation();

// Export USkeletalMeshComponent::execSetMaterial(FFrame&, void* const)
native function SetMaterial(int ElementIndex, MaterialInterface Material);

defaultproperties
{
	GlobalAnimRateScale=1.0000000
	StreamingDistanceMultiplier=1.0000000
	WireframeColor=(R=221,G=221,B=255,A=28)
	AnimationLODFrameRate=2
	bTransformFromAnimParent=1
	bUpdateSkelWhenNotRendered=true
	bTickAnimNodesWhenNotRendered=true
	bUpdateKinematicBonesFromAnimation=true
	bSyncActorLocationToRootRigidBody=true
	LineCheckBoundsScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	bAutoFreezeClothWhenNotRendered=true
	bCacheAnimSequenceNodes=true
	ClothBlendWeight=1.0000000
	ClothBlendMinDistanceFactor=-1.0000000
	ClothRBChannel=ERBCollisionChannel.RBCC_Cloth
	ClothImpulseScale=1.0000000
	ClothAttachmentTearFactor=-1.0000000
	MinDistanceForClothReset=256.0000000
	ApexClothingRBChannel=ERBCollisionChannel.RBCC_Clothing
	ApexClothingRBCollideWithChannels=(Default=true,Nothing=false,Pawn=false,Vehicle=false,Water=false,GameplayPhysics=true,EffectPhysics=true,Untitled1=false,Untitled2=false,Untitled3=false,Untitled4=false,Cloth=false,FluidDrain=false,SoftBody=false,FracturedMeshPart=false,BlockingVolume=true,DeadPawn=false,Clothing=false,ClothingCollision=true)
	ApexClothingCollisionRBChannel=ERBCollisionChannel.RBCC_ClothingCollision
	bAutoFreezeApexClothingWhenNotRendered=true
	SoftBodyImpulseScale=1.0000000
	bSoftBodyUseCompartment=true
	SoftBodyRBChannel=ERBCollisionChannel.RBCC_SoftBody
	RootMotionAccelScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	RootMotionMode=ERootMotionMode.RMM_Ignore
	PreviousRMM=ERootMotionMode.RMM_Ignore
	FaceFXBlendMode=EFaceFXBlendMode.FXBM_Additive
	ProgressiveDrawingFraction=1.0000000
	ReplacementPrimitive=none
	bAcceptsDynamicDecals=false
	TickGroup=ETickingGroup.TG_PreAsyncWork
}