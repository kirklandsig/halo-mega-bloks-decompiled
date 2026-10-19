// The script VM's frame as exec thunks use it (UE3's UnStack.h). Include it
// after a generated header that declares FFrame with its members.
#pragma once

extern Native GNatives[];

// Where a P_GET_*_REF parameter's script variable lives (set by Stack.Step)
extern unsigned char *GPropAddr;
extern UObject *GPropObject;
extern UProperty *GProperty;

// Set while a function runs whose optional parameter the caller skipped
extern unsigned long GRuntimeUCFlags;
#define RUC_SkippedOptionalParm 0x02

inline void FFrame::Step(UObject *Context, void *const Result)
{
    int B = *Code++;
    (Context->*GNatives[B])(*this, Result);
}
