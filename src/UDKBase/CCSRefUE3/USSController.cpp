// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// usscontroller.cpp: the controller of a USS (cover-shooter) pawn.
// Not attempted yet (todo): AUSSController::PostPollMove (788 bytes).
#include "UDKBase/Inc/UDKBaseClasses.h"

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
