// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ussbrainbuilder.cpp: the Unreal side of the brain builder: it turns a
// script behaviour tree and system config into a CCS brain, then hooks the
// brain's blackboard and action framework to their script objects and adds
// the Unreal control systems.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../CCSRef/CCSBrainBuilder.cpp"

// The constructor's out-of-line copy (it is inline in the header).
// @retail 0x83339918
// USSBrainBuilder::USSBrainBuilder (in the header)
#pragma inline_depth(0)
#ifndef HAGGAR_HOST
void EmitUSSBrainBuilderConstructor(void *pMem)
{
    new (pMem) USSBrainBuilder;
}
#endif
#pragma inline_depth()

// @retail 0x83339950
CCSSystemsConfig USSBrainBuilder::CreateConfig(FCCSSystemConfigData *pData)
{
    CCSSystemsConfig Config;
    Config.maxAwareRadius = pData->MaxAwareRadius;
    Config.maxSightRadius = pData->MaxSightRadius;
    Config.maxBehindSightRadius = pData->MaxBehindSightRadius;
    Config.maxHearingRadius = pData->MaxHearingRadius;
    Config.visionCone = pData->VisionCone;
    Config.coverQueryRadius = pData->CoverQueryRadius;
    Config.PassiveObjectiveWeight = pData->PassiveObjectiveWeight;
    Config.PassiveSecondaryWeight = pData->PassiveSecondaryWeight;
    Config.AggressiveMobileWeight = pData->AggressiveMobileWeight;
    Config.AggressiveStationaryWeight = pData->AggressiveStationaryWeight;
    Config.targetSelection = (CCS::ETargetSelectionConfig)pData->TargetSelection;
    Config.movement = (CCS::EMovementConfig)pData->Movement;
    return Config;
}

// @retail 0x833681E8
void USSBrainBuilder::SetUpBrain()
{
    CCSBrainBuilder::SetUpBrain();
    m_pBTInterface->Blackboard->Initialize(m_pBrain->GetBlackboard<GripBlackboard>());
    m_pBTInterface->ActionFramework->NativeFramework = m_pAFFramework;
    AddSystem(new CCSCSCoverUnreal(m_pCSInterface));
    if (m_pUnSystemConfigData->Movement == CCS::MovementGWNav)
    {
        AddSystem(new CCSCSMovementGwNav(m_pCSInterface));
    }
    else
    {
        AddSystem(new CCSCSMovementUnreal(m_pCSInterface));
    }
}

// USSBrainBuilder::ConstructBrain (0x833439E8) is left as todo: it passes
// the Cognition SDK's licence string to CCSRBTFactory, and that string is
// game data this repository does not publish.
