// @object Unity_UDKCoverEtAl.cpp.obj
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnMath.h"

// @retail 0x833C8148
void AUDKCover::BeginDestroy()
{
    Super::BeginDestroy();
}

// @retail 0x833C8150
void AUDKCover::AddCoverLink(ACoverLink *Link)
{
    Link->NextDestructibleCoverLink = FirstCoverLink;
    FirstCoverLink = Link;
}

// @retail 0x833C8160
void AUDKCover::RemoveCoverLink(ACoverLink *Link)
{
    ACoverLink *Prev = 0;
    for (ACoverLink *Cur = FirstCoverLink; Cur != 0; Cur = Cur->NextDestructibleCoverLink)
    {
        if (Cur == Link)
        {
            if (Prev != 0)
            {
                Prev->NextDestructibleCoverLink = Cur->NextDestructibleCoverLink;
            }
            else
            {
                FirstCoverLink = Cur->NextDestructibleCoverLink;
            }
            Cur->NextDestructibleCoverLink = 0;
            return;
        }
        Prev = Cur;
    }
}

// @retail 0x833C9628
void AUDKCover::PreBeginPlay()
{
    Super::PreBeginPlay();
    ACoverLink *List = CCSNorman::getInstance()->GetDestructibleCoverList(this);
    if (List != 0)
    {
        if (FirstCoverLink == 0)
        {
            FirstCoverLink = List;
        }
        else
        {
            ACoverLink *Link = FirstCoverLink;
            while (Link->NextDestructibleCoverLink != 0)
            {
                Link = Link->NextDestructibleCoverLink;
            }
            Link->NextDestructibleCoverLink = List;
        }
    }
}

// @retail 0x833C9100
FVector AUDKCover::GetPawnViewLocation()
{
    UUDKTargetableComponent *Comp = Cast<UUDKTargetableComponent>(GetComponentOfType(UUDKTargetableComponent::StaticClass()));
    if (Comp != 0)
    {
        return Location + FVector(0.0f, 0.0f, 1.0f) * Comp->fAITargetHeight;
    }
    return Location;
}

// @retail 0x833C81C0
void AUDKCover::KillCoverLinks()
{
    while (FirstCoverLink != 0)
    {
        FirstCoverLink->eventSetDisabled(1);
        FirstCoverLink = FirstCoverLink->NextDestructibleCoverLink;
    }
}
