// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccssensorscheduler.cpp: ticks the brains' sensor systems, self awareness
// every tick and the target-awareness and cover sensors three brains a
// tick.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x83340770
void CCSSS_SafeAddGroup(Grip_ArrayPOD<GripSystemTickGroup *, 2> &TickGroups, GripSystemTickGroup *pTickGroup, int, int StatId)
{
    pTickGroup->SetStatId(CCSStat::GetStatEntry(StatId));
    TickGroups.AddItem(pTickGroup);
}

// @retail 0x8334CDF8
void CCSSensorScheduler::Initialize()
{
    m_tickGroups.Reserve(CCSSensorSystem::SST_NUM_OF);
    CCSSS_SafeAddGroup(m_tickGroups, new GripSystemTickGroup, CCSSensorSystem::SST_SELF_AWARENESS, -1);
    CCSSS_SafeAddGroup(m_tickGroups, new GripTGLowHigh(3), CCSSensorSystem::SST_TARGET_AWARENESS, CCS_STAT_TargetAwareness);
    CCSSS_SafeAddGroup(m_tickGroups, new GripTGLowHigh(3), CCSSensorSystem::SST_COVER, CCS_STAT_Cover);
}
