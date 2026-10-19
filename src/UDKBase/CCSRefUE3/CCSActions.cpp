// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsactions.cpp: the action handles script creates, each building its
// objective and asking the factory for the action.
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../CCSRef/CCSCover.cpp"

// @retail 0x83341F08
int UCCSAFEnterCover::CreateAction(GripAFFactory *pFactory)
{
    CCSCover Cover;
    Cover.m_gameCover.m_coverInfo.Link = CoverLink;
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = Target;
    CCSAOEnterCover Objective = {Cover, Character};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOEnterCover, CCSAFEnterCover>(Objective);
}

// @retail 0x83328B18
int UCCSAFExitCover::CreateAction(GripAFFactory *pFactory)
{
    CCSAOExitCover Objective;
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOExitCover, CCSAFExitCover>(Objective);
}

// @retail 0x83335D30
int UCCSAFFireBurst::CreateAction(GripAFFactory *pFactory)
{
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = Target;
    CCSAOFireBurst Objective = {Character};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOFireBurst, CCSAFFireBurst>(Objective);
}

// @retail 0x83341FD0
int UCCSAFGetInCover::CreateAction(GripAFFactory *pFactory)
{
    CCSCover Cover;
    Cover.m_gameCover.m_coverInfo.Link = CoverLink;
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = Target;
    CCSAOGetInCover Objective = {Cover, Character};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOGetInCover, CCSAFGetInCover>(Objective);
}

// @retail 0x83342098
int UCCSAFGetOutCover::CreateAction(GripAFFactory *pFactory)
{
    CCSCover Cover;
    Cover.m_gameCover.m_coverInfo.Link = CoverLink;
    CCSCharacter Character;
    Character.m_gameCharacter.m_pawn = Target;
    CCSAOGetOutCover Objective = {Cover, Character};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOGetOutCover, CCSAFGetOutCover>(Objective);
}

// @retail 0x83328B50
int UCCSAFIdle::CreateAction(GripAFFactory *pFactory)
{
    CCSAOIdle Objective = {CCS::MovementType_Idle, (CCS::EAlertnessState)Alertness};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOIdle, CCSAFIdle>(Objective);
}

// @retail 0x83335DB8
int UCCSAFMoveTo::CreateAction(GripAFFactory *pFactory)
{
    CCSAOMoveTo Objective = {Target, (CCS::EMovementType)MovementType, (CCS::EAlertnessState)Alertness};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOMoveTo, CCSAFMoveTo>(Objective);
}

// @retail 0x83335E18
int UCCSAFMoveToActor::CreateAction(GripAFFactory *pFactory)
{
    CCSAOMoveToActor Objective = {Target, (CCS::EMovementType)MovementType, (CCS::EAlertnessState)Alertness};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOMoveToActor, CCSAFMoveToActor>(Objective);
}

// @retail 0x83335E88
int UCCSAFStrafeTarget::CreateAction(GripAFFactory *pFactory)
{
    CCSAOStrafeTarget Objective = {Target};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOStrafeTarget, CCSAFStrafeTarget>(Objective);
}

// @retail 0x83335F00
int UCCSAFStrafeTo::CreateAction(GripAFFactory *pFactory)
{
    CCSAOStrafeTo Objective = {Target, (CCS::EMovementType)MovementType, (CCS::EAlertnessState)Alertness};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOStrafeTo, CCSAFStrafeTo>(Objective);
}

// @retail 0x83335F60
int UCCSAFEncircleTarget::CreateAction(GripAFFactory *pFactory)
{
    CCSAOEncircleTarget Objective = {Target};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOEncircleTarget, CCSAFEncircleTarget>(Objective);
}

// @retail 0x83335FD8
int UCCSAFFlee::CreateAction(GripAFFactory *pFactory)
{
    CCSAOFlee Objective = {Target};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOFlee, CCSAFFlee>(Objective);
}

// @retail 0x83336038
int UCCSAFOrientToward::CreateAction(GripAFFactory *pFactory)
{
    CCSAOOrientToward Objective = {Target, (CCS::EAlertnessState)Alertness};
    return Handle = static_cast<CCSAFFactory *>(pFactory)->CreateActionInternal<CCSAOOrientToward, CCSAFOrientToward>(Objective);
}
