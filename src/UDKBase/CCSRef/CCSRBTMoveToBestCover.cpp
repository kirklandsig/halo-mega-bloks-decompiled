// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsrbtmovetobestcover.cpp, ccsrbtmovetoclosestcover.cpp and
// ccsrbtmovetoinitialcover.cpp: the move-to-cover nodes that choose which
// cover to take (the best scored, the closest by path, or the initial one).
#pragma once
#include "CCSRBTMoveToCover.cpp"

// @retail 0x83331CC8
void CCSRBTMoveToBestCover::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagCurrentTarget();
    pBB->m_covers.FlagAsUsed();
}

// near: retail keeps the current cover's slot and both constants in saved
// registers across the loop (a bigger frame); ours reloads them
// @retail 0x8333EB60
CCSCover CCSRBTMoveToBestCover::FindBestCover(IGripBTInterface *pInterface) const
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSCover Current = pInterface->GetMeatPuppetQuery<CCSMeatPuppetQuery>()->GetCurrentCover();
    CCSCover Best;
    int BestScore = 0;
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        CCSCover &Cover = pBB->m_covers[i];
        if (!Cover.IsValid() || Cover.IsLocked())
        {
            continue;
        }
        if (m_excludeCurrentCover && Cover.m_gameCover == Current.m_gameCover)
        {
            continue;
        }
        int Score = 0;
        if (Cover.m_state == CCS::CoverState_Valid)
        {
            Score = 20000;
        }
        Score += Max((int)(2000.0f - Abs(Cover.m_targetDist - m_idealShootingDistance)), 0);
        Score += Max((int)((2000.0f - Cover.m_pathDistance) * 0.25f), 0);
        if (!Best.IsValid() || Score > BestScore)
        {
            Best = Cover;
            BestScore = Score;
        }
    }
    if (!Best.IsValid() && Current.IsValid())
    {
        Best = Current;
    }
    return Best;
}

// @retail 0x83331CD8
void CCSRBTMoveToClosestCover::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    CCSBlackboard *pBB = static_cast<CCSBlackboard *>(pBlackboard);
    pBB->FlagCurrentTarget();
    pBB->m_covers.FlagAsUsed();
}

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8333EE10
CCSRBTMoveToClosestCover::CCSRBTMoveToClosestCover()
{
}
#endif

// @retail 0x8333EE58
CCSCover CCSRBTMoveToClosestCover::FindBestCover(IGripBTInterface *pInterface) const
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSCover Best;
    for (int i = 0; i < pBB->m_covers.Num(); i++)
    {
        CCSCover &Cover = pBB->m_covers[i];
        if (!Cover.IsValid() || Cover.IsLocked())
        {
            continue;
        }
        if (!Best.IsValid() || Cover.m_pathDistance < Best.m_pathDistance)
        {
            Best = Cover;
        }
    }
    return Best;
}

// @retail 0x83324B78
void CCSRBTMoveToInitialCover::FlagUsedBBMembers(GripBlackboard *pBlackboard)
{
    static_cast<CCSBlackboard *>(pBlackboard)->m_initialCover.FlagAsUsed();
}

// @retail 0x8333F128
CCSCover CCSRBTMoveToInitialCover::FindBestCover(IGripBTInterface *pInterface) const
{
    CCSBlackboard *pBB = pInterface->GetBlackboard<CCSBlackboard>();
    CCSCover &Initial = pBB->m_initialCover.GetReference();
    // the state is read through the property, the address of the cover is formed later
    if (pBB->m_initialCover.Get().IsValid() && !Initial.IsLocked())
    {
        return Initial;
    }
    return CCSCover::NONE;
}

// ccsrbtmovetobestcover.h's inline setters, out of line as in retail
#pragma inline_depth(0)
extern void (CCSRBTMoveToBestCover::*const EmitBestCoverSetIdealShootingDistance)(float) = &CCSRBTMoveToBestCover::SetIdealShootingDistance;
extern void (CCSRBTMoveToBestCover::*const EmitBestCoverSetExcludeCurrentCover)(bool) = &CCSRBTMoveToBestCover::SetExcludeCurrentCover;
#pragma inline_depth()

// @retail 0x8331EC78
// CCSRBTMoveToBestCover::SetIdealShootingDistance (in the header)
// @retail 0x8331EC80
// CCSRBTMoveToBestCover::SetExcludeCurrentCover (in the header)
