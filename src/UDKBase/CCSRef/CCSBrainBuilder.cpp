// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsbrainbuilder.cpp: builds a CCS brain: the brain itself, its
// blackboard, queries, action framework and control interface, then its
// sensor and analysis systems.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSBlackboard.cpp"
#include "CCSMeatPuppetQuery.cpp"
#include "CCSWorldQuery.cpp"
#include "CCSAFInterface.cpp"
#include "CCSAFFactory.cpp"
#include "CCSCSInterface.cpp"
#include "CCSPSSelfAwareness.cpp"
#include "CCSASTarget.cpp"

// The constructor's out-of-line copy (it is inline in the header).
// @retail 0x8332ED80
// CCSBrainBuilder::CCSBrainBuilder (in the header)
#pragma inline_depth(0)
#ifndef HAGGAR_HOST
void EmitBrainBuilderConstructor(void *pMem)
{
    new (pMem) CCSBrainBuilder;
}
#endif
#pragma inline_depth()

// @retail 0x8332EDB0
void CCSBrainBuilder::ConstructBrain(GripRBTTree *pTree, ICCSMeatPuppet *pMeatPuppet, const CCSSystemsConfig &Config)
{
    m_pBrain = new CCSBrain(pTree);
    m_pMeatPuppet = pMeatPuppet;
    m_systemsConfig = Config;
}

// @retail 0x83363220
void CCSBrainBuilder::SetUpBrain()
{
    CCSBlackboard *pBlackboard = new CCSBlackboard();
    CCSMeatPuppetQuery *pMeatPuppetQuery = new CCSMeatPuppetQuery(m_pBrain);
    CCSWorldQuery *pWorldQuery = new CCSWorldQuery(m_pBrain);
    CCSAFInterface *pAFInterface = new CCSAFInterface(m_pBrain);
    CCSAFFactory *pFactory = new CCSAFFactory();
    m_pAFFramework = new GripAFFramework();
    CCSAISystem *pAISystem = GripEngineServices::GetAIManagerSystem<CCSAISystem>();
    CCSGlobalBlackboard *pGlobalBB = pAISystem != 0 ? pAISystem->GetGlobalBB() : 0;
    pBlackboard->Initialize();
    pFactory->Initialize(m_pMeatPuppet, pAFInterface);
    m_pAFFramework->Initialize(pFactory);
    m_pCSInterface = new CCSCSInterface(m_pBrain);
    m_pBrain->m_afFramework = m_pAFFramework;
    m_pBrain->m_blackboard = pBlackboard;
    m_pBrain->m_meatPuppetQuery = pMeatPuppetQuery;
    m_pBrain->m_worldQuery = pWorldQuery;
    m_pBrain->m_csInterface = m_pCSInterface;
    m_pBrain->m_meatPuppet = m_pMeatPuppet;
    m_pBrain->m_pGlobalBB = pGlobalBB;
    m_pBrain->m_systemsConfig = m_systemsConfig;
    SetUpSystems();
}

// @retail 0x83323C38
CCSBrain *CCSBrainBuilder::CookBrain()
{
    SetUpBrain();
    m_pBrain->CompleteSetUp();
    m_pBrain->NotifyBrainEvent(IGripBrainListener::SPAWNED);
    CCSBrain *pBrain = m_pBrain;
    m_pBrain = 0;
    return pBrain;
}

// @retail 0x83323CA0
void CCSBrainBuilder::AddSystem(GripBrainSystem *pSystem)
{
    m_pBrain->m_systems.Add(pSystem);
}

// @retail 0x833441B8
void CCSBrainBuilder::SetUpSystems()
{
    AddSystem(new CCSPSSelfAwareness(m_pBrain));
    AddSystem(new CCSPSTargetAwareness(m_pBrain));
    AddSystem(new CCSPSCover(m_pBrain));
    AddSystem(new CCSASTarget(m_pBrain));
    m_pBrain->m_systems.GetSystem(CCSSensorSystem::SGetFamily(), CCSSensorSystem::SST_SELF_AWARENESS)->FlagAsUsed();
}
