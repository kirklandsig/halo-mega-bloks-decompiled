// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsaisystem.cpp: the CCS layer's AI system: it owns the global data,
// sensor and analysis schedulers and the shared blackboard.
#pragma once
#include "CCSGlobalDataScheduler.cpp"
#include "CCSGlobalBlackboard.cpp"
#include "CCSMessengerWorker.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83354EB0
CCSAISystem::CCSAISystem(GripAIManager *pAIMgr) : GripAISystem(pAIMgr)
{
}
#endif

// @retail 0x833626F8
void CCSAISystem::Initialize(bool bConsoleLink)
{
    m_globalDataScheduler.Initialize(&m_globalBB);
    m_sensorScheduler.Initialize();
    m_analysisScheduler.Initialize();
    if (bConsoleLink)
    {
        m_pAIMgr->AddMessengerWorker(new CCSMessengerWorker(m_pAIMgr->m_pMessenger));
    }
}

// @retail 0x8333A8D0
void CCSAISystem::Finalize()
{
    m_globalDataScheduler.Finalize();
}

// @retail 0x8332E1C0
void CCSAISystem::Tick(float DeltaTime)
{
    GripScopeCycleCounter Counter(CCSStat::GetStatEntry(CCS_STAT_Complete));
    m_globalDataScheduler.Tick(DeltaTime);
    m_sensorScheduler.Tick(DeltaTime);
    m_analysisScheduler.Tick(DeltaTime);
}

// ccsaisystem.h's inline functions, out of line as in retail
#pragma inline_depth(0)
extern int (*const EmitAISystemSGetId)() = &CCSAISystem::SGetId;
extern CCSGlobalDataScheduler *(CCSAISystem::*const EmitGetGlobalDataScheduler)() = &CCSAISystem::GetGlobalDataScheduler;
extern CCSSensorScheduler *(CCSAISystem::*const EmitGetSensorScheduler)() = &CCSAISystem::GetSensorScheduler;
extern CCSAnalysisScheduler *(CCSAISystem::*const EmitGetAnalysisScheduler)() = &CCSAISystem::GetAnalysisScheduler;
extern CCSGlobalBlackboard *(CCSAISystem::*const EmitGetGlobalBB)() = &CCSAISystem::GetGlobalBB;
#pragma inline_depth()

// @retail 0x8331EA68
// CCSAISystem::SGetId (in the header)
// @retail 0x8331EA70
// CCSAISystem::GetGlobalDataScheduler (in the header)
// @retail 0x8331EA78
// CCSAISystem::GetSensorScheduler (in the header)
// @retail 0x8331EA80
// CCSAISystem::GetAnalysisScheduler (in the header)
// @retail 0x8331EA88
// CCSAISystem::GetGlobalBB (in the header)
