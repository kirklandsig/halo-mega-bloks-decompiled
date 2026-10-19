// @object Unity_UDKCoverEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833C7F48
AActor *UUDKTargetableComponent::GetOwner()
{
    return myOwner;
}

// @retail 0x833C7F70
void CCSNorman::RemoveTargeter(CCSPSTargetAwareness *pTargeter)
{
    CCSPSTargetAwareness *pCur = pFirstTargeter;
    if (pCur == pTargeter)
    {
        pFirstTargeter = pTargeter->pNextTargeter;
        return;
    }
    for (; pCur->pNextTargeter != 0; pCur = pCur->pNextTargeter)
    {
        if (pCur->pNextTargeter == pTargeter)
        {
            pCur->pNextTargeter = pTargeter->pNextTargeter;
            return;
        }
    }
}

// @retail 0x833C7FC8
void CCSNorman::RemoveCoverSeeker(CCSPSCover *pSeeker)
{
    CCSPSCover *pCur = pFirstCoverSeeker;
    if (pCur == pSeeker)
    {
        pFirstCoverSeeker = pSeeker->pNextCoverSeeker;
        return;
    }
    for (; pCur->pNextCoverSeeker != 0; pCur = pCur->pNextCoverSeeker)
    {
        if (pCur->pNextCoverSeeker == pSeeker)
        {
            pCur->pNextCoverSeeker = pSeeker->pNextCoverSeeker;
            return;
        }
    }
}

// Not attempted yet (todo), and why: the rest of this file (CCSNorman's
// constructor, getInstance, reset, the Add*/Count*/Get* functions) and
// UUDKTargetableComponent's Tick, BeginPlay, BeginDeath and BeginDestroy
// inline UE3's TArray templates (Num, operator(), Empty, AddItem, Remove),
// which aren't written yet.
