// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// usscontroller.cpp: the controller of a USS (cover-shooter) pawn.
#include "UDKBase/Inc/UDKBaseClasses.h"

// emitted out of line in retail too
template CCSMeatPuppetQuery *IGripBTInterface::GetMeatPuppetQuery<CCSMeatPuppetQuery>();

// @retail 0x83327210
// IGripBTInterface::GetMeatPuppetQuery<CCSMeatPuppetQuery> (in the header)

// Todo (804 bytes vs 788): retail copies the other pawn's location through
// the stack and keeps different stack slots; the logic is retail's. The casts
// to const pick Grip_Vector::operator*(float): the PDB doesn't record that
// Grip_Vector(float) is explicit, so both overloads are viable here.
// Steps the pawn aside when its move would run into another pawn that is in
// cover: it aims for a point beside the other pawn, away from the cover.
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
    Extent.X *= 1.001f;
    Extent.Y *= 1.001f;
    GripEngineServices::SingleLineCheck(Result, this, Start, Destination, 1, Extent);
    if (Result.m_pActor == 0)
    {
        return;
    }
    APawn *pOther = ((AActor *)Result.m_pActor)->GetAPawn();
    if (pOther == 0)
    {
        return;
    }
    AUSSController *pOtherController = Cast<AUSSController>(pOther->Controller);
    if (pOtherController == 0 || pOtherController->Brain == 0)
    {
        return;
    }
    CCSMeatPuppetQuery *pQuery = pOtherController->Brain->GetMeatPuppetQuery<CCSMeatPuppetQuery>();
    if (!pQuery->IsInCover() || pQuery->GetCurrentCover() == CCSCover::NONE)
    {
        return;
    }
    const Grip_Vector OtherLocation = pOther->Location;
    Grip_Vector Away(OtherLocation.X - Pawn->Location.X, OtherLocation.Y - Pawn->Location.Y, 0.0f);
    Away.Normalize();
    Away = Grip_Vector(Away.Y, -Away.X, 0.0f);
    Grip_Vector CoverFacing = pQuery->GetCurrentCover().GetOrientation().Vector2D();
    CoverFacing.Z = 0.0f;
    if ((Away | CoverFacing) < 0.0f)
    {
        Away = static_cast<const Grip_Vector &>(Away) * -1.0f;
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
