// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtwaitincover.cpp: the behaviour-tree node that waits while the pawn
// is in cover.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "../Src/HaloRBTKamikaze.cpp"
#include "CCSBlackboard.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x833250C8
CCSRBTWaitInCover::CCSRBTWaitInCover()
{
}
#endif

// @retail 0x83340728
bool CCSRBTWaitInCover::TestPreCondition(IGripBTInterface *pInterface)
{
    return pInterface->GetMeatPuppetQuery<CCSMeatPuppetQuery>()->IsInCover();
}

// @retail 0x83325110
GripRBTNode::EBTExecutionResult CCSRBTWaitInCover::ExecuteInternal(IGripBTInterface *, bool bInterrupt)
{
    return bInterrupt ? ER_SUCCESSFULLY_INTERRUPTED : ER_INPROGRESS;
}
