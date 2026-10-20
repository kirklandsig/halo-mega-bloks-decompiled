// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsstat.cpp: the CCS layer's stats: a stat group and four cycle counters
// (the whole CCS update, the behaviour trees, cover and target awareness).
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnStats.h"

// The CCS stat ids, after the engine's own (UnStats.h's enums)
enum
{
    STATGROUP_CCS = 11001,
};
enum
{
    STAT_CCSComplete = 7010,
    STAT_CCSBehaviorTree,
    STAT_CCSCover,
    STAT_CCSTargetAwareness,
};

#line 29
DECLARE_STATS_GROUP(L"CCS", STATGROUP_CCS);

DECLARE_CYCLE_STAT(L"   Target Awareness", STAT_CCSTargetAwareness, STATGROUP_CCS);
DECLARE_CYCLE_STAT(L"   Cover", STAT_CCSCover, STATGROUP_CCS);
DECLARE_CYCLE_STAT(L"   Behavior Tree", STAT_CCSBehaviorTree, STATGROUP_CCS);
DECLARE_CYCLE_STAT(L"CCS System", STAT_CCSComplete, STATGROUP_CCS);

// The stat objects' initializers
// @retail 0x84289220
// `dynamic initializer for 'GroupFactory_STATGROUP_CCS''
// @retail 0x84289238
// `dynamic initializer for 'StatFactory_UE3_STAT_CCSTargetAwareness''
// @retail 0x84289258
// `dynamic initializer for 'StatFactory_UE3_STAT_CCSCover''
// @retail 0x84289278
// `dynamic initializer for 'StatFactory_UE3_STAT_CCSBehaviorTree''
// @retail 0x84289298
// `dynamic initializer for 'StatFactory_UE3_STAT_CCSComplete''
