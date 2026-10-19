// MegaHaloGameClasses.h's hand-written part: inline bodies the PDB has no
// code for, written from the disassembly. Included at the end of that header.
#pragma once

#ifndef HAGGAR_HOST
// unarc.h: the archive base and the memory and proxy archives
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

inline FNameAsStringProxyArchive::FNameAsStringProxyArchive(FArchive &InInnerArchive) : FArchiveProxy(InInnerArchive) {}
inline FObjectAndNameAsStringProxyArchive::FObjectAndNameAsStringProxyArchive(FArchive &InInnerArchive)
    : FNameAsStringProxyArchive(InInnerArchive)
{
}
#endif
