class Controller extends Actor
	abstract
	native
	nativereplication
	notplaceable
	implements(Interface_NavigationHandle);

const LATENT_MOVETOWARD = 503;

struct native VisiblePortalInfo
{
	var Actor Source;
	var Actor Destination;

	structdefaultproperties
	{
		Source=none
		Destination=none
	}
};

var private native const noexport Pointer VfTable_IInterface_NavigationHandle;
var repnotify editinline Pawn Pawn;
var repnotify editinline PlayerReplicationInfo PlayerReplicationInfo;
var const int PlayerNum;
var private const Controller NextController;
var bool bIsPlayer;
var bool bGodMode;
var bool bMassivelyDamageEnemies;
var bool bMinimallyDamageEnemies;
var bool bSoaking;
var bool bSlowerZAcquire;
var bool bNotifyPostLanded;
var bool bNotifyApex;
var bool bOverrideSearchStart;
var bool bAdvancedTactics;
var bool bCanDoSpecial;
var bool bAdjusting;
var bool bPreparingMove;
var bool bForceStrafe;
var const bool bLOSflag;
var bool bSkipExtraLOSChecks;
var bool bNotifyFallingHitWall;
var bool bEarlyOutOfSighTestsForSameType;
var bool bForceMaxMoveTowardPawnTargetTime;
var bool bPreciseDestination;
var bool bSeeFriendly;
var bool bUsingPathLanes;
var input byte bFire;
var input byte bAltFire;
var float MinHitWall;
var Class<NavigationHandle> NavigationHandleClass;
var editinline NavigationHandle NavigationHandle;
var Vector OverrideSearchStart;
var float MoveTimer;
var Actor MoveTarget;
var BasedPosition DestinationPosition;
var BasedPosition FocalPosition;
var Actor Focus;
var Actor GoalList[4];
var BasedPosition AdjustPosition;
var NavigationPoint StartSpot;
var array<NavigationPoint> RouteCache;
var ReachSpec CurrentPath;
var ReachSpec NextRoutePath;
var Vector CurrentPathDir;
var Actor RouteGoal;
var float RouteDist;
var float LastRouteFind;
var InterpActor PendingMover;
var Actor FailedMoveTarget;
var int MoveFailureCount;
var float GroundPitchTime;
var Pawn ShotTarget;
var const Actor LastFailedReach;
var const float FailedReachTime;
var const Vector FailedReachLocation;
var float SightCounter;
var float SightCounterInterval;
var float InUseNodeCostMultiplier;
var int HighJumpNodeCostModifier;
var float MaxMoveTowardPawnTargetTime;
var Pawn Enemy;
var array<VisiblePortalInfo> VisiblePortals;
var float LaneOffset;
var const Rotator OldBasedRotation;
var Vector NavMeshPath_SearchExtent_Modifier;

replication
{
	// Pos:0x000
	if(bNetDirty && int(Role) == int(ROLE_Authority))
		Pawn, PlayerReplicationInfo;
}

// Export UController::execIsLocalPlayerController(FFrame&, void* const)
native function bool IsLocalPlayerController();

// Export UController::execIsLocalController(FFrame&, void* const)
native function bool IsLocalController();

// Export UController::execRouteCache_Empty(FFrame&, void* const)
native function RouteCache_Empty();

// Export UController::execRouteCache_AddItem(FFrame&, void* const)
native function RouteCache_AddItem(NavigationPoint Nav);

// Export UController::execRouteCache_InsertItem(FFrame&, void* const)
native function RouteCache_InsertItem(NavigationPoint Nav, optional int Idx = 0);

// Export UController::execRouteCache_RemoveItem(FFrame&, void* const)
native function RouteCache_RemoveItem(NavigationPoint Nav);

// Export UController::execRouteCache_RemoveIndex(FFrame&, void* const)
native function RouteCache_RemoveIndex(int InIndex, optional int Count = 1);

// Export UController::execSetFocalPoint(FFrame&, void* const)
native final function SetFocalPoint(Vector FP, optional bool bOffsetFromBase);

// Export UController::execGetFocalPoint(FFrame&, void* const)
native final function Vector GetFocalPoint();

// Export UController::execSetDestinationPosition(FFrame&, void* const)
native final function SetDestinationPosition(Vector Dest, optional bool bOffsetFromBase);

// Export UController::execGetDestinationPosition(FFrame&, void* const)
native final function Vector GetDestinationPosition();

// Export UController::execSetAdjustLocation(FFrame&, void* const)
native final function SetAdjustLocation(Vector NewLoc, bool bAdjust, optional bool bOffsetFromBase);

// Export UController::execGetAdjustLocation(FFrame&, void* const)
native final function Vector GetAdjustLocation();

event NotifyPathChanged()
{
	//return;	
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
	Pawn.BeginAnimControl(InInterpGroup);
	//return;	
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion)
{
	Pawn.SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping, bEnableRootMotion);
	//return;	
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
	Pawn.FinishAnimControl(InInterpGroup);
	//return;	
}

event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay, AkEvent AkEventToPlay)
{
	return Pawn.PlayActorFaceFXAnim(AnimSet, GroupName, SeqName, SoundCueToPlay, AkEventToPlay);
	//return ReturnValue;	
}

event StopActorFaceFXAnim()
{
	Pawn.StopActorFaceFXAnim();
	//return;	
}

event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
	Pawn.SetMorphWeight(MorphNodeName, MorphWeight);
	//return;	
}

event SetSkelControlScale(name SkelControlName, float Scale)
{
	Pawn.SetSkelControlScale(SkelControlName, Scale);
	//return;	
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x65
	if(!bDeleteMe && int(WorldInfo.NetMode) != int(NM_Client))
	{
		// End:0x5B
		if(bIsPlayer)
		{
			InitPlayerReplicationInfo();
		}
		InitNavigationHandle();
	}
	SightCounter = SightCounterInterval * FRand();
	//return;	
}

function Reset()
{
	super.Reset();
	Enemy = none;
	StartSpot = none;
	bAdjusting = false;
	bPreparingMove = false;
	MoveTimer = -1.0000000;
	MoveTarget = none;
	CurrentPath = none;
	RouteGoal = none;
	//return;	
}

reliable client simulated function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
	SetRotation(NewRotation);
	// End:0x1A8
	if(Pawn != none)
	{
		// End:0x148
		if((Rotation.Pitch > Pawn.MaxPitchLimit) && Rotation.Pitch < (65536 - Pawn.MaxPitchLimit))
		{
			// End:0x106
			if(Rotation.Pitch < 32768)
			{
				NewRotation.Pitch = Pawn.MaxPitchLimit;				
			}
			else
			{
				NewRotation.Pitch = 65536 - Pawn.MaxPitchLimit;
			}
		}
		NewRotation.Roll = 0;
		Pawn.SetRotation(NewRotation);
		Pawn.SetLocation(NewLocation);
	}
	//return;	
}

reliable client simulated function ClientSetRotation(Rotator NewRotation, optional bool bResetCamera)
{
	SetRotation(NewRotation);
	// End:0x79
	if(Pawn != none)
	{
		NewRotation.Pitch = 0;
		NewRotation.Roll = 0;
		Pawn.SetRotation(NewRotation);
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x49
	if(VarName == 'PlayerReplicationInfo')
	{
		// End:0x46
		if(PlayerReplicationInfo != none)
		{
			PlayerReplicationInfo.ClientInitialize(self);
		}		
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
	//return;	
}

function OnPossess(SeqAct_Possess inAction)
{
	local Pawn OldPawn;
	local Vehicle V;

	V = Vehicle(Pawn);
	// End:0x6F
	if(inAction.bTryToLeaveVehicle && V != none)
	{
		V.DriverLeave(true);
	}
	// End:0x1A0
	if(inAction.PawnToPossess != none)
	{
		V = Vehicle(inAction.PawnToPossess);
		// End:0x10F
		if((Pawn != none) && V != none)
		{
			V.TryToDrive(Pawn);			
		}
		else
		{
			OldPawn = Pawn;
			UnPossess();
			Possess(inAction.PawnToPossess, false);
			// End:0x1A0
			if(inAction.bKillOldPawn && OldPawn != none)
			{
				OldPawn.Destroy();
			}
		}
	}
	//return;	
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
	// End:0x58
	if(inPawn.Controller != none)
	{
		inPawn.Controller.UnPossess();
	}
	inPawn.PossessedBy(self, bVehicleTransition);
	Pawn = inPawn;
	SetFocalPoint(Pawn.Location + (float(512) * Vector(Pawn.Rotation)), true);
	Restart(bVehicleTransition);
	// End:0x12C
	if(Pawn.Weapon == none)
	{
		ClientSwitchToBestWeapon();
	}
	//return;	
}

event UnPossess()
{
	// End:0x39
	if(Pawn != none)
	{
		Pawn.UnPossessed();
		Pawn = none;
	}
	//return;	
}

function PawnDied(Pawn inPawn)
{
	local int Idx;

	// End:0x19
	if(inPawn != Pawn)
	{
		return;
	}
	TriggerEventClass(Class'Engine.SeqEvent_Death', self);
	Idx = 0;
	J0x3B:

	// End:0xA4 [Loop If]
	if(Idx < LatentActions.Length)
	{
		// End:0x96
		if(LatentActions[Idx] != none)
		{
			LatentActions[Idx].AbortFor(self);
		}
		Idx++;
		// [Loop Continue]
		goto J0x3B;
	}
	LatentActions.Length = 0;
	// End:0xFF
	if(Pawn != none)
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
	}
	Pawn = none;
	// End:0x137
	if(bIsPlayer)
	{
		// End:0x134
		if(!GamePlayEndedState())
		{
			GotoState('Dead');
		}		
	}
	else
	{
		Destroy();
	}
	//return;	
}

function bool GamePlayEndedState()
{
	return false;
	//return ReturnValue;	
}

event NotifyPostLanded()
{
	//return;	
}

event Destroyed()
{
	// End:0x114
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x7C
		if(bIsPlayer && WorldInfo.Game != none)
		{
			WorldInfo.Game.Logout(self);
		}
		// End:0x114
		if(PlayerReplicationInfo != none)
		{
			// End:0x10A
			if(!PlayerReplicationInfo.bOnlySpectator && PlayerReplicationInfo.Team != none)
			{
				PlayerReplicationInfo.Team.RemoveFromTeam(self);
			}
			CleanupPRI();
		}
	}
	super.Destroyed();
	//return;	
}

function CleanupPRI()
{
	PlayerReplicationInfo.Destroy();
	PlayerReplicationInfo = none;
	//return;	
}

function Restart(bool bVehicleTransition)
{
	Pawn.Restart();
	// End:0x39
	if(!bVehicleTransition)
	{
		Enemy = none;
	}
	// End:0xA3
	if((bVehicleTransition == false) && Pawn.InvManager != none)
	{
		Pawn.InvManager.UpdateController();
	}
	//return;	
}

// Export UController::execBeyondFogDistance(FFrame&, void* const)
native final function bool BeyondFogDistance(Vector ViewPoint, Vector OtherPoint);

function EnemyJustTeleported()
{
	LineOfSightTo(Enemy);
	//return;	
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	//return;	
}

function InitPlayerReplicationInfo()
{
	PlayerReplicationInfo = Spawn(WorldInfo.Game.PlayerReplicationInfoClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
	// End:0xC8
	if(PlayerReplicationInfo.PlayerName == "")
	{
		PlayerReplicationInfo.PlayerName = Class'Engine.GameInfo'.default.DefaultPlayerName;
	}
	//return;	
}

// Export UController::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

reliable server function ServerRestartPlayer()
{
	// End:0x44
	if((int(WorldInfo.NetMode) != int(NM_Client)) && Pawn != none)
	{
		ServerGivePawn();
	}
	//return;	
}

function ServerGivePawn()
{
	//return;	
}

function SetCharacter(string inCharacter)
{
	//return;	
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
	GotoState('RoundEnded');
	//return;	
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> damageTyp)
{
	// End:0x43
	if(Pawn != none)
	{
		Pawn.TriggerEventClass(Class'Engine.SeqEvent_SeeDeath', KilledPawn);
	}
	// End:0x65
	if(Enemy == KilledPawn)
	{
		Enemy = none;
	}
	//return;	
}

function NotifyProjLanded(Projectile Proj)
{
	// End:0x54
	if((Proj != none) && Pawn != none)
	{
		Pawn.TriggerEventClass(Class'Engine.SeqEvent_ProjectileLanded', Proj);
	}
	//return;	
}

function WarnProjExplode(Projectile Proj)
{
	//return;	
}

event float RatePickup(Actor PickupHolder, Class<Inventory> inPickup)
{
	//return ReturnValue;	
}

function bool FireWeaponAt(Actor inActor)
{
	//return ReturnValue;	
}

event StopFiring()
{
	bFire = 0;
	// End:0x3A
	if(Pawn != none)
	{
		Pawn.StopFiring();
	}
	//return;	
}

function RoundHasEnded(optional Actor EndRoundFocus)
{
	GotoState('RoundEnded');
	//return;	
}

function HandlePickup(Inventory Inv)
{
	//return;	
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	// End:0x2F
	if(Pawn != none)
	{
		return Pawn.GetBaseAimRotation();
	}
	return Rotation;
	//return ReturnValue;	
}

function InstantWarnTarget(Actor InTarget, Weapon FiredWeapon, Vector FireDir)
{
	local Pawn P;

	P = Pawn(InTarget);
	// End:0x9C
	if((P != none) && P.Controller != none)
	{
		P.Controller.ReceiveWarning(Pawn, -1.0000000, FireDir);
	}
	//return;	
}

function ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
	//return;	
}

function ReceiveProjectileWarning(Projectile Proj)
{
	//return;	
}

exec function SwitchToBestWeapon(optional bool bForceNewWeapon)
{
	// End:0x38
	if((Pawn == none) || Pawn.InvManager == none)
	{
		return;
	}
	Pawn.InvManager.SwitchToBestWeapon(bForceNewWeapon);
	//return;	
}

reliable client simulated function ClientSwitchToBestWeapon(optional bool bForceNewWeapon)
{
	SwitchToBestWeapon(bForceNewWeapon);
	//return;	
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
	//return;	
}

// Export UController::execLineOfSightTo(FFrame&, void* const)
native(514) final function bool LineOfSightTo(Actor Other, optional Vector chkLocation, optional bool bTryAlternateTargetLoc);

// Export UController::execCanSee(FFrame&, void* const)
native(533) final function bool CanSee(Pawn Other);

// Export UController::execCanSeeByPoints(FFrame&, void* const)
native(537) final function bool CanSeeByPoints(Vector ViewLocation, Vector TestLocation, Rotator ViewRotation);

// Export UController::execPickTarget(FFrame&, void* const)
native(531) final function Pawn PickTarget(Class<Pawn> TargetClass, out float bestAim, out float bestDist, Vector FireDir, Vector projStart, float MaxRange);

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
	//return;	
}

event SeePlayer(Pawn Seen)
{
	//return;	
}

event SeeMonster(Pawn Seen)
{
	//return;	
}

event EnemyNotVisible()
{
	//return;	
}

// Export UController::execMoveTo(FFrame&, void* const)
native(500) final latent function MoveTo(Vector NewDestination, optional Actor ViewFocus, optional float DestinationOffset, optional bool bShouldWalk = ((Pawn != none) ? Pawn.bIsWalking : false));

// Export UController::execMoveToDirectNonPathPos(FFrame&, void* const)
native final latent function MoveToDirectNonPathPos(Vector NewDestination, optional Actor ViewFocus, optional float DestinationOffset, optional bool bShouldWalk = ((Pawn != none) ? Pawn.bIsWalking : false));

// Export UController::execMoveToward(FFrame&, void* const)
native(502) final latent function MoveToward(Actor NewTarget, optional Actor ViewFocus, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk = ((Pawn != none) ? Pawn.bIsWalking : false));

event SetupSpecialPathAbilities()
{
	//return;	
}

// Export UController::execFinishRotation(FFrame&, void* const)
native(508) final latent function FinishRotation();

// Export UController::execFindPathTo(FFrame&, void* const)
native(518) final function Actor FindPathTo(Vector aPoint, optional int MaxPathLength, optional bool bReturnPartial);

// Export UController::execFindPathToward(FFrame&, void* const)
native(517) final function Actor FindPathToward(Actor anActor, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

// Export UController::execFindPathTowardNearest(FFrame&, void* const)
native final function Actor FindPathTowardNearest(Class<NavigationPoint> GoalClass, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

// Export UController::execFindRandomDest(FFrame&, void* const)
native(525) final function NavigationPoint FindRandomDest();

// Export UController::execFindPathToIntercept(FFrame&, void* const)
native final function Actor FindPathToIntercept(Pawn P, Actor InRouteGoal, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

// Export UController::execPointReachable(FFrame&, void* const)
native(521) final function bool PointReachable(Vector aPoint);

// Export UController::execActorReachable(FFrame&, void* const)
native(520) final function bool ActorReachable(Actor anActor);

event MoveUnreachable(Vector AttemptedDest, Actor AttemptedTarget)
{
	//return;	
}

// Export UController::execPickWallAdjust(FFrame&, void* const)
native(526) final function bool PickWallAdjust(Vector HitNormal);

// Export UController::execWaitForLanding(FFrame&, void* const)
native(527) final latent function WaitForLanding(optional float waitDuration);

event LongFall()
{
	//return;	
}

// Export UController::execEndClimbLadder(FFrame&, void* const)
native function EndClimbLadder();

event MayFall(bool bFloor, Vector FloorNormal)
{
	//return;	
}

event bool AllowDetourTo(NavigationPoint N)
{
	return true;
	//return ReturnValue;	
}

function WaitForMover(InterpActor M)
{
	PendingMover = M;
	M.bMonitorMover = true;
	bPreparingMove = true;
	Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	//return;	
}

event bool MoverFinished()
{
	// End:0x90
	if(((Pawn == none) || PendingMover.MyMarker == none) || PendingMover.MyMarker.ProceedWithMove(Pawn))
	{
		PendingMover = none;
		bPreparingMove = false;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function UnderLift(LiftCenter Lift)
{
	//return;	
}

event bool HandlePathObstruction(Actor BlockedBy)
{
	//return ReturnValue;	
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
	out_Location = Location;
	out_Rotation = Rotation;
	//return;	
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
	// End:0x43
	if(Pawn != none)
	{
		Pawn.GetActorEyesViewPoint(out_Location, out_Rotation);		
	}
	else
	{
		out_Location = Location;
		out_Rotation = Rotation;
	}
	//return;	
}

simulated function bool IsAimingAt(Actor ATarget, float Epsilon)
{
	local Vector Loc;
	local Rotator Rot;

	GetPlayerViewPoint(Loc, Rot);
	return (Normal(ATarget.Location - Loc) Dot Vector(Rot)) >= Epsilon;
	//return ReturnValue;	
}

simulated function bool PawnIsFacing(Actor ATarget, float Epsilon)
{
	local Vector pawnToTargetDir;

	// End:0xC1
	if(Pawn != none)
	{
		pawnToTargetDir = ATarget.Location - Pawn.Location;
		pawnToTargetDir.Z = 0.0000000;
		// End:0xC1
		if(!IsZero(pawnToTargetDir))
		{
			return (pawnToTargetDir Dot Vector(Pawn.Rotation)) >= Epsilon;
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function bool LandingShake()
{
	return false;
	//return ReturnValue;	
}

event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
	//return;	
}

event bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
{
	//return ReturnValue;	
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
	//return ReturnValue;	
}

event bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
	//return ReturnValue;	
}

event NotifyFallingHitWall(Vector HitNormal, Actor Wall)
{
	//return;	
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
	//return ReturnValue;	
}

event NotifyJumpApex()
{
	//return;	
}

event NotifyMissedJump()
{
	//return;	
}

event ReachedPreciseDestination()
{
	//return;	
}

// Export UController::execInLatentExecution(FFrame&, void* const)
native final function bool InLatentExecution(int LatentActionNumber);

// Export UController::execStopLatentExecution(FFrame&, void* const)
native final function StopLatentExecution();

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	// End:0x129
	if(Pawn == none)
	{
		// End:0x86
		if(PlayerReplicationInfo == none)
		{
			Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);			
		}
		else
		{
			PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
		}
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		super.DisplayDebug(HUD, out_YL, out_YPos);
		return;
	}
	Canvas.SetDrawColor(255, 0, 0);
	Canvas.DrawText((("CONTROLLER " $ (GetItemName(string(self)))) $ " Pawn ") $ (GetItemName(string(Pawn))));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText(" bPreciseDestination:" @ string(bPreciseDestination));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	// End:0x3A4
	if(HUD.ShouldDisplayDebug('AI'))
	{
		// End:0x31C
		if(Enemy != none)
		{
			Canvas.DrawText((("     STATE: " $ string(GetStateName())) $ " Enemy ") $ Enemy.GetHumanReadableName(), false);			
		}
		else
		{
			Canvas.DrawText(("     STATE: " $ string(GetStateName())) $ " NO Enemy ", false);
		}
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	//return;	
}

simulated function string GetHumanReadableName()
{
	// End:0x31
	if(PlayerReplicationInfo != none)
	{
		return PlayerReplicationInfo.PlayerName;		
	}
	else
	{
		return GetItemName(string(self));
	}
	//return ReturnValue;	
}

function bool IsDead()
{
	//return ReturnValue;	
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	// End:0x5C
	if(Action != none)
	{
		// End:0x49
		if(Pawn != none)
		{
			Pawn.OnTeleport(Action);			
		}
		else
		{
			super.OnTeleport(Action);
		}
	}
	//return;	
}

function OnAttachToActor(SeqAct_AttachToActor Action)
{
	// End:0x3A
	if(Pawn != none)
	{
		Pawn.OnAttachToActor(Action);		
	}
	else
	{
		super.OnAttachToActor(Action);
	}
	//return;	
}

function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
	// End:0x46
	if(inAction.InputLinks[0].bHasImpulse)
	{
		bGodMode = true;		
	}
	else
	{
		// End:0x8C
		if(inAction.InputLinks[1].bHasImpulse)
		{
			bGodMode = false;			
		}
		else
		{
			bGodMode = !bGodMode;
		}
	}
	//return;	
}

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
	// End:0x3A
	if(Pawn != none)
	{
		Pawn.OnSetPhysics(Action);		
	}
	else
	{
		super.OnSetPhysics(Action);
	}
	//return;	
}

simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
	// End:0x3A
	if(Pawn != none)
	{
		Pawn.OnSetVelocity(Action);		
	}
	else
	{
		super.OnSetVelocity(Action);
	}
	//return;	
}

simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx, optional bool bAdjacentIdx)
{
	//return;	
}

simulated event NotifyCoverAdjusted()
{
	//return;	
}

simulated function bool NotifyCoverClaimViolation(Controller NewClaim, CoverLink Link, int SlotIdx)
{
	//return ReturnValue;	
}

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
	// End:0x37
	if(Pawn != none)
	{
		Pawn.OnModifyHealth(Action);
	}
	//return;	
}

function NotifyAddInventory(Inventory NewItem)
{
	//return;	
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	// End:0x37
	if(Pawn != none)
	{
		Pawn.OnToggleHidden(Action);
	}
	//return;	
}

event bool IsSpectating()
{
	return false;
	//return ReturnValue;	
}

event bool IsInCombat(optional bool bForceCheck)
{
	//return ReturnValue;	
}

event CurrentLevelUnloaded()
{
	//return;	
}

function SendMessage(PlayerReplicationInfo Recipient, name MessageType, float Wait, optional Class<DamageType> DamageType)
{
	//return;	
}

function ReadyForLift()
{
	//return;	
}

simulated function InitNavigationHandle()
{
	// End:0x27
	if(NavigationHandleClass != none)
	{
		NavigationHandle = new (self) NavigationHandleClass;
	}
	//return;	
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
	// End:0x40
	if(Pawn != none)
	{
		Pawn.InterpolationStarted(InterpAction, GroupInst);
	}
	super.InterpolationStarted(InterpAction, GroupInst);
	//return;	
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
	// End:0x37
	if(Pawn != none)
	{
		Pawn.InterpolationFinished(InterpAction);
	}
	super.InterpolationFinished(InterpAction);
	//return;	
}

event bool GeneratePathToActor(Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath)
{
	//return ReturnValue;	
}

event bool GeneratePathToLocation(Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath)
{
	//return ReturnValue;	
}

state Dead
{
	ignores KilledBy, HearNoise, SeePlayer;

	function bool IsDead()
	{
		return true;
		//return ReturnValue;		
	}

	function PawnDied(Pawn P)
	{
		// End:0x4F
		if(int(WorldInfo.NetMode) != int(NM_Client))
		{
			WarnInternal(string(self) @ "Pawndied while dead");
			ScriptTrace();
		}
		//return;		
	}

	reliable server function ServerRestartPlayer()
	{
		// End:0x2B
		if(int(WorldInfo.NetMode) == int(NM_Client))
		{
			return;
		}
		// End:0x44
		if(Pawn != none)
		{
			UnPossess();
		}
		WorldInfo.Game.RestartPlayer(self);
		//return;		
	}
	stop;	
}

state RoundEnded
{
	ignores ReceiveWarning, TakeDamage, Falling, NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, HitWall, 
		NotifyBump, KilledBy, HearNoise, SeePlayer;

	function bool GamePlayEndedState()
	{
		return true;
		//return ReturnValue;		
	}

	event BeginState(name PreviousStateName)
	{
		// End:0x71
		if(Pawn != none)
		{
			Pawn.TurnOff();
			StopFiring();
			// End:0x71
			if(!bIsPlayer)
			{
				Pawn.UnPossessed();
				Pawn = none;
			}
		}
		// End:0x83
		if(!bIsPlayer)
		{
			Destroy();
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bSlowerZAcquire=true
	MinHitWall=-1.0000000
	NavigationHandleClass=Class'Engine.NavigationHandle'
	SightCounterInterval=0.2000000
	MaxMoveTowardPawnTargetTime=1.2000000
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bHidden=true
	bOnlyRelevantToOwner=true
	bHiddenEd=true
	RotationRate=(Pitch=2048,Yaw=30000,Roll=30000)
}