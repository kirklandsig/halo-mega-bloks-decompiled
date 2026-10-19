// Generated from the PDB by: python tools/gen_classes.py UDKBase
#pragma once
#include "Core/Inc/HostGuest.h"

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
HG_PRIVATE:
    static unsigned int &GetIsInitialized();
    void Init(const char *, int, EFindName);
    void Init(const wchar_t *, int, EFindName, unsigned int);
public:
    static TArray<FNameEntry *,FDefaultAllocator> &GetPureNamesTable();
    #ifndef HAGGAR_HOST
    FName(ELinkerNameTableConstructor, const char *);
    FName(ELinkerNameTableConstructor, const wchar_t *);
    FName(const wchar_t *, int, EFindName);
    FName(int);
    FName(const char *, EFindName);
    FName(const wchar_t *, EFindName, unsigned int);
    FName();
    FName(EName, int);
    FName(EName);
    #endif
    #ifndef HAGGAR_HOST
    static TArrayNoInit<FNameEntry *> Names;
    static FNameEntry *NameHash[4096];
    static int NameEntryMemorySize;
    static int NumAnsiNames;
    static int NumUnicodeNames;
    #else
    static TArrayNoInit<FNameEntry *> (&Names);
    static hg::gptr<FNameEntry> (&NameHash)[4096];
    static hg::be<int> (&NameEntryMemorySize);
    static hg::be<int> (&NumAnsiNames);
    static hg::be<int> (&NumUnicodeNames);
    #endif
HG_PRIVATE:
    unsigned int FNameData[0x2];
};

class FRenderCommandFence  // size 0x4, opaque
{
public:
    void BeginFence();
    void Wait(unsigned int) const;
    unsigned int GetNumPendingFences() const;
    #ifndef HAGGAR_HOST
    FRenderCommandFence();
    #endif
HG_PRIVATE:
    unsigned int FRenderCommandFenceData[0x1];
};

class FRotator  // size 0xC, opaque
{
public:
    void SerializeCompressed(FArchive &);
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
    #ifndef HAGGAR_HOST
    FRotator(const FQuat &);
    FRotator(EEventParm);
    FRotator(int, int, int);
    FRotator();
    #endif
    #ifndef HAGGAR_HOST
    static FRotator ZeroRotator;
    #else
    static FRotator (&ZeroRotator);
    #endif
HG_PRIVATE:
    unsigned int FRotatorData[0x3];
};

class FVector  // size 0xC
{
public:
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
    #ifndef HAGGAR_HOST
    FVector(EEventParm);
    FVector(FIntPoint);
    FVector(const FLinearColor &);
    FVector(const FVector4 &);
    FVector(const FVector2D, float);
    FVector(float, float, float);
    FVector(float);
    FVector();
    #endif
    #ifndef HAGGAR_HOST
    static FVector ZeroVector;
    float X;  // 0x0
    float Y;  // 0x4
    float Z;  // 0x8
    #else
    static FVector (&ZeroVector);
    hg::be<float> X;
    hg::be<float> Y;
    hg::be<float> Z;
    #endif
};

template <> class TArray<AActor *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    AActor *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<AActor *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<AActor *> : public TArray<AActor *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<AActor *> &operator=(const TArray<AActor *,FDefaultAllocator> &);
    TArrayNoInit<AActor *> &operator=(const TArrayNoInit<AActor *> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<FTimerData,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    const FTimerData &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<FTimerData,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<FTimerData> : public TArray<FTimerData,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<FTimerData> &operator=(const TArray<FTimerData,FDefaultAllocator> &);
    TArrayNoInit<FTimerData> &operator=(const TArrayNoInit<FTimerData> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<UActorComponent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    UActorComponent *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<UActorComponent *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<UActorComponent *> : public TArray<UActorComponent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<UActorComponent *> &operator=(const TArray<UActorComponent *,FDefaultAllocator> &);
    TArrayNoInit<UActorComponent *> &operator=(const TArrayNoInit<UActorComponent *> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<UClass *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    UClass *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<UClass *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<UClass *> : public TArray<UClass *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<UClass *> &operator=(const TArray<UClass *,FDefaultAllocator> &);
    TArrayNoInit<UClass *> &operator=(const TArrayNoInit<UClass *> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<USeqAct_Latent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    USeqAct_Latent *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<USeqAct_Latent *> : public TArray<USeqAct_Latent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<USeqAct_Latent *> &operator=(const TArray<USeqAct_Latent *,FDefaultAllocator> &);
    TArrayNoInit<USeqAct_Latent *> &operator=(const TArrayNoInit<USeqAct_Latent *> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<USequenceEvent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    USequenceEvent *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<USequenceEvent *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<USequenceEvent *> : public TArray<USequenceEvent *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<USequenceEvent *> &operator=(const TArray<USequenceEvent *,FDefaultAllocator> &);
    TArrayNoInit<USequenceEvent *> &operator=(const TArrayNoInit<USequenceEvent *> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

class UObject  // size 0x3C, opaque
{
public:
    enum
    {
        StaticClassCastFlags = 0,
    };
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~UObject();)
    HG_VIRTUAL unsigned int PreSaveRoot(const wchar_t *, TArray<FString,FDefaultAllocator> &);
    HG_VIRTUAL void PostSaveRoot(unsigned int);
    HG_VIRTUAL void PreSave();
    HG_VIRTUAL void Modify(unsigned int);
    HG_VIRTUAL unsigned int SaveToTransactionBuffer(unsigned int);
    HG_VIRTUAL void PostLoad();
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL unsigned int IsReadyForFinishDestroy();
    HG_VIRTUAL void FinishDestroy();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL unsigned int IsPendingKill() const;
    HG_VIRTUAL void ShutdownAfterError();
    HG_VIRTUAL void PreEditChange(UProperty *);
    HG_VIRTUAL void PreEditChange(FEditPropertyChain &);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    HG_VIRTUAL void PostEditChangeChainProperty(FPropertyChangedChainEvent &);
    HG_VIRTUAL unsigned int CanEditChange(const UProperty *) const;
    HG_VIRTUAL void PreEditUndo();
    HG_VIRTUAL void PostEditUndo();
    HG_VIRTUAL void PostRename();
    HG_VIRTUAL void PostDuplicate();
    HG_VIRTUAL void GetDynamicListValues(const FString &, TArray<FString,FDefaultAllocator> &);
    HG_VIRTUAL unsigned int UsesManagedArchetypePropagation(UObject **) const;
    HG_VIRTUAL void PreSerializeIntoPropagationArchive();
    HG_VIRTUAL void PostSerializeIntoPropagationArchive();
    HG_VIRTUAL void PreSerializeFromPropagationArchive();
    HG_VIRTUAL void PostSerializeFromPropagationArchive();
    HG_VIRTUAL void GetArchetypeInstances(TArray<UObject *,FDefaultAllocator> &);
    HG_VIRTUAL void SaveInstancesIntoPropagationArchive(TArray<UObject *,FDefaultAllocator> &);
    HG_VIRTUAL void LoadInstancesFromPropagationArchive(TArray<UObject *,FDefaultAllocator> &);
    HG_VIRTUAL void PostCrossLevelFixup();
    HG_VIRTUAL void Register();
    HG_VIRTUAL void LanguageChange();
    HG_VIRTUAL unsigned int NeedsLoadForClient() const;
    HG_VIRTUAL unsigned int NeedsLoadForServer() const;
    HG_VIRTUAL unsigned int NeedsLoadForEdit() const;
HG_PROTECTED:
    HG_VIRTUAL UObject *GetProfilerAssetObjectInternal() const;
    HG_VIRTUAL FString GetDetailedInfoInternal() const;
public:
    HG_VIRTUAL FObjectInstancingGraph *GetCustomPostLoadInstanceGraph();
    HG_VIRTUAL void ExportCustomProperties(FOutputDevice &, unsigned int);
    HG_VIRTUAL void ImportCustomProperties(const wchar_t *, FFeedbackContext *);
    HG_VIRTUAL void PostEditImport();
    HG_VIRTUAL unsigned int IsAComponent() const;
    HG_VIRTUAL unsigned int IsAPrefabArchetype(UObject **) const;
    HG_VIRTUAL unsigned int IsInPrefabInstance() const;
    HG_VIRTUAL unsigned int Rename(const wchar_t *, UObject *, unsigned long);
    HG_VIRTUAL UComponent *FindComponent(FName, unsigned int);
    HG_VIRTUAL void PostReloadConfig(UProperty *);
    HG_VIRTUAL void NetDirty(UProperty *);
    HG_VIRTUAL void StripData(UE3::EPlatformType, unsigned int);
    HG_VIRTUAL FString GetDesc();
    HG_VIRTUAL FString GetDetailedDescription(int);
    HG_VIRTUAL unsigned int GetNativePropertyValues(TMap<FString,FString,FDefaultSetAllocator> &, unsigned long) const;
    HG_VIRTUAL unsigned int IsSelected() const;
    HG_VIRTUAL void MarkPackageDirty(unsigned int) const;
    HG_VIRTUAL UObject *CreateArchetype(const wchar_t *, UObject *, UObject *, FObjectInstancingGraph *);
    HG_VIRTUAL void UpdateArchetype();
    HG_VIRTUAL int GetResourceSize();
    HG_VIRTUAL FName GetExporterName();
    HG_VIRTUAL unsigned int IsLocalizedResource();
    HG_VIRTUAL void InitializeProperties(UObject *, FObjectInstancingGraph *);
    HG_VIRTUAL void SetArchetype(UObject *, unsigned int, FObjectInstancingGraph *);
    HG_VIRTUAL void AddReferencedObjects(TArray<UObject *,FDefaultAllocator> &);
    HG_VIRTUAL void ProcessEvent(UFunction *, void *, void *);
    HG_VIRTUAL void ProcessDelegate(FName, const FScriptDelegate *, void *, void *);
    HG_VIRTUAL void ProcessState(float);
    HG_VIRTUAL unsigned int ProcessRemoteFunction(UFunction *, void *, FFrame *);
    HG_VIRTUAL void InitExecution();
    HG_VIRTUAL unsigned int GotoLabel(FName);
    HG_VIRTUAL EGotoState GotoState(FName, unsigned int, unsigned int);
    HG_VIRTUAL unsigned int ScriptConsoleExec(const wchar_t *, FOutputDevice &, UObject *);
    HG_VIRTUAL unsigned int Get_bDebug();
HG_PRIVATE:
    UObject &operator=(const UObject &);
public:
    static UClass *GetPrivateStaticClassUObject(const wchar_t *);
    static void InitializePrivateStaticClassUObject();
    static UClass *StaticClass();
    static const wchar_t *StaticConfigName();
HG_PRIVATE:
    void AddObject(int);
    void HashObject();
    void UnhashObject();
    static ULinkerLoad *GetLoader(int);
    static unsigned int ResolveName(UObject *&, FString &, unsigned int, unsigned int, unsigned int);
    static void SafeLoadError(UObject *, unsigned long, const wchar_t *, const wchar_t *, ...);
    unsigned int IsNameHashed();
public:
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
HG_PRIVATE:
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
HG_PRIVATE:
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
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PRIVATE:
    static void operator delete(void *, unsigned int);
public:
    UObject(EStaticConstructor, const wchar_t *, const wchar_t *, unsigned __int64);
    UObject(ENativeConstructor, UClass *, const wchar_t *, const wchar_t *, unsigned __int64);
    UObject(const UObject &);
    UObject();
    #endif
    #ifndef HAGGAR_HOST
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
    static unsigned int GExclusiveResourceSizeMode;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static hg::be<unsigned int> (&GObjInitialized);
    static hg::be<unsigned int> (&GObjNoRegister);
    static hg::be<int> (&GObjBeginLoadCount);
    static hg::be<unsigned int> (&GIsSavingPackage);
    static hg::be<int> (&GObjRegisterCount);
    static hg::be<int> (&GImportCount);
    static hg::be<int> (&GForcedExportCount);
    static hg::gptr<UObject> (&GObjHash)[32768];
    static hg::gptr<UObject> (&GObjHashOuter)[32768];
    static hg::gptr<UObject> (&GAutoRegister);
    static TArray<UObject *,FDefaultAllocator> (&GObjLoaded);
    static TArray<UObject *,FDefaultAllocator> (&GObjConstructedDuringAsyncLoading);
    static TArray<UObject *,FDefaultAllocator> (&GObjObjects);
    static TArray<int,FDefaultAllocator> (&GObjAvailable);
    static TArray<ULinkerLoad *,FDefaultAllocator> (&GObjLoaders);
    static TMap<FName,FName,FDefaultSetAllocator> (&PackageNameToFileMapping);
    static hg::gptr<UPackage> (&GObjTransientPkg);
    static hg::be<wchar_t> (&GObjCachedLanguage)[32];
    static TArray<UObject *,FDefaultAllocator> (&GObjRegistrants);
    static TIndirectArray<FAsyncPackage,FDefaultAllocator> (&GObjAsyncPackages);
    static hg::be<wchar_t> (&GLanguage)[64];
    static hg::be<unsigned int> (&GObjIncrementalPurgeIsInProgress);
    static hg::be<unsigned int> (&GObjFinishDestroyHasBeenRoutedToAllObjects);
    static hg::be<unsigned int> (&GObjPurgeIsRequired);
    static hg::be<int> (&GObjCurrentPurgeObjectIndex);
    static hg::be<int> (&GObjFirstGCIndex);
    static hg::be<int> (&GObjLastNonGCIndex);
    static hg::be<int> (&GPermanentObjectPoolSize);
    static hg::gptr<unsigned char> (&GPermanentObjectPool);
    static hg::gptr<unsigned char> (&GPermanentObjectPoolTail);
    static TArray<int,FDefaultAllocator> (&GGCObjectsPendingDestruction);
    static hg::be<int> (&GGCObjectsPendingDestructionCount);
    static hg::be<unsigned int> (&GExclusiveResourceSizeMode);
    #endif
HG_PRIVATE:
    unsigned int UObjectData[0xE];
};

class AActor : public UObject  // size 0x1D4
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void ForceUpdateComponents(unsigned int, unsigned int);
    HG_VIRTUAL FString ConsoleCommand(const FString &, unsigned int);
    HG_VIRTUAL unsigned char MovingWhichWay(float &);
    HG_VIRTUAL void SetShadowParentOnAllAttachedComponents(UPrimitiveComponent *, ULightEnvironmentComponent *);
    HG_VIRTUAL float GetTerminalVelocity();
    HG_VIRTUAL void FindBase();
    HG_VIRTUAL void SearchForBaseBelow(float, AActor *&, FVector &);
    HG_VIRTUAL AActor *GetBaseMost();
    HG_VIRTUAL FBox GetComponentsBoundingBox(unsigned int) const;
    HG_VIRTUAL void GetBoundingCylinder(float &, float &) const;
    HG_VIRTUAL FVector GetDestination(AController *);
    HG_VIRTUAL float GetGravityZ();
    HG_VIRTUAL void PrestreamTextures(float, unsigned int, int);
    HG_VIRTUAL unsigned int IsPlayerOwned();
    HG_VIRTUAL unsigned char GetTeamNum();
    HG_VIRTUAL void SetTeamNum(unsigned char);
    HG_VIRTUAL FVector GetTargetLocation(AActor *, unsigned int) const;
    HG_VIRTUAL void SetHUDLocation(FVector);
    HG_VIRTUAL void NativePostRenderFor(APlayerController *, UCanvas *, FVector, FVector);
    HG_VIRTUAL UParticleSystem *GetAnimTrailParticleSystem(const UAnimNotify_Trails *) const;
    HG_VIRTUAL unsigned int SupportsKismetModification(USequenceOp *, FString &) const;
    HG_VIRTUAL unsigned int ShouldBeHiddenBySHOW_NavigationNodes();
    HG_VIRTUAL int GetActorMetrics(unsigned char);
    HG_VIRTUAL USpriteComponent *GetActorSpriteComponent() const;
    HG_VIRTUAL FVector GetPawnViewLocation();
    HG_VIRTUAL FVector GetNavAdjustedLocation(FVector, float) const;
    HG_VIRTUAL unsigned int IsInvisible();
    HG_VIRTUAL int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    HG_VIRTUAL APawn *GetPlayerPawn() const;
    HG_VIRTUAL unsigned int IsPlayerPawn() const;
    HG_VIRTUAL unsigned int IgnoreBlockingBy(const AActor *) const;
    HG_VIRTUAL unsigned int CanCauseFractureOnTouch();
    HG_VIRTUAL FVector CreateLocationOffset(unsigned int, unsigned int, int, float) const;
    HG_VIRTUAL float GetNetPriority(const FVector &, const FVector &, APlayerController *, UActorChannel *, float, unsigned int);
    HG_VIRTUAL unsigned int Tick(float, ELevelTick);
    HG_VIRTUAL void PostEditMove(unsigned int);
    HG_VIRTUAL void Spawned();
    HG_VIRTUAL void PreNetReceive();
    HG_VIRTUAL void PostNetReceive();
    HG_VIRTUAL void PostNetReceiveLocation();
    HG_VIRTUAL void PostNetReceiveBase(AActor *);
    HG_VIRTUAL void PostScriptDestroyed();
    HG_VIRTUAL unsigned int ShouldTrace(UPrimitiveComponent *, AActor *, unsigned long);
    HG_VIRTUAL unsigned int IsOverlapping(AActor *, FCheckResult *, UPrimitiveComponent *, UPrimitiveComponent *);
    HG_VIRTUAL unsigned int FindInterpMoveTrack(UInterpTrackMove **, UInterpTrackInstMove **, USeqAct_Interp **);
    HG_VIRTUAL void SetHardAttach(unsigned int);
    HG_VIRTUAL void NotifyBump(AActor *, UPrimitiveComponent *, const FVector &);
    HG_VIRTUAL void NotifyBumpLevel(const FVector &, const FVector &);
    HG_VIRTUAL void SetBase(AActor *, FVector, int, USkeletalMeshComponent *, FName);
    HG_VIRTUAL void TickAuthoritative(float);
    HG_VIRTUAL void TickSimulated(float);
    HG_VIRTUAL void TickSpecial(float);
    HG_VIRTUAL unsigned int PlayerControlled();
    HG_VIRTUAL unsigned int IsNetRelevantFor(APlayerController *, AActor *, const FVector &);
    HG_VIRTUAL unsigned int IsRelevancyOwnerFor(AActor *, AActor *, AActor *);
    HG_VIRTUAL void SetZone(unsigned int, unsigned int);
    HG_VIRTUAL void SetVolumes();
    HG_VIRTUAL void SetVolumes(const TArray<AVolume *,FDefaultAllocator> &);
    HG_VIRTUAL void PreBeginPlay();
    HG_VIRTUAL void PostBeginPlay();
    HG_VIRTUAL void setPhysics(unsigned char, AActor *, FVector);
    HG_VIRTUAL void performPhysics(float);
    HG_VIRTUAL void physProjectile(float, int);
    HG_VIRTUAL void BoundProjectileVelocity();
    HG_VIRTUAL void processHitWall(const FCheckResult &, float);
    HG_VIRTUAL void processLanded(const FVector &, AActor *, float, int);
    HG_VIRTUAL void physFalling(float, int);
    HG_VIRTUAL void physWalking(float, int);
    HG_VIRTUAL void physNavMeshWalking(float);
    HG_VIRTUAL void physCustom(float, int);
    HG_VIRTUAL void physicsRotation(float, FVector);
    HG_VIRTUAL FRotator FindSlopeRotation(const FVector &, const FRotator &);
    HG_VIRTUAL void GetNetBuoyancy(float &, float &);
    HG_VIRTUAL void SmoothHitWall(const FVector &, AActor *);
    HG_VIRTUAL void stepUp(const FVector &, const FVector &, const FVector &, FCheckResult &);
    HG_VIRTUAL unsigned int ShrinkCollision(AActor *, UPrimitiveComponent *, const FVector &);
    HG_VIRTUAL void GrowCollision();
    HG_VIRTUAL unsigned int MoveWithInterpMoveTrack(UInterpTrackMove *, UInterpTrackInstMove *, float, float);
    HG_VIRTUAL void AdjustInterpTrackMove(FVector &, FRotator &, float, unsigned int);
    HG_VIRTUAL void physInterpolating(float);
    HG_VIRTUAL void PushedBy(AActor *);
    HG_VIRTUAL void UpdateBasedRotation(FRotator &, const FRotator &);
    HG_VIRTUAL void ReverseBasedRotation();
    HG_VIRTUAL void physRigidBody(float);
    HG_VIRTUAL void physSoftBody(float);
    HG_VIRTUAL void InitRBPhys();
    HG_VIRTUAL void InitRBPhysEditor();
    HG_VIRTUAL void TermRBPhys(FRBPhysScene *);
    HG_VIRTUAL void BuildPhysStaticMeshCache(ULevel *, int &, int &, int &, int &);
    HG_VIRTUAL void OnRigidBodyCollision(const FRigidBodyCollisionInfo &, const FRigidBodyCollisionInfo &, const FCollisionImpactData &);
    HG_VIRTUAL void UpdatePushBody();
    HG_VIRTUAL void ModifyNxActorDesc(NxActorDesc &, UPrimitiveComponent *, const NxGroupsMask &, unsigned int);
    HG_VIRTUAL void PostInitRigidBody(NxActor *, NxActorDesc &, UPrimitiveComponent *);
    HG_VIRTUAL void PreTermRigidBody(NxActor *);
    HG_VIRTUAL void SyncActorToRBPhysics();
    HG_VIRTUAL void GetAnimControlSlotDesc(TArray<FAnimSlotDesc,FDefaultAllocator> &);
    HG_VIRTUAL void PreviewBeginAnimControl(UInterpGroup *);
    HG_VIRTUAL void PreviewSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int, float);
    HG_VIRTUAL void PreviewSetAnimWeights(TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL void PreviewFinishAnimControl(UInterpGroup *);
    HG_VIRTUAL void PreviewUpdateFaceFX(unsigned int, const FString &, const FString &, float);
    HG_VIRTUAL void PreviewActorPlayFaceFX(const FString &, const FString &, UAkBaseSoundObject *);
    HG_VIRTUAL void PreviewActorStopFaceFX();
    HG_VIRTUAL UAudioComponent *PreviewGetFaceFXAudioComponent();
    HG_VIRTUAL UFaceFXAsset *PreviewGetActorFaceFXAsset();
    HG_VIRTUAL void PreviewSetMorphWeight(FName, float);
    HG_VIRTUAL void PreviewSetSkelControlScale(FName, float);
    HG_VIRTUAL void SetSkelControlStrength(FName, float);
    HG_VIRTUAL AActor *AssociatedLevelGeometry();
    HG_VIRTUAL unsigned int HasAssociatedLevelGeometry(AActor *);
    HG_VIRTUAL unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    HG_VIRTUAL unsigned int TouchReachSucceeded(APawn *, const FVector &);
    HG_VIRTUAL unsigned int BlockedByVehicle();
    HG_VIRTUAL void PrePath();
    HG_VIRTUAL void PostPath();
    HG_VIRTUAL unsigned int IsABuilderBrush() const;
    HG_VIRTUAL unsigned int IsCurrentBuilderBrush() const;
    HG_VIRTUAL unsigned int IsABrush() const;
    HG_VIRTUAL unsigned int IsAVolume() const;
    HG_VIRTUAL unsigned int IsABrushShape() const;
    HG_VIRTUAL unsigned int IsAFluidSurface() const;
    HG_VIRTUAL APlayerController *GetAPlayerController();
    HG_VIRTUAL AController *GetAController();
    HG_VIRTUAL APawn *GetAPawn();
    HG_VIRTUAL const APawn *GetAPawn() const;
    HG_VIRTUAL AVehicle *GetAVehicle();
    HG_VIRTUAL AVolume *GetAVolume();
    HG_VIRTUAL AFluidSurfaceActor *GetAFluidSurface();
    HG_VIRTUAL AProjectile *GetAProjectile();
    HG_VIRTUAL const AProjectile *GetAProjectile() const;
    HG_VIRTUAL APortalTeleporter *GetAPortalTeleporter();
    HG_VIRTUAL APlayerController *GetTopPlayerController();
    HG_VIRTUAL unsigned int VerifyNoUnreachableReferences();
    HG_VIRTUAL void ClearComponents();
    HG_VIRTUAL unsigned int WantsOverlapCheckWith(AActor *);
    HG_VIRTUAL unsigned int ForceReturnComponent(UPrimitiveComponent *);
HG_PROTECTED:
    HG_VIRTUAL void UpdateComponentsInternal(unsigned int);
public:
    HG_VIRTUAL void ConditionalForceUpdateComponents(unsigned int, unsigned int);
    HG_VIRTUAL void MarkComponentsAsPendingKill(unsigned int);
    HG_VIRTUAL unsigned int GetActorStaticLightingInfo(TArray<FStaticLightingPrimitiveInfo,FDefaultAllocator> &, const TArray<ULightComponent *,FDefaultAllocator> &, const FLightingBuildOptions &);
    HG_VIRTUAL void OrderComponentsForDeterministicLighting();
    HG_VIRTUAL void InvalidateLightingCache();
    HG_VIRTUAL void FinalizeStaticLighting();
    HG_VIRTUAL unsigned int ActorLineCheck(FCheckResult &, const FVector &, const FVector &, const FVector &, unsigned long);
    HG_VIRTUAL void ClearCrossLevelReferences();
    HG_VIRTUAL void GetActorReferences(TArray<FActorReference *,FDefaultAllocator> &, unsigned int);
    HG_VIRTUAL FGuid *GetGuid();
    HG_VIRTUAL ANavigationPoint *SpecifyEndAnchor(APawn *);
    HG_VIRTUAL unsigned int AnchorNeedNotBeReachable();
    HG_VIRTUAL void NotifyAnchorFindingResult(ANavigationPoint *, APawn *);
    HG_VIRTUAL unsigned int ShouldHideActor(const FVector &);
    HG_VIRTUAL void SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL unsigned int ResolveAttachedMoveEncroachment(AActor *, const FCheckResult &);
    HG_VIRTUAL void OnEditorAnimEnd(UAnimNodeSequence *, float, float);
    HG_VIRTUAL void OnRemoveFromWorld();
    HG_VIRTUAL unsigned int NeedsCollisionOverrideDuringCoverBuild();
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
HG_PRIVATE:
    AActor &operator=(const AActor &);
public:
    static UClass *GetPrivateStaticClassAActor(const wchar_t *);
    static void InitializePrivateStaticClassAActor();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL unsigned int IsReadyForFinishDestroy();
    HG_VIRTUAL void ProcessEvent(UFunction *, void *, void *);
    HG_VIRTUAL void ProcessState(float);
    HG_VIRTUAL unsigned int ProcessRemoteFunction(UFunction *, void *, FFrame *);
    void ProcessDemoRecFunction(UFunction *, void *, FFrame *);
    HG_VIRTUAL void InitExecution();
    HG_VIRTUAL void PreEditChange(UProperty *);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    HG_VIRTUAL void PreSave();
    HG_VIRTUAL void PostLoad();
    HG_VIRTUAL void NetDirty(UProperty *);
    unsigned int IsOwnedBy(const AActor *) const;
    unsigned int IsBlockedBy(const AActor *, const UPrimitiveComponent *) const;
    unsigned int IsBasedOn(const AActor *) const;
    APrefabInstance *FindOwningPrefabInstance() const;
    AActor *GetBase() const;
    void EditorUpdateBase();
    void EditorUpdateAttachedActors(const TArray<AActor *,FDefaultAllocator> &);
    unsigned int IsHiddenEd() const;
    HG_VIRTUAL unsigned int IsSelected() const;
    HG_VIRTUAL void PostRename();
    void SetDefaultCollisionType();
    void SetCollisionFromCollisionType();
    FMatrix LocalToWorld() const;
    FMatrix WorldToLocal() const;
    FVector GetCylinderExtent() const;
    AActor *GetTopOwner();
    HG_VIRTUAL unsigned int IsPendingKill() const;
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
    HG_VIRTUAL unsigned int Get_bDebug();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AActor();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    static FVector OverlapAdjust;
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
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static FVector (&OverlapAdjust);
    hg::gptr<AActor> Next_Actor;
    hg::gptr<AActor> Next_Reactive;
    hg::gptr<AActor> Next_Vehicle;
    hg::gptr<AActor> Next_Target_Actor;
    TArrayNoInit<UActorComponent *> Components;
    TArrayNoInit<UActorComponent *> AllComponents;
    FVector Location;
    FRotator Rotation;
    hg::be<float> DrawScale;
    FVector DrawScale3D;
    FVector PrePivot;
    FRenderCommandFence DetachFence;
    hg::be<float> CustomTimeDilation;
    unsigned char Physics;
    unsigned char RemoteRole;
    unsigned char Role;
    unsigned char CollisionType;
    unsigned char ReplicatedCollisionType;
    unsigned char TickGroup;
    char _pad0[0x2];
    hg::gptr<AActor> Owner;
    hg::gptr<AActor> Base;
    TArrayNoInit<FTimerData> Timers;
    hg::be<unsigned int> _bitsBC;  // 0xBC, from bStatic
    hg::be<unsigned int> _bitsC0;  // 0xC0, from bNetInitialRotation
    hg::be<unsigned int> _bitsC4;  // 0xC4, from bBlocksTeleport
    hg::be<int> NetTag;
    hg::be<float> NetUpdateTime;
    hg::be<float> NetUpdateFrequency;
    hg::be<float> NetPriority;
    hg::be<float> LastNetUpdateTime;
    hg::be<float> TimeSinceLastTick;
    hg::gptr<APawn> Instigator;
    hg::gptr<AWorldInfo> WorldInfo;
    hg::be<float> LifeSpan;
    hg::be<float> CreationTime;
    hg::be<float> LastRenderTime;
    FName Tag;
    FName InitialState;
    FName Layer;
    FName Group_DEPRECATED;
    hg::be<unsigned __int64> HiddenEditorViews;
    TArrayNoInit<AActor *> Touching;
    TArrayNoInit<AActor *> Children;
    hg::be<float> LatentFloat;
    hg::gptr<UAnimNodeSequence> LatentSeqNode;
    hg::gptr<APhysicsVolume> PhysicsVolume;
    FVector Velocity;
    FVector Acceleration;
    FVector AngularVelocity;
    hg::gptr<USkeletalMeshComponent> BaseSkelComponent;
    FName BaseBoneName;
    TArrayNoInit<AActor *> Attached;
    FVector RelativeLocation;
    FRotator RelativeRotation;
    hg::gptr<UPrimitiveComponent> CollisionComponent;
    hg::be<int> OverlapTag;
    FRotator RotationRate;
    hg::gptr<AActor> PendingTouch;
    hg::gptr<UClass> MessageClass;
    TArrayNoInit<UClass *> SupportedEvents;
    TArrayNoInit<USequenceEvent *> GeneratedEvents;
    TArrayNoInit<USeqAct_Latent *> LatentActions;
    #endif
};

class IInterface_NavigationHandle  // size 0x4, opaque
{
    HG_VFPTR
HG_PROTECTED:
    HG_XDK(HG_VIRTUAL ~IInterface_NavigationHandle();)
public:
    HG_VIRTUAL UObject *GetUObjectInterfaceInterface_NavigationHandle() HG_PURE;
    HG_VIRTUAL void eventNotifyPathChanged() HG_PURE;
    HG_VIRTUAL unsigned int CanCoverSlip(ACoverLink *, int);
    HG_VIRTUAL FVector GetEdgeZAdjust(FNavMeshEdgeBase *) HG_PURE;
    HG_VIRTUAL unsigned int CheckMantleValidity(FNavMeshMantleEdge *);
    HG_VIRTUAL void SetupPathfindingParams(FNavMeshPathParams &) HG_PURE;
    HG_VIRTUAL void InitForPathfinding() HG_PURE;
    HG_VIRTUAL int ExtraEdgeCostToAddWhenActive(FNavMeshEdgeBase *);
    HG_VIRTUAL void DebugLogInternal(const wchar_t *);
};

class AController : public AActor, public IInterface_NavigationHandle  // size 0x358, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL unsigned int IsLocalPlayerController();
    HG_VIRTUAL unsigned int IsLocalController();
    HG_VIRTUAL void RouteCache_Empty();
    HG_VIRTUAL void RouteCache_AddItem(ANavigationPoint *);
    HG_VIRTUAL void RouteCache_InsertItem(ANavigationPoint *, int);
    HG_VIRTUAL void RouteCache_RemoveItem(ANavigationPoint *);
    HG_VIRTUAL void RouteCache_RemoveIndex(int, int);
    HG_VIRTUAL void SetAdjustLocation(FVector, unsigned int, unsigned int);
    HG_VIRTUAL void EndClimbLadder();
    HG_VIRTUAL unsigned int IsPlayerOwner();
    HG_VIRTUAL unsigned int CanHear(const FVector &, float, AActor *);
    HG_VIRTUAL void ShowSelf();
    HG_VIRTUAL unsigned int ShouldCheckVisibilityOf(AController *);
    HG_VIRTUAL unsigned long SeePawn(APawn *, unsigned int);
    HG_VIRTUAL unsigned long LineOfSightTo(const AActor *, int, const FVector *, unsigned int);
    HG_VIRTUAL void HearNoise(AActor *, float, FName);
    HG_VIRTUAL int AcceptNearbyPath(AActor *);
    HG_VIRTUAL UReachSpec *PrepareForMove(ANavigationPoint *, UReachSpec *);
    HG_VIRTUAL void AdjustFromWall(FVector, AActor *);
    HG_VIRTUAL void MarkEndPoints(ANavigationPoint *, AActor *, const FVector &);
    HG_VIRTUAL unsigned int OverridePathTo(ANavigationPoint *, AActor *, const FVector &, unsigned int, float &);
    HG_VIRTUAL unsigned int WantsLedgeCheck();
    HG_VIRTUAL unsigned int StopAtLedge();
    HG_VIRTUAL void PrePollMove();
    HG_VIRTUAL void PostPollMove();
    HG_VIRTUAL void PollMoveComplete();
    HG_VIRTUAL AActor *GetViewTarget();
    HG_VIRTUAL void UpdateEnemyInfo(APawn *);
    HG_VIRTUAL void JumpOverWall(FVector);
    HG_VIRTUAL void UpdatePawnRotation();
    HG_VIRTUAL unsigned int ForceReached(ANavigationPoint *, const FVector &);
    HG_VIRTUAL FRotator SetRotationRate(float);
    HG_VIRTUAL FVector DesiredDirection();
    HG_VIRTUAL void FailMove();
    HG_VIRTUAL void PreAirSteering(float);
    HG_VIRTUAL void PostAirSteering(float);
    HG_VIRTUAL void PostPhysFalling(float);
    HG_VIRTUAL void PostPhysWalking(float);
    HG_VIRTUAL void PostPhysSpider(float);
    HG_VIRTUAL unsigned int AirControlFromWall(float, FVector &);
    HG_VIRTUAL void NotifyJumpApex();
    HG_VIRTUAL void ClearCrossLevelPaths(ULevel *);
    HG_VIRTUAL void execPollMoveTo(FFrame &, void *const);
    HG_VIRTUAL void execPollMoveToward(FFrame &, void *const);
    HG_VIRTUAL unsigned int ShouldOffsetCorners();
    HG_VIRTUAL unsigned int ShouldUsePathLanes();
    HG_VIRTUAL unsigned int ShouldIgnoreNavigationBlockingFor(const AActor *);
    HG_VIRTUAL void MoveTo(const FVector &, AActor *, float, unsigned int);
    HG_VIRTUAL void MoveToward(AActor *, AActor *, float, unsigned int, unsigned int);
    HG_VIRTUAL float GetMaxDropHeight();
    void SetFocalPoint(FVector, unsigned int);
    FVector GetFocalPoint();
    void SetDestinationPosition(FVector, unsigned int);
    FVector GetDestinationPosition();
    FVector GetAdjustLocation();
    unsigned int BeyondFogDistance(FVector, FVector);
    HG_VIRTUAL unsigned char GetTeamNum();
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
    HG_VIRTUAL void eventNotifyPathChanged();
HG_PRIVATE:
    AController &operator=(const AController &);
public:
    static UClass *GetPrivateStaticClassAController(const wchar_t *);
    static void InitializePrivateStaticClassAController();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL UObject *GetUObjectInterfaceInterface_NavigationHandle();
    HG_VIRTUAL int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    HG_VIRTUAL unsigned int Tick(float, ELevelTick);
    HG_VIRTUAL void Spawned();
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL unsigned int IsPlayerOwned();
    HG_VIRTUAL AController *GetAController();
    void CheckEnemyVisible();
    AActor *HandleSpecial(AActor *);
    UReachSpec *GetNextRoutePath(ANavigationPoint *);
    void SetRouteCache(ANavigationPoint *, float, float);
    AActor *FindPath(const FVector &, AActor *, unsigned int, int, unsigned int);
    AActor *SetPath(int);
    void SetPathLane(float);
    HG_VIRTUAL void PostBeginPlay();
    HG_VIRTUAL void PostScriptDestroyed();
    void execPollWaitForLanding(FFrame &, void *const);
    void execPollFinishRotation(FFrame &, void *const);
    HG_VIRTUAL void GetAnimControlSlotDesc(TArray<FAnimSlotDesc,FDefaultAllocator> &);
    HG_VIRTUAL void PreviewBeginAnimControl(UInterpGroup *);
    HG_VIRTUAL void PreviewSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int, float);
    HG_VIRTUAL void PreviewSetAnimWeights(TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL void PreviewFinishAnimControl(UInterpGroup *);
    HG_VIRTUAL void PreviewUpdateFaceFX(unsigned int, const FString &, const FString &, float);
    HG_VIRTUAL void PreviewActorPlayFaceFX(const FString &, const FString &, UAkBaseSoundObject *);
    HG_VIRTUAL void PreviewActorStopFaceFX();
    HG_VIRTUAL UAudioComponent *PreviewGetFaceFXAudioComponent();
    HG_VIRTUAL UFaceFXAsset *PreviewGetActorFaceFXAsset();
    HG_VIRTUAL void PreviewSetMorphWeight(FName, float);
    HG_VIRTUAL void PreviewSetSkelControlScale(FName, float);
    HG_VIRTUAL void SetSkelControlStrength(FName, float);
    HG_VIRTUAL void SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL unsigned int CanCoverSlip(ACoverLink *, int);
    HG_VIRTUAL void SetupPathfindingParams(FNavMeshPathParams &);
    HG_VIRTUAL void InitForPathfinding();
    HG_VIRTUAL int ExtraEdgeCostToAddWhenActive(FNavMeshEdgeBase *);
    HG_VIRTUAL FVector GetEdgeZAdjust(FNavMeshEdgeBase *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AController();
public:
    #endif
    typedef AActor Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
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
HG_PRIVATE:
    AAIController &operator=(const AAIController &);
public:
    static UClass *GetPrivateStaticClassAAIController(const wchar_t *);
    static void InitializePrivateStaticClassAAIController();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int AcceptNearbyPath(AActor *);
    HG_VIRTUAL void AdjustFromWall(FVector, AActor *);
    HG_VIRTUAL void SetAdjustLocation(FVector, unsigned int, unsigned int);
    HG_VIRTUAL FVector DesiredDirection();
    HG_VIRTUAL void PostScriptDestroyed();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AAIController();
public:
    #endif
    typedef AController Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int AAIControllerData[0x6];
};

class AGwNavAIController : public AAIController  // size 0x370, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    AGwNavAIController &operator=(const AGwNavAIController &);
public:
    static UClass *GetPrivateStaticClassAGwNavAIController(const wchar_t *);
    static void InitializePrivateStaticClassAGwNavAIController();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AGwNavAIController();
    AGwNavAIController();
public:
    #endif
    typedef AAIController Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class AGameAIController : public AGwNavAIController  // size 0x3A8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void PushCommand(UGameAICommand *);
    HG_VIRTUAL void PopCommand(UGameAICommand *);
    HG_VIRTUAL unsigned int AbortCommand(UGameAICommand *, UClass *);
    HG_VIRTUAL UGameAICommand *GetAICommandInStack(const UClass *);
    HG_VIRTUAL void StoreCommandHistory(UGameAICommand *);
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
HG_PRIVATE:
    AGameAIController &operator=(const AGameAIController &);
public:
    static UClass *GetPrivateStaticClassAGameAIController(const wchar_t *);
    static void InitializePrivateStaticClassAGameAIController();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    void AILog__VA(EName, const wchar_t *, ...);
    void AILog__VA(const wchar_t *, ...);
    void AILog(EName, const wchar_t *);
    void AILog(const wchar_t *);
    HG_VIRTUAL unsigned int Tick(float, ELevelTick);
    HG_VIRTUAL EGotoState GotoState(FName, unsigned int, unsigned int);
    HG_VIRTUAL void ProcessState(float);
    HG_VIRTUAL void DebugLogInternal(const wchar_t *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AGameAIController();
public:
    #endif
    typedef AGwNavAIController Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int AGameAIControllerData[0xE];
};

class ACCSController : public AGameAIController  // size 0x4B0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void SetDesiredPosition(AActor *);
    HG_VIRTUAL void ActuallySetDesiredPosition(FVector);
    HG_VIRTUAL void CalcAccuracyAngles(AActor *);
    HG_VIRTUAL void TakePossession();
    HG_VIRTUAL void SetState(const FString &);
    HG_VIRTUAL void RemoveState(const FString &);
    HG_VIRTUAL void SetInitialCover(AActor *);
    HG_VIRTUAL void TriggerEvent(const FString &);
    HG_VIRTUAL void DisableBrain(unsigned int);
    HG_VIRTUAL void UpdateOnlyPawnRotation();
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &);
    HG_VIRTUAL unsigned char GetTeamNum();
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
HG_PRIVATE:
    ACCSController &operator=(const ACCSController &);
public:
    static UClass *GetPrivateStaticClassACCSController(const wchar_t *);
    static void InitializePrivateStaticClassACCSController();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL unsigned int Tick(float, ELevelTick);
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL void PostScriptDestroyed();
    HG_VIRTUAL void UpdatePawnRotation();
    HG_VIRTUAL void AdjustFromWall(FVector, AActor *);
    HG_VIRTUAL void ShowSelf();
    HG_VIRTUAL void HearNoise(AActor *, float, FName);
HG_PRIVATE:
    void DestroyBrain();
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ACCSController();
public:
    #endif
    typedef AGameAIController Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int ACCSControllerData[0x42];
};

class ANavigationPoint : public AActor  // size 0x294, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL unsigned int IsUsableAnchorFor(APawn *);
    HG_VIRTUAL unsigned int CanTeleport(AActor *);
    HG_VIRTUAL UClass *GetReachSpecClass(ANavigationPoint *, UClass *);
    HG_VIRTUAL void ClearPaths();
    HG_VIRTUAL unsigned int ShouldBeBased();
    HG_VIRTUAL void Validate();
    HG_VIRTUAL void TogglePathRendering(unsigned int);
    HG_VIRTUAL void InitForPathFinding();
    HG_VIRTUAL void ClearForPathFinding();
    HG_VIRTUAL APickupFactory *GetAPickupFactory();
    HG_VIRTUAL unsigned int GetUpDir(FVector &);
    HG_VIRTUAL void AddToNavigationOctree();
    HG_VIRTUAL void RemoveFromNavigationOctree();
    HG_VIRTUAL unsigned int PlaceScout(AScout *);
    HG_VIRTUAL void GetBoundingCylinder(float &, float &) const;
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
HG_PRIVATE:
    ANavigationPoint &operator=(const ANavigationPoint &);
public:
    static UClass *GetPrivateStaticClassANavigationPoint(const wchar_t *);
    static void InitializePrivateStaticClassANavigationPoint();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void FindBase();
    HG_VIRTUAL void PostScriptDestroyed();
HG_PROTECTED:
    HG_VIRTUAL void UpdateComponentsInternal(unsigned int);
public:
    HG_VIRTUAL void PostEditMove(unsigned int);
    HG_VIRTUAL void Spawned();
    void UpdateMaxPathSize();
    unsigned int FindAlternatePath(UReachSpec *, int);
    unsigned int CanReach(ANavigationPoint *, float, unsigned int, unsigned int);
    HG_VIRTUAL void SetVolumes();
    HG_VIRTUAL void SetVolumes(const TArray<AVolume *,FDefaultAllocator> &);
    HG_VIRTUAL unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    HG_VIRTUAL unsigned int TouchReachSucceeded(APawn *, const FVector &);
    HG_VIRTUAL FVector GetDestination(AController *);
    void SortPathList();
    HG_VIRTUAL void GetActorReferences(TArray<FActorReference *,FDefaultAllocator> &, unsigned int);
    HG_VIRTUAL void ClearCrossLevelReferences();
    HG_VIRTUAL FGuid *GetGuid();
    HG_VIRTUAL ANavigationPoint *SpecifyEndAnchor(APawn *);
    HG_VIRTUAL void MarkComponentsAsPendingKill(unsigned int);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ANavigationPoint();
public:
    #endif
    typedef AActor Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int ANavigationPointData[0x30];
};

template <> class TArray<APawn *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    APawn *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<APawn *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<APawn *> : public TArray<APawn *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<APawn *> &operator=(const TArray<APawn *,FDefaultAllocator> &);
    TArrayNoInit<APawn *> &operator=(const TArrayNoInit<APawn *> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<FCoverSlot,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    const FCoverSlot &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<FCoverSlot,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<FCoverSlot> : public TArray<FCoverSlot,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<FCoverSlot> &operator=(const TArray<FCoverSlot,FDefaultAllocator> &);
    TArrayNoInit<FCoverSlot> &operator=(const TArrayNoInit<FCoverSlot> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

template <> class TArray<FDynamicLinkInfo,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    const FDynamicLinkInfo &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArrayNoInit<FDynamicLinkInfo> : public TArray<FDynamicLinkInfo,FDefaultAllocator>  // size 0xC, opaque
{
public:
    TArrayNoInit<FDynamicLinkInfo> &operator=(const TArray<FDynamicLinkInfo,FDefaultAllocator> &);
    TArrayNoInit<FDynamicLinkInfo> &operator=(const TArrayNoInit<FDynamicLinkInfo> &);
    #ifndef HAGGAR_HOST
    TArrayNoInit(EForceInit);
    TArrayNoInit();
    #endif
};

class ACoverLink : public ANavigationPoint  // size 0x328
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    struct FFireLinkInfo;
    HG_VIRTUAL unsigned int GetFireLinkTargetCoverInfo(int, int, FCoverInfo &, unsigned char);
    HG_VIRTUAL unsigned int GetSwatTurnTarget(int, int, FCoverInfo &);
    HG_VIRTUAL void BuildSlotInfo(int, unsigned int, AScout *);
    HG_VIRTUAL void BuildSlotInfoInternal(AScout *, int, unsigned int);
    HG_VIRTUAL unsigned int GetFireLinkTo(int, const FCoverInfo &, unsigned char, unsigned char, int &, TArray<int,FDefaultAllocator> &);
    HG_VIRTUAL unsigned int HasFireLinkTo(int, const FCoverInfo &, unsigned int);
    HG_VIRTUAL unsigned int IsFireLinkValid(int, int, unsigned char);
    HG_VIRTUAL unsigned int LinkCoverSlotToNavigationMesh(int, UNavigationMeshBase *);
    HG_VIRTUAL int FindCoverReference(ACoverLink *, int, unsigned int);
    HG_VIRTUAL unsigned int GetCachedCoverInfo(int, FCoverInfo &);
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
HG_PRIVATE:
    ACoverLink &operator=(const ACoverLink &);
public:
    static UClass *GetPrivateStaticClassACoverLink(const wchar_t *);
    static void InitializePrivateStaticClassACoverLink();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    void SortSlots(FCoverSlot **);
    void BuildFireLinks(AScout *);
    void BuildOtherLinks(AScout *);
    unsigned int GetFireActions(ACoverLink::FFireLinkInfo &, ACoverLink *, int, unsigned int);
    unsigned int CanFireLinkHit(const FVector &, const FVector &, unsigned int);
    unsigned int GetExposedInfo(ACoverLink *, int, ACoverLink *, int, float &);
    float GetSlotHeight(int);
    HG_VIRTUAL void GetActorReferences(TArray<FActorReference *,FDefaultAllocator> &, unsigned int);
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
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ACoverLink();
public:
    #endif
    typedef ANavigationPoint Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
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
    char _pad0[0x3];
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<unsigned int> _bits294;  // 0x294, from GLOBAL_bUseSlotMarkers
    hg::gptr<AActor> DestructibleCoverActor;
    hg::gptr<ACoverLink> NextDestructibleCoverLink;
    hg::be<float> LeanTraceDist;
    TArrayNoInit<FCoverSlot> Slots;
    TArrayNoInit<FDynamicLinkInfo> DynamicLinkInfos;
    TArrayNoInit<APawn *> Claims;
    hg::be<float> InvalidateDistance;
    hg::be<float> MaxFireLinkDist;
    FVector CircularOrigin;
    hg::be<float> CircularRadius;
    hg::be<float> AlignDist;
    hg::be<float> AutoCoverSlotInterval;
    hg::be<float> StandHeight;
    hg::be<float> MidHeight;
    FVector StandingLeanOffset;
    FVector CrouchLeanOffset;
    FVector PopupOffset;
    hg::be<float> SlipDist;
    hg::be<float> TurnDist;
    hg::be<float> DangerScale;
    hg::gptr<ACoverLink> NextCoverLink;
    unsigned char LocationDescription;
    char _pad0[0x3];
    #endif
};

class IInterface_Speaker  // size 0x4, opaque
{
    HG_VFPTR
HG_PROTECTED:
    HG_XDK(HG_VIRTUAL ~IInterface_Speaker();)
public:
    HG_VIRTUAL UObject *GetUObjectInterfaceInterface_Speaker() HG_PURE;
    HG_VIRTUAL void eventSpeak(USoundCue *) HG_PURE;
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    IInterface_Speaker();
public:
    #endif
};

class APawn : public AActor, public IInterface_Speaker  // size 0x47C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void CacheAnimNodes();
    HG_VIRTUAL void MAT_BeginAnimControl(UInterpGroup *);
    HG_VIRTUAL void MAT_FinishAnimControl(UInterpGroup *);
    HG_VIRTUAL void MAT_SetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int);
    HG_VIRTUAL void MAT_SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL void MAT_SetMorphWeight(FName, float);
    HG_VIRTUAL void MAT_SetSkelControlScale(FName, float);
    HG_VIRTUAL void MAT_SetSkelControlStrength(FName, float);
    HG_VIRTUAL unsigned int IsAliveAndWell() const;
    HG_VIRTUAL FVector AdjustDestination(AActor *, FVector);
    HG_VIRTUAL unsigned int SuggestJumpVelocity(FVector &, FVector, FVector, unsigned int);
    HG_VIRTUAL float GetFallDuration();
    HG_VIRTUAL unsigned int IsValidEnemyTargetFor(const APlayerReplicationInfo *, unsigned int);
    HG_VIRTUAL void SetAnchor(ANavigationPoint *);
    HG_VIRTUAL ANavigationPoint *GetBestAnchor(AActor *, FVector, unsigned int, unsigned int, float &);
    HG_VIRTUAL unsigned int ReachedDestination(AActor *);
    HG_VIRTUAL unsigned int ReachedDestination(const FVector &, const FVector &, AActor *, unsigned int);
    HG_VIRTUAL unsigned int ReachedPoint(FVector, AActor *);
    HG_VIRTUAL void ForceCrouch();
    HG_VIRTUAL void SetPushesRigidBodies(unsigned int);
    HG_VIRTUAL unsigned int ReachedDesiredRotation();
    HG_VIRTUAL unsigned int InitRagdoll();
    HG_VIRTUAL unsigned int TermRagdoll();
    HG_VIRTUAL FRotator GetViewRotation();
    HG_VIRTUAL AVehicle *GetVehicleBase();
    HG_VIRTUAL void ClearConstraints();
    HG_VIRTUAL void AddPathConstraint(UPathConstraint *);
    HG_VIRTUAL void AddGoalEvaluator(UPathGoalEvaluator *);
    HG_VIRTUAL void IncrementPathStep(int, UCanvas *);
    HG_VIRTUAL void IncrementPathChild(int, UCanvas *);
    HG_VIRTUAL void DrawPathStep(UCanvas *);
    HG_VIRTUAL void ClearPathStep();
    HG_VIRTUAL void SetRootMotionInterpCurrentTime(float, float, unsigned int);
    HG_VIRTUAL void SmoothCorrection(const FVector &);
    HG_VIRTUAL USkeletalMeshComponent *GetMeshForSkelControlLimbTransform(const USkeletalMeshComponent *);
    HG_VIRTUAL void CheckNoiseHearing(AActor *, float, FName);
    HG_VIRTUAL float DampenNoise(AActor *, float, FName);
    HG_VIRTUAL void setMoveTimer(FVector);
    HG_VIRTUAL unsigned int moveToward(const FVector &, AActor *);
    HG_VIRTUAL unsigned int IsGlider();
    HG_VIRTUAL void rotateToward(FVector);
    HG_VIRTUAL unsigned int SharingVehicleWith(APawn *);
    HG_VIRTUAL void HandleSerpentineMovement(FVector &, float, const FVector &);
    HG_VIRTUAL int pointReachable(FVector, int);
    HG_VIRTUAL int actorReachable(AActor *, unsigned int, unsigned int);
    HG_VIRTUAL int Reachable(FVector, AActor *);
    HG_VIRTUAL unsigned int TryJumpUp(FVector, FVector, unsigned long, unsigned int);
    HG_VIRTUAL unsigned int ReachThresholdTest(const FVector &, const FVector &, AActor *, float, float, float);
    HG_VIRTUAL unsigned int SetHighJumpFlag();
    HG_VIRTUAL ETestMoveResult FindBestJump(FVector, FVector &);
    HG_VIRTUAL ETestMoveResult FindJumpUp(FVector, FVector &);
    HG_VIRTUAL unsigned int HurtByDamageType(UClass *);
    HG_VIRTUAL void SetMaxLandingVelocity(float);
    HG_VIRTUAL ANavigationPoint *CheckDetour(ANavigationPoint *, ANavigationPoint *, unsigned int);
    HG_VIRTUAL int calcMoveFlags();
    HG_VIRTUAL void MarkEndPoints(ANavigationPoint *, AActor *, const FVector &);
    HG_VIRTUAL float SecondRouteAttempt(ANavigationPoint *, ANavigationPoint *, float (*)(ANavigationPoint *, APawn *, float), float, AActor *, const FVector &, float, float, int, int);
    HG_VIRTUAL int ModifyCostForReachSpec(UReachSpec *, int);
    HG_VIRTUAL void InitForPathfinding(AActor *, ANavigationPoint *);
    HG_VIRTUAL unsigned int IsValidAnchor(ANavigationPoint *);
    HG_VIRTUAL void PostProcessPhysics(float, const FVector &);
    HG_VIRTUAL unsigned int ShouldBypassSimulatedClientPhysics();
    HG_VIRTUAL FVector CheckForLedges(FVector, FVector, FVector, int &, int &);
    HG_VIRTUAL void physFlying(float, int);
    HG_VIRTUAL void physSwimming(float, int);
    HG_VIRTUAL void physSpider(float, int);
    HG_VIRTUAL void physLadder(float, int);
    HG_VIRTUAL void startNewPhysics(float, int);
    HG_VIRTUAL void StartFalling(int, float, float, const FVector &, const FVector &);
    HG_VIRTUAL unsigned int ShouldCatchAir(const FVector &, const FVector &);
    HG_VIRTUAL void SetPostLandedPhysics(AActor *, FVector);
    HG_VIRTUAL void Crouch(int);
    HG_VIRTUAL void UnCrouch(int);
    HG_VIRTUAL FVector NewFallVelocity(FVector, FVector, float);
    HG_VIRTUAL float MaxSpeedModifier();
    HG_VIRTUAL float GetMaxAccel(float);
    HG_VIRTUAL FVector CalculateSlopeSlide(const FVector &, const FCheckResult &);
    HG_VIRTUAL void ProcessPushNotify(const FRigidBodyCollisionInfo &, const TArray<FRigidBodyContactInfo,FDefaultAllocator> &);
    HG_VIRTUAL unsigned int HasAudibleAmbientSound(const FVector &);
    HG_VIRTUAL unsigned int HasReached(ANavigationPoint *, unsigned int &);
    HG_VIRTUAL FVector GetIdealCameraOrigin();
    HG_VIRTUAL void BuildAnimSetList();
HG_PROTECTED:
    HG_VIRTUAL void ApplyVelocityBraking(float, float);
    HG_VIRTUAL void CalcVelocity(FVector &, float, float, float, int, int, int);
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
    HG_VIRTUAL unsigned int IsInvisible();
    void SetRemoteViewPitch(int);
    HG_VIRTUAL void GetBoundingCylinder(float &, float &) const;
    unsigned int IsHumanControlled(AController *);
    unsigned int IsLocallyControlled();
    HG_VIRTUAL unsigned int IsPlayerPawn() const;
    HG_VIRTUAL FVector GetPawnViewLocation();
    HG_VIRTUAL unsigned char GetTeamNum();
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
    HG_VIRTUAL void eventSpeak(USoundCue *);
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
HG_PRIVATE:
    APawn &operator=(const APawn &);
public:
    static UClass *GetPrivateStaticClassAPawn(const wchar_t *);
    static void InitializePrivateStaticClassAPawn();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    HG_VIRTUAL UObject *GetUObjectInterfaceInterface_Speaker();
    HG_VIRTUAL void PostBeginPlay();
    HG_VIRTUAL void PostScriptDestroyed();
    HG_VIRTUAL APawn *GetPlayerPawn() const;
    HG_VIRTUAL float GetNetPriority(const FVector &, const FVector &, APlayerController *, UActorChannel *, float, unsigned int);
    HG_VIRTUAL int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    HG_VIRTUAL void NotifyBump(AActor *, UPrimitiveComponent *, const FVector &);
    HG_VIRTUAL void TickSimulated(float);
    HG_VIRTUAL void TickSpecial(float);
    HG_VIRTUAL unsigned int PlayerControlled();
    HG_VIRTUAL void SetBase(AActor *, FVector, int, USkeletalMeshComponent *, FName);
    HG_VIRTUAL unsigned int IsNetRelevantFor(APlayerController *, AActor *, const FVector &);
    unsigned int CacheNetRelevancy(unsigned int, APlayerController *, AActor *);
    HG_VIRTUAL unsigned int ShouldTrace(UPrimitiveComponent *, AActor *, unsigned long);
    HG_VIRTUAL void PreNetReceive();
    HG_VIRTUAL void PostNetReceiveLocation();
    HG_VIRTUAL const APawn *GetAPawn() const;
    HG_VIRTUAL APawn *GetAPawn();
    HG_VIRTUAL void SetHardAttach(unsigned int);
    HG_VIRTUAL unsigned int CanCauseFractureOnTouch();
    HG_VIRTUAL void SetZone(unsigned int, unsigned int);
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
    HG_VIRTUAL unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
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
    HG_VIRTUAL ANavigationPoint *SpecifyEndAnchor(APawn *);
    HG_VIRTUAL unsigned int AnchorNeedNotBeReachable();
    HG_VIRTUAL void NotifyAnchorFindingResult(ANavigationPoint *, APawn *);
    HG_VIRTUAL void setPhysics(unsigned char, AActor *, FVector);
    HG_VIRTUAL void performPhysics(float);
    HG_VIRTUAL void physWalking(float, int);
    HG_VIRTUAL void physNavMeshWalking(float);
    HG_VIRTUAL void physFalling(float, int);
    HG_VIRTUAL void GetNetBuoyancy(float &, float &);
    void startSwimming(FVector, FVector, float, float, int);
    HG_VIRTUAL void physicsRotation(float, FVector);
    HG_VIRTUAL void processLanded(const FVector &, AActor *, float, int);
    HG_VIRTUAL void processHitWall(const FCheckResult &, float);
    HG_VIRTUAL void SmoothHitWall(const FVector &, AActor *);
    HG_VIRTUAL void stepUp(const FVector &, const FVector &, const FVector &, FCheckResult &);
    HG_VIRTUAL unsigned int IgnoreBlockingBy(const AActor *) const;
    HG_VIRTUAL void PushedBy(AActor *);
    HG_VIRTUAL void UpdateBasedRotation(FRotator &, const FRotator &);
    HG_VIRTUAL void ReverseBasedRotation();
    HG_VIRTUAL void InitRBPhys();
    HG_VIRTUAL void TermRBPhys(FRBPhysScene *);
    HG_VIRTUAL void UpdatePushBody();
    HG_VIRTUAL unsigned int Tick(float, ELevelTick);
    void RestoreAnimSetsToDefault();
    HG_VIRTUAL void GetAnimControlSlotDesc(TArray<FAnimSlotDesc,FDefaultAllocator> &);
    HG_VIRTUAL void PreviewBeginAnimControl(UInterpGroup *);
    HG_VIRTUAL void PreviewSetAnimPosition(FName, int, FName, float, unsigned int, unsigned int, unsigned int, float);
    HG_VIRTUAL void PreviewSetAnimWeights(TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL void PreviewFinishAnimControl(UInterpGroup *);
    HG_VIRTUAL void PreviewUpdateFaceFX(unsigned int, const FString &, const FString &, float);
    HG_VIRTUAL void PreviewActorPlayFaceFX(const FString &, const FString &, UAkBaseSoundObject *);
    HG_VIRTUAL void PreviewActorStopFaceFX();
    HG_VIRTUAL UAudioComponent *PreviewGetFaceFXAudioComponent();
    HG_VIRTUAL UFaceFXAsset *PreviewGetActorFaceFXAsset();
    HG_VIRTUAL void PreviewSetMorphWeight(FName, float);
    HG_VIRTUAL void PreviewSetSkelControlScale(FName, float);
    HG_VIRTUAL void SetSkelControlStrength(FName, float);
    HG_VIRTUAL void SetAnimWeights(const TArray<FAnimSlotInfo,FDefaultAllocator> &);
    HG_VIRTUAL void AdjustInterpTrackMove(FVector &, FRotator &, float, unsigned int);
    HG_VIRTUAL unsigned int FindInterpMoveTrack(UInterpTrackMove **, UInterpTrackInstMove **, USeqAct_Interp **);
    void UpdateScalarParameterInterp(float);
HG_PRIVATE:
    unsigned int Pick3DWallAdjust(FVector, AActor *);
    float Swim(FVector, FCheckResult &);
    FVector findWaterLine(FVector, FVector);
    void SpiderstepUp(const FVector &, const FVector &, FCheckResult &);
    int findNewFloor(FVector, float, float, int);
    int checkFloor(FVector, FCheckResult &);
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~APawn();
public:
    #endif
    typedef AActor Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int APawnData[0xA9];
};

class AVehicle : public APawn  // size 0x4F0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL float GetMaxRiseForce();
    HG_VIRTUAL unsigned int HasRelevantDriver();
    HG_VIRTUAL unsigned int IsStuck();
    HG_VIRTUAL unsigned int AdjustFlight(float, unsigned int, float, AActor *);
    HG_VIRTUAL void SteerVehicle(FVector);
    HG_VIRTUAL void AdjustThrottle(float);
    HG_VIRTUAL unsigned int JumpOutCheck(AActor *, float, float);
    HG_VIRTUAL void moveTowardGwNav(const FVector &);
    HG_VIRTUAL FVector GetTargetLocation(AActor *, unsigned int) const;
    void execGetMaxRiseForce(FFrame &, void *const);
    unsigned int eventGwNavBotExitVehicle(APawn *);
    unsigned int eventGwNavBotEnterVehicle(APawn *);
    FVector eventGetEntryLocation();
    unsigned int eventDriverLeave(unsigned int);
    unsigned int eventContinueOnFoot();
HG_PRIVATE:
    AVehicle &operator=(const AVehicle &);
public:
    static UClass *GetPrivateStaticClassAVehicle(const wchar_t *);
    static void InitializePrivateStaticClassAVehicle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    HG_VIRTUAL unsigned int IsNetRelevantFor(APlayerController *, AActor *, const FVector &);
    HG_VIRTUAL unsigned int ReachedBy(APawn *, const FVector &, const FVector &);
    HG_VIRTUAL ANavigationPoint *CheckDetour(ANavigationPoint *, ANavigationPoint *, unsigned int);
    HG_VIRTUAL void performPhysics(float);
    HG_VIRTUAL AVehicle *GetAVehicle();
    HG_VIRTUAL unsigned int IsRelevancyOwnerFor(AActor *, AActor *, AActor *);
    HG_VIRTUAL void setMoveTimer(FVector);
    HG_VIRTUAL unsigned int moveToward(const FVector &, AActor *);
    HG_VIRTUAL void rotateToward(FVector);
    HG_VIRTUAL void MarkEndPoints(ANavigationPoint *, AActor *, const FVector &);
    HG_VIRTUAL float SecondRouteAttempt(ANavigationPoint *, ANavigationPoint *, float (*)(ANavigationPoint *, APawn *, float), float, AActor *, const FVector &, float, float, int, int);
    HG_VIRTUAL unsigned int IsGlider();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AVehicle();
public:
    #endif
    typedef APawn Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int AVehicleData[0x1D];
};

class ASVehicle : public AVehicle  // size 0x620, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void AddForce(FVector);
    HG_VIRTUAL void AddImpulse(FVector);
    HG_VIRTUAL void AddTorque(FVector);
    HG_VIRTUAL unsigned int IsSleeping();
    HG_VIRTUAL void InitVehicleRagdoll(USkeletalMesh *, UPhysicsAsset *, FVector, unsigned int);
    HG_VIRTUAL unsigned int HasWheelsOnGround();
    HG_VIRTUAL void VehiclePackRBState();
    HG_VIRTUAL void VehicleUnpackRBState();
    HG_VIRTUAL FVector GetDampingForce(const FVector &);
    HG_VIRTUAL void UpdateVehicle(ASVehicle *, float);
    HG_VIRTUAL void SetWheelEffectParams(USVehicleWheel *, float);
    void SetWheelCollision(int, unsigned int);
    void execAddForce(FFrame &, void *const);
    void execAddImpulse(FFrame &, void *const);
    void execAddTorque(FFrame &, void *const);
    void execIsSleeping(FFrame &, void *const);
    void execSetWheelCollision(FFrame &, void *const);
    void execInitVehicleRagdoll(FFrame &, void *const);
    void execHasWheelsOnGround(FFrame &, void *const);
    void eventSuspensionHeavyShift(float);
HG_PRIVATE:
    ASVehicle &operator=(const ASVehicle &);
public:
    static UClass *GetPrivateStaticClassASVehicle(const wchar_t *);
    static void InitializePrivateStaticClassASVehicle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    HG_VIRTUAL void physRigidBody(float);
    HG_VIRTUAL void TickSimulated(float);
    HG_VIRTUAL void TickAuthoritative(float);
    HG_VIRTUAL void setPhysics(unsigned char, AActor *, FVector);
    HG_VIRTUAL void PostNetReceiveLocation();
    HG_VIRTUAL int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    HG_VIRTUAL void OnRigidBodyCollision(const FRigidBodyCollisionInfo &, const FRigidBodyCollisionInfo &, const FCollisionImpactData &);
    HG_VIRTUAL void ModifyNxActorDesc(NxActorDesc &, UPrimitiveComponent *, const NxGroupsMask &, unsigned int);
    HG_VIRTUAL void PostInitRigidBody(NxActor *, NxActorDesc &, UPrimitiveComponent *);
    HG_VIRTUAL void PreTermRigidBody(NxActor *);
    HG_VIRTUAL void TermRBPhys(FRBPhysScene *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ASVehicle();
public:
    #endif
    typedef AVehicle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int ASVehicleData[0x4C];
};

class AGwNavVehicle : public ASVehicle  // size 0x630, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void MoveToPosition(FVector);
    HG_VIRTUAL unsigned int IsArrived();
    HG_VIRTUAL void IntializeNavigationBot(UGwNavNavdataFamily *, unsigned int, unsigned int, int);
    void execMoveToPosition(FFrame &, void *const);
    void execIsArrived(FFrame &, void *const);
    void execIntializeNavigationBot(FFrame &, void *const);
    void eventExecuteVehicleCommand(unsigned char);
HG_PRIVATE:
    AGwNavVehicle &operator=(const AGwNavVehicle &);
public:
    static UClass *GetPrivateStaticClassAGwNavVehicle(const wchar_t *);
    static void InitializePrivateStaticClassAGwNavVehicle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
    HG_VIRTUAL void PostBeginPlay();
    HG_VIRTUAL void PostScriptDestroyed();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AGwNavVehicle();
public:
    #endif
    typedef ASVehicle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int AGwNavVehicleData[0x4];
};

class AKAsset : public AActor  // size 0x1E4, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    AKAsset &operator=(const AKAsset &);
public:
    static UClass *GetPrivateStaticClassAKAsset(const wchar_t *);
    static void InitializePrivateStaticClassAKAsset();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int *GetOptimizedRepList(unsigned char *, FPropertyRetirement *, int *, UPackageMap *, UActorChannel *);
    HG_VIRTUAL unsigned int ShouldTrace(UPrimitiveComponent *, AActor *, unsigned long);
    HG_VIRTUAL unsigned int IgnoreBlockingBy(const AActor *) const;
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AKAsset();
public:
    #endif
    typedef AActor Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int AKAssetData[0x4];
};

class AUDKCover : public AKAsset  // size 0x1E8
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void AddCoverLink(ACoverLink *);
    HG_VIRTUAL void RemoveCoverLink(ACoverLink *);
    HG_VIRTUAL void KillCoverLinks();
    HG_VIRTUAL FVector GetPawnViewLocation();
    void execAddCoverLink(FFrame &, void *const);
    void execRemoveCoverLink(FFrame &, void *const);
    void execKillCoverLinks(FFrame &, void *const);
HG_PRIVATE:
    AUDKCover &operator=(const AUDKCover &);
public:
    static UClass *GetPrivateStaticClassAUDKCover(const wchar_t *);
    static void InitializePrivateStaticClassAUDKCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL void PreBeginPlay();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AUDKCover();
public:
    #endif
    typedef AKAsset Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    ACoverLink *FirstCoverLink;  // 0x1E4
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<ACoverLink> FirstCoverLink;
    #endif
};

class AUSSController : public ACCSController  // size 0x4B0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    AUSSController &operator=(const AUSSController &);
public:
    static UClass *GetPrivateStaticClassAUSSController(const wchar_t *);
    static void InitializePrivateStaticClassAUSSController();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
HG_PROTECTED:
    HG_VIRTUAL void PostPollMove();
public:
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AUSSController();
public:
    #endif
    typedef ACCSController Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class ICCSPawn  // size 0x4, opaque
{
    HG_VFPTR
HG_PROTECTED:
    HG_XDK(HG_VIRTUAL ~ICCSPawn();)
public:
    HG_VIRTUAL UObject *GetUObjectInterfaceCCSPawn() HG_PURE;
    HG_VIRTUAL unsigned char GetMovementType() HG_PURE;
    HG_VIRTUAL void SetMovementType(unsigned char) HG_PURE;
    HG_VIRTUAL void SetMovementTypeDefault() HG_PURE;
    HG_VIRTUAL unsigned char GetAlertness() HG_PURE;
    HG_VIRTUAL void SetAlertness(unsigned char) HG_PURE;
    HG_VIRTUAL void SetAlertnessDefault() HG_PURE;
    HG_VIRTUAL unsigned char GetSpeed() HG_PURE;
    HG_VIRTUAL void SetSpeed(unsigned char) HG_PURE;
    HG_VIRTUAL void SetMovementSpeedDefault() HG_PURE;
    HG_VIRTUAL unsigned int IsCrouched() HG_PURE;
    HG_VIRTUAL void SetCrouched(unsigned int) HG_PURE;
    HG_VIRTUAL void SetPostureDefault() HG_PURE;
    HG_VIRTUAL unsigned int PostureTransitionOver() HG_PURE;
    HG_VIRTUAL unsigned int CanAim(FRotator) HG_PURE;
    HG_VIRTUAL void SetCoverPose(unsigned char, float) HG_PURE;
    HG_VIRTUAL void SetNoCoverPose() HG_PURE;
    HG_VIRTUAL unsigned int CoverPoseTransitionOver() HG_PURE;
    HG_VIRTUAL void MoveToInCover(FVector) HG_PURE;
    HG_VIRTUAL unsigned int IsInCover() HG_PURE;
    HG_VIRTUAL unsigned int GetIsPanicking() HG_PURE;
    HG_VIRTUAL void SetIsPanicking(unsigned int) HG_PURE;
    HG_VIRTUAL float GetYellingDistance() HG_PURE;
    HG_VIRTUAL UCCSBTTree *GetDefaultBehaviorTree() HG_PURE;
    HG_VIRTUAL void SetDefaultBehaviorTree(UCCSBTTree *) HG_PURE;
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    ICCSPawn();
public:
    #endif
};

class AUSSPawn : public APawn, public ICCSPawn  // size 0x4CC, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL unsigned char GetMovementType();
    HG_VIRTUAL void SetMovementType(unsigned char);
    HG_VIRTUAL void SetMovementTypeDefault();
    HG_VIRTUAL unsigned char GetAlertness();
    HG_VIRTUAL void SetAlertness(unsigned char);
    HG_VIRTUAL void SetAlertnessDefault();
    HG_VIRTUAL unsigned char GetSpeed();
    HG_VIRTUAL void SetSpeed(unsigned char);
    HG_VIRTUAL void SetMovementSpeedDefault();
    HG_VIRTUAL unsigned int IsCrouched();
    HG_VIRTUAL void SetCrouched(unsigned int);
    HG_VIRTUAL void SetPostureDefault();
    HG_VIRTUAL unsigned int PostureTransitionOver();
    HG_VIRTUAL unsigned int CanAim(FRotator);
    HG_VIRTUAL void SetCoverPose(unsigned char, float);
    HG_VIRTUAL void SetNoCoverPose();
    HG_VIRTUAL unsigned int CoverPoseTransitionOver();
    HG_VIRTUAL void MoveToInCover(FVector);
    HG_VIRTUAL unsigned int IsInCover();
    HG_VIRTUAL void SetIsPanicking(unsigned int);
    HG_VIRTUAL unsigned int GetIsPanicking();
    HG_VIRTUAL UCCSBTTree *GetDefaultBehaviorTree();
    HG_VIRTUAL void SetDefaultBehaviorTree(UCCSBTTree *);
    HG_VIRTUAL float GetYellingDistance();
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
HG_PRIVATE:
    AUSSPawn &operator=(const AUSSPawn &);
public:
    static UClass *GetPrivateStaticClassAUSSPawn(const wchar_t *);
    static void InitializePrivateStaticClassAUSSPawn();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL UObject *GetUObjectInterfaceCCSPawn();
    HG_VIRTUAL void TickSpecial(float);
    HG_VIRTUAL float MaxSpeedModifier();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~AUSSPawn();
public:
    #endif
    typedef APawn Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int AUSSPawnData[0x13];
};

class GripVHeapObject  // size 0x4, opaque
{
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~GripVHeapObject();)
    #ifndef HAGGAR_HOST
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
    #endif
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
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float) HG_PURE;
    HG_VIRTUAL const char *GetName();
    GripAFAction::EGripAFActionStatus GetStatus();
    Grip_ArrayPOD<GripAFModifier *,2> &GetModifiers();
    #ifndef HAGGAR_HOST
    GripAFAction();
    HG_VIRTUAL ~GripAFAction();
    #endif
HG_PRIVATE:
    unsigned int GripAFActionData[0x6];
};

class CCSAFAction : public GripAFAction  // size 0x20, opaque
{
public:
    #ifndef HAGGAR_HOST
    CCSAFAction();
    #endif
HG_PRIVATE:
    unsigned int CCSAFActionData[0x1];
};

class CCSAFEncircleTarget : public CCSAFAction  // size 0x5C, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOEncircleTarget &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    void UpdateGoal();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFEncircleTarget();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFEncircleTargetData[0xF];
};

class CCSAFEnterCover : public CCSAFAction  // size 0x58, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOEnterCover &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFEnterCover();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFEnterCoverData[0xE];
};

class CCSAFExitCover : public CCSAFAction  // size 0x24, opaque
{
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    void SetObjective(const CCSAOExitCover &);
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFExitCover();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFExitCoverData[0x1];
};

class CCSAFFireBurst : public CCSAFAction  // size 0x44, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOFireBurst &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFFireBurst();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFFireBurstData[0x9];
};

class CCSAFFlee : public CCSAFAction  // size 0x58, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOFlee &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
HG_PRIVATE:
    void UpdateMoveTarget();
public:
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFFlee();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFFleeData[0xE];
};

class CCSAFGetInCover : public CCSAFAction  // size 0x58, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOGetInCover &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFGetInCover();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFGetInCoverData[0xE];
};

class CCSAFGetOutCover : public CCSAFAction  // size 0x58, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOGetOutCover &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFGetOutCover();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFGetOutCoverData[0xE];
};

class CCSAFIdle : public CCSAFAction  // size 0x28, opaque
{
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void Tick(float);
    void SetObjective(const CCSAOIdle &);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFIdle();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFIdleData[0x2];
};

class CCSAFMoveTo : public CCSAFAction  // size 0x38, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOMoveTo &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFMoveTo();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFMoveToData[0x6];
};

class CCSAFMoveToActor : public CCSAFAction  // size 0x5C, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOMoveToActor &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFMoveToActor();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFMoveToActorData[0xF];
};

class CCSAFOrientToward : public CCSAFAction  // size 0x38, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOOrientToward &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFOrientToward();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFOrientTowardData[0x6];
};

class CCSAFStrafeTarget : public CCSAFAction  // size 0x5C, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOStrafeTarget &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    bool UpdateGoal();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFStrafeTarget();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFStrafeTargetData[0xF];
};

class CCSAFStrafeTo : public CCSAFAction  // size 0x38, opaque
{
HG_PROTECTED:
    void SetObjective(const CCSAOStrafeTo &);
public:
    HG_VIRTUAL void PostCreate();
    HG_VIRTUAL void OnActivate();
    HG_VIRTUAL bool TransitionTo(GripAFAction *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL const char *GetName();
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    CCSAFStrafeTo();
public:
    #endif
HG_PRIVATE:
    unsigned int CCSAFStrafeToData[0x6];
};

class GripBlackboard : public GripVHeapObject  // size 0x8C, opaque
{
public:
    HG_VIRTUAL void Reset();
    HG_VIRTUAL void RegisterMembers();
    HG_VIRTUAL GripBBVisualization *GetVisualizer() HG_PURE;
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &);
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
    #ifndef HAGGAR_HOST
    GripBlackboard();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL void Reset();
    HG_VIRTUAL void RegisterMembers();
    HG_VIRTUAL GripBBVisualization *GetVisualizer();
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
HG_PRIVATE:
    void UpdateTargetPointers();
public:
    CCSTarget *GetSpecificTarget(FString);
    FVector GetCurrentTether();
    #ifndef HAGGAR_HOST
    CCSBlackboard();
    #endif
HG_PRIVATE:
    unsigned int CCSBlackboardData[0x17C];
};

struct CCSController_eventActionStopFiring_Parms  // size 0x1
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventActionStopFiring_Parms(EEventParm);
    #endif
};

struct CCSController_eventAimAt_Parms  // size 0x4
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventAimAt_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    AActor *newFocus;  // 0x0
    #else
    hg::gptr<AActor> newFocus;
    #endif
};

struct CCSController_eventCanFireAt_Parms  // size 0x8
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventCanFireAt_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    AActor *Target;  // 0x0
    unsigned int ReturnValue;  // 0x4
    #else
    hg::gptr<AActor> Target;
    hg::be<unsigned int> ReturnValue;
    #endif
};

struct CCSController_eventCreateDebugVizComponent_Parms  // size 0x1
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventCreateDebugVizComponent_Parms(EEventParm);
    #endif
};

struct CCSController_eventFindNavMeshDistance_Parms  // size 0x14
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventFindNavMeshDistance_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    FVector targetPos;  // 0x0
    float Distance;  // 0xC
    unsigned int ReturnValue;  // 0x10
    #else
    FVector targetPos;
    hg::be<float> Distance;
    hg::be<unsigned int> ReturnValue;
    #endif
};

struct CCSController_eventFindNavMeshPath_Parms  // size 0x10
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventFindNavMeshPath_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    FVector targetPos;  // 0x0
    unsigned int ReturnValue;  // 0xC
    #else
    FVector targetPos;
    hg::be<unsigned int> ReturnValue;
    #endif
};

struct CCSController_eventFireWeapon_Parms  // size 0x10
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventFireWeapon_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    unsigned int charge;  // 0x0
    unsigned int lastShot;  // 0x4
    unsigned int alwaysFire;  // 0x8
    unsigned int ReturnValue;  // 0xC
    #else
    hg::be<unsigned int> charge;
    hg::be<unsigned int> lastShot;
    hg::be<unsigned int> alwaysFire;
    hg::be<unsigned int> ReturnValue;
    #endif
};

struct CCSController_eventNotifyAIMoveToActorCompleted_Parms  // size 0x1
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventNotifyAIMoveToActorCompleted_Parms(EEventParm);
    #endif
};

struct CCSController_eventStartFireBurstObj_Parms  // size 0x8
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventStartFireBurstObj_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    AActor *Target;  // 0x0
    unsigned int ReturnValue;  // 0x4
    #else
    hg::gptr<AActor> Target;
    hg::be<unsigned int> ReturnValue;
    #endif
};

struct CCSController_eventStartFireBurst_Parms  // size 0x8
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventStartFireBurst_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    APawn *Target;  // 0x0
    unsigned int ReturnValue;  // 0x4
    #else
    hg::gptr<APawn> Target;
    hg::be<unsigned int> ReturnValue;
    #endif
};

struct CCSController_eventStopFireBurst_Parms  // size 0x4
{
public:
    #ifndef HAGGAR_HOST
    CCSController_eventStopFireBurst_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    unsigned int ReturnValue;  // 0x0
    #else
    hg::be<unsigned int> ReturnValue;
    #endif
};

template <> class TArray<ActorWrapper *,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    ActorWrapper *const &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<ActorWrapper *,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

template <> class TArray<CCSGameCover,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
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
HG_PRIVATE:
    const CCSGameCover &DebugGet(int) const;
HG_PROTECTED:
    void DestructItems(int, int);
public:
    #ifndef HAGGAR_HOST
    TArray(const TArray<CCSGameCover,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    #endif
HG_PRIVATE:
    unsigned int TArrayData[0x3];
};

class CCSNorman  // size 0x2C
{
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
    #ifndef HAGGAR_HOST
HG_PRIVATE:
    CCSNorman();
public:
    #endif
    #ifndef HAGGAR_HOST
    static CCSNorman *instance;
    CCSPSTargetAwareness *pFirstTargeter;  // 0x0
    TArray<ActorWrapper *,FDefaultAllocator> m_ThreatTargetsMasterList;  // 0x4
    CCSPSCover *pFirstCoverSeeker;  // 0x10
    TArray<CCSGameCover,FDefaultAllocator> m_CoverMasterList;  // 0x14
    int m_ThreatTargetsMasterListRefCount;  // 0x20
    int m_CoverMasterListRefCount;  // 0x24
    ACoverLink *FirstCoverLink;  // 0x28
    #else
    static hg::gptr<CCSNorman> (&instance);
    hg::gptr<CCSPSTargetAwareness> pFirstTargeter;
    TArray<ActorWrapper *,FDefaultAllocator> m_ThreatTargetsMasterList;
    hg::gptr<CCSPSCover> pFirstCoverSeeker;
    TArray<CCSGameCover,FDefaultAllocator> m_CoverMasterList;
    hg::be<int> m_ThreatTargetsMasterListRefCount;
    hg::be<int> m_CoverMasterListRefCount;
    hg::gptr<ACoverLink> FirstCoverLink;
    #endif
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
    HG_VIRTUAL void Initialize(const GripSystemConfig *);
    HG_VIRTUAL void Finalize();
    HG_VIRTUAL void FlagAsUsed();
    HG_VIRTUAL void Activate();
    HG_VIRTUAL void Deactivate();
    HG_VIRTUAL void Tick(float) HG_PURE;
    HG_VIRTUAL bool TickBudget(float, int &);
    HG_VIRTUAL int GetId() const;
    HG_VIRTUAL int GetFamily() const;
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &);
    HG_VIRTUAL void DrawScene(IGripSceneRenderer *);
    GripBrainSystem::EActivationState GetState() const;
    bool IsInStasis() const;
    bool IsUsed() const;
    void OnTickCycleCompleted();
    #ifndef HAGGAR_HOST
    GripBrainSystem();
    HG_VIRTUAL ~GripBrainSystem();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL void Initialize(const GripSystemConfig *);
    static int SGetFamily();
    HG_VIRTUAL int GetFamily() const;
    void BecomeAware(bool);
    void AlertFriends();
    #ifndef HAGGAR_HOST
    CCSSensorSystem(CCSBrain *);
    #endif
HG_PRIVATE:
    unsigned int CCSSensorSystemData[0x1];
};

struct GripSystemConfig : public GripVHeapObject  // size 0x4, opaque
{
};

struct CCSSystemsConfig : public GripSystemConfig  // size 0x34, opaque
{
HG_PRIVATE:
    unsigned int CCSSystemsConfigData[0xC];
};

class CCSPSCover : public CCSSensorSystem  // size 0x50
{
public:
    HG_VIRTUAL void Initialize(const GripSystemConfig *);
    HG_VIRTUAL void Finalize();
    void AddCover(ACoverLink *);
    void AddCover(CCSGameCover &);
    void RemoveCover(ACoverLink *);
    void RemoveCover(CCSGameCover &);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL bool TickBudget(float, int &);
    static int SGetId();
    HG_VIRTUAL int GetId() const;
HG_PRIVATE:
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
    #ifndef HAGGAR_HOST
    CCSPSCover(CCSBrain *);
    HG_VIRTUAL ~CCSPSCover();
    #endif
    #ifndef HAGGAR_HOST
    CCSPSCover *pNextCoverSeeker;  // 0x10
    int m_coverIdx;  // 0x14
    CCSSystemsConfig m_config;  // 0x18
    CCSCoverRenderingComponent *m_pDebugComponent;  // 0x4C
    #else
    hg::gptr<CCSPSCover> pNextCoverSeeker;
    hg::be<int> m_coverIdx;
    CCSSystemsConfig m_config;
    hg::gptr<CCSCoverRenderingComponent> m_pDebugComponent;
    #endif
};

template <> class Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > : public GripVHeapObject  // size 0x10, opaque
{
public:
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
HG_PROTECTED:
    void CloneContainer(CCSCharacter *, int, int);
    void DestructItems(int, int);
    void ResizeTo(int);
    void DeleteContainerContent();
public:
    #ifndef HAGGAR_HOST
    Grip_Array(const Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > &);
    Grip_Array(const int);
    HG_VIRTUAL ~Grip_Array();
    #endif
    #ifndef HAGGAR_HOST
    static const int increment;
    #else
    static const hg::be<int> (&increment);
    #endif
HG_PRIVATE:
    unsigned int Grip_ArrayData[0x3];
};

class CCSPSTargetAwareness : public CCSSensorSystem  // size 0x5C
{
public:
    struct Config  // size 0x28, opaque
    {
    public:
        #ifndef HAGGAR_HOST
        Config();
        #endif
    HG_PRIVATE:
        unsigned int ConfigData[0xA];
    };
    HG_VIRTUAL void Initialize(const GripSystemConfig *);
    HG_VIRTUAL void Finalize();
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL bool TickBudget(float, int &);
    static int SGetId();
    HG_VIRTUAL int GetId() const;
    void AddThreatTarget(AActor *);
    void RemoveThreatTarget(AActor *);
HG_PRIVATE:
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
    #ifndef HAGGAR_HOST
    CCSPSTargetAwareness(CCSBrain *);
    #endif
    #ifndef HAGGAR_HOST
    CCSPSTargetAwareness *pNextTargeter;  // 0x10
    int m_targetIdx;  // 0x14
    int m_vehicleIdx;  // 0x18
    bool m_curTargetIsCamoed;  // 0x1C
    char _pad0[0x3];
    CCSPSTargetAwareness::Config m_config;  // 0x20
    Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > m_vehicles;  // 0x48
    CCSTargetRenderingComponent *m_pDebugComponent;  // 0x58
    #else
    hg::gptr<CCSPSTargetAwareness> pNextTargeter;
    hg::be<int> m_targetIdx;
    hg::be<int> m_vehicleIdx;
    bool m_curTargetIsCamoed;
    char _pad0[0x3];
    CCSPSTargetAwareness::Config m_config;
    Grip_Array<CCSCharacter,Grip::AllocatorGH<CCSCharacter,2> > m_vehicles;
    hg::gptr<CCSTargetRenderingComponent> m_pDebugComponent;
    #endif
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
    HG_VIRTUAL void GripBTInitialize();
    HG_VIRTUAL void Delete();
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTEvaluationResult EvaluateInternal(IGripBTInterface *, GripBTStack *);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL void GameEventRegistration(GripGameEventHandler &);
public:
    HG_VIRTUAL void SurveyUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL void GetUsedControlSystems(GripBTSystemFlags &);
    HG_VIRTUAL GripRBTNode::EBTEvaluationResult Evaluate(IGripBTInterface *, GripBTStack *);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult Execute(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL EGripBTNodeFamily GetFamily();
    HG_VIRTUAL float GetWeight(IGripBTInterface *);
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
    void Serialize(GripSerializer *);
HG_PRIVATE:
    Grip::String GetNodeTypeLabel();
public:
    GripRBTNode::EBTExecutionResult GetExecutionResultVisualization() const;
    Grip::String GetName() const;
    int GetNodeID() const;
    void SetName(Grip::String);
    Grip::String GetJSONRepresentation();
    #ifndef HAGGAR_HOST
    GripRBTNode();
    HG_VIRTUAL ~GripRBTNode();
    static void *operator new(unsigned int);
    static void operator delete(void *);
    #endif
    #ifndef HAGGAR_HOST
    static int ms_IDCounter;
    static GripRBTAllocator *ms_pAllocator;
    #else
    static hg::be<int> (&ms_IDCounter);
    static hg::gptr<GripRBTAllocator> (&ms_pAllocator);
    #endif
HG_PRIVATE:
    unsigned int GripRBTNodeData[0x18];
};

class GripRBTBehavior : public GripRBTNode  // size 0x64, opaque
{
public:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL EGripBTNodeFamily GetFamily();
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
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetFireChance(float);
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetDirectionFlags(bool, bool);
    void SetForceFire(bool);
    #ifndef HAGGAR_HOST
    CCSRBTEncircleTarget();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL EGripBTNodeFamily GetFamily();
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTEvaluationResult EvaluateInternal(IGripBTInterface *, GripBTStack *);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
};

class GripRBTBooleanCondition : public GripRBTCondition  // size 0x68, opaque
{
public:
    void SetNegate(bool);
    #ifndef HAGGAR_HOST
    GripRBTBooleanCondition();
    #endif
HG_PRIVATE:
    unsigned int GripRBTBooleanConditionData[0x1];
};

class CCSRBTEnemyAware : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

template <> class GripRBTNumericCondition<int> : public GripRBTCondition  // size 0x70
{
public:
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    void SetOperator(GripRBTCondition::EOperator);
    void SetThreshold(int);
    void SetValue(int);
    #ifndef HAGGAR_HOST
    GripRBTNumericCondition();
    #endif
    #ifndef HAGGAR_HOST
    GripRBTCondition::EOperator m_operator;  // 0x64
    int m_threshold;  // 0x68
    int m_value;  // 0x6C
    #else
    hg::be<GripRBTCondition::EOperator> m_operator;
    hg::be<int> m_threshold;
    hg::be<int> m_value;
    #endif
};

class CCSRBTEnemyClosestRange : public GripRBTNumericCondition<int>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

template <> class GripRBTNumericCondition<float> : public GripRBTCondition  // size 0x70
{
public:
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    void SetOperator(GripRBTCondition::EOperator);
    void SetThreshold(float);
    void SetValue(float);
    #ifndef HAGGAR_HOST
    GripRBTNumericCondition();
    #endif
    #ifndef HAGGAR_HOST
    GripRBTCondition::EOperator m_operator;  // 0x64
    float m_threshold;  // 0x68
    float m_value;  // 0x6C
    #else
    hg::be<GripRBTCondition::EOperator> m_operator;
    hg::be<float> m_threshold;
    hg::be<float> m_value;
    #endif
};

class CCSRBTEnemyLowestLKPAge : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
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
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
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
HG_PRIVATE:
    CCSTarget *GetSecondaryTarget(IGripBTInterface *);
public:
    #ifndef HAGGAR_HOST
    CCSRBTMoveTo();
    #endif
HG_PRIVATE:
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
HG_PROTECTED:
    HG_VIRTUAL CCSCover FindBestCover(IGripBTInterface *) const;
    GripRBTNode::EBTExecutionResult StartMoveToCover(IGripBTInterface *);
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
    bool MovingToCover(CCSBlackboard *);
    void EnterCover(CCSBlackboard *, CCSAFFactory *, GripAFScheduler *);
    void ExitCover(CCSAFFactory *, GripAFScheduler *);
public:
    #ifndef HAGGAR_HOST
    CCSRBTMoveToCover();
    #endif
HG_PRIVATE:
    unsigned int CCSRBTMoveToCoverData[0xC];
};

class CCSRBTMoveToBestCover : public CCSRBTMoveToCover  // size 0xDC, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
HG_PROTECTED:
    HG_VIRTUAL CCSCover FindBestCover(IGripBTInterface *) const;
public:
    void SetIdealShootingDistance(float);
    void SetExcludeCurrentCover(bool);
    #ifndef HAGGAR_HOST
    CCSRBTMoveToBestCover();
    #endif
HG_PRIVATE:
    unsigned int CCSRBTMoveToBestCoverData[0x2];
};

class CCSRBTMoveToClosestCover : public CCSRBTMoveToCover  // size 0xD4, opaque
{
HG_PROTECTED:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL CCSCover FindBestCover(IGripBTInterface *) const;
public:
    #ifndef HAGGAR_HOST
    CCSRBTMoveToClosestCover();
    #endif
};

class CCSRBTMoveToInitialCover : public CCSRBTMoveToCover  // size 0xD4, opaque
{
HG_PROTECTED:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL CCSCover FindBestCover(IGripBTInterface *) const;
};

class CCSRBTMoveToTether : public CCSRBTMoveTo  // size 0xE0, opaque
{
public:
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    void StartMoveToSeat(IGripBTInterface *);
    void UpdateTetherTarget(AActor *);
    bool TetherIsInVehicle();
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
public:
    #ifndef HAGGAR_HOST
    CCSRBTMoveToTether();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
HG_PRIVATE:
    void MoveToLKP(IGripBTInterface *);
    void MoveToRandomLocation(IGripBTInterface *);
    void FindNavigationPoints();
public:
    #ifndef HAGGAR_HOST
    CCSRBTSearch();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
public:
    void SetSelectionAlgo(CCSRBTSelectTarget::EAlgorithm);
    void SetTargetName(FString);
    #ifndef HAGGAR_HOST
    CCSRBTSelectTarget();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
public:
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetChargedShotChance(float);
    #ifndef HAGGAR_HOST
    CCSRBTShoot();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
HG_PRIVATE:
    int GetInCover(CCSTarget *, CCSCover *, CCSAFFactory *, GripAFScheduler *);
    int GetOutCover(CCSTarget *, CCSCover *, CCSAFFactory *, GripAFScheduler *);
    int ExitCover(CCSAFFactory *, GripAFScheduler *);
    int FireBurst(CCSAOFireBurst &, CCSAFFactory *, GripAFScheduler *);
public:
    #ifndef HAGGAR_HOST
    CCSRBTShootFromCover();
    #endif
HG_PRIVATE:
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
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
    HG_VIRTUAL void ExecutePostInternal(IGripBTInterface *, bool);
public:
    void SetFireChance(float);
    void SetChargedShotChance(float);
    void SetFireBurstPerShot(int);
    void SetDelayBetweenBursts(float);
    void SetDirectionFlags(bool, bool, bool, bool);
    CCSTarget *GetSecondaryTarget(IGripBTInterface *);
    #ifndef HAGGAR_HOST
    CCSRBTStrafeTarget();
    #endif
HG_PRIVATE:
    unsigned int CCSRBTStrafeTargetData[0x9];
};

class CCSRBTTargetAngle : public GripRBTBooleanCondition  // size 0x6C, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    void SetActiveZones(bool, bool, bool, bool);
HG_PRIVATE:
    unsigned int CCSRBTTargetAngleData[0x1];
};

class CCSRBTTargetClear : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetInCover : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetKnockedDown : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetRange : public GripRBTNumericCondition<int>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetShootable : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTargetVisible : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceAimedAt : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceBecameAware : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceDamage : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceEvent : public GripRBTNumericCondition<float>  // size 0x7C, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    void SetEventType(EEventType);
    void SetActorClass(UClass *);
    void SetMaxDistance(float);
HG_PRIVATE:
    unsigned int CCSRBTTimeSinceEventData[0x3];
};

class CCSRBTTimeSinceGrenadeStuck : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceStaggered : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceSuccessfulAttack : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceTargetCamoed : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceThreatChanged : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTTimeSinceThreatened : public GripRBTNumericCondition<float>  // size 0x70, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTVisibleToPlayerCamera : public GripRBTBooleanCondition  // size 0x68, opaque
{
public:
    HG_VIRTUAL void FlagUsedBBMembers(GripBlackboard *);
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
};

class CCSRBTWaitInCover : public GripRBTBehavior  // size 0x64, opaque
{
public:
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, bool);
public:
    #ifndef HAGGAR_HOST
    CCSRBTWaitInCover();
    #endif
};

struct CoverLink_eventSetDisabled_Parms  // size 0x4
{
public:
    #ifndef HAGGAR_HOST
    CoverLink_eventSetDisabled_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    unsigned int bNewDisabled;  // 0x0
    #else
    hg::be<unsigned int> bNewDisabled;
    #endif
};

class FOutputDevice  // size 0x10, opaque
{
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~FOutputDevice();)
    HG_VIRTUAL void Serialize(const wchar_t *, EName);
    HG_VIRTUAL void Flush();
    HG_VIRTUAL void TearDown();
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
    #ifndef HAGGAR_HOST
    FOutputDevice(unsigned int);
    #endif
HG_PRIVATE:
    unsigned int FOutputDeviceData[0x3];
};

struct FFrame : public FOutputDevice  // size 0x28
{
public:
    void Step(UObject *, void *const);
    HG_VIRTUAL void Serialize(const wchar_t *, EName);
    int ReadInt();
    float ReadFloat();
    FName ReadName();
    UObject *ReadObject();
    int ReadWord();
    unsigned short ReadCodeSkipCount();
    unsigned short ReadVariableSize(UField **);
    FString GetStackTrace() const;
    #ifndef HAGGAR_HOST
    FFrame(UObject *, UStruct *, int, void *, FFrame *);
    FFrame(UObject *);
    HG_VIRTUAL ~FFrame();
    #endif
    #ifndef HAGGAR_HOST
    UStruct *Node;  // 0x10
    UObject *Object;  // 0x14
    unsigned char *Code;  // 0x18
    unsigned char *Locals;  // 0x1C
    FFrame *PreviousFrame;  // 0x20
    FOutParmRec *OutParms;  // 0x24
    #else
    hg::gptr<UStruct> Node;
    hg::gptr<UObject> Object;
    hg::gptr<unsigned char> Code;
    hg::gptr<unsigned char> Locals;
    hg::gptr<FFrame> PreviousFrame;
    hg::gptr<FOutParmRec> OutParms;
    #endif
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
HG_PRIVATE:
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
    #ifndef HAGGAR_HOST
    static Grip::MemoryHeap *pGlobalHeap;
    #else
    static hg::gptr<Grip::MemoryHeap> (&pGlobalHeap);
    #endif
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
HG_PROTECTED:
    HG_XDK(HG_VIRTUAL ~MemoryHeap();)
public:
    HG_VIRTUAL void CreateArena(unsigned int, Grip::SysAllocPaged *) HG_PURE;
    HG_VIRTUAL void DestroyArena(unsigned int) HG_PURE;
    HG_VIRTUAL bool ArenaIsEmpty(unsigned int) HG_PURE;
    HG_VIRTUAL Grip::MemoryHeap *CreateHeap(const char *, const Grip::MemoryHeap::HeapDesc &) HG_PURE;
    HG_VIRTUAL void SetLimitHandler(Grip::MemoryHeap::LimitHandler *) HG_PURE;
    HG_VIRTUAL void SetLimit(unsigned int) HG_PURE;
    HG_VIRTUAL void AddRef() HG_PURE;
    HG_VIRTUAL void Release() HG_PURE;
    HG_VIRTUAL void *Alloc(unsigned int, const Grip::AllocInfo *) HG_PURE;
    HG_VIRTUAL void *Alloc(unsigned int, unsigned int, const Grip::AllocInfo *) HG_PURE;
    HG_VIRTUAL void *Realloc(void *, unsigned int) HG_PURE;
    HG_VIRTUAL void Free(void *) HG_PURE;
    HG_VIRTUAL void *AllocAutoHeap(const void *, unsigned int, const Grip::AllocInfo *) HG_PURE;
    HG_VIRTUAL void *AllocAutoHeap(const void *, unsigned int, unsigned int, const Grip::AllocInfo *) HG_PURE;
    HG_VIRTUAL Grip::MemoryHeap *GetAllocHeap(const void *) HG_PURE;
    HG_VIRTUAL unsigned int GetUsableSize(const void *) HG_PURE;
    HG_VIRTUAL void *AllocSysDirect(unsigned int) HG_PURE;
    HG_VIRTUAL void FreeSysDirect(void *, unsigned int) HG_PURE;
    HG_VIRTUAL bool GetStats(Grip::StatBag *) HG_PURE;
    HG_VIRTUAL unsigned int GetFootprint() const HG_PURE;
    HG_VIRTUAL unsigned int GetTotalFootprint() const HG_PURE;
    HG_VIRTUAL unsigned int GetUsedSpace() const HG_PURE;
    HG_VIRTUAL unsigned int GetTotalUsedSpace() const HG_PURE;
    HG_VIRTUAL void GetRootStats(Grip::MemoryHeap::RootStats *) HG_PURE;
    HG_VIRTUAL void VisitMem(Grip::Heap::MemVisitor *, unsigned int) HG_PURE;
    HG_VIRTUAL void VisitRootSegments(Grip::Heap::SegVisitor *) HG_PURE;
    HG_VIRTUAL void VisitHeapSegments(Grip::Heap::SegVisitor *) const HG_PURE;
    HG_VIRTUAL void SetTracer(Grip::MemoryHeap::HeapTracer *) HG_PURE;
HG_PROTECTED:
    HG_VIRTUAL void destroyItself() HG_PURE;
    HG_VIRTUAL void ultimateCheck() HG_PURE;
    HG_VIRTUAL void releaseCachedMem() HG_PURE;
    HG_VIRTUAL bool dumpMemoryLeaks() HG_PURE;
    HG_VIRTUAL void checkIntegrity() const HG_PURE;
    HG_VIRTUAL void getUserDebugStats(Grip::MemoryHeap::RootStats *) const HG_PURE;
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
    #ifndef HAGGAR_HOST
HG_PROTECTED:
    MemoryHeap();
public:
    #endif
HG_PRIVATE:
    unsigned int MemoryHeapData[0x18];
};
}

struct GripBTScriptNodeCache_eventCacheAllConditions_Parms  // size 0x4
{
public:
    #ifndef HAGGAR_HOST
    GripBTScriptNodeCache_eventCacheAllConditions_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    UGripBTInterface *BTInterface;  // 0x0
    #else
    hg::gptr<UGripBTInterface> BTInterface;
    #endif
};

struct GripBTScriptNodeCache_eventInitializeAllNodes_Parms  // size 0x1
{
public:
    #ifndef HAGGAR_HOST
    GripBTScriptNodeCache_eventInitializeAllNodes_Parms(EEventParm);
    #endif
};

struct GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms  // size 0x4
{
public:
    #ifndef HAGGAR_HOST
    GripBTScriptNodeCache_eventSurveyUsedBBMembers_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    UGripBlackboard *Blackboard;  // 0x0
    #else
    hg::gptr<UGripBlackboard> Blackboard;
    #endif
};

class GripRBTAllocator : public GripVHeapObject  // size 0x10, opaque
{
public:
    HG_VIRTUAL void *AllocateAlign(unsigned int);
    bool Reserve(unsigned int);
HG_PRIVATE:
    void DeleteMemoryBlock();
public:
    unsigned int GetAlignedSize(unsigned int);
    void DeallocateAlign(void *);
    #ifndef HAGGAR_HOST
    GripRBTAllocator();
    HG_VIRTUAL ~GripRBTAllocator();
    #endif
HG_PRIVATE:
    unsigned int GripRBTAllocatorData[0x3];
};

struct GwNavVehicle_eventExecuteVehicleCommand_Parms  // size 0x1
{
public:
    #ifndef HAGGAR_HOST
    GwNavVehicle_eventExecuteVehicleCommand_Parms(EEventParm);
    #endif
    #ifndef HAGGAR_HOST
    unsigned char HVC;  // 0x0
    #else
    unsigned char HVC;
    #endif
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
    HG_VIRTUAL bool TestPreCondition(IGripBTInterface *);
    void SetDetonationDistance(float);
    void SetArmKamikazeAnimName(FName);
    void SetDetonateKamikazeAnimName(FName);
    void SetBlendTimes(float, float);
HG_PROTECTED:
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecutePreInternal(IGripBTInterface *, bool);
    HG_VIRTUAL GripRBTNode::EBTExecutionResult ExecuteInternal(IGripBTInterface *, GripBTStack *, bool);
public:
    #ifndef HAGGAR_HOST
    HaloRBTKamikaze();
    #endif
HG_PRIVATE:
    unsigned int HaloRBTKamikazeData[0xB];
};

class UComponent : public UObject  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL unsigned int AreNativePropertiesIdenticalTo(UComponent *) const;
HG_PRIVATE:
    UComponent &operator=(const UComponent &);
public:
    static UClass *GetPrivateStaticClassUComponent(const wchar_t *);
    static void InitializePrivateStaticClassUComponent();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void LinkToSourceDefaultObject(UComponent *, UClass *, FName);
    void PreSerialize(FArchive &);
    UComponent *ResolveSourceDefaultObject();
    FName GetInstanceMapName() const;
    unsigned int IsInstanced() const;
    HG_VIRTUAL unsigned int GetNativePropertyValues(TMap<FString,FString,FDefaultSetAllocator> &, unsigned long) const;
    HG_VIRTUAL unsigned int IsPendingKill() const;
    HG_VIRTUAL unsigned int IsAComponent() const;
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UComponent();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UComponentData[0x3];
};

class UActorComponent : public UComponent  // size 0x58, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PROTECTED:
    HG_VIRTUAL void SetParentToWorld(const FMatrix &);
    HG_VIRTUAL void Attach();
    HG_VIRTUAL void UpdateTransform();
    HG_VIRTUAL void Detach(unsigned int);
    HG_VIRTUAL void BeginPlay();
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL void UpdateChildComponents();
public:
    HG_VIRTUAL unsigned int IsValidComponent() const;
    HG_VIRTUAL void InvalidateLightingCache();
    HG_VIRTUAL void InitComponentRBPhys(unsigned int);
    HG_VIRTUAL void SetComponentRBFixed(unsigned int);
    HG_VIRTUAL void TermComponentRBPhys(FRBPhysScene *);
    HG_VIRTUAL unsigned int AllowBeingMarkedPendingKill();
HG_PRIVATE:
    UActorComponent &operator=(const UActorComponent &);
public:
    static UClass *GetPrivateStaticClassUActorComponent(const wchar_t *);
    static void InitializePrivateStaticClassUActorComponent();
    static UClass *StaticClass();
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
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL unsigned int NeedsLoadForClient() const;
    HG_VIRTUAL unsigned int NeedsLoadForServer() const;
    HG_VIRTUAL void PreEditChange(UProperty *);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    void execSetComponentRBFixed(FFrame &, void *const);
    void execSetTickGroup(FFrame &, void *const);
    void SetTickGroup(unsigned char);
    void execForceUpdate(FFrame &, void *const);
    void execDetachFromAny(FFrame &, void *const);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UActorComponent();
public:
    #endif
    typedef UComponent Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UActorComponentData[0x4];
};

class UActorFactory : public UObject  // size 0x68, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    HG_VIRTUAL unsigned int CanCreateActor(FString &, unsigned int);
    HG_VIRTUAL void AutoFillFields(USelection *);
    HG_VIRTUAL void ClearFields();
    HG_VIRTUAL FString GetMenuName();
    HG_VIRTUAL AActor *GetDefaultActor();
    void eventPostCreateActor(AActor *, const USeqAct_ActorFactory *);
HG_PRIVATE:
    UActorFactory &operator=(const UActorFactory &);
public:
    static UClass *GetPrivateStaticClassUActorFactory(const wchar_t *);
    static void InitializePrivateStaticClassUActorFactory();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    static const wchar_t *StaticConfigName();
HG_PROTECTED:
    unsigned int IsEnoughRoomToSpawnPawn(const FVector *const, const USeqAct_ActorFactory *const) const;
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UActorFactory();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UActorFactoryData[0xB];
};

class UActorFactoryAI : public UActorFactory  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UActorFactoryAI &operator=(const UActorFactoryAI &);
public:
    static UClass *GetPrivateStaticClassUActorFactoryAI(const wchar_t *);
    static void InitializePrivateStaticClassUActorFactoryAI();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    HG_VIRTUAL unsigned int CanCreateActor(FString &, unsigned int);
    HG_VIRTUAL AActor *GetDefaultActor();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UActorFactoryAI();
public:
    #endif
    typedef UActorFactory Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UActorFactoryAIData[0xB];
};

class UAnimObject : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL UAnimNode *GetAnimNode();
    HG_VIRTUAL UMorphNodeBase *GetMorphNodeBase();
    HG_VIRTUAL USkelControlBase *GetSkelControlBase();
    HG_VIRTUAL void DrawNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    HG_VIRTUAL void OnPaste();
HG_PRIVATE:
    UAnimObject &operator=(const UAnimObject &);
public:
    static UClass *GetPrivateStaticClassUAnimObject(const wchar_t *);
    static void InitializePrivateStaticClassUAnimObject();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UAnimObject();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UAnimObjectData[0x1];
};

class UAnimNode : public UAnimObject  // size 0xC0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void PlayAnim(unsigned int, float, float);
    HG_VIRTUAL void StopAnim();
    HG_VIRTUAL void ReplayAnim();
    HG_VIRTUAL void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    HG_VIRTUAL void DeferredInitAnim();
    HG_VIRTUAL void CallDeferredInitAnim();
    HG_VIRTUAL void AnimSetsUpdated();
    HG_VIRTUAL void PostAnimNodeInstance(UAnimNode *, TMap<UAnimNode *,UAnimNode *,FDefaultSetAllocator> &);
    HG_VIRTUAL void ResetAnimNodeToSource(UAnimNode *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL unsigned int CanBlendOutFrom();
    HG_VIRTUAL unsigned int CanBlendTo();
    HG_VIRTUAL void BuildParentNodesArray();
    HG_VIRTUAL void BuildTickArray(TArray<UAnimNode *,FDefaultAllocator> &);
    HG_VIRTUAL void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    HG_VIRTUAL unsigned int GetCachedResults(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &, int);
    HG_VIRTUAL unsigned int ShouldSaveCachedResults();
    HG_VIRTUAL unsigned int ShouldKeepCachedResult();
    HG_VIRTUAL void ClearCachedResult();
    HG_VIRTUAL void OnBecomeRelevant();
    HG_VIRTUAL void OnCeaseRelevant();
    HG_VIRTUAL UAnimTree *GetAnimTree();
    HG_VIRTUAL void SetAnim(FName);
    HG_VIRTUAL void SetPosition(float, unsigned int);
    HG_VIRTUAL void DrawAnimNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    HG_VIRTUAL FString GetNodeTitle();
    HG_VIRTUAL FIntPoint GetConnectionLocation(int, int);
    HG_VIRTUAL int GetNumSliders() const;
    HG_VIRTUAL ESliderType GetSliderType(int) const;
    HG_VIRTUAL float GetSliderPosition(int, int);
    HG_VIRTUAL void HandleSliderMove(int, int, float);
    HG_VIRTUAL FString GetSliderDrawValue(int);
    HG_VIRTUAL void GetNodesInternal(TArray<UAnimNode *,FDefaultAllocator> &);
    HG_VIRTUAL UAnimNodeSlot *GetAnimNodeSlot();
    HG_VIRTUAL UAnimNodeAimOffset *GetAnimNodeAimOffset();
    HG_VIRTUAL UAnimNodeSequence *GetAnimNodeSequence();
    UAnimNode *FindAnimNode(FName);
    void execFindAnimNode(FFrame &, void *const);
    void execPlayAnim(FFrame &, void *const);
    void execStopAnim(FFrame &, void *const);
    void execReplayAnim(FFrame &, void *const);
    void eventOnCeaseRelevant();
    void eventOnBecomeRelevant();
    void eventOnInit();
HG_PRIVATE:
    UAnimNode &operator=(const UAnimNode &);
public:
    static UClass *GetPrivateStaticClassUAnimNode(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNode();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL UAnimNode *GetAnimNode();
    void GetNodes(TArray<UAnimNode *,FDefaultAllocator> &, bool);
    void GetNodesByClass(TArray<UAnimNode *,FDefaultAllocator> &, UClass *);
    void GetAnimSeqNodes(TArray<UAnimNodeSequence *,FDefaultAllocator> &, FName);
    void SaveCachedResults(const TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const FBoneAtom &, int, const TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &, int);
    unsigned int WereAllParentsTicked() const;
    unsigned int IsChildOf(UAnimNode *);
    unsigned int IsChildOf_Internal(UAnimNode *);
    HG_VIRTUAL unsigned int NeedsLoadForClient() const;
    HG_VIRTUAL unsigned int NeedsLoadForServer() const;
    HG_VIRTUAL void DrawNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    HG_VIRTUAL void OnPaste();
    static void FillWithRefPose(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, const TArray<FMeshBone,FDefaultAllocator> &);
    static void FillWithRefPose(TArray<FBoneAtom,FDefaultAllocator> &, const TArray<unsigned char,FDefaultAllocator> &, const TArray<FMeshBone,FDefaultAllocator> &);
    static void EnsureParentsPresent(TArray<unsigned char,FDefaultAllocator> &, USkeletalMesh *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UAnimNode();
public:
    #endif
    typedef UAnimObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    static unsigned int bNodeSearching;
    static int CurrentSearchTag;
    static TArray<UAnimNode *,FDefaultAllocator> NodesRequiringCacheClear;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static hg::be<unsigned int> (&bNodeSearching);
    static hg::be<int> (&CurrentSearchTag);
    static TArray<UAnimNode *,FDefaultAllocator> (&NodesRequiringCacheClear);
    #endif
HG_PRIVATE:
    unsigned int UAnimNodeData[0x20];
};

class UAnimNodeBlendBase : public UAnimNode  // size 0xE0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void GetChildBoneAtoms(int, TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    HG_VIRTUAL int Extend2DSlider(FCanvas *, const FIntPoint &, int, unsigned int, int);
    HG_VIRTUAL void OnChildAnimEnd(UAnimNodeSequence *, float, float);
    HG_VIRTUAL void OnAddChild(int);
    HG_VIRTUAL void OnRemoveChild(int);
    HG_VIRTUAL void OnChildAnimChange(int);
    HG_VIRTUAL void RenameChildConnectors();
    HG_VIRTUAL int BlendCurveWeights(const TArray<TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> >,TMemStackAllocator<GMainThreadMemStack,8> > &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
HG_PROTECTED:
    HG_VIRTUAL void UpdateChildWeight(int);
public:
    HG_VIRTUAL void PlayAnim(unsigned int, float, float);
    HG_VIRTUAL void StopAnim();
    HG_VIRTUAL void ReplayAnim();
HG_PRIVATE:
    UAnimNodeBlendBase &operator=(const UAnimNodeBlendBase &);
public:
    static UClass *GetPrivateStaticClassUAnimNodeBlendBase(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNodeBlendBase();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void CallDeferredInitAnim();
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL void BuildParentNodesArray();
    HG_VIRTUAL void BuildTickArray(TArray<UAnimNode *,FDefaultAllocator> &);
    float GetBlendWeight(float);
    void SetBlendTypeWeights();
    HG_VIRTUAL void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    void GetMirroredBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, int, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    HG_VIRTUAL void DrawAnimNode(FCanvas *, const TArray<UAnimObject *,FDefaultAllocator> &, unsigned int);
    HG_VIRTUAL FString GetNodeTitle();
    HG_VIRTUAL FIntPoint GetConnectionLocation(int, int);
    float GetChildWeightTotal();
    HG_VIRTUAL void GetNodesInternal(TArray<UAnimNode *,FDefaultAllocator> &);
    HG_VIRTUAL void OnPaste();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UAnimNodeBlendBase();
public:
    #endif
    typedef UAnimNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UAnimNodeBlendBaseData[0x8];
};

class UAnimNodeBlendList : public UAnimNodeBlendBase  // size 0x100, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void SetActiveChild(int, float);
    void execSetActiveChild(FFrame &, void *const);
HG_PRIVATE:
    UAnimNodeBlendList &operator=(const UAnimNodeBlendList &);
public:
    static UClass *GetPrivateStaticClassUAnimNodeBlendList(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNodeBlendList();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    HG_VIRTUAL void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    HG_VIRTUAL void ResetAnimNodeToSource(UAnimNode *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL int GetNumSliders() const;
    HG_VIRTUAL float GetSliderPosition(int, int);
    HG_VIRTUAL void HandleSliderMove(int, int, float);
    HG_VIRTUAL FString GetSliderDrawValue(int);
    HG_VIRTUAL void OnAddChild(int);
    HG_VIRTUAL void OnRemoveChild(int);
    HG_VIRTUAL void OnPaste();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UAnimNodeBlendList();
public:
    #endif
    typedef UAnimNodeBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UAnimNodeBlendListData[0x8];
};

class UAnimNodeSlot : public UAnimNodeBlendBase  // size 0x100, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void MAT_SetAnimPosition(int, FName, float, unsigned int, unsigned int, unsigned int);
    HG_VIRTUAL void MAT_SetAnimWeights(const FAnimSlotInfo &);
    HG_VIRTUAL void SelectedActiveSequence(UAnimNodeSequence *);
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
HG_PRIVATE:
    UAnimNodeSlot &operator=(const UAnimNodeSlot &);
public:
    static UClass *GetPrivateStaticClassUAnimNodeSlot(const wchar_t *);
    static void InitializePrivateStaticClassUAnimNodeSlot();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    HG_VIRTUAL void RenameChildConnectors();
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    HG_VIRTUAL void OnAddChild(int);
    HG_VIRTUAL void OnRemoveChild(int);
    HG_VIRTUAL void OnChildAnimChange(int);
    HG_VIRTUAL void OnChildAnimEnd(UAnimNodeSequence *, float, float);
    HG_VIRTUAL int GetNumSliders() const;
    int FindBestChildToPlayAnim(FName, unsigned int);
    void SetActiveChild(int, float);
    void UpdateWeightsForAdditiveAnimations();
    HG_VIRTUAL void OnPaste();
    HG_VIRTUAL UAnimNodeSlot *GetAnimNodeSlot();
    static void CleanUpSlotNodeSequencePool();
    static void FlushReleasedSequenceNodes(const USkeletalMeshComponent *);
    static void ReleaseSequenceNodes(const USkeletalMeshComponent *);
    static void PrintSlotNodeSequencePool();
HG_PROTECTED:
    HG_VIRTUAL void UpdateChildWeight(int);
    void EnsureChildExists(int, unsigned int);
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UAnimNodeSlot();
public:
    #endif
    typedef UAnimNodeBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UAnimNodeSlotData[0x8];
};

class UGripAFActionHandle : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL int CreateAction(GripAFFactory *);
HG_PRIVATE:
    UGripAFActionHandle &operator=(const UGripAFActionHandle &);
public:
    static UClass *GetPrivateStaticClassUGripAFActionHandle(const wchar_t *);
    static void InitializePrivateStaticClassUGripAFActionHandle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripAFActionHandle();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripAFActionHandleData[0x1];
};

class UCCSAFEncircleTarget : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFEncircleTarget &operator=(const UCCSAFEncircleTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSAFEncircleTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFEncircleTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFEncircleTarget();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFEncircleTargetData[0x1];
};

class UCCSAFEnterCover : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFEnterCover &operator=(const UCCSAFEnterCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFEnterCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFEnterCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFEnterCover();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFEnterCoverData[0x2];
};

class UCCSAFExitCover : public UGripAFActionHandle  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFExitCover &operator=(const UCCSAFExitCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFExitCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFExitCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFExitCover();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSAFFireBurst : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFFireBurst &operator=(const UCCSAFFireBurst &);
public:
    static UClass *GetPrivateStaticClassUCCSAFFireBurst(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFFireBurst();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFFireBurst();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFFireBurstData[0x1];
};

class UCCSAFFlee : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFFlee &operator=(const UCCSAFFlee &);
public:
    static UClass *GetPrivateStaticClassUCCSAFFlee(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFFlee();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFFlee();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFFleeData[0x1];
};

class UCCSAFGetInCover : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFGetInCover &operator=(const UCCSAFGetInCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFGetInCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFGetInCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFGetInCover();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFGetInCoverData[0x2];
};

class UCCSAFGetOutCover : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFGetOutCover &operator=(const UCCSAFGetOutCover &);
public:
    static UClass *GetPrivateStaticClassUCCSAFGetOutCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFGetOutCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFGetOutCover();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFGetOutCoverData[0x2];
};

class UCCSAFIdle : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFIdle &operator=(const UCCSAFIdle &);
public:
    static UClass *GetPrivateStaticClassUCCSAFIdle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFIdle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFIdle();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFIdleData[0x1];
};

class UCCSAFMoveTo : public UGripAFActionHandle  // size 0x50, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFMoveTo &operator=(const UCCSAFMoveTo &);
public:
    static UClass *GetPrivateStaticClassUCCSAFMoveTo(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFMoveTo();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFMoveTo();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFMoveToData[0x4];
};

class UCCSAFMoveToActor : public UGripAFActionHandle  // size 0x48, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFMoveToActor &operator=(const UCCSAFMoveToActor &);
public:
    static UClass *GetPrivateStaticClassUCCSAFMoveToActor(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFMoveToActor();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFMoveToActor();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFMoveToActorData[0x2];
};

class UCCSAFOrientToward : public UGripAFActionHandle  // size 0x50, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFOrientToward &operator=(const UCCSAFOrientToward &);
public:
    static UClass *GetPrivateStaticClassUCCSAFOrientToward(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFOrientToward();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFOrientToward();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFOrientTowardData[0x4];
};

class UCCSAFStrafeTarget : public UGripAFActionHandle  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFStrafeTarget &operator=(const UCCSAFStrafeTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSAFStrafeTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFStrafeTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFStrafeTarget();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFStrafeTargetData[0x1];
};

class UCCSAFStrafeTo : public UGripAFActionHandle  // size 0x54, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSAFStrafeTo &operator=(const UCCSAFStrafeTo &);
public:
    static UClass *GetPrivateStaticClassUCCSAFStrafeTo(const wchar_t *);
    static void InitializePrivateStaticClassUCCSAFStrafeTo();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL int CreateAction(GripAFFactory *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSAFStrafeTo();
public:
    #endif
    typedef UGripAFActionHandle Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSAFStrafeToData[0x5];
};

class UCCSATAnimNodeSlot : public UAnimNodeSlot  // size 0x100, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void ActivateChild(int, float);
    void execActivateChild(FFrame &, void *const);
    float eventActivateInput(FName, float, float, float, unsigned int, unsigned int, float);
HG_PRIVATE:
    UCCSATAnimNodeSlot &operator=(const UCCSATAnimNodeSlot &);
public:
    static UClass *GetPrivateStaticClassUCCSATAnimNodeSlot(const wchar_t *);
    static void InitializePrivateStaticClassUCCSATAnimNodeSlot();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSATAnimNodeSlot();
    UCCSATAnimNodeSlot();
public:
    #endif
    typedef UAnimNodeSlot Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSATBlendListBase : public UAnimNodeBlendList  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSATBlendListBase &operator=(const UCCSATBlendListBase &);
public:
    static UClass *GetPrivateStaticClassUCCSATBlendListBase(const wchar_t *);
    static void InitializePrivateStaticClassUCCSATBlendListBase();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSATBlendListBase();
    UCCSATBlendListBase();
public:
    #endif
    typedef UAnimNodeBlendList Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSATBlendListBaseData[0x4];
};

class UGwNavActorFactoryAI : public UActorFactoryAI  // size 0xA0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGwNavActorFactoryAI &operator=(const UGwNavActorFactoryAI &);
public:
    static UClass *GetPrivateStaticClassUGwNavActorFactoryAI(const wchar_t *);
    static void InitializePrivateStaticClassUGwNavActorFactoryAI();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGwNavActorFactoryAI();
public:
    #endif
    typedef UActorFactoryAI Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGwNavActorFactoryAIData[0x3];
};

class UCCSActorFactory : public UGwNavActorFactoryAI  // size 0xD8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSActorFactory &operator=(const UCCSActorFactory &);
public:
    static UClass *GetPrivateStaticClassUCCSActorFactory(const wchar_t *);
    static void InitializePrivateStaticClassUCCSActorFactory();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL AActor *CreateActor(const FVector *const, const FRotator *const, const USeqAct_ActorFactory *const);
    HG_VIRTUAL unsigned int CanCreateActor(FString &, unsigned int);
    HG_VIRTUAL AActor *GetDefaultActor();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSActorFactory();
public:
    #endif
    typedef UGwNavActorFactoryAI Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSActorFactoryData[0xE];
};

class UGripBTObject : public UObject  // size 0x44, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL UGripBTNode *GetNode();
    HG_VIRTUAL void DrawNode(FCanvas *, unsigned int, unsigned int, unsigned int);
HG_PRIVATE:
    UGripBTObject &operator=(const UGripBTObject &);
public:
    static UClass *GetPrivateStaticClassUGripBTObject(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTObject();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTObject();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTObjectData[0x2];
};

class UGripBTNode : public UGripBTObject  // size 0x88, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    HG_VIRTUAL FString GetNodeTitle();
HG_PRIVATE:
    HG_VIRTUAL void GetNodesInternal(TArray<UGripBTNode *,FDefaultAllocator> &);
    UGripBTNode &operator=(const UGripBTNode &);
public:
    static UClass *GetPrivateStaticClassUGripBTNode(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTNode();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL UGripBTNode *GetNode();
    void GetNodes(TArray<UGripBTNode *,FDefaultAllocator> &);
    UGripBTNode *GetGripBTChild(const int) const;
    unsigned int IsChildOf(UGripBTNode *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTNode();
public:
    #endif
    typedef UGripBTObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTNodeData[0x11];
};

class UCCSBTEncircleTarget : public UGripBTNode  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTEncircleTarget &operator=(const UCCSBTEncircleTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEncircleTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEncircleTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTEncircleTarget();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTEncircleTargetData[0x4];
};

class UGripBTBooleanCondition : public UGripBTNode  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTBooleanCondition &operator=(const UGripBTBooleanCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTBooleanCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTBooleanCondition();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    HG_VIRTUAL FString GetNodeTitle();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTBooleanCondition();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTBooleanConditionData[0x1];
};

class UCCSBTEnemyAware : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTEnemyAware &operator=(const UCCSBTEnemyAware &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEnemyAware(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEnemyAware();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTEnemyAware();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UGripBTNumericCondition : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTNumericCondition &operator=(const UGripBTNumericCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTNumericCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTNumericCondition();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    HG_VIRTUAL FString GetNodeTitle();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTNumericCondition();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTNumericConditionData[0x3];
};

class UCCSBTEnemyClosestRange : public UGripBTNumericCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTEnemyClosestRange &operator=(const UCCSBTEnemyClosestRange &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEnemyClosestRange(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEnemyClosestRange();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTEnemyClosestRange();
public:
    #endif
    typedef UGripBTNumericCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UGripBTFloatCondition : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTFloatCondition &operator=(const UGripBTFloatCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTFloatCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTFloatCondition();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    HG_VIRTUAL FString GetNodeTitle();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTFloatCondition();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTFloatConditionData[0x3];
};

class UCCSBTEnemyLowestLKPAge : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTEnemyLowestLKPAge &operator=(const UCCSBTEnemyLowestLKPAge &);
public:
    static UClass *GetPrivateStaticClassUCCSBTEnemyLowestLKPAge(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTEnemyLowestLKPAge();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTEnemyLowestLKPAge();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTFlee : public UGripBTNode  // size 0x88, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTFlee &operator=(const UCCSBTFlee &);
public:
    static UClass *GetPrivateStaticClassUCCSBTFlee(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTFlee();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTFlee();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTIdle : public UGripBTNode  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTIdle &operator=(const UCCSBTIdle &);
public:
    static UClass *GetPrivateStaticClassUCCSBTIdle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTIdle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTIdle();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTIdleData[0x1];
};

class UCCSBTMoveTo : public UGripBTNode  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveTo &operator=(const UCCSBTMoveTo &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveTo(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveTo();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveTo();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTMoveToData[0xC];
};

class UCCSBTMoveIntoCover : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveIntoCover &operator=(const UCCSBTMoveIntoCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveIntoCover();
    UCCSBTMoveIntoCover();
public:
    #endif
    typedef UCCSBTMoveTo Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTMoveIntoBestCover : public UCCSBTMoveIntoCover  // size 0xC0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveIntoBestCover &operator=(const UCCSBTMoveIntoBestCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoBestCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoBestCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveIntoBestCover();
public:
    #endif
    typedef UCCSBTMoveIntoCover Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTMoveIntoBestCoverData[0x2];
};

class UCCSBTMoveIntoClosestCover : public UCCSBTMoveIntoCover  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveIntoClosestCover &operator=(const UCCSBTMoveIntoClosestCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoClosestCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoClosestCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveIntoClosestCover();
public:
    #endif
    typedef UCCSBTMoveIntoCover Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTMoveIntoInitialCover : public UCCSBTMoveIntoCover  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveIntoInitialCover &operator=(const UCCSBTMoveIntoInitialCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveIntoInitialCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveIntoInitialCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveIntoInitialCover();
public:
    #endif
    typedef UCCSBTMoveIntoCover Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTMoveToActor : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveToActor &operator=(const UCCSBTMoveToActor &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToActor(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToActor();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveToActor();
public:
    #endif
    typedef UCCSBTMoveTo Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTMoveToTarget : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveToTarget &operator=(const UCCSBTMoveToTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveToTarget();
public:
    #endif
    typedef UCCSBTMoveTo Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTMoveToTether : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveToTether &operator=(const UCCSBTMoveToTether &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToTether(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToTether();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveToTether();
public:
    #endif
    typedef UCCSBTMoveTo Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTMoveToVehicle : public UCCSBTMoveToTarget  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTMoveToVehicle &operator=(const UCCSBTMoveToVehicle &);
public:
    static UClass *GetPrivateStaticClassUCCSBTMoveToVehicle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTMoveToVehicle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTMoveToVehicle();
public:
    #endif
    typedef UCCSBTMoveToTarget Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTOrientTowardTarget : public UGripBTNode  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTOrientTowardTarget &operator=(const UCCSBTOrientTowardTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTOrientTowardTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTOrientTowardTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTOrientTowardTarget();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
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
HG_PRIVATE:
    UGripBTScriptNode &operator=(const UGripBTScriptNode &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptNode(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptNode();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL FString GetNodeTitle();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTScriptNode();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTScriptNodeData[0x3];
};

class UGripBTScriptBehavior : public UGripBTScriptNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTScriptBehavior &operator=(const UGripBTScriptBehavior &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptBehavior(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptBehavior();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTScriptBehavior();
public:
    #endif
    typedef UGripBTScriptNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTScriptBehavior : public UGripBTScriptBehavior  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTScriptBehavior &operator=(const UCCSBTScriptBehavior &);
public:
    static UClass *GetPrivateStaticClassUCCSBTScriptBehavior(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTScriptBehavior();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTScriptBehavior();
    UCCSBTScriptBehavior();
public:
    #endif
    typedef UGripBTScriptBehavior Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTScriptBehaviorData[0x1];
};

class UGripBTScriptCondition : public UGripBTScriptNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTScriptCondition &operator=(const UGripBTScriptCondition &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptCondition(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptCondition();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTScriptCondition();
public:
    #endif
    typedef UGripBTScriptNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTScriptCondition : public UGripBTScriptCondition  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTScriptCondition &operator=(const UCCSBTScriptCondition &);
public:
    static UClass *GetPrivateStaticClassUCCSBTScriptCondition(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTScriptCondition();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTScriptCondition();
    UCCSBTScriptCondition();
public:
    #endif
    typedef UGripBTScriptCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTScriptConditionData[0x1];
};

class UCCSBTScriptCover : public UCCSBTScriptBehavior  // size 0xCC, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTScriptCover &operator=(const UCCSBTScriptCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTScriptCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTScriptCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTScriptCover();
public:
    #endif
    typedef UCCSBTScriptBehavior Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTScriptCoverData[0xD];
};

class UCCSBTSearch : public UCCSBTMoveTo  // size 0xB8, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTSearch &operator=(const UCCSBTSearch &);
public:
    static UClass *GetPrivateStaticClassUCCSBTSearch(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTSearch();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTSearch();
public:
    #endif
    typedef UCCSBTMoveTo Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTSelectTarget : public UGripBTNode  // size 0x98, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTSelectTarget &operator=(const UCCSBTSelectTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTSelectTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTSelectTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    HG_VIRTUAL FString GetNodeTitle();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTSelectTarget();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTSelectTargetData[0x4];
};

class UCCSBTShoot : public UGripBTNode  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTShoot &operator=(const UCCSBTShoot &);
public:
    static UClass *GetPrivateStaticClassUCCSBTShoot(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTShoot();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTShoot();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTShootData[0x3];
};

class UCCSBTShootFromCover : public UGripBTNode  // size 0x90, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTShootFromCover &operator=(const UCCSBTShootFromCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTShootFromCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTShootFromCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTShootFromCover();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTShootFromCoverData[0x2];
};

class UCCSBTStrafeTarget : public UGripBTNode  // size 0x9C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTStrafeTarget &operator=(const UCCSBTStrafeTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSBTStrafeTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTStrafeTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTStrafeTarget();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTStrafeTargetData[0x5];
};

class UCCSBTTargetAngle : public UGripBTBooleanCondition  // size 0x90, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetAngle &operator=(const UCCSBTTargetAngle &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetAngle(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetAngle();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetAngle();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTTargetAngleData[0x1];
};

class UCCSBTTargetClear : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetClear &operator=(const UCCSBTTargetClear &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetClear(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetClear();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetClear();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTargetInCover : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetInCover &operator=(const UCCSBTTargetInCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetInCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetInCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetInCover();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTargetKnockedDown : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetKnockedDown &operator=(const UCCSBTTargetKnockedDown &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetKnockedDown(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetKnockedDown();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetKnockedDown();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTargetRange : public UGripBTNumericCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetRange &operator=(const UCCSBTTargetRange &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetRange(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetRange();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetRange();
public:
    #endif
    typedef UGripBTNumericCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTargetShootable : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetShootable &operator=(const UCCSBTTargetShootable &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetShootable(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetShootable();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetShootable();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTargetVisible : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTargetVisible &operator=(const UCCSBTTargetVisible &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTargetVisible(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTargetVisible();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTargetVisible();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceAimedAt : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceAimedAt &operator=(const UCCSBTTimeSinceAimedAt &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceAimedAt(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceAimedAt();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceAimedAt();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceBecameAware : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceBecameAware &operator=(const UCCSBTTimeSinceBecameAware &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceBecameAware(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceBecameAware();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceBecameAware();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceDamage : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceDamage &operator=(const UCCSBTTimeSinceDamage &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceDamage(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceDamage();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceDamage();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceEvent : public UGripBTFloatCondition  // size 0xA0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceEvent &operator=(const UCCSBTTimeSinceEvent &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceEvent(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceEvent();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL BTMenuType GetMenuType();
    HG_VIRTUAL FString GetNodeTitle();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceEvent();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSBTTimeSinceEventData[0x3];
};

class UCCSBTTimeSinceGrenadeStuck : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceGrenadeStuck &operator=(const UCCSBTTimeSinceGrenadeStuck &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceGrenadeStuck(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceGrenadeStuck();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceGrenadeStuck();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceStaggered : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceStaggered &operator=(const UCCSBTTimeSinceStaggered &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceStaggered(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceStaggered();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceStaggered();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceSuccessfulAttack : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceSuccessfulAttack &operator=(const UCCSBTTimeSinceSuccessfulAttack &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceSuccessfulAttack(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceSuccessfulAttack();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceSuccessfulAttack();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceTargetCamoed : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceTargetCamoed &operator=(const UCCSBTTimeSinceTargetCamoed &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceTargetCamoed(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceTargetCamoed();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceTargetCamoed();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceThreatChanged : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceThreatChanged &operator=(const UCCSBTTimeSinceThreatChanged &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceThreatChanged(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceThreatChanged();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceThreatChanged();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTTimeSinceThreatened : public UGripBTFloatCondition  // size 0x94, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTimeSinceThreatened &operator=(const UCCSBTTimeSinceThreatened &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTimeSinceThreatened(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTimeSinceThreatened();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTimeSinceThreatened();
public:
    #endif
    typedef UGripBTFloatCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTVisibleToPlayerCamera : public UGripBTBooleanCondition  // size 0x8C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTVisibleToPlayerCamera &operator=(const UCCSBTVisibleToPlayerCamera &);
public:
    static UClass *GetPrivateStaticClassUCCSBTVisibleToPlayerCamera(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTVisibleToPlayerCamera();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTVisibleToPlayerCamera();
public:
    #endif
    typedef UGripBTBooleanCondition Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSBTWaitInCover : public UGripBTNode  // size 0x88, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTWaitInCover &operator=(const UCCSBTWaitInCover &);
public:
    static UClass *GetPrivateStaticClassUCCSBTWaitInCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTWaitInCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTWaitInCover();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UGripBlackboard : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL unsigned int ContainState(const FString &) const;
    HG_VIRTUAL void FlagStatesAsUsed();
    void execContainState(FFrame &, void *const);
    void execFlagStatesAsUsed(FFrame &, void *const);
HG_PRIVATE:
    UGripBlackboard &operator=(const UGripBlackboard &);
public:
    static UClass *GetPrivateStaticClassUGripBlackboard(const wchar_t *);
    static void InitializePrivateStaticClassUGripBlackboard();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void Initialize(GripBlackboard *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBlackboard();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBlackboardData[0x1];
};

class UCCSBlackboard : public UGripBlackboard  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL int GetHealth() const;
    HG_VIRTUAL void SetHealth(int);
    HG_VIRTUAL void GetCovers(TArray<FCCSCoverData,FDefaultAllocator> &) const;
    HG_VIRTUAL FCCSTargetData GetCurrentTarget() const;
    HG_VIRTUAL void SetCurrentTether(AActor *);
    HG_VIRTUAL FVector GetCurrentTether() const;
    HG_VIRTUAL void GetTargets(TArray<FCCSTargetData,FDefaultAllocator> &) const;
    HG_VIRTUAL FCCSMoveCmdData GetMoveCommand() const;
    HG_VIRTUAL void ClearMoveCommand();
    HG_VIRTUAL void FlagThreatLocationAsUsed();
    HG_VIRTUAL void FlagThreatDirectionAsUsed();
    HG_VIRTUAL FVector GetThreatLocation();
    HG_VIRTUAL FVector GetThreatDirection();
    HG_VIRTUAL unsigned char GetThreatType();
    HG_VIRTUAL void SetHeatGenerated(float);
    HG_VIRTUAL float GetHeatGenerated() const;
    HG_VIRTUAL void FlagHeatGeneratedAsUsed();
    HG_VIRTUAL FCCSTargetData GetClosestVisibleEnemy() const;
    HG_VIRTUAL void FlagHealthAsUsed();
    HG_VIRTUAL void FlagCoversAsUsed();
    HG_VIRTUAL void FlagTargetsAsUsed();
    HG_VIRTUAL void FlagTetherAsUsed();
    HG_VIRTUAL void FlagClosestVisibleEnemyAsUsed();
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
HG_PRIVATE:
    UCCSBlackboard &operator=(const UCCSBlackboard &);
public:
    static UClass *GetPrivateStaticClassUCCSBlackboard(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBlackboard();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBlackboard();
    UCCSBlackboard();
public:
    #endif
    typedef UGripBlackboard Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSCover : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSCover &operator=(const UCCSCover &);
public:
    static UClass *GetPrivateStaticClassUCCSCover(const wchar_t *);
    static void InitializePrivateStaticClassUCCSCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSCover();
    UCCSCover();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UInterface : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UInterface &operator=(const UInterface &);
public:
    static UClass *GetPrivateStaticClassUInterface(const wchar_t *);
    static void InitializePrivateStaticClassUInterface();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UInterface();
    UInterface();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSPawn : public UInterface  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSPawn &operator=(const UCCSPawn &);
public:
    static UClass *GetPrivateStaticClassUCCSPawn(const wchar_t *);
    static void InitializePrivateStaticClassUCCSPawn();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSPawn();
    UCCSPawn();
public:
    #endif
    typedef UInterface Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSSystemConfig : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSSystemConfig &operator=(const UCCSSystemConfig &);
public:
    static UClass *GetPrivateStaticClassUCCSSystemConfig(const wchar_t *);
    static void InitializePrivateStaticClassUCCSSystemConfig();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSSystemConfig();
    UCCSSystemConfig();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UCCSTarget : public UObject  // size 0x3C, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSTarget &operator=(const UCCSTarget &);
public:
    static UClass *GetPrivateStaticClassUCCSTarget(const wchar_t *);
    static void InitializePrivateStaticClassUCCSTarget();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSTarget();
    UCCSTarget();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UPrimitiveComponent : public UActorComponent  // size 0x1E0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void GenerateDecalRenderData(FDecalState *, TArray<FDecalRenderData *,FDefaultAllocator> &) const;
    HG_VIRTUAL unsigned int ShouldRenderSelected() const;
    HG_VIRTUAL unsigned int UsesOnlyUnlitMaterials() const;
    HG_VIRTUAL unsigned int GetLightMapResolution(int &, int &) const;
    HG_VIRTUAL int GetStaticLightMapResolution() const;
    HG_VIRTUAL void GetLightAndShadowMapMemoryUsage(int &, int &) const;
    HG_VIRTUAL void UpdateBounds();
    HG_VIRTUAL void GetStaticLightingInfo(FStaticLightingPrimitiveInfo &, const TArray<ULightComponent *,FDefaultAllocator> &, const FLightingBuildOptions &);
    HG_VIRTUAL ELightMapInteractionType GetStaticLightingType() const;
    HG_VIRTUAL void GetStaticTriangles(FPrimitiveTriangleDefinitionInterface *) const;
    HG_VIRTUAL void GetStreamingTextureInfo(TArray<FStreamingTexturePrimitiveInfo,FDefaultAllocator> &) const;
    HG_VIRTUAL unsigned char GetStaticDepthPriorityGroup() const;
    HG_VIRTUAL void GetUsedMaterials(TArray<UMaterialInterface *,FDefaultAllocator> &) const;
    HG_VIRTUAL unsigned int PointCheck(FCheckResult &, const FVector &, const FVector &, unsigned long);
    HG_VIRTUAL unsigned int LineCheck(FCheckResult &, const FVector &, const FVector &, const FVector &, unsigned long);
    HG_VIRTUAL unsigned int IsAlwaysStatic();
    HG_VIRTUAL URB_BodySetup *GetRBBodySetup();
    HG_VIRTUAL FKCachedConvexData *GetCachedPhysConvexData(const FVector &);
    HG_VIRTUAL FKCachedConvexData *GetBoneCachedPhysConvexData(const FVector &, const FName &);
    HG_VIRTUAL void AddImpulse(FVector, FVector, FName, unsigned int);
    HG_VIRTUAL void AddRadialImpulse(const FVector &, float, float, unsigned char, unsigned int);
    HG_VIRTUAL void AddRadialForce(const FVector &, float, float, unsigned char);
    HG_VIRTUAL void AddForceField(FForceApplicator *, const FBox &, unsigned int, unsigned int);
    HG_VIRTUAL void SetRBLinearVelocity(const FVector &, unsigned int);
    HG_VIRTUAL void SetRBAngularVelocity(const FVector &, unsigned int);
    HG_VIRTUAL void RetardRBLinearVelocity(const FVector &, float);
    HG_VIRTUAL void SetRBPosition(const FVector &, FName);
    HG_VIRTUAL void SetRBRotation(const FRotator &, FName);
    HG_VIRTUAL void WakeRigidBody(FName);
    HG_VIRTUAL void PutRigidBodyToSleep(FName);
    HG_VIRTUAL unsigned int RigidBodyIsAwake(FName);
    HG_VIRTUAL void SetBlockRigidBody(unsigned int);
    HG_VIRTUAL void SetNotifyRigidBodyCollision(unsigned int);
    HG_VIRTUAL void SetRBDominanceGroup(unsigned char);
    HG_VIRTUAL void SetPhysMaterialOverride(UPhysicalMaterial *);
    HG_VIRTUAL URB_BodyInstance *GetRootBodyInstance();
    HG_VIRTUAL void UpdateRBKinematicData();
    HG_VIRTUAL unsigned char ClosestPointOnComponentInternal(IGJKHelper *, FVector &, FVector &);
    HG_VIRTUAL unsigned char ClosestPointOnComponentToComponent(UPrimitiveComponent *&, FVector &, FVector &);
    HG_VIRTUAL void SetTransformedToWorld();
    HG_VIRTUAL unsigned int IsPrimitiveInstanced() const;
    HG_VIRTUAL int GetInstanceCount() const;
    HG_VIRTUAL const FMatrix GetInstanceLocalToWorld(int) const;
    HG_VIRTUAL void OverrideTraceFlagsForNonCollisionComponentChecks(unsigned long &);
    HG_VIRTUAL int GetNumElements() const;
    HG_VIRTUAL UMaterialInterface *GetElementMaterial(int) const;
    HG_VIRTUAL void SetElementMaterial(int, UMaterialInterface *);
    HG_VIRTUAL int GetActorMetrics(EActorMetricsType);
    HG_VIRTUAL NxActor *GetNxActor(FName);
    HG_VIRTUAL NxActor *GetIndexedNxActor(int);
    HG_VIRTUAL void GetAllNxActors(TArray<NxActor *,FDefaultAllocator> &);
    HG_VIRTUAL FPrimitiveSceneProxy *CreateSceneProxy();
    HG_VIRTUAL unsigned int ShouldRecreateProxyOnUpdateTransform() const;
HG_PROTECTED:
    HG_VIRTUAL unsigned int AllowDecalRemovalOnDetach() const;
    HG_VIRTUAL unsigned int AllowDecalAutomaticReAttach() const;
    HG_VIRTUAL void UpdatePhysicsToRBChannels();
public:
    HG_VIRTUAL unsigned int SupportsDecalRendering() const;
    HG_VIRTUAL unsigned int HasMotionBlurVelocityMeshes() const;
    HG_VIRTUAL void SetOwnerNoSee(unsigned int);
    HG_VIRTUAL void SetOnlyOwnerSee(unsigned int);
    HG_VIRTUAL void SetIgnoreOwnerHidden(unsigned int);
    HG_VIRTUAL unsigned int ShouldComponentAddToScene() const;
    HG_VIRTUAL void SetHiddenGame(unsigned int);
    HG_VIRTUAL void SetHiddenEditor(unsigned int);
    HG_VIRTUAL void SetShadowParent(UPrimitiveComponent *);
    HG_VIRTUAL void SetLightEnvironment(ULightEnvironmentComponent *);
    HG_VIRTUAL void SetCullDistance(float);
    HG_VIRTUAL void SetLightingChannels(FLightingChannelContainer);
    HG_VIRTUAL void SetDepthPriorityGroup(ESceneDepthPriorityGroup);
    HG_VIRTUAL void SetViewOwnerDepthPriorityGroup(unsigned int, ESceneDepthPriorityGroup);
    HG_VIRTUAL float GetEmissiveBoost(int) const;
    HG_VIRTUAL float GetDiffuseBoost(int) const;
    HG_VIRTUAL float GetSpecularBoost(int) const;
    HG_VIRTUAL unsigned int GetShadowIndirectOnly() const;
    HG_VIRTUAL unsigned int SetupLightmapResolutionViewInfo(FPrimitiveSceneProxy &) const;
HG_PRIVATE:
    UPrimitiveComponent &operator=(const UPrimitiveComponent &);
public:
    static UClass *GetPrivateStaticClassUPrimitiveComponent(const wchar_t *);
    static void InitializePrivateStaticClassUPrimitiveComponent();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    unsigned int ShouldCollide() const;
    void AttachDecal(UDecalComponent *, FDecalRenderData *, const FDecalState *);
    void DetachDecal(UDecalComponent *);
    unsigned int HasStaticShadowing() const;
    void ValidateLightingChannels();
    HG_VIRTUAL void InvalidateLightingCache();
    void GetUsedTextures(TArray<UTexture *,FDefaultAllocator> &, EMaterialShaderQuality, unsigned int);
    FVector GetOrigin() const;
    void GetTransformAndScale(FMatrix &, FVector &);
    HG_VIRTUAL void InitComponentRBPhys(unsigned int);
    HG_VIRTUAL void SetComponentRBFixed(unsigned int);
    HG_VIRTUAL void TermComponentRBPhys(FRBPhysScene *);
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
HG_PROTECTED:
    HG_VIRTUAL void SetParentToWorld(const FMatrix &);
    HG_VIRTUAL void Attach();
    HG_VIRTUAL void UpdateTransform();
    HG_VIRTUAL void Detach(unsigned int);
public:
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    HG_VIRTUAL void PostEditChangeChainProperty(FPropertyChangedChainEvent &);
    HG_VIRTUAL void PostLoad();
    HG_VIRTUAL unsigned int IsReadyForFinishDestroy();
    HG_VIRTUAL unsigned int NeedsLoadForClient() const;
    HG_VIRTUAL unsigned int NeedsLoadForServer() const;
    HG_VIRTUAL void PostCrossLevelFixup();
    void execShouldComponentAddToScene(FFrame &, void *const);
    void PushSelectionToProxy(const unsigned int);
    void PushHoveredToProxy(const unsigned int);
    void PushEditorVisibilityToProxy(unsigned __int64);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UPrimitiveComponent();
public:
    UPrimitiveComponent();
    #endif
    typedef UActorComponent Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    static int CurrentTag;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static hg::be<int> (&CurrentTag);
    #endif
HG_PRIVATE:
    unsigned int UPrimitiveComponentData[0x62];
};

class UCCSVisualizationComponent : public UPrimitiveComponent  // size 0x1F0, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSVisualizationComponent &operator=(const UCCSVisualizationComponent &);
public:
    static UClass *GetPrivateStaticClassUCCSVisualizationComponent(const wchar_t *);
    static void InitializePrivateStaticClassUCCSVisualizationComponent();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void UpdateBounds();
    HG_VIRTUAL FPrimitiveSceneProxy *CreateSceneProxy();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSVisualizationComponent();
public:
    #endif
    typedef UPrimitiveComponent Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UCCSVisualizationComponentData[0x4];
};

class UField : public UObject  // size 0x40, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    HG_VIRTUAL void AddCppProperty(UProperty *);
    HG_VIRTUAL unsigned int MergeBools();
    HG_VIRTUAL void Bind();
HG_PRIVATE:
    UField &operator=(const UField &);
public:
    static UClass *GetPrivateStaticClassUField(const wchar_t *);
    static void InitializePrivateStaticClassUField();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void PostLoad();
    UClass *GetOwnerClass() const;
    UStruct *GetOwnerStruct() const;
HG_PRIVATE:
    HG_VIRTUAL UObject *CreateArchetype(const wchar_t *, UObject *, UObject *, FObjectInstancingGraph *);
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UField();
public:
    UField();
    UField(EStaticConstructor, const wchar_t *, const wchar_t *, unsigned __int64);
    UField(ENativeConstructor, UClass *, const wchar_t *, const wchar_t *, unsigned __int64);
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UFieldData[0x1];
};

class UStruct : public UField  // size 0x74, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    HG_VIRTUAL UStruct *GetInheritanceSuper() const;
    HG_VIRTUAL void Link(FArchive &, unsigned int);
    HG_VIRTUAL void SerializeBin(FArchive &, unsigned char *, int) const;
    HG_VIRTUAL EExprToken SerializeExpr(int &, FArchive &);
    HG_VIRTUAL void PropagateStructDefaults();
    HG_VIRTUAL const wchar_t *GetPrefixCPP();
HG_PRIVATE:
    UStruct &operator=(const UStruct &);
public:
    static UClass *GetPrivateStaticClassUStruct(const wchar_t *);
    static void InitializePrivateStaticClassUStruct();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void PostLoad();
    HG_VIRTUAL void FinishDestroy();
    HG_VIRTUAL void Register();
    HG_VIRTUAL void StripData(UE3::EPlatformType, unsigned int);
    HG_VIRTUAL void AddCppProperty(UProperty *);
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
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UStruct();
public:
    UStruct(UStruct *);
    UStruct(EStaticConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64);
    UStruct(ENativeConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64, UStruct *);
HG_PROTECTED:
    UStruct();
public:
    #endif
    typedef UField Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UStructData[0xD];
};

class UState : public UStruct  // size 0xBC, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
HG_PRIVATE:
    UState &operator=(const UState &);
public:
    static UClass *GetPrivateStaticClassUState(const wchar_t *);
    static void InitializePrivateStaticClassUState();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL unsigned int MergeBools();
    HG_VIRTUAL UStruct *GetInheritanceSuper() const;
    UState *GetSuperState() const;
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UState();
public:
    UState(UState *);
    UState(EStaticConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64);
    UState(ENativeConstructor, int, const wchar_t *, const wchar_t *, unsigned __int64, UState *);
HG_PROTECTED:
    UState();
public:
    #endif
    typedef UStruct Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UStateData[0x12];
};

class UClass : public UState  // size 0x154, opaque
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
HG_PRIVATE:
    UClass &operator=(const UClass &);
public:
    static UClass *GetPrivateStaticClassUClass(const wchar_t *);
    static void InitializePrivateStaticClassUClass();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    UPackage *GetOuterUPackage() const;
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void PostLoad();
    HG_VIRTUAL void FinishDestroy();
    HG_VIRTUAL void Register();
    HG_VIRTUAL unsigned int Rename(const wchar_t *, UObject *, unsigned long);
    HG_VIRTUAL UComponent *FindComponent(FName, unsigned int);
    HG_VIRTUAL void AddReferencedObjects(TArray<UObject *,FDefaultAllocator> &);
    HG_VIRTUAL void Bind();
    HG_VIRTUAL void PropagateStructDefaults();
    unsigned char *GetDefaults();
    int GetDefaultsCount();
    HG_VIRTUAL unsigned int MergeBools();
    HG_VIRTUAL UStruct *GetInheritanceSuper() const;
    void ConditionalLink();
    HG_VIRTUAL void Link(FArchive &, unsigned int);
    HG_VIRTUAL const wchar_t *GetPrefixCPP();
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
    HG_VIRTUAL FString GetDesc();
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
HG_PRIVATE:
    unsigned int IsA(UClass *) const;
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UClass();
public:
    UClass(EStaticConstructor, unsigned long, unsigned long, unsigned long, const wchar_t *, const wchar_t *, const wchar_t *, unsigned __int64, void (*)(void *), void (UObject::*)(), void (UObject::*)());
    UClass(ENativeConstructor, unsigned long, unsigned long, unsigned long, UClass *, UClass *, const wchar_t *, const wchar_t *, const wchar_t *, unsigned __int64, void (*)(void *), void (UObject::*)(), void (UObject::*)());
    UClass(UClass *);
    UClass();
    #endif
    typedef UState Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
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
HG_PRIVATE:
    UGripBTScriptNodeCache &operator=(const UGripBTScriptNodeCache &);
public:
    static UClass *GetPrivateStaticClassUGripBTScriptNodeCache(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTScriptNodeCache();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTScriptNodeCache();
    UGripBTScriptNodeCache();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
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
HG_PRIVATE:
    UUDKAnimBlendBase &operator=(const UUDKAnimBlendBase &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimBlendBase(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimBlendBase();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL void HandleSliderMove(int, int, float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUDKAnimBlendBase();
public:
    #endif
    typedef UAnimNodeBlendList Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UUDKAnimBlendBaseData[0x8];
};

class UHaloAnimBlendByAimProfile : public UUDKAnimBlendBase  // size 0x120, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UHaloAnimBlendByAimProfile &operator=(const UHaloAnimBlendByAimProfile &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByAimProfile(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByAimProfile();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void WeapTypeChanged(FName);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloAnimBlendByAimProfile();
public:
    #endif
    typedef UUDKAnimBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UHaloAnimBlendByForwardMomentum : public UUDKAnimBlendBase  // size 0x120, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UHaloAnimBlendByForwardMomentum &operator=(const UHaloAnimBlendByForwardMomentum &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByForwardMomentum(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByForwardMomentum();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL int GetNumSliders() const;
    HG_VIRTUAL ESliderType GetSliderType(int) const;
    HG_VIRTUAL float GetSliderPosition(int, int);
    HG_VIRTUAL FString GetSliderDrawValue(int);
    void UpdateChildWeights();
    HG_VIRTUAL void HandleSliderMove(int, int, float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloAnimBlendByForwardMomentum();
public:
    #endif
    typedef UUDKAnimBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UHaloAnimBlendByJumpType : public UUDKAnimBlendBase  // size 0x130, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    HG_VIRTUAL void OnChangeJumpType(int, unsigned int);
    void execOnChangeJumpType(FFrame &, void *const);
HG_PRIVATE:
    UHaloAnimBlendByJumpType &operator=(const UHaloAnimBlendByJumpType &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByJumpType(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByJumpType();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL void SetActiveChild(int, float);
    HG_VIRTUAL void OnBecomeRelevant();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloAnimBlendByJumpType();
public:
    #endif
    typedef UUDKAnimBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UHaloAnimBlendByJumpTypeData[0x4];
};

class UUDKAnimBlendByPhysics : public UUDKAnimBlendBase  // size 0x170, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUDKAnimBlendByPhysics &operator=(const UUDKAnimBlendByPhysics &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimBlendByPhysics(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimBlendByPhysics();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUDKAnimBlendByPhysics();
public:
    #endif
    typedef UUDKAnimBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UUDKAnimBlendByPhysicsData[0x14];
};

class UHaloAnimBlendByPhysics : public UUDKAnimBlendByPhysics  // size 0x180, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UHaloAnimBlendByPhysics &operator=(const UHaloAnimBlendByPhysics &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByPhysics(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByPhysics();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void SetActiveChild(int, float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloAnimBlendByPhysics();
public:
    #endif
    typedef UUDKAnimBlendByPhysics Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UHaloAnimBlendByPhysicsData[0x4];
};

class UUDKAnimBlendByTurnInPlace : public UUDKAnimBlendBase  // size 0x130, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUDKAnimBlendByTurnInPlace &operator=(const UUDKAnimBlendByTurnInPlace &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimBlendByTurnInPlace(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimBlendByTurnInPlace();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUDKAnimBlendByTurnInPlace();
public:
    #endif
    typedef UUDKAnimBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UUDKAnimBlendByTurnInPlaceData[0x4];
};

class UHaloAnimBlendByTurnInPlace : public UUDKAnimBlendByTurnInPlace  // size 0x130, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UHaloAnimBlendByTurnInPlace &operator=(const UHaloAnimBlendByTurnInPlace &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimBlendByTurnInPlace(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimBlendByTurnInPlace();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloAnimBlendByTurnInPlace();
public:
    #endif
    typedef UUDKAnimBlendByTurnInPlace Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UUDKAnimNodeCopyBoneTranslation : public UAnimNodeBlendBase  // size 0x140, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUDKAnimNodeCopyBoneTranslation &operator=(const UUDKAnimNodeCopyBoneTranslation &);
public:
    static UClass *GetPrivateStaticClassUUDKAnimNodeCopyBoneTranslation(const wchar_t *);
    static void InitializePrivateStaticClassUUDKAnimNodeCopyBoneTranslation();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void PostEditChangeProperty(FPropertyChangedEvent &);
    void UpdateListOfRequiredBones(FName);
    HG_VIRTUAL void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL void GetBoneAtoms(TArray<FBoneAtom,TMemStackAllocator<GMainThreadMemStack,8> > &, const TArray<unsigned char,FDefaultAllocator> &, FBoneAtom &, int &, TArray<FCurveKey,TMemStackAllocator<GMainThreadMemStack,8> > &);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUDKAnimNodeCopyBoneTranslation();
public:
    #endif
    typedef UAnimNodeBlendBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UUDKAnimNodeCopyBoneTranslationData[0x18];
};

class UHaloAnimNodeCopyBoneTranslation : public UUDKAnimNodeCopyBoneTranslation  // size 0x150, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UHaloAnimNodeCopyBoneTranslation &operator=(const UHaloAnimNodeCopyBoneTranslation &);
public:
    static UClass *GetPrivateStaticClassUHaloAnimNodeCopyBoneTranslation(const wchar_t *);
    static void InitializePrivateStaticClassUHaloAnimNodeCopyBoneTranslation();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void InitAnim(USkeletalMeshComponent *, UAnimNodeBlendBase *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloAnimNodeCopyBoneTranslation();
public:
    #endif
    typedef UUDKAnimNodeCopyBoneTranslation Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UHaloAnimNodeCopyBoneTranslationData[0x4];
};

class UHaloBTKamikaze : public UCCSBTMoveTo  // size 0xD4, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UHaloBTKamikaze &operator=(const UHaloBTKamikaze &);
public:
    static UClass *GetPrivateStaticClassUHaloBTKamikaze(const wchar_t *);
    static void InitializePrivateStaticClassUHaloBTKamikaze();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL GripRBTNode *CreateRuntime();
    HG_VIRTUAL void InitializeRuntime(GripRBTNode *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UHaloBTKamikaze();
public:
    #endif
    typedef UCCSBTMoveTo Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
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
HG_PRIVATE:
    UUDKTargetableComponent &operator=(const UUDKTargetableComponent &);
public:
    static UClass *GetPrivateStaticClassUUDKTargetableComponent(const wchar_t *);
    static void InitializePrivateStaticClassUUDKTargetableComponent();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL void BeginPlay();
    HG_VIRTUAL void BeginDestroy();
    AActor *GetOwner();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUDKTargetableComponent();
public:
    #endif
    typedef UActorComponent Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
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
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<int> BaseThreatVal;
    hg::be<float> MaxAIHeat;
    hg::be<float> CurAIHeat;
    hg::be<float> ReduceHeatPerSecond;
    hg::be<float> InnerThreatRadius;
    hg::be<float> OutterThreatRadius;
    hg::be<float> ModifiableThreatPct;
    hg::be<float> fAITargetHeight;
    unsigned char AITargetType;
    char _pad0[0x3];
    hg::be<unsigned int> _bits7C;  // 0x7C, from bAITargetable
    hg::gptr<AActor> myOwner;
    #endif
};

class UUSSATBlendByAlertness : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUSSATBlendByAlertness &operator=(const UUSSATBlendByAlertness &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByAlertness(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByAlertness();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUSSATBlendByAlertness();
public:
    #endif
    typedef UCCSATBlendListBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UUSSATBlendByCover : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUSSATBlendByCover &operator=(const UUSSATBlendByCover &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByCover(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByCover();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUSSATBlendByCover();
public:
    #endif
    typedef UCCSATBlendListBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UUSSATBlendByCoverPose : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUSSATBlendByCoverPose &operator=(const UUSSATBlendByCoverPose &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByCoverPose(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByCoverPose();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    HG_VIRTUAL void OnCeaseRelevant();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUSSATBlendByCoverPose();
public:
    #endif
    typedef UCCSATBlendListBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UUSSATBlendByMove : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUSSATBlendByMove &operator=(const UUSSATBlendByMove &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByMove(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByMove();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUSSATBlendByMove();
public:
    #endif
    typedef UCCSATBlendListBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UUSSATBlendByPosture : public UCCSATBlendListBase  // size 0x110, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UUSSATBlendByPosture &operator=(const UUSSATBlendByPosture &);
public:
    static UClass *GetPrivateStaticClassUUSSATBlendByPosture(const wchar_t *);
    static void InitializePrivateStaticClassUUSSATBlendByPosture();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void TickAnim(float);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UUSSATBlendByPosture();
public:
    #endif
    typedef UCCSATBlendListBase Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
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
