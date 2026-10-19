// UDKBaseClasses.h's hand-written part: inline bodies the PDB has no code
// for, written from the disassembly. Included at the end of that header.
#pragma once
#include "Core/Inc/UnMath.h"

extern UWorld *GWorld;

// gripbtinterface.h
template <class T0> inline T0 *IGripBTInterface::GetBlackboard()
{
    return static_cast<T0 *>(GetBlackboardInternal());
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// ccsgamecharacter.h, ccscharacter.h
inline CCSGameCharacter::CCSGameCharacter()
    : m_pawn(0), m_actor(0), m_targetableComponent(0), m_targetableComponentCheck(false), m_cachedTeamNum(-1)
{
}
inline CCSCharacter::CCSCharacter() {}
#endif

// grip_vector.h
#ifndef HAGGAR_HOST
inline Grip_Vector::Grip_Vector() : X(0.0f), Y(0.0f), Z(0.0f) {}
inline Grip_Vector::Grip_Vector(const FVector &V) : X(V.X), Y(V.Y), Z(V.Z) {}
inline Grip_Vector::Grip_Vector(float InX, float InY, float InZ) : X(InX), Y(InY), Z(InZ) {}
#endif
inline Grip_Vector::operator FVector() const { return FVector(X, Y, Z); }
inline Grip_Vector Grip_Vector::operator+(const Grip_Vector &V) const { return Grip_Vector(V.X + X, V.Y + Y, V.Z + Z); }
inline Grip_Vector Grip_Vector::operator-(const Grip_Vector &V) const { return Grip_Vector(X - V.X, Y - V.Y, Z - V.Z); }
inline Grip_Vector Grip_Vector::operator*(float Scale) const { return Grip_Vector(X * Scale, Y * Scale, Z * Scale); }
inline float Grip_Vector::operator|(const Grip_Vector &V) const { return X * V.X + Y * V.Y + Z * V.Z; }
inline float Grip_Vector::SizeSquared() const { return X * X + Y * Y + Z * Z; }
inline float Grip_Vector::SizeSquared2D() const { return X * X + Y * Y; }

// gripheapobject.h
#ifndef HAGGAR_HOST
inline void *GripHeapObject::operator new(unsigned int, void *Mem) { return Mem; }
inline void GripHeapObject::operator delete(void *Ptr) { Grip::Memory::pGlobalHeap->Free(Ptr); }
#endif

// engineclasses.h (UActorComponent's cpptext)
inline AActor *UActorComponent::GetOwner() const { return Owner; }

DECLARE_CAST_BY_FLAG(UByteProperty)

// gripvheapobject.h
inline void GripVHeapObject::operator delete(void *Ptr) { Grip::Memory::pGlobalHeap->Free(Ptr); }

// gripafinterface.h
template <class T0> inline T0 *IGripAFInterface::GetSystem()
{
    return static_cast<T0 *>(GetSystemInternal(T0::SGetFamily(), T0::SGetId()));
}

// ccscontrolsystem.h, ccscscover.h, ccscsmovement.h
inline int CCSControlSystem::SGetFamily() { return 2; }
inline int CCSControlSystem::GetFamily() const { return SGetFamily(); }
inline int CCSCSCover::SGetId() { return CST_COVER; }
inline int CCSCSCover::GetId() const { return SGetId(); }
inline int CCSCSMovement::SGetId() { return CST_MOVEMENT; }
inline int CCSCSMovement::GetId() const { return SGetId(); }

#ifndef HAGGAR_HOST
// ccsafaction.h
inline CCSAFAction::CCSAFAction() : m_pMeatPuppet(0) {}
#endif

#ifndef HAGGAR_HOST
// gripafmodifier.h
inline GripAFModifier::GripAFModifier() : m_id(-1) {}
inline GripAFModifier::~GripAFModifier() {}
// gripvheapobject.h
inline GripVHeapObject::~GripVHeapObject() {}
#endif
inline void GripAFModifier::Apply() {}
inline void GripAFModifier::Revert() {}

// gripvheapobject.h, griprbtnode.h: allocation
inline void *GripVHeapObject::operator new(unsigned int Size) { return Grip::Memory::pGlobalHeap->Alloc(Size, 0); }
inline void *GripRBTNode::operator new(unsigned int Size)
{
    if (ms_pAllocator == 0)
    {
        return GripVHeapObject::operator new(Size);
    }
    return ms_pAllocator->AllocateAlign(Size);
}

// ccsgamecharacter.h, ccscharacter.h
inline bool CCSGameCharacter::operator==(const CCSGameCharacter &Other) const
{
    return m_pawn == Other.m_pawn && m_actor == Other.m_actor;
}
inline bool CCSCharacter::operator==(const CCSCharacter &Other) const { return m_gameCharacter == Other.m_gameCharacter; }
inline bool CCSCharacter::operator!=(const CCSCharacter &Other) const { return !(*this == Other); }
inline void *CCSCharacter::GetActor() const
{
    if (*this != NONE)
    {
        return m_gameCharacter.GetActor();
    }
    return 0;
}

// gripafaction.h
inline GripAFAction::EGripAFActionStatus GripAFAction::GetStatus() { return m_status; }
inline Grip_ArrayPOD<GripAFModifier *, 2> &GripAFAction::GetModifiers() { return m_modifiers; }

// grip_rotation.h
#ifndef HAGGAR_HOST
inline Grip_Rotation::Grip_Rotation() : Pitch(0), Yaw(0), Roll(0) {}
inline Grip_Rotation::Grip_Rotation(int InPitch, int InYaw, int InRoll) : Pitch(InPitch), Yaw(InYaw), Roll(InRoll) {}
inline Grip_Rotation::Grip_Rotation(const FRotator &R) : Pitch(R.Pitch), Yaw(R.Yaw), Roll(R.Roll) {}
#endif
inline Grip_Rotation::operator FRotator() const { return FRotator(Pitch, Yaw, Roll); }

// ccsgamecover.h
inline bool CCSGameCover::operator==(const CCSGameCover &Other) const { return (m_coverInfo == Other.m_coverInfo) == 1; }
inline Grip_Vector CCSGameCover::GetPosition() const
{
    return Grip_Vector(m_coverInfo.Link->GetSlotLocation(m_coverInfo.SlotIdx, 0));
}
inline Grip_Rotation CCSGameCover::GetOrientation() const
{
    return Grip_Rotation(m_coverInfo.Link->GetSlotRotation(m_coverInfo.SlotIdx, 0));
}
inline bool CCSGameCover::IsLocked() const
{
    if (m_coverInfo.Link == 0)
    {
        return true;
    }
    APawn *pOwner = m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOwner;
    return pOwner != 0 && !pOwner->IsPendingKill();
}
inline bool CCSGameCover::IsLockedBy(CCSCharacter Character) const
{
    if (m_coverInfo.Link == 0)
    {
        return true;
    }
    return IsLocked() && m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOwner == Character.m_gameCharacter.m_pawn;
}
inline bool CCSGameCover::LockCover(CCSCharacter Character)
{
    if (m_coverInfo.Link == 0)
    {
        return false;
    }
    if (IsLocked())
    {
        return false;
    }
    if (!IsOccupiedBy(Character))
    {
        m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier = 0;
    }
    m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOwner = Character.m_gameCharacter.m_pawn;
    return true;
}
inline bool CCSGameCover::UnlockCover(CCSCharacter Character)
{
    if (m_coverInfo.Link == 0)
    {
        return false;
    }
    FCoverSlot &Slot = m_coverInfo.Link->Slots(m_coverInfo.SlotIdx);
    if (Slot.SlotOwner != Character.m_gameCharacter.m_pawn)
    {
        return false;
    }
    Slot.SlotOwner = 0;
    return true;
}
inline bool CCSGameCover::IsOccupied() const
{
    if (m_coverInfo.Link == 0)
    {
        return true;
    }
    APawn *pOccupier = m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier;
    return pOccupier != 0 && !pOccupier->IsPendingKill();
}
inline bool CCSGameCover::IsOccupiedBy(CCSCharacter Character) const
{
    if (m_coverInfo.Link == 0)
    {
        return true;
    }
    return IsOccupied() && m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier == Character.m_gameCharacter.m_pawn;
}
inline bool CCSGameCover::OccupyCover(CCSCharacter Character)
{
    if (m_coverInfo.Link == 0)
    {
        return false;
    }
    APawn *pPawn = Character.m_gameCharacter.m_pawn;
    if (IsLocked() && m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOwner != pPawn)
    {
        return false;
    }
    if (IsOccupied())
    {
        return m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier == pPawn;
    }
    m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier = pPawn;
    AUDKPawn *pUDKPawn = Cast<AUDKPawn>(pPawn);
    if (pUDKPawn != 0)
    {
        pUDKPawn->OccupiedCoverCount++;
    }
    return true;
}
inline bool CCSGameCover::VacateCover(CCSCharacter Character)
{
    if (m_coverInfo.Link == 0)
    {
        return false;
    }
    if (m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier != Character.m_gameCharacter.m_pawn)
    {
        return false;
    }
    AUDKPawn *pUDKPawn = Cast<AUDKPawn>(Character.m_gameCharacter.m_pawn);
    if (pUDKPawn != 0)
    {
        pUDKPawn->OccupiedCoverCount--;
    }
    m_coverInfo.Link->Slots(m_coverInfo.SlotIdx).SlotOccupier = 0;
    return true;
}

// ccscover.h
inline bool CCSCover::operator==(const CCSCover &Other) const { return m_gameCover == Other.m_gameCover; }
inline bool CCSCover::operator!=(const CCSCover &Other) const { return !(m_gameCover == Other.m_gameCover); }
inline bool CCSCover::IsEnabled() const { return m_gameCover.IsEnabled(); }
inline bool CCSCover::IsOccupied() const { return m_gameCover.IsOccupied(); }
inline bool CCSCover::IsOccupiedBy(CCSCharacter Character) { return m_gameCover.IsOccupiedBy(Character); }
inline bool CCSCover::OccupyCover(CCSCharacter Character) { return m_gameCover.OccupyCover(Character); }
inline bool CCSCover::VacateCover(CCSCharacter Character) { return m_gameCover.VacateCover(Character); }
inline bool CCSCover::IsValid() const { return m_state == CCS::CoverState_Valid || m_state == CCS::CoverState_BadAttackAngle; }
inline Grip_Vector CCSCover::GetPosition() const { return m_gameCover.GetPosition(); }
inline Grip_Rotation CCSCover::GetOrientation() const { return m_gameCover.GetOrientation(); }
inline bool CCSCover::IsLocked() const { return m_gameCover.IsLocked(); }
inline bool CCSCover::IsLockedBy(CCSCharacter Character) const { return m_gameCover.IsLockedBy(Character); }
inline bool CCSCover::LockCover(CCSCharacter Character) { return m_gameCover.LockCover(Character); }
inline bool CCSCover::UnlockCover(CCSCharacter Character) { return m_gameCover.UnlockCover(Character); }
inline CCS::ECoverShootConfig CCSCover::GetShootConfig() const { return m_gameCover.GetShootConfig(); }
inline CCS::ECoverType CCSCover::GetType() const { return m_gameCover.GetType(); }
inline Grip_Vector CCSCover::GetShootPosition(const CCS::ECoverShootConfig Config, const float Offset) const
{
    return m_gameCover.GetShootPosition(Config, Offset);
}

// engineclasses.h (FCoverInfo's cpptext)
inline unsigned int FCoverInfo::operator==(const FCoverInfo &Other) const { return Link == Other.Link && SlotIdx == Other.SlotIdx; }

// gripbbmember.h, gripblackboard.h
inline void GripBBMember::FlagAsUsed() { m_used = true; }
inline Grip_Array<Grip::String, Grip::AllocatorGH<Grip::String, 2> > &GripBlackboard::GetStates() { return m_states.GetArray(); }

// ccsblackboard.h
inline void CCSBlackboard::FlagHighestThreatTarget() { m_pHighestThreatTarget.FlagAsUsed(); }
inline void CCSBlackboard::FlagClosestEnemy() { m_closestEnemy.FlagAsUsed(); }
inline void CCSBlackboard::FlagClosestVisibleEnemy() { m_closestVisibleEnemy.FlagAsUsed(); }
inline void CCSBlackboard::FlagCurrentTarget() { m_currentTarget.FlagAsUsed(); }
inline void CCSBlackboard::FlagLowestLKPAgeEnemy() { m_lowestLKPAgeEnemy.FlagAsUsed(); }
inline void CCSBlackboard::FlagClosestObjective() { m_closestObjective.FlagAsUsed(); }
inline void CCSBlackboard::FlagReactiveTarget() { m_closestReactiveTarget.FlagAsUsed(); }
inline void CCSBlackboard::FlagHasBecomeAware() { m_bHasBecomeAware.FlagAsUsed(); }
inline void CCSBlackboard::SetHeatGenerated(float Heat) { m_heatGenerated.Set(Heat); }
inline float CCSBlackboard::GetHeatGenerated() const { return m_heatGenerated.Get(); }
inline void CCSBlackboard::ClearMoveCommand() { m_moveCommand.Set(MOVE_CMD_NONE); }
inline void CCSBlackboard::FlagMoveCommandAsUsed()
{
    m_moveCommand.FlagAsUsed();
    m_movePosition.FlagAsUsed();
}
inline CCSBlackboard::EMoveCmd CCSBlackboard::GetMoveCommand() const { return m_moveCommand.Get(); }
inline Grip_Vector CCSBlackboard::GetMovePosition() const { return m_movePosition.Get(); }

// ccscharacter.h
inline Grip_Vector CCSCharacter::GetEyesPosition() const { return m_gameCharacter.GetEyesPosition(); }

// sf_refcount.h: reference-counted objects come from Gameware's heap
#ifndef HAGGAR_HOST
inline void *Kaim::RefCountBaseStatImpl<Kaim::RefCountImpl, 139>::operator new(unsigned int Size)
{
    return Kaim::Memory::pGlobalHeap->Alloc(Size, 0);
}
#endif

// gwnavutils.h (UnrealEd's GwNav glue)
Kaim::Vec3f UnrealToGwNavVector(const FVector &V);
#ifndef HAGGAR_HOST
inline void *Kaim::IQuery::operator new(unsigned int Size) { return Kaim::Memory::pGlobalHeap->Alloc(Size, 0); }
#endif

// astarquery.h: the typed query forwards to its base
inline void Kaim::AStarQuery<Kaim::DefaultTraverseLogic>::BindToDatabase(Kaim::Database *pDatabase)
{
    BaseAStarQuery::BindToDatabase(pDatabase);
}
inline void Kaim::AStarQuery<Kaim::DefaultTraverseLogic>::Initialize(const Kaim::Vec3f &StartPos, const Kaim::Vec3f &DestPos)
{
    BaseAStarQuery::Initialize(StartPos, DestPos);
}

// grip_vector.h: comparisons
inline bool Grip_Vector::operator==(const Grip_Vector &V) const { return X == V.X && Y == V.Y && Z == V.Z; }
inline bool Grip_Vector::operator!=(const Grip_Vector &V) const { return X != V.X || Y != V.Y || Z != V.Z; }

// gripengineservices.h
inline Grip_Vector GripEngineServices::GetActorPosition(void *pActor) { return ms_pImpl->GetActorPosition(pActor); }
inline Grip_Vector CCSCharacter::GetPosition() const { return m_gameCharacter.GetPosition(); }

// line-check results (the iterator's Next is left as it is)
inline FIteratorList::FIteratorList() {}
inline FIteratorActorList::FIteratorActorList() : Actor(0) {}
inline FCheckResult::FCheckResult()
    : Location(0, 0, 0), Normal(0, 0, 0), Time(0), Item(INDEX_NONE), Material(0), PhysMaterial(0), Component(0),
      SourceComponent(0), BoneName(NAME_None), Level(0), LevelIndex(INDEX_NONE), bStartPenetrating(0)
{
}

// gripbbmember.h
inline bool GripBBMember::IsUsed() const { return m_used; }
inline void CCSBlackboard::FlagThreatLocationAsUsed() { m_threatLocation.FlagAsUsed(); }
inline void CCSBlackboard::FlagThreatDirectionAsUsed() { m_threatDirection.FlagAsUsed(); }
inline Grip_Vector CCSBlackboard::GetThreatLocation() const { return m_threatLocation.Get(); }
inline Grip_Vector CCSBlackboard::GetThreatDirection() const { return m_threatDirection.Get(); }
inline EThreatType CCSBlackboard::GetThreatType() const { return m_threatType.Get(); }
inline void CCSBlackboard::FlagHeatGeneratedAsUsed() { m_heatGenerated.FlagAsUsed(); }

// gripbtsystemflags.h, gripbbmember.h
#ifndef HAGGAR_HOST
inline GripBTSystemFlags::GripBTSystemFlags() : m_flags(0) {}
inline GripBBMember::GripBBMember() : m_blackboard(0), m_used(false) {}
inline GripBBMember::~GripBBMember() {}
#endif

// gripbbvisualization.h
#ifndef HAGGAR_HOST
inline GripBBVisualization::GripBBVisualization() : m_pBB(0) {}
#endif
inline void GripBBVisualization::SetBlackboard(GripBlackboard *pBB) { m_pBB = pBB; }
