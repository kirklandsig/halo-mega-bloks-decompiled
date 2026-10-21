// EngineUtils.h: the actor iterator. Its constructor and operator++ are
// out of line in retail; operator* and the bool test inline, and operator*
// checks the actor (the checks carry EngineUtils.h's lines 272 and 273).
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

#ifndef HAGGAR_HOST
inline unsigned int UObject::HasAnyFlags(unsigned __int64 Flags) const { return (ObjectFlags & Flags) != 0; }

class FActorIteratorBase
{
protected:
    int ActorIndex;
    int LevelIndex;
    unsigned int ReachedEnd;
    int ConsideredCount;
    AActor *CurrentActor;

    FActorIteratorBase();

public:
    __forceinline AActor *operator*()
    {
        // The actor is read once, through a volatile pointer, so that the
        // compiler keeps it in a register: the checks call out, and retail
        // hands the same copy to the caller's cast.
        AActor *const Actor = *(AActor * volatile *)&CurrentActor;
#line 272
        check(Actor);
        checkf(!Actor->HasAnyFlags(RF_Unreachable), L"%s", *Actor->GetFullName(0));
        return Actor;
    }
    __forceinline operator unsigned int() { return !ReachedEnd; }
};

class FActorFilter
{
};

class FTickableLevelFilter
{
};

template <class ACTOR_FILTER_CLASS, class LEVEL_FILTER_CLASS> class TActorIteratorBase : public FActorIteratorBase
{
protected:
    TActorIteratorBase(const ACTOR_FILTER_CLASS &InFilterClass = ACTOR_FILTER_CLASS(),
                       const LEVEL_FILTER_CLASS &InLevelFilterClass = LEVEL_FILTER_CLASS())
        : FilterClass(InFilterClass), LevelFilterClass(InLevelFilterClass)
    {
    }

public:
    void operator++();

protected:
    const ACTOR_FILTER_CLASS &FilterClass;
    const LEVEL_FILTER_CLASS &LevelFilterClass;
};

class FActorIterator : public TActorIteratorBase<FActorFilter, FTickableLevelFilter>
{
public:
    FActorIterator() { ++(*this); }
};
#endif
