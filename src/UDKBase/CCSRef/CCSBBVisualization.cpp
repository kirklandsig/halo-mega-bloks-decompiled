// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsbbvisualization.cpp: what the AI console shows of a CCS blackboard:
// each member as a name and a printed value, and per target its last
// known position's age, range and whether it is shootable and visible.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "CCSBlackboard.cpp"
#include "../Src/HaloRBTKamikaze.cpp"

namespace Grip
{
unsigned int SFsprintf(char *pDest, unsigned int DestSize, const char *pFormat, ...);
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8334B158
CCSBBTargetVisualization::CCSBBTargetVisualization() : m_pTarget(0)
{
}
#endif

// ccsbbvisualization.h's accessors
// @retail 0x83320400
void CCSBBTargetVisualization::SetTarget(CCSTarget *pTarget)
{
    m_pTarget = pTarget;
}

// @retail 0x83320408
float CCSBBTargetVisualization::GetLKPAge()
{
    return m_pTarget != 0 ? m_pTarget->LKPAge : 0.0f;
}

// @retail 0x83320428
float CCSBBTargetVisualization::GetRange2D()
{
    return m_pTarget != 0 ? m_pTarget->range2D : 0.0f;
}

// @retail 0x83320448
bool CCSBBTargetVisualization::GetShootable()
{
    return m_pTarget != 0 ? m_pTarget->canShoot : false;
}

// @retail 0x83320468
bool CCSBBTargetVisualization::GetIsVisible()
{
    return m_pTarget != 0 ? m_pTarget->isVisible : false;
}

// score 7 (was 14): apart from the placement of one instruction the code is
// retail's. Retail computes the members array address (addi r27, r30, 8) just
// before the first AddItem; a reference bound anywhere at or before that use
// moves the address to retail's place but the allocator then numbers the
// members pointer r29 and the two "YES"/"NO" string pointers r28 and r27
// (retail: r27, r29, r28), which scores 14; the reference at the top keeps
// retail's numbering but leaves the address at the top of the function. The
// two go together: the address is defined where the source names m_members
// (never sunk or rematerialised), and a value born before the first if/else
// gets r27, one born at the AddItem r29; the PDB puts retail's address on the
// AddItem's line, yet it has r27. Tried by both lanes, none better than 7: no
// reference; a pointer, reference or const reference bound at the top, after
// the member constructor, before the first member or just before the first
// AddItem; m_members used directly at all, some or only the first call;
// this->, (*), casts, base-class pointers or references; the buffer per if
// block; the locals in the other order; the ?: as an if/else; the first
// member split into declaration and assignment; the string temporaries
// reshaped; two ten-minute permuter runs.
// This session: m_members used directly, this->m_members, and a pointer or a
// reference bound just before the first AddItem all put the address at
// retail's place but number the members pointer r29 (score 14); the same with
// the accessors replaced by the members they read, and with the "YES"/"NO"
// ternary through a named const char*, also score 14. A reference at the top
// with the first AddItem written directly does give retail's r27 (score 7)
// but still computes the address at the top, from r3 before the first call.
// The register follows the place the address is born, and the source cannot
// have both.
// @retail 0x8334BDA8
void CCSBBTargetVisualization::Refresh()
{
    Grip_Array<GripSerializationMember, Grip::AllocatorGH<GripSerializationMember, 2> > &Members = m_members;
    Grip::String Value;
    char Buffer[64];
    if (m_pTarget != 0)
    {
        Grip::SFsprintf(Buffer, sizeof(Buffer), "%01.2f", GetLKPAge());
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    else
    {
        Value = "No target.";
    }
    GripSerializationMember Member("   LKP Time", Value.ToCStr());
    Members.AddItem(Member);
    if (m_pTarget != 0)
    {
        int Range = (int)GetRange2D();
        Grip::SFsprintf(Buffer, sizeof(Buffer), "%i", Range - Range % 10);
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    else
    {
        Value = "No target.";
    }
    Member = GripSerializationMember("   2D Range", Value.ToCStr());
    Members.AddItem(Member);
    if (m_pTarget != 0)
    {
        Value = GetShootable() ? "YES" : "NO";
    }
    else
    {
        Value = "No target.";
    }
    Member = GripSerializationMember("   Shootable", Value.ToCStr());
    Members.AddItem(Member);
    if (m_pTarget != 0)
    {
        Value = GetIsVisible() ? "YES" : "NO";
    }
    else
    {
        Value = "No target.";
    }
    Member = GripSerializationMember("   Visible", Value.ToCStr());
    Members.AddItem(Member);
}

// The blackboard's members as the console shows them: the states, the
// current target's details and the self-awareness values.
// @retail 0x83355060
void CCSBBVisualization::Refresh()
{
    if (m_pBB == 0)
    {
        return;
    }
    m_members.Reset();
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(m_pBB);
    Grip::String Value;
    Grip_Array<Grip::String, Grip::AllocatorGH<Grip::String, 2> > &States = m_pBB->GetStates();
    for (int i = 0; i < States.Num(); i++)
    {
        if (i > 0)
        {
            Value.AppendString(", ", -1);
        }
        Value += States[i];
    }
    m_members.AddItem(GripSerializationMember("Current State(s)", Value.ToCStr()));
    CCSBBTargetVisualization TargetVisualization;
    TargetVisualization.SetTarget(pBB->GetCurrentTarget());
    TargetVisualization.Refresh();
    m_members.AddItem(GripSerializationMember("Current Target", ""));
    for (int i = 0; i < TargetVisualization.GetMembers().Num(); i++)
    {
        m_members.AddItem(TargetVisualization.GetMembers()[i]);
    }
    char Buffer[64];
    Grip::SFsprintf(Buffer, sizeof(Buffer), "%01.2f", pBB->GetLowestLKPAgeEnemy() != 0 ? pBB->GetLowestLKPAgeEnemy()->LKPAge : 0.0f);
    {
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Lowest Enemy LKP Age", Value.ToCStr()));
    int Range = pBB->GetClosestVisibleEnemy() != 0 ? (int)pBB->GetClosestVisibleEnemy()->range2D : 0;
    Grip::SFsprintf(Buffer, sizeof(Buffer), "%i", Range - Range % 10);
    {
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Closest Visible Enemy Range", Value.ToCStr()));
    Range = pBB->GetHighestThreatTarget() != 0 ? (int)pBB->GetHighestThreatTarget()->range2D : -1;
    Grip::SFsprintf(Buffer, sizeof(Buffer), "%i", Range - Range % 10);
    {
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Highest Threat Target Range", Value.ToCStr()));
    Value = pBB->m_bHasBecomeAware.Get() ? "YES" : "NO";
    m_members.AddItem(GripSerializationMember("Has Become Aware", Value.ToCStr()));
    Value = pBB->m_visibleToPlayerCamera.Get() ? "YES" : "NO";
    m_members.AddItem(GripSerializationMember("Visible To Player Camera", Value.ToCStr()));
    const float Never = 3.402823466e+38F;
    if (pBB->m_timeSinceDamage.Get() == Never)
    {
        Value = "---";
    }
    else
    {
        Grip::SFsprintf(Buffer, sizeof(Buffer), "%01.2f", pBB->m_timeSinceDamage.Get());
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Time Since Damage", Value.ToCStr()));
    if (pBB->m_timeSinceAimedAt.Get() == Never)
    {
        Value = "---";
    }
    else
    {
        Grip::SFsprintf(Buffer, sizeof(Buffer), "%01.2f", pBB->m_timeSinceAimedAt.Get());
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Time Since Aimed At", Value.ToCStr()));
    if (pBB->m_timeSinceThreatened.Get() == Never)
    {
        Value = "---";
    }
    else
    {
        Grip::SFsprintf(Buffer, sizeof(Buffer), "%01.2f", pBB->m_timeSinceThreatened.Get());
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Time Since Threatened", Value.ToCStr()));
    Grip::SFsprintf(Buffer, sizeof(Buffer), "%i", pBB->m_health.Get());
    {
        Grip::String Printed(Buffer);
        Value = Printed;
    }
    m_members.AddItem(GripSerializationMember("Health", Value.ToCStr()));
}
