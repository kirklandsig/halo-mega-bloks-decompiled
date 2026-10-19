// Generated from the PDB by:
//   python tools/gen_header.py HaloRBTKamikaze CCSBlackboard CCSBrain CCSTarget CCSCharacter CCSGameCharacter "GripBBProperty<CCSTarget *>" FName --opaque ICCSMeatPuppet --add "IGripBTInterface=template <class T0> T0 *GetBlackboard();" --host-thunks runtime/src/decomp/HaloRBTKamikaze.thunks.cpp -o <this file>
#pragma once
#include "Core/Inc/HostGuest.h"

namespace Grip {
template <class T0, int T1> struct AllocatorGH;
struct MemAddressStub;
class MemoryHeap;
class String;
}

template <class T0, class T1> class GripBBArray;
template <class T0> class GripBBProperty;
template <class T0, class T1> class Grip_Array;
template <class T0, int T1> class Grip_ArrayPOD;
template <class T0, class T1> class TArray;
template <class T0> class TArrayNoInit;
class AActor;
class APawn;
class CCSBBVisualization;
class CCSBlackboard;
class CCSBrain;
class CCSCSInterface;
struct CCSCharacter;
struct CCSCover;
struct CCSGameCharacter;
class CCSGlobalBlackboard;
class CCSRBTMoveTo;
struct CCSSystemsConfig;
struct CCSTarget;
class FDefaultAllocator;
class FName;
struct FNameEntry;
class FOutputDevice;
class FString;
class FVector;
class GripAFFactory;
class GripAFFramework;
class GripAFScheduler;
class GripBBMember;
class GripBBVisualization;
class GripBTStack;
class GripBTSystemFlags;
class GripBlackboard;
class GripBrain;
class GripBrainSnapshotSerializer;
class GripBrainSystem;
class GripBrainSystemContainer;
struct GripEvent;
class GripGameEventHandler;
class GripHUDRenderer;
class GripHeapObject;
class GripRBTAllocator;
class GripRBTBehavior;
class GripRBTNode;
class GripRBTTree;
struct GripSerializationMember;
class GripSerializer;
struct GripSystemConfig;
class GripVHeapObject;
struct Grip_Rotation;
struct Grip_Vector;
class HaloRBTKamikaze;
class ICCSMeatPuppet;
class IGripBTInterface;
class IGripBrainListener;
class IGripMeatPuppetQuery;
class IGripRBTTreeListener;
class IGripSRComponent;
class IGripSRProxy;
class IGripWorldQuery;
class UAnimNodeSlot;
class UClass;
class UGwNavBotHandle;
class UUDKTargetableComponent;
enum EAITargetType
{
    AITargetType_NONE = 0,
    AITargetType_PassiveObjective = 1,
    AITargetType_PassiveSecondary = 2,
    AITargetType_AggressiveMobile = 3,
    AITargetType_AggressiveStationary = 4,
    AITargetType_MAX = 5,
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
enum EFindName
{
    FNAME_Find = 0,
    FNAME_Add = 1,
    FNAME_Replace = 2,
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
enum ELinkerNameTableConstructor
{
    ENAME_LinkerConstructor = 0,
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
enum EThreatType
{
};

namespace Kaim {
template <class T0> class AStarQuery;
template <class T0> class Pickable;
template <class T0> class Ptr;
class DefaultTraverseLogic;
enum AStarQueryResult
{
    ASTAR_NOT_INITIALIZED = 0,
    ASTAR_NOT_PROCESSED = 1,
    ASTAR_PROCESSING_TRAVERSAL = 2,
    ASTAR_PROCESSING_TRAVERSAL_DONE = 3,
    ASTAR_PROCESSING_REFINING_INIT = 4,
    ASTAR_PROCESSING_REFINING = 5,
    ASTAR_PROCESSING_PATHCLAMPING_INIT = 6,
    ASTAR_PROCESSING_PATHCLAMPING = 7,
    ASTAR_PROCESSING_PATHBUILDING = 8,
    ASTAR_PROCESSING_CHANNEL_INIT = 9,
    ASTAR_PROCESSING_CHANNEL_COMPUTE = 10,
    ASTAR_DONE_START_OUTSIDE = 11,
    ASTAR_DONE_START_NAVTAG_FORBIDDEN = 12,
    ASTAR_DONE_END_OUTSIDE = 13,
    ASTAR_DONE_END_NAVTAG_FORBIDDEN = 14,
    ASTAR_DONE_PATH_NOT_FOUND = 15,
    ASTAR_DONE_NAVDATA_CHANGED = 16,
    ASTAR_DONE_ERROR_LACK_OF_WORKING_MEMORY = 17,
    ASTAR_DONE_COMPUTATION_ERROR = 18,
    ASTAR_DONE_CHANNELCOMPUTATION_ERROR = 19,
    ASTAR_DONE_COMPUTATION_CANCELED = 20,
    ASTAR_DONE_DEST_IS_START_NO_PATH = 21,
    ASTAR_DONE_PATH_FOUND = 22,
};
enum PickType
{
    PickValue = 0,
};
}

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

class GripBBVisualization : public GripVHeapObject  // size 0x18, opaque
{
public:
    HG_VIRTUAL void Refresh() HG_PURE;
    HG_VIRTUAL void Serialize(GripSerializer *);
    void SetBlackboard(GripBlackboard *);
    const Grip_Array<GripSerializationMember,Grip::AllocatorGH<GripSerializationMember,2> > &GetMembers() const;
    #ifndef HAGGAR_HOST
    GripBBVisualization();
    #endif
HG_PRIVATE:
    unsigned int GripBBVisualizationData[0x5];
};

class CCSBBVisualization : public GripBBVisualization  // size 0x18, opaque
{
public:
    HG_VIRTUAL void Refresh();
};

class GripBBMember : public GripVHeapObject  // size 0x1C, opaque
{
public:
    void FlagAsUsed();
    bool IsUsed() const;
    void GetUsedPerceptionSystems(GripBTSystemFlags &, GripBTSystemFlags &);
    void AddUsedSensorSystems(const int);
    void AddUsedAnalysisSystems(const int);
    void SetBlackboard(GripBlackboard *);
    void DirtyBlackboard();
    #ifndef HAGGAR_HOST
    GripBBMember();
    HG_VIRTUAL ~GripBBMember();
    #endif
HG_PRIVATE:
    unsigned int GripBBMemberData[0x6];
};

template <> class GripBBArray<CCSCover,Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > > : public GripBBMember  // size 0x2C, opaque
{
public:
    void AddItem(const CCSCover &);
    void AddUniqueItem(const CCSCover &);
    void Remove(int);
    void RemoveItem(const CCSCover &);
    void RemoveItemSwap(int);
    void Empty();
    void Reset();
    bool ContainsItem(const CCSCover &) const;
    int FindObject(const CCSCover &) const;
    int Num() const;
    const Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > &GetArray() const;
    Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > &GetArray();
    const CCSCover &operator[](int) const;
    CCSCover &operator[](int);
    #ifndef HAGGAR_HOST
    GripBBArray();
    #endif
HG_PRIVATE:
    unsigned int GripBBArrayData[0x4];
};

template <> class GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > : public GripBBMember  // size 0x2C, opaque
{
public:
    void AddItem(const CCSTarget &);
    void AddUniqueItem(const CCSTarget &);
    void Remove(int);
    void RemoveItem(const CCSTarget &);
    void RemoveItemSwap(int);
    void Empty();
    void Reset();
    bool ContainsItem(const CCSTarget &) const;
    int FindObject(const CCSTarget &) const;
    int Num() const;
    const Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > &GetArray() const;
    Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > &GetArray();
    const CCSTarget &operator[](int) const;
    CCSTarget &operator[](int);
    #ifndef HAGGAR_HOST
    GripBBArray();
    #endif
HG_PRIVATE:
    unsigned int GripBBArrayData[0x4];
};

template <> class GripBBProperty<CCSCover> : public GripBBMember  // size 0x3C, opaque
{
public:
    CCSCover &GetReference();
    const CCSCover &Get() const;
    void Set(const CCSCover &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x8];
};

template <> class GripBBProperty<CCSTarget *> : public GripBBMember  // size 0x20
{
public:
    CCSTarget *&GetReference();
    CCSTarget *const &Get() const;
    void Set(CCSTarget *const &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
    #ifndef HAGGAR_HOST
    CCSTarget *m_value;  // 0x1C
    #else
    hg::gptr<CCSTarget> m_value;
    #endif
};

template <> class GripBBProperty<FVector> : public GripBBMember  // size 0x28, opaque
{
public:
    FVector &GetReference();
    const FVector &Get() const;
    void Set(const FVector &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x3];
};

template <> class GripBBProperty<Grip_Vector> : public GripBBMember  // size 0x28, opaque
{
public:
    Grip_Vector &GetReference();
    const Grip_Vector &Get() const;
    void Set(const Grip_Vector &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x3];
};

template <> class GripBBProperty<UClass *> : public GripBBMember  // size 0x20, opaque
{
public:
    UClass *&GetReference();
    UClass *const &Get() const;
    void Set(UClass *const &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x1];
};

template <> class GripBBProperty<bool> : public GripBBMember  // size 0x20, opaque
{
public:
    bool &GetReference();
    const bool &Get() const;
    void Set(const bool &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x1];
};

template <> class GripBBProperty<enum EEventType> : public GripBBMember  // size 0x20, opaque
{
public:
    EEventType &GetReference();
    const EEventType &Get() const;
    void Set(const EEventType &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x1];
};

template <> class GripBBProperty<enum EThreatType> : public GripBBMember  // size 0x20, opaque
{
public:
    EThreatType &GetReference();
    const EThreatType &Get() const;
    void Set(const EThreatType &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x1];
};

template <> class GripBBProperty<float> : public GripBBMember  // size 0x20, opaque
{
public:
    float &GetReference();
    const float &Get() const;
    void Set(const float &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x1];
};

template <> class GripBBProperty<int> : public GripBBMember  // size 0x20, opaque
{
public:
    int &GetReference();
    const int &Get() const;
    void Set(const int &);
    #ifndef HAGGAR_HOST
    GripBBProperty();
    #endif
HG_PRIVATE:
    unsigned int GripBBPropertyData[0x1];
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

class CCSBlackboard : public GripBlackboard  // size 0x67C
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
    #ifndef HAGGAR_HOST
    GripBBProperty<CCSTarget *> m_pHighestThreatTarget;  // 0x8C
    GripBBProperty<CCSTarget *> m_closestEnemy;  // 0xAC
    GripBBProperty<CCSTarget *> m_closestVisibleEnemy;  // 0xCC
    GripBBProperty<CCSTarget *> m_currentTarget;  // 0xEC
    GripBBProperty<CCSTarget *> m_lowestLKPAgeEnemy;  // 0x10C
    GripBBProperty<CCSTarget *> m_closestObjective;  // 0x12C
    GripBBProperty<CCSTarget *> m_closestReactiveTarget;  // 0x14C
    GripBBProperty<CCSTarget *> m_secondaryTarget;  // 0x16C
    GripBBProperty<bool> m_bHasBecomeAware;  // 0x18C
    GripBBProperty<bool> m_visibleToPlayerCamera;  // 0x1AC
    GripBBProperty<int> m_team;  // 0x1CC
    GripBBProperty<float> m_timeSinceDamage;  // 0x1EC
    GripBBProperty<int> m_health;  // 0x20C
    GripBBProperty<float> m_timeSinceAimedAt;  // 0x22C
    GripBBProperty<float> m_timeSinceStaggered;  // 0x24C
    GripBBProperty<float> m_timeSinceThreatened;  // 0x26C
    GripBBProperty<float> m_timeSinceGrenadeStuck;  // 0x28C
    GripBBProperty<float> m_timeSinceSuccessfulAttack;  // 0x2AC
    GripBBProperty<enum EEventType> m_eventType;  // 0x2CC
    GripBBProperty<float> m_timeSinceEvent;  // 0x2EC
    GripBBProperty<UClass *> m_eventSenderClass;  // 0x30C
    GripBBProperty<Grip_Vector> m_eventLocation;  // 0x32C
    GripBBProperty<Grip_Vector> m_threatLocation;  // 0x354
    GripBBProperty<Grip_Vector> m_threatDirection;  // 0x37C
    GripBBProperty<enum EThreatType> m_threatType;  // 0x3A4
    GripBBProperty<float> m_timeSinceThreatTargetChanged;  // 0x3C4
    GripBBProperty<float> m_timeSinceTargetCamoed;  // 0x3E4
    GripBBProperty<float> m_timeSinceBecameAware;  // 0x404
    GripBBProperty<float> m_timeSinceLostAware;  // 0x424
    GripBBProperty<float> m_heatGenerated;  // 0x444
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_targets;  // 0x464
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_OutRangeThreatTargets;  // 0x490
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_friendlies;  // 0x4BC
    char m_TargetThreatData[0x2C];  // 0x4E8 GripBBProperty<Grip_Array<CCSBlackboard::TargetThreatData,Grip::AllocatorGH<CCSBlackboard::TargetThreatData,2> > >
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_Vehicles;  // 0x514
    GripBBProperty<CCSTarget *> m_closestEntryVehicle;  // 0x540
    GripBBProperty<FVector> m_currentTether;  // 0x560
    GripBBArray<CCSCover,Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > > m_covers;  // 0x588
    GripBBArray<CCSCover,Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > > m_invalidcovers;  // 0x5B4
    GripBBProperty<CCSCover> m_initialCover;  // 0x5E0
    char m_moveCommand[0x20];  // 0x61C GripBBProperty<enum CCSBlackboard::EMoveCmd>
    GripBBProperty<Grip_Vector> m_movePosition;  // 0x63C
    CCSBBVisualization m_vis;  // 0x664
    #else
    GripBBProperty<CCSTarget *> m_pHighestThreatTarget;
    GripBBProperty<CCSTarget *> m_closestEnemy;
    GripBBProperty<CCSTarget *> m_closestVisibleEnemy;
    GripBBProperty<CCSTarget *> m_currentTarget;
    GripBBProperty<CCSTarget *> m_lowestLKPAgeEnemy;
    GripBBProperty<CCSTarget *> m_closestObjective;
    GripBBProperty<CCSTarget *> m_closestReactiveTarget;
    GripBBProperty<CCSTarget *> m_secondaryTarget;
    GripBBProperty<bool> m_bHasBecomeAware;
    GripBBProperty<bool> m_visibleToPlayerCamera;
    GripBBProperty<int> m_team;
    GripBBProperty<float> m_timeSinceDamage;
    GripBBProperty<int> m_health;
    GripBBProperty<float> m_timeSinceAimedAt;
    GripBBProperty<float> m_timeSinceStaggered;
    GripBBProperty<float> m_timeSinceThreatened;
    GripBBProperty<float> m_timeSinceGrenadeStuck;
    GripBBProperty<float> m_timeSinceSuccessfulAttack;
    GripBBProperty<enum EEventType> m_eventType;
    GripBBProperty<float> m_timeSinceEvent;
    GripBBProperty<UClass *> m_eventSenderClass;
    GripBBProperty<Grip_Vector> m_eventLocation;
    GripBBProperty<Grip_Vector> m_threatLocation;
    GripBBProperty<Grip_Vector> m_threatDirection;
    GripBBProperty<enum EThreatType> m_threatType;
    GripBBProperty<float> m_timeSinceThreatTargetChanged;
    GripBBProperty<float> m_timeSinceTargetCamoed;
    GripBBProperty<float> m_timeSinceBecameAware;
    GripBBProperty<float> m_timeSinceLostAware;
    GripBBProperty<float> m_heatGenerated;
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_targets;
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_OutRangeThreatTargets;
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_friendlies;
    char m_TargetThreatData[0x2C];  // 0x4E8 GripBBProperty<Grip_Array<CCSBlackboard::TargetThreatData,Grip::AllocatorGH<CCSBlackboard::TargetThreatData,2> > >
    GripBBArray<CCSTarget,Grip_Array<CCSTarget,Grip::AllocatorGH<CCSTarget,2> > > m_Vehicles;
    GripBBProperty<CCSTarget *> m_closestEntryVehicle;
    GripBBProperty<FVector> m_currentTether;
    GripBBArray<CCSCover,Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > > m_covers;
    GripBBArray<CCSCover,Grip_Array<CCSCover,Grip::AllocatorGH<CCSCover,2> > > m_invalidcovers;
    GripBBProperty<CCSCover> m_initialCover;
    char m_moveCommand[0x20];  // 0x61C GripBBProperty<enum CCSBlackboard::EMoveCmd>
    GripBBProperty<Grip_Vector> m_movePosition;
    CCSBBVisualization m_vis;
    #endif
};

struct GripSystemConfig : public GripVHeapObject  // size 0x4, opaque
{
};

struct CCSSystemsConfig : public GripSystemConfig  // size 0x34, opaque
{
HG_PRIVATE:
    unsigned int CCSSystemsConfigData[0xC];
};

class GripBTSystemFlags : public GripVHeapObject  // size 0x8, opaque
{
public:
    void ClearFlag(int);
    bool TestFlag(int) const;
    void SetFlag(int);
    void Reset();
    GripBTSystemFlags &operator|=(const GripBTSystemFlags &);
    #ifndef HAGGAR_HOST
    GripBTSystemFlags();
    #endif
HG_PRIVATE:
    unsigned int GripBTSystemFlagsData[0x1];
};

class IGripBTInterface  // size 0x4, opaque
{
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~IGripBTInterface();)
    HG_VIRTUAL float GetDeltaTime() HG_PURE;
    HG_VIRTUAL float GetTime() HG_PURE;
    HG_VIRTUAL float GetRandomFloat() HG_PURE;
    HG_VIRTUAL GripAFScheduler *GetActionScheduler() HG_PURE;
    HG_VIRTUAL void BroadcastGameEvent(const Grip::String) HG_PURE;
    HG_VIRTUAL void ConsumeGameEvent(const Grip::String) HG_PURE;
HG_PROTECTED:
    HG_VIRTUAL GripAFFactory *GetActionFactoryInternal() HG_PURE;
    HG_VIRTUAL GripBlackboard *GetBlackboardInternal() HG_PURE;
    HG_VIRTUAL IGripMeatPuppetQuery *GetMeatPuppetQueryInternal() HG_PURE;
    HG_VIRTUAL IGripWorldQuery *GetWorldQueryInternal() HG_PURE;
public:
    template <class T0> T0 *GetBlackboard();
};

class IGripBrainListener  // size 0x4, opaque
{
public:
    enum EEventType
    {
        SPAWNED = 0,
        TRANSITION = 1,
        DESTROYED = 2,
        TREEBREAKPOINT = 3,
        DISABLED = 4,
        ENABLED = 5,
    };
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~IGripBrainListener();)
    HG_VIRTUAL void OnBrainEvent(GripBrain *, IGripBrainListener::EEventType) HG_PURE;
};

class IGripRBTTreeListener  // size 0x4, opaque
{
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~IGripRBTTreeListener();)
    HG_VIRTUAL void OnTreeChanged(GripRBTTree *) HG_PURE;
    HG_VIRTUAL void OnTreeBreakpoint(GripRBTTree *) HG_PURE;
    HG_VIRTUAL void OnTreeEvaluated(GripRBTTree *) HG_PURE;
};

class GripBrain : public GripVHeapObject, public IGripBTInterface, public IGripRBTTreeListener  // size 0x9C, opaque
{
public:
    HG_VIRTUAL void CompleteSetUp();
    HG_VIRTUAL void FinalizeInternal();
    HG_VIRTUAL void Tick(float);
    HG_VIRTUAL void StasisTick();
HG_PROTECTED:
    HG_VIRTUAL void SchedulerRegistration();
    HG_VIRTUAL void SchedulerUnregistration();
    HG_VIRTUAL void TickBehaviorTree();
    HG_VIRTUAL void TickSystems(float);
public:
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &);
    HG_VIRTUAL void DrawHUDBlackboard(GripHUDRenderer *, int &);
    HG_VIRTUAL void DrawHUDEvents(GripHUDRenderer *, int &);
    HG_VIRTUAL void CreateDebugRenderingProxies(Grip_ArrayPOD<IGripSRProxy *,2> &);
    HG_VIRTUAL GripBrainSnapshotSerializer *GetSnapshotSerializer();
    void Finalize();
    HG_VIRTUAL float GetDeltaTime();
    HG_VIRTUAL float GetTime();
    HG_VIRTUAL void BroadcastGameEvent(const Grip::String);
    HG_VIRTUAL void ConsumeGameEvent(const Grip::String);
    HG_VIRTUAL void OnTreeChanged(GripRBTTree *);
    HG_VIRTUAL void OnTreeBreakpoint(GripRBTTree *);
    HG_VIRTUAL void OnTreeEvaluated(GripRBTTree *);
    void Disable(bool);
    Grip::String GetBehaviorTreeName() const;
    int GetBrainID();
    GripBrainSystemContainer &GetSystems();
    GripGameEventHandler &GetGameEventHandler();
    void NotifyBrainEvent(IGripBrainListener::EEventType);
    void OnGameEvent(const GripEvent &);
    void SetStepDebug(const bool);
    void SetDebug(bool);
    bool IsDebug();
    GripBTStack &GetEvalStackDraw(bool &);
    bool IsDisabled();
    void DrawHUDBehaviorTree(GripHUDRenderer *, int &);
    void AddDebugRenderer(IGripSRComponent *);
    void RemoveDebugRenderer(IGripSRComponent *);
    GripRBTTree *GetBehaviorTree();
    #ifndef HAGGAR_HOST
    GripBrain(GripRBTTree *);
    HG_VIRTUAL ~GripBrain();
    #endif
    #ifndef HAGGAR_HOST
    static int ms_brainCounter;
    #else
    static hg::be<int> (&ms_brainCounter);
    #endif
HG_PRIVATE:
    unsigned int GripBrainData[0x24];
};

class CCSBrain : public GripBrain  // size 0xFC
{
HG_PRIVATE:
    void SetUpBlackboard(GripBlackboard *);
    void SetUpMeatPuppetQuery(IGripMeatPuppetQuery *);
    void SetUpWorldQuery(IGripWorldQuery *);
    void SetUpActionFramework(GripAFFramework *);
    void SetUpControlSystemInterface(CCSCSInterface *);
    void SetUpMeatPuppet(ICCSMeatPuppet *);
    void SetUpGlobalBlackboard(CCSGlobalBlackboard *);
    void SetUpSystemConfig(const CCSSystemsConfig &);
    HG_VIRTUAL void CompleteSetUp();
public:
    HG_VIRTUAL float GetRandomFloat();
    HG_VIRTUAL GripAFFactory *GetActionFactoryInternal();
    HG_VIRTUAL GripAFScheduler *GetActionScheduler();
    HG_VIRTUAL GripBlackboard *GetBlackboardInternal();
    HG_VIRTUAL IGripMeatPuppetQuery *GetMeatPuppetQueryInternal();
    HG_VIRTUAL IGripWorldQuery *GetWorldQueryInternal();
    HG_VIRTUAL void Tick(float);
HG_PROTECTED:
    HG_VIRTUAL void SchedulerRegistration();
    HG_VIRTUAL void SchedulerUnregistration();
    HG_VIRTUAL void TickBehaviorTree();
    HG_VIRTUAL void TickSystems(float);
public:
    ICCSMeatPuppet *GetMeatPuppet();
    CCSGlobalBlackboard *GetGlobalBB();
HG_PRIVATE:
    void InitializeSystems();
    void InitializePerceptionSystems(Grip_Array<GripBrainSystem *,Grip::AllocatorGH<GripBrainSystem *,2> > &, const CCSSystemsConfig &, const GripBTSystemFlags &);
    void InitializeControlSystems(const CCSSystemsConfig &);
public:
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &);
    HG_VIRTUAL void CreateDebugRenderingProxies(Grip_ArrayPOD<IGripSRProxy *,2> &);
    #ifndef HAGGAR_HOST
    HG_VIRTUAL ~CCSBrain();
HG_PRIVATE:
    CCSBrain(GripRBTTree *);
public:
    #endif
    #ifndef HAGGAR_HOST
    ICCSMeatPuppet *m_meatPuppet;  // 0x9C
    GripBTSystemFlags m_ssFlags;  // 0xA0
    GripBTSystemFlags m_asFlags;  // 0xA8
    GripBlackboard *m_blackboard;  // 0xB0
    CCSGlobalBlackboard *m_pGlobalBB;  // 0xB4
    GripAFFramework *m_afFramework;  // 0xB8
    CCSCSInterface *m_csInterface;  // 0xBC
    CCSSystemsConfig m_systemsConfig;  // 0xC0
    IGripMeatPuppetQuery *m_meatPuppetQuery;  // 0xF4
    IGripWorldQuery *m_worldQuery;  // 0xF8
    #else
    hg::gptr<ICCSMeatPuppet> m_meatPuppet;
    GripBTSystemFlags m_ssFlags;
    GripBTSystemFlags m_asFlags;
    hg::gptr<GripBlackboard> m_blackboard;
    hg::gptr<CCSGlobalBlackboard> m_pGlobalBB;
    hg::gptr<GripAFFramework> m_afFramework;
    hg::gptr<CCSCSInterface> m_csInterface;
    CCSSystemsConfig m_systemsConfig;
    hg::gptr<IGripMeatPuppetQuery> m_meatPuppetQuery;
    hg::gptr<IGripWorldQuery> m_worldQuery;
    #endif
};

class GripHeapObject  // size 0x1, opaque
{
public:
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

struct CCSGameCharacter : public GripHeapObject  // size 0x14
{
public:
    bool operator==(const CCSGameCharacter &) const;
    void *GetActor() const;
    UUDKTargetableComponent *GetTargetableComponent();
    Grip_Vector GetEyesPosition() const;
    float GetHeight() const;
    Grip_Rotation GetOrientation() const;
    Grip_Vector GetPosition() const;
    float GetSize() const;
    int GetTeam();
    bool IsPlayer() const;
    #ifndef HAGGAR_HOST
    CCSGameCharacter();
    #endif
    #ifndef HAGGAR_HOST
    static const CCSGameCharacter NONE;
    APawn *m_pawn;  // 0x0
    AActor *m_actor;  // 0x4
    UUDKTargetableComponent *m_targetableComponent;  // 0x8
    bool m_targetableComponentCheck;  // 0xC
    char _pad0[0x3];
    int m_cachedTeamNum;  // 0x10
    #else
    static const CCSGameCharacter (&NONE);
    hg::gptr<APawn> m_pawn;
    hg::gptr<AActor> m_actor;
    hg::gptr<UUDKTargetableComponent> m_targetableComponent;
    bool m_targetableComponentCheck;
    char _pad0[0x3];
    hg::be<int> m_cachedTeamNum;
    #endif
};

struct CCSCharacter : public GripHeapObject  // size 0x14
{
public:
    bool operator==(const CCSCharacter &) const;
    bool operator!=(const CCSCharacter &) const;
    void *GetActor() const;
    CCSBrain *GetBrain() const;
    UUDKTargetableComponent *GetTargetableComponent();
    Grip_Vector GetEyesPosition() const;
    float GetHeight() const;
    Grip_Rotation GetOrientation() const;
    Grip_Vector GetPosition() const;
    float GetSize() const;
    int GetTeam();
    bool IsPlayer() const;
    #ifndef HAGGAR_HOST
    CCSCharacter();
    #endif
    #ifndef HAGGAR_HOST
    static const CCSCharacter NONE;
    CCSGameCharacter m_gameCharacter;  // 0x0
    #else
    static const CCSCharacter (&NONE);
    CCSGameCharacter m_gameCharacter;
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

struct Grip_Vector : public GripHeapObject  // size 0xC, opaque
{
public:
    operator class FVector() const;
    Grip_Vector operator+(const Grip_Vector &) const;
    Grip_Vector operator+=(const Grip_Vector &);
    Grip_Vector operator-() const;
    Grip_Vector operator-(const Grip_Vector &) const;
    Grip_Vector operator-=(const Grip_Vector &);
    Grip_Vector operator*(const Grip_Vector &);
    Grip_Vector operator*(float) const;
    Grip_Vector operator*=(float);
    Grip_Vector operator/(float) const;
    Grip_Vector operator/=(float);
    bool operator==(const Grip_Vector &) const;
    bool operator!=(const Grip_Vector &) const;
    float operator|(const Grip_Vector &) const;
    Grip_Vector operator^(const Grip_Vector &) const;
    bool Equals(const Grip_Vector &, float) const;
    void Set(float, float, float);
    float Size() const;
    float Size2D() const;
    void Normalize();
    Grip_Vector SafeNormal();
    float SizeSquared() const;
    Grip_Vector GetOrthogonal() const;
    float SizeSquared2D() const;
    int IsNearlyZero(float) const;
    bool ContainsNaN() const;
    Grip_Rotation Rotation() const;
    #ifndef HAGGAR_HOST
    Grip_Vector(float, float, float);
    Grip_Vector(float);
    Grip_Vector(const FVector &);
    Grip_Vector();
    #endif
HG_PRIVATE:
    char Grip_VectorData[0xB];
};

namespace Kaim {
template <> class Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> >  // size 0x4, opaque
{
public:
    bool operator==(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *) const;
    bool operator==(const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &) const;
    bool operator!=(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *) const;
    bool operator!=(const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &) const;
    bool operator<(const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &) const;
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &operator=(Kaim::Pickable<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> >);
    const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &operator=(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> &);
    const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &operator=(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *);
    const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &operator=(const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &);
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &SetPtr(Kaim::Pickable<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> >);
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &SetPtr(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> &);
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &SetPtr(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *);
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &SetPtr(const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &);
    void NullWithoutRelease();
    void Clear();
    Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *&GetRawRef();
    Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *GetPtr() const;
    Kaim::AStarQuery<Kaim::DefaultTraverseLogic> &operator*() const;
    Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *operator->() const;
    operator class Kaim::AStarQuery<class Kaim::DefaultTraverseLogic> *() const;
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &Pick(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *);
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &Pick(Kaim::Pickable<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> >);
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &Pick(Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &);
    #ifndef HAGGAR_HOST
    Ptr(const Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &);
    Ptr(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> *);
    Ptr(Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > &, Kaim::PickType);
    Ptr(Kaim::Pickable<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> >);
    Ptr(Kaim::AStarQuery<Kaim::DefaultTraverseLogic> &);
    Ptr();
    ~Ptr();
    #endif
HG_PRIVATE:
    unsigned int PtrData[0x1];
};
}

struct CCSTarget : public GripHeapObject  // size 0x64
{
public:
    Grip_Vector GetDefaultShootLocation() const;
    bool IsValid() const;
    void ResetAwareness();
    float CurrentCamo() const;
    void FindDestinationReachable(Grip_Vector);
    void UpdateDestinationReachable();
    bool CanFindPath();
    #ifndef HAGGAR_HOST
    CCSTarget(CCSBrain *);
    CCSTarget();
    #endif
    #ifndef HAGGAR_HOST
    CCSCharacter character;  // 0x0
    int teamNum;  // 0x14
    Grip_Vector position;  // 0x18
    Grip_Vector LKP;  // 0x24
    float LKPAge;  // 0x30
    float CNTAge;  // 0x34
    float range2D;  // 0x38
    float rangeNavMesh;  // 0x3C
    float currentThreat;  // 0x40
    bool canShoot;  // 0x44
    bool ClearOfFriendlies;  // 0x45
    bool isAware;  // 0x46
    bool isFiring;  // 0x47
    bool isVisible;  // 0x48
    bool isHeard;  // 0x49
    bool isAvailableVehicle;  // 0x4A
    bool isBehindCover;  // 0x4B
    float forwardDot;  // 0x4C
    float rightDot;  // 0x50
    EAITargetType m_aiTargetType;  // 0x54
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > m_asyncAStarQuery;  // 0x58
    UGwNavBotHandle *m_pGwNavBotHandle;  // 0x5C
    Kaim::AStarQueryResult pathResult;  // 0x60
    #else
    CCSCharacter character;
    hg::be<int> teamNum;
    Grip_Vector position;
    Grip_Vector LKP;
    hg::be<float> LKPAge;
    hg::be<float> CNTAge;
    hg::be<float> range2D;
    hg::be<float> rangeNavMesh;
    hg::be<float> currentThreat;
    bool canShoot;
    bool ClearOfFriendlies;
    bool isAware;
    bool isFiring;
    bool isVisible;
    bool isHeard;
    bool isAvailableVehicle;
    bool isBehindCover;
    hg::be<float> forwardDot;
    hg::be<float> rightDot;
    hg::be<EAITargetType> m_aiTargetType;
    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > m_asyncAStarQuery;
    hg::gptr<UGwNavBotHandle> m_pGwNavBotHandle;
    hg::be<Kaim::AStarQueryResult> pathResult;
    #endif
};

class FName  // size 0x8
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
    int Index;  // 0x0
    int Number;  // 0x4
    #else
    static TArrayNoInit<FNameEntry *> (&Names);
    static hg::gptr<FNameEntry> (&NameHash)[4096];
    static hg::be<int> (&NameEntryMemorySize);
    static hg::be<int> (&NumAnsiNames);
    static hg::be<int> (&NumUnicodeNames);
    hg::be<int> Index;
    hg::be<int> Number;
    #endif
};

class HaloRBTKamikaze : public CCSRBTMoveTo  // size 0xD0
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
    #ifndef HAGGAR_HOST
    int m_actionHandle;  // 0xA4
    float m_detonationDistance;  // 0xA8
    HaloRBTKamikaze::KamikazeState m_kamikazeState;  // 0xAC
    UAnimNodeSlot *m_FullBodyAnimSlot;  // 0xB0
    FName m_ArmKamikazeAnimName;  // 0xB4
    FName m_DetonateKamikazeAnimName;  // 0xBC
    float m_BlendInTime;  // 0xC4
    float m_BlendOutTime;  // 0xC8
    CCSTarget *kamikazeTarget;  // 0xCC
    #else
    hg::be<int> m_actionHandle;
    hg::be<float> m_detonationDistance;
    hg::be<HaloRBTKamikaze::KamikazeState> m_kamikazeState;
    hg::gptr<UAnimNodeSlot> m_FullBodyAnimSlot;
    FName m_ArmKamikazeAnimName;
    FName m_DetonateKamikazeAnimName;
    hg::be<float> m_BlendInTime;
    hg::be<float> m_BlendOutTime;
    hg::gptr<CCSTarget> kamikazeTarget;
    #endif
};

class ICCSMeatPuppet  // size 0x4, opaque
{
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~ICCSMeatPuppet();)
    HG_VIRTUAL CCS::EMovementType GetMovementType() HG_PURE;
    HG_VIRTUAL void SetMovementType(CCS::EMovementType) HG_PURE;
    HG_VIRTUAL void SetMovementTypeDefault() HG_PURE;
    HG_VIRTUAL CCS::EAlertnessState GetAlertness() HG_PURE;
    HG_VIRTUAL void SetAlertness(CCS::EAlertnessState) HG_PURE;
    HG_VIRTUAL void SetAlertnessDefault() HG_PURE;
    HG_VIRTUAL CCS::EMovementSpeed GetSpeed() HG_PURE;
    HG_VIRTUAL void SetSpeed(CCS::EMovementSpeed) HG_PURE;
    HG_VIRTUAL void SetMovementSpeedDefault() HG_PURE;
    HG_VIRTUAL bool IsMoving() HG_PURE;
    HG_VIRTUAL bool ReachedPoint(Grip_Vector) HG_PURE;
    HG_VIRTUAL void Stop() HG_PURE;
    HG_VIRTUAL bool IsCrouched() HG_PURE;
    HG_VIRTUAL void SetCrouched(bool) HG_PURE;
    HG_VIRTUAL void SetPostureDefault() HG_PURE;
    HG_VIRTUAL bool PostureTransitionOver() HG_PURE;
    HG_VIRTUAL bool GetIsPanicking() HG_PURE;
    HG_VIRTUAL void SetIsPanicking(bool) HG_PURE;
    HG_VIRTUAL bool CanAim(Grip_Rotation) HG_PURE;
    HG_VIRTUAL bool CanFireAt(CCSCharacter) HG_PURE;
    HG_VIRTUAL Grip_Vector GetWeaponStartPosition() HG_PURE;
    HG_VIRTUAL bool HasLineOfSightTo(CCSCharacter) HG_PURE;
    HG_VIRTUAL int GetTeam() HG_PURE;
    HG_VIRTUAL bool CanPlayerSeeMe() HG_PURE;
    HG_VIRTUAL int GetHealth() HG_PURE;
    HG_VIRTUAL bool HasHeardCharacter(CCSCharacter) HG_PURE;
    HG_VIRTUAL void NotifyAIMoveToActorCompleted() HG_PURE;
    HG_VIRTUAL CCSCharacter GetCharacter() HG_PURE;
    HG_VIRTUAL bool AimedAt() HG_PURE;
    HG_VIRTUAL bool Threatened() HG_PURE;
    HG_VIRTUAL bool GrenadeStuck() HG_PURE;
    HG_VIRTUAL bool Staggered() HG_PURE;
    HG_VIRTUAL bool SuccessfulAttack() HG_PURE;
    HG_VIRTUAL bool HeardNoise() HG_PURE;
    HG_VIRTUAL bool Event() HG_PURE;
    HG_VIRTUAL EEventType GetEventType() HG_PURE;
    HG_VIRTUAL Grip_Vector GetThreatLocation() HG_PURE;
    HG_VIRTUAL Grip_Vector GetThreatDirection() HG_PURE;
    HG_VIRTUAL Grip_Vector GetEventLocation() HG_PURE;
    HG_VIRTUAL EThreatType GetThreatType() HG_PURE;
    HG_VIRTUAL UAnimNodeSlot *GetFullBodyAnimSlot() HG_PURE;
    HG_VIRTUAL UAnimNodeSlot *GetTopHalfAnimSlot() HG_PURE;
    HG_VIRTUAL UClass *GetEventClass() HG_PURE;
    HG_VIRTUAL void DrawHUD(GripHUDRenderer *, int &) HG_PURE;
};

// ---- written by hand below this line (gen_header.py keeps it) ----

template <class T0> inline T0 *IGripBTInterface::GetBlackboard()
{
    return static_cast<T0 *>(GetBlackboardInternal());
}

inline bool CCSCharacter::operator==(const CCSCharacter &Other) const
{
    return m_gameCharacter.m_pawn == Other.m_gameCharacter.m_pawn
        && m_gameCharacter.m_actor == Other.m_gameCharacter.m_actor;
}

inline void HaloRBTKamikaze::SetDetonationDistance(float Distance) { m_detonationDistance = Distance; }
inline void HaloRBTKamikaze::SetArmKamikazeAnimName(FName Name) { m_ArmKamikazeAnimName = Name; }
inline void HaloRBTKamikaze::SetDetonateKamikazeAnimName(FName Name) { m_DetonateKamikazeAnimName = Name; }
inline void HaloRBTKamikaze::SetBlendTimes(float BlendIn, float BlendOut)
{
    m_BlendInTime = BlendIn;
    m_BlendOutTime = BlendOut;
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
inline FName::FName() {}
#endif
