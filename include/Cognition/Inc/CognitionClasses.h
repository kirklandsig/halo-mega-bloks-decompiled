// Generated from the PDB by: python tools/gen_classes.py Cognition
#pragma once
#include "Core/Inc/HostGuest.h"

template <class T0, class T1> class TArray;
template <class T0, class T1> class TIndirectArray;
template <class T0, class T1, class T2> class TMap;
class AActor;
class FArchive;
struct FAsyncPackage;
class FCanvas;
class FDefaultAllocator;
class FDefaultSetAllocator;
class FEditPropertyChain;
class FExportObjectInnerContext;
class FFeedbackContext;
struct FFrame;
class FGuid;
class FName;
struct FObjectDuplicationParameters;
struct FObjectInstancingGraph;
class FOutputDevice;
struct FPropertyChangedChainEvent;
struct FPropertyChangedEvent;
struct FReferencerInformation;
struct FReferencerInformationList;
struct FScriptDelegate;
struct FStateFrame;
class FString;
class GripRBTNode;
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
class ULinkerLoad;
class ULinkerSave;
class UObject;
class UPackage;
class UPackageMap;
class UProperty;
class UState;
class UStruct;
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
enum EGotoState
{
    GOTOSTATE_NotFound = 0,
    GOTOSTATE_Success = 1,
    GOTOSTATE_Preempted = 2,
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
enum ENativeConstructor
{
    EC_NativeConstructor = 0,
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

class UGripBTPriority : public UGripBTNode  // size 0x88, opaque
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

class UGripBTTree : public UGripBTPriority  // size 0x98, opaque
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
    #else
    static hg::gptr<UClass> (&PrivateStaticClass);
    #endif
HG_PRIVATE:
    unsigned int UGripBTTreeData[0x4];
};

class UCCSBTTree : public UGripBTTree  // size 0x98, opaque
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


// ---- written by hand below this line (gen_header.py keeps it) ----
