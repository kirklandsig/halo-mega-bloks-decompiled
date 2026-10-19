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

// UnName.h: a name compares as one 64-bit word on this target
inline unsigned int FName::operator==(const FName &Other) const
{
    return *(const unsigned __int64 *)this == *(const unsigned __int64 *)&Other;
}
inline unsigned int FName::operator!=(const FName &Other) const
{
    return *(const unsigned __int64 *)this != *(const unsigned __int64 *)&Other;
}
#ifndef HAGGAR_HOST
inline FName::FName(EName N) : Index(N), Number(0) {}
#endif

inline UClass *UObject::GetClass() const { return Class; }

// UnClass.h: field lookup by name (out of line in retail)
template <class T> T *FindField(UStruct *Owner, FName FieldName);

// Casts.h: UField classes cast by their class's cast flags, inline
#define DECLARE_CAST_BY_FLAG(ClassName)                                                       \
    template <> inline ClassName *Cast<ClassName>(UObject *Src)                               \
    {                                                                                         \
        return Src && Src->GetClass()->HasAnyCastFlag(CASTCLASS_##ClassName) ? (ClassName *)Src : 0; \
    }
inline unsigned int UClass::HasAnyCastFlag(EClassCastFlag FlagToCheck) const { return (ClassCastFlags & FlagToCheck) != 0; }

inline unsigned int UObject::IsA(const UClass *SomeBase) const
{
    if (SomeBase == 0)
    {
        return 1;
    }
    for (const UClass *TempClass = Class; TempClass; TempClass = (const UClass *)TempClass->SuperStruct)
    {
        if (TempClass == SomeBase)
        {
            return 1;
        }
    }
    return 0;
}
