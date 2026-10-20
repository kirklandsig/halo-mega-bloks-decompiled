// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsanalysisscheduler.cpp: ticks the brains' analysis systems in one tick
// group.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x8333A8D8
void CCSAS_SafeAddGroup(Grip_ArrayPOD<GripSystemTickGroup *, 2> &TickGroups, GripSystemTickGroup *pTickGroup, int, int StatId)
{
    pTickGroup->SetStatId(CCSStat::GetStatEntry(StatId));
    TickGroups.AddItem(pTickGroup);
}

// @retail 0x8334BCA8
void CCSAnalysisScheduler::Initialize()
{
    m_tickGroups.Reserve(CCSAnalysisSystem::AST_NUM_OF);
    CCSAS_SafeAddGroup(m_tickGroups, new GripSystemTickGroup, CCSAnalysisSystem::AST_TARGET, -1);
}
