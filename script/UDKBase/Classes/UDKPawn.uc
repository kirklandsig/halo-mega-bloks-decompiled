class UDKPawn extends GamePawn
	native
	nativereplication
	config(Game)
	implements(CCSPawn);

struct native MaterialImpactEffect
{
	var name MaterialType;
	var SoundCue Sound;
	var array<MaterialInterface> DecalMaterials;
	var float DurationOfDecal;
	var name DecalDissolveParamName;
	var float DecalWidth;
	var float DecalHeight;
	var ParticleSystem ParticleTemplate;

	structdefaultproperties
	{
		MaterialType="None"
		Sound=none
		DecalMaterials=none
		DurationOfDecal=24.0000000
		DecalDissolveParamName="DissolveAmount"
		DecalWidth=0.0000000
		DecalHeight=0.0000000
		ParticleTemplate=none
	}
};

struct native MaterialSoundEffect
{
	var name MaterialType;
	var SoundCue Sound;

	structdefaultproperties
	{
		MaterialType="None"
		Sound=none
	}
};

struct native MaterialParticleEffect
{
	var name MaterialType;
	var ParticleSystem ParticleTemplate;

	structdefaultproperties
	{
		MaterialType="None"
		ParticleTemplate=none
	}
};

struct native DistanceBasedParticleTemplate
{
	var ParticleSystem Template;
	var float MinDistance;

	structdefaultproperties
	{
		Template=none
		MinDistance=0.0000000
	}
};

struct native PlayEmoteInfo
{
	var name EmoteTag;
	var int EmoteID;
	var bool bNewData;

	structdefaultproperties
	{
		EmoteTag="None"
		EmoteID=0
		bNewData=false
	}
};

struct native UTTakeHitInfo
{
	var int Damage;
	var Vector HitLocation;
	var Vector Momentum;
	var Class<DamageType> DamageType;
	var name HitBone;

	structdefaultproperties
	{
		Damage=0
		HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		DamageType=none
		HitBone="None"
	}
};

struct native EmoteInfo
{
	var name CategoryName;
	var name EmoteTag;
	var const localized string EmoteName;
	var name EmoteAnim;
	var bool bVictoryEmote;
	var bool bTopHalfEmote;
	var name Command;
	var bool bRequiresPlayer;

	structdefaultproperties
	{
		CategoryName="None"
		EmoteTag="None"
		EmoteName=""
		EmoteAnim="None"
		bVictoryEmote=false
		bTopHalfEmote=false
		Command="None"
		bRequiresPlayer=false
	}
};

struct native DrivenWeaponPawnInfo
{
	var UDKVehicle BaseVehicle;
	var byte SeatIndex;
	var PlayerReplicationInfo PRI;

	structdefaultproperties
	{
		BaseVehicle=none
		SeatIndex=0
		PRI=none
	}
};

var private native const noexport Pointer VfTable_ICCSPawn;
var bool bReadyToDoubleJump;
var bool bRequiresDoubleJump;
var bool bCanDoubleJump;
var bool bNoJumpAdjust;
var bool bIsHoverboardAnimPawn;
var repnotify bool bFeigningDeath;
var bool bIsKnockedDown;
var bool bIsPanicking;
var bool bShouldCover;
var private bool bInCover;
var bool bNotifyStopFalling;
var repnotify bool bIsInvisible;
var bool bSmoothNetUpdates;
var protected repnotify bool bPuttingDownWeapon;
var bool bPlayingFeignDeathRecovery;
var bool bCanPlayFallingImpacts;
var bool bEnableFootPlacement;
var bool bPostRenderOtherTeam;
var bool bBlendOutTakeHitPhysics;
var bool bUpdateEyeheight;
var bool bTearOffGibs;
var float MaxDoubleJumpHeight;
var int MultiJumpRemaining;
var int MaxMultiJump;
var int MultiJumpBoost;
var int OccupiedCoverCount;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSCoverPose WantedCoverPose;
var CCSPawn.ECCSCoverPose CurrentCoverPose;
var CCSPawn.ECCSAlertnessState AlertnessState;
var repnotify byte BigTeleportCount;
var repnotify byte WeaponOverlayFlags;
var Vector2D AimYawRange;
var Vector2D AimPitchRange;
var float Camo;
var Vector CamoVanishingPoint;
var CCSBTTree DefaultBehaviorTree;
var float YellingDistance;
var private float CoverPct;
var float CoverPoseBlendTimeOverride;
var float CustomGravityScaling;
var repnotify PlayEmoteInfo EmoteRepInfo;
var float LastEmoteTime;
var float MinTimeBetweenEmotes;
var repnotify UTTakeHitInfo LastTakeHitInfo;
var float LastTakeHitTimeout;
var repnotify float FireRateMultiplier;
var repnotify float HeadScale;
var float MaxSmoothNetUpdateDist;
var float NoSmoothNetUpdateDist;
var float SmoothNetUpdateTime;
var Vector MeshTranslationOffset;
var float OldZ;
var protected export editinline AudioComponent PawnAmbientSound;
var protected repnotify SoundCue PawnAmbientSoundCue;
var repnotify DrivenWeaponPawnInfo DrivenWeaponPawn;
var protected export editinline AudioComponent WeaponAmbientSound;
var protected repnotify SoundCue WeaponAmbientSoundCue;
var repnotify Material ReplicatedBodyMaterial;
var protected array<MaterialInstanceConstant> BodyMaterialInstances;
var protected repnotify MaterialInterface OverlayMaterialInstance;
var SkelControlSingleBone RootRotControl;
var AnimNodeAimOffset AimNode;
var GameSkelCtrl_Recoil GunRecoilNode;
var GameSkelCtrl_Recoil LeftRecoilNode;
var GameSkelCtrl_Recoil RightRecoilNode;
var array<UDKBot> Trackers;
var float BodyMatFadeDuration;
var LinearColor CurrentBodyMatColor;
var float RemainingBodyMatDuration;
var repnotify float ClientBodyMatDuration;
var LinearColor BodyMatColor;
var repnotify Rotator CompressedBodyMatColor;
var float StartFallImpactTime;
var name TorsoBoneName;
var SoundCue FallImpactSound;
var float FallSpeedThreshold;
var export editinline StaticMeshComponent BlobShadow;
var protected export editinline SkeletalMeshComponent OverlayMesh;
var name LeftFootBone;
var name RightFootBone;
var name LeftFootControlName;
var name RightFootControlName;
var float BaseTranslationOffset;
var float CrouchTranslationOffset;
var float OldLocationZ;
var const float ZSmoothingRate;
var float MaxFootPlacementDistSquared;
var SkelControlFootPlacement LeftLegControl;
var SkelControlFootPlacement RightLegControl;
var SkelControlLimb LeftHandIK;
var SkelControlLimb RightHandIK;
var name DamageParameterName;
var name SaturationParameterName;
var float LastPostRenderTraceTime;
var float TeamBeaconMaxDist;
var float StartedFallingTime;
var float SlopeBoostFriction;
var AnimNodeAimOffset FlyingDirOffset;
var int MaxLeanRoll;
var float FeignDeathPhysicsBlendOutSpeed;
var float SwimmingZOffset;
var float SwimmingZOffsetSpeed;
var float CrouchMeshZOffset;
var float TakeHitPhysicsBlendOutSpeed;
var export editinline UDKSkeletalMeshComponent ArmsMesh[2];
var int RootYaw;
var float RootYawSpeed;
var int MaxYawAim;
var Vector2D CurrentSkelAim;
var Vector HUDLocation;

replication
{
	// Pos:0x000
	if(bNetOwner && bNetDirty)
		FireRateMultiplier;

	// Pos:0x019
	if(bNetDirty)
		BigTeleportCount, ClientBodyMatDuration, 
		CompressedBodyMatColor, CustomGravityScaling, 
		HeadScale, OverlayMaterialInstance, 
		PawnAmbientSoundCue, ReplicatedBodyMaterial, 
		WeaponAmbientSoundCue, WeaponOverlayFlags, 
		bFeigningDeath, bIsInvisible;

	// Pos:0x023
	if(bNetDirty && (WorldInfo.TimeSeconds - LastEmoteTime) <= MinTimeBetweenEmotes)
		EmoteRepInfo;

	// Pos:0x066
	if(bNetDirty && WorldInfo.TimeSeconds < LastTakeHitTimeout)
		LastTakeHitInfo;

	// Pos:0x09E
	if(bNetDirty && bNetOwner!)
		DrivenWeaponPawn, bPuttingDownWeapon;

	// Pos:0x0B9
	if(bTearOff && bNetDirty)
		bTearOffGibs;
}

// Export UUDKPawn::execGetBoundingCylinder(FFrame&, void* const)
native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

// Export UUDKPawn::execRestorePreRagdollCollisionComponent(FFrame&, void* const)
native function RestorePreRagdollCollisionComponent();

// Export UUDKPawn::execEnsureOverlayComponentLast(FFrame&, void* const)
native function EnsureOverlayComponentLast();

// Export UUDKPawn::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc);

// Export UUDKPawn::execIsInvisible(FFrame&, void* const)
native function bool IsInvisible();

simulated event HoldGameObject(UDKCarriedObject UDKGameObj)
{
	//return;	
}

event StoppedFalling()
{
	CustomGravityScaling = 1.0000000;
	bNotifyStopFalling = false;
	//return;	
}

simulated event EndCrouch(float HeightAdjust)
{
	OldZ += HeightAdjust;
	super(Pawn).EndCrouch(HeightAdjust);
	CrouchMeshZOffset = 0.0000000;
	//return;	
}

simulated event StartCrouch(float HeightAdjust)
{
	OldZ -= HeightAdjust;
	super(Pawn).StartCrouch(HeightAdjust);
	CrouchMeshZOffset = HeightAdjust;
	//return;	
}

// Export UUDKPawn::execSuggestJumpVelocity(FFrame&, void* const)
native function bool SuggestJumpVelocity(out Vector JumpVelocity, Vector Destination, Vector Start, optional bool bRequireFallLanding);

// Export UUDKPawn::execSetHUDLocation(FFrame&, void* const)
native simulated function SetHUDLocation(Vector NewHUDLocation);

// Export UUDKPawn::execNativePostRenderFor(FFrame&, void* const)
native simulated function NativePostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir);

simulated function SetWeaponAttachmentVisibility(bool bAttachmentVisible)
{
	//return;	
}

simulated function SetHandIKEnabled(bool bEnabled)
{
	//return;	
}

simulated event StartFeignDeathRecoveryAnim()
{
	//return;	
}

simulated event TakeHitBlendedOut()
{
	//return;	
}

event UpdateEyeHeight(float DeltaTime)
{
	//return;	
}

event StuckFalling()
{
	//return;	
}

// Export UUDKPawn::execGetMovementType(FFrame&, void* const)
native function CCSPawn.ECCSMovementType GetMovementType();

// Export UUDKPawn::execSetMovementType(FFrame&, void* const)
native function SetMovementType(CCSPawn.ECCSMovementType NewMovementType);

// Export UUDKPawn::execSetMovementTypeDefault(FFrame&, void* const)
native function SetMovementTypeDefault();

// Export UUDKPawn::execGetAlertness(FFrame&, void* const)
native function CCSPawn.ECCSAlertnessState GetAlertness();

// Export UUDKPawn::execSetAlertness(FFrame&, void* const)
native function SetAlertness(CCSPawn.ECCSAlertnessState NewAlertness);

// Export UUDKPawn::execSetAlertnessDefault(FFrame&, void* const)
native function SetAlertnessDefault();

// Export UUDKPawn::execGetSpeed(FFrame&, void* const)
native function CCSPawn.ECCSMovementSpeed GetSpeed();

// Export UUDKPawn::execSetSpeed(FFrame&, void* const)
native function SetSpeed(CCSPawn.ECCSMovementSpeed Speed);

// Export UUDKPawn::execSetMovementSpeedDefault(FFrame&, void* const)
native function SetMovementSpeedDefault();

// Export UUDKPawn::execIsCrouched(FFrame&, void* const)
native function bool IsCrouched();

// Export UUDKPawn::execSetCrouched(FFrame&, void* const)
native function SetCrouched(bool bCrouched);

// Export UUDKPawn::execSetPostureDefault(FFrame&, void* const)
native function SetPostureDefault();

// Export UUDKPawn::execPostureTransitionOver(FFrame&, void* const)
native function bool PostureTransitionOver();

// Export UUDKPawn::execCanAim(FFrame&, void* const)
native function bool CanAim(Rotator AimRotation);

// Export UUDKPawn::execSetCoverPose(FFrame&, void* const)
native function SetCoverPose(CCSPawn.ECCSCoverPose NewCoverPose, optional float BlendTime = -1.0000000);

// Export UUDKPawn::execSetNoCoverPose(FFrame&, void* const)
native function SetNoCoverPose();

// Export UUDKPawn::execCoverPoseTransitionOver(FFrame&, void* const)
native function bool CoverPoseTransitionOver();

// Export UUDKPawn::execMoveToInCover(FFrame&, void* const)
native function MoveToInCover(Vector Dest);

// Export UUDKPawn::execIsInCover(FFrame&, void* const)
native function bool IsInCover();

// Export UUDKPawn::execSetIsPanicking(FFrame&, void* const)
native function SetIsPanicking(bool isPanicking);

// Export UUDKPawn::execGetIsPanicking(FFrame&, void* const)
native function bool GetIsPanicking();

// Export UUDKPawn::execGetYellingDistance(FFrame&, void* const)
native function float GetYellingDistance();

// Export UUDKPawn::execGetDefaultBehaviorTree(FFrame&, void* const)
native function CCSBTTree GetDefaultBehaviorTree();

// Export UUDKPawn::execSetDefaultBehaviorTree(FFrame&, void* const)
native function SetDefaultBehaviorTree(CCSBTTree newDefaultBehaviorTree);

simulated function bool IsPlayingCustomAnimation()
{
	return false;
	//return ReturnValue;	
}

simulated function PlayFiringAnimation(optional bool charge = false, optional bool lastShot = false)
{
	//return;	
}

defaultproperties
{
	bSmoothNetUpdates=true
	CustomGravityScaling=1.0000000
	MaxSmoothNetUpdateDist=84.0000000
	NoSmoothNetUpdateDist=128.0000000
	SmoothNetUpdateTime=0.1250000
	CurrentBodyMatColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
	BodyMatColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
	MaxYawAim=7000
	// Reference: GwNavBotHandle'UDKBase.Default__UDKPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'GameFramework.Default__GamePawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: CylinderComponent'UDKBase.Default__UDKPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GameFramework.Default__GamePawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	Components[3]=myGwNavBotHandle
	CollisionComponent=CollisionCylinder
}