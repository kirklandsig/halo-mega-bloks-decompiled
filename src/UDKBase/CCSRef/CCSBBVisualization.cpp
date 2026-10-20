// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsbbvisualization.cpp: what the AI console shows of a CCS blackboard:
// each member as a name and a printed value, and per target its last
// known position's age, range and whether it is shootable and visible.
#pragma once
#include "UDKBase/Inc/UDKBaseClasses.h"

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

// near: retail keeps the members array in r27 and the YES and NO strings in
// r28 and r29, ours the array in r29 (if-else, ternary and nested-if value
// forms tried)
// @retail 0x8334BDA8
void CCSBBTargetVisualization::Refresh()
{
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
    m_members.AddItem(Member);
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
    m_members.AddItem(Member);
    if (m_pTarget != 0)
    {
        Value = GetShootable() ? "YES" : "NO";
    }
    else
    {
        Value = "No target.";
    }
    Member = GripSerializationMember("   Shootable", Value.ToCStr());
    m_members.AddItem(Member);
    if (m_pTarget != 0)
    {
        Value = GetIsVisible() ? "YES" : "NO";
    }
    else
    {
        Value = "No target.";
    }
    Member = GripSerializationMember("   Visible", Value.ToCStr());
    m_members.AddItem(Member);
}
