// @object Unity_NullSurveysEtAl.cpp.obj
#include "Core/Inc/UnMathXe.h"
#include "MegaHaloGame/Inc/MegaHaloGameClasses.h"

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

// Not attempted yet (todo), and why:
// - AutoInitializeRegistrantsMegaHaloGame (0x833CA4D0): adds the natives to
//   GNativeLookupFuncs through TMap::Set, whose inline templates aren't written yet.
// - UHaloSaveGame::BasicSerializeObject, BasicDeserializeObject and their
//   exec thunks, the save game's destructor, and SystemSettingsSingleton's
//   atexit destructor: they inline UE3's TArray, FMemoryWriter/FMemoryReader
//   and FFrame templates, which aren't written yet.
