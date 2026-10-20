// UnStats.h: the stat factories that DECLARE_STATS_GROUP and
// DECLARE_CYCLE_STAT define at file scope; their constructors are out of
// line and they have no destructors to register.
#pragma once

enum EStatType
{
    STATTYPE_CycleCounter = 0,
};

struct FStatCommonData
{
    const wchar_t *CounterName;
    unsigned int CounterFName[2];
    const unsigned long StatId;
    unsigned long GroupId;
    unsigned int bShowStat;
};

struct FStatFactory : public FStatCommonData
{
    FStatFactory(const wchar_t *InCounterName, unsigned long InStatId, unsigned long InGroupId, EStatType InStatType);
    virtual void *CreateStat() const;
    const unsigned long GroupId;
    const EStatType StatType;
    const FStatFactory *NextFactory;
    static FStatFactory *FirstFactory;
};

struct FStatGroupFactory
{
    FStatGroupFactory(const wchar_t *InGroupDesc, unsigned long InGroupId);
    const wchar_t *GroupDesc;
    const unsigned long GroupId;
    const FStatGroupFactory *NextFactory;
    static FStatGroupFactory *FirstFactory;
};

#define DECLARE_STATS_GROUP(GroupDesc, GroupId) FStatGroupFactory GroupFactory_##GroupId(GroupDesc, GroupId)
#define DECLARE_CYCLE_STAT(CounterName, StatId, GroupId) \
    FStatFactory StatFactory_UE3_##StatId(CounterName, StatId, GroupId, STATTYPE_CycleCounter)
