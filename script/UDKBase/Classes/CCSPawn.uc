interface CCSPawn extends Interface
	native;

enum ECCSMovementType
{
	CCSMovementType_Idle,           // 0
	CCSMovementType_Walk,           // 1
	CCSMovementType_Run,            // 2
	CCSMovementType_Strafe,         // 3
	CCSMovementType_Encircle,       // 4
	CCSMovementType_MAX             // 5
};

enum ECCSMovementSpeed
{
	CCSMovementSpeed_Walk,          // 0
	CCSMovementSpeed_Run,           // 1
	CCSMovementSpeed_MAX            // 2
};

enum ECCSAlertnessState
{
	CCSAlertnessState_Relax,        // 0
	CCSAlertnessState_Alert,        // 1
	CCSAlertnessState_MAX           // 2
};

enum ECCSCoverPose
{
	CCSCoverPose_Idle,              // 0
	CCSCoverPose_ShootRight,        // 1
	CCSCoverPose_ShootLeft,         // 2
	CCSCoverPose_ShootOver,         // 3
	CCSCoverPose_SideStepRight,     // 4
	CCSCoverPose_SideStepLeft,      // 5
	CCSCoverPose_BackSideStepRight, // 6
	CCSCoverPose_BackSideStepLeft,  // 7
	CCSCoverPose_MAX                // 8
};

// Export UCCSPawn::execGetMovementType(FFrame&, void* const)
native function CCSPawn.ECCSMovementType GetMovementType();

// Export UCCSPawn::execSetMovementType(FFrame&, void* const)
native function SetMovementType(CCSPawn.ECCSMovementType NewMovementType);

// Export UCCSPawn::execSetMovementTypeDefault(FFrame&, void* const)
native function SetMovementTypeDefault();

// Export UCCSPawn::execGetAlertness(FFrame&, void* const)
native function CCSPawn.ECCSAlertnessState GetAlertness();

// Export UCCSPawn::execSetAlertness(FFrame&, void* const)
native function SetAlertness(CCSPawn.ECCSAlertnessState NewAlertness);

// Export UCCSPawn::execSetAlertnessDefault(FFrame&, void* const)
native function SetAlertnessDefault();

// Export UCCSPawn::execGetSpeed(FFrame&, void* const)
native function CCSPawn.ECCSMovementSpeed GetSpeed();

// Export UCCSPawn::execSetSpeed(FFrame&, void* const)
native function SetSpeed(CCSPawn.ECCSMovementSpeed Speed);

// Export UCCSPawn::execSetMovementSpeedDefault(FFrame&, void* const)
native function SetMovementSpeedDefault();

// Export UCCSPawn::execIsCrouched(FFrame&, void* const)
native function bool IsCrouched();

// Export UCCSPawn::execSetCrouched(FFrame&, void* const)
native function SetCrouched(bool bCrouched);

// Export UCCSPawn::execSetPostureDefault(FFrame&, void* const)
native function SetPostureDefault();

// Export UCCSPawn::execPostureTransitionOver(FFrame&, void* const)
native function bool PostureTransitionOver();

// Export UCCSPawn::execCanAim(FFrame&, void* const)
native function bool CanAim(Rotator AimRotation);

// Export UCCSPawn::execSetCoverPose(FFrame&, void* const)
native function SetCoverPose(CCSPawn.ECCSCoverPose NewCoverPose, optional float BlendTime = -1.0000000);

// Export UCCSPawn::execSetNoCoverPose(FFrame&, void* const)
native function SetNoCoverPose();

// Export UCCSPawn::execCoverPoseTransitionOver(FFrame&, void* const)
native function bool CoverPoseTransitionOver();

// Export UCCSPawn::execMoveToInCover(FFrame&, void* const)
native function MoveToInCover(Vector Dest);

// Export UCCSPawn::execIsInCover(FFrame&, void* const)
native function bool IsInCover();

// Export UCCSPawn::execGetIsPanicking(FFrame&, void* const)
native function bool GetIsPanicking();

// Export UCCSPawn::execSetIsPanicking(FFrame&, void* const)
native function SetIsPanicking(bool isPanicking);

// Export UCCSPawn::execGetYellingDistance(FFrame&, void* const)
native function float GetYellingDistance();

// Export UCCSPawn::execGetDefaultBehaviorTree(FFrame&, void* const)
native function CCSBTTree GetDefaultBehaviorTree();

// Export UCCSPawn::execSetDefaultBehaviorTree(FFrame&, void* const)
native function SetDefaultBehaviorTree(CCSBTTree newDefaultBehaviorTree);

simulated function bool IsPlayingCustomAnimation()
{
	//return ReturnValue;	
}

simulated function PlayFiringAnimation(optional bool charge = false, optional bool lastShot = false)
{
	//return;	
}
