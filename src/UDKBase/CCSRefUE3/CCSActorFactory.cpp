// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsactorfactory.cpp: Kismet's factory for a pawn with a CCS controller,
// optionally in a vehicle.
#include "UDKBase/Inc/UDKBaseClasses.h"

// Todo (976 bytes vs 1,044): retail calls AUDKVehicle::StaticClass and
// AGwNavPawn::StaticClass out of line here, where ours inlines them; forcing
// those calls out of line makes ours smaller still, so retail must inline
// more somewhere else.
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
        if (pVehicle->IsA(AUDKVehicle::StaticClass()))
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
                FRotator SpawnRotation = Rotation != 0 ? *Rotation : ControllerClass->GetDefaultActor()->Rotation;
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
                    pController->eventPossess(pPawn, 0);
                    pController->CCSPawn->SetDefaultBehaviorTree(BehaviorTree);
                    if (pController->PlayerReplicationInfo != 0 && PawnName != L"")
                    {
                        pController->PlayerReplicationInfo->eventSetPlayerName(PawnName);
                    }
                }
            }
            if (pPawn->IsA(AGwNavPawn::StaticClass()))
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
            for (int i = 0; i < InventoryList.Num(); i++)
            {
                pPawn->eventCreateInventory(InventoryList(i), 0);
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
