class HaloPawn extends UTPawn
	config(Game);

enum ECharacterRole
{
	CR_NONE,                        // 0
	CR_SOLDIER,                     // 1
	CR_SCOUT,                       // 2
	CR_HEAVY,                       // 3
	CR_MAX                          // 4
};

enum HaloJumpType
{
	HaloJumpType_None,              // 0
	HaloJumpType_Single,            // 1
	HaloJumpType_Double,            // 2
	HaloJumpType_Ledge,             // 3
	HaloJumpType_JumpPad,           // 4
	HaloJumpType_MAX                // 5
};

struct CustomAnimationStruct
{
	var name AnimName;
	var float ForceDuration;
	var float BlendInTime;
	var float BlendOutTime;
	var bool IsFullBody;
	var bool IsLooping;
	var byte ByteMe;

	structdefaultproperties
	{
		AnimName="None"
		ForceDuration=0.0000000
		BlendInTime=0.2000000
		BlendOutTime=0.2000000
		IsFullBody=true
		IsLooping=false
		ByteMe=0
	}
};

struct KnockdownBehavior
{
	var const Class<DamageType> DamageType;
	var const name AnimName;
	var const float MinRecoverTime;
	var const float MaxRecoverTime;
	var const bool bIsDirectional;
	var const float AnimHitDirection;
	var const bool bSnapDirection;
	var Rotator rDirection;

	structdefaultproperties
	{
		DamageType=none
		AnimName="None"
		MinRecoverTime=2.0000000
		MaxRecoverTime=4.0000000
		bIsDirectional=false
		AnimHitDirection=0.0000000
		bSnapDirection=false
		rDirection=(Pitch=0,Yaw=0,Roll=0)
	}
};

struct HaloMeleeSwipeKeyFrame
{
	var Vector RelativeLoc;
	var float Time;

	structdefaultproperties
	{
		RelativeLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Time=0.0000000
	}
};

struct HaloMeleeAttackDesc
{
	var int Damage;
	var Class<DamageType> DamageType;
	var array<HaloMeleeSwipeKeyFrame> SwipeKeyFrames;
	var Vector SwipeExtent;
	var float TargetRange;
	var float TargetAngle;
	var float DamageAngle;
	var float DamageRange;
	var name AnimName;
	var float BlendInTime;
	var float BlendOutTime;
	var bool bIsFullBodyAnim;
	var bool bLockMovementInput;
	var bool bUseRootMotion;
	var ParticleSystem HitFxTemplate;
	var ParticleSystem RibbonTemplate;

	structdefaultproperties
	{
		Damage=0
		DamageType=none
		SwipeKeyFrames=none
		SwipeExtent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		TargetRange=0.0000000
		TargetAngle=0.0000000
		DamageAngle=0.0000000
		DamageRange=0.0000000
		AnimName="None"
		BlendInTime=0.0000000
		BlendOutTime=0.0000000
		bIsFullBodyAnim=false
		bLockMovementInput=false
		bUseRootMotion=false
		HitFxTemplate=none
		RibbonTemplate=none
	}
};

struct HaloLeapAttackDesc
{
	var int Damage;
	var Class<DamageType> DamageType;
	var float TargetRange;
	var float TargetAngle;
	var float LoopDuration;
	var name AnimNameIn;
	var name AnimNameLoop;
	var name AnimNameOut;

	structdefaultproperties
	{
		Damage=0
		DamageType=none
		TargetRange=0.0000000
		TargetAngle=0.0000000
		LoopDuration=0.0000000
		AnimNameIn="None"
		AnimNameLoop="None"
		AnimNameOut="None"
	}
};

struct TakedownDesc
{
	var Class<HaloPawn> TargetClass;
	var float MaxRange;
	var float MaxAngleOffset;
	var float MaxBackAngleOffset;
	var float TargetDistance;
	var float MyRightOffset;
	var name MyAnimName;
	var name TargetAnimName;
	var float BlendInTime;
	var float BlendOutTime;
	var float LerpTime;
	var bool bTargetUsesRootMotionOnZAxis;

	structdefaultproperties
	{
		TargetClass=none
		MaxRange=250.0000000
		MaxAngleOffset=60.0000000
		MaxBackAngleOffset=60.0000000
		TargetDistance=125.0000000
		MyRightOffset=0.0000000
		MyAnimName="None"
		TargetAnimName="None"
		BlendInTime=0.1000000
		BlendOutTime=0.1000000
		LerpTime=0.1500000
		bTargetUsesRootMotionOnZAxis=false
	}
};

var array< Class<DamageType> > KnockdownIgnoredDamageTypes;
var array<KnockdownBehavior> KnockdownBehaviors;
var HaloAnimBlendByKnockdownRecovery KnockdownRecoveryBlend;
var float KnockedDownRecoverTime;
var export editinline HaloCollectibleBlokSpawnerComponent CollectibleBlokSpawner;
var export editinline HaloSuitShieldComponent SuitShield;
var export editinline HaloFootPlacementComponent FootPlacement;
var export editinline UDKTargetableComponent MyTargetableComponent;
var export editinline HaloTargetableComponent_Pawn MyHaloTargetableComponent;
var byte TeamNum;
var HaloPawn.ECharacterRole CharacterRole;
var GFxHaloMinimapHUD.PlayerPawnType PawnType;
var repnotify byte AimOffsetReplicate[2];
var byte VehicleSeatIndex;
var HaloPawn.HaloJumpType JumpType;
var Class<Weapon> DefaultWeaponClass;
var float PassiveObjectivePrejudice;
var float PassiveSecondaryPrejudice;
var float AggressiveStationaryPrejudice;
var float AggressiveMobilePrejudice;
var bool bIsFiring;
var bool bIsCameraAimEnabled;
var bool bIsGunRaised;
var bool bIsOKToDeployTDItem;
var bool bIsIntendedForPlayerControl;
var bool WaitingForDoJumpNow;
var bool bExitAnimationExists;
var bool bDrawMeleeSwipeBoxes;
var bool bTakedownSyncsRootMotionCollision;
var bool bReadyToFade;
var bool bIsFading;
var bool bShouldFlashUponPlayerDamage;
var bool bHasHadFlashMatsReplaced;
var AnimNodeAimOffset AimOffsetNode;
var UDKAnimNodeCopyBoneTranslation AnimNodeProfileUpdater;
var HaloTurretAnimNode TurretAnimNode;
var AnimNodeBlend AnimNodeBlendWarthogSteering;
var AnimNodeBlend AnimNodeBlendMongooseSteering;
var repnotify CustomAnimationStruct CustomAnimationReplicate;
var HaloPlayerPawnController IntendedDeploymentController;
var string DeployTDPreviewMeshPath;
var float SprintTime;
var float SprintGroundSpeed;
var int TouchedPickupCount;
var Class<Inventory> ScriptedPickupClassMsg;
var name AkCharacterType;
var AkEvent WalkingSoundEvent;
var AkEvent RunningSoundEvent;
var AkEvent JumpingSoundEvent;
var AkEvent DoubleJumpSoundEvent;
var AkEvent JumpFromLedgeSoundEvent;
var AkEvent LandingSoundEvent;
var AkEvent FallingSoundEvent;
var AkEvent MeleeImpactSoundEvent;
var AkEvent KilledSoundEvent;
var AkEvent TakeDownSoundEvent;
var AkEvent TeleportSoundEvent;
var AkEvent SpawnSoundEvent;
var name PreviousMaterial;
var ParticleSystem TeleportOutEffect;
var float ZoneCaptureRate;
var Vector LerpLocStart;
var Vector LerpLocEnd;
var float LerpLocAlpha;
var float LerpLocRate;
var Quat LerpRotStart;
var Quat LerpRotEnd;
var float LerpRotAlpha;
var float LerpRotRate;
var export editinline HaloJumpComponent JumpComponent;
var float DoubleJumpCooldown;
var ParticleSystem LandFxTemplate;
var float LandFxFallSpeedThreshold;
var float GrenadeThrowTargetDistance;
var int GrenadeThrowPitchOffset;
var Vector AttachToVehicleStartLoc;
var Quat AttachToVehicleStartRot;
var name AttachToVehicleSeatBone;
var Vector AttachToVehicleSeatOffset;
var Vector ExitingVehiclePrevLoc;
var Rotator ExitingVehicleStartRot;
var float ExitingVehicleRotDuration;
var float ExitTurretInterpDuration;
var Rotator ExitTurretRotStart;
var Rotator ExitTurretRotEnd;
var Vector ExitTurretPivot;
var Vector ExitTurretOffset;
var float DeathBroadcastDistance;
var float DamagedBroadcastDistance;
var Class<Actor> EventBroadcastClass;
var const PhysicsAsset GibPhysics;
var const SkeletalMesh GibMesh;
var const float GibMomentumScalar;
var const int GibHealthThreshold;
var AnimNodeAdditiveBlending AdditiveFlinchBlendNode;
var AnimNodeSequence AdditiveFlinchSequenceNode;
var Actor MeleeTarget;
var HaloMeleeAttackDesc CurMeleeDesc;
var HaloLeapAttackDesc CurLeapDesc;
var float MeleeMomentum;
var AnimNodeBlendList MeleeChargeUpNode;
var int NextMeleeSwipeKeyIndex;
var Vector PrevMeleeSwipeLocation;
var array<Actor> MeleeSwipeTouchList;
var export editinline ParticleSystemComponent MeleeRibbon;
var float RamSpeed;
var float RamDistance;
var float RamTargetRange;
var float RamTargetAngle;
var float RamToFallSpeedScale;
var float RamMissDuration;
var name RamStartAnimName;
var name RamLoopAnimName;
var name RamWhileAirborneLoopAnimName;
var name RamHitActorAnimName;
var name RamHitWallAnimName;
var int RamDamage;
var float RamDamageMomentum;
var float RamHitWallBounce;
var float RamHitWallImpulseZ;
var AkEvent RamSoundEvent;
var AkEvent RamHitSoundEvent;
var ParticleSystem RamFxTemplate;
var export editinline ParticleSystemComponent RamFx;
var array<TakedownDesc> TakedownDescs;
var TakedownDesc CurTakedownDesc;
var float TakedownMaxRange;
var HaloPawn TakedownPartner;
var export editinline HaloNeedleTargetComponent NeedleTargetComponent;
var float LedgeGrabOffsetZ;
var float LedgeGrabRadius2D;
var float LedgeGrabToleranceZ;
var float LedgeGrabToleranceZFromJump;
var HaloGrabbableLedge LedgeGrabLedge;
var export editinline HaloArmorAbilityComponent ArmorAbility;
var Class<HaloArmorAbilityComponent> ArmorAbilityClass;
var array<name> TargetNodes;
var ParticleSystem DefaultHitFxTemplate;
var Actor BubbleShieldLOSHackActor;
var MaterialInstanceTimeVarying FadeOutMaterial;
var float TimeBeforeFadeOut;
var float FadeOutDuration;
var name FlashDamageParamName;
var float FlashDamagePct;
var float FlashDamageUpdateInterval;

replication
{
	// Pos:0x000
	if(bNetDirty && bNetOwner!)
		CustomAnimationReplicate, DeployTDPreviewMeshPath, 
		bIsGunRaised;

	// Pos:0x01B
	if((bIsGunRaised && bNetDirty) && bNetOwner!)
		AimOffsetReplicate;

	// Pos:0x045
	if(bNetDirty)
		VehicleSeatIndex, bIsOKToDeployTDItem;
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0xD0
	if(VarName == 'CustomAnimationReplicate')
	{
		BeginCustomAnimation(CustomAnimationReplicate.AnimName, CustomAnimationReplicate.IsFullBody, CustomAnimationReplicate.IsLooping, CustomAnimationReplicate.ForceDuration,, CustomAnimationReplicate.BlendInTime, CustomAnimationReplicate.BlendOutTime);		
	}
	else
	{
		// End:0x10A
		if(VarName == 'AimOffsetReplicate')
		{
			ClientSetAimOffset(AimOffsetReplicate[0], AimOffsetReplicate[1]);			
		}
		else
		{
			super.ReplicatedEvent(VarName);
		}
	}
	//return;	
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	GunRecoilNode = RightRecoilNode;
	AnimNodeProfileUpdater = UDKAnimNodeCopyBoneTranslation(SkelComp.FindAnimNode('AnimNodeProfileUpdater'));
	AimOffsetNode = AnimNodeAimOffset(SkelComp.FindAnimNode('AimOffset'));
	// End:0x10A
	if(AimOffsetNode != none)
	{
		// End:0xE2
		if(AnimNodeProfileUpdater != none)
		{
			AnimNodeProfileUpdater.CachedAimNode = AimOffsetNode;
		}
		AimOffsetNode.SetActiveProfileByName('Default');
	}
	KnockdownRecoveryBlend = HaloAnimBlendByKnockdownRecovery(SkelComp.FindAnimNode('KnockdownRecovery'));
	AnimNodeBlendWarthogSteering = AnimNodeBlend(SkelComp.FindAnimNode('AnimNodeBlendWarthogSteering'));
	AnimNodeBlendMongooseSteering = AnimNodeBlend(SkelComp.FindAnimNode('AnimNodeBlendMongooseSteering'));
	TurretAnimNode = HaloTurretAnimNode(SkelComp.FindAnimNode('TurretAnimNode'));
	AdditiveFlinchBlendNode = AnimNodeAdditiveBlending(SkelComp.FindAnimNode('AdditiveFlinchBlend'));
	AdditiveFlinchSequenceNode = AnimNodeSequence(SkelComp.FindAnimNode('AdditiveFlinchSequence'));
	MeleeChargeUpNode = AnimNodeBlendList(SkelComp.FindAnimNode('MeleeChargeUp'));
	//return;	
}

simulated event Destroyed()
{
	// End:0x2E
	if(SuitShield != none)
	{
		SuitShield.OnOwnerDestroyed();
	}
	// End:0x5C
	if(NeedleTargetComponent != none)
	{
		NeedleTargetComponent.OnOwnerDestroyed();
	}
	super.Destroyed();
	//return;	
}

simulated function SetWeapAnimType(UTPawn.EWeapAnimType AnimType)
{
	// End:0x115
	if(AimOffsetNode != none)
	{
		switch(AnimType)
		{
			// End:0x52
			case 0:
				AimOffsetNode.SetActiveProfileByName('Default');
				// End:0x115
				break;
			// End:0x82
			case 1:
				AimOffsetNode.SetActiveProfileByName('SinglePistol');
				// End:0x115
				break;
			// End:0xB2
			case 2:
				AimOffsetNode.SetActiveProfileByName('DualPistols');
				// End:0x115
				break;
			// End:0xE2
			case 3:
				AimOffsetNode.SetActiveProfileByName('ShoulderRocket');
				// End:0x115
				break;
			// End:0x112
			case 4:
				AimOffsetNode.SetActiveProfileByName('Stinger');
				// End:0x115
				break;
			// End:0xFFFF
			default:
				break;
		}
	}
	else
	{
		//return;		
	}
}

simulated function bool IsBusy()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsMeleeing()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsRamming()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsLeaping()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsThrowingGrenade()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsSwappingWeapon()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsReloadingWeapon()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsKnockedDown()
{
	return false;
	//return ReturnValue;	
}

simulated function bool IsGrabbingLedge()
{
	return false;
	//return ReturnValue;	
}

simulated function SetIsGunRaised(bool Enabled)
{
	// End:0x28
	if(int(Role) < int(ROLE_Authority))
	{
		ServerSetIsGunRaised(Enabled);
	}
	bIsGunRaised = Enabled;
	//return;	
}

reliable server function ServerSetIsGunRaised(bool Enabled)
{
	SetIsGunRaised(Enabled);
	//return;	
}

simulated function float PlayCustomAnimation(name AnimName, optional bool IsFullBody = true, optional bool IsLooping = false, optional float ForceDuration = 0.0000000, optional float failedDuration = 1.5000000, optional float BlendInTime = 0.0000000, optional float BlendOutTime = 0.0000000, optional float Rate = 1.0000000)
{
	local CustomAnimationStruct Anim;

	// End:0x189
	if(int(Role) == int(ROLE_Authority))
	{
		Anim.AnimName = AnimName;
		Anim.ForceDuration = ForceDuration;
		Anim.BlendInTime = BlendInTime;
		Anim.BlendOutTime = BlendOutTime;
		Anim.IsFullBody = IsFullBody;
		Anim.IsLooping = IsLooping;
		Anim.ByteMe = byte(int(CustomAnimationReplicate.ByteMe) + int(1));
		CustomAnimationReplicate = Anim;
	}
	return BeginCustomAnimation(AnimName, IsFullBody, IsLooping, ForceDuration, failedDuration, BlendInTime, BlendOutTime, Rate);
	//return ReturnValue;	
}

simulated function StopCustomAnimation(optional bool IsFullBody = true, optional float BlendOutTime = 0.0000000)
{
	local CustomAnimationStruct Anim;

	// End:0xEC
	if(int(Role) == int(ROLE_Authority))
	{
		Anim.AnimName = 'None';
		Anim.BlendOutTime = BlendOutTime;
		Anim.IsFullBody = IsFullBody;
		Anim.ByteMe = byte(int(CustomAnimationReplicate.ByteMe) + int(1));
		CustomAnimationReplicate = Anim;
	}
	BeginCustomAnimation('None', IsFullBody,,,,, BlendOutTime);
	//return;	
}

simulated function float BeginCustomAnimation(name AnimName, optional bool IsFullBody = true, optional bool IsLooping = false, optional float ForceDuration = 0.0000000, optional float failedDuration = 1.5000000, optional float BlendInTime = 0.0000000, optional float BlendOutTime = 0.0000000, optional float Rate = 1.0000000)
{
	local AnimNodeSlot animSlot;
	local float AnimTime;

	// End:0x5A
	if(IsFullBody)
	{
		animSlot = FullBodyAnimSlot;		
	}
	else
	{
		animSlot = TopHalfAnimSlot;
	}
	// End:0x1D6
	if(animSlot != none)
	{
		// End:0xBE
		if(AnimName == 'None')
		{
			animSlot.StopCustomAnim(BlendOutTime);			
		}
		else
		{
			// End:0x135
			if(ForceDuration > 0.0000000)
			{
				animSlot.PlayCustomAnimByDuration(AnimName, ForceDuration, BlendInTime, BlendOutTime, IsLooping, true);
				AnimTime = ForceDuration;				
			}
			else
			{
				AnimTime = animSlot.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, IsLooping, true);
			}
		}
		animSlot.SetRootBoneAxisOption();
		animSlot.SetRootBoneRotationOption();		
	}
	else
	{
		return ((ForceDuration > 0.0000000) ? ForceDuration : failedDuration);
	}
	return AnimTime;
	//return ReturnValue;	
}

simulated function bool IsPlayingCustomAnimation()
{
	return FullBodyAnimSlot.bIsPlayingCustomAnim || TopHalfAnimSlot.bIsPlayingCustomAnim;
	//return ReturnValue;	
}

function PullTrigger()
{
	//return;	
}

function ReleaseTrigger()
{
	//return;	
}

simulated function SetAimOffset(Vector2D Offset)
{
	local byte X, Y;

	// End:0x139
	if(AimOffsetNode != none)
	{
		X = byte((Offset.X + 1.0000000) * 127.0000000);
		Y = byte((Offset.Y + 1.0000000) * 127.0000000);
		// End:0x111
		if((int(X) != int(AimOffsetReplicate[0])) || int(Y) != int(AimOffsetReplicate[1]))
		{
			// End:0xE7
			if(int(Role) < int(ROLE_Authority))
			{
				ServerSetAimOffset(X, Y);
			}
			AimOffsetReplicate[0] = X;
			AimOffsetReplicate[1] = Y;
		}
		AimOffsetNode.Aim = Offset;
	}
	//return;	
}

unreliable server function ServerSetAimOffset(byte X, byte Y)
{
	local Vector2D Offset;

	Offset.X = (float(X) - 127.0000000) / 127.0000000;
	Offset.Y = (float(Y) - 127.0000000) / 127.0000000;
	SetAimOffset(Offset);
	//return;	
}

simulated function ClientSetAimOffset(byte X, byte Y)
{
	local Vector2D Offset;

	// End:0xA3
	if(AimOffsetNode != none)
	{
		Offset.X = (float(X) - 127.0000000) / 127.0000000;
		Offset.Y = (float(Y) - 127.0000000) / 127.0000000;
		AimOffsetNode.Aim = Offset;
	}
	//return;	
}

simulated function UpdateAimOffset(float DeltaTime)
{
	local Vector2D Offset;
	local Rotator AimRot;
	local HaloPlayerPawnController PC;

	// End:0x185
	if((Controller != none) && AimOffsetNode != none)
	{
		PC = HaloPlayerPawnController(Controller);
		// End:0x76
		if(PC != none)
		{
			AimRot = PC.WeaponAimRotation;			
		}
		else
		{
			AimRot = Controller.Rotation;
		}
		Offset.X = float(NormalizeRotAxis(AimRot.Yaw - Rotation.Yaw)) / 16384.0000000;
		Offset.Y = float(NormalizeRotAxis(AimRot.Pitch - Rotation.Pitch)) / 16384.0000000;
		SetAimOffset(Offset);
	}
	//return;	
}

simulated function UpdateSteering(float DeltaTime)
{
	// End:0x97
	if((AnimNodeBlendWarthogSteering != none) && SVehicle(DrivenVehicle) != none)
	{
		AnimNodeBlendWarthogSteering.SetBlendTarget(1.0000000 - (float(SVehicle(DrivenVehicle).VState.ServerSteering) / 255.0000000), 0.1000000);
	}
	// End:0x12E
	if((AnimNodeBlendMongooseSteering != none) && SVehicle(DrivenVehicle) != none)
	{
		AnimNodeBlendMongooseSteering.SetBlendTarget(1.0000000 - (float(SVehicle(DrivenVehicle).VState.ServerSteering) / 255.0000000), 0.1000000);
	}
	//return;	
}

function PlayWalkStepNow()
{
	PlayWalkingSound();
	//return;	
}

function PlayRunStepNow()
{
	PlayRunningSound();
	//return;	
}

simulated function UpdateFeetMaterial()
{
	local name MaterialName, MaterialValue;

	MaterialName = GetMaterialBelowFeet();
	switch(MaterialName)
	{
		// End:0x33
		case 'Grass':
		// End:0x3F
		case 'Grass_Material':
		// End:0x61
		case 'PM_Grass':
			MaterialValue = 'Grass';
			// End:0x16E
			break;
		// End:0x6D
		case 'Dirt':
		// End:0x79
		case 'Dirt_Material':
		// End:0x9B
		case 'PM_Dirt':
			MaterialValue = 'Dirt';
			// End:0x16E
			break;
		// End:0xA7
		case 'Water':
		// End:0xB3
		case 'Water_Material':
		// End:0xD5
		case 'PM_Water':
			MaterialValue = 'Water';
			// End:0x16E
			break;
		// End:0xE1
		case 'Snow':
		// End:0xED
		case 'Snow_Material':
		// End:0x10F
		case 'PM_Snow':
			MaterialValue = 'Snow';
			// End:0x16E
			break;
		// End:0x11B
		case 'Concrete':
		// End:0x127
		case 'Concrete_Material':
		// End:0x133
		case 'PM_Concrete':
		// End:0x155
		case 'None':
			MaterialValue = 'Concrete';
			// End:0x16E
			break;
		// End:0xFFFF
		default:
			MaterialValue = PreviousMaterial;
			// End:0x16E
			break;
			break;
	}
	// End:0x1B4
	if(PreviousMaterial != MaterialValue)
	{
		PreviousMaterial = MaterialValue;
		SetSwitch('Surface', MaterialValue);
	}
	//return;	
}

simulated event Tick(float DeltaTime)
{
	// End:0x22
	if(DrivenVehicle != none)
	{
		UpdateSteering(DeltaTime);
	}
	UpdateAimOffset(DeltaTime);
	// End:0x6C
	if(JumpComponent != none)
	{
		JumpComponent.Tick(DeltaTime);
	}
	// End:0xB9
	if((WaitingForDoJumpNow! && int(Physics) != int(2)) && IsGrabbingLedge()!)
	{
		SetJumpType(0, false);
		AllowDoubleJump();
	}
	// End:0x14E
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x104
		if(SuitShield != none)
		{
			SuitShield.Tick(DeltaTime);
		}
		// End:0x13B
		if(NeedleTargetComponent != none)
		{
			NeedleTargetComponent.Tick(DeltaTime);
		}
		super(Actor).Tick(DeltaTime);
	}
	// End:0x17C
	if(NeedleTargetComponent != none)
	{
		NeedleTargetComponent.UpdateStickyAttachments();
	}
	//return;	
}

function bool ShouldFollowTargetZ()
{
	return (((int(JumpType) == int(0)) || int(JumpType) == int(4)) || (IsGrabbingLedge()) == true) || HaloGravityLift(PhysicsVolume) != none;
	//return ReturnValue;	
}

simulated event EndViewTarget(PlayerController PC)
{
	// End:0x6E
	if(LocalPlayer(PC.Player) != none)
	{
		SetMeshVisibility(true);
		bArmsAttached = false;
		DetachComponent(ArmsMesh[0]);
		DetachComponent(ArmsMesh[1]);
	}
	//return;	
}

simulated function TakeFallingDamage()
{
	//return;	
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
	return false;
	//return ReturnValue;	
}

function NotifySucccessfulAttack(Controller InstigatedBy)
{
	local CCSController aiAttackerController;

	aiAttackerController = CCSController(InstigatedBy);
	// End:0x4A
	if(aiAttackerController != none)
	{
		aiAttackerController.NotifySuccessfulAttack();
	}
	//return;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local CCSController aiAttackerController;
	local editinline UDKTargetableComponent targetableComponent;
	local HaloPawn damagerPawn;
	local HaloPhysicalMaterialProperty haloPhysMat;
	local Weapon weaponBeforeDmg;
	local HaloPlayerPawnController HPPCController;
	local int PrevHealth, prevShield, totalDamageDelt;
	local Class<HaloDamageType> HaloDamageType;

	// End:0x38
	if(((int(Role) < int(ROLE_Authority)) || Health <= 0) || bIsInvulnerable)
	{
		return;
	}
	HPPCController = HaloPlayerPawnController(self.Controller);
	aiAttackerController = CCSController(InstigatedBy);
	targetableComponent = UDKTargetableComponent(GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
	HaloDamageType = Class<HaloDamageType>(DamageType);
	// End:0x106
	if(HaloDamageType != none)
	{
		// End:0x106
		if(HPPCController != none)
		{
			Damage *= HaloDamageType.default.ToPlayerScaler;
		}
	}
	// End:0x2DF
	if(aiAttackerController != none)
	{
		// End:0x2DC
		if(aiAttackerController.Pawn != none)
		{
			damagerPawn = HaloPawn(aiAttackerController.Pawn);
			// End:0x2DC
			if(damagerPawn != none)
			{
				// End:0x2DC
				if(targetableComponent != none)
				{
					// End:0x1DD
					if(int(targetableComponent.AITargetType) == int(1))
					{
						Damage *= damagerPawn.PassiveObjectivePrejudice;						
					}
					else
					{
						// End:0x232
						if(int(targetableComponent.AITargetType) == int(2))
						{
							Damage *= damagerPawn.PassiveSecondaryPrejudice;							
						}
						else
						{
							// End:0x287
							if(int(targetableComponent.AITargetType) == int(3))
							{
								Damage *= damagerPawn.AggressiveStationaryPrejudice;								
							}
							else
							{
								// End:0x2D9
								if(int(targetableComponent.AITargetType) == int(4))
								{
									Damage *= damagerPawn.AggressiveMobilePrejudice;
								}
							}
						}
					}					
				}
			}
		}		
	}
	else
	{
		// End:0x4FE
		if(((DamageCauser != none) && Projectile(DamageCauser) != none) && Projectile(DamageCauser).InstigatorController != none)
		{
			damagerPawn = HaloPawn(Projectile(DamageCauser).InstigatorController.Pawn);
			// End:0x4FB
			if(damagerPawn != none)
			{
				// End:0x4F8
				if(targetableComponent != none)
				{
					// End:0x3F9
					if(int(targetableComponent.AITargetType) == int(1))
					{
						Damage *= damagerPawn.PassiveObjectivePrejudice;						
					}
					else
					{
						// End:0x44E
						if(int(targetableComponent.AITargetType) == int(2))
						{
							Damage *= damagerPawn.PassiveSecondaryPrejudice;							
						}
						else
						{
							// End:0x4A3
							if(int(targetableComponent.AITargetType) == int(3))
							{
								Damage *= damagerPawn.AggressiveStationaryPrejudice;								
							}
							else
							{
								// End:0x4F5
								if(int(targetableComponent.AITargetType) == int(4))
								{
									Damage *= damagerPawn.AggressiveMobilePrejudice;
								}
							}
						}
					}					
				}				
			}			
		}
	}
	// End:0x59C
	if(HitInfo.PhysMaterial != none)
	{
		haloPhysMat = HaloPhysicalMaterialProperty(HitInfo.PhysMaterial.PhysicalMaterialProperty);
		// End:0x59C
		if(haloPhysMat != none)
		{
			Damage *= haloPhysMat.DamageScale;
		}
	}
	// End:0x5F5
	if((ClassIsChildOf(DamageType, Class'Engine.DmgType_Fell') && HPPCController != none) && HPPCController.bTeleportToBreadcrumbOnFall)
	{
		WarpToLastBreadcrumbLocation();
		return;
	}
	// End:0x629
	if(Damage > 0)
	{
		SpawnDefaultHitFX(HitLocation, Momentum, Damage);
	}
	// End:0x667
	if((Controller != none) && Controller.bGodMode)
	{
		Damage = 0;
	}
	PrevHealth = Health;
	// End:0x71B
	if(SuitShield != none)
	{
		prevShield = int(SuitShield.Shield);
		Damage = SuitShield.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
	weaponBeforeDmg = Weapon;
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	BroadcastEvent(1, DamagedBroadcastDistance);
	// End:0x80A
	if((bShouldFlashUponPlayerDamage && PrevHealth > Health) && (InstigatedBy == none) || PlayerController(InstigatedBy) != none)
	{
		ClearTimer('RampFlashDamageDown');
		FlashDamagePct = -1.0000000;
		RampFlashDamageDown();
	}
	// End:0x8FC
	if(Health > 0)
	{
		totalDamageDelt = PrevHealth - Health;
		// End:0x87E
		if(SuitShield != none)
		{
			totalDamageDelt += int(float(prevShield) - SuitShield.Shield);
		}
		HandleHitReaction(totalDamageDelt, DamageType, HitLocation, Momentum);
		// End:0x8F9
		if(CollectibleBlokSpawner != none)
		{
			CollectibleBlokSpawner.TryToThrowBloks((100.0000000 * float(Health)) / float(HealthMax));
		}		
	}
	else
	{
		// End:0x92A
		if(weaponBeforeDmg != none)
		{
			weaponBeforeDmg.HandleFinishedFiring();
		}
		// End:0x958
		if(SuitShield != none)
		{
			SuitShield.OnDeath();
		}
		// End:0x986
		if(NeedleTargetComponent != none)
		{
			NeedleTargetComponent.OnDeath();
		}
		// End:0x9B6
		if(Mesh != none)
		{
			Mesh.SetRBChannel(7);
		}
		// End:0xA45
		if((DamageCauser != none) && NotEqual_InterfaceInterface(HaloUpgradableInterface(DamageCauser.Instigator), HaloUpgradableInterface(none)))
		{
			HaloUpgradableInterface(DamageCauser.Instigator).AddUpgradeXP(50);
		}
		// End:0xA73
		if(targetableComponent != none)
		{
			targetableComponent.BeginDeath();
		}
		BroadcastEvent(2, DeathBroadcastDistance);
	}
	// End:0xAC8
	if(HaloPlayerPawnController(Controller) != none)
	{
		HaloPlayerPawnController(Controller).TookDamage();
	}
	//return;	
}

event RampFlashDamageDown()
{
	local int I;
	local MaterialInstanceConstant alterableMaterial;

	// End:0x25
	if(FlashDamagePct == -1.0000000)
	{
		FlashDamagePct = 1.0000000;		
	}
	else
	{
		FlashDamagePct = FClamp(FlashDamagePct - 0.5000000, 0.0000000, 1.0000000);
	}
	// End:0x1A4
	if(Mesh != none)
	{
		// End:0xE3
		if(bHasHadFlashMatsReplaced!)
		{
			I = 0;
			J0x74:

			// End:0xD7 [Loop If]
			if(I < Mesh.GetNumElements())
			{
				Mesh.CreateAndSetMaterialInstanceConstant(I);
				I++;
				// [Loop Continue]
				goto J0x74;
			}
			bHasHadFlashMatsReplaced = true;
		}
		I = 0;
		J0xEE:

		// End:0x1A4 [Loop If]
		if(I < Mesh.GetNumElements())
		{
			alterableMaterial = MaterialInstanceConstant(Mesh.GetMaterial(I));
			// End:0x196
			if(alterableMaterial != none)
			{
				alterableMaterial.SetScalarParameterValue(FlashDamageParamName, FlashDamagePct);
			}
			I++;
			// [Loop Continue]
			goto J0xEE;
		}
	}
	// End:0x1CE
	if(FlashDamagePct > 0.0000000)
	{
		SetTimer(FlashDamageUpdateInterval, false, 'RampFlashDamageDown');
	}
	//return;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	// End:0x2A
	if(super.Died(Killer, DamageType, HitLocation))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool HandleHitReaction(int Damage, Class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
	local Class<HaloDamageType> HaloDamageType;

	// End:0xC6
	if(KnockdownBehaviors.Length > 0)
	{
		HaloDamageType = Class<HaloDamageType>(DamageType);
		// End:0xC6
		if((HaloDamageType != none) && DrivenVehicle == none)
		{
			// End:0xC6
			if(HaloDamageType.default.bKnockdown && Damage >= HaloDamageType.default.KnockdownDamageThreshold)
			{
				// End:0xC6
				if(KnockdownFromDamageType(HaloDamageType, HitLocation, Momentum))
				{
					return true;
				}
			}
		}
	}
	return false;
	//return ReturnValue;	
}

event Landed(Vector HitNormal, Actor FloorActor)
{
	// End:0x39
	if(Velocity.Z < MaxFallSpeed-)
	{
		PlayFallingSound();		
	}
	else
	{
		// End:0x74
		if(Velocity.Z < (MaxFallSpeed * -0.2500000))
		{
			PlayLandingSound();
		}
	}
	// End:0xB3
	if(Velocity.Z < LandFxFallSpeedThreshold-)
	{
		SpawnLandFx(FloorActor);
	}
	super.Landed(HitNormal, FloorActor);
	//return;	
}

function SpawnLandFx(Actor FloorActor)
{
	local Vector SpawnLoc, spawnUp, spawnFwd;
	local Rotator SpawnRot;
	local editinline ParticleSystemComponent FX;

	// End:0x1C1
	if(LandFxTemplate != none)
	{
		SpawnLoc = Location;
		SpawnLoc.Z -= (GetCollisionHeight());
		spawnUp = Normal(Velocity);
		// End:0xDE
		if(Abs(spawnUp.Z) > 0.1000000)
		{
			spawnFwd = Vector(Rotation);
			spawnFwd -= ((spawnUp Dot spawnFwd) * spawnUp);
			SpawnRot = Rotator(spawnFwd);			
		}
		else
		{
			SpawnRot = Rotation;
		}
		FX = WorldInfo.MyEmitterPool.SpawnEmitter(LandFxTemplate, SpawnLoc, SpawnRot);
		// End:0x1C1
		if(FX != none)
		{
			FX.SetVectorParameter('LandingVelocity', Velocity);
			FX.SetFloatParameter('LandingSpeed', VSize(Velocity));
		}
	}
	//return;	
}

function PlayWalkingSound()
{
	UpdateFeetMaterial();
	SetRTPCValue('Character_Speed', 0.0000000);
	// End:0x5B
	if((WalkingSoundEvent != none) && Health > 0)
	{
		PlayAkEvent(WalkingSoundEvent);
	}
	//return;	
}

function PlayRunningSound()
{
	UpdateFeetMaterial();
	SetRTPCValue('Character_Speed', 100.0000000);
	// End:0x5B
	if((RunningSoundEvent != none) && Health > 0)
	{
		PlayAkEvent(RunningSoundEvent);
	}
	//return;	
}

function PlayJumpingSound()
{
	local AkEvent sndEvent;

	UpdateFeetMaterial();
	switch(JumpType)
	{
		// End:0x38
		case 2:
			sndEvent = DoubleJumpSoundEvent;
			// End:0x56
			break;
		// End:0x53
		case 3:
			sndEvent = JumpFromLedgeSoundEvent;
			// End:0x56
			break;
		// End:0xFFFF
		default:
			break;
	}
	// End:0x78
	if(sndEvent == none)
	{
		sndEvent = JumpingSoundEvent;
	}
	// End:0xA0
	if(sndEvent != none)
	{
		PlayAkEvent(sndEvent);
	}
	//return;	
}

function PlayLandingSound()
{
	UpdateFeetMaterial();
	// End:0x32
	if(LandingSoundEvent != none)
	{
		PlayAkEvent(LandingSoundEvent);
	}
	//return;	
}

function PlayFallingSound()
{
	UpdateFeetMaterial();
	// End:0x32
	if(FallingSoundEvent != none)
	{
		PlayAkEvent(FallingSoundEvent);
	}
	//return;	
}

function PlayMeleeDamageSound(name akWeaponType)
{
	// End:0x60
	if(MeleeImpactSoundEvent != none)
	{
		SetSwitch('Surface', 'Concrete');
		SetSwitch('Weapon_Type', akWeaponType);
		PlayAkEvent(MeleeImpactSoundEvent);
	}
	//return;	
}

function PlayDyingSound()
{
	// End:0x28
	if(KilledSoundEvent != none)
	{
		PlayAkEvent(KilledSoundEvent);
	}
	//return;	
}

function PlayTeleportSound()
{
	// End:0x28
	if(TeleportSoundEvent != none)
	{
		PlayAkEvent(TeleportSoundEvent);
	}
	//return;	
}

function PlaySpawnSound()
{
	// End:0x28
	if(SpawnSoundEvent != none)
	{
		PlayAkEvent(SpawnSoundEvent);
	}
	//return;	
}

simulated function SetPawnAmbientSound(SoundCue NewAmbientSound)
{
	//return;	
}

simulated function SetWeaponAmbientSound(SoundCue NewAmbientSound)
{
	//return;	
}

function DeactivateSpawnProtection()
{
	// End:0x1B
	if(bSpawnDone!)
	{
		bSpawnDone = true;
	}
	//return;	
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	// End:0x76
	if(bOut && TeleportOutEffect != none)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(TeleportOutEffect, self.Location);
	}
	// End:0x8D
	if(bSound)
	{
		PlayTeleportSound();
	}
	//return;	
}

simulated function bool ShouldGib(Class<UTDamageType> UTDamageType)
{
	return false;
	//return ReturnValue;	
}

function TimerLowerGun()
{
	SetIsGunRaised(false);
	SetControllerCrosshair(false);
	//return;	
}

simulated function SetIsFiring(bool IsFiring)
{
	// End:0x38
	if(bIsFiring != IsFiring)
	{
		bIsFiring = IsFiring;
		UpdateIsGunRaised();
	}
	//return;	
}

simulated function SetIsCameraAimEnabled(bool Enabled)
{
	// End:0x38
	if(bIsCameraAimEnabled != Enabled)
	{
		bIsCameraAimEnabled = Enabled;
		UpdateIsGunRaised();
	}
	//return;	
}

simulated function UpdateIsGunRaised()
{
	// End:0x49
	if(bIsFiring || bIsCameraAimEnabled)
	{
		SetIsGunRaised(true);
		ClearTimer('TimerLowerGun');
		SetControllerCrosshair(true);		
	}
	else
	{
		SetTimer(0.5000000, false, 'TimerLowerGun');
	}
	//return;	
}

function SetControllerCrosshair(bool showCrosshair)
{
	local UTPlayerController PC;

	PC = UTPlayerController(Controller);
	// End:0x57
	if(PC != none)
	{
		PC.bNoCrosshair = showCrosshair!;
	}
	//return;	
}

function bool IsControlledByAPlayer()
{
	return PlayerController(Controller) != none;
	//return ReturnValue;	
}

simulated event NotifyIntendedController()
{
	// End:0x3A
	if(IntendedDeploymentController != none)
	{
		IntendedDeploymentController.NotifyOfPawnReadyForPossession(self);
		IntendedDeploymentController = none;
	}
	//return;	
}

simulated event BecomeViewTarget(PlayerController PC)
{
	local UTPlayerController UTPC;
	local UTWeapon UTWeap;

	// End:0x38
	if(PhysicsVolume != none)
	{
		PhysicsVolume.NotifyPawnBecameViewTarget(self, PC);
	}
	// End:0x92
	if(bReplicateHealthToAll! && int(WorldInfo.NetMode) != int(NM_Client))
	{
		PC.ForceSingleNetUpdateFor(self);
	}
	// End:0x1B0
	if(LocalPlayer(PC.Player) != none)
	{
		bArmsAttached = true;
		AttachComponent(ArmsMesh[0]);
		UTWeap = UTWeapon(Weapon);
		// End:0x142
		if(UTWeap != none)
		{
			// End:0x142
			if(UTWeap.bUsesOffhand)
			{
				AttachComponent(ArmsMesh[1]);
			}
		}
		UTPC = UTPlayerController(PC);
		// End:0x199
		if(UTPC != none)
		{
			SetMeshVisibility(UTPC.bBehindView);			
		}
		else
		{
			SetMeshVisibility(true);
		}
		bUpdateEyeheight = true;
	}
	SetIsFiring(false);
	SetIsCameraAimEnabled(false);
	SetIsGunRaised(false);
	SetControllerCrosshair(false);
	//return;	
}

simulated function Actor NetworkSpawn(Class<Actor> SpawnClass, Vector SpawnLocation, Rotator SpawnRotation)
{
	local Actor spawnedActor;

	// End:0xD0
	if(int(Role) == int(ROLE_Authority))
	{
		spawnedActor = Spawn(SpawnClass,,, SpawnLocation, SpawnRotation,, true);
		// End:0xCD
		if((UTVehicle(spawnedActor) != none) && UTVehicle(spawnedActor).Mesh != none)
		{
			UTVehicle(spawnedActor).Mesh.WakeRigidBody();
		}		
	}
	else
	{
		ServerNetworkSpawn(SpawnClass, SpawnLocation, SpawnRotation);
	}
	return spawnedActor;
	//return ReturnValue;	
}

reliable server function ServerNetworkSpawn(Class<Actor> SpawnClass, Vector SpawnLocation, Rotator SpawnRotation)
{
	NetworkSpawn(SpawnClass, SpawnLocation, SpawnRotation);
	//return;	
}

function bool MeleeAttack(HaloMeleeAttackDesc Desc, optional Actor Target)
{
	// End:0x7E
	if(int(Physics) == int(1))
	{
		CurMeleeDesc = Desc;
		return TryMeleeAttack('Meleeing', Desc.TargetRange, Desc.TargetAngle, false, Target);
	}
	return false;
	//return ReturnValue;	
}

function RamAttack(optional Actor Target)
{
	// End:0x6C
	if((RamDistance > 0.0000000) && RamSpeed > 0.0000000)
	{
		// End:0x6C
		if(int(Physics) == int(1))
		{
			TryMeleeAttack('Ramming_Start', RamTargetRange, RamTargetAngle, true, Target);
		}
	}
	//return;	
}

function LeapAttack(HaloLeapAttackDesc Desc, optional Actor Target)
{
	CurLeapDesc = Desc;
	TryMeleeAttack('LeapAttack_Start', Desc.TargetRange, Desc.TargetAngle, false, Target);
	//return;	
}

function AllowComboQueueing()
{
	local HaloWeapon_Melee W;

	W = HaloWeapon_Melee(Weapon);
	// End:0x4A
	if(W != none)
	{
		W.AllowComboQueueing();
	}
	//return;	
}

function StartComboWindow()
{
	local HaloWeapon_Melee W;

	W = HaloWeapon_Melee(Weapon);
	// End:0x4A
	if(W != none)
	{
		W.StartComboWindow();
	}
	//return;	
}

function EndComboWindow()
{
	local HaloWeapon_Melee W;

	W = HaloWeapon_Melee(Weapon);
	// End:0x4A
	if(W != none)
	{
		W.EndComboWindow();
	}
	//return;	
}

function bool TryMeleeAttack(name StateName, float findTargetRange, float findTargetAngle, bool tryTakedown, optional Actor Target)
{
	local HaloPlayerPawnController MyController;

	// End:0x12
	if(Health <= 0)
	{
		return false;
	}
	MyController = HaloPlayerPawnController(Controller);
	// End:0x85
	if(MyController != none)
	{
		// End:0x61
		if(MyController.bIsAimingTargetDesignator)
		{
			return false;
		}
		// End:0x85
		if(MyController.bCinematicMode)
		{
			return false;
		}
	}
	// End:0xAA
	if(Target != none)
	{
		MeleeTarget = Target;		
	}
	else
	{
		FindMeleeTarget(findTargetRange, findTargetAngle);
	}
	// End:0xE5
	if(tryTakedown && Takedown())
	{
		return true;
	}
	NetworkGotoState(StateName, true);
	return true;
	//return ReturnValue;	
}

function FindMeleeTarget(float Range, float Angle)
{
	local Pawn pawnWithinRadius;
	local Actor actorWithinRadius;
	local HaloDestructibleActor hdaWithinRadius;
	local bool validTarget;
	local Actor closestTarget;
	local float MaxDistance, Distance;
	local TraceHitInfo HitInfo;
	local float angOffset;

	MaxDistance = 10000.0000000;
	// End:0x284
	if(MeleeTarget == none)
	{
		// End:0x261
		foreach CollidingActors(Class'Engine.Actor', actorWithinRadius, Range + CylinderComponent.CollisionRadius, Location, true,, HitInfo)
		{
			validTarget = false;
			hdaWithinRadius = HaloDestructibleActor(actorWithinRadius);
			// End:0x101
			if(hdaWithinRadius != none)
			{
				// End:0xFE
				if((hdaWithinRadius.Health > 0) && hdaWithinRadius.bCanBeHitByMelee)
				{
					validTarget = true;
				}				
			}
			else
			{
				pawnWithinRadius = Pawn(actorWithinRadius);
				// End:0x16D
				if(pawnWithinRadius != none)
				{
					// End:0x16D
					if((pawnWithinRadius != self) && pawnWithinRadius.Health > 0)
					{
						validTarget = true;
					}
				}
			}
			// End:0x260
			if(validTarget)
			{
				angOffset = RDiff(Rotation, Rotator(actorWithinRadius.Location - Location));
				// End:0x260
				if(angOffset < Angle)
				{
					Distance = VSize(actorWithinRadius.Location - Location);
					// End:0x260
					if((Distance > 0.0000000) && Distance <= MaxDistance)
					{
						MaxDistance = Distance;
						closestTarget = actorWithinRadius;
					}
				}
			}			
		}		
		// End:0x284
		if(closestTarget != none)
		{
			MeleeTarget = closestTarget;
		}
	}
	//return;	
}

function MeleeContact()
{
	// End:0x51
	if(MeleeTarget == none)
	{
		FindMeleeTarget(CurMeleeDesc.DamageRange, CurMeleeDesc.DamageAngle);
	}
	HandleMeleeDamage(MeleeTarget);
	//return;	
}

function HandleMeleeDamage(optional Actor Target)
{
	local HaloDestructibleActor targetAsHDA;

	targetAsHDA = HaloDestructibleActor(Target);
	// End:0x42
	if(targetAsHDA != none)
	{
		HandleHDAMelee(targetAsHDA);		
	}
	else
	{
		HandlePawnMelee(Pawn(Target));
	}
	// End:0x80
	if(MeleeTarget == Target)
	{
		MeleeTarget = none;
	}
	//return;	
}

function HandlePawnMelee(Pawn myTarget)
{
	local HaloPawn myHaloTarget;
	local float halfSpaceDot;
	local Vector HitLoc, HitMomentum, ToTarget, targetForward;
	local bool instantKill;
	local int TotalDamage;

	// End:0x364
	if(myTarget != none)
	{
		HitMomentum = Vector(Rotation) * MeleeMomentum;
		targetForward = Vector(myTarget.Rotation);
		ToTarget = Location - myTarget.Location;
		halfSpaceDot = ToTarget Dot targetForward;
		HitLoc = myTarget.Location;
		HitLoc.Z += myTarget.EyeHeight;
		// End:0x190
		if(((HaloAIPawn(self) == none) && HaloVehicle(myTarget) == none) && halfSpaceDot < (myTarget.CylinderComponent.CollisionRadius * float(-1)))
		{
			instantKill = true;
		}
		myHaloTarget = HaloPawn(myTarget);
		// End:0x25A
		if(instantKill)
		{
			// End:0x22E
			if((myHaloTarget != none) && myHaloTarget.SuitShield != none)
			{
				TotalDamage += int(myHaloTarget.SuitShield.ShieldMax);
			}
			TotalDamage += myTarget.Health;			
		}
		else
		{
			TotalDamage = CurMeleeDesc.Damage;
		}
		// End:0x2F8
		if(myHaloTarget != none)
		{
			myHaloTarget.PlayMeleeDamageSound(((HaloWeapon(Weapon) != none) ? HaloWeapon(Weapon).akWeaponType : 'Unarmed'));
		}
		myTarget.TakeDamage(TotalDamage, Controller, HitLoc, HitMomentum, CurMeleeDesc.DamageType,, self);
		myTarget = none;
	}
	//return;	
}

function HandleHDAMelee(HaloDestructibleActor myTarget)
{
	local float halfSpaceDot;
	local Vector HitLoc, HitMomentum, ToTarget, targetFwd;
	local int TotalDamage;

	HitLoc = myTarget.Location;
	HitMomentum = Vector(Rotation) * MeleeMomentum;
	targetFwd = Vector(myTarget.Rotation);
	ToTarget = myTarget.Location - Location;
	halfSpaceDot = ToTarget Dot targetFwd;
	// End:0x101
	if(halfSpaceDot < 0.0000000)
	{
		TotalDamage = myTarget.Health;		
	}
	else
	{
		TotalDamage = CurMeleeDesc.Damage;
	}
	myTarget.TakeDamage(TotalDamage, Controller, HitLoc, HitMomentum, CurMeleeDesc.DamageType,, self);
	myTarget = none;
	//return;	
}

simulated function StartMeleeSwipe()
{
	//return;	
}

simulated function EndMeleeSwipe()
{
	//return;	
}

function PlayChargeUpAnim()
{
	// End:0x34
	if(MeleeChargeUpNode != none)
	{
		MeleeChargeUpNode.SetActiveChild(1, 0.1000000);
	}
	//return;	
}

function StopChargeUpAnim()
{
	// End:0x34
	if(MeleeChargeUpNode != none)
	{
		MeleeChargeUpNode.SetActiveChild(0, 0.0000000);
	}
	//return;	
}

exec function ToggleMeleeSwipeBoxes()
{
	bDrawMeleeSwipeBoxes = bDrawMeleeSwipeBoxes!;
	//return;	
}

exec function BakeMeleeSwipes()
{
	local HaloWeapon_Melee W;

	// End:0x1E
	if((IsBusy()) || IsGrabbingLedge())
	{
		return;
	}
	StopFire(0);
	StopFire(1);
	SetIsFiring(false);
	TimerLowerGun();
	W = HaloWeapon_Melee(Weapon);
	// End:0x9F
	if((W == none) && W.ComboAttackDescs.Length > 0)
	{
		return;
	}
	GotoState('BakeMeleeSwipeState');
	//return;	
}

function BakeMeleeSwipeKeyFrame(optional bool skipLineDraw)
{
	//return;	
}

function IgnoreMoveInput(bool ignore)
{
	local PlayerController C;

	C = PlayerController(Controller);
	// End:0x54
	if(C != none)
	{
		C.IgnoreMoveInput(ignore);
	}
	//return;	
}

function PlayRamFX()
{
	// End:0xED
	if((Mesh != none) && RamFxTemplate != none)
	{
		RamFx = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(RamFxTemplate, Mesh, 'Back_Hole_Socket', true);
		RamFx.SetActorParameter('BoneSocketActor', self);
		RamFx.SetFloatParameter('IsGrounded', ((int(Physics) == int(1)) ? 1.0000000 : 0.0000000));
	}
	//return;	
}

function bool HasGrenades()
{
	local HaloPlayerInventoryManager HaloInvMgr;

	HaloInvMgr = HaloPlayerInventoryManager(InvManager);
	// End:0x7D
	if(HaloInvMgr != none)
	{
		return (int(HaloInvMgr.FragGrenadeCount) > int(0)) || int(HaloInvMgr.PlasmaGrenadeCount) > int(0);
	}
	return true;
	//return ReturnValue;	
}

function bool CanThrowGrenade()
{
	return (((Health > 0) && IsBusy()!) && IsGrabbingLedge()!) && HasGrenades();
	//return ReturnValue;	
}

exec function AddFragGrenadesToInventory(optional int Count = 1, optional bool clampResult = true)
{
	local HaloPlayerInventoryManager HaloInvMgr;

	HaloInvMgr = HaloPlayerInventoryManager(InvManager);
	// End:0xCF
	if(HaloInvMgr != none)
	{
		HaloInvMgr.FragGrenadeCount += byte(Count);
		// End:0xCF
		if(clampResult)
		{
			HaloInvMgr.FragGrenadeCount = byte(Clamp(int(HaloInvMgr.FragGrenadeCount), 0, HaloInvMgr.FragGrenadeCountMax));
		}
	}
	//return;	
}

exec function AddPlasmaGrenadesToInventory(optional int Count = 1, optional bool clampResult = true)
{
	local HaloPlayerInventoryManager HaloInvMgr;

	HaloInvMgr = HaloPlayerInventoryManager(InvManager);
	// End:0xCF
	if(HaloInvMgr != none)
	{
		HaloInvMgr.PlasmaGrenadeCount += byte(Count);
		// End:0xCF
		if(clampResult)
		{
			HaloInvMgr.PlasmaGrenadeCount = byte(Clamp(int(HaloInvMgr.PlasmaGrenadeCount), 0, HaloInvMgr.FragGrenadeCountMax));
		}
	}
	//return;	
}

function Class<HaloProjectile_Grenade> RemoveGrenadeFromInventory()
{
	local HaloPlayerInventoryManager HaloInvMgr;

	HaloInvMgr = HaloPlayerInventoryManager(InvManager);
	// End:0xD5
	if(HaloInvMgr != none)
	{
		// End:0x80
		if(int(HaloInvMgr.PlasmaGrenadeCount) > int(0))
		{
			HaloInvMgr.PlasmaGrenadeCount -= 1;
			return Class'MegaHaloGame.HaloProjectile_PlasmaGrenade';
		}
		// End:0xD5
		if(int(HaloInvMgr.FragGrenadeCount) > int(0))
		{
			HaloInvMgr.FragGrenadeCount -= 1;
			return Class'MegaHaloGame.HaloProjectile_Grenade';
		}
	}
	return none;
	//return ReturnValue;	
}

function ThrowGrenade()
{
	// End:0x21
	if(CanThrowGrenade())
	{
		NetworkGotoState('ThrowingGrenade');
	}
	//return;	
}

function CalculateTossVelocity(out Vector TossVelocity, const float tossDegrees, const float Gravity, const Vector End, const Vector Start)
{
	local float Range, Speed, Angle;
	local Vector Trace, horzTrace;
	local Rotator Rot;

	Angle = tossDegrees * 0.0174533;
	Trace = End - Start;
	horzTrace = Trace;
	horzTrace.Z = 0.0000000;
	Range = VSize(horzTrace);
	Speed = Sqrt(((Range * Abs(Gravity)) / Cos(Angle)) / (2.0000000 * Sin(Angle)));
	Rot = Rotator(horzTrace);
	Rot.Pitch = int(tossDegrees * 182.0444031);
	TossVelocity = Vector(Rot) * Speed;
	//return;	
}

function CalculateTossDirection(out Vector tossDirection, const float TossSpeed, const float Gravity, const Vector End, const Vector Start)
{
	local float Range, Angle;
	local Vector Trace, horzTrace;
	local Rotator Rot;

	Trace = End - Start;
	horzTrace = Trace;
	horzTrace.Z = 0.0000000;
	Range = VSize(horzTrace);
	Angle = Asin((((Range * Abs(Gravity)) / TossSpeed) / (2.0000000 * TossSpeed)) * 2.0000000) / 2.0000000;
	Rot = Rotator(horzTrace);
	Rot.Pitch = int((Angle * 10430.3779297) + float(Rotator(Trace).Pitch));
	tossDirection = Vector(Rot);
	//return;	
}

function ThrowGrenadeNow()
{
	local Class<HaloProjectile_Grenade> NewProjectileClass;
	local HaloGameDefault Game;
	local Projectile NewProjectile;
	local HaloProjectile_Grenade grenade;
	local Vector ProjectileLoc, ProjectileDir, ProjectileTarg;
	local Actor projectileTarget;
	local HaloPlayerPawnController PC;

	// End:0x16
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	NewProjectileClass = RemoveGrenadeFromInventory();
	// End:0x3B
	if(NewProjectileClass == none)
	{
		return;
	}
	// End:0x85
	if((Mesh != none) && Mesh.GetSocketWorldLocationAndRotation(WeaponSocket2, ProjectileLoc))
	{		
	}
	else
	{
		ProjectileLoc = Location + vect(0.0000000, 0.0000000, 92.0000000);
	}
	// End:0x13B
	if(Controller != none)
	{
		PC = HaloPlayerPawnController(Controller);
		// End:0x10E
		if(PC != none)
		{
			ProjectileDir = Vector(PC.WeaponAimRotation);			
		}
		else
		{
			ProjectileDir = Vector(Controller.Rotation);
		}		
	}
	else
	{
		ProjectileDir = Vector(Rotation);
	}
	// End:0x19A
	if(HaloPlayerPawnController(Controller) != none)
	{
		projectileTarget = HaloPlayerPawnController(Controller).GetCameraAutoAimTarget();
	}
	// End:0x1E3
	if(CCSController(Controller) != none)
	{
		projectileTarget = CCSController(Controller).TargetObj;
	}
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x2EE
	if((Game != none) && Game.TheRAM != none)
	{
		NewProjectile = Projectile(Game.TheRAM.RequestActor(NewProjectileClass, self));
		grenade = HaloProjectile_Grenade(NewProjectile);
		// End:0x2EE
		if(grenade != none)
		{
			grenade.BeginReplay(self, ProjectileLoc);
		}
	}
	// End:0x345
	if(NewProjectile == none)
	{
		NewProjectile = Spawn(NewProjectileClass,,, ProjectileLoc);
		grenade = HaloProjectile_Grenade(NewProjectile);
	}
	// End:0x5DE
	if((NewProjectile != none) && NewProjectile.bDeleteMe!)
	{
		// End:0x3C3
		if(CCSController(Controller) != none)
		{
			CCSController(Controller).CalcAccuracyAngles(projectileTarget);
		}
		// End:0x4F0
		if(Pawn(projectileTarget) != none)
		{
			ProjectileTarg = GetRealLocationOf(projectileTarget);
			// End:0x463
			if(grenade.bSticksToPawns == false)
			{
				ProjectileTarg.Z -= Pawn(projectileTarget).GetCollisionHeight();
			}
			CalculateTossDirection(ProjectileDir, NewProjectile.Speed, NewProjectile.GetGravityZ(), ProjectileTarg, ProjectileLoc);
			NewProjectile.Init(ProjectileDir);			
		}
		else
		{
			ProjectileTarg = ProjectileLoc;
			ProjectileTarg.Z -= (GetCollisionHeight());
			ProjectileTarg += (GrenadeThrowTargetDistance * ProjectileDir);
			CalculateTossDirection(ProjectileDir, NewProjectile.Speed, NewProjectile.GetGravityZ(), ProjectileTarg, ProjectileLoc);
			NewProjectile.Init(ProjectileDir);
		}
		OnGrenadeThrow();
	}
	//return;	
}

function EnterVehicle(int SeatIndex)
{
	VehicleSeatIndex = byte(SeatIndex);
	//return;	
}

function AttachToVehicle(Vehicle V, name SeatBone, Vector SeatOffset, name AnimName)
{
	PlayCustomAnimation(AnimName);
	AttachToVehicleSeatBone = SeatBone;
	AttachToVehicleSeatOffset = SeatOffset;
	AttachToVehicleSeatOffset.Z += BaseTranslationOffset;
	SetTimer(0.5000000, false, 'AttachToVehicleNow');
	GotoState('AttachingToVehicle');
	//return;	
}

function bool AttachToVehicleNow(optional Vehicle passedInV)
{
	local HaloVehicleInterface V;

	// End:0x9A
	if(Health > 0)
	{
		V = HaloVehicleInterface(passedInV);
		// End:0x57
		if(passedInV == none)
		{
			V = HaloVehicleInterface(Owner);
		}
		// End:0x9A
		if(NotEqual_InterfaceInterface(V, HaloVehicleInterface(none)))
		{
			V.AttachDriverNow(self);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function DriverLeave(name AnimName, Controller C)
{
	local float animDuration;
	local HaloPlayerPawnController PC;

	animDuration = PlayCustomAnimation(AnimName,,,,, 0.1000000, 0.0000000);
	bExitAnimationExists = animDuration > 0.0000000;
	SetTimer(FMax(0.1000000, animDuration), false, 'OnAnimDone');
	GotoState('ExitingVehicle');
	PC = HaloPlayerPawnController(C);
	// End:0xBD
	if(PC != none)
	{
		PC.OnExitingVehicleBegin();
	}
	//return;	
}

function bool PlaceExitingDriver(Vehicle V)
{
	local Vector tryPlace, Extent, HitLocation, HitNormal, TraceLoc;

	local HaloVehicle HV;

	HV = HaloVehicle(V);
	// End:0x14C
	if((bExitAnimationExists || HV == none) || HV.Seats.Length == 0)
	{
		Extent = (GetCollisionRadius()) * vect(1.0000000, 1.0000000, 0.0000000);
		Extent.Z = GetCollisionHeight();
		tryPlace = Mesh.GetBoneLocation(Mesh.GetBoneName(0));
		TraceLoc = tryPlace;
		TraceLoc.Z += (Extent.Z * 0.5000000);		
	}
	else
	{
		Extent = HV.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
		Extent.Z = HV.GetCollisionHeight();
		tryPlace = HV.Mesh.GetBoneLocation(HV.Seats[0].SeatBone);
		tryPlace.Z += (Extent.Z + float(115));
		TraceLoc = tryPlace;
	}
	// End:0x2E4
	if(V.Trace(HitLocation, HitNormal, TraceLoc, TraceLoc, false, Extent) == none)
	{
		// End:0x2E4
		if(SetLocation(tryPlace))
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function DriverLeaveTurret(name AnimName, Controller C, Rotator rotStart, Rotator rotEnd, Vector Pivot)
{
	GotoState('ExitingTurret');
	BeginExitingTurretState(AnimName, C, rotStart, rotEnd, Pivot);
	//return;	
}

simulated function BeginExitingTurretState(name AnimName, Controller C, Rotator rotStart, Rotator rotEnd, Vector Pivot)
{
	//return;	
}

simulated function BroadcastEvent(CCSBlackboard.EEventType EventType, float broadcastDistance)
{
	local HaloAIPawn enemyPawn;
	local CCSController enemyPawnController;

	// End:0xE1
	foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloAIPawn', enemyPawn, Location, broadcastDistance)
	{
		// End:0xE0
		if((enemyPawn != none) && enemyPawn != self)
		{
			enemyPawnController = CCSController(enemyPawn.Controller);
			// End:0xE0
			if(enemyPawnController != none)
			{
				enemyPawnController.NotifyEvent(EventBroadcastClass, EventType, Location);
			}
		}		
	}	
	//return;	
}

function bool DoJump(bool bUpdating)
{
	// End:0x24
	if(JumpComponent == none)
	{
		return super.DoJump(bUpdating);
	}
	// End:0x53
	if((bJumpCapable! || bIsCrouched) || bWantsToCrouch)
	{
		return false;
	}
	switch(Physics)
	{
		// End:0x85
		case 1:
			SetJumpType(1, true);
			StartDoubleJumpCooldown();
			// End:0xBD
			break;
		// End:0xB8
		case 2:
			// End:0xB3
			if(CanDoubleJump())
			{
				SetJumpType(2, true);
				bReadyToDoubleJump = false;				
			}
			else
			{
				return false;
			}
			// End:0xBD
			break;
		// End:0xFFFF
		default:
			return false;
			break;
	}
	// End:0xD6
	if(bUpdating!)
	{
		PlayJumpingSound();
	}
	DoJumpNow();
	return true;
	//return ReturnValue;	
}

function DoJumpNow()
{
	Velocity.Z = JumpComponent.GetJumpZ(JumpType);
	// End:0x1F6
	if(((Base != none) && Base.bWorldGeometry!) && Base.Velocity.Z > 0.0000000)
	{
		// End:0x1A7
		if((WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ) && (GetGravityZ()) == WorldInfo.WorldGravityZ)
		{
			Velocity.Z += (Base.Velocity.Z * Sqrt((GetGravityZ()) / WorldInfo.DefaultGravityZ));			
		}
		else
		{
			Velocity.Z += Base.Velocity.Z;
		}
	}
	SetPhysics(2);
	JumpComponent.JumpPressed();
	bDodging = false;
	// End:0x255
	if(Controller.IsA('HaloPlayerPawnController')!)
	{
		AdjustVelocityForLedgeGrab();
	}
	WaitingForDoJumpNow = false;
	//return;	
}

function SetJumpType(HaloPawn.HaloJumpType Type, bool PlayJumpAnim)
{
	local HaloAnimBlendByJumpType Blend;

	// End:0xC5
	if((int(JumpType) != int(Type)) || PlayJumpAnim)
	{
		JumpType = Type;
		// End:0xC5
		if(Mesh != none)
		{
			// End:0xC4
			foreach Mesh.AllAnimNodes(Class'UDKBase.HaloAnimBlendByJumpType', Blend)
			{
				// End:0xC3
				if(Blend != none)
				{
					Blend.OnChangeJumpType(int(JumpType), PlayJumpAnim);
				}				
			}			
		}
	}
	//return;	
}

function bool CanDoubleJump()
{
	return (bReadyToDoubleJump && int(JumpType) != int(2)) && int(JumpType) != int(4);
	//return ReturnValue;	
}

function StartDoubleJumpCooldown()
{
	// End:0x2D
	if(DoubleJumpCooldown > 0.0000000)
	{
		SetTimer(DoubleJumpCooldown, false, 'AllowDoubleJump');		
	}
	else
	{
		AllowDoubleJump();
	}
	//return;	
}

function AllowDoubleJump()
{
	bReadyToDoubleJump = true;
	//return;	
}

function JumpReleased()
{
	// End:0x2E
	if(JumpComponent != none)
	{
		JumpComponent.JumpReleased();
	}
	//return;	
}

exec function LogJumpStats(int I)
{
	// End:0x38
	if(JumpComponent != none)
	{
		JumpComponent.LogJumpStats(self, I);
	}
	//return;	
}

exec function LogJumpParams()
{
	// End:0x2E
	if(JumpComponent != none)
	{
		JumpComponent.LogJumpParams();
	}
	//return;	
}

exec function LogFallTimes()
{
	// End:0x2F
	if(JumpComponent != none)
	{
		JumpComponent.LogFallTimes(self);
	}
	//return;	
}

exec function SetupJumpStart(int I, float JumpImpulse, float gravStartScale, float gravUpScale, float buttonTime)
{
	// End:0x5C
	if(JumpComponent != none)
	{
		JumpComponent.SetupJumpStart(self, I, JumpImpulse, gravStartScale, gravUpScale, buttonTime);
	}
	//return;	
}

exec function SetupJumpStartByMetrics(int I, optional float MinHeight = 366.0000000, optional float MaxHeight = 480.0000000, optional float MaxTime = 0.5000000, optional float holdTime = 0.2000000)
{
	// End:0x80
	if(JumpComponent != none)
	{
		JumpComponent.SetupJumpStartByMetrics(self, I, MinHeight, MaxHeight, MaxTime, holdTime);
	}
	//return;	
}

exec function SetupJumpApex(int I, float apexDuration, float apexGravScale)
{
	// End:0x4A
	if(JumpComponent != none)
	{
		JumpComponent.SetupJumpApex(self, I, apexDuration, apexGravScale);
	}
	//return;	
}

exec function SetupJumpFallByMetrics(int I, float fallDuration)
{
	// End:0x41
	if(JumpComponent != none)
	{
		JumpComponent.SetupJumpFallByMetrics(self, I, fallDuration);
	}
	//return;	
}

function bool Takedown(optional HaloPawn Target)
{
	local int I;

	// End:0x12C
	if(ReadyForTakedown())
	{
		// End:0x4E
		if(Target == none)
		{
			Target = FindTakedownTarget(I);
			// End:0x4B
			if(Target == none)
			{
				return false;
			}			
		}
		else
		{
			// End:0x72
			if(CanTakedown(Target, I)!)
			{
				return false;
			}
		}
		// End:0x12C
		if(I >= 0)
		{
			CurTakedownDesc = TakedownDescs[I];
			TakedownPartner = Target;
			Target.TakedownPartner = self;
			Target.CurTakedownDesc = CurTakedownDesc;
			GotoState('TakedownAsAttacker');
			Target.GotoState('TakedownAsTarget');
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function HaloPawn FindTakedownTarget(optional out int bestDescIdx)
{
	local HaloPawn Target, BestTarget;
	local float angOffset, bestAngOffset;
	local int I;

	// End:0x12
	if(ReadyForTakedown()!)
	{
		return none;
	}
	bestAngOffset = 999.9000244;
	bestDescIdx = -1;
	// End:0xDC
	foreach CollidingActors(Class'MegaHaloGame.HaloPawn', Target, TakedownMaxRange, Location)
	{
		// End:0x8B
		if(CanTakedown(Target, I, angOffset)!)
		{
			continue;			
		}
		// End:0xDB
		if(angOffset <= bestAngOffset)
		{
			BestTarget = Target;
			bestAngOffset = angOffset;
			bestDescIdx = I;
		}		
	}	
	return BestTarget;
	//return ReturnValue;	
}

function int GetTakedownDescIndexForClass(Class<HaloPawn> TargetClass)
{
	local int I, T;

	T = -1;
	I = 0;
	J0x1A:

	// End:0xBF [Loop If]
	if(I < TakedownDescs.Length)
	{
		// End:0xB1
		if(ClassIsChildOf(TargetClass, TakedownDescs[I].TargetClass))
		{
			T = I;
			// End:0xB1
			if(TargetClass == TakedownDescs[I].TargetClass)
			{
				// [Explicit Break]
				goto J0xBF;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x1A;
	}
	J0xBF:

	return T;
	//return ReturnValue;	
}

function bool CanTakedown(HaloPawn Target, optional out int I, optional out float angOffset)
{
	local Vector ToTarget;

	// End:0x28
	if(Target.ReadyForTakedown()!)
	{
		return false;
	}
	// End:0x85
	if((int(Target.TeamNum) <= int(0)) || int(Target.TeamNum) == int(TeamNum))
	{
		return false;
	}
	I = GetTakedownDescIndexForClass(Target.Class);
	// End:0xC8
	if(I < 0)
	{
		return false;
	}
	ToTarget = Target.Location - Location;
	// End:0x15B
	if(VSizeSq(ToTarget) > (TakedownDescs[I].MaxRange * TakedownDescs[I].MaxRange))
	{
		return false;
	}
	angOffset = RDiff(Target.Rotation, Rotator(ToTarget));
	// End:0x1CE
	if(angOffset > TakedownDescs[I].MaxBackAngleOffset)
	{
		return false;
	}
	angOffset = RDiff(Rotation, Rotator(ToTarget));
	// End:0x22C
	if(angOffset > TakedownDescs[I].MaxAngleOffset)
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function NotifyTakedownDown(bool Enable)
{
	NotifyKnockedDown(Enable);
	//return;	
}

function bool ReadyForTakedown()
{
	return ((Health > 0) && int(Physics) == int(1)) && IsBusy()!;
	//return ReturnValue;	
}

simulated function Takedown_Timer()
{
	//return;	
}

simulated function Takedown_EnableHitWall()
{
	//return;	
}

simulated function Takedown_DieNow()
{
	//return;	
}

simulated function Takedown_StopRootMotionCollisionSyncing()
{
	//return;	
}

function ShowWeapon()
{
	SetWeaponAttachmentVisibility(true);
	//return;	
}

function HideWeapon()
{
	SetWeaponAttachmentVisibility(false);
	//return;	
}

function float GetCurrentShield()
{
	// End:0x2E
	if(SuitShield != none)
	{
		return SuitShield.Shield;
	}
	return 0.0000000;
	//return ReturnValue;	
}

function bool CheckForLedgeGrab()
{
	local float grav;
	local Vector apexLoc;
	local HaloGrabbableLedge testLedge, bestLedge;
	local Vector testLoc, BestLoc, toTestLoc;
	local float testDistSq, BestDistSq;
	local Vector testEdge, bestEdge, faceDir;
	local float inFront;
	local Vector desiredFwd;
	local Rotator DesiredRot;
	local name MaterialName;

	// End:0x21
	if(int(Physics) == int(1))
	{
		LedgeGrabLedge = none;
		return false;
	}
	// End:0x30
	if(IsStillWithinPrevousLedgeRange())
	{
		return false;
	}
	// End:0xE4
	if(VSizeSq2D(Acceleration) > 0.0001000)
	{
		faceDir.X = Acceleration.X;
		faceDir.Y = Acceleration.Y;
		faceDir.Z = 0.0000000;		
	}
	else
	{
		faceDir = Vector(Rotation);
	}
	apexLoc = Location;
	// End:0x1B7
	if(Velocity.Z > 0.0000000)
	{
		grav = -2.0000000 * (GetGravityZ());
		apexLoc.Z += ((Velocity.Z * Velocity.Z) / (2.0000000 * grav));
	}
	BestDistSq = LedgeGrabRadius2D * LedgeGrabRadius2D;
	// End:0x43C
	foreach OverlappingActors(Class'MegaHaloGame.HaloGrabbableLedge', testLedge, 0.0000000, Location)
	{
		testLedge.GetClosestGrabPoint(GetCollisionRadius(), Location, testLoc, testEdge);
		testLoc.Z += LedgeGrabOffsetZ;
		// End:0x2AF
		if(testLoc.Z > apexLoc.Z)
		{
			continue;			
		}
		toTestLoc = testLoc - Location;
		// End:0x2FD
		if(toTestLoc.Z < LedgeGrabToleranceZ-)
		{
			continue;			
		}
		// End:0x354
		if(Velocity.Z > 0.0000000)
		{
			// End:0x351
			if(toTestLoc.Z > LedgeGrabToleranceZFromJump)
			{
				continue;				
			}			
		}
		else
		{
			// End:0x382
			if(toTestLoc.Z > LedgeGrabToleranceZ)
			{
				continue;				
			}
		}
		testDistSq = VSizeSq2D(toTestLoc);
		// End:0x3BA
		if(testDistSq >= BestDistSq)
		{
			continue;			
		}
		inFront = toTestLoc Dot faceDir;
		// End:0x3EF
		if(inFront < 0.0000000)
		{
			continue;			
		}
		bestLedge = testLedge;
		BestLoc = testLoc;
		BestDistSq = testDistSq;
		bestEdge = testEdge;		
	}	
	// End:0x67D
	if(bestLedge != none)
	{
		LedgeGrabLedge = bestLedge;
		desiredFwd = bestLedge.Location - BestLoc;
		desiredFwd.Z = 0.0000000;
		bestEdge = Normal(bestEdge);
		desiredFwd -= ((bestEdge Dot desiredFwd) * bestEdge);
		// End:0x541
		if(VSizeSq(desiredFwd) > 0.0001000)
		{
			desiredFwd = Normal(desiredFwd);
			DesiredRot = Rotator(desiredFwd);
			SetRotation(DesiredRot);			
		}
		else
		{
			desiredFwd = Vector(Rotation);
		}
		LerpLocStart = Location;
		LerpLocEnd = BestLoc - (desiredFwd * ((GetCollisionRadius()) + 1.0000000));
		MaterialName = GetMaterialBelowFeet();
		SetSwitch('Surface', ((MaterialName != 'None') ? MaterialName : 'Concrete'));
		PlayAkEvent(AkEvent'Foley.Play_Movement_Grab');
		// End:0x664
		if(Location.Z < (BestLoc.Z - LedgeGrabToleranceZ))
		{
			NetworkGotoState('LedgeGrab_JumpToLedge');			
		}
		else
		{
			NetworkGotoState('LedgeGrab_FallToLedge');
		}
		return true;		
	}
	else
	{
		LedgeGrabLedge = none;
	}
	return false;
	//return ReturnValue;	
}

function bool IsStillWithinPrevousLedgeRange()
{
	local Vector testLoc, toTestLoc;
	local float testDistSq, maxDistSq;

	// End:0x140
	if(LedgeGrabLedge != none)
	{
		LedgeGrabLedge.GetClosestGrabPoint(GetCollisionRadius(), Location, testLoc);
		toTestLoc = testLoc - Location;
		toTestLoc.Z += LedgeGrabOffsetZ;
		// End:0xEA
		if((toTestLoc.Z < LedgeGrabToleranceZ-) || toTestLoc.Z > LedgeGrabToleranceZFromJump)
		{
			return false;
		}
		testDistSq = VSizeSq2D(toTestLoc);
		maxDistSq = LedgeGrabRadius2D * LedgeGrabRadius2D;
		// End:0x13E
		if(testDistSq >= maxDistSq)
		{
			return false;
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function AdjustVelocityForLedgeGrab()
{
	local HaloGrabbableLedge testLedge, bestLedge;
	local float grav;
	local Vector apexLoc, testLoc, BestLoc, toTestLoc;
	local float testDistSq, BestDistSq;

	grav = -2.0000000 * (GetGravityZ());
	apexLoc = Location;
	apexLoc.Z += ((Velocity.Z * Velocity.Z) / (2.0000000 * grav));
	apexLoc.Z -= LedgeGrabOffsetZ;
	BestDistSq = LedgeGrabRadius2D * LedgeGrabRadius2D;
	// End:0x279
	foreach OverlappingActors(Class'MegaHaloGame.HaloGrabbableLedge', testLedge, 0.0000000, apexLoc)
	{
		// End:0x126
		if(testLedge == LedgeGrabLedge)
		{
			continue;			
		}
		testLedge.GetClosestGrabPoint(GetCollisionRadius(), apexLoc, testLoc);
		// End:0x1E9
		if((testLoc.Z < (Location.Z + 25.0000000)) || testLoc.Z > apexLoc.Z)
		{
			continue;			
		}
		toTestLoc = testLoc - apexLoc;
		testDistSq = VSizeSq2D(toTestLoc);
		// End:0x23F
		if(testDistSq >= BestDistSq)
		{
			continue;			
		}
		bestLedge = testLedge;
		BestLoc = testLoc;
		BestDistSq = testDistSq;		
	}	
	// End:0x2FB
	if(bestLedge != none)
	{
		Velocity.Z = Sqrt((2.0000000 * grav) * ((BestLoc.Z - 100.0000000) - Location.Z));
	}
	//return;	
}

function LetGoOfLedge()
{
	//return;	
}

function LetGoOfLedgeNow()
{
	//return;	
}

function TryToAbortJumpToLedge()
{
	//return;	
}

function OnLedgeGripped()
{
	//return;	
}

function AllowJump()
{
	//return;	
}

exec function TestKnockdown()
{
	KnockdownFromDamageType(Class'MegaHaloGame.HaloDamageType_Grenade', Location, Vector(Rotation));
	//return;	
}

simulated function bool KnockdownFromDamageType(Class<HaloDamageType> dmgType, Vector HitLocation, Vector Momentum)
{
	local Vector HitVec;
	local int I;

	// End:0x63
	if(dmgType != none)
	{
		I = 0;
		J0x1A:

		// End:0x63 [Loop If]
		if(I < KnockdownIgnoredDamageTypes.Length)
		{
			// End:0x55
			if(KnockdownIgnoredDamageTypes[I] == dmgType)
			{
				return false;
			}
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	HitVec = Momentum;
	HitVec.Z = 0.0000000;
	// End:0x10E
	if(IsZero(HitVec))
	{
		HitVec = HitLocation - Location;
		HitVec.Z = 0.0000000;
		// End:0x10B
		if(IsZero(HitVec))
		{
			HitVec = Normal(HitVec);
		}		
	}
	else
	{
		HitVec = Normal(HitVec-);
	}
	I = FindBestKnockdownBehavor(dmgType, HitVec);
	// End:0x178
	if(I < 0)
	{
		I = FindBestKnockdownBehavor(none, HitVec);
	}
	// End:0x1A5
	if(I >= 0)
	{
		ServerKnockdown(I, HitVec);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function int FindBestKnockdownBehavor(Class<HaloDamageType> dmgType, Vector HitVec)
{
	local int I, BestIdx;
	local float BestDot, thisdot;
	local Rotator thisrot;

	BestIdx = -1;
	BestDot = -1.1000000;
	I = 0;
	J0x29:

	// End:0x153 [Loop If]
	if(I < KnockdownBehaviors.Length)
	{
		// End:0x145
		if(KnockdownBehaviors[I].DamageType == dmgType)
		{
			// End:0x13B
			if(KnockdownBehaviors[I].bIsDirectional)
			{
				thisrot = Rotation + KnockdownBehaviors[I].rDirection;
				thisdot = HitVec Dot Vector(thisrot);
				// End:0x138
				if(thisdot > BestDot)
				{
					BestDot = thisdot;
					BestIdx = I;
				}				
			}
			else
			{
				return I;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x29;
	}
	return BestIdx;
	//return ReturnValue;	
}

reliable server function ServerKnockdown(int I, Vector HitVec)
{
	GotoState('KnockedDown_Start',, true);
	BeginKnockdownState(I, HitVec);
	//return;	
}

simulated function SyncKnockedDownState()
{
	// End:0x2F
	if(int(Role) > int(ROLE_Authority))
	{
		// End:0x2F
		if(bIsKnockedDown)
		{
			GotoState('KnockedDown_Start');
		}
	}
	//return;	
}

function NotifyKnockedDown(bool Enabled)
{
	local CCSController AIController;
	local HaloPlayerPawnController PlayerController;

	AIController = CCSController(Controller);
	// End:0x89
	if(AIController != none)
	{
		// End:0x61
		if(Enabled)
		{
			AIController.SetState("Pause");			
		}
		else
		{
			AIController.RemoveState("Pause");
		}
		return;
	}
	PlayerController = HaloPlayerPawnController(Controller);
	// End:0xDF
	if(PlayerController != none)
	{
		PlayerController.EnableLockedState(Enabled);
		return;
	}
	//return;	
}

simulated function BeginKnockdownState(int I, Vector HitVec)
{
	//return;	
}

function SwapToFadeMaterial()
{
	local int I;
	local Texture ColorMap, NormalMap;
	local MaterialInterface BaseMaterial;
	local MaterialInstanceTimeVarying MITV;

	I = 0;
	J0x0B:

	// End:0x1DD [Loop If]
	if(I < Mesh.GetNumElements())
	{
		BaseMaterial = Mesh.GetMaterial(I);
		BaseMaterial.GetTextureParameterValue('CLR_Texture', ColorMap);
		BaseMaterial.GetTextureParameterValue('NRM_Texture', NormalMap);
		MITV = new (Mesh) Class'Engine.MaterialInstanceTimeVarying';
		MITV.SetParent(FadeOutMaterial);
		MITV.SetDuration(FadeOutDuration);
		MITV.SetTextureParameterValue('CLR_Texture', ColorMap);
		MITV.SetTextureParameterValue('NRM_Texture', NormalMap);
		Mesh.SetMaterial(I, MITV);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

exec function RefillAssaultRifle()
{
	local HaloWeapon_AssaultRifle W;

	// End:0x72
	foreach InvManager.InventoryActors(Class'MegaHaloGame.HaloWeapon_AssaultRifle', W)
	{
		W.ExtraAmmoCount = W.MaxExtraAmmoCount;		
	}	
	//return;	
}

exec function PickupAssaultRifle()
{
	local HaloPlayerInventoryManager HaloInvMgr;
	local HaloDroppedPickup Pickup;

	HaloInvMgr = HaloPlayerInventoryManager(InvManager);
	Pickup = Spawn(Class'MegaHaloGame.HaloDroppedPickup', self,, self.Location);
	Pickup.Inventory = Spawn(Class'MegaHaloGame.HaloWeapon_AssaultRifle');
	HaloInvMgr.AddDroppedPickup(Pickup);
	//return;	
}

simulated function NetworkGotoState(name StateName, optional bool forceRestart)
{
	GotoState(StateName,, forceRestart);
	// End:0x49
	if(int(Role) < int(ROLE_Authority))
	{
		ServerGotoState(StateName, forceRestart);
	}
	//return;	
}

reliable server function ServerGotoState(name StateName, bool forceRestart)
{
	GotoState(StateName,, forceRestart);
	//return;	
}

simulated event byte ScriptGetTeamNum()
{
	return TeamNum;
	//return ReturnValue;	
}

function OnAnimDone()
{
	//return;	
}

simulated function bool Flinch()
{
	// End:0xB2
	if(((AdditiveFlinchBlendNode != none) && AdditiveFlinchSequenceNode != none) && AdditiveFlinchBlendNode.Child2Weight == 0.0000000)
	{
		AdditiveFlinchSequenceNode.PlayAnim(false, 1.0000000, 0.0000000);
		AdditiveFlinchBlendNode.SetBlendTarget(1.0000000, 0.2500000);
		SetTimer(0.2500000, false, 'StopFlinch');
		return true;
	}
	return false;
	//return ReturnValue;	
}

function StopFlinch()
{
	AdditiveFlinchBlendNode.SetBlendTarget(0.0000000, AdditiveFlinchSequenceNode.GetTimeLeft());
	//return;	
}

function WarpToLastBreadcrumbLocation()
{
	local HaloPlayerPawnController PC;
	local Vector bestLocation;

	PC = HaloPlayerPawnController(Controller);
	// End:0x7D
	if((PC != none) && PC.FindABreadcrumbSpot(GetCollisionExtent(), bestLocation) == true)
	{
		SetLocation(bestLocation);
		PlayTeleportEffect(true, true);
	}
	//return;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	local HaloPlayerPawnController HPPC;

	// End:0x7D
	if(bIgnoreKillZ!)
	{
		HPPC = HaloPlayerPawnController(Controller);
		// End:0x6A
		if((HPPC != none) && HPPC.bTeleportToBreadcrumbOnFall)
		{
			WarpToLastBreadcrumbLocation();
			return;
		}
		super.FellOutOfWorld(dmgType);
	}
	//return;	
}

function AddDefaultInventory()
{
	// End:0x23
	if(DefaultWeaponClass != none)
	{
		CreateInventory(DefaultWeaponClass, false);
	}
	super.AddDefaultInventory();
	SetSwitch('Weapon_Type', HaloWeapon(Weapon).akWeaponType);
	//return;	
}

function OnGrenadeThrow()
{
	//return;	
}

function OnMelee()
{
	//return;	
}

function OnRam()
{
	//return;	
}

function OnTakedown()
{
	//return;	
}

function OnWeaponFire()
{
	//return;	
}

function OnWeaponAttach()
{
	//return;	
}

function OnWeaponDetach()
{
	//return;	
}

function bool ActivateArmorAbility()
{
	return false;
	//return ReturnValue;	
}

simulated event PostBeginPlay()
{
	local int I, Angle;

	SetSwitch('Character_Type', AkCharacterType);
	// End:0x75
	if(ArmorAbilityClass != none)
	{
		ArmorAbility = new (self) ArmorAbilityClass;
		AttachComponent(ArmorAbility);
		ArmorAbility.PostBeginPlay();
	}
	I = 0;
	J0x80:

	// End:0x19C [Loop If]
	if(I < KnockdownBehaviors.Length)
	{
		Angle = int(KnockdownBehaviors[I].AnimHitDirection * 32768.0000000) / 180;
		KnockdownBehaviors[I].rDirection.Yaw = Angle;
		KnockdownBehaviors[I].rDirection.Pitch = 0;
		KnockdownBehaviors[I].rDirection.Roll = 0;
		I++;
		// [Loop Continue]
		goto J0x80;
	}
	TakedownMaxRange = 0.0000000;
	I = 0;
	J0x1B6:

	// End:0x217 [Loop If]
	if(I < TakedownDescs.Length)
	{
		TakedownMaxRange = FMax(TakedownMaxRange, TakedownDescs[I].MaxRange);
		I++;
		// [Loop Continue]
		goto J0x1B6;
	}
	super.PostBeginPlay();
	// End:0x24F
	if(MyHaloTargetableComponent != none)
	{
		MyHaloTargetableComponent.PostBeginPlay();
	}
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Actor A;

	// End:0x68
	foreach VisibleActors(Class'Engine.Actor', A, 5000.0000000, Location)
	{
		// End:0x67
		if(A.bCanBeDamaged == true)
		{
			DebugActorInfo(HUD, A);
		}		
	}	
	//return;	
}

simulated function DebugActorInfo(HUD HUD, Actor A)
{
	local Canvas Canvas;
	local float YPos;
	local editinline UDKTargetableComponent myCurTargetableComponent, enemyTargetableComponent;
	local CCSController AIController;
	local Pawn aiPawn;
	local int I, totalThreat;

	myCurTargetableComponent = UDKTargetableComponent(A.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
	// End:0xAF4
	if(myCurTargetableComponent != none)
	{
		Canvas = HUD.Canvas;
		YPos = Canvas.Project(A.Location).Y;
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.SetPos(Canvas.Project(A.Location).X, YPos);
		Canvas.DrawText((("Heat: " @ string(myCurTargetableComponent.CurAIHeat)) @ "/") @ string(myCurTargetableComponent.MaxAIHeat), false);
		YPos += float(12);
		aiPawn = Pawn(A);
		// End:0xAF4
		if(aiPawn != none)
		{
			AIController = CCSController(aiPawn.Controller);
			// End:0xAF1
			if(AIController != none)
			{
				I = 0;
				J0x264:

				// End:0xAEE [Loop If]
				if(I < AIController.TotalEnemyThreat.Length)
				{
					// End:0x2D5
					if(AIController.TotalEnemyThreat[I].TotalDamageAmount <= 0)
					{						
					}
					else
					{
						Canvas.SetPos(Canvas.Project(A.Location).X, YPos);
						// End:0x6FF
						if(AIController.TotalEnemyThreat[I].DamageInstigator != none)
						{
							// End:0x587
							if(AIController.TotalEnemyThreat[I].DamageInstigator.Pawn != none)
							{
								totalThreat = AIController.TotalEnemyThreat[I].TotalDamageAmount;
								enemyTargetableComponent = UDKTargetableComponent(AIController.TotalEnemyThreat[I].DamageInstigator.Pawn.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
								// End:0x4E4
								if(enemyTargetableComponent != none)
								{
									totalThreat += enemyTargetableComponent.BaseThreatVal;
								}
								Canvas.DrawText((string(AIController.TotalEnemyThreat[I].DamageInstigator.Pawn.Name) @ " : = ") @ string(totalThreat), false);								
							}
							else
							{
								totalThreat = AIController.TotalEnemyThreat[I].TotalDamageAmount;
								enemyTargetableComponent = UDKTargetableComponent(AIController.TotalEnemyThreat[I].DamageInstigator.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
								// End:0x671
								if(enemyTargetableComponent != none)
								{
									totalThreat += enemyTargetableComponent.BaseThreatVal;
								}
								Canvas.DrawText((string(AIController.TotalEnemyThreat[I].DamageInstigator.Name) @ " : = ") @ string(totalThreat), false);
							}							
						}
						else
						{
							// End:0xAD1
							if(AIController.TotalEnemyThreat[I].DamagingActor != none)
							{
								// End:0x953
								if(Weapon(AIController.TotalEnemyThreat[I].DamagingActor).Owner != none)
								{
									totalThreat = AIController.TotalEnemyThreat[I].TotalDamageAmount;
									enemyTargetableComponent = UDKTargetableComponent(Weapon(AIController.TotalEnemyThreat[I].DamagingActor).Owner.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
									// End:0x8A7
									if(enemyTargetableComponent != none)
									{
										totalThreat += enemyTargetableComponent.BaseThreatVal;
									}
									Canvas.DrawText((string(Weapon(AIController.TotalEnemyThreat[I].DamagingActor).Owner.Name) @ " : = ") @ string(totalThreat), false);									
								}
								else
								{
									totalThreat = AIController.TotalEnemyThreat[I].TotalDamageAmount;
									enemyTargetableComponent = UDKTargetableComponent(Weapon(AIController.TotalEnemyThreat[I].DamagingActor).GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
									// End:0xA46
									if(enemyTargetableComponent != none)
									{
										totalThreat += enemyTargetableComponent.BaseThreatVal;
									}
									Canvas.DrawText((string(AIController.TotalEnemyThreat[I].DamagingActor.Name) @ " : = ") @ string(totalThreat), false);
								}
							}
						}
						YPos += float(12);
					}
					I++;
					// [Loop Continue]
					goto J0x264;
				}				
			}			
		}
	}
	//return;	
}

function bool CheatGhost()
{
	// End:0x1D
	if(super(Pawn).CheatGhost() == true)
	{
		SetMeshVisibility(false);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool CheatWalk()
{
	// End:0x1D
	if(super(Pawn).CheatWalk() == true)
	{
		SetMeshVisibility(true);
		return true;
	}
	return false;
	//return ReturnValue;	
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	super(Actor).PhysicsVolumeChange(NewVolume);
	// End:0x4A
	if(JumpComponent != none)
	{
		JumpComponent.PhysicsVolumeChange(NewVolume);
	}
	//return;	
}

simulated function TickGravityLifts(float DeltaTime)
{
	local HaloGravityLift Lift;

	Lift = HaloGravityLift(PhysicsVolume);
	// End:0x54
	if(Lift != none)
	{
		Lift.TickPawn(self, DeltaTime);
	}
	//return;	
}

simulated function bool PlayWeaponSwapAnim(name AnimName)
{
	GotoState('SwappingWeapon');
	return BeginSwappingWeaponState(AnimName);
	//return ReturnValue;	
}

simulated function bool BeginSwappingWeaponState(name AnimName)
{
	//return ReturnValue;	
}

function WeaponIsDown()
{
	// End:0x2E
	if(Weapon != none)
	{
		Weapon.WeaponIsDown();
	}
	//return;	
}

function bool WaitForWeaponReload()
{
	// End:0x1E
	if((IsBusy()) || IsGrabbingLedge())
	{
		return false;
	}
	GotoState('WaitingForWeaponReload');
	return IsReloadingWeapon();
	//return ReturnValue;	
}

simulated function OnWeaponReloadDone()
{
	//return;	
}

function ReloadNow()
{
	local HaloWeapon W;

	W = HaloWeapon(Weapon);
	// End:0x4A
	if(W != none)
	{
		W.ReloadNow();
	}
	//return;	
}

function bool PickupClosestWeapon()
{
	// End:0x1E
	if((IsBusy()) || IsGrabbingLedge())
	{
		return false;
	}
	// End:0x2F
	if(TouchedPickupCount <= 0)
	{
		return false;
	}
	GotoState('PickingUpWeapon');
	return true;
	//return ReturnValue;	
}

simulated function LockController(bool Enabled)
{
	local HaloPlayerPawnController C;

	C = HaloPlayerPawnController(Controller);
	// End:0x54
	if(C != none)
	{
		C.EnableLockedState(Enabled);
	}
	//return;	
}

function bool UseWeaponCloset(HaloWeaponCloset closet)
{
	// End:0x1E
	if((IsBusy()) || IsGrabbingLedge())
	{
		return false;
	}
	// End:0x2F
	if(closet == none)
	{
		return false;
	}
	GotoState('UsingWeaponCloset');
	return true;
	//return ReturnValue;	
}

function SpawnDefaultHitFX(Vector fxLoc, Vector fxFwd, int Damage)
{
	local editinline ParticleSystemComponent FX;

	// End:0x11
	if(DefaultHitFxTemplate == none)
	{
		return;
	}
	// End:0x6E
	if(VSizeSq(fxFwd) < 0.0000001)
	{
		fxFwd = Location - fxLoc;
		// End:0x6E
		if(VSizeSq(fxFwd) < 0.0000001)
		{
			fxFwd = Vector(Rotation);
		}
	}
	FX = WorldInfo.MyEmitterPool.SpawnEmitter(DefaultHitFxTemplate, fxLoc, Rotator(fxFwd), self);
	// End:0x10F
	if(FX != none)
	{
		FX.SetFloatParameter('Damage', float(Damage));
	}
	//return;	
}

function Vector GetRealLocation()
{
	// End:0x3A
	if(Mesh != none)
	{
		return MatrixGetOrigin(Mesh.GetBoneMatrix(0));
	}
	return Location;
	//return ReturnValue;	
}

static function Vector GetRealLocationOf(const Actor aActor)
{
	// End:0x93
	if((Pawn(aActor) != none) && Pawn(aActor).Mesh != none)
	{
		return MatrixGetOrigin(Pawn(aActor).Mesh.GetBoneMatrix(0));		
	}
	else
	{
		// End:0xB0
		if(aActor == none)
		{
			return vect(0.0000000, 0.0000000, 0.0000000);
		}
	}
	return aActor.Location;
	//return ReturnValue;	
}

simulated state Meleeing
{
	simulated function bool IsMeleeing()
	{
		return true;
		//return ReturnValue;		
	}

	simulated event BeginState(name PrevStateName)
	{
		local float MeleeCooldown;

		SetIsFiring(false);
		TimerLowerGun();
		// End:0x40
		if(CurMeleeDesc.bLockMovementInput)
		{
			IgnoreMoveInput(true);
		}
		MeleeCooldown = PlayCustomAnimation(CurMeleeDesc.AnimName, CurMeleeDesc.bIsFullBodyAnim, false,,, CurMeleeDesc.BlendInTime, CurMeleeDesc.BlendOutTime);
		// End:0x1CA
		if(MeleeCooldown > 0.0000000)
		{
			SetTimer(MeleeCooldown - CurMeleeDesc.BlendOutTime, false, 'OnAnimDone');
			// End:0x186
			if(CurMeleeDesc.bUseRootMotion)
			{
				// End:0x186
				if(FullBodyAnimSlot != none)
				{
					FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
					Mesh.RootMotionMode = 3;
				}
			}
			MeleeSwipeTouchList.Length = 0;
			NextMeleeSwipeKeyIndex = ((CurMeleeDesc.SwipeKeyFrames.Length > 1) ? 0 : -1);			
		}
		else
		{
			MeleeContact();
			OnAnimDone();
		}
		OnMelee();
		// End:0x1FF
		if(bDrawMeleeSwipeBoxes)
		{
			FlushPersistentDebugLines();
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		EndMeleeSwipe();
		MeleeSwipeTouchList.Length = 0;
		// End:0x57
		if(CurMeleeDesc.bUseRootMotion)
		{
			Mesh.RootMotionMode = 0;
		}
		// End:0x82
		if(CurMeleeDesc.bLockMovementInput)
		{
			IgnoreMoveInput(false);
		}
		MeleeTarget = none;
		SetIsFiring(false);
		//return;		
	}

	simulated function OnAnimDone()
	{
		local HaloWeapon_Melee W;

		NetworkGotoState('None');
		W = HaloWeapon_Melee(Weapon);
		// End:0x5E
		if(W != none)
		{
			W.OnMeleeDone();
		}
		//return;		
	}

	simulated event Tick(float DeltaTime)
	{
		super(HaloPawn).Tick(DeltaTime);
		TickSwipe(DeltaTime);
		//return;		
	}

	simulated function TickSwipe(float DeltaTime)
	{
		local float T;
		local Vector nextLoc;

		// End:0x1D3
		if(NextMeleeSwipeKeyIndex >= 0)
		{
			T = GetTimerCount('OnAnimDone');
			J0x2D:

			// End:0x1D3 [Loop If]
			if(T >= CurMeleeDesc.SwipeKeyFrames[NextMeleeSwipeKeyIndex].Time)
			{
				nextLoc = CurMeleeDesc.SwipeKeyFrames[NextMeleeSwipeKeyIndex].RelativeLoc;
				nextLoc.Z = 0.0000000;
				nextLoc = (nextLoc >> Rotation) + Location;
				// End:0x131
				if(NextMeleeSwipeKeyIndex > 0)
				{
					DoSwipe(PrevMeleeSwipeLocation, nextLoc);					
				}
				else
				{
					// End:0x174
					if(bDrawMeleeSwipeBoxes)
					{
						DrawDebugBox(nextLoc, CurMeleeDesc.SwipeExtent, 255, 0, 0, true);
					}
				}
				PrevMeleeSwipeLocation = nextLoc;
				NextMeleeSwipeKeyIndex += 1;
				// End:0x1D0
				if(NextMeleeSwipeKeyIndex == CurMeleeDesc.SwipeKeyFrames.Length)
				{
					NextMeleeSwipeKeyIndex = -1;
					// [Explicit Break]
					goto J0x1D3;
				}
				// [Loop Continue]
				goto J0x2D;
			}
		}
		J0x1D3:

		//return;		
	}

	simulated function bool AlreadyTouched(Actor HitActor)
	{
		local Actor touchedActor;

		// End:0x32
		foreach MeleeSwipeTouchList(touchedActor)
		{
			// End:0x31
			if(touchedActor == HitActor)
			{				
				return true;
			}			
		}		
		return false;
		//return ReturnValue;		
	}

	simulated function SpawnMeleeHitFx(Vector fxLoc, Vector StartLoc)
	{
		local int I;
		local Vector endLoc, fxRight, fxFwd;
		local Rotator fxRot;

		// End:0x24
		if(CurMeleeDesc.HitFxTemplate == none)
		{
			return;
		}
		I = Min(NextMeleeSwipeKeyIndex + 1, CurMeleeDesc.SwipeKeyFrames.Length - 1);
		endLoc = CurMeleeDesc.SwipeKeyFrames[I].RelativeLoc;
		endLoc.Z = 0.0000000;
		endLoc = (endLoc >> Rotation) + Location;
		fxRight = Normal(endLoc - StartLoc);
		// End:0x16D
		if(Abs(fxRight.Z) < 0.9750000)
		{
			fxFwd = fxRight Cross vect(0.0000000, 0.0000000, 1.0000000);
			fxRot = Rotator(fxFwd);			
		}
		else
		{
			// End:0x1BA
			if(fxRight.Z < 0.0000000)
			{
				fxRot.Roll = 16384-;				
			}
			else
			{
				fxRot.Roll = 16384;
			}
		}
		WorldInfo.MyEmitterPool.SpawnEmitter(CurMeleeDesc.HitFxTemplate, fxLoc, fxRot, self);
		//return;		
	}

	simulated function DoSwipe(Vector StartLoc, Vector endLoc)
	{
		local Actor HitActor;
		local Vector HitNorm, HitLoc;
		local TraceHitInfo HitInfo;
		local editinline HaloTargetableComponent hitTarget;
		local int hitTeamNum;

		// End:0x43
		if(bDrawMeleeSwipeBoxes)
		{
			DrawDebugBox(endLoc, CurMeleeDesc.SwipeExtent, 255, 0, 0, true);
		}
		// End:0x27D
		foreach TraceActors(Class'Engine.Actor', HitActor, HitLoc, HitNorm, endLoc, StartLoc, CurMeleeDesc.SwipeExtent, HitInfo)
		{
			// End:0xBF
			if(AlreadyTouched(HitActor))
			{
				continue;				
			}
			hitTarget = HaloTargetableComponent(HitActor.GetComponentOfType(Class'MegaHaloGame.HaloTargetableComponent'));
			// End:0x10D
			if(hitTarget == none)
			{
				continue;				
			}
			// End:0x133
			if(hitTarget.IsDead())
			{
				continue;				
			}
			hitTeamNum = int(hitTarget.GetTeamNum());
			// End:0x18C
			if((hitTeamNum <= 0) || hitTeamNum == int(TeamNum))
			{
				continue;				
			}
			HitActor.TakeDamage(CurMeleeDesc.Damage, Controller, HitLoc, vect(0.0000000, 0.0000000, 0.0000000), CurMeleeDesc.DamageType,, self);
			MeleeSwipeTouchList.AddItem(HitActor);
			SpawnMeleeHitFx(HitLoc, StartLoc);
			// End:0x27C
			if((MeleeTarget == HitActor) && hitTarget.IsDead())
			{
				MeleeTarget = none;
			}			
		}		
		//return;		
	}

	simulated function StartMeleeSwipe()
	{
		EndMeleeSwipe();
		// End:0xB0
		if(CurMeleeDesc.RibbonTemplate != none)
		{
			MeleeRibbon = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(CurMeleeDesc.RibbonTemplate, CurrentWeaponAttachment.Mesh, 'SwipeFX_Socket', true);
		}
		//return;		
	}

	simulated function EndMeleeSwipe()
	{
		// End:0x39
		if(MeleeRibbon != none)
		{
			MeleeRibbon.DeactivateSystem();
			MeleeRibbon = none;
		}
		//return;		
	}
	stop;	
}

state BakeMeleeSwipeState
{
	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		LockController(true);
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		SetPhysics(4);
		SetLocation(Location + vect(0.0000000, 0.0000000, 200.0000000));
		FlushPersistentDebugLines();
		HaloWeapon_Melee(Weapon).NextComboAttackIndex = 0;
		BakeNextCombo();
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x41
		if(CurMeleeDesc.bUseRootMotion)
		{
			Mesh.RootMotionMode = 0;
		}
		SetPhysics(2);
		LockController(false);
		//return;		
	}

	function BakeNextCombo()
	{
		local HaloWeapon_Melee W;
		local float MeleeCooldown;

		W = HaloWeapon_Melee(Weapon);
		// End:0x172
		if(W != none)
		{
			CurMeleeDesc = W.ComboAttackDescs[W.NextComboAttackIndex];
			MeleeCooldown = PlayCustomAnimation(CurMeleeDesc.AnimName, CurMeleeDesc.bIsFullBodyAnim, false,,, 0.0000000, 0.0000000, 0.0500000);
			// End:0x172
			if(MeleeCooldown > 0.0000000)
			{
				SetTimer(MeleeCooldown, false, 'OnAnimDone');
				// End:0x170
				if(CurMeleeDesc.bUseRootMotion)
				{
					// End:0x170
					if(FullBodyAnimSlot != none)
					{
						FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
						Mesh.RootMotionMode = 3;
					}
				}
				return;
			}
		}
		OnAnimDone();
		//return;		
	}

	function OnAnimDone()
	{
		local HaloWeapon_Melee W;

		W = HaloWeapon_Melee(Weapon);
		// End:0x9E
		if(W != none)
		{
			// End:0x92
			if(W.NextComboAttackIndex++ >= W.ComboAttackDescs.Length)
			{
				W.NextComboAttackIndex = 0;				
			}
			else
			{
				BakeNextCombo();
				return;
			}
		}
		GotoState('None');
		//return;		
	}

	simulated function StartMeleeSwipe()
	{
		SetTimer(1.0000000 / (float(30) * 0.0500000), true, 'BakeMeleeSwipeKeyFrame');
		BakeMeleeSwipeKeyFrame(true);
		//return;		
	}

	simulated function EndMeleeSwipe()
	{
		// End:0x36
		if(IsTimerActive('BakeMeleeSwipeKeyFrame'))
		{
			ClearTimer('BakeMeleeSwipeKeyFrame');
			BakeMeleeSwipeKeyFrame(false);
		}
		//return;		
	}

	function BakeMeleeSwipeKeyFrame(optional bool skipLineDraw)
	{
		local Vector RelativeLoc, WorldLoc;
		local float Time;
		local int I;

		// End:0x163
		if(CurrentWeaponAttachment.Mesh.GetSocketWorldLocationAndRotation('Swipe_Socket', WorldLoc))
		{
			// End:0x7E
			if(skipLineDraw!)
			{
				DrawDebugLine(PrevMeleeSwipeLocation, WorldLoc, 255, 0, 0, true);
			}
			PrevMeleeSwipeLocation = WorldLoc;
			RelativeLoc = (WorldLoc - Location) << Rotation;
			Time = GetTimerCount('OnAnimDone') * 0.0500000;
			I = HaloWeapon_Melee(Weapon).NextComboAttackIndex;
			LogInternal(((((("AddSwipeKey( " $ string(I)) $ ", ") $ string(Time)) $ ", vect(") $ string(RelativeLoc)) $ ") );");
		}
		//return;		
	}
	stop;	
}

simulated state Ramming_Base
{
	ignores LeapAttack, RamAttack, ThrowGrenade, StopFire, StartFire;

	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool IsRamming()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		IgnoreMoveInput(true);
		//return;		
	}

	event EndState(name NextStateName)
	{
		IgnoreMoveInput(false);
		//return;		
	}

	function bool DoJump(bool isUpdating)
	{
		return false;
		//return ReturnValue;		
	}

	function NotifyMeleeDone()
	{
		local HaloWeapon_Melee W;

		W = HaloWeapon_Melee(Weapon);
		// End:0x4A
		if(W != none)
		{
			W.OnMeleeDone();
		}
		//return;		
	}
	stop;	
}

simulated state Ramming_Start extends Ramming_Base
{
	simulated event BeginState(name PrevStateName)
	{
		local float Duration;

		super.BeginState(PrevStateName);
		global.StopFire(0);
		TimerLowerGun();
		Duration = PlayCustomAnimation(RamStartAnimName, true, false);
		OnRam();
		// End:0x84
		if(Duration > 0.0000000)
		{
			SetTimer(Duration, false, 'OnAnimDone');			
		}
		else
		{
			PlayRamFX();
			OnAnimDone();
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		// End:0x35
		if(NextStateName != 'Ramming_Loop')
		{
			MeleeTarget = none;
		}
		//return;		
	}

	function OnAnimDone()
	{
		NetworkGotoState('Ramming_Loop');
		//return;		
	}
	stop;	
}

simulated state Ramming_Loop extends Ramming_Base
{
	event BeginState(name PrevStateName)
	{
		local name AnimName;
		local float BlendInTime;

		super.BeginState(PrevStateName);
		// End:0x6A
		if(int(Physics) == int(1))
		{
			AnimName = RamLoopAnimName;
			BlendInTime = ((RamStartAnimName == 'None') ? 0.0500000 : 0.0000000);			
		}
		else
		{
			AnimName = RamWhileAirborneLoopAnimName;
			BlendInTime = 0.1000000;
		}
		PlayCustomAnimation(AnimName, true, true,,, BlendInTime);
		PlayAkEvent(RamSoundEvent);
		SetTimer(RamDistance / RamSpeed);
		GroundSpeed = RamSpeed;
		bDirectHitWall = true;
		//return;		
	}

	event EndState(name NextStateName)
	{
		bDirectHitWall = default.bDirectHitWall;
		GroundSpeed = default.GroundSpeed;
		MeleeTarget = none;
		super.EndState(NextStateName);
		//return;		
	}

	function Timer()
	{
		StopCustomAnimation(true, RamMissDuration);
		SetTimer(RamMissDuration);
		NetworkGotoState('Ramming_Exit');
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local Vector Temp;

		// End:0x90
		if((MeleeTarget != none) && int(Physics) == int(2))
		{
			Temp = MeleeTarget.Location - Location;
			// End:0x8D
			if(VSizeSq(Temp) > 0.0001000)
			{
				Velocity = GroundSpeed * Normal(Temp);
			}			
		}
		else
		{
			Temp = Vector(Rotation) * GroundSpeed;
			Velocity.X = Temp.X;
			Velocity.Y = Temp.Y;
		}
		super(HaloPawn).Tick(DeltaTime);
		//return;		
	}

	function HurtActor(Actor Other, Vector HitLocation, Vector HitNormal)
	{
		local Vector Momentum;
		local HaloPawn HaloOther;
		local HaloDestructibleActor Destructible;
		local float Damage;
		local bool shouldExit;

		// End:0x35
		if((Other == none) || Other.bStatic)
		{
			return;
		}
		// End:0x2D3
		if(IsBlockedBy(Other))
		{
			Damage = float(RamDamage);
			Destructible = HaloDestructibleActor(Other);
			// End:0xF7
			if((Destructible != none) && Destructible.bBlocksRam!)
			{
				Damage = float(Max(int(Damage), Destructible.Health));
				shouldExit = false;				
			}
			else
			{
				shouldExit = true;
			}
			// End:0x140
			if(Other.IsA('Pawn'))
			{
				Other.SetPhysics(2);
			}
			Momentum = Normal(Other.Location - Location) * RamDamageMomentum;
			Momentum.Z = 0.2000000 * RamDamageMomentum;
			Other.TakeDamage(int(Damage), Controller, HitLocation, Momentum, Class'MegaHaloGame.HaloDamageType_Ram',, self);
			HaloOther = HaloPawn(Other);
			// End:0x291
			if(HaloOther != none)
			{
				HaloOther.PlayMeleeDamageSound(((HaloWeapon(Weapon) != none) ? HaloWeapon(Weapon).akWeaponType : 'Unarmed'));
			}
			// End:0x2B3
			if(MeleeTarget == Other)
			{
				MeleeTarget = none;
			}
			// End:0x2D3
			if(shouldExit)
			{
				GotoExitState(RamHitActorAnimName);
			}
		}
		//return;		
	}

	event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
	{
		super(Actor).Bump(Other, OtherComp, HitNormal);
		HurtActor(Other, Other.Location, HitNormal);
		//return;		
	}

	event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
	{
		super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
		HurtActor(Other, HitLocation, HitNormal);
		//return;		
	}

	event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
	{
		local HaloDestructibleActor Destructible;
		local Rotator R;

		Destructible = HaloDestructibleActor(Wall);
		// End:0x53
		if((Destructible != none) && Destructible.bBlocksRam!)
		{
			return;
		}
		super(Actor).HitWall(HitNormal, Wall, WallComp);
		Velocity -= (((1.0000000 + RamHitWallBounce) * (HitNormal Dot Velocity)) * HitNormal);
		Velocity.Z += RamHitWallImpulseZ;
		SetPhysics(2);
		R = Rotator(HitNormal-);
		R.Pitch = 0;
		R.Roll = 0;
		SetRotation(R);
		SetDesiredRotation(R);
		// End:0x186
		if(Controller != none)
		{
			Controller.SetRotation(R);
		}
		GotoExitState(RamHitWallAnimName);
		//return;		
	}

	function GotoExitState(name AnimName)
	{
		local float Duration;

		// End:0x39
		if(RamFx != none)
		{
			RamFx.DeactivateSystem();
			RamFx = none;
		}
		Duration = PlayCustomAnimation(AnimName, true, false);
		SetTimer(Duration);
		// End:0x94
		if(RamHitSoundEvent != none)
		{
			PlayAkEvent(RamHitSoundEvent);
		}
		NetworkGotoState('Ramming_Exit');
		//return;		
	}
	stop;	
}

simulated state Ramming_Exit extends Ramming_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		// End:0x75
		if(int(Physics) == int(2))
		{
			Velocity.X *= RamToFallSpeedScale;
			Velocity.Y *= RamToFallSpeedScale;
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		local HaloPlayerPawnController C;

		NotifyMeleeDone();
		C = HaloPlayerPawnController(Controller);
		// End:0x6C
		if((C != none) && int(C.bFireButtonState) > int(0))
		{
			global.StartFire(0);
		}
		super.EndState(NextStateName);
		//return;		
	}

	function Timer()
	{
		NetworkGotoState('None');
		//return;		
	}
	stop;	
}

simulated state LeapAttack_Base
{
	ignores LeapAttack, RamAttack, ThrowGrenade, StopFire, StartFire;

	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool IsLeaping()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		IgnoreMoveInput(true);
		//return;		
	}

	event EndState(name NextStateName)
	{
		IgnoreMoveInput(false);
		//return;		
	}

	function bool DoJump(bool isUpdating)
	{
		return false;
		//return ReturnValue;		
	}

	function NotifyMeleeDone()
	{
		local HaloWeapon_Melee W;

		W = HaloWeapon_Melee(Weapon);
		// End:0x4A
		if(W != none)
		{
			W.OnMeleeDone();
		}
		//return;		
	}
	stop;	
}

simulated state LeapAttack_Start extends LeapAttack_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		TimerLowerGun();
		LerpLocStart = Location;
		LerpLocEnd = Location + (Vector(Rotation) * CurLeapDesc.TargetRange);
		NetworkGotoState('LeapAttack_Loop');
		//return;		
	}
	stop;	
}

simulated state LeapAttack_Loop extends LeapAttack_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		PlayCustomAnimation(CurLeapDesc.AnimNameLoop, true, true,,, 0.1000000);
		PlayAkEvent(RamSoundEvent);
		SetTimer(CurLeapDesc.LoopDuration);
		bDirectHitWall = true;
		//return;		
	}

	event EndState(name NextStateName)
	{
		bDirectHitWall = default.bDirectHitWall;
		MeleeTarget = none;
		super.EndState(NextStateName);
		//return;		
	}

	function Timer()
	{
		StopCustomAnimation(true, RamMissDuration);
		SetTimer(RamMissDuration);
		NetworkGotoState('LeapAttack_Exit');
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local float T;

		// End:0x5A
		if(MeleeTarget != none)
		{
			LerpLocEnd = MeleeTarget.Location;
			LerpLocEnd.Z += 100.0000000;
		}
		T = GetTimerRate() - GetTimerCount();
		// End:0xF2
		if(T > 0.0001000)
		{
			Velocity = (LerpLocEnd - Location) / T;
			Velocity.Z -= ((GetGravityZ()) * T);
			SetPhysics(2);
		}
		super(HaloPawn).Tick(DeltaTime);
		//return;		
	}

	function HurtActor(Actor Other, Vector HitLocation, Vector HitNormal)
	{
		local Vector Momentum;
		local HaloPawn HaloOther;
		local HaloDestructibleActor Destructible;
		local float Damage;
		local bool shouldExit;

		// End:0x35
		if((Other == none) || Other.bStatic)
		{
			return;
		}
		// End:0x2F9
		if(IsBlockedBy(Other))
		{
			Damage = float(CurLeapDesc.Damage);
			Destructible = HaloDestructibleActor(Other);
			// End:0x10A
			if((Destructible != none) && Destructible.bBlocksRam!)
			{
				Damage = float(Max(int(Damage), Destructible.Health));
				shouldExit = false;				
			}
			else
			{
				shouldExit = true;
			}
			// End:0x153
			if(Other.IsA('Pawn'))
			{
				Other.SetPhysics(2);
			}
			Momentum = Normal(Other.Location - Location) * RamDamageMomentum;
			Momentum.Z = 0.2000000 * RamDamageMomentum;
			Other.TakeDamage(int(Damage), Controller, HitLocation, Momentum, CurLeapDesc.DamageType,, self);
			HaloOther = HaloPawn(Other);
			// End:0x2B7
			if(HaloOther != none)
			{
				HaloOther.PlayMeleeDamageSound(((HaloWeapon(Weapon) != none) ? HaloWeapon(Weapon).akWeaponType : 'Unarmed'));
			}
			// End:0x2D9
			if(MeleeTarget == Other)
			{
				MeleeTarget = none;
			}
			// End:0x2F9
			if(shouldExit)
			{
				GotoExitState(RamHitActorAnimName);
			}
		}
		//return;		
	}

	event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
	{
		super(Actor).Bump(Other, OtherComp, HitNormal);
		HurtActor(Other, Other.Location, HitNormal);
		//return;		
	}

	event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
	{
		super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
		HurtActor(Other, HitLocation, HitNormal);
		//return;		
	}

	event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
	{
		local HaloDestructibleActor Destructible;
		local Rotator R;

		Destructible = HaloDestructibleActor(Wall);
		// End:0x53
		if((Destructible != none) && Destructible.bBlocksRam!)
		{
			return;
		}
		super(Actor).HitWall(HitNormal, Wall, WallComp);
		Velocity -= (((1.0000000 + RamHitWallBounce) * (HitNormal Dot Velocity)) * HitNormal);
		Velocity.Z += RamHitWallImpulseZ;
		SetPhysics(2);
		R = Rotator(HitNormal-);
		R.Pitch = 0;
		R.Roll = 0;
		SetRotation(R);
		SetDesiredRotation(R);
		// End:0x186
		if(Controller != none)
		{
			Controller.SetRotation(R);
		}
		GotoExitState(RamHitWallAnimName);
		//return;		
	}

	function GotoExitState(name AnimName)
	{
		local float Duration;

		// End:0x39
		if(RamFx != none)
		{
			RamFx.DeactivateSystem();
			RamFx = none;
		}
		Duration = PlayCustomAnimation(AnimName, true, false);
		SetTimer(Duration);
		// End:0x94
		if(RamHitSoundEvent != none)
		{
			PlayAkEvent(RamHitSoundEvent);
		}
		NetworkGotoState('LeapAttack_Exit');
		//return;		
	}
	stop;	
}

simulated state LeapAttack_Exit extends LeapAttack_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		// End:0x75
		if(int(Physics) == int(2))
		{
			Velocity.X *= RamToFallSpeedScale;
			Velocity.Y *= RamToFallSpeedScale;
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		local HaloPlayerPawnController C;

		NotifyMeleeDone();
		C = HaloPlayerPawnController(Controller);
		// End:0x6C
		if((C != none) && int(C.bFireButtonState) > int(0))
		{
			global.StartFire(0);
		}
		super.EndState(NextStateName);
		//return;		
	}

	function Timer()
	{
		NetworkGotoState('None');
		//return;		
	}
	stop;	
}

state ThrowingGrenade
{
	ignores ThrowGrenade, StopFire, StartFire;

	simulated function bool IsThrowingGrenade()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		local HaloWeapon W;
		local name AnimName;
		local float AnimTime;

		global.StopFire(0);
		SetIsFiring(true);
		W = HaloWeapon(Weapon);
		// End:0x6D
		if(W != none)
		{
			AnimName = W.ThrowGrenadePawnAnimName;			
		}
		else
		{
			AnimName = Class'MegaHaloGame.HaloWeapon'.default.ThrowGrenadePawnAnimName;
		}
		AnimTime = PlayCustomAnimation(AnimName, false);
		// End:0xE6
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime, false, 'OnAnimDone');			
		}
		else
		{
			ThrowGrenadeNow();
			OnAnimDone();
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		local HaloPlayerPawnController C;

		// End:0x3B
		if(IsTimerActive('OnAnimDone'))
		{
			ClearTimer('OnAnimDone');
			StopCustomAnimation(false, 0.1500000);
		}
		SetIsFiring(false);
		C = HaloPlayerPawnController(Controller);
		// End:0xA8
		if((C != none) && int(C.bFireButtonState) > int(0))
		{
			global.StartFire(0);
		}
		//return;		
	}

	function RamAttack(optional Actor Target)
	{
		StopCustomAnimation(false);
		super(HaloPawn).RamAttack(Target);
		//return;		
	}

	function LeapAttack(HaloLeapAttackDesc Desc, optional Actor Target)
	{
		StopCustomAnimation(false);
		super(HaloPawn).LeapAttack(Desc, Target);
		//return;		
	}

	function OnAnimDone()
	{
		NetworkGotoState('None');
		//return;		
	}

	function ThrowGrenadeNow()
	{
		super(HaloPawn).ThrowGrenadeNow();
		SetIsFiring(false);
		//return;		
	}
	stop;	
}

state AttachingToVehicle
{
	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	function BeginState(name PrevState)
	{
		AttachToVehicleStartLoc = Location;
		AttachToVehicleStartRot = QuatFromRotator(Rotation);
		SetCollision(false, false);
		bCollideWorld = false;
		SetBase(none);
		SetPhysics(0);
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local Vehicle V;
		local HaloWeaponPawn WP;
		local Vector endLoc;
		local Quat EndRot;
		local float T, tz;
		local Vector MidLoc;

		// End:0x453
		if((Owner != none) && IsTimerActive('AttachToVehicleNow'))
		{
			V = Vehicle(Owner);
			// End:0xA6
			if(V != none)
			{
				WP = HaloWeaponPawn(V);
				// End:0xA6
				if(WP != none)
				{
					V = WP.MyVehicle;
				}
			}
			// End:0x209
			if(V != none)
			{
				// End:0x185
				if((V.Mesh != none) && AttachToVehicleSeatBone != 'None')
				{
					endLoc = V.Mesh.GetBoneLocation(AttachToVehicleSeatBone);
					EndRot = V.Mesh.GetBoneQuaternion(AttachToVehicleSeatBone);					
				}
				else
				{
					endLoc = V.Location;
					EndRot = QuatFromRotator(V.Rotation);
				}
				endLoc += QuatRotateVector(EndRot, AttachToVehicleSeatOffset);				
			}
			else
			{
				endLoc = Owner.Location;
				EndRot = QuatFromRotator(Owner.Rotation);
			}
			T = GetTimerCount('AttachToVehicleNow') / GetTimerRate('AttachToVehicleNow');
			tz = FMin(1.0000000, 1.5000000 * T);
			tz = tz * (2.0000000 - tz);
			MidLoc.X = Lerp(AttachToVehicleStartLoc.X, endLoc.X, T);
			MidLoc.Y = Lerp(AttachToVehicleStartLoc.Y, endLoc.Y, T);
			MidLoc.Z = Lerp(AttachToVehicleStartLoc.Z, endLoc.Z, tz);
			SetLocation(MidLoc);
			SetRotation(QuatToRotator(QuatSlerp(AttachToVehicleStartRot, EndRot, T, true)));
			SetDesiredRotation(Rotation);
		}
		global.Tick(DeltaTime);
		//return;		
	}

	function bool AttachToVehicleNow(optional Vehicle passedInV)
	{
		// End:0x27
		if(global.AttachToVehicleNow(passedInV))
		{
			GotoState('None');
			return true;
		}
		return false;
		//return ReturnValue;		
	}
	stop;	
}

simulated state ExitingVehicle
{
	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		// End:0x55
		if(FullBodyAnimSlot != none)
		{
			FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
			Mesh.RootMotionMode = 4;
		}
		ExitingVehicleStartRot = Rotation;
		ExitingVehicleRotDuration = -1.0000000;
		//return;		
	}

	event EndState(name NextStateName)
	{
		local HaloPlayerPawnController C;

		DriverLeaveNow();
		// End:0x5C
		if(FullBodyAnimSlot != none)
		{
			FullBodyAnimSlot.SetRootBoneAxisOption();
			Mesh.RootMotionMode = 0;
		}
		C = HaloPlayerPawnController(Controller);
		// End:0xA6
		if(C != none)
		{
			C.OnExitingVehicleEnd();
		}
		//return;		
	}

	function DetachFromVehicle()
	{
		ExitingVehicleRotDuration = GetTimerRate('OnAnimDone') - GetTimerCount('OnAnimDone');
		//return;		
	}

	function OnAnimDone()
	{
		GotoState('None');
		//return;		
	}

	function DriverLeaveNow()
	{
		local Vehicle V;
		local HaloVehicleInterface HV;
		local Vector Vel;

		V = Vehicle(Owner);
		// End:0xD0
		if(V != none)
		{
			Vel = Velocity;
			HV = HaloVehicleInterface(V);
			// End:0x9D
			if(NotEqual_InterfaceInterface(HV, HaloVehicleInterface(none)))
			{
				HV.DriverLeaveNow();				
			}
			else
			{
				V.DriverLeave(true);
			}
			Velocity = Vel;
		}
		//return;		
	}

	function TickVelocity(float DeltaTime)
	{
		local Vector Loc, deltaLoc;

		Loc = Location;
		deltaLoc = Loc - ExitingVehiclePrevLoc;
		ExitingVehiclePrevLoc = Loc;
		Velocity = deltaLoc / DeltaTime;
		//return;		
	}

	function TickRotation(float DeltaTime)
	{
		local float T;
		local Rotator targRot, targRelRot;

		// End:0x116
		if(ExitingVehicleRotDuration >= 0.0000000)
		{
			T = ExitingVehicleRotDuration - (GetTimerRate('OnAnimDone') - GetTimerCount('OnAnimDone'));
			T = FMax(0.0000000, T / ExitingVehicleRotDuration);
			targRot.Yaw = ExitingVehicleStartRot.Yaw;
			targRelRot = targRot - ExitingVehicleStartRot;
			targRelRot = RLerp(rot(0, 0, 0), targRelRot, T, true);
			SetRelativeRotation(targRelRot);
		}
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		super(HaloPawn).Tick(DeltaTime);
		TickVelocity(DeltaTime);
		TickRotation(DeltaTime);
		//return;		
	}

	function bool PlaceExitingDriver(Vehicle V)
	{
		// End:0x28
		if(global.PlaceExitingDriver(V))
		{
			StopCustomAnimation(true, 0.0000000);
			return true;
		}
		return false;
		//return ReturnValue;		
	}
	stop;	
}

simulated state ExitingTurret
{
	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function BeginExitingTurretState(name AnimName, Controller C, Rotator rotStart, Rotator rotEnd, Vector Pivot)
	{
		local float animDuration;
		local HaloPlayerPawnController PC;

		PC = HaloPlayerPawnController(C);
		// End:0x4A
		if(PC != none)
		{
			PC.OnExitingVehicleBegin();
		}
		ExitTurretInterpDuration = 0.0000000;
		ExitTurretRotStart = rotStart;
		ExitTurretRotEnd = rotEnd;
		ExitTurretPivot = Pivot;
		ExitTurretOffset = (Location - Pivot) << ExitTurretRotStart;
		SetBase(none);
		SetPhysics(0);
		// End:0x151
		if(ExitTurretInterpDuration <= 0.0000000)
		{
			SetLocation((ExitTurretOffset >> ExitTurretRotEnd) + ExitTurretPivot);
			SetRotation(ExitTurretRotEnd);
			SetDesiredRotation(Rotation);
			// End:0x151
			if(Controller != none)
			{
				Controller.SetRotation(Rotation);
			}
		}
		animDuration = PlayCustomAnimation(AnimName, true, false,,, ExitTurretInterpDuration, 0.2000000);
		// End:0x1CA
		if(animDuration > float(0))
		{
			SetTimer(animDuration, false, 'OnAnimDone');
			SetTimer(animDuration * 0.5000000, false, 'DriverLeaveNow');			
		}
		else
		{
			DriverLeaveNow();
			OnAnimDone();
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		local HaloPlayerPawnController PC;

		DriverLeaveNow();
		PC = HaloPlayerPawnController(Controller);
		// End:0x54
		if(PC != none)
		{
			PC.OnExitingVehicleEnd();
		}
		//return;		
	}

	function OnAnimDone()
	{
		GotoState('None');
		//return;		
	}

	function DriverLeaveNow()
	{
		local Vehicle V;
		local HaloVehicleInterface HV;

		V = Vehicle(Owner);
		// End:0xAA
		if(V != none)
		{
			HV = HaloVehicleInterface(V);
			// End:0x8A
			if(NotEqual_InterfaceInterface(HV, HaloVehicleInterface(none)))
			{
				HV.DriverLeaveNow();				
			}
			else
			{
				V.DriverLeave(true);
			}
		}
		SetPhysics(1);
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local float T;
		local Rotator R;

		// End:0xFC
		if(ExitTurretInterpDuration > 0.0000000)
		{
			T = GetTimerCount('OnAnimDone') / ExitTurretInterpDuration;
			T = FMin(1.0000000, T);
			R = RLerp(ExitTurretRotStart, ExitTurretRotEnd, T, true);
			SetLocation((ExitTurretOffset >> R) + ExitTurretPivot);
			SetRotation(R);
			SetDesiredRotation(R);
			// End:0xFC
			if(Controller != none)
			{
				Controller.SetRotation(R);
			}
		}
		global.Tick(DeltaTime);
		//return;		
	}
	stop;	
}

state TakedownBase
{
	ignores TakeDamage, LeapAttack, RamAttack, ThrowGrenade, StopFire, StartFire;

	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		NotifyTakedownDown(true);
		IgnoreMoveInput(true);
		LerpLocStart = Location;
		LerpRotStart = QuatFromRotator(Rotation);
		SetTimer(CurTakedownDesc.LerpTime, false, 'Takedown_Timer');
		bDirectHitWall = false;
		bTakedownSyncsRootMotionCollision = true;
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x30
		if(Mesh != none)
		{
			Mesh.RootMotionMode = 0;
		}
		TakedownPartner = none;
		MeleeTarget = none;
		ShowWeapon();
		IgnoreMoveInput(false);
		NotifyTakedownDown(false);
		//return;		
	}

	function OnAnimDone()
	{
		GotoState('None');
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local float T;

		// End:0xB1
		if(IsTimerActive('Takedown_Timer'))
		{
			T = GetTimerCount('Takedown_Timer') / GetTimerRate('Takedown_Timer');
			Move(VLerp(LerpLocStart, LerpLocEnd, T) - Location);
			SetRotation(QuatToRotator(QuatSlerp(LerpRotStart, LerpRotEnd, T, true)));
		}
		SetDesiredRotation(Rotation);
		// End:0xF8
		if(Controller != none)
		{
			Controller.SetRotation(Rotation);
		}
		global.Tick(DeltaTime);
		//return;		
	}

	simulated function Takedown_Timer()
	{
		Move(LerpLocEnd - Location);
		SetRotation(QuatToRotator(LerpRotEnd));
		SetDesiredRotation(Rotation);
		// End:0x74
		if(Controller != none)
		{
			Controller.SetRotation(Rotation);
		}
		//return;		
	}

	simulated function Takedown_EnableRootMotion(bool enableZAxis)
	{
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		SetPhysics(4);
		// End:0xAA
		if((Mesh != none) && FullBodyAnimSlot != none)
		{
			Mesh.RootMotionMode = 0;
			FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, ((enableZAxis) ? 2 : 0));
		}
		//return;		
	}

	function bool DoJump(bool isUpdating)
	{
		return false;
		//return ReturnValue;		
	}

	function bool CheckForLedgeGrab()
	{
		return false;
		//return ReturnValue;		
	}

	simulated function Takedown_StopRootMotionCollisionSyncing()
	{
		bTakedownSyncsRootMotionCollision = false;
		//return;		
	}

	simulated event OnRootMotionCollision(Vector adjustment)
	{
		// End:0x3F
		if(bTakedownSyncsRootMotionCollision && TakedownPartner != none)
		{
			TakedownPartner.Move(adjustment);
		}
		//return;		
	}
	stop;	
}

state TakedownAsAttacker extends TakedownBase
{
	function bool ReadyForTakedown()
	{
		return false;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		local Vector ToTarget, Offset;

		super.BeginState(PrevStateName);
		global.StopFire(0);
		TimerLowerGun();
		// End:0x51
		if(TakeDownSoundEvent != none)
		{
			PlayAkEvent(TakeDownSoundEvent);
		}
		ToTarget = TakedownPartner.Location - Location;
		ToTarget.Z = 0.0000000;
		// End:0x13E
		if(IsZero(ToTarget)!)
		{
			ToTarget = Normal(ToTarget);
			Offset = CurTakedownDesc.TargetDistance * ToTarget;
			Offset += (CurTakedownDesc.MyRightOffset * (ToTarget Cross vect(0.0000000, 0.0000000, 1.0000000)));
		}
		LerpLocEnd = TakedownPartner.Location - Offset;
		LerpLocEnd.Z = FMax(Location.Z, (TakedownPartner.Location.Z - TakedownPartner.GetCollisionHeight()) + (GetCollisionHeight()));
		LerpRotEnd = QuatFromRotator(Rotator(Offset));
		OnTakedown();
		//return;		
	}

	event EndState(name NextStateName)
	{
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		super.EndState(NextStateName);
		//return;		
	}

	simulated function Takedown_Timer()
	{
		local float AnimTime;

		super.Takedown_Timer();
		AnimTime = PlayCustomAnimation(CurTakedownDesc.MyAnimName,,,,, CurTakedownDesc.BlendInTime, CurTakedownDesc.BlendOutTime);
		// End:0xAF
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime, false, 'OnAnimDone');
			Takedown_EnableRootMotion(false);			
		}
		else
		{
			OnAnimDone();
		}
		//return;		
	}
	stop;	
}

state TakedownAsTarget extends TakedownBase
{
	ignores SpawnDefaultHitFX;

	event BeginState(name PrevStateName)
	{
		local Vector Offset;
		local CCSController AIController;

		super.BeginState(PrevStateName);
		AIController = CCSController(Controller);
		// End:0x5E
		if(AIController != none)
		{
			AIController.DisableBrain(true);
		}
		Offset = Location - TakedownPartner.Location;
		Offset.Z = 0.0000000;
		LerpLocEnd = Location;
		LerpLocEnd.Z = FMax(Location.Z, (TakedownPartner.Location.Z - TakedownPartner.GetCollisionHeight()) + (GetCollisionHeight()));
		LerpRotEnd = QuatFromRotator(Rotator(Offset));
		SetCollisionType(1);
		//return;		
	}

	event EndState(name NextStateName)
	{
		Takedown_DieNow();
		super.EndState(NextStateName);
		//return;		
	}

	simulated function Takedown_Timer()
	{
		local float AnimTime;

		super.Takedown_Timer();
		AnimTime = PlayCustomAnimation(CurTakedownDesc.TargetAnimName,,,,, CurTakedownDesc.BlendInTime);
		// End:0xB0
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime, false, 'OnAnimDone');
			Takedown_EnableRootMotion(CurTakedownDesc.bTargetUsesRootMotionOnZAxis);			
		}
		else
		{
			OnAnimDone();
		}
		//return;		
	}

	simulated function Takedown_EnableHitWall()
	{
		bDirectHitWall = true;
		//return;		
	}

	simulated function Takedown_DieNow()
	{
		// End:0xDE
		if(Health > 0)
		{
			Velocity += Mesh.RootMotionVelocity;
			// End:0x6B
			if(SuitShield != none)
			{
				SuitShield.Shield = 0.0000000;
			}
			global.TakeDamage(Health, TakedownPartner.Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'MegaHaloGame.HaloDamageType_Melee',, TakedownPartner);
			// End:0xDE
			if(Health > 0)
			{
				Suicide();
			}
		}
		//return;		
	}

	function DieFromCollision()
	{
		Velocity *= 0.5000000;
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		Takedown_DieNow();
		//return;		
	}

	event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
	{
		DieFromCollision();
		//return;		
	}

	simulated event OnRootMotionCollision(Vector adjustment)
	{
		// End:0x1A
		if(bDirectHitWall)
		{
			DieFromCollision();			
		}
		else
		{
			super.OnRootMotionCollision(adjustment);
		}
		//return;		
	}
	stop;	
}

simulated state LedgeGrab_Base
{
	ignores LeapAttack, RamAttack, ThrowGrenade;

	simulated function bool IsGrabbingLedge()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PrevStateName)
	{
		bNoWeaponFiring = true;
		HideWeapon();
		//return;		
	}

	event EndState(name NextStateName)
	{
		ShowWeapon();
		bNoWeaponFiring = false;
		//return;		
	}

	function ExitLedgeGrab(bool StopAnim, optional bool Jumping)
	{
		// End:0x1E
		if(StopAnim)
		{
			StopCustomAnimation(true, 0.0000000);
		}
		// End:0x37
		if(int(Physics) == int(4))
		{
			SetPhysics(2);
		}
		NotifyLedgeGrab(false, Jumping);
		NetworkGotoState('None');
		//return;		
	}

	function NotifyLedgeGrab(bool ledgeGrabEnabled, optional bool Jumping)
	{
		local HaloPlayerPawnController C;

		C = HaloPlayerPawnController(Controller);
		// End:0x5F
		if(C != none)
		{
			C.NotifyLedgeGrab(ledgeGrabEnabled, Jumping);
		}
		//return;		
	}

	function float GetCustomAnimNotifyTime(name FuncName)
	{
		local AnimNodeSequence Node;
		local AnimNotifyEvent NotifyEvent;
		local AnimNotify_Script Notify;

		// End:0x16F
		if(FullBodyAnimSlot != none)
		{
			Node = FullBodyAnimSlot.GetCustomAnimNodeSeq();
			// End:0x16F
			if((Node != none) && Node.AnimSeq != none)
			{
				// End:0x16E
				foreach Node.AnimSeq.Notifies(NotifyEvent)
				{
					Notify = AnimNotify_Script(NotifyEvent.Notify);
					// End:0x16D
					if((Notify != none) && Notify.NotifyName == FuncName)
					{						
						return NotifyEvent.Time / Node.AnimSeq.RateScale;
					}					
				}				
			}
		}
		return 0.1000000;
		//return ReturnValue;		
	}

	function bool DoJump(bool isUpdating)
	{
		return false;
		//return ReturnValue;		
	}

	function bool CheckForLedgeGrab()
	{
		return false;
		//return ReturnValue;		
	}
	stop;	
}

simulated state LedgeGrab_JumpToLedge extends LedgeGrab_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		CommonBegin('Ledge_Grab');
		//return;		
	}

	function CommonBegin(name AnimName)
	{
		local float BlendInTime, LerpTime, Duration;

		global.StopFire(0);
		TimerLowerGun();
		BlendInTime = ((int(JumpType) == int(2)) ? 0.0000000 : 0.0100000);
		Duration = PlayCustomAnimation(AnimName, true, false,,, BlendInTime, 0.0000000);
		Duration = FMax(Duration, 0.1000000);
		SetTimer(Duration, false, 'OnAnimDone');
		LerpTime = GetCustomAnimNotifyTime('OnLedgeGripped');
		LerpLocAlpha = 0.0000000;
		LerpLocRate = 1.0000000 / LerpTime;
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		SetPhysics(4);
		NotifyLedgeGrab(true);
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local float tz;
		local Vector MidLoc;

		// End:0x1AE
		if(LerpLocAlpha < 1.0000000)
		{
			LerpLocAlpha = FMin(1.0000000, LerpLocAlpha + (LerpLocRate * DeltaTime));
			tz = 1.0000000 - LerpLocAlpha;
			tz = 1.0000000 - (tz * tz);
			MidLoc.X = Lerp(LerpLocStart.X, LerpLocEnd.X, LerpLocAlpha);
			MidLoc.Y = Lerp(LerpLocStart.Y, LerpLocEnd.Y, LerpLocAlpha);
			MidLoc.Z = Lerp(LerpLocStart.Z, LerpLocEnd.Z, tz);
			SetLocation(MidLoc);
		}
		super(HaloPawn).Tick(DeltaTime);
		//return;		
	}

	function OnAnimDone()
	{
		PlayCustomAnimation('Ledge_Loop', true, true);
		NetworkGotoState('LedgeGrab_Loop');
		//return;		
	}

	function AllowJump()
	{
		NetworkGotoState('LedgeGrab_Loop');
		//return;		
	}

	function TryToAbortJumpToLedge()
	{
		local float S;

		// End:0x15
		if(LerpLocAlpha >= 1.0000000)
		{
			return;
		}
		S = 1.0000000 / LerpLocRate;
		Velocity.X = S * (LerpLocEnd.X - LerpLocStart.X);
		Velocity.Y = S * (LerpLocEnd.Y - LerpLocStart.Y);
		// End:0x19F
		if(LerpLocEnd.Z > Location.Z)
		{
			Velocity.Z = Sqrt((-4.0000000 * (GetGravityZ())) * (LerpLocEnd.Z - Location.Z));			
		}
		else
		{
			Velocity.Z = 0.0000000;
		}
		SetPhysics(2);
		StopCustomAnimation(true, 0.2000000);
		NotifyLedgeGrab(false);
		NetworkGotoState('None');
		//return;		
	}
	stop;	
}

simulated state LedgeGrab_FallToLedge extends LedgeGrab_JumpToLedge
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		CommonBegin('Ledge_Fall_Grab');
		//return;		
	}
	stop;	
}

simulated state LedgeGrab_Loop extends LedgeGrab_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		//return;		
	}

	event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		ClearTimer('LetGoOfLedgeNow');
		//return;		
	}

	function bool DoJump(bool bUpdating)
	{
		NetworkGotoState('LedgeGrab_Jump');
		return true;
		//return ReturnValue;		
	}

	function LetGoOfLedge()
	{
		// End:0x2C
		if(IsTimerActive('LetGoOfLedgeNow')!)
		{
			SetTimer(0.1000000, false, 'LetGoOfLedgeNow');
		}
		//return;		
	}

	function LetGoOfLedgeNow()
	{
		NetworkGotoState('LedgeGrab_Drop');
		//return;		
	}

	function OnAnimDone()
	{
		PlayCustomAnimation('Ledge_Loop', true, true);
		//return;		
	}
	stop;	
}

simulated state LedgeGrab_Drop extends LedgeGrab_Base
{
	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		PlayAkEvent(AkEvent'Foley.Play_Movement_Detach');
		SetPhysics(2);
		SetJumpType(3, false);
		StopCustomAnimation(true, 0.2000000);
		SetTimer(0.1500000, false, 'OnAnimDone');
		//return;		
	}

	function OnAnimDone()
	{
		NotifyLedgeGrab(false);
		NetworkGotoState('None');
		//return;		
	}

	function bool CheckForLedgeGrab()
	{
		return global.CheckForLedgeGrab();
		//return ReturnValue;		
	}
	stop;	
}

simulated state LedgeGrab_Jump extends LedgeGrab_Base
{
	event BeginState(name PrevStateName)
	{
		local float Duration;

		super.BeginState(PrevStateName);
		PlayAkEvent(AkEvent'Foley.Play_Movement_PullUp');
		SetJumpType(3, false);
		StartDoubleJumpCooldown();
		Duration = PlayCustomAnimation('Ledge_Up', true, false);
		// End:0xCD
		if((Mesh != none) && FullBodyAnimSlot != none)
		{
			Mesh.RootMotionMode = 3;
			FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 2);
		}
		PlayJumpingSound();
		Duration = FMax(Duration, 0.1000000);
		SetTimer(Duration, false, 'DoJumpNow');
		//return;		
	}

	event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		// End:0x43
		if(Mesh != none)
		{
			Mesh.RootMotionMode = 0;
		}
		ClearTimer('DoJumpNow');
		//return;		
	}

	function DoJumpNow()
	{
		// End:0x66
		if((Mesh != none) && FullBodyAnimSlot != none)
		{
			Mesh.RootMotionMode = 0;
			FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
		}
		global.DoJumpNow();
		ExitLedgeGrab(false, true);
		//return;		
	}
	stop;	
}

simulated state KnockedDown_Base
{
	ignores LeapAttack, RamAttack, ThrowGrenade, StartFire;

	simulated function bool IsBusy()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool IsKnockedDown()
	{
		return true;
		//return ReturnValue;		
	}

	simulated event BeginState(name PrevStateName)
	{
		// End:0x20
		if(int(Role) == int(ROLE_Authority))
		{
			bIsKnockedDown = true;
		}
		IgnoreMoveInput(true);
		bNoWeaponFiring = true;
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		IgnoreMoveInput(false);
		bNoWeaponFiring = default.bNoWeaponFiring;
		// End:0x40
		if(int(Role) == int(ROLE_Authority))
		{
			bIsKnockedDown = false;
		}
		//return;		
	}

	function bool DoJump(bool isUpdating)
	{
		return false;
		//return ReturnValue;		
	}

	simulated function AbortKnockdown()
	{
		local UTWeapon UTWeap;

		RestorePreRagdollCollisionComponent();
		Mesh.PhysicsWeight = 0.0000000;
		Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;
		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
		Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
		SetPawnRBChannels(false);
		Mesh.bUpdateKinematicBonesFromAnimation = true;
		CylinderComponent.SetActorCollision(true, true);
		Mesh.SetActorCollision(false, false);
		Mesh.SetTraceBlocking(false, false);
		Mesh.SetTickGroup(0);
		// End:0x1A9
		if(int(Physics) == int(10))
		{
			SetPhysics(2);
		}
		UTWeap = UTWeapon(Weapon);
		// End:0x1F3
		if(UTWeap != none)
		{
			UTWeap.PlayWeaponEquip();
		}
		NotifyKnockedDown(false);
		//return;		
	}

	simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
	{
		AbortKnockdown();
		bIsKnockedDown = false;
		global.PlayDying(DamageType, HitLoc, Killer);
		//return;		
	}
	stop;	
}

simulated state KnockedDown_Start extends KnockedDown_Base
{
	simulated event BeginKnockdownState(int I, Vector HitVec)
	{
		local float Duration;

		NotifyKnockedDown(true);
		KnockedDownRecoverTime = WorldInfo.TimeSeconds + RandRange(KnockdownBehaviors[I].MinRecoverTime, KnockdownBehaviors[I].MaxRecoverTime);
		// End:0xEC
		if(KnockdownBehaviors[I].bSnapDirection)
		{
			SetRotation(Rotator(HitVec << KnockdownBehaviors[I].rDirection));
		}
		global.StopFire(0);
		TimerLowerGun();
		SetPhysics(4);
		Duration = PlayCustomAnimation(KnockdownBehaviors[I].AnimName);
		// End:0x1CA
		if(Duration > 0.0000000)
		{
			SetTimer(Duration, false, 'OnAnimDone');
			// End:0x1C7
			if(FullBodyAnimSlot != none)
			{
				FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
				Mesh.RootMotionMode = 3;
			}			
		}
		else
		{
			OnAnimDone();
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		// End:0x6A
		if((NextStateName != 'KnockedDown_Start') && NextStateName != 'KnockedDown_Ragdoll')
		{
			// End:0x5F
			if(Health > 0)
			{
				AbortKnockdown();				
			}
			else
			{
				NotifyKnockedDown(false);
			}
		}
		//return;		
	}

	simulated event OnAnimDone()
	{
		GotoState('KnockedDown_Ragdoll');
		//return;		
	}

	simulated function SyncKnockedDownState()
	{
		// End:0x31
		if(int(Role) > int(ROLE_Authority))
		{
			// End:0x31
			if(bIsKnockedDown!)
			{
				GotoState('None');
			}
		}
		//return;		
	}

	simulated function AbortKnockdown()
	{
		ClearTimer('OnAnimDone');
		Mesh.RootMotionMode = 0;
		NotifyKnockedDown(false);
		//return;		
	}
	stop;	
}

simulated state KnockedDown_Ragdoll extends KnockedDown_Base
{
	simulated event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		StartFallImpactTime = WorldInfo.TimeSeconds;
		bCanPlayFallingImpacts = true;
		// End:0x60
		if(int(Physics) == int(10))
		{
			SetPhysics(2);
		}
		Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
		SetPawnRBChannels(true);
		Mesh.ForceSkelUpdate();
		Mesh.SetTickGroup(2);
		bBlendOutTakeHitPhysics = false;
		PreRagdollCollisionComponent = CollisionComponent;
		CollisionComponent = Mesh;
		CylinderComponent.SetActorCollision(false, false);
		Mesh.SetActorCollision(true, true);
		Mesh.SetTraceBlocking(true, true);
		SetPhysics(10);
		Mesh.PhysicsWeight = 1.0000000;
		// End:0x1D2
		if(Mesh.bNotUpdatingKinematicDueToDistance)
		{
			Mesh.UpdateRBBonesFromSpaceBases(true, true);
		}
		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
		Mesh.bUpdateKinematicBonesFromAnimation = false;
		Mesh.SetRBLinearVelocity(Velocity, false);
		FeignDeathStartTime = WorldInfo.TimeSeconds;
		Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * BaseTranslationOffset);
		Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
		Mesh.SetNotifyRigidBodyCollision(true);
		Mesh.WakeRigidBody();
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		// End:0x43
		if(NextStateName != 'KnockedDown_GetUp')
		{
			// End:0x43
			if(Health > 0)
			{
				AbortKnockdown();
			}
		}
		//return;		
	}

	simulated function SyncKnockedDownState()
	{
		// End:0x31
		if(int(Role) > int(ROLE_Authority))
		{
			// End:0x31
			if(bIsKnockedDown!)
			{
				GotoState('KnockedDown_GetUp');
			}
		}
		//return;		
	}

	simulated event Tick(float DeltaTime)
	{
		super(HaloPawn).Tick(DeltaTime);
		// End:0x69
		if(KnockedDownRecoverTime <= WorldInfo.TimeSeconds)
		{
			// End:0x69
			if(VSizeSq(Velocity) < (100.0000000 * 100.0000000))
			{
				GotoState('KnockedDown_GetUp');
			}
		}
		//return;		
	}

	exec function TestKnockdown()
	{
		GotoState('KnockedDown_GetUp');
		//return;		
	}
	stop;	
}

simulated state KnockedDown_GetUp extends KnockedDown_Base
{
	simulated event BeginState(name NextStateName)
	{
		local Vector HeightVec, HitLoc, HitNorm, TraceStart, TraceEnd, Impulse;

		local bool foundFloor;
		local UTVehicle V;
		local Controller Killer;
		local Vector hipsLoc, headLoc, hipFwd, newFwd;

		super.BeginState(NextStateName);
		HeightVec = vect(0.0000000, 0.0000000, 10.0000000);
		HeightVec.Z += (GetCollisionHeight());
		CollisionComponent = PreRagdollCollisionComponent;
		TraceStart = Location + HeightVec;
		TraceEnd = Location - (2.0000000 * HeightVec);
		// End:0xFC
		if(Trace(HitLoc, HitNorm, TraceEnd, TraceStart, true) != none)
		{
			SetLocation(HitLoc + HeightVec);
			foundFloor = true;
		}
		TraceStart = Location;
		TraceEnd = Location + HeightVec;
		// End:0x17D
		if(Trace(HitLoc, HitNorm, TraceEnd, TraceStart, true) != none)
		{
			CollisionComponent = Mesh;
			Suicide();
			return;
		}
		CollisionComponent = Mesh;
		Mesh.SetNotifyRigidBodyCollision(false);
		SetPhysics(0);
		// End:0x3EA
		if(int(Role) == int(ROLE_Authority))
		{
			CollisionComponent = PreRagdollCollisionComponent;
			// End:0x3D6
			foreach CollidingActors(Class'UTGame.UTVehicle', V, GetCollisionRadius(),, true)
			{
				// End:0x3D5
				if(IsOverlapping(V))
				{
					// End:0x2D5
					if(V.Class == HoverboardClass)
					{
						Impulse = VRand() * V.GroundSpeed;
						Impulse.Z = 500.0000000;
						V.Mesh.AddImpulse(Impulse,,, true);
						// End:0x3D5
						continue;
					}
					CollisionComponent = Mesh;
					// End:0x337
					if(V.Controller != none)
					{
						Killer = V.Controller;						
					}
					else
					{
						// End:0x398
						if(V.Instigator != none)
						{
							Killer = V.Instigator.Controller;
						}
					}
					Died(Killer, V.RanOverDamageType, Location);					
					return;
				}				
			}			
			CollisionComponent = Mesh;
		}
		// End:0x606
		if((KnockdownRecoveryBlend != none) && bIsCrouched!)
		{
			RestorePreRagdollCollisionComponent();
			Mesh.PhysicsWeight = 1.0000000;
			Mesh.RootMotionMode = 3;
			SetPhysics(((foundFloor) ? 1 : 2));
			headLoc = Mesh.GetBoneLocation(HeadBone);
			hipsLoc = Mesh.GetBoneLocation(HipsBone);
			hipFwd = Mesh.GetBoneAxis(HipsBone, 2);
			newFwd = headLoc - hipsLoc;
			newFwd.Z = 0.0000000;
			// End:0x5DB
			if(IsZero(newFwd)!)
			{
				// End:0x595
				if(hipFwd.Z < 0.0000000)
				{
					newFwd = newFwd-;
				}
				SetRotation(Rotator(newFwd));
				Controller.SetRotation(Rotation);
				SetDesiredRotation(Rotation);
			}
			KnockdownRecoveryBlend.SetActiveChildFromForwardVector(hipFwd);			
		}
		else
		{
			AbortKnockdown();
			GotoState('None');
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		Mesh.RootMotionMode = 0;
		// End:0x7A
		if((Health > 0) && Mesh.PhysicsWeight > 0.0000000)
		{
			AbortKnockdown();			
		}
		else
		{
			NotifyKnockedDown(false);
		}
		//return;		
	}

	simulated event Tick(float DeltaTime)
	{
		super(HaloPawn).Tick(DeltaTime);
		// End:0xC5
		if(Mesh.PhysicsWeight > 0.0000000)
		{
			Mesh.PhysicsWeight -= (FeignDeathPhysicsBlendOutSpeed * DeltaTime);
			// End:0xC5
			if(Mesh.PhysicsWeight <= 0.0000000)
			{
				Mesh.PhysicsWeight = 0.0000000;
				PlayRecoveryAnim();
			}
		}
		//return;		
	}

	simulated function PlayRecoveryAnim()
	{
		local UTWeapon UTWeap;

		RestorePreRagdollCollisionComponent();
		Mesh.PhysicsWeight = 0.0000000;
		Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;
		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
		Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
		SetPawnRBChannels(false);
		Mesh.bUpdateKinematicBonesFromAnimation = true;
		CylinderComponent.SetActorCollision(true, true);
		Mesh.SetActorCollision(false, false);
		Mesh.SetTraceBlocking(false, false);
		Mesh.SetTickGroup(0);
		// End:0x1A9
		if(int(Physics) == int(10))
		{
			SetPhysics(2);
		}
		UTWeap = UTWeapon(Weapon);
		// End:0x1F3
		if(UTWeap != none)
		{
			UTWeap.PlayWeaponEquip();
		}
		// End:0x224
		if(KnockdownRecoveryBlend != none)
		{
			KnockdownRecoveryBlend.PlayActiveChild();			
		}
		else
		{
			bNoWeaponFiring = default.bNoWeaponFiring;
			GotoState('Auto');
		}
		//return;		
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		// End:0x34
		if(KnockdownRecoveryBlend != none)
		{
			KnockdownRecoveryBlend.SetActiveChild(0, 0.1500000);
		}
		GotoState('None');
		//return;		
	}

	simulated function AbortKnockdown()
	{
		// End:0x34
		if(KnockdownRecoveryBlend != none)
		{
			KnockdownRecoveryBlend.SetActiveChild(0, 0.0000000);
		}
		super.AbortKnockdown();
		//return;		
	}
	stop;	
}

state Dying
{
	simulated event Tick(float DeltaTime)
	{
		switch(DeathTick)
		{
			// End:0x32
			case 0:
				DeathTick++;
				// End:0x32
				if(TryThrowWeaponOnDeath())
				{
					// End:0xC3
					break;
				}
			// End:0xA6
			case 1:
				DeathTick++;
				// End:0xA3
				if((CollectibleBlokSpawner != none) && CollectibleBlokSpawner.GetWaveIndexToThrow(0.0000000) >= 0)
				{
					CollectibleBlokSpawner.TryToThrowBloks(0.0000000);
					// [Explicit Continue]
					goto J0xC3;
				}
				// End:0xC3
				break;
			// End:0xFFFF
			default:
				// End:0xC3
				if(DeathTick < 0)
				{
					DeathTick++;
				}
				break;
		}
		J0xC3:

		// End:0x14E
		if(bIsFading == false)
		{
			// End:0x14E
			if(bReadyToFade)
			{
				// End:0x142
				if(FadeOutMaterial != none)
				{
					TimeBeforeFadeOut -= DeltaTime;
					// End:0x13F
					if(TimeBeforeFadeOut <= 0.0000000)
					{
						SwapToFadeMaterial();
						LifeSpan = FadeOutDuration;
						bIsFading = true;
					}					
				}
				else
				{
					bIsFading = true;
				}
			}
		}
		//return;		
	}
	stop;	
}

simulated state SwappingWeapon
{
	simulated function bool IsSwappingWeapon()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool BeginSwappingWeaponState(name AnimName)
	{
		local float Duration;

		Duration = PlayCustomAnimation(AnimName, false, false,,, 0.1500000, 0.1500000);
		// End:0x59
		if(Duration > 0.0000000)
		{
			SetTimer(Duration, false, 'OnAnimDone');			
		}
		else
		{
			OnAnimDone();
		}
		return Duration > 0.0000000;
		//return ReturnValue;		
	}

	simulated event EndState(name NextStateName)
	{
		local HaloPlayerInventoryManager playerInvMgr;

		playerInvMgr = HaloPlayerInventoryManager(InvManager);
		// End:0x4A
		if(playerInvMgr != none)
		{
			playerInvMgr.CancelWeaponSwap();
		}
		// End:0x85
		if(IsTimerActive('OnAnimDone'))
		{
			ClearTimer('OnAnimDone');
			StopCustomAnimation(false, 0.1500000);
		}
		//return;		
	}

	function OnAnimDone()
	{
		GotoState('None');
		//return;		
	}
	stop;	
}

simulated state WaitingForWeaponReload
{
	simulated function bool IsReloadingWeapon()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool WaitForWeaponReload()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function OnWeaponReloadDone()
	{
		GotoState('None');
		//return;		
	}

	simulated event BeginState(name PrevStateName)
	{
		super(Object).BeginState(PrevStateName);
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		local HaloWeapon W;

		W = HaloWeapon(Weapon);
		// End:0x4A
		if(W != none)
		{
			W.OwnerStoppedWaitingForReload();
		}
		super(Object).EndState(NextStateName);
		//return;		
	}
	stop;	
}

simulated state PickingUpWeapon
{
	simulated event BeginState(name PrevStateName)
	{
		local float Duration;

		LockController(true);
		Velocity.X = 0.0000000;
		Velocity.Y = 0.0000000;
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		Duration = PlayCustomAnimation('Spartan _PickUpWeapon', true, false,,, 0.1500000, 0.1500000);
		// End:0xBD
		if(Duration > float(0))
		{
			SetTimer(Duration, false, 'OnAnimDone');			
		}
		else
		{
			DoWeaponPickup();
			OnAnimDone();
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		// End:0x27
		if(IsTimerActive('OnAnimDone'))
		{
			StopCustomAnimation(true, 0.1500000);
		}
		LockController(false);
		//return;		
	}

	simulated function DoWeaponPickup()
	{
		local HaloPlayerPawnController C;

		C = HaloPlayerPawnController(Controller);
		// End:0x4A
		if(C != none)
		{
			C.DoWeaponPickup();
		}
		//return;		
	}

	simulated function OnAnimDone()
	{
		ClearTimer('OnAnimDone');
		GotoState('None');
		//return;		
	}
	stop;	
}

simulated state UsingWeaponCloset
{
	simulated event BeginState(name PrevStateName)
	{
		local float Duration;
		local HaloPlayerPawnController C;
		local Vector toCloset;

		LockController(true);
		Velocity.X = 0.0000000;
		Velocity.Y = 0.0000000;
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		Duration = PlayCustomAnimation('Spartan_Pist_Idel_Melee_01', true, false,,, 0.1500000, 0.1500000);
		// End:0xBD
		if(Duration > float(0))
		{
			SetTimer(Duration, false, 'OnAnimDone');			
		}
		else
		{
			OnAnimDone();
		}
		C = HaloPlayerPawnController(Controller);
		// End:0x1A7
		if((C != none) && C.ActiveWeaponCloset != none)
		{
			toCloset = C.ActiveWeaponCloset.Location - Location;
			toCloset.Z = 0.0000000;
			SetRotation(Rotator(toCloset));
			SetDesiredRotation(Rotation);
		}
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		// End:0x2A
		if(IsTimerActive('OnAnimDone'))
		{
			StopCustomAnimation(true, 0.1500000);			
		}
		else
		{
			DoWeaponPickup();
		}
		LockController(false);
		//return;		
	}

	simulated function DoWeaponPickup()
	{
		local HaloPlayerPawnController C;
		local HaloPlayerInventoryManager invMgr;

		C = HaloPlayerPawnController(Controller);
		// End:0x53
		if((C == none) || C.ActiveWeaponCloset == none)
		{
			return;
		}
		invMgr = HaloPlayerInventoryManager(InvManager);
		// End:0x80
		if(invMgr == none)
		{
			return;
		}
		invMgr.PickUpWeaponByClass(C.ActiveWeaponCloset.GetWeaponType(), true);
		C.SetActiveWeaponCloset(none);
		//return;		
	}

	simulated function OnAnimDone()
	{
		ClearTimer('OnAnimDone');
		GotoState('None');
		//return;		
	}
	stop;	
}

defaultproperties
{
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent" class=MegaHaloGame.HaloCollectibleBlokSpawnerComponent
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=5,MaxTotalValue=10)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloPawn.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		BaseThreatVal=5000
		AITargetType=HaloTargetType.TARGET_AGGRESSIVE_MOBILE
		bAITargetable=true
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent" class=MegaHaloGame.HaloTargetableComponent_Pawn
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	PawnType=PlayerPawnType.PPT_Soldier
	PassiveObjectivePrejudice=1.0000000
	PassiveSecondaryPrejudice=1.0000000
	AggressiveStationaryPrejudice=1.0000000
	AggressiveMobilePrejudice=1.0000000
	bExitAnimationExists=true
	bShouldFlashUponPlayerDamage=true
	CustomAnimationReplicate=(AnimName="None",ForceDuration=0.0000000,BlendInTime=0.2000000,BlendOutTime=0.2000000,IsFullBody=true,IsLooping=false,ByteMe=0)
	SprintTime=7.0000000
	SprintGroundSpeed=900.0000000
	WalkingSoundEvent=AkEvent'Foley.Play_Movement_Footstep'
	RunningSoundEvent=AkEvent'Foley.Play_Movement_Footstep'
	JumpingSoundEvent=AkEvent'Foley.Play_Movement_Jump'
	LandingSoundEvent=AkEvent'Foley.Play_Movement_Land'
	FallingSoundEvent=AkEvent'Foley.Play_Movement_Land'
	MeleeImpactSoundEvent=AkEvent'Foley.Play_Melee_Charge_Impact'
	PreviousMaterial="Unknown"
	ZoneCaptureRate=1.0000000
	LandFxFallSpeedThreshold=800.0000000
	GrenadeThrowTargetDistance=2400.0000000
	GrenadeThrowPitchOffset=1200
	DeathBroadcastDistance=5000.0000000
	DamagedBroadcastDistance=5000.0000000
	EventBroadcastClass=Class'MegaHaloGame.HaloPawn'
	GibMomentumScalar=3.0000000
	GibHealthThreshold=-50
	MeleeMomentum=500.0000000
	CurTakedownDesc=(TargetClass=none,MaxRange=250.0000000,MaxAngleOffset=60.0000000,MaxBackAngleOffset=60.0000000,TargetDistance=125.0000000,MyRightOffset=0.0000000,MyAnimName="None",TargetAnimName="None",BlendInTime=0.1000000,BlendOutTime=0.1000000,LerpTime=0.1500000,bTargetUsesRootMotionOnZAxis=false)
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	begin object name="NeedleTarget" class=MegaHaloGame.HaloNeedleTargetComponent
	end object
	NeedleTargetComponent=NeedleTarget
	LedgeGrabOffsetZ=-125.0000000
	LedgeGrabRadius2D=100.0000000
	LedgeGrabToleranceZ=50.0000000
	LedgeGrabToleranceZFromJump=50.0000000
	DefaultHitFxTemplate=ParticleSystem'fx_Char_ALLPurpHit.Effects.fx_Char_ALLPurpHit'
	FadeOutMaterial=MaterialInstanceTimeVarying'Shared_Destruction_Materials.Materials.Master.Destruct_EnemyDestroy_MITV'
	TimeBeforeFadeOut=10.0000000
	FadeOutDuration=1.0000000
	FlashDamageParamName="FresnelIntensity_RD"
	FlashDamageUpdateInterval=0.0500000
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	WeaponSocket="Right_Hand_Socket"
	WeaponSocket2="Left_Hand_Socket"
	HeadBone="Bip001-Head"
	HipsBone="Bip001-Pelvis"
	bReadyToDoubleJump=true
	MultiJumpBoost=-400
	PawnAmbientSound=none
	WeaponAmbientSound=none
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	MaxLeanRoll=0
	FeignDeathPhysicsBlendOutSpeed=5.0000000
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UTGame.Default__UTPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	ControllerClass=none
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=90.0000000
		CollisionRadius=35.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	VehicleCheckRadius=500.0000000
	InventoryManagerClass=Class'MegaHaloGame.HaloPlayerInventoryManager'
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloPawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2"
	end object
	Components[6]=AmbientSoundComponent2
	Components[7]=targetableComponent
	Components[8]=HaloTargetableComponent
	Components[9]=CollectibleBlokSpawnerComponent
	Components[10]=NeedleTarget
	bPhysRigidBodyOutOfWorldCheck=false
	CollisionComponent=CollisionCylinder
}