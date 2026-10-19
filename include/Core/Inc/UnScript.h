// The script VM's frame as exec thunks use it (UE3's UnStack.h). Include it
// after a generated header that declares FFrame with its members.
#pragma once

extern Native GNatives[];

inline void FFrame::Step(UObject *Context, void *const Result)
{
    int B = *Code++;
    (Context->*GNatives[B])(*this, Result);
}
