// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsengineservices.cpp: the CCS layer's questions to the engine: every
// cover slot, brain, player and vehicle in the world.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "UDKBase/Inc/EngineUtils.h"
#include "../CCSRef/CCSCover.cpp"

// The actor comes from the shared iterator's operator*, which reads its
// member through a volatile pointer so that the compiler keeps the actor in
// a register across the checks: retail hands the cast the actor it kept in
// r31, and the checks' calls may have changed the member.
// @retail 0x833387C0
void CCSEngineServices::FindAllCovers(Grip_Array<CCSCover, Grip::AllocatorGH<CCSCover, 2> > &Covers)
{
    if (GWorld == 0)
    {
        return;
    }
    for (FActorIterator It; It; ++It)
    {
        ACoverLink *pLink = Cast<ACoverLink>(*It);
        if (pLink == 0)
        {
            continue;
        }
        for (int i = 0; i < pLink->Slots.Num(); i++)
        {
            CCSCover Cover;
            Cover.m_gameCover.m_coverInfo.Link = pLink;
            Cover.m_gameCover.m_coverInfo.SlotIdx = i;
            Covers.AddItem(Cover);
        }
    }
}

// @retail 0x8336D320
void CCSEngineServices::FindAllBrains(Grip_ArrayPOD<CCSBrain *, 2> &Brains)
{
    if (GWorld == 0)
    {
        return;
    }
    for (AController *pController = GWorld->GetFirstController(); pController != 0; pController = pController->NextController)
    {
        ACCSController *pCCSController = Cast<ACCSController>(pController);
        if (pCCSController != 0 && pCCSController->IsValid() && pCCSController->Brain != 0 && !pCCSController->IsPendingKill())
        {
            Brains.AddItem(pCCSController->Brain);
        }
    }
}

// @retail 0x83338A88
void CCSEngineServices::FindAllPlayers(Grip_Array<CCSCharacter, Grip::AllocatorGH<CCSCharacter, 2> > &Players)
{
    if (GWorld == 0)
    {
        return;
    }
    for (AController *pController = GWorld->GetFirstController(); pController != 0; pController = pController->NextController)
    {
        if (pController->IsPlayerOwner() && pController->Pawn != 0)
        {
            APlayerController *pPlayer = Cast<APlayerController>(pController);
            if (pPlayer != 0)
            {
                CCSCharacter Character;
                Character.m_gameCharacter.m_pawn = pPlayer->Pawn;
                if (pPlayer->IsValid() && !pPlayer->IsPendingKill())
                {
                    Players.AddItem(Character);
                }
            }
        }
    }
}

// @retail 0x83338B60
void CCSEngineServices::FindAllVehicles(Grip_Array<CCSCharacter, Grip::AllocatorGH<CCSCharacter, 2> > &Vehicles)
{
    if (GWorld == 0)
    {
        return;
    }
    for (AActor *pVehicle = GWorld->GetFirstVehicle(); pVehicle != 0; pVehicle = pVehicle->Next_Vehicle)
    {
        CCSCharacter Character;
        Character.m_gameCharacter.m_actor = pVehicle;
        if (pVehicle->IsValid() && !pVehicle->IsPendingKill())
        {
            Vehicles.AddItem(Character);
        }
    }
}
