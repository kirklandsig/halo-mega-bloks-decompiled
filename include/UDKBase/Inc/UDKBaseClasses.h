// Generated from the PDB by: python tools/gen_classes.py UDKBase
#pragma once

namespace Grip {
template <class T0, int T1> struct AllocatorGH;
template <class T0> struct ListNode;
struct AllocInfo;
struct MemAddressStub;
struct MemItem;
class Memory;
class MemoryHeap;
class StatBag;
class String;
class StringBuffer;
class SysAlloc;
class SysAllocPaged;
}

template <class T0> class GripRBTNumericCondition;
template <class T0, class T1> class Grip_Array;
template <class T0, int T1> class Grip_ArrayPOD;
template <class T0, class T1> class TArray;
template <class T0> class TArrayNoInit;
template <class T0, class T1> class TIndirectArray;
template <class T0, class T1, class T2> class TMap;
template <class T0, int T1> class TMemStackAllocator;
class AAIController;
class AActor;
class ACCSController;
class AController;
class ACoverLink;
class AFluidSurfaceActor;
class AGameAIController;
class AGwNavAIController;
class AGwNavVehicle;
class AInventory;
class AKAsset;
class ANavigationPoint;
class APawn;
class APhysicsVolume;
class APickupFactory;
class APlayerController;
class APlayerReplicationInfo;
class APortalTeleporter;
class APrefabInstance;
class AProjectile;
class ASVehicle;
class AScout;
class AUDKCover;
class AUDKPawn;
class AUSSController;
class AUSSPawn;
class AVehicle;
class AVolume;
class AWeapon;
class AWorldInfo;
struct ActorWrapper;
class CCSAFAction;
class CCSAFEncircleTarget;
class CCSAFEnterCover;
class CCSAFExitCover;
class CCSAFFactory;
class CCSAFFireBurst;
class CCSAFFlee;
class CCSAFGetInCover;
class CCSAFGetOutCover;
class CCSAFIdle;
class CCSAFMoveTo;
class CCSAFMoveToActor;
class CCSAFOrientToward;
class CCSAFStrafeTarget;
class CCSAFStrafeTo;
struct CCSAOEncircleTarget;
struct CCSAOEnterCover;
struct CCSAOExitCover;
struct CCSAOFireBurst;
struct CCSAOFlee;
struct CCSAOGetInCover;
struct CCSAOGetOutCover;
struct CCSAOIdle;
struct CCSAOMoveTo;
struct CCSAOMoveToActor;
struct CCSAOOrientToward;
struct CCSAOStrafeTarget;
struct CCSAOStrafeTo;
class CCSBlackboard;
class CCSBrain;
struct CCSCharacter;
struct CCSController_eventActionStopFiring_Parms;
struct CCSController_eventAimAt_Parms;
struct CCSController_eventCanFireAt_Parms;
struct CCSController_eventCreateDebugVizComponent_Parms;
struct CCSController_eventFindNavMeshDistance_Parms;
struct CCSController_eventFindNavMeshPath_Parms;
struct CCSController_eventFireWeapon_Parms;
struct CCSController_eventNotifyAIMoveToActorCompleted_Parms;
struct CCSController_eventStartFireBurstObj_Parms;
struct CCSController_eventStartFireBurst_Parms;
struct CCSController_eventStopFireBurst_Parms;
struct CCSCover;
class CCSCoverRenderingComponent;
struct CCSGameCover;
class CCSNorman;
class CCSPSCover;
class CCSPSTargetAwareness;
class CCSRBTEncircleTarget;
class CCSRBTEnemyAware;
class CCSRBTEnemyClosestRange;
class CCSRBTEnemyLowestLKPAge;
class CCSRBTMoveTo;
class CCSRBTMoveToBestCover;
class CCSRBTMoveToClosestCover;
class CCSRBTMoveToCover;
class CCSRBTMoveToInitialCover;
class CCSRBTMoveToTether;
class CCSRBTSearch;
class CCSRBTSelectTarget;
class CCSRBTShoot;
class CCSRBTShootFromCover;
class CCSRBTStrafeTarget;
class CCSRBTTargetAngle;
class CCSRBTTargetClear;
class CCSRBTTargetInCover;
class CCSRBTTargetKnockedDown;
class CCSRBTTargetRange;
class CCSRBTTargetShootable;
class CCSRBTTargetVisible;
class CCSRBTTimeSinceAimedAt;
class CCSRBTTimeSinceBecameAware;
class CCSRBTTimeSinceDamage;
class CCSRBTTimeSinceEvent;
class CCSRBTTimeSinceGrenadeStuck;
class CCSRBTTimeSinceStaggered;
class CCSRBTTimeSinceSuccessfulAttack;
class CCSRBTTimeSinceTargetCamoed;
class CCSRBTTimeSinceThreatChanged;
class CCSRBTTimeSinceThreatened;
class CCSRBTVisibleToPlayerCamera;
class CCSRBTWaitInCover;
class CCSSensorSystem;
struct CCSSystemsConfig;
struct CCSTarget;
class CCSTargetRenderingComponent;
struct CoverLink_eventSetDisabled_Parms;
struct FActorReference;
struct FAnimSlotDesc;
struct FAnimSlotInfo;
class FArchive;
struct FAsyncPackage;
struct FBasedPosition;
class FBoneAtom;
class FBox;
struct FCCSCoverData;
struct FCCSMoveCmdData;
struct FCCSTargetData;
class FCanvas;
struct FCheckResult;
struct FCollisionImpactData;
class FColor;
struct FCoverInfo;
struct FCoverReference;
struct FCoverSlot;
struct FCurveKey;
struct FCylinder;
class FDecalRenderData;
class FDecalState;
class FDefaultAllocator;
class FDefaultSetAllocator;
struct FDynamicLinkInfo;
class FEditPropertyChain;
class FExportObjectInnerContext;
class FFeedbackContext;
class FForceApplicator;
struct FFrame;
class FGuid;
struct FIntPoint;
class FKCachedConvexData;
class FLightingBuildOptions;
struct FLightingChannelContainer;
struct FLinearColor;
class FMatrix;
struct FMeshBone;
class FName;
struct FNameEntry;
struct FNavMeshEdgeBase;
struct FNavMeshMantleEdge;
struct FNavMeshPathParams;
struct FObjectDuplicationParameters;
struct FObjectInstancingGraph;
struct FOutParmRec;
class FOutputDevice;
class FPlane;
class FPrimitiveSceneProxy;
class FPrimitiveTriangleDefinitionInterface;
struct FPropertyChangedChainEvent;
struct FPropertyChangedEvent;
struct FPropertyRetirement;
class FQuat;
struct FRBCollisionChannelContainer;
class FRBPhysScene;
struct FReferencerInformation;
struct FReferencerInformationList;
class FRenderCommandFence;
struct FRigidBodyCollisionInfo;
struct FRigidBodyContactInfo;
struct FRigidBodyState;
class FRotator;
struct FScalarParameterInterpStruct;
class FSceneInterface;
struct FScriptDelegate;
struct FStateFrame;
struct FStaticLightingPrimitiveInfo;
struct FStreamingTexturePrimitiveInfo;
class FString;
struct FTimerData;
struct FTraceHitInfo;
class FVector;
struct FVector2D;
class FVector4;
class GMainThreadMemStack;
class GripAFAction;
class GripAFFactory;
class GripAFModifier;
class GripAFScheduler;
class GripBBMember;
class GripBBVisualization;
struct GripBTScriptNodeCache_eventCacheAllConditions_Parms;
struct GripBTScriptNodeCache_eventInitializeAllNodes_Parms;
struct GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms;
class GripBTStack;
class GripBTSystemFlags;
class GripBlackboard;
class GripBrainSystem;
struct GripEvent;
class GripGameEventHandler;
class GripHUDRenderer;
class GripRBTAllocator;
class GripRBTBehavior;
class GripRBTBooleanCondition;
class GripRBTCondition;
class GripRBTNode;
class GripSerializer;
struct GripSystemConfig;
class GripVHeapObject;
struct Grip_Rotation;
struct Grip_Vector;
struct GwNavVehicle_eventExecuteVehicleCommand_Parms;
class HaloRBTKamikaze;
class ICCSMeatPuppet;
class ICCSPawn;
class IGJKHelper;
class IGripBTInterface;
class IGripSceneRenderer;
class IInterface_NavigationHandle;
class IInterface_Speaker;
class NxActor;
class NxActorDesc;
class NxGroupsMask;
class UActorChannel;
class UActorComponent;
class UActorFactory;
class UActorFactoryAI;
class UAkBaseSoundObject;
class UAkEvent;
class UAnimNode;
class UAnimNodeAimOffset;
class UAnimNodeBlendBase;
class UAnimNodeBlendList;
class UAnimNodeSequence;
class UAnimNodeSlot;
class UAnimNotify_ForceField;
class UAnimNotify_PlayParticleEffect;
class UAnimNotify_Trails;
class UAnimObject;
class UAnimSet;
class UAnimTree;
class UArrayProperty;
class UAudioComponent;
class UCCSAFEncircleTarget;
class UCCSAFEnterCover;
class UCCSAFExitCover;
class UCCSAFFireBurst;
class UCCSAFFlee;
class UCCSAFGetInCover;
class UCCSAFGetOutCover;
class UCCSAFIdle;
class UCCSAFMoveTo;
class UCCSAFMoveToActor;
class UCCSAFOrientToward;
class UCCSAFStrafeTarget;
class UCCSAFStrafeTo;
class UCCSATAnimNodeSlot;
class UCCSATBlendListBase;
class UCCSActorFactory;
class UCCSBTEncircleTarget;
class UCCSBTEnemyAware;
class UCCSBTEnemyClosestRange;
class UCCSBTEnemyLowestLKPAge;
class UCCSBTFlee;
class UCCSBTIdle;
class UCCSBTMoveIntoBestCover;
class UCCSBTMoveIntoClosestCover;
class UCCSBTMoveIntoCover;
class UCCSBTMoveIntoInitialCover;
class UCCSBTMoveTo;
class UCCSBTMoveToActor;
class UCCSBTMoveToTarget;
class UCCSBTMoveToTether;
class UCCSBTMoveToVehicle;
class UCCSBTOrientTowardTarget;
class UCCSBTScriptBehavior;
class UCCSBTScriptCondition;
class UCCSBTScriptCover;
class UCCSBTSearch;
class UCCSBTSelectTarget;
class UCCSBTShoot;
class UCCSBTShootFromCover;
class UCCSBTStrafeTarget;
class UCCSBTTargetAngle;
class UCCSBTTargetClear;
class UCCSBTTargetInCover;
class UCCSBTTargetKnockedDown;
class UCCSBTTargetRange;
class UCCSBTTargetShootable;
class UCCSBTTargetVisible;
class UCCSBTTimeSinceAimedAt;
class UCCSBTTimeSinceBecameAware;
class UCCSBTTimeSinceDamage;
class UCCSBTTimeSinceEvent;
class UCCSBTTimeSinceGrenadeStuck;
class UCCSBTTimeSinceStaggered;
class UCCSBTTimeSinceSuccessfulAttack;
class UCCSBTTimeSinceTargetCamoed;
class UCCSBTTimeSinceThreatChanged;
class UCCSBTTimeSinceThreatened;
class UCCSBTTree;
class UCCSBTVisibleToPlayerCamera;
class UCCSBTWaitInCover;
class UCCSBlackboard;
class UCCSCover;
class UCCSPawn;
class UCCSSystemConfig;
class UCCSTarget;
class UCCSVisualizationComponent;
class UCanvas;
class UClass;
class UComponent;
class UDecalComponent;
class UFaceFXAnimSet;
class UFaceFXAsset;
class UField;
class UFunction;
class UGameAICommand;
class UGripAFActionHandle;
class UGripBTBooleanCondition;
class UGripBTFloatCondition;
class UGripBTInterface;
class UGripBTNode;
class UGripBTNumericCondition;
class UGripBTObject;
class UGripBTScriptBehavior;
class UGripBTScriptCondition;
class UGripBTScriptNode;
class UGripBTScriptNodeCache;
class UGripBlackboard;
class UGwNavActorFactoryAI;
class UGwNavNavdataFamily;
class UHaloAnimBlendByAimProfile;
class UHaloAnimBlendByForwardMomentum;
class UHaloAnimBlendByJumpType;
class UHaloAnimBlendByPhysics;
class UHaloAnimBlendByTurnInPlace;
class UHaloAnimNodeCopyBoneTranslation;
class UHaloBTKamikaze;
class UInterface;
class UInterpGroup;
class UInterpGroupInst;
class UInterpTrackInstMove;
class UInterpTrackMove;
class ULevel;
class ULightComponent;
class ULightEnvironmentComponent;
class ULinkerLoad;
class ULinkerSave;
class UMaterialInterface;
class UMorphNodeBase;
class UNavigationHandle;
class UNavigationMeshBase;
class UObject;
class UPackage;
class UPackageMap;
class UParticleSystem;
class UPathConstraint;
class UPathGoalEvaluator;
class UPhysicalMaterial;
class UPhysicsAsset;
class UPrimitiveComponent;
class UProperty;
class URB_BodyInstance;
class URB_BodySetup;
class URB_ConstraintInstance;
class URB_ConstraintSetup;
class UReachSpec;
class USVehicleWheel;
class USelection;
class USeqAct_ActorFactory;
class USeqAct_Interp;
class USeqAct_Latent;
class USequenceEvent;
class USequenceObject;
class USequenceOp;
class USkelControlBase;
class USkelControlLookAt;
class USkeletalMesh;
class USkeletalMeshComponent;
class USoundCue;
class USpriteComponent;
class UState;
class UStruct;
class UTexture;
class UUDKAnimBlendBase;
class UUDKAnimBlendByPhysics;
class UUDKAnimBlendByTurnInPlace;
class UUDKAnimNodeCopyBoneTranslation;
class UUDKTargetableComponent;
class UUSSATBlendByAlertness;
class UUSSATBlendByCover;
class UUSSATBlendByCoverPose;
class UUSSATBlendByMove;
class UUSSATBlendByPosture;
enum BTMenuType
{
    MT_BEHAVIOR = 0,
    MT_CONDITION = 1,
    MT_CONTROL = 2,
    MT_TEST = 3,
    MT_ROOT = 4,
    MT_HIDDEN = 5,
    MT_NUMOF = 6,
    MT_MAX = 7,
};
enum EActorMetricsType
{
    METRICS_VERTS = 0,
    METRICS_TRIS = 1,
    METRICS_SECTIONS = 2,
    METRICS_MAX = 3,
};
enum EClassCastFlag
{
    CASTCLASS_None = 0,
    CASTCLASS_UField = 1,
    CASTCLASS_UConst = 2,
    CASTCLASS_UEnum = 4,
    CASTCLASS_UStruct = 8,
    CASTCLASS_UScriptStruct = 16,
    CASTCLASS_UClass = 32,
    CASTCLASS_UByteProperty = 64,
    CASTCLASS_UIntProperty = 128,
    CASTCLASS_UFloatProperty = 256,
    CASTCLASS_UComponentProperty = 512,
    CASTCLASS_UClassProperty = 1024,
    CASTCLASS_UInterfaceProperty = 4096,
    CASTCLASS_UNameProperty = 8192,
    CASTCLASS_UStrProperty = 16384,
    CASTCLASS_UProperty = 32768,
    CASTCLASS_UObjectProperty = 65536,
    CASTCLASS_UBoolProperty = 131072,
    CASTCLASS_UState = 262144,
    CASTCLASS_UFunction = 524288,
    CASTCLASS_UStructProperty = 1048576,
    CASTCLASS_UArrayProperty = 2097152,
    CASTCLASS_UMapProperty = 4194304,
    CASTCLASS_UDelegateProperty = 8388608,
    CASTCLASS_UComponent = 16777216,
    CASTCLASS_AllFlags = -1,
};
enum EEventParm
{
    EC_EventParm = 0,
};
enum EEventType
{
    HALO_EVENT_NONE = 0,
    HALO_EVENT_DAMAGED = 1,
    HALO_EVENT_DEATH = 2,
    HALO_EVENT_ENTER_SLOW_TRAP = 3,
    HALO_EVENT_EXIT_SLOW_TRAP = 4,
    HALO_EVENT_ROOT_MOTION_COLLISION = 5,
    HALO_EVENT_MAX = 6,
};
enum EExprToken
{
    EX_LocalVariable = 0,
    EX_InstanceVariable = 1,
    EX_DefaultVariable = 2,
    EX_StateVariable = 3,
    EX_Return = 4,
    EX_Switch = 5,
    EX_Jump = 6,
    EX_JumpIfNot = 7,
    EX_Stop = 8,
    EX_Assert = 9,
    EX_Case = 10,
    EX_Nothing = 11,
    EX_LabelTable = 12,
    EX_GotoLabel = 13,
    EX_EatReturnValue = 14,
    EX_Let = 15,
    EX_DynArrayElement = 16,
    EX_New = 17,
    EX_ClassContext = 18,
    EX_MetaCast = 19,
    EX_LetBool = 20,
    EX_EndParmValue = 21,
    EX_EndFunctionParms = 22,
    EX_Self = 23,
    EX_Skip = 24,
    EX_Context = 25,
    EX_ArrayElement = 26,
    EX_VirtualFunction = 27,
    EX_FinalFunction = 28,
    EX_IntConst = 29,
    EX_FloatConst = 30,
    EX_StringConst = 31,
    EX_ObjectConst = 32,
    EX_NameConst = 33,
    EX_RotationConst = 34,
    EX_VectorConst = 35,
    EX_ByteConst = 36,
    EX_IntZero = 37,
    EX_IntOne = 38,
    EX_True = 39,
    EX_False = 40,
    EX_NativeParm = 41,
    EX_NoObject = 42,
    EX_IntConstByte = 44,
    EX_BoolVariable = 45,
    EX_DynamicCast = 46,
    EX_Iterator = 47,
    EX_IteratorPop = 48,
    EX_IteratorNext = 49,
    EX_StructCmpEq = 50,
    EX_StructCmpNe = 51,
    EX_UnicodeStringConst = 52,
    EX_StructMember = 53,
    EX_DynArrayLength = 54,
    EX_GlobalFunction = 55,
    EX_PrimitiveCast = 56,
    EX_DynArrayInsert = 57,
    EX_ReturnNothing = 58,
    EX_EqualEqual_DelDel = 59,
    EX_NotEqual_DelDel = 60,
    EX_EqualEqual_DelFunc = 61,
    EX_NotEqual_DelFunc = 62,
    EX_EmptyDelegate = 63,
    EX_DynArrayRemove = 64,
    EX_DebugInfo = 65,
    EX_DelegateFunction = 66,
    EX_DelegateProperty = 67,
    EX_LetDelegate = 68,
    EX_Conditional = 69,
    EX_DynArrayFind = 70,
    EX_DynArrayFindStruct = 71,
    EX_LocalOutVariable = 72,
    EX_DefaultParmValue = 73,
    EX_EmptyParmValue = 74,
    EX_InstanceDelegate = 75,
    EX_InterfaceContext = 81,
    EX_InterfaceCast = 82,
    EX_EndOfScript = 83,
    EX_DynArrayAdd = 84,
    EX_DynArrayAddItem = 85,
    EX_DynArrayRemoveItem = 86,
    EX_DynArrayInsertItem = 87,
    EX_DynArrayIterator = 88,
    EX_DynArraySort = 89,
    EX_JumpIfFilterEditorOnly = 90,
    EX_ExtendedNative = 96,
    EX_FirstNative = 112,
    EX_Max = 4096,
};
enum EFindName
{
    FNAME_Find = 0,
    FNAME_Add = 1,
    FNAME_Replace = 2,
};
enum EForceInit
{
    E_ForceInit = 0,
};
enum EGotoState
{
    GOTOSTATE_NotFound = 0,
    GOTOSTATE_Success = 1,
    GOTOSTATE_Preempted = 2,
};
enum EGripBTNodeFamily
{
    GRIP_NF_BEHAVIOR = 0,
    GRIP_NF_CONTROL = 1,
    GRIP_NF_CONDITION = 2,
    GRIP_NF_NUM_OF = 3,
};
enum EGripBTNodeType
{
    GRIP_NT_ROOT = 0,
    GRIP_NT_CONDITION = 1,
    GRIP_NT_OR_CONDITION = 2,
    GRIP_NT_AND_CONDITION = 3,
    GRIP_NT_PRIORITY = 4,
    GRIP_NT_SEQUENCE = 5,
    GRIP_NT_NI_SEQUENCE = 6,
    GRIP_NT_SEQUENCE_OR = 7,
    GRIP_NT_LOOP = 8,
    GRIP_NT_TIMER = 9,
    GRIP_NT_RANDOM = 10,
    GRIP_NT_DYN_PRIORITY = 11,
    GRIP_NT_PRIORITY_WEIGHT = 12,
    GRIP_NT_BEHAVIOR = 13,
    GRIP_NT_CUTOFF = 14,
    GRIP_NT_COOLDOWN = 15,
    GRIP_NT_PF_OVERRIDE = 16,
    GRIP_NT_NUMOF = 17,
};
enum EInternal
{
    EC_Internal = 0,
};
enum ELevelTick
{
    LEVELTICK_TimeOnly = 0,
    LEVELTICK_ViewportsOnly = 1,
    LEVELTICK_All = 2,
};
enum ELightMapInteractionType
{
    LMIT_None = 0,
    LMIT_Vertex = 1,
    LMIT_Texture = 2,
};
enum ELinkerNameTableConstructor
{
    ENAME_LinkerConstructor = 0,
};
enum EMaterialShaderQuality
{
    MSQ_HIGH = 0,
    MSQ_LOW = 1,
    MSQ_MAX = 2,
    MSQ_TERRAIN = 0,
    MSQ_UNSPECIFIED = 2,
};
enum EName
{
    NAME_None = 0,
    NAME_ByteProperty = 1,
    NAME_IntProperty = 2,
    NAME_BoolProperty = 3,
    NAME_FloatProperty = 4,
    NAME_ObjectProperty = 5,
    NAME_NameProperty = 6,
    NAME_DelegateProperty = 7,
    NAME_ClassProperty = 8,
    NAME_ArrayProperty = 9,
    NAME_StructProperty = 10,
    NAME_VectorProperty = 11,
    NAME_RotatorProperty = 12,
    NAME_StrProperty = 13,
    NAME_MapProperty = 14,
    NAME_InterfaceProperty = 15,
    NAME_Core = 20,
    NAME_Engine = 21,
    NAME_Editor = 22,
    NAME_Gameplay = 23,
    NAME_Byte = 80,
    NAME_Int = 81,
    NAME_Bool = 82,
    NAME_Float = 83,
    NAME_Name = 84,
    NAME_String = 85,
    NAME_Struct = 86,
    NAME_Vector = 87,
    NAME_Rotator = 88,
    NAME_SHVector = 89,
    NAME_Color = 90,
    NAME_Plane = 91,
    NAME_Button = 92,
    NAME_Matrix = 94,
    NAME_LinearColor = 95,
    NAME_QWord = 96,
    NAME_Pointer = 97,
    NAME_Double = 98,
    NAME_Quat = 99,
    NAME_Vector4 = 1250,
    NAME_Begin = 100,
    NAME_State = 102,
    NAME_Function = 103,
    NAME_Self = 104,
    NAME_TRUE = 105,
    NAME_FALSE = 106,
    NAME_Transient = 107,
    NAME_Enum = 117,
    NAME_Replication = 119,
    NAME_Reliable = 120,
    NAME_Unreliable = 121,
    NAME_Always = 122,
    NAME_Server = 123,
    NAME_Client = 124,
    NAME_Field = 150,
    NAME_Object = 151,
    NAME_TextBuffer = 152,
    NAME_Linker = 153,
    NAME_LinkerLoad = 154,
    NAME_LinkerSave = 155,
    NAME_Subsystem = 156,
    NAME_Factory = 157,
    NAME_TextBufferFactory = 158,
    NAME_Exporter = 159,
    NAME_StackNode = 160,
    NAME_Property = 161,
    NAME_Camera = 162,
    NAME_PlayerInput = 163,
    NAME_Actor = 164,
    NAME_ObjectRedirector = 165,
    NAME_ObjectArchetype = 166,
    NAME_Vect = 600,
    NAME_Rot = 601,
    NAME_ArrayCount = 605,
    NAME_EnumCount = 606,
    NAME_Rng = 607,
    NAME_NameOf = 608,
    NAME_Else = 620,
    NAME_If = 621,
    NAME_Goto = 622,
    NAME_Stop = 623,
    NAME_Until = 625,
    NAME_While = 626,
    NAME_Do = 627,
    NAME_Break = 628,
    NAME_For = 629,
    NAME_ForEach = 630,
    NAME_Assert = 631,
    NAME_Switch = 632,
    NAME_Case = 633,
    NAME_Default = 634,
    NAME_Continue = 635,
    NAME_ElseIf = 636,
    NAME_FilterEditorOnly = 637,
    NAME_Private = 640,
    NAME_Const = 641,
    NAME_Out = 642,
    NAME_Export = 643,
    NAME_DuplicateTransient = 644,
    NAME_NoImport = 645,
    NAME_Skip = 646,
    NAME_Coerce = 647,
    NAME_Optional = 648,
    NAME_Input = 649,
    NAME_Config = 650,
    NAME_EditorOnly = 651,
    NAME_NotForConsole = 652,
    NAME_EditConst = 653,
    NAME_Localized = 654,
    NAME_GlobalConfig = 655,
    NAME_SafeReplace = 656,
    NAME_New = 657,
    NAME_Protected = 658,
    NAME_Public = 659,
    NAME_EditInline = 660,
    NAME_EditInlineUse = 661,
    NAME_Deprecated = 662,
    NAME_Atomic = 663,
    NAME_Immutable = 664,
    NAME_Automated = 665,
    NAME_RepNotify = 666,
    NAME_Interp = 667,
    NAME_NoClear = 668,
    NAME_NonTransactional = 669,
    NAME_EditFixedSize = 670,
    NAME_ImmutableWhenCooked = 940,
    NAME_RepRetry = 941,
    NAME_PrivateWrite = 942,
    NAME_ProtectedWrite = 943,
    NAME_EditHide = 944,
    NAME_EditTextBox = 945,
    NAME_Intrinsic = 671,
    NAME_Within = 672,
    NAME_Abstract = 673,
    NAME_Package = 674,
    NAME_Guid = 675,
    NAME_Parent = 676,
    NAME_Class = 677,
    NAME_Extends = 678,
    NAME_NoExport = 679,
    NAME_Placeable = 680,
    NAME_PerObjectConfig = 681,
    NAME_NativeReplication = 682,
    NAME_NotPlaceable = 683,
    NAME_EditInlineNew = 684,
    NAME_NotEditInlineNew = 685,
    NAME_HideCategories = 686,
    NAME_ShowCategories = 687,
    NAME_CollapseCategories = 688,
    NAME_DontCollapseCategories = 689,
    NAME_DependsOn = 698,
    NAME_HideDropDown = 699,
    NAME_Implements = 950,
    NAME_Interface = 951,
    NAME_Inherits = 952,
    NAME_PerObjectLocalized = 953,
    NAME_NonTransient = 954,
    NAME_Archetype = 955,
    NAME_StrictConfig = 956,
    NAME_UnusedStructKeyword1 = 957,
    NAME_UnusedStructKeyword2 = 958,
    NAME_SerializeText = 959,
    NAME_CrossLevel = 960,
    NAME_CrossLevelActive = 961,
    NAME_CrossLevelPassive = 962,
    NAME_ClassGroup = 963,
    NAME_Auto = 690,
    NAME_Ignores = 691,
    NAME_Instanced = 692,
    NAME_Component = 693,
    NAME_Components = 694,
    NAME_Global = 695,
    NAME_Super = 696,
    NAME_Outer = 697,
    NAME_Operator = 700,
    NAME_PreOperator = 701,
    NAME_PostOperator = 702,
    NAME_Final = 703,
    NAME_Iterator = 704,
    NAME_Latent = 705,
    NAME_Return = 706,
    NAME_Singular = 707,
    NAME_Simulated = 708,
    NAME_Exec = 709,
    NAME_Event = 710,
    NAME_Static = 711,
    NAME_Native = 712,
    NAME_Invariant = 713,
    NAME_Delegate = 714,
    NAME_Virtual = 715,
    NAME_NoExportHeader = 716,
    NAME_DLLImport = 717,
    NAME_NativeOnly = 718,
    NAME_UnusedFunctionKeyword3 = 719,
    NAME_Var = 720,
    NAME_Local = 721,
    NAME_Import = 722,
    NAME_From = 723,
    NAME_Spawn = 730,
    NAME_Array = 731,
    NAME_Map = 732,
    NAME_AutoExpandCategories = 733,
    NAME_AutoCollapseCategories = 734,
    NAME_DontAutoCollapseCategories = 735,
    NAME_DontSortCategories = 736,
    NAME_Tag = 740,
    NAME_Role = 742,
    NAME_RemoteRole = 743,
    NAME_System = 744,
    NAME_User = 745,
    NAME_PersistentLevel = 746,
    NAME_TheWorld = 747,
    NAME_Benchmark = 748,
    NAME_Windows = 750,
    NAME_XBox = 751,
    NAME_PlayStation = 752,
    NAME_Linux = 753,
    NAME_MacOSX = 754,
    NAME_PC = 755,
    NAME_DevDecals = 756,
    NAME_PerfWarning = 757,
    NAME_DevStreaming = 758,
    NAME_DevLive = 759,
    NAME_Log = 760,
    NAME_Critical = 761,
    NAME_Init = 762,
    NAME_Exit = 763,
    NAME_Cmd = 764,
    NAME_Play = 765,
    NAME_Console = 766,
    NAME_Warning = 767,
    NAME_ExecWarning = 768,
    NAME_ScriptWarning = 769,
    NAME_ScriptLog = 770,
    NAME_Dev = 771,
    NAME_DevNet = 772,
    NAME_DevPath = 773,
    NAME_DevNetTraffic = 774,
    NAME_DevAudio = 775,
    NAME_DevLoad = 776,
    NAME_DevSave = 777,
    NAME_DevGarbage = 778,
    NAME_DevKill = 779,
    NAME_DevReplace = 780,
    NAME_DevUI = 781,
    NAME_DevSound = 782,
    NAME_DevCompile = 783,
    NAME_DevBind = 784,
    NAME_Localization = 785,
    NAME_Compatibility = 786,
    NAME_NetComeGo = 787,
    NAME_Title = 788,
    NAME_Error = 789,
    NAME_Heading = 790,
    NAME_SubHeading = 791,
    NAME_FriendlyError = 792,
    NAME_Progress = 793,
    NAME_UserPrompt = 794,
    NAME_SourceControl = 795,
    NAME_DevPhysics = 796,
    NAME_DevTick = 797,
    NAME_DevStats = 798,
    NAME_DevComponents = 799,
    NAME_DevMemory = 809,
    NAME_XMA = 810,
    NAME_WAV = 811,
    NAME_AILog = 812,
    NAME_DevParticle = 813,
    NAME_PerfEvent = 814,
    NAME_LocalizationWarning = 815,
    NAME_DevUIStyles = 816,
    NAME_DevUIStates = 817,
    NAME_DevUIFocus = 818,
    NAME_ParticleWarn = 819,
    NAME_UTrace = 854,
    NAME_DevCollision = 855,
    NAME_DevSHA = 856,
    NAME_DevSpawn = 857,
    NAME_DevAnim = 858,
    NAME_Hack = 859,
    NAME_DevShaders = 1118,
    NAME_DevDataBase = 1119,
    NAME_DevDataStore = 1120,
    NAME_DevAudioVerbose = 1121,
    NAME_DevUIAnimation = 1125,
    NAME_DevHDDCaching = 1126,
    NAME_DevMovie = 1127,
    NAME_DevShadersDetailed = 1128,
    NAME_PlayerManagement = 1129,
    NAME_DevPatch = 1130,
    NAME_DevLightmassSolver = 1131,
    NAME_DevAssetDataBase = 1132,
    NAME_GameStats = 200,
    NAME_DevFaceFX = 201,
    NAME_DevCrossLevel = 202,
    NAME_DevConfig = 203,
    NAME_DevCamera = 204,
    NAME_DebugState = 205,
    NAME_DevAbsorbFuncs = 206,
    NAME_DevLevelTools = 207,
    NAME_DevGFxUI = 208,
    NAME_DevGFxUIWarning = 209,
    NAME_DevNavMesh = 210,
    NAME_DevNavMeshWarning = 211,
    NAME_DevMCP = 212,
    NAME_DevBeacon = 213,
    NAME_DevHTTP = 214,
    NAME_DevMovieCapture = 215,
    NAME_DevHttpRequest = 216,
    NAME_DevNetTrafficDetail = 217,
    NAME_White = 800,
    NAME_Black = 801,
    NAME_Red = 802,
    NAME_Green = 803,
    NAME_Blue = 804,
    NAME_Cyan = 805,
    NAME_Magenta = 806,
    NAME_Yellow = 807,
    NAME_DefaultColor = 808,
    NAME_KeyType = 820,
    NAME_KeyEvent = 821,
    NAME_Write = 822,
    NAME_Message = 823,
    NAME_InitialState = 824,
    NAME_Texture = 825,
    NAME_Sound = 826,
    NAME_FireTexture = 827,
    NAME_IceTexture = 828,
    NAME_WaterTexture = 829,
    NAME_WaveTexture = 830,
    NAME_WetTexture = 831,
    NAME_Main = 832,
    NAME_VideoChange = 834,
    NAME_SendText = 835,
    NAME_SendBinary = 836,
    NAME_ConnectFailure = 837,
    NAME_Length = 838,
    NAME_Insert = 839,
    NAME_Remove = 840,
    NAME_Add = 1200,
    NAME_AddItem = 1201,
    NAME_RemoveItem = 1202,
    NAME_InsertItem = 1203,
    NAME_Sort = 1204,
    NAME_Game = 841,
    NAME_SequenceObjects = 842,
    NAME_PausedState = 843,
    NAME_ContinuedState = 844,
    NAME_SelectionColor = 845,
    NAME_Find = 846,
    NAME_UI = 847,
    NAME_DevCooking = 848,
    NAME_DevOnline = 849,
    NAME_DataBinding = 850,
    NAME_OptionMusic = 851,
    NAME_OptionSFX = 852,
    NAME_OptionVoice = 853,
    NAME_Linear = 1122,
    NAME_Point = 1123,
    NAME_Aniso = 1124,
    NAME_Master = 860,
    NAME_Ambient = 861,
    NAME_UnGrouped = 862,
    NAME_VoiceChat = 863,
    NAME_Brush = 1208,
    NAME_Attributes = 865,
    NAME_Strings = 866,
    NAME_Images = 867,
    NAME_SceneData = 868,
    NAME_EndIf = 870,
    NAME_Include = 871,
    NAME_Define = 872,
    NAME_Undefine = 873,
    NAME_IsDefined = 874,
    NAME_NotDefined = 875,
    NAME_Debug = 876,
    NAME_Counter = 877,
    NAME_SetCounter = 878,
    NAME_GetCounter = 879,
    NAME_EngineVersion = 880,
    NAME_IfCondition = 881,
    NAME_FontCharacter = 900,
    NAME_SourceState = 901,
    NAME_InitChild2StartBone = 902,
    NAME_SourceStyle = 903,
    NAME_SoundCueLocalized = 904,
    NAME_SoundCue = 905,
    NAME_RawDistributionFloat = 906,
    NAME_RawDistributionVector = 907,
    NAME_UIDockingSet = 908,
    NAME_DockPadding = 909,
    NAME_ScaleType = 912,
    NAME_EvalType = 913,
    NAME_AutoSizePadding = 914,
    NAME_PlayerWalking = 915,
    NAME_PlayerClimbing = 916,
    NAME_PlayerDriving = 917,
    NAME_PlayerSwimming = 918,
    NAME_PlayerFlying = 919,
    NAME_Spectating = 920,
    NAME_PlayerWaiting = 921,
    NAME_WaitingForPawn = 922,
    NAME_RoundEnded = 923,
    NAME_Dead = 924,
    NAME_Gear_General = 1000,
    NAME_Gear_ActiveReload = 1001,
    NAME_Gear_MiniGames = 1002,
    NAME_Gear_ResurrectionSystem = 1003,
    NAME_Gear_VehicleSystem = 1004,
    NAME_Gear_CheckpointSystem = 1005,
    NAME_Cover = 1006,
    NAME_AICommand = 1007,
    NAME_Success = 1008,
    NAME_Failure = 1009,
    NAME_Aborted = 1010,
    NAME_PlayerTakingCover = 1011,
    NAME_Engaging = 1012,
    NAME_PlayerTurreting = 1013,
    NAME_Reviving = 1014,
    NAME_PlayerID = 1080,
    NAME_TeamID = 1081,
    NAME_HearSoundFinished = 1082,
    NAME_OnParticleSystemFinished = 1083,
    NAME_Time = 1100,
    NAME_PPVolume_BloomEffect = 1101,
    NAME_PPVolume_DOFEffect = 1102,
    NAME_PPVolume_MotionBlurEffect = 1103,
    NAME_PPVolume_SceneEffect = 1104,
    NAME_PPVolume_DOFAndBloomEffect = 1105,
    NAME_Desaturation = 1106,
    NAME_HighLights = 1107,
    NAME_MidTones = 1108,
    NAME_Shadows = 1109,
    NAME_PPVolume_UberPostProcessEffect = 1110,
    NAME_DeviceID = 1111,
    NAME_InterpCurveFloat = 1112,
    NAME_InterpCurveVector2D = 1113,
    NAME_InterpCurveVector = 1114,
    NAME_InterpCurveTwoVectors = 1115,
    NAME_InterpCurveQuat = 1116,
    NAME_UniqueNetId = 1117,
    NAME_PopUp = 1133,
    NAME_Team = 1134,
    NAME_DevDlc = 1135,
    NAME_Landscape_RedTexture = 1140,
    NAME_Landscape_GreenTexture = 1141,
    NAME_Landscape_BlueTexture = 1142,
    NAME_Landscape_RedMask = 1143,
    NAME_Landscape_GreenMask = 1144,
    NAME_Landscape_BlueMask = 1145,
    NAME_Base = 1150,
    NAME_Specular = 1151,
    NAME_Emissive = 1152,
    NAME_Environment = 1153,
    NAME_RimLighting = 1154,
    NAME_BumpOffset = 1155,
    NAME_Masking = 1156,
    NAME_TextureBlending = 1157,
    NAME_ColorBlending = 1158,
    NAME_TextureTransform = 1159,
    NAME_VertexAnimation = 1160,
    NAME_MobileSpecularPower = 1165,
    NAME_MobileEnvironmentAmount = 1166,
    NAME_MobileEnvironmentFresnelAmount = 1167,
    NAME_MobileEnvironmentFresnelExponent = 1168,
    NAME_MobileRimLightingStrength = 1169,
    NAME_MobileRimLightingExponent = 1170,
    NAME_MobileBumpOffsetReferencePlane = 1171,
    NAME_MobileBumpOffsetHeightRatio = 1172,
    NAME_MobileTransformCenterX = 1173,
    NAME_MobileTransformCenterY = 1174,
    NAME_MobilePannerSpeedX = 1175,
    NAME_MobilePannerSpeedY = 1176,
    NAME_MobileRotateSpeed = 1177,
    NAME_MobileFixedScaleX = 1178,
    NAME_MobileFixedScaleY = 1179,
    NAME_MobileSineScaleX = 1180,
    NAME_MobileSineScaleY = 1181,
    NAME_MobileSineScaleFrequencyMultipler = 1182,
    NAME_MobileFixedOffsetX = 1183,
    NAME_MobileFixedOffsetY = 1184,
    NAME_MobileTangentVertexFrequencyMultiplier = 1185,
    NAME_MobileVerticalFrequencyMultiplier = 1186,
    NAME_MobileMaxVertexMovementAmplitude = 1187,
    NAME_MobileSwayFrequencyMultiplier = 1188,
    NAME_MobileSwayMaxAngle = 1189,
    NAME_MobileSpecularColor = 1190,
    NAME_MobileEmissiveColor = 1191,
    NAME_MobileEnvironmentColor = 1192,
    NAME_MobileRimLightingColor = 1193,
    NAME_MobileDefaultUniformColor = 1194,
    NAME_MobileOpacityMultiplier = 1195,
    NAME_MobileBaseTexture = 1230,
    NAME_MobileNormalTexture = 1231,
    NAME_MobileEmissiveTexture = 1232,
    NAME_MobileMaskTexture = 1233,
    NAME_MobileDetailTexture = 1234,
    NAME_MobileDetailTexture2 = 1235,
    NAME_MobileDetailTexture3 = 1236,
    NAME_MobileEnvironmentTexture = 1237,
    NAME_Fortress_MCP = 1056,
    NAME_Destroyed = 300,
    NAME_GainedChild = 301,
    NAME_LostChild = 302,
    NAME_HitWall = 303,
    NAME_Falling = 304,
    NAME_Landed = 305,
    NAME_Touch = 306,
    NAME_UnTouch = 307,
    NAME_Bump = 308,
    NAME_BeginState = 309,
    NAME_EndState = 310,
    NAME_BaseChange = 311,
    NAME_Attach = 312,
    NAME_Detach = 313,
    NAME_EncroachingOn = 314,
    NAME_EncroachedBy = 315,
    NAME_MayFall = 316,
    NAME_Tick = 317,
    NAME_SeePlayer = 318,
    NAME_EnemyNotVisible = 319,
    NAME_HearNoise = 320,
    NAME_UpdateEyeHeight = 321,
    NAME_SeeMonster = 322,
    NAME_SpecialHandling = 323,
    NAME_BotDesireability = 324,
    NAME_NotifyBump = 325,
    NAME_NotifyLanded = 326,
    NAME_NotifyHitWall = 327,
    NAME_PreBeginPlay = 328,
    NAME_PostBeginPlay = 329,
    NAME_UnusedProbe = 330,
    NAME_All = 331,
    NAME_PoppedState = 398,
    NAME_PushedState = 399,
    NAME_MeshEmitterVertexColor = 400,
    NAME_TextureOffsetParameter = 401,
    NAME_TextureScaleParameter = 402,
    NAME_ImpactVel = 403,
    NAME_SlideVel = 404,
    NAME_TextureOffset1Parameter = 405,
    NAME_MeshEmitterDynamicParameter = 406,
    NAME_ExpressionInput = 407,
    NAME_OnAudioFinished = 1205,
    NAME_ForceScriptOrder = 1206,
    NAME_Mobile = 1207,
    NAME_Untitled = 1209,
    NAME_Timer = 1210,
    NAME_PS3 = 1211,
};
enum ENativeConstructor
{
    EC_NativeConstructor = 0,
};
enum ENoInit
{
    E_NoInit = 0,
};
enum ERBCollisionChannel
{
    RBCC_Default = 0,
    RBCC_Nothing = 1,
    RBCC_Pawn = 2,
    RBCC_Vehicle = 3,
    RBCC_Water = 4,
    RBCC_GameplayPhysics = 5,
    RBCC_EffectPhysics = 6,
    RBCC_Untitled1 = 7,
    RBCC_Untitled2 = 8,
    RBCC_Untitled3 = 9,
    RBCC_Untitled4 = 10,
    RBCC_Cloth = 11,
    RBCC_FluidDrain = 12,
    RBCC_SoftBody = 13,
    RBCC_FracturedMeshPart = 14,
    RBCC_BlockingVolume = 15,
    RBCC_DeadPawn = 16,
    RBCC_Clothing = 17,
    RBCC_ClothingCollision = 18,
};
enum ESceneDepthPriorityGroup
{
    SDPG_UnrealEdBackground = 0,
    SDPG_World = 1,
    SDPG_Foreground = 2,
    SDPG_UnrealEdForeground = 3,
    SDPG_PostProcess = 4,
    SDPG_MAX = 5,
};
enum ESliderType
{
    ST_1D = 0,
    ST_2D = 1,
    ST_MAX = 2,
};
enum EStaticConstructor
{
    EC_StaticConstructor = 0,
};
enum ETestMoveResult
{
    TESTMOVE_Stopped = 0,
    TESTMOVE_Moved = 1,
    TESTMOVE_Fell = 2,
    TESTMOVE_HitGoal = 5,
};
enum EThreatType
{
};

namespace Grip { namespace Heap {
class MemVisitor;
class SegVisitor;
}}

namespace CCS {
enum EAlertnessState
{
    AlertnessState_Relax = 0,
    AlertnessState_Alert = 1,
    AlertnessState_MAX = 2,
};
enum EMovementSpeed
{
    MovementSpeed_Walk = 0,
    MovementSpeed_Run = 1,
    MovementSpeed_MAX = 2,
};
enum EMovementType
{
    MovementType_Idle = 0,
    MovementType_Walk = 1,
    MovementType_Run = 2,
    MovementType_Strafe = 3,
    MovementType_Encircle = 4,
    MovementType_MAX = 5,
};
}

namespace UE3 {
enum EPlatformType
{
    PLATFORM_Unknown = 0,
    PLATFORM_Windows = 1,
    PLATFORM_WindowsServer = 2,
    PLATFORM_Xbox360 = 4,
    PLATFORM_PS3 = 8,
    PLATFORM_Linux = 16,
    PLATFORM_MacOSX = 32,
    PLATFORM_WindowsConsole = 64,
    PLATFORM_IPhone = 128,
    PLATFORM_NGP = 256,
    PLATFORM_Android = 512,
    PLATFORM_WiiU = 1024,
    PLATFORM_Flash = 2048,
    PLATFORM_PC = 115,
    PLATFORM_AnyWindows = 67,
    PLATFORM_Console = 3980,
    PLATFORM_Mobile = 2944,
    PLATFORM_FilterEditorOnly = 3982,
    PLATFORM_Stripped = 4046,
    PLATFORM_OpenGLES2 = 2688,
    PLATFORM_DLCSupported = 78,
};
}

class FName  // size 0x8, opaque
{
public:
    int GetIndex() const;
    int GetNumber() const;
    const FString GetNameString() const;
    void ToString(FString &) const;
    FString ToString() const;
    void AppendString(FString &) const;
    unsigned int HasAnyFlags(unsigned __int64) const;
    void SetFlags(unsigned __int64) const;
    void ClearFlags(unsigned __int64) const;
    unsigned int operator==(const wchar_t *) const;
    unsigned int operator==(const FName &) const;
    unsigned int operator!=(const FName &) const;
    unsigned int IsValid() const;
    int Compare(const FName &) const;
    FName(ELinkerNameTableConstructor, const char *);
    FName(ELinkerNameTableConstructor, const wchar_t *);
    FName(const wchar_t *, int, EFindName);
    FName(int);
    FName(const char *, EFindName);
    FName(const wchar_t *, EFindName, unsigned int);
    FName();
    FName(EName, int);
    FName(EName);
    static void StaticInit();
    static void DisplayHash(FOutputDevice &);
    static void Hardcode(FNameEntry *);
    static FString SafeString(EName, int);
    static unsigned int SafeSuppressed(EName);
    static int GetMaxNames();
    static int GetNameEntryMemorySize();
    static int GetNameTableMemorySize();
    static int GetNumAnsiNames();
    static int GetNumUnicodeNames();
    static FNameEntry *GetEntry(int);
    static unsigned int GetInitialized();
    static void SplitOldName(const wchar_t *, FString &, int &);
    static unsigned int SplitNameWithCheck(const wchar_t *, wchar_t *, int, int &);
private:
    static unsigned int &GetIsInitialized();
    void Init(const char *, int, EFindName);
    void Init(const wchar_t *, int, EFindName, unsigned int);
public:
    static TArray<FNameEntry *,FDefaultAllocator> &GetPureNamesTable();
private:
    static TArrayNoInit<FNameEntry *> Names;
    static FNameEntry *NameHash[4096];
    static int NameEntryMemorySize;
    static int NumAnsiNames;
    static int NumUnicodeNames;
    unsigned int FNameData[0x2];
};

class FRenderCommandFence  // size 0x4, opaque
{
public:
    FRenderCommandFence();
    void BeginFence();
    void Wait(unsigned int) const;
    unsigned int GetNumPendingFences() const;
private:
    unsigned int FRenderCommandFenceData[0x1];
};

class FRotator  // size 0xC, opaque
{
public:
    void SerializeCompressed(FArchive &);
    FRotator(const FQuat &);
    FRotator(EEventParm);
    FRotator(int, int, int);
    FRotator();
    FRotator operator+(const FRotator &) const;
    FRotator operator-(const FRotator &) const;
    FRotator operator*(float) const;
    FRotator operator*=(float);
    unsigned int operator==(const FRotator &) const;
    unsigned int operator!=(const FRotator &) const;
    FRotator operator+=(const FRotator &);
    FRotator operator-=(const FRotator &);
    FRotator Reduce() const;
    int IsZero() const;
    FRotator Add(int, int, int);
    FRotator AddBounded(int, int, int);
    FRotator GridSnap(const FRotator &) const;
    FVector Vector() const;
    FQuat Quaternion() const;
    FVector Euler() const;
    static FRotator MakeFromEuler(const FVector &);
    FRotator Clamp() const;
    static int NormalizeAxis(int);
    FRotator GetNormalized() const;
    FRotator GetDenormalized() const;
    void MakeShortestRoute();
    void GetWindingAndRemainder(FRotator &, FRotator &) const;
    FString ToString() const;
    unsigned int InitFromString(const FString &);
    static FRotator ZeroRotator;
private:
    unsigned int FRotatorData[0x3];
};

class FVector  // size 0xC
{
public:
    FVector(EEventParm);
    FVector(FIntPoint);
    FVector(const FLinearColor &);
    FVector(const FVector4 &);
    FVector(const FVector2D, float);
    FVector(float, float, float);
    FVector(float);
    FVector();
    FVector operator^(const FVector &) const;
    float operator|(const FVector &) const;
    FVector operator+(float) const;
    FVector operator+(const FVector &) const;
    FVector operator-() const;
    FVector operator-(float) const;
    FVector operator-(const FVector &) const;
    FVector operator*(const FVector &) const;
    FVector operator*(float) const;
    FVector operator/(const FVector &) const;
    FVector operator/(float) const;
    unsigned int operator==(const FVector &) const;
    unsigned int operator!=(const FVector &) const;
    unsigned int Equals(const FVector &, float) const;
    unsigned int AllComponentsEqual(float) const;
    FVector operator+=(const FVector &);
    FVector operator-=(const FVector &);
    FVector operator*=(const FVector &);
    FVector operator*=(float);
    FVector operator/=(const FVector &);
    FVector operator/=(float);
    float operator[](int) const;
    float &operator[](int);
    void Set(float, float, float);
    float GetMax() const;
    float GetAbsMax() const;
    float GetMin() const;
    float Size() const;
    float SizeSquared() const;
    float Size2D() const;
    float SizeSquared2D() const;
    float Distance(const FVector &) const;
    float DistanceSquared(const FVector &) const;
    int IsNearlyZero(float) const;
    unsigned int IsZero() const;
    unsigned int Normalize(float);
    unsigned int IsNormalized() const;
    void ToDirectionAndLength(FVector &, float &);
    FVector Projection() const;
    FVector UnsafeNormal() const;
    FVector GridSnap(const float &) const;
    FVector BoundToCube(float) const;
    void AddBounded(const FVector &, float);
    float &Component(int);
    unsigned int IsUniform(float) const;
    FVector MirrorByVector(const FVector &) const;
    FVector MirrorByPlane(const FPlane &) const;
    FVector RotateAngleAxis(const int, const FVector &) const;
    FVector SafeNormal(float) const;
    FVector SafeNormal2D(float) const;
    float Dot2d(FVector);
    FVector ProjectOnTo(const FVector &) const;
    FRotator Rotation() const;
    void FindBestAxisVectors(FVector &, FVector &) const;
    void UnwindEuler();
    unsigned int ContainsNaN() const;
    unsigned int IsUnit(float) const;
    FString ToString() const;
    unsigned int InitFromString(const FString &);
    void SerializeCompressed(FArchive &);
    float X;  // 0x0
    float Y;  // 0x4
    float Z;  // 0x8
    static FVector ZeroVector;
};

template <> class TArray<AActor *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<AActor *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    AActor *const *GetTypedData() const;
    AActor **GetTypedData();
    AActor *const *GetData() const;
    AActor **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    AActor *const &operator()(int) const;
    AActor *&operator()(int);
    AActor *Pop();
    void Push(AActor *const &);
    AActor *const &Top() const;
    AActor *&Top();
    AActor *const &Last(int) const;
    AActor *&Last(int);
    void Shrink();
    unsigned int FindItem(AActor *const &, int &) const;
    int FindItemIndex(AActor *const &) const;
    unsigned int ContainsItem(AActor *const &) const;
    unsigned int operator==(const TArray<AActor *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<AActor *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(AActor *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<AActor *,FDefaultAllocator> &);
    TArray<AActor *,FDefaultAllocator> &operator+=(const TArray<AActor *,FDefaultAllocator> &);
    TArray<AActor *,FDefaultAllocator> &operator=(const TArray<AActor *,FDefaultAllocator> &);
    int AddItem(AActor *const &);
    int AddZeroed(int);
    int AddUniqueItem(AActor *const &);
    void Reserve(int);
    void Init(AActor *const &, int);
    void Init(int);
    int RemoveSingleItem(AActor *const &);
    int RemoveItem(AActor *const &);
    int RemoveSingleItemSwap(AActor *const &);
    int RemoveItemSwap(AActor *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    AActor *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<AActor *> : public TArray<AActor *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<AActor *> &operator=(const TArray<AActor *,FDefaultAllocator> &);
    TArrayNoInit<AActor *> &operator=(const TArrayNoInit<AActor *> &);
};

template <> class TArray<FTimerData,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<FTimerData,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    const FTimerData *GetTypedData() const;
    FTimerData *GetTypedData();
    const FTimerData *GetData() const;
    FTimerData *GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    const FTimerData &operator()(int) const;
    FTimerData &operator()(int);
    FTimerData Pop();
    void Push(const FTimerData &);
    const FTimerData &Top() const;
    FTimerData &Top();
    const FTimerData &Last(int) const;
    FTimerData &Last(int);
    void Shrink();
    unsigned int FindItem(const FTimerData &, int &) const;
    int FindItemIndex(const FTimerData &) const;
    unsigned int ContainsItem(const FTimerData &) const;
    unsigned int operator==(const TArray<FTimerData,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<FTimerData,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(const FTimerData &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<FTimerData,FDefaultAllocator> &);
    TArray<FTimerData,FDefaultAllocator> &operator+=(const TArray<FTimerData,FDefaultAllocator> &);
    TArray<FTimerData,FDefaultAllocator> &operator=(const TArray<FTimerData,FDefaultAllocator> &);
    int AddItem(const FTimerData &);
    int AddZeroed(int);
    int AddUniqueItem(const FTimerData &);
    void Reserve(int);
    void Init(const FTimerData &, int);
    void Init(int);
    int RemoveSingleItem(const FTimerData &);
    int RemoveItem(const FTimerData &);
    int RemoveSingleItemSwap(const FTimerData &);
    int RemoveItemSwap(const FTimerData &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    const FTimerData &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<FTimerData> : public TArray<FTimerData,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<FTimerData> &operator=(const TArray<FTimerData,FDefaultAllocator> &);
    TArrayNoInit<FTimerData> &operator=(const TArrayNoInit<FTimerData> &);
};

template <> class TArray<UActorComponent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<UActorComponent *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    UActorComponent *const *GetTypedData() const;
    UActorComponent **GetTypedData();
    UActorComponent *const *GetData() const;
    UActorComponent **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    UActorComponent *const &operator()(int) const;
    UActorComponent *&operator()(int);
    UActorComponent *Pop();
    void Push(UActorComponent *const &);
    UActorComponent *const &Top() const;
    UActorComponent *&Top();
    UActorComponent *const &Last(int) const;
    UActorComponent *&Last(int);
    void Shrink();
    unsigned int FindItem(UActorComponent *const &, int &) const;
    int FindItemIndex(UActorComponent *const &) const;
    unsigned int ContainsItem(UActorComponent *const &) const;
    unsigned int operator==(const TArray<UActorComponent *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<UActorComponent *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(UActorComponent *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<UActorComponent *,FDefaultAllocator> &);
    TArray<UActorComponent *,FDefaultAllocator> &operator+=(const TArray<UActorComponent *,FDefaultAllocator> &);
    TArray<UActorComponent *,FDefaultAllocator> &operator=(const TArray<UActorComponent *,FDefaultAllocator> &);
    int AddItem(UActorComponent *const &);
    int AddZeroed(int);
    int AddUniqueItem(UActorComponent *const &);
    void Reserve(int);
    void Init(UActorComponent *const &, int);
    void Init(int);
    int RemoveSingleItem(UActorComponent *const &);
    int RemoveItem(UActorComponent *const &);
    int RemoveSingleItemSwap(UActorComponent *const &);
    int RemoveItemSwap(UActorComponent *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    UActorComponent *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<UActorComponent *> : public TArray<UActorComponent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<UActorComponent *> &operator=(const TArray<UActorComponent *,FDefaultAllocator> &);
    TArrayNoInit<UActorComponent *> &operator=(const TArrayNoInit<UActorComponent *> &);
};

template <> class TArray<UClass *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<UClass *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    UClass *const *GetTypedData() const;
    UClass **GetTypedData();
    UClass *const *GetData() const;
    UClass **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    UClass *const &operator()(int) const;
    UClass *&operator()(int);
    UClass *Pop();
    void Push(UClass *const &);
    UClass *const &Top() const;
    UClass *&Top();
    UClass *const &Last(int) const;
    UClass *&Last(int);
    void Shrink();
    unsigned int FindItem(UClass *const &, int &) const;
    int FindItemIndex(UClass *const &) const;
    unsigned int ContainsItem(UClass *const &) const;
    unsigned int operator==(const TArray<UClass *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<UClass *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(UClass *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<UClass *,FDefaultAllocator> &);
    TArray<UClass *,FDefaultAllocator> &operator+=(const TArray<UClass *,FDefaultAllocator> &);
    TArray<UClass *,FDefaultAllocator> &operator=(const TArray<UClass *,FDefaultAllocator> &);
    int AddItem(UClass *const &);
    int AddZeroed(int);
    int AddUniqueItem(UClass *const &);
    void Reserve(int);
    void Init(UClass *const &, int);
    void Init(int);
    int RemoveSingleItem(UClass *const &);
    int RemoveItem(UClass *const &);
    int RemoveSingleItemSwap(UClass *const &);
    int RemoveItemSwap(UClass *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    UClass *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<UClass *> : public TArray<UClass *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<UClass *> &operator=(const TArray<UClass *,FDefaultAllocator> &);
    TArrayNoInit<UClass *> &operator=(const TArrayNoInit<UClass *> &);
};

template <> class TArray<USeqAct_Latent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    USeqAct_Latent *const *GetTypedData() const;
    USeqAct_Latent **GetTypedData();
    USeqAct_Latent *const *GetData() const;
    USeqAct_Latent **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    USeqAct_Latent *const &operator()(int) const;
    USeqAct_Latent *&operator()(int);
    USeqAct_Latent *Pop();
    void Push(USeqAct_Latent *const &);
    USeqAct_Latent *const &Top() const;
    USeqAct_Latent *&Top();
    USeqAct_Latent *const &Last(int) const;
    USeqAct_Latent *&Last(int);
    void Shrink();
    unsigned int FindItem(USeqAct_Latent *const &, int &) const;
    int FindItemIndex(USeqAct_Latent *const &) const;
    unsigned int ContainsItem(USeqAct_Latent *const &) const;
    unsigned int operator==(const TArray<USeqAct_Latent *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<USeqAct_Latent *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(USeqAct_Latent *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    TArray<USeqAct_Latent *,FDefaultAllocator> &operator+=(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    TArray<USeqAct_Latent *,FDefaultAllocator> &operator=(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    int AddItem(USeqAct_Latent *const &);
    int AddZeroed(int);
    int AddUniqueItem(USeqAct_Latent *const &);
    void Reserve(int);
    void Init(USeqAct_Latent *const &, int);
    void Init(int);
    int RemoveSingleItem(USeqAct_Latent *const &);
    int RemoveItem(USeqAct_Latent *const &);
    int RemoveSingleItemSwap(USeqAct_Latent *const &);
    int RemoveItemSwap(USeqAct_Latent *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    USeqAct_Latent *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<USeqAct_Latent *> : public TArray<USeqAct_Latent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<USeqAct_Latent *> &operator=(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    TArrayNoInit<USeqAct_Latent *> &operator=(const TArrayNoInit<USeqAct_Latent *> &);
};

template <> class TArray<USequenceEvent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<USequenceEvent *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    USequenceEvent *const *GetTypedData() const;
    USequenceEvent **GetTypedData();
    USequenceEvent *const *GetData() const;
    USequenceEvent **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    USequenceEvent *const &operator()(int) const;
    USequenceEvent *&operator()(int);
    USequenceEvent *Pop();
    void Push(USequenceEvent *const &);
    USequenceEvent *const &Top() const;
    USequenceEvent *&Top();
    USequenceEvent *const &Last(int) const;
    USequenceEvent *&Last(int);
    void Shrink();
    unsigned int FindItem(USequenceEvent *const &, int &) const;
    int FindItemIndex(USequenceEvent *const &) const;
    unsigned int ContainsItem(USequenceEvent *const &) const;
    unsigned int operator==(const TArray<USequenceEvent *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<USequenceEvent *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(USequenceEvent *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<USequenceEvent *,FDefaultAllocator> &);
    TArray<USequenceEvent *,FDefaultAllocator> &operator+=(const TArray<USequenceEvent *,FDefaultAllocator> &);
    TArray<USequenceEvent *,FDefaultAllocator> &operator=(const TArray<USequenceEvent *,FDefaultAllocator> &);
    int AddItem(USequenceEvent *const &);
    int AddZeroed(int);
    int AddUniqueItem(USequenceEvent *const &);
    void Reserve(int);
    void Init(USequenceEvent *const &, int);
    void Init(int);
    int RemoveSingleItem(USequenceEvent *const &);
    int RemoveItem(USequenceEvent *const &);
    int RemoveSingleItemSwap(USequenceEvent *const &);
    int RemoveItemSwap(USequenceEvent *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    USequenceEvent *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<USequenceEvent *> : public TArray<USequenceEvent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<USequenceEvent *> &operator=(const TArray<USequenceEvent *,FDefaultAllocator> &);
    TArrayNoInit<USequenceEvent *> &operator=(const TArrayNoInit<USequenceEvent *> &);
};

class UObject  // size 0x3C, opaque
{
public:
    enum
    {
        StaticClassCastFlags = 0,
    };
    virtual ~UObject();
    virtual unsigned int PreSaveRoot(const wchar_t *, TArray<FString,FDefaultAllocator> &);
    virtual void PostSaveRoot(unsigned int);
    virtual void PreSave();
    virtual void Modify(unsigned int);
    virtual unsigned int SaveToTransactionBuffer(unsigned int);
    virtual void PostLoad();
    virtual void BeginDestroy();
    virtual unsigned int IsReadyForFinishDestroy();
    virtual void FinishDestroy();
    virtual void Serialize(FArchive &);
    virtual unsigned int IsPendingKill() const;
    virtual void ShutdownAfterError();
    virtual void PreEditChange(UProperty *);
    virtual void PreEditChange(FEditPropertyChain &);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    virtual void PostEditChangeChainProperty(FPropertyChangedChainEvent &);
    virtual unsigned int CanEditChange(const UProperty *) const;
    virtual void PreEditUndo();
    virtual void PostEditUndo();
    virtual void PostRename();
    virtual void PostDuplicate();
    virtual void GetDynamicListValues(const FString &, TArray<FString,FDefaultAllocator> &);
    virtual unsigned int UsesManagedArchetypePropagation(UObject **) const;
    virtual void PreSerializeIntoPropagationArchive();
    virtual void PostSerializeIntoPropagationArchive();
    virtual void PreSerializeFromPropagationArchive();
    virtual void PostSerializeFromPropagationArchive();
    virtual void GetArchetypeInstances(TArray<UObject *,FDefaultAllocator> &);
    virtual void SaveInstancesIntoPropagationArchive(TArray<UObject *,FDefaultAllocator> &);
    virtual void LoadInstancesFromPropagationArchive(TArray<UObject *,FDefaultAllocator> &);
    virtual void PostCrossLevelFixup();
    virtual void Register();
    virtual void LanguageChange();
    virtual unsigned int NeedsLoadForClient() const;
    virtual unsigned int NeedsLoadForServer() const;
    virtual unsigned int NeedsLoadForEdit() const;
protected:
    virtual UObject *GetProfilerAssetObjectInternal() const;
    virtual FString GetDetailedInfoInternal() const;
public:
    virtual FObjectInstancingGraph *GetCustomPostLoadInstanceGraph();
    virtual void ExportCustomProperties(FOutputDevice &, unsigned int);
    virtual void ImportCustomProperties(const wchar_t *, FFeedbackContext *);
    virtual void PostEditImport();
    virtual unsigned int IsAComponent() const;
    virtual unsigned int IsAPrefabArchetype(UObject **) const;
    virtual unsigned int IsInPrefabInstance() const;
    virtual unsigned int Rename(const wchar_t *, UObject *, unsigned long);
    virtual UComponent *FindComponent(FName, unsigned int);
    virtual void PostReloadConfig(UProperty *);
    virtual void NetDirty(UProperty *);
    virtual void StripData(UE3::EPlatformType, unsigned int);
    virtual FString GetDesc();
    virtual FString GetDetailedDescription(int);
    virtual unsigned int GetNativePropertyValues(TMap<FString,FString,FDefaultSetAllocator> &, unsigned long) const;
    virtual unsigned int IsSelected() const;
    virtual void MarkPackageDirty(unsigned int) const;
    virtual UObject *CreateArchetype(const wchar_t *, UObject *, UObject *, FObjectInstancingGraph *);
    virtual void UpdateArchetype();
    virtual int GetResourceSize();
    virtual FName GetExporterName();
    virtual unsigned int IsLocalizedResource();
    virtual void InitializeProperties(UObject *, FObjectInstancingGraph *);
    virtual void SetArchetype(UObject *, unsigned int, FObjectInstancingGraph *);
    virtual void AddReferencedObjects(TArray<UObject *,FDefaultAllocator> &);
    virtual void ProcessEvent(UFunction *, void *, void *);
    virtual void ProcessDelegate(FName, const FScriptDelegate *, void *, void *);
    virtual void ProcessState(float);
    virtual unsigned int ProcessRemoteFunction(UFunction *, void *, FFrame *);
    virtual void InitExecution();
    virtual unsigned int GotoLabel(FName);
    virtual EGotoState GotoState(FName, unsigned int, unsigned int);
    virtual unsigned int ScriptConsoleExec(const wchar_t *, FOutputDevice &, UObject *);
    virtual unsigned int Get_bDebug();
private:
    UObject &operator=(const UObject &);
public:
    static UClass *GetPrivateStaticClassUObject(const wchar_t *);
    static void InitializePrivateStaticClassUObject();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
    static const wchar_t *StaticConfigName();
private:
    void AddObject(int);
    void HashObject();
    void UnhashObject();
    static ULinkerLoad *GetLoader(int);
    static unsigned int ResolveName(UObject *&, FString &, unsigned int, unsigned int, unsigned int);
    static void SafeLoadError(UObject *, unsigned long, const wchar_t *, const wchar_t *, ...);
    static void operator delete(void *, unsigned int);
    unsigned int IsNameHashed();
public:
    UObject(EStaticConstructor, const wchar_t *, const wchar_t *, unsigned __int64);
    UObject(ENativeConstructor, UClass *, const wchar_t *, const wchar_t *, unsigned __int64);
    UObject(const UObject &);
    UObject();
    void StaticConstructor();
    void InitializeIntrinsicPropertyValues();
    static void InternalConstructor(void *);
    const FName &GetPureName() const;
    void SetLinker(ULinkerLoad *, int);
    void SerializeNetIndex(FArchive &);
    void SerializeScriptProperties(FArchive &, UObject *, int) const;
    void SerializeStateLocals(FArchive &) const;
    void MarkPendingKill();
    void PostEditChange();
    void ConditionalCleanupCrossLevelReferences();
    int GetNetIndex();
    FName GetStateName();
private:
    static UObject *StaticFindObjectFastInternal(UClass *, UObject *, FName, unsigned int, unsigned int, unsigned __int64);
    void SetNetIndex(int);
public:
    static UObject *StaticFindObjectFastExplicit(UClass *, FName, const FString &, unsigned int, unsigned __int64);
    static UObject *StaticFindObjectFast(UClass *, UObject *, FName, unsigned int, unsigned int, unsigned __int64);
    static UObject *StaticFindObject(UClass *, UObject *, const wchar_t *, unsigned int);
    static UObject *StaticFindObjectChecked(UClass *, UObject *, const wchar_t *, unsigned int);
    static UObject *StaticLoadObject(UClass *, UObject *, const wchar_t *, const wchar_t *, unsigned long, UPackageMap *, unsigned int);
    static UClass *StaticLoadClass(UClass *, UObject *, const wchar_t *, const wchar_t *, unsigned long, UPackageMap *);
    static UObject *StaticAllocateObject(UClass *, UObject *, FName, unsigned __int64, UObject *, FOutputDevice *, UObject *, UObject *, FObjectInstancingGraph *);
    static UObject *StaticConstructObject(UClass *, UObject *, FName, unsigned __int64, UObject *, FOutputDevice *, UObject *, FObjectInstancingGraph *);
    static UObject *StaticDuplicateObject(UObject *, UObject *, UObject *, const wchar_t *, unsigned __int64, UClass *, unsigned int);
    static UObject *StaticDuplicateObjectEx(FObjectDuplicationParameters &);
    static void StaticInit();
    static void StaticExit();
    static unsigned int StaticExec(const wchar_t *, FOutputDevice &);
    static void StaticTick(float);
    void VerifyObjectHashChain();
    static void VerifyObjectHash();
    static UPackage *LoadPackage(UPackage *, const wchar_t *, unsigned long);
    static void LoadPackageAsync(const FString &, void (*)(UObject *, void *), void *, const FGuid *, FName);
    static float GetAsyncLoadPercentage(const FString &);
    static unsigned int SavePackage(UPackage *, UObject *, unsigned __int64, const wchar_t *, FOutputDevice *, ULinkerLoad *, unsigned int, unsigned int, unsigned long);
    static void SaveThumbnails(UPackage *, ULinkerSave *);
    static unsigned int IsStartupPackage(const FString &, wchar_t *);
    static void CollectGarbage(unsigned __int64, unsigned int);
    static void SerializeRootSet(FArchive &, unsigned __int64);
    static unsigned int IsIncrementalPurgePending();
    static void IncrementalPurgeGarbage(unsigned int, float);
    static FName MakeUniqueObjectName(UObject *, UClass *, FName);
    static unsigned int IsReferenced(UObject *&, unsigned __int64);
    static void FlushAsyncLoading(FName);
    static unsigned int IsAsyncLoading();
    static void ProcessAsyncLoading(unsigned int, float, FName);
    static void DissociateImportsAndForcedExports();
    static void BeginLoad();
    static void EndLoad(const wchar_t *);
    void SafeInitProperties(unsigned char *, int, UClass *, unsigned char *, int, UObject *, UObject *, FObjectInstancingGraph *);
    static void InitProperties(unsigned char *, int, UClass *, unsigned char *, int, UObject *, UObject *, FObjectInstancingGraph *);
    static void ExitProperties(unsigned char *, UClass *);
    static void ResetLoaders(UObject *);
    static void LoadLocalizedProp(UProperty *, const wchar_t *, const wchar_t *, const wchar_t *, UObject *, unsigned char *);
    static void LoadLocalizedStruct(UStruct *, const wchar_t *, const wchar_t *, const wchar_t *, UObject *, unsigned char *);
    static void LoadLocalizedDynamicArray(UArrayProperty *, const wchar_t *, const wchar_t *, const wchar_t *, UObject *, unsigned char *);
    static UPackage *FindPackage(UObject *, const wchar_t *);
    static UPackage *CreatePackage(UObject *, const wchar_t *, unsigned int);
    static ULinkerLoad *GetPackageLinker(UPackage *, const wchar_t *, unsigned long, UPackageMap *, FGuid *);
    static void StaticShutdownAfterError();
    static UObject *GetIndexedObject(int);
    static void GlobalSetProperty(const wchar_t *, UClass *, UProperty *, int, unsigned int);
    static void ExportProperties(const FExportObjectInnerContext *, FOutputDevice &, UClass *, unsigned char *, int, UClass *, unsigned char *, UObject *, unsigned long);
    static unsigned int GetInitialized();
    static UPackage *GetTransientPackage();
    static void ProcessRegistrants();
    static void BindPackage(UPackage *);
    static const wchar_t *GetLanguage();
    static void SetLanguage(const wchar_t *, unsigned int);
    static int GetObjectArrayNum();
    void AddToRoot();
    void RemoveFromRoot();
    static void ClearPackageToFileMapping();
    static TMap<FName,FName,FDefaultSetAllocator> *GetPackageNameToFileMapping();
    FString GetFullName(const UObject *) const;
private:
    void GetPathName(const UObject *, FString &) const;
public:
    FString GetPathName(const UObject *) const;
    FString GetDetailedInfo() const;
    UObject *GetProfilerAssetObject() const;
    FString GetFullGroupName(unsigned int) const;
    unsigned int IsValid();
    void ConditionalDestroy();
    void ConditionalRegister();
    unsigned int ConditionalBeginDestroy();
    unsigned int ConditionalFinishDestroy();
    void ConditionalPostLoad();
    void ConditionalPostLoadSubobjects(FObjectInstancingGraph *);
    void ConditionalShutdownAfterError();
    unsigned int IsA(const UClass *) const;
    unsigned int IsIn(const UObject *) const;
    unsigned int IsInA(const UClass *) const;
    unsigned int RootPackageHasAnyFlags(unsigned long) const;
    unsigned int RootPackageHasAllFlags(unsigned long) const;
    unsigned int IsInPIEPackage() const;
    unsigned int ResidesInPermanentPool() const;
    unsigned int IsDisregardedForGC() const;
    unsigned int IsBasedOnArchetype(const UObject *const) const;
    UField *FindObjectField(FName, unsigned int);
    UFunction *FindFunction(FName, unsigned int) const;
    UFunction *FindFunctionChecked(FName, unsigned int) const;
    UState *FindState(FName);
    void CollectComponents(TArray<UComponent *,FDefaultAllocator> &, unsigned int);
    void CollectComponents(TMap<FName,UComponent *,FDefaultSetAllocator> &, unsigned int);
    void DumpComponents();
    void SaveConfig(unsigned __int64, const wchar_t *);
    void LoadConfig(UClass *, const wchar_t *, unsigned long, UProperty *);
    void ReloadConfig(UClass *, const wchar_t *, unsigned long, UProperty *);
    void LoadLocalized(UObject *, unsigned int);
    void ReloadLocalized();
    unsigned int GetLocalizationDataLocation(UObject *, FString &, FString &, FString &);
    void InitClassDefaultObject(UClass *, unsigned int, unsigned int);
    void ParseParms(const wchar_t *);
    void OutputReferencers(FOutputDevice &, unsigned int, FReferencerInformationList *);
    void RetrieveReferencers(TArray<FReferencerInformation,FDefaultAllocator> *, TArray<FReferencerInformation,FDefaultAllocator> *, unsigned int);
    UObject *GetStableArchetype();
    unsigned int IsTemplate(unsigned __int64) const;
    const UClass *FindNearestCommonBaseClass(const UClass *) const;
    UClass *GetClass() const;
    void SetClass(UClass *);
    unsigned __int64 GetFlags() const;
    void SetFlags(unsigned __int64);
    void ClearFlags(unsigned __int64);
    unsigned int HasAnyFlags(unsigned __int64) const;
    unsigned int HasAllFlags(unsigned __int64) const;
    unsigned __int64 GetMaskedFlags(unsigned __int64) const;
    void GetName(FString &) const;
    FString GetName() const;
    void AppendName(FString &) const;
    const FName GetFName() const;
    UObject *GetOuter() const;
    UPackage *GetOutermost() const;
    int GetIndex() const;
    ULinkerLoad *GetLinker() const;
    int GetLinkerIndex() const;
    int GetLinkerVersion() const;
    int GetLinkerLicenseeVersion() const;
    FStateFrame *GetStateFrame() const;
    UObject *GetArchetype() const;
    void InstanceSubobjectTemplates(FObjectInstancingGraph *);
    void InstanceComponentTemplates(FObjectInstancingGraph *);
    void *GetInterfaceAddress(UClass *);
    static void AddReferencedObject(TArray<UObject *,FDefaultAllocator> &, UObject *);
    void AddReferencedObjectsViaSerialization(TArray<UObject *,FDefaultAllocator> &);
    unsigned int IsInState(FName, unsigned int);
    void CallFunction(FFrame &, void *const, UFunction *);
    void ProcessInternal(FFrame &, void *const);
    void SkipFunction(FFrame &, void *const, UFunction *);
    unsigned int IsProbing(FName);
    void PushState(FName, FName);
    void PopState(FFrame &, unsigned int);
    void execUndefined(FFrame &, void *const);
    void execLocalVariable(FFrame &, void *const);
    void execInstanceVariable(FFrame &, void *const);
    void execDefaultVariable(FFrame &, void *const);
    void execLocalOutVariable(FFrame &, void *const);
    void execStateVariable(FFrame &, void *const);
    void execInterfaceVariable(FFrame &, void *const);
    void execInterfaceContext(FFrame &, void *const);
    void execDefaultParmValue(FFrame &, void *const);
    void execArrayElement(FFrame &, void *const);
    void execDynArrayElement(FFrame &, void *const);
    void execDynArrayLength(FFrame &, void *const);
    void execDynArrayInsert(FFrame &, void *const);
    void execDynArrayRemove(FFrame &, void *const);
    void execDynArrayFind(FFrame &, void *const);
    void execDynArrayFindStruct(FFrame &, void *const);
    void execDynArrayAdd(FFrame &, void *const);
    void execDynArrayAddItem(FFrame &, void *const);
    void execDynArrayInsertItem(FFrame &, void *const);
    void execDynArrayRemoveItem(FFrame &, void *const);
    void execDynArrayIterator(FFrame &, void *const);
    void execDynArraySort(FFrame &, void *const);
    void execBoolVariable(FFrame &, void *const);
    void execClassDefaultVariable(FFrame &, void *const);
    void execEndFunctionParms(FFrame &, void *const);
    void execNothing(FFrame &, void *const);
    void execEndOfScript(FFrame &, void *const);
    void execReturnNothing(FFrame &, void *const);
    void execIteratorPop(FFrame &, void *const);
    void execEmptyParmValue(FFrame &, void *const);
    void execStop(FFrame &, void *const);
    void execEndCode(FFrame &, void *const);
    void execSwitch(FFrame &, void *const);
    void execCase(FFrame &, void *const);
    void execJump(FFrame &, void *const);
    void execJumpIfNot(FFrame &, void *const);
    void execAssert(FFrame &, void *const);
    void execGotoLabel(FFrame &, void *const);
    void execLet(FFrame &, void *const);
    void execLetBool(FFrame &, void *const);
    void execLetDelegate(FFrame &, void *const);
    void execEatReturnValue(FFrame &, void *const);
    void execSelf(FFrame &, void *const);
    void execContext(FFrame &, void *const);
    void execVirtualFunction(FFrame &, void *const);
    void execFinalFunction(FFrame &, void *const);
    void execGlobalFunction(FFrame &, void *const);
    void execDelegateFunction(FFrame &, void *const);
    void execDelegateProperty(FFrame &, void *const);
    void execStructCmpEq(FFrame &, void *const);
    void execStructCmpNe(FFrame &, void *const);
    void execStructMember(FFrame &, void *const);
    void execEqualEqual_DelegateDelegate(FFrame &, void *const);
    void execNotEqual_DelegateDelegate(FFrame &, void *const);
    void execEqualEqual_DelegateFunction(FFrame &, void *const);
    void execNotEqual_DelegateFunction(FFrame &, void *const);
    void execIntConst(FFrame &, void *const);
    void execFloatConst(FFrame &, void *const);
    void execStringConst(FFrame &, void *const);
    void execUnicodeStringConst(FFrame &, void *const);
    void execObjectConst(FFrame &, void *const);
    void execInstanceDelegate(FFrame &, void *const);
    void execNameConst(FFrame &, void *const);
    void execByteConst(FFrame &, void *const);
    void execIntZero(FFrame &, void *const);
    void execIntOne(FFrame &, void *const);
    void execTrue(FFrame &, void *const);
    void execFalse(FFrame &, void *const);
    void execNoObject(FFrame &, void *const);
    void execEmptyDelegate(FFrame &, void *const);
    void execIntConstByte(FFrame &, void *const);
    void execDynamicCast(FFrame &, void *const);
    void execMetaCast(FFrame &, void *const);
    void execPrimitiveCast(FFrame &, void *const);
    void execInterfaceCast(FFrame &, void *const);
    void execByteToInt(FFrame &, void *const);
    void execByteToBool(FFrame &, void *const);
    void execByteToFloat(FFrame &, void *const);
    void execByteToString(FFrame &, void *const);
    void execIntToByte(FFrame &, void *const);
    void execIntToBool(FFrame &, void *const);
    void execIntToFloat(FFrame &, void *const);
    void execIntToString(FFrame &, void *const);
    void execBoolToByte(FFrame &, void *const);
    void execBoolToInt(FFrame &, void *const);
    void execBoolToFloat(FFrame &, void *const);
    void execBoolToString(FFrame &, void *const);
    void execFloatToByte(FFrame &, void *const);
    void execFloatToInt(FFrame &, void *const);
    void execFloatToBool(FFrame &, void *const);
    void execFloatToString(FFrame &, void *const);
    void execRotationConst(FFrame &, void *const);
    void execVectorConst(FFrame &, void *const);
    void execPointDistToLine(FFrame &, void *const);
    void execPointDistToSegment(FFrame &, void *const);
    void execPointProjectToPlane(FFrame &, void *const);
    void execGetDotDistance(FFrame &, void *const);
    void execGetAngularDistance(FFrame &, void *const);
    void execGetAngularFromDotDist(FFrame &, void *const);
    void execStringToVector(FFrame &, void *const);
    void execStringToRotator(FFrame &, void *const);
    void execVectorToBool(FFrame &, void *const);
    void execVectorToString(FFrame &, void *const);
    void execVectorToRotator(FFrame &, void *const);
    void execRotatorToBool(FFrame &, void *const);
    void execRotatorToVector(FFrame &, void *const);
    void execRotatorToString(FFrame &, void *const);
    void execRotRand(FFrame &, void *const);
    void execGetRotatorAxis(FFrame &, void *const);
    void execGetUnAxes(FFrame &, void *const);
    void execGetAxes(FFrame &, void *const);
    void execSubtractEqual_RotatorRotator(FFrame &, void *const);
    void execAddEqual_RotatorRotator(FFrame &, void *const);
    void execSubtract_RotatorRotator(FFrame &, void *const);
    void execAdd_RotatorRotator(FFrame &, void *const);
    void execDivideEqual_RotatorFloat(FFrame &, void *const);
    void execMultiplyEqual_RotatorFloat(FFrame &, void *const);
    void execDivide_RotatorFloat(FFrame &, void *const);
    void execMultiply_FloatRotator(FFrame &, void *const);
    void execMultiply_RotatorFloat(FFrame &, void *const);
    void execNotEqual_RotatorRotator(FFrame &, void *const);
    void execEqualEqual_RotatorRotator(FFrame &, void *const);
    void execGetRand(FFrame &, void *const);
    void execRSize(FFrame &, void *const);
    void execRMin(FFrame &, void *const);
    void execRMax(FFrame &, void *const);
    void execMirrorVectorByNormal(FFrame &, void *const);
    void execVRand(FFrame &, void *const);
    void execVRandCone(FFrame &, void *const);
    void execVRandCone2(FFrame &, void *const);
    void execVLerp(FFrame &, void *const);
    void execVInterpTo(FFrame &, void *const);
    void execClampLength(FFrame &, void *const);
    void execNoZDot(FFrame &, void *const);
    void execNormal(FFrame &, void *const);
    void execNormal2D(FFrame &, void *const);
    void execVSize(FFrame &, void *const);
    void execVSize2D(FFrame &, void *const);
    void execVSizeSq(FFrame &, void *const);
    void execVSizeSq2D(FFrame &, void *const);
    void execSubtractEqual_VectorVector(FFrame &, void *const);
    void execAddEqual_VectorVector(FFrame &, void *const);
    void execDivideEqual_VectorFloat(FFrame &, void *const);
    void execMultiplyEqual_VectorVector(FFrame &, void *const);
    void execMultiplyEqual_VectorFloat(FFrame &, void *const);
    void execCross_VectorVector(FFrame &, void *const);
    void execDot_VectorVector(FFrame &, void *const);
    void execNotEqual_VectorVector(FFrame &, void *const);
    void execEqualEqual_VectorVector(FFrame &, void *const);
    void execGreaterGreater_VectorRotator(FFrame &, void *const);
    void execLessLess_VectorRotator(FFrame &, void *const);
    void execSubtract_VectorVector(FFrame &, void *const);
    void execAdd_VectorVector(FFrame &, void *const);
    void execDivide_VectorFloat(FFrame &, void *const);
    void execMultiply_VectorVector(FFrame &, void *const);
    void execMultiply_FloatVector(FFrame &, void *const);
    void execMultiply_VectorFloat(FFrame &, void *const);
    void execSubtract_PreVector(FFrame &, void *const);
    void execOrthoRotation(FFrame &, void *const);
    void execNormalize(FFrame &, void *const);
    void execRLerp(FFrame &, void *const);
    void execRTransform(FFrame &, void *const);
    void execRInterpTo(FFrame &, void *const);
    void execNormalizeRotAxis(FFrame &, void *const);
    void execRDiff(FFrame &, void *const);
    void execClockwiseFrom_IntInt(FFrame &, void *const);
    void execObjectToBool(FFrame &, void *const);
    void execObjectToInterface(FFrame &, void *const);
    void execObjectToString(FFrame &, void *const);
    void execInterfaceToString(FFrame &, void *const);
    void execInterfaceToBool(FFrame &, void *const);
    void execInterfaceToObject(FFrame &, void *const);
    void execDelegateToString(FFrame &, void *const);
    void execNameToBool(FFrame &, void *const);
    void execNameToString(FFrame &, void *const);
    void execStringToName(FFrame &, void *const);
    void execStringToByte(FFrame &, void *const);
    void execStringToInt(FFrame &, void *const);
    void execStringToBool(FFrame &, void *const);
    void execStringToFloat(FFrame &, void *const);
    void execNot_PreBool(FFrame &, void *const);
    void execEqualEqual_BoolBool(FFrame &, void *const);
    void execNotEqual_BoolBool(FFrame &, void *const);
    void execAndAnd_BoolBool(FFrame &, void *const);
    void execXorXor_BoolBool(FFrame &, void *const);
    void execOrOr_BoolBool(FFrame &, void *const);
    void execMultiplyEqual_ByteByte(FFrame &, void *const);
    void execMultiplyEqual_ByteFloat(FFrame &, void *const);
    void execDivideEqual_ByteByte(FFrame &, void *const);
    void execAddEqual_ByteByte(FFrame &, void *const);
    void execSubtractEqual_ByteByte(FFrame &, void *const);
    void execAddAdd_PreByte(FFrame &, void *const);
    void execSubtractSubtract_PreByte(FFrame &, void *const);
    void execAddAdd_Byte(FFrame &, void *const);
    void execSubtractSubtract_Byte(FFrame &, void *const);
    void execComplement_PreInt(FFrame &, void *const);
    void execSubtract_PreInt(FFrame &, void *const);
    void execMultiply_IntInt(FFrame &, void *const);
    void execDivide_IntInt(FFrame &, void *const);
    void execPercent_IntInt(FFrame &, void *const);
    void execAdd_IntInt(FFrame &, void *const);
    void execSubtract_IntInt(FFrame &, void *const);
    void execLessLess_IntInt(FFrame &, void *const);
    void execGreaterGreater_IntInt(FFrame &, void *const);
    void execGreaterGreaterGreater_IntInt(FFrame &, void *const);
    void execLess_IntInt(FFrame &, void *const);
    void execGreater_IntInt(FFrame &, void *const);
    void execLessEqual_IntInt(FFrame &, void *const);
    void execGreaterEqual_IntInt(FFrame &, void *const);
    void execEqualEqual_IntInt(FFrame &, void *const);
    void execNotEqual_IntInt(FFrame &, void *const);
    void execAnd_IntInt(FFrame &, void *const);
    void execXor_IntInt(FFrame &, void *const);
    void execOr_IntInt(FFrame &, void *const);
    void execMultiplyEqual_IntFloat(FFrame &, void *const);
    void execDivideEqual_IntFloat(FFrame &, void *const);
    void execAddEqual_IntInt(FFrame &, void *const);
    void execSubtractEqual_IntInt(FFrame &, void *const);
    void execAddAdd_PreInt(FFrame &, void *const);
    void execSubtractSubtract_PreInt(FFrame &, void *const);
    void execAddAdd_Int(FFrame &, void *const);
    void execSubtractSubtract_Int(FFrame &, void *const);
    void execRand(FFrame &, void *const);
    void execMin(FFrame &, void *const);
    void execMax(FFrame &, void *const);
    void execClamp(FFrame &, void *const);
    void execToHex(FFrame &, void *const);
    void execSubtract_PreFloat(FFrame &, void *const);
    void execMultiplyMultiply_FloatFloat(FFrame &, void *const);
    void execMultiply_FloatFloat(FFrame &, void *const);
    void execDivide_FloatFloat(FFrame &, void *const);
    void execPercent_FloatFloat(FFrame &, void *const);
    void execAdd_FloatFloat(FFrame &, void *const);
    void execSubtract_FloatFloat(FFrame &, void *const);
    void execLess_FloatFloat(FFrame &, void *const);
    void execGreater_FloatFloat(FFrame &, void *const);
    void execLessEqual_FloatFloat(FFrame &, void *const);
    void execGreaterEqual_FloatFloat(FFrame &, void *const);
    void execEqualEqual_FloatFloat(FFrame &, void *const);
    void execNotEqual_FloatFloat(FFrame &, void *const);
    void execComplementEqual_FloatFloat(FFrame &, void *const);
    void execMultiplyEqual_FloatFloat(FFrame &, void *const);
    void execDivideEqual_FloatFloat(FFrame &, void *const);
    void execAddEqual_FloatFloat(FFrame &, void *const);
    void execSubtractEqual_FloatFloat(FFrame &, void *const);
    void execAbs(FFrame &, void *const);
    void execDebugInfo(FFrame &, void *const);
    void execSin(FFrame &, void *const);
    void execAsin(FFrame &, void *const);
    void execCos(FFrame &, void *const);
    void execAcos(FFrame &, void *const);
    void execTan(FFrame &, void *const);
    void execAtan(FFrame &, void *const);
    void execAtan2(FFrame &, void *const);
    void execExp(FFrame &, void *const);
    void execLoge(FFrame &, void *const);
    void execSqrt(FFrame &, void *const);
    void execSquare(FFrame &, void *const);
    void execRound(FFrame &, void *const);
    void execFFloor(FFrame &, void *const);
    void execFCeil(FFrame &, void *const);
    void execFRand(FFrame &, void *const);
    void execFMin(FFrame &, void *const);
    void execFMax(FFrame &, void *const);
    void execFClamp(FFrame &, void *const);
    void execLerp(FFrame &, void *const);
    void execFCubicInterp(FFrame &, void *const);
    void execFInterpEaseInOut(FFrame &, void *const);
    void execFInterpTo(FFrame &, void *const);
    void execFInterpConstantTo(FFrame &, void *const);
    void execConcat_StrStr(FFrame &, void *const);
    void execAt_StrStr(FFrame &, void *const);
    void execLess_StrStr(FFrame &, void *const);
    void execGreater_StrStr(FFrame &, void *const);
    void execLessEqual_StrStr(FFrame &, void *const);
    void execGreaterEqual_StrStr(FFrame &, void *const);
    void execEqualEqual_StrStr(FFrame &, void *const);
    void execNotEqual_StrStr(FFrame &, void *const);
    void execComplementEqual_StrStr(FFrame &, void *const);
    void execConcatEqual_StrStr(FFrame &, void *const);
    void execAtEqual_StrStr(FFrame &, void *const);
    void execSubtractEqual_StrStr(FFrame &, void *const);
    void execLen(FFrame &, void *const);
    void execInStr(FFrame &, void *const);
    void execMid(FFrame &, void *const);
    void execLeft(FFrame &, void *const);
    void execRight(FFrame &, void *const);
    void execCaps(FFrame &, void *const);
    void execLocs(FFrame &, void *const);
    void execChr(FFrame &, void *const);
    void execAsc(FFrame &, void *const);
    void execRepl(FFrame &, void *const);
    void execParseStringIntoArray(FFrame &, void *const);
    void execMatrixGetOrigin(FFrame &, void *const);
    void execMatrixGetAxis(FFrame &, void *const);
    void execMatrixGetRotator(FFrame &, void *const);
    void execMakeRotationMatrix(FFrame &, void *const);
    void execMakeRotationTranslationMatrix(FFrame &, void *const);
    void execInverseTransformNormal(FFrame &, void *const);
    void execTransformNormal(FFrame &, void *const);
    void execInverseTransformVector(FFrame &, void *const);
    void execTransformVector(FFrame &, void *const);
    void execMultiply_MatrixMatrix(FFrame &, void *const);
    void execQuatProduct(FFrame &, void *const);
    void execQuatDot(FFrame &, void *const);
    void execQuatInvert(FFrame &, void *const);
    void execQuatRotateVector(FFrame &, void *const);
    void execQuatFindBetween(FFrame &, void *const);
    void execQuatFromAxisAndAngle(FFrame &, void *const);
    void execQuatFromRotator(FFrame &, void *const);
    void execQuatToRotator(FFrame &, void *const);
    void execQuatSlerp(FFrame &, void *const);
    void execAdd_QuatQuat(FFrame &, void *const);
    void execSubtract_QuatQuat(FFrame &, void *const);
    void execAdd_Vector2DVector2D(FFrame &, void *const);
    void execSubtract_Vector2DVector2D(FFrame &, void *const);
    void execMultiply_Vector2DFloat(FFrame &, void *const);
    void execDivide_Vector2DFloat(FFrame &, void *const);
    void execMultiplyEqual_Vector2DFloat(FFrame &, void *const);
    void execDivideEqual_Vector2DFloat(FFrame &, void *const);
    void execAddEqual_Vector2DVector2D(FFrame &, void *const);
    void execSubtractEqual_Vector2DVector2D(FFrame &, void *const);
    void execGetMappedRangeValue(FFrame &, void *const);
    void execEvalInterpCurveVector2D(FFrame &, void *const);
    void execEvalInterpCurveVector(FFrame &, void *const);
    void execEvalInterpCurveFloat(FFrame &, void *const);
    void execEqualEqual_ObjectObject(FFrame &, void *const);
    void execNotEqual_ObjectObject(FFrame &, void *const);
    void execEqualEqual_InterfaceInterface(FFrame &, void *const);
    void execNotEqual_InterfaceInterface(FFrame &, void *const);
    void execEqualEqual_NameName(FFrame &, void *const);
    void execNotEqual_NameName(FFrame &, void *const);
    void execLogInternal(FFrame &, void *const);
    void execWarnInternal(FFrame &, void *const);
    void execConditional(FFrame &, void *const);
    void execNew(FFrame &, void *const);
    void execClassIsChildOf(FFrame &, void *const);
    void execClassContext(FFrame &, void *const);
    void execGoto(FFrame &, void *const);
    void execGotoState(FFrame &, void *const);
    void execPushState(FFrame &, void *const);
    void execPopState(FFrame &, void *const);
    void execDumpStateStack(FFrame &, void *const);
    void execIsA(FFrame &, void *const);
    void execEnable(FFrame &, void *const);
    void execDisable(FFrame &, void *const);
    void execIterator(FFrame &, void *const);
    void execLocalize(FFrame &, void *const);
    void execNativeParm(FFrame &, void *const);
    void execSaveConfig(FFrame &, void *const);
    void execStaticSaveConfig(FFrame &, void *const);
    void execImportJSON(FFrame &, void *const);
    void execGetPerObjectConfigSections(FFrame &, void *const);
    void execGetEnum(FFrame &, void *const);
    void execDynamicLoadObject(FFrame &, void *const);
    void execFindObject(FFrame &, void *const);
    void execIsAsyncLoadingActive(FFrame &, void *const);
    void execIsInState(FFrame &, void *const);
    void execIsChildState(FFrame &, void *const);
    void execGetStateName(FFrame &, void *const);
    void execGetFuncName(FFrame &, void *const);
    void execDebugBreak(FFrame &, void *const);
    void execScriptTrace(FFrame &, void *const);
    void execGetScriptTrace(FFrame &, void *const);
    void execSetUTracing(FFrame &, void *const);
    void execIsUTracing(FFrame &, void *const);
    void execHighNative0(FFrame &, void *const);
    void execHighNative1(FFrame &, void *const);
    void execHighNative2(FFrame &, void *const);
    void execHighNative3(FFrame &, void *const);
    void execHighNative4(FFrame &, void *const);
    void execHighNative5(FFrame &, void *const);
    void execHighNative6(FFrame &, void *const);
    void execHighNative7(FFrame &, void *const);
    void execHighNative8(FFrame &, void *const);
    void execHighNative9(FFrame &, void *const);
    void execHighNative10(FFrame &, void *const);
    void execHighNative11(FFrame &, void *const);
    void execHighNative12(FFrame &, void *const);
    void execHighNative13(FFrame &, void *const);
    void execHighNative14(FFrame &, void *const);
    void execHighNative15(FFrame &, void *const);
    void execProjectOnTo(FFrame &, void *const);
    void execIsZero(FFrame &, void *const);
    void execPathName(FFrame &, void *const);
    void execTimeStamp(FFrame &, void *const);
    void execGetSystemTime(FFrame &, void *const);
    void execIsPendingKill(FFrame &, void *const);
    void execTransformVectorByRotation(FFrame &, void *const);
    void execGetEngineVersion(FFrame &, void *const);
    void execGetBuildChangelistNumber(FFrame &, void *const);
    void execJumpIfNotEditorOnly(FFrame &, void *const);
    void execGetLanguage(FFrame &, void *const);
    void execInvalidateGuid(FFrame &, void *const);
    void execIsGuidValid(FFrame &, void *const);
    void execCreateGuid(FFrame &, void *const);
    void execGetGuidFromString(FFrame &, void *const);
    void execGetStringFromGuid(FFrame &, void *const);
    void eventBeginState(FName);
    void eventEndState(FName);
    void eventPushedState();
    void eventPoppedState();
    void eventPausedState();
    void eventContinuedState();
private:
    static UClass *PrivateStaticClass;
    static unsigned int GObjInitialized;
    static unsigned int GObjNoRegister;
    static int GObjBeginLoadCount;
    static unsigned int GIsSavingPackage;
    static int GObjRegisterCount;
    static int GImportCount;
    static int GForcedExportCount;
    static UObject *GObjHash[32768];
    static UObject *GObjHashOuter[32768];
    static UObject *GAutoRegister;
    static TArray<UObject *,FDefaultAllocator> GObjLoaded;
    static TArray<UObject *,FDefaultAllocator> GObjConstructedDuringAsyncLoading;
    static TArray<UObject *,FDefaultAllocator> GObjObjects;
    static TArray<int,FDefaultAllocator> GObjAvailable;
    static TArray<ULinkerLoad *,FDefaultAllocator> GObjLoaders;
    static TMap<FName,FName,FDefaultSetAllocator> PackageNameToFileMapping;
    static UPackage *GObjTransientPkg;
    static wchar_t GObjCachedLanguage[32];
    static TArray<UObject *,FDefaultAllocator> GObjRegistrants;
    static TIndirectArray<FAsyncPackage,FDefaultAllocator> GObjAsyncPackages;
    static wchar_t GLanguage[64];
    static unsigned int GObjIncrementalPurgeIsInProgress;
    static unsigned int GObjFinishDestroyHasBeenRoutedToAllObjects;
    static unsigned int GObjPurgeIsRequired;
    static int GObjCurrentPurgeObjectIndex;
    static int GObjFirstGCIndex;
    static int GObjLastNonGCIndex;
    static int GPermanentObjectPoolSize;
    static unsigned char *GPermanentObjectPool;
    static unsigned char *GPermanentObjectPoolTail;
    static TArray<int,FDefaultAllocator> GGCObjectsPendingDestruction;
    static int GGCObjectsPendingDestructionCount;
protected:
    static unsigned int GExclusiveResourceSizeMode;
private:
    unsigned int UObjectData[0xE];
};

class AActor : public UObject  // size 0x1D4
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void ForceUpdateComponents(unsigned int, unsigned int);
    virtual FString ConsoleCommand(const FString &, unsigned int);
    virtual unsigned char MovingWhichWay(float &);
    virtual void SetShadowParentOnAllAttachedComponents(UPrimitiveComponent *, ULightEnvironmentComponent *);
    virtual float GetTerminalVelocity();
    virtual void FindBase();
    virtual void SearchForBaseBelow(float, AActor *&, FVector &);
    virtual AActor *GetBaseMost();
    virtual FBox GetComponentsBoundingBox(unsigned int) const;
    virtual void GetBoundingCylinder(float &, float &) const;
    virtual FVector GetDestination(AController *);
    virtual float GetGravityZ();
    virtual void PrestreamTextures(float, unsigned int, int);
    virtual unsigned int IsPlayerOwned();
    virtual unsigned char GetTeamNum();
    virtual void SetTeamNum(unsigned char);
    virtual FVector GetTargetLocation(AActor *, unsigned int) const;
    virtual void SetHUDLocation(FVector);
    virtual void NativePostRenderFor(APlayerController *, UCanvas *, FVector, FVector);
    virtual UParticleSystem *GetAnimTrailParticleSystem(const UAnimNotify_Trails *) const;
    virtual unsigned int SupportsKismetModification(USequenceOp *, FString &) const;
    virtual unsigned int ShouldBeHiddenBySHOW_NavigationNodes();
    virtual int GetActorMetrics(unsigned char);
    virtual USpriteComponent *GetActorSpriteComponent() const;
    virtual FVector GetPawnViewLocation();
    virtual FVector GetNavAdjustedLocation(FVector, float) const;
    virtual unsigned int IsInvisible();
    virtual int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    virtual APawn *GetPlayerPawn() const;
    virtual unsigned int IsPlayerPawn() const;
    virtual unsigned int IgnoreBlockingBy(const AActor *) const;
    virtual unsigned int CanCauseFractureOnTouch();
    virtual FVector CreateLocationOffset(unsigned int, unsigned int, int, float) const;
    virtual float GetNetPriority(const FVector &, const FVector &, APlayerController *, UActorChannel *, float, unsigned int);
    virtual unsigned int Tick(float, ELevelTick);
    virtual void PostEditMove(unsigned int);
    virtual void Spawned();
    virtual void PreNetReceive();
    virtual void PostNetReceive();
    virtual void PostNetReceiveLocation();
    virtual void PostNetReceiveBase(AActor *);
    virtual void PostScriptDestroyed();
    virtual unsigned int ShouldTrace(UPrimitiveComponent *, AActor *, unsigned long);
    virtual unsigned int IsOverlapping(AActor *, FCheckResult *, UPrimitiveComponent *, UPrimitiveComponent *);
    virtual unsigned int FindInterpMoveTrack(UInterpTrackMove **, UInterpTrackInstMove **, USeqAct_Interp **);
    virtual void SetHardAttach(unsigned int);
    virtual void NotifyBump(AActor *, UPrimitiveComponent *, const FVector &);
    virtual void NotifyBumpLevel(const FVector &, const FVector &);
    virtual void SetBase(AActor *, FVector, int, USkeletalMeshComponent *, FName);
    virtual void TickAuthoritative(float);
    virtual void TickSimulated(float);
    virtual void TickSpecial(float);
    virtual unsigned int PlayerControlled();
    virtual unsigned int IsNetRelevantFor(APlayerController *, AActor *, const FVector &);
    virtual unsigned int IsRelevancyOwnerFor(AActor *, AActor *, AActor *);
    virtual void SetZone(unsigned int, unsigned int);
    virtual void SetVolumes();
    virtual void SetVolumes(const TArray<AVolume *,FDefaultAllocator> &);
    virtual void PreBeginPlay();
    virtual void PostBeginPlay();
    virtual void setPhysics(unsigned char, AActor *, FVector);
    virtual void performPhysics(float);
    virtual void physProjectile(float, int);
    virtual void BoundProjectileVelocity();
    virtual void processHitWall(const FCheckResult &, float);
    virtual void processLanded(const FVector &, AActor *, float, int);
    virtual void physFalling(float, int);
    virtual void physWalking(float, int);
    virtual void physNavMeshWalking(float);
    virtual void physCustom(float, int);
    virtual void physicsRotation(float, FVector);
    virtual FRotator FindSlopeRotation(const FVector &, const FRotator &);
    virtual void GetNetBuoyancy(float &, float &);
    virtual void SmoothHitWall(const FVector &, AActor *);
    virtual void stepUp(const FVector &, const FVector &, const FVector &, FCheckResult &);
    virtual unsigned int ShrinkCollision(AActor *, UPrimitiveComponent *, const FVector &);
    virtual void GrowCollision();
    virtual unsigned int MoveWithInterpMoveTrack(UInterpTrackMove *, UInterpTrackInstMove *, float, float);
    virtual void AdjustInterpTrackMove(FVector &, FRotator &, float, unsigned int);
    virtual void physInterpolating(float);
    virtual void PushedBy(AActor *);
    virtual void UpdateBasedRotation(FRotator &, const FRotator &);
    virtual void ReverseBasedRotation();
    virtual void physRigidBody(float);
    virtual void physSoftBody(float);
    virtual void InitRBPhys();
    virtual void InitRBPhysEditor();
    virtual void TermRBPhys(FRBPhysScene *);
    virtual void BuildPhysStaticMeshCache(ULevel *, int &, int &, int &, int &);
    virtual void OnRigidBodyCollision(const FRigidBodyCollisionInfo &, const FRigidBodyCollisionInfo &, const FCollisionImpactData &);
    virtual void UpdatePushBody();
    virtual void ModifyNxActorDesc(NxActorDesc &, UPrimitiveComponent *, const NxGroupsMask &, unsigned int);
    virtual void PostInitRigidBody(NxActor *, NxActorDesc &, UPrimitiveComponent *);
    virtual void PreTermRigidBody(NxActor *);
    virtual void SyncActorToRBPhysics();
    virtual void GetAnimControlSlotDesc(TArray<FAnimSlotDesc,FDefaultAllocator> &);
    virtual void PreviewBeginAnimControl(UInterpGroup *);
    virtual void PreviewSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int, float);
    virtual void PreviewSetAnimWeights(TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual void PreviewFinishAnimControl(UInterpGroup *);
    virtual void PreviewUpdateFaceFX(unsigned int, const FString &, const FString &, float);
    virtual void PreviewActorPlayFaceFX(const FString &, const FString &, UAkBaseSoundObject *);
    virtual void PreviewActorStopFaceFX();
    virtual UAudioComponent *PreviewGetFaceFXAudioComponent();
    virtual UFaceFXAsset *PreviewGetActorFaceFXAsset();
    virtual void PreviewSetMorphWeight(FName, float);
    virtual void PreviewSetSkelControlScale(FName, float);
    virtual void SetSkelControlStrength(FName, float);
    virtual AActor *AssociatedLevelGeometry();
    virtual unsigned int HasAssociatedLevelGeometry(AActor *);
    virtual unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    virtual unsigned int TouchReachSucceeded(APawn *, const FVector &);
    virtual unsigned int BlockedByVehicle();
    virtual void PrePath();
    virtual void PostPath();
    virtual unsigned int IsABuilderBrush() const;
    virtual unsigned int IsCurrentBuilderBrush() const;
    virtual unsigned int IsABrush() const;
    virtual unsigned int IsAVolume() const;
    virtual unsigned int IsABrushShape() const;
    virtual unsigned int IsAFluidSurface() const;
    virtual APlayerController *GetAPlayerController();
    virtual AController *GetAController();
    virtual APawn *GetAPawn();
    virtual const APawn *GetAPawn() const;
    virtual AVehicle *GetAVehicle();
    virtual AVolume *GetAVolume();
    virtual AFluidSurfaceActor *GetAFluidSurface();
    virtual AProjectile *GetAProjectile();
    virtual const AProjectile *GetAProjectile() const;
    virtual APortalTeleporter *GetAPortalTeleporter();
    virtual APlayerController *GetTopPlayerController();
    virtual unsigned int VerifyNoUnreachableReferences();
    virtual void ClearComponents();
    virtual unsigned int WantsOverlapCheckWith(AActor *);
    virtual unsigned int ForceReturnComponent(UPrimitiveComponent *);
protected:
    virtual void UpdateComponentsInternal(unsigned int);
public:
    virtual void ConditionalForceUpdateComponents(unsigned int, unsigned int);
    virtual void MarkComponentsAsPendingKill(unsigned int);
    virtual unsigned int GetActorStaticLightingInfo(TArray<FStaticLightingPrimitiveInfo,FDefaultAllocator> &, const TArray<ULightComponent *,FDefaultAllocator> &, const FLightingBuildOptions &);
    virtual void OrderComponentsForDeterministicLighting();
    virtual void InvalidateLightingCache();
    virtual void FinalizeStaticLighting();
    virtual unsigned int ActorLineCheck(FCheckResult &, const FVector &, const FVector &, const FVector &, unsigned long);
    virtual void ClearCrossLevelReferences();
    virtual void GetActorReferences(TArray<FActorReference *,FDefaultAllocator> &, unsigned int);
    virtual FGuid *GetGuid();
    virtual ANavigationPoint *SpecifyEndAnchor(APawn *);
    virtual unsigned int AnchorNeedNotBeReachable();
    virtual void NotifyAnchorFindingResult(ANavigationPoint *, APawn *);
    virtual unsigned int ShouldHideActor(const FVector &);
    virtual void SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual unsigned int ResolveAttachedMoveEncroachment(AActor *, const FCheckResult &);
    virtual void OnEditorAnimEnd(UAnimNodeSequence *, float, float);
    virtual void OnRemoveFromWorld();
    virtual unsigned int NeedsCollisionOverrideDuringCoverBuild();
    void Sleep(float);
    void FinishAnim(UAnimNodeSequence *, unsigned int);
    void SetCollisionSize(float, float);
    void SetCollisionType(unsigned char);
    void SetDrawScale(float);
    void SetDrawScale3D(FVector);
    unsigned int Move(FVector);
    unsigned int SetLocation(FVector);
    unsigned int SetRotation(FRotator);
    unsigned int SetRelativeRotation(FRotator);
    unsigned int SetRelativeLocation(FVector);
    int fixedTurn(int, int, int);
    void AutonomousPhysics(float);
    void SetOwner(AActor *);
    FVector GetAggregateBaseVelocity(AActor *);
    void SetForcedInitialReplicatedProperty(UProperty *, unsigned int);
    void Vect2BP(FBasedPosition &, FVector, AActor *) const;
    FVector BP2Vect(FBasedPosition) const;
    void SetBasedPosition(FBasedPosition &, FVector, AActor *) const;
    FVector GetBasedPosition(FBasedPosition) const;
    void FlushPersistentDebugLines() const;
    void DrawDebugLine(FVector, FVector, unsigned char, unsigned char, unsigned char, unsigned int) const;
    void DrawDebugPoint(FVector, float, FLinearColor, unsigned int) const;
    void DrawDebugBox(FVector, FVector, unsigned char, unsigned char, unsigned char, unsigned int) const;
    void DrawDebugStar(FVector, float, unsigned char, unsigned char, unsigned char, unsigned int) const;
    void DrawDebugCoordinateSystem(FVector, FRotator, float, unsigned int) const;
    void DrawDebugSphere(FVector, float, int, unsigned char, unsigned char, unsigned char, unsigned int) const;
    void DrawDebugCylinder(FVector, FVector, float, int, unsigned char, unsigned char, unsigned char, unsigned int) const;
    void DrawDebugCone(FVector, FVector, float, float, float, int, FColor, unsigned int) const;
    void DrawDebugString(FVector, const FString &, AActor *, FColor, float) const;
    void DrawDebugFrustrum(const FMatrix &, unsigned char, unsigned char, unsigned char, unsigned int) const;
    void FlushDebugStrings() const;
    void ChartData(const FString &, float);
    void SetHidden(unsigned int);
    void SetOnlyOwnerSee(unsigned int);
    void Clock(float &);
    void UnClock(float &);
    void AttachComponent(UActorComponent *);
    void DetachComponent(UActorComponent *);
    void ReattachComponent(UActorComponent *);
    void SetTickGroup(unsigned char);
    void SetTickIsDisabled(unsigned int);
    unsigned int ClampRotation(FRotator &, FRotator, FRotator, FRotator);
    unsigned int FindSpot(FVector, FVector &);
    unsigned int ContainsPoint(FVector);
    void GetComponentsBoundingBox(FBox &) const;
    void SetTimer(float, unsigned int, FName, UObject *);
    void ClearTimer(FName, UObject *);
    void ClearAllTimers(UObject *);
    void PauseTimer(unsigned int, FName, UObject *);
    unsigned int IsTimerActive(FName, UObject *);
    float GetTimerCount(FName, UObject *);
    float GetTimerRate(FName, UObject *);
    void ModifyTimerTimeDilation(const FName, const float, UObject *);
    void ResetTimerTimeDilation(const FName, UObject *);
    UAudioComponent *CreateAudioComponent(USoundCue *, unsigned int, unsigned int, unsigned int, FVector, unsigned int);
    void PostAkEvent(UAkEvent *);
    void PostGlobalAkEvent(UAkEvent *);
    void PostAkEventOnBone(UAkEvent *, FName);
    void SetRTPCValue(FName, float);
    void SetAkState(FName, FName);
    void SetSwitch(FName, FName);
    void PostTrigger(FName);
    void ActivateOcclusion(unsigned int);
    void MakeNoise(float, FName);
    unsigned int PlayerCanSeeMe(unsigned int);
    unsigned int CalculateMinSpeedTrajectory(FVector &, FVector, FVector, float, float, FVector, float, float, unsigned int);
    FString GetURLMap();
    UActorComponent *GetComponentOfType(UClass *);
    APlayerController *GetALocalPlayerController();
    void SetNetUpdateTime(float);
    FGuid GetPackageGuid(FName);
    unsigned int IsInPersistentLevel(unsigned int) const;
    FVector GetAvoidanceVector(const TArray<AActor *,FDefaultAllocator> &, FVector, float, float, int, float, float);
    unsigned int WillOverlap(FVector, FVector, FVector, FVector, float, float, float &);
    void execForceUpdateComponents(FFrame &, void *const);
    void execConsoleCommand(FFrame &, void *const);
    void execSleep(FFrame &, void *const);
    void execFinishAnim(FFrame &, void *const);
    void execSetCollision(FFrame &, void *const);
    void execSetCollisionSize(FFrame &, void *const);
    void execSetCollisionType(FFrame &, void *const);
    void execSetDrawScale(FFrame &, void *const);
    void execSetDrawScale3D(FFrame &, void *const);
    void execMove(FFrame &, void *const);
    void execSetLocation(FFrame &, void *const);
    void execSetRotation(FFrame &, void *const);
    void execMovingWhichWay(FFrame &, void *const);
    void execSetZone(FFrame &, void *const);
    void execSetRelativeRotation(FFrame &, void *const);
    void execSetRelativeLocation(FFrame &, void *const);
    void execSetHardAttach(FFrame &, void *const);
    void execSetShadowParentOnAllAttachedComponents(FFrame &, void *const);
    void execfixedTurn(FFrame &, void *const);
    void execMoveSmooth(FFrame &, void *const);
    void execAutonomousPhysics(FFrame &, void *const);
    void execGetTerminalVelocity(FFrame &, void *const);
    void execSetBase(FFrame &, void *const);
    void execSetOwner(FFrame &, void *const);
    void execFindBase(FFrame &, void *const);
    void execSearchForBaseBelow(FFrame &, void *const);
    void execIsBasedOn(FFrame &, void *const);
    void execGetBaseMost(FFrame &, void *const);
    void execIsOwnedBy(FFrame &, void *const);
    void execGetAggregateBaseVelocity(FFrame &, void *const);
    void execSetForcedInitialReplicatedProperty(FFrame &, void *const);
    void execVect2BP(FFrame &, void *const);
    void execBP2Vect(FFrame &, void *const);
    void execSetBasedPosition(FFrame &, void *const);
    void execGetBasedPosition(FFrame &, void *const);
    void execFlushPersistentDebugLines(FFrame &, void *const);
    void execDrawDebugLine(FFrame &, void *const);
    void execDrawDebugPoint(FFrame &, void *const);
    void execDrawDebugBox(FFrame &, void *const);
    void execDrawDebugStar(FFrame &, void *const);
    void execDrawDebugCoordinateSystem(FFrame &, void *const);
    void execDrawDebugSphere(FFrame &, void *const);
    void execDrawDebugCylinder(FFrame &, void *const);
    void execDrawDebugCone(FFrame &, void *const);
    void execDrawDebugString(FFrame &, void *const);
    void execDrawDebugFrustrum(FFrame &, void *const);
    void execFlushDebugStrings(FFrame &, void *const);
    void execChartData(FFrame &, void *const);
    void execSetHidden(FFrame &, void *const);
    void execSetOnlyOwnerSee(FFrame &, void *const);
    void execSetPhysics(FFrame &, void *const);
    void execClock(FFrame &, void *const);
    void execUnClock(FFrame &, void *const);
    void execAttachComponent(FFrame &, void *const);
    void execDetachComponent(FFrame &, void *const);
    void execReattachComponent(FFrame &, void *const);
    void execSetTickGroup(FFrame &, void *const);
    void execSetTickIsDisabled(FFrame &, void *const);
    void execClampRotation(FFrame &, void *const);
    void execTrace(FFrame &, void *const);
    void execTraceComponent(FFrame &, void *const);
    void execPointCheckComponent(FFrame &, void *const);
    void execFastTrace(FFrame &, void *const);
    void execTraceAllPhysicsAssetInteractions(FFrame &, void *const);
    void execFindSpot(FFrame &, void *const);
    void execContainsPoint(FFrame &, void *const);
    void execIsOverlapping(FFrame &, void *const);
    void execGetComponentsBoundingBox(FFrame &, void *const);
    void execGetBoundingCylinder(FFrame &, void *const);
    void execIsBlockedBy(FFrame &, void *const);
    void execSpawn(FFrame &, void *const);
    void execDestroy(FFrame &, void *const);
    void execSetTimer(FFrame &, void *const);
    void execClearTimer(FFrame &, void *const);
    void execClearAllTimers(FFrame &, void *const);
    void execPauseTimer(FFrame &, void *const);
    void execIsTimerActive(FFrame &, void *const);
    void execGetTimerCount(FFrame &, void *const);
    void execGetTimerRate(FFrame &, void *const);
    void execModifyTimerTimeDilation(FFrame &, void *const);
    void execResetTimerTimeDilation(FFrame &, void *const);
    void execCreateAudioComponent(FFrame &, void *const);
    void execPlaySound(FFrame &, void *const);
    void execPlayAkEvent(FFrame &, void *const);
    void execPlaySoundBase(FFrame &, void *const);
    void execPostAkEvent(FFrame &, void *const);
    void execPostGlobalAkEvent(FFrame &, void *const);
    void execPostAkEventOnBone(FFrame &, void *const);
    void execSetRTPCValue(FFrame &, void *const);
    void execSetAkState(FFrame &, void *const);
    void execSetSwitch(FFrame &, void *const);
    void execPostTrigger(FFrame &, void *const);
    void execActivateOcclusion(FFrame &, void *const);
    void execMakeNoise(FFrame &, void *const);
    void execPlayerCanSeeMe(FFrame &, void *const);
    void execSuggestTossVelocity(FFrame &, void *const);
    void execCalculateMinSpeedTrajectory(FFrame &, void *const);
    void execGetDestination(FFrame &, void *const);
    void execGetURLMap(FFrame &, void *const);
    void execAllActors(FFrame &, void *const);
    void execDynamicActors(FFrame &, void *const);
    void execChildActors(FFrame &, void *const);
    void execBasedActors(FFrame &, void *const);
    void execTouchingActors(FFrame &, void *const);
    void execTraceActors(FFrame &, void *const);
    void execVisibleActors(FFrame &, void *const);
    void execVisibleCollidingActors(FFrame &, void *const);
    void execCollidingActors(FFrame &, void *const);
    void execOverlappingActors(FFrame &, void *const);
    void execComponentList(FFrame &, void *const);
    void execGetComponentOfType(FFrame &, void *const);
    void execAllOwnedComponents(FFrame &, void *const);
    void execLocalPlayerControllers(FFrame &, void *const);
    void execGetALocalPlayerController(FFrame &, void *const);
    void execGetGravityZ(FFrame &, void *const);
    void execSetNetUpdateTime(FFrame &, void *const);
    void execPrestreamTextures(FFrame &, void *const);
    void execIsPlayerOwned(FFrame &, void *const);
    void execGetTeamNum(FFrame &, void *const);
    void execSetTeamNum(FFrame &, void *const);
    void execGetTargetLocation(FFrame &, void *const);
    void execSetHUDLocation(FFrame &, void *const);
    void execNativePostRenderFor(FFrame &, void *const);
    void execGetPackageGuid(FFrame &, void *const);
    void execIsInPersistentLevel(FFrame &, void *const);
    void execGetAnimTrailParticleSystem(FFrame &, void *const);
    void execSupportsKismetModification(FFrame &, void *const);
    void execGetAvoidanceVector(FFrame &, void *const);
    void execWillOverlap(FFrame &, void *const);
    void execShouldBeHiddenBySHOW_NavigationNodes(FFrame &, void *const);
    void execGetActorMetrics(FFrame &, void *const);
    void execGetActorSpriteComponent(FFrame &, void *const);
    void execGetPawnViewLocation(FFrame &, void *const);
    void execGetNavAdjustedLocation(FFrame &, void *const);
    void execIsInvisible(FFrame &, void *const);
    FVector eventGetPawnViewLocation();
    unsigned int eventOnMobileTouch(APlayerController *, FVector2D);
    void eventReplicationEnded();
    void eventPostDemoRewind();
    void eventAnimTreeUpdated(USkeletalMeshComponent *);
    void eventTrailsNotifyEnd(const UAnimNotify_Trails *);
    void eventTrailsNotifyTick(const UAnimNotify_Trails *);
    void eventTrailsNotify(const UAnimNotify_Trails *);
    unsigned int eventCreateForceField(const UAnimNotify_ForceField *);
    unsigned int eventPlayParticleEffect(const UAnimNotify_PlayParticleEffect *);
    void eventOnRigidBodySpringOverextension(URB_BodyInstance *);
    void eventPostInitAnimTree(USkeletalMeshComponent *);
    void eventRootMotionExtracted(USkeletalMeshComponent *, FBoneAtom &);
    void eventRootMotionProcessed(USkeletalMeshComponent *);
    void eventRootMotionModeChanged(USkeletalMeshComponent *);
    void eventPostRenderFor(APlayerController *, UCanvas *, FVector, FVector);
    void eventOnRanOver(ASVehicle *, UPrimitiveComponent *, int);
    void eventRigidBodyCollision(UPrimitiveComponent *, UPrimitiveComponent *, const FCollisionImpactData &, int);
    void eventInterpolationChanged(USeqAct_Interp *);
    void eventInterpolationFinished(USeqAct_Interp *);
    void eventInterpolationStarted(USeqAct_Interp *, UInterpGroupInst *);
    void eventSpawnedByKismet();
    void eventScriptSetTeamNum(unsigned char);
    unsigned char eventScriptGetTeamNum();
    void eventGetActorEyesViewPoint(FVector &, FRotator &);
    UFaceFXAsset *eventGetActorFaceFXAsset();
    void eventTickSkelControl(float, USkeletalMeshComponent *, USkelControlBase *);
    void eventSetSkelControlScale(FName, float);
    void eventSetMorphWeight(FName, float);
    void eventStopActorFaceFXAnim();
    unsigned int eventPlayActorFaceFXAnim(UFaceFXAnimSet *, const FString &, const FString &, USoundCue *, UAkEvent *);
    void eventFinishAnimControl(UInterpGroup *);
    void eventSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int);
    void eventBeginAnimControl(UInterpGroup *);
    void eventOnAnimPlay(UAnimNodeSequence *);
    void eventOnAnimEnd(UAnimNodeSequence *, float, float);
    void eventShutDown();
    void eventForceNetRelevant();
    void eventReceivedNewEvent(USequenceEvent *);
    void eventDebugMessagePlayer(const FString &);
    void eventReset();
    UAudioComponent *eventGetFaceFXAudioComponent();
    void eventModifyHearSoundComponent(UAudioComponent *);
    void eventEndViewTarget(APlayerController *);
    void eventBecomeViewTarget(APlayerController *);
    void eventDebugFreezeGame(AActor *);
    unsigned int eventHealDamage(int, AController *, UClass *);
    void eventTakeDamage(int, AController *, FVector, FVector, UClass *, FTraceHitInfo, AActor *);
    void eventNotifySkelControlBeyondLimit(USkelControlLookAt *);
    void eventConstraintBrokenNotify(AActor *, URB_ConstraintSetup *, URB_ConstraintInstance *);
    void eventSetInitialState();
    void eventPostBeginPlay();
    void eventBroadcastLocalizedTeamMessage(int, UClass *, int, APlayerReplicationInfo *, APlayerReplicationInfo *, UObject *);
    void eventBroadcastLocalizedMessage(UClass *, int, APlayerReplicationInfo *, APlayerReplicationInfo *, UObject *);
    void eventPreBeginPlay();
    void eventTornOff();
    void eventOutsideWorldBounds();
    void eventFellOutOfWorld(UClass *);
    unsigned int eventOverRotated(FRotator &, FRotator &);
    void eventOnSleepRBPhysics();
    void eventOnWakeRBPhysics();
    void eventRanInto(AActor *);
    void eventEncroachedBy(AActor *);
    unsigned int eventEncroachingOn(AActor *);
    void eventCollisionChanged();
    AActor *eventSpecialHandling(APawn *);
    void eventDetach(AActor *);
    void eventAttach(AActor *);
    void eventBaseChange();
    void eventBump(AActor *, UPrimitiveComponent *, FVector);
    void eventUnTouch(AActor *);
    void eventPostTouch(AActor *);
    void eventTouch(AActor *, UPrimitiveComponent *, FVector, FVector);
    void eventPhysicsVolumeChange(APhysicsVolume *);
    void eventLanded(FVector, AActor *);
    void eventFalling();
    void eventHitWall(FVector, AActor *, UPrimitiveComponent *);
    void eventTimer();
    void eventTick(float);
    void eventLostChild(AActor *);
    void eventGainedChild(AActor *);
    void eventDestroyed();
    void eventReplicatedEvent(FName);
private:
    AActor &operator=(const AActor &);
public:
    static UClass *GetPrivateStaticClassAActor(const wchar_t *);
    static void InitializePrivateStaticClassAActor();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AActor();
public:
    static void InternalConstructor(void *);
    virtual void BeginDestroy();
    virtual unsigned int IsReadyForFinishDestroy();
    virtual void ProcessEvent(UFunction *, void *, void *);
    virtual void ProcessState(float);
    virtual unsigned int ProcessRemoteFunction(UFunction *, void *, FFrame *);
    void ProcessDemoRecFunction(UFunction *, void *, FFrame *);
    virtual void InitExecution();
    virtual void PreEditChange(UProperty *);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    virtual void PreSave();
    virtual void PostLoad();
    virtual void NetDirty(UProperty *);
    unsigned int IsOwnedBy(const AActor *) const;
    unsigned int IsBlockedBy(const AActor *, const UPrimitiveComponent *) const;
    unsigned int IsBasedOn(const AActor *) const;
    APrefabInstance *FindOwningPrefabInstance() const;
    AActor *GetBase() const;
    void EditorUpdateBase();
    void EditorUpdateAttachedActors(const TArray<AActor *,FDefaultAllocator> &);
    unsigned int IsHiddenEd() const;
    virtual unsigned int IsSelected() const;
    virtual void PostRename();
    void SetDefaultCollisionType();
    void SetCollisionFromCollisionType();
    FMatrix LocalToWorld() const;
    FMatrix WorldToLocal() const;
    FVector GetCylinderExtent() const;
    AActor *GetTopOwner();
    virtual unsigned int IsPendingKill() const;
    unsigned int ActorIsPendingKill() const;
    void CheckStillInWorld();
    void UnTouchActors();
    void FindTouchingActors();
    void BeginTouch(AActor *, UPrimitiveComponent *, const FVector &, const FVector &, UPrimitiveComponent *);
    void EndTouch(AActor *, unsigned int);
    unsigned int IsBrush() const;
    unsigned int IsStaticBrush() const;
    unsigned int IsVolumeBrush() const;
    unsigned int IsBrushShape() const;
    unsigned int IsEncroacher() const;
    unsigned int WantsTick() const;
    unsigned int IsStatic() const;
    unsigned int HasStaticShadowing() const;
    void SetCollision(unsigned int, unsigned int, unsigned int);
    void UpdateTimers(float);
    unsigned int IsRelevantThroughPortals(APlayerController *);
    void PlaySound(USoundCue *, unsigned int, unsigned int, unsigned int, FVector *, unsigned int, float);
    void PlayAkEvent(UAkEvent *, unsigned int, unsigned int, unsigned int, FVector *, unsigned int, float);
    void PlaySoundBase(UAkBaseSoundObject *, unsigned int, unsigned int, unsigned int, FVector *, unsigned int, float);
    void TwoWallAdjust(const FVector &, FVector &, const FVector &, const FVector &, float);
    unsigned int moveSmooth(const FVector &);
    void UpdateRelativeRotation();
    void AddRBGravAndDamping();
    void ApplyNewRBState(const FRigidBodyState &, float *, FVector &);
    unsigned int GetCurrentRBState(FRigidBodyState &);
    void SyncActorToClothPhysics();
    int TestCanSeeMe(APlayerController *);
    unsigned int SuggestTossVelocity(FVector *, const FVector &, const FVector &, float, float, float, const FVector &, float, float, unsigned int);
    AActor *GetHitActor();
    void ConditionalUpdateComponents(unsigned int);
    void MarkComponentsAsDirty(unsigned int);
    void execPollSleep(FFrame &, void *const);
    void execPollFinishAnim(FFrame &, void *const);
    void GetInterpFloatPropertyNames(TArray<FName,FDefaultAllocator> &);
    void GetInterpVectorPropertyNames(TArray<FName,FDefaultAllocator> &);
    void GetInterpColorPropertyNames(TArray<FName,FDefaultAllocator> &);
    void GetInterpLinearColorPropertyNames(TArray<FName,FDefaultAllocator> &);
    float *GetInterpFloatPropertyRef(FName, void *&);
    FVector *GetInterpVectorPropertyRef(FName);
    FColor *GetInterpColorPropertyRef(FName);
    FLinearColor *GetInterpLinearColorPropertyRef(FName);
    void GetInterpBoolPropertyNames(TArray<FName,FDefaultAllocator> &);
    unsigned long *GetInterpBoolPropertyRef(FName, unsigned long &);
    unsigned int IsInLevel(const ULevel *) const;
    ULevel *GetLevel() const;
    unsigned int IsReferencedByKismet(USequenceObject **) const;
    unsigned int HasSingleCollidingComponent();
    virtual unsigned int Get_bDebug();
    typedef UObject Super;
    AActor *Next_Actor;  // 0x3C
    AActor *Next_Reactive;  // 0x40
    AActor *Next_Vehicle;  // 0x44
    AActor *Next_Target_Actor;  // 0x48
    TArrayNoInit<UActorComponent *> Components;  // 0x4C
    TArrayNoInit<UActorComponent *> AllComponents;  // 0x58
    FVector Location;  // 0x64
    FRotator Rotation;  // 0x70
    float DrawScale;  // 0x7C
    FVector DrawScale3D;  // 0x80
    FVector PrePivot;  // 0x8C
    FRenderCommandFence DetachFence;  // 0x98
    float CustomTimeDilation;  // 0x9C
    unsigned char Physics;  // 0xA0
    unsigned char RemoteRole;  // 0xA1
    unsigned char Role;  // 0xA2
    unsigned char CollisionType;  // 0xA3
    unsigned char ReplicatedCollisionType;  // 0xA4
    unsigned char TickGroup;  // 0xA5
    char _pad0[0x2];
    AActor *Owner;  // 0xA8
    AActor *Base;  // 0xAC
    TArrayNoInit<FTimerData> Timers;  // 0xB0
    unsigned long bStatic : 1;  // 0xBC
    unsigned long bHidden : 1;
    unsigned long bNoDelete : 1;
    unsigned long bDeleteMe : 1;
    unsigned long bTicked : 1;
    unsigned long bOnlyOwnerSee : 1;
    unsigned long bTickIsDisabled : 1;
    unsigned long bWorldGeometry : 1;
    unsigned long bIgnoreRigidBodyPawns : 1;
    unsigned long bOrientOnSlope : 1;
    unsigned long bIgnoreEncroachers : 1;
    unsigned long bPushedByEncroachers : 1;
    unsigned long bDestroyedByInterpActor : 1;
    unsigned long bRouteBeginPlayEvenIfStatic : 1;
    unsigned long bIsMoving : 1;
    unsigned long bAlwaysEncroachCheck : 1;
    unsigned long bHasAlternateTargetLocation : 1;
    unsigned long bCanStepUpOn : 1;
    unsigned long bNetTemporary : 1;
    unsigned long bOnlyRelevantToOwner : 1;
    unsigned long bNetDirty : 1;
    unsigned long bAlwaysRelevant : 1;
    unsigned long bReplicateInstigator : 1;
    unsigned long bReplicateMovement : 1;
    unsigned long bSkipActorPropertyReplication : 1;
    unsigned long bUpdateSimulatedPosition : 1;
    unsigned long bTearOff : 1;
    unsigned long bOnlyDirtyReplication : 1;
    unsigned long bAllowFluidSurfaceInteraction : 1;
    unsigned long bDemoRecording : 1;
    unsigned long bDemoOwner : 1;
    unsigned long bForceDemoRelevant : 1;
    unsigned long bNetInitialRotation : 1;  // 0xC0
    unsigned long bReplicateRigidBodyLocation : 1;
    unsigned long bKillDuringLevelTransition : 1;
    unsigned long bExchangedRoles : 1;
    unsigned long bConsiderAllStaticMeshComponentsForStreaming : 1;
    unsigned long bDebug : 1;
    unsigned long bPostRenderIfNotVisible : 1;
    unsigned long bForceNetUpdate : 1;
    unsigned long bPendingNetUpdate : 1;
    unsigned long bHardAttach : 1;
    unsigned long bIgnoreBaseRotation : 1;
    unsigned long bShadowParented : 1;
    unsigned long bSkipAttachedMoves : 1;
    unsigned long bCanBeAdheredTo : 1;
    unsigned long bCanBeFrictionedTo : 1;
    unsigned long bHurtEntry : 1;
    unsigned long bGameRelevant : 1;
    unsigned long bMovable : 1;
    unsigned long bDestroyInPainVolume : 1;
    unsigned long bCanBeDamaged : 1;
    unsigned long bShouldBaseAtStartup : 1;
    unsigned long bPendingDelete : 1;
    unsigned long bCanTeleport : 1;
    unsigned long bAlwaysTick : 1;
    unsigned long bBlocksNavigation : 1;
    unsigned long BlockRigidBody : 1;
    unsigned long bCollideWhenPlacing : 1;
    unsigned long bCollideActors : 1;
    unsigned long bCollideWorld : 1;
    unsigned long bCollideComplex : 1;
    unsigned long bBlockActors : 1;
    unsigned long bProjTarget : 1;
    unsigned long bBlocksTeleport : 1;  // 0xC4
    unsigned long bMoveIgnoresDestruction : 1;
    unsigned long bProjectileMoveSingleBlocking : 1;
    unsigned long bNoEncroachCheck : 1;
    unsigned long bCollideAsEncroacher : 1;
    unsigned long bPhysRigidBodyOutOfWorldCheck : 1;
    unsigned long bComponentOutsideWorld : 1;
    unsigned long bForceOctreeSNFilter : 1;
    unsigned long bForceOctreeMNFilter : 1;
    unsigned long bRigidBodyWasAwake : 1;
    unsigned long bCallRigidBodyWakeEvents : 1;
    unsigned long bBounce : 1;
    unsigned long bJustTeleported : 1;
    unsigned long bEnableMobileTouch : 1;
    unsigned long bNetInitial : 1;
    unsigned long bNetOwner : 1;
    unsigned long bHiddenEd : 1;
    unsigned long bEditable : 1;
    unsigned long bHiddenEdGroup_DEPRECATED : 1;
    unsigned long bHiddenEdLayer : 1;
    unsigned long bHiddenEdCustom : 1;
    unsigned long bHiddenEdTemporary : 1;
    unsigned long bHiddenEdLevel : 1;
    unsigned long bHiddenEdScene : 1;
    unsigned long bEdShouldSnap : 1;
    unsigned long bTempEditor : 1;
    unsigned long bPathColliding : 1;
    unsigned long bPathTemp : 1;
    unsigned long bScriptInitialized : 1;
    unsigned long bLockLocation : 1;
    unsigned long bForceAllowKismetModification : 1;
    unsigned long bDebugEffectIsRelevant : 1;
    int NetTag;  // 0xC8
    float NetUpdateTime;  // 0xCC
    float NetUpdateFrequency;  // 0xD0
    float NetPriority;  // 0xD4
    float LastNetUpdateTime;  // 0xD8
    float TimeSinceLastTick;  // 0xDC
    APawn *Instigator;  // 0xE0
    AWorldInfo *WorldInfo;  // 0xE4
    float LifeSpan;  // 0xE8
    float CreationTime;  // 0xEC
    float LastRenderTime;  // 0xF0
    FName Tag;  // 0xF4
    FName InitialState;  // 0xFC
    FName Layer;  // 0x104
    FName Group_DEPRECATED;  // 0x10C
    unsigned __int64 HiddenEditorViews;  // 0x114
    TArrayNoInit<AActor *> Touching;  // 0x11C
    TArrayNoInit<AActor *> Children;  // 0x128
    float LatentFloat;  // 0x134
    UAnimNodeSequence *LatentSeqNode;  // 0x138
    APhysicsVolume *PhysicsVolume;  // 0x13C
    FVector Velocity;  // 0x140
    FVector Acceleration;  // 0x14C
    FVector AngularVelocity;  // 0x158
    USkeletalMeshComponent *BaseSkelComponent;  // 0x164
    FName BaseBoneName;  // 0x168
    TArrayNoInit<AActor *> Attached;  // 0x170
    FVector RelativeLocation;  // 0x17C
    FRotator RelativeRotation;  // 0x188
    UPrimitiveComponent *CollisionComponent;  // 0x194
    int OverlapTag;  // 0x198
    FRotator RotationRate;  // 0x19C
    AActor *PendingTouch;  // 0x1A8
    UClass *MessageClass;  // 0x1AC
    TArrayNoInit<UClass *> SupportedEvents;  // 0x1B0
    TArrayNoInit<USequenceEvent *> GeneratedEvents;  // 0x1BC
    TArrayNoInit<USeqAct_Latent *> LatentActions;  // 0x1C8
private:
    static UClass *PrivateStaticClass;
public:
    static FVector OverlapAdjust;
};

class IInterface_NavigationHandle  // size 0x4, opaque
{
protected:
    virtual ~IInterface_NavigationHandle();
public:
    virtual UObject *GetUObjectInterfaceInterface_NavigationHandle() = 0;
    virtual void eventNotifyPathChanged() = 0;
    virtual unsigned int CanCoverSlip(ACoverLink *, int);
    virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase *) = 0;
    virtual unsigned int CheckMantleValidity(FNavMeshMantleEdge *);
    virtual void SetupPathfindingParams(FNavMeshPathParams &) = 0;
    virtual void InitForPathfinding() = 0;
    virtual int ExtraEdgeCostToAddWhenActive(FNavMeshEdgeBase *);
    virtual void DebugLogInternal(const wchar_t *);
};

class AController : public AActor, public IInterface_NavigationHandle  // size 0x358, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual unsigned int IsLocalPlayerController();
    virtual unsigned int IsLocalController();
    virtual void RouteCache_Empty();
    virtual void RouteCache_AddItem(ANavigationPoint *);
    virtual void RouteCache_InsertItem(ANavigationPoint *, int);
    virtual void RouteCache_RemoveItem(ANavigationPoint *);
    virtual void RouteCache_RemoveIndex(int, int);
    virtual void SetAdjustLocation(FVector, unsigned int, unsigned int);
    virtual void EndClimbLadder();
    virtual unsigned int IsPlayerOwner();
    virtual unsigned int CanHear(const FVector &, float, AActor *);
    virtual void ShowSelf();
    virtual unsigned int ShouldCheckVisibilityOf(AController *);
    virtual unsigned long SeePawn(APawn *, unsigned int);
    virtual unsigned long LineOfSightTo(const AActor *, int, const FVector *, unsigned int);
    virtual void HearNoise(AActor *, float, FName);
    virtual int AcceptNearbyPath(AActor *);
    virtual UReachSpec *PrepareForMove(ANavigationPoint *, UReachSpec *);
    virtual void AdjustFromWall(FVector, AActor *);
    virtual void MarkEndPoints(ANavigationPoint *, AActor *, const FVector &);
    virtual unsigned int OverridePathTo(ANavigationPoint *, AActor *, const FVector &, unsigned int, float &);
    virtual unsigned int WantsLedgeCheck();
    virtual unsigned int StopAtLedge();
    virtual void PrePollMove();
    virtual void PostPollMove();
    virtual void PollMoveComplete();
    virtual AActor *GetViewTarget();
    virtual void UpdateEnemyInfo(APawn *);
    virtual void JumpOverWall(FVector);
    virtual void UpdatePawnRotation();
    virtual unsigned int ForceReached(ANavigationPoint *, const FVector &);
    virtual FRotator SetRotationRate(float);
    virtual FVector DesiredDirection();
    virtual void FailMove();
    virtual void PreAirSteering(float);
    virtual void PostAirSteering(float);
    virtual void PostPhysFalling(float);
    virtual void PostPhysWalking(float);
    virtual void PostPhysSpider(float);
    virtual unsigned int AirControlFromWall(float, FVector &);
    virtual void NotifyJumpApex();
    virtual void ClearCrossLevelPaths(ULevel *);
    virtual void execPollMoveTo(FFrame &, void *const);
    virtual void execPollMoveToward(FFrame &, void *const);
    virtual unsigned int ShouldOffsetCorners();
    virtual unsigned int ShouldUsePathLanes();
    virtual unsigned int ShouldIgnoreNavigationBlockingFor(const AActor *);
    virtual void MoveTo(const FVector &, AActor *, float, unsigned int);
    virtual void MoveToward(AActor *, AActor *, float, unsigned int, unsigned int);
    virtual float GetMaxDropHeight();
    void SetFocalPoint(FVector, unsigned int);
    FVector GetFocalPoint();
    void SetDestinationPosition(FVector, unsigned int);
    FVector GetDestinationPosition();
    FVector GetAdjustLocation();
    unsigned int BeyondFogDistance(FVector, FVector);
    virtual unsigned char GetTeamNum();
    unsigned int CanSee(APawn *);
    unsigned int CanSeeByPoints(FVector, FVector, FRotator);
    APawn *PickTarget(UClass *, float &, float &, FVector, FVector, float);
    void FinishRotation();
    AActor *FindPathTo(FVector, int, unsigned int);
    AActor *FindPathToward(AActor *, unsigned int, int, unsigned int);
    AActor *FindPathTowardNearest(UClass *, unsigned int, int, unsigned int);
    ANavigationPoint *FindRandomDest();
    AActor *FindPathToIntercept(APawn *, AActor *, unsigned int, int, unsigned int);
    unsigned int PointReachable(FVector);
    unsigned int ActorReachable(AActor *);
    unsigned int PickWallAdjust(FVector);
    unsigned int InLatentExecution(int);
    void StopLatentExecution();
    void execIsLocalPlayerController(FFrame &, void *const);
    void execIsLocalController(FFrame &, void *const);
    void execRouteCache_Empty(FFrame &, void *const);
    void execRouteCache_AddItem(FFrame &, void *const);
    void execRouteCache_InsertItem(FFrame &, void *const);
    void execRouteCache_RemoveItem(FFrame &, void *const);
    void execRouteCache_RemoveIndex(FFrame &, void *const);
    void execSetFocalPoint(FFrame &, void *const);
    void execGetFocalPoint(FFrame &, void *const);
    void execSetDestinationPosition(FFrame &, void *const);
    void execGetDestinationPosition(FFrame &, void *const);
    void execSetAdjustLocation(FFrame &, void *const);
    void execGetAdjustLocation(FFrame &, void *const);
    void execBeyondFogDistance(FFrame &, void *const);
    void execLineOfSightTo(FFrame &, void *const);
    void execCanSee(FFrame &, void *const);
    void execCanSeeByPoints(FFrame &, void *const);
    void execPickTarget(FFrame &, void *const);
    void execMoveTo(FFrame &, void *const);
    void execMoveToDirectNonPathPos(FFrame &, void *const);
    void execMoveToward(FFrame &, void *const);
    void execFinishRotation(FFrame &, void *const);
    void execFindPathTo(FFrame &, void *const);
    void execFindPathToward(FFrame &, void *const);
    void execFindPathTowardNearest(FFrame &, void *const);
    void execFindRandomDest(FFrame &, void *const);
    void execFindPathToIntercept(FFrame &, void *const);
    void execPointReachable(FFrame &, void *const);
    void execActorReachable(FFrame &, void *const);
    void execPickWallAdjust(FFrame &, void *const);
    void execWaitForLanding(FFrame &, void *const);
    void execEndClimbLadder(FFrame &, void *const);
    void execInLatentExecution(FFrame &, void *const);
    void execStopLatentExecution(FFrame &, void *const);
    unsigned int eventGeneratePathToLocation(FVector, float, unsigned int);
    unsigned int eventGeneratePathToActor(AActor *, float, unsigned int);
    void eventCurrentLevelUnloaded();
    unsigned int eventIsInCombat(unsigned int);
    unsigned int eventIsSpectating();
    void eventNotifyCoverAdjusted();
    void eventReachedPreciseDestination();
    void eventNotifyMissedJump();
    void eventNotifyJumpApex();
    unsigned int eventNotifyBump(AActor *, FVector);
    void eventNotifyFallingHitWall(FVector, AActor *);
    unsigned int eventNotifyHitWall(FVector, AActor *);
    unsigned int eventNotifyLanded(FVector, AActor *);
    unsigned int eventNotifyHeadVolumeChange(APhysicsVolume *);
    void eventNotifyPhysicsVolumeChange(APhysicsVolume *);
    void eventGetPlayerViewPoint(FVector &, FRotator &);
    unsigned int eventHandlePathObstruction(AActor *);
    unsigned int eventMoverFinished();
    unsigned int eventAllowDetourTo(ANavigationPoint *);
    void eventMayFall(unsigned int, FVector);
    void eventLongFall();
    void eventMoveUnreachable(FVector, AActor *);
    void eventSetupSpecialPathAbilities();
    void eventEnemyNotVisible();
    void eventSeeMonster(APawn *);
    void eventSeePlayer(APawn *);
    void eventHearNoise(float, AActor *, FName);
    void eventStopFiring();
    float eventRatePickup(AActor *, UClass *);
    void eventNotifyPostLanded();
    void eventUnPossess();
    void eventPossess(APawn *, unsigned int);
    virtual void eventNotifyPathChanged();
private:
    AController &operator=(const AController &);
public:
    static UClass *GetPrivateStaticClassAController(const wchar_t *);
    static void InitializePrivateStaticClassAController();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AController();
public:
    static void InternalConstructor(void *);
    virtual UObject *GetUObjectInterfaceInterface_NavigationHandle();
    virtual int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    virtual unsigned int Tick(float, ELevelTick);
    virtual void Spawned();
    virtual void BeginDestroy();
    virtual unsigned int IsPlayerOwned();
    virtual AController *GetAController();
    void CheckEnemyVisible();
    AActor *HandleSpecial(AActor *);
    UReachSpec *GetNextRoutePath(ANavigationPoint *);
    void SetRouteCache(ANavigationPoint *, float, float);
    AActor *FindPath(const FVector &, AActor *, unsigned int, int, unsigned int);
    AActor *SetPath(int);
    void SetPathLane(float);
    virtual void PostBeginPlay();
    virtual void PostScriptDestroyed();
    void execPollWaitForLanding(FFrame &, void *const);
    void execPollFinishRotation(FFrame &, void *const);
    virtual void GetAnimControlSlotDesc(TArray<FAnimSlotDesc,FDefaultAllocator> &);
    virtual void PreviewBeginAnimControl(UInterpGroup *);
    virtual void PreviewSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int, float);
    virtual void PreviewSetAnimWeights(TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual void PreviewFinishAnimControl(UInterpGroup *);
    virtual void PreviewUpdateFaceFX(unsigned int, const FString &, const FString &, float);
    virtual void PreviewActorPlayFaceFX(const FString &, const FString &, UAkBaseSoundObject *);
    virtual void PreviewActorStopFaceFX();
    virtual UAudioComponent *PreviewGetFaceFXAudioComponent();
    virtual UFaceFXAsset *PreviewGetActorFaceFXAsset();
    virtual void PreviewSetMorphWeight(FName, float);
    virtual void PreviewSetSkelControlScale(FName, float);
    virtual void SetSkelControlStrength(FName, float);
    virtual void SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual unsigned int CanCoverSlip(ACoverLink *, int);
    virtual void SetupPathfindingParams(FNavMeshPathParams &);
    virtual void InitForPathfinding();
    virtual int ExtraEdgeCostToAddWhenActive(FNavMeshEdgeBase *);
    virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase *);
    typedef AActor Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AControllerData[0x60];
};

class AAIController : public AController  // size 0x370, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    void eventSetTeam(int);
private:
    AAIController &operator=(const AAIController &);
public:
    static UClass *GetPrivateStaticClassAAIController(const wchar_t *);
    static void InitializePrivateStaticClassAAIController();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AAIController();
public:
    static void InternalConstructor(void *);
    virtual int AcceptNearbyPath(AActor *);
    virtual void AdjustFromWall(FVector, AActor *);
    virtual void SetAdjustLocation(FVector, unsigned int, unsigned int);
    virtual FVector DesiredDirection();
    virtual void PostScriptDestroyed();
    typedef AController Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AAIControllerData[0x6];
};

class AGwNavAIController : public AAIController  // size 0x370, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    AGwNavAIController &operator=(const AGwNavAIController &);
public:
    static UClass *GetPrivateStaticClassAGwNavAIController(const wchar_t *);
    static void InitializePrivateStaticClassAGwNavAIController();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AGwNavAIController();
public:
    static void InternalConstructor(void *);
protected:
    AGwNavAIController();
public:
    typedef AAIController Super;
private:
    static UClass *PrivateStaticClass;
};

class AGameAIController : public AGwNavAIController  // size 0x3A8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void PushCommand(UGameAICommand *);
    virtual void PopCommand(UGameAICommand *);
    virtual unsigned int AbortCommand(UGameAICommand *, UClass *);
    virtual UGameAICommand *GetAICommandInStack(const UClass *);
    virtual void StoreCommandHistory(UGameAICommand *);
    UGameAICommand *GetActiveCommand();
    void CheckCommandCount();
    void DumpCommandStack();
    UGameAICommand *FindCommandOfClass(UClass *) const;
    void execAllCommands(FFrame &, void *const);
    void execPushCommand(FFrame &, void *const);
    void execPopCommand(FFrame &, void *const);
    void execAbortCommand(FFrame &, void *const);
    void execGetActiveCommand(FFrame &, void *const);
    void execCheckCommandCount(FFrame &, void *const);
    void execDumpCommandStack(FFrame &, void *const);
    void execFindCommandOfClass(FFrame &, void *const);
    void execGetAICommandInStack(FFrame &, void *const);
    FString eventGetActionString();
    void eventAILog_Internal(const FString &, FName, unsigned int);
private:
    AGameAIController &operator=(const AGameAIController &);
public:
    static UClass *GetPrivateStaticClassAGameAIController(const wchar_t *);
    static void InitializePrivateStaticClassAGameAIController();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AGameAIController();
public:
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    void AILog__VA(EName, const wchar_t *, ...);
    void AILog__VA(const wchar_t *, ...);
    void AILog(EName, const wchar_t *);
    void AILog(const wchar_t *);
    virtual unsigned int Tick(float, ELevelTick);
    virtual EGotoState GotoState(FName, unsigned int, unsigned int);
    virtual void ProcessState(float);
    virtual void DebugLogInternal(const wchar_t *);
    typedef AGwNavAIController Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AGameAIControllerData[0xE];
};

class ACCSController : public AGameAIController  // size 0x4B0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void SetDesiredPosition(AActor *);
    virtual void ActuallySetDesiredPosition(FVector);
    virtual void CalcAccuracyAngles(AActor *);
    virtual void TakePossession();
    virtual void SetState(const FString &);
    virtual void RemoveState(const FString &);
    virtual void SetInitialCover(AActor *);
    virtual void TriggerEvent(const FString &);
    virtual void DisableBrain(unsigned int);
    virtual void UpdateOnlyPawnRotation();
    virtual void DrawHUD(GripHUDRenderer *, int &);
    virtual unsigned char GetTeamNum();
    void execSetDesiredPosition(FFrame &, void *const);
    void execActuallySetDesiredPosition(FFrame &, void *const);
    void execCalcAccuracyAngles(FFrame &, void *const);
    void execTakePossession(FFrame &, void *const);
    void execSetState(FFrame &, void *const);
    void execRemoveState(FFrame &, void *const);
    void execSetInitialCover(FFrame &, void *const);
    void execTriggerEvent(FFrame &, void *const);
    void execDisableBrain(FFrame &, void *const);
    void eventCreateDebugVizComponent();
    unsigned int eventFindNavMeshDistance(FVector, float &);
    unsigned int eventFindNavMeshPath(FVector);
    void eventActionStopFiring();
    void eventAimAt(AActor *);
    unsigned int eventFireWeapon(unsigned int, unsigned int, unsigned int);
    unsigned int eventStopFireBurst();
    unsigned int eventStartFireBurstObj(AActor *);
    unsigned int eventStartFireBurst(APawn *);
    unsigned int eventCanFireAt(AActor *);
    void eventNotifyAIMoveToActorCompleted();
private:
    ACCSController &operator=(const ACCSController &);
public:
    static UClass *GetPrivateStaticClassACCSController(const wchar_t *);
    static void InitializePrivateStaticClassACCSController();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~ACCSController();
public:
    static void InternalConstructor(void *);
    virtual unsigned int Tick(float, ELevelTick);
    virtual void BeginDestroy();
    virtual void PostScriptDestroyed();
    virtual void UpdatePawnRotation();
    virtual void AdjustFromWall(FVector, AActor *);
    virtual void ShowSelf();
    virtual void HearNoise(AActor *, float, FName);
private:
    void DestroyBrain();
public:
    typedef AGameAIController Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int ACCSControllerData[0x42];
};

class ANavigationPoint : public AActor  // size 0x294, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual unsigned int IsUsableAnchorFor(APawn *);
    virtual unsigned int CanTeleport(AActor *);
    virtual UClass *GetReachSpecClass(ANavigationPoint *, UClass *);
    virtual void ClearPaths();
    virtual unsigned int ShouldBeBased();
    virtual void Validate();
    virtual void TogglePathRendering(unsigned int);
    virtual void InitForPathFinding();
    virtual void ClearForPathFinding();
    virtual APickupFactory *GetAPickupFactory();
    virtual unsigned int GetUpDir(FVector &);
    virtual void AddToNavigationOctree();
    virtual void RemoveFromNavigationOctree();
    virtual unsigned int PlaceScout(AScout *);
    virtual void GetBoundingCylinder(float &, float &) const;
    UReachSpec *GetReachSpecTo(ANavigationPoint *, UClass *);
    unsigned int GetAllNavInRadius(AActor *, FVector, float, TArray<ANavigationPoint *,FDefaultAllocator> &, unsigned int, int, FCylinder);
    unsigned int IsOnDifferentNetwork(ANavigationPoint *);
    void execGetReachSpecTo(FFrame &, void *const);
    void execIsUsableAnchorFor(FFrame &, void *const);
    void execCanTeleport(FFrame &, void *const);
    void execGetAllNavInRadius(FFrame &, void *const);
    void execIsOnDifferentNetwork(FFrame &, void *const);
    FString eventGetDebugAbbrev();
    unsigned int eventSuggestMovePreparation(APawn *);
    float eventDetourWeight(APawn *, float);
    unsigned int eventAccept(AActor *, AActor *);
    int eventSpecialCost(APawn *, UReachSpec *);
private:
    ANavigationPoint &operator=(const ANavigationPoint &);
public:
    static UClass *GetPrivateStaticClassANavigationPoint(const wchar_t *);
    static void InitializePrivateStaticClassANavigationPoint();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~ANavigationPoint();
public:
    static void InternalConstructor(void *);
    virtual void FindBase();
    virtual void PostScriptDestroyed();
protected:
    virtual void UpdateComponentsInternal(unsigned int);
public:
    virtual void PostEditMove(unsigned int);
    virtual void Spawned();
    void UpdateMaxPathSize();
    unsigned int FindAlternatePath(UReachSpec *, int);
    unsigned int CanReach(ANavigationPoint *, float, unsigned int, unsigned int);
    virtual void SetVolumes();
    virtual void SetVolumes(const TArray<AVolume *,FDefaultAllocator> &);
    virtual unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    virtual unsigned int TouchReachSucceeded(APawn *, const FVector &);
    virtual FVector GetDestination(AController *);
    void SortPathList();
    virtual void GetActorReferences(TArray<FActorReference *,FDefaultAllocator> &, unsigned int);
    virtual void ClearCrossLevelReferences();
    virtual FGuid *GetGuid();
    virtual ANavigationPoint *SpecifyEndAnchor(APawn *);
    virtual void MarkComponentsAsPendingKill(unsigned int);
    typedef AActor Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int ANavigationPointData[0x30];
};

template <> class TArray<APawn *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<APawn *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    APawn *const *GetTypedData() const;
    APawn **GetTypedData();
    APawn *const *GetData() const;
    APawn **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    APawn *const &operator()(int) const;
    APawn *&operator()(int);
    APawn *Pop();
    void Push(APawn *const &);
    APawn *const &Top() const;
    APawn *&Top();
    APawn *const &Last(int) const;
    APawn *&Last(int);
    void Shrink();
    unsigned int FindItem(APawn *const &, int &) const;
    int FindItemIndex(APawn *const &) const;
    unsigned int ContainsItem(APawn *const &) const;
    unsigned int operator==(const TArray<APawn *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<APawn *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(APawn *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<APawn *,FDefaultAllocator> &);
    TArray<APawn *,FDefaultAllocator> &operator+=(const TArray<APawn *,FDefaultAllocator> &);
    TArray<APawn *,FDefaultAllocator> &operator=(const TArray<APawn *,FDefaultAllocator> &);
    int AddItem(APawn *const &);
    int AddZeroed(int);
    int AddUniqueItem(APawn *const &);
    void Reserve(int);
    void Init(APawn *const &, int);
    void Init(int);
    int RemoveSingleItem(APawn *const &);
    int RemoveItem(APawn *const &);
    int RemoveSingleItemSwap(APawn *const &);
    int RemoveItemSwap(APawn *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    APawn *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<APawn *> : public TArray<APawn *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<APawn *> &operator=(const TArray<APawn *,FDefaultAllocator> &);
    TArrayNoInit<APawn *> &operator=(const TArrayNoInit<APawn *> &);
};

template <> class TArray<FCoverSlot,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<FCoverSlot,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    const FCoverSlot *GetTypedData() const;
    FCoverSlot *GetTypedData();
    const FCoverSlot *GetData() const;
    FCoverSlot *GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    const FCoverSlot &operator()(int) const;
    FCoverSlot &operator()(int);
    FCoverSlot Pop();
    void Push(const FCoverSlot &);
    const FCoverSlot &Top() const;
    FCoverSlot &Top();
    const FCoverSlot &Last(int) const;
    FCoverSlot &Last(int);
    void Shrink();
    unsigned int FindItem(const FCoverSlot &, int &) const;
    int FindItemIndex(const FCoverSlot &) const;
    unsigned int ContainsItem(const FCoverSlot &) const;
    unsigned int operator==(const TArray<FCoverSlot,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<FCoverSlot,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(const FCoverSlot &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<FCoverSlot,FDefaultAllocator> &);
    TArray<FCoverSlot,FDefaultAllocator> &operator+=(const TArray<FCoverSlot,FDefaultAllocator> &);
    TArray<FCoverSlot,FDefaultAllocator> &operator=(const TArray<FCoverSlot,FDefaultAllocator> &);
    int AddItem(const FCoverSlot &);
    int AddZeroed(int);
    int AddUniqueItem(const FCoverSlot &);
    void Reserve(int);
    void Init(const FCoverSlot &, int);
    void Init(int);
    int RemoveSingleItem(const FCoverSlot &);
    int RemoveItem(const FCoverSlot &);
    int RemoveSingleItemSwap(const FCoverSlot &);
    int RemoveItemSwap(const FCoverSlot &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    const FCoverSlot &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<FCoverSlot> : public TArray<FCoverSlot,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<FCoverSlot> &operator=(const TArray<FCoverSlot,FDefaultAllocator> &);
    TArrayNoInit<FCoverSlot> &operator=(const TArrayNoInit<FCoverSlot> &);
};

template <> class TArray<FDynamicLinkInfo,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    const FDynamicLinkInfo *GetTypedData() const;
    FDynamicLinkInfo *GetTypedData();
    const FDynamicLinkInfo *GetData() const;
    FDynamicLinkInfo *GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    const FDynamicLinkInfo &operator()(int) const;
    FDynamicLinkInfo &operator()(int);
    FDynamicLinkInfo Pop();
    void Push(const FDynamicLinkInfo &);
    const FDynamicLinkInfo &Top() const;
    FDynamicLinkInfo &Top();
    const FDynamicLinkInfo &Last(int) const;
    FDynamicLinkInfo &Last(int);
    void Shrink();
    unsigned int FindItem(const FDynamicLinkInfo &, int &) const;
    int FindItemIndex(const FDynamicLinkInfo &) const;
    unsigned int ContainsItem(const FDynamicLinkInfo &) const;
    unsigned int operator==(const TArray<FDynamicLinkInfo,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<FDynamicLinkInfo,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(const FDynamicLinkInfo &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    TArray<FDynamicLinkInfo,FDefaultAllocator> &operator+=(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    TArray<FDynamicLinkInfo,FDefaultAllocator> &operator=(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    int AddItem(const FDynamicLinkInfo &);
    int AddZeroed(int);
    int AddUniqueItem(const FDynamicLinkInfo &);
    void Reserve(int);
    void Init(const FDynamicLinkInfo &, int);
    void Init(int);
    int RemoveSingleItem(const FDynamicLinkInfo &);
    int RemoveItem(const FDynamicLinkInfo &);
    int RemoveSingleItemSwap(const FDynamicLinkInfo &);
    int RemoveItemSwap(const FDynamicLinkInfo &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    const FDynamicLinkInfo &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<FDynamicLinkInfo> : public TArray<FDynamicLinkInfo,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    TArrayNoInit<FDynamicLinkInfo> &operator=(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    TArrayNoInit<FDynamicLinkInfo> &operator=(const TArrayNoInit<FDynamicLinkInfo> &);
};

class ACoverLink : public ANavigationPoint  // size 0x328
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    struct FFireLinkInfo;
    virtual unsigned int GetFireLinkTargetCoverInfo(int, int, FCoverInfo &, unsigned char);
    virtual unsigned int GetSwatTurnTarget(int, int, FCoverInfo &);
    virtual void BuildSlotInfo(int, unsigned int, AScout *);
    virtual void BuildSlotInfoInternal(AScout *, int, unsigned int);
    virtual unsigned int GetFireLinkTo(int, const FCoverInfo &, unsigned char, unsigned char, int &, TArray<int,FDefaultAllocator> &);
    virtual unsigned int HasFireLinkTo(int, const FCoverInfo &, unsigned int);
    virtual unsigned int IsFireLinkValid(int, int, unsigned char);
    virtual unsigned int LinkCoverSlotToNavigationMesh(int, UNavigationMeshBase *);
    virtual int FindCoverReference(ACoverLink *, int, unsigned int);
    virtual unsigned int GetCachedCoverInfo(int, FCoverInfo &);
    unsigned char PackFireLinkInteractionInfo(unsigned char, unsigned char, unsigned char, unsigned char);
    void UnPackFireLinkInteractionInfo(const unsigned char, unsigned char &, unsigned char &, unsigned char &, unsigned char &);
    FVector GetSlotLocation(int, unsigned int);
    FRotator GetSlotRotation(int, unsigned int);
    FVector GetSlotViewPoint(int, unsigned char, unsigned char);
    unsigned int IsExposedTo(int, FCoverInfo, float &);
    unsigned int IsValidClaim(APawn *, int, unsigned int, unsigned int);
    unsigned int IsValidClaimBetween(APawn *, int, int, unsigned int, unsigned int);
    unsigned int FindSlots(FVector, float, int &, int &);
    unsigned int IsEdgeSlot(int, unsigned int);
    unsigned int IsLeftEdgeSlot(int, unsigned int);
    unsigned int IsRightEdgeSlot(int, unsigned int);
    int GetSlotIdxToLeft(int, int);
    int GetSlotIdxToRight(int, int);
    void GetSlotActions(int, TArray<unsigned char,FDefaultAllocator> &);
    unsigned int AutoAdjustSlot(int, unsigned int);
    unsigned int IsEnabled();
    int AddCoverSlot(FVector &, FRotator &, FCoverSlot, int);
    int AddCoverSlot(FVector, FRotator, int, unsigned int, AScout *);
    unsigned char GetLocationDescription(int);
    void AddToNorman();
    void RemoveFromNorman();
    void execGetFireLinkTargetCoverInfo(FFrame &, void *const);
    void execPackFireLinkInteractionInfo(FFrame &, void *const);
    void execUnPackFireLinkInteractionInfo(FFrame &, void *const);
    void execGetSlotLocation(FFrame &, void *const);
    void execGetSlotRotation(FFrame &, void *const);
    void execGetSlotViewPoint(FFrame &, void *const);
    void execIsExposedTo(FFrame &, void *const);
    void execIsValidClaim(FFrame &, void *const);
    void execIsValidClaimBetween(FFrame &, void *const);
    void execFindSlots(FFrame &, void *const);
    void execIsEdgeSlot(FFrame &, void *const);
    void execIsLeftEdgeSlot(FFrame &, void *const);
    void execIsRightEdgeSlot(FFrame &, void *const);
    void execGetSlotIdxToLeft(FFrame &, void *const);
    void execGetSlotIdxToRight(FFrame &, void *const);
    void execGetFireLinkTo(FFrame &, void *const);
    void execHasFireLinkTo(FFrame &, void *const);
    void execGetSlotActions(FFrame &, void *const);
    void execAutoAdjustSlot(FFrame &, void *const);
    void execIsEnabled(FFrame &, void *const);
    void execGetSwatTurnTarget(FFrame &, void *const);
    void execAddCoverSlot(FFrame &, void *const);
    void execGetLocationDescription(FFrame &, void *const);
    void execAddToNorman(FFrame &, void *const);
    void execRemoveFromNorman(FFrame &, void *const);
    FString eventGetDebugString(int);
    void eventSetSlotPlayerOnly(int, unsigned int);
    void eventSetSlotEnabled(int, unsigned int);
    void eventSetDisabled(unsigned int);
    unsigned int eventUnClaim(APawn *, int, unsigned int);
    unsigned int eventClaim(APawn *, int);
    void eventSetInvalidUntil(int, float);
private:
    ACoverLink &operator=(const ACoverLink &);
public:
    static UClass *GetPrivateStaticClassACoverLink(const wchar_t *);
    static void InitializePrivateStaticClassACoverLink();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~ACoverLink();
public:
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    virtual void BeginDestroy();
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    void SortSlots(FCoverSlot **);
    void BuildFireLinks(AScout *);
    void BuildOtherLinks(AScout *);
    unsigned int GetFireActions(ACoverLink::FFireLinkInfo &, ACoverLink *, int, unsigned int);
    unsigned int CanFireLinkHit(const FVector &, const FVector &, unsigned int);
    unsigned int GetExposedInfo(ACoverLink *, int, ACoverLink *, int, float &);
    float GetSlotHeight(int);
    virtual void GetActorReferences(TArray<FActorReference *,FDefaultAllocator> &, unsigned int);
    unsigned int IsOverlapSlotClaimed(APawn *, int, unsigned int);
    static FCoverSlot *CoverInfoToSlotPtr(FCoverInfo &);
    static FCoverSlot *CoverRefToSlotPtr(FCoverReference &);
    unsigned int FindCoverEdges(const FVector &, FVector, FVector, FVector);
    void EditorAutoSetup(FVector, FVector *, FVector *);
    void ClearExposedFireLinks();
    void FixupLevelCoverReferences();
    static void FireLinkInteraction_PackSrcType(unsigned char, unsigned char &);
    static void FireLinkInteraction_PackSrcAction(unsigned char, unsigned char &);
    static void FireLinkInteraction_PackDestType(unsigned char, unsigned char &);
    static void FireLinkInteraction_PackDestAction(unsigned char, unsigned char &);
    static unsigned char FireLinkInteraction_UnpackSrcType(const unsigned char);
    static unsigned char FireLinkInteraction_UnpackSrcAction(const unsigned char);
    static unsigned char FireLinkInteraction_UnpackDestType(const unsigned char);
    static unsigned char FireLinkInteraction_UnpackDestAction(const unsigned char);
    typedef ANavigationPoint Super;
    unsigned long GLOBAL_bUseSlotMarkers : 1;  // 0x294
    unsigned long bDisabled : 1;
    unsigned long bClaimAllSlots : 1;
    unsigned long bAutoSort : 1;
    unsigned long bAutoAdjust : 1;
    unsigned long bCircular : 1;
    unsigned long bLooped : 1;
    unsigned long bPlayerOnly : 1;
    unsigned long bDynamicCover : 1;
    unsigned long bFractureOnTouch : 1;
    unsigned long bDebug_FireLinks : 1;
    unsigned long bDebug_ExposedLinks : 1;
    unsigned long bDebug_CoverGen : 1;
    unsigned long bDoAutoSlotDensityFixup : 1;
    AActor *DestructibleCoverActor;  // 0x298
    ACoverLink *NextDestructibleCoverLink;  // 0x29C
    float LeanTraceDist;  // 0x2A0
    TArrayNoInit<FCoverSlot> Slots;  // 0x2A4
    TArrayNoInit<FDynamicLinkInfo> DynamicLinkInfos;  // 0x2B0
    TArrayNoInit<APawn *> Claims;  // 0x2BC
    float InvalidateDistance;  // 0x2C8
    float MaxFireLinkDist;  // 0x2CC
    FVector CircularOrigin;  // 0x2D0
    float CircularRadius;  // 0x2DC
    float AlignDist;  // 0x2E0
    float AutoCoverSlotInterval;  // 0x2E4
    float StandHeight;  // 0x2E8
    float MidHeight;  // 0x2EC
    FVector StandingLeanOffset;  // 0x2F0
    FVector CrouchLeanOffset;  // 0x2FC
    FVector PopupOffset;  // 0x308
    float SlipDist;  // 0x314
    float TurnDist;  // 0x318
    float DangerScale;  // 0x31C
    ACoverLink *NextCoverLink;  // 0x320
    unsigned char LocationDescription;  // 0x324
private:
    static UClass *PrivateStaticClass;
public:
    char _pad0[0x3];
};

class IInterface_Speaker  // size 0x4, opaque
{
protected:
    virtual ~IInterface_Speaker();
public:
    virtual UObject *GetUObjectInterfaceInterface_Speaker() = 0;
    virtual void eventSpeak(USoundCue *) = 0;
protected:
    IInterface_Speaker();
};

class APawn : public AActor, public IInterface_Speaker  // size 0x47C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void CacheAnimNodes();
    virtual void MAT_BeginAnimControl(UInterpGroup *);
    virtual void MAT_FinishAnimControl(UInterpGroup *);
    virtual void MAT_SetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int);
    virtual void MAT_SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual void MAT_SetMorphWeight(FName, float);
    virtual void MAT_SetSkelControlScale(FName, float);
    virtual void MAT_SetSkelControlStrength(FName, float);
    virtual unsigned int IsAliveAndWell() const;
    virtual FVector AdjustDestination(AActor *, FVector);
    virtual unsigned int SuggestJumpVelocity(FVector &, FVector, FVector, unsigned int);
    virtual float GetFallDuration();
    virtual unsigned int IsValidEnemyTargetFor(const APlayerReplicationInfo *, unsigned int);
    virtual void SetAnchor(ANavigationPoint *);
    virtual ANavigationPoint *GetBestAnchor(AActor *, FVector, unsigned int, unsigned int, float &);
    virtual unsigned int ReachedDestination(AActor *);
    virtual unsigned int ReachedDestination(const FVector &, const FVector &, AActor *, unsigned int);
    virtual unsigned int ReachedPoint(FVector, AActor *);
    virtual void ForceCrouch();
    virtual void SetPushesRigidBodies(unsigned int);
    virtual unsigned int ReachedDesiredRotation();
    virtual unsigned int InitRagdoll();
    virtual unsigned int TermRagdoll();
    virtual FRotator GetViewRotation();
    virtual AVehicle *GetVehicleBase();
    virtual void ClearConstraints();
    virtual void AddPathConstraint(UPathConstraint *);
    virtual void AddGoalEvaluator(UPathGoalEvaluator *);
    virtual void IncrementPathStep(int, UCanvas *);
    virtual void IncrementPathChild(int, UCanvas *);
    virtual void DrawPathStep(UCanvas *);
    virtual void ClearPathStep();
    virtual void SetRootMotionInterpCurrentTime(float, float, unsigned int);
    virtual void SmoothCorrection(const FVector &);
    virtual USkeletalMeshComponent *GetMeshForSkelControlLimbTransform(const USkeletalMeshComponent *);
    virtual void CheckNoiseHearing(AActor *, float, FName);
    virtual float DampenNoise(AActor *, float, FName);
    virtual void setMoveTimer(FVector);
    virtual unsigned int moveToward(const FVector &, AActor *);
    virtual unsigned int IsGlider();
    virtual void rotateToward(FVector);
    virtual unsigned int SharingVehicleWith(APawn *);
    virtual void HandleSerpentineMovement(FVector &, float, const FVector &);
    virtual int pointReachable(FVector, int);
    virtual int actorReachable(AActor *, unsigned int, unsigned int);
    virtual int Reachable(FVector, AActor *);
    virtual unsigned int TryJumpUp(FVector, FVector, unsigned long, unsigned int);
    virtual unsigned int ReachThresholdTest(const FVector &, const FVector &, AActor *, float, float, float);
    virtual unsigned int SetHighJumpFlag();
    virtual ETestMoveResult FindBestJump(FVector, FVector &);
    virtual ETestMoveResult FindJumpUp(FVector, FVector &);
    virtual unsigned int HurtByDamageType(UClass *);
    virtual void SetMaxLandingVelocity(float);
    virtual ANavigationPoint *CheckDetour(ANavigationPoint *, ANavigationPoint *, unsigned int);
    virtual int calcMoveFlags();
    virtual void MarkEndPoints(ANavigationPoint *, AActor *, const FVector &);
    virtual float SecondRouteAttempt(ANavigationPoint *, ANavigationPoint *, float (*)(ANavigationPoint *, APawn *, float), float, AActor *, const FVector &, float, float, int, int);
    virtual int ModifyCostForReachSpec(UReachSpec *, int);
    virtual void InitForPathfinding(AActor *, ANavigationPoint *);
    virtual unsigned int IsValidAnchor(ANavigationPoint *);
    virtual void PostProcessPhysics(float, const FVector &);
    virtual unsigned int ShouldBypassSimulatedClientPhysics();
    virtual FVector CheckForLedges(FVector, FVector, FVector, int &, int &);
    virtual void physFlying(float, int);
    virtual void physSwimming(float, int);
    virtual void physSpider(float, int);
    virtual void physLadder(float, int);
    virtual void startNewPhysics(float, int);
    virtual void StartFalling(int, float, float, const FVector &, const FVector &);
    virtual unsigned int ShouldCatchAir(const FVector &, const FVector &);
    virtual void SetPostLandedPhysics(AActor *, FVector);
    virtual void Crouch(int);
    virtual void UnCrouch(int);
    virtual FVector NewFallVelocity(FVector, FVector, float);
    virtual float MaxSpeedModifier();
    virtual float GetMaxAccel(float);
    virtual FVector CalculateSlopeSlide(const FVector &, const FCheckResult &);
    virtual void ProcessPushNotify(const FRigidBodyCollisionInfo &, const TArray<FRigidBodyContactInfo,FDefaultAllocator> &);
    virtual unsigned int HasAudibleAmbientSound(const FVector &);
    virtual unsigned int HasReached(ANavigationPoint *, unsigned int &);
    virtual FVector GetIdealCameraOrigin();
    virtual void BuildAnimSetList();
protected:
    virtual void ApplyVelocityBraking(float, float);
    virtual void CalcVelocity(FVector &, float, float, float, int, int, int);
public:
    unsigned int PickWallAdjust(FVector, AActor *);
    unsigned int SetDesiredRotation(FRotator, unsigned int, unsigned int, float, unsigned int);
    void LockDesiredRotation(unsigned int, unsigned int);
    void ResetDesiredRotation();
    void CheckDesiredRotation();
    unsigned int IsDesiredRotationInUse();
    unsigned int IsDesiredRotationLocked();
    void UpdateAnimSetList();
    void AddAnimSets(const TArray<UAnimSet *,FDefaultAllocator> &);
    unsigned int ValidAnchor();
    virtual unsigned int IsInvisible();
    void SetRemoteViewPitch(int);
    virtual void GetBoundingCylinder(float &, float &) const;
    unsigned int IsHumanControlled(AController *);
    unsigned int IsLocallyControlled();
    virtual unsigned int IsPlayerPawn() const;
    virtual FVector GetPawnViewLocation();
    virtual unsigned char GetTeamNum();
    void SetScalarParameterInterp(const FScalarParameterInterpStruct &);
    void execPickWallAdjust(FFrame &, void *const);
    void execSetDesiredRotation(FFrame &, void *const);
    void execLockDesiredRotation(FFrame &, void *const);
    void execResetDesiredRotation(FFrame &, void *const);
    void execCheckDesiredRotation(FFrame &, void *const);
    void execIsDesiredRotationInUse(FFrame &, void *const);
    void execIsDesiredRotationLocked(FFrame &, void *const);
    void execCacheAnimNodes(FFrame &, void *const);
    void execUpdateAnimSetList(FFrame &, void *const);
    void execAddAnimSets(FFrame &, void *const);
    void execMAT_BeginAnimControl(FFrame &, void *const);
    void execMAT_FinishAnimControl(FFrame &, void *const);
    void execMAT_SetAnimPosition(FFrame &, void *const);
    void execMAT_SetAnimWeights(FFrame &, void *const);
    void execMAT_SetMorphWeight(FFrame &, void *const);
    void execMAT_SetSkelControlScale(FFrame &, void *const);
    void execMAT_SetSkelControlStrength(FFrame &, void *const);
    void execIsAliveAndWell(FFrame &, void *const);
    void execAdjustDestination(FFrame &, void *const);
    void execValidAnchor(FFrame &, void *const);
    void execSuggestJumpVelocity(FFrame &, void *const);
    void execGetFallDuration(FFrame &, void *const);
    void execIsValidEnemyTargetFor(FFrame &, void *const);
    void execSetRemoteViewPitch(FFrame &, void *const);
    void execSetAnchor(FFrame &, void *const);
    void execGetBestAnchor(FFrame &, void *const);
    void execReachedDestination(FFrame &, void *const);
    void execReachedPoint(FFrame &, void *const);
    void execForceCrouch(FFrame &, void *const);
    void execSetPushesRigidBodies(FFrame &, void *const);
    void execReachedDesiredRotation(FFrame &, void *const);
    void execInitRagdoll(FFrame &, void *const);
    void execTermRagdoll(FFrame &, void *const);
    void execIsHumanControlled(FFrame &, void *const);
    void execIsLocallyControlled(FFrame &, void *const);
    void execIsPlayerPawn(FFrame &, void *const);
    void execGetViewRotation(FFrame &, void *const);
    void execGetVehicleBase(FFrame &, void *const);
    void execClearConstraints(FFrame &, void *const);
    void execAddPathConstraint(FFrame &, void *const);
    void execAddGoalEvaluator(FFrame &, void *const);
    void execIncrementPathStep(FFrame &, void *const);
    void execIncrementPathChild(FFrame &, void *const);
    void execDrawPathStep(FFrame &, void *const);
    void execClearPathStep(FFrame &, void *const);
    void execSetRootMotionInterpCurrentTime(FFrame &, void *const);
    void execSetScalarParameterInterp(FFrame &, void *const);
    void eventOnRootMotionCollision(FVector);
    void eventNotifyGrenadeStuck();
    virtual void eventSpeak(USoundCue *);
    void eventSoakPause();
    void eventMessagePlayer(const FString &);
    AInventory *eventCreateInventory(UClass *, unsigned int);
    void eventStopDriving(AVehicle *);
    void eventStartDriving(AVehicle *);
    void eventPlayFootStepSound(int);
    void eventBreathTimer();
    void eventHeadVolumeChange(APhysicsVolume *);
    void eventTickSpecial(float);
    void eventNotifyBecameThreatened();
    unsigned int eventIsSameTeam(APawn *);
    unsigned int eventTakeRadiusDamageOnBones(AController *, float, float, UClass *, float, FVector, unsigned int, AActor *, const TArray<FName,FDefaultAllocator> &);
    void eventStuckOnPawn(APawn *);
    void eventUpdatePawnRotation(FRotator);
    void eventStartCrouch(float);
    void eventEndCrouch(float);
    void eventClientMessage(const FString &, FName);
    unsigned int eventInFreeCam();
    FRotator eventGetBaseAimRotation();
    FVector eventGetWeaponStartTraceLocation(AWeapon *);
    FRotator eventGetViewRotation();
    void eventSetWalking(unsigned int);
    unsigned int eventSpecialMoveThruEdge(unsigned char, int, FVector, FVector, AActor *, int, UNavigationHandle *);
    void eventMAT_FinishAIGroup();
    void eventMAT_BeginAIGroup(FVector, FRotator);
    unsigned int eventRestoreAnimSetsToDefault();
    void eventAnimSetListUpdated();
    void eventBuildScriptAnimSetList();
    void eventCacheAnimNodes();
private:
    APawn &operator=(const APawn &);
public:
    static UClass *GetPrivateStaticClassAPawn(const wchar_t *);
    static void InitializePrivateStaticClassAPawn();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~APawn();
public:
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    virtual UObject *GetUObjectInterfaceInterface_Speaker();
    virtual void PostBeginPlay();
    virtual void PostScriptDestroyed();
    virtual APawn *GetPlayerPawn() const;
    virtual float GetNetPriority(const FVector &, const FVector &, APlayerController *, UActorChannel *, float, unsigned int);
    virtual int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    virtual void NotifyBump(AActor *, UPrimitiveComponent *, const FVector &);
    virtual void TickSimulated(float);
    virtual void TickSpecial(float);
    virtual unsigned int PlayerControlled();
    virtual void SetBase(AActor *, FVector, int, USkeletalMeshComponent *, FName);
    virtual unsigned int IsNetRelevantFor(APlayerController *, AActor *, const FVector &);
    unsigned int CacheNetRelevancy(unsigned int, APlayerController *, AActor *);
    virtual unsigned int ShouldTrace(UPrimitiveComponent *, AActor *, unsigned long);
    virtual void PreNetReceive();
    virtual void PostNetReceiveLocation();
    virtual const APawn *GetAPawn() const;
    virtual APawn *GetAPawn();
    virtual void SetHardAttach(unsigned int);
    virtual unsigned int CanCauseFractureOnTouch();
    virtual void SetZone(unsigned int, unsigned int);
    float GetMaxSpeed();
    void StartNewSerpentine(const FVector &, const FVector &);
    void ClearSerpentine();
    void InitSerpentine();
    int walkReachable(const FVector &, const FVector &, int, AActor *);
    int flyReachable(const FVector &, const FVector &, int, AActor *);
    int swimReachable(const FVector &, const FVector &, int, AActor *);
    int ladderReachable(const FVector &, const FVector &, int, AActor *);
    int spiderReachable(const FVector &, const FVector &, int, AActor *);
    FVector GetGravityDirection();
    virtual unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    void TestMove(const FVector &, FVector &, FCheckResult &, const FVector &);
    FVector GetDefaultCollisionSize();
    FVector GetCrouchSize();
    ETestMoveResult walkMove(FVector, FVector &, const FVector &, FCheckResult &, AActor *, float);
    ETestMoveResult flyMove(FVector, FVector &, AActor *, float);
    ETestMoveResult swimMove(FVector, FVector &, AActor *, float);
    ETestMoveResult HitGoal(AActor *);
    unsigned int CanCrouchWalk(const FVector &, const FVector &, AActor *);
    unsigned int GeneratePath();
    float findPathToward(AActor *, FVector, float (*)(ANavigationPoint *, APawn *, float), float, unsigned int, int, unsigned int, int);
    ANavigationPoint *BestPathTo(float (*)(ANavigationPoint *, APawn *, float), ANavigationPoint *, float *, unsigned int, int, int);
    float GetAIMaxFallSpeed();
    ANavigationPoint *FindAnchor(AActor *, const FVector &, unsigned int, unsigned int, float &);
    virtual ANavigationPoint *SpecifyEndAnchor(APawn *);
    virtual unsigned int AnchorNeedNotBeReachable();
    virtual void NotifyAnchorFindingResult(ANavigationPoint *, APawn *);
    virtual void setPhysics(unsigned char, AActor *, FVector);
    virtual void performPhysics(float);
    virtual void physWalking(float, int);
    virtual void physNavMeshWalking(float);
    virtual void physFalling(float, int);
    virtual void GetNetBuoyancy(float &, float &);
    void startSwimming(FVector, FVector, float, float, int);
    virtual void physicsRotation(float, FVector);
    virtual void processLanded(const FVector &, AActor *, float, int);
    virtual void processHitWall(const FCheckResult &, float);
    virtual void SmoothHitWall(const FVector &, AActor *);
    virtual void stepUp(const FVector &, const FVector &, const FVector &, FCheckResult &);
    virtual unsigned int IgnoreBlockingBy(const AActor *) const;
    virtual void PushedBy(AActor *);
    virtual void UpdateBasedRotation(FRotator &, const FRotator &);
    virtual void ReverseBasedRotation();
    virtual void InitRBPhys();
    virtual void TermRBPhys(FRBPhysScene *);
    virtual void UpdatePushBody();
    virtual unsigned int Tick(float, ELevelTick);
    void RestoreAnimSetsToDefault();
    virtual void GetAnimControlSlotDesc(TArray<FAnimSlotDesc,FDefaultAllocator> &);
    virtual void PreviewBeginAnimControl(UInterpGroup *);
    virtual void PreviewSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int, float);
    virtual void PreviewSetAnimWeights(TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual void PreviewFinishAnimControl(UInterpGroup *);
    virtual void PreviewUpdateFaceFX(unsigned int, const FString &, const FString &, float);
    virtual void PreviewActorPlayFaceFX(const FString &, const FString &, UAkBaseSoundObject *);
    virtual void PreviewActorStopFaceFX();
    virtual UAudioComponent *PreviewGetFaceFXAudioComponent();
    virtual UFaceFXAsset *PreviewGetActorFaceFXAsset();
    virtual void PreviewSetMorphWeight(FName, float);
    virtual void PreviewSetSkelControlScale(FName, float);
    virtual void SetSkelControlStrength(FName, float);
    virtual void SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    virtual void AdjustInterpTrackMove(FVector &, FRotator &, float, unsigned int);
    virtual unsigned int FindInterpMoveTrack(UInterpTrackMove **, UInterpTrackInstMove **, USeqAct_Interp **);
    void UpdateScalarParameterInterp(float);
private:
    unsigned int Pick3DWallAdjust(FVector, AActor *);
    float Swim(FVector, FCheckResult &);
    FVector findWaterLine(FVector, FVector);
    void SpiderstepUp(const FVector &, const FVector &, FCheckResult &);
    int findNewFloor(FVector, float, float, int);
    int checkFloor(FVector, FCheckResult &);
public:
    typedef AActor Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int APawnData[0xA9];
};

class AVehicle : public APawn  // size 0x4F0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual float GetMaxRiseForce();
    virtual unsigned int HasRelevantDriver();
    virtual unsigned int IsStuck();
    virtual unsigned int AdjustFlight(float, unsigned int, float, AActor *);
    virtual void SteerVehicle(FVector);
    virtual void AdjustThrottle(float);
    virtual unsigned int JumpOutCheck(AActor *, float, float);
    virtual void moveTowardGwNav(const FVector &);
    virtual FVector GetTargetLocation(AActor *, unsigned int) const;
    void execGetMaxRiseForce(FFrame &, void *const);
    unsigned int eventGwNavBotExitVehicle(APawn *);
    unsigned int eventGwNavBotEnterVehicle(APawn *);
    FVector eventGetEntryLocation();
    unsigned int eventDriverLeave(unsigned int);
    unsigned int eventContinueOnFoot();
private:
    AVehicle &operator=(const AVehicle &);
public:
    static UClass *GetPrivateStaticClassAVehicle(const wchar_t *);
    static void InitializePrivateStaticClassAVehicle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AVehicle();
public:
    static void InternalConstructor(void *);
    virtual int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    virtual unsigned int IsNetRelevantFor(APlayerController *, AActor *, const FVector &);
    virtual unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    virtual ANavigationPoint *CheckDetour(ANavigationPoint *, ANavigationPoint *, unsigned int);
    virtual void performPhysics(float);
    virtual AVehicle *GetAVehicle();
    virtual unsigned int IsRelevancyOwnerFor(AActor *, AActor *, AActor *);
    virtual void setMoveTimer(FVector);
    virtual unsigned int moveToward(const FVector &, AActor *);
    virtual void rotateToward(FVector);
    virtual void MarkEndPoints(ANavigationPoint *, AActor *, const FVector &);
    virtual float SecondRouteAttempt(ANavigationPoint *, ANavigationPoint *, float (*)(ANavigationPoint *, APawn *, float), float, AActor *, const FVector &, float, float, int, int);
    virtual unsigned int IsGlider();
    typedef APawn Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AVehicleData[0x1D];
};

class ASVehicle : public AVehicle  // size 0x620, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void AddForce(FVector);
    virtual void AddImpulse(FVector);
    virtual void AddTorque(FVector);
    virtual unsigned int IsSleeping();
    virtual void InitVehicleRagdoll(USkeletalMesh *, UPhysicsAsset *, FVector, unsigned int);
    virtual unsigned int HasWheelsOnGround();
    virtual void VehiclePackRBState();
    virtual void VehicleUnpackRBState();
    virtual FVector GetDampingForce(const FVector &);
    virtual void UpdateVehicle(ASVehicle *, float);
    virtual void SetWheelEffectParams(USVehicleWheel *, float);
    void SetWheelCollision(int, unsigned int);
    void execAddForce(FFrame &, void *const);
    void execAddImpulse(FFrame &, void *const);
    void execAddTorque(FFrame &, void *const);
    void execIsSleeping(FFrame &, void *const);
    void execSetWheelCollision(FFrame &, void *const);
    void execInitVehicleRagdoll(FFrame &, void *const);
    void execHasWheelsOnGround(FFrame &, void *const);
    void eventSuspensionHeavyShift(float);
private:
    ASVehicle &operator=(const ASVehicle &);
public:
    static UClass *GetPrivateStaticClassASVehicle(const wchar_t *);
    static void InitializePrivateStaticClassASVehicle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~ASVehicle();
public:
    static void InternalConstructor(void *);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    virtual void physRigidBody(float);
    virtual void TickSimulated(float);
    virtual void TickAuthoritative(float);
    virtual void setPhysics(unsigned char, AActor *, FVector);
    virtual void PostNetReceiveLocation();
    virtual int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    virtual void OnRigidBodyCollision(const FRigidBodyCollisionInfo &, const FRigidBodyCollisionInfo &, const FCollisionImpactData &);
    virtual void ModifyNxActorDesc(NxActorDesc &, UPrimitiveComponent *, const NxGroupsMask &, unsigned int);
    virtual void PostInitRigidBody(NxActor *, NxActorDesc &, UPrimitiveComponent *);
    virtual void PreTermRigidBody(NxActor *);
    virtual void TermRBPhys(FRBPhysScene *);
    typedef AVehicle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int ASVehicleData[0x4C];
};

class AGwNavVehicle : public ASVehicle  // size 0x630, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void MoveToPosition(FVector);
    virtual unsigned int IsArrived();
    virtual void IntializeNavigationBot(UGwNavNavdataFamily *, unsigned int, unsigned int, int);
    void execMoveToPosition(FFrame &, void *const);
    void execIsArrived(FFrame &, void *const);
    void execIntializeNavigationBot(FFrame &, void *const);
    void eventExecuteVehicleCommand(unsigned char);
private:
    AGwNavVehicle &operator=(const AGwNavVehicle &);
public:
    static UClass *GetPrivateStaticClassAGwNavVehicle(const wchar_t *);
    static void InitializePrivateStaticClassAGwNavVehicle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AGwNavVehicle();
public:
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    virtual void PostBeginPlay();
    virtual void PostScriptDestroyed();
    typedef ASVehicle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AGwNavVehicleData[0x4];
};

class AKAsset : public AActor  // size 0x1E4, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    AKAsset &operator=(const AKAsset &);
public:
    static UClass *GetPrivateStaticClassAKAsset(const wchar_t *);
    static void InitializePrivateStaticClassAKAsset();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AKAsset();
public:
    static void InternalConstructor(void *);
    virtual int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    virtual unsigned int ShouldTrace(UPrimitiveComponent *, AActor *, unsigned long);
    virtual unsigned int IgnoreBlockingBy(const AActor *) const;
    typedef AActor Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AKAssetData[0x4];
};

class AUDKCover : public AKAsset  // size 0x1E8
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void AddCoverLink(ACoverLink *);
    virtual void RemoveCoverLink(ACoverLink *);
    virtual void KillCoverLinks();
    virtual FVector GetPawnViewLocation();
    void execAddCoverLink(FFrame &, void *const);
    void execRemoveCoverLink(FFrame &, void *const);
    void execKillCoverLinks(FFrame &, void *const);
private:
    AUDKCover &operator=(const AUDKCover &);
public:
    static UClass *GetPrivateStaticClassAUDKCover(const wchar_t *);
    static void InitializePrivateStaticClassAUDKCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AUDKCover();
public:
    static void InternalConstructor(void *);
    virtual void BeginDestroy();
    virtual void PreBeginPlay();
    typedef AKAsset Super;
    ACoverLink *FirstCoverLink;  // 0x1E4
private:
    static UClass *PrivateStaticClass;
};

class AUSSController : public ACCSController  // size 0x4B0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    AUSSController &operator=(const AUSSController &);
public:
    static UClass *GetPrivateStaticClassAUSSController(const wchar_t *);
    static void InitializePrivateStaticClassAUSSController();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AUSSController();
public:
    static void InternalConstructor(void *);
protected:
    virtual void PostPollMove();
public:
    virtual void DrawHUD(GripHUDRenderer *, int &);
    typedef ACCSController Super;
private:
    static UClass *PrivateStaticClass;
};

class ICCSPawn  // size 0x4, opaque
{
protected:
    virtual ~ICCSPawn();
public:
    virtual UObject *GetUObjectInterfaceCCSPawn() = 0;
    virtual unsigned char GetMovementType() = 0;
    virtual void SetMovementType(unsigned char) = 0;
    virtual void SetMovementTypeDefault() = 0;
    virtual unsigned char GetAlertness() = 0;
    virtual void SetAlertness(unsigned char) = 0;
    virtual void SetAlertnessDefault() = 0;
    virtual unsigned char GetSpeed() = 0;
    virtual void SetSpeed(unsigned char) = 0;
    virtual void SetMovementSpeedDefault() = 0;
    virtual unsigned int IsCrouched() = 0;
    virtual void SetCrouched(unsigned int) = 0;
    virtual void SetPostureDefault() = 0;
    virtual unsigned int PostureTransitionOver() = 0;
    virtual unsigned int CanAim(FRotator) = 0;
    virtual void SetCoverPose(unsigned char, float) = 0;
    virtual void SetNoCoverPose() = 0;
    virtual unsigned int CoverPoseTransitionOver() = 0;
    virtual void MoveToInCover(FVector) = 0;
    virtual unsigned int IsInCover() = 0;
    virtual unsigned int GetIsPanicking() = 0;
    virtual void SetIsPanicking(unsigned int) = 0;
    virtual float GetYellingDistance() = 0;
    virtual UCCSBTTree *GetDefaultBehaviorTree() = 0;
    virtual void SetDefaultBehaviorTree(UCCSBTTree *) = 0;
protected:
    ICCSPawn();
};

class AUSSPawn : public APawn, public ICCSPawn  // size 0x4CC, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual unsigned char GetMovementType();
    virtual void SetMovementType(unsigned char);
    virtual void SetMovementTypeDefault();
    virtual unsigned char GetAlertness();
    virtual void SetAlertness(unsigned char);
    virtual void SetAlertnessDefault();
    virtual unsigned char GetSpeed();
    virtual void SetSpeed(unsigned char);
    virtual void SetMovementSpeedDefault();
    virtual unsigned int IsCrouched();
    virtual void SetCrouched(unsigned int);
    virtual void SetPostureDefault();
    virtual unsigned int PostureTransitionOver();
    virtual unsigned int CanAim(FRotator);
    virtual void SetCoverPose(unsigned char, float);
    virtual void SetNoCoverPose();
    virtual unsigned int CoverPoseTransitionOver();
    virtual void MoveToInCover(FVector);
    virtual unsigned int IsInCover();
    virtual void SetIsPanicking(unsigned int);
    virtual unsigned int GetIsPanicking();
    virtual UCCSBTTree *GetDefaultBehaviorTree();
    virtual void SetDefaultBehaviorTree(UCCSBTTree *);
    virtual float GetYellingDistance();
    void execGetMovementType(FFrame &, void *const);
    void execSetMovementType(FFrame &, void *const);
    void execSetMovementTypeDefault(FFrame &, void *const);
    void execGetAlertness(FFrame &, void *const);
    void execSetAlertness(FFrame &, void *const);
    void execSetAlertnessDefault(FFrame &, void *const);
    void execGetSpeed(FFrame &, void *const);
    void execSetSpeed(FFrame &, void *const);
    void execSetMovementSpeedDefault(FFrame &, void *const);
    void execIsCrouched(FFrame &, void *const);
    void execSetCrouched(FFrame &, void *const);
    void execSetPostureDefault(FFrame &, void *const);
    void execPostureTransitionOver(FFrame &, void *const);
    void execCanAim(FFrame &, void *const);
    void execSetCoverPose(FFrame &, void *const);
    void execSetNoCoverPose(FFrame &, void *const);
    void execCoverPoseTransitionOver(FFrame &, void *const);
    void execMoveToInCover(FFrame &, void *const);
    void execIsInCover(FFrame &, void *const);
    void execSetIsPanicking(FFrame &, void *const);
    void execGetIsPanicking(FFrame &, void *const);
    void execGetDefaultBehaviorTree(FFrame &, void *const);
    void execSetDefaultBehaviorTree(FFrame &, void *const);
    void execGetYellingDistance(FFrame &, void *const);
private:
    AUSSPawn &operator=(const AUSSPawn &);
public:
    static UClass *GetPrivateStaticClassAUSSPawn(const wchar_t *);
    static void InitializePrivateStaticClassAUSSPawn();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~AUSSPawn();
public:
    static void InternalConstructor(void *);
    virtual UObject *GetUObjectInterfaceCCSPawn();
    virtual void TickSpecial(float);
    virtual float MaxSpeedModifier();
    typedef APawn Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int AUSSPawnData[0x13];
};

class GripVHeapObject  // size 0x4, opaque
{
public:
    virtual ~GripVHeapObject();
    static void *operator new(unsigned int, void *);
    static void *operator new(unsigned int, Grip::MemAddressStub *, int, const char *, int);
    static void *operator new(unsigned int, Grip::MemoryHeap *, int, const char *, int);
    static void *operator new(unsigned int, int, const char *, int);
    static void *operator new(unsigned int, Grip::MemAddressStub *, const char *, int);
    static void *operator new(unsigned int, Grip::MemoryHeap *, const char *, int);
    static void *operator new(unsigned int, const char *, int);
    static void *operator new(unsigned int, Grip::MemAddressStub *);
    static void *operator new(unsigned int, Grip::MemoryHeap *, int);
    static void *operator new(unsigned int, Grip::MemoryHeap *);
    static void *operator new(unsigned int);
    static void operator delete(void *, void *);
    static void operator delete(void *, Grip::MemAddressStub *, int, const char *, int);
    static void operator delete(void *, Grip::MemAddressStub *, const char *, int);
    static void operator delete(void *, Grip::MemAddressStub *, int);
    static void operator delete(void *, Grip::MemAddressStub *);
    static void operator delete(void *, Grip::MemoryHeap *, int, const char *, int);
    static void operator delete(void *, Grip::MemoryHeap *, const char *, int);
    static void operator delete(void *, Grip::MemoryHeap *, int);
    static void operator delete(void *, Grip::MemoryHeap *);
    static void operator delete(void *, int, const char *, int);
    static void operator delete(void *, const char *, int);
    static void operator delete(void *);
};

class GripAFAction : public GripVHeapObject  // size 0x1C, opaque
{
public:
    enum EGripAFActionStatus
    {
        AS_DONE = 0,
        AS_FAILURE = 1,
        AS_INPROGRESS = 2,
        AS_QUEUED = 3,
    };
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float) = 0;
    virtual const char *GetName();
    GripAFAction();
    virtual ~GripAFAction();
    GripAFAction::EGripAFActionStatus GetStatus();
    Grip_ArrayPOD<GripAFModifier *,2> &GetModifiers();
private:
    unsigned int GripAFActionData[0x6];
};

class CCSAFAction : public GripAFAction  // size 0x20, opaque
{
public:
    CCSAFAction();
private:
    unsigned int CCSAFActionData[0x1];
};

class CCSAFEncircleTarget : public CCSAFAction  // size 0x5C, opaque
{
protected:
    CCSAFEncircleTarget();
    void SetObjective(const CCSAOEncircleTarget &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    void UpdateGoal();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFEncircleTargetData[0xF];
};

class CCSAFEnterCover : public CCSAFAction  // size 0x58, opaque
{
protected:
    CCSAFEnterCover();
    void SetObjective(const CCSAOEnterCover &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFEnterCoverData[0xE];
};

class CCSAFExitCover : public CCSAFAction  // size 0x24, opaque
{
protected:
    CCSAFExitCover();
public:
    virtual void PostCreate();
    virtual void OnActivate();
    void SetObjective(const CCSAOExitCover &);
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFExitCoverData[0x1];
};

class CCSAFFireBurst : public CCSAFAction  // size 0x44, opaque
{
protected:
    CCSAFFireBurst();
    void SetObjective(const CCSAOFireBurst &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFFireBurstData[0x9];
};

class CCSAFFlee : public CCSAFAction  // size 0x58, opaque
{
protected:
    CCSAFFlee();
    void SetObjective(const CCSAOFlee &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    void UpdateMoveTarget();
    unsigned int CCSAFFleeData[0xE];
};

class CCSAFGetInCover : public CCSAFAction  // size 0x58, opaque
{
protected:
    CCSAFGetInCover();
    void SetObjective(const CCSAOGetInCover &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFGetInCoverData[0xE];
};

class CCSAFGetOutCover : public CCSAFAction  // size 0x58, opaque
{
protected:
    CCSAFGetOutCover();
    void SetObjective(const CCSAOGetOutCover &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFGetOutCoverData[0xE];
};

class CCSAFIdle : public CCSAFAction  // size 0x28, opaque
{
protected:
    CCSAFIdle();
public:
    virtual void PostCreate();
    virtual void Tick(float);
    void SetObjective(const CCSAOIdle &);
    virtual const char *GetName();
private:
    unsigned int CCSAFIdleData[0x2];
};

class CCSAFMoveTo : public CCSAFAction  // size 0x38, opaque
{
protected:
    CCSAFMoveTo();
    void SetObjective(const CCSAOMoveTo &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFMoveToData[0x6];
};

class CCSAFMoveToActor : public CCSAFAction  // size 0x5C, opaque
{
protected:
    CCSAFMoveToActor();
    void SetObjective(const CCSAOMoveToActor &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFMoveToActorData[0xF];
};

class CCSAFOrientToward : public CCSAFAction  // size 0x38, opaque
{
protected:
    CCSAFOrientToward();
    void SetObjective(const CCSAOOrientToward &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFOrientTowardData[0x6];
};

class CCSAFStrafeTarget : public CCSAFAction  // size 0x5C, opaque
{
protected:
    CCSAFStrafeTarget();
    void SetObjective(const CCSAOStrafeTarget &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    bool UpdateGoal();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFStrafeTargetData[0xF];
};

class CCSAFStrafeTo : public CCSAFAction  // size 0x38, opaque
{
protected:
    CCSAFStrafeTo();
    void SetObjective(const CCSAOStrafeTo &);
public:
    virtual void PostCreate();
    virtual void OnActivate();
    virtual bool TransitionTo(GripAFAction *);
    virtual void Tick(float);
    virtual const char *GetName();
private:
    unsigned int CCSAFStrafeToData[0x6];
};

class GripBlackboard : public GripVHeapObject  // size 0x8C, opaque
{
public:
    virtual void Reset();
    virtual void RegisterMembers();
    virtual GripBBVisualization *GetVisualizer() = 0;
    virtual void DrawHUD(GripHUDRenderer *, int &);
    GripBlackboard();
    void Initialize();
    void GetUsedPerceptionSystems(GripBTSystemFlags &, GripBTSystemFlags &);
    void AddMember(GripBBMember &);
    bool ContainState(const Grip::String) const;
    void AddState(const Grip::String);
    void RemoveState(const Grip::String);
    Grip_Array<Grip::String,Grip::AllocatorGH<Grip::String,2> > &GetStates();
    void ClearAllState();
    void FlagStatesAsUsed();
    bool AreStatesUsed() const;
    GripEvent GetLastValidEvent() const;
    void SetLastValidEvent(const GripEvent &);
    void ClearLastValidEvent();
    void FlagEventsAsUsed();
    bool IsDirty() const;
    void SetDirty();
    void ClearDirty();
private:
    unsigned int GripBlackboardData[0x22];
};

class CCSBlackboard : public GripBlackboard  // size 0x67C, opaque
{
public:
    enum EMoveCmd
    {
        MOVE_CMD_NONE = 0,
        MOVE_CMD_POS = 1,
    };
    CCSBlackboard();
    virtual void Reset();
    virtual void RegisterMembers();
    virtual GripBBVisualization *GetVisualizer();
    void ClearMoveCommand();
    void SetMoveCommand(Grip_Vector);
    CCSBlackboard::EMoveCmd GetMoveCommand() const;
    Grip_Vector GetMovePosition() const;
    void FlagMoveCommandAsUsed();
    void OnNewTarget(const CCSTarget &);
    void OnTargetDestroyed(int);
    void OnNewVehicle(const CCSTarget &);
    void OnVehicleDestroyed(int);
    void OnNewThreatTarget(const CCSTarget &);
    void OnThreatTargetDestroyed(int);
    void OnNewFriendly(const CCSTarget &);
    void OnFriendlyDestroyed(int);
    void OnNewCover(const CCSCover &);
    void OnCoverDestroyed(int);
    void FlagThreatLocationAsUsed();
    void FlagThreatDirectionAsUsed();
    Grip_Vector GetThreatLocation() const;
    Grip_Vector GetThreatDirection() const;
    EThreatType GetThreatType() const;
    CCSTarget *GetClosestVisibleEnemy();
    CCSTarget *GetClosestVisibleEnemy() const;
    void FlagClosestVisibleEnemyAsUsed();
    void UpdateTargetListsByRange(const Grip_Vector &, const float, const float);
    void SetHeatGenerated(float);
    float GetHeatGenerated() const;
    void FlagHeatGeneratedAsUsed();
    CCSTarget *GetHighestThreatTarget();
    void SetHighestThreatTarget(CCSTarget *);
    void FlagHighestThreatTarget();
    CCSTarget *GetClosestEnemy();
    void SetClosestEnemy(CCSTarget *);
    void FlagClosestEnemy();
    void SetClosestVisibleEnemy(CCSTarget *);
    void FlagClosestVisibleEnemy();
    CCSTarget *GetCurrentTarget();
    void SetCurrentTarget(CCSTarget *);
    void FlagCurrentTarget();
    CCSTarget *GetLowestLKPAgeEnemy();
    void SetLowestLKPAgeEnemy(CCSTarget *);
    void FlagLowestLKPAgeEnemy();
    CCSTarget *GetClosestObjective();
    void SetClosestObjective(CCSTarget *);
    void FlagClosestObjective();
    CCSTarget *GetReactiveTarget();
    void SetReactiveTarget(CCSTarget *);
    void FlagReactiveTarget();
    CCSTarget *GetSecondaryTarget();
    void SetSecondaryTarget(CCSTarget *);
    void FlagSecondaryTarget();
    bool GetHasBecomeAware();
    void SetHasBecomeAware(bool);
    void FlagHasBecomeAware();
private:
    void UpdateTargetPointers();
public:
    CCSTarget *GetSpecificTarget(FString);
    FVector GetCurrentTether();
private:
    unsigned int CCSBlackboardData[0x17C];
};

struct CCSController_eventActionStopFiring_Parms  // size 0x1
{
public:
    CCSController_eventActionStopFiring_Parms(EEventParm);
};

struct CCSController_eventAimAt_Parms  // size 0x4
{
public:
    CCSController_eventAimAt_Parms(EEventParm);
    AActor *newFocus;  // 0x0
};

struct CCSController_eventCanFireAt_Parms  // size 0x8
{
public:
    CCSController_eventCanFireAt_Parms(EEventParm);
    AActor *Target;  // 0x0
    unsigned int ReturnValue;  // 0x4
};

struct CCSController_eventCreateDebugVizComponent_Parms  // size 0x1
{
public:
    CCSController_eventCreateDebugVizComponent_Parms(EEventParm);
};

struct CCSController_eventFindNavMeshDistance_Parms  // size 0x14
{
public:
    CCSController_eventFindNavMeshDistance_Parms(EEventParm);
    FVector targetPos;  // 0x0
    float Distance;  // 0xC
    unsigned int ReturnValue;  // 0x10
};

struct CCSController_eventFindNavMeshPath_Parms  // size 0x10
{
public:
    CCSController_eventFindNavMeshPath_Parms(EEventParm);
    FVector targetPos;  // 0x0
    unsigned int ReturnValue;  // 0xC
};

struct CCSController_eventFireWeapon_Parms  // size 0x10
{
public:
    CCSController_eventFireWeapon_Parms(EEventParm);
    unsigned int charge;  // 0x0
    unsigned int lastShot;  // 0x4
    unsigned int alwaysFire;  // 0x8
    unsigned int ReturnValue;  // 0xC
};

struct CCSController_eventNotifyAIMoveToActorCompleted_Parms  // size 0x1
{
public:
    CCSController_eventNotifyAIMoveToActorCompleted_Parms(EEventParm);
};

struct CCSController_eventStartFireBurstObj_Parms  // size 0x8
{
public:
    CCSController_eventStartFireBurstObj_Parms(EEventParm);
    AActor *Target;  // 0x0
    unsigned int ReturnValue;  // 0x4
};

struct CCSController_eventStartFireBurst_Parms  // size 0x8
{
public:
    CCSController_eventStartFireBurst_Parms(EEventParm);
    APawn *Target;  // 0x0
    unsigned int ReturnValue;  // 0x4
};

struct CCSController_eventStopFireBurst_Parms  // size 0x4
{
public:
    CCSController_eventStopFireBurst_Parms(EEventParm);
    unsigned int ReturnValue;  // 0x0
};

template <> class TArray<ActorWrapper *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<ActorWrapper *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    ActorWrapper *const *GetTypedData() const;
    ActorWrapper **GetTypedData();
    ActorWrapper *const *GetData() const;
    ActorWrapper **GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    ActorWrapper *const &operator()(int) const;
    ActorWrapper *&operator()(int);
    ActorWrapper *Pop();
    void Push(ActorWrapper *const &);
    ActorWrapper *const &Top() const;
    ActorWrapper *&Top();
    ActorWrapper *const &Last(int) const;
    ActorWrapper *&Last(int);
    void Shrink();
    unsigned int FindItem(ActorWrapper *const &, int &) const;
    int FindItemIndex(ActorWrapper *const &) const;
    unsigned int ContainsItem(ActorWrapper *const &) const;
    unsigned int operator==(const TArray<ActorWrapper *,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<ActorWrapper *,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(ActorWrapper *const &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<ActorWrapper *,FDefaultAllocator> &);
    TArray<ActorWrapper *,FDefaultAllocator> &operator+=(const TArray<ActorWrapper *,FDefaultAllocator> &);
    TArray<ActorWrapper *,FDefaultAllocator> &operator=(const TArray<ActorWrapper *,FDefaultAllocator> &);
    int AddItem(ActorWrapper *const &);
    int AddZeroed(int);
    int AddUniqueItem(ActorWrapper *const &);
    void Reserve(int);
    void Init(ActorWrapper *const &, int);
    void Init(int);
    int RemoveSingleItem(ActorWrapper *const &);
    int RemoveItem(ActorWrapper *const &);
    int RemoveSingleItemSwap(ActorWrapper *const &);
    int RemoveItemSwap(ActorWrapper *const &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    ActorWrapper *const &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

template <> class TArray<CCSGameCover,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<CCSGameCover,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    const CCSGameCover *GetTypedData() const;
    CCSGameCover *GetTypedData();
    const CCSGameCover *GetData() const;
    CCSGameCover *GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    const CCSGameCover &operator()(int) const;
    CCSGameCover &operator()(int);
    CCSGameCover Pop();
    void Push(const CCSGameCover &);
    const CCSGameCover &Top() const;
    CCSGameCover &Top();
    const CCSGameCover &Last(int) const;
    CCSGameCover &Last(int);
    void Shrink();
    unsigned int FindItem(const CCSGameCover &, int &) const;
    int FindItemIndex(const CCSGameCover &) const;
    unsigned int ContainsItem(const CCSGameCover &) const;
    unsigned int operator==(const TArray<CCSGameCover,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<CCSGameCover,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(const CCSGameCover &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<CCSGameCover,FDefaultAllocator> &);
    TArray<CCSGameCover,FDefaultAllocator> &operator+=(const TArray<CCSGameCover,FDefaultAllocator> &);
    TArray<CCSGameCover,FDefaultAllocator> &operator=(const TArray<CCSGameCover,FDefaultAllocator> &);
    int AddItem(const CCSGameCover &);
    int AddZeroed(int);
    int AddUniqueItem(const CCSGameCover &);
    void Reserve(int);
    void Init(const CCSGameCover &, int);
    void Init(int);
    int RemoveSingleItem(const CCSGameCover &);
    int RemoveItem(const CCSGameCover &);
    int RemoveSingleItemSwap(const CCSGameCover &);
    int RemoveItemSwap(const CCSGameCover &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    const CCSGameCover &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

class CCSNorman  // size 0x2C
{
private:
    CCSNorman();
public:
    void reset();
    static CCSNorman *getInstance();
    void AddTarget(AActor *);
    void RemoveTarget(AActor *);
    void AddTargeter(CCSPSTargetAwareness *);
    void RemoveTargeter(CCSPSTargetAwareness *);
    void AddCover(ACoverLink *);
    void RemoveCover(ACoverLink *);
    void AddCoverSeeker(CCSPSCover *);
    void RemoveCoverSeeker(CCSPSCover *);
    ACoverLink *GetDestructibleCoverList(AUDKCover *);
    void CountBrainlessCover(AUDKPawn *);
    void VacateAllBrainlessCover(AUDKPawn *);
    bool IsAlertedEnemyInRange(AActor *, float);
private:
    static CCSNorman *instance;
public:
    CCSPSTargetAwareness *pFirstTargeter;  // 0x0
    TArray<ActorWrapper *,FDefaultAllocator> m_ThreatTargetsMasterList;  // 0x4
    CCSPSCover *pFirstCoverSeeker;  // 0x10
    TArray<CCSGameCover,FDefaultAllocator> m_CoverMasterList;  // 0x14
    int m_ThreatTargetsMasterListRefCount;  // 0x20
    int m_CoverMasterListRefCount;  // 0x24
    ACoverLink *FirstCoverLink;  // 0x28
};

class GripBrainSystem : public GripVHeapObject  // size 0xC, opaque
{
public:
    enum EActivationState
    {
        AS_ACTIVE = 0,
        AS_INACTIVE = 1,
        AS_DEACTIVATING = 2,
    };
    virtual void Initialize(const GripSystemConfig *);
    virtual void Finalize();
    virtual void FlagAsUsed();
    virtual void Activate();
    virtual void Deactivate();
    virtual void Tick(float) = 0;
    virtual bool TickBudget(float, int &);
    virtual int GetId() const;
    virtual int GetFamily() const;
    virtual void DrawHUD(GripHUDRenderer *, int &);
    virtual void DrawScene(IGripSceneRenderer *);
    GripBrainSystem();
    virtual ~GripBrainSystem();
    GripBrainSystem::EActivationState GetState() const;
    bool IsInStasis() const;
    bool IsUsed() const;
    void OnTickCycleCompleted();
private:
    unsigned int GripBrainSystemData[0x2];
};

class CCSSensorSystem : public GripBrainSystem  // size 0x10, opaque
{
public:
    enum EType
    {
        SST_SELF_AWARENESS = 0,
        SST_TARGET_AWARENESS = 1,
        SST_COVER = 2,
        SST_NUM_OF = 3,
    };
    CCSSensorSystem(CCSBrain *);
    virtual void Initialize(const GripSystemConfig *);
    static int SGetFamily();
    virtual int GetFamily() const;
    void BecomeAware(bool);
    void AlertFriends();
private:
    unsigned int CCSSensorSystemData[0x1];
};

struct GripSystemConfig : public GripVHeapObject  // size 0x4, opaque
{
};

struct CCSSystemsConfig : public GripSystemConfig  // size 0x34, opaque
{
private:
    unsigned int CCSSystemsConfigData[0xC];
};

class CCSPSCover : public CCSSensorSystem  // size 0x50
{
public:
    CCSPSCover(CCSBrain *);
    virtual ~CCSPSCover();
    virtual void Initialize(const GripSystemConfig *);
    virtual void Finalize();
    void AddCover(ACoverLink *);
    void AddCover(CCSGameCover &);
    void RemoveCover(ACoverLink *);
    void RemoveCover(CCSGameCover &);
    virtual void Tick(float);
    virtual bool TickBudget(float, int &);
    static int SGetId();
    virtual int GetId() const;
private:
    void LowCostPerception();
    void ResetCoverForLowCostPerception();
    void ComputeDistanceToTarget();
    bool DisabledCulling(CCSCover &);
    bool OccupiedCulling(CCSCover &);
    bool DistanceCulling(CCSCover &);
    bool DefensiveAngleCulling(CCSCover &);
    bool AttackAngleCulling(CCSCover &);
    bool PathCulling(CCSCover &);
    void UpdateFromGlobalData();
    bool HighCostPerception(int &);
    bool HasValidDefensiveAngle(const float, const float, const Grip_Vector, const Grip_Rotation &, const CCSTarget *);
    bool HasValidAttackAngle(ICCSMeatPuppet *, const CCSCover &, const Grip_Rotation &, const CCSTarget *);
    float GetCurrentTargetDistance(const CCSCover &);
public:
    CCSPSCover *pNextCoverSeeker;  // 0x10
    int m_coverIdx;  // 0x14
    CCSSystemsConfig m_config;  // 0x18
    CCSCoverRenderingComponent *m_pDebugComponent;  // 0x4C
};

template <> class Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > : public GripVHeapObject  // size 0x10, opaque
{
public:
    Grip_Array(const Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > &);
    Grip_Array(const int);
    virtual ~Grip_Array();
    Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > &operator=(const Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > &);
    void Clone(const Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > &);
    void Empty();
    void Reset();
    void Reserve(int);
    int FindObject(const CCSCharacter &) const;
    bool ContainsItem(const CCSCharacter &) const;
    int Num() const;
    const CCSCharacter &operator[](int) const;
    CCSCharacter &operator[](int);
    void AddItem(const CCSCharacter &);
    void AddUniqueItem(const CCSCharacter &);
    void InsertItemAt(const CCSCharacter &, int);
    void RemoveItemSwap(int);
    void RemoveItem(int);
    void RemoveItemItem(const CCSCharacter &);
    CCSCharacter *GetData();
protected:
    void CloneContainer(CCSCharacter *, int, int);
    void DestructItems(int, int);
    void ResizeTo(int);
    void DeleteContainerContent();
public:
    static const int increment;
private:
    unsigned int Grip_ArrayData[0x3];
};

class CCSPSTargetAwareness : public CCSSensorSystem  // size 0x5C
{
public:
    struct Config  // size 0x28, opaque
    {
    public:
        Config();
    private:
        unsigned int ConfigData[0xA];
    };
    CCSPSTargetAwareness(CCSBrain *);
    virtual void Initialize(const GripSystemConfig *);
    virtual void Finalize();
    virtual void Tick(float);
    virtual bool TickBudget(float, int &);
    static int SGetId();
    virtual int GetId() const;
    void AddThreatTarget(AActor *);
    void RemoveThreatTarget(AActor *);
private:
    void UpdateTargetList();
    void UpdateTargetListsByRange();
    void ComputeLowCostAwareness(float);
    void ComputeHighCostAwareness(float, CCSTarget &);
    bool IsTargetHeard(const CCSTarget &, ICCSMeatPuppet *);
    bool IsTargetVisible(const CCSTarget &, ICCSMeatPuppet *);
    bool IsEnemy(CCSBlackboard *, ICCSMeatPuppet *);
    bool TargetPlayers();
    bool TargetNPCs();
    bool TargetObjectives();
    void UpdateClosestVisibleEnemy();
    void UpdateLowestLKPAgeEnemy();
    void NotifyTargetBecameVisible(CCSTarget &);
    void UpdateHighestThreatTarget(float);
    int ComputeTotalThreat(CCSTarget &, float);
    void UpdateCurrentTarget();
    void AlertFriends();
public:
    CCSPSTargetAwareness *pNextTargeter;  // 0x10
    int m_targetIdx;  // 0x14
    int m_vehicleIdx;  // 0x18
    bool m_curTargetIsCamoed;  // 0x1C
    char _pad0[0x3];
    CCSPSTargetAwareness::Config m_config;  // 0x20
    Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > m_vehicles;  // 0x48
    CCSTargetRenderingComponent *m_pDebugComponent;  // 0x58
};

class GripRBTNode : public GripVHeapObject  // size 0x64, opaque
{
public:
    enum
    {
        MAX_NB_CHILDREN = 16,
    };
    enum EBTEvaluationResult
    {
        EVR_READY = 0,
        EVR_NOT_READY = 1,
        EVR_OVER = 2,
        EVR_MAX = 3,
    };
    enum EBTExecutionResult
    {
        ER_SUCCESS = 0,
        ER_FAILURE = 1,
        ER_INPROGRESS = 2,
        ER_INTERRUPTING = 3,
        ER_SUCCESSFULLY_INTERRUPTED = 4,
        ER_READY = 5,
        ER_NOT_READY = 6,
        ER_MAX = 7,
    };
    virtual void GripBTInitialize();
    virtual void Delete();
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTEvaluationResult EvaluateInternal(IGripBTInterface *, GripBTStack *);
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual void GameEventRegistration(GripGameEventHandler &);
public:
    virtual void SurveyUsedBBMembers(GripBlackboard *);
    virtual void GetUsedControlSystems(GripBTSystemFlags &);
    virtual GripRBTNode::EBTEvaluationResult Evaluate(IGripBTInterface *, GripBTStack *);
    virtual GripRBTNode::EBTExecutionResult Execute(IGripBTInterface *, GripBTStack *, bool);
    virtual EGripBTNodeType GetType();
    virtual EGripBTNodeFamily GetFamily();
    virtual float GetWeight(IGripBTInterface *);
    GripRBTNode();
    virtual ~GripRBTNode();
    void InitiateGameEventRegistration(GripGameEventHandler &);
    int GetChildCount() const;
    bool AddChild(GripRBTNode *);
    GripRBTNode *GetChild(const int);
    GripRBTNode::EBTExecutionResult GetLastExecutionResult() const;
    GripRBTNode::EBTEvaluationResult GetLastEvaluationResult() const;
    static bool IsExecuting(GripRBTNode::EBTExecutionResult);
    bool IsExecuting() const;
    void SetWeight(float);
    int GetCardinality() const;
    void SetAsContextSwitch(bool);
    bool IsContextSwitch() const;
    static void *operator new(unsigned int);
    static void operator delete(void *);
    void Serialize(GripSerializer *);
private:
    Grip::String GetNodeTypeLabel();
public:
    GripRBTNode::EBTExecutionResult GetExecutionResultVisualization() const;
    Grip::String GetName() const;
    int GetNodeID() const;
    void SetName(Grip::String);
    Grip::String GetJSONRepresentation();
protected:
    static int ms_IDCounter;
    static GripRBTAllocator *ms_pAllocator;
private:
    unsigned int GripRBTNodeData[0x18];
};

class GripRBTBehavior : public GripRBTNode  // size 0x64, opaque
{
public:
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
    virtual bool TestPreCondition(IGripBTInterface *);
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
    virtual EGripBTNodeType GetType();
    virtual EGripBTNodeFamily GetFamily();
};

class CCSRBTEncircleTarget : public GripRBTBehavior  // size 0x84, opaque
{
public:
    enum EBTEncircleTargetShootState
    {
        EBTEncircleTargetShootState_Init = 0,
        EBTEncircleTargetShootState_Shooting = 1,
        EBTEncircleTargetShootState_Delay = 2,
        EBTEncircleTargetShootState_Done = 3,
    };
    CCSRBTEncircleTarget();
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetFireChance(float);
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetDirectionFlags(bool, bool);
    void SetForceFire(bool);
private:
    unsigned int CCSRBTEncircleTargetData[0x8];
};

class GripRBTCondition : public GripRBTNode  // size 0x64, opaque
{
public:
    enum EOperator
    {
        LESS_THAN = 0,
        LESS_THAN_OR_EQUAL_TO = 1,
        EQUAL_TO = 2,
        NOT_EQUAL_TO = 3,
        GREATER_THAN = 4,
        GREATER_THAN_OR_EQUAL_TO = 5,
        BTConditionOperator_MAX = 6,
    };
    virtual EGripBTNodeType GetType();
    virtual EGripBTNodeFamily GetFamily();
protected:
    virtual GripRBTNode::EBTEvaluationResult EvaluateInternal(IGripBTInterface *, GripBTStack *);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
};

class GripRBTBooleanCondition : public GripRBTCondition  // size 0x68, opaque
{
public:
    GripRBTBooleanCondition();
    void SetNegate(bool);
private:
    unsigned int GripRBTBooleanConditionData[0x1];
};

class CCSRBTEnemyAware : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

template <> class GripRBTNumericCondition<int> : public GripRBTCondition  // size 0x70
{
public:
    GripRBTNumericCondition();
    virtual bool TestPreCondition(IGripBTInterface *);
    void SetOperator(GripRBTCondition::EOperator);
    void SetThreshold(int);
    void SetValue(int);
    GripRBTCondition::EOperator m_operator;  // 0x64
    int m_threshold;  // 0x68
    int m_value;  // 0x6C
};

class CCSRBTEnemyClosestRange : public GripRBTNumericCondition<int>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

template <> class GripRBTNumericCondition<float> : public GripRBTCondition  // size 0x70
{
public:
    GripRBTNumericCondition();
    virtual bool TestPreCondition(IGripBTInterface *);
    void SetOperator(GripRBTCondition::EOperator);
    void SetThreshold(float);
    void SetValue(float);
    GripRBTCondition::EOperator m_operator;  // 0x64
    float m_threshold;  // 0x68
    float m_value;  // 0x6C
};

class CCSRBTEnemyLowestLKPAge : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTMoveTo : public GripRBTBehavior  // size 0xA4, opaque
{
public:
    enum EBTMoveToShootState
    {
        EBTMoveToShootState_Init = 0,
        EBTMoveToShootState_Shooting = 1,
        EBTMoveToShootState_Delay = 2,
        EBTMoveToShootState_Done = 3,
    };
    CCSRBTMoveTo();
    virtual void FlagUsedBBMembers(GripBlackboard *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetSpeed(CCS::EMovementSpeed);
    void SetAlertness(CCS::EAlertnessState);
    void SetMovementType(CCS::EMovementType);
    void SetFireChance(float);
    void SetChargedShotChance(float);
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetPrimaryAttackRange(float);
    void SetSecondaryAttackRange(float);
    void SetPrimaryTargetWeight(float);
    void SetPlayerTargetWeight(float);
    void SetReactiveTargetWeight(float);
    void SetObjectiveTargetWeight(float);
private:
    CCSTarget *GetSecondaryTarget(IGripBTInterface *);
    unsigned int CCSRBTMoveToData[0x10];
};

class CCSRBTMoveToCover : public CCSRBTMoveTo  // size 0xD4, opaque
{
public:
    enum EMoveToCoverState
    {
        MoveToCover_Waiting = 0,
        MoveToCover_Moving = 1,
        MoveToCover_TakingCover = 2,
        MoveToCover_ExitingCover = 3,
    };
protected:
    virtual CCSCover FindBestCover(IGripBTInterface *) const;
public:
    CCSRBTMoveToCover();
protected:
    GripRBTNode::EBTExecutionResult StartMoveToCover(IGripBTInterface *);
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
    bool MovingToCover(CCSBlackboard *);
    void EnterCover(CCSBlackboard *, CCSAFFactory *, GripAFScheduler *);
    void ExitCover(CCSAFFactory *, GripAFScheduler *);
private:
    unsigned int CCSRBTMoveToCoverData[0xC];
};

class CCSRBTMoveToBestCover : public CCSRBTMoveToCover  // size 0xDC, opaque
{
public:
    CCSRBTMoveToBestCover();
    virtual void FlagUsedBBMembers(GripBlackboard *);
protected:
    virtual CCSCover FindBestCover(IGripBTInterface *) const;
public:
    void SetIdealShootingDistance(float);
    void SetExcludeCurrentCover(bool);
private:
    unsigned int CCSRBTMoveToBestCoverData[0x2];
};

class CCSRBTMoveToClosestCover : public CCSRBTMoveToCover  // size 0xD4, opaque
{
public:
    CCSRBTMoveToClosestCover();
protected:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual CCSCover FindBestCover(IGripBTInterface *) const;
};

class CCSRBTMoveToInitialCover : public CCSRBTMoveToCover  // size 0xD4, opaque
{
protected:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual CCSCover FindBestCover(IGripBTInterface *) const;
};

class CCSRBTMoveToTether : public CCSRBTMoveTo  // size 0xE0, opaque
{
public:
    CCSRBTMoveToTether();
    virtual bool TestPreCondition(IGripBTInterface *);
    virtual void FlagUsedBBMembers(GripBlackboard *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    void StartMoveToSeat(IGripBTInterface *);
    void UpdateTetherTarget(AActor *);
    bool TetherIsInVehicle();
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
private:
    unsigned int CCSRBTMoveToTetherData[0xF];
};

class CCSRBTSearch : public CCSRBTMoveTo  // size 0xD0, opaque
{
public:
    enum ESearch
    {
        Search_MovingToLKP = 0,
        Search_MovingToRandomLocation = 1,
    };
    CCSRBTSearch();
    virtual bool TestPreCondition(IGripBTInterface *);
    virtual void FlagUsedBBMembers(GripBlackboard *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
private:
    void MoveToLKP(IGripBTInterface *);
    void MoveToRandomLocation(IGripBTInterface *);
    void FindNavigationPoints();
    unsigned int CCSRBTSearchData[0xB];
};

class CCSRBTSelectTarget : public GripRBTBehavior  // size 0x74, opaque
{
public:
    enum EAlgorithm
    {
        Algorithm_Closest = 0,
        Algorithm_Closest_Objective = 1,
        Algorithm_Closest_Reactive_Target = 2,
        Algorithm_Specific_Tag = 3,
        Algorithm_Highest_Threat = 4,
        Algorithm_Closest_Entry_Vehicle = 5,
        Algorithm_None = 6,
    };
    CCSRBTSelectTarget();
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
public:
    void SetSelectionAlgo(CCSRBTSelectTarget::EAlgorithm);
    void SetTargetName(FString);
private:
    unsigned int CCSRBTSelectTargetData[0x4];
};

class CCSRBTShoot : public GripRBTBehavior  // size 0x80, opaque
{
public:
    enum EBTShootState
    {
        BTShootState_Init = 0,
        BTShootState_Shooting = 1,
        BTShootState_Delay = 2,
    };
    CCSRBTShoot();
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
public:
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetChargedShotChance(float);
private:
    unsigned int CCSRBTShootData[0x7];
};

class CCSRBTShootFromCover : public GripRBTBehavior  // size 0x84, opaque
{
public:
    enum EBTCoverShootState
    {
        BTCoverShootState_Init = 0,
        BTCoverShootState_Hiding = 1,
        BTCoverShootState_GettingOutCover = 2,
        BTCoverShootState_Shooting = 3,
        BTCoverShootState_ShootingDelay = 4,
        BTCoverShootState_ReturningToCover = 5,
        BTCoverShootState_ExitingCover = 6,
    };
    CCSRBTShootFromCover();
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
private:
    int GetInCover(CCSTarget *, CCSCover *, CCSAFFactory *, GripAFScheduler *);
    int GetOutCover(CCSTarget *, CCSCover *, CCSAFFactory *, GripAFScheduler *);
    int ExitCover(CCSAFFactory *, GripAFScheduler *);
    int FireBurst(CCSAOFireBurst &, CCSAFFactory *, GripAFScheduler *);
    unsigned int CCSRBTShootFromCoverData[0x8];
};

class CCSRBTStrafeTarget : public GripRBTBehavior  // size 0x88, opaque
{
public:
    enum EBTStrafeTargetShootState
    {
        EBTStrafeTargetShootState_Init = 0,
        EBTStrafeTargetShootState_Shooting = 1,
        EBTStrafeTargetShootState_Delay = 2,
        EBTStrafeTargetShootState_Done = 3,
    };
    CCSRBTStrafeTarget();
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    virtual void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetFireChance(float);
    void SetChargedShotChance(float);
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetDirectionFlags(bool, bool, bool, bool);
    CCSTarget *GetSecondaryTarget(IGripBTInterface *);
private:
    unsigned int CCSRBTStrafeTargetData[0x9];
};

class CCSRBTTargetAngle : public GripRBTBooleanCondition  // size 0x6C, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
    void SetActiveZones(bool, bool, bool, bool);
private:
    unsigned int CCSRBTTargetAngleData[0x1];
};

class CCSRBTTargetClear : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetInCover : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetKnockedDown : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetRange : public GripRBTNumericCondition<int>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetShootable : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetVisible : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceAimedAt : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceBecameAware : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceDamage : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceEvent : public GripRBTNumericCondition<float>  // size 0x7C, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
    void SetEventType(EEventType);
    void SetActorClass(UClass *);
    void SetMaxDistance(float);
private:
    unsigned int CCSRBTTimeSinceEventData[0x3];
};

class CCSRBTTimeSinceGrenadeStuck : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceStaggered : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceSuccessfulAttack : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceTargetCamoed : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceThreatChanged : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceThreatened : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTVisibleToPlayerCamera : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    virtual void FlagUsedBBMembers(GripBlackboard *);
    virtual bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTWaitInCover : public GripRBTBehavior  // size 0x64, opaque
{
public:
    CCSRBTWaitInCover();
    virtual bool TestPreCondition(IGripBTInterface *);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
};

struct CoverLink_eventSetDisabled_Parms  // size 0x4
{
public:
    CoverLink_eventSetDisabled_Parms(EEventParm);
    unsigned int bNewDisabled;  // 0x0
};

class FOutputDevice  // size 0x10, opaque
{
public:
    virtual ~FOutputDevice();
    virtual void Serialize(const wchar_t *, EName);
    virtual void Flush();
    virtual void TearDown();
    FOutputDevice(unsigned int);
    void SetSuppressEventTag(unsigned int);
    unsigned int GetSuppressEventTag();
    void SetAutoEmitLineTerminator(unsigned int);
    unsigned int GetAutoEmitLineTerminator();
    void Log(EName, const FString &);
    void Log(const FString &);
    void Log(EName, const wchar_t *);
    void Log(const wchar_t *);
    void Logf__VA(EName, const wchar_t *, ...);
    void Logf__VA(const wchar_t *, ...);
    void Logf(EName, const wchar_t *);
    void Logf(const wchar_t *);
private:
    unsigned int FOutputDeviceData[0x3];
};

struct FFrame : public FOutputDevice  // size 0x28
{
public:
    FFrame(UObject *, UStruct *, int, void *, FFrame *);
    FFrame(UObject *);
    virtual ~FFrame();
    void Step(UObject *, void *const);
    virtual void Serialize(const wchar_t *, EName);
    int ReadInt();
    float ReadFloat();
    FName ReadName();
    UObject *ReadObject();
    int ReadWord();
    unsigned short ReadCodeSkipCount();
    unsigned short ReadVariableSize(UField **);
    FString GetStackTrace() const;
    UStruct *Node;  // 0x10
    UObject *Object;  // 0x14
    unsigned char *Code;  // 0x18
    unsigned char *Locals;  // 0x1C
    FFrame *PreviousFrame;  // 0x20
    FOutParmRec *OutParms;  // 0x24
};

namespace Grip {
template <> struct ListNode<Grip::MemoryHeap>  // size 0x8, opaque
{
public:
    void RemoveNode();
    void ReplaceNodeWith(Grip::MemoryHeap *);
    void InsertNodeAfter(Grip::MemoryHeap *);
    void InsertNodeBefore(Grip::MemoryHeap *);
    void Alloc_MoveTo(Grip::ListNode<Grip::MemoryHeap> *);
private:
    unsigned int ListNodeData[0x2];
};
}

namespace Grip {
class Memory  // size 0x1, opaque
{
public:
    static void SetGlobalHeap(Grip::MemoryHeap *);
    static Grip::MemoryHeap *GetGlobalHeap();
    static void CreateArena(unsigned int, Grip::SysAllocPaged *);
    static void DestroyArena(unsigned int);
    static bool ArenaIsEmpty(unsigned int);
    static void *Alloc(unsigned int, unsigned int, const Grip::AllocInfo &);
    static void *Alloc(unsigned int, const Grip::AllocInfo &);
    static void *Alloc(unsigned int, unsigned int);
    static void *Alloc(unsigned int);
    static void *AllocAutoHeap(const void *, unsigned int, unsigned int, const Grip::AllocInfo &);
    static void *AllocAutoHeap(const void *, unsigned int, const Grip::AllocInfo &);
    static void *AllocAutoHeap(const void *, unsigned int, unsigned int);
    static void *AllocAutoHeap(const void *, unsigned int);
    static void *AllocInHeap(Grip::MemoryHeap *, unsigned int, unsigned int, const Grip::AllocInfo &);
    static void *AllocInHeap(Grip::MemoryHeap *, unsigned int, const Grip::AllocInfo &);
    static void *AllocInHeap(Grip::MemoryHeap *, unsigned int, unsigned int);
    static void *AllocInHeap(Grip::MemoryHeap *, unsigned int);
    static void *Realloc(void *, unsigned int);
    static void Free(void *);
    static Grip::MemoryHeap *GetHeapByAddress(const void *);
    static bool DetectMemoryLeaks();
    static Grip::MemoryHeap *pGlobalHeap;
};
}

namespace Grip {
class MemoryHeap : public Grip::ListNode<Grip::MemoryHeap>  // size 0x6C, opaque
{
public:
    enum MemReportType
    {
        MemReportBrief = 0,
        MemReportFull = 1,
        MemReportFileSummary = 2,
        MemReportHeapDetailed = 3,
    };
    enum HeapFlags
    {
        Heap_ThreadUnsafe = 1,
        Heap_FastTinyBlocks = 2,
        Heap_FixedGranularity = 4,
        Heap_Root = 8,
        Heap_NoDebugInfo = 16,
        Heap_UserDebug = 4096,
    };
    enum RootHeapParameters
    {
        RootHeap_MinAlign = 16,
        RootHeap_Granularity = 16384,
        RootHeap_Reserve = 16384,
        RootHeap_Threshold = 262144,
        RootHeap_Limit = 0,
    };
    struct HeapDesc;
    struct HeapInfo;
    struct HeapVisitor;
    struct LimitHandler;
    struct HeapTracer;
    struct RootStats;
protected:
    virtual ~MemoryHeap();
public:
    virtual void CreateArena(unsigned int, Grip::SysAllocPaged *) = 0;
    virtual void DestroyArena(unsigned int) = 0;
    virtual bool ArenaIsEmpty(unsigned int) = 0;
    virtual Grip::MemoryHeap *CreateHeap(const char *, const Grip::MemoryHeap::HeapDesc &) = 0;
    virtual void SetLimitHandler(Grip::MemoryHeap::LimitHandler *) = 0;
    virtual void SetLimit(unsigned int) = 0;
    virtual void AddRef() = 0;
    virtual void Release() = 0;
    virtual void *Alloc(unsigned int, const Grip::AllocInfo *) = 0;
    virtual void *Alloc(unsigned int, unsigned int, const Grip::AllocInfo *) = 0;
    virtual void *Realloc(void *, unsigned int) = 0;
    virtual void Free(void *) = 0;
    virtual void *AllocAutoHeap(const void *, unsigned int, const Grip::AllocInfo *) = 0;
    virtual void *AllocAutoHeap(const void *, unsigned int, unsigned int, const Grip::AllocInfo *) = 0;
    virtual Grip::MemoryHeap *GetAllocHeap(const void *) = 0;
    virtual unsigned int GetUsableSize(const void *) = 0;
    virtual void *AllocSysDirect(unsigned int) = 0;
    virtual void FreeSysDirect(void *, unsigned int) = 0;
    virtual bool GetStats(Grip::StatBag *) = 0;
    virtual unsigned int GetFootprint() const = 0;
    virtual unsigned int GetTotalFootprint() const = 0;
    virtual unsigned int GetUsedSpace() const = 0;
    virtual unsigned int GetTotalUsedSpace() const = 0;
    virtual void GetRootStats(Grip::MemoryHeap::RootStats *) = 0;
    virtual void VisitMem(Grip::Heap::MemVisitor *, unsigned int) = 0;
    virtual void VisitRootSegments(Grip::Heap::SegVisitor *) = 0;
    virtual void VisitHeapSegments(Grip::Heap::SegVisitor *) const = 0;
    virtual void SetTracer(Grip::MemoryHeap::HeapTracer *) = 0;
protected:
    virtual void destroyItself() = 0;
    virtual void ultimateCheck() = 0;
    virtual void releaseCachedMem() = 0;
    virtual bool dumpMemoryLeaks() = 0;
    virtual void checkIntegrity() const = 0;
    virtual void getUserDebugStats(Grip::MemoryHeap::RootStats *) const = 0;
    MemoryHeap();
public:
    static void InitPT(Grip::SysAllocPaged *);
    static void InitMH(Grip::SysAlloc *);
    static void CleanUpPT();
    static void CleanUpMH();
    static Grip::MemoryHeap *CreateRootHeapPT(const Grip::MemoryHeap::HeapDesc &);
    static Grip::MemoryHeap *CreateRootHeapPT();
    static Grip::MemoryHeap *CreateRootHeapMH(const Grip::MemoryHeap::HeapDesc &);
    static Grip::MemoryHeap *CreateRootHeapMH();
    static void ReleaseRootHeapPT();
    static void ReleaseRootHeapMH();
    Grip::MemoryHeap *CreateHeap(const char *, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int);
    void GetHeapInfo(Grip::MemoryHeap::HeapInfo *) const;
    const char *GetName() const;
    unsigned int GetId() const;
    Grip::MemoryHeap *GetParentHeap() const;
    unsigned int GetFlags() const;
    unsigned int GetGranularity() const;
    unsigned int GetLimit() const;
    bool IsThreadSafe() const;
    void ReleaseOnFree(void *);
    void AssignToCurrentThread();
    void MemReport(Grip::MemItem *, Grip::MemoryHeap::MemReportType);
    void MemReport(Grip::StringBuffer &, Grip::MemoryHeap::MemReportType, bool);
    bool DumpMemoryLeaks();
    void UltimateCheck();
    void VisitChildHeaps(Grip::MemoryHeap::HeapVisitor *);
    void LockAndVisit(Grip::MemoryHeap::HeapVisitor *);
    void CheckIntegrity();
    void ReleaseCachedMem();
private:
    unsigned int MemoryHeapData[0x18];
};
}

struct GripBTScriptNodeCache_eventCacheAllConditions_Parms  // size 0x4
{
public:
    GripBTScriptNodeCache_eventCacheAllConditions_Parms(EEventParm);
    UGripBTInterface *BTInterface;  // 0x0
};

struct GripBTScriptNodeCache_eventInitializeAllNodes_Parms  // size 0x1
{
public:
    GripBTScriptNodeCache_eventInitializeAllNodes_Parms(EEventParm);
};

struct GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms  // size 0x4
{
public:
    GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms(EEventParm);
    UGripBlackboard *Blackboard;  // 0x0
};

class GripRBTAllocator : public GripVHeapObject  // size 0x10, opaque
{
public:
    virtual void *AllocateAlign(unsigned int);
    GripRBTAllocator();
    virtual ~GripRBTAllocator();
    bool Reserve(unsigned int);
private:
    void DeleteMemoryBlock();
public:
    unsigned int GetAlignedSize(unsigned int);
    void DeallocateAlign(void *);
private:
    unsigned int GripRBTAllocatorData[0x3];
};

struct GwNavVehicle_eventExecuteVehicleCommand_Parms  // size 0x1
{
public:
    GwNavVehicle_eventExecuteVehicleCommand_Parms(EEventParm);
    unsigned char HVC;  // 0x0
};

class HaloRBTKamikaze : public CCSRBTMoveTo  // size 0xD0, opaque
{
public:
    enum KamikazeState
    {
        Initialize = 0,
        Arming = 1,
        Chasing = 2,
        Detonating = 3,
    };
    HaloRBTKamikaze();
    virtual bool TestPreCondition(IGripBTInterface *);
    void SetDetonationDistance(float);
    void SetArmKamikazeAnimName(FName);
    void SetDetonateKamikazeAnimName(FName);
    void SetBlendTimes(float, float);
protected:
    virtual GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    virtual GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
private:
    unsigned int HaloRBTKamikazeData[0xB];
};

class UComponent : public UObject  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual unsigned int AreNativePropertiesIdenticalTo(UComponent *) const;
private:
    UComponent &operator=(const UComponent &);
public:
    static UClass *GetPrivateStaticClassUComponent(const wchar_t *);
    static void InitializePrivateStaticClassUComponent();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UComponent();
public:
    static void InternalConstructor(void *);
    void LinkToSourceDefaultObject(UComponent *, UClass *, FName);
    void PreSerialize(FArchive &);
    UComponent *ResolveSourceDefaultObject();
    FName GetInstanceMapName() const;
    unsigned int IsInstanced() const;
    virtual unsigned int GetNativePropertyValues(TMap<FString,FString,FDefaultSetAllocator> &, unsigned long) const;
    virtual unsigned int IsPendingKill() const;
    virtual unsigned int IsAComponent() const;
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UComponentData[0x3];
};

class UActorComponent : public UComponent  // size 0x58, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
protected:
    virtual void SetParentToWorld(const FMatrix &);
    virtual void Attach();
    virtual void UpdateTransform();
    virtual void Detach(unsigned int);
    virtual void BeginPlay();
    virtual void Tick(float);
    virtual void UpdateChildComponents();
public:
    virtual unsigned int IsValidComponent() const;
    virtual void InvalidateLightingCache();
    virtual void InitComponentRBPhys(unsigned int);
    virtual void SetComponentRBFixed(unsigned int);
    virtual void TermComponentRBPhys(FRBPhysScene *);
    virtual unsigned int AllowBeingMarkedPendingKill();
private:
    UActorComponent &operator=(const UActorComponent &);
public:
    static UClass *GetPrivateStaticClassUActorComponent(const wchar_t *);
    static void InitializePrivateStaticClassUActorComponent();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UActorComponent();
public:
    static void InternalConstructor(void *);
    void ConditionalAttach(FSceneInterface *, AActor *, const FMatrix &);
    void ConditionalUpdateTransform();
    void ConditionalUpdateTransform(const FMatrix &);
    void ConditionalDetach(unsigned int);
    void ConditionalBeginPlay();
    void ConditionalTick(float);
    unsigned int IsOwnerSelected() const;
    void MarkLightingRequiringRebuild();
    void DetachFromAny();
    void UpdateComponent(FSceneInterface *, AActor *, const FMatrix &, unsigned int);
    void BeginDeferredReattach();
    void BeginDeferredUpdateTransform();
    void DirtyTransform();
    FSceneInterface *GetScene() const;
    AActor *GetOwner() const;
    void SetOwner(AActor *);
    unsigned int IsAttached() const;
    unsigned int NeedsReattach() const;
    unsigned int NeedsUpdateTransform() const;
    virtual void BeginDestroy();
    virtual unsigned int NeedsLoadForClient() const;
    virtual unsigned int NeedsLoadForServer() const;
    virtual void PreEditChange(UProperty *);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    void execSetComponentRBFixed(FFrame &, void *const);
    void execSetTickGroup(FFrame &, void *const);
    void SetTickGroup(unsigned char);
    void execForceUpdate(FFrame &, void *const);
    void execDetachFromAny(FFrame &, void *const);
    typedef UComponent Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UActorComponentData[0x4];
};

class UActorFactory : public UObject  // size 0x68, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    virtual unsigned int CanCreateActor(FString &, unsigned int);
    virtual void AutoFillFields(USelection *);
    virtual void ClearFields();
    virtual FString GetMenuName();
    virtual AActor *GetDefaultActor();
    void eventPostCreateActor(AActor *, const USeqAct_ActorFactory *);
private:
    UActorFactory &operator=(const UActorFactory &);
public:
    static UClass *GetPrivateStaticClassUActorFactory(const wchar_t *);
    static void InitializePrivateStaticClassUActorFactory();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UActorFactory();
public:
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
protected:
    unsigned int IsEnoughRoomToSpawnPawn(const FVector *const, const USeqAct_ActorFactory *const) const;
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UActorFactoryData[0xB];
};

class UActorFactoryAI : public UActorFactory  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UActorFactoryAI &operator=(const UActorFactoryAI &);
public:
    static UClass *GetPrivateStaticClassUActorFactoryAI(const wchar_t *);
    static void InitializePrivateStaticClassUActorFactoryAI();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UActorFactoryAI();
public:
    static void InternalConstructor(void *);
    virtual AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    virtual unsigned int CanCreateActor(FString &, unsigned int);
    virtual AActor *GetDefaultActor();
    typedef UActorFactory Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UActorFactoryAIData[0xB];
};

class UAnimObject : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual UAnimNode *GetAnimNode();
    virtual UMorphNodeBase *GetMorphNodeBase();
    virtual USkelControlBase *GetSkelControlBase();
    virtual void DrawNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    virtual void OnPaste();
private:
    UAnimObject &operator=(const UAnimObject &);
public:
    static UClass *GetPrivateStaticClassUAnimObject(const wchar_t *);
    static void InitializePrivateStaticClassUAnimObject();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UAnimObject();
public:
    static void InternalConstructor(void *);
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UAnimObjectData[0x1];
};

class UAnimNode : public UAnimObject  // size 0xC0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void PlayAnim(unsigned int, float, float);
    virtual void StopAnim();
    virtual void ReplayAnim();
    virtual void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    virtual void DeferredInitAnim();
    virtual void CallDeferredInitAnim();
    virtual void AnimSetsUpdated();
    virtual void PostAnimNodeInstance(UAnimNode *, TMap<UAnimNode *,UAnimNode *,FDefaultSetAllocator> &);
    virtual void ResetAnimNodeToSource(UAnimNode *);
    virtual void TickAnim(float);
    virtual unsigned int CanBlendOutFrom();
    virtual unsigned int CanBlendTo();
    virtual void BuildParentNodesArray();
    virtual void BuildTickArray(TArray<UAnimNode *,FDefaultAllocator> &);
    virtual void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    virtual unsigned int GetCachedResults(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &, int);
    virtual unsigned int ShouldSaveCachedResults();
    virtual unsigned int ShouldKeepCachedResult();
    virtual void ClearCachedResult();
    virtual void OnBecomeRelevant();
    virtual void OnCeaseRelevant();
    virtual UAnimTree *GetAnimTree();
    virtual void SetAnim(FName);
    virtual void SetPosition(float, unsigned int);
    virtual void DrawAnimNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    virtual FString GetNodeTitle();
    virtual FIntPoint GetConnectionLocation(int, int);
    virtual int GetNumSliders() const;
    virtual ESliderType GetSliderType(int) const;
    virtual float GetSliderPosition(int, int);
    virtual void HandleSliderMove(int, int, float);
    virtual FString GetSliderDrawValue(int);
    virtual void GetNodesInternal(TArray<UAnimNode *,FDefaultAllocator> &);
    virtual UAnimNodeSlot *GetAnimNodeSlot();
    virtual UAnimNodeAimOffset *GetAnimNodeAimOffset();
    virtual UAnimNodeSequence *GetAnimNodeSequence();
    UAnimNode *FindAnimNode(FName);
    void execFindAnimNode(FFrame &, void *const);
    void execPlayAnim(FFrame &, void *const);
    void execStopAnim(FFrame &, void *const);
    void execReplayAnim(FFrame &, void *const);
    void eventOnCeaseRelevant();
    void eventOnBecomeRelevant();
    void eventOnInit();
private:
    UAnimNode &operator=(const UAnimNode &);
public:
    static UClass *GetPrivateStaticClassUAnimNode(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNode();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UAnimNode();
public:
    static void InternalConstructor(void *);
    virtual UAnimNode *GetAnimNode();
    void GetNodes(TArray<UAnimNode *,FDefaultAllocator> &, bool);
    void GetNodesByClass(TArray<UAnimNode *,FDefaultAllocator> &, UClass *);
    void GetAnimSeqNodes(TArray<UAnimNodeSequence *,FDefaultAllocator> &, FName);
    void SaveCachedResults(const TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const FBoneAtom &, int, const TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &, int);
    unsigned int WereAllParentsTicked() const;
    unsigned int IsChildOf(UAnimNode *);
    unsigned int IsChildOf_Internal(UAnimNode *);
    virtual unsigned int NeedsLoadForClient() const;
    virtual unsigned int NeedsLoadForServer() const;
    virtual void DrawNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    virtual void OnPaste();
    static void FillWithRefPose(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, const TArray<FMeshBone,FDefaultAllocator> &);
    static void FillWithRefPose(TArray<FBoneAtom,FDefaultAllocator> &, const TArray<unsigned char,FDefaultAllocator> &, const TArray<FMeshBone,FDefaultAllocator> &);
    static void EnsureParentsPresent(TArray<unsigned char,FDefaultAllocator> &, USkeletalMesh *);
    typedef UAnimObject Super;
private:
    static UClass *PrivateStaticClass;
public:
    static unsigned int bNodeSearching;
    static int CurrentSearchTag;
    static TArray<UAnimNode *,FDefaultAllocator> NodesRequiringCacheClear;
private:
    unsigned int UAnimNodeData[0x20];
};

class UAnimNodeBlendBase : public UAnimNode  // size 0xE0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void GetChildBoneAtoms(int, TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    virtual int Extend2DSlider(FCanvas *, const FIntPoint &, int, unsigned int, int);
    virtual void OnChildAnimEnd(UAnimNodeSequence *, float, float);
    virtual void OnAddChild(int);
    virtual void OnRemoveChild(int);
    virtual void OnChildAnimChange(int);
    virtual void RenameChildConnectors();
    virtual int BlendCurveWeights(const TArray<TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> >,TMemStackAllocator<GMainThreadMemStack,8> > &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
protected:
    virtual void UpdateChildWeight(int);
public:
    virtual void PlayAnim(unsigned int, float, float);
    virtual void StopAnim();
    virtual void ReplayAnim();
private:
    UAnimNodeBlendBase &operator=(const UAnimNodeBlendBase &);
public:
    static UClass *GetPrivateStaticClassUAnimNodeBlendBase(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNodeBlendBase();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UAnimNodeBlendBase();
public:
    static void InternalConstructor(void *);
    virtual void CallDeferredInitAnim();
    virtual void TickAnim(float);
    virtual void BuildParentNodesArray();
    virtual void BuildTickArray(TArray<UAnimNode *,FDefaultAllocator> &);
    float GetBlendWeight(float);
    void SetBlendTypeWeights();
    virtual void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    void GetMirroredBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, int, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    virtual void DrawAnimNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    virtual FString GetNodeTitle();
    virtual FIntPoint GetConnectionLocation(int, int);
    float GetChildWeightTotal();
    virtual void GetNodesInternal(TArray<UAnimNode *,FDefaultAllocator> &);
    virtual void OnPaste();
    typedef UAnimNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UAnimNodeBlendBaseData[0x8];
};

class UAnimNodeBlendList : public UAnimNodeBlendBase  // size 0x100, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void SetActiveChild(int, float);
    void execSetActiveChild(FFrame &, void *const);
private:
    UAnimNodeBlendList &operator=(const UAnimNodeBlendList &);
public:
    static UClass *GetPrivateStaticClassUAnimNodeBlendList(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNodeBlendList();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UAnimNodeBlendList();
public:
    static void InternalConstructor(void *);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    virtual void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    virtual void ResetAnimNodeToSource(UAnimNode *);
    virtual void TickAnim(float);
    virtual int GetNumSliders() const;
    virtual float GetSliderPosition(int, int);
    virtual void HandleSliderMove(int, int, float);
    virtual FString GetSliderDrawValue(int);
    virtual void OnAddChild(int);
    virtual void OnRemoveChild(int);
    virtual void OnPaste();
    typedef UAnimNodeBlendBase Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UAnimNodeBlendListData[0x8];
};

class UAnimNodeSlot : public UAnimNodeBlendBase  // size 0x100, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void MAT_SetAnimPosition(int, FName, float, unsigned int, unsigned int, unsigned int);
    virtual void MAT_SetAnimWeights(const FAnimSlotInfo &);
    virtual void SelectedActiveSequence(UAnimNodeSequence *);
    float PlayCustomAnim(FName, float, float, float, unsigned int, unsigned int, float, float);
    unsigned int PlayCustomAnimByDuration(FName, float, float, float, unsigned int, unsigned int);
    FName GetPlayedAnimation();
    void StopCustomAnim(float);
    void SetAllowPauseAnims(unsigned int);
    void SetCustomAnim(FName);
    void SetActorAnimEndNotification(unsigned int);
    UAnimNodeSequence *GetCustomAnimNodeSeq();
    void SetRootBoneAxisOption(unsigned char, unsigned char, unsigned char);
    void SetRootBoneRotationOption(unsigned char, unsigned char, unsigned char);
    void TickChildWeights(float);
    void execPlayCustomAnim(FFrame &, void *const);
    void execPlayCustomAnimByDuration(FFrame &, void *const);
    void execGetPlayedAnimation(FFrame &, void *const);
    void execStopCustomAnim(FFrame &, void *const);
    void execSetAllowPauseAnims(FFrame &, void *const);
    void execSetCustomAnim(FFrame &, void *const);
    void execSetActorAnimEndNotification(FFrame &, void *const);
    void execGetCustomAnimNodeSeq(FFrame &, void *const);
    void execSetRootBoneAxisOption(FFrame &, void *const);
    void execSetRootBoneRotationOption(FFrame &, void *const);
    void execTickChildWeights(FFrame &, void *const);
private:
    UAnimNodeSlot &operator=(const UAnimNodeSlot &);
public:
    static UClass *GetPrivateStaticClassUAnimNodeSlot(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNodeSlot();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UAnimNodeSlot();
public:
    static void InternalConstructor(void *);
    virtual void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    virtual void RenameChildConnectors();
    virtual void TickAnim(float);
    virtual void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    virtual void OnAddChild(int);
    virtual void OnRemoveChild(int);
    virtual void OnChildAnimChange(int);
    virtual void OnChildAnimEnd(UAnimNodeSequence *, float, float);
    virtual int GetNumSliders() const;
    int FindBestChildToPlayAnim(FName, unsigned int);
    void SetActiveChild(int, float);
    void UpdateWeightsForAdditiveAnimations();
    virtual void OnPaste();
    virtual UAnimNodeSlot *GetAnimNodeSlot();
    static void CleanUpSlotNodeSequencePool();
    static void FlushReleasedSequenceNodes(const USkeletalMeshComponent *);
    static void ReleaseSequenceNodes(const USkeletalMeshComponent *);
    static void PrintSlotNodeSequencePool();
protected:
    virtual void UpdateChildWeight(int);
    void EnsureChildExists(int, unsigned int);
public:
    typedef UAnimNodeBlendBase Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UAnimNodeSlotData[0x8];
};

class UGripAFActionHandle : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual int CreateAction(GripAFFactory *);
private:
    UGripAFActionHandle &operator=(const UGripAFActionHandle &);
public:
    static UClass *GetPrivateStaticClassUGripAFActionHandle(const wchar_t *);
    static void InitializePrivateStaticClassUGripAFActionHandle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripAFActionHandle();
public:
    static void InternalConstructor(void *);
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripAFActionHandleData[0x1];
};

class UCCSAFEncircleTarget : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFEncircleTarget &operator=(const UCCSAFEncircleTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSAFEncircleTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFEncircleTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFEncircleTarget();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFEncircleTargetData[0x1];
};

class UCCSAFEnterCover : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFEnterCover &operator=(const UCCSAFEnterCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFEnterCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFEnterCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFEnterCover();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFEnterCoverData[0x2];
};

class UCCSAFExitCover : public UGripAFActionHandle  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFExitCover &operator=(const UCCSAFExitCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFExitCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFExitCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFExitCover();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSAFFireBurst : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFFireBurst &operator=(const UCCSAFFireBurst &);
public:
    static UClass *GetPrivateStaticClassUCCSAFFireBurst(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFFireBurst();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFFireBurst();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFFireBurstData[0x1];
};

class UCCSAFFlee : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFFlee &operator=(const UCCSAFFlee &);
public:
    static UClass *GetPrivateStaticClassUCCSAFFlee(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFFlee();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFFlee();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFFleeData[0x1];
};

class UCCSAFGetInCover : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFGetInCover &operator=(const UCCSAFGetInCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFGetInCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFGetInCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFGetInCover();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFGetInCoverData[0x2];
};

class UCCSAFGetOutCover : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFGetOutCover &operator=(const UCCSAFGetOutCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFGetOutCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFGetOutCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFGetOutCover();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFGetOutCoverData[0x2];
};

class UCCSAFIdle : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFIdle &operator=(const UCCSAFIdle &);
public:
    static UClass *GetPrivateStaticClassUCCSAFIdle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFIdle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFIdle();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFIdleData[0x1];
};

class UCCSAFMoveTo : public UGripAFActionHandle  // size 0x50, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFMoveTo &operator=(const UCCSAFMoveTo &);
public:
    static UClass *GetPrivateStaticClassUCCSAFMoveTo(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFMoveTo();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFMoveTo();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFMoveToData[0x4];
};

class UCCSAFMoveToActor : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFMoveToActor &operator=(const UCCSAFMoveToActor &);
public:
    static UClass *GetPrivateStaticClassUCCSAFMoveToActor(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFMoveToActor();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFMoveToActor();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFMoveToActorData[0x2];
};

class UCCSAFOrientToward : public UGripAFActionHandle  // size 0x50, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFOrientToward &operator=(const UCCSAFOrientToward &);
public:
    static UClass *GetPrivateStaticClassUCCSAFOrientToward(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFOrientToward();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFOrientToward();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFOrientTowardData[0x4];
};

class UCCSAFStrafeTarget : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFStrafeTarget &operator=(const UCCSAFStrafeTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSAFStrafeTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFStrafeTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFStrafeTarget();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFStrafeTargetData[0x1];
};

class UCCSAFStrafeTo : public UGripAFActionHandle  // size 0x54, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSAFStrafeTo &operator=(const UCCSAFStrafeTo &);
public:
    static UClass *GetPrivateStaticClassUCCSAFStrafeTo(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFStrafeTo();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSAFStrafeTo();
public:
    static void InternalConstructor(void *);
    virtual int CreateAction(GripAFFactory *);
    typedef UGripAFActionHandle Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSAFStrafeToData[0x5];
};

class UCCSATAnimNodeSlot : public UAnimNodeSlot  // size 0x100, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void ActivateChild(int, float);
    void execActivateChild(FFrame &, void *const);
    float eventActivateInput(FName, float, float, float, unsigned int, unsigned int, float);
private:
    UCCSATAnimNodeSlot &operator=(const UCCSATAnimNodeSlot &);
public:
    static UClass *GetPrivateStaticClassUCCSATAnimNodeSlot(const wchar_t *);
    static void InitializePrivateStaticClassUCCSATAnimNodeSlot();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSATAnimNodeSlot();
public:
    static void InternalConstructor(void *);
protected:
    UCCSATAnimNodeSlot();
public:
    typedef UAnimNodeSlot Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSATBlendListBase : public UAnimNodeBlendList  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSATBlendListBase &operator=(const UCCSATBlendListBase &);
public:
    static UClass *GetPrivateStaticClassUCCSATBlendListBase(const wchar_t *);
    static void InitializePrivateStaticClassUCCSATBlendListBase();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSATBlendListBase();
public:
    static void InternalConstructor(void *);
protected:
    UCCSATBlendListBase();
public:
    typedef UAnimNodeBlendList Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSATBlendListBaseData[0x4];
};

class UGwNavActorFactoryAI : public UActorFactoryAI  // size 0xA0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UGwNavActorFactoryAI &operator=(const UGwNavActorFactoryAI &);
public:
    static UClass *GetPrivateStaticClassUGwNavActorFactoryAI(const wchar_t *);
    static void InitializePrivateStaticClassUGwNavActorFactoryAI();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGwNavActorFactoryAI();
public:
    static void InternalConstructor(void *);
    virtual AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    typedef UActorFactoryAI Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGwNavActorFactoryAIData[0x3];
};

class UCCSActorFactory : public UGwNavActorFactoryAI  // size 0xD8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSActorFactory &operator=(const UCCSActorFactory &);
public:
    static UClass *GetPrivateStaticClassUCCSActorFactory(const wchar_t *);
    static void InitializePrivateStaticClassUCCSActorFactory();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSActorFactory();
public:
    static void InternalConstructor(void *);
    virtual AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    virtual unsigned int CanCreateActor(FString &, unsigned int);
    virtual AActor *GetDefaultActor();
    typedef UGwNavActorFactoryAI Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSActorFactoryData[0xE];
};

class UGripBTObject : public UObject  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual UGripBTNode *GetNode();
    virtual void DrawNode(FCanvas *, unsigned int, unsigned int, unsigned int);
private:
    UGripBTObject &operator=(const UGripBTObject &);
public:
    static UClass *GetPrivateStaticClassUGripBTObject(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTObject();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTObject();
public:
    static void InternalConstructor(void *);
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTObjectData[0x2];
};

class UGripBTNode : public UGripBTObject  // size 0x88, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    virtual FString GetNodeTitle();
private:
    virtual void GetNodesInternal(TArray<UGripBTNode *,FDefaultAllocator> &);
    UGripBTNode &operator=(const UGripBTNode &);
public:
    static UClass *GetPrivateStaticClassUGripBTNode(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTNode();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTNode();
public:
    static void InternalConstructor(void *);
    virtual UGripBTNode *GetNode();
    void GetNodes(TArray<UGripBTNode *,FDefaultAllocator> &);
    UGripBTNode *GetGripBTChild(const int) const;
    unsigned int IsChildOf(UGripBTNode *);
    typedef UGripBTObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTNodeData[0x11];
};

class UCCSBTEncircleTarget : public UGripBTNode  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTEncircleTarget &operator=(const UCCSBTEncircleTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEncircleTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEncircleTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTEncircleTarget();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTEncircleTargetData[0x4];
};

class UGripBTBooleanCondition : public UGripBTNode  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UGripBTBooleanCondition &operator=(const UGripBTBooleanCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTBooleanCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTBooleanCondition();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTBooleanCondition();
public:
    static void InternalConstructor(void *);
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    virtual FString GetNodeTitle();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTBooleanConditionData[0x1];
};

class UCCSBTEnemyAware : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTEnemyAware &operator=(const UCCSBTEnemyAware &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEnemyAware(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEnemyAware();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTEnemyAware();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UGripBTNumericCondition : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UGripBTNumericCondition &operator=(const UGripBTNumericCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTNumericCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTNumericCondition();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTNumericCondition();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    virtual FString GetNodeTitle();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTNumericConditionData[0x3];
};

class UCCSBTEnemyClosestRange : public UGripBTNumericCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTEnemyClosestRange &operator=(const UCCSBTEnemyClosestRange &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEnemyClosestRange(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEnemyClosestRange();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTEnemyClosestRange();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNumericCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UGripBTFloatCondition : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UGripBTFloatCondition &operator=(const UGripBTFloatCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTFloatCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTFloatCondition();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTFloatCondition();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    virtual FString GetNodeTitle();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTFloatConditionData[0x3];
};

class UCCSBTEnemyLowestLKPAge : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTEnemyLowestLKPAge &operator=(const UCCSBTEnemyLowestLKPAge &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEnemyLowestLKPAge(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEnemyLowestLKPAge();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTEnemyLowestLKPAge();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTFlee : public UGripBTNode  // size 0x88, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTFlee &operator=(const UCCSBTFlee &);
public:
    static UClass *GetPrivateStaticClassUCCSBTFlee(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTFlee();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTFlee();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTIdle : public UGripBTNode  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTIdle &operator=(const UCCSBTIdle &);
public:
    static UClass *GetPrivateStaticClassUCCSBTIdle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTIdle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTIdle();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTIdleData[0x1];
};

class UCCSBTMoveTo : public UGripBTNode  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveTo &operator=(const UCCSBTMoveTo &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveTo(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveTo();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveTo();
public:
    static void InternalConstructor(void *);
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTMoveToData[0xC];
};

class UCCSBTMoveIntoCover : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveIntoCover &operator=(const UCCSBTMoveIntoCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveIntoCover();
public:
    static void InternalConstructor(void *);
protected:
    UCCSBTMoveIntoCover();
public:
    typedef UCCSBTMoveTo Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTMoveIntoBestCover : public UCCSBTMoveIntoCover  // size 0xC0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveIntoBestCover &operator=(const UCCSBTMoveIntoBestCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoBestCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoBestCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveIntoBestCover();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveIntoCover Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTMoveIntoBestCoverData[0x2];
};

class UCCSBTMoveIntoClosestCover : public UCCSBTMoveIntoCover  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveIntoClosestCover &operator=(const UCCSBTMoveIntoClosestCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoClosestCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoClosestCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveIntoClosestCover();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveIntoCover Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTMoveIntoInitialCover : public UCCSBTMoveIntoCover  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveIntoInitialCover &operator=(const UCCSBTMoveIntoInitialCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoInitialCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoInitialCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveIntoInitialCover();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveIntoCover Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTMoveToActor : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveToActor &operator=(const UCCSBTMoveToActor &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToActor(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToActor();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveToActor();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveTo Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTMoveToTarget : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveToTarget &operator=(const UCCSBTMoveToTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveToTarget();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveTo Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTMoveToTether : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveToTether &operator=(const UCCSBTMoveToTether &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToTether(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToTether();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveToTether();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveTo Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTMoveToVehicle : public UCCSBTMoveToTarget  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTMoveToVehicle &operator=(const UCCSBTMoveToVehicle &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToVehicle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToVehicle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTMoveToVehicle();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveToTarget Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTOrientTowardTarget : public UGripBTNode  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTOrientTowardTarget &operator=(const UCCSBTOrientTowardTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTOrientTowardTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTOrientTowardTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTOrientTowardTarget();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTOrientTowardTargetData[0x1];
};

class UGripBTScriptNode : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    unsigned char eventExecutePass(UGripBTInterface *, unsigned int, unsigned int);
    FString eventGetNodeTitle();
private:
    UGripBTScriptNode &operator=(const UGripBTScriptNode &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptNode(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptNode();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTScriptNode();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual FString GetNodeTitle();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTScriptNodeData[0x3];
};

class UGripBTScriptBehavior : public UGripBTScriptNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UGripBTScriptBehavior &operator=(const UGripBTScriptBehavior &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptBehavior(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptBehavior();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTScriptBehavior();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTScriptNode Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTScriptBehavior : public UGripBTScriptBehavior  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTScriptBehavior &operator=(const UCCSBTScriptBehavior &);
public:
    static UClass *GetPrivateStaticClassUCCSBTScriptBehavior(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTScriptBehavior();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTScriptBehavior();
public:
    static void InternalConstructor(void *);
protected:
    UCCSBTScriptBehavior();
public:
    typedef UGripBTScriptBehavior Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTScriptBehaviorData[0x1];
};

class UGripBTScriptCondition : public UGripBTScriptNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UGripBTScriptCondition &operator=(const UGripBTScriptCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptCondition();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTScriptCondition();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTScriptNode Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTScriptCondition : public UGripBTScriptCondition  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTScriptCondition &operator=(const UCCSBTScriptCondition &);
public:
    static UClass *GetPrivateStaticClassUCCSBTScriptCondition(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTScriptCondition();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTScriptCondition();
public:
    static void InternalConstructor(void *);
protected:
    UCCSBTScriptCondition();
public:
    typedef UGripBTScriptCondition Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTScriptConditionData[0x1];
};

class UCCSBTScriptCover : public UCCSBTScriptBehavior  // size 0xCC, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTScriptCover &operator=(const UCCSBTScriptCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTScriptCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTScriptCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTScriptCover();
public:
    static void InternalConstructor(void *);
    virtual BTMenuType GetMenuType();
    typedef UCCSBTScriptBehavior Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTScriptCoverData[0xD];
};

class UCCSBTSearch : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTSearch &operator=(const UCCSBTSearch &);
public:
    static UClass *GetPrivateStaticClassUCCSBTSearch(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTSearch();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTSearch();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveTo Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTSelectTarget : public UGripBTNode  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTSelectTarget &operator=(const UCCSBTSelectTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTSelectTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTSelectTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTSelectTarget();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    virtual FString GetNodeTitle();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTSelectTargetData[0x4];
};

class UCCSBTShoot : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTShoot &operator=(const UCCSBTShoot &);
public:
    static UClass *GetPrivateStaticClassUCCSBTShoot(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTShoot();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTShoot();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTShootData[0x3];
};

class UCCSBTShootFromCover : public UGripBTNode  // size 0x90, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTShootFromCover &operator=(const UCCSBTShootFromCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTShootFromCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTShootFromCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTShootFromCover();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTShootFromCoverData[0x2];
};

class UCCSBTStrafeTarget : public UGripBTNode  // size 0x9C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTStrafeTarget &operator=(const UCCSBTStrafeTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTStrafeTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTStrafeTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTStrafeTarget();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTStrafeTargetData[0x5];
};

class UCCSBTTargetAngle : public UGripBTBooleanCondition  // size 0x90, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetAngle &operator=(const UCCSBTTargetAngle &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetAngle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetAngle();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetAngle();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTTargetAngleData[0x1];
};

class UCCSBTTargetClear : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetClear &operator=(const UCCSBTTargetClear &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetClear(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetClear();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetClear();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTargetInCover : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetInCover &operator=(const UCCSBTTargetInCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetInCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetInCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetInCover();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTargetKnockedDown : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetKnockedDown &operator=(const UCCSBTTargetKnockedDown &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetKnockedDown(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetKnockedDown();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetKnockedDown();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTargetRange : public UGripBTNumericCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetRange &operator=(const UCCSBTTargetRange &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetRange(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetRange();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetRange();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNumericCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTargetShootable : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetShootable &operator=(const UCCSBTTargetShootable &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetShootable(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetShootable();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetShootable();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTargetVisible : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTargetVisible &operator=(const UCCSBTTargetVisible &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetVisible(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetVisible();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTargetVisible();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceAimedAt : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceAimedAt &operator=(const UCCSBTTimeSinceAimedAt &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceAimedAt(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceAimedAt();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceAimedAt();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceBecameAware : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceBecameAware &operator=(const UCCSBTTimeSinceBecameAware &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceBecameAware(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceBecameAware();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceBecameAware();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceDamage : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceDamage &operator=(const UCCSBTTimeSinceDamage &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceDamage(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceDamage();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceDamage();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceEvent : public UGripBTFloatCondition  // size 0xA0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceEvent &operator=(const UCCSBTTimeSinceEvent &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceEvent(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceEvent();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceEvent();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual BTMenuType GetMenuType();
    virtual FString GetNodeTitle();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSBTTimeSinceEventData[0x3];
};

class UCCSBTTimeSinceGrenadeStuck : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceGrenadeStuck &operator=(const UCCSBTTimeSinceGrenadeStuck &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceGrenadeStuck(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceGrenadeStuck();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceGrenadeStuck();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceStaggered : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceStaggered &operator=(const UCCSBTTimeSinceStaggered &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceStaggered(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceStaggered();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceStaggered();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceSuccessfulAttack : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceSuccessfulAttack &operator=(const UCCSBTTimeSinceSuccessfulAttack &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceSuccessfulAttack(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceSuccessfulAttack();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceSuccessfulAttack();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceTargetCamoed : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceTargetCamoed &operator=(const UCCSBTTimeSinceTargetCamoed &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceTargetCamoed(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceTargetCamoed();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceTargetCamoed();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceThreatChanged : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceThreatChanged &operator=(const UCCSBTTimeSinceThreatChanged &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceThreatChanged(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceThreatChanged();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceThreatChanged();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTTimeSinceThreatened : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTTimeSinceThreatened &operator=(const UCCSBTTimeSinceThreatened &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceThreatened(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceThreatened();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTTimeSinceThreatened();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTFloatCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTVisibleToPlayerCamera : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTVisibleToPlayerCamera &operator=(const UCCSBTVisibleToPlayerCamera &);
public:
    static UClass *GetPrivateStaticClassUCCSBTVisibleToPlayerCamera(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTVisibleToPlayerCamera();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTVisibleToPlayerCamera();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual BTMenuType GetMenuType();
    typedef UGripBTBooleanCondition Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSBTWaitInCover : public UGripBTNode  // size 0x88, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSBTWaitInCover &operator=(const UCCSBTWaitInCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTWaitInCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTWaitInCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBTWaitInCover();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UGripBTNode Super;
private:
    static UClass *PrivateStaticClass;
};

class UGripBlackboard : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual unsigned int ContainState(const FString &) const;
    virtual void FlagStatesAsUsed();
    void execContainState(FFrame &, void *const);
    void execFlagStatesAsUsed(FFrame &, void *const);
private:
    UGripBlackboard &operator=(const UGripBlackboard &);
public:
    static UClass *GetPrivateStaticClassUGripBlackboard(const wchar_t *);
    static void InitializePrivateStaticClassUGripBlackboard();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBlackboard();
public:
    static void InternalConstructor(void *);
    void Initialize(GripBlackboard *);
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBlackboardData[0x1];
};

class UCCSBlackboard : public UGripBlackboard  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual int GetHealth() const;
    virtual void SetHealth(int);
    virtual void GetCovers(TArray<FCCSCoverData,FDefaultAllocator> &) const;
    virtual FCCSTargetData GetCurrentTarget() const;
    virtual void SetCurrentTether(AActor *);
    virtual FVector GetCurrentTether() const;
    virtual void GetTargets(TArray<FCCSTargetData,FDefaultAllocator> &) const;
    virtual FCCSMoveCmdData GetMoveCommand() const;
    virtual void ClearMoveCommand();
    virtual void FlagThreatLocationAsUsed();
    virtual void FlagThreatDirectionAsUsed();
    virtual FVector GetThreatLocation();
    virtual FVector GetThreatDirection();
    virtual unsigned char GetThreatType();
    virtual void SetHeatGenerated(float);
    virtual float GetHeatGenerated() const;
    virtual void FlagHeatGeneratedAsUsed();
    virtual FCCSTargetData GetClosestVisibleEnemy() const;
    virtual void FlagHealthAsUsed();
    virtual void FlagCoversAsUsed();
    virtual void FlagTargetsAsUsed();
    virtual void FlagTetherAsUsed();
    virtual void FlagClosestVisibleEnemyAsUsed();
    void execGetHealth(FFrame &, void *const);
    void execSetHealth(FFrame &, void *const);
    void execGetCovers(FFrame &, void *const);
    void execGetCurrentTarget(FFrame &, void *const);
    void execSetCurrentTether(FFrame &, void *const);
    void execGetCurrentTether(FFrame &, void *const);
    void execGetTargets(FFrame &, void *const);
    void execGetMoveCommand(FFrame &, void *const);
    void execClearMoveCommand(FFrame &, void *const);
    void execFlagThreatLocationAsUsed(FFrame &, void *const);
    void execFlagThreatDirectionAsUsed(FFrame &, void *const);
    void execGetThreatLocation(FFrame &, void *const);
    void execGetThreatDirection(FFrame &, void *const);
    void execGetThreatType(FFrame &, void *const);
    void execSetHeatGenerated(FFrame &, void *const);
    void execGetHeatGenerated(FFrame &, void *const);
    void execFlagHeatGeneratedAsUsed(FFrame &, void *const);
    void execGetClosestVisibleEnemy(FFrame &, void *const);
    void execFlagHealthAsUsed(FFrame &, void *const);
    void execFlagCoversAsUsed(FFrame &, void *const);
    void execFlagTargetsAsUsed(FFrame &, void *const);
    void execFlagTetherAsUsed(FFrame &, void *const);
    void execFlagClosestVisibleEnemyAsUsed(FFrame &, void *const);
private:
    UCCSBlackboard &operator=(const UCCSBlackboard &);
public:
    static UClass *GetPrivateStaticClassUCCSBlackboard(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBlackboard();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSBlackboard();
public:
    static void InternalConstructor(void *);
protected:
    UCCSBlackboard();
public:
    typedef UGripBlackboard Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSCover : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSCover &operator=(const UCCSCover &);
public:
    static UClass *GetPrivateStaticClassUCCSCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSCover();
public:
    static void InternalConstructor(void *);
protected:
    UCCSCover();
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
};

class UInterface : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UInterface &operator=(const UInterface &);
public:
    static UClass *GetPrivateStaticClassUInterface(const wchar_t *);
    static void InitializePrivateStaticClassUInterface();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UInterface();
public:
    static void InternalConstructor(void *);
protected:
    UInterface();
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSPawn : public UInterface  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSPawn &operator=(const UCCSPawn &);
public:
    static UClass *GetPrivateStaticClassUCCSPawn(const wchar_t *);
    static void InitializePrivateStaticClassUCCSPawn();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSPawn();
public:
    static void InternalConstructor(void *);
protected:
    UCCSPawn();
public:
    typedef UInterface Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSSystemConfig : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSSystemConfig &operator=(const UCCSSystemConfig &);
public:
    static UClass *GetPrivateStaticClassUCCSSystemConfig(const wchar_t *);
    static void InitializePrivateStaticClassUCCSSystemConfig();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSSystemConfig();
public:
    static void InternalConstructor(void *);
protected:
    UCCSSystemConfig();
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
};

class UCCSTarget : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSTarget &operator=(const UCCSTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSTarget();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSTarget();
public:
    static void InternalConstructor(void *);
protected:
    UCCSTarget();
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
};

class UPrimitiveComponent : public UActorComponent  // size 0x1E0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void GenerateDecalRenderData(FDecalState *, TArray<FDecalRenderData *,FDefaultAllocator> &) const;
    virtual unsigned int ShouldRenderSelected() const;
    virtual unsigned int UsesOnlyUnlitMaterials() const;
    virtual unsigned int GetLightMapResolution(int &, int &) const;
    virtual int GetStaticLightMapResolution() const;
    virtual void GetLightAndShadowMapMemoryUsage(int &, int &) const;
    virtual void UpdateBounds();
    virtual void GetStaticLightingInfo(FStaticLightingPrimitiveInfo &, const TArray<ULightComponent *,FDefaultAllocator> &, const FLightingBuildOptions &);
    virtual ELightMapInteractionType GetStaticLightingType() const;
    virtual void GetStaticTriangles(FPrimitiveTriangleDefinitionInterface *) const;
    virtual void GetStreamingTextureInfo(TArray<FStreamingTexturePrimitiveInfo,FDefaultAllocator> &) const;
    virtual unsigned char GetStaticDepthPriorityGroup() const;
    virtual void GetUsedMaterials(TArray<UMaterialInterface *,FDefaultAllocator> &) const;
    virtual unsigned int PointCheck(FCheckResult &, const FVector &, const FVector &, unsigned long);
    virtual unsigned int LineCheck(FCheckResult &, const FVector &, const FVector &, const FVector &, unsigned long);
    virtual unsigned int IsAlwaysStatic();
    virtual URB_BodySetup *GetRBBodySetup();
    virtual FKCachedConvexData *GetCachedPhysConvexData(const FVector &);
    virtual FKCachedConvexData *GetBoneCachedPhysConvexData(const FVector &, const FName &);
    virtual void AddImpulse(FVector, FVector, FName, unsigned int);
    virtual void AddRadialImpulse(const FVector &, float, float, unsigned char, unsigned int);
    virtual void AddRadialForce(const FVector &, float, float, unsigned char);
    virtual void AddForceField(FForceApplicator *, const FBox &, unsigned int, unsigned int);
    virtual void SetRBLinearVelocity(const FVector &, unsigned int);
    virtual void SetRBAngularVelocity(const FVector &, unsigned int);
    virtual void RetardRBLinearVelocity(const FVector &, float);
    virtual void SetRBPosition(const FVector &, FName);
    virtual void SetRBRotation(const FRotator &, FName);
    virtual void WakeRigidBody(FName);
    virtual void PutRigidBodyToSleep(FName);
    virtual unsigned int RigidBodyIsAwake(FName);
    virtual void SetBlockRigidBody(unsigned int);
    virtual void SetNotifyRigidBodyCollision(unsigned int);
    virtual void SetRBDominanceGroup(unsigned char);
    virtual void SetPhysMaterialOverride(UPhysicalMaterial *);
    virtual URB_BodyInstance *GetRootBodyInstance();
    virtual void UpdateRBKinematicData();
    virtual unsigned char ClosestPointOnComponentInternal(IGJKHelper *, FVector &, FVector &);
    virtual unsigned char ClosestPointOnComponentToComponent(UPrimitiveComponent *&, FVector &, FVector &);
    virtual void SetTransformedToWorld();
    virtual unsigned int IsPrimitiveInstanced() const;
    virtual int GetInstanceCount() const;
    virtual const FMatrix GetInstanceLocalToWorld(int) const;
    virtual void OverrideTraceFlagsForNonCollisionComponentChecks(unsigned long &);
    virtual int GetNumElements() const;
    virtual UMaterialInterface *GetElementMaterial(int) const;
    virtual void SetElementMaterial(int, UMaterialInterface *);
    virtual int GetActorMetrics(EActorMetricsType);
    virtual NxActor *GetNxActor(FName);
    virtual NxActor *GetIndexedNxActor(int);
    virtual void GetAllNxActors(TArray<NxActor *,FDefaultAllocator> &);
    virtual FPrimitiveSceneProxy *CreateSceneProxy();
    virtual unsigned int ShouldRecreateProxyOnUpdateTransform() const;
protected:
    virtual unsigned int AllowDecalRemovalOnDetach() const;
    virtual unsigned int AllowDecalAutomaticReAttach() const;
    virtual void UpdatePhysicsToRBChannels();
public:
    virtual unsigned int SupportsDecalRendering() const;
    virtual unsigned int HasMotionBlurVelocityMeshes() const;
    virtual void SetOwnerNoSee(unsigned int);
    virtual void SetOnlyOwnerSee(unsigned int);
    virtual void SetIgnoreOwnerHidden(unsigned int);
    virtual unsigned int ShouldComponentAddToScene() const;
    virtual void SetHiddenGame(unsigned int);
    virtual void SetHiddenEditor(unsigned int);
    virtual void SetShadowParent(UPrimitiveComponent *);
    virtual void SetLightEnvironment(ULightEnvironmentComponent *);
    virtual void SetCullDistance(float);
    virtual void SetLightingChannels(FLightingChannelContainer);
    virtual void SetDepthPriorityGroup(ESceneDepthPriorityGroup);
    virtual void SetViewOwnerDepthPriorityGroup(unsigned int, ESceneDepthPriorityGroup);
    virtual float GetEmissiveBoost(int) const;
    virtual float GetDiffuseBoost(int) const;
    virtual float GetSpecularBoost(int) const;
    virtual unsigned int GetShadowIndirectOnly() const;
    virtual unsigned int SetupLightmapResolutionViewInfo(FPrimitiveSceneProxy &) const;
private:
    UPrimitiveComponent &operator=(const UPrimitiveComponent &);
public:
    static UClass *GetPrivateStaticClassUPrimitiveComponent(const wchar_t *);
    static void InitializePrivateStaticClassUPrimitiveComponent();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UPrimitiveComponent();
public:
    static void InternalConstructor(void *);
    unsigned int ShouldCollide() const;
    void AttachDecal(UDecalComponent *, FDecalRenderData *, const FDecalState *);
    void DetachDecal(UDecalComponent *);
    unsigned int HasStaticShadowing() const;
    void ValidateLightingChannels();
    virtual void InvalidateLightingCache();
    void GetUsedTextures(TArray<UTexture *,FDefaultAllocator> &, EMaterialShaderQuality, unsigned int);
    FVector GetOrigin() const;
    void GetTransformAndScale(FMatrix &, FVector &);
    virtual void InitComponentRBPhys(unsigned int);
    virtual void SetComponentRBFixed(unsigned int);
    virtual void TermComponentRBPhys(FRBPhysScene *);
    URB_BodySetup *FindRBBodySetup();
    void AddForce(FVector, FVector, FName);
    void AddTorque(FVector, FName);
    void SetRBCollidesWithChannel(ERBCollisionChannel, unsigned int);
    void SetRBCollisionChannels(FRBCollisionChannelContainer);
    void SetRBChannel(ERBCollisionChannel);
    unsigned char ClosestPointOnComponentToPoint(const FVector &, const FVector &, FVector &, FVector &);
    unsigned int IsOverlapping(UPrimitiveComponent *, FCheckResult *, const FVector &, unsigned long, unsigned long);
    void execAddImpulse(FFrame &, void *const);
    void execAddRadialImpulse(FFrame &, void *const);
    void execAddForce(FFrame &, void *const);
    void execAddRadialForce(FFrame &, void *const);
    void execAddTorque(FFrame &, void *const);
    void execSetRBLinearVelocity(FFrame &, void *const);
    void execSetRBAngularVelocity(FFrame &, void *const);
    void execRetardRBLinearVelocity(FFrame &, void *const);
    void execSetRBPosition(FFrame &, void *const);
    void execSetRBRotation(FFrame &, void *const);
    void execWakeRigidBody(FFrame &, void *const);
    void execPutRigidBodyToSleep(FFrame &, void *const);
    void execRigidBodyIsAwake(FFrame &, void *const);
    void execSetBlockRigidBody(FFrame &, void *const);
    void execSetRBCollidesWithChannel(FFrame &, void *const);
    void execSetRBCollisionChannels(FFrame &, void *const);
    void execSetRBChannel(FFrame &, void *const);
    void execSetNotifyRigidBodyCollision(FFrame &, void *const);
    void execInitRBPhys(FFrame &, void *const);
    void execSetPhysMaterialOverride(FFrame &, void *const);
    void execSetRBDominanceGroup(FFrame &, void *const);
    void execSetHidden(FFrame &, void *const);
    void execSetOwnerNoSee(FFrame &, void *const);
    void execSetOnlyOwnerSee(FFrame &, void *const);
    void execSetIgnoreOwnerHidden(FFrame &, void *const);
    void execSetShadowParent(FFrame &, void *const);
    void execSetLightEnvironment(FFrame &, void *const);
    void execSetCullDistance(FFrame &, void *const);
    void execSetLightingChannels(FFrame &, void *const);
    void execSetDepthPriorityGroup(FFrame &, void *const);
    void execSetViewOwnerDepthPriorityGroup(FFrame &, void *const);
    void execSetTraceBlocking(FFrame &, void *const);
    void execSetActorCollision(FFrame &, void *const);
    void execGetRootBodyInstance(FFrame &, void *const);
    void execSetTranslation(FFrame &, void *const);
    void execSetRotation(FFrame &, void *const);
    void execSetScale(FFrame &, void *const);
    void execSetScale3D(FFrame &, void *const);
    void execSetAbsolute(FFrame &, void *const);
    void execGetPosition(FFrame &, void *const);
    void execGetRotation(FFrame &, void *const);
    void execClosestPointOnComponentToPoint(FFrame &, void *const);
    void execClosestPointOnComponentToComponent(FFrame &, void *const);
protected:
    virtual void SetParentToWorld(const FMatrix &);
    virtual void Attach();
    virtual void UpdateTransform();
    virtual void Detach(unsigned int);
public:
    virtual void Serialize(FArchive &);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    virtual void PostEditChangeChainProperty(FPropertyChangedChainEvent &);
    virtual void PostLoad();
    virtual unsigned int IsReadyForFinishDestroy();
    virtual unsigned int NeedsLoadForClient() const;
    virtual unsigned int NeedsLoadForServer() const;
    virtual void PostCrossLevelFixup();
    void execShouldComponentAddToScene(FFrame &, void *const);
    void PushSelectionToProxy(const unsigned int);
    void PushHoveredToProxy(const unsigned int);
    void PushEditorVisibilityToProxy(unsigned __int64);
    UPrimitiveComponent();
    typedef UActorComponent Super;
private:
    static UClass *PrivateStaticClass;
public:
    static int CurrentTag;
private:
    unsigned int UPrimitiveComponentData[0x62];
};

class UCCSVisualizationComponent : public UPrimitiveComponent  // size 0x1F0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UCCSVisualizationComponent &operator=(const UCCSVisualizationComponent &);
public:
    static UClass *GetPrivateStaticClassUCCSVisualizationComponent(const wchar_t *);
    static void InitializePrivateStaticClassUCCSVisualizationComponent();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UCCSVisualizationComponent();
public:
    static void InternalConstructor(void *);
    virtual void UpdateBounds();
    virtual FPrimitiveSceneProxy *CreateSceneProxy();
    typedef UPrimitiveComponent Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UCCSVisualizationComponentData[0x4];
};

class UField : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    virtual void AddCppProperty(UProperty *);
    virtual unsigned int MergeBools();
    virtual void Bind();
private:
    UField &operator=(const UField &);
public:
    static UClass *GetPrivateStaticClassUField(const wchar_t *);
    static void InitializePrivateStaticClassUField();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UField();
public:
    static void InternalConstructor(void *);
    UField();
    UField(EStaticConstructor, const wchar_t *, const wchar_t *, unsigned __int64);
    UField(ENativeConstructor, UClass *, const wchar_t *, const wchar_t *, unsigned __int64);
    void StaticConstructor();
    virtual void Serialize(FArchive &);
    virtual void PostLoad();
    UClass *GetOwnerClass() const;
    UStruct *GetOwnerStruct() const;
private:
    virtual UObject *CreateArchetype(const wchar_t *, UObject *, UObject *, FObjectInstancingGraph *);
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UFieldData[0x1];
};

class UStruct : public UField  // size 0x74, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    virtual UStruct *GetInheritanceSuper() const;
    virtual void Link(FArchive &, unsigned int);
    virtual void SerializeBin(FArchive &, unsigned char *, int) const;
    virtual EExprToken SerializeExpr(int &, FArchive &);
    virtual void PropagateStructDefaults();
    virtual const wchar_t *GetPrefixCPP();
private:
    UStruct &operator=(const UStruct &);
public:
    static UClass *GetPrivateStaticClassUStruct(const wchar_t *);
    static void InitializePrivateStaticClassUStruct();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UStruct();
public:
    static void InternalConstructor(void *);
    UStruct(UStruct *);
    UStruct(EStaticConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64);
    UStruct(ENativeConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64, UStruct *);
protected:
    UStruct();
public:
    void StaticConstructor();
    virtual void Serialize(FArchive &);
    virtual void PostLoad();
    virtual void FinishDestroy();
    virtual void Register();
    virtual void StripData(UE3::EPlatformType, unsigned int);
    virtual void AddCppProperty(UProperty *);
    void InstanceComponentTemplates(unsigned char *, unsigned char *, int, UObject *, FObjectInstancingGraph *);
    void InstanceSubobjectTemplates(unsigned char *, unsigned char *, int, UObject *, FObjectInstancingGraph *) const;
    void SerializeBinProperty(UProperty *, FArchive &, unsigned char *) const;
    void SerializeBinEx(FArchive &, unsigned char *, unsigned char *, int) const;
    void SerializeTaggedProperties(FArchive &, unsigned char *, UStruct *, unsigned char *, int) const;
    int GetPropertiesSize() const;
    int GetMinAlignment() const;
    void SetPropertiesSize(int);
    unsigned int IsChildOf(const UStruct *) const;
    UStruct *GetSuperStruct() const;
    unsigned int StructCompare(const void *, const void *, unsigned long);
    typedef UField Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UStructData[0xD];
};

class UState : public UStruct  // size 0xBC, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
private:
    UState &operator=(const UState &);
public:
    static UClass *GetPrivateStaticClassUState(const wchar_t *);
    static void InitializePrivateStaticClassUState();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UState();
public:
    static void InternalConstructor(void *);
    UState(UState *);
    UState(EStaticConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64);
    UState(ENativeConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64, UState *);
protected:
    UState();
public:
    void StaticConstructor();
    virtual void Serialize(FArchive &);
    virtual unsigned int MergeBools();
    virtual UStruct *GetInheritanceSuper() const;
    UState *GetSuperState() const;
    typedef UStruct Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UStateData[0x12];
};

class UClass : public UState  // size 0x154, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
private:
    UClass &operator=(const UClass &);
public:
    static UClass *GetPrivateStaticClassUClass(const wchar_t *);
    static void InitializePrivateStaticClassUClass();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UClass();
public:
    static void InternalConstructor(void *);
    UPackage *GetOuterUPackage() const;
    UClass(EStaticConstructor, unsigned long, unsigned long, unsigned long, const wchar_t *, const wchar_t *, const wchar_t *, unsigned __int64, void (*)(void *), void (UObject::*)(), void (UObject::*)());
    UClass(ENativeConstructor, unsigned long, unsigned long, unsigned long, UClass *, UClass *, const wchar_t *, const wchar_t *, const wchar_t *, unsigned __int64, void (*)(void *), void (UObject::*)(), void (UObject::*)());
    UClass(UClass *);
    UClass();
    void StaticConstructor();
    virtual void Serialize(FArchive &);
    virtual void PostLoad();
    virtual void FinishDestroy();
    virtual void Register();
    virtual unsigned int Rename(const wchar_t *, UObject *, unsigned long);
    virtual UComponent *FindComponent(FName, unsigned int);
    virtual void AddReferencedObjects(TArray<UObject *,FDefaultAllocator> &);
    virtual void Bind();
    virtual void PropagateStructDefaults();
    unsigned char *GetDefaults();
    int GetDefaultsCount();
    virtual unsigned int MergeBools();
    virtual UStruct *GetInheritanceSuper() const;
    void ConditionalLink();
    virtual void Link(FArchive &, unsigned int);
    virtual const wchar_t *GetPrefixCPP();
    const FString GetConfigName() const;
    UClass *GetSuperClass() const;
    UObject *GetDefaultObject(unsigned int);
    AActor *GetDefaultActor();
    unsigned int HasAnyClassFlags(unsigned long) const;
    unsigned int HasAllClassFlags(unsigned long) const;
    unsigned int HasAnyCastFlag(EClassCastFlag) const;
    unsigned int HasAllCastFlags(EClassCastFlag) const;
    unsigned int HasNativesToExport(UObject *);
    unsigned int IsMisaligned();
    virtual FString GetDesc();
    FString GetDescription() const;
    unsigned int ChangeParentClass(UClass *);
    void EmitObjectReference(int);
    void EmitObjectArrayReference(int);
    unsigned long EmitStructArrayBegin(int, int);
    void EmitStructArrayEnd(unsigned long);
    void EmitFixedArrayBegin(int, int, int);
    void EmitFixedArrayEnd();
    void AssembleReferenceTokenStream();
    unsigned int ImplementsInterface(const UClass *) const;
    void SerializeDefaultObject(UObject *, FArchive &);
private:
    unsigned int IsA(UClass *) const;
public:
    typedef UState Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UClassData[0x26];
};

class UGripBTScriptNodeCache : public UObject  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    void eventCacheAllConditions(UGripBTInterface *);
    void eventSurveyUsedBBMembers(UGripBlackboard *);
    void eventInitializeAllNodes();
private:
    UGripBTScriptNodeCache &operator=(const UGripBTScriptNodeCache &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptNodeCache(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptNodeCache();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UGripBTScriptNodeCache();
public:
    static void InternalConstructor(void *);
protected:
    UGripBTScriptNodeCache();
public:
    typedef UObject Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UGripBTScriptNodeCacheData[0x3];
};

class UUDKAnimBlendBase : public UAnimNodeBlendList  // size 0x120, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    float GetBlendTime(int, unsigned int);
    float GetAnimDuration(int);
    void execGetBlendTime(FFrame &, void *const);
    void execGetAnimDuration(FFrame &, void *const);
    void eventTickAnim(float);
private:
    UUDKAnimBlendBase &operator=(const UUDKAnimBlendBase &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimBlendBase(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimBlendBase();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUDKAnimBlendBase();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    virtual void HandleSliderMove(int, int, float);
    typedef UAnimNodeBlendList Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UUDKAnimBlendBaseData[0x8];
};

class UHaloAnimBlendByAimProfile : public UUDKAnimBlendBase  // size 0x120, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UHaloAnimBlendByAimProfile &operator=(const UHaloAnimBlendByAimProfile &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByAimProfile(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByAimProfile();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloAnimBlendByAimProfile();
public:
    static void InternalConstructor(void *);
    void WeapTypeChanged(FName);
    typedef UUDKAnimBlendBase Super;
private:
    static UClass *PrivateStaticClass;
};

class UHaloAnimBlendByForwardMomentum : public UUDKAnimBlendBase  // size 0x120, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UHaloAnimBlendByForwardMomentum &operator=(const UHaloAnimBlendByForwardMomentum &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByForwardMomentum(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByForwardMomentum();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloAnimBlendByForwardMomentum();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    virtual int GetNumSliders() const;
    virtual ESliderType GetSliderType(int) const;
    virtual float GetSliderPosition(int, int);
    virtual FString GetSliderDrawValue(int);
    void UpdateChildWeights();
    virtual void HandleSliderMove(int, int, float);
    typedef UUDKAnimBlendBase Super;
private:
    static UClass *PrivateStaticClass;
};

class UHaloAnimBlendByJumpType : public UUDKAnimBlendBase  // size 0x130, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    virtual void OnChangeJumpType(int, unsigned int);
    void execOnChangeJumpType(FFrame &, void *const);
private:
    UHaloAnimBlendByJumpType &operator=(const UHaloAnimBlendByJumpType &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByJumpType(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByJumpType();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloAnimBlendByJumpType();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    virtual void SetActiveChild(int, float);
    virtual void OnBecomeRelevant();
    typedef UUDKAnimBlendBase Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UHaloAnimBlendByJumpTypeData[0x4];
};

class UUDKAnimBlendByPhysics : public UUDKAnimBlendBase  // size 0x170, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUDKAnimBlendByPhysics &operator=(const UUDKAnimBlendByPhysics &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimBlendByPhysics(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimBlendByPhysics();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUDKAnimBlendByPhysics();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    typedef UUDKAnimBlendBase Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UUDKAnimBlendByPhysicsData[0x14];
};

class UHaloAnimBlendByPhysics : public UUDKAnimBlendByPhysics  // size 0x180, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UHaloAnimBlendByPhysics &operator=(const UHaloAnimBlendByPhysics &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByPhysics(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByPhysics();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloAnimBlendByPhysics();
public:
    static void InternalConstructor(void *);
    virtual void SetActiveChild(int, float);
    typedef UUDKAnimBlendByPhysics Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UHaloAnimBlendByPhysicsData[0x4];
};

class UUDKAnimBlendByTurnInPlace : public UUDKAnimBlendBase  // size 0x130, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUDKAnimBlendByTurnInPlace &operator=(const UUDKAnimBlendByTurnInPlace &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimBlendByTurnInPlace(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimBlendByTurnInPlace();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUDKAnimBlendByTurnInPlace();
public:
    static void InternalConstructor(void *);
    virtual void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    virtual void TickAnim(float);
    typedef UUDKAnimBlendBase Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UUDKAnimBlendByTurnInPlaceData[0x4];
};

class UHaloAnimBlendByTurnInPlace : public UUDKAnimBlendByTurnInPlace  // size 0x130, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UHaloAnimBlendByTurnInPlace &operator=(const UHaloAnimBlendByTurnInPlace &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByTurnInPlace(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByTurnInPlace();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloAnimBlendByTurnInPlace();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    typedef UUDKAnimBlendByTurnInPlace Super;
private:
    static UClass *PrivateStaticClass;
};

class UUDKAnimNodeCopyBoneTranslation : public UAnimNodeBlendBase  // size 0x140, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUDKAnimNodeCopyBoneTranslation &operator=(const UUDKAnimNodeCopyBoneTranslation &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimNodeCopyBoneTranslation(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimNodeCopyBoneTranslation();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUDKAnimNodeCopyBoneTranslation();
public:
    static void InternalConstructor(void *);
    virtual void PostEditChangeProperty(FPropertyChangedEvent &);
    void UpdateListOfRequiredBones(FName);
    virtual void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    virtual void TickAnim(float);
    virtual void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    typedef UAnimNodeBlendBase Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UUDKAnimNodeCopyBoneTranslationData[0x18];
};

class UHaloAnimNodeCopyBoneTranslation : public UUDKAnimNodeCopyBoneTranslation  // size 0x150, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UHaloAnimNodeCopyBoneTranslation &operator=(const UHaloAnimNodeCopyBoneTranslation &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimNodeCopyBoneTranslation(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimNodeCopyBoneTranslation();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloAnimNodeCopyBoneTranslation();
public:
    static void InternalConstructor(void *);
    virtual void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    virtual void TickAnim(float);
    typedef UUDKAnimNodeCopyBoneTranslation Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UHaloAnimNodeCopyBoneTranslationData[0x4];
};

class UHaloBTKamikaze : public UCCSBTMoveTo  // size 0xD4, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UHaloBTKamikaze &operator=(const UHaloBTKamikaze &);
public:
    static UClass *GetPrivateStaticClassUHaloBTKamikaze(const wchar_t *);
    static void InitializePrivateStaticClassUHaloBTKamikaze();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloBTKamikaze();
public:
    static void InternalConstructor(void *);
    virtual GripRBTNode *CreateRuntime();
    virtual void InitializeRuntime(GripRBTNode *);
    virtual EGripBTNodeType GetType();
    virtual BTMenuType GetMenuType();
    typedef UCCSBTMoveTo Super;
private:
    static UClass *PrivateStaticClass;
    unsigned int UHaloBTKamikazeData[0x7];
};

class UUDKTargetableComponent : public UActorComponent  // size 0x84
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    void BeginDeath();
    void execBeginDeath(FFrame &, void *const);
private:
    UUDKTargetableComponent &operator=(const UUDKTargetableComponent &);
public:
    static UClass *GetPrivateStaticClassUUDKTargetableComponent(const wchar_t *);
    static void InitializePrivateStaticClassUUDKTargetableComponent();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUDKTargetableComponent();
public:
    static void InternalConstructor(void *);
    virtual void Tick(float);
    virtual void BeginPlay();
    virtual void BeginDestroy();
    AActor *GetOwner();
    typedef UActorComponent Super;
    int BaseThreatVal;  // 0x58
    float MaxAIHeat;  // 0x5C
    float CurAIHeat;  // 0x60
    float ReduceHeatPerSecond;  // 0x64
    float InnerThreatRadius;  // 0x68
    float OutterThreatRadius;  // 0x6C
    float ModifiableThreatPct;  // 0x70
    float fAITargetHeight;  // 0x74
    unsigned char AITargetType;  // 0x78
    char _pad0[0x3];
    unsigned long bAITargetable : 1;  // 0x7C
    unsigned long bIsVehicle : 1;
    AActor *myOwner;  // 0x80
private:
    static UClass *PrivateStaticClass;
};

class UUSSATBlendByAlertness : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUSSATBlendByAlertness &operator=(const UUSSATBlendByAlertness &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByAlertness(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByAlertness();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUSSATBlendByAlertness();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    typedef UCCSATBlendListBase Super;
private:
    static UClass *PrivateStaticClass;
};

class UUSSATBlendByCover : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUSSATBlendByCover &operator=(const UUSSATBlendByCover &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByCover(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByCover();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUSSATBlendByCover();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    typedef UCCSATBlendListBase Super;
private:
    static UClass *PrivateStaticClass;
};

class UUSSATBlendByCoverPose : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUSSATBlendByCoverPose &operator=(const UUSSATBlendByCoverPose &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByCoverPose(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByCoverPose();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUSSATBlendByCoverPose();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    virtual void OnCeaseRelevant();
    typedef UCCSATBlendListBase Super;
private:
    static UClass *PrivateStaticClass;
};

class UUSSATBlendByMove : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUSSATBlendByMove &operator=(const UUSSATBlendByMove &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByMove(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByMove();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUSSATBlendByMove();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    typedef UCCSATBlendListBase Super;
private:
    static UClass *PrivateStaticClass;
};

class UUSSATBlendByPosture : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
private:
    UUSSATBlendByPosture &operator=(const UUSSATBlendByPosture &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByPosture(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByPosture();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UUSSATBlendByPosture();
public:
    static void InternalConstructor(void *);
    virtual void TickAnim(float);
    typedef UCCSATBlendListBase Super;
private:
    static UClass *PrivateStaticClass;
};

#include "Core/Inc/UnObjBas.h"
#include "Core/Inc/UnScript.h"

inline UClass *AActor::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAActor(L"Engine");
        InitializePrivateStaticClassAActor();
    }
    return PrivateStaticClass;
}

inline UClass *AController::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAController(L"Engine");
        InitializePrivateStaticClassAController();
    }
    return PrivateStaticClass;
}

inline UClass *AAIController::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAAIController(L"Engine");
        InitializePrivateStaticClassAAIController();
    }
    return PrivateStaticClass;
}
inline AAIController::~AAIController() { ConditionalDestroy(); }

inline AGwNavAIController::AGwNavAIController() {}
inline UClass *AGwNavAIController::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAGwNavAIController(L"GwNavEngine");
        InitializePrivateStaticClassAGwNavAIController();
    }
    return PrivateStaticClass;
}
inline AGwNavAIController::~AGwNavAIController() { ConditionalDestroy(); }

inline UClass *AGameAIController::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAGameAIController(L"GameFramework");
        InitializePrivateStaticClassAGameAIController();
    }
    return PrivateStaticClass;
}
inline const wchar_t *AGameAIController::StaticConfigName() { return L"Game"; }

inline UClass *ACCSController::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassACCSController(L"UDKBase");
        InitializePrivateStaticClassACCSController();
    }
    return PrivateStaticClass;
}
inline ACCSController::~ACCSController() { ConditionalDestroy(); }
inline void *ACCSController::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void ACCSController::InternalConstructor(void *X) { new ((EInternal *)X) ACCSController; }

inline UClass *AKAsset::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAKAsset(L"Engine");
        InitializePrivateStaticClassAKAsset();
    }
    return PrivateStaticClass;
}
inline AKAsset::~AKAsset() { ConditionalDestroy(); }

inline UClass *AUDKCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAUDKCover(L"UDKBase");
        InitializePrivateStaticClassAUDKCover();
    }
    return PrivateStaticClass;
}
inline AUDKCover::~AUDKCover() { ConditionalDestroy(); }
inline void *AUDKCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void AUDKCover::InternalConstructor(void *X) { new ((EInternal *)X) AUDKCover; }

inline UClass *AUSSController::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAUSSController(L"UDKBase");
        InitializePrivateStaticClassAUSSController();
    }
    return PrivateStaticClass;
}
inline AUSSController::~AUSSController() { ConditionalDestroy(); }
inline void *AUSSController::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void AUSSController::InternalConstructor(void *X) { new ((EInternal *)X) AUSSController; }

inline UClass *APawn::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAPawn(L"Engine");
        InitializePrivateStaticClassAPawn();
    }
    return PrivateStaticClass;
}
inline const wchar_t *APawn::StaticConfigName() { return L"Game"; }

inline UClass *AUSSPawn::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassAUSSPawn(L"UDKBase");
        InitializePrivateStaticClassAUSSPawn();
    }
    return PrivateStaticClass;
}
inline AUSSPawn::~AUSSPawn() { ConditionalDestroy(); }
inline void *AUSSPawn::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void AUSSPawn::InternalConstructor(void *X) { new ((EInternal *)X) AUSSPawn; }

inline UClass *UGripAFActionHandle::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripAFActionHandle(L"Grip");
        InitializePrivateStaticClassUGripAFActionHandle();
    }
    return PrivateStaticClass;
}
inline UGripAFActionHandle::~UGripAFActionHandle() { ConditionalDestroy(); }

inline UClass *UCCSAFEncircleTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFEncircleTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSAFEncircleTarget();
    }
    return PrivateStaticClass;
}
inline UCCSAFEncircleTarget::~UCCSAFEncircleTarget() { ConditionalDestroy(); }
inline void *UCCSAFEncircleTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFEncircleTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFEncircleTarget; }

inline UClass *UCCSAFEnterCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFEnterCover(L"UDKBase");
        InitializePrivateStaticClassUCCSAFEnterCover();
    }
    return PrivateStaticClass;
}
inline UCCSAFEnterCover::~UCCSAFEnterCover() { ConditionalDestroy(); }
inline void *UCCSAFEnterCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFEnterCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFEnterCover; }

inline UClass *UCCSAFExitCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFExitCover(L"UDKBase");
        InitializePrivateStaticClassUCCSAFExitCover();
    }
    return PrivateStaticClass;
}
inline UCCSAFExitCover::~UCCSAFExitCover() { ConditionalDestroy(); }
inline void *UCCSAFExitCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFExitCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFExitCover; }

inline UClass *UCCSAFFireBurst::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFFireBurst(L"UDKBase");
        InitializePrivateStaticClassUCCSAFFireBurst();
    }
    return PrivateStaticClass;
}
inline UCCSAFFireBurst::~UCCSAFFireBurst() { ConditionalDestroy(); }
inline void *UCCSAFFireBurst::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFFireBurst::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFFireBurst; }

inline UClass *UCCSAFFlee::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFFlee(L"UDKBase");
        InitializePrivateStaticClassUCCSAFFlee();
    }
    return PrivateStaticClass;
}
inline UCCSAFFlee::~UCCSAFFlee() { ConditionalDestroy(); }
inline void *UCCSAFFlee::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFFlee::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFFlee; }

inline UClass *UCCSAFGetInCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFGetInCover(L"UDKBase");
        InitializePrivateStaticClassUCCSAFGetInCover();
    }
    return PrivateStaticClass;
}
inline UCCSAFGetInCover::~UCCSAFGetInCover() { ConditionalDestroy(); }
inline void *UCCSAFGetInCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFGetInCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFGetInCover; }

inline UClass *UCCSAFGetOutCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFGetOutCover(L"UDKBase");
        InitializePrivateStaticClassUCCSAFGetOutCover();
    }
    return PrivateStaticClass;
}
inline UCCSAFGetOutCover::~UCCSAFGetOutCover() { ConditionalDestroy(); }
inline void *UCCSAFGetOutCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFGetOutCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFGetOutCover; }

inline UClass *UCCSAFIdle::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFIdle(L"UDKBase");
        InitializePrivateStaticClassUCCSAFIdle();
    }
    return PrivateStaticClass;
}
inline UCCSAFIdle::~UCCSAFIdle() { ConditionalDestroy(); }
inline void *UCCSAFIdle::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFIdle::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFIdle; }

inline UClass *UCCSAFMoveTo::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFMoveTo(L"UDKBase");
        InitializePrivateStaticClassUCCSAFMoveTo();
    }
    return PrivateStaticClass;
}
inline UCCSAFMoveTo::~UCCSAFMoveTo() { ConditionalDestroy(); }
inline void *UCCSAFMoveTo::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFMoveTo::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFMoveTo; }

inline UClass *UCCSAFMoveToActor::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFMoveToActor(L"UDKBase");
        InitializePrivateStaticClassUCCSAFMoveToActor();
    }
    return PrivateStaticClass;
}
inline UCCSAFMoveToActor::~UCCSAFMoveToActor() { ConditionalDestroy(); }
inline void *UCCSAFMoveToActor::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFMoveToActor::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFMoveToActor; }

inline UClass *UCCSAFOrientToward::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFOrientToward(L"UDKBase");
        InitializePrivateStaticClassUCCSAFOrientToward();
    }
    return PrivateStaticClass;
}
inline UCCSAFOrientToward::~UCCSAFOrientToward() { ConditionalDestroy(); }
inline void *UCCSAFOrientToward::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFOrientToward::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFOrientToward; }

inline UClass *UCCSAFStrafeTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFStrafeTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSAFStrafeTarget();
    }
    return PrivateStaticClass;
}
inline UCCSAFStrafeTarget::~UCCSAFStrafeTarget() { ConditionalDestroy(); }
inline void *UCCSAFStrafeTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFStrafeTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFStrafeTarget; }

inline UClass *UCCSAFStrafeTo::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSAFStrafeTo(L"UDKBase");
        InitializePrivateStaticClassUCCSAFStrafeTo();
    }
    return PrivateStaticClass;
}
inline UCCSAFStrafeTo::~UCCSAFStrafeTo() { ConditionalDestroy(); }
inline void *UCCSAFStrafeTo::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSAFStrafeTo::InternalConstructor(void *X) { new ((EInternal *)X) UCCSAFStrafeTo; }

inline UClass *UAnimObject::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUAnimObject(L"Engine");
        InitializePrivateStaticClassUAnimObject();
    }
    return PrivateStaticClass;
}
inline UAnimObject::~UAnimObject() { ConditionalDestroy(); }

inline UClass *UAnimNode::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUAnimNode(L"Engine");
        InitializePrivateStaticClassUAnimNode();
    }
    return PrivateStaticClass;
}

inline UClass *UAnimNodeBlendBase::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUAnimNodeBlendBase(L"Engine");
        InitializePrivateStaticClassUAnimNodeBlendBase();
    }
    return PrivateStaticClass;
}

inline UClass *UAnimNodeSlot::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUAnimNodeSlot(L"Engine");
        InitializePrivateStaticClassUAnimNodeSlot();
    }
    return PrivateStaticClass;
}

inline UCCSATAnimNodeSlot::UCCSATAnimNodeSlot() {}
inline UClass *UCCSATAnimNodeSlot::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSATAnimNodeSlot(L"UDKBase");
        InitializePrivateStaticClassUCCSATAnimNodeSlot();
    }
    return PrivateStaticClass;
}
inline UCCSATAnimNodeSlot::~UCCSATAnimNodeSlot() { ConditionalDestroy(); }
inline void *UCCSATAnimNodeSlot::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSATAnimNodeSlot::InternalConstructor(void *X) { new ((EInternal *)X) UCCSATAnimNodeSlot; }

inline UClass *UAnimNodeBlendList::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUAnimNodeBlendList(L"Engine");
        InitializePrivateStaticClassUAnimNodeBlendList();
    }
    return PrivateStaticClass;
}

inline UCCSATBlendListBase::UCCSATBlendListBase() {}
inline UClass *UCCSATBlendListBase::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSATBlendListBase(L"UDKBase");
        InitializePrivateStaticClassUCCSATBlendListBase();
    }
    return PrivateStaticClass;
}
inline UCCSATBlendListBase::~UCCSATBlendListBase() { ConditionalDestroy(); }
inline void *UCCSATBlendListBase::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSATBlendListBase::InternalConstructor(void *X) { new ((EInternal *)X) UCCSATBlendListBase; }

inline UClass *UActorFactory::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUActorFactory(L"Engine");
        InitializePrivateStaticClassUActorFactory();
    }
    return PrivateStaticClass;
}

inline UClass *UActorFactoryAI::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUActorFactoryAI(L"Engine");
        InitializePrivateStaticClassUActorFactoryAI();
    }
    return PrivateStaticClass;
}

inline UClass *UGwNavActorFactoryAI::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGwNavActorFactoryAI(L"GwNavEngine");
        InitializePrivateStaticClassUGwNavActorFactoryAI();
    }
    return PrivateStaticClass;
}
inline UGwNavActorFactoryAI::~UGwNavActorFactoryAI() { ConditionalDestroy(); }

inline UClass *UCCSActorFactory::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSActorFactory(L"UDKBase");
        InitializePrivateStaticClassUCCSActorFactory();
    }
    return PrivateStaticClass;
}
inline UCCSActorFactory::~UCCSActorFactory() { ConditionalDestroy(); }
inline void *UCCSActorFactory::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSActorFactory::InternalConstructor(void *X) { new ((EInternal *)X) UCCSActorFactory; }

inline UClass *UGripBTObject::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTObject(L"Grip");
        InitializePrivateStaticClassUGripBTObject();
    }
    return PrivateStaticClass;
}
inline UGripBTObject::~UGripBTObject() { ConditionalDestroy(); }

inline UClass *UGripBTNode::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTNode(L"Grip");
        InitializePrivateStaticClassUGripBTNode();
    }
    return PrivateStaticClass;
}

inline UClass *UCCSBTEncircleTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTEncircleTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSBTEncircleTarget();
    }
    return PrivateStaticClass;
}
inline UCCSBTEncircleTarget::~UCCSBTEncircleTarget() { ConditionalDestroy(); }
inline void *UCCSBTEncircleTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTEncircleTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTEncircleTarget; }

inline UClass *UGripBTBooleanCondition::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTBooleanCondition(L"Grip");
        InitializePrivateStaticClassUGripBTBooleanCondition();
    }
    return PrivateStaticClass;
}
inline UGripBTBooleanCondition::~UGripBTBooleanCondition() { ConditionalDestroy(); }

inline UClass *UCCSBTEnemyAware::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTEnemyAware(L"UDKBase");
        InitializePrivateStaticClassUCCSBTEnemyAware();
    }
    return PrivateStaticClass;
}
inline UCCSBTEnemyAware::~UCCSBTEnemyAware() { ConditionalDestroy(); }
inline void *UCCSBTEnemyAware::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTEnemyAware::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTEnemyAware; }

inline UClass *UGripBTNumericCondition::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTNumericCondition(L"Grip");
        InitializePrivateStaticClassUGripBTNumericCondition();
    }
    return PrivateStaticClass;
}
inline UGripBTNumericCondition::~UGripBTNumericCondition() { ConditionalDestroy(); }

inline UClass *UCCSBTEnemyClosestRange::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTEnemyClosestRange(L"UDKBase");
        InitializePrivateStaticClassUCCSBTEnemyClosestRange();
    }
    return PrivateStaticClass;
}
inline UCCSBTEnemyClosestRange::~UCCSBTEnemyClosestRange() { ConditionalDestroy(); }
inline void *UCCSBTEnemyClosestRange::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTEnemyClosestRange::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTEnemyClosestRange; }

inline UClass *UGripBTFloatCondition::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTFloatCondition(L"Grip");
        InitializePrivateStaticClassUGripBTFloatCondition();
    }
    return PrivateStaticClass;
}
inline UGripBTFloatCondition::~UGripBTFloatCondition() { ConditionalDestroy(); }

inline UClass *UCCSBTEnemyLowestLKPAge::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTEnemyLowestLKPAge(L"UDKBase");
        InitializePrivateStaticClassUCCSBTEnemyLowestLKPAge();
    }
    return PrivateStaticClass;
}
inline UCCSBTEnemyLowestLKPAge::~UCCSBTEnemyLowestLKPAge() { ConditionalDestroy(); }
inline void *UCCSBTEnemyLowestLKPAge::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTEnemyLowestLKPAge::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTEnemyLowestLKPAge; }

inline UClass *UCCSBTFlee::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTFlee(L"UDKBase");
        InitializePrivateStaticClassUCCSBTFlee();
    }
    return PrivateStaticClass;
}
inline UCCSBTFlee::~UCCSBTFlee() { ConditionalDestroy(); }
inline void *UCCSBTFlee::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTFlee::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTFlee; }

inline UClass *UCCSBTIdle::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTIdle(L"UDKBase");
        InitializePrivateStaticClassUCCSBTIdle();
    }
    return PrivateStaticClass;
}
inline UCCSBTIdle::~UCCSBTIdle() { ConditionalDestroy(); }
inline void *UCCSBTIdle::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTIdle::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTIdle; }

inline UClass *UCCSBTMoveTo::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveTo(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveTo();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveTo::~UCCSBTMoveTo() { ConditionalDestroy(); }
inline void *UCCSBTMoveTo::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveTo::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveTo; }

inline UCCSBTMoveIntoCover::UCCSBTMoveIntoCover() {}
inline UClass *UCCSBTMoveIntoCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveIntoCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveIntoCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveIntoCover::~UCCSBTMoveIntoCover() { ConditionalDestroy(); }
inline void *UCCSBTMoveIntoCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveIntoCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveIntoCover; }

inline UClass *UCCSBTMoveIntoBestCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveIntoBestCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveIntoBestCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveIntoBestCover::~UCCSBTMoveIntoBestCover() { ConditionalDestroy(); }
inline void *UCCSBTMoveIntoBestCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveIntoBestCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveIntoBestCover; }

inline UClass *UCCSBTMoveIntoClosestCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveIntoClosestCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveIntoClosestCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveIntoClosestCover::~UCCSBTMoveIntoClosestCover() { ConditionalDestroy(); }
inline void *UCCSBTMoveIntoClosestCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveIntoClosestCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveIntoClosestCover; }

inline UClass *UCCSBTMoveIntoInitialCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveIntoInitialCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveIntoInitialCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveIntoInitialCover::~UCCSBTMoveIntoInitialCover() { ConditionalDestroy(); }
inline void *UCCSBTMoveIntoInitialCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveIntoInitialCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveIntoInitialCover; }

inline UClass *UCCSBTMoveToActor::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveToActor(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveToActor();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveToActor::~UCCSBTMoveToActor() { ConditionalDestroy(); }
inline void *UCCSBTMoveToActor::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveToActor::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveToActor; }

inline UClass *UCCSBTMoveToTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveToTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveToTarget();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveToTarget::~UCCSBTMoveToTarget() { ConditionalDestroy(); }
inline void *UCCSBTMoveToTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveToTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveToTarget; }

inline UClass *UCCSBTMoveToTether::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveToTether(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveToTether();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveToTether::~UCCSBTMoveToTether() { ConditionalDestroy(); }
inline void *UCCSBTMoveToTether::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveToTether::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveToTether; }

inline UClass *UCCSBTMoveToVehicle::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTMoveToVehicle(L"UDKBase");
        InitializePrivateStaticClassUCCSBTMoveToVehicle();
    }
    return PrivateStaticClass;
}
inline UCCSBTMoveToVehicle::~UCCSBTMoveToVehicle() { ConditionalDestroy(); }
inline void *UCCSBTMoveToVehicle::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTMoveToVehicle::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTMoveToVehicle; }

inline UClass *UCCSBTOrientTowardTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTOrientTowardTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSBTOrientTowardTarget();
    }
    return PrivateStaticClass;
}
inline UCCSBTOrientTowardTarget::~UCCSBTOrientTowardTarget() { ConditionalDestroy(); }
inline void *UCCSBTOrientTowardTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTOrientTowardTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTOrientTowardTarget; }

inline UClass *UGripBTScriptNode::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTScriptNode(L"Grip");
        InitializePrivateStaticClassUGripBTScriptNode();
    }
    return PrivateStaticClass;
}
inline UGripBTScriptNode::~UGripBTScriptNode() { ConditionalDestroy(); }

inline UClass *UGripBTScriptBehavior::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTScriptBehavior(L"Grip");
        InitializePrivateStaticClassUGripBTScriptBehavior();
    }
    return PrivateStaticClass;
}
inline UGripBTScriptBehavior::~UGripBTScriptBehavior() { ConditionalDestroy(); }

inline UCCSBTScriptBehavior::UCCSBTScriptBehavior() {}
inline UClass *UCCSBTScriptBehavior::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTScriptBehavior(L"UDKBase");
        InitializePrivateStaticClassUCCSBTScriptBehavior();
    }
    return PrivateStaticClass;
}
inline UCCSBTScriptBehavior::~UCCSBTScriptBehavior() { ConditionalDestroy(); }
inline void *UCCSBTScriptBehavior::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTScriptBehavior::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTScriptBehavior; }

inline UClass *UGripBTScriptCondition::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTScriptCondition(L"Grip");
        InitializePrivateStaticClassUGripBTScriptCondition();
    }
    return PrivateStaticClass;
}
inline UGripBTScriptCondition::~UGripBTScriptCondition() { ConditionalDestroy(); }

inline UCCSBTScriptCondition::UCCSBTScriptCondition() {}
inline UClass *UCCSBTScriptCondition::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTScriptCondition(L"UDKBase");
        InitializePrivateStaticClassUCCSBTScriptCondition();
    }
    return PrivateStaticClass;
}
inline UCCSBTScriptCondition::~UCCSBTScriptCondition() { ConditionalDestroy(); }
inline void *UCCSBTScriptCondition::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTScriptCondition::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTScriptCondition; }

inline UClass *UCCSBTScriptCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTScriptCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTScriptCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTScriptCover::~UCCSBTScriptCover() { ConditionalDestroy(); }
inline void *UCCSBTScriptCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTScriptCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTScriptCover; }

inline UClass *UCCSBTSearch::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTSearch(L"UDKBase");
        InitializePrivateStaticClassUCCSBTSearch();
    }
    return PrivateStaticClass;
}
inline UCCSBTSearch::~UCCSBTSearch() { ConditionalDestroy(); }
inline void *UCCSBTSearch::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTSearch::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTSearch; }

inline UClass *UCCSBTSelectTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTSelectTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSBTSelectTarget();
    }
    return PrivateStaticClass;
}
inline UCCSBTSelectTarget::~UCCSBTSelectTarget() { ConditionalDestroy(); }
inline void *UCCSBTSelectTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTSelectTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTSelectTarget; }

inline UClass *UCCSBTShoot::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTShoot(L"UDKBase");
        InitializePrivateStaticClassUCCSBTShoot();
    }
    return PrivateStaticClass;
}
inline UCCSBTShoot::~UCCSBTShoot() { ConditionalDestroy(); }
inline void *UCCSBTShoot::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTShoot::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTShoot; }

inline UClass *UCCSBTShootFromCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTShootFromCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTShootFromCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTShootFromCover::~UCCSBTShootFromCover() { ConditionalDestroy(); }
inline void *UCCSBTShootFromCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTShootFromCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTShootFromCover; }

inline UClass *UCCSBTStrafeTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTStrafeTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSBTStrafeTarget();
    }
    return PrivateStaticClass;
}
inline UCCSBTStrafeTarget::~UCCSBTStrafeTarget() { ConditionalDestroy(); }
inline void *UCCSBTStrafeTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTStrafeTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTStrafeTarget; }

inline UClass *UCCSBTTargetAngle::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetAngle(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetAngle();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetAngle::~UCCSBTTargetAngle() { ConditionalDestroy(); }
inline void *UCCSBTTargetAngle::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetAngle::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetAngle; }

inline UClass *UCCSBTTargetClear::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetClear(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetClear();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetClear::~UCCSBTTargetClear() { ConditionalDestroy(); }
inline void *UCCSBTTargetClear::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetClear::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetClear; }

inline UClass *UCCSBTTargetInCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetInCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetInCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetInCover::~UCCSBTTargetInCover() { ConditionalDestroy(); }
inline void *UCCSBTTargetInCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetInCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetInCover; }

inline UClass *UCCSBTTargetKnockedDown::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetKnockedDown(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetKnockedDown();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetKnockedDown::~UCCSBTTargetKnockedDown() { ConditionalDestroy(); }
inline void *UCCSBTTargetKnockedDown::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetKnockedDown::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetKnockedDown; }

inline UClass *UCCSBTTargetRange::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetRange(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetRange();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetRange::~UCCSBTTargetRange() { ConditionalDestroy(); }
inline void *UCCSBTTargetRange::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetRange::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetRange; }

inline UClass *UCCSBTTargetShootable::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetShootable(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetShootable();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetShootable::~UCCSBTTargetShootable() { ConditionalDestroy(); }
inline void *UCCSBTTargetShootable::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetShootable::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetShootable; }

inline UClass *UCCSBTTargetVisible::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTargetVisible(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTargetVisible();
    }
    return PrivateStaticClass;
}
inline UCCSBTTargetVisible::~UCCSBTTargetVisible() { ConditionalDestroy(); }
inline void *UCCSBTTargetVisible::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTargetVisible::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTargetVisible; }

inline UClass *UCCSBTTimeSinceAimedAt::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceAimedAt(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceAimedAt();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceAimedAt::~UCCSBTTimeSinceAimedAt() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceAimedAt::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceAimedAt::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceAimedAt; }

inline UClass *UCCSBTTimeSinceBecameAware::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceBecameAware(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceBecameAware();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceBecameAware::~UCCSBTTimeSinceBecameAware() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceBecameAware::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceBecameAware::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceBecameAware; }

inline UClass *UCCSBTTimeSinceDamage::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceDamage(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceDamage();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceDamage::~UCCSBTTimeSinceDamage() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceDamage::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceDamage::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceDamage; }

inline UClass *UCCSBTTimeSinceEvent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceEvent(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceEvent();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceEvent::~UCCSBTTimeSinceEvent() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceEvent::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceEvent::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceEvent; }

inline UClass *UCCSBTTimeSinceGrenadeStuck::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceGrenadeStuck(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceGrenadeStuck();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceGrenadeStuck::~UCCSBTTimeSinceGrenadeStuck() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceGrenadeStuck::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceGrenadeStuck::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceGrenadeStuck; }

inline UClass *UCCSBTTimeSinceStaggered::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceStaggered(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceStaggered();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceStaggered::~UCCSBTTimeSinceStaggered() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceStaggered::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceStaggered::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceStaggered; }

inline UClass *UCCSBTTimeSinceSuccessfulAttack::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceSuccessfulAttack(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceSuccessfulAttack();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceSuccessfulAttack::~UCCSBTTimeSinceSuccessfulAttack() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceSuccessfulAttack::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceSuccessfulAttack::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceSuccessfulAttack; }

inline UClass *UCCSBTTimeSinceTargetCamoed::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceTargetCamoed(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceTargetCamoed();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceTargetCamoed::~UCCSBTTimeSinceTargetCamoed() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceTargetCamoed::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceTargetCamoed::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceTargetCamoed; }

inline UClass *UCCSBTTimeSinceThreatChanged::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceThreatChanged(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceThreatChanged();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceThreatChanged::~UCCSBTTimeSinceThreatChanged() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceThreatChanged::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceThreatChanged::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceThreatChanged; }

inline UClass *UCCSBTTimeSinceThreatened::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTimeSinceThreatened(L"UDKBase");
        InitializePrivateStaticClassUCCSBTTimeSinceThreatened();
    }
    return PrivateStaticClass;
}
inline UCCSBTTimeSinceThreatened::~UCCSBTTimeSinceThreatened() { ConditionalDestroy(); }
inline void *UCCSBTTimeSinceThreatened::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTimeSinceThreatened::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTimeSinceThreatened; }

inline UClass *UCCSBTVisibleToPlayerCamera::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTVisibleToPlayerCamera(L"UDKBase");
        InitializePrivateStaticClassUCCSBTVisibleToPlayerCamera();
    }
    return PrivateStaticClass;
}
inline UCCSBTVisibleToPlayerCamera::~UCCSBTVisibleToPlayerCamera() { ConditionalDestroy(); }
inline void *UCCSBTVisibleToPlayerCamera::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTVisibleToPlayerCamera::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTVisibleToPlayerCamera; }

inline UClass *UCCSBTWaitInCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTWaitInCover(L"UDKBase");
        InitializePrivateStaticClassUCCSBTWaitInCover();
    }
    return PrivateStaticClass;
}
inline UCCSBTWaitInCover::~UCCSBTWaitInCover() { ConditionalDestroy(); }
inline void *UCCSBTWaitInCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTWaitInCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTWaitInCover; }

inline UClass *UGripBlackboard::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBlackboard(L"Grip");
        InitializePrivateStaticClassUGripBlackboard();
    }
    return PrivateStaticClass;
}
inline UGripBlackboard::~UGripBlackboard() { ConditionalDestroy(); }

inline UCCSBlackboard::UCCSBlackboard() {}
inline UClass *UCCSBlackboard::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBlackboard(L"UDKBase");
        InitializePrivateStaticClassUCCSBlackboard();
    }
    return PrivateStaticClass;
}
inline UCCSBlackboard::~UCCSBlackboard() { ConditionalDestroy(); }
inline void *UCCSBlackboard::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBlackboard::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBlackboard; }

inline UCCSCover::UCCSCover() {}
inline UClass *UCCSCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSCover(L"UDKBase");
        InitializePrivateStaticClassUCCSCover();
    }
    return PrivateStaticClass;
}
inline UCCSCover::~UCCSCover() { ConditionalDestroy(); }
inline void *UCCSCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSCover::InternalConstructor(void *X) { new ((EInternal *)X) UCCSCover; }

inline UInterface::UInterface() {}
inline UClass *UInterface::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUInterface(L"Core");
        InitializePrivateStaticClassUInterface();
    }
    return PrivateStaticClass;
}
inline UInterface::~UInterface() { ConditionalDestroy(); }

inline UCCSPawn::UCCSPawn() {}
inline UClass *UCCSPawn::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSPawn(L"UDKBase");
        InitializePrivateStaticClassUCCSPawn();
    }
    return PrivateStaticClass;
}
inline UCCSPawn::~UCCSPawn() { ConditionalDestroy(); }
inline void *UCCSPawn::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSPawn::InternalConstructor(void *X) { new ((EInternal *)X) UCCSPawn; }

inline UCCSSystemConfig::UCCSSystemConfig() {}
inline UClass *UCCSSystemConfig::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSSystemConfig(L"UDKBase");
        InitializePrivateStaticClassUCCSSystemConfig();
    }
    return PrivateStaticClass;
}
inline UCCSSystemConfig::~UCCSSystemConfig() { ConditionalDestroy(); }
inline void *UCCSSystemConfig::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSSystemConfig::InternalConstructor(void *X) { new ((EInternal *)X) UCCSSystemConfig; }

inline UCCSTarget::UCCSTarget() {}
inline UClass *UCCSTarget::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSTarget(L"UDKBase");
        InitializePrivateStaticClassUCCSTarget();
    }
    return PrivateStaticClass;
}
inline UCCSTarget::~UCCSTarget() { ConditionalDestroy(); }
inline void *UCCSTarget::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSTarget::InternalConstructor(void *X) { new ((EInternal *)X) UCCSTarget; }

inline UClass *UComponent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUComponent(L"Core");
        InitializePrivateStaticClassUComponent();
    }
    return PrivateStaticClass;
}
inline UComponent::~UComponent() { ConditionalDestroy(); }

inline UClass *UActorComponent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUActorComponent(L"Engine");
        InitializePrivateStaticClassUActorComponent();
    }
    return PrivateStaticClass;
}
inline UActorComponent::~UActorComponent() { ConditionalDestroy(); }

inline UPrimitiveComponent::UPrimitiveComponent() {}
inline UClass *UPrimitiveComponent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUPrimitiveComponent(L"Engine");
        InitializePrivateStaticClassUPrimitiveComponent();
    }
    return PrivateStaticClass;
}

inline UClass *UCCSVisualizationComponent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSVisualizationComponent(L"UDKBase");
        InitializePrivateStaticClassUCCSVisualizationComponent();
    }
    return PrivateStaticClass;
}
inline UCCSVisualizationComponent::~UCCSVisualizationComponent() { ConditionalDestroy(); }
inline void *UCCSVisualizationComponent::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSVisualizationComponent::InternalConstructor(void *X) { new ((EInternal *)X) UCCSVisualizationComponent; }

inline UClass *UUDKAnimBlendBase::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUDKAnimBlendBase(L"UDKBase");
        InitializePrivateStaticClassUUDKAnimBlendBase();
    }
    return PrivateStaticClass;
}

inline UClass *UHaloAnimBlendByAimProfile::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloAnimBlendByAimProfile(L"UDKBase");
        InitializePrivateStaticClassUHaloAnimBlendByAimProfile();
    }
    return PrivateStaticClass;
}
inline UHaloAnimBlendByAimProfile::~UHaloAnimBlendByAimProfile() { ConditionalDestroy(); }
inline void *UHaloAnimBlendByAimProfile::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloAnimBlendByAimProfile::InternalConstructor(void *X) { new ((EInternal *)X) UHaloAnimBlendByAimProfile; }

inline UClass *UHaloAnimBlendByForwardMomentum::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloAnimBlendByForwardMomentum(L"UDKBase");
        InitializePrivateStaticClassUHaloAnimBlendByForwardMomentum();
    }
    return PrivateStaticClass;
}
inline UHaloAnimBlendByForwardMomentum::~UHaloAnimBlendByForwardMomentum() { ConditionalDestroy(); }
inline void *UHaloAnimBlendByForwardMomentum::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloAnimBlendByForwardMomentum::InternalConstructor(void *X) { new ((EInternal *)X) UHaloAnimBlendByForwardMomentum; }

inline UClass *UHaloAnimBlendByJumpType::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloAnimBlendByJumpType(L"UDKBase");
        InitializePrivateStaticClassUHaloAnimBlendByJumpType();
    }
    return PrivateStaticClass;
}
inline UHaloAnimBlendByJumpType::~UHaloAnimBlendByJumpType() { ConditionalDestroy(); }
inline void *UHaloAnimBlendByJumpType::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloAnimBlendByJumpType::InternalConstructor(void *X) { new ((EInternal *)X) UHaloAnimBlendByJumpType; }

inline UClass *UUDKAnimBlendByPhysics::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUDKAnimBlendByPhysics(L"UDKBase");
        InitializePrivateStaticClassUUDKAnimBlendByPhysics();
    }
    return PrivateStaticClass;
}
inline UUDKAnimBlendByPhysics::~UUDKAnimBlendByPhysics() { ConditionalDestroy(); }

inline UClass *UHaloAnimBlendByPhysics::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloAnimBlendByPhysics(L"UDKBase");
        InitializePrivateStaticClassUHaloAnimBlendByPhysics();
    }
    return PrivateStaticClass;
}
inline UHaloAnimBlendByPhysics::~UHaloAnimBlendByPhysics() { ConditionalDestroy(); }
inline void *UHaloAnimBlendByPhysics::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloAnimBlendByPhysics::InternalConstructor(void *X) { new ((EInternal *)X) UHaloAnimBlendByPhysics; }

inline UClass *UUDKAnimBlendByTurnInPlace::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUDKAnimBlendByTurnInPlace(L"UDKBase");
        InitializePrivateStaticClassUUDKAnimBlendByTurnInPlace();
    }
    return PrivateStaticClass;
}
inline UUDKAnimBlendByTurnInPlace::~UUDKAnimBlendByTurnInPlace() { ConditionalDestroy(); }

inline UClass *UHaloAnimBlendByTurnInPlace::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloAnimBlendByTurnInPlace(L"UDKBase");
        InitializePrivateStaticClassUHaloAnimBlendByTurnInPlace();
    }
    return PrivateStaticClass;
}
inline UHaloAnimBlendByTurnInPlace::~UHaloAnimBlendByTurnInPlace() { ConditionalDestroy(); }
inline void *UHaloAnimBlendByTurnInPlace::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloAnimBlendByTurnInPlace::InternalConstructor(void *X) { new ((EInternal *)X) UHaloAnimBlendByTurnInPlace; }

inline UClass *UUDKAnimNodeCopyBoneTranslation::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUDKAnimNodeCopyBoneTranslation(L"UDKBase");
        InitializePrivateStaticClassUUDKAnimNodeCopyBoneTranslation();
    }
    return PrivateStaticClass;
}

inline UClass *UHaloAnimNodeCopyBoneTranslation::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloAnimNodeCopyBoneTranslation(L"UDKBase");
        InitializePrivateStaticClassUHaloAnimNodeCopyBoneTranslation();
    }
    return PrivateStaticClass;
}
inline UHaloAnimNodeCopyBoneTranslation::~UHaloAnimNodeCopyBoneTranslation() { ConditionalDestroy(); }
inline void *UHaloAnimNodeCopyBoneTranslation::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloAnimNodeCopyBoneTranslation::InternalConstructor(void *X) { new ((EInternal *)X) UHaloAnimNodeCopyBoneTranslation; }

inline UClass *UHaloBTKamikaze::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloBTKamikaze(L"UDKBase");
        InitializePrivateStaticClassUHaloBTKamikaze();
    }
    return PrivateStaticClass;
}
inline UHaloBTKamikaze::~UHaloBTKamikaze() { ConditionalDestroy(); }
inline void *UHaloBTKamikaze::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloBTKamikaze::InternalConstructor(void *X) { new ((EInternal *)X) UHaloBTKamikaze; }

inline UClass *UUDKTargetableComponent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUDKTargetableComponent(L"UDKBase");
        InitializePrivateStaticClassUUDKTargetableComponent();
    }
    return PrivateStaticClass;
}
inline UUDKTargetableComponent::~UUDKTargetableComponent() { ConditionalDestroy(); }
inline void *UUDKTargetableComponent::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UUDKTargetableComponent::InternalConstructor(void *X) { new ((EInternal *)X) UUDKTargetableComponent; }

inline UClass *UUSSATBlendByAlertness::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUSSATBlendByAlertness(L"UDKBase");
        InitializePrivateStaticClassUUSSATBlendByAlertness();
    }
    return PrivateStaticClass;
}
inline UUSSATBlendByAlertness::~UUSSATBlendByAlertness() { ConditionalDestroy(); }
inline void *UUSSATBlendByAlertness::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UUSSATBlendByAlertness::InternalConstructor(void *X) { new ((EInternal *)X) UUSSATBlendByAlertness; }

inline UClass *UUSSATBlendByCover::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUSSATBlendByCover(L"UDKBase");
        InitializePrivateStaticClassUUSSATBlendByCover();
    }
    return PrivateStaticClass;
}
inline UUSSATBlendByCover::~UUSSATBlendByCover() { ConditionalDestroy(); }
inline void *UUSSATBlendByCover::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UUSSATBlendByCover::InternalConstructor(void *X) { new ((EInternal *)X) UUSSATBlendByCover; }

inline UClass *UUSSATBlendByCoverPose::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUSSATBlendByCoverPose(L"UDKBase");
        InitializePrivateStaticClassUUSSATBlendByCoverPose();
    }
    return PrivateStaticClass;
}
inline UUSSATBlendByCoverPose::~UUSSATBlendByCoverPose() { ConditionalDestroy(); }
inline void *UUSSATBlendByCoverPose::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UUSSATBlendByCoverPose::InternalConstructor(void *X) { new ((EInternal *)X) UUSSATBlendByCoverPose; }

inline UClass *UUSSATBlendByMove::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUSSATBlendByMove(L"UDKBase");
        InitializePrivateStaticClassUUSSATBlendByMove();
    }
    return PrivateStaticClass;
}
inline UUSSATBlendByMove::~UUSSATBlendByMove() { ConditionalDestroy(); }
inline void *UUSSATBlendByMove::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UUSSATBlendByMove::InternalConstructor(void *X) { new ((EInternal *)X) UUSSATBlendByMove; }

inline UClass *UUSSATBlendByPosture::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUUSSATBlendByPosture(L"UDKBase");
        InitializePrivateStaticClassUUSSATBlendByPosture();
    }
    return PrivateStaticClass;
}
inline UUSSATBlendByPosture::~UUSSATBlendByPosture() { ConditionalDestroy(); }
inline void *UUSSATBlendByPosture::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UUSSATBlendByPosture::InternalConstructor(void *X) { new ((EInternal *)X) UUSSATBlendByPosture; }

extern FName UDKBASE_ActionStopFiring;
extern FName UDKBASE_AimAt;
extern FName UDKBASE_CacheAllConditions;
extern FName UDKBASE_CanFireAt;
extern FName UDKBASE_CreateDebugVizComponent;
extern FName UDKBASE_ExecuteVehicleCommand;
extern FName UDKBASE_FindNavMeshDistance;
extern FName UDKBASE_FindNavMeshPath;
extern FName UDKBASE_FireWeapon;
extern FName UDKBASE_InitializeAllNodes;
extern FName UDKBASE_NotifyAIMoveToActorCompleted;
extern FName UDKBASE_SetDisabled;
extern FName UDKBASE_StartFireBurst;
extern FName UDKBASE_StartFireBurstObj;
extern FName UDKBASE_StopFireBurst;
extern FName UDKBASE_SurveyUsedBBMembers;

inline FVector::FVector() {}
inline FRotator::FRotator() {}
inline GwNavVehicle_eventExecuteVehicleCommand_Parms::GwNavVehicle_eventExecuteVehicleCommand_Parms(EEventParm) {}
inline CCSController_eventCreateDebugVizComponent_Parms::CCSController_eventCreateDebugVizComponent_Parms(EEventParm) {}
inline CCSController_eventFindNavMeshDistance_Parms::CCSController_eventFindNavMeshDistance_Parms(EEventParm) {}
inline CCSController_eventFindNavMeshPath_Parms::CCSController_eventFindNavMeshPath_Parms(EEventParm) {}
inline CCSController_eventActionStopFiring_Parms::CCSController_eventActionStopFiring_Parms(EEventParm) {}
inline CCSController_eventAimAt_Parms::CCSController_eventAimAt_Parms(EEventParm) {}
inline CCSController_eventFireWeapon_Parms::CCSController_eventFireWeapon_Parms(EEventParm) {}
inline CCSController_eventStopFireBurst_Parms::CCSController_eventStopFireBurst_Parms(EEventParm) {}
inline CCSController_eventStartFireBurstObj_Parms::CCSController_eventStartFireBurstObj_Parms(EEventParm) {}
inline CCSController_eventStartFireBurst_Parms::CCSController_eventStartFireBurst_Parms(EEventParm) {}
inline CCSController_eventCanFireAt_Parms::CCSController_eventCanFireAt_Parms(EEventParm) {}
inline CCSController_eventNotifyAIMoveToActorCompleted_Parms::CCSController_eventNotifyAIMoveToActorCompleted_Parms(EEventParm) {}
inline GripBTScriptNodeCache_eventCacheAllConditions_Parms::GripBTScriptNodeCache_eventCacheAllConditions_Parms(EEventParm) {}
inline GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms::GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms(EEventParm) {}
inline GripBTScriptNodeCache_eventInitializeAllNodes_Parms::GripBTScriptNodeCache_eventInitializeAllNodes_Parms(EEventParm) {}
inline CoverLink_eventSetDisabled_Parms::CoverLink_eventSetDisabled_Parms(EEventParm) {}
inline void AGwNavVehicle::eventExecuteVehicleCommand(unsigned char HVC)
{
    GwNavVehicle_eventExecuteVehicleCommand_Parms Parms(EC_EventParm);
    Parms.HVC = HVC;
    ProcessEvent(FindFunctionChecked(UDKBASE_ExecuteVehicleCommand, 0), &Parms, 0);
}

inline void ACCSController::eventCreateDebugVizComponent()
{
    ProcessEvent(FindFunctionChecked(UDKBASE_CreateDebugVizComponent, 0), 0, 0);
}

inline unsigned int ACCSController::eventFindNavMeshDistance(FVector targetPos, float &Distance)
{
    CCSController_eventFindNavMeshDistance_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    Parms.targetPos = targetPos;
    Parms.Distance = Distance;
    ProcessEvent(FindFunctionChecked(UDKBASE_FindNavMeshDistance, 0), &Parms, 0);
    Distance = Parms.Distance;
    return Parms.ReturnValue;
}

inline unsigned int ACCSController::eventFindNavMeshPath(FVector targetPos)
{
    CCSController_eventFindNavMeshPath_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    Parms.targetPos = targetPos;
    ProcessEvent(FindFunctionChecked(UDKBASE_FindNavMeshPath, 0), &Parms, 0);
    return Parms.ReturnValue;
}

inline void ACCSController::eventActionStopFiring()
{
    ProcessEvent(FindFunctionChecked(UDKBASE_ActionStopFiring, 0), 0, 0);
}

inline void ACCSController::eventAimAt(AActor *newFocus)
{
    CCSController_eventAimAt_Parms Parms(EC_EventParm);
    Parms.newFocus = newFocus;
    ProcessEvent(FindFunctionChecked(UDKBASE_AimAt, 0), &Parms, 0);
}

inline unsigned int ACCSController::eventFireWeapon(unsigned int charge, unsigned int lastShot, unsigned int alwaysFire)
{
    CCSController_eventFireWeapon_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    Parms.charge = charge ? FIRST_BITFIELD : 0;
    Parms.lastShot = lastShot ? FIRST_BITFIELD : 0;
    Parms.alwaysFire = alwaysFire ? FIRST_BITFIELD : 0;
    ProcessEvent(FindFunctionChecked(UDKBASE_FireWeapon, 0), &Parms, 0);
    return Parms.ReturnValue;
}

inline unsigned int ACCSController::eventStopFireBurst()
{
    CCSController_eventStopFireBurst_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    ProcessEvent(FindFunctionChecked(UDKBASE_StopFireBurst, 0), &Parms, 0);
    return Parms.ReturnValue;
}

inline unsigned int ACCSController::eventStartFireBurstObj(AActor *Target)
{
    CCSController_eventStartFireBurstObj_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    Parms.Target = Target;
    ProcessEvent(FindFunctionChecked(UDKBASE_StartFireBurstObj, 0), &Parms, 0);
    return Parms.ReturnValue;
}

inline unsigned int ACCSController::eventStartFireBurst(APawn *Target)
{
    CCSController_eventStartFireBurst_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    Parms.Target = Target;
    ProcessEvent(FindFunctionChecked(UDKBASE_StartFireBurst, 0), &Parms, 0);
    return Parms.ReturnValue;
}

inline unsigned int ACCSController::eventCanFireAt(AActor *Target)
{
    CCSController_eventCanFireAt_Parms Parms(EC_EventParm);
    Parms.ReturnValue = 0;
    Parms.Target = Target;
    ProcessEvent(FindFunctionChecked(UDKBASE_CanFireAt, 0), &Parms, 0);
    return Parms.ReturnValue;
}

inline void ACCSController::eventNotifyAIMoveToActorCompleted()
{
    ProcessEvent(FindFunctionChecked(UDKBASE_NotifyAIMoveToActorCompleted, 0), 0, 0);
}

inline void UGripBTScriptNodeCache::eventCacheAllConditions(UGripBTInterface *BTInterface)
{
    GripBTScriptNodeCache_eventCacheAllConditions_Parms Parms(EC_EventParm);
    Parms.BTInterface = BTInterface;
    ProcessEvent(FindFunctionChecked(UDKBASE_CacheAllConditions, 0), &Parms, 0);
}

inline void UGripBTScriptNodeCache::eventSurveyUsedBBMembers(UGripBlackboard *Blackboard)
{
    GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms Parms(EC_EventParm);
    Parms.Blackboard = Blackboard;
    ProcessEvent(FindFunctionChecked(UDKBASE_SurveyUsedBBMembers, 0), &Parms, 0);
}

inline void UGripBTScriptNodeCache::eventInitializeAllNodes()
{
    ProcessEvent(FindFunctionChecked(UDKBASE_InitializeAllNodes, 0), 0, 0);
}

inline void ACoverLink::eventSetDisabled(unsigned int bNewDisabled)
{
    CoverLink_eventSetDisabled_Parms Parms(EC_EventParm);
    Parms.bNewDisabled = bNewDisabled ? FIRST_BITFIELD : 0;
    ProcessEvent(FindFunctionChecked(UDKBASE_SetDisabled, 0), &Parms, 0);
}

inline void UCCSATAnimNodeSlot::execActivateChild(FFrame &Stack, void *const)
{
    int A0 = 0;
    Stack.Step(Stack.Object, &A0);
    float A1 = 0;
    Stack.Step(Stack.Object, &A1);
    Stack.Code++;
    ActivateChild(A0, A1);
}

inline void UCCSBlackboard::execGetHealth(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(int *)Result = GetHealth();
}

inline void UCCSBlackboard::execSetHealth(FFrame &Stack, void *const)
{
    int A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetHealth(A0);
}

inline void UCCSBlackboard::execSetCurrentTether(FFrame &Stack, void *const)
{
    AActor *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetCurrentTether(A0);
}

inline void UCCSBlackboard::execGetCurrentTether(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(FVector *)Result = GetCurrentTether();
}

inline void UCCSBlackboard::execClearMoveCommand(FFrame &Stack, void *const)
{
    Stack.Code++;
    ClearMoveCommand();
}

inline void UCCSBlackboard::execFlagThreatLocationAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagThreatLocationAsUsed();
}

inline void UCCSBlackboard::execFlagThreatDirectionAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagThreatDirectionAsUsed();
}

inline void UCCSBlackboard::execGetThreatLocation(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(FVector *)Result = GetThreatLocation();
}

inline void UCCSBlackboard::execGetThreatDirection(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(FVector *)Result = GetThreatDirection();
}

inline void UCCSBlackboard::execGetThreatType(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned char *)Result = GetThreatType();
}

inline void UCCSBlackboard::execSetHeatGenerated(FFrame &Stack, void *const)
{
    float A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetHeatGenerated(A0);
}

inline void UCCSBlackboard::execGetHeatGenerated(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(float *)Result = GetHeatGenerated();
}

inline void UCCSBlackboard::execFlagHeatGeneratedAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagHeatGeneratedAsUsed();
}

inline void UCCSBlackboard::execFlagHealthAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagHealthAsUsed();
}

inline void UCCSBlackboard::execFlagCoversAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagCoversAsUsed();
}

inline void UCCSBlackboard::execFlagTargetsAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagTargetsAsUsed();
}

inline void UCCSBlackboard::execFlagTetherAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagTetherAsUsed();
}

inline void UCCSBlackboard::execFlagClosestVisibleEnemyAsUsed(FFrame &Stack, void *const)
{
    Stack.Code++;
    FlagClosestVisibleEnemyAsUsed();
}

inline void ACCSController::execSetDesiredPosition(FFrame &Stack, void *const)
{
    AActor *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetDesiredPosition(A0);
}

inline void ACCSController::execActuallySetDesiredPosition(FFrame &Stack, void *const)
{
    FVector A0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    ActuallySetDesiredPosition(A0);
}

inline void ACCSController::execCalcAccuracyAngles(FFrame &Stack, void *const)
{
    AActor *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    CalcAccuracyAngles(A0);
}

inline void ACCSController::execTakePossession(FFrame &Stack, void *const)
{
    Stack.Code++;
    TakePossession();
}

inline void ACCSController::execSetInitialCover(FFrame &Stack, void *const)
{
    AActor *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetInitialCover(A0);
}

inline void ACCSController::execDisableBrain(FFrame &Stack, void *const)
{
    unsigned int A0 = 0;
    Stack.Step(Stack.Object, &A0);
    A0 = A0 ? 1 : 0;
    Stack.Code++;
    DisableBrain(A0);
}

inline void AUDKCover::execAddCoverLink(FFrame &Stack, void *const)
{
    ACoverLink *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    AddCoverLink(A0);
}

inline void AUDKCover::execRemoveCoverLink(FFrame &Stack, void *const)
{
    ACoverLink *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    RemoveCoverLink(A0);
}

inline void AUDKCover::execKillCoverLinks(FFrame &Stack, void *const)
{
    Stack.Code++;
    KillCoverLinks();
}

inline void UUDKTargetableComponent::execBeginDeath(FFrame &Stack, void *const)
{
    Stack.Code++;
    BeginDeath();
}

inline void AUSSPawn::execGetMovementType(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned char *)Result = GetMovementType();
}

inline void AUSSPawn::execSetMovementType(FFrame &Stack, void *const)
{
    unsigned char A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetMovementType(A0);
}

inline void AUSSPawn::execSetMovementTypeDefault(FFrame &Stack, void *const)
{
    Stack.Code++;
    SetMovementTypeDefault();
}

inline void AUSSPawn::execGetAlertness(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned char *)Result = GetAlertness();
}

inline void AUSSPawn::execSetAlertness(FFrame &Stack, void *const)
{
    unsigned char A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetAlertness(A0);
}

inline void AUSSPawn::execSetAlertnessDefault(FFrame &Stack, void *const)
{
    Stack.Code++;
    SetAlertnessDefault();
}

inline void AUSSPawn::execGetSpeed(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned char *)Result = GetSpeed();
}

inline void AUSSPawn::execSetSpeed(FFrame &Stack, void *const)
{
    unsigned char A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetSpeed(A0);
}

inline void AUSSPawn::execSetMovementSpeedDefault(FFrame &Stack, void *const)
{
    Stack.Code++;
    SetMovementSpeedDefault();
}

inline void AUSSPawn::execIsCrouched(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned int *)Result = IsCrouched();
}

inline void AUSSPawn::execSetCrouched(FFrame &Stack, void *const)
{
    unsigned int A0 = 0;
    Stack.Step(Stack.Object, &A0);
    A0 = A0 ? 1 : 0;
    Stack.Code++;
    SetCrouched(A0);
}

inline void AUSSPawn::execSetPostureDefault(FFrame &Stack, void *const)
{
    Stack.Code++;
    SetPostureDefault();
}

inline void AUSSPawn::execPostureTransitionOver(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned int *)Result = PostureTransitionOver();
}

inline void AUSSPawn::execCanAim(FFrame &Stack, void *const Result)
{
    FRotator A0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    *(unsigned int *)Result = CanAim(A0);
}

inline void AUSSPawn::execSetCoverPose(FFrame &Stack, void *const)
{
    unsigned char A0 = 0;
    Stack.Step(Stack.Object, &A0);
    float A1 = 0;
    Stack.Step(Stack.Object, &A1);
    Stack.Code++;
    SetCoverPose(A0, A1);
}

inline void AUSSPawn::execSetNoCoverPose(FFrame &Stack, void *const)
{
    Stack.Code++;
    SetNoCoverPose();
}

inline void AUSSPawn::execCoverPoseTransitionOver(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned int *)Result = CoverPoseTransitionOver();
}

inline void AUSSPawn::execMoveToInCover(FFrame &Stack, void *const)
{
    FVector A0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    MoveToInCover(A0);
}

inline void AUSSPawn::execIsInCover(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned int *)Result = IsInCover();
}

inline void AUSSPawn::execSetIsPanicking(FFrame &Stack, void *const)
{
    unsigned int A0 = 0;
    Stack.Step(Stack.Object, &A0);
    A0 = A0 ? 1 : 0;
    Stack.Code++;
    SetIsPanicking(A0);
}

inline void AUSSPawn::execGetIsPanicking(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(unsigned int *)Result = GetIsPanicking();
}

inline void AUSSPawn::execGetDefaultBehaviorTree(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(UCCSBTTree **)Result = GetDefaultBehaviorTree();
}

inline void AUSSPawn::execSetDefaultBehaviorTree(FFrame &Stack, void *const)
{
    UCCSBTTree *A0 = 0;
    Stack.Step(Stack.Object, &A0);
    Stack.Code++;
    SetDefaultBehaviorTree(A0);
}

inline void AUSSPawn::execGetYellingDistance(FFrame &Stack, void *const Result)
{
    Stack.Code++;
    *(float *)Result = GetYellingDistance();
}

inline void UHaloAnimBlendByJumpType::execOnChangeJumpType(FFrame &Stack, void *const)
{
    int A0 = 0;
    Stack.Step(Stack.Object, &A0);
    unsigned int A1 = 0;
    Stack.Step(Stack.Object, &A1);
    A1 = A1 ? 1 : 0;
    Stack.Code++;
    OnChangeJumpType(A0, A1);
}

// ---- written by hand below this line (gen_header.py keeps it) ----
