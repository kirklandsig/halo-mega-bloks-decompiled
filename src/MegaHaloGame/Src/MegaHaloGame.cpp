// @object Unity_NullSurveysEtAl.cpp.obj
#include "Core/Inc/UnMathXe.h"
#include "MegaHaloGame/Inc/MegaHaloGameClasses.h"
#include "Core/Inc/Map.h"

// The vector constants' initializers (Core/Inc/UnMathXe.h)
// @retail 0x8428CAF8
// GlobalVectorConstants::`dynamic initializer for 'Float0001''
// @retail 0x8428CB18
// GlobalVectorConstants::`dynamic initializer for 'SmallLengthThreshold''
// @retail 0x8428CB38
// GlobalVectorConstants::`dynamic initializer for 'FloatOneHundredth''
// @retail 0x8428CB58
// GlobalVectorConstants::`dynamic initializer for 'Float111_Minus1''
// @retail 0x8428CB78
// GlobalVectorConstants::`dynamic initializer for 'FloatOneHalf''
// @retail 0x8428CB98
// GlobalVectorConstants::`dynamic initializer for 'QINV_SIGN_MASK''
// @retail 0x8428CBB8
// GlobalVectorConstants::`dynamic initializer for 'QMULTI_SIGN_MASK0''
// @retail 0x8428CBD8
// GlobalVectorConstants::`dynamic initializer for 'QMULTI_SIGN_MASK1''
// @retail 0x8428CBF8
// GlobalVectorConstants::`dynamic initializer for 'QMULTI_SIGN_MASK2''
// @retail 0x8428CC18
// `dynamic initializer for 'XBOXALTIVEC_ONE''
// @retail 0x8428CC38
// `dynamic initializer for 'XBOXALTIVEC_SELECT_MASK''
// @retail 0x8428CC68
// `dynamic initializer for 'XBOXALTIVEC_SWIZZLE_MASK_UNPACK''
// @retail 0x8428CCB0
// `dynamic initializer for 'XBOXALTIVEC_SWIZZLE_MASK_UNPACK_REVERSE''
// @retail 0x8428CCF8
// GlobalVectorConstants::`dynamic initializer for 'AnimWeightThreshold''
// @retail 0x8428CD18
// GlobalVectorConstants::`dynamic initializer for 'RotationSignificantThreshold''

// megahalogameclasses.h registers the class's natives
IMPLEMENT_FUNCTION(UHaloSaveGame, -1, execBasicDeserializeObject)
IMPLEMENT_FUNCTION(UHaloSaveGame, -1, execBasicSerializeObject)
// @retail 0x8428CD38
// `dynamic initializer for 'UHaloSaveGameexecBasicDeserializeObjectTemp''
// @retail 0x8428CD70
// `dynamic initializer for 'UHaloSaveGameexecBasicSerializeObjectTemp''

// @retail 0x833C9D98
void AutoGenerateNamesMegaHaloGame()
{
}

// @retail 0x833C9DA0
void appOnDownloadableContentChanged(unsigned int)
{
}

// @retail 0x833C9E18
FSystemSettings &GetSystemSettings()
{
    static FSystemSettings SystemSettingsSingleton;
    return SystemSettingsSingleton;
}
// @retail 0x842C65C8
// `GetSystemSettings'::`2'::`dynamic atexit destructor for 'SystemSettingsSingleton''

// BasicSerializeObject and BasicDeserializeObject are near: the same
// instructions as retail, only ordered differently. Serialize score 12 (was
// 12): retail materializes the TArray's zero constant first (the pool holds
// the zero, then the FArchive vtable's lis with its addi next to the
// store) where ours hoists the whole vtable constant ahead of the zero.
// Deserialize score 8 (was 8): retail stores the archive's Offset before
// materializing the constant 1, ours the other way round. In both retail
// keeps the proxy archive's vtable in r11 and the object's vtable in r5,
// ours the other way round. Tried: the order of the archive flags, an
// initializer list, a temporary proxy, the writer through an FArchive
// reference, a scope block, the copy constructor of the array, a serialize
// call in place of the operator, an initialized version variable, the
// comparison the other way round, an explicit temporary for the array, the
// TArray's constructor as an assignment, the retail's line spacing (from
// the PDB's line table), casts and named locals around the serialize call,
// and the permuter (once per function): none of them move the score.
// @retail 0x833C9E98
TArray<unsigned char, FDefaultAllocator> UHaloSaveGame::BasicSerializeObject(UObject *Obj, int Version)
{
    TArray<unsigned char, FDefaultAllocator> SaveData;
    FMemoryWriter MemoryWriter(SaveData, 1);
    MemoryWriter.SetIsSaveGame(1);
    MemoryWriter << Version;
    FObjectAndNameAsStringProxyArchive Ar(MemoryWriter);
    Obj->Serialize(Ar);
    return SaveData;
}

// @retail 0x833C9F50
unsigned int UHaloSaveGame::BasicDeserializeObject(UObject *Obj, int Version, const TArray<unsigned char, FDefaultAllocator> &InSaveGameData)
{
    TArray<unsigned char, FDefaultAllocator> SaveData = InSaveGameData;
    FMemoryReader MemoryReader(SaveData, 1);
    MemoryReader.SetIsSaveGame(1);
    int SavedVersion;
    MemoryReader << SavedVersion;
    if (SavedVersion != Version)
    {
        return 0;
    }
    FObjectAndNameAsStringProxyArchive Ar(MemoryReader);
    Obj->Serialize(Ar);
    return 1;
}

// The native lookup table (megahalogameclasses.h, NATIVES_ONLY) and the map
// it is registered in (UnScript.cpp).
struct FNativeFunctionLookup
{
    const char *Name;
    void (UObject::*Pointer)(FFrame &, void *const);
};
extern FNativeFunctionLookup GMegaHaloGameUHaloSaveGameNatives[];
extern TMap<FName, FNativeFunctionLookup *, FDefaultSetAllocator> GNativeLookupFuncs;

// AUTO_INITIALIZE_REGISTRANTS_MEGAHALOGAME
// @retail 0x833CA4D0
void AutoInitializeRegistrantsMegaHaloGame(int &)
{
    UHaloSaveGame::StaticClass();
    GNativeLookupFuncs.Set(FName("HaloSaveGame", FNAME_Add), GMegaHaloGameUHaloSaveGameNatives);
}
