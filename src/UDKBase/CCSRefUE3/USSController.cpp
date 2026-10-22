// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// usscontroller.cpp: the controller of a USS (cover-shooter) pawn.
#include "UDKBase/Inc/UDKBaseClasses.h"

// emitted out of line in retail too
template CCSMeatPuppetQuery *IGripBTInterface::GetMeatPuppetQuery<CCSMeatPuppetQuery>();

// @retail 0x83327210
// IGripBTInterface::GetMeatPuppetQuery<CCSMeatPuppetQuery> (in the header)

// Steps the pawn aside when its move would run into another pawn that is in
// cover: it aims for a point beside the other pawn, away from the cover.
// score 146 (was 153): the rotation is now a local assigned in place, so the
// stack slots match retail (rotation 0x60, scaled extent 0x70, destination
// 0x80, start 0x90, cover direction 0xa0, line check 0xb0, cover 0xc0).
// Still differing: retail zeroes the whole line check result where ours
// zeroes the rotation, retail copies the other pawn's location into a stack
// slot (a 12 byte copy) where ours keeps it in registers, retail keeps the
// negated direction in registers (a phi) where ours stores it back, and
// retail's `this` is in r29, ours in r30.
// @retail 0x8336E868
void AUSSController::PostPollMove()
{
    if (bAdjusting)
    {
        return;
    }
    Grip_Rotation Rotation;
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
    Grip_Vector OtherLocation = pOther->Location;
    Grip_Vector Away = OtherLocation - Pawn->Location;
    Away.Z = 0.0f;
    Away.Normalize();
    Away = Grip_Vector(Away.Y, -Away.X, 0.0f);
    Rotation = pQuery->GetCurrentCover().GetOrientation();
    Grip_Vector CoverFacing = Rotation.Vector2D();
    CoverFacing.Z = 0.0f;
    if (0.0f > (Away | CoverFacing))
    {
        Away = static_cast<const Grip_Vector &>(Away) * -1.0f;
    }
    const Grip_Vector Target = OtherLocation - static_cast<const Grip_Vector &>(Away) * 50.0f;
    if ((Pawn->Location | Target) > 0.0f)
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
