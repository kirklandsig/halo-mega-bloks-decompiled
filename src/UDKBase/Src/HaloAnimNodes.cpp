// @object Unity_UDKWeaponEtAl.cpp.obj
// n-Space's Halo animation nodes: haloanimblendbyaimprofile.cpp,
// haloanimblendbyforwardmomentum.cpp, haloanimblendbyjumptype.cpp,
// haloanimblendbyphysics.cpp, haloanimblendbyturninplace.cpp and
// haloanimnodecopybonetranslation.cpp, in one file as the unity object
// compiles them, after the UDK function they inline.
#include "UDKBase/Inc/UDKBaseClasses.h"
#include "Core/Inc/UnMath.h"

// udkanimnodes.cpp (UDK's), which the nodes' TickAnim inline
// @retail 0x8337C4B8
void UUDKAnimBlendBase::TickAnim(float DeltaSeconds)
{
    if (bTickAnimInScript)
    {
        eventTickAnim(DeltaSeconds);
    }
    Super::TickAnim(DeltaSeconds);
}

// ---- haloanimblendbyaimprofile.cpp

// @retail 0x8338F130
void UHaloAnimBlendByAimProfile::WeapTypeChanged(FName NewAimProfileName)
{
    for (int i = 0; i < Children.Num(); i++)
    {
        if (Children(i).Name == NewAimProfileName)
        {
            if (Children(i).Anim != 0)
            {
                SetActiveChild(i, 0.0f);
                return;
            }
            break;
        }
    }
    SetActiveChild(0, 0.0f);
}

// ---- haloanimblendbyforwardmomentum.cpp

// @retail 0x833B8148
void UHaloAnimBlendByForwardMomentum::TickAnim(float DeltaSeconds)
{
    if (SkelComponent != 0 && SkelComponent->GetOwner() != 0)
    {
        AUDKPawn *Pawn = Cast<AUDKPawn>(SkelComponent->GetOwner());
        if (Pawn != 0)
        {
            SliderPosition = (Pawn->Velocity | Pawn->Rotation.Vector()) / Pawn->GroundSpeed;
            UpdateChildWeights();
        }
    }
    Super::TickAnim(DeltaSeconds);
}

// @retail 0x8337BDB0
float UHaloAnimBlendByForwardMomentum::GetSliderPosition(int, int)
{
    return SliderPosition;
}

// @retail 0x833984A0
FString UHaloAnimBlendByForwardMomentum::GetSliderDrawValue(int)
{
    return FString::Printf__VA(L"%3.2f%%", SliderPosition * 100.0f);
}

// @retail 0x8338ED98
void UHaloAnimBlendByForwardMomentum::UpdateChildWeights()
{
    SliderPosition = Clamp(SliderPosition, 0.0f, 1.0f);
    Children(0).Weight = 1.0f - SliderPosition;
    Children(1).Weight = SliderPosition;
    ActiveChildIndex = (int)(SliderPosition + 0.5f);
}

// @retail 0x8338EE08
void UHaloAnimBlendByForwardMomentum::HandleSliderMove(int, int, float NewSliderValue)
{
    SliderPosition = NewSliderValue;
    UpdateChildWeights();
}

// ---- haloanimblendbyjumptype.cpp

namespace
{
// @retail 0x833984F0
void AlwaysTickChild(USkeletalMeshComponent *SkelComp, UAnimNode *Node, bool bAlwaysTick)
{
    if (SkelComp == 0 || Node == 0)
    {
        return;
    }
    if (bAlwaysTick)
    {
        SkelComp->AnimAlwaysTickArray.AddUniqueItem(Node);
    }
    else
    {
        SkelComp->AnimAlwaysTickArray.RemoveItem(Node);
    }
    UAnimNodeBlendBase *Blend = Cast<UAnimNodeBlendBase>(Node);
    if (Blend != 0)
    {
        for (int i = 0; i < Blend->Children.Num(); i++)
        {
            AlwaysTickChild(SkelComp, Blend->Children(i).Anim, bAlwaysTick);
        }
    }
}

// @retail 0x8338EE78
void PlayJumpAnimOnChild(UAnimNode *Node)
{
    if (Node == 0)
    {
        return;
    }
    UHaloAnimBlendByJumpLand *JumpLand = Cast<UHaloAnimBlendByJumpLand>(Node);
    if (JumpLand != 0)
    {
        JumpLand->PlayJumpAnim();
        return;
    }
    UAnimNodeBlendBase *Blend = Cast<UAnimNodeBlendBase>(Node);
    if (Blend != 0)
    {
        for (int i = 0; i < Blend->Children.Num(); i++)
        {
            PlayJumpAnimOnChild(Blend->Children(i).Anim);
        }
    }
}
}

// @retail 0x83388F98
void UHaloAnimBlendByJumpType::TickAnim(float DeltaSeconds)
{
    Super::TickAnim(DeltaSeconds);
    if (LandBlendDelayTimer > 0.0f)
    {
        LandBlendDelayTimer -= DeltaSeconds;
        if (LandBlendDelayTimer <= 0.0f)
        {
            SetActiveChild(0, LandBlend);
        }
    }
}

// @retail 0x83398598
void UHaloAnimBlendByJumpType::SetActiveChild(int ChildIndex, float BlendTime)
{
    if (ActiveChildIndex > 0)
    {
        AlwaysTickChild(SkelComponent, Children(ActiveChildIndex).Anim, false);
    }
    Super::SetActiveChild(ChildIndex, BlendTime);
    if (ActiveChildIndex > 0)
    {
        AlwaysTickChild(SkelComponent, Children(ActiveChildIndex).Anim, true);
    }
}

// @retail 0x8337BDB8
void UHaloAnimBlendByJumpType::OnBecomeRelevant()
{
    if ((CachedJumpType <= 0 || CachedJumpType > 3) && ActiveChildIndex != 0)
    {
        SetActiveChild(0, 0.0f);
    }
}

// @retail 0x8338EF08
void UHaloAnimBlendByJumpType::OnChangeJumpType(int NewJumpType, unsigned int bPlayJumpAnim)
{
    bool bLanded = CachedJumpType > 0 && NewJumpType <= 0;
    if (bLanded)
    {
        if (LandBlendDelay > 0.0f)
        {
            LandBlendDelayTimer = LandBlendDelay;
        }
        else
        {
            SetActiveChild(0, LandBlend);
        }
    }
    else if (NewJumpType >= 1 && NewJumpType < Children.Num())
    {
        SetActiveChild(NewJumpType, 0.0f);
        if (bPlayJumpAnim)
        {
            PlayJumpAnimOnChild(Children(ActiveChildIndex).Anim);
        }
    }
    CachedJumpType = NewJumpType;
}

// ---- haloanimblendbyphysics.cpp

namespace
{
// @retail 0x8338F000
bool IsPawnJumping(APawn *Pawn)
{
    UByteProperty *JumpType = Cast<UByteProperty>(FindField<UProperty>(Pawn->GetClass(), FName("JumpType", FNAME_Add)));
    if (JumpType != 0)
    {
        return *((unsigned char *)Pawn + JumpType->Offset) != 0;
    }
    return false;
}
}

// @retail 0x8338F090
void UHaloAnimBlendByPhysics::SetActiveChild(int ChildIndex, float BlendTime)
{
    if (ChildIndex == PhysicsMap[PHYS_Falling] && SkelComponent != 0 && SkelComponent->GetOwner() != 0)
    {
        APawn *Pawn = SkelComponent->GetOwner()->GetAPawn();
        if (Pawn != 0 && IsPawnJumping(Pawn))
        {
            BlendTime = JumpBlendInTime;
        }
    }
    Super::SetActiveChild(ChildIndex, BlendTime);
}

// ---- haloanimblendbyturninplace.cpp

// @retail 0x83389030
void UHaloAnimBlendByTurnInPlace::TickAnim(float DeltaSeconds)
{
    if (SkelComponent != 0 && SkelComponent->GetOwner() != 0 && OwnerUTP != 0)
    {
        if (OwnerUTP->RootYawSpeed < -RootYawSpeedThresh)
        {
            if (ActiveChildIndex != 0)
            {
                SetActiveChild(0, BlendTime);
            }
        }
        else if (OwnerUTP->RootYawSpeed > RootYawSpeedThresh)
        {
            if (ActiveChildIndex != 2)
            {
                SetActiveChild(2, BlendTime);
            }
        }
        else if (ActiveChildIndex != 1)
        {
            SetActiveChild(1, BlendTime);
        }
    }
    UUDKAnimBlendBase::TickAnim(DeltaSeconds);
}

// ---- haloanimnodecopybonetranslation.cpp

// @retail 0x833BC6D0
void UHaloAnimNodeCopyBoneTranslation::InitAnim(USkeletalMeshComponent *MeshComp, UAnimNodeBlendBase *Parent)
{
    Super::InitAnim(MeshComp, Parent);
    AimProfileBlends.Empty();
    TArray<UAnimNode *, FDefaultAllocator> Nodes;
    MeshComp->Animations->GetNodes(Nodes, 0);
    for (int i = 0; i < Nodes.Num(); i++)
    {
        UHaloAnimBlendByAimProfile *Blend = Cast<UHaloAnimBlendByAimProfile>(Nodes(i));
        if (Blend != 0)
        {
            AimProfileBlends.AddItem(Blend);
        }
    }
}

// @retail 0x833AC110
void UHaloAnimNodeCopyBoneTranslation::TickAnim(float DeltaSeconds)
{
    FName AimProfileName(NAME_None);
    if (CachedAimNode != 0)
    {
        FAimOffsetProfile *Profile = CachedAimNode->GetCurrentProfile();
        if (Profile != 0)
        {
            AimProfileName = Profile->ProfileName;
        }
    }
    if (AimProfileName != OldAimProfileName)
    {
        for (int i = 0; i < AimProfileBlends.Num(); i++)
        {
            AimProfileBlends(i)->WeapTypeChanged(AimProfileName);
        }
    }
    Super::TickAnim(DeltaSeconds);
}
