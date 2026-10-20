// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscharacter.cpp, and the out-of-line copies of ccscharacter.h's and
// ccsgamecharacter.h's inline functions that retail keeps.
#pragma once
#include "../CCSRefUE3/CCSGameCharacter.cpp"

// @retail 0x8336D7D0
CCSBrain *CCSCharacter::GetBrain() const
{
    APawn *pPawn = Cast<APawn>((UObject *)m_gameCharacter.m_actor);
    if (pPawn != 0)
    {
        ACCSController *pController = Cast<ACCSController>(pPawn->Controller);
        if (pController != 0 && pController->Brain != 0)
        {
            return pController->Brain;
        }
    }
    return 0;
}

#pragma inline_depth(0)
#ifndef HAGGAR_HOST
void EmitCharacterConstructors()
{
    CCSGameCharacter GameCharacter;
    CCSCharacter Character;
}
#endif
extern bool (CCSGameCharacter::*const EmitGameCharacterEquals)(const CCSGameCharacter &) const = &CCSGameCharacter::operator==;
extern bool (CCSCharacter::*const EmitCharacterNotEquals)(const CCSCharacter &) const = &CCSCharacter::operator!=;
extern void *(CCSCharacter::*const EmitCharacterGetActor)() const = &CCSCharacter::GetActor;
extern Grip_Vector (CCSCharacter::*const EmitCharacterGetEyesPosition)() const = &CCSCharacter::GetEyesPosition;
extern float (CCSCharacter::*const EmitCharacterGetHeight)() const = &CCSCharacter::GetHeight;
extern Grip_Rotation (CCSCharacter::*const EmitCharacterGetOrientation)() const = &CCSCharacter::GetOrientation;
extern Grip_Vector (CCSCharacter::*const EmitCharacterGetPosition)() const = &CCSCharacter::GetPosition;
extern float (CCSCharacter::*const EmitCharacterGetSize)() const = &CCSCharacter::GetSize;
extern int (CCSCharacter::*const EmitCharacterGetTeam)() = &CCSCharacter::GetTeam;
extern bool (CCSCharacter::*const EmitCharacterIsPlayer)() const = &CCSCharacter::IsPlayer;
extern UUDKTargetableComponent *(CCSCharacter::*const EmitCharacterGetTargetableComponent)() = &CCSCharacter::GetTargetableComponent;
#pragma inline_depth()

// @retail 0x8331DAA0
// CCSGameCharacter::CCSGameCharacter (in the header)
// @retail 0x8331DAC0
// CCSGameCharacter::operator== (in the header)
// @retail 0x8331DAF0
// CCSCharacter::CCSCharacter (in the header)
// @retail 0x8331DB40
// CCSCharacter::operator!= (in the header)
// @retail 0x83327B28
// CCSCharacter::GetActor (in the header)
// @retail 0x83327B70
// CCSCharacter::GetEyesPosition (in the header)
// @retail 0x83327BA0
// CCSCharacter::GetHeight (in the header)
// @retail 0x83327BC0
// CCSCharacter::GetOrientation (in the header)
// @retail 0x83327C20
// CCSCharacter::GetPosition (in the header)
// @retail 0x83327C48
// CCSCharacter::GetSize (in the header)
// @retail 0x83327C80
// CCSCharacter::GetTeam (in the header)
// @retail 0x83327CE8
// CCSCharacter::IsPlayer (in the header)
// @retail 0x833357B0
// CCSCharacter::GetTargetableComponent (in the header)
