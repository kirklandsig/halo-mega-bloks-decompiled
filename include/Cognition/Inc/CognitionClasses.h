// Generated from the PDB by: python tools/gen_classes.py Cognition
#pragma once
#include "Core/Inc/HostGuest.h"
#include "Core/Inc/Array.h"
#include "Core/Inc/ScriptInterface.h"

template <class T0, int T1> struct DefaultKeyFuncs;
template <class T0> class TDoubleLinkedList;
template <class T0, class T1> class TIndirectArray;
template <class T0, class T1> class TLookupMap;
template <class T0, class T1, class T2> class TMap;
template <class T0, class T1, int T2, class T3> class TMapBase;
template <class T0> class TRefCountPtr;
template <class T0> class TScopedPointer;
template <class T0, class T1, class T2> class TSet;
template <class T0, class T1, int T2, class T3> class TSortableMapBase;
class AActor;
class FArchive;
struct FAsyncPackage;
class FBatchedElementParameters;
class FBatchedElements;
class FCanvas;
class FClassNetCache;
struct FCompressedChunk;
class FContextSupplier;
class FDefaultSetAllocator;
struct FDependencyRef;
struct FDepthFieldGlowInfo;
class FEditPropertyChain;
struct FEnumPatchData;
class FExportObjectInnerContext;
class FFeedbackContext;
struct FFrame;
struct FGCReferenceInfo;
struct FGCReferenceTokenStream;
struct FGCSkipInfo;
class FGuid;
class FHitProxyConsumer;
class FHitProxyId;
struct FImplementedInterface;
struct FLevelGuids;
class FMaterialRenderProxy;
class FMatrix;
class FName;
struct FNameEntry;
class FNetObjectNotify;
struct FNodeChild;
struct FObjectDuplicationParameters;
struct FObjectExport;
struct FObjectImport;
struct FObjectInstancingGraph;
struct FObjectResource;
class FObjectThumbnail;
struct FOutParmRec;
class FOutputDevice;
struct FPackageFileSummary;
class FPackageInfo;
struct FPatchData;
class FPatchReader;
struct FPropertyChangedChainEvent;
struct FPropertyChangedEvent;
struct FReferencerInformation;
struct FReferencerInformationList;
class FRenderTarget;
struct FRepRecord;
class FSHA1;
struct FScriptDelegate;
struct FScriptPatchData;
struct FScriptPatcher;
struct FStateFrame;
class FString;
struct FStringNoInit;
class FTexture;
struct FUntypedBulkData;
class GripBTStack;
class GripBTSystemFlags;
class GripBlackboard;
class GripGameEventHandler;
class GripRBTAllocator;
class GripRBTNode;
class GripSerializer;
class GripVHeapObject;
class HHitProxy;
class IGripBTInterface;
class UArrayProperty;
class UCCSBTTree;
class UClass;
class UComponent;
class UField;
class UFunction;
class UGripBTNode;
class UGripBTObject;
class UGripBTPriority;
class UGripBTTree;
class ULinker;
class ULinkerLoad;
class ULinkerSave;
class UMetaData;
class UObject;
class UPackage;
class UPackageMap;
class UProperty;
union UPropertyValue;
class UState;
class UStruct;
class UStructProperty;
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
enum ECompressionFlags
{
    COMPRESS_None = 0,
    COMPRESS_ZLIB = 1,
    COMPRESS_LZO = 2,
    COMPRESS_LZX = 4,
    COMPRESS_BiasMemory = 16,
    COMPRESS_BiasSpeed = 32,
    COMPRESS_ForcePPUDecompressZLib = 128,
};
enum ECppProperty
{
    EC_CppProperty = 0,
};
enum EEventParm
{
    EC_EventParm = 0,
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
enum EImportTextFormat
{
    ITF_Unreal = 0,
    ITF_JSON = 1,
};
enum EInternal
{
    EC_Internal = 0,
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
enum ENativeConstructor
{
    EC_NativeConstructor = 0,
};
enum ESimpleElementBlendMode
{
    SE_BLEND_Opaque = 0,
    SE_BLEND_Masked = 1,
    SE_BLEND_Translucent = 2,
    SE_BLEND_Additive = 3,
    SE_BLEND_Modulate = 4,
    SE_BLEND_ModulateAndAdd = 5,
    SE_BLEND_MaskedDistanceField = 6,
    SE_BLEND_MaskedDistanceFieldShadowed = 7,
    SE_BLEND_TranslucentDistanceField = 8,
    SE_BLEND_TranslucentDistanceFieldShadowed = 9,
    SE_BLEND_AlphaComposite = 10,
    SE_BLEND_AlphaOnly = 11,
    SE_BLEND_RGBA_MASK_START = 12,
    SE_BLEND_RGBA_MASK_END = 43,
    SE_BLEND_MAX = 44,
};
enum EStaticConstructor
{
    EC_StaticConstructor = 0,
};
enum MapCheckGroup
{
    MCGROUP_DEFAULT = 0,
    MCGROUP_KISMET = 1,
    MCGROUP_MOBILEPLATFORM = 2,
};
enum MapCheckType
{
    MCTYPE_NONE = 0,
    MCTYPE_CRITICALERROR = 1,
    MCTYPE_ERROR = 2,
    MCTYPE_PERFORMANCEWARNING = 4,
    MCTYPE_WARNING = 8,
    MCTYPE_NOTE = 16,
    MCTYPE_INFO = 32,
};

namespace Grip {
struct MemAddressStub;
class MemoryHeap;
class String;
class StringBuffer;
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

class FArchive  // size 0x84
{
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~FArchive();)
    HG_VIRTUAL void Serialize(void *, int);
    HG_VIRTUAL void SerializeBits(void *, int);
    HG_VIRTUAL void SerializeInt(unsigned long &, unsigned long);
    HG_VIRTUAL void Preload(UObject *);
    HG_VIRTUAL void CountBytes(unsigned long, unsigned long);
    HG_VIRTUAL FArchive &operator<<(FName &);
    HG_VIRTUAL FArchive &operator<<(UObject *&);
    HG_VIRTUAL FString GetArchiveName() const;
    HG_VIRTUAL ULinker *GetLinker();
    HG_VIRTUAL int Tell();
    HG_VIRTUAL int TotalSize();
    HG_VIRTUAL unsigned int AtEnd();
    HG_VIRTUAL void Seek(int);
    HG_VIRTUAL void AttachBulkData(UObject *, FUntypedBulkData *);
    HG_VIRTUAL void DetachBulkData(FUntypedBulkData *, unsigned int);
    HG_VIRTUAL unsigned int Precache(int, int);
    HG_VIRTUAL void FlushCache();
    HG_VIRTUAL unsigned int SetCompressionMap(TArray<FCompressedChunk,FDefaultAllocator> *, ECompressionFlags);
    HG_VIRTUAL void Flush();
    HG_VIRTUAL unsigned int Close();
    HG_VIRTUAL unsigned int GetError();
    HG_VIRTUAL void MarkScriptSerializationStart(const UObject *);
    HG_VIRTUAL void MarkScriptSerializationEnd(const UObject *);
    HG_VIRTUAL void WillSerializePotentialCrossLevelPointer(UObject *, const UProperty *);
    HG_VIRTUAL unsigned int IsCloseComplete(unsigned int &);
    HG_VIRTUAL unsigned int IsFilterEditorOnly();
    HG_VIRTUAL void SetFilterEditorOnly(unsigned int);
    void SerializeCompressed(void *, int, ECompressionFlags, unsigned int);
    void ThisContainsCode();
    void ThisContainsMap();
    void ThisContainsCookedData();
    void StartSerializingDefaults();
    void StopSerializingDefaults();
    unsigned int AllowEliminatingReferences(unsigned int);
    void Logf__VA(const wchar_t *, ...);
    void Logf(const wchar_t *);
    int Ver() const;
    int NetVer() const;
    int LicenseeVer() const;
    unsigned int IsLoading() const;
    unsigned int IsSaving() const;
    unsigned int IsSaveGame() const;
    unsigned int IsTransacting() const;
    unsigned int WantBinaryPropertySerialization() const;
    unsigned int IsForcingUnicode() const;
    unsigned int IsNet() const;
    unsigned int IsPersistent() const;
    unsigned int IsError() const;
    unsigned int IsCriticalError() const;
    unsigned int ContainsCookedData() const;
    unsigned int ForEdit() const;
    unsigned int ForClient() const;
    unsigned int ForServer() const;
    unsigned int ContainsCode() const;
    unsigned int ContainsMap() const;
    unsigned int ForceByteSwapping() const;
    unsigned int IsSerializingDefaults() const;
    unsigned int IsIgnoringArchetypeRef() const;
    unsigned int IsIgnoringOuterRef() const;
    unsigned int IsIgnoringClassRef() const;
    unsigned int IsAllowingReferenceElimination() const;
    unsigned int IsAllowingLazyLoading() const;
    unsigned int IsObjectReferenceCollector() const;
    unsigned int IsCountingMemory() const;
    unsigned long GetPortFlags() const;
    unsigned int HasAnyPortFlags(unsigned long) const;
    unsigned int HasAllPortFlags(unsigned long) const;
    unsigned int ShouldSkipBulkData() const;
    unsigned int IsFinalPackageSave() const;
    int GetMaxSerializeSize() const;
    void SetVer(int);
    void SetLicenseeVer(int);
    void SetForceUnicode(unsigned int);
    void SetByteSwapping(unsigned int);
    void SetPortFlags(unsigned long);
    void SetIsSaveGame(unsigned int);
HG_PROTECTED:
    void Reset();
public:
    #ifndef HAGGAR_HOST
    FArchive();
    #endif
    #ifndef HAGGAR_HOST
    int ArVer;  // 0x4
    int ArNetVer;  // 0x8
    int ArLicenseeVer;  // 0xC
    unsigned int ArIsLoading;  // 0x10
    unsigned int ArIsSaving;  // 0x14
    unsigned int ArIsTransacting;  // 0x18
    unsigned int ArWantBinaryPropertySerialization;  // 0x1C
    unsigned int ArForceUnicode;  // 0x20
    unsigned int ArIsPersistent;  // 0x24
    unsigned int ArForEdit;  // 0x28
    unsigned int ArForClient;  // 0x2C
    unsigned int ArForServer;  // 0x30
    unsigned int ArIsError;  // 0x34
    unsigned int ArIsCriticalError;  // 0x38
    unsigned int ArContainsCookedData;  // 0x3C
    unsigned int ArContainsCode;  // 0x40
    unsigned int ArContainsMap;  // 0x44
    unsigned int ArForceByteSwapping;  // 0x48
    int ArSerializingDefaults;  // 0x4C
    unsigned int ArIgnoreArchetypeRef;  // 0x50
    unsigned int ArIgnoreOuterRef;  // 0x54
    unsigned int ArIgnoreClassRef;  // 0x58
    int ArAllowEliminatingReferences;  // 0x5C
    unsigned int ArAllowLazyLoading;  // 0x60
    unsigned int ArIsObjectReferenceCollector;  // 0x64
    unsigned int ArIsCountingMemory;  // 0x68
    unsigned long ArPortFlags;  // 0x6C
    unsigned int ArShouldSkipBulkData;  // 0x70
    unsigned int ArIsSaveGame;  // 0x74
    unsigned int ArIsFinalPackageSave;  // 0x78
    int ArMaxSerializeSize;  // 0x7C
    unsigned int ArIsFilterEditorOnly;  // 0x80
    #else
    hg::be<int> ArVer;
    hg::be<int> ArNetVer;
    hg::be<int> ArLicenseeVer;
    hg::be<unsigned int> ArIsLoading;
    hg::be<unsigned int> ArIsSaving;
    hg::be<unsigned int> ArIsTransacting;
    hg::be<unsigned int> ArWantBinaryPropertySerialization;
    hg::be<unsigned int> ArForceUnicode;
    hg::be<unsigned int> ArIsPersistent;
    hg::be<unsigned int> ArForEdit;
    hg::be<unsigned int> ArForClient;
    hg::be<unsigned int> ArForServer;
    hg::be<unsigned int> ArIsError;
    hg::be<unsigned int> ArIsCriticalError;
    hg::be<unsigned int> ArContainsCookedData;
    hg::be<unsigned int> ArContainsCode;
    hg::be<unsigned int> ArContainsMap;
    hg::be<unsigned int> ArForceByteSwapping;
    hg::be<int> ArSerializingDefaults;
    hg::be<unsigned int> ArIgnoreArchetypeRef;
    hg::be<unsigned int> ArIgnoreOuterRef;
    hg::be<unsigned int> ArIgnoreClassRef;
    hg::be<int> ArAllowEliminatingReferences;
    hg::be<unsigned int> ArAllowLazyLoading;
    hg::be<unsigned int> ArIsObjectReferenceCollector;
    hg::be<unsigned int> ArIsCountingMemory;
    hg::be<unsigned long> ArPortFlags;
    hg::be<unsigned int> ArShouldSkipBulkData;
    hg::be<unsigned int> ArIsSaveGame;
    hg::be<unsigned int> ArIsFinalPackageSave;
    hg::be<int> ArMaxSerializeSize;
    hg::be<unsigned int> ArIsFilterEditorOnly;
    #endif
};

template <> class TMapBase<int,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<int,int,0,FDefaultSetAllocator> &operator=(const TMapBase<int,int,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<int,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    int &Set(const int, const int);
    int Remove(const int);
    int RemoveKey(const int);
    const int *FindKey(const int) const;
    const int *Find(const int) const;
    int *Find(const int);
    int &FindOrAdd(const int);
    int &FindOrAddKey(const int);
    int FindRef(const int) const;
    unsigned int HasKey(const int) const;
    void GenerateKeyArray(TArray<int,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<int,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<int,int,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<int,int,0,FDefaultSetAllocator> : public TMapBase<int,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<int,int,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<int,int,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<int,int,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<int,int,FDefaultSetAllocator> : public TSortableMapBase<int,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<int,int,FDefaultSetAllocator> &operator=(const TMap<int,int,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const int, int &);
    #ifndef HAGGAR_HOST
    TMap(const TMap<int,int,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TRefCountPtr<HHitProxy>  // size 0x4, opaque
{
public:
    TRefCountPtr<HHitProxy> &operator=(const TRefCountPtr<HHitProxy> &);
    TRefCountPtr<HHitProxy> &operator=(HHitProxy *);
    unsigned int operator==(const TRefCountPtr<HHitProxy> &) const;
    HHitProxy *operator->() const;
    operator class HHitProxy *() const;
    HHitProxy **GetInitReference();
    HHitProxy *GetReference() const;
    void SafeRelease();
    unsigned long GetRefCount();
    #ifndef HAGGAR_HOST
    TRefCountPtr(const TRefCountPtr<HHitProxy> &);
    TRefCountPtr(HHitProxy *, unsigned int);
    TRefCountPtr();
    ~TRefCountPtr();
    #endif
HG_PRIVATE:
    unsigned int TRefCountPtrData[0x1];
};

class FCanvas  // size 0x90
{
public:
    enum EElementType
    {
        ET_Line = 0,
        ET_Triangle = 1,
        ET_MAX = 2,
    };
    enum ECanvasAllowModes
    {
        Allow_MaskedRegions = 1,
        Allow_DepthTest = 2,
        Allow_Flush = 4,
        Allow_DeleteOnRender = 8,
    };
    struct FMaskRegion;
    class FCanvasSortElement;
    FBatchedElements *GetBatchedElements(FCanvas::EElementType, FBatchedElementParameters *, const FTexture *, ESimpleElementBlendMode, const FDepthFieldGlowInfo &);
    void AddTileRenderItem(float, float, float, float, float, float, float, float, const FMaterialRenderProxy *, FHitProxyId, unsigned int);
    void Flush(unsigned int);
    void PushRelativeTransform(const FMatrix &);
    void PushAbsoluteTransform(const FMatrix &);
    void PopTransform();
    void SetBaseTransform(const FMatrix &);
    static FMatrix CalcBaseTransform2D(unsigned int, unsigned int);
    static FMatrix CalcBaseTransform3D(unsigned int, unsigned int, float, float);
    static FMatrix CalcViewMatrix(unsigned int, unsigned int, float);
    static FMatrix CalcProjectionMatrix(unsigned int, unsigned int, float, float);
    FMatrix GetTransform() const;
    const FMatrix &GetBottomTransform() const;
    const FMatrix &GetFullTransform() const;
    void CopyTransformStack(const FCanvas &);
    void SetDepthTestingEnabled(unsigned int);
    void PushMaskRegion(float, float, float, float);
    void ReplaceMaskRegion(float, float, float, float);
    void PopMaskRegion();
    void SetRenderTarget(FRenderTarget *);
    FRenderTarget *GetRenderTarget() const;
    void SetRenderTargetDirty(unsigned int);
    void SetHitProxy(HHitProxy *);
    FHitProxyId GetHitProxyId() const;
    FHitProxyConsumer *GetHitProxyConsumer() const;
    unsigned int IsHitTesting() const;
    void PushDepthSortKey(int);
    int PopDepthSortKey();
    int TopDepthSortKey();
    void SetAllowedModes(unsigned long);
    unsigned long GetAllowedModes() const;
    unsigned int HasBatchesToRender() const;
    FCanvas::FMaskRegion GetCurrentMaskRegion() const;
HG_PRIVATE:
    FCanvas::FCanvasSortElement &GetSortElement(int);
    void FlushSetMaskRegion();
    void FlushResetMaskRegion();
    unsigned int RegionMaskingAllowed() const;
public:
    #ifndef HAGGAR_HOST
    FCanvas(FRenderTarget *, FHitProxyConsumer *);
    ~FCanvas();
    #endif
    #ifndef HAGGAR_HOST
    float AlphaModulate;  // 0x0
    float CachedTime;  // 0x4
    FRenderTarget *RenderTarget;  // 0x8
    unsigned int bEnableDepthTest;  // 0xC
    unsigned int bRenderTargetDirty;  // 0x10
    FHitProxyConsumer *HitProxyConsumer;  // 0x14
    TRefCountPtr<HHitProxy> CurrentHitProxy;  // 0x18
    TArray<int,FDefaultAllocator> DepthSortKeyStack;  // 0x1C
    char TransformStack[0xC];  // 0x28 TArray<FCanvas::FTransformEntry,FDefaultAllocator>
    unsigned long AllowedModes;  // 0x34
    char MaskRegionStack[0xC];  // 0x38 TArray<FCanvas::FMaskRegion,FDefaultAllocator>
    char SortedElements[0xC];  // 0x44 TArray<FCanvas::FCanvasSortElement,FDefaultAllocator>
    TMap<int,int,FDefaultSetAllocator> SortedElementLookupMap;  // 0x50
    int LastElementIndex;  // 0x8C
    #else
    hg::be<float> AlphaModulate;
    hg::be<float> CachedTime;
    hg::gptr<FRenderTarget> RenderTarget;
    hg::be<unsigned int> bEnableDepthTest;
    hg::be<unsigned int> bRenderTargetDirty;
    hg::gptr<FHitProxyConsumer> HitProxyConsumer;
    TRefCountPtr<HHitProxy> CurrentHitProxy;
    TArray<int,FDefaultAllocator> DepthSortKeyStack;
    char TransformStack[0xC];  // 0x28 TArray<FCanvas::FTransformEntry,FDefaultAllocator>
    hg::be<unsigned long> AllowedModes;
    char MaskRegionStack[0xC];  // 0x38 TArray<FCanvas::FMaskRegion,FDefaultAllocator>
    char SortedElements[0xC];  // 0x44 TArray<FCanvas::FCanvasSortElement,FDefaultAllocator>
    TMap<int,int,FDefaultSetAllocator> SortedElementLookupMap;
    hg::be<int> LastElementIndex;
    #endif
};

template <> class TDoubleLinkedList<UProperty *>  // size 0x10
{
public:
    class TDoubleLinkedListNode;
    HG_VFPTR
public:
    HG_XDK(HG_VIRTUAL ~TDoubleLinkedList();)
HG_PROTECTED:
    HG_VIRTUAL void SetListSize(int);
public:
    unsigned int AddHead(UProperty *const &);
    unsigned int AddTail(UProperty *const &);
    unsigned int InsertNode(UProperty *const &, TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *);
    void RemoveNode(TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *);
    void RemoveNode(UProperty *const &);
    void Clear();
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *GetHead() const;
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *GetTail() const;
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *FindNode(UProperty *const &);
    int Num();
    #ifndef HAGGAR_HOST
    TDoubleLinkedList();
    #endif
    #ifndef HAGGAR_HOST
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *HeadNode;  // 0x4
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *TailNode;  // 0x8
    int ListSize;  // 0xC
    #else
    hg::gptr<TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode> HeadNode;
    hg::gptr<TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode> TailNode;
    hg::be<int> ListSize;
    #endif
};

class FEditPropertyChain : public TDoubleLinkedList<UProperty *>  // size 0x18
{
public:
    unsigned int SetActivePropertyNode(UProperty *);
    unsigned int SetActiveMemberPropertyNode(UProperty *);
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *GetActiveNode() const;
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *GetActiveMemberNode() const;
HG_PROTECTED:
    HG_VIRTUAL void SetListSize(int);
public:
    #ifndef HAGGAR_HOST
    FEditPropertyChain();
    #endif
    #ifndef HAGGAR_HOST
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *ActivePropertyNode;  // 0x10
    TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode *ActiveMemberPropertyNode;  // 0x14
    #else
    hg::gptr<TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode> ActivePropertyNode;
    hg::gptr<TDoubleLinkedList<UProperty *>::TDoubleLinkedListNode> ActiveMemberPropertyNode;
    #endif
};

template <> class TMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> &operator=(const TMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<UObject *,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    TArray<UObject *,FDefaultAllocator> &Set(UObject *, const TArray<UObject *,FDefaultAllocator> &);
    int Remove(const UObject *);
    int RemoveKey(const UObject *);
    UObject *const *FindKey(const TArray<UObject *,FDefaultAllocator> &) const;
    const TArray<UObject *,FDefaultAllocator> *Find(const UObject *) const;
    TArray<UObject *,FDefaultAllocator> *Find(const UObject *);
    TArray<UObject *,FDefaultAllocator> &FindOrAdd(UObject *);
    TArray<UObject *,FDefaultAllocator> &FindOrAddKey(UObject *);
    TArray<UObject *,FDefaultAllocator> FindRef(const UObject *) const;
    unsigned int HasKey(const UObject *) const;
    void GenerateKeyArray(TArray<UObject *,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<TArray<UObject *,FDefaultAllocator>,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> : public TMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<UObject *,TArray<UObject *,FDefaultAllocator>,FDefaultSetAllocator> : public TSortableMapBase<UObject *,TArray<UObject *,FDefaultAllocator>,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<UObject *,TArray<UObject *,FDefaultAllocator>,FDefaultSetAllocator> &operator=(const TMap<UObject *,TArray<UObject *,FDefaultAllocator>,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(UObject *, TArray<UObject *,FDefaultAllocator> &);
    #ifndef HAGGAR_HOST
    TMap(const TMap<UObject *,TArray<UObject *,FDefaultAllocator>,FDefaultSetAllocator> &);
    TMap();
    #endif
};

class FExportObjectInnerContext  // size 0x3C
{
public:
    const TArray<UObject *,FDefaultAllocator> *GetObjectInners(UObject *) const;
    #ifndef HAGGAR_HOST
    FExportObjectInnerContext(const unsigned int);
    FExportObjectInnerContext(TArray<UObject *,FDefaultAllocator> &);
    FExportObjectInnerContext();
    #endif
    #ifndef HAGGAR_HOST
    TMap<UObject *,TArray<UObject *,FDefaultAllocator>,FDefaultSetAllocator> ObjectToInnerMap;  // 0x0
    #else
    TMap<UObject *,TArray<UObject *,FDefaultAllocator>,FDefaultSetAllocator> ObjectToInnerMap;
    #endif
};

class FOutputDevice  // size 0x10
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
    #ifndef HAGGAR_HOST
    unsigned int bAllowSuppression;  // 0x4
    unsigned int bSuppressEventTag;  // 0x8
    unsigned int bAutoEmitLineTerminator;  // 0xC
    #else
    hg::be<unsigned int> bAllowSuppression;
    hg::be<unsigned int> bSuppressEventTag;
    hg::be<unsigned int> bAutoEmitLineTerminator;
    #endif
};

class FString : public TArray<wchar_t,FDefaultAllocator>  // size 0xC
{
public:
    FString &operator=(const FString &);
    FString &operator=(const wchar_t *);
    const wchar_t &operator[](int) const;
    wchar_t &operator[](int);
    void CheckInvariants() const;
    void Empty(int);
    unsigned int IsEmpty() const;
    void Shrink();
    void TrimToNullTerminator();
    FString operator*(const FString &) const;
    FString operator*(const wchar_t *) const;
    const wchar_t *operator*() const;
    const TArray<wchar_t,FDefaultAllocator> &GetCharArray() const;
    TArray<wchar_t,FDefaultAllocator> &GetCharArray();
    FString &operator+=(const FString &);
    FString &operator+=(const wchar_t);
    FString &operator+=(const char *);
    FString &operator+=(const wchar_t *);
    FString &AppendChar(const wchar_t);
    FString operator+(const FString &) const;
    FString operator+(const wchar_t *) const;
    FString operator+(const wchar_t) const;
    FString &operator*=(const FString &);
    FString &operator*=(const wchar_t *);
    unsigned int operator<=(const FString &) const;
    unsigned int operator<=(const wchar_t *) const;
    unsigned int operator<(const FString &) const;
    unsigned int operator<(const wchar_t *) const;
    unsigned int operator>=(const FString &) const;
    unsigned int operator>=(const wchar_t *) const;
    unsigned int operator>(const FString &) const;
    unsigned int operator>(const wchar_t *) const;
    unsigned int operator==(const FString &) const;
    unsigned int operator==(const wchar_t *) const;
    unsigned int operator!=(const FString &) const;
    unsigned int operator!=(const wchar_t *) const;
    int Len() const;
    FString Left(int) const;
    FString LeftChop(int) const;
    FString Right(int) const;
    FString RightChop(int) const;
    FString Mid(int, int) const;
    int InStr(const FString &, unsigned int, unsigned int, int) const;
    int InStr(const wchar_t *, unsigned int, unsigned int, int) const;
    unsigned int Split(const FString &, FString *, FString *, unsigned int) const;
    FString ToUpper() const;
    FString ToLower() const;
    unsigned int ToUBOOL() const;
    FString LeftPad(int) const;
    FString RightPad(int) const;
    unsigned int IsNumeric() const;
    static FString Printf__VA(const wchar_t *, ...);
    static FString Printf(const wchar_t *);
    static FString Chr(wchar_t);
    unsigned int StartsWith(const FString &) const;
    unsigned int EndsWith(const FString &) const;
    FString Trim();
    FString TrimTrailing();
    FString TrimQuotes(unsigned int *) const;
    int ParseIntoArray(TArray<FString,FDefaultAllocator> *, const wchar_t *, unsigned int) const;
    int ParseIntoArrayWS(TArray<FString,FDefaultAllocator> *, const wchar_t *) const;
    static int CullArray(TArray<FString,FDefaultAllocator> *);
    FString Reverse() const;
    void ReverseString();
    FString Replace(const wchar_t *, const wchar_t *, unsigned int) const;
    int ReplaceInline(const wchar_t *, const wchar_t *);
    FString ReplaceQuotesWithEscapedQuotes() const;
    FString ReplaceCharWithEscapedChar(const TArray<wchar_t,FDefaultAllocator> *) const;
    FString ReplaceEscapedCharWithChar(const TArray<wchar_t,FDefaultAllocator> *) const;
    FString ConvertTabsToSpaces(const int);
    static FString FormatAsNumber(int);
    void Reserve(const unsigned int);
    #ifndef HAGGAR_HOST
    FString(ENoInit);
    FString(const char *);
    FString(int, const wchar_t *);
    FString(const wchar_t *);
    FString(const FString &, int);
    FString(const FString &);
    FString();
    #endif
};

class FFeedbackContext : public FOutputDevice  // size 0x34
{
public:
    HG_VIRTUAL unsigned int YesNof__VA(const wchar_t *, ...) HG_PURE;
    HG_VIRTUAL void BeginSlowTask(const wchar_t *, unsigned int, unsigned int) HG_PURE;
    HG_VIRTUAL void EndSlowTask() HG_PURE;
    HG_VIRTUAL unsigned int ReceivedUserCancel();
    HG_VIRTUAL unsigned int StatusUpdatef__VA(int, int, const wchar_t *, ...) HG_PURE;
    HG_VIRTUAL void UpdateProgress(int, int);
    HG_VIRTUAL void PushStatus();
    HG_VIRTUAL void PopStatus();
    HG_VIRTUAL FContextSupplier *GetContext() const;
    HG_VIRTUAL void SetContext(FContextSupplier *);
    HG_VIRTUAL unsigned int MapCheck_IsActive() const;
    HG_VIRTUAL void MapCheck_Show();
    HG_VIRTUAL void MapCheck_ShowConditionally();
    HG_VIRTUAL void MapCheck_Hide();
    HG_VIRTUAL void MapCheck_Clear();
    HG_VIRTUAL void MapCheck_BeginBulkAdd();
    HG_VIRTUAL void MapCheck_Add(MapCheckType, UObject *, const wchar_t *, const wchar_t *, MapCheckGroup);
    HG_VIRTUAL void MapCheck_EndBulkAdd();
    HG_VIRTUAL unsigned int LightingBuild_IsActive() const;
    HG_VIRTUAL void LightingBuild_Show();
    HG_VIRTUAL void LightingBuild_ShowConditionally();
    HG_VIRTUAL void LightingBuild_Hide();
    HG_VIRTUAL void LightingBuild_Clear();
    HG_VIRTUAL void LightingBuild_BeginBulkAdd();
    HG_VIRTUAL void LightingBuild_Add(MapCheckType, UObject *, const wchar_t *, const wchar_t *, MapCheckGroup);
    HG_VIRTUAL void LightingBuild_EndBulkAdd();
    HG_VIRTUAL void LightingBuild_Refresh();
    HG_VIRTUAL unsigned int LightingBuildInfo_IsActive() const;
    HG_VIRTUAL void LightingBuildInfo_Show();
    HG_VIRTUAL void LightingBuildInfo_Hide();
    HG_VIRTUAL void LightingBuildInfo_Clear();
    HG_VIRTUAL void LightingBuildInfo_BeginBulkAdd();
    HG_VIRTUAL void LightingBuildInfo_Add(UObject *, double, float, int, int);
    HG_VIRTUAL void LightingBuildInfo_EndBulkAdd();
    HG_VIRTUAL void LightingBuildInfo_Refresh();
    HG_VIRTUAL void LightingBuildInfoList_Clear();
    unsigned int YesNof(const wchar_t *);
    unsigned int StatusUpdatef(int, int, const wchar_t *);
    #ifndef HAGGAR_HOST
    FFeedbackContext();
    #endif
    #ifndef HAGGAR_HOST
    TArray<FString,FDefaultAllocator> Warnings;  // 0x10
    TArray<FString,FDefaultAllocator> Errors;  // 0x1C
    unsigned int TreatWarningsAsErrors;  // 0x28
    int winEditorFrame;  // 0x2C
    int hWndEditorFrame;  // 0x30
    #else
    TArray<FString,FDefaultAllocator> Warnings;
    TArray<FString,FDefaultAllocator> Errors;
    hg::be<unsigned int> TreatWarningsAsErrors;
    hg::be<int> winEditorFrame;
    hg::be<int> hWndEditorFrame;
    #endif
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

struct FGCReferenceTokenStream  // size 0xC, opaque
{
public:
    enum EGCArrayInfoPlaceholder
    {
        E_GCSkipIndexPlaceholder = -559039810,
    };
    void Shrink();
    void PrependStream(const FGCReferenceTokenStream &);
    void EmitReferenceInfo(FGCReferenceInfo);
    unsigned long EmitSkipIndexPlaceholder();
    void UpdateSkipIndexPlaceholder(unsigned long, unsigned long);
    void EmitCount(unsigned long);
    void EmitStride(unsigned long);
    unsigned long EmitReturn();
    unsigned long ReadCount(unsigned long &);
    unsigned long ReadStride(unsigned long &);
    FGCReferenceInfo ReadReferenceInfo(unsigned long &);
    FGCReferenceInfo AccessReferenceInfo(unsigned long) const;
    FGCSkipInfo ReadSkipInfo(unsigned long &);
    unsigned long GetSkipReturnCount(FGCSkipInfo);
    unsigned int EndOfStream(unsigned long);
    #ifndef HAGGAR_HOST
    FGCReferenceTokenStream();
    #endif
HG_PRIVATE:
    unsigned int FGCReferenceTokenStreamData[0x3];
};

class FGuid  // size 0x10
{
public:
    unsigned int IsValid() const;
    void Invalidate();
    const unsigned long &operator[](int) const;
    unsigned long &operator[](int);
    FString String() const;
    unsigned int InitFromString(const FString &);
    #ifndef HAGGAR_HOST
    FGuid(EEventParm);
    FGuid(unsigned long, unsigned long, unsigned long, unsigned long);
    FGuid();
    #endif
    #ifndef HAGGAR_HOST
    unsigned long A;  // 0x0
    unsigned long B;  // 0x4
    unsigned long C;  // 0x8
    unsigned long D;  // 0xC
    #else
    hg::be<unsigned long> A;
    hg::be<unsigned long> B;
    hg::be<unsigned long> C;
    hg::be<unsigned long> D;
    #endif
};

struct FImplementedInterface  // size 0x8, opaque
{
public:
    #ifndef HAGGAR_HOST
    FImplementedInterface(UClass *, UProperty *);
    FImplementedInterface();
    #endif
HG_PRIVATE:
    unsigned int FImplementedInterfaceData[0x2];
};

struct FLevelGuids  // size 0x14, opaque
{
HG_PRIVATE:
    unsigned int FLevelGuidsData[0x5];
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

struct FNodeChild  // size 0x14, opaque
{
public:
    #ifndef HAGGAR_HOST
    FNodeChild(EEventParm);
    FNodeChild();
    #endif
HG_PRIVATE:
    unsigned int FNodeChildData[0x5];
};

template <> class TMapBase<UObject *,UObject *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<UObject *,UObject *,0,FDefaultSetAllocator> &operator=(const TMapBase<UObject *,UObject *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<UObject *,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    UObject *&Set(UObject *, UObject *);
    int Remove(const UObject *);
    int RemoveKey(const UObject *);
    UObject *const *FindKey(UObject *) const;
    UObject *const *Find(const UObject *) const;
    UObject **Find(const UObject *);
    UObject *&FindOrAdd(UObject *);
    UObject *&FindOrAddKey(UObject *);
    UObject *FindRef(const UObject *) const;
    unsigned int HasKey(const UObject *) const;
    void GenerateKeyArray(TArray<UObject *,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<UObject *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<UObject *,UObject *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<UObject *,UObject *,0,FDefaultSetAllocator> : public TMapBase<UObject *,UObject *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<UObject *,UObject *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<UObject *,UObject *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<UObject *,UObject *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<UObject *,UObject *,FDefaultSetAllocator> : public TSortableMapBase<UObject *,UObject *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<UObject *,UObject *,FDefaultSetAllocator> &operator=(const TMap<UObject *,UObject *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(UObject *, UObject *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<UObject *,UObject *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

struct FObjectDuplicationParameters  // size 0x68
{
public:
    #ifndef HAGGAR_HOST
    FObjectDuplicationParameters(UObject *, UObject *);
    #endif
    #ifndef HAGGAR_HOST
    UObject *SourceObject;  // 0x0
    UObject *DestOuter;  // 0x4
    FName DestName;  // 0x8
    unsigned __int64 FlagMask;  // 0x10
    unsigned __int64 ApplyFlags;  // 0x18
    UClass *DestClass;  // 0x20
    unsigned int bMigrateArchetypes;  // 0x24
    TMap<UObject *,UObject *,FDefaultSetAllocator> DuplicationSeed;  // 0x28
    TMap<UObject *,UObject *,FDefaultSetAllocator> *CreatedObjects;  // 0x64
    #else
    hg::gptr<UObject> SourceObject;
    hg::gptr<UObject> DestOuter;
    FName DestName;
    hg::be<unsigned __int64> FlagMask;
    hg::be<unsigned __int64> ApplyFlags;
    hg::gptr<UClass> DestClass;
    hg::be<unsigned int> bMigrateArchetypes;
    TMap<UObject *,UObject *,FDefaultSetAllocator> DuplicationSeed;
    hg::gptr<TMap<UObject *,UObject *,FDefaultSetAllocator>> CreatedObjects;
    #endif
};

struct FObjectResource  // size 0xC, opaque
{
public:
    #ifndef HAGGAR_HOST
    FObjectResource(UObject *);
    FObjectResource();
    #endif
HG_PRIVATE:
    unsigned int FObjectResourceData[0x3];
};

struct FObjectExport : public FObjectResource  // size 0x5C, opaque
{
public:
    unsigned long GetFlags() const;
    void SetFlags(unsigned long);
    void ClearFlags(unsigned long);
    unsigned int HasAnyFlags(unsigned long) const;
    unsigned int HasAllFlags(unsigned long) const;
    unsigned long GetMaskedFlags(unsigned long) const;
    #ifndef HAGGAR_HOST
    FObjectExport(UObject *);
    FObjectExport();
    #endif
HG_PRIVATE:
    unsigned int FObjectExportData[0x14];
};

struct FObjectImport : public FObjectResource  // size 0x28, opaque
{
public:
    #ifndef HAGGAR_HOST
    FObjectImport(UObject *);
    FObjectImport();
    #endif
HG_PRIVATE:
    unsigned int FObjectImportData[0x7];
};

template <> class TMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> &operator=(const TMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<UComponent *,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    UComponent *&Set(UComponent *, UComponent *);
    int Remove(const UComponent *);
    int RemoveKey(const UComponent *);
    UComponent *const *FindKey(UComponent *) const;
    UComponent *const *Find(const UComponent *) const;
    UComponent **Find(const UComponent *);
    UComponent *&FindOrAdd(UComponent *);
    UComponent *&FindOrAddKey(UComponent *);
    UComponent *FindRef(const UComponent *) const;
    unsigned int HasKey(const UComponent *) const;
    void GenerateKeyArray(TArray<UComponent *,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<UComponent *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> : public TMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<UComponent *,UComponent *,FDefaultSetAllocator> : public TSortableMapBase<UComponent *,UComponent *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<UComponent *,UComponent *,FDefaultSetAllocator> &operator=(const TMap<UComponent *,UComponent *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(UComponent *, UComponent *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<UComponent *,UComponent *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

struct FObjectInstancingGraph  // size 0x98
{
public:
    unsigned int IsInitialized() const;
    void SetDestinationRoot(UObject *, UObject *);
    UObject *GetDestinationObject(UObject *, unsigned int);
    UComponent *GetInstancedComponent(UComponent *, UComponent *, UObject *);
    UObject *GetDestinationRoot() const;
    UObject *GetSourceRoot() const;
    void AddObjectPair(UObject *, UObject *);
    void AddComponentPair(UComponent *, UComponent *);
    void RemoveComponent(UComponent *);
    void ClearComponentMap();
    void RetrieveObjectInstances(UObject *, TArray<UObject *,FDefaultAllocator> &, unsigned int);
    void RetrieveComponents(UObject *, TArray<UComponent *,FDefaultAllocator> &, unsigned int);
    void EnableComponentInstancing(unsigned int);
    void EnableObjectInstancing(unsigned int);
    unsigned int IsObjectInstancingEnabled() const;
    unsigned int IsComponentInstancingEnabled() const;
    void SetLoadingObject(unsigned int);
    unsigned int IsLoadingObject() const;
    unsigned int IsCreatingArchetype(unsigned int) const;
    unsigned int IsUpdatingArchetype() const;
    const TMap<UObject *,UObject *,FDefaultSetAllocator> *GetSourceToDestinationMap() const;
    #ifndef HAGGAR_HOST
    FObjectInstancingGraph(UObject *, UObject *);
    FObjectInstancingGraph();
    #endif
    #ifndef HAGGAR_HOST
    UObject *SourceRoot;  // 0x0
    UObject *DestinationRoot;  // 0x4
    unsigned long InstanceFlags;  // 0x8
    unsigned int bCreatingArchetype;  // 0xC
    unsigned int bUpdatingArchetype;  // 0x10
    unsigned int bEnableComponentInstancing;  // 0x14
    unsigned int bEnableObjectInstancing;  // 0x18
    unsigned int bLoadingObject;  // 0x1C
    TMap<UObject *,UObject *,FDefaultSetAllocator> SourceToDestinationMap;  // 0x20
    TMap<UComponent *,UComponent *,FDefaultSetAllocator> ComponentInstanceMap;  // 0x5C
    #else
    hg::gptr<UObject> SourceRoot;
    hg::gptr<UObject> DestinationRoot;
    hg::be<unsigned long> InstanceFlags;
    hg::be<unsigned int> bCreatingArchetype;
    hg::be<unsigned int> bUpdatingArchetype;
    hg::be<unsigned int> bEnableComponentInstancing;
    hg::be<unsigned int> bEnableObjectInstancing;
    hg::be<unsigned int> bLoadingObject;
    TMap<UObject *,UObject *,FDefaultSetAllocator> SourceToDestinationMap;
    TMap<UComponent *,UComponent *,FDefaultSetAllocator> ComponentInstanceMap;
    #endif
};

struct FPackageFileSummary  // size 0xA4, opaque
{
public:
    int GetFileVersion() const;
    int GetFileVersionLicensee() const;
    int GetCookedContentVersion() const;
    void SetFileVersions(int, int);
    #ifndef HAGGAR_HOST
    FPackageFileSummary();
    #endif
HG_PRIVATE:
    unsigned int FPackageFileSummaryData[0x29];
};

class FPackageInfo  // size 0x50, opaque
{
public:
    #ifndef HAGGAR_HOST
    FPackageInfo(UPackage *);
    #endif
HG_PRIVATE:
    unsigned int FPackageInfoData[0x14];
};

struct FPropertyChangedEvent  // size 0x14
{
public:
    void SetArrayIndexPerObject(const TArray<TMap<FString,int,FDefaultSetAllocator>,FDefaultAllocator> &);
    int GetArrayIndex(const FString &);
    #ifndef HAGGAR_HOST
    FPropertyChangedEvent(UProperty *, const unsigned int, unsigned int);
    #endif
    #ifndef HAGGAR_HOST
    UProperty *Property;  // 0x0
    unsigned int bChangesTopology;  // 0x4
    unsigned int ChangeType;  // 0x8
    int ObjectIteratorIndex;  // 0xC
    const TArray<TMap<FString,int,FDefaultSetAllocator>,FDefaultAllocator> *ArrayIndicesPerObject;  // 0x10
    #else
    hg::gptr<UProperty> Property;
    hg::be<unsigned int> bChangesTopology;
    hg::be<unsigned int> ChangeType;
    hg::be<int> ObjectIteratorIndex;
    hg::gptr<const TArray<TMap<FString,int,FDefaultSetAllocator>,FDefaultAllocator>> ArrayIndicesPerObject;
    #endif
};

struct FPropertyChangedChainEvent : public FPropertyChangedEvent  // size 0x18
{
public:
    #ifndef HAGGAR_HOST
    FPropertyChangedChainEvent(FEditPropertyChain &, FPropertyChangedEvent &);
    #endif
    #ifndef HAGGAR_HOST
    FEditPropertyChain &PropertyChain;  // 0x14
    #else
    hg::gptr<FEditPropertyChain> PropertyChain;
    #endif
};

struct FReferencerInformation  // size 0x14, opaque
{
public:
    #ifndef HAGGAR_HOST
    FReferencerInformation(UObject *, int, const TArray<UProperty *,FDefaultAllocator> &);
    #endif
HG_PRIVATE:
    unsigned int FReferencerInformationData[0x5];
};

struct FReferencerInformationList  // size 0x18
{
public:
    #ifndef HAGGAR_HOST
    FReferencerInformationList(const TArray<FReferencerInformation,FDefaultAllocator> &, const TArray<FReferencerInformation,FDefaultAllocator> &);
    FReferencerInformationList();
    #endif
    #ifndef HAGGAR_HOST
    TArray<FReferencerInformation,FDefaultAllocator> InternalReferences;  // 0x0
    TArray<FReferencerInformation,FDefaultAllocator> ExternalReferences;  // 0xC
    #else
    TArray<FReferencerInformation,FDefaultAllocator> InternalReferences;
    TArray<FReferencerInformation,FDefaultAllocator> ExternalReferences;
    #endif
};

struct FRepRecord  // size 0x8, opaque
{
public:
    #ifndef HAGGAR_HOST
    FRepRecord(UProperty *, int);
    #endif
HG_PRIVATE:
    unsigned int FRepRecordData[0x2];
};

struct FScriptDelegate  // size 0xC
{
public:
    unsigned int IsCallable(const UObject *) const;
    FString ToString(const UObject *) const;
    unsigned int operator==(const FScriptDelegate &) const;
    unsigned int operator!=(const FScriptDelegate &) const;
    #ifndef HAGGAR_HOST
    FScriptDelegate(EEventParm);
    FScriptDelegate();
    #endif
    #ifndef HAGGAR_HOST
    UObject *Object;  // 0x0
    FName FunctionName;  // 0x4
    #else
    hg::gptr<UObject> Object;
    FName FunctionName;
    #endif
};

struct FStateFrame : public FFrame  // size 0x44
{
public:
    FStateFrame &operator=(const FStateFrame &);
    FString Describe();
    void InitLocalVars(UClass *);
    void ClearLocalVars();
    #ifndef HAGGAR_HOST
    FStateFrame(UObject *);
    FStateFrame(const FStateFrame &);
    HG_VIRTUAL ~FStateFrame();
    #endif
    #ifndef HAGGAR_HOST
    UState *StateNode;  // 0x28
    unsigned long ProbeMask;  // 0x2C
    unsigned short LatentAction;  // 0x30
    unsigned char bContinuedState;  // 0x32
    char _pad0[0x1];
    char StateStack[0xC];  // 0x34 TArray<FStateFrame::FPushedState,FDefaultAllocator>
    UClass *LocalVarsOwner;  // 0x40
    #else
    hg::gptr<UState> StateNode;
    hg::be<unsigned long> ProbeMask;
    hg::be<unsigned short> LatentAction;
    unsigned char bContinuedState;
    char _pad0[0x1];
    char StateStack[0xC];  // 0x34 TArray<FStateFrame::FPushedState,FDefaultAllocator>
    hg::gptr<UClass> LocalVarsOwner;
    #endif
};

struct FStringNoInit : public FString  // size 0xC
{
public:
    FStringNoInit &operator=(const FString &);
    FStringNoInit &operator=(const wchar_t *);
    #ifndef HAGGAR_HOST
    FStringNoInit(EForceInit);
    FStringNoInit();
    #endif
};

namespace Grip {
class String  // size 0x4, opaque
{
public:
    enum FlagConstants
    {
        Flag_LengthIsSizeShift = 31,
    };
    struct DataDesc;
    enum HeapType
    {
        HT_Global = 0,
        HT_Local = 1,
        HT_Dynamic = 2,
        HT_Mask = 3,
    };
    struct NoConstructor;
    struct InitStruct;
    struct NoCaseKey;
HG_PROTECTED:
    Grip::String::HeapType GetHeapType() const;
    Grip::String::DataDesc *GetData() const;
    void SetData(Grip::String::DataDesc *);
    Grip::String::DataDesc *AllocData(Grip::MemoryHeap *, unsigned int, unsigned int);
    Grip::String::DataDesc *AllocDataCopy1(Grip::MemoryHeap *, unsigned int, unsigned int, const char *, unsigned int);
    Grip::String::DataDesc *AllocDataCopy2(Grip::MemoryHeap *, unsigned int, unsigned int, const char *, unsigned int, const char *, unsigned int);
public:
    Grip::MemoryHeap *GetHeap() const;
    void Clear();
    operator const char *() const;
    const char *ToCStr() const;
    unsigned int GetSize() const;
    bool IsEmpty() const;
    unsigned int GetLength() const;
    unsigned long GetCharAt(unsigned int) const;
    unsigned long GetFirstCharAt(unsigned int, const char **) const;
    unsigned long GetNextChar(const char **) const;
    void AppendChar(unsigned long);
    void AppendString(const char *, int);
    void AppendString(const wchar_t *, int);
    void AssignString(const char *, unsigned int);
    void AssignString(const Grip::String::InitStruct &, unsigned int);
    void Remove(unsigned int, int);
    Grip::String Substring(unsigned int, unsigned int) const;
    Grip::String ToUpper() const;
    Grip::String ToLower() const;
    Grip::String &Insert(const char *, unsigned int, int);
    unsigned int InsertCharAt(unsigned long, unsigned int);
    unsigned int GetByteIndex(unsigned int) const;
    int CompareNoCase(const Grip::String &) const;
    int CompareNoCase(const char *) const;
    static int CompareNoCase(const char *, const char *, int);
    static int CompareNoCase(const char *, const char *);
    static unsigned int BernsteinHashFunctionCIS(const void *, unsigned int, unsigned int);
    static unsigned int BernsteinHashFunction(const void *, unsigned int, unsigned int);
    static void EscapeSpecialHTML(const char *, unsigned int, Grip::String *);
    static void UnescapeSpecialHTML(const char *, unsigned int, Grip::String *);
    bool HasAbsolutePath() const;
    static bool HasAbsolutePath(const char *);
    bool HasExtension() const;
    static bool HasExtension(const char *);
    bool HasProtocol() const;
    static bool HasProtocol(const char *);
    Grip::String GetProtocol() const;
    Grip::String GetPath() const;
    Grip::String GetFilename() const;
    Grip::String GetExtension() const;
    void StripProtocol();
    void StripExtension();
    void operator=(const Grip::StringBuffer &);
    void operator=(const Grip::String &);
    void operator=(const wchar_t *);
    void operator=(const char *);
    void operator+=(char);
    void operator+=(const wchar_t *);
    void operator+=(const char *);
    void operator+=(const Grip::String &);
    Grip::String operator+(const Grip::String &) const;
    Grip::String operator+(const char *) const;
    bool operator==(const Grip::String::NoCaseKey &) const;
    bool operator==(const char *) const;
    bool operator==(const Grip::String &) const;
    bool operator!=(const Grip::String::NoCaseKey &) const;
    bool operator!=(const char *) const;
    bool operator!=(const Grip::String &) const;
    bool operator<(const Grip::String &) const;
    bool operator<(const char *) const;
    bool operator>(const Grip::String &) const;
    bool operator>(const char *) const;
    const char &operator[](unsigned int) const;
    const char &operator[](int) const;
    #ifndef HAGGAR_HOST
    static void *operator new(unsigned int, void *);
    static void operator delete(void *, void *);
    String(const wchar_t *);
    String(const Grip::String::InitStruct &, unsigned int);
    String(const Grip::StringBuffer &);
    String(const Grip::String &);
    String(const char *, unsigned int);
    String(const char *, const char *, const char *);
    String(const char *);
    String();
HG_PROTECTED:
    String(const Grip::String::NoConstructor &);
public:
    ~String();
    #endif
    #ifndef HAGGAR_HOST
    static Grip::String::DataDesc NullData;
    #else
    static Grip::String::DataDesc (&NullData);
    #endif
HG_PRIVATE:
    unsigned int StringData[0x1];
};
}

class GripVHeapObject  // size 0x4
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

class GripRBTNode : public GripVHeapObject  // size 0x64
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
    GripRBTNode *m_children[16];  // 0x4
    int m_nbChildren;  // 0x44
    int m_nodeID;  // 0x48
    float m_weight;  // 0x4C
    GripRBTNode::EBTExecutionResult m_lastExecutionResult;  // 0x50
    GripRBTNode::EBTEvaluationResult m_lastEvaluationResult;  // 0x54
    GripRBTNode::EBTExecutionResult m_execResultVisualization;  // 0x58
    Grip::String m_name;  // 0x5C
    bool m_isContextSwitch;  // 0x60
    char _pad0[0x3];
    #else
    static hg::be<int> (&ms_IDCounter);
    static hg::gptr<GripRBTAllocator> (&ms_pAllocator);
    hg::gptr<GripRBTNode> m_children[16];
    hg::be<int> m_nbChildren;
    hg::be<int> m_nodeID;
    hg::be<float> m_weight;
    hg::be<GripRBTNode::EBTExecutionResult> m_lastExecutionResult;
    hg::be<GripRBTNode::EBTEvaluationResult> m_lastEvaluationResult;
    hg::be<GripRBTNode::EBTExecutionResult> m_execResultVisualization;
    Grip::String m_name;
    bool m_isContextSwitch;
    char _pad0[0x3];
    #endif
};

template <> class TMapBase<FGuid,UObject *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<FGuid,UObject *,0,FDefaultSetAllocator> &operator=(const TMapBase<FGuid,UObject *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<FGuid,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    UObject *&Set(const FGuid &, UObject *);
    int Remove(const FGuid &);
    int RemoveKey(const FGuid &);
    const FGuid *FindKey(UObject *) const;
    UObject *const *Find(const FGuid &) const;
    UObject **Find(const FGuid &);
    UObject *&FindOrAdd(const FGuid &);
    UObject *&FindOrAddKey(const FGuid &);
    UObject *FindRef(const FGuid &) const;
    unsigned int HasKey(const FGuid &) const;
    void GenerateKeyArray(TArray<FGuid,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<UObject *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<FGuid,UObject *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<FGuid,UObject *,0,FDefaultSetAllocator> : public TMapBase<FGuid,UObject *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<FGuid,UObject *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<FGuid,UObject *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<FGuid,UObject *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<FGuid,UObject *,FDefaultSetAllocator> : public TSortableMapBase<FGuid,UObject *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<FGuid,UObject *,FDefaultSetAllocator> &operator=(const TMap<FGuid,UObject *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const FGuid &, UObject *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<FGuid,UObject *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<FGuid,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<FGuid,int,0,FDefaultSetAllocator> &operator=(const TMapBase<FGuid,int,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<FGuid,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    int &Set(const FGuid &, const int);
    int Remove(const FGuid &);
    int RemoveKey(const FGuid &);
    const FGuid *FindKey(const int) const;
    const int *Find(const FGuid &) const;
    int *Find(const FGuid &);
    int &FindOrAdd(const FGuid &);
    int &FindOrAddKey(const FGuid &);
    int FindRef(const FGuid &) const;
    unsigned int HasKey(const FGuid &) const;
    void GenerateKeyArray(TArray<FGuid,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<int,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<FGuid,int,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<FGuid,int,0,FDefaultSetAllocator> : public TMapBase<FGuid,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<FGuid,int,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<FGuid,int,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<FGuid,int,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<FGuid,int,FDefaultSetAllocator> : public TSortableMapBase<FGuid,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<FGuid,int,FDefaultSetAllocator> &operator=(const TMap<FGuid,int,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const FGuid &, int &);
    #ifndef HAGGAR_HOST
    TMap(const TMap<FGuid,int,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<FName,UComponent *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<FName,UComponent *,0,FDefaultSetAllocator> &operator=(const TMapBase<FName,UComponent *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<FName,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    UComponent *&Set(const FName &, UComponent *);
    int Remove(const FName &);
    int RemoveKey(const FName &);
    const FName *FindKey(UComponent *) const;
    UComponent *const *Find(const FName &) const;
    UComponent **Find(const FName &);
    UComponent *&FindOrAdd(const FName &);
    UComponent *&FindOrAddKey(const FName &);
    UComponent *FindRef(const FName &) const;
    unsigned int HasKey(const FName &) const;
    void GenerateKeyArray(TArray<FName,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<UComponent *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<FName,UComponent *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<FName,UComponent *,0,FDefaultSetAllocator> : public TMapBase<FName,UComponent *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<FName,UComponent *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<FName,UComponent *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<FName,UComponent *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<FName,UComponent *,FDefaultSetAllocator> : public TSortableMapBase<FName,UComponent *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<FName,UComponent *,FDefaultSetAllocator> &operator=(const TMap<FName,UComponent *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const FName &, UComponent *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<FName,UComponent *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<FName,UFunction *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<FName,UFunction *,0,FDefaultSetAllocator> &operator=(const TMapBase<FName,UFunction *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<FName,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    UFunction *&Set(const FName &, UFunction *);
    int Remove(const FName &);
    int RemoveKey(const FName &);
    const FName *FindKey(UFunction *) const;
    UFunction *const *Find(const FName &) const;
    UFunction **Find(const FName &);
    UFunction *&FindOrAdd(const FName &);
    UFunction *&FindOrAddKey(const FName &);
    UFunction *FindRef(const FName &) const;
    unsigned int HasKey(const FName &) const;
    void GenerateKeyArray(TArray<FName,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<UFunction *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<FName,UFunction *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<FName,UFunction *,0,FDefaultSetAllocator> : public TMapBase<FName,UFunction *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<FName,UFunction *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<FName,UFunction *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<FName,UFunction *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<FName,UFunction *,FDefaultSetAllocator> : public TSortableMapBase<FName,UFunction *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<FName,UFunction *,FDefaultSetAllocator> &operator=(const TMap<FName,UFunction *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const FName &, UFunction *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<FName,UFunction *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<FName,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<FName,int,0,FDefaultSetAllocator> &operator=(const TMapBase<FName,int,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<FName,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    int &Set(const FName &, const int);
    int Remove(const FName &);
    int RemoveKey(const FName &);
    const FName *FindKey(const int) const;
    const int *Find(const FName &) const;
    int *Find(const FName &);
    int &FindOrAdd(const FName &);
    int &FindOrAddKey(const FName &);
    int FindRef(const FName &) const;
    unsigned int HasKey(const FName &) const;
    void GenerateKeyArray(TArray<FName,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<int,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<FName,int,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<FName,int,0,FDefaultSetAllocator> : public TMapBase<FName,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<FName,int,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<FName,int,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<FName,int,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<FName,int,FDefaultSetAllocator> : public TSortableMapBase<FName,int,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<FName,int,FDefaultSetAllocator> &operator=(const TMap<FName,int,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const FName &, int &);
    #ifndef HAGGAR_HOST
    TMap(const TMap<FName,int,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> &operator=(const TMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<UClass *,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    FClassNetCache *&Set(UClass *, FClassNetCache *);
    int Remove(const UClass *);
    int RemoveKey(const UClass *);
    UClass *const *FindKey(FClassNetCache *) const;
    FClassNetCache *const *Find(const UClass *) const;
    FClassNetCache **Find(const UClass *);
    FClassNetCache *&FindOrAdd(UClass *);
    FClassNetCache *&FindOrAddKey(UClass *);
    FClassNetCache *FindRef(const UClass *) const;
    unsigned int HasKey(const UClass *) const;
    void GenerateKeyArray(TArray<UClass *,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<FClassNetCache *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> : public TMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<UClass *,FClassNetCache *,FDefaultSetAllocator> : public TSortableMapBase<UClass *,FClassNetCache *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<UClass *,FClassNetCache *,FDefaultSetAllocator> &operator=(const TMap<UClass *,FClassNetCache *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(UClass *, FClassNetCache *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<UClass *,FClassNetCache *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> &operator=(const TMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<int,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    FEnumPatchData *&Set(const int, FEnumPatchData *);
    int Remove(const int);
    int RemoveKey(const int);
    const int *FindKey(FEnumPatchData *) const;
    FEnumPatchData *const *Find(const int) const;
    FEnumPatchData **Find(const int);
    FEnumPatchData *&FindOrAdd(const int);
    FEnumPatchData *&FindOrAddKey(const int);
    FEnumPatchData *FindRef(const int) const;
    unsigned int HasKey(const int) const;
    void GenerateKeyArray(TArray<int,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<FEnumPatchData *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> : public TMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<int,FEnumPatchData *,FDefaultSetAllocator> : public TSortableMapBase<int,FEnumPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<int,FEnumPatchData *,FDefaultSetAllocator> &operator=(const TMap<int,FEnumPatchData *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const int, FEnumPatchData *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<int,FEnumPatchData *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<int,FPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<int,FPatchData *,0,FDefaultSetAllocator> &operator=(const TMapBase<int,FPatchData *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<int,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    FPatchData *&Set(const int, FPatchData *);
    int Remove(const int);
    int RemoveKey(const int);
    const int *FindKey(FPatchData *) const;
    FPatchData *const *Find(const int) const;
    FPatchData **Find(const int);
    FPatchData *&FindOrAdd(const int);
    FPatchData *&FindOrAddKey(const int);
    FPatchData *FindRef(const int) const;
    unsigned int HasKey(const int) const;
    void GenerateKeyArray(TArray<int,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<FPatchData *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<int,FPatchData *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<int,FPatchData *,0,FDefaultSetAllocator> : public TMapBase<int,FPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<int,FPatchData *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<int,FPatchData *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<int,FPatchData *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<int,FPatchData *,FDefaultSetAllocator> : public TSortableMapBase<int,FPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<int,FPatchData *,FDefaultSetAllocator> &operator=(const TMap<int,FPatchData *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const int, FPatchData *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<int,FPatchData *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> &operator=(const TMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> &);
    void Empty(int);
    void Reset();
    void Shrink();
    void Compact();
    int Num() const;
    int GetKeys(TLookupMap<int,FDefaultSetAllocator> &) const;
    unsigned long GetAllocatedSize() const;
    void CountBytes(FArchive &);
    FScriptPatchData *&Set(const int, FScriptPatchData *);
    int Remove(const int);
    int RemoveKey(const int);
    const int *FindKey(FScriptPatchData *) const;
    FScriptPatchData *const *Find(const int) const;
    FScriptPatchData **Find(const int);
    FScriptPatchData *&FindOrAdd(const int);
    FScriptPatchData *&FindOrAddKey(const int);
    FScriptPatchData *FindRef(const int) const;
    unsigned int HasKey(const int) const;
    void GenerateKeyArray(TArray<int,FDefaultAllocator> &) const;
    void GenerateValueArray(TArray<FScriptPatchData *,FDefaultAllocator> &) const;
    void Dump(FOutputDevice &);
    #ifndef HAGGAR_HOST
    TMapBase(const TMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> &);
    TMapBase();
    #endif
HG_PRIVATE:
    unsigned int TMapBaseData[0xF];
};

template <> class TSortableMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> : public TMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TSortableMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> &operator=(const TSortableMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> &);
    #ifndef HAGGAR_HOST
    TSortableMapBase(const TSortableMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator> &);
    TSortableMapBase();
    #endif
};

template <> class TMap<int,FScriptPatchData *,FDefaultSetAllocator> : public TSortableMapBase<int,FScriptPatchData *,0,FDefaultSetAllocator>  // size 0x3C, opaque
{
public:
    TMap<int,FScriptPatchData *,FDefaultSetAllocator> &operator=(const TMap<int,FScriptPatchData *,FDefaultSetAllocator> &);
    unsigned int RemoveAndCopyValue(const int, FScriptPatchData *&);
    #ifndef HAGGAR_HOST
    TMap(const TMap<int,FScriptPatchData *,FDefaultSetAllocator> &);
    TMap();
    #endif
};

template <> class TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> >  // size 0x4, opaque
{
public:
    TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> > &operator=(const TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> > &);
    TMap<FName,FObjectThumbnail,FDefaultSetAllocator> &operator*() const;
    TMap<FName,FObjectThumbnail,FDefaultSetAllocator> *operator->() const;
    TMap<FName,FObjectThumbnail,FDefaultSetAllocator> *GetOwnedPointer() const;
    unsigned int IsValid() const;
    operator class TMap<class FName,class FObjectThumbnail,class FDefaultSetAllocator> *() const;
    void Swap(TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> > &);
    void Reset(TMap<FName,FObjectThumbnail,FDefaultSetAllocator> *);
    TMap<FName,FObjectThumbnail,FDefaultSetAllocator> *Release();
    #ifndef HAGGAR_HOST
    TScopedPointer(const TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> > &);
    TScopedPointer(TMap<FName,FObjectThumbnail,FDefaultSetAllocator> *);
    ~TScopedPointer();
    #endif
HG_PRIVATE:
    unsigned int TScopedPointerData[0x1];
};

class UObject  // size 0x3C
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
    UObject *HashNext;  // 0x4
    unsigned __int64 ObjectFlags;  // 0x8
    UObject *HashOuterNext;  // 0x10
    FStateFrame *StateFrame;  // 0x14
    ULinkerLoad *_Linker;  // 0x18
    int _LinkerIndex;  // 0x1C
    int Index;  // 0x20
    int NetIndex;  // 0x24
    UObject *Outer;  // 0x28
    FName Name;  // 0x2C
    UClass *Class;  // 0x34
    UObject *ObjectArchetype;  // 0x38
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
    hg::gptr<UObject> HashNext;
    hg::be<unsigned __int64> ObjectFlags;
    hg::gptr<UObject> HashOuterNext;
    hg::gptr<FStateFrame> StateFrame;
    hg::gptr<ULinkerLoad> _Linker;
    hg::be<int> _LinkerIndex;
    hg::be<int> Index;
    hg::be<int> NetIndex;
    hg::gptr<UObject> Outer;
    FName Name;
    hg::gptr<UClass> Class;
    hg::gptr<UObject> ObjectArchetype;
    #endif
};

class UField : public UObject  // size 0x40
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
    UField *Next;  // 0x3C
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<UField> Next;
    #endif
};

class UProperty : public UField  // size 0x64
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    HG_VIRTUAL FString GetCPPMacroType(FString &) const;
    HG_VIRTUAL FString GetCPPType(FString *, unsigned long) const;
    HG_VIRTUAL void Link(FArchive &, UProperty *);
    HG_VIRTUAL unsigned int Identical(const void *, const void *, unsigned long) const;
    HG_VIRTUAL void SerializeItem(FArchive &, void *, int, void *) const;
    HG_VIRTUAL unsigned int NetSerializeItem(FArchive &, UPackageMap *, void *) const;
    HG_VIRTUAL void ExportTextItem(FString &, const unsigned char *, const unsigned char *, UObject *, int, EImportTextFormat) const;
    HG_VIRTUAL const wchar_t *ImportText(const wchar_t *, unsigned char *, int, UObject *, FOutputDevice *, EImportTextFormat) const;
    HG_VIRTUAL unsigned int GetPropertyValue(unsigned char *, UPropertyValue &) const;
    HG_VIRTUAL unsigned int SetPropertyValue(unsigned char *, const UPropertyValue &) const;
    HG_VIRTUAL void CopySingleValue(void *, void *, UObject *, UObject *, FObjectInstancingGraph *) const;
    HG_VIRTUAL void CopyCompleteValue(void *, void *, UObject *, UObject *, FObjectInstancingGraph *) const;
    HG_VIRTUAL unsigned int HasValue(const unsigned char *, unsigned long) const;
    HG_VIRTUAL void ClearValue(unsigned char *, unsigned long) const;
    HG_VIRTUAL void DestroyValue(void *) const;
    HG_VIRTUAL FName GetID() const;
    HG_VIRTUAL unsigned int IsLocalized() const;
    HG_VIRTUAL unsigned int RequiresInit() const;
    HG_VIRTUAL void InstanceComponents(unsigned char *, unsigned char *, UObject *, FObjectInstancingGraph *);
    HG_VIRTUAL int GetMinAlignment() const;
    HG_VIRTUAL unsigned int ContainsObjectReference() const;
    HG_VIRTUAL unsigned int ContainsInstancedObjectProperty() const;
    HG_VIRTUAL void InstanceSubobjects(void *, void *, UObject *, FObjectInstancingGraph *) const;
    HG_VIRTUAL void EmitReferenceInfo(FGCReferenceTokenStream *, int);
    HG_VIRTUAL unsigned int IsEditorOnlyProperty() const;
HG_PRIVATE:
    UProperty &operator=(const UProperty &);
public:
    static UClass *GetPrivateStaticClassUProperty(const wchar_t *);
    static void InitializePrivateStaticClassUProperty();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    UField *GetOuterUField() const;
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    void ExportCppDeclaration(FOutputDevice &, unsigned int, unsigned int, unsigned int) const;
    FString GetNameCPP() const;
    unsigned int ExportText(int, FString &, const unsigned char *, const unsigned char *, UObject *, int, EImportTextFormat) const;
    unsigned int ValidateImportFlags(unsigned long, FOutputDevice *) const;
    unsigned int Port(unsigned long) const;
    unsigned int Matches(const void *, const void *, int, unsigned int, unsigned long) const;
    int GetSize() const;
    unsigned int ShouldSerializeValue(FArchive &) const;
    unsigned int ShouldDuplicateValue() const;
    UProperty *GetOwnerProperty();
    unsigned int HasMetaData(const wchar_t *) const;
    const FString &GetMetaData(const wchar_t *) const;
    void SetMetaData(const wchar_t *, const FString &);
    unsigned int GetBoolMetaData(const wchar_t *) const;
    int GetINTMetaData(const wchar_t *) const;
    float GetFLOATMetaData(const wchar_t *) const;
    FString GetFriendlyName(UClass *) const;
    unsigned __int64 GetPropertyFlags() const;
    void SetPropertyFlags(unsigned __int64);
    void ClearPropertyFlags(unsigned __int64);
    unsigned int HasAnyPropertyFlags(unsigned __int64) const;
    unsigned int HasAllPropertyFlags(unsigned __int64) const;
    UProperty *GetRepOwner();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UProperty();
public:
    UProperty(ECppProperty, int, const wchar_t *, unsigned __int64);
    UProperty();
    #endif
    typedef UField Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    int ArrayDim;  // 0x40
    int ElementSize;  // 0x44
    unsigned __int64 PropertyFlags;  // 0x48
    unsigned short RepOffset;  // 0x50
    unsigned short RepIndex;  // 0x52
    int Offset;  // 0x54
    UProperty *PropertyLinkNext;  // 0x58
    UProperty *ConstructorLinkNext;  // 0x5C
    UProperty *NextRef;  // 0x60
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<int> ArrayDim;
    hg::be<int> ElementSize;
    hg::be<unsigned __int64> PropertyFlags;
    hg::be<unsigned short> RepOffset;
    hg::be<unsigned short> RepIndex;
    hg::be<int> Offset;
    hg::gptr<UProperty> PropertyLinkNext;
    hg::gptr<UProperty> ConstructorLinkNext;
    hg::gptr<UProperty> NextRef;
    #endif
};

class UArrayProperty : public UProperty  // size 0x68
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
HG_PRIVATE:
    UArrayProperty &operator=(const UArrayProperty &);
public:
    static UClass *GetPrivateStaticClassUArrayProperty(const wchar_t *);
    static void InitializePrivateStaticClassUArrayProperty();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void Link(FArchive &, UProperty *);
    HG_VIRTUAL unsigned int Identical(const void *, const void *, unsigned long) const;
    HG_VIRTUAL void SerializeItem(FArchive &, void *, int, void *) const;
    HG_VIRTUAL unsigned int NetSerializeItem(FArchive &, UPackageMap *, void *) const;
    HG_VIRTUAL FString GetCPPType(FString *, unsigned long) const;
    HG_VIRTUAL FString GetCPPMacroType(FString &) const;
    HG_VIRTUAL void ExportTextItem(FString &, const unsigned char *, const unsigned char *, UObject *, int, EImportTextFormat) const;
    HG_VIRTUAL const wchar_t *ImportText(const wchar_t *, unsigned char *, int, UObject *, FOutputDevice *, EImportTextFormat) const;
    HG_VIRTUAL void CopyCompleteValue(void *, void *, UObject *, UObject *, FObjectInstancingGraph *) const;
    HG_VIRTUAL unsigned int HasValue(const unsigned char *, unsigned long) const;
    HG_VIRTUAL void ClearValue(unsigned char *, unsigned long) const;
    HG_VIRTUAL void DestroyValue(void *) const;
    HG_VIRTUAL unsigned int IsLocalized() const;
    HG_VIRTUAL void InstanceComponents(unsigned char *, unsigned char *, UObject *, FObjectInstancingGraph *);
    HG_VIRTUAL int GetMinAlignment() const;
    HG_VIRTUAL unsigned int RequiresInit() const;
    HG_VIRTUAL unsigned int ContainsObjectReference() const;
    HG_VIRTUAL unsigned int ContainsInstancedObjectProperty() const;
    HG_VIRTUAL void InstanceSubobjects(void *, void *, UObject *, FObjectInstancingGraph *) const;
    HG_VIRTUAL void EmitReferenceInfo(FGCReferenceTokenStream *, int);
    HG_VIRTUAL void AddCppProperty(UProperty *);
    HG_VIRTUAL unsigned int GetPropertyValue(unsigned char *, UPropertyValue &) const;
    HG_VIRTUAL unsigned int SetPropertyValue(unsigned char *, const UPropertyValue &) const;
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UArrayProperty();
public:
    UArrayProperty(ECppProperty, int, const wchar_t *, unsigned __int64);
    UArrayProperty();
    #endif
    typedef UProperty Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    UProperty *Inner;  // 0x64
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<UProperty> Inner;
    #endif
};

class UGripBTObject : public UObject  // size 0x44
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
    int dummyVarJustSoTheClassDoesNotStartWithAnEnum;  // 0x3C
    unsigned long childrenCollapsed : 1;  // 0x40
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<int> dummyVarJustSoTheClassDoesNotStartWithAnEnum;
    hg::be<unsigned int> _bits40;  // 0x40, from childrenCollapsed
    #endif
};

class UGripBTNode : public UGripBTObject  // size 0x88
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
    UGripBTNode *ParentNode;  // 0x44
    TArrayNoInit<FNodeChild> Children;  // 0x48
    float RandomWeight;  // 0x54
    FName NodeName;  // 0x58
    FStringNoInit NodeDescription;  // 0x60
    FStringNoInit Comment;  // 0x6C
    FName DefaultTitle;  // 0x78
    unsigned char LastExecutionResult;  // 0x80
    unsigned char LastEvaluationResult;  // 0x81
    char _pad0[0x2];
    int DummyVarJustSoBaseClassDontEndWithAByteToAvoidCompilerWarning;  // 0x84
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<UGripBTNode> ParentNode;
    TArrayNoInit<FNodeChild> Children;
    hg::be<float> RandomWeight;
    FName NodeName;
    FStringNoInit NodeDescription;
    FStringNoInit Comment;
    FName DefaultTitle;
    unsigned char LastExecutionResult;
    unsigned char LastEvaluationResult;
    char _pad0[0x2];
    hg::be<int> DummyVarJustSoBaseClassDontEndWithAByteToAvoidCompilerWarning;
    #endif
};

class UGripBTPriority : public UGripBTNode  // size 0x88
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTPriority &operator=(const UGripBTPriority &);
public:
    static UClass *GetPrivateStaticClassUGripBTPriority(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTPriority();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTPriority();
public:
    #endif
    typedef UGripBTNode Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UGripBTTree : public UGripBTPriority  // size 0x98
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UGripBTTree &operator=(const UGripBTTree &);
public:
    static UClass *GetPrivateStaticClassUGripBTTree(const wchar_t *);
    static void InitializePrivateStaticClassUGripBTTree();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL EGripBTNodeType GetType();
    HG_VIRTUAL BTMenuType GetMenuType();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UGripBTTree();
public:
    #endif
    typedef UGripBTPriority Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    TArrayNoInit<UGripBTNode *> AllTreeNodes;  // 0x88
    unsigned long bBeingEdited : 1;  // 0x94
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    TArrayNoInit<UGripBTNode *> AllTreeNodes;
    hg::be<unsigned int> _bits94;  // 0x94, from bBeingEdited
    #endif
};

class UCCSBTTree : public UGripBTTree  // size 0x98
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
HG_PRIVATE:
    UCCSBTTree &operator=(const UCCSBTTree &);
public:
    static UClass *GetPrivateStaticClassUCCSBTTree(const wchar_t *);
    static void InitializePrivateStaticClassUCCSBTTree();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UCCSBTTree();
    UCCSBTTree();
public:
    #endif
    typedef UGripBTTree Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
};

class UStruct : public UField  // size 0x74
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
    UStruct *SuperStruct;  // 0x40
    UField *Children;  // 0x44
    int PropertiesSize;  // 0x48
    TArray<unsigned char,FDefaultAllocator> Script;  // 0x4C
    int MinAlignment;  // 0x58
    UProperty *RefLink;  // 0x5C
    UProperty *PropertyLink;  // 0x60
    UProperty *ConstructorLink;  // 0x64
    TArray<UObject *,FDefaultAllocator> ScriptObjectReferences;  // 0x68
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<UStruct> SuperStruct;
    hg::gptr<UField> Children;
    hg::be<int> PropertiesSize;
    TArray<unsigned char,FDefaultAllocator> Script;
    hg::be<int> MinAlignment;
    hg::gptr<UProperty> RefLink;
    hg::gptr<UProperty> PropertyLink;
    hg::gptr<UProperty> ConstructorLink;
    TArray<UObject *,FDefaultAllocator> ScriptObjectReferences;
    #endif
};

class UState : public UStruct  // size 0xBC
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
    unsigned long ProbeMask;  // 0x74
    unsigned long StateFlags;  // 0x78
    unsigned short LabelTableOffset;  // 0x7C
    char _pad0[0x2];
    TMap<FName,UFunction *,FDefaultSetAllocator> FuncMap;  // 0x80
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<unsigned long> ProbeMask;
    hg::be<unsigned long> StateFlags;
    hg::be<unsigned short> LabelTableOffset;
    char _pad0[0x2];
    TMap<FName,UFunction *,FDefaultSetAllocator> FuncMap;
    #endif
};

class UClass : public UState  // size 0x154
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
    unsigned long ClassFlags;  // 0xBC
    unsigned long ClassCastFlags;  // 0xC0
    int ClassUnique;  // 0xC4
    UClass *ClassWithin;  // 0xC8
    FName ClassConfigName;  // 0xCC
    TArray<FRepRecord,FDefaultAllocator> ClassReps;  // 0xD4
    TArray<UField *,FDefaultAllocator> NetFields;  // 0xE0
    UObject *ClassDefaultObject;  // 0xEC
    void (*ClassConstructor)(void *);  // 0xF0
    void (UObject::*ClassStaticConstructor)();  // 0xF4
    void (UObject::*ClassStaticInitializer)();  // 0xF8
    TMap<FName,UComponent *,FDefaultSetAllocator> ComponentNameToDefaultObjectMap;  // 0xFC
    TArray<FImplementedInterface,FDefaultAllocator> Interfaces;  // 0x138
    unsigned int bNeedsPropertiesLinked;  // 0x144
    FGCReferenceTokenStream ReferenceTokenStream;  // 0x148
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<unsigned long> ClassFlags;
    hg::be<unsigned long> ClassCastFlags;
    hg::be<int> ClassUnique;
    hg::gptr<UClass> ClassWithin;
    FName ClassConfigName;
    TArray<FRepRecord,FDefaultAllocator> ClassReps;
    TArray<UField *,FDefaultAllocator> NetFields;
    hg::gptr<UObject> ClassDefaultObject;
    hg::be<unsigned int> ClassConstructor;
    hg::be<unsigned int> ClassStaticConstructor;
    hg::be<unsigned int> ClassStaticInitializer;
    TMap<FName,UComponent *,FDefaultSetAllocator> ComponentNameToDefaultObjectMap;
    TArray<FImplementedInterface,FDefaultAllocator> Interfaces;
    hg::be<unsigned int> bNeedsPropertiesLinked;
    FGCReferenceTokenStream ReferenceTokenStream;
    #endif
};

class UComponent : public UObject  // size 0x48
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
    UClass *TemplateOwnerClass;  // 0x3C
    FName TemplateName;  // 0x40
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<UClass> TemplateOwnerClass;
    FName TemplateName;
    #endif
};

class UFunction : public UStruct  // size 0x8C
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
HG_PRIVATE:
    UFunction &operator=(const UFunction &);
public:
    static UClass *GetPrivateStaticClassUFunction(const wchar_t *);
    static void InitializePrivateStaticClassUFunction();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    UState *GetOuterUState() const;
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void PostLoad();
    HG_VIRTUAL void Bind();
    HG_VIRTUAL unsigned int MergeBools();
    HG_VIRTUAL UStruct *GetInheritanceSuper() const;
    HG_VIRTUAL void Link(FArchive &, unsigned int);
    UFunction *GetSuperFunction() const;
    UProperty *GetReturnProperty();
    unsigned int HasAnyFunctionFlags(unsigned long) const;
    unsigned int HasAllFunctionFlags(unsigned long) const;
    unsigned long GetMaskedFlags(unsigned long) const;
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UFunction();
public:
    UFunction(UFunction *);
HG_PROTECTED:
    UFunction();
public:
    #endif
    typedef UStruct Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    unsigned long FunctionFlags;  // 0x74
    unsigned short iNative;  // 0x78
    unsigned short RepOffset;  // 0x7A
    unsigned char OperPrecedence;  // 0x7C
    unsigned char NumParms;  // 0x7D
    unsigned short ParmsSize;  // 0x7E
    unsigned short ReturnValueOffset;  // 0x80
    char _pad0[0x2];
    UStructProperty *FirstStructWithDefaults;  // 0x84
    void (UObject::*Func)(FFrame &, void *const);  // 0x88
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::be<unsigned long> FunctionFlags;
    hg::be<unsigned short> iNative;
    hg::be<unsigned short> RepOffset;
    unsigned char OperPrecedence;
    unsigned char NumParms;
    hg::be<unsigned short> ParmsSize;
    hg::be<unsigned short> ReturnValueOffset;
    char _pad0[0x2];
    hg::gptr<UStructProperty> FirstStructWithDefaults;
    hg::be<unsigned int> Func;
    #endif
};

class ULinker : public UObject  // size 0x168
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
HG_PRIVATE:
    ULinker &operator=(const ULinker &);
public:
    static UClass *GetPrivateStaticClassULinker(const wchar_t *);
    static void InitializePrivateStaticClassULinker();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    FString GetImportPathName(int);
    FString GetExportPathName(int, const wchar_t *, unsigned int);
    FString GetImportFullName(int);
    FString GetExportFullName(int, const wchar_t *, unsigned int);
    FName IndexToName(int, int) const;
    int FindFirstPatchedExportIndex() const;
    void StartScriptSHAGeneration();
    void UpdateScriptSHAKey(const TArray<unsigned char,FDefaultAllocator> &);
    void GetScriptSHAKey(unsigned char *);
    HG_VIRTUAL void BeginDestroy();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ULinker();
public:
    ULinker(UPackage *, const wchar_t *);
HG_PROTECTED:
    ULinker();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    UPackage *LinkerRoot;  // 0x3C
    FPackageFileSummary Summary;  // 0x40
    TArray<FName,FDefaultAllocator> NameMap;  // 0xE4
    TArray<FObjectImport,FDefaultAllocator> ImportMap;  // 0xF0
    TArray<FObjectExport,FDefaultAllocator> ExportMap;  // 0xFC
    TArray<TArray<int,FDefaultAllocator>,FDefaultAllocator> DependsMap;  // 0x108
    TMap<FGuid,int,FDefaultSetAllocator> ExportGuidsAwaitingLookup;  // 0x114
    FString Filename;  // 0x150
    unsigned __int64 _ContextFlags;  // 0x15C
    FSHA1 *ScriptSHA;  // 0x164
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    hg::gptr<UPackage> LinkerRoot;
    FPackageFileSummary Summary;
    TArray<FName,FDefaultAllocator> NameMap;
    TArray<FObjectImport,FDefaultAllocator> ImportMap;
    TArray<FObjectExport,FDefaultAllocator> ExportMap;
    TArray<TArray<int,FDefaultAllocator>,FDefaultAllocator> DependsMap;
    TMap<FGuid,int,FDefaultSetAllocator> ExportGuidsAwaitingLookup;
    FString Filename;
    hg::be<unsigned __int64> _ContextFlags;
    hg::gptr<FSHA1> ScriptSHA;
    #endif
};

class ULinkerLoad : public ULinker, public FArchive  // size 0x72C
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    struct FPackagePrecacheInfo;
HG_PRIVATE:
    HG_VIRTUAL void DetachAllBulkData(unsigned int);
    HG_VIRTUAL void Detach(unsigned int);
    ULinkerLoad &operator=(const ULinkerLoad &);
public:
    static UClass *GetPrivateStaticClassULinkerLoad(const wchar_t *);
    static void InitializePrivateStaticClassULinkerLoad();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void CreateActiveRedirectsMap(const wchar_t *);
    unsigned int FindImportClassAndPackage(FName, int &, int &);
    unsigned int CreateImportClassAndPackage(FName, FName, int &, int &);
    unsigned int FixupExportMap();
    static void GetListOfPackagesInPackagePrecacheMap(TArray<FString,FDefaultAllocator> &);
    unsigned int HasFinishedInitializtion() const;
    HG_VIRTUAL ULinker *GetLinker();
    static ULinkerLoad *CreateLinker(UPackage *, const wchar_t *, unsigned long);
    void Verify();
    FName GetExportClassPackage(int);
    FName GetExportClassName(int);
    HG_VIRTUAL FString GetArchiveName() const;
    void GatherExportDependencies(int, TSet<FDependencyRef,DefaultKeyFuncs<FDependencyRef,0>,FDefaultSetAllocator> &, unsigned int);
    void GatherImportDependencies(int, TSet<FDependencyRef,DefaultKeyFuncs<FDependencyRef,0>,FDefaultSetAllocator> &, unsigned int);
    void VerifyImport(int);
    void LoadAllObjects(unsigned int);
    FName ResolveResourceName(int);
    void RemapLinkerPackageNames();
    void RemapLinkerPackageNamesForMultilanguageCooks();
    int FindExportIndex(FName, FName, FName, int);
    UObject *Create(UClass *, FName, UObject *, unsigned long, unsigned int);
    UObject *CreateByOuterIndex(UClass *, FName, int, unsigned long, unsigned int);
    HG_VIRTUAL void Preload(UObject *);
    UObject *FindExistingExport(int);
    void BuildPathName(FString &, int) const;
    unsigned int WillTextureBeLoaded(UClass *, int);
    static void AsyncPreloadPackage(const wchar_t *);
    FPatchReader *GetScriptPatchArchive() const;
    FScriptPatchData *FindBytecodePatch(int) const;
    FPatchData *FindDefaultsPatch(int) const;
    FEnumPatchData *FindEnumPatch(int) const;
    HG_VIRTUAL void MarkScriptSerializationStart(const UObject *);
    HG_VIRTUAL void MarkScriptSerializationEnd(const UObject *);
    HG_VIRTUAL void WillSerializePotentialCrossLevelPointer(UObject *, const UProperty *);
    UObject *ResolveCrossLevelReference(int, int, UObject *, const UProperty *);
    static ULinkerLoad *FindExistingLinkerForPackage(UPackage *);
HG_PRIVATE:
    FScriptPatcher *GetScriptPatcher();
    FScriptPatcher *GetExistingScriptPatcher();
    void CreatePatchReader();
    void AppendNames(const TArray<FName,FDefaultAllocator> &);
    void AppendImports(const TArray<FObjectImport,FDefaultAllocator> &);
    void AppendExports(const TArray<FObjectExport,FDefaultAllocator> &, const TArray<FPatchData,FDefaultAllocator> &);
    UObject *CreateExport(int);
    UObject *CreateImport(int);
    UObject *IndexToObject(int);
    void DetachExport(int);
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL unsigned int Precache(int, int);
    HG_VIRTUAL void AttachBulkData(UObject *, FUntypedBulkData *);
    HG_VIRTUAL void DetachBulkData(FUntypedBulkData *, unsigned int);
    HG_VIRTUAL void Seek(int);
    HG_VIRTUAL int Tell();
    HG_VIRTUAL int TotalSize();
    HG_VIRTUAL void Serialize(void *, int);
    HG_VIRTUAL FArchive &operator<<(FName &);
    HG_VIRTUAL FArchive &operator<<(UObject *&);
    unsigned int VerifyImportInner(int, FString &);
    static ULinkerLoad *CreateLinkerAsync(UPackage *, const wchar_t *, unsigned long);
HG_PROTECTED:
    unsigned int Tick(float, unsigned int);
HG_PRIVATE:
    unsigned int IsTimeLimitExceeded(const wchar_t *, int);
    unsigned int CreateLoader();
    unsigned int SerializePackageFileSummary();
    unsigned int SerializeNameMap();
    unsigned int SerializeImportMap();
    unsigned int FixupImportMap();
    unsigned int RemapClasses();
    unsigned int SerializeExportMap();
    unsigned int StartTextureAllocation();
    unsigned int IntegrateScriptPatches();
    unsigned int SerializeDependsMap();
    unsigned int SerializeGuidMaps();
public:
    unsigned int SerializeThumbnails(unsigned int);
HG_PRIVATE:
    unsigned int CreateExportHash();
    unsigned int FindExistingExports();
    unsigned int FinalizeCreation();
public:
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ULinkerLoad();
    ULinkerLoad(UPackage *, const wchar_t *, unsigned long);
    ULinkerLoad();
public:
    #endif
    typedef ULinker Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    static TMap<FName,FName,FDefaultSetAllocator> ObjectNameRedirects;
    static TMap<FName,FName,FDefaultSetAllocator> ObjectNameRedirectsInstanceOnly;
    static TMap<FName,FName,FDefaultSetAllocator> ObjectNameRedirectsObjectOnly;
    static FScriptPatcher *ScriptPatcher;
    static TMap<FString,ULinkerLoad::FPackagePrecacheInfo,FDefaultSetAllocator> PackagePrecacheMap;
    unsigned long LoadFlags;  // 0x1EC
    unsigned int bHaveImportsBeenVerified;  // 0x1F0
    int ExportHash[256];  // 0x1F4
    TArray<FUntypedBulkData *,FDefaultAllocator> BulkDataLoaders;  // 0x5F4
    FArchive *Loader;  // 0x600
    int NameMapIndex;  // 0x604
    int ImportMapIndex;  // 0x608
    int ExportMapIndex;  // 0x60C
    int DependsMapIndex;  // 0x610
    int ExportHashIndex;  // 0x614
    unsigned int bHasSerializedPackageFileSummary;  // 0x618
    unsigned int bHasFixedUpImportMap;  // 0x61C
    unsigned int bHasFoundExistingExports;  // 0x620
    unsigned int bHasFinishedInitialization;  // 0x624
    unsigned int bHasRemappedExternalPackageReferencesForMultilanguageCooks;  // 0x628
    unsigned int bHasIntegratedNamePatches;  // 0x62C
    unsigned int bHasIntegratedImportPatches;  // 0x630
    unsigned int bHasIntegratedExportPatches;  // 0x634
    unsigned int bHasIntegratedScriptPatches;  // 0x638
    unsigned int bHasIntegratedDefaultsPatches;  // 0x63C
    unsigned int bHasIntegratedEnumPatches;  // 0x640
    unsigned int bHasRemappedExternalPackageReferences;  // 0x644
    unsigned int bIsGatheringDependencies;  // 0x648
    unsigned int bTimeLimitExceeded;  // 0x64C
    int IsTimeLimitExceededCallCount;  // 0x650
    unsigned int bUseTimeLimit;  // 0x654
    float TimeLimit;  // 0x658
    double TickStartTime;  // 0x65C
    unsigned int bFixupExportMapDone;  // 0x664
    FPatchReader *PatchDataAr;  // 0x668
    FArchive *OriginalLoader;  // 0x66C
    TMap<int,FScriptPatchData *,FDefaultSetAllocator> FunctionsToPatch;  // 0x670
    TMap<int,FPatchData *,FDefaultSetAllocator> DefaultsToPatch;  // 0x6AC
    TMap<int,FEnumPatchData *,FDefaultSetAllocator> EnumsToPatch;  // 0x6E8
    UObject *PotentialCrossLevelOwner;  // 0x724
    const UProperty *PotentialCrossLevelProperty;  // 0x728
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static TMap<FName,FName,FDefaultSetAllocator> (&ObjectNameRedirects);
    static TMap<FName,FName,FDefaultSetAllocator> (&ObjectNameRedirectsInstanceOnly);
    static TMap<FName,FName,FDefaultSetAllocator> (&ObjectNameRedirectsObjectOnly);
    static hg::gptr<FScriptPatcher> (&ScriptPatcher);
    static TMap<FString,ULinkerLoad::FPackagePrecacheInfo,FDefaultSetAllocator> (&PackagePrecacheMap);
    hg::be<unsigned long> LoadFlags;
    hg::be<unsigned int> bHaveImportsBeenVerified;
    hg::be<int> ExportHash[256];
    TArray<FUntypedBulkData *,FDefaultAllocator> BulkDataLoaders;
    hg::gptr<FArchive> Loader;
    hg::be<int> NameMapIndex;
    hg::be<int> ImportMapIndex;
    hg::be<int> ExportMapIndex;
    hg::be<int> DependsMapIndex;
    hg::be<int> ExportHashIndex;
    hg::be<unsigned int> bHasSerializedPackageFileSummary;
    hg::be<unsigned int> bHasFixedUpImportMap;
    hg::be<unsigned int> bHasFoundExistingExports;
    hg::be<unsigned int> bHasFinishedInitialization;
    hg::be<unsigned int> bHasRemappedExternalPackageReferencesForMultilanguageCooks;
    hg::be<unsigned int> bHasIntegratedNamePatches;
    hg::be<unsigned int> bHasIntegratedImportPatches;
    hg::be<unsigned int> bHasIntegratedExportPatches;
    hg::be<unsigned int> bHasIntegratedScriptPatches;
    hg::be<unsigned int> bHasIntegratedDefaultsPatches;
    hg::be<unsigned int> bHasIntegratedEnumPatches;
    hg::be<unsigned int> bHasRemappedExternalPackageReferences;
    hg::be<unsigned int> bIsGatheringDependencies;
    hg::be<unsigned int> bTimeLimitExceeded;
    hg::be<int> IsTimeLimitExceededCallCount;
    hg::be<unsigned int> bUseTimeLimit;
    hg::be<float> TimeLimit;
    hg::be<double> TickStartTime;
    hg::be<unsigned int> bFixupExportMapDone;
    hg::gptr<FPatchReader> PatchDataAr;
    hg::gptr<FArchive> OriginalLoader;
    TMap<int,FScriptPatchData *,FDefaultSetAllocator> FunctionsToPatch;
    TMap<int,FPatchData *,FDefaultSetAllocator> DefaultsToPatch;
    TMap<int,FEnumPatchData *,FDefaultSetAllocator> EnumsToPatch;
    hg::gptr<UObject> PotentialCrossLevelOwner;
    hg::gptr<const UProperty> PotentialCrossLevelProperty;
    #endif
};

class ULinkerSave : public ULinker, public FArchive  // size 0x20C
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    HG_VIRTUAL int MapName(const FName *) const;
    HG_VIRTUAL int MapObject(const UObject *) const;
HG_PRIVATE:
    ULinkerSave &operator=(const ULinkerSave &);
public:
    static UClass *GetPrivateStaticClassULinkerSave(const wchar_t *);
    static void InitializePrivateStaticClassULinkerSave();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    HG_VIRTUAL void BeginDestroy();
    HG_VIRTUAL FArchive &operator<<(UObject *&);
    HG_VIRTUAL FArchive &operator<<(FName &);
    HG_VIRTUAL ULinker *GetLinker();
    HG_VIRTUAL void Seek(int);
    HG_VIRTUAL int Tell();
    HG_VIRTUAL void Serialize(void *, int);
    void Detach();
    HG_VIRTUAL void WillSerializePotentialCrossLevelPointer(UObject *, const UProperty *);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~ULinkerSave();
public:
    ULinkerSave(UPackage *, unsigned int);
    ULinkerSave(UPackage *, const wchar_t *, unsigned int);
HG_PROTECTED:
    ULinkerSave();
public:
    #endif
    typedef ULinker Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    static TMap<FString,TArray<unsigned char,FDefaultAllocator>,FDefaultSetAllocator> PackagesToScriptSHAMap;
    FArchive *Saver;  // 0x1EC
    TArray<int,FDefaultAllocator> ObjectIndices;  // 0x1F0
    TArray<int,FDefaultAllocator> NameIndices;  // 0x1FC
    unsigned int bIsNextObjectSerializePotentialCrossLevelRef;  // 0x208
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static TMap<FString,TArray<unsigned char,FDefaultAllocator>,FDefaultSetAllocator> (&PackagesToScriptSHAMap);
    hg::gptr<FArchive> Saver;
    TArray<int,FDefaultAllocator> ObjectIndices;
    TArray<int,FDefaultAllocator> NameIndices;
    hg::be<unsigned int> bIsNextObjectSerializePotentialCrossLevelRef;
    #endif
};

class UPackage : public UObject  // size 0xF0
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
HG_PRIVATE:
    UPackage &operator=(const UPackage &);
public:
    static UClass *GetPrivateStaticClassUPackage(const wchar_t *);
    static void InitializePrivateStaticClassUPackage();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    static const TArray<UPackage *,FDefaultAllocator> &GetNetPackages();
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    unsigned int IsBound() const;
    void SetBound(unsigned int);
    void SetLoadTime(float);
    float GetLoadTime();
    FName GetFolderName() const;
    void SetFolderName(FName);
    void SetDirtyFlag(unsigned int);
    unsigned int IsDirty() const;
    unsigned int IsDirtyForPIE() const;
    void ClearDirtyForPIEFlag();
    void MarkAsFullyLoaded();
    unsigned int IsFullyLoaded();
    void FullyLoad();
    void FindExportsInMemoryFirst(unsigned int);
    unsigned int ShouldFindExportsInMemoryFirst();
    void ThisContainsMap();
    unsigned int ContainsMap() const;
    unsigned int HasThumbnailMap() const;
    const TMap<FName,FObjectThumbnail,FDefaultSetAllocator> &GetThumbnailMap() const;
    TMap<FName,FObjectThumbnail,FDefaultSetAllocator> &AccessThumbnailMap();
    void InitNetInfo(ULinkerLoad *, int);
    void AddNetObject(UObject *);
    void RemoveNetObject(UObject *);
    void ClearAllNetObjectsInside(UObject *);
    void PatchNetObjectList(int);
    UObject *GetNetObjectAtIndex(int);
    int GetNetObjectCount(int);
    const TArray<int,FDefaultAllocator> &GetGenerationNetObjectCount();
    FGuid GetGuid();
    void MakeNewGuid();
    void CreateEmptyNetInfo();
    int GetFileSize();
    FName GetForcedExportBasePackageName();
    int GetCurrentNumNetObjects();
    void LookupAllOutstandingCrossLevelExports(ULinkerLoad *);
    UMetaData *GetMetaData();
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UPackage();
public:
    UPackage();
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    static TArray<UPackage *,FDefaultAllocator> NetPackages;
    static TArray<FNetObjectNotify *,FDefaultAllocator> NetObjectNotifies;
    unsigned int bDirty;  // 0x3C
    unsigned int bDirtyForPIE;  // 0x40
    unsigned int bHasBeenFullyLoaded;  // 0x44
    unsigned int bShouldFindExportsInMemoryFirst;  // 0x48
    unsigned int bIsBound;  // 0x4C
    FName FolderName;  // 0x50
    float LoadTime;  // 0x58
    FGuid Guid;  // 0x5C
    int FileSize;  // 0x6C
    TArray<UObject *,FDefaultAllocator> NetObjects;  // 0x70
    int CurrentNumNetObjects;  // 0x7C
    TArray<int,FDefaultAllocator> GenerationNetObjectCount;  // 0x80
    FName ForcedExportBasePackageName;  // 0x8C
    TMap<FGuid,UObject *,FDefaultSetAllocator> ExportGuids;  // 0x94
    TArray<FLevelGuids,FDefaultAllocator> ImportGuids;  // 0xD0
    unsigned long PackageFlags;  // 0xDC
    FName FileName;  // 0xE0
    TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> > ThumbnailMap;  // 0xE8
    UMetaData *MetaData;  // 0xEC
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    static TArray<UPackage *,FDefaultAllocator> (&NetPackages);
    static TArray<FNetObjectNotify *,FDefaultAllocator> (&NetObjectNotifies);
    hg::be<unsigned int> bDirty;
    hg::be<unsigned int> bDirtyForPIE;
    hg::be<unsigned int> bHasBeenFullyLoaded;
    hg::be<unsigned int> bShouldFindExportsInMemoryFirst;
    hg::be<unsigned int> bIsBound;
    FName FolderName;
    hg::be<float> LoadTime;
    FGuid Guid;
    hg::be<int> FileSize;
    TArray<UObject *,FDefaultAllocator> NetObjects;
    hg::be<int> CurrentNumNetObjects;
    TArray<int,FDefaultAllocator> GenerationNetObjectCount;
    FName ForcedExportBasePackageName;
    TMap<FGuid,UObject *,FDefaultSetAllocator> ExportGuids;
    TArray<FLevelGuids,FDefaultAllocator> ImportGuids;
    hg::be<unsigned long> PackageFlags;
    FName FileName;
    TScopedPointer<TMap<FName,FObjectThumbnail,FDefaultSetAllocator> > ThumbnailMap;
    hg::gptr<UMetaData> MetaData;
    #endif
};

class UPackageMap : public UObject  // size 0xC0
{
public:
    enum
    {
        IsIntrinsic = 1,
    };
    HG_VIRTUAL unsigned int CanSerializeObject(UObject *);
    HG_VIRTUAL unsigned int SupportsPackage(UObject *);
    HG_VIRTUAL unsigned int SupportsObject(UObject *);
    HG_VIRTUAL unsigned int SerializeObject(FArchive &, UClass *, UObject *&);
    HG_VIRTUAL unsigned int SerializeName(FArchive &, FName &);
    HG_VIRTUAL void Compute();
    HG_VIRTUAL void AddNetPackages();
    HG_VIRTUAL int AddPackage(UPackage *);
    HG_VIRTUAL void AddPackageInfo(const FPackageInfo &);
    HG_VIRTUAL void Copy(UPackageMap *);
HG_PROTECTED:
    HG_VIRTUAL int ObjectToIndex(UObject *);
    HG_VIRTUAL UObject *IndexToObject(int, unsigned int);
HG_PRIVATE:
    UPackageMap &operator=(const UPackageMap &);
public:
    static UClass *GetPrivateStaticClassUPackageMap(const wchar_t *);
    static void InitializePrivateStaticClassUPackageMap();
    static UClass *StaticClass();
    static void InternalConstructor(void *);
    void StaticConstructor();
    HG_VIRTUAL void Serialize(FArchive &);
    HG_VIRTUAL void FinishDestroy();
    FClassNetCache *GetClassNetCache(UClass *);
    void RemoveClassNetCache(UClass *);
    void RemovePackage(UPackage *, unsigned int);
    void RemovePackageByGuid(const FGuid &);
    unsigned int RemovePackageOnlyIfSynced(UPackage *);
    void LogDebugInfo(FOutputDevice &);
    #ifndef HAGGAR_HOST
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
HG_PROTECTED:
    HG_VIRTUAL ~UPackageMap();
public:
    #endif
    typedef UObject Super;
    #ifndef HAGGAR_HOST
    static UClass *PrivateStaticClass;
    TArray<FPackageInfo,FDefaultAllocator> List;  // 0x3C
    TMap<FName,int,FDefaultSetAllocator> PackageListMap;  // 0x48
    TMap<UClass *,FClassNetCache *,FDefaultSetAllocator> ClassFieldIndices;  // 0x84
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    TArray<FPackageInfo,FDefaultAllocator> List;
    TMap<FName,int,FDefaultSetAllocator> PackageListMap;
    TMap<UClass *,FClassNetCache *,FDefaultSetAllocator> ClassFieldIndices;
    #endif
};

#include "Core/Inc/UnObjBas.h"

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
inline UGripBTNode::~UGripBTNode() { ConditionalDestroy(); }

inline UClass *UGripBTPriority::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTPriority(L"Grip");
        InitializePrivateStaticClassUGripBTPriority();
    }
    return PrivateStaticClass;
}
inline UGripBTPriority::~UGripBTPriority() { ConditionalDestroy(); }

inline UClass *UGripBTTree::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUGripBTTree(L"Grip");
        InitializePrivateStaticClassUGripBTTree();
    }
    return PrivateStaticClass;
}
inline UGripBTTree::~UGripBTTree() { ConditionalDestroy(); }

inline UCCSBTTree::UCCSBTTree() {}
inline UClass *UCCSBTTree::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUCCSBTTree(L"Cognition");
        InitializePrivateStaticClassUCCSBTTree();
    }
    return PrivateStaticClass;
}
inline UCCSBTTree::~UCCSBTTree() { ConditionalDestroy(); }
inline void *UCCSBTTree::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UCCSBTTree::InternalConstructor(void *X) { new ((EInternal *)X) UCCSBTTree; }

inline UClass *UArrayProperty::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUArrayProperty(L"Cognition");
        InitializePrivateStaticClassUArrayProperty();
    }
    return PrivateStaticClass;
}
inline UClass *UClass::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUClass(L"Cognition");
        InitializePrivateStaticClassUClass();
    }
    return PrivateStaticClass;
}
inline UClass *UComponent::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUComponent(L"Core");
        InitializePrivateStaticClassUComponent();
    }
    return PrivateStaticClass;
}
inline UClass *UField::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUField(L"Cognition");
        InitializePrivateStaticClassUField();
    }
    return PrivateStaticClass;
}
inline UClass *UFunction::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUFunction(L"Cognition");
        InitializePrivateStaticClassUFunction();
    }
    return PrivateStaticClass;
}
inline UClass *ULinker::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassULinker(L"Cognition");
        InitializePrivateStaticClassULinker();
    }
    return PrivateStaticClass;
}
inline UClass *ULinkerLoad::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassULinkerLoad(L"Cognition");
        InitializePrivateStaticClassULinkerLoad();
    }
    return PrivateStaticClass;
}
inline UClass *ULinkerSave::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassULinkerSave(L"Cognition");
        InitializePrivateStaticClassULinkerSave();
    }
    return PrivateStaticClass;
}
inline UClass *UPackage::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUPackage(L"Cognition");
        InitializePrivateStaticClassUPackage();
    }
    return PrivateStaticClass;
}
inline UClass *UPackageMap::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUPackageMap(L"Cognition");
        InitializePrivateStaticClassUPackageMap();
    }
    return PrivateStaticClass;
}
inline UClass *UProperty::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUProperty(L"Cognition");
        InitializePrivateStaticClassUProperty();
    }
    return PrivateStaticClass;
}
inline UClass *UState::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUState(L"Cognition");
        InitializePrivateStaticClassUState();
    }
    return PrivateStaticClass;
}
inline UClass *UStruct::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUStruct(L"Cognition");
        InitializePrivateStaticClassUStruct();
    }
    return PrivateStaticClass;
}

#ifndef HAGGAR_HOST
inline FString::FString() {}
inline FString::FString(ENoInit) : TArray<wchar_t, FDefaultAllocator>(E_NoInit) {}
inline FStringNoInit::FStringNoInit() : FString(E_NoInit) {}
#endif
#ifndef HAGGAR_HOST
inline FGuid::FGuid() {}
inline FNodeChild::FNodeChild() {}
inline FScriptDelegate::FScriptDelegate() {}
#endif
// ---- written by hand below this line (gen_header.py keeps it) ----
