class USSPawn extends Pawn
	native
	config(Game)
	implements(CCSPawn)
	dependson(CCSPawn);

var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSAlertnessState AlertnessState;
var CCSPawn.ECCSCoverPose WantedCoverPose;
var CCSPawn.ECCSCoverPose CurrentCoverPose;
var bool bInCrouchedPosture;
var bool bShouldCover;
var private bool bInCover;
var private bool bIsPanicking;
var private float CoverPct;
var float CoverPoseBlendTimeOverride;
var Vector2D AimCurrentSkel;
var Vector2D AimPitchRange;
var Vector2D AimYawRange;
var float MaxPitchSpeed;
var float MaxYawSpeed;
var Class<USSWeaponAttachment> CurrentWeaponAttachmentClass;
var USSWeaponAttachment CurrentWeaponAttachment;
var float WeaponHeight;
var ParticleSystem BloodParticleSystem;
var array<AnimNodeAimOffset> AimNodes;

// Export UUSSPawn::execGetMovementType(FFrame&, void* const)
native function CCSPawn.ECCSMovementType GetMovementType();

// Export UUSSPawn::execSetMovementType(FFrame&, void* const)
native function SetMovementType(CCSPawn.ECCSMovementType NewMovementType);

// Export UUSSPawn::execSetMovementTypeDefault(FFrame&, void* const)
native function SetMovementTypeDefault();

// Export UUSSPawn::execGetAlertness(FFrame&, void* const)
native function CCSPawn.ECCSAlertnessState GetAlertness();

// Export UUSSPawn::execSetAlertness(FFrame&, void* const)
native function SetAlertness(CCSPawn.ECCSAlertnessState NewAlertness);

// Export UUSSPawn::execSetAlertnessDefault(FFrame&, void* const)
native function SetAlertnessDefault();

// Export UUSSPawn::execGetSpeed(FFrame&, void* const)
native function CCSPawn.ECCSMovementSpeed GetSpeed();

// Export UUSSPawn::execSetSpeed(FFrame&, void* const)
native function SetSpeed(CCSPawn.ECCSMovementSpeed Speed);

// Export UUSSPawn::execSetMovementSpeedDefault(FFrame&, void* const)
native function SetMovementSpeedDefault();

// Export UUSSPawn::execIsCrouched(FFrame&, void* const)
native function bool IsCrouched();

// Export UUSSPawn::execSetCrouched(FFrame&, void* const)
native function SetCrouched(bool bCrouched);

// Export UUSSPawn::execSetPostureDefault(FFrame&, void* const)
native function SetPostureDefault();

// Export UUSSPawn::execPostureTransitionOver(FFrame&, void* const)
native function bool PostureTransitionOver();

// Export UUSSPawn::execCanAim(FFrame&, void* const)
native function bool CanAim(Rotator AimRotation);

// Export UUSSPawn::execSetCoverPose(FFrame&, void* const)
native function SetCoverPose(CCSPawn.ECCSCoverPose NewCoverPose, optional float BlendTime = -1.0000000);

// Export UUSSPawn::execSetNoCoverPose(FFrame&, void* const)
native function SetNoCoverPose();

// Export UUSSPawn::execCoverPoseTransitionOver(FFrame&, void* const)
native function bool CoverPoseTransitionOver();

// Export UUSSPawn::execMoveToInCover(FFrame&, void* const)
native function MoveToInCover(Vector Dest);

// Export UUSSPawn::execIsInCover(FFrame&, void* const)
native function bool IsInCover();

// Export UUSSPawn::execSetIsPanicking(FFrame&, void* const)
native function SetIsPanicking(bool isPanicking);

// Export UUSSPawn::execGetIsPanicking(FFrame&, void* const)
native function bool GetIsPanicking();

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local AnimNodeAimOffset AimNode;

	AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimStand'));
	// End:0x60
	if(AimNode != none)
	{
		AimNodes.AddItem(AimNode);
	}
	AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimCoverStand'));
	// End:0xC0
	if(AimNode != none)
	{
		AimNodes.AddItem(AimNode);
	}
	AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimCrouch'));
	// End:0x120
	if(AimNode != none)
	{
		AimNodes.AddItem(AimNode);
	}
	AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimCoverCrouch'));
	// End:0x180
	if(AimNode != none)
	{
		AimNodes.AddItem(AimNode);
	}
	//return;	
}

simulated function WeaponAttachmentChanged()
{
	// End:0x142
	if(((CurrentWeaponAttachment == none) || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass) && Mesh.SkeletalMesh != none)
	{
		// End:0xB2
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.DetachFrom(Mesh);
			CurrentWeaponAttachment.Destroy();
		}
		// End:0x108
		if(CurrentWeaponAttachmentClass != none)
		{
			CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass, self);
			CurrentWeaponAttachment.Instigator = self;			
		}
		else
		{
			CurrentWeaponAttachment = none;
		}
		// End:0x142
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.AttachTo(self);
		}
	}
	//return;	
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
	super.PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
	PlayTakeHitEffects(Damage, HitLocation, DamageType, Momentum, HitInfo);
	//return;	
}

simulated function PlayTakeHitEffects(float Damage, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
	local Vector BloodMomentum;

	// End:0x1D
	if(!EffectIsRelevant(Location, false))
	{
		return;
	}
	// End:0x7C
	if(((Damage < float(0)) || IsZero(Momentum)) || WorldInfo.Game.GoreLevel == 0)
	{
		return;
	}
	// End:0x107
	if(BloodParticleSystem != none)
	{
		BloodMomentum = Normal(-1.0000000 * Momentum) + (0.5000000 * VRand());
		WorldInfo.MyEmitterPool.SpawnEmitter(BloodParticleSystem, HitLocation, Rotator(BloodMomentum), self);
	}
	//return;	
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
{
	local TraceHitInfo HitInfo;
	local Vector ApplyImpulse, ShotDir;

	// End:0x1A
	if(int(Physics) == int(10))
	{
		SetPhysics(2);
	}
	CurrentWeaponAttachmentClass = none;
	WeaponAttachmentChanged();
	Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
	SetPawnRBChannels(true);
	Mesh.ForceSkelUpdate();
	Mesh.SetTickGroup(2);
	PreRagdollCollisionComponent = CollisionComponent;
	CollisionComponent = Mesh;
	CylinderComponent.SetActorCollision(false, false);
	Mesh.SetActorCollision(true, true);
	Mesh.SetTraceBlocking(true, true);
	SetPhysics(10);
	Mesh.PhysicsWeight = 1.0000000;
	// End:0x195
	if(Mesh.bNotUpdatingKinematicDueToDistance)
	{
		Mesh.UpdateRBBonesFromSpaceBases(true, true);
	}
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
	Mesh.bUpdateKinematicBonesFromAnimation = false;
	Mesh.SetRBLinearVelocity(Velocity, false);
	Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * Mesh.Translation.Z);
	Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
	Mesh.SetNotifyRigidBodyCollision(true);
	Mesh.WakeRigidBody();
	HitDamageType = DamageType;
	TakeHitLocation = HitLoc;
	CheckHitInfo(HitInfo, Mesh, Normal(TearOffMomentum), TakeHitLocation);
	// End:0x442
	if(TearOffMomentum != vect(0.0000000, 0.0000000, 0.0000000))
	{
		ShotDir = Normal(TearOffMomentum);
		ApplyImpulse = ShotDir * DamageType.default.KDamageImpulse;
		// End:0x3F4
		if(Velocity.Z > float(-10))
		{
			ApplyImpulse += (vect(0.0000000, 0.0000000, 1.0000000) * DamageType.default.KDeathUpKick);
		}
		Mesh.AddImpulse(ApplyImpulse, TakeHitLocation, HitInfo.BoneName, true);
	}
	GotoState('Dying');
	//return;	
}

simulated function SetPawnRBChannels(bool bRagdollMode)
{
	Mesh.SetRBChannel(2);
	Mesh.SetRBCollidesWithChannel(0, true);
	Mesh.SetRBCollidesWithChannel(2, true);
	Mesh.SetRBCollidesWithChannel(3, true);
	Mesh.SetRBCollidesWithChannel(15, true);
	//return;	
}

simulated event Destroyed()
{
	super.Destroyed();
	// End:0x59
	if(CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.DetachFrom(Mesh);
		CurrentWeaponAttachment.Destroy();
	}
	//return;	
}

function bool NeedToTurn(Vector Target)
{
	local Rotator AimRotation, NeededRotation;

	AimRotation = Rotator(Target - (GetWeaponStartTraceLocation()));
	NeededRotation = AimRotation - Rotation;
	return !CanAim(NeededRotation);
	//return ReturnValue;	
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	local Vector WeaponStartTrace;

	WeaponStartTrace = Location;
	WeaponStartTrace.Z += WeaponHeight;
	return WeaponStartTrace;
	//return ReturnValue;	
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
	// End:0xD7
	if(CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.CauseMuzzleFlash();
		// End:0xD7
		if((HitLocation != vect(0.0000000, 0.0000000, 0.0000000)) && ((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || bViaReplication)
		{
			CurrentWeaponAttachment.PlayImpactEffects(HitLocation);
		}
	}
	//return;	
}

simulated function bool IsPlayingCustomAnimation()
{
	return false;
	//return ReturnValue;	
}

simulated function PlayFiringAnimation(optional bool charge = false, optional bool lastShot = false)
{
	//return;	
}

// Export UUSSPawn::execGetDefaultBehaviorTree(FFrame&, void* const)
native function CCSBTTree GetDefaultBehaviorTree();

// Export UUSSPawn::execSetDefaultBehaviorTree(FFrame&, void* const)
native function SetDefaultBehaviorTree(CCSBTTree newDefaultBehaviorTree);

// Export UUSSPawn::execGetYellingDistance(FFrame&, void* const)
native function float GetYellingDistance();

state Dying
{
	event BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		LifeSpan = 2.0000000;
		//return;		
	}

	simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local Vector ShotDir, ApplyImpulse;

		ShotDir = Normal(Momentum);
		ApplyImpulse = DamageType.default.KDamageImpulse * ShotDir;
		// End:0xBB
		if((DamageType != none) && Velocity.Z > float(-10))
		{
			ApplyImpulse += (vect(0.0000000, 0.0000000, 1.0000000) * DamageType.default.KDeathUpKick);
		}
		Mesh.WakeRigidBody();
		Mesh.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName, true);
		//return;		
	}
	stop;	
}

defaultproperties
{
	CoverPct=0.4857000
	AimPitchRange=(X=1.0000000,Y=-1.0000000)
	AimYawRange=(X=1.0000000,Y=-1.0000000)
	MaxPitchSpeed=16384.0000000
	MaxYawSpeed=16384.0000000
	WeaponHeight=25.0000000
	MaxStepHeight=26.0000000
	MaxJumpHeight=49.0000000
	WalkableFloorZ=0.7800000
	bCanCrouch=true
	bCanClimbLadders=true
	bCanPickupInventory=true
	CrouchHeight=46.0000000
	CrouchRadius=21.0000000
	AwareRadius=12000.0000000
	SightRadius=12000.0000000
	GroundSpeed=220.0000000
	WaterSpeed=220.0000000
	AirSpeed=440.0000000
	JumpZ=322.0000000
	AirControl=0.3500000
	WalkingPct=0.5500000
	CrouchedPct=0.5500000
	BaseEyeHeight=33.0000000
	EyeHeight=33.0000000
	// Reference: SkeletalMeshComponent'UDKBase.Default__USSPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent" class=Engine.SkeletalMeshComponent
		MinDistFactorForKinematicUpdate=0.2000000
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bHasPhysicsAssetInstance=true
		bOverrideAttachmentOwnerVisibility=true
		bChartDistanceFactor=true
		bCacheAnimSequenceNodes=false
		RootMotionMode=RMM_Translate
		RootMotionRotationMode=RMRM_RotateActor
		ReplacementPrimitive=none
		RBChannel=RBCC_Untitled3
		RBDominanceGroup=20
		bOwnerNoSee=true
		BlockRigidBody=true
		RBCollideWithChannels=(Untitled3=true)
		Translation=(X=8.0000000,Y=0.0000000,Z=0.0000000)
		Scale=1.0750000
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'UDKBase.Default__USSPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Pawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=44.0000000
		CollisionRadius=21.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AlwaysRelevantDistanceSquared=1960000.0000000
	ViewPitchMin=-6000.0000000
	ViewPitchMax=8192.0000000
	InventoryManagerClass=Class'UDKBase.USSInventoryManager'
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=WPawnSkeletalMeshComponent
	CollisionComponent=CollisionCylinder
	RotationRate=(Pitch=20000,Yaw=40000,Roll=20000)
}