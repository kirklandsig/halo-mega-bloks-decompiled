// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsglobaldatascheduler.cpp: ticks the global data systems, each in its own
// tick group, while some sensor needs them.
#pragma once
#include "CCSGSCover.cpp"

// @retail 0x8333C020
void CCSGDS_SafeAddGroup(Grip_ArrayPOD<GripSystemTickGroup *, 2> &TickGroups, GripSystemTickGroup *pTickGroup, int, int StatId)
{
    pTickGroup->SetStatId(CCSStat::GetStatEntry(StatId));
    TickGroups.AddItem(pTickGroup);
}

// Out-of-line copies of header inlines, as in retail.
// @retail 0x8331EA50
// CCSGlobalDataScheduler::TickGroupInfo::TickGroupInfo (in the header)
// @retail 0x83321F90
// CCSStat::GetStatEntry(ECCSStat) (ccsstat.h)
// @retail 0x83321FA8
// CCSStat::GetStatEntry(int) (ccsstat.h)
#pragma inline_depth(0)
#ifndef HAGGAR_HOST
void EmitTickGroupInfo(void *pMem)
{
    new (pMem) CCSGlobalDataScheduler::TickGroupInfo;
}
#endif
GripStatEntry EmitGetStatEntry(ECCSStat Stat, int Index)
{
    CCSStat::GetStatEntry(Stat);
    return CCSStat::GetStatEntry(Index);
}
#pragma inline_depth()

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8334C3A8
CCSGlobalDataScheduler::CCSGlobalDataScheduler() : m_pGlobalBB(0)
{
}
#endif

// score 157 (was 157): retail inlines the info array's AddItem, with its
// ResizeTo, and CCSGSCover's constructor; ours calls all three. A blanket
// __forceinline on Grip_Array::AddItem gave 112 (448 bytes) but regressed
// other files, so it needs this instantiation alone.
// @retail 0x8335F260
void CCSGlobalDataScheduler::Initialize(CCSGlobalBlackboard *pGlobalBB)
{
    m_pGlobalBB = pGlobalBB;
    m_tickGroups.Reserve(CCSGlobalDataSystem::GST_NUM_OF);
    CCSGDS_SafeAddGroup(m_tickGroups, new GripSystemTickGroup, 0, CCS_STAT_Cover);
    m_tickGroupInfos.Reserve(CCSGlobalDataSystem::GST_NUM_OF);
    m_tickGroupInfos.AddItem(TickGroupInfo());
    m_tickGroupInfos[CCSGlobalDataSystem::GST_COVER].pGDS = new CCSGSCover(pGlobalBB);
    Register(m_tickGroupInfos[CCSGlobalDataSystem::GST_COVER].pGDS);
}

// @retail 0x833300A8
void CCSGlobalDataScheduler::Finalize()
{
    for (int i = 0; i < m_tickGroupInfos.Num(); i++)
    {
        if (m_tickGroupInfos[i].pGDS)
        {
            m_tickGroupInfos[i].pGDS->Finalize();
            delete m_tickGroupInfos[i].pGDS;
        }
    }
}

// @retail 0x83344478
void CCSGlobalDataScheduler::Tick(float DeltaTime)
{
    ManageSystems();
    GripSystemScheduler::Tick(DeltaTime);
}

// @retail 0x83330130
void CCSGlobalDataScheduler::RegisterSensor(const int Type)
{
    m_tickGroupInfos[Type].sensorCount++;
}

// @retail 0x83330158
void CCSGlobalDataScheduler::UnregisterSensor(const int Type)
{
    m_tickGroupInfos[Type].sensorCount--;
}

// @retail 0x8333C0D0
void CCSGlobalDataScheduler::ManageSystems()
{
    for (int i = 0; i < m_tickGroupInfos.Num(); i++)
    {
        if (m_tickGroupInfos[i].sensorCount > 0)
        {
            if (m_tickGroupInfos[i].isActive)
            {
                ActivateSystems(i);
                m_tickGroupInfos[i].isActive = false;
            }
        }
        else if (!m_tickGroupInfos[i].isActive)
        {
            DeactivateSystems(i);
            m_tickGroupInfos[i].isActive = true;
        }
    }
}

// @retail 0x83330180
void CCSGlobalDataScheduler::ActivateSystems(const int Type)
{
    Grip_ArrayPOD<GripBrainSystem *, 2> &Systems = m_tickGroups[Type]->GetSystems();
    for (int i = 0; i < Systems.Num(); i++)
    {
        Systems[i]->Activate();
    }
}

// @retail 0x833301E8
void CCSGlobalDataScheduler::DeactivateSystems(const int Type)
{
    Grip_ArrayPOD<GripBrainSystem *, 2> &Systems = m_tickGroups[Type]->GetSystems();
    for (int i = 0; i < Systems.Num(); i++)
    {
        Systems[i]->Deactivate();
    }
}
