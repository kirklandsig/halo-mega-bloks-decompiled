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

// The Cognition SDK's licence string, which CCSRBTFactory checks. It is game
// data, so the repository doesn't define it: the comparison masks the
// relocation that addresses it, and a build that links this file defines it
// from its own copy of the game (the basefile's string at 0x821F9240).
extern const char GCognitionLicense[];

#ifndef HAGGAR_HOST  // it builds guest objects; it stays recompiled in the port
// score 19 (was 19), near: after the mediator's allocation retail copies the
// result to r11 before the null check, ours inside the constructor's path (so
// the vtable addresses land in r5..r7 there, r6..r8 here). The new-expression's
// form is the suspect; the mediator's constructor written with assignments
// changes nothing. Everything else in the function matches byte for byte, so
// only the copy's place differs. Tried: the mediator assigned to the
// interface pointer first, the interface pointer initialised before the if,
// the two setters swapped, an explicit cast in the assignment, new T() with
// parentheses, the concrete pointer declared outside the if, an explicit null
// check, and the permuter (600s).
// @retail 0x833439E8
void USSBrainBuilder::ConstructBrain(UObject *pOwner, UCCSBTTree *pBTTree, ICCSMeatPuppet *pMeatPuppet,
                                     FCCSSystemConfigData *pSystemConfigData, UGripBTInterface *pBTInterface,
                                     UGripBTScriptNodeCache *pScriptNodeCache)
{
    m_pBTInterface = pBTInterface;
    m_pUnSystemConfigData = pSystemConfigData;
    CCSSystemsConfig Config = CreateConfig(pSystemConfigData);
    GripUnrealRBTFactory Factory(new CCSRBTFactory(GCognitionLicense), pBTInterface, pOwner);
    GripRBTTree *pTree = Factory.Instantiate(pBTTree);
    pTree->SetName(*pBTTree->GetName());
    Grip_ArrayPOD<UGripBTScriptNode *, 2> &ScriptNodes = Factory.GetScriptNodeOwnership();
    for (int i = 0; i < ScriptNodes.Num(); i++)
    {
        pScriptNodeCache->ScriptNodes.AddItem(ScriptNodes[i]);
    }
    IGripBTScriptNodeMediator *pMediator;
    if (ScriptNodes.Num() > 0)
    {
        GripBTScriptNodeMediator *pScriptNodeMediator = new GripBTScriptNodeMediator;
        pScriptNodeMediator->SetScriptNodeCache(pScriptNodeCache);
        pScriptNodeMediator->SetBTInterface(pBTInterface);
        pMediator = pScriptNodeMediator;
        pMediator->InitializeAllNodes();
    }
    else
    {
        pMediator = 0;
    }
    pTree->SetScriptNodeMediator(pMediator);
    pTree->GripBTInitialize();
    CCSBrainBuilder::ConstructBrain(pTree, pMeatPuppet, Config);
}
#endif
