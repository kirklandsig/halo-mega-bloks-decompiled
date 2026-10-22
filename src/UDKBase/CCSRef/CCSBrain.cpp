// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsbrain.cpp: the brain's setup and its per-frame work.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../CCSRefUE3/CCSGameCharacter.cpp"

// The CCS debug options are the third AI system the manager holds. The early
// outs are what retail's code does: each of them leaves the options unset.
static CCSDebugOptions *GetDebugOptions(GripAIManager *pAIManager)
{
    if (pAIManager == 0)
    {
        return 0;
    }
    if (pAIManager->m_aiSystems.Num() <= 2)
    {
        return 0;
    }
    return static_cast<CCSDebugOptions *>(pAIManager->m_aiSystems[2]);
}

// @retail 0x83323AF8
void CCSBrain::SetUpBlackboard(GripBlackboard *pBlackboard)
{
    m_blackboard = pBlackboard;
}

// @retail 0x83323B00
void CCSBrain::SetUpMeatPuppetQuery(IGripMeatPuppetQuery *pQuery)
{
    m_meatPuppetQuery = pQuery;
}

// @retail 0x83323B08
void CCSBrain::SetUpWorldQuery(IGripWorldQuery *pQuery)
{
    m_worldQuery = pQuery;
}

// @retail 0x83323B10
void CCSBrain::SetUpActionFramework(GripAFFramework *pFramework)
{
    m_afFramework = pFramework;
}

// @retail 0x83323B18
void CCSBrain::SetUpControlSystemInterface(CCSCSInterface *pInterface)
{
    m_csInterface = pInterface;
}

// @retail 0x83323B20
void CCSBrain::SetUpMeatPuppet(ICCSMeatPuppet *pMeatPuppet)
{
    m_meatPuppet = pMeatPuppet;
}

// @retail 0x83323B28
void CCSBrain::SetUpGlobalBlackboard(CCSGlobalBlackboard *pBlackboard)
{
    m_pGlobalBB = pBlackboard;
}

// @retail 0x83323C28
float CCSBrain::GetRandomFloat()
{
    return Grip::Alg::Random::GetUnitFloat();
}

// @retail 0x83323B38
GripAFScheduler *CCSBrain::GetActionScheduler()
{
    if (m_afFramework == 0)
    {
        return 0;
    }
    return m_afFramework->GetScheduler();
}

// @retail 0x83323B50
GripAFFactory *CCSBrain::GetActionFactoryInternal()
{
    if (m_afFramework == 0)
    {
        return 0;
    }
    return m_afFramework->GetFactory();
}

// @retail 0x83323B68
GripBlackboard *CCSBrain::GetBlackboardInternal()
{
    return m_blackboard;
}

// @retail 0x8332E9F0
IGripMeatPuppetQuery *CCSBrain::GetMeatPuppetQueryInternal()
{
    return m_meatPuppetQuery;
}

// @retail 0x8332E9F8
IGripWorldQuery *CCSBrain::GetWorldQueryInternal()
{
    return m_worldQuery;
}

// ccsbrain.h's getters
// @retail 0x83320518
ICCSMeatPuppet *CCSBrain::GetMeatPuppet()
{
    return m_meatPuppet;
}

// @retail 0x83320520
CCSGlobalBlackboard *CCSBrain::GetGlobalBB()
{
    return m_pGlobalBB;
}

// @retail 0x83344180
void CCSBrain::CompleteSetUp()
{
    GripBrain::CompleteSetUp();
    InitializeSystems();
}

// @retail 0x83323B70
void CCSBrain::Tick(float DeltaTime)
{
    GripScopeCycleCounter CycleCounter(CCSStat::GetStatEntry(CCS_STAT_Complete));
    GripBrain::Tick(DeltaTime);
}

// @retail 0x83323BD0
void CCSBrain::TickBehaviorTree()
{
    GripScopeCycleCounter CycleCounter(CCSStat::GetStatEntry(CCS_STAT_BehaviorTree));
    GripBrain::TickBehaviorTree();
}

// @retail 0x8333B8C8
void CCSBrain::InitializeSystems()
{
    m_blackboard->GetUsedPerceptionSystems(m_ssFlags, m_asFlags);
    InitializePerceptionSystems(m_systems.GetSystems(0), m_systemsConfig, m_ssFlags);
    InitializePerceptionSystems(m_systems.GetSystems(1), m_systemsConfig, m_asFlags);
    InitializeControlSystems(m_systemsConfig);
    SchedulerRegistration();
}

// @retail 0x8333B860
void CCSBrain::SetUpSystemConfig(const CCSSystemsConfig &Config)
{
    m_systemsConfig.maxAwareRadius = Config.maxAwareRadius;
    m_systemsConfig.maxSightRadius = Config.maxSightRadius;
    m_systemsConfig.maxBehindSightRadius = Config.maxBehindSightRadius;
    m_systemsConfig.maxHearingRadius = Config.maxHearingRadius;
    m_systemsConfig.visionCone = Config.visionCone;
    m_systemsConfig.coverQueryRadius = Config.coverQueryRadius;
    m_systemsConfig.PassiveObjectiveWeight = Config.PassiveObjectiveWeight;
    m_systemsConfig.PassiveSecondaryWeight = Config.PassiveSecondaryWeight;
    m_systemsConfig.AggressiveMobileWeight = Config.AggressiveMobileWeight;
    m_systemsConfig.AggressiveStationaryWeight = Config.AggressiveStationaryWeight;
    m_systemsConfig.targetSelection = Config.targetSelection;
    m_systemsConfig.movement = Config.movement;
}

// @retail 0x8332EBA0
void CCSBrain::TickSystems(float DeltaTime)
{
    if (m_afFramework != 0)
    {
        m_afFramework->Tick(DeltaTime);
    }
    Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Systems = m_systems.GetSystems(2);
    for (int i = 0; i < Systems.Num(); i++)
    {
        GripBrainSystem *pSystem = Systems[i];
        if (pSystem != 0 && pSystem->m_activationState != GripBrainSystem::AS_INACTIVE)
        {
            pSystem->Tick(DeltaTime);
        }
    }
}

// @retail 0x8332EC40
void CCSBrain::InitializePerceptionSystems(Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Systems, const CCSSystemsConfig &Config, const GripBTSystemFlags &Flags)
{
    for (int i = 0; i < Systems.Num(); i++)
    {
        if (Systems[i] == 0)
        {
            continue;
        }
        if (Flags.TestFlag(i))
        {
            Systems[i]->FlagAsUsed();
        }
        if (Systems[i]->m_used)
        {
            Systems[i]->Initialize(&Config);
            Systems[i]->Activate();
        }
    }
}

// @retail 0x8332ED08
void CCSBrain::InitializeControlSystems(const CCSSystemsConfig &Config)
{
    Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Systems = m_systems.GetSystems(2);
    for (int i = 0; i < Systems.Num(); i++)
    {
        if (Systems[i] != 0)
        {
            static_cast<CCSControlSystem *>(Systems[i])->Initialize(&Config);
        }
    }
}

// @retail 0x8332E950
CCSBrain::CCSBrain(GripRBTTree *pTree)
    : GripBrain(pTree)
    , m_meatPuppet(0)
    , m_ssFlags()
    , m_asFlags()
    , m_blackboard(0)
    , m_pGlobalBB(0)
    , m_afFramework(0)
    , m_systemsConfig()
    , m_meatPuppetQuery(0)
    , m_worldQuery(0)
{
}

// @retail 0x8332EA10
CCSBrain::~CCSBrain()
{
    delete m_afFramework;
    m_afFramework = 0;
    delete m_csInterface;
    m_csInterface = 0;
    delete m_meatPuppetQuery;
    m_meatPuppetQuery = 0;
    delete m_worldQuery;
    m_worldQuery = 0;
    delete m_blackboard;
    m_blackboard = 0;
}

// @retail 0x8333B960
// score 1 (was 1): the indexed load of the array element has its two
// registers the other way round: retail loads the element with the byte
// offset first (lwzx r10, r31, r11), ours with the data pointer first
// (lwzx r10, r11, r31) in the second loop only. The order is the
// commutative add inside the inlined Grip_Array::operator[], and MSVC
// picks it per loop. Tried: a named element, a pointer to the data, the
// const overload of operator[], a while loop, an unsigned index, the
// guard as a truth test and inside the loop condition, the shared
// operator[] inline itself, and the permuter (6.7k rewrites); also a
// reference binding, address-of, a hoisted Num(), GetData()[i] and
// m_ContainerContent[i], the offset written before the base in the
// pointer arithmetic, the guard in its other spellings, the declaration
// order, and a file-local helper that indexes the array. Newly tried:
// the source shape the retail line table implies (the loop variable
// declared before the loop, the element in a named temporary, one test
// per line, the second loop with a variable of its own), the element
// read through a pointer to the array, the count hoisted out of the
// condition, the index as unsigned and the loop variable renamed through
// twelve names, the index into m_aiSystems spelled four ways, ten other
// unity translation units included, the shared operator[] inline
// respelled three ways (char* arithmetic, a scaled index, a plain
// pointer add), and the two functions swapped in the file. None of them
// moves the order of the two registers; the same source shape compiles
// to one order in the perception loop and the other in the control loop,
// so it is the compiler's choice, not the spelling.
void CCSBrain::SchedulerRegistration()
{
    GripAIManager *pAIManager = GripEngineServices::GetAIManager();
    if (pAIManager == 0)
    {
        return;
    }
    if (pAIManager->m_aiSystems.Num() <= 1)
    {
        return;
    }
    CCSAISystem *pCCSSystem = static_cast<CCSAISystem *>(pAIManager->m_aiSystems[1]);
    if (pCCSSystem == 0)
    {
        return;
    }
    GripSystemScheduler *pSensorScheduler = &pCCSSystem->m_sensorScheduler;
    Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Perception = m_systems.GetSystems(0);
    for (int i = 0; i < Perception.Num(); i++)
    {
        if (Perception[i] != 0 && Perception[i]->m_used)
        {
            pSensorScheduler->Register(Perception[i]);
        }
    }
    GripSystemScheduler *pAnalysisScheduler = &pCCSSystem->m_analysisScheduler;
    Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Control = m_systems.GetSystems(1);
    if (pAnalysisScheduler != 0)
    {
        for (int i = 0; i < Control.Num(); i++)
        {
            if (Control[i] != 0 && Control[i]->m_used)
            {
                pAnalysisScheduler->Register(Control[i]);
            }
        }
    }
}

// @retail 0x8333BA88
// score 1 (was 1): the indexed load of the array element has its two
// registers the other way round: retail loads the element with the data
// pointer first (lwzx r4, r11, r31) in the first loop, ours with the byte
// offset first (lwzx r4, r31, r11). The order is the commutative add
// inside the inlined Grip_Array::operator[], and MSVC picks it per loop.
// Tried: a named element, a pointer to the data, the const overload of
// operator[], a while loop, an unsigned index, the shared operator[]
// inline itself, and the permuter (6.7k rewrites); also a reference
// binding, address-of, a hoisted Num(), GetData()[i] and
// m_ContainerContent[i], the offset written before the base in the
// pointer arithmetic, the guard in its other spellings, the declaration
// order, and a file-local helper that indexes the array. Newly tried:
// the element read through a pointer to the array, the count hoisted out
// of the condition, the index as unsigned, the loop variable renamed
// through twelve names, the index into m_aiSystems spelled four ways,
// ten other unity translation units included, the shared operator[]
// inline respelled three ways, and the two functions swapped in the
// file. None of them moves the order of the two registers; taking the
// guard away flips the order of the *other* loop instead, and changes
// the code. Retail's own two loops here differ in the order although the
// source of the two is symmetric, so the choice is the compiler's and
// the spelling of the loop cannot reach it.
void CCSBrain::SchedulerUnregistration()
{
    GripAIManager *pAIManager = GripEngineServices::GetAIManager();
    if (pAIManager == 0)
    {
        return;
    }
    if (pAIManager->m_aiSystems.Num() <= 1)
    {
        return;
    }
    CCSAISystem *pCCSSystem = static_cast<CCSAISystem *>(pAIManager->m_aiSystems[1]);
    if (pCCSSystem == 0)
    {
        return;
    }
    GripSystemScheduler *pAnalysisScheduler = &pCCSSystem->m_analysisScheduler;
    Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Control = m_systems.GetSystems(1);
    if (pAnalysisScheduler != 0)
    {
        for (int i = 0; i < Control.Num(); i++)
        {
            pAnalysisScheduler->Unregister(Control[i]);
        }
    }
    GripSystemScheduler *pSensorScheduler = &pCCSSystem->m_sensorScheduler;
    Grip_Array<GripBrainSystem *, Grip::AllocatorGH<GripBrainSystem *, 2> > &Perception = m_systems.GetSystems(0);
    if (pSensorScheduler != 0)
    {
        for (int i = 0; i < Perception.Num(); i++)
        {
            pSensorScheduler->Unregister(Perception[i]);
        }
    }
}

// @retail 0x8333BB88
void CCSBrain::DrawHUD(GripHUDRenderer *pRenderer, int &Y)
{
    GripBrain::DrawHUD(pRenderer, Y);
    GripAIManager *pAIManager = GripEngineServices::GetAIManager();
    CCSDebugOptions *pOptions = GetDebugOptions(pAIManager);
    if (this->GetActionScheduler() != 0)
    {
        if (pOptions != 0 && pOptions->m_options[CCSDebugOptions::ACTION_SCHEDULER])
        {
            this->GetActionScheduler()->DrawHUD(pRenderer, Y);
            Y += pRenderer->endl;
        }
    }
    if (pOptions != 0 && pOptions->m_options[CCSDebugOptions::ANIM_FLAGS])
    {
        m_meatPuppet->DrawHUD(pRenderer, Y);
        Y += pRenderer->endl;
    }
}

// Adds the brain's own debug marker, 20 units above the pawn.
// @retail 0x8333BC98
void CCSBrain::CreateDebugRenderingProxies(Grip_ArrayPOD<IGripSRProxy *, 2> &Proxies)
{
    GripBrain::CreateDebugRenderingProxies(Proxies);
    CCSCharacter Character = m_meatPuppet->GetCharacter();
    Grip_Vector Position = Character.GetPosition();
    Position.Z = Character.GetHeight() + Position.Z + 20.0f;
    Proxies.AddItem(new GripBrainRenderingProxy(Position, 1.0f, m_debug, m_disabled));
}
