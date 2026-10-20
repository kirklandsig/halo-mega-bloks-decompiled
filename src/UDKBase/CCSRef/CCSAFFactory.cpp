// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsaffactory.cpp, ccsaffactory.h: makes the CCS actions (an objective
// becomes its action object, registered with the memory pool).
#pragma once
#include "CCSAFIdle.cpp"
#include "CCSAFMoveTo.cpp"
#include "CCSAFMoveToActor.cpp"
#include "CCSAFStrafeTarget.cpp"
#include "CCSAFStrafeTo.cpp"
#include "CCSAFEncircleTarget.cpp"
#include "CCSAFFlee.cpp"
#include "CCSAFOrientToward.cpp"
#include "CCSAFFireBurst.cpp"
#include "CCSAFGetInCover.cpp"
#include "CCSAFGetOutCover.cpp"
#include "CCSAFEnterCover.cpp"
#include "CCSAFExitCover.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332C5A0
CCSAFFactory::CCSAFFactory() : m_pMeatPuppet(0), m_pAFInterface(0)
{
}
#endif

// @retail 0x83322C40
CCSAFFactory::~CCSAFFactory()
{
    if (m_pAFInterface != 0)
    {
        delete m_pAFInterface;
    }
    m_pAFInterface = 0;
}

// @retail 0x83322CA8
void CCSAFFactory::Initialize(ICCSMeatPuppet *pMeatPuppet, IGripAFInterface *pAFInterface)
{
    m_pMeatPuppet = pMeatPuppet;
    m_pAFInterface = pAFInterface;
}

template <class AO, class AF> int CCSAFFactory::CreateActionInternal(const AO &Objective)
{
    AF *pAction = new AF;
    pAction->m_pMeatPuppet = m_pMeatPuppet;
    pAction->m_pAFInterface = m_pAFInterface;
    pAction->SetObjective(Objective);
    pAction->PostCreate();
    return m_pMemoryPool->RegisterAction(pAction);
}

// @retail 0x83327E70
template <> int CCSAFFactory::CreateAction<CCSAOIdle>(const CCSAOIdle &Objective)
{
    return CreateActionInternal<CCSAOIdle, CCSAFIdle>(Objective);
}

// @retail 0x83335CF0
template <> int CCSAFFactory::CreateAction<CCSAOMoveTo>(const CCSAOMoveTo &Objective)
{
    return CreateActionInternal<CCSAOMoveTo, CCSAFMoveTo>(Objective);
}

// @retail 0x83335CF8
template <> int CCSAFFactory::CreateAction<CCSAOMoveToActor>(const CCSAOMoveToActor &Objective)
{
    return CreateActionInternal<CCSAOMoveToActor, CCSAFMoveToActor>(Objective);
}

// @retail 0x83335D00
template <> int CCSAFFactory::CreateAction<CCSAOStrafeTarget>(const CCSAOStrafeTarget &Objective)
{
    return CreateActionInternal<CCSAOStrafeTarget, CCSAFStrafeTarget>(Objective);
}

// @retail 0x83335D08
template <> int CCSAFFactory::CreateAction<CCSAOStrafeTo>(const CCSAOStrafeTo &Objective)
{
    return CreateActionInternal<CCSAOStrafeTo, CCSAFStrafeTo>(Objective);
}

// @retail 0x83335D10
template <> int CCSAFFactory::CreateAction<CCSAOEncircleTarget>(const CCSAOEncircleTarget &Objective)
{
    return CreateActionInternal<CCSAOEncircleTarget, CCSAFEncircleTarget>(Objective);
}

// @retail 0x83335D18
template <> int CCSAFFactory::CreateAction<CCSAOFlee>(const CCSAOFlee &Objective)
{
    return CreateActionInternal<CCSAOFlee, CCSAFFlee>(Objective);
}

// @retail 0x83335D20
template <> int CCSAFFactory::CreateAction<CCSAOOrientToward>(const CCSAOOrientToward &Objective)
{
    return CreateActionInternal<CCSAOOrientToward, CCSAFOrientToward>(Objective);
}

// @retail 0x83335D28
template <> int CCSAFFactory::CreateAction<CCSAOFireBurst>(const CCSAOFireBurst &Objective)
{
    return CreateActionInternal<CCSAOFireBurst, CCSAFFireBurst>(Objective);
}

// @retail 0x83341EF0
template <> int CCSAFFactory::CreateAction<CCSAOGetInCover>(const CCSAOGetInCover &Objective)
{
    return CreateActionInternal<CCSAOGetInCover, CCSAFGetInCover>(Objective);
}

// @retail 0x83341EF8
template <> int CCSAFFactory::CreateAction<CCSAOGetOutCover>(const CCSAOGetOutCover &Objective)
{
    return CreateActionInternal<CCSAOGetOutCover, CCSAFGetOutCover>(Objective);
}

// @retail 0x83341F00
template <> int CCSAFFactory::CreateAction<CCSAOEnterCover>(const CCSAOEnterCover &Objective)
{
    return CreateActionInternal<CCSAOEnterCover, CCSAFEnterCover>(Objective);
}

// @retail 0x83327E78
template <> int CCSAFFactory::CreateAction<CCSAOExitCover>(const CCSAOExitCover &Objective)
{
    return CreateActionInternal<CCSAOExitCover, CCSAFExitCover>(Objective);
}

// the instances CreateAction calls
// @retail 0x83326E88
// CCSAFFactory::CreateActionInternal<CCSAOIdle,CCSAFIdle>
// @retail 0x83334EA8
// CCSAFFactory::CreateActionInternal<CCSAOMoveTo,CCSAFMoveTo>
// @retail 0x83334F78
// CCSAFFactory::CreateActionInternal<CCSAOMoveToActor,CCSAFMoveToActor>
// @retail 0x83335008
// CCSAFFactory::CreateActionInternal<CCSAOStrafeTarget,CCSAFStrafeTarget>
// @retail 0x833350A0
// CCSAFFactory::CreateActionInternal<CCSAOStrafeTo,CCSAFStrafeTo>
// @retail 0x83335170
// CCSAFFactory::CreateActionInternal<CCSAOEncircleTarget,CCSAFEncircleTarget>
// @retail 0x83335208
// CCSAFFactory::CreateActionInternal<CCSAOFlee,CCSAFFlee>
// @retail 0x833352A8
// CCSAFFactory::CreateActionInternal<CCSAOOrientToward,CCSAFOrientToward>
// @retail 0x83335378
// CCSAFFactory::CreateActionInternal<CCSAOFireBurst,CCSAFFireBurst>
// @retail 0x83341900
// CCSAFFactory::CreateActionInternal<CCSAOGetInCover,CCSAFGetInCover>
// @retail 0x83341998
// CCSAFFactory::CreateActionInternal<CCSAOGetOutCover,CCSAFGetOutCover>
// @retail 0x83341A30
// CCSAFFactory::CreateActionInternal<CCSAOEnterCover,CCSAFEnterCover>
// @retail 0x83326F30
// CCSAFFactory::CreateActionInternal<CCSAOExitCover,CCSAFExitCover>
