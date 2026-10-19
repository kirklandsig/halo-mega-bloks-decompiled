// Generated from the PDB by: python tools/gen_classes.py MegaHaloGame
#pragma once

template <class T0, class T1> class TArray;
template <class T0> class TArrayNoInit;
template <class T0, class T1> class TIndirectArray;
template <int T0, class T1> class TInlineAllocator;
template <class T0, class T1, class T2> class TMap;
template <class T0, class T1, int T2, int T3, int T4> class TSetAllocator;
template <class T0, class T1> class TSparseArrayAllocator;
class AActor;
class FArchive;
struct FAsyncCompletionCallbackInfo;
struct FAsyncPackage;
class FDefaultAllocator;
class FDefaultBitArrayAllocator;
class FDefaultSetAllocator;
class FEditPropertyChain;
class FExportObjectInnerContext;
class FFeedbackContext;
struct FFrame;
class FGuid;
class FHeapAllocator;
class FName;
struct FNameEntry;
struct FObjectDuplicationParameters;
struct FObjectInstancingGraph;
class FOutputDevice;
struct FPropertyChangedChainEvent;
struct FPropertyChangedEvent;
struct FReferencerInformation;
struct FReferencerInformationList;
struct FScriptDelegate;
class FSerializableObject;
struct FStateFrame;
class FString;
class UArrayProperty;
class UClass;
class UComponent;
class UField;
class UFunction;
class UHaloSaveGame;
class ULinkerLoad;
class ULinkerSave;
class UObject;
class UObjectSerializer;
class UPackage;
class UPackageMap;
class UProperty;
class UState;
class UStruct;
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
enum EGotoState
{
    GOTOSTATE_NotFound = 0,
    GOTOSTATE_Success = 1,
    GOTOSTATE_Preempted = 2,
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
enum ENoInit
{
    E_NoInit = 0,
};
enum EStaticConstructor
{
    EC_StaticConstructor = 0,
};

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

class FSerializableObject  // size 0x4, opaque
{
public:
    virtual ~FSerializableObject();
    virtual void Serialize(FArchive &) = 0;
    static void StaticInit();
    FSerializableObject();
    static UObjectSerializer *GObjectSerializer;
};

struct FAsyncPackage : public FSerializableObject  // size 0x74, opaque
{
public:
    FAsyncPackage(const FString &, const FGuid *, FName);
    unsigned int Tick(unsigned int, float);
    float GetLoadPercentage() const;
    double GetLoadStartTime() const;
    void ResetLoader();
    const FString &GetPackageName() const;
    const FName &GetPackageType() const;
    void AddCompletionCallback(const FAsyncCompletionCallbackInfo &);
    virtual void Serialize(FArchive &);
private:
    unsigned int GiveUpTimeSlice();
    unsigned int IsTimeLimitExceeded();
    void BeginAsyncLoad();
    void EndAsyncLoad();
    unsigned int CreateLinker();
    unsigned int FinishLinker();
    unsigned int CreateImports();
    unsigned int FinishTextureAllocations();
    unsigned int CreateExports();
    unsigned int PreLoadObjects();
    unsigned int FinishExportGuids();
    unsigned int PostLoadObjects();
    unsigned int FinishObjects();
    unsigned int FAsyncPackageData[0x1C];
};

class FHeapAllocator  // size 0x1, opaque
{
public:
    enum
    {
        NeedsElementType = 0,
    };
};

class FDefaultAllocator : public FHeapAllocator  // size 0x1, opaque
{
};

template <> class TInlineAllocator<4,FDefaultAllocator>  // size 0x1, opaque
{
public:
    enum
    {
        NeedsElementType = 1,
    };
};

class FDefaultBitArrayAllocator : public TInlineAllocator<4,FDefaultAllocator>  // size 0x1, opaque
{
};

template <> class TInlineAllocator<1,FDefaultAllocator>  // size 0x1, opaque
{
public:
    enum
    {
        NeedsElementType = 1,
    };
};

template <> class TSparseArrayAllocator<FDefaultAllocator,FDefaultBitArrayAllocator>  // size 0x1, opaque
{
};

template <> class TSetAllocator<TSparseArrayAllocator<FDefaultAllocator,FDefaultBitArrayAllocator>,TInlineAllocator<1,FDefaultAllocator>,2,8,4>  // size 0x1, opaque
{
public:
    static unsigned int GetNumberOfHashBuckets(unsigned int);
};

class FDefaultSetAllocator : public TSetAllocator<TSparseArrayAllocator<FDefaultAllocator,FDefaultBitArrayAllocator>,TInlineAllocator<1,FDefaultAllocator>,2,8,4>  // size 0x1, opaque
{
};

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

struct FReferencerInformation  // size 0x14, opaque
{
public:
    FReferencerInformation(UObject *, int, const TArray<UProperty *,FDefaultAllocator> &);
private:
    unsigned int FReferencerInformationData[0x5];
};

template <> class TArray<wchar_t,FDefaultAllocator>  // size 0xC, opaque
{
public:
    enum
    {
        AllocatorNeedsElementType = 0,
    };
    TArray(const TArray<wchar_t,FDefaultAllocator> &);
    TArray(int);
    TArray(ENoInit);
    TArray();
    ~TArray();
    const wchar_t *GetTypedData() const;
    wchar_t *GetTypedData();
    const wchar_t *GetData() const;
    wchar_t *GetData();
    unsigned long GetTypeSize() const;
    unsigned long GetAllocatedSize() const;
    int GetSlack() const;
    unsigned int IsValidIndex(int) const;
    int Num() const;
    const wchar_t &operator()(int) const;
    wchar_t &operator()(int);
    wchar_t Pop();
    void Push(const wchar_t &);
    const wchar_t &Top() const;
    wchar_t &Top();
    const wchar_t &Last(int) const;
    wchar_t &Last(int);
    void Shrink();
    unsigned int FindItem(const wchar_t &, int &) const;
    int FindItemIndex(const wchar_t &) const;
    unsigned int ContainsItem(const wchar_t &) const;
    unsigned int operator==(const TArray<wchar_t,FDefaultAllocator> &) const;
    unsigned int operator!=(const TArray<wchar_t,FDefaultAllocator> &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    int Add(int);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(const wchar_t &, int);
    void Remove(int, int);
    void RemoveSwap(int, int);
    void Empty(int);
    void SetNum(int);
    void Append(const TArray<wchar_t,FDefaultAllocator> &);
    TArray<wchar_t,FDefaultAllocator> &operator+=(const TArray<wchar_t,FDefaultAllocator> &);
    TArray<wchar_t,FDefaultAllocator> &operator=(const TArray<wchar_t,FDefaultAllocator> &);
    int AddItem(const wchar_t &);
    int AddZeroed(int);
    int AddUniqueItem(const wchar_t &);
    void Reserve(int);
    void Init(const wchar_t &, int);
    void Init(int);
    int RemoveSingleItem(const wchar_t &);
    int RemoveItem(const wchar_t &);
    int RemoveSingleItemSwap(const wchar_t &);
    int RemoveItemSwap(const wchar_t &);
    void Swap(int, int);
    void SwapItems(int, int);
    void Reset(int);
private:
    const wchar_t &DebugGet(int) const;
protected:
    void DestructItems(int, int);
private:
    unsigned int TArrayData[0x3];
};

class FString : public TArray<wchar_t,FDefaultAllocator>  // size 0xC, opaque
{
public:
    FString(ENoInit);
    FString(const char *);
    FString(int, const wchar_t *);
    FString(const wchar_t *);
    FString(const FString &, int);
    FString(const FString &);
    FString();
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
    virtual void PreEditChange(FEditPropertyChain &);
    virtual void PreEditChange(UProperty *);
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
    unsigned int IsBasedOnArchetype(const UObject *) const;
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
    void CallFunction(FFrame &, void *, UFunction *);
    void ProcessInternal(FFrame &, void *);
    void SkipFunction(FFrame &, void *, UFunction *);
    unsigned int IsProbing(FName);
    void PushState(FName, FName);
    void PopState(FFrame &, unsigned int);
    void execUndefined(FFrame &, void *);
    void execLocalVariable(FFrame &, void *);
    void execInstanceVariable(FFrame &, void *);
    void execDefaultVariable(FFrame &, void *);
    void execLocalOutVariable(FFrame &, void *);
    void execStateVariable(FFrame &, void *);
    void execInterfaceVariable(FFrame &, void *);
    void execInterfaceContext(FFrame &, void *);
    void execDefaultParmValue(FFrame &, void *);
    void execArrayElement(FFrame &, void *);
    void execDynArrayElement(FFrame &, void *);
    void execDynArrayLength(FFrame &, void *);
    void execDynArrayInsert(FFrame &, void *);
    void execDynArrayRemove(FFrame &, void *);
    void execDynArrayFind(FFrame &, void *);
    void execDynArrayFindStruct(FFrame &, void *);
    void execDynArrayAdd(FFrame &, void *);
    void execDynArrayAddItem(FFrame &, void *);
    void execDynArrayInsertItem(FFrame &, void *);
    void execDynArrayRemoveItem(FFrame &, void *);
    void execDynArrayIterator(FFrame &, void *);
    void execDynArraySort(FFrame &, void *);
    void execBoolVariable(FFrame &, void *);
    void execClassDefaultVariable(FFrame &, void *);
    void execEndFunctionParms(FFrame &, void *);
    void execNothing(FFrame &, void *);
    void execEndOfScript(FFrame &, void *);
    void execReturnNothing(FFrame &, void *);
    void execIteratorPop(FFrame &, void *);
    void execEmptyParmValue(FFrame &, void *);
    void execStop(FFrame &, void *);
    void execEndCode(FFrame &, void *);
    void execSwitch(FFrame &, void *);
    void execCase(FFrame &, void *);
    void execJump(FFrame &, void *);
    void execJumpIfNot(FFrame &, void *);
    void execAssert(FFrame &, void *);
    void execGotoLabel(FFrame &, void *);
    void execLet(FFrame &, void *);
    void execLetBool(FFrame &, void *);
    void execLetDelegate(FFrame &, void *);
    void execEatReturnValue(FFrame &, void *);
    void execSelf(FFrame &, void *);
    void execContext(FFrame &, void *);
    void execVirtualFunction(FFrame &, void *);
    void execFinalFunction(FFrame &, void *);
    void execGlobalFunction(FFrame &, void *);
    void execDelegateFunction(FFrame &, void *);
    void execDelegateProperty(FFrame &, void *);
    void execStructCmpEq(FFrame &, void *);
    void execStructCmpNe(FFrame &, void *);
    void execStructMember(FFrame &, void *);
    void execEqualEqual_DelegateDelegate(FFrame &, void *);
    void execNotEqual_DelegateDelegate(FFrame &, void *);
    void execEqualEqual_DelegateFunction(FFrame &, void *);
    void execNotEqual_DelegateFunction(FFrame &, void *);
    void execIntConst(FFrame &, void *);
    void execFloatConst(FFrame &, void *);
    void execStringConst(FFrame &, void *);
    void execUnicodeStringConst(FFrame &, void *);
    void execObjectConst(FFrame &, void *);
    void execInstanceDelegate(FFrame &, void *);
    void execNameConst(FFrame &, void *);
    void execByteConst(FFrame &, void *);
    void execIntZero(FFrame &, void *);
    void execIntOne(FFrame &, void *);
    void execTrue(FFrame &, void *);
    void execFalse(FFrame &, void *);
    void execNoObject(FFrame &, void *);
    void execEmptyDelegate(FFrame &, void *);
    void execIntConstByte(FFrame &, void *);
    void execDynamicCast(FFrame &, void *);
    void execMetaCast(FFrame &, void *);
    void execPrimitiveCast(FFrame &, void *);
    void execInterfaceCast(FFrame &, void *);
    void execByteToInt(FFrame &, void *);
    void execByteToBool(FFrame &, void *);
    void execByteToFloat(FFrame &, void *);
    void execByteToString(FFrame &, void *);
    void execIntToByte(FFrame &, void *);
    void execIntToBool(FFrame &, void *);
    void execIntToFloat(FFrame &, void *);
    void execIntToString(FFrame &, void *);
    void execBoolToByte(FFrame &, void *);
    void execBoolToInt(FFrame &, void *);
    void execBoolToFloat(FFrame &, void *);
    void execBoolToString(FFrame &, void *);
    void execFloatToByte(FFrame &, void *);
    void execFloatToInt(FFrame &, void *);
    void execFloatToBool(FFrame &, void *);
    void execFloatToString(FFrame &, void *);
    void execRotationConst(FFrame &, void *);
    void execVectorConst(FFrame &, void *);
    void execPointDistToLine(FFrame &, void *);
    void execPointDistToSegment(FFrame &, void *);
    void execPointProjectToPlane(FFrame &, void *);
    void execGetDotDistance(FFrame &, void *);
    void execGetAngularDistance(FFrame &, void *);
    void execGetAngularFromDotDist(FFrame &, void *);
    void execStringToVector(FFrame &, void *);
    void execStringToRotator(FFrame &, void *);
    void execVectorToBool(FFrame &, void *);
    void execVectorToString(FFrame &, void *);
    void execVectorToRotator(FFrame &, void *);
    void execRotatorToBool(FFrame &, void *);
    void execRotatorToVector(FFrame &, void *);
    void execRotatorToString(FFrame &, void *);
    void execRotRand(FFrame &, void *);
    void execGetRotatorAxis(FFrame &, void *);
    void execGetUnAxes(FFrame &, void *);
    void execGetAxes(FFrame &, void *);
    void execSubtractEqual_RotatorRotator(FFrame &, void *);
    void execAddEqual_RotatorRotator(FFrame &, void *);
    void execSubtract_RotatorRotator(FFrame &, void *);
    void execAdd_RotatorRotator(FFrame &, void *);
    void execDivideEqual_RotatorFloat(FFrame &, void *);
    void execMultiplyEqual_RotatorFloat(FFrame &, void *);
    void execDivide_RotatorFloat(FFrame &, void *);
    void execMultiply_FloatRotator(FFrame &, void *);
    void execMultiply_RotatorFloat(FFrame &, void *);
    void execNotEqual_RotatorRotator(FFrame &, void *);
    void execEqualEqual_RotatorRotator(FFrame &, void *);
    void execGetRand(FFrame &, void *);
    void execRSize(FFrame &, void *);
    void execRMin(FFrame &, void *);
    void execRMax(FFrame &, void *);
    void execMirrorVectorByNormal(FFrame &, void *);
    void execVRand(FFrame &, void *);
    void execVRandCone(FFrame &, void *);
    void execVRandCone2(FFrame &, void *);
    void execVLerp(FFrame &, void *);
    void execVInterpTo(FFrame &, void *);
    void execClampLength(FFrame &, void *);
    void execNoZDot(FFrame &, void *);
    void execNormal(FFrame &, void *);
    void execNormal2D(FFrame &, void *);
    void execVSize(FFrame &, void *);
    void execVSize2D(FFrame &, void *);
    void execVSizeSq(FFrame &, void *);
    void execVSizeSq2D(FFrame &, void *);
    void execSubtractEqual_VectorVector(FFrame &, void *);
    void execAddEqual_VectorVector(FFrame &, void *);
    void execDivideEqual_VectorFloat(FFrame &, void *);
    void execMultiplyEqual_VectorVector(FFrame &, void *);
    void execMultiplyEqual_VectorFloat(FFrame &, void *);
    void execCross_VectorVector(FFrame &, void *);
    void execDot_VectorVector(FFrame &, void *);
    void execNotEqual_VectorVector(FFrame &, void *);
    void execEqualEqual_VectorVector(FFrame &, void *);
    void execGreaterGreater_VectorRotator(FFrame &, void *);
    void execLessLess_VectorRotator(FFrame &, void *);
    void execSubtract_VectorVector(FFrame &, void *);
    void execAdd_VectorVector(FFrame &, void *);
    void execDivide_VectorFloat(FFrame &, void *);
    void execMultiply_VectorVector(FFrame &, void *);
    void execMultiply_FloatVector(FFrame &, void *);
    void execMultiply_VectorFloat(FFrame &, void *);
    void execSubtract_PreVector(FFrame &, void *);
    void execOrthoRotation(FFrame &, void *);
    void execNormalize(FFrame &, void *);
    void execRLerp(FFrame &, void *);
    void execRTransform(FFrame &, void *);
    void execRInterpTo(FFrame &, void *);
    void execNormalizeRotAxis(FFrame &, void *);
    void execRDiff(FFrame &, void *);
    void execClockwiseFrom_IntInt(FFrame &, void *);
    void execObjectToBool(FFrame &, void *);
    void execObjectToInterface(FFrame &, void *);
    void execObjectToString(FFrame &, void *);
    void execInterfaceToString(FFrame &, void *);
    void execInterfaceToBool(FFrame &, void *);
    void execInterfaceToObject(FFrame &, void *);
    void execDelegateToString(FFrame &, void *);
    void execNameToBool(FFrame &, void *);
    void execNameToString(FFrame &, void *);
    void execStringToName(FFrame &, void *);
    void execStringToByte(FFrame &, void *);
    void execStringToInt(FFrame &, void *);
    void execStringToBool(FFrame &, void *);
    void execStringToFloat(FFrame &, void *);
    void execNot_PreBool(FFrame &, void *);
    void execEqualEqual_BoolBool(FFrame &, void *);
    void execNotEqual_BoolBool(FFrame &, void *);
    void execAndAnd_BoolBool(FFrame &, void *);
    void execXorXor_BoolBool(FFrame &, void *);
    void execOrOr_BoolBool(FFrame &, void *);
    void execMultiplyEqual_ByteByte(FFrame &, void *);
    void execMultiplyEqual_ByteFloat(FFrame &, void *);
    void execDivideEqual_ByteByte(FFrame &, void *);
    void execAddEqual_ByteByte(FFrame &, void *);
    void execSubtractEqual_ByteByte(FFrame &, void *);
    void execAddAdd_PreByte(FFrame &, void *);
    void execSubtractSubtract_PreByte(FFrame &, void *);
    void execAddAdd_Byte(FFrame &, void *);
    void execSubtractSubtract_Byte(FFrame &, void *);
    void execComplement_PreInt(FFrame &, void *);
    void execSubtract_PreInt(FFrame &, void *);
    void execMultiply_IntInt(FFrame &, void *);
    void execDivide_IntInt(FFrame &, void *);
    void execPercent_IntInt(FFrame &, void *);
    void execAdd_IntInt(FFrame &, void *);
    void execSubtract_IntInt(FFrame &, void *);
    void execLessLess_IntInt(FFrame &, void *);
    void execGreaterGreater_IntInt(FFrame &, void *);
    void execGreaterGreaterGreater_IntInt(FFrame &, void *);
    void execLess_IntInt(FFrame &, void *);
    void execGreater_IntInt(FFrame &, void *);
    void execLessEqual_IntInt(FFrame &, void *);
    void execGreaterEqual_IntInt(FFrame &, void *);
    void execEqualEqual_IntInt(FFrame &, void *);
    void execNotEqual_IntInt(FFrame &, void *);
    void execAnd_IntInt(FFrame &, void *);
    void execXor_IntInt(FFrame &, void *);
    void execOr_IntInt(FFrame &, void *);
    void execMultiplyEqual_IntFloat(FFrame &, void *);
    void execDivideEqual_IntFloat(FFrame &, void *);
    void execAddEqual_IntInt(FFrame &, void *);
    void execSubtractEqual_IntInt(FFrame &, void *);
    void execAddAdd_PreInt(FFrame &, void *);
    void execSubtractSubtract_PreInt(FFrame &, void *);
    void execAddAdd_Int(FFrame &, void *);
    void execSubtractSubtract_Int(FFrame &, void *);
    void execRand(FFrame &, void *);
    void execMin(FFrame &, void *);
    void execMax(FFrame &, void *);
    void execClamp(FFrame &, void *);
    void execToHex(FFrame &, void *);
    void execSubtract_PreFloat(FFrame &, void *);
    void execMultiplyMultiply_FloatFloat(FFrame &, void *);
    void execMultiply_FloatFloat(FFrame &, void *);
    void execDivide_FloatFloat(FFrame &, void *);
    void execPercent_FloatFloat(FFrame &, void *);
    void execAdd_FloatFloat(FFrame &, void *);
    void execSubtract_FloatFloat(FFrame &, void *);
    void execLess_FloatFloat(FFrame &, void *);
    void execGreater_FloatFloat(FFrame &, void *);
    void execLessEqual_FloatFloat(FFrame &, void *);
    void execGreaterEqual_FloatFloat(FFrame &, void *);
    void execEqualEqual_FloatFloat(FFrame &, void *);
    void execNotEqual_FloatFloat(FFrame &, void *);
    void execComplementEqual_FloatFloat(FFrame &, void *);
    void execMultiplyEqual_FloatFloat(FFrame &, void *);
    void execDivideEqual_FloatFloat(FFrame &, void *);
    void execAddEqual_FloatFloat(FFrame &, void *);
    void execSubtractEqual_FloatFloat(FFrame &, void *);
    void execAbs(FFrame &, void *);
    void execDebugInfo(FFrame &, void *);
    void execSin(FFrame &, void *);
    void execAsin(FFrame &, void *);
    void execCos(FFrame &, void *);
    void execAcos(FFrame &, void *);
    void execTan(FFrame &, void *);
    void execAtan(FFrame &, void *);
    void execAtan2(FFrame &, void *);
    void execExp(FFrame &, void *);
    void execLoge(FFrame &, void *);
    void execSqrt(FFrame &, void *);
    void execSquare(FFrame &, void *);
    void execRound(FFrame &, void *);
    void execFFloor(FFrame &, void *);
    void execFCeil(FFrame &, void *);
    void execFRand(FFrame &, void *);
    void execFMin(FFrame &, void *);
    void execFMax(FFrame &, void *);
    void execFClamp(FFrame &, void *);
    void execLerp(FFrame &, void *);
    void execFCubicInterp(FFrame &, void *);
    void execFInterpEaseInOut(FFrame &, void *);
    void execFInterpTo(FFrame &, void *);
    void execFInterpConstantTo(FFrame &, void *);
    void execConcat_StrStr(FFrame &, void *);
    void execAt_StrStr(FFrame &, void *);
    void execLess_StrStr(FFrame &, void *);
    void execGreater_StrStr(FFrame &, void *);
    void execLessEqual_StrStr(FFrame &, void *);
    void execGreaterEqual_StrStr(FFrame &, void *);
    void execEqualEqual_StrStr(FFrame &, void *);
    void execNotEqual_StrStr(FFrame &, void *);
    void execComplementEqual_StrStr(FFrame &, void *);
    void execConcatEqual_StrStr(FFrame &, void *);
    void execAtEqual_StrStr(FFrame &, void *);
    void execSubtractEqual_StrStr(FFrame &, void *);
    void execLen(FFrame &, void *);
    void execInStr(FFrame &, void *);
    void execMid(FFrame &, void *);
    void execLeft(FFrame &, void *);
    void execRight(FFrame &, void *);
    void execCaps(FFrame &, void *);
    void execLocs(FFrame &, void *);
    void execChr(FFrame &, void *);
    void execAsc(FFrame &, void *);
    void execRepl(FFrame &, void *);
    void execParseStringIntoArray(FFrame &, void *);
    void execMatrixGetOrigin(FFrame &, void *);
    void execMatrixGetAxis(FFrame &, void *);
    void execMatrixGetRotator(FFrame &, void *);
    void execMakeRotationMatrix(FFrame &, void *);
    void execMakeRotationTranslationMatrix(FFrame &, void *);
    void execInverseTransformNormal(FFrame &, void *);
    void execTransformNormal(FFrame &, void *);
    void execInverseTransformVector(FFrame &, void *);
    void execTransformVector(FFrame &, void *);
    void execMultiply_MatrixMatrix(FFrame &, void *);
    void execQuatProduct(FFrame &, void *);
    void execQuatDot(FFrame &, void *);
    void execQuatInvert(FFrame &, void *);
    void execQuatRotateVector(FFrame &, void *);
    void execQuatFindBetween(FFrame &, void *);
    void execQuatFromAxisAndAngle(FFrame &, void *);
    void execQuatFromRotator(FFrame &, void *);
    void execQuatToRotator(FFrame &, void *);
    void execQuatSlerp(FFrame &, void *);
    void execAdd_QuatQuat(FFrame &, void *);
    void execSubtract_QuatQuat(FFrame &, void *);
    void execAdd_Vector2DVector2D(FFrame &, void *);
    void execSubtract_Vector2DVector2D(FFrame &, void *);
    void execMultiply_Vector2DFloat(FFrame &, void *);
    void execDivide_Vector2DFloat(FFrame &, void *);
    void execMultiplyEqual_Vector2DFloat(FFrame &, void *);
    void execDivideEqual_Vector2DFloat(FFrame &, void *);
    void execAddEqual_Vector2DVector2D(FFrame &, void *);
    void execSubtractEqual_Vector2DVector2D(FFrame &, void *);
    void execGetMappedRangeValue(FFrame &, void *);
    void execEvalInterpCurveVector2D(FFrame &, void *);
    void execEvalInterpCurveVector(FFrame &, void *);
    void execEvalInterpCurveFloat(FFrame &, void *);
    void execEqualEqual_ObjectObject(FFrame &, void *);
    void execNotEqual_ObjectObject(FFrame &, void *);
    void execEqualEqual_InterfaceInterface(FFrame &, void *);
    void execNotEqual_InterfaceInterface(FFrame &, void *);
    void execEqualEqual_NameName(FFrame &, void *);
    void execNotEqual_NameName(FFrame &, void *);
    void execLogInternal(FFrame &, void *);
    void execWarnInternal(FFrame &, void *);
    void execConditional(FFrame &, void *);
    void execNew(FFrame &, void *);
    void execClassIsChildOf(FFrame &, void *);
    void execClassContext(FFrame &, void *);
    void execGoto(FFrame &, void *);
    void execGotoState(FFrame &, void *);
    void execPushState(FFrame &, void *);
    void execPopState(FFrame &, void *);
    void execDumpStateStack(FFrame &, void *);
    void execIsA(FFrame &, void *);
    void execEnable(FFrame &, void *);
    void execDisable(FFrame &, void *);
    void execIterator(FFrame &, void *);
    void execLocalize(FFrame &, void *);
    void execNativeParm(FFrame &, void *);
    void execSaveConfig(FFrame &, void *);
    void execStaticSaveConfig(FFrame &, void *);
    void execImportJSON(FFrame &, void *);
    void execGetPerObjectConfigSections(FFrame &, void *);
    void execGetEnum(FFrame &, void *);
    void execDynamicLoadObject(FFrame &, void *);
    void execFindObject(FFrame &, void *);
    void execIsAsyncLoadingActive(FFrame &, void *);
    void execIsInState(FFrame &, void *);
    void execIsChildState(FFrame &, void *);
    void execGetStateName(FFrame &, void *);
    void execGetFuncName(FFrame &, void *);
    void execDebugBreak(FFrame &, void *);
    void execScriptTrace(FFrame &, void *);
    void execGetScriptTrace(FFrame &, void *);
    void execSetUTracing(FFrame &, void *);
    void execIsUTracing(FFrame &, void *);
    void execHighNative0(FFrame &, void *);
    void execHighNative1(FFrame &, void *);
    void execHighNative2(FFrame &, void *);
    void execHighNative3(FFrame &, void *);
    void execHighNative4(FFrame &, void *);
    void execHighNative5(FFrame &, void *);
    void execHighNative6(FFrame &, void *);
    void execHighNative7(FFrame &, void *);
    void execHighNative8(FFrame &, void *);
    void execHighNative9(FFrame &, void *);
    void execHighNative10(FFrame &, void *);
    void execHighNative11(FFrame &, void *);
    void execHighNative12(FFrame &, void *);
    void execHighNative13(FFrame &, void *);
    void execHighNative14(FFrame &, void *);
    void execHighNative15(FFrame &, void *);
    void execProjectOnTo(FFrame &, void *);
    void execIsZero(FFrame &, void *);
    void execPathName(FFrame &, void *);
    void execTimeStamp(FFrame &, void *);
    void execGetSystemTime(FFrame &, void *);
    void execIsPendingKill(FFrame &, void *);
    void execTransformVectorByRotation(FFrame &, void *);
    void execGetEngineVersion(FFrame &, void *);
    void execGetBuildChangelistNumber(FFrame &, void *);
    void execJumpIfNotEditorOnly(FFrame &, void *);
    void execGetLanguage(FFrame &, void *);
    void execInvalidateGuid(FFrame &, void *);
    void execIsGuidValid(FFrame &, void *);
    void execCreateGuid(FFrame &, void *);
    void execGetGuidFromString(FFrame &, void *);
    void execGetStringFromGuid(FFrame &, void *);
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
    static UClass *PrivateStaticClass;
    unsigned int UClassData[0x26];
};

class UHaloSaveGame : public UObject  // size 0x68, opaque
{
public:
    enum
    {
        IsIntrinsic = 0,
    };
    TArray<unsigned char,FDefaultAllocator> BasicSerializeObject(UObject *, int);
    unsigned int BasicDeserializeObject(UObject *, int, const TArray<unsigned char,FDefaultAllocator> &);
    void execBasicSerializeObject(FFrame &, void *);
    void execBasicDeserializeObject(FFrame &, void *);
private:
    UHaloSaveGame &operator=(const UHaloSaveGame &);
public:
    static UClass *GetPrivateStaticClassUHaloSaveGame(const wchar_t *);
    static void InitializePrivateStaticClassUHaloSaveGame();
    static UClass *StaticClass();
    static void *operator new(const unsigned int, EInternal *);
    static void *operator new(const unsigned int, UObject *, FName, unsigned __int64);
protected:
    virtual ~UHaloSaveGame();
public:
    static void InternalConstructor(void *);
protected:
    UHaloSaveGame();
private:
    static UClass *PrivateStaticClass;
    unsigned int UHaloSaveGameData[0xB];
};

#include "Core/Inc/UnObjBas.h"

inline UHaloSaveGame::UHaloSaveGame() {}
inline UClass *UHaloSaveGame::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUHaloSaveGame(L"MegaHaloGame");
        InitializePrivateStaticClassUHaloSaveGame();
    }
    return PrivateStaticClass;
}
inline UHaloSaveGame::~UHaloSaveGame() { ConditionalDestroy(); }
inline void *UHaloSaveGame::operator new(const unsigned int, EInternal *InMem) { return (void *)InMem; }
inline void UHaloSaveGame::InternalConstructor(void *X) { new ((EInternal *)X) UHaloSaveGame; }


// ---- written by hand below this line (gen_header.py keeps it) ----
