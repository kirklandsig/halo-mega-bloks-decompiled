// MegaHaloGameClasses.h's hand-written part: inline bodies the PDB has no
// code for, written from the disassembly. Included at the end of that header.
#pragma once

#ifndef HAGGAR_HOST
// unarc.h: the archive base and the memory and proxy archives
// FArchive::Reset() writes the three engine version globals and the flag
// defaults. The body has to be visible here: with only the declaration the
// compiler treats the call as opaque and schedules the archive's fields
// differently from retail.
extern int GEngineVer;
extern int GEngineNetVer;
extern int GEngineLicenseeVer;
inline void FArchive::Reset()
{
    ArVer = GEngineVer;
    ArNetVer = GEngineNetVer;
    ArLicenseeVer = GEngineLicenseeVer;
    ArIsLoading = 0;
    ArIsSaving = 0;
    ArIsTransacting = 0;
    ArWantBinaryPropertySerialization = 0;
    ArForceUnicode = 0;
    ArIsPersistent = 0;
    ArForEdit = 1;
    ArForClient = 1;
    ArForServer = 1;
    ArIsError = 0;
    ArIsCriticalError = 0;
    ArContainsCookedData = 0;
    ArContainsCode = 0;
    ArContainsMap = 0;
    ArForceByteSwapping = 0;
    ArSerializingDefaults = 0;
    ArIgnoreArchetypeRef = 0;
    ArIgnoreOuterRef = 0;
    ArIgnoreClassRef = 0;
    ArAllowEliminatingReferences = 1;
    ArAllowLazyLoading = 0;
    ArIsObjectReferenceCollector = 0;
    ArIsCountingMemory = 0;
    ArPortFlags = 0;
    ArShouldSkipBulkData = 0;
    ArIsSaveGame = 0;
    ArIsFinalPackageSave = 0;
    ArMaxSerializeSize = 0;
    ArIsFilterEditorOnly = 0;
}
inline FArchive::FArchive() { Reset(); }
inline FArchive::~FArchive() {}
inline void FArchive::SetIsSaveGame(unsigned int bInIsSaveGame) { ArIsSaveGame = bInIsSaveGame; }
inline FArchive &operator<<(FArchive &Ar, int &Value)
{
    Ar.Serialize(&Value, sizeof(Value));
    return Ar;
}

inline FMemoryArchive::FMemoryArchive(TArray<unsigned char, FDefaultAllocator> &InBytes)
    : Offset(0), Bytes(InBytes)
{
}
inline FMemoryWriter::FMemoryWriter(TArray<unsigned char, FDefaultAllocator> &InBytes, unsigned int bIsPersistent)
    : FMemoryArchive(InBytes)
{
    ArIsSaving = 1;
    ArIsPersistent = bIsPersistent;
}
inline FMemoryReader::FMemoryReader(TArray<unsigned char, FDefaultAllocator> &InBytes, unsigned int bIsPersistent)
    : FMemoryArchive(InBytes)
{
    ArIsLoading = 1;
    ArIsPersistent = bIsPersistent;
}

// FArchiveProxy's constructor copies the inner archive's flags. Its body has
// to be visible here for the same reason as FArchive::Reset()'s: with only
// the declaration the call is opaque and the caller schedules its own fields
// differently from retail. Written from the retail copy at 0x824B1458: the
// base constructor (FArchive::Reset) fills the flags, the proxy then copies
// the inner archive's, except ArIsTransacting and ArIsFilterEditorOnly, which
// it zeroes, and ArContainsCookedData, which it leaves alone.
inline FArchiveProxy::FArchiveProxy(FArchive &InInnerArchive) : InnerArchive(InInnerArchive)
{
    ArVer = InInnerArchive.ArVer;
    ArNetVer = InInnerArchive.ArNetVer & ~1;
    ArLicenseeVer = InInnerArchive.ArLicenseeVer;
    ArIsLoading = InInnerArchive.ArIsLoading;
    ArIsSaving = InInnerArchive.ArIsSaving;
    ArIsTransacting = 0;
    ArWantBinaryPropertySerialization = InInnerArchive.ArWantBinaryPropertySerialization;
    ArForceUnicode = InInnerArchive.ArForceUnicode;
    ArIsPersistent = InInnerArchive.ArIsPersistent;
    ArForEdit = InInnerArchive.ArForEdit;
    ArForClient = InInnerArchive.ArForClient;
    ArForServer = InInnerArchive.ArForServer;
    ArIsError = InInnerArchive.ArIsError;
    ArIsCriticalError = InInnerArchive.ArIsCriticalError;
    ArContainsCode = InInnerArchive.ArContainsCode;
    ArContainsMap = InInnerArchive.ArContainsMap;
    ArForceByteSwapping = InInnerArchive.ArForceByteSwapping;
    ArSerializingDefaults = InInnerArchive.ArSerializingDefaults != 0;
    ArIgnoreArchetypeRef = InInnerArchive.ArIgnoreArchetypeRef;
    ArIgnoreOuterRef = InInnerArchive.ArIgnoreOuterRef;
    ArIgnoreClassRef = InInnerArchive.ArIgnoreClassRef;
    ArAllowEliminatingReferences = InInnerArchive.ArAllowEliminatingReferences != 0;
    ArAllowLazyLoading = InInnerArchive.ArAllowLazyLoading;
    ArIsObjectReferenceCollector = InInnerArchive.ArIsObjectReferenceCollector;
    ArIsCountingMemory = InInnerArchive.ArIsCountingMemory;
    ArPortFlags = InInnerArchive.ArPortFlags;
    ArShouldSkipBulkData = InInnerArchive.ArShouldSkipBulkData;
    ArIsSaveGame = InInnerArchive.ArIsSaveGame;
    ArIsFinalPackageSave = InInnerArchive.ArIsFinalPackageSave;
    ArMaxSerializeSize = InInnerArchive.ArMaxSerializeSize;
    ArIsFilterEditorOnly = 0;
}

inline FNameAsStringProxyArchive::FNameAsStringProxyArchive(FArchive &InInnerArchive) : FArchiveProxy(InInnerArchive) {}
inline FObjectAndNameAsStringProxyArchive::FObjectAndNameAsStringProxyArchive(FArchive &InInnerArchive)
    : FNameAsStringProxyArchive(InInnerArchive)
{
}
#endif
