// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsactorfactory.cpp: Kismet's factory for a pawn with a CCS controller,
// optionally in a vehicle.
#include "UDKBase/Inc/UDKBaseClasses.h"

// retail calls the two StaticClass()s out of line (they are the header's
// inline functions, emitted as copies); MSVC inlines ours, so the class
// pointer and its initialization end up in the frame.
#pragma inline_depth(0)
static UClass *VehicleStaticClass() { return AUDKVehicle::StaticClass(); }
static UClass *GwNavPawnStaticClass() { return AGwNavPawn::StaticClass(); }
#pragma inline_depth()

// The engine's event wrappers build their parameter block inside the wrapper,
// where it is a call temporary and MSVC reuses a dead stack slot for it.
// Retail keeps the block in the caller's scope, so it gets a slot of its own;
// filling the block here reproduces that. MSVC stores the constant fields of
// a block first, so those assignments are written back to front.
static inline void CreateInventoryEvent(APawn *pPawn, UClass *NewInvClass,
                                        Pawn_eventCreateInventory_Parms &Parms)
{
    Parms.NewInvClass = NewInvClass;
    Parms.ReturnValue = 0;
    Parms.bDoNotActivate = 0;
    pPawn->ProcessEvent(pPawn->FindFunctionChecked(UDKBASE_CreateInventory, 0), &Parms, 0);
}

// score 0 (was 113): CreateActor now matches the retail. The last
// differences were in the stack frame: retail keeps the two event parameter
// blocks in the caller's scope, so each gets a slot of its own (0x88 and
// 0xa0) instead of reusing the dead spawn-name slot, and the frame grows
// from 0xf0 to 0x100. Filling the blocks here, instead of calling the engine
// wrappers that build them as call temporaries, reproduces that. The rotator
// is copied through a named local, and the two StaticClass() calls stay out
// of line, as in the retail.
// @retail 0x83342160
AActor *UCCSActorFactory::CreateActor(const FVector *const Location, const FRotator *const Rotation,
                                      const USeqAct_ActorFactory *const ActorFactoryData)
{
    AActor *pVehicle = 0;
    if (VehicleClass != 0)
    {
        NewActorClass = VehicleClass;
        SpawningVehicle = 1;
        pVehicle = UActorFactory::CreateActor(Location, Rotation, ActorFactoryData);
        if (pVehicle->IsA(VehicleStaticClass()))
        {
            Cast<AUDKVehicle>(pVehicle)->MoveToRadius = VehicleMoveToRadius;
        }
        ((USeqAct_ActorFactory *)ActorFactoryData)->bCheckSpawnCollision = 0;
        SpawningVehicle = 0;
    }
    APawn *pPawn = 0;
    if (PawnClass != 0)
    {
        pPawn = (APawn *)Super::CreateActor(Location, Rotation, ActorFactoryData);
        if (pPawn != 0)
        {
            if (ControllerClass != 0)
            {
                Controller_eventPossess_Parms PossessParms;
                FRotator SpawnRotation;
                if (Rotation != 0)
                {
                    SpawnRotation = *Rotation;
                }
                else
                {
                    SpawnRotation = ControllerClass->GetDefaultActor()->Rotation;
                }
#line 72
                check(Location);
                ACCSController *pController = (ACCSController *)GWorld->SpawnActor(ControllerClass, NAME_None, *Location, SpawnRotation, 0, 0, 0, 0, 0, 0, 0, 0);
                if (pController != 0)
                {
                    pController->SystemConfig = Config;
                    pController->BehaviorTreeTemplate = BehaviorTree;
                    if (TeamIndex == 255 && pPawn->GetTeamNum() != 255)
                    {
                        TeamIndex = pPawn->GetTeamNum();
                    }
                    pController->CCSTeam = (unsigned char)TeamIndex;
                    pController->eventSetTeam(TeamIndex);
                    // the parameter block is filled here rather than in the
                    // engine's wrapper, so that it keeps a stack slot of its own
                    PossessParms.inPawn = pPawn;
                    PossessParms.bVehicleTransition = 0;
                    pController->ProcessEvent(pController->FindFunctionChecked(UDKBASE_Possess, 0), &PossessParms, 0);
                    pController->CCSPawn->SetDefaultBehaviorTree(BehaviorTree);
                    if (pController->PlayerReplicationInfo != 0 && PawnName != L"")
                    {
                        pController->PlayerReplicationInfo->eventSetPlayerName(PawnName);
                    }
                }
            }
            if (pPawn->IsA(GwNavPawnStaticClass()))
            {
                if (Config.PassiveObjectiveWeight != -1.0f)
                {
                    pPawn->PassiveObjectiveWeight = Config.PassiveObjectiveWeight;
                }
                if (Config.PassiveSecondaryWeight != -1.0f)
                {
                    pPawn->PassiveSecondaryWeight = Config.PassiveSecondaryWeight;
                }
                if (Config.AggressiveStationaryWeight != -1.0f)
                {
                    pPawn->AggressiveStationaryWeight = Config.AggressiveStationaryWeight;
                }
                if (Config.AggressiveMobileWeight != -1.0f)
                {
                    pPawn->AggressiveMobileWeight = Config.AggressiveMobileWeight;
                }
            }
            if (bGiveDefaultInventory && pPawn->WorldInfo->Game != 0)
            {
                pPawn->WorldInfo->Game->eventAddDefaultInventory(pPawn);
            }
            Pawn_eventCreateInventory_Parms InvParms;
            for (int i = 0; i < InventoryList.Num(); i++)
            {
                CreateInventoryEvent(pPawn, InventoryList(i), InvParms);
            }
            if (pVehicle != 0)
            {
                ((AVehicle *)pVehicle)->eventGwNavBotEnterVehicle(pPawn);
            }
        }
    }
    return pVehicle != 0 ? pVehicle : pPawn;
}

// @retail 0x83328B98
unsigned int UCCSActorFactory::CanCreateActor(FString &OutErrorMsg, unsigned int bFromAssetOnly)
{
    unsigned int bResult = 1;
    if (bFromAssetOnly && PawnClass == 0)
    {
        bResult = 0;
        OutErrorMsg = L"Error_CouldNotCreateActor_NoAssetAssigned";
    }
    return bResult;
}

// @retail 0x8331E700
AActor *UCCSActorFactory::GetDefaultActor()
{
    if (SpawningVehicle && VehicleClass != 0)
    {
        NewActorClass = VehicleClass;
    }
    else if (PawnClass != 0)
    {
        NewActorClass = PawnClass;
    }
#line 152
    check(NewActorClass);
    check(!(NewActorClass->ClassFlags & CLASS_Abstract));
    return NewActorClass->GetDefaultActor();
}
