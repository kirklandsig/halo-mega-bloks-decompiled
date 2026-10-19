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
