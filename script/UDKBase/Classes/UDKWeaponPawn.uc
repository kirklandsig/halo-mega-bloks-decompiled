class UDKWeaponPawn extends UDKVehicleBase
	native
	nativereplication
	config(GwNavEngine)
	implements(CCSPawn);

var private native const noexport Pointer VfTable_ICCSPawn;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSAlertnessState AlertnessState;
var Vector2D AimYawRange;
var Vector2D AimPitchRange;
var CCSBTTree DefaultBehaviorTree;
var float YellingDistance;
var repnotify UDKVehicle MyVehicle;
var repnotify UDKWeapon MyVehicleWeapon;
var repnotify int MySeatIndex;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		MySeatIndex, MyVehicle, 
		MyVehicleWeapon;
}

// Export UUDKWeaponPawn::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc);

// Export UUDKWeaponPawn::execGetMovementType(FFrame&, void* const)
native function CCSPawn.ECCSMovementType GetMovementType();

// Export UUDKWeaponPawn::execSetMovementType(FFrame&, void* const)
native function SetMovementType(CCSPawn.ECCSMovementType NewMovementType);

// Export UUDKWeaponPawn::execSetMovementTypeDefault(FFrame&, void* const)
native function SetMovementTypeDefault();

// Export UUDKWeaponPawn::execGetAlertness(FFrame&, void* const)
native function CCSPawn.ECCSAlertnessState GetAlertness();

// Export UUDKWeaponPawn::execSetAlertness(FFrame&, void* const)
native function SetAlertness(CCSPawn.ECCSAlertnessState NewAlertness);

// Export UUDKWeaponPawn::execSetAlertnessDefault(FFrame&, void* const)
native function SetAlertnessDefault();

// Export UUDKWeaponPawn::execGetSpeed(FFrame&, void* const)
native function CCSPawn.ECCSMovementSpeed GetSpeed();

// Export UUDKWeaponPawn::execSetSpeed(FFrame&, void* const)
native function SetSpeed(CCSPawn.ECCSMovementSpeed Speed);

// Export UUDKWeaponPawn::execSetMovementSpeedDefault(FFrame&, void* const)
native function SetMovementSpeedDefault();

// Export UUDKWeaponPawn::execIsCrouched(FFrame&, void* const)
native function bool IsCrouched();

// Export UUDKWeaponPawn::execSetCrouched(FFrame&, void* const)
native function SetCrouched(bool bCrouched);

// Export UUDKWeaponPawn::execSetPostureDefault(FFrame&, void* const)
native function SetPostureDefault();

// Export UUDKWeaponPawn::execPostureTransitionOver(FFrame&, void* const)
native function bool PostureTransitionOver();

// Export UUDKWeaponPawn::execCanAim(FFrame&, void* const)
native function bool CanAim(Rotator AimRotation);

// Export UUDKWeaponPawn::execSetCoverPose(FFrame&, void* const)
native function SetCoverPose(CCSPawn.ECCSCoverPose NewCoverPose, optional float BlendTime = -1.0000000);

// Export UUDKWeaponPawn::execSetNoCoverPose(FFrame&, void* const)
native function SetNoCoverPose();

// Export UUDKWeaponPawn::execCoverPoseTransitionOver(FFrame&, void* const)
native function bool CoverPoseTransitionOver();

// Export UUDKWeaponPawn::execMoveToInCover(FFrame&, void* const)
native function MoveToInCover(Vector Dest);

// Export UUDKWeaponPawn::execIsInCover(FFrame&, void* const)
native function bool IsInCover();

// Export UUDKWeaponPawn::execSetIsPanicking(FFrame&, void* const)
native function SetIsPanicking(bool isPanicking);

// Export UUDKWeaponPawn::execGetIsPanicking(FFrame&, void* const)
native function bool GetIsPanicking();

// Export UUDKWeaponPawn::execGetYellingDistance(FFrame&, void* const)
native function float GetYellingDistance();

simulated function bool IsPlayingCustomAnimation()
{
	return false;
	//return ReturnValue;	
}

simulated function PlayFiringAnimation(optional bool charge = false, optional bool lastShot = false)
{
	//return;	
}

// Export UUDKWeaponPawn::execGetDefaultBehaviorTree(FFrame&, void* const)
native function CCSBTTree GetDefaultBehaviorTree();

// Export UUDKWeaponPawn::execSetDefaultBehaviorTree(FFrame&, void* const)
native function SetDefaultBehaviorTree(CCSBTTree newDefaultBehaviorTree);

defaultproperties
{
	// Reference: GwNavBotHandle'UDKBase.Default__UDKWeaponPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UDKBase.Default__UDKVehicleBase.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: RB_StayUprightSetup'UDKBase.Default__UDKWeaponPawn.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UDKBase.Default__UDKVehicleBase.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'UDKBase.Default__UDKWeaponPawn.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UDKBase.Default__UDKVehicleBase.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	// Reference: SkeletalMeshComponent'UDKBase.Default__UDKWeaponPawn.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UDKBase.Default__UDKVehicleBase.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'UDKBase.Default__UDKWeaponPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UDKBase.Default__UDKVehicleBase.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	CollisionComponent=SVehicleMesh
}