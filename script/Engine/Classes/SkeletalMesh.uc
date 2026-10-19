class SkeletalMesh extends Object
	native
	noexport
	dependson(ApexClothingAsset);

enum BoneBreakOption
{
	BONEBREAK_SoftPreferred,        // 0
	BONEBREAK_AutoDetect,           // 1
	BONEBREAK_RigidPreferred,       // 2
	BONEBREAK_MAX                   // 3
};

enum TriangleSortOption
{
	TRISORT_None,                   // 0
	TRISORT_CenterRadialDistance,   // 1
	TRISORT_Random,                 // 2
	TRISORT_MergeContiguous,        // 3
	TRISORT_Custom,                 // 4
	TRISORT_CustomLeftRight,        // 5
	TRISORT_MAX                     // 6
};

enum ClothMovementScaleGen
{
	ECMDM_DistToFixedVert,          // 0
	ECMDM_VertexBoneWeight,         // 1
	ECMDM_Empty,                    // 2
	ECMDM_MAX                       // 3
};

enum TriangleSortAxis
{
	TSA_X_Axis,                     // 0
	TSA_Y_Axis,                     // 1
	TSA_Z_Axis,                     // 2
	TSA_MAX                         // 3
};

enum SkeletalMeshOptimizationImportance
{
	SMOI_Off,                       // 0
	SMOI_Lowest,                    // 1
	SMOI_Low,                       // 2
	SMOI_Normal,                    // 3
	SMOI_High,                      // 4
	SMOI_Highest,                   // 5
	SMOI_MAX                        // 6
};

enum SkeletalMeshOptimizationType
{
	SMOT_NumOfTriangles,            // 0
	SMOT_MaxDeviation,              // 1
	SMOT_MAX                        // 2
};

enum SkeletalMeshOptimizationNormalMode
{
	SMONM_Recalculate,              // 0
	SMONM_RecalculateSoft,          // 1
	SMONM_RecalculateHard,          // 2
	SMONM_MAX                       // 3
};

enum ClothBoneType
{
	CLOTHBONE_Fixed,                // 0
	CLOTHBONE_BreakableAttachment,  // 1
	CLOTHBONE_TearLine,             // 2
	CLOTHBONE_MAX                   // 3
};

enum SoftBodyBoneType
{
	SOFTBODYBONE_Fixed,             // 0
	SOFTBODYBONE_BreakableAttachment,// 1
	SOFTBODYBONE_TwoWayAttachment,  // 2
	SOFTBODYBONE_MAX                // 3
};

struct native ApexClothingLodInfo
{
	var editfixedsize array<int> ClothingSectionInfo;

	structdefaultproperties
	{
		ClothingSectionInfo=none
	}
};

struct native ApexClothingAssetInfo
{
	var editfixedsize array<ApexClothingLodInfo> ClothingLodInfo;
	var name ClothingAssetName;

	structdefaultproperties
	{
		ClothingLodInfo=none
		ClothingAssetName="None"
	}
};

struct native BoneMirrorInfo
{
	var int SourceIndex;
	var Object.EAxis BoneFlipAxis;

	structdefaultproperties
	{
		SourceIndex=0
		BoneFlipAxis=AXIS_NONE
	}
};

struct native BoneMirrorExport
{
	var name BoneName;
	var name SourceBoneName;
	var Object.EAxis BoneFlipAxis;

	structdefaultproperties
	{
		BoneName="None"
		SourceBoneName="None"
		BoneFlipAxis=AXIS_NONE
	}
};

struct TriangleSortSettings
{
	var SkeletalMesh.TriangleSortOption TriangleSorting;
	var SkeletalMesh.TriangleSortAxis CustomLeftRightAxis;
	var name CustomLeftRightBoneName;

	structdefaultproperties
	{
		TriangleSorting=TRISORT_None
		CustomLeftRightAxis=TSA_X_Axis
		CustomLeftRightBoneName="None"
	}
};

struct native SkeletalMeshLODInfo
{
	var float DisplayFactor;
	var float LODHysteresis;
	var editfixedsize array<int> LODMaterialMap;
	var editfixedsize array<bool> bEnableShadowCasting;
	var deprecated array<deprecated SkeletalMesh.TriangleSortOption> TriangleSorting;
	var editfixedsize array<TriangleSortSettings> TriangleSortSettings;
	var bool bDisableCompressions;
	var bool bHasBeenSimplified;

	structdefaultproperties
	{
		DisplayFactor=0.0000000
		LODHysteresis=0.0000000
		LODMaterialMap=none
		bEnableShadowCasting=none
		TriangleSortSettings=none
		bDisableCompressions=false
		bHasBeenSimplified=false
	}
};

struct native SkeletalMeshOptimizationSettings
{
	var float MaxDeviationPercentage;
	var SkeletalMesh.SkeletalMeshOptimizationImportance SilhouetteImportance;
	var SkeletalMesh.SkeletalMeshOptimizationImportance TextureImportance;
	var SkeletalMesh.SkeletalMeshOptimizationImportance ShadingImportance;
	var SkeletalMesh.SkeletalMeshOptimizationImportance SkinningImportance;
	var deprecated SkeletalMesh.SkeletalMeshOptimizationNormalMode NormalMode;
	var float BoneReductionRatio;
	var int MaxBonesPerVertex;
	var SkeletalMesh.SkeletalMeshOptimizationType ReductionMethod;
	var float NumOfTrianglesPercentage;
	var float WeldingThreshold;
	var bool bRecalcNormals;
	var float NormalsThreshold;

	structdefaultproperties
	{
		MaxDeviationPercentage=0.0000000
		SilhouetteImportance=SMOI_Off
		TextureImportance=SMOI_Off
		ShadingImportance=SMOI_Off
		SkinningImportance=SMOI_Off
		BoneReductionRatio=0.0000000
		MaxBonesPerVertex=0
		ReductionMethod=SMOT_NumOfTriangles
		NumOfTrianglesPercentage=0.0000000
		WeldingThreshold=0.0000000
		bRecalcNormals=false
		NormalsThreshold=0.0000000
	}
};

struct native ClothSpecialBoneInfo
{
	var name BoneName;
	var SkeletalMesh.ClothBoneType BoneType;
	var const array<int> AttachedVertexIndices;

	structdefaultproperties
	{
		BoneName="None"
		BoneType=CLOTHBONE_Fixed
		AttachedVertexIndices=none
	}
};

struct native SoftBodyTetraLink
{
	var int Index;
	var Vector Bary;

	structdefaultproperties
	{
		Index=0
		Bary=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

struct native SoftBodySpecialBoneInfo
{
	var name BoneName;
	var SkeletalMesh.SoftBodyBoneType BoneType;
	var const array<int> AttachedVertexIndices;

	structdefaultproperties
	{
		BoneName="None"
		BoneType=SOFTBODYBONE_Fixed
		AttachedVertexIndices=none
	}
};

var native const BoxSphereBounds Bounds;
var native const array<MaterialInterface> Materials;
var editfixedsize array<ApexClothingAsset> ClothingAssets;
var editfixedsize array<ApexClothingAssetInfo> ClothingLodMap;
var native const Vector Origin;
var native const Rotator RotOrigin;
var native const array<int> RefSkeleton;
var native const int SkeletalDepth;
var native const map{VOID,VOID} NameIndexMap;
var private native const IndirectArray_Mirror LODModels;
var private native const Pointer SourceData;
var native const array<BoneAtom> RefBasesInvMatrix;
var editfixedsize array<BoneMirrorInfo> SkelMirrorTable;
var Object.EAxis SkelMirrorAxis;
var Object.EAxis SkelMirrorFlipAxis;
var array<SkeletalMeshSocket> Sockets;
var native const editconst array<editconst string> BoneBreakNames;
var native const array<SkeletalMesh.BoneBreakOption> BoneBreakOptions;
var editfixedsize array<SkeletalMeshLODInfo> LODInfo;
var array<SkeletalMeshOptimizationSettings> OptimizationSettings;
var array<name> PerPolyCollisionBones;
var array<name> AddToParentPerPolyCollisionBone;
var private native const array<int> PerPolyBoneKDOPs;
var bool bPerPolyUseSoftWeighting;
var bool bUseSimpleLineCollision;
var bool bUseSimpleBoxCollision;
var const bool bForceCPUSkinning;
var const bool bUseFullPrecisionUVs;
var bool bHasBeenSimplified;
var FaceFXAsset FaceFXAsset;
var int LODBiasPC;
var int LODBiasPS3;
var int LODBiasXbox360;
var native const transient array<Pointer> ClothMesh;
var native const transient array<float> ClothMeshScale;
var const array<int> ClothToGraphicsVertMap;
var const array<float> ClothMovementScale;
var SkeletalMesh.ClothMovementScaleGen ClothMovementScaleGenMode;
var float ClothToAnimMeshMaxDist;
var bool bLimitClothToAnimMesh;
var const array<int> ClothWeldingMap;
var const int ClothWeldingDomain;
var const array<int> ClothWeldedIndices;
var const bool bForceNoWelding;
var const int NumFreeClothVerts;
var const array<int> ClothIndexBuffer;
var const array<name> ClothBones;
var const int ClothHierarchyLevels;
var const bool bEnableClothBendConstraints;
var const bool bEnableClothDamping;
var const bool bUseClothCOMDamping;
var const float ClothStretchStiffness;
var const float ClothBendStiffness;
var const float ClothDensity;
var const float ClothThickness;
var const float ClothDamping;
var const int ClothIterations;
var const int ClothHierarchicalIterations;
var const float ClothFriction;
var const float ClothRelativeGridSpacing;
var const float ClothPressure;
var const float ClothCollisionResponseCoefficient;
var const float ClothAttachmentResponseCoefficient;
var const float ClothAttachmentTearFactor;
var const float ClothSleepLinearVelocity;
var const float HardStretchLimitFactor;
var const bool bHardStretchLimit;
var const bool bEnableClothOrthoBendConstraints;
var const bool bEnableClothSelfCollision;
var const bool bEnableClothPressure;
var const bool bEnableClothTwoWayCollision;
var const array<ClothSpecialBoneInfo> ClothSpecialBones;
var const bool bEnableClothLineChecks;
var const bool bClothMetal;
var const float ClothMetalImpulseThreshold;
var const float ClothMetalPenetrationDepth;
var const float ClothMetalMaxDeformationDistance;
var const bool bEnableClothTearing;
var const float ClothTearFactor;
var const int ClothTearReserve;
var bool bEnableValidBounds;
var Vector ValidBoundsMin;
var Vector ValidBoundsMax;
var native const Map_Mirror ClothTornTriMap;
var const array<int> SoftBodySurfaceToGraphicsVertMap;
var const array<int> SoftBodySurfaceIndices;
var const array<Vector> SoftBodyTetraVertsUnscaled;
var const array<int> SoftBodyTetraIndices;
var const array<SoftBodyTetraLink> SoftBodyTetraLinks;
var native const transient array<Pointer> CachedSoftBodyMeshes;
var native const transient array<float> CachedSoftBodyMeshScales;
var const array<name> SoftBodyBones;
var const array<SoftBodySpecialBoneInfo> SoftBodySpecialBones;
var const float SoftBodyVolumeStiffness;
var const float SoftBodyStretchingStiffness;
var const float SoftBodyDensity;
var const float SoftBodyParticleRadius;
var const float SoftBodyDamping;
var const int SoftBodySolverIterations;
var const float SoftBodyFriction;
var const float SoftBodyRelativeGridSpacing;
var const float SoftBodySleepLinearVelocity;
var const bool bEnableSoftBodySelfCollision;
var const float SoftBodyAttachmentResponse;
var const float SoftBodyCollisionResponse;
var const float SoftBodyDetailLevel;
var const int SoftBodySubdivisionLevel;
var const bool bSoftBodyIsoSurface;
var const bool bEnableSoftBodyDamping;
var const bool bUseSoftBodyCOMDamping;
var const float SoftBodyAttachmentThreshold;
var const bool bEnableSoftBodyTwoWayCollision;
var const float SoftBodyAttachmentTearFactor;
var const bool bEnableSoftBodyLineChecks;
var bool bHasVertexColors;
var native const array<bool> GraphicsIndexIsCloth;
var native const array<float> CachedStreamingTextureFactors;
var const float StreamingDistanceMultiplier;
var native const transient int ReleaseResourcesFence;
var const transient QWord SkelMeshRUID;
var const bool bUseClothingAssetMaterial;

defaultproperties
{
	SkelMirrorAxis=AXIS_X
	SkelMirrorFlipAxis=AXIS_Z
	bUseSimpleLineCollision=true
	bUseSimpleBoxCollision=true
	ClothStretchStiffness=1.0000000
	ClothBendStiffness=1.0000000
	ClothDensity=1.0000000
	ClothThickness=0.5000000
	ClothDamping=0.5000000
	ClothIterations=5
	ClothHierarchicalIterations=2
	ClothFriction=0.5000000
	ClothRelativeGridSpacing=1.0000000
	ClothPressure=1.0000000
	ClothCollisionResponseCoefficient=0.2000000
	ClothAttachmentResponseCoefficient=0.2000000
	ClothAttachmentTearFactor=1.5000000
	ClothSleepLinearVelocity=-1.0000000
	HardStretchLimitFactor=1.1000000
	ClothMetalImpulseThreshold=10.0000000
	ClothTearFactor=3.5000000
	ClothTearReserve=128
	SoftBodyVolumeStiffness=1.0000000
	SoftBodyStretchingStiffness=1.0000000
	SoftBodyDensity=1.0000000
	SoftBodyParticleRadius=0.1000000
	SoftBodyDamping=0.5000000
	SoftBodySolverIterations=5
	SoftBodyFriction=0.5000000
	SoftBodyRelativeGridSpacing=1.0000000
	SoftBodySleepLinearVelocity=-1.0000000
	SoftBodyAttachmentResponse=0.2000000
	SoftBodyCollisionResponse=0.2000000
	SoftBodyDetailLevel=0.5000000
	SoftBodySubdivisionLevel=4
	bSoftBodyIsoSurface=true
	SoftBodyAttachmentThreshold=0.5000000
	bEnableSoftBodyTwoWayCollision=true
	SoftBodyAttachmentTearFactor=1.5000000
	StreamingDistanceMultiplier=1.0000000
}