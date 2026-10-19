// The base of UE3's Core that inline code expands to: memory, check(), the
// global operator new and delete. Written from the disassembly. Generated
// headers include it first.
#pragma once

#ifndef HAGGAR_HOST
// UE3's platform header turns this one off: classes with reference members
// (FArchiveProxy, FMemoryArchive) can't have an assignment operator.
#pragma warning(disable : 4512)
// ...and this one: anonymous structs in unions (FColor)
#pragma warning(disable : 4201)
// ...and these: a class whose base's constructor takes a defaulted argument
// the PDB doesn't record (FOutputDeviceRedirectorBase)
#pragma warning(disable : 4510 4610)

// The CRT's, declared here (the XDK's CRT headers aren't needed)
extern "C" void *memcpy(void *Dest, const void *Src, unsigned int Count);
extern "C" void *memmove(void *Dest, const void *Src, unsigned int Count);
extern "C" void *memset(void *Dest, int Value, unsigned int Count);
extern "C" double __fsqrt(double);
extern "C" float __fsqrts(float);
#pragma intrinsic(__fsqrts)
#pragma intrinsic(__fsqrt)
extern "C" int rand();
extern "C" double atan(double);
inline void *operator new(unsigned int, void *Mem) throw() { return Mem; }
inline void operator delete(void *, void *) throw() {}
#else
#include <cstring>
#include <new>
#include <cmath>
#include <cstdlib>
#endif

enum ENoInit
{
    E_NoInit = 0,
};

#define DEFAULT_ALIGNMENT 8
#define INDEX_NONE -1

void *appMalloc(unsigned long Count, unsigned long Alignment = DEFAULT_ALIGNMENT);
void *appRealloc(void *Original, unsigned long Count, unsigned long Alignment = DEFAULT_ALIGNMENT);
void appFree(void *Original);
inline void *appMemcpy(void *Dest, const void *Src, int Count) { return memcpy(Dest, Src, Count); }
inline void *appMemmove(void *Dest, const void *Src, int Count) { return memmove(Dest, Src, Count); }
inline void appMemzero(void *Dest, int Count) { memset(Dest, 0, Count); }
#ifndef HAGGAR_HOST
inline float appSqrt(float F) { return __fsqrts(F); }
inline float appInvSqrt(float F) { return (float)(1.0 / __fsqrt(F)); }
inline float appAtan(float Value) { return (float)atan(Value); }
#else
inline float appSqrt(float F) { return (float)std::sqrt(F); }
inline float appInvSqrt(float F) { return (float)(1.0 / std::sqrt(F)); }
inline float appAtan(float Value) { return (float)std::atan(Value); }
#endif

#define SMALL_NUMBER (1.e-8f)

#ifndef HAGGAR_HOST
inline void *operator new(unsigned int Size) { return appMalloc(Size); }
inline void operator delete(void *Ptr) { appFree(Ptr); }
inline void *operator new[](unsigned int Size) { return appMalloc(Size); }
inline void operator delete[](void *Ptr) { appFree(Ptr); }
#endif

void appFailAssertFunc(const char *Expr, const char *File, int Line, const wchar_t *Format = L"", ...);
void appFailAssertFuncDebug(const char *Expr, const char *File, int Line, const wchar_t *Format = L"", ...);

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

template <class T> inline T Min(const T A, const T B) { return (A <= B) ? A : B; }
template <class T> inline T Max(const T A, const T B) { return (A >= B) ? A : B; }
template <class T> inline T Clamp(const T X, const T Lo, const T Hi) { return X < Lo ? Lo : X < Hi ? X : Hi; }
#ifndef HAGGAR_HOST
// floats select without a branch on this target
extern "C" double __fsel(double Comparand, double ValGE, double ValLT);
#pragma intrinsic(__fsel)
template <> inline float Min(const float A, const float B) { return (float)__fsel(A - B, B, A); }
template <> inline float Max(const float A, const float B) { return (float)__fsel(A - B, A, B); }
#endif
