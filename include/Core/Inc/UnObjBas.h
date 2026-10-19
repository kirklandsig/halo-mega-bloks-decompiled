// UObject's inline members, as n-Space's generated code expands them
// (check() and the memory functions are in Core.h). Written
// from the disassembly; include it after a generated header declares
// UObject and UClass.
#pragma once

#include "Core/Inc/Core.h"

void InitializePrivateStaticClass(UClass *TClass_Super_StaticClass, UClass *TClass_PrivateStaticClass,
                                  UClass *TClass_WithinClass_StaticClass);

// The first bit of a bitfield word, where script stores a bool (big-endian)
#define FIRST_BITFIELD 0x80000000

// RF_Public | RF_Standalone | RF_Transient | RF_Native, as IMPLEMENT_CLASS passes them
#define RF_IMPLEMENT_CLASS 0x0408408400004000ULL

inline const wchar_t *UObject::StaticConfigName() { return L"Engine"; }

inline UClass *UObject::StaticClass()
{
    if (!PrivateStaticClass)
    {
        PrivateStaticClass = GetPrivateStaticClassUObject(L"Core");
        InitializePrivateStaticClassUObject();
    }
    return PrivateStaticClass;
}

// IMPLEMENT_FUNCTION: a native's entry for the script VM, registered at startup
typedef void (UObject::*Native)(FFrame &TheStack, void *const Result);
unsigned char GRegisterNative(int iNative, const Native &Func);
#define IMPLEMENT_FUNCTION(cls, num, func)                       \
    extern "C" {                                                 \
    Native int##cls##func = (Native)&cls::func;                  \
    }                                                            \
    static unsigned char cls##func##Temp = GRegisterNative(num, int##cls##func);

// Cast<T>: retail calls its out-of-line copy
template <class T> T *Cast(UObject *Src);

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
inline FName::FName() {}
#endif
