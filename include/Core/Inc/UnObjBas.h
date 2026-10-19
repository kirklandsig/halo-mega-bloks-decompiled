// The little of UE3's Core that n-Space's generated code expands to:
// check(), the global operator new, and UObject's inline members. Written
// from the disassembly; include it after a generated header declares
// UObject and UClass.
#pragma once

void *appMalloc(unsigned long Count, unsigned long Alignment = 8);
void appFailAssertFunc(const char *Expr, const char *File, int Line, const wchar_t *Format = L"", ...);
void appFailAssertFuncDebug(const char *Expr, const char *File, int Line, const wchar_t *Format = L"", ...);
void InitializePrivateStaticClass(UClass *TClass_Super_StaticClass, UClass *TClass_PrivateStaticClass,
                                  UClass *TClass_WithinClass_StaticClass);

inline void *operator new(unsigned int Size) { return appMalloc(Size); }

#define appDebugBreak() (*((int *)3) = 13)
#define check(expr)                                                   \
    {                                                                 \
        if (!(expr))                                                  \
        {                                                             \
            appFailAssertFuncDebug(#expr, __FILE__, __LINE__, L"");   \
            appDebugBreak();                                          \
            appFailAssertFunc(#expr, __FILE__, __LINE__, L"");        \
        }                                                             \
    }

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
