// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbttimesinceevent.cpp: the behaviour-tree condition on the time since
// a game event of a given type, from a given class of actor, happened within
// a given distance.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

// The setters (ccsrbttimesinceevent.h), out of line as in retail
void EmitTimeSinceEventSetters(CCSRBTTimeSinceEvent *pNode)
{
    pNode->SetEventType(EEventType(0));
    pNode->SetActorClass(0);
    pNode->SetMaxDistance(0.0f);
}
// @retail 0x8331ECC0
// CCSRBTTimeSinceEvent::SetEventType (in the header)
// @retail 0x8331ECC8
// CCSRBTTimeSinceEvent::SetActorClass (in the header)
// @retail 0x8331ECD0
// CCSRBTTimeSinceEvent::SetMaxDistance (in the header)

// @retail 0x83325040
void CCSRBTTimeSinceEvent::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->m_eventType.FlagAsUsed();
    pBB->m_timeSinceEvent.FlagAsUsed();
    pBB->m_eventSenderClass.FlagAsUsed();
    pBB->m_eventLocation.FlagAsUsed();
}

// Near: retail loads the event location before storing the time and keeps
// the squared distance's terms in another order (tried a reference to the
// location and a named delta).
// @retail 0x83333188
bool CCSRBTTimeSinceEvent::TestPreCondition(IGripBTInterface *pInterface)
{
    bool bResult = false;
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    UClass *pSenderClass = pBB->m_eventSenderClass.Get();
    if (pSenderClass != 0)
    {
        const Grip_Vector Position = static_cast<CCSBrain *>(pInterface)->m_meatPuppet->GetCharacter().GetPosition();
        const Grip_Vector Delta = pBB->m_eventLocation.Get() - Position;
        m_value = pBB->m_timeSinceEvent.Get();
        const float DistanceSquared = Delta.SizeSquared();
        if (EventType == pBB->m_eventType.Get() && pSenderClass->IsChildOf(ActorClass)
            && GripRBTNumericCondition<float>::TestPreCondition(pInterface) && DistanceSquared <= MaxDistance * MaxDistance)
        {
            bResult = true;
        }
    }
    return bResult;
}
