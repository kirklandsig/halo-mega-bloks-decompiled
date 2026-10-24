// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// usscontroller.cpp: the controller of a USS (cover-shooter) pawn.
#include "UDKBase/Inc/UDKBaseClasses.h"

// emitted out of line in retail too
template CCSMeatPuppetQuery *IGripBTInterface::GetMeatPuppetQuery<CCSMeatPuppetQuery>();

// @retail 0x83327210
// IGripBTInterface::GetMeatPuppetQuery<CCSMeatPuppetQuery> (in the header)

// Steps the pawn aside when its move would run into another pawn that is in
// cover: it aims for a point beside the other pawn, away from the cover.
// score 9 (was 11): the direction test is written as (Away | CoverFacing) <
// 0.0f and the target test as (Target | Pawn->Location) > 0.0f, which puts
// the dot products' operands the way round retail has them.
// Still differing: retail's destination and extent sret temporaries are at
// 0x60 and 0x50 where ours are at 0x70 and 0x60 (retail lets the extent
// buffer share the direction's slot), retail recomputes the cover and
// rotation addresses where ours forwards the callee's returned pointer, the
// global the line check is called through sits at another offset in the
// constant pool, and the first multiply of the direction test has its
// operands the other way round.
// Tried this session: spelling the extent scaling as "*=" instead of
// "x = x *" left the score at 9 (slot layout unchanged); binding the cover
// and rotation to named locals gives the retail "addi r4, r1, ..." form but
// grows the frame to 0x140 and scores worse; a permuter run over this body
// (3101 iterations, 8 rewrite kinds) found nothing better than 9.
// Tried again: naming only the rotation gives retail's "addi r4, r1, ..."
// for Vector2D but the frame grows to 0x140 and the score worsens to 91;
// naming only the cover does the same for GetOrientation (frame 0x150,
// score 61); writing the direction test out as "Away.X * CoverFacing.X +
// Away.Y * CoverFacing.Y + Away.Z * CoverFacing.Z" turns the first multiply
// the way round retail has it but leaves the score at 9.
// Retail's PDB names its locals direction/rotation/coverLocation/
// coverDirection/lineCheck/cover at 0x50/0x60/0x70/0xa0/0xb0/0xc0, so its
// extent and destination sret buffers are plain temporaries that share the
// direction's and rotation's slots; ours are named variables that take
// slots of their own, which is what moves them to 0x60 and 0x70.
// @retail 0x8336E868
void AUSSController::PostPollMove()
{
    if (bAdjusting)
    {
        return;
    }
    GripLineCheckResult Result;
    const Grip_Vector Destination = GetDestinationPosition();
    const Grip_Vector Start = Pawn->Location;
    Grip_Vector Extent = Pawn->GetCylinderExtent();
    Extent.X = Extent.X * 1.001f;
    Extent.Y *= 1.001f;
    GripEngineServices::SingleLineCheck(Result, this, Start, Destination, 1, Extent);
    if (0 == Result.m_pActor)
    {
        return;
    }
    APawn *pOther = ((AActor *)Result.m_pActor)->GetAPawn();
    if (pOther == 0)
    {
        return;
    }
    AUSSController *pOtherController = Cast<AUSSController>(pOther->Controller);
    if (0 == pOtherController || pOtherController->Brain == 0)
    {
        return;
    }
    CCSMeatPuppetQuery *pQuery;
    pQuery = pOtherController->Brain->GetMeatPuppetQuery<CCSMeatPuppetQuery>();
    if (!pQuery->IsInCover() || pQuery->GetCurrentCover() == CCSCover::NONE)
    {
        return;
    }
    FVector OtherLocation = pOther->Location;
    Grip_Vector Away = OtherLocation - Pawn->Location;
    Away.Z = 0.0f;
    Away.Normalize();
    Away = Grip_Vector(Away.Y, -Away.X, 0.0f);
    Grip_Vector CoverFacing = pQuery->GetCurrentCover().GetOrientation().Vector2D();
    CoverFacing.Z = 0.0f;
    if ((Away | CoverFacing) < 0.0f)
    {
        Away.X = Away.X * -1.0f;
        Away.Y = Away.Y * -1.0f;
        Away.Z = Away.Z * -1.0f;
    }
    const Grip_Vector Target = OtherLocation - static_cast<const Grip_Vector &>(Away) * 50.0f;
    if ((Target | Pawn->Location) > 0.0f)
    {
        SetAdjustLocation(Target, 1, 0);
    }
}

// @retail 0x8336A8C8
void AUSSController::DrawHUD(GripHUDRenderer *pRenderer, int &Y)
{
    const Grip_Color Color(0, 255, 0);
    Super::DrawHUD(pRenderer, Y);
    AUSSPawn *pPawn = Cast<AUSSPawn>(Pawn);
    if (pPawn == 0)
    {
        return;
    }
    const char *BoolNames[] = {"False", "True"};
    pRenderer->DrawString(18, Y, "In Cover:", Color);
    pRenderer->DrawString(255, Y, BoolNames[pPawn->bInCover], Color);
    Y += pRenderer->endl;
    const char *CoverPoseNames[] = {"Idle", "ShootRight", "ShootLeft", "ShootOver", "SideStepRight", "SideStepLeft", "BackSideStepRight", "BackSideStepLeft"};
    pRenderer->DrawString(18, Y, "Cover Pose:", Color);
    pRenderer->DrawString(255, Y, CoverPoseNames[pPawn->WantedCoverPose], Color);
    Y += pRenderer->endl;
}
