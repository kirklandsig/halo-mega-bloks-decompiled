class UDKVehicle extends UDKVehicleBase
	abstract
	native
	nativereplication
	config(GwNavEngine)
	implements(CCSPawn);

struct native BurnOutDatum
{
	var MaterialInstanceTimeVarying MITV;
	var float CurrValue;

	structdefaultproperties
	{
		MITV=none
		CurrValue=0.0000000
	}
};

struct native WeaponEffectInfo
{
	var name SocketName;
	var Vector Offset;
	var Vector Scale3D;
	var export editinline StaticMeshComponent Effect;

	structdefaultproperties
	{
		SocketName="None"
		Offset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Scale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
		Effect=none
	}
};

struct native VehicleSeat
{
	var editinline Pawn StoragePawn;
	var editinline Vehicle SeatPawn;
	var Class<UDKWeapon> GunClass;
	var editinline UDKWeapon Gun;
	var array<name> GunSocket;
	var array<name> GunPivotPoints;
	var int BarrelIndex;
	var string TurretVarPrefix;
	var array<WeaponEffectInfo> WeaponEffects;
	var name WeaponRotationName;
	var name FlashLocationName;
	var name FlashCountName;
	var name FiringModeName;
	var const Pointer WeaponRotationProperty;
	var const Pointer FlashLocationProperty;
	var const Pointer FlashCountProperty;
	var const Pointer FiringModeProperty;
	var Rotator LastWeaponRotation;
	var array<name> TurretControls;
	var editinline array<editinline UDKSkelControl_TurretConstrained> TurretControllers;
	var Vector AimPoint;
	var Actor AimTarget;
	var float PivotFireOffsetZ;
	var bool bDisableOffsetZAdjust;
	var name CameraTag;
	var Vector CameraBaseOffset;
	var Vector CameraSafeOffset;
	var float CameraOffset;
	var float CameraEyeHeight;
	var float ViewPitchMin;
	var float ViewPitchMax;
	var bool bSeatVisible;
	var name SeatBone;
	var Vector SeatOffset;
	var Rotator SeatRotation;
	var name SeatSocket;
	var Class<UDKExplosionLight> MuzzleFlashLightClass;
	var export editinline UDKExplosionLight MuzzleFlashLight;
	var Class<UDKExplosionLight> ImpactFlashLightClass;
	var float DriverDamageMult;
	var export editinline AudioComponent SeatMotionAudio;
	var UDKVehicleMovementEffect SeatMovementEffect;
	var Vector2D SeatIconPOS;
	var float SeatCameraYawRate;

	structdefaultproperties
	{
		StoragePawn=none
		SeatPawn=none
		GunClass=none
		Gun=none
		GunSocket=none
		GunPivotPoints=none
		BarrelIndex=0
		TurretVarPrefix=""
		WeaponEffects=none
		WeaponRotationName="None"
		FlashLocationName="None"
		FlashCountName="None"
		FiringModeName="None"
		WeaponRotationProperty=()
		FlashLocationProperty=()
		FlashCountProperty=()
		FiringModeProperty=()
		LastWeaponRotation=(Pitch=0,Yaw=0,Roll=0)
		TurretControls=none
		TurretControllers=none
		AimPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		AimTarget=none
		PivotFireOffsetZ=0.0000000
		bDisableOffsetZAdjust=false
		CameraTag="None"
		CameraBaseOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		CameraSafeOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		CameraOffset=0.0000000
		CameraEyeHeight=0.0000000
		ViewPitchMin=0.0000000
		ViewPitchMax=0.0000000
		bSeatVisible=false
		SeatBone="None"
		SeatOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		SeatRotation=(Pitch=0,Yaw=0,Roll=0)
		SeatSocket="None"
		MuzzleFlashLightClass=none
		MuzzleFlashLight=none
		ImpactFlashLightClass=none
		DriverDamageMult=0.0000000
		SeatMotionAudio=none
		SeatMovementEffect=none
		SeatIconPOS=(X=0.0000000,Y=0.0000000)
		SeatCameraYawRate=0.0000000
	}
};

struct native VehicleAnim
{
	var name AnimTag;
	var array<name> AnimSeqs;
	var float AnimRate;
	var bool bAnimLoopLastSeq;
	var name AnimPlayerName;

	structdefaultproperties
	{
		AnimTag="None"
		AnimSeqs=none
		AnimRate=0.0000000
		bAnimLoopLastSeq=false
		AnimPlayerName="None"
	}
};

struct native VehicleSound
{
	var name SoundStartTag;
	var name SoundEndTag;
	var SoundCue SoundTemplate;
	var export editinline AudioComponent SoundRef;

	structdefaultproperties
	{
		SoundStartTag="None"
		SoundEndTag="None"
		SoundTemplate=none
		SoundRef=none
	}
};

struct native FDamageMorphTargets
{
	var name MorphNodeName;
	var MorphNodeWeight MorphNode;
	var name LinkedMorphNodeName;
	var int LinkedMorphNodeIndex;
	var name InfluenceBone;
	var int Health;
	var array<name> DamagePropNames;

	structdefaultproperties
	{
		MorphNodeName="None"
		MorphNode=none
		LinkedMorphNodeName="None"
		LinkedMorphNodeIndex=0
		InfluenceBone="None"
		Health=1
		DamagePropNames=none
	}
};

struct native DamageParamScales
{
	var name DamageParamName;
	var float Scale;

	structdefaultproperties
	{
		DamageParamName="None"
		Scale=0.0000000
	}
};

struct native VehicleEffect
{
	var name EffectStartTag;
	var name EffectEndTag;
	var bool bRestartRunning;
	var bool bHighDetailOnly;
	var ParticleSystem EffectTemplate;
	var ParticleSystem EffectTemplate_Blue;
	var name EffectSocket;
	var export editinline ParticleSystemComponent EffectRef;

	structdefaultproperties
	{
		EffectStartTag="None"
		EffectEndTag="None"
		bRestartRunning=true
		bHighDetailOnly=false
		EffectTemplate=none
		EffectTemplate_Blue=none
		EffectSocket="None"
		EffectRef=none
	}
};

var private native const noexport Pointer VfTable_ICCSPawn;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSCoverPose WantedCoverPose;
var CCSPawn.ECCSCoverPose CurrentCoverPose;
var CCSPawn.ECCSAlertnessState AlertnessState;
var repnotify byte Team;
var Vector2D AimYawRange;
var Vector2D AimPitchRange;
var bool bIsPanicking;
var bool bShouldCover;
var private bool bInCover;
var bool bEjectKilledBodies;
var bool bHomingTarget;
var const bool bFrontalCollision;
var const bool bFrontalCollisionWithFixed;
var bool bNoZDampingInAir;
var bool bNoZDamping;
var repnotify bool bIsDisabled;
var bool bIsBurning;
var bool bEjectPassengersWhenFlipped;
var bool bIsScraping;
var bool bTakeWaterDamageWhileDriving;
var bool bIsInDestroyablePenetration;
var repnotify bool bDeadVehicle;
var bool bJostleWhileDriving;
var bool bFloatWhenDriven;
var bool bAllowedExit;
var bool bUseAlternatePaths;
var bool bDisableDriverlessReset;
var bool bShowLocked;
var bool bTeamLocked;
var bool bDisableRepulsorsAtMaxFallSpeed;
var bool bTrickJumping;
var bool bGrab1;
var bool bGrab2;
var bool bForceSpinWarmup;
var private float CoverPct;
var float CoverPoseBlendTimeOverride;
var float RemainingBurn;
var array<BurnOutDatum> BurnOutMaterialInstances;
var const editconst export editinline AudioComponent TireAudioComp;
var array<MaterialSoundEffect> TireSoundList;
var name CurrentTireMaterial;
var float MaxWheelEffectDistSq;
var array<MaterialParticleEffect> WheelParticleEffects;
var int WheelIndexToParticleCheck;
var int DefaultWheelParticleIndex;
var float LastCheckUpsideDownTime;
var float FlippedCount;
var export editinline AudioComponent ScrapeSound;
var float FireDamageThreshold;
var float FireDamagePerSec;
var float AccruedFireDamage;
var float UpsideDownDamagePerSec;
var float OccupiedUpsideDownDamagePerSec;
var float WaterDamage;
var float AccumulatedWaterDamage;
var array<int> GroundEffectIndices;
var float MaxGroundEffectDist;
var name GroundEffectDistParameterName;
var ParticleSystem WaterGroundEffect;
var repnotify Rotator WeaponRotation;
var array<VehicleSeat> Seats;
var int SeatMask;
var array<VehicleAnim> VehicleAnims;
var array<VehicleSound> VehicleSounds;
var name DrivingAnim;
var float DestroyOnPenetrationThreshold;
var float DestroyOnPenetrationDuration;
var float TimeInDestroyablePenetration;
var float LastDeathImpactTime;
var SoundCue LargeChunkImpactSound;
var SoundCue MediumChunkImpactSound;
var SoundCue SmallChunkImpactSound;
var float CustomGravityScaling;
var array<DamageParamScales> DamageParamScaleLevels;
var array<UDKSkelControl_Damage> DamageSkelControls;
var array<FDamageMorphTargets> DamageMorphTargets;
var MaterialInstanceConstant DamageMaterialInstance[2];
var UTTakeHitInfo LastTakeHitInfo;
var float LastTakeHitTimeout;
var array<VehicleEffect> VehicleEffects;
var Controller KillerController;
var float LastJumpOutCheck;
var name WaterEffectType;
var array<int> ContrailEffectIndices;
var name ContrailColorParameterName;
var float ObjectiveGetOutDist;
var array<UDKBot> Trackers;
var float ExtraReachDownThreshold;
var float ResetTime;
var float MinRunOverSpeed;
var float LastRunOverWarningTime;
var float MinRunOverWarningAim;
var float TeamBeaconMaxDist;
var float LastPostRenderTraceTime;
var float ShowLockedMaxDist;
var Vector HUDLocation;
var export editinline ParticleSystemComponent HoverboardDust;
var CCSBTTree DefaultBehaviorTree;
var float YellingDistance;
var float MoveToRadius;

replication
{
	// Pos:0x000
	if(bNetDirty)
		CustomGravityScaling, SeatMask, 
		Team, bDeadVehicle, 
		bGrab1, bGrab2, 
		bIsDisabled, bTeamLocked;

	// Pos:0x00A
	if(bNetDirty && !bNetOwner || bDemoRecording)
		WeaponRotation, bForceSpinWarmup, 
		bTrickJumping;

	// Pos:0x034
	if(bNetDirty && WorldInfo.TimeSeconds < LastTakeHitTimeout)
		LastTakeHitInfo;

	// Pos:0x06C
	if(bNetDirty && WorldInfo.ReplicationViewers.Find('InViewer', PlayerController(KillerController)) != -1)
		KillerController;
}

// Export UUDKVehicle::execSeatWeaponRotation(FFrame&, void* const)
native simulated function Rotator SeatWeaponRotation(int SeatIndex, optional Rotator NewRot, optional bool bReadValue);

// Export UUDKVehicle::execSeatFlashLocation(FFrame&, void* const)
native simulated function Vector SeatFlashLocation(int SeatIndex, optional Vector NewLoc, optional bool bReadValue);

// Export UUDKVehicle::execSeatFlashCount(FFrame&, void* const)
native simulated function byte SeatFlashCount(int SeatIndex, optional byte NewCount, optional bool bReadValue);

// Export UUDKVehicle::execSeatFiringMode(FFrame&, void* const)
native simulated function byte SeatFiringMode(int SeatIndex, optional byte NewFireMode, optional bool bReadValue);

// Export UUDKVehicle::execForceWeaponRotation(FFrame&, void* const)
native simulated function ForceWeaponRotation(int SeatIndex, Rotator NewRotation);

// Export UUDKVehicle::execGetSeatPivotPoint(FFrame&, void* const)
native simulated function Vector GetSeatPivotPoint(int SeatIndex);

// Export UUDKVehicle::execGetBarrelIndex(FFrame&, void* const)
native simulated function int GetBarrelIndex(int SeatIndex);

// Export UUDKVehicle::execIsSeatControllerReplicationViewer(FFrame&, void* const)
native(999) final function bool IsSeatControllerReplicationViewer(int SeatIndex);

function Class<DamageType> GetRanOverDamageType()
{
	return Class'Engine.DmgType_Crushed';
	//return ReturnValue;	
}

simulated event LockOnWarning(UDKProjectile IncomingMissile)
{
	//return;	
}

event OnPropertyChange(name PropName)
{
	//return;	
}

// Export UUDKVehicle::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

function bool OnTouchForcedDirVolume(UDKForcedDirectionVolume Vol)
{
	return true;
	//return ReturnValue;	
}

simulated event PlayTakeHitEffects()
{
	//return;	
}

simulated event ReceivedHealthChange()
{
	//return;	
}

event JumpOutCheck()
{
	//return;	
}

// Export UUDKVehicle::execGetMaxRiseForce(FFrame&, void* const)
native function float GetMaxRiseForce();

// Export UUDKVehicle::execCheckAutoDestruct(FFrame&, void* const)
native simulated function bool CheckAutoDestruct(TeamInfo InstigatorTeam, float CheckRadius);

event SelfDestruct(Actor ImpactedActor)
{
	//return;	
}

// Export UUDKVehicle::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

// Export UUDKVehicle::execNativePostRenderFor(FFrame&, void* const)
native simulated function NativePostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir);

// Export UUDKVehicle::execInUseableRange(FFrame&, void* const)
native simulated function bool InUseableRange(UDKPlayerController PC, float Dist);

// Export UUDKVehicle::execSetHUDLocation(FFrame&, void* const)
native simulated function SetHUDLocation(Vector NewHUDLocation);

// Export UUDKVehicle::execInitDamageSkel(FFrame&, void* const)
native simulated function InitDamageSkel();

// Export UUDKVehicle::execUpdateDamageMaterial(FFrame&, void* const)
native simulated function UpdateDamageMaterial();

// Export UUDKVehicle::execApplyMorphDamage(FFrame&, void* const)
native function ApplyMorphDamage(Vector HitLocation, int Damage, Vector Momentum);

simulated event MorphTargetDestroyed(int MorphNodeIndex)
{
	//return;	
}

event RBPenetrationDestroy()
{
	// End:0x49
	if(Health > 0)
	{
		TakeDamage(10000, GetCollisionDamageInstigator(), Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
	}
	//return;	
}

event TakeWaterDamage()
{
	//return;	
}

event CheckReset()
{
	ResetTime = WorldInfo.TimeSeconds + 10000000.0000000;
	//return;	
}

event TakeFireDamage()
{
	//return;	
}

event PostInitRigidBody(PrimitiveComponent PrimComp)
{
	//return;	
}

event UpdateHoverboardDustEffect(float DustHeight)
{
	//return;	
}

event Vector GetAIEntryLocation(int SeatIndex)
{
	return Location;
	//return ReturnValue;	
}

// Export UUDKVehicle::execGetMovementType(FFrame&, void* const)
native function CCSPawn.ECCSMovementType GetMovementType();

// Export UUDKVehicle::execSetMovementType(FFrame&, void* const)
native function SetMovementType(CCSPawn.ECCSMovementType NewMovementType);

// Export UUDKVehicle::execSetMovementTypeDefault(FFrame&, void* const)
native function SetMovementTypeDefault();

// Export UUDKVehicle::execGetAlertness(FFrame&, void* const)
native function CCSPawn.ECCSAlertnessState GetAlertness();

// Export UUDKVehicle::execSetAlertness(FFrame&, void* const)
native function SetAlertness(CCSPawn.ECCSAlertnessState NewAlertness);

// Export UUDKVehicle::execSetAlertnessDefault(FFrame&, void* const)
native function SetAlertnessDefault();

// Export UUDKVehicle::execGetSpeed(FFrame&, void* const)
native function CCSPawn.ECCSMovementSpeed GetSpeed();

// Export UUDKVehicle::execSetSpeed(FFrame&, void* const)
native function SetSpeed(CCSPawn.ECCSMovementSpeed Speed);

// Export UUDKVehicle::execSetMovementSpeedDefault(FFrame&, void* const)
native function SetMovementSpeedDefault();

// Export UUDKVehicle::execIsCrouched(FFrame&, void* const)
native function bool IsCrouched();

// Export UUDKVehicle::execSetCrouched(FFrame&, void* const)
native function SetCrouched(bool bCrouched);

// Export UUDKVehicle::execSetPostureDefault(FFrame&, void* const)
native function SetPostureDefault();

// Export UUDKVehicle::execPostureTransitionOver(FFrame&, void* const)
native function bool PostureTransitionOver();

// Export UUDKVehicle::execCanAim(FFrame&, void* const)
native function bool CanAim(Rotator AimRotation);

// Export UUDKVehicle::execSetCoverPose(FFrame&, void* const)
native function SetCoverPose(CCSPawn.ECCSCoverPose NewCoverPose, optional float BlendTime = -1.0000000);

// Export UUDKVehicle::execSetNoCoverPose(FFrame&, void* const)
native function SetNoCoverPose();

// Export UUDKVehicle::execCoverPoseTransitionOver(FFrame&, void* const)
native function bool CoverPoseTransitionOver();

// Export UUDKVehicle::execMoveToInCover(FFrame&, void* const)
native function MoveToInCover(Vector Dest);

// Export UUDKVehicle::execIsInCover(FFrame&, void* const)
native function bool IsInCover();

// Export UUDKVehicle::execSetIsPanicking(FFrame&, void* const)
native function SetIsPanicking(bool isPanicking);

// Export UUDKVehicle::execGetIsPanicking(FFrame&, void* const)
native function bool GetIsPanicking();

// Export UUDKVehicle::execGetYellingDistance(FFrame&, void* const)
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

// Export UUDKVehicle::execGetDefaultBehaviorTree(FFrame&, void* const)
native function CCSBTTree GetDefaultBehaviorTree();

// Export UUDKVehicle::execSetDefaultBehaviorTree(FFrame&, void* const)
native function SetDefaultBehaviorTree(CCSBTTree newDefaultBehaviorTree);

defaultproperties
{
	bNoZDampingInAir=true
	bAllowedExit=true
	bUseAlternatePaths=true
	MaxWheelEffectDistSq=16000000.0000000
	CustomGravityScaling=1.0000000
	ObjectiveGetOutDist=1000.0000000
	TeamBeaconMaxDist=5000.0000000
	ShowLockedMaxDist=3000.0000000
	MoveToRadius=2000.0000000
	// Reference: GwNavBotHandle'UDKBase.Default__UDKVehicle.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UDKBase.Default__UDKVehicleBase.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: RB_StayUprightSetup'UDKBase.Default__UDKVehicle.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UDKBase.Default__UDKVehicleBase.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'UDKBase.Default__UDKVehicle.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UDKBase.Default__UDKVehicleBase.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	// Reference: SkeletalMeshComponent'UDKBase.Default__UDKVehicle.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UDKBase.Default__UDKVehicleBase.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'UDKBase.Default__UDKVehicle.CollisionCylinder'
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