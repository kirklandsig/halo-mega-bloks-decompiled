class Pawn extends Actor
	abstract
	native
	nativereplication
	config(Game)
	placeable
	implements(Interface_Speaker);

enum EPathSearchType
{
	PST_Default,                    // 0
	PST_Breadth,                    // 1
	PST_NewBestPathTo,              // 2
	PST_Constraint,                 // 3
	PST_MAX                         // 4
};

struct native ScalarParameterInterpStruct
{
	var name ParameterName;
	var float ParameterValue;
	var float InterpTime;
	var float WarmupTime;

	structdefaultproperties
	{
		ParameterName="None"
		ParameterValue=0.0000000
		InterpTime=0.0000000
		WarmupTime=0.0000000
	}
};

var private native const noexport Pointer VfTable_IInterface_Speaker;
var const float MaxStepHeight;
var const float MaxJumpHeight;
var const float WalkableFloorZ;
var const float LedgeCheckThreshold;
var const Vector PartialLedgeMoveDir;
var repnotify editinline Controller Controller;
var const Pawn NextPawn;
var float NetRelevancyTime;
var PlayerController LastRealViewer;
var Actor LastViewer;
var bool bScriptTickSpecial;
var bool bUpAndOut;
var bool bIsWalking;
var bool bWantsToCrouch;
var const bool bIsCrouched;
var const bool bTryToUncrouch;
var bool bCanCrouch;
var bool bCrawler;
var const bool bReducedSpeed;
var bool bJumpCapable;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanClimbLadders;
var bool bCanStrafe;
var bool bAvoidLedges;
var bool bStopAtLedges;
var bool bAllowLedgeOverhang;
var const bool bPartiallyOverLedge;
var const bool bSimulateGravity;
var bool bIgnoreForces;
var bool bCanWalkOffLedges;
var bool bCanBeBaseForPawns;
var const bool bSimGravityDisabled;
var bool bDirectHitWall;
var const bool bPushesRigidBodies;
var bool bForceFloorCheck;
var bool bForceKeepAnchor;
var bool bDisableBraking;
var config bool bCanMantle;
var config bool bCanClimbUp;
var bool bCanClimbCeilings;
var config bool bCanSwatTurn;
var config bool bCanLeap;
var config bool bCanCoverSlip;
var globalconfig bool bDisplayPathErrors;
var bool bCanPickupInventory;
var bool bAmbientCreature;
var bool bLOSHearing;
var bool bMuffledHearing;
var bool bDontPossess;
var bool bRollToDesired;
var bool bStationary;
var bool bCachedRelevant;
var bool bNoWeaponFiring;
var bool bModifyReachSpecCost;
var bool bModifyNavPointDest;
var bool bPathfindsAsVehicle;
var bool bPrevBypassSimulatedClientPhysics;
var bool bRunPhysicsWithNoController;
var bool bForceMaxAccel;
var bool bLimitFallAccel;
var bool bReplicateHealthToAll;
var bool bForceRMVelocity;
var bool bForceRegularVelocity;
var bool bPlayedDeath;
var private const bool bDesiredRotationSet;
var private const bool bLockDesiredRotation;
var private const bool bUnlockWhenReached;
var bool bNeedsBaseTickedFirst;
var repnotify transient bool bUsedByMatinee;
var bool bRootMotionFromInterpCurve;
var bool bDebugShowCameraLocation;
var bool bFastAttachedMove;
var bool bIgnoreKillZ;
var Actor.EPhysics WalkingPhysics;
var Pawn.EPathSearchType PathSearchType;
var const byte RemoteViewPitch;
var repnotify byte FlashCount;
var repnotify byte FiringMode;
var const float UncrouchTime;
var float CrouchHeight;
var float CrouchRadius;
var const int FullHeight;
var float NonPreferredVehiclePathMultiplier;
var PathConstraint PathConstraintList;
var PathGoalEvaluator PathGoalList;
var float DesiredSpeed;
var float MaxDesiredSpeed;
var float HearingThreshold;
var float Alertness;
var float AwareRadius;
var float SightRadius;
var float PeripheralVision;
var const float AvgPhysicsTime;
var float Mass;
var float Buoyancy;
var float MeleeRange;
var const NavigationPoint Anchor;
var const int AnchorItem;
var const NavigationPoint LastAnchor;
var float FindAnchorFailedTime;
var float LastValidAnchorTime;
var float DestinationOffset;
var float NextPathRadius;
var Vector SerpentineDir;
var float SerpentineDist;
var float SerpentineTime;
var float SpawnTime;
var int MaxPitchLimit;
var float GroundSpeed;
var float WaterSpeed;
var float AirSpeed;
var float LadderSpeed;
var float AccelRate;
var float JumpZ;
var float OutofWaterZ;
var float MaxOutOfWaterStepHeight;
var float AirControl;
var float WalkingPct;
var float MovementSpeedModifier;
var float CrouchedPct;
var float MaxFallSpeed;
var float AIMaxFallSpeedFactor;
var float BaseEyeHeight;
var float EyeHeight;
var Vector Floor;
var float SplashTime;
var transient PhysicsVolume HeadVolume;
var int Health;
var int HealthMax;
var float BreathTime;
var float UnderWaterTime;
var float LastPainTime;
var float KismetDeathDelayTime;
var Vector RMVelocity;
var const Vector noise1spot;
var const float noise1time;
var const Pawn noise1other;
var const float noise1loudness;
var const Vector noise2spot;
var const float noise2time;
var const Pawn noise2other;
var const float noise2loudness;
var float SoundDampening;
var float DamageScaling;
var const localized string MenuName;
var Class<AIController> ControllerClass;
var repnotify editinline PlayerReplicationInfo PlayerReplicationInfo;
var LadderVolume OnLadder;
var name LandMovementState;
var name WaterMovementState;
var PlayerStart LastStartSpot;
var float LastStartTime;
var Vector TakeHitLocation;
var Class<DamageType> HitDamageType;
var Vector TearOffMomentum;
var int DeathTick;
var export editinline SkeletalMeshComponent Mesh;
var export editinline CylinderComponent CylinderComponent;
var float RBPushRadius;
var float RBPushStrength;
var repnotify Vehicle DrivenVehicle;
var float AlwaysRelevantDistanceSquared;
var float VehicleCheckRadius;
var Controller LastHitBy;
var float ViewPitchMin;
var float ViewPitchMax;
var int AllowedYawError;
var const Rotator DesiredRotation;
var Class<InventoryManager> InventoryManagerClass;
var repnotify InventoryManager InvManager;
var Weapon Weapon;
var repnotify Vector FlashLocation;
var Vector LastFiringFlashLocation;
var int ShotCount;
var export editinline PrimitiveComponent PreRagdollCollisionComponent;
var RB_BodyInstance PhysicsPushBody;
var int FailedLandingCount;
var transient array<AnimNodeSlot> SlotNodes;
var transient array<InterpGroup> InterpGroupList;
var protected export editinline transient AudioComponent FacialAudioComp;
var protected transient MaterialInstanceConstant MIC_PawnMat;
var protected transient MaterialInstanceConstant MIC_PawnHair;
var array<ScalarParameterInterpStruct> ScalarParameterInterpArray;
var RootMotionCurve RootMotionInterpCurve;
var float RootMotionInterpRate;
var float RootMotionInterpCurrentTime;
var Vector RootMotionInterpCurveLastValue;
var float PassiveObjectiveWeight;
var float PassiveSecondaryWeight;
var float AggressiveMobileWeight;
var float AggressiveStationaryWeight;
var float ChanceToFireAtTargetsBehindCover;

replication
{
	// Pos:0x000
	if(bNetDirty)
		DrivenVehicle, FlashLocation, 
		HitDamageType, PlayerReplicationInfo, 
		TakeHitLocation, bFastAttachedMove, 
		bIsWalking, bSimulateGravity, 
		bUsedByMatinee;

	// Pos:0x00A
	if(bNetDirty && bNetOwner || bReplicateHealthToAll)
		Health;

	// Pos:0x032
	if(bNetDirty && bNetOwner)
		AccelRate, AirControl, 
		AirSpeed, Controller, 
		GroundSpeed, InvManager, 
		JumpZ, WaterSpeed;

	// Pos:0x04B
	if((bNetDirty && bNetOwner) && bNetInitial)
		bCanSwatTurn;

	// Pos:0x073
	if(bNetDirty && bNetOwner! || bDemoRecording)
		FiringMode, FlashCount, 
		bIsCrouched;

	// Pos:0x09D
	if(bTearOff && bNetDirty)
		TearOffMomentum;

	// Pos:0x0B6
	if(bNetOwner! || bDemoRecording)
		RemoteViewPitch;

	// Pos:0x0D1
	if(bNetInitial && bNetOwner!)
		bRootMotionFromInterpCurve;

	// Pos:0x0EC
	if((bNetInitial && bNetOwner!) && bRootMotionFromInterpCurve)
		RootMotionInterpCurrentTime, RootMotionInterpCurveLastValue, 
		RootMotionInterpRate;

	// Pos:0x116
	if((int(Role) == int(ROLE_Authority)) && bNetDirty)
		HealthMax;
}

// Export UPawn::execPickWallAdjust(FFrame&, void* const)
native final function bool PickWallAdjust(Vector WallHitNormal, Actor HitActor);

// Export UPawn::execSetDesiredRotation(FFrame&, void* const)
native final function bool SetDesiredRotation(Rotator TargetDesiredRotation, optional bool InLockDesiredRotation = false, optional bool InUnlockWhenReached = false, optional float InterpolationTime = -1.0000000, optional bool bResetRotationRate = true);

// Export UPawn::execLockDesiredRotation(FFrame&, void* const)
native final function LockDesiredRotation(bool Lock, optional bool InUnlockWhenReached = false);

// Export UPawn::execResetDesiredRotation(FFrame&, void* const)
native final function ResetDesiredRotation();

// Export UPawn::execCheckDesiredRotation(FFrame&, void* const)
native final function CheckDesiredRotation();

// Export UPawn::execIsDesiredRotationInUse(FFrame&, void* const)
native final function bool IsDesiredRotationInUse();

// Export UPawn::execIsDesiredRotationLocked(FFrame&, void* const)
native final function bool IsDesiredRotationLocked();

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	// End:0x3E
	if(SkelComp == Mesh)
	{
		ClearAnimNodes();
		CacheAnimNodes();
	}
	//return;	
}

// Export UPawn::execCacheAnimNodes(FFrame&, void* const)
native simulated event CacheAnimNodes();

simulated function ClearAnimNodes()
{
	SlotNodes.Length = 0;
	//return;	
}

// Export UPawn::execUpdateAnimSetList(FFrame&, void* const)
native final simulated function UpdateAnimSetList();

simulated event BuildScriptAnimSetList()
{
	//return;	
}

// Export UPawn::execAddAnimSets(FFrame&, void* const)
native final simulated function AddAnimSets(const out array<AnimSet> CustomAnimSets);

simulated event AnimSetListUpdated()
{
	//return;	
}

simulated event bool RestoreAnimSetsToDefault()
{
	Mesh.AnimSets = default.Mesh.AnimSets;
	return true;
	//return ReturnValue;	
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
	MAT_BeginAnimControl(InInterpGroup);
	//return;	
}

// Export UPawn::execMAT_BeginAnimControl(FFrame&, void* const)
native function MAT_BeginAnimControl(InterpGroup InInterpGroup);

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
	MAT_FinishAnimControl(InInterpGroup);
	//return;	
}

// Export UPawn::execMAT_FinishAnimControl(FFrame&, void* const)
native function MAT_FinishAnimControl(InterpGroup InInterpGroup);

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion)
{
	MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping, bEnableRootMotion);
	//return;	
}

// Export UPawn::execMAT_SetAnimPosition(FFrame&, void* const)
native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion);

// Export UPawn::execMAT_SetAnimWeights(FFrame&, void* const)
native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos);

// Export UPawn::execMAT_SetMorphWeight(FFrame&, void* const)
native function MAT_SetMorphWeight(name MorphNodeName, float MorphWeight);

// Export UPawn::execMAT_SetSkelControlScale(FFrame&, void* const)
native function MAT_SetSkelControlScale(name SkelControlName, float Scale);

// Export UPawn::execMAT_SetSkelControlStrength(FFrame&, void* const)
native function MAT_SetSkelControlStrength(name SkelControlName, float ControlStrength);

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
	super.InterpolationStarted(InterpAction, GroupInst);
	//return;	
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
	super.InterpolationFinished(InterpAction);
	//return;	
}

simulated function BeginAIGroup()
{
	//return;	
}

simulated function FinishAIGroup()
{
	//return;	
}

event MAT_BeginAIGroup(Vector StartLoc, Rotator StartRot)
{
	SetLocation(StartLoc);
	SetRotation(StartRot);
	BeginAIGroup();
	bUsedByMatinee = true;
	//return;	
}

event MAT_FinishAIGroup()
{
	FinishAIGroup();
	bUsedByMatinee = false;
	//return;	
}

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay, AkEvent AkEventToPlay)
{
	return Mesh.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay, AkEventToPlay);
	//return ReturnValue;	
}

event StopActorFaceFXAnim()
{
	Mesh.StopFaceFXAnim();
	//return;	
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
	return FacialAudioComp;
	//return ReturnValue;	
}

simulated function bool IsActorPlayingFaceFXAnim()
{
	return (Mesh != none) && Mesh.IsPlayingFaceFXAnim();
	//return ReturnValue;	
}

simulated function bool CanActorPlayFaceFXAnim()
{
	return true;
	//return ReturnValue;	
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
	Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay, inAction.AkEventToPlay);
	//return;	
}

simulated function FaceFXAudioFinished(AudioComponent AC)
{
	//return;	
}

event FaceFXAsset GetActorFaceFXAsset()
{
	// End:0x81
	if((Mesh.SkeletalMesh != none) && Mesh.bDisableFaceFX!)
	{
		return Mesh.SkeletalMesh.FaceFXAsset;		
	}
	else
	{
		return none;
	}
	//return ReturnValue;	
}

event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
	MAT_SetMorphWeight(MorphNodeName, MorphWeight);
	//return;	
}

event SetSkelControlScale(name SkelControlName, float Scale)
{
	MAT_SetSkelControlScale(SkelControlName, Scale);
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	super.ReplicatedEvent(VarName);
	// End:0x4A
	if(VarName == 'FlashCount')
	{
		FlashCountUpdated(Weapon, FlashCount, true);		
	}
	else
	{
		// End:0x81
		if(VarName == 'FlashLocation')
		{
			FlashLocationUpdated(Weapon, FlashLocation, true);			
		}
		else
		{
			// End:0xB8
			if(VarName == 'FiringMode')
			{
				FiringModeUpdated(Weapon, FiringMode, true);				
			}
			else
			{
				// End:0xEB
				if(VarName == 'DrivenVehicle')
				{
					// End:0xE8
					if(DrivenVehicle != none)
					{
						NotifyTeamChanged();
					}					
				}
				else
				{
					// End:0x10F
					if(VarName == 'PlayerReplicationInfo')
					{
						NotifyTeamChanged();						
					}
					else
					{
						// End:0x1F7
						if(VarName == 'Controller')
						{
							// End:0x1F4
							if((Controller != none) && Controller.Pawn == none)
							{
								Controller.Pawn = self;
								// End:0x1F4
								if((PlayerController(Controller) != none) && PlayerController(Controller).ViewTarget == Controller)
								{
									PlayerController(Controller).SetViewTarget(self);
								}
							}							
						}
						else
						{
							// End:0x232
							if(VarName == 'bUsedByMatinee')
							{
								// End:0x228
								if(bUsedByMatinee)
								{
									BeginAIGroup();									
								}
								else
								{
									FinishAIGroup();
								}
							}
						}
					}
				}
			}
		}
	}
	//return;	
}

// Export UPawn::execIsAliveAndWell(FFrame&, void* const)
native final simulated function bool IsAliveAndWell();

// Export UPawn::execAdjustDestination(FFrame&, void* const)
native final function Vector AdjustDestination(Actor GoalActor, optional Vector Dest);

// Export UPawn::execValidAnchor(FFrame&, void* const)
native final function bool ValidAnchor();

// Export UPawn::execSuggestJumpVelocity(FFrame&, void* const)
native function bool SuggestJumpVelocity(out Vector JumpVelocity, Vector Destination, Vector Start, optional bool bRequireFallLanding);

// Export UPawn::execGetFallDuration(FFrame&, void* const)
native function float GetFallDuration();

// Export UPawn::execIsValidEnemyTargetFor(FFrame&, void* const)
native function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

// Export UPawn::execIsInvisible(FFrame&, void* const)
native function bool IsInvisible();

// Export UPawn::execSetRemoteViewPitch(FFrame&, void* const)
native final function SetRemoteViewPitch(int NewRemoteViewPitch);

// Export UPawn::execSetAnchor(FFrame&, void* const)
native function SetAnchor(NavigationPoint NewAnchor);

// Export UPawn::execGetBestAnchor(FFrame&, void* const)
native function NavigationPoint GetBestAnchor(Actor TestActor, Vector TestLocation, bool bStartPoint, bool bOnlyCheckVisible, out float out_Dist);

// Export UPawn::execReachedDestination(FFrame&, void* const)
native function bool ReachedDestination(Actor Goal);

// Export UPawn::execReachedPoint(FFrame&, void* const)
native function bool ReachedPoint(Vector Point, Actor NewAnchor);

// Export UPawn::execForceCrouch(FFrame&, void* const)
native function ForceCrouch();

// Export UPawn::execSetPushesRigidBodies(FFrame&, void* const)
native function SetPushesRigidBodies(bool NewPush);

// Export UPawn::execReachedDesiredRotation(FFrame&, void* const)
native final function bool ReachedDesiredRotation();

// Export UPawn::execGetBoundingCylinder(FFrame&, void* const)
native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

// Export UPawn::execInitRagdoll(FFrame&, void* const)
native function bool InitRagdoll();

// Export UPawn::execTermRagdoll(FFrame&, void* const)
native function bool TermRagdoll();

function bool SpecialMoveTo(NavigationPoint Start, NavigationPoint End, Actor Next)
{
	//return ReturnValue;	
}

event bool SpecialMoveThruEdge(Pylon.ENavMeshEdgeType EdgeType, int Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem, optional NavigationHandle NavHandle)
{
	//return ReturnValue;	
}

simulated function SetBaseEyeheight()
{
	// End:0x25
	if(bIsCrouched!)
	{
		BaseEyeHeight = default.BaseEyeHeight;		
	}
	else
	{
		BaseEyeHeight = FMin(0.8000000 * CrouchHeight, CrouchHeight - float(10));
	}
	//return;	
}

function PlayerChangedTeam()
{
	Died(none, Class'Engine.DamageType', Location);
	//return;	
}

function Reset()
{
	// End:0x44
	if((Controller == none) || Controller.bIsPlayer)
	{
		DetachFromController();
		Destroy();		
	}
	else
	{
		super.Reset();
	}
	//return;	
}

function bool StopFiring()
{
	// End:0x4C
	if(Weapon != none)
	{
		Weapon.StopFire(Weapon.CurrentFireMode);
	}
	return true;
	//return ReturnValue;	
}

simulated function StartFire(byte FireModeNum)
{
	// End:0x0F
	if(bNoWeaponFiring)
	{
		return;
	}
	// End:0x46
	if(Weapon != none)
	{
		Weapon.StartFire(FireModeNum);
	}
	//return;	
}

simulated function StopFire(byte FireModeNum)
{
	// End:0x37
	if(Weapon != none)
	{
		Weapon.StopFire(FireModeNum);
	}
	//return;	
}

simulated function byte GetWeaponFiringMode(Weapon InWeapon)
{
	return FiringMode;
	//return ReturnValue;	
}

simulated function SetFiringMode(Weapon InWeapon, byte InFiringMode)
{
	// End:0x57
	if(int(FiringMode) != int(InFiringMode))
	{
		FiringMode = InFiringMode;
		bForceNetUpdate = true;
		FiringModeUpdated(InWeapon, FiringMode, false);
	}
	//return;	
}

simulated function FiringModeUpdated(Weapon InWeapon, byte InFiringMode, bool bViaReplication)
{
	// End:0x41
	if(InWeapon != none)
	{
		InWeapon.FireModeUpdated(InFiringMode, bViaReplication);
	}
	//return;	
}

simulated function IncrementFlashCount(Weapon InWeapon, byte InFiringMode)
{
	bForceNetUpdate = true;
	FlashCount++;
	// End:0x38
	if(int(FlashCount) == int(0))
	{
		FlashCount += 2;
	}
	SetFiringMode(InWeapon, InFiringMode);
	FlashCountUpdated(InWeapon, FlashCount, false);
	//return;	
}

simulated function FlashCountUpdated(Weapon InWeapon, byte InFlashCount, bool bViaReplication)
{
	// End:0x35
	if(int(InFlashCount) > int(0))
	{
		WeaponFired(InWeapon, bViaReplication);		
	}
	else
	{
		WeaponStoppedFiring(InWeapon, bViaReplication);
	}
	//return;	
}

simulated function ClearFlashCount(Weapon InWeapon)
{
	// End:0x49
	if(int(FlashCount) != int(0))
	{
		bForceNetUpdate = true;
		FlashCount = 0;
		FlashCountUpdated(InWeapon, FlashCount, false);
	}
	//return;	
}

simulated function SetFlashLocation(Weapon InWeapon, byte InFiringMode, Vector NewLoc)
{
	// End:0x2F
	if(NewLoc == LastFiringFlashLocation)
	{
		NewLoc += vect(0.0000000, 0.0000000, 1.0000000);
	}
	// End:0x61
	if(NewLoc == vect(0.0000000, 0.0000000, 0.0000000))
	{
		NewLoc = vect(0.0000000, 0.0000000, 1.0000000);
	}
	bForceNetUpdate = true;
	FlashLocation = NewLoc;
	LastFiringFlashLocation = NewLoc;
	SetFiringMode(InWeapon, InFiringMode);
	FlashLocationUpdated(InWeapon, FlashLocation, false);
	//return;	
}

function ClearFlashLocation(Weapon InWeapon)
{
	// End:0x51
	if(IsZero(FlashLocation)!)
	{
		bForceNetUpdate = true;
		FlashLocation = vect(0.0000000, 0.0000000, 0.0000000);
		FlashLocationUpdated(InWeapon, FlashLocation, false);
	}
	//return;	
}

simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
	// End:0x3A
	if(IsZero(InFlashLocation)!)
	{
		WeaponFired(InWeapon, bViaReplication, InFlashLocation);		
	}
	else
	{
		WeaponStoppedFiring(InWeapon, bViaReplication);
	}
	//return;	
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
	ShotCount++;
	// End:0x56
	if(InWeapon != none)
	{
		InWeapon.PlayFireEffects(GetWeaponFiringMode(InWeapon), HitLocation);
	}
	//return;	
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	ShotCount = 0;
	// End:0x4C
	if(InWeapon != none)
	{
		InWeapon.StopFireEffects(GetWeaponFiringMode(InWeapon));
	}
	//return;	
}

function bool BotFire(bool bFinished)
{
	StartFire(0);
	return true;
	//return ReturnValue;	
}

function bool CanAttack(Actor Other)
{
	// End:0x11
	if(Weapon == none)
	{
		return false;
	}
	return Weapon.CanAttack(Other);
	//return ReturnValue;	
}

function bool TooCloseToAttack(Actor Other)
{
	return false;
	//return ReturnValue;	
}

function bool FireOnRelease()
{
	// End:0x2F
	if(Weapon != none)
	{
		return Weapon.FireOnRelease();
	}
	return false;
	//return ReturnValue;	
}

function bool HasRangedAttack()
{
	return Weapon != none;
	//return ReturnValue;	
}

function bool IsFiring()
{
	// End:0x2F
	if(Weapon != none)
	{
		return Weapon.IsFiring();
	}
	return false;
	//return ReturnValue;	
}

function bool NeedToTurn(Vector targ)
{
	local Vector LookDir, AimDir;

	LookDir = Vector(Rotation);
	LookDir.Z = 0.0000000;
	LookDir = Normal(LookDir);
	AimDir = targ - Location;
	AimDir.Z = 0.0000000;
	AimDir = Normal(AimDir);
	return (LookDir Dot AimDir) < 0.9300000;
	//return ReturnValue;	
}

simulated function string GetHumanReadableName()
{
	// End:0x2E
	if(PlayerReplicationInfo != none)
	{
		return PlayerReplicationInfo.PlayerName;
	}
	return MenuName;
	//return ReturnValue;	
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	//return;	
}

simulated function NotifyTeamChanged()
{
	//return;	
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Controller = C;
	NetPriority = 3.0000000;
	NetUpdateFrequency = 100.0000000;
	bForceNetUpdate = true;
	// End:0x89
	if(C.PlayerReplicationInfo != none)
	{
		PlayerReplicationInfo = C.PlayerReplicationInfo;
	}
	UpdateControllerOnPossess(bVehicleTransition);
	SetOwner(Controller);
	EyeHeight = BaseEyeHeight;
	// End:0x147
	if(C.IsA('PlayerController'))
	{
		// End:0x114
		if(int(WorldInfo.NetMode) != int(NM_Standalone))
		{
			RemoteRole = ROLE_AutonomousProxy;
		}
		// End:0x144
		if(Weapon != none)
		{
			Weapon.ClientWeaponSet(false);
		}		
	}
	else
	{
		RemoteRole = default.RemoteRole;
	}
	// End:0x188
	if(Weapon != none)
	{
		Weapon.CacheAIController();
	}
	//return;	
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
	// End:0x30
	if(bVehicleTransition!)
	{
		Controller.SetRotation(Rotation);
	}
	//return;	
}

function UnPossessed()
{
	bForceNetUpdate = true;
	// End:0x2A
	if(DrivenVehicle != none)
	{
		NetUpdateFrequency = 5.0000000;
	}
	PlayerReplicationInfo = none;
	SetOwner(none);
	Controller = none;
	//return;	
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
	// End:0x82
	if(((RequestedBy != none) && RequestedBy.PlayerCamera != none) && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
	{
		return 'Fixed';
	}
	return 'FirstPerson';
	//return ReturnValue;	
}

function DropToGround()
{
	bCollideWorld = true;
	// End:0x57
	if(Health > 0)
	{
		SetCollision(true, true);
		SetPhysics(2);
		// End:0x57
		if(IsHumanControlled())
		{
			Controller.GotoState(LandMovementState);
		}
	}
	//return;	
}

function bool CanGrabLadder()
{
	return ((bCanClimbLadders && Controller != none) && int(Physics) != int(9)) && (int(Physics) != int(2)) || Abs(Velocity.Z) <= JumpZ;
	//return ReturnValue;	
}

function bool RecommendLongRangedAttack()
{
	return false;
	//return ReturnValue;	
}

function float RangedAttackTime()
{
	return 0.0000000;
	//return ReturnValue;	
}

event SetWalking(bool bNewIsWalking)
{
	// End:0x2E
	if(bNewIsWalking != bIsWalking)
	{
		bIsWalking = bNewIsWalking;
	}
	//return;	
}

simulated function bool CanSplash()
{
	// End:0xB2
	if((((WorldInfo.TimeSeconds - SplashTime) > 0.1500000) && (int(Physics) == int(2)) || int(Physics) == int(4)) && Abs(Velocity.Z) > float(100))
	{
		SplashTime = WorldInfo.TimeSeconds;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function EndClimbLadder(LadderVolume OldLadder)
{
	// End:0x2E
	if(Controller != none)
	{
		Controller.EndClimbLadder();
	}
	// End:0x47
	if(int(Physics) == int(9))
	{
		SetPhysics(2);
	}
	//return;	
}

function ClimbLadder(LadderVolume L)
{
	OnLadder = L;
	SetRotation(OnLadder.WallDir);
	SetPhysics(9);
	// End:0x6A
	if(IsHumanControlled())
	{
		Controller.GotoState('PlayerClimbing');
	}
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local string T;
	local Canvas Canvas;
	local AnimTree AnimTreeRootNode;
	local int I;

	Canvas = HUD.Canvas;
	// End:0xB9
	if(PlayerReplicationInfo == none)
	{
		Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);		
	}
	else
	{
		PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
	}
	super.DisplayDebug(HUD, out_YL, out_YPos);
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.DrawText("Health " $ string(Health));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	// End:0x298
	if(HUD.ShouldDisplayDebug('AI'))
	{
		Canvas.DrawText((((("Anchor " $ string(Anchor)) $ " Serpentine Dist ") $ string(SerpentineDist)) $ " Time ") $ string(SerpentineTime));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	// End:0x604
	if(HUD.ShouldDisplayDebug('Physics'))
	{
		T = (((("Floor " $ string(Floor)) $ " DesiredSpeed ") $ string(DesiredSpeed)) $ " Crouched ") $ string(bIsCrouched);
		// End:0x371
		if((OnLadder != none) || int(Physics) == int(9))
		{
			T = (T $ " on ladder ") $ string(OnLadder);
		}
		Canvas.DrawText(T);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		T = "Collision Component:" @ string(CollisionComponent);
		Canvas.DrawText(T);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		T = "bForceMaxAccel:" @ string(bForceMaxAccel);
		Canvas.DrawText(T);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		// End:0x604
		if(Mesh != none)
		{
			T = (("RootMotionMode:" @ string(Mesh.RootMotionMode)) @ "RootMotionVelocity:") @ string(Mesh.RootMotionVelocity);
			Canvas.DrawText(T);
			out_YPos += out_YL;
			Canvas.SetPos(4.0000000, out_YPos);
		}
	}
	// End:0x6CD
	if(HUD.ShouldDisplayDebug('Camera'))
	{
		Canvas.DrawText((("EyeHeight " $ string(EyeHeight)) $ " BaseEyeHeight ") $ string(BaseEyeHeight));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	// End:0x7C8
	if(Controller == none)
	{
		Canvas.SetDrawColor(255, 0, 0);
		Canvas.DrawText("NO CONTROLLER");
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		HUD.PlayerOwner.DisplayDebug(HUD, out_YL, out_YPos);		
	}
	else
	{
		Controller.DisplayDebug(HUD, out_YL, out_YPos);
	}
	// End:0x90F
	if(HUD.ShouldDisplayDebug('Weapon'))
	{
		// End:0x8D5
		if(Weapon == none)
		{
			Canvas.SetDrawColor(0, 255, 0);
			Canvas.DrawText("NO WEAPON");
			out_YPos += out_YL;
			Canvas.SetPos(4.0000000, out_YPos);			
		}
		else
		{
			Weapon.DisplayDebug(HUD, out_YL, out_YPos);
		}
	}
	// End:0xBDC
	if(HUD.ShouldDisplayDebug('animation'))
	{
		// End:0xBDC
		if((Mesh != none) && Mesh.Animations != none)
		{
			AnimTreeRootNode = AnimTree(Mesh.Animations);
			// End:0xBDC
			if(AnimTreeRootNode != none)
			{
				Canvas.DrawText("AnimGroups count:" @ string(AnimTreeRootNode.AnimGroups.Length));
				out_YPos += out_YL;
				Canvas.SetPos(4.0000000, out_YPos);
				I = 0;
				J0xA55:

				// End:0xBDC [Loop If]
				if(I < AnimTreeRootNode.AnimGroups.Length)
				{
					Canvas.DrawText(((((" GroupName:" @ string(AnimTreeRootNode.AnimGroups[I].GroupName)) @ "NodeCount:") @ string(AnimTreeRootNode.AnimGroups[I].SeqNodes.Length)) @ "RateScale:") @ string(AnimTreeRootNode.AnimGroups[I].RateScale));
					out_YPos += out_YL;
					Canvas.SetPos(4.0000000, out_YPos);
					I++;
					// [Loop Continue]
					goto J0xA55;
				}
			}
		}
	}
	//return;	
}

// Export UPawn::execIsHumanControlled(FFrame&, void* const)
native final simulated function bool IsHumanControlled(optional Controller PawnController);

// Export UPawn::execIsLocallyControlled(FFrame&, void* const)
native final simulated function bool IsLocallyControlled();

// Export UPawn::execIsPlayerPawn(FFrame&, void* const)
native simulated function bool IsPlayerPawn();

simulated function bool IsFirstPerson()
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	return (PC != none) && PC.UsingFirstPersonCamera();
	//return ReturnValue;	
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
	out_ViewRotation += out_DeltaRot;
	out_DeltaRot = rot(0, 0, 0);
	// End:0x91
	if(PlayerController(Controller) != none)
	{
		out_ViewRotation = PlayerController(Controller).LimitViewRotation(out_ViewRotation, ViewPitchMin, ViewPitchMax);
	}
	//return;	
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
	out_Location = GetPawnViewLocation();
	out_Rotation = GetViewRotation();
	//return;	
}

// Export UPawn::execGetViewRotation(FFrame&, void* const)
native simulated event Rotator GetViewRotation();

// Export UPawn::execGetPawnViewLocation(FFrame&, void* const)
native simulated event Vector GetPawnViewLocation();

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	local Vector POVLoc;
	local Rotator POVRot;

	// End:0x4B
	if(Controller != none)
	{
		Controller.GetPlayerViewPoint(POVLoc, POVRot);
		return POVLoc;
	}
	return GetPawnViewLocation();
	//return ReturnValue;	
}

singular simulated event Rotator GetBaseAimRotation()
{
	local Vector POVLoc;
	local Rotator POVRot;

	// End:0x5B
	if((Controller != none) && InFreeCam()!)
	{
		Controller.GetPlayerViewPoint(POVLoc, POVRot);
		return POVRot;
	}
	POVRot = Rotation;
	// End:0xBE
	if(POVRot.Pitch == 0)
	{
		POVRot.Pitch = int(RemoteViewPitch) << int(8);
	}
	return POVRot;
	//return ReturnValue;	
}

simulated event bool InFreeCam()
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	return ((PC != none) && PC.PlayerCamera != none) && (PC.PlayerCamera.CameraStyle == 'FreeCam') || PC.PlayerCamera.CameraStyle == 'FreeCam_Default';
	//return ReturnValue;	
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	// End:0x30
	if((Controller == none) || int(Role) < int(ROLE_Authority))
	{
		return GetBaseAimRotation();
	}
	return Controller.GetAdjustedAimFor(W, StartFireLoc);
	//return ReturnValue;	
}

simulated function SetViewRotation(Rotator NewRotation)
{
	// End:0x33
	if(Controller != none)
	{
		Controller.SetRotation(NewRotation);		
	}
	else
	{
		SetRotation(NewRotation);
	}
	//return;	
}

function bool InGodMode()
{
	return (Controller != none) && Controller.bGodMode;
	//return ReturnValue;	
}

function SetMoveTarget(Actor NewTarget)
{
	// End:0x37
	if(Controller != none)
	{
		Controller.MoveTarget = NewTarget;
	}
	//return;	
}

function bool LineOfSightTo(Actor Other)
{
	return (Controller != none) && Controller.LineOfSightTo(Other);
	//return ReturnValue;	
}

function HandlePickup(Inventory Inv)
{
	// End:0x37
	if(Controller != none)
	{
		Controller.HandlePickup(Inv);
	}
	//return;	
}

event ClientMessage(coerce string S, optional name Type)
{
	// End:0x54
	if(PlayerController(Controller) != none)
	{
		PlayerController(Controller).ClientMessage(S, Type);
	}
	//return;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	// End:0x79
	if(int(Role) == int(ROLE_Authority))
	{
		Health = -1;
		Died(none, dmgType, Location);
		// End:0x79
		if(dmgType == none)
		{
			SetPhysics(0);
			SetHidden(true);
			LifeSpan = FMin(LifeSpan, 1.0000000);
		}
	}
	//return;	
}

singular simulated event OutsideWorldBounds()
{
	// End:0x34
	if((int(Role) == int(ROLE_Authority)) && PlayerController(Controller) == none)
	{
		Destroy();		
	}
	else
	{
		// End:0x53
		if(int(Role) == int(ROLE_Authority))
		{
			KilledBy(self);
		}
		SetPhysics(ROLE_None);
		SetHidden(true);
		LifeSpan = FMin(LifeSpan, 1.0000000);
	}
	//return;	
}

simulated function UnCrouch()
{
	// End:0x27
	if(bIsCrouched || bWantsToCrouch)
	{
		ShouldCrouch(false);
	}
	//return;	
}

function ShouldCrouch(bool bCrouch)
{
	bWantsToCrouch = bCrouch;
	//return;	
}

simulated event EndCrouch(float HeightAdjust)
{
	EyeHeight -= HeightAdjust;
	SetBaseEyeheight();
	//return;	
}

simulated event StartCrouch(float HeightAdjust)
{
	EyeHeight += HeightAdjust;
	SetBaseEyeheight();
	//return;	
}

function HandleMomentum(Vector Momentum, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
	AddVelocity(Momentum, HitLocation, DamageType, HitInfo);
	//return;	
}

function AddVelocity(Vector NewVelocity, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
	// End:0x2D
	if(bIgnoreForces || NewVelocity == vect(0.0000000, 0.0000000, 0.0000000))
	{
		return;
	}
	// End:0x9E
	if((int(Physics) == int(1)) || ((int(Physics) == int(9)) || int(Physics) == int(8)) && NewVelocity.Z > default.JumpZ)
	{
		SetPhysics(2);
	}
	// End:0x111
	if((Velocity.Z > default.JumpZ) && NewVelocity.Z > float(0))
	{
		NewVelocity.Z *= 0.5000000;
	}
	Velocity += NewVelocity;
	//return;	
}

function KilledBy(Pawn EventInstigator)
{
	local Controller Killer;

	Health = 0;
	// End:0x4D
	if(EventInstigator != none)
	{
		Killer = EventInstigator.Controller;
		LastHitBy = none;
	}
	Died(Killer, Class'Engine.DmgType_Suicided', Location);
	//return;	
}

function TakeFallingDamage()
{
	local float EffectiveSpeed;

	// End:0x130
	if(Velocity.Z < (-0.5000000 * MaxFallSpeed))
	{
		// End:0x130
		if(int(Role) == int(ROLE_Authority))
		{
			// End:0x130
			if(Velocity.Z < (float(-1) * MaxFallSpeed))
			{
				EffectiveSpeed = Velocity.Z;
				// End:0xBA
				if(TouchingWaterVolume())
				{
					EffectiveSpeed += float(100);
				}
				// End:0x130
				if(EffectiveSpeed < (float(-1) * MaxFallSpeed))
				{
					TakeDamage(int((float(-100) * (EffectiveSpeed + MaxFallSpeed)) / MaxFallSpeed), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
				}
			}
		}
	}
	//return;	
}

function Restart()
{
	//return;	
}

simulated function ClientRestart()
{
	ZeroMovementVariables();
	SetBaseEyeheight();
	//return;	
}

function ClientSetRotation(Rotator NewRotation)
{
	// End:0x38
	if(Controller != none)
	{
		Controller.ClientSetRotation(NewRotation);
	}
	//return;	
}

final simulated event UpdatePawnRotation(Rotator NewRotation)
{
	FaceRotation(NewRotation, 0.0000000);
	//return;	
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
	// End:0xA2
	if(InFreeCam()!)
	{
		// End:0x4E
		if(int(Physics) == int(9))
		{
			NewRotation = OnLadder.WallDir;			
		}
		else
		{
			// End:0x96
			if((int(Physics) == int(1)) || int(Physics) == int(2))
			{
				NewRotation.Pitch = 0;
			}
		}
		SetRotation(NewRotation);
	}
	//return;	
}

event bool EncroachingOn(Actor Other)
{
	// End:0x48
	if(Other.bWorldGeometry || Other.bBlocksTeleport)
	{
		return true;
	}
	// End:0x99
	if(((Controller == none) || Controller.bIsPlayer!) && Pawn(Other) != none)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

event EncroachedBy(Actor Other)
{
	// End:0x45
	if((Pawn(Other) != none) && Vehicle(Other) == none)
	{
		gibbedBy(Other);
	}
	//return;	
}

function gibbedBy(Actor Other)
{
	// End:0x16
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	// End:0x74
	if(Pawn(Other) != none)
	{
		Died(Pawn(Other).Controller, Class'Engine.DmgType_Telefragged', Location);		
	}
	else
	{
		Died(none, Class'Engine.DmgType_Telefragged', Location);
	}
	//return;	
}

function JumpOffPawn()
{
	Velocity += ((float(100) + CylinderComponent.CollisionRadius) * VRand());
	// End:0x82
	if(VSize2D(Velocity) > FMax(500.0000000, GroundSpeed))
	{
		Velocity = FMax(500.0000000, GroundSpeed) * Normal(Velocity);
	}
	Velocity.Z = 200.0000000 + CylinderComponent.CollisionHeight;
	SetPhysics(2);
	//return;	
}

event StuckOnPawn(Pawn OtherPawn)
{
	//return;	
}

singular event BaseChange()
{
	local DynamicSMActor Dyn;

	// End:0xB9
	if((Pawn(Base) != none) && (DrivenVehicle == none) || DrivenVehicle.IsBasedOn(Base)!)
	{
		// End:0xB9
		if(Pawn(Base).CanBeBaseForPawn(self)!)
		{
			Pawn(Base).CrushedBy(self);
			JumpOffPawn();
		}
	}
	Dyn = DynamicSMActor(Base);
	// End:0x115
	if((Dyn != none) && Dyn.CanBasePawn(self)!)
	{
		JumpOffPawn();
	}
	//return;	
}

simulated function bool CanBeBaseForPawn(Pawn aPawn)
{
	return bCanBeBaseForPawns;
	//return ReturnValue;	
}

function CrushedBy(Pawn OtherPawn)
{
	TakeDamage(int(((float(1) - (OtherPawn.Velocity.Z / float(400))) * OtherPawn.Mass) / Mass), OtherPawn.Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
	//return;	
}

function DetachFromController(optional bool bDestroyController)
{
	local Controller OldController;

	// End:0x124
	if((Controller != none) && Controller.Pawn == self)
	{
		OldController = Controller;
		Controller.PawnDied(self);
		// End:0x97
		if(Controller != none)
		{
			Controller.UnPossess();
		}
		// End:0x119
		if(((bDestroyController && OldController != none) && OldController.bDeleteMe!) && OldController.bIsPlayer!)
		{
			OldController.Destroy();
		}
		Controller = none;
	}
	//return;	
}

simulated event Destroyed()
{
	DetachFromController();
	// End:0x32
	if(InvManager != none)
	{
		InvManager.Destroy();
	}
	// End:0x5D
	if(int(WorldInfo.NetMode) == int(NM_Client))
	{
		return;
	}
	SetAnchor(none);
	Weapon = none;
	ClearPathStep();
	super.Destroyed();
	//return;	
}

simulated event PreBeginPlay()
{
	// End:0x22
	if(HealthMax == 0)
	{
		HealthMax = default.Health;
	}
	super.PreBeginPlay();
	Instigator = self;
	SetDesiredRotation(Rotation);
	EyeHeight = BaseEyeHeight;
	//return;	
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	SplashTime = 0.0000000;
	SpawnTime = WorldInfo.TimeSeconds;
	EyeHeight = BaseEyeHeight;
	// End:0xA2
	if((WorldInfo.bStartup && Health > 0) && bDontPossess!)
	{
		SpawnDefaultController();
	}
	// End:0xE1
	if(FacialAudioComp != none)
	{
		FacialAudioComp.__OnAudioFinished__Delegate = FaceFXAudioFinished;
	}
	// End:0x1BF
	if(((int(Role) == int(ROLE_Authority)) && InvManager == none) && InventoryManagerClass != none)
	{
		InvManager = Spawn(InventoryManagerClass, self);
		// End:0x19F
		if(InvManager == none)
		{
			LogInternal(((("Warning! Couldn't spawn InventoryManager" @ string(InventoryManagerClass)) @ "for") @ string(self)) @ (GetHumanReadableName()));			
		}
		else
		{
			InvManager.SetupFor(self);
		}
	}
	ClearPathStep();
	//return;	
}

function SpawnDefaultController()
{
	// End:0x56
	if(Controller != none)
	{
		LogInternal((("SpawnDefaultController" @ string(self)) @ ", Controller != None") @ string(Controller));
		return;
	}
	// End:0x89
	if(ControllerClass != none)
	{
		Controller = Spawn(ControllerClass);
	}
	// End:0xB9
	if(Controller != none)
	{
		Controller.Possess(self, false);
	}
	//return;	
}

simulated event ReceivedNewEvent(SequenceEvent Evt)
{
	// End:0x37
	if(Controller != none)
	{
		Controller.ReceivedNewEvent(Evt);
	}
	super.ReceivedNewEvent(Evt);
	//return;	
}

function OnAssignController(SeqAct_AssignController inAction)
{
	// End:0xEF
	if(inAction.ControllerClass != none)
	{
		// End:0x3E
		if(Controller != none)
		{
			DetachFromController(true);
		}
		Controller = Spawn(inAction.ControllerClass);
		Controller.Possess(self, false);
		// End:0xEC
		if(Controller.IsA('AIController'))
		{
			ControllerClass = Class<AIController>(Controller.Class);
		}		
	}
	else
	{
		WarnInternal("Assign controller w/o a class specified!");
	}
	//return;	
}

simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
	local int Idx;
	local Class<Inventory> InvClass;

	// End:0x41
	if(inAction.bClearExisting)
	{
		InvManager.DiscardInventory();
	}
	// End:0x16E
	if(inAction.InventoryList.Length > 0)
	{
		Idx = 0;
		J0x71:

		// End:0x16B [Loop If]
		if(Idx < inAction.InventoryList.Length)
		{
			InvClass = inAction.InventoryList[Idx];
			// End:0x110
			if(InvClass != none)
			{
				// End:0x10D
				if(FindInventoryType(InvClass, false) == none)
				{
					CreateInventory(InvClass);
				}				
			}
			else
			{
				inAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
			}
			Idx++;
			// [Loop Continue]
			goto J0x71;
		}		
	}
	else
	{
		inAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
	}
	//return;	
}

function Gasp()
{
	//return;	
}

function SetMovementPhysics()
{
	// End:0x2A
	if(PhysicsVolume.bWaterVolume)
	{
		SetPhysics(3);		
	}
	else
	{
		// End:0x43
		if(int(Physics) != int(2))
		{
			SetPhysics(2);
		}
	}
	//return;	
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, Class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
	//return;	
}

event bool HealDamage(int Amount, Controller Healer, Class<DamageType> DamageType)
{
	// End:0x56
	if((Health > 0) && Health < HealthMax)
	{
		Health = Min(HealthMax, Health + Amount);
		return true;		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

function PruneDamagedBoneList(out array<name> Bones)
{
	//return;	
}

event bool TakeRadiusDamageOnBones(Controller InstigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, array<name> Bones)
{
	local int Idx;
	local TraceHitInfo HitInfo;
	local bool bResult;
	local float DamageScale, Dist;
	local Vector Dir, BoneLoc;

	PruneDamagedBoneList(Bones);
	Idx = 0;
	J0x1E:

	// End:0x1EE [Loop If]
	if(Idx < Bones.Length)
	{
		HitInfo.BoneName = Bones[Idx];
		HitInfo.HitComponent = Mesh;
		BoneLoc = Mesh.GetBoneLocation(Bones[Idx]);
		Dir = BoneLoc - HurtOrigin;
		Dist = VSize(Dir);
		Dir = Normal(Dir);
		// End:0x130
		if(bFullDamage)
		{
			DamageScale = 1.0000000;			
		}
		else
		{
			DamageScale = 1.0000000 - (Dist / DamageRadius);
		}
		// End:0x1D4
		if(DamageScale > 0.0000000)
		{
			TakeDamage(int(DamageScale * BaseDamage), InstigatedBy, BoneLoc, (DamageScale * Momentum) * Dir, DamageType, HitInfo, DamageCauser);
		}
		bResult = true;
		Idx++;
		// [Loop Continue]
		goto J0x1E;
	}
	return bResult;
	//return ReturnValue;	
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum, Actor DamageCauser)
{
	// End:0x5B
	if(Controller != none)
	{
		Controller.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
	}
	//return;	
}

function Controller SetKillInstigator(Controller InstigatedBy, Class<DamageType> DamageType)
{
	// End:0x35
	if((InstigatedBy != none) && InstigatedBy != Controller)
	{
		return InstigatedBy;		
	}
	else
	{
		// End:0x72
		if(DamageType.default.bCausedByWorld && LastHitBy != none)
		{
			return LastHitBy;
		}
	}
	return InstigatedBy;
	//return ReturnValue;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int actualDamage;
	local PlayerController PC;
	local Controller Killer;

	// End:0x29
	if((int(Role) < int(ROLE_Authority)) || Health <= 0)
	{
		return;
	}
	// End:0x116
	if(DamageType == none)
	{
		// End:0x79
		if(InstigatedBy == none)
		{
			WarnInternal("No damagetype for damage with no instigator");			
		}
		else
		{
			WarnInternal((("No damagetype for damage by " $ string(InstigatedBy.Pawn)) $ " with weapon ") $ string(InstigatedBy.Pawn.Weapon));
		}
		DamageType = Class'Engine.DamageType';
	}
	Damage = Max(Damage, 0);
	// End:0x15B
	if((int(Physics) == int(0)) && DrivenVehicle == none)
	{
		SetMovementPhysics();
	}
	// End:0x1E0
	if((int(Physics) == int(1)) && DamageType.default.bExtraMomentumZ)
	{
		Momentum.Z = FMax(Momentum.Z, 0.4000000 * VSize(Momentum));
	}
	Momentum = Momentum / Mass;
	// End:0x259
	if(DrivenVehicle != none)
	{
		DrivenVehicle.AdjustDriverDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	}
	actualDamage = Damage;
	WorldInfo.Game.ReduceDamage(actualDamage, self, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	AdjustDamage(actualDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
	super.TakeDamage(actualDamage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	Health -= actualDamage;
	// End:0x3AB
	if(HitLocation == vect(0.0000000, 0.0000000, 0.0000000))
	{
		HitLocation = Location;
	}
	// End:0x484
	if(Health <= 0)
	{
		PC = PlayerController(Controller);
		// End:0x423
		if(PC != none)
		{
			PC.ClientPlayForceFeedbackWaveform(DamageType.default.KilledFFWaveform);
		}
		Killer = SetKillInstigator(InstigatedBy, DamageType);
		TearOffMomentum = Momentum;
		Died(Killer, DamageType, HitLocation);		
	}
	else
	{
		HandleMomentum(Momentum, HitLocation, DamageType, HitInfo);
		NotifyTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum, DamageCauser);
		// End:0x54D
		if(DrivenVehicle != none)
		{
			DrivenVehicle.NotifyDriverTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		}
		// End:0x588
		if((InstigatedBy != none) && InstigatedBy != Controller)
		{
			LastHitBy = InstigatedBy;
		}
	}
	PlayHit(float(actualDamage), InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
	//return;	
}

// Export UPawn::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function TeamInfo GetTeam()
{
	// End:0x6C
	if((Controller != none) && Controller.PlayerReplicationInfo != none)
	{
		return Controller.PlayerReplicationInfo.Team;		
	}
	else
	{
		// End:0x9D
		if(PlayerReplicationInfo != none)
		{
			return PlayerReplicationInfo.Team;			
		}
		else
		{
			// End:0x109
			if((DrivenVehicle != none) && DrivenVehicle.PlayerReplicationInfo != none)
			{
				return DrivenVehicle.PlayerReplicationInfo.Team;				
			}
			else
			{
				return none;
			}
		}
	}
	//return ReturnValue;	
}

simulated event bool IsSameTeam(Pawn Other)
{
	return ((Other != none) && Other.GetTeam() != none) && Other.GetTeam() == (GetTeam());
	//return ReturnValue;	
}

simulated event NotifyBecameThreatened()
{
	//return;	
}

function ThrowWeaponOnDeath()
{
	ThrowActiveWeapon();
	//return;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	local SeqAct_Latent Action;

	// End:0x22
	if(DamageType == none)
	{
		DamageType = Class'Engine.DamageType';
	}
	// End:0x90
	if((bDeleteMe || WorldInfo.Game == none) || WorldInfo.Game.bLevelChange)
	{
		return false;
	}
	// End:0x100
	if((DamageType.default.bCausedByWorld && (Killer == none) || Killer == Controller) && LastHitBy != none)
	{
		Killer = LastHitBy;
	}
	// End:0x16B
	if(WorldInfo.Game.PreventDeath(self, Killer, DamageType, HitLocation))
	{
		Health = Max(Health, 1);
		return false;
	}
	Health = Min(0, Health);
	// End:0x19F
	if(default.KismetDeathDelayTime > float(0))
	{
		DelayTriggerDeath();		
	}
	else
	{
		TriggerEventClass(Class'Engine.SeqEvent_Death', self);
	}
	KismetDeathDelayTime = default.KismetDeathDelayTime + WorldInfo.TimeSeconds;
	// End:0x221
	foreach LatentActions(Action)
	{
		Action.AbortFor(self);		
	}	
	LatentActions.Length = 0;
	// End:0x28D
	if(DrivenVehicle != none)
	{
		Velocity = DrivenVehicle.Velocity;
		DrivenVehicle.DriverDied(DamageType);
	}
	// End:0x2EF
	if(Controller != none)
	{
		WorldInfo.Game.Killed(Killer, Controller, self, DamageType);		
	}
	else
	{
		WorldInfo.Game.Killed(Killer, Controller(Owner), self, DamageType);
	}
	DrivenVehicle = none;
	Velocity.Z *= 1.3000000;
	// End:0x3AC
	if(IsHumanControlled())
	{
		PlayerController(Controller).ForceDeathUpdate();
	}
	NetUpdateFrequency = default.NetUpdateFrequency;
	PlayDying(DamageType, HitLocation, Killer);
	return true;
	//return ReturnValue;	
}

function bool TryThrowWeaponOnDeath()
{
	// End:0x87
	if(Weapon != none)
	{
		Weapon.HolderDied();
		ThrowWeaponOnDeath();
		// End:0x85
		if(InvManager != none)
		{
			InvManager.DiscardInventory();
			InvManager.OwnerDied();
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function DelayTriggerDeath()
{
	TriggerEventClass(Class'Engine.SeqEvent_Death', self);
	//return;	
}

event Falling()
{
	//return;	
}

event Landed(Vector HitNormal, Actor FloorActor)
{
	TakeFallingDamage();
	// End:0x3F
	if(Health > 0)
	{
		PlayLanded(Velocity.Z);
	}
	LastHitBy = none;
	//return;	
}

event TickSpecial(float DeltaTime)
{
	//return;	
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
	// End:0x3C
	if((int(WorldInfo.NetMode) == int(NM_Client)) || Controller == none)
	{
		return;
	}
	// End:0xF8
	if((HeadVolume != none) && HeadVolume.bWaterVolume)
	{
		// End:0xF5
		if(newHeadVolume.bWaterVolume!)
		{
			// End:0xE6
			if((Controller.bIsPlayer && BreathTime > float(0)) && BreathTime < float(8))
			{
				Gasp();
			}
			BreathTime = -1.0000000;
		}		
	}
	else
	{
		// End:0x12D
		if(newHeadVolume.bWaterVolume)
		{
			BreathTime = UnderWaterTime;
		}
	}
	//return;	
}

function bool TouchingWaterVolume()
{
	local PhysicsVolume V;

	// End:0x3E
	foreach TouchingActors(Class'Engine.PhysicsVolume', V)
	{
		// End:0x3D
		if(V.bWaterVolume)
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

event BreathTimer()
{
	// End:0x9A
	if(HeadVolume.bWaterVolume)
	{
		// End:0x6F
		if(((Health < 0) || int(WorldInfo.NetMode) == int(NM_Client)) || DrivenVehicle != none)
		{
			return;
		}
		TakeDrowningDamage();
		// End:0x97
		if(Health > 0)
		{
			BreathTime = 2.0000000;
		}		
	}
	else
	{
		BreathTime = 0.0000000;
	}
	//return;	
}

function TakeDrowningDamage()
{
	//return;	
}

function bool CheckWaterJump(out Vector WallNormal)
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal, Checkpoint, Start, checkNorm, Extent;

	// End:0x14C
	if(AIController(Controller) != none)
	{
		// End:0x117
		if((Controller.InLatentExecution(Controller.503) && Controller.MoveTarget != none) && Controller.MoveTarget.PhysicsVolume.bWaterVolume!)
		{
			Checkpoint = Normal(Controller.MoveTarget.Location - Location);			
		}
		else
		{
			Checkpoint = Acceleration;
		}
		Checkpoint.Z = 0.0000000;
	}
	// End:0x17C
	if(Checkpoint == vect(0.0000000, 0.0000000, 0.0000000))
	{
		Checkpoint = Vector(Rotation);
	}
	Checkpoint.Z = 0.0000000;
	checkNorm = Normal(Checkpoint);
	Checkpoint = Location + ((1.2000000 * CylinderComponent.CollisionRadius) * checkNorm);
	Extent = CylinderComponent.CollisionRadius * vect(1.0000000, 1.0000000, 0.0000000);
	Extent.Z = CylinderComponent.CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, Checkpoint, Location, true, Extent,, 8);
	// End:0x3DB
	if((HitActor != none) && Pawn(HitActor) == none)
	{
		WallNormal = float(-1) * HitNormal;
		Start = Location;
		Start.Z += MaxOutOfWaterStepHeight;
		Checkpoint = Start + ((3.2000000 * CylinderComponent.CollisionRadius) * WallNormal);
		HitActor = Trace(HitLocation, HitNormal, Checkpoint, Start, true,,, 8);
		// End:0x3DB
		if((HitActor == none) || HitNormal.Z > 0.7000000)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool DoJump(bool bUpdating)
{
	// End:0x203
	if(((bJumpCapable && bIsCrouched!) && bWantsToCrouch!) && ((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
	{
		// End:0xA6
		if(int(Physics) == int(8))
		{
			Velocity = JumpZ * Floor;			
		}
		else
		{
			// End:0xDF
			if(int(Physics) == int(9))
			{
				Velocity.Z = 0.0000000;				
			}
			else
			{
				// End:0x115
				if(bIsWalking)
				{
					Velocity.Z = default.JumpZ;					
				}
				else
				{
					Velocity.Z = JumpZ;
				}
			}
		}
		// End:0x1FC
		if(((Base != none) && Base.bWorldGeometry!) && Base.Velocity.Z > 0.0000000)
		{
			Velocity.Z += Base.Velocity.Z;
		}
		SetPhysics(2);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function PlayDyingSound()
{
	//return;	
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
	// End:0x4A
	if((Damage <= float(0)) && (Controller == none) || Controller.bGodMode!)
	{
		return;
	}
	LastPainTime = WorldInfo.TimeSeconds;
	//return;	
}

simulated function TurnOff()
{
	// End:0x20
	if(int(Role) == int(ROLE_Authority))
	{
		RemoteRole = ROLE_SimulatedProxy;
	}
	// End:0xD4
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none)
	{
		Mesh.bPauseAnims = true;
		// End:0xD4
		if(int(Physics) == int(10))
		{
			Mesh.PhysicsWeight = 1.0000000;
			Mesh.bUpdateKinematicBonesFromAnimation = false;
		}
	}
	SetCollision(true, false);
	bNoWeaponFiring = true;
	Velocity = vect(0.0000000, 0.0000000, 0.0000000);
	SetPhysics(0);
	bIgnoreForces = true;
	// End:0x15A
	if(Weapon != none)
	{
		Weapon.StopFire(Weapon.CurrentFireMode);
	}
	//return;	
}

function SetDyingPhysics()
{
	// End:0x19
	if(int(Physics) != int(10))
	{
		SetPhysics(2);
	}
	//return;	
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
{
	GotoState('Dying');
	bReplicateMovement = false;
	bTearOff = true;
	Velocity += TearOffMomentum;
	SetDyingPhysics();
	bPlayedDeath = true;
	KismetDeathDelayTime = default.KismetDeathDelayTime + WorldInfo.TimeSeconds;
	//return;	
}

simulated event TornOff()
{
	// End:0x2C
	if(bPlayedDeath!)
	{
		PlayDying(HitDamageType, TakeHitLocation);
	}
	//return;	
}

event PlayFootStepSound(int FootDown)
{
	//return;	
}

function bool CannotJumpNow()
{
	return false;
	//return ReturnValue;	
}

function PlayLanded(float ImpactVel)
{
	//return;	
}

// Export UPawn::execGetVehicleBase(FFrame&, void* const)
native function Vehicle GetVehicleBase();

function Suicide()
{
	KilledBy(self);
	//return;	
}

simulated function bool CanThrowWeapon()
{
	return (Weapon != none) && Weapon.CanThrow();
	//return ReturnValue;	
}

simulated event StartDriving(Vehicle V)
{
	StopFiring();
	// End:0x1B
	if(Health <= 0)
	{
		return;
	}
	DrivenVehicle = V;
	bForceNetUpdate = true;
	ShouldCrouch(false);
	bIgnoreForces = true;
	bCanTeleport = false;
	BreathTime = 0.0000000;
	V.AttachDriver(self);
	//return;	
}

simulated event StopDriving(Vehicle V)
{
	// End:0x6C
	if(Mesh != none)
	{
		Mesh.SetCullDistance(default.Mesh.CachedMaxDrawDistance);
		Mesh.SetShadowParent(none);
	}
	bForceNetUpdate = true;
	// End:0xA6
	if(V != none)
	{
		V.StopFiring();
	}
	// End:0xBC
	if(int(Physics) == int(10))
	{
		return;
	}
	DrivenVehicle = none;
	bIgnoreForces = false;
	SetHardAttach(false);
	bCanTeleport = true;
	bCollideWorld = true;
	// End:0x125
	if(V != none)
	{
		V.DetachDriver(self);
	}
	SetCollision(true, true);
	// End:0x191
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x17A
		if(PhysicsVolume.bWaterVolume && Health > 0)
		{
			SetPhysics(3);			
		}
		else
		{
			SetPhysics(2);
		}
		SetBase(none);
		SetHidden(false);
	}
	//return;	
}

function AddDefaultInventory()
{
	//return;	
}

final event Inventory CreateInventory(Class<Inventory> NewInvClass, optional bool bDoNotActivate)
{
	// End:0x43
	if(InvManager != none)
	{
		return InvManager.CreateInventory(NewInvClass, bDoNotActivate);
	}
	return none;
	//return ReturnValue;	
}

final simulated function Inventory FindInventoryType(Class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
	return ((InvManager != none) ? InvManager.FindInventoryType(DesiredClass, bAllowSubclass) : none);
	//return ReturnValue;	
}

simulated function DrawHUD(HUD H)
{
	// End:0x37
	if(InvManager != none)
	{
		InvManager.DrawHUD(H);
	}
	//return;	
}

function ThrowActiveWeapon(optional bool bDestroyWeap)
{
	// End:0x24
	if(Weapon != none)
	{
		TossInventory(Weapon);
	}
	//return;	
}

function TossInventory(Inventory Inv, optional Vector ForceVelocity)
{
	local Vector POVLoc, TossVel;
	local Rotator POVRot;
	local Vector X, Y, Z;

	// End:0x32
	if(ForceVelocity != vect(0.0000000, 0.0000000, 0.0000000))
	{
		TossVel = ForceVelocity;		
	}
	else
	{
		GetActorEyesViewPoint(POVLoc, POVRot);
		TossVel = Vector(POVRot);
		TossVel = (TossVel * ((Velocity Dot TossVel) + float(500))) + vect(0.0000000, 0.0000000, 200.0000000);
	}
	GetAxes(Rotation, X, Y, Z);
	Inv.DropFrom((Location + ((0.8000000 * CylinderComponent.CollisionRadius) * X)) - ((0.5000000 * CylinderComponent.CollisionRadius) * Y), TossVel);
	//return;	
}

simulated function SetActiveWeapon(Weapon NewWeapon)
{
	// End:0x37
	if(InvManager != none)
	{
		InvManager.SetCurrentWeapon(NewWeapon);
	}
	//return;	
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	//return;	
}

function bool CheatWalk()
{
	UnderWaterTime = default.UnderWaterTime;
	SetCollision(true, true);
	SetPhysics(2);
	bCollideWorld = true;
	SetPushesRigidBodies(default.bPushesRigidBodies);
	// End:0x60
	if(MovementSpeedModifier >= float(200))
	{
		MovementSpeedModifier -= 200.0000000;
	}
	return true;
	//return ReturnValue;	
}

function bool CheatGhost()
{
	UnderWaterTime = -1.0000000;
	SetCollision(false, false);
	bCollideWorld = false;
	SetPushesRigidBodies(false);
	// End:0x4D
	if(MovementSpeedModifier <= float(200))
	{
		MovementSpeedModifier += float(200);
	}
	return true;
	//return ReturnValue;	
}

function bool CheatFly()
{
	UnderWaterTime = default.UnderWaterTime;
	SetCollision(true, true);
	bCollideWorld = true;
	return true;
	//return ReturnValue;	
}

simulated function float GetCollisionRadius()
{
	return ((CylinderComponent != none) ? CylinderComponent.CollisionRadius : 0.0000000);
	//return ReturnValue;	
}

simulated function float GetCollisionHeight()
{
	return ((CylinderComponent != none) ? CylinderComponent.CollisionHeight : 0.0000000);
	//return ReturnValue;	
}

final simulated function Vector GetCollisionExtent()
{
	local Vector Extent;

	Extent = (GetCollisionRadius()) * vect(1.0000000, 1.0000000, 0.0000000);
	Extent.Z = GetCollisionHeight();
	return Extent;
	//return ReturnValue;	
}

function bool IsStationary()
{
	return false;
	//return ReturnValue;	
}

event SpawnedByKismet()
{
	// End:0x2E
	if(Controller != none)
	{
		Controller.SpawnedByKismet();
	}
	//return;	
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
	local bool bOldCollideActors, bOldBlockActors, bValidBone, bValidSocket;

	// End:0x19E
	if((Mesh != none) && Action.BoneName != 'None')
	{
		bValidSocket = Mesh.GetSocketByName(Action.BoneName) != none;
		bValidBone = Mesh.MatchRefBone(Action.BoneName) != -1;
		// End:0x19E
		if(bValidBone! && bValidSocket!)
		{
			LogInternal((((((((string(WorldInfo.TimeSeconds) @ string(Class)) @ string(GetFuncName())) @ "bone or socket") @ string(Action.BoneName)) @ "not found on actor") @ string(self)) @ "with mesh") @ string(Mesh));
		}
	}
	// End:0x4EF
	if(bValidBone || bValidSocket)
	{
		bOldCollideActors = Attachment.bCollideActors;
		bOldBlockActors = Attachment.bBlockActors;
		Attachment.SetCollision(false, false);
		Attachment.SetHardAttach(Action.bHardAttach);
		// End:0x37F
		if(bValidBone && bValidSocket!)
		{
			// End:0x2FD
			if(Action.bUseRelativeOffset)
			{
				Attachment.SetLocation(Mesh.GetBoneLocation(Action.BoneName));
			}
			// End:0x37F
			if(Action.bUseRelativeRotation)
			{
				Attachment.SetRotation(QuatToRotator(Mesh.GetBoneQuaternion(Action.BoneName)));
			}
		}
		Attachment.SetBase(self,, Mesh, Action.BoneName);
		// End:0x440
		if(Action.bUseRelativeRotation)
		{
			Attachment.SetRelativeRotation(Attachment.RelativeRotation + Action.RelativeRotation);
		}
		// End:0x4BF
		if(Action.bUseRelativeOffset)
		{
			Attachment.SetRelativeLocation(Attachment.RelativeLocation + Action.RelativeOffset);
		}
		Attachment.SetCollision(bOldCollideActors, bOldBlockActors);		
	}
	else
	{
		super.DoKismetAttachment(Attachment, Action);
	}
	//return;	
}

function float GetDamageScaling()
{
	return DamageScaling;
	//return ReturnValue;	
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
	// End:0x6A
	if(Mesh != none)
	{
		Mesh.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
	}
	//return;	
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	local array<Object> objVars;
	local Pawn altDriver;

	// End:0xA2
	if(Vehicle(self) != none)
	{
		altDriver = Vehicle(self).Driver;
		Vehicle(self).DisableVehicle();
		self.Destroy();
		// End:0xA0
		if(altDriver != none)
		{
			altDriver.OnTeleport(Action);
		}
		return;
	}
	Action.GetObjectVars(objVars, "Destination");
	// End:0x18E
	if(HandleTeleport(objVars, Action.bUpdateRotation, Action.bCheckOverlap,, Action.TeleportVolumes)!)
	{
		WarnInternal("failed to handle teleport kismet action properly" @ string(Action));
	}
	//return;	
}

simulated function bool HandleTeleport(array<Object> DestList, bool bUpdateRotation, bool bCheckOverlap, optional float TeleportDistance, optional array<Volume> TeleportVolumes, optional int PreferredDestIndex)
{
	local int Idx, Cnt;
	local Actor destActor, tempActor, A;
	local Controller C;
	local bool bOccupiedDest, bColliding;
	local Vector Extent;

	Extent = GetCollisionExtent();
	bOccupiedDest = false;
	// End:0x2AE
	if(DestList.Length > 0)
	{
		Idx = ((PreferredDestIndex >= 0) ? PreferredDestIndex : 0);
		// End:0x86
		if(Idx >= DestList.Length)
		{
			Idx = 0;
			PreferredDestIndex = 0;
		}
		Cnt = 0;
		J0x91:

		tempActor = Actor(DestList[Idx]);
		// End:0x241
		if(tempActor != none)
		{
			C = Controller(tempActor);
			// End:0x13F
			if((C != none) && C.Pawn != none)
			{
				tempActor = C.Pawn;
			}
			// End:0x1FA
			if(bCheckOverlap)
			{
				bColliding = false;
				// End:0x1E4
				foreach VisibleCollidingActors(Class'Engine.Actor', A, Extent.X * 2.0000000, tempActor.Location, false, Extent, true)
				{
					// End:0x1E3
					if(IsBlockedBy(A))
					{
						bColliding = true;
						// End:0x1E4
						break;
					}					
				}				
				bOccupiedDest = bColliding;
			}
			destActor = tempActor;
			// End:0x241
			if((bCheckOverlap! || bOccupiedDest!) && destActor != none)
			{
				// [Explicit Continue]
				goto J0x2AB;
			}
		}
		Idx++;
		// End:0x26F
		if(Idx >= DestList.Length)
		{
			Idx = 0;
		}
		Cnt++;
		// End:0x91
		if(!((Idx == PreferredDestIndex) || Cnt >= DestList.Length))
			goto J0x91;
		J0x2AB:
		
	}
	else
	{
		WarnInternal("Unable to teleport - no destination list given");
	}
	// End:0x4F6
	if((destActor != none) && Class'Engine.SeqAct_Teleport'.static.ShouldTeleport(self, destActor.Location, TeleportDistance, TeleportVolumes))
	{
		// End:0x4CE
		if(SetLocation(destActor.Location))
		{
			// End:0x3E0
			if(IsLocallyControlled()! && PlayerController(Controller) != none)
			{
				PlayerController(Controller).ClientSetLocation(destActor.Location, Rotation);
			}
			PlayTeleportEffect(false, true);
			// End:0x49D
			if(bUpdateRotation)
			{
				SetRotation(destActor.Rotation);
				// End:0x49D
				if(Controller != none)
				{
					Controller.SetRotation(destActor.Rotation);
					Controller.ClientSetRotation(destActor.Rotation);
				}
			}
			// End:0x4CC
			if(Controller != none)
			{
				Controller.OnTeleport(none);
			}
			return true;
		}
		WarnInternal("Unable to teleport to" @ string(destActor));
		return false;
	}
	// End:0x534
	if(destActor == none)
	{
		WarnInternal("Unable to teleport - no destination given");
		return false;
	}
	return true;
	//return ReturnValue;	
}

final event MessagePlayer(coerce string msg)
{
	local PlayerController PC;

	// End:0x4A
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		PC.ClientMessage(msg);		
	}	
	//return;	
}

simulated event BecomeViewTarget(PlayerController PC)
{
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
	//return;	
}

event SoakPause()
{
	local PlayerController PC;

	// End:0x58
	foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		PC.SoakPause(self);
		// End:0x58
		break;		
	}	
	//return;	
}

// Export UPawn::execClearConstraints(FFrame&, void* const)
native function ClearConstraints();

// Export UPawn::execAddPathConstraint(FFrame&, void* const)
native function AddPathConstraint(PathConstraint Constraint);

// Export UPawn::execAddGoalEvaluator(FFrame&, void* const)
native function AddGoalEvaluator(PathGoalEvaluator Evaluator);

function PathConstraint CreatePathConstraint(Class<PathConstraint> ConstraintClass)
{
	return new (self) ConstraintClass;
	//return ReturnValue;	
}

function PathGoalEvaluator CreatePathGoalEvaluator(Class<PathGoalEvaluator> GoalEvalClass)
{
	return new (self) GoalEvalClass;
	//return ReturnValue;	
}

// Export UPawn::execIncrementPathStep(FFrame&, void* const)
native function IncrementPathStep(int Cnt, Canvas C);

// Export UPawn::execIncrementPathChild(FFrame&, void* const)
native function IncrementPathChild(int Cnt, Canvas C);

// Export UPawn::execDrawPathStep(FFrame&, void* const)
native function DrawPathStep(Canvas C);

// Export UPawn::execClearPathStep(FFrame&, void* const)
native function ClearPathStep();

simulated function ZeroMovementVariables()
{
	Velocity = vect(0.0000000, 0.0000000, 0.0000000);
	Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	//return;	
}

simulated function SetCinematicMode(bool bInCinematicMode)
{
	//return;	
}

// Export UPawn::execSetRootMotionInterpCurrentTime(FFrame&, void* const)
native function SetRootMotionInterpCurrentTime(float inTime, optional float DeltaTime, optional bool bUpdateSkelPose);

// Export UPawn::execSetScalarParameterInterp(FFrame&, void* const)
native final simulated function SetScalarParameterInterp(const out ScalarParameterInterpStruct ScalarParameterInterp);

simulated event Speak(SoundCue Cue)
{
	PlaySound(Cue, true);
	//return;	
}

simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
	super.OnSetVelocity(Action);
	// End:0x53
	if(Action.VelocityMag == float(0))
	{
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);		
	}
	else
	{
		Acceleration = Velocity / 0.2000000;
	}
	//return;	
}

simulated event NotifyGrenadeStuck()
{
	//return;	
}

simulated function NotifyTrap(int Type, bool bEntered, optional bool bBroadcast = false, optional float broadcastDist = 5000.0000000)
{
	//return;	
}

simulated event OnRootMotionCollision(Vector adjustment)
{
	//return;	
}

state Dying
{
	ignores Died, Landed, BaseChange, PlayNextAnimation, PlayWeaponSwitch, FellOutOfWorld, 
		BreathTimer, Falling, PhysicsVolumeChange, HeadVolumeChange, HitWall, 
		Bump;

	singular simulated event OutsideWorldBounds()
	{
		SetPhysics(0);
		SetHidden(true);
		LifeSpan = FMin(LifeSpan, 1.0000000);
		//return;		
	}

	event Timer()
	{
		// End:0x0F
		if(PlayerCanSeeMe()!)
		{
			Destroy();			
		}
		else
		{
			SetTimer(2.0000000, false);
		}
		//return;		
	}

	event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		SetPhysics(2);
		// End:0x66
		if((int(Physics) == int(0)) && Momentum.Z < float(0))
		{
			Momentum.Z *= float(-1);
		}
		Velocity += ((float(3) * Momentum) / (Mass + float(200)));
		// End:0xB3
		if(DamageType == none)
		{
			DamageType = Class'Engine.DamageType';
		}
		Health -= Damage;
		//return;		
	}

	simulated event Tick(float DeltaTime)
	{
		global.Tick(DeltaTime);
		// End:0x3A
		if(DeathTick == 0)
		{
			DeathTick++;
			TryThrowWeaponOnDeath();			
		}
		else
		{
			// End:0x54
			if(DeathTick < 0)
			{
				DeathTick++;
			}
		}
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		local Actor A;
		local array<SequenceEvent> TouchEvents;
		local int I;

		// End:0x4A
		if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
		{
			LifeSpan = 2.0000000;			
		}
		else
		{
			SetTimer(5.0000000, false);
			LifeSpan = 25.0000000;
		}
		SetDyingPhysics();
		SetCollision(true, false);
		// End:0xCB
		if(Controller != none)
		{
			// End:0xB3
			if(Controller.bIsPlayer)
			{
				DetachFromController();				
			}
			else
			{
				Controller.Destroy();
			}
		}
		// End:0x189
		foreach TouchingActors(Class'Engine.Actor', A)
		{
			// End:0x188
			if(A.FindEventsOfClass(Class'Engine.SeqEvent_Touch', TouchEvents))
			{
				I = 0;
				J0x123:

				// End:0x17C [Loop If]
				if(I < TouchEvents.Length)
				{
					SeqEvent_Touch(TouchEvents[I]).NotifyTouchingPawnDied(self);
					I++;
					// [Loop Continue]
					goto J0x123;
				}
				TouchEvents.Length = 0;
			}			
		}		
		// End:0x1C2
		foreach BasedActors(Class'Engine.Actor', A)
		{
			A.PawnBaseDied();			
		}		
		// End:0x208
		if(PreviousStateName != 'Dying')
		{
			LogInternal(string(self) $ " IS STARTING TO DIE!");
			DeathTick = Rand(4)-;
		}
		//return;		
	}
Begin:

	Sleep(0.2000000);
	PlayDyingSound();
	stop;		
}

defaultproperties
{
	MaxStepHeight=35.0000000
	MaxJumpHeight=96.0000000
	WalkableFloorZ=0.7000000
	LedgeCheckThreshold=4.0000000
	bJumpCapable=true
	bCanJump=true
	bCanWalk=true
	bAllowLedgeOverhang=true
	bSimulateGravity=true
	bLOSHearing=true
	bModifyNavPointDest=true
	bLimitFallAccel=true
	WalkingPhysics=EPhysics.PHYS_Walking
	CrouchHeight=40.0000000
	CrouchRadius=34.0000000
	NonPreferredVehiclePathMultiplier=1.0000000
	DesiredSpeed=1.0000000
	MaxDesiredSpeed=1.0000000
	HearingThreshold=2750.0000000
	AwareRadius=10000.0000000
	SightRadius=5000.0000000
	AvgPhysicsTime=0.1000000
	Mass=100.0000000
	MaxPitchLimit=3072
	GroundSpeed=600.0000000
	WaterSpeed=300.0000000
	AirSpeed=600.0000000
	LadderSpeed=200.0000000
	AccelRate=2048.0000000
	JumpZ=420.0000000
	OutofWaterZ=420.0000000
	MaxOutOfWaterStepHeight=40.0000000
	AirControl=0.0500000
	WalkingPct=0.5000000
	MovementSpeedModifier=1.0000000
	CrouchedPct=0.5000000
	MaxFallSpeed=1200.0000000
	AIMaxFallSpeedFactor=1.0000000
	BaseEyeHeight=64.0000000
	EyeHeight=54.0000000
	Health=100
	noise1time=-10.0000000
	noise2time=-10.0000000
	SoundDampening=1.0000000
	DamageScaling=1.0000000
	ControllerClass=Class'Engine.AIController'
	LandMovementState="PlayerWalking"
	WaterMovementState="PlayerSwimming"
	// Reference: CylinderComponent'Engine.Default__Pawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=78.0000000
		CollisionRadius=34.0000000
		ReplacementPrimitive=none
		CollideActors=true
		BlockActors=true
	end object
	CylinderComponent=CollisionCylinder
	RBPushRadius=10.0000000
	RBPushStrength=50.0000000
	VehicleCheckRadius=150.0000000
	ViewPitchMin=-16384.0000000
	ViewPitchMax=16383.0000000
	AllowedYawError=2000
	InventoryManagerClass=Class'Engine.InventoryManager'
	RootMotionInterpRate=1.0000000
	ChanceToFireAtTargetsBehindCover=1.0000000
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bUpdateSimulatedPosition=true
	bCanBeDamaged=true
	bShouldBaseAtStartup=true
	bCanTeleport=true
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bProjTarget=true
	NetPriority=2.0000000
	CollisionComponent=CollisionCylinder
	RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
}