// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ussanimtree.cpp: blend lists that follow the pawn's alertness, cover,
// cover pose, movement and posture.
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x8332B980
void UUSSATBlendByAlertness::TickAnim(float DeltaSeconds)
{
    if (SkelComponent != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>(SkelComponent->GetOwner());
        if (pPawn != 0)
        {
            const unsigned char Alertness = pPawn->GetAlertness();
            const int Difference = Abs(ActiveChildIndex - Alertness);
            if (Difference != 0)
            {
                SetActiveChild(Alertness, BlendTime * Difference);
            }
        }
    }
    Super::TickAnim(DeltaSeconds);
}

// @retail 0x8332BA40
void UUSSATBlendByCover::TickAnim(float DeltaSeconds)
{
    if (SkelComponent != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>(SkelComponent->GetOwner());
        if (pPawn != 0)
        {
            if (pPawn->bShouldCover != pPawn->bInCover)
            {
                SetActiveChild(pPawn->bShouldCover, BlendTime);
                pPawn->bInCover = pPawn->bShouldCover;
            }
            else if (pPawn->bInCover != (unsigned long)ActiveChildIndex)
            {
                SetActiveChild(pPawn->bInCover, BlendTime);
            }
        }
    }
    Super::TickAnim(DeltaSeconds);
}

// @retail 0x833397D8
void UUSSATBlendByCoverPose::TickAnim(float DeltaSeconds)
{
    if (SkelComponent != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>(SkelComponent->GetOwner());
        if (pPawn != 0)
        {
            if (ActiveChildIndex != pPawn->WantedCoverPose)
            {
                SetActiveChild(pPawn->WantedCoverPose,
                               pPawn->CoverPoseBlendTimeOverride > 0.0f ? pPawn->CoverPoseBlendTimeOverride : BlendTime);
            }
            if (pPawn->WantedCoverPose != pPawn->CurrentCoverPose)
            {
                UAnimNodeSequence *pSequence = Cast<UAnimNodeSequence>(Children(ActiveChildIndex).Anim);
                if (((pSequence == 0 || pSequence->bLooping) && Children(ActiveChildIndex).Weight > 0.9f) ||
                    (pSequence != 0 && !pSequence->bPlaying))
                {
                    pPawn->CurrentCoverPose = pPawn->WantedCoverPose;
                }
            }
        }
    }
    Super::TickAnim(DeltaSeconds);
}

// @retail 0x8332BB10
void UUSSATBlendByCoverPose::OnCeaseRelevant()
{
    if (SkelComponent != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>(SkelComponent->GetOwner());
        if (pPawn != 0)
        {
            pPawn->CurrentCoverPose = pPawn->WantedCoverPose;
        }
    }
    Super::OnCeaseRelevant();
}

// @retail 0x8332BB68
void UUSSATBlendByMove::TickAnim(float DeltaSeconds)
{
    if (SkelComponent != 0)
    {
        AUDKPawn *pPawn = Cast<AUDKPawn>(SkelComponent->GetOwner());
        if (pPawn != 0)
        {
            const unsigned char MovementType = pPawn->GetMovementType();
            const int Difference = Abs(ActiveChildIndex - MovementType);
            if (Difference != 0)
            {
                SetActiveChild(MovementType, BlendTime * Difference);
            }
        }
    }
    Super::TickAnim(DeltaSeconds);
}

// @retail 0x8336A718
void UUSSATBlendByPosture::TickAnim(float DeltaSeconds)
{
    APawn *pPawn = SkelComponent != 0 ? Cast<APawn>(SkelComponent->GetOwner()) : 0;
    if (pPawn != 0)
    {
        const int Difference = Abs(ActiveChildIndex - (int)pPawn->bIsCrouched);
        if (Difference != 0)
        {
            SetActiveChild(pPawn->bIsCrouched, BlendTime * Difference);
        }
    }
    AUSSPawn *pUSSPawn = Cast<AUSSPawn>(pPawn);
    if (pUSSPawn != 0 && Children(ActiveChildIndex).Weight > 0.99f && pUSSPawn->bInCrouchedPosture != pPawn->bIsCrouched)
    {
        pUSSPawn->bInCrouchedPosture = pPawn->bIsCrouched;
    }
    Super::TickAnim(DeltaSeconds);
}
