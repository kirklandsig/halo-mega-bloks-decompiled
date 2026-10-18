class UTBot extends UDKBot;

const MAXSTAKEOUTDIST = 2000;
const ENEMYLOCATIONFUZZ = 1200;
const TACTICALHEIGHTADVANTAGE = 320;
const MINSTRAFEDIST = 200;
const MINVIEWDIST = 200;
const AngleConvert = 0.0000958738;

var Pawn InstantWarningShooter;
var float LastWarningTime;
var bool bHuntPlayer;
var bool bCanFire;
var bool bStrafeDir;
var bool bChangeDir;
var bool bFrustrated;
var bool bInitLifeMessage;
var bool bReachedGatherPoint;
var bool bTacticalDoubleJump;
var bool bWasNearObjective;
var bool bHasFired;
var bool bForcedDirection;
var bool bFireSuccess;
var bool bStoppedFiring;
var bool bMustCharge;
var bool bPursuingFlag;
var bool bJustLanded;
var bool bRecommendFastMove;
var bool bIgnoreEnemyChange;
var bool bHasSuperWeapon;
var bool bPendingDoubleJump;
var bool bAllowedToImpactJump;
var bool bScriptedFrozen;
var bool bSendFlagMessage;
var bool bForceNoDetours;
var bool bShortCamp;
var bool bBetrayTeam;
var bool bSpawnedByKismet;
var bool bFinalStretch;
var bool bDirectHunt;
var transient bool bCheckDriverPickups;
var transient bool bResetCombatTimer;
var Actor ImpactTarget;
var float ImpactJumpZ;
var float MaxSpecialJumpZ;
var name OldMessageType;
var int OldMessageID;
var int LastTauntIndex;
var Class<UTVehicle> KilledVehicleClass;
var Vector HidingSpot;
var float Aggressiveness;
var float LastAttractCheck;
var NavigationPoint BlockedPath;
var float AcquireTime;
var float Aggression;
var float LoseEnemyCheckTime;
var Actor StartleActor;
var float StartTacticalTime;
var float LastUnderFire;
var float RetreatStartTime;
var float ForcedFlagDropTime;
var float BaseAlertness;
var float Accuracy;
var float BaseAggressiveness;
var float StrafingAbility;
var float CombatStyle;
var float Tactics;
var float ReactionTime;
var float Jumpiness;
var Class<Weapon> FavoriteWeapon;
var float OldMessageTime;
var string GoalString;
var string SoakString;
var UTBot NextSquadMember;
var float ReTaskTime;
var UTDefensePoint DefensePoint;
var NavigationPoint DefensivePosition;
var Actor NoVehicleGoal;
var Vector DirectionHint;
var float StopStartTime;
var float LastRespawnTime;
var float FailedHuntTime;
var Pawn FailedHuntEnemy;
var float LastSearchTime;
var float LastSearchWeight;
var float CampTime;
var int NumRandomJumps;
var float LastFireAttempt;
var float GatherTime;
var name OrderNames[16];
var name OldOrders;
var Controller OldOrderGiver;
var Vector LastKnownPosition;
var Vector LastKillerPosition;
var Actor ScriptedTarget;
var float LastActionMusicUpdate;
var float LastTryHoverboardTime;
var Actor LastFireTarget;
var float LastCanAttackCheckTime;
var float LastInjuredVoiceMessageTime;
//var delegate<CustomActionFunc> __CustomActionFunc__Delegate;

function EnemyJustTeleported()
{
	local EnemyPosition NewPosition;

	LineOfSightTo(Enemy);
	SavedPositions.Remove(0, SavedPositions.Length);
	NewPosition.Position = Enemy.GetTargetLocation();
	NewPosition.Velocity = Enemy.Velocity;
	NewPosition.Time = WorldInfo.TimeSeconds;
	SavedPositions[0] = NewPosition;
	//return;	
}

function WasKilledBy(Controller Other)
{
	// End:0x72
	if((Other != none) && Other.Pawn != none)
	{
		LastKillerPosition = Other.Pawn.Location;
	}
	//return;	
}

function StartMonitoring(Pawn P, float MaxDist)
{
	MonitoredPawn = P;
	MonitorStartLoc = P.Location;
	MonitorMaxDistSq = MaxDist * MaxDist;
	//return;	
}

function PawnDied(Pawn P)
{
	// End:0x19
	if(Pawn != P)
	{
		return;
	}
	PendingMover = none;
	super(Controller).PawnDied(P);
	//return;	
}

function Destroyed()
{
	// End:0x2E
	if(Pawn != none)
	{
		Pawn.Suicide();
	}
	// End:0x66
	if(Squad != none)
	{
		UTSquadAI(Squad).RemoveBot(self);
	}
	// End:0x94
	if(DefensePoint != none)
	{
		DefensePoint.FreePoint();
	}
	super(Controller).Destroyed();
	//return;	
}

function PostBeginPlay()
{
	super(Controller).PostBeginPlay();
	SetCombatTimer();
	Aggressiveness = BaseAggressiveness;
	// End:0x73
	if(UTGame(WorldInfo.Game).bSoaking)
	{
		bSoaking = true;
	}
	//return;	
}

event SpawnedByKismet()
{
	bSpawnedByKismet = true;
	// End:0x3F
	if(Pawn != none)
	{
		Pawn.MaxDesiredSpeed = 1.0000000;
	}
	//return;	
}

simulated function bool LandingShake()
{
	return true;
	//return ReturnValue;	
}

function bool HasTimedPowerup()
{
	local Vehicle V;

	// End:0x34
	if(Pawn.FindInventoryType(Class'UTGame.UTTimedPowerup', true) != none)
	{
		return true;		
	}
	else
	{
		V = Vehicle(Pawn);
		// End:0xCA
		if((V != none) && V.Driver != none)
		{
			return V.Driver.FindInventoryType(Class'UTGame.UTTimedPowerup', true) != none;			
		}
		else
		{
			return false;
		}
	}
	//return ReturnValue;	
}

function NotifyAddInventory(Inventory NewItem)
{
	// End:0x0F
	if(bHasSuperWeapon)
	{
		return;
	}
	bHasSuperWeapon = (UTWeapon(NewItem) != none) && UTWeapon(NewItem).bSuperWeapon;
	//return;	
}

event SetupSpecialPathAbilities()
{
	bAllowedToImpactJump = CanImpactJump();
	// End:0x148
	if(Pawn.bCanJump)
	{
		MaxSpecialJumpZ = Pawn.JumpZ;
		// End:0x80
		if(bAllowedToImpactJump)
		{
			MaxSpecialJumpZ += ImpactJumpZ;
		}
		// End:0x136
		if((UTPawn(Pawn) != none) && UTPawn(Pawn).bCanDoubleJump)
		{
			MultiJumpZ = (Pawn.JumpZ * 0.3000000) + float(UTPawn(Pawn).MultiJumpBoost);
			MaxSpecialJumpZ += MultiJumpZ;			
		}
		else
		{
			MultiJumpZ = 0.0000000;
		}		
	}
	else
	{
		MaxSpecialJumpZ = 0.0000000;
	}
	//return;	
}

event bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
	local Vector JumpDir;
	local UTCarriedObject Flag;

	// End:0x1A8
	if((UTPawn(Pawn) != none) && int(Pawn.Physics) == int(3))
	{
		// End:0x1A8
		if(((InLatentExecution(503) && MoveTarget != none) && MoveTarget.PhysicsVolume.bWaterVolume!) && Pawn.HeadVolume.bWaterVolume!)
		{
			JumpDir = MoveTarget.Location - Pawn.Location;
			JumpDir.Z = 0.0000000;
			ImpactVelocity = vect(0.0000000, 0.0000000, 0.0000000);
			UTPawn(Pawn).JumpOutOfWater(Normal(JumpDir));
			bNotifyApex = true;
			bPendingDoubleJump = true;
		}
	}
	LastBlockingVehicle = Vehicle(Wall);
	// End:0x623
	if((LastBlockingVehicle != none) && Vehicle(Pawn) == none)
	{
		// End:0x28F
		if((UTCarriedObject(MoveTarget) != none) && MoveTarget.Touching.Find(LastBlockingVehicle) != -1)
		{
			MoveTarget.Touch(Pawn, none, MoveTarget.Location, HitNormal);			
		}
		else
		{
			// End:0x393
			if(UTGameObjective(MoveTarget) != none)
			{
				Flag = UTGameObjective(MoveTarget).GetFlag();
				// End:0x393
				if(((Flag != none) && Flag.bHome) && Flag.Touching.Find(LastBlockingVehicle) != -1)
				{
					Flag.Touch(Pawn, none, Flag.Location, HitNormal);
				}
			}
		}
		// End:0x48B
		if((Wall == RouteGoal) || (Vehicle(RouteGoal) != none) && Wall == Vehicle(RouteGoal).GetVehicleBase())
		{
			// End:0x489
			if(LastBlockingVehicle != none)
			{
				LastBlockingVehicle.TryToDrive(Pawn);
				// End:0x489
				if(Vehicle(Pawn) != none)
				{
					LastBlockingVehicle = none;
					UTSquadAI(Squad).BotEnteredVehicle(self);
					WhatToDoNext();
				}
			}
			return true;
		}
		// End:0x4C2
		if((LastBlockingVehicle.Controller != none) || FRand() < 0.9000000)
		{
			return false;			
		}
		else
		{
			bNotifyApex = true;
			bPendingDoubleJump = true;
			Pawn.SetPhysics(2);
			Pawn.Velocity = GetDestinationPosition() - Pawn.Location;
			Pawn.Velocity.Z = 0.0000000;
			Pawn.Velocity = Pawn.GroundSpeed * Normal(Pawn.Velocity);
			Pawn.Velocity.Z = Pawn.JumpZ;
		}
	}
	return false;
	//return ReturnValue;	
}

function FearThisSpot(UTAvoidMarker aSpot)
{
	local int I;

	// End:0x2F
	if((Pawn == none) || Skill < (float(1) + (4.5000000 * FRand())))
	{
		return;
	}
	// End:0x44
	if(LineOfSightTo(aSpot)!)
	{
		return;
	}
	I = 0;
	J0x4F:

	// End:0xD3 [Loop If]
	if(I < 2)
	{
		// End:0xC5
		if((FearSpots[I] == none) || FearSpots[I].bDeleteMe)
		{
			FearSpots[I] = aSpot;
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x4F;
	}
	I = 0;
	J0xDE:

	// End:0x1AA [Loop If]
	if(I < 2)
	{
		// End:0x19C
		if(VSize(Pawn.Location - FearSpots[I].Location) > VSize(Pawn.Location - aSpot.Location))
		{
			FearSpots[I] = aSpot;
			return;
		}
		I++;
		// [Loop Continue]
		goto J0xDE;
	}
	//return;	
}

function Startle(Actor Feared)
{
	// End:0x1A
	if(Vehicle(Pawn) != none)
	{
		return;
	}
	GoalString = "STARTLED!";
	StartleActor = Feared;
	GotoState('Startled');
	//return;	
}

function SetCombatTimer()
{
	SetTimer(1.2000000 - (0.0900000 * FMin(10.0000000, Skill + ReactionTime)), true);
	//return;	
}

function bool CanImpactJump()
{
	return (((ImpactJumpZ > 0.0000000) && Pawn.Health >= 80) && Skill >= 5.0000000) && UTSquadAI(Squad).AllowImpactJumpBy(self);
	//return ReturnValue;	
}

event TimeDJReset()
{
	SetTimer(12.0000000, false, 'ResetDoubleJump');
	//return;	
}

function ResetDoubleJump()
{
	local UTPawn P;

	P = UTPawn(Pawn);
	// End:0x7F
	if((P == none) && Vehicle(Pawn) != none)
	{
		P = UTPawn(Vehicle(Pawn).Driver);
	}
	// End:0xAF
	if(P != none)
	{
		P.bCanDoubleJump = true;
	}
	//return;	
}

function WaitForMover(InterpActor M)
{
	ReadyForLift();
	// End:0x61
	if((Enemy != none) && (WorldInfo.TimeSeconds - LastSeenTime) < 3.0000000)
	{
		Focus = Enemy;
	}
	StopStartTime = WorldInfo.TimeSeconds;
	super(Controller).WaitForMover(M);
	//return;	
}

function ReadyForLift()
{
	local float Dist;

	// End:0xE6
	if(Vehicle(Pawn) != none)
	{
		// End:0x3E
		if(UTVehicle_Hoverboard(Pawn) != none)
		{
			LeaveVehicle(false);			
		}
		else
		{
			Pawn.SetAnchor(Pawn.GetBestAnchor(Pawn, Pawn.Location, true, true, Dist));
			// End:0xE6
			if(LiftCenter(Pawn.Anchor) != none)
			{
				LeaveVehicle(false);
			}
		}
	}
	//return;	
}

function bool WeaponFireAgain(bool bFinishedFire)
{
	LastFireAttempt = WorldInfo.TimeSeconds;
	bFireSuccess = false;
	// End:0x59
	if(ScriptedTarget != none)
	{
		Focus = ScriptedTarget;		
	}
	else
	{
		// End:0x7B
		if(Focus == none)
		{
			Focus = Enemy;
		}
	}
	// End:0x295
	if(Focus != none)
	{
		// End:0x1F7
		if(Pawn.IsFiring()!)
		{
			// End:0x1E8
			if(((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon) || Pawn.NeedToTurn(GetFocalPoint())! && CanAttack(Focus))
			{
				LastCanAttackCheckTime = WorldInfo.TimeSeconds;
				bCanFire = true;
				bStoppedFiring = false;
				bFireSuccess = Pawn.BotFire(bFinishedFire);
				LastFireTarget = Focus;
				return bFireSuccess;				
			}
			else
			{
				bCanFire = false;
			}			
		}
		else
		{
			// End:0x295
			if(bCanFire && ShouldFireAgain())
			{
				// End:0x295
				if(Focus.bDeleteMe!)
				{
					bStoppedFiring = false;
					bFireSuccess = Pawn.BotFire(bFinishedFire);
					LastFireTarget = Focus;
					return bFireSuccess;
				}
			}
		}
	}
	StopFiring();
	return false;
	//return ReturnValue;	
}

function bool ShouldFireAgain()
{
	local UTWeapon UTWeap;
	local float LandTime, ProjTime, TargetGravityZ;
	local Vector HitLocation, HitNormal, TargetLoc;

	// End:0x11
	if(ScriptedTarget != none)
	{
		return true;
	}
	// End:0x44
	if((Focus != LastFireTarget) && Pawn(Focus) == none)
	{
		return false;
	}
	UTWeap = UTWeapon(Pawn.Weapon);
	// End:0x16A
	if(UTWeap != none)
	{
		// End:0xF9
		if((WorldInfo.TimeSeconds - LastCanAttackCheckTime) > 1.0000000)
		{
			LastCanAttackCheckTime = WorldInfo.TimeSeconds;
			// End:0xF9
			if(CanAttack(Focus)!)
			{
				return false;
			}
		}
		// End:0x120
		if(UTWeap.bFastRepeater)
		{
			return true;			
		}
		else
		{
			// End:0x16A
			if(UTWeap.bLockedAimWhileFiring && Focus.IsStationary()!)
			{
				return false;
			}
		}
	}
	// End:0x779
	if((Pawn.Weapon == none) || Pawn.Weapon.bMeleeWeapon!)
	{
		// End:0x260
		if(Pawn.FireOnRelease())
		{
			return (FRand() < 0.8000000) || (((Skill > (1.0000000 + (3.0000000 * FRand()))) && UTWeap != none) && UTWeap.IsFullyCharged()) && LineOfSightTo(Focus);			
		}
		else
		{
			// End:0x76B
			if((UTWeap != none) && Focus == Enemy)
			{
				// End:0x336
				if(UTWeap.bInstantHit)
				{
					// End:0x333
					if(((VSize(Enemy.Velocity) > Enemy.GroundSpeed) && FRand() < 0.4000000) && ((Skill + Tactics) + ReactionTime) > (2.0000000 + (4.0000000 * FRand())))
					{
						return false;
					}					
				}
				else
				{
					// End:0x76B
					if((UTWeap.bRecommendSplashDamage && int(Focus.Physics) == int(2)) && ((Skill + Accuracy) + Tactics) > (2.0000000 + (2.0000000 * FRand())))
					{
						// End:0x76B
						if((int(UTWeap.CurrentFireMode) < UTWeap.WeaponProjectiles.Length) && UTWeap.WeaponProjectiles[int(UTWeap.CurrentFireMode)] != none)
						{
							// End:0x76B
							if(Trace(HitLocation, HitNormal, Focus.Location - vect(0.0000000, 0.0000000, 10000.0000000), Focus.Location, false, Pawn(Focus).GetCollisionExtent()) != none)
							{
								TargetLoc = Focus.Location;
								TargetLoc.Z = HitLocation.Z;
								TargetGravityZ = Focus.GetGravityZ();
								LandTime = (Focus.Velocity.Z- - Sqrt(Square(Focus.Velocity.Z) - ((2.0000000 * TargetGravityZ) * (Focus.Location.Z - TargetLoc.Z)))) / TargetGravityZ;
								ProjTime = UTWeap.WeaponProjectiles[int(UTWeap.CurrentFireMode)].static.StaticGetTimeToLocation(TargetLoc, UTWeap.GetPhysicalFireStartLoc(), self);
								// End:0x76B
								if((LandTime + 0.1000000) > ProjTime)
								{
									// End:0x743
									if((LandTime - UTWeap.GetFireInterval(UTWeap.CurrentFireMode)) > ProjTime)
									{
										return true;										
									}
									else
									{
										SetTimer(LandTime - ProjTime, true);
										bResetCombatTimer = true;
										return false;
									}
								}
							}
						}
					}
				}
			}
		}
		// End:0x779
		if(FRand() < 0.8000000)
		{
			return true;
		}
	}
	// End:0x80D
	if(Pawn(Focus) != none)
	{
		return (Pawn.bStationary || Pawn(Focus).bStationary) && Pawn(Focus).Health > 0;
	}
	return IsShootingObjective();
	//return ReturnValue;	
}

function TimedFireWeaponAtEnemy()
{
	bResetCombatTimer = false;
	// End:0x4F
	if((Enemy == none) || FireWeaponAt(Enemy))
	{
		// End:0x4C
		if(bResetCombatTimer!)
		{
			SetCombatTimer();
		}		
	}
	else
	{
		// End:0x69
		if(bResetCombatTimer!)
		{
			SetTimer(0.1000000, true);
		}
	}
	//return;	
}

function bool FireWeaponAt(Actor A)
{
	// End:0x22
	if(A == none)
	{
		A = Enemy;
	}
	// End:0x4C
	if((A == none) || Focus != A)
	{
		return false;
	}
	Focus = A;
	// End:0xC9
	if(Pawn.Weapon != none)
	{
		// End:0xC6
		if(Pawn.Weapon.HasAnyAmmo())
		{
			return WeaponFireAgain(false);
		}		
	}
	else
	{
		return WeaponFireAgain(false);
	}
	return false;
	//return ReturnValue;	
}

function bool CanAttack(Actor Other)
{
	local UTMapInfo WorldMapInfo;

	WorldMapInfo = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0xF2
	if(((WorldMapInfo != none) && WorldMapInfo.VisibilityModifier < 1.0000000) && (WorldMapInfo.VisibilityModifier * Pawn.SightRadius) < VSize(Other.Location - Pawn.Location))
	{
		return false;
	}
	return Pawn.CanAttack(Other);
	//return ReturnValue;	
}

function OnAIStartFireAt(UTSeqAct_AIStartFireAt FireAction)
{
	local SeqVar_Object ObjVar;

	// End:0x82
	foreach FireAction.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Fire At")
	{
		ScriptedTarget = Actor(ObjVar.GetObjectValue());
		// End:0x81
		if(ScriptedTarget != none)
		{
			// End:0x82
			break;
		}		
	}	
	// End:0x142
	if(ScriptedTarget != none)
	{
		// End:0xE6
		if(ScriptedTarget.IsA('Controller'))
		{
			ScriptedTarget = Controller(ScriptedTarget).Pawn;
		}
		Focus = ScriptedTarget;
		SwitchToBestWeapon();
		ScriptedFireMode = FireAction.ForcedFireMode;
		SetTimer(0.1000000, true, 'TimedFireWeaponAtScriptedTarget');		
	}
	else
	{
		FireAction.ScriptLog("WARNING: Missing Actor to fire at");
	}
	//return;	
}

function TimedFireWeaponAtScriptedTarget()
{
	Focus = ScriptedTarget;
	FireWeaponAt(ScriptedTarget);
	//return;	
}

function StopFiring()
{
	bStoppedFiring = (Pawn == none) || Pawn.StopFiring();
	bCanFire = false;
	//return;	
}

function OnAIStopFire(UTSeqAct_AIStopFire FireAction)
{
	ScriptedTarget = none;
	StopFiring();
	ClearTimer('TimedFireWeaponAtScriptedTarget');
	//return;	
}

simulated function float RateWeapon(Weapon W)
{
	local float Rating;

	Rating = (UTWeapon(W).GetAIRating() + (FRand() * 0.0500000)) + (WeaponPreference(W));
	return Rating;
	//return ReturnValue;	
}

function float WeaponPreference(Weapon W)
{
	local float WeaponStickiness;

	// End:0xC2
	if((((DefensePoint != none) && DefensePoint.WeaponPreference != none) && ClassIsChildOf(W.Class, DefensePoint.WeaponPreference)) && Pawn.ReachedDestination(DefensePoint.GetMoveTarget()))
	{
		return 0.3000000;
	}
	// End:0xF1
	if((Focus != none) && Pawn(Focus) == none)
	{
		return 0.0000000;
	}
	// End:0x167
	if((FavoriteWeapon != none) && ClassIsChildOf(W.Class, FavoriteWeapon))
	{
		// End:0x161
		if(W == Pawn.Weapon)
		{
			return 0.3000000;
		}
		return 0.1500000;
	}
	// End:0x24D
	if(W == Pawn.Weapon)
	{
		WeaponStickiness = 0.1000000;
		// End:0x204
		if((Pawn.Weapon.AIRating < 0.5000000) || Enemy == none)
		{
			return WeaponStickiness + 0.1000000;			
		}
		else
		{
			// End:0x23C
			if(Skill < float(5))
			{
				return (WeaponStickiness + 0.6000000) - (0.1000000 * Skill);				
			}
			else
			{
				return WeaponStickiness + 0.1000000;
			}
		}
	}
	return 0.0000000;
	//return ReturnValue;	
}

function bool ProficientWithWeapon()
{
	local float proficiency;

	// End:0x37
	if((Pawn == none) || Pawn.Weapon == none)
	{
		return false;
	}
	proficiency = Skill;
	// End:0xAC
	if((FavoriteWeapon != none) && ClassIsChildOf(Pawn.Weapon.Class, FavoriteWeapon))
	{
		proficiency += float(2);
	}
	return proficiency > (float(2) + (FRand() * float(4)));
	//return ReturnValue;	
}

function bool CanComboMoving()
{
	// End:0x58
	if((Skill >= float(5)) && ClassIsChildOf(Pawn.Weapon.Class, FavoriteWeapon))
	{
		return true;
	}
	// End:0x74
	if(Skill >= float(7))
	{
		return FRand() < 0.9000000;
	}
	return (Skill - float(3)) > (float(4) * FRand());
	//return ReturnValue;	
}

function bool CanCombo()
{
	// End:0x0F
	if(Stopped())
	{
		return true;
	}
	// End:0x3A
	if(int(Pawn.Physics) == int(2))
	{
		return false;
	}
	// End:0x85
	if((Pawn.Acceleration == vect(0.0000000, 0.0000000, 0.0000000)) || MoveTarget == Enemy)
	{
		return true;
	}
	return CanComboMoving();
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
	local UTWeapon Best[5], Moving, Temp;
	local bool bFound;
	local int I;
	local UTWeapon W;
	local string S;
	local Canvas Canvas;

	super(AIController).DisplayDebug(HUD, YL, YPos);
	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);
	// End:0xBF
	if(Squad != none)
	{
		Squad.DisplayDebug(HUD, YL, YPos);		
	}
	else
	{
		Canvas.DrawText("NO SQUAD");
	}
	// End:0x194
	if(DefensePoint != none)
	{
		Canvas.DrawText((((((("     " $ GoalString) $ " DefensePoint ") $ (GetItemName(string(DefensePoint)))) $ " Sniping ") $ string(IsSniping())) $ " ReTaskTime ") $ string(ReTaskTime), false);		
	}
	else
	{
		Canvas.DrawText((("     " $ GoalString) $ " ReTaskTime ") $ string(ReTaskTime), false);
	}
	YPos += (float(2) * YL);
	Canvas.SetPos(4.0000000, YPos);
	// End:0x3B1
	if(Enemy != none)
	{
		Canvas.DrawText((((((((("Enemy Dist " $ string(VSize(Enemy.Location - Pawn.Location))) $ " Strength ") $ string(RelativeStrength(Enemy))) $ " Acquired ") $ string(bEnemyAcquired)) $ " LastSeenTime ") $ string(WorldInfo.TimeSeconds - LastSeenTime)) $ " AcquireTime ") $ string(WorldInfo.TimeSeconds - AcquireTime));
		YPos += YL;
		Canvas.SetPos(4.0000000, YPos);
	}
	// End:0x558
	foreach Pawn.InvManager.InventoryActors(Class'UTGame.UTWeapon', W)
	{
		bFound = false;
		I = 0;
		J0x411:

		// End:0x474 [Loop If]
		if(I < 5)
		{
			// End:0x466
			if(Best[I] == none)
			{
				bFound = true;
				Best[I] = W;
				// [Explicit Break]
				goto J0x474;
			}
			I++;
			// [Loop Continue]
			goto J0x411;
		}
		J0x474:

		// End:0x557
		if(bFound!)
		{
			Moving = W;
			I = 0;
			J0x4A1:

			// End:0x557 [Loop If]
			if(I < 5)
			{
				// End:0x549
				if(Best[I].CurrentRating < Moving.CurrentRating)
				{
					Temp = Moving;
					Moving = Best[I];
					Best[I] = Temp;
				}
				I++;
				// [Loop Continue]
				goto J0x4A1;
			}
		}		
	}	
	Canvas.DrawText((((("Weapons Fire last attempt at " $ string(LastFireAttempt)) $ " success ") $ string(bFireSuccess)) $ " stopped firing ") $ string(bStoppedFiring), false);
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	I = 0;
	J0x632:

	// End:0x6D3 [Loop If]
	if(I < 5)
	{
		// End:0x6C5
		if(Best[I] != none)
		{
			S = (S @ Best[I].GetHumanReadableName()) @ string(Best[I].CurrentRating);
		}
		I++;
		// [Loop Continue]
		goto J0x632;
	}
	Canvas.DrawText("Weapons: " $ S, false);
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText((((("PERSONALITY: Alertness " $ string(BaseAlertness)) $ " Accuracy ") $ string(Accuracy)) $ " Favorite Weap ") $ string(FavoriteWeapon));
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText((((((("    Aggressiveness " $ string(BaseAggressiveness)) $ " CombatStyle ") $ string(CombatStyle)) $ " Strafing ") $ string(StrafingAbility)) $ " Tactics ") $ string(Tactics));
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	//return;	
}

function name GetOrders()
{
	local UTSquadAI UTSquad;

	UTSquad = UTSquadAI(Squad);
	// End:0x41
	if(UTHoldSpot(DefensePoint) != none)
	{
		return 'Hold';		
	}
	else
	{
		// End:0x5D
		if(UTSquad == none)
		{
			return 'ATTACK';			
		}
		else
		{
			// End:0x97
			if(PlayerController(UTSquad.SquadLeader) != none)
			{
				return 'Follow';				
			}
			else
			{
				return UTSquad.GetOrders();
			}
		}
	}
	//return ReturnValue;	
}

function YellAt(PlayerReplicationInfo Moron)
{
	local float Threshold;

	// End:0x21
	if(Enemy == none)
	{
		Threshold = 0.2000000;		
	}
	else
	{
		Threshold = 0.7000000;
	}
	// End:0x42
	if(FRand() < Threshold)
	{
		return;
	}
	SendMessage(Moron, 'FRIENDLYFIRE', 5.0000000);
	//return;	
}

function SendMessage(PlayerReplicationInfo Recipient, name MessageType, float Wait, optional Class<DamageType> DamageType)
{
	// End:0x53
	if((MessageType == OldMessageType) && (WorldInfo.TimeSeconds - OldMessageTime) < Wait)
	{
		return;
	}
	// End:0xC5
	if(WorldInfo.Game.bGameEnded || WorldInfo.Game.bWaitingToStartMatch)
	{
		return;
	}
	OldMessageType = MessageType;
	OldMessageTime = WorldInfo.TimeSeconds;
	UTPlayerReplicationInfo(PlayerReplicationInfo).VoiceClass.static.SendVoiceMessage(self, Recipient, MessageType, DamageType);
	//return;	
}

function SetBotOrders(name NewOrders, Controller OrderGiver, bool bShouldAck)
{
	// End:0x58
	if(PlayerReplicationInfo.Team != OrderGiver.PlayerReplicationInfo.Team)
	{
		return;
	}
	Aggressiveness = BaseAggressiveness;
	// End:0xAA
	if((NewOrders == 'Hold') || NewOrders == 'Follow')
	{
		Aggressiveness = 1.0000000;
	}
	// End:0xEE
	if(bShouldAck)
	{
		SendMessage(OrderGiver.PlayerReplicationInfo, 'ACK', 5.0000000);
	}
	UTTeamInfo(PlayerReplicationInfo.Team).AI.SetOrders(self, NewOrders, OrderGiver);
	WhatToDoNext();
	//return;	
}

function SetTemporaryOrders(name NewOrders, Controller OrderGiver)
{
	// End:0x7E
	if(OldOrders == 'None')
	{
		OldOrders = GetOrders();
		OldOrderGiver = UTSquadAI(Squad).SquadLeader;
		// End:0x7E
		if(OldOrderGiver == none)
		{
			OldOrderGiver = OrderGiver;
		}
	}
	SetBotOrders(NewOrders, OrderGiver, false);
	//return;	
}

function ClearTemporaryOrders()
{
	// End:0xEC
	if(OldOrders != 'None')
	{
		Aggressiveness = BaseAggressiveness;
		// End:0x69
		if((OldOrders == 'Hold') || OldOrders == 'Follow')
		{
			Aggressiveness = 1.0000000;
		}
		UTTeamInfo(PlayerReplicationInfo.Team).AI.SetOrders(self, OldOrders, OldOrderGiver);
		OldOrders = 'None';
		OldOrderGiver = none;
	}
	//return;	
}

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
	// End:0x118
	if(NoiseMaker.Instigator.IsInvisible())
	{
		// End:0x118
		if((((Skill < float(3)) || (PickupFactory(NoiseMaker) != none) && Projectile(NoiseMaker) != none) || (Vector(Rotation) Dot Normal(NoiseMaker.Instigator.Location - Pawn.Location)) < 0.7000000) || LineOfSightTo(NoiseMaker.Instigator)!)
		{
			return;
		}
	}
	// End:0x16C
	if(UTSquadAI(Squad).SetEnemy(self, NoiseMaker.Instigator))
	{
		WhatToDoNext();
	}
	//return;	
}

event SeePlayer(Pawn SeenPlayer)
{
	// End:0x8B
	if((Squad == none) && WorldInfo.GRI.OnSameTeam(self, SeenPlayer)!)
	{
		Pawn.TriggerEventClass(Class'Engine.SeqEvent_AISeeEnemy', SeenPlayer);		
	}
	else
	{
		// End:0xFE
		if(UTSquadAI(Squad).SetEnemy(self, SeenPlayer))
		{
			Pawn.TriggerEventClass(Class'Engine.SeqEvent_AISeeEnemy', SeenPlayer);
			WhatToDoNext();
		}
	}
	// End:0x15C
	if(Enemy == SeenPlayer)
	{
		VisibleEnemy = Enemy;
		EnemyVisibilityTime = WorldInfo.TimeSeconds;
		bEnemyIsVisible = true;
	}
	//return;	
}

function SetAttractionState()
{
	// End:0x20
	if(Enemy != none)
	{
		GotoState('Fallback');		
	}
	else
	{
		GotoState('Roaming');
	}
	//return;	
}

function bool ClearShot(Vector TargetLoc, bool bImmediateFire)
{
	local bool bSeeTarget;

	// End:0x4A
	if((Enemy == none) || VSize(Enemy.Location - TargetLoc) > float(2000))
	{
		return false;
	}
	bSeeTarget = FastTrace(TargetLoc, Pawn.Location + (Pawn.EyeHeight * vect(0.0000000, 0.0000000, 1.0000000)),, true);
	// End:0x15B
	if((bImmediateFire! && bSeeTarget!) && Pawn.bIsCrouched)
	{
		bSeeTarget = FastTrace(TargetLoc, Pawn.Location + (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)),, true);
	}
	// End:0x16C
	if(bSeeTarget!)
	{
		return false;
	}
	// End:0x248
	if((VSize(Pawn.Location - TargetLoc) < UTWeapon(Pawn.Weapon).GetDamageRadius()) || FastTrace(TargetLoc + (vect(0.0000000, 0.0000000, 0.9000000) * Enemy.GetCollisionHeight()), Pawn.Location,, true)!)
	{
		StopFiring();
		return false;
	}
	return true;
	//return ReturnValue;	
}

function bool CanStakeOut()
{
	local float relstr;

	relstr = RelativeStrength(Enemy);
	// End:0x13E
	if((((bFrustrated || bEnemyInfoValid!) || VSize(Enemy.Location - Pawn.Location) > (0.5000000 * (float(2000) + (((FRand() * relstr) - CombatStyle) * float(2000))))) || (WorldInfo.TimeSeconds - FMax(LastSeenTime, AcquireTime)) > (2.5000000 + FMax(-1.0000000, 3.0000000 * (FRand() + (float(2) * (relstr - CombatStyle)))))) || ClearShot(LastSeenPos, false)!)
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function CheckIfShouldCrouch(Vector StartPosition, Vector TargetPosition, float probability)
{
	local Actor HitActor;
	local Vector HitNormal, HitLocation, projStart;

	// End:0xCC
	if((((WorldInfo.bUseConsoleInput || Pawn.bCanCrouch!) || Pawn.bIsCrouched! && FRand() > probability) || IsSniping()!) || Skill < (float(3) * FRand()))
	{
		Pawn.bWantsToCrouch = false;
		return;
	}
	projStart = Pawn.GetWeaponStartTraceLocation();
	projStart = (projStart + StartPosition) - Pawn.Location;
	projStart.Z = projStart.Z - (1.8000000 * (Pawn.GetCollisionHeight() - Pawn.CrouchHeight));
	HitActor = Trace(HitLocation, HitNormal, TargetPosition, projStart, false);
	// End:0x21C
	if(HitActor == none)
	{
		Pawn.bWantsToCrouch = true;
		return;
	}
	projStart.Z = projStart.Z + (1.8000000 * (Pawn.CylinderComponent.default.CollisionHeight - Pawn.CrouchHeight));
	HitActor = Trace(HitLocation, HitNormal, TargetPosition, projStart, false);
	// End:0x318
	if(HitActor == none)
	{
		Pawn.bWantsToCrouch = false;
		return;
	}
	Pawn.bWantsToCrouch = true;
	//return;	
}

function bool IsSniping()
{
	return ((((DefensePoint != none) && DefensePoint.bSniping) && UTWeapon(Pawn.Weapon) != none) && UTWeapon(Pawn.Weapon).bSniping) && Pawn.ReachedDestination(DefensePoint.GetMoveTarget());
	//return ReturnValue;	
}

function FreePoint()
{
	// End:0x39
	if(DefensePoint != none)
	{
		DefensePoint.FreePoint();
		DefensePoint = none;
	}
	//return;	
}

function bool AssignSquadResponsibility()
{
	// End:0x2E
	if(LastAttractCheck == WorldInfo.TimeSeconds)
	{
		return false;
	}
	LastAttractCheck = WorldInfo.TimeSeconds;
	return UTSquadAI(Squad).AssignSquadResponsibility(self);
	//return ReturnValue;	
}

function float RelativeStrength(Pawn Other)
{
	local float compare;
	local int adjustedOther;

	// End:0x48
	if(Pawn == none)
	{
		WarnInternal("Relative strength with no pawn in state " $ string(GetStateName()));
		return 0.0000000;
	}
	adjustedOther = int(0.5000000 * float(Other.Health + Other.HealthMax));
	compare = 0.0100000 * float(adjustedOther - Pawn.Health);
	// End:0x12F
	if(UTPawn(Pawn) != none)
	{
		compare = compare - UTPawn(Pawn).AdjustedStrength();		
	}
	else
	{
		// End:0x184
		if(UTVehicle(Pawn) != none)
		{
			compare = compare - UTVehicle(Pawn).AdjustedStrength();
		}
	}
	// End:0x1DC
	if(UTPawn(Other) != none)
	{
		compare = compare + UTPawn(Other).AdjustedStrength();		
	}
	else
	{
		// End:0x231
		if(UTVehicle(Other) != none)
		{
			compare = compare + UTVehicle(Other).AdjustedStrength();
		}
	}
	// End:0x38D
	if(UTWeapon(Pawn.Weapon) != none)
	{
		compare -= ((0.5000000 * Pawn.GetDamageScaling()) * UTWeapon(Pawn.Weapon).CurrentRating);
		// End:0x38D
		if(Pawn.Weapon.AIRating < 0.5000000)
		{
			compare += 0.3000000;
			// End:0x38D
			if((Other.Weapon != none) && Other.Weapon.AIRating > 0.5000000)
			{
				compare += 0.3000000;
			}
		}
	}
	// End:0x417
	if(Other.Weapon != none)
	{
		compare += ((0.5000000 * Other.GetDamageScaling()) * Other.Weapon.AIRating);
	}
	// End:0x49A
	if(Other.Location.Z > (Pawn.Location.Z + float(320)))
	{
		compare += 0.2000000;		
	}
	else
	{
		// End:0x51A
		if(Pawn.Location.Z > (Other.Location.Z + float(320)))
		{
			compare -= 0.1500000;
		}
	}
	return compare;
	//return ReturnValue;	
}

function SetEnemyInfo(bool bNewEnemyVisible)
{
	local UTBot B;
	local UTVehicle V;

	// End:0x2B6
	if(bNewEnemyVisible)
	{
		AcquireTime = WorldInfo.TimeSeconds;
		LastSeenTime = WorldInfo.TimeSeconds;
		LastSeenPos = Enemy.Location;
		LastSeeingPos = Pawn.Location;
		bEnemyInfoValid = true;
		// End:0x248
		if(WorldInfo.Game.bTeamGame)
		{
			V = UTVehicle(Enemy);
			// End:0x1A3
			if((V != none) && V.bHasEnemyVehicleSound)
			{
				// End:0x1A0
				if((WorldInfo.TimeSeconds - V.LastEnemyWarningTime) > float(15))
				{
					SendMessage(none, 'INCOMINGVEHICLE', 10.0000000);
				}				
			}
			else
			{
				// End:0x248
				if((((GetOrders()) == 'Defend') && UTGame(WorldInfo.Game) != none) && UTGame(WorldInfo.Game).VehicleList == none)
				{
					SendMessage(none, 'Incoming', 25.0000000);
				}
			}
		}
		// End:0x2B3
		if(UTPlayerController(Enemy.Controller) != none)
		{
			UTPlayerController(Enemy.Controller).ClientMusicEvent(0);
		}		
	}
	else
	{
		LastSeenTime = -1000.0000000;
		bEnemyInfoValid = false;
		B = UTSquadAI(Squad).SquadMembers;
		J0x302:

		// End:0x39B [Loop If]
		if(B != none)
		{
			// End:0x370
			if(B.Enemy == Enemy)
			{
				AcquireTime = FMax(AcquireTime, B.AcquireTime);
			}
			B = B.NextSquadMember;
			// [Loop Continue]
			goto J0x302;
		}
	}
	//return;	
}

function EnemyChanged(bool bNewEnemyVisible)
{
	bEnemyAcquired = false;
	SetEnemyInfo(bNewEnemyVisible);
	//return;	
}

function bool StrafeFromDamage(float Damage, Class<DamageType> DamageType, bool bFindDest)
{
	//return ReturnValue;	
}

event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
	local Vector JumpDir;

	// End:0x1A
	if(Vehicle(Pawn) != none)
	{
		return;
	}
	// End:0xEF
	if(NewVolume.bWaterVolume)
	{
		bPlannedJump = false;
		// End:0x7E
		if(Pawn.bCanSwim!)
		{
			MoveTimer = -1.0000000;			
		}
		else
		{
			// End:0xEC
			if((int(Pawn.Physics) != int(3)) && int(Pawn.Physics) != int(10))
			{
				Pawn.SetPhysics(3);
			}
		}		
	}
	else
	{
		// End:0x307
		if(int(Pawn.Physics) == int(3))
		{
			// End:0x157
			if(Pawn.bCanFly)
			{
				Pawn.SetPhysics(4);				
			}
			else
			{
				Pawn.SetPhysics(2);
				// End:0x307
				if(((Pawn.bCanWalk && ((Abs(Pawn.Acceleration.X) + Abs(Pawn.Acceleration.Y)) + Abs(Acceleration.Z)) > float(0)) && GetDestinationPosition().Z >= Pawn.Location.Z) && Pawn.CheckWaterJump(JumpDir))
				{
					ImpactVelocity = vect(0.0000000, 0.0000000, 0.0000000);
					UTPawn(Pawn).JumpOutOfWater(JumpDir);
					bNotifyApex = true;
					bPendingDoubleJump = true;
				}
			}
		}
	}
	//return;	
}

event MayDodgeToMoveTarget()
{
	local Vector Dir, X, Y, Z, DodgeV, NewDir;

	local float Dist, newdist, RealJumpZ;
	local Actor OldMoveTarget;
	local float RealGroundSpeed;

	// End:0x2B
	if(int(Pawn.Physics) != int(1))
	{
		return;
	}
	// End:0x6F
	if((Focus != MoveTarget) && (Skill + Jumpiness) < (4.5000000 + (1.5000000 * FRand())))
	{
		return;
	}
	// End:0xB3
	if(Pawn.GetGravityZ() > WorldInfo.DefaultGravityZ)
	{
		return;
	}
	Dir = MoveTarget.GetDestination(self) - Pawn.Location;
	Dist = VSize(Dir);
	OldMoveTarget = MoveTarget;
	// End:0x377
	if((Dist < 500.0000000) || Dir.Z < 0.0000000)
	{
		// End:0x1D7
		if((((PathNode(MoveTarget) == none) && PlayerStart(MoveTarget) == none) || RouteCache.Length == 0) || MoveTarget != RouteCache[0])
		{
			// End:0x1D4
			if(Dist < 500.0000000)
			{
				return;
			}			
		}
		else
		{
			// End:0x377
			if((RouteCache.Length > 1) && RouteCache[1] != none)
			{
				// End:0x298
				if((Pawn.Location.Z + Pawn.MaxStepHeight) < RouteCache[1].Location.Z)
				{
					// End:0x298
					if(Dist < 500.0000000)
					{
						return;
					}
				}
				NewDir = RouteCache[1].Location - Pawn.Location;
				newdist = VSize(NewDir);
				// End:0x362
				if((newdist > 500.0000000) && CanMakePathTo(RouteCache[1]))
				{
					Dist = newdist;
					Dir = NewDir;
					MoveTarget = RouteCache[1];					
				}
				else
				{
					// End:0x377
					if(Dist < 500.0000000)
					{
						return;
					}
				}
			}
		}
	}
	// End:0x3A1
	if(Focus == OldMoveTarget)
	{
		Focus = MoveTarget;
	}
	SetDestinationPosition(MoveTarget.Location);
	GetAxes(Pawn.Rotation, X, Y, Z);
	// End:0x4AC
	if(Abs(X Dot Dir) > Abs(Y Dot Dir))
	{
		// End:0x47F
		if((X Dot Dir) > float(0))
		{
			UTPawn(Pawn).CurrentDir = 3;			
		}
		else
		{
			UTPawn(Pawn).CurrentDir = 4;
		}		
	}
	else
	{
		// End:0x4F5
		if((Y Dot Dir) < float(0))
		{
			UTPawn(Pawn).CurrentDir = 1;			
		}
		else
		{
			UTPawn(Pawn).CurrentDir = 2;
		}
	}
	bPlannedJump = true;
	UTPawn(Pawn).PerformDodge(UTPawn(Pawn).CurrentDir, Normal(Dir), vect(0.0000000, 0.0000000, 0.0000000));
	// End:0x7DE
	if(Dir.Z < (float(-1) * Pawn.GetCollisionHeight()))
	{
		Pawn.Velocity.Z = 0.0000000;
		RealJumpZ = Pawn.JumpZ;
		DodgeV = UTPawn(Pawn).BotDodge(vect(1.0000000, 0.0000000, 0.0000000));
		Pawn.JumpZ = DodgeV.Z;
		DodgeV.Z = 0.0000000;
		RealGroundSpeed = Pawn.GroundSpeed;
		Pawn.GroundSpeed = VSize(DodgeV);
		Pawn.SuggestJumpVelocity(Pawn.Velocity, GetDestinationPosition(), Pawn.Location);
		Pawn.GroundSpeed = RealGroundSpeed;
		Pawn.JumpZ = RealJumpZ;
	}
	Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	//return;	
}

event NotifyJumpApex()
{
	local Vector HitLocation, HitNormal, HalfHeight, Start;
	local Actor HitActor;

	// End:0x91
	if(bPendingDoubleJump)
	{
		Pawn.bWantsToCrouch = false;
		// End:0x82
		if(UTPawn(Pawn).CanDoubleJump())
		{
			UTPawn(Pawn).DoDoubleJump(false);
		}
		bPendingDoubleJump = false;		
	}
	else
	{
		// End:0x2EF
		if(bJumpOverWall)
		{
			Pawn.Acceleration = GetDestinationPosition() - Pawn.Location;
			Pawn.Acceleration.Z = 0.0000000;
			HalfHeight = Pawn.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
			HalfHeight.Z = 0.5000000 * Pawn.GetCollisionHeight();
			Start = Pawn.Location - (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 0.5000000));
			HitActor = Pawn.Trace(HitLocation, HitNormal, Start + (float(8) * Normal(Pawn.Acceleration)), Start, true, HalfHeight);
			// End:0x2EF
			if(HitActor != none)
			{
				Pawn.bWantsToCrouch = false;
				// End:0x2EF
				if(UTPawn(Pawn).CanDoubleJump())
				{
					UTPawn(Pawn).DoDoubleJump(false);
				}
			}
		}
	}
	//return;	
}

event NotifyMissedJump()
{
	local NavigationPoint N;
	local Actor OldMoveTarget;
	local Vector Loc2D, NavLoc2D;
	local float bestDist, newdist;

	OldMoveTarget = MoveTarget;
	MoveTarget = none;
	// End:0x277
	if(MoveTarget == none)
	{
		Loc2D = Pawn.Location;
		Loc2D.Z = 0.0000000;
		// End:0x252
		foreach WorldInfo.AllNavigationPoints(Class'Engine.NavigationPoint', N)
		{
			// End:0x251
			if(N.Location.Z < Pawn.Location.Z)
			{
				NavLoc2D = N.Location;
				NavLoc2D.Z = 0.0000000;
				newdist = VSize(NavLoc2D - Loc2D);
				// End:0x251
				if(((newdist <= (Pawn.Location.Z - N.Location.Z)) && (MoveTarget == none) || bestDist > newdist) && LineOfSightTo(N))
				{
					MoveTarget = N;
					bestDist = newdist;
				}
			}			
		}		
		// End:0x277
		if(MoveTarget == none)
		{
			MoveTarget = OldMoveTarget;
			return;
		}
	}
	MoveTimer = 1.0000000;
	//return;	
}

function Reset()
{
	super(AIController).Reset();
	NextRoutePath = none;
	LastSeenTime = 0.0000000;
	MonitoredPawn = none;
	WarningProjectile = none;
	bHuntPlayer = false;
	bEnemyAcquired = false;
	ResetSkill();
	bPlannedJump = false;
	bFrustrated = false;
	bInitLifeMessage = false;
	bReachedGatherPoint = false;
	bFinalStretch = false;
	bHasSuperWeapon = false;
	bJumpOverWall = false;
	StartleActor = none;
	DefensePoint = none;
	ImpactVelocity = vect(0.0000000, 0.0000000, 0.0000000);
	PendingMover = none;
	Enemy = none;
	bFrustrated = false;
	BlockedPath = none;
	bInitLifeMessage = false;
	bInDodgeMove = false;
	bWasNearObjective = false;
	bPreparingMove = false;
	bPursuingFlag = false;
	ImpactJumpZ = 0.0000000;
	RouteGoal = none;
	NoVehicleGoal = none;
	SquadRouteGoal = none;
	bUsingSquadRoute = true;
	bUsePreviousSquadRoute = false;
	MoveTarget = none;
	bEnemyInfoValid = false;
	// End:0x1C2
	if(Pawn == none)
	{
		GotoState('Dead');
	}
	//return;	
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	// End:0x82
	if(aPawn.bDeleteMe)
	{
		WarnInternal(((string(self) @ (GetHumanReadableName())) @ "attempted to possess destroyed Pawn") @ string(aPawn));
		ScriptTrace();
		GotoState('Dead');		
	}
	else
	{
		super(Controller).Possess(aPawn, bVehicleTransition);
		bPlannedJump = false;
		ResetSkill();
		ImpactVelocity = vect(0.0000000, 0.0000000, 0.0000000);
		Pawn.SetMovementPhysics();
		// End:0x12E
		if(int(Pawn.Physics) == int(1))
		{
			Pawn.SetPhysics(2);
		}
		Enable('NotifyBump');
	}
	//return;	
}

function Initialize(float InSkill, const out CharacterInfo BotInfo)
{
	local UTPlayerReplicationInfo PRI;

	Skill = FClamp(InSkill, 0.0000000, 7.0000000);
	// End:0x126
	if(BotInfo.AIData.FavoriteWeapon != "")
	{
		// End:0xD0
		if(WorldInfo.IsConsoleBuild())
		{
			FavoriteWeapon = Class<Weapon>(FindObject(BotInfo.AIData.FavoriteWeapon, Class'Core.Class'));			
		}
		else
		{
			FavoriteWeapon = Class<Weapon>(DynamicLoadObject(BotInfo.AIData.FavoriteWeapon, Class'Core.Class'));
		}
	}
	Aggressiveness = FClamp(BotInfo.AIData.Aggressiveness, 0.0000000, 1.0000000);
	BaseAggressiveness = Aggressiveness;
	Accuracy = FClamp(BotInfo.AIData.Accuracy, -5.0000000, 5.0000000);
	StrafingAbility = FClamp(BotInfo.AIData.StrafingAbility, -5.0000000, 5.0000000);
	CombatStyle = FClamp(BotInfo.AIData.CombatStyle, -1.0000000, 1.0000000);
	Jumpiness = FClamp(BotInfo.AIData.Jumpiness, -1.0000000, 1.0000000);
	Tactics = FClamp(BotInfo.AIData.Tactics, -5.0000000, 5.0000000);
	ReactionTime = FClamp(BotInfo.AIData.ReactionTime, -5.0000000, 5.0000000);
	PRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
	// End:0x3A1
	if(PRI != none)
	{
		PRI.CharClassInfo = Class'UTGame.UTCharInfo'.static.FindFamilyInfo(BotInfo.FamilyID);
	}
	ResetSkill();
	//return;	
}

function ResetSkill()
{
	// End:0x3B
	if(Skill >= float(0))
	{
		TrackingReactionTime = (BaseTrackingReactionTime * float(7)) / (Skill + float(2));
	}
	// End:0x5F
	if(Skill < float(3))
	{
		DodgeToGoalPct = 0.0000000;		
	}
	else
	{
		DodgeToGoalPct = (Jumpiness * 0.5000000) + (Skill / float(6));
	}
	Aggressiveness = BaseAggressiveness;
	bLeadTarget = Skill >= float(4);
	SetCombatTimer();
	SetPeripheralVision();
	HearingThreshold = default.HearingThreshold * FClamp(Skill / 6.0000000, 0.0000000, 1.0000000);
	// End:0x16E
	if(WorldInfo.IsConsoleBuild())
	{
		RotationRate.Yaw = Min(int(float(30000) + (float(4000) * (Skill + ReactionTime))), 60000);		
	}
	else
	{
		// End:0x1BF
		if((Skill + ReactionTime) >= float(7))
		{
			SightCounterInterval = 0.2000000;
			RotationRate.Yaw = 110000;			
		}
		else
		{
			// End:0x233
			if((Skill + ReactionTime) >= float(4))
			{
				RotationRate.Yaw = int(float(7000) + (float(10000) * (Skill + ReactionTime)));
				SightCounterInterval = 0.3000000;				
			}
			else
			{
				RotationRate.Yaw = int(float(35000) + (float(3000) * (Skill + ReactionTime)));
				SightCounterInterval = 0.4000000;
			}
		}
	}
	RotationRate.Pitch = RotationRate.Yaw;
	AcquisitionYawRate = int(FMin(1.0000000, 0.7500000 + (0.0500000 * ReactionTime)) * float(RotationRate.Yaw));
	SetMaxDesiredSpeed();
	//return;	
}

function SetMaxDesiredSpeed()
{
	// End:0x1C4
	if((Pawn != none) && bSpawnedByKismet!)
	{
		// End:0xD7
		if((UTGame(WorldInfo.Game) != none) && UTGame(WorldInfo.Game).bDemoMode)
		{
			Pawn.bCanCrouch = false;
			Pawn.MaxDesiredSpeed = 0.7500000;			
		}
		else
		{
			// End:0x110
			if(Skill >= float(4))
			{
				Pawn.MaxDesiredSpeed = 1.0000000;				
			}
			else
			{
				// End:0x18E
				if((UTPlayerReplicationInfo(PlayerReplicationInfo) != none) && UTPlayerReplicationInfo(PlayerReplicationInfo).bHasFlag)
				{
					Pawn.MaxDesiredSpeed = 0.8000000 + (0.0500000 * Skill);					
				}
				else
				{
					Pawn.MaxDesiredSpeed = 0.6000000 + (0.1000000 * Skill);
				}
			}
		}
	}
	//return;	
}

function SetPeripheralVision()
{
	// End:0x11
	if(Pawn == none)
	{
		return;
	}
	// End:0x90
	if(Pawn.bStationary || int(Pawn.Physics) == int(4))
	{
		bSlowerZAcquire = false;
		Pawn.PeripheralVision = -0.7000000;
		return;
	}
	bSlowerZAcquire = true;
	// End:0xD5
	if(Skill < float(2))
	{
		Pawn.PeripheralVision = 0.7000000;		
	}
	else
	{
		// End:0x11A
		if(Skill > float(6))
		{
			bSlowerZAcquire = false;
			Pawn.PeripheralVision = -0.2000000;			
		}
		else
		{
			Pawn.PeripheralVision = 1.0000000 - (0.2000000 * Skill);
		}
	}
	Pawn.PeripheralVision = FMin(Pawn.PeripheralVision - BaseAlertness, 0.8000000);
	Pawn.SightRadius = Pawn.default.SightRadius;
	//return;	
}

function SetAlertness(float NewAlertness)
{
	// End:0xA4
	if(Pawn.Alertness != NewAlertness)
	{
		Pawn.PeripheralVision += (0.7070000 * (Pawn.Alertness - NewAlertness));
		Pawn.Alertness = NewAlertness;
	}
	//return;	
}

event WhatToDoNext()
{
	// End:0x30
	if(bExecutingWhatToDoNext)
	{
		LogInternal("WhatToDoNext loop:" @ (GetHumanReadableName()));
	}
	// End:0x6A
	if(Pawn == none)
	{
		WarnInternal((GetHumanReadableName()) @ "WhatToDoNext with no pawn");
		return;
	}
	// End:0x2EE
	if(((Enemy == none) || Enemy.bDeleteMe) || Enemy.Health <= 0)
	{
		// End:0x23E
		if(bSpawnedByKismet! && UTGame(WorldInfo.Game).TooManyBots(self))
		{
			// End:0x239
			if(Pawn != none)
			{
				// End:0x1D2
				if((Vehicle(Pawn) != none) && Vehicle(Pawn).Driver != none)
				{
					Vehicle(Pawn).Driver.KilledBy(Vehicle(Pawn).Driver);					
				}
				else
				{
					Pawn.Health = 0;
					Pawn.Died(self, Class'Engine.DmgType_Suicided', Pawn.Location);
				}
			}
			Destroy();
			return;
		}
		BlockedPath = none;
		bFrustrated = false;
		// End:0x2EE
		if((Focus == none) || (Pawn(Focus) != none) && Pawn(Focus).Health <= 0)
		{
			StopFiring();
			// End:0x2EE
			if((Pawn == none) || Pawn.Health <= 0)
			{
				return;
			}
		}
	}
	ReTaskTime = 0.0000000;
	DecisionComponent.bTriggered = true;
	//return;	
}

protected event ExecuteWhatToDoNext()
{
	local float StartleRadius, StartleHeight;

	// End:0x11
	if(Pawn == none)
	{
		return;
	}
	bHasFired = false;
	GoalString = "WhatToDoNext at " $ string(WorldInfo.TimeSeconds);
	// End:0xE8
	if(((Squad == none) && PlayerReplicationInfo != none) && UTTeamInfo(PlayerReplicationInfo.Team) != none)
	{
		UTTeamInfo(PlayerReplicationInfo.Team).SetBotOrders(self);
	}
	SwitchToBestWeapon();
	// End:0x13B
	if(int(Pawn.Physics) == int(0))
	{
		Pawn.SetMovementPhysics();
	}
	// End:0x175
	if((int(Pawn.Physics) == int(2)) && DoWaitForLanding())
	{
		return;
	}
	// End:0x23E
	if((StartleActor != none) && StartleActor.bDeleteMe!)
	{
		StartleActor.GetBoundingCylinder(StartleRadius, StartleHeight);
		// End:0x23E
		if(VSize(StartleActor.Location - Pawn.Location) < StartleRadius)
		{
			Startle(StartleActor);
			return;
		}
	}
	bIgnoreEnemyChange = true;
	// End:0x2AF
	if((Enemy != none) && (Enemy.Health <= 0) || Enemy.Controller == none)
	{
		LoseEnemy();
	}
	// End:0x2EB
	if(Enemy == none)
	{
		UTSquadAI(Squad).FindNewEnemyFor(self, false);		
	}
	else
	{
		// End:0x39D
		if(UTSquadAI(Squad).MustKeepEnemy(Enemy)! && LineOfSightTo(Enemy)!)
		{
			// End:0x381
			if(UTSquadAI(Squad).IsDefending(self))
			{
				// End:0x37E
				if(LostContact(4.0000000))
				{
					LoseEnemy();
				}				
			}
			else
			{
				// End:0x39D
				if(LostContact(7.0000000))
				{
					LoseEnemy();
				}
			}
		}
	}
	bIgnoreEnemyChange = false;
	// End:0x3B8
	if(AssignSquadResponsibility())
	{
		return;
	}
	// End:0x3C7
	if(ShouldDefendPosition())
	{
		return;
	}
	// End:0x3E3
	if(Enemy != none)
	{
		ChooseAttackMode();		
	}
	else
	{
		// End:0x643
		if(Pawn.FindAnchorFailedTime == WorldInfo.TimeSeconds)
		{
			GoalString = "No anchor" @ string(WorldInfo.TimeSeconds);
			// End:0x643
			if(Pawn.LastValidAnchorTime > 5.0000000)
			{
				// End:0x4B0
				if(bSoaking)
				{
					SoakStop("NO PATH AVAILABLE!!!");
				}
				// End:0x511
				if((NumRandomJumps > 4) || PhysicsVolume.bWaterVolume)
				{
					Pawn.SetTimer(0.0100000, false, 'Suicide');
					return;					
				}
				else
				{
					NumRandomJumps++;
					// End:0x643
					if((Pawn.IsA('Vehicle')! && int(Pawn.Physics) != int(2)) && Pawn.DoJump(false))
					{
						Pawn.SetPhysics(2);
						Pawn.Velocity = (0.5000000 * Pawn.GroundSpeed) * VRand();
						Pawn.Velocity.Z = Pawn.JumpZ;
					}
				}
			}
		}		
		GoalString @= ("- Wander or Camp at" @ string(WorldInfo.TimeSeconds));
		bShortCamp = UTPlayerReplicationInfo(PlayerReplicationInfo).bHasFlag;
		WanderOrCamp();
	}
	//return;	
}

function EnterVehicle(Vehicle V)
{
	GoalString = "Entering vehicle" @ string(V);
	RouteGoal = V;
	GotoState('EnteringVehicle');
	//return;	
}

function LeaveVehicle(bool bBlocking)
{
	// End:0x39
	if(bBlocking)
	{
		GoalString = "Leaving vehicle";
		GotoState('LeavingVehicle');		
	}
	else
	{
		bNeedDelayedLeaveVehicle = true;
	}
	//return;	
}

event DelayedLeaveVehicle()
{
	local Vehicle V;

	V = Vehicle(Pawn);
	// End:0x5D
	if((V != none) && V.DriverLeave(false)!)
	{
		LeaveVehicle(true);
	}
	//return;	
}

function bool DoWaitForLanding()
{
	GotoState('WaitingForLanding');
	return true;
	//return ReturnValue;	
}

function VehicleFightEnemy(bool bCanCharge, float EnemyStrength)
{
	local UTVehicle V;

	V = UTVehicle(Pawn);
	// End:0x5C
	if((V != none) && V.bShouldLeaveForCombat)
	{
		LeaveVehicle(true);
		return;
	}
	// End:0x106
	if((Pawn.bStationary || UTWeaponPawn(Pawn) != none) || V.bKeyVehicle)
	{
		// End:0xF1
		if(LineOfSightTo(Enemy)!)
		{
			GoalString = "Stake Out";
			DoStakeOut();			
		}
		else
		{
			DoRangedAttackOn(Enemy);
		}
		return;
	}
	// End:0x185
	if((bFrustrated! && Pawn.HasRangedAttack()) && Pawn.TooCloseToAttack(Enemy))
	{
		GoalString = "Retreat";
		DoRetreat();
		return;
	}
	// End:0x267
	if(((Enemy == FailedHuntEnemy) && WorldInfo.TimeSeconds == FailedHuntTime) || V.bKeyVehicle)
	{
		GoalString = "FAILED HUNT - HANG OUT";
		// End:0x25B
		if(Pawn.HasRangedAttack() && LineOfSightTo(Enemy))
		{
			DoRangedAttackOn(Enemy);			
		}
		else
		{
			WanderOrCamp();
		}
		return;
	}
	// End:0x3E2
	if(LineOfSightTo(Enemy)!)
	{
		// End:0x2DD
		if(UTSquadAI(Squad).MustKeepEnemy(Enemy))
		{
			GoalString = "Hunt priority enemy";
			GotoState('Hunting');
			return;
		}
		// End:0x350
		if(bCanCharge! || UTSquadAI(Squad).IsDefending(self) && LostContact(4.0000000))
		{
			GoalString = "Stake Out";
			DoStakeOut();			
		}
		else
		{
			// End:0x3C2
			if((((Aggression < float(1)) && LostContact(3.0000000 + (float(2) * FRand()))!) || IsSniping()) && CanStakeOut())
			{
				GoalString = "Stake Out2";
				DoStakeOut();				
			}
			else
			{
				GoalString = "Hunt";
				GotoState('Hunting');
			}
		}
		return;
	}
	BlockedPath = none;
	Focus = Enemy;
	// End:0x44A
	if(V.RecommendCharge(self, Enemy))
	{
		GoalString = "Charge";
		DoCharge();
		return;
	}
	// End:0x584
	if(((Pawn.bCanFly && Enemy.bCanFly!) && (Pawn.Weapon == none) || VSize(Pawn.Location - Enemy.Location) < Pawn.Weapon.MaxRange()) && FRand() < (0.1700000 * ((Skill + Tactics) - float(1))))
	{
		GoalString = "Do tactical move";
		DoTacticalMove();
		return;
	}
	// End:0x5D9
	if(Pawn.RecommendLongRangedAttack())
	{
		GoalString = "Long Ranged Attack";
		DoRangedAttackOn(Enemy);
		return;
	}
	GoalString = "Charge";
	DoCharge();
	//return;	
}

function FightEnemy(bool bCanCharge, float EnemyStrength)
{
	local Vector X, Y, Z;
	local float enemyDist, AdjustedCombatStyle;
	local bool bFarAway, bOldForcedCharge;

	// End:0x7F
	if(((Squad == none) || Enemy == none) || Pawn == none)
	{
		LogInternal((((("HERE 3 Squad " $ string(Squad)) $ " Enemy ") $ string(Enemy)) $ " pawn ") $ string(Pawn));
	}
	// End:0xB6
	if(Vehicle(Pawn) != none)
	{
		VehicleFightEnemy(bCanCharge, EnemyStrength);
		return;
	}
	// End:0x160
	if(Pawn.IsInPain() && FindInventoryGoal(0.0000000))
	{
		GoalString = (("Fallback out of pain volume " $ string(RouteGoal)) $ " hidden ") $ string(RouteGoal.bHidden);
		GotoState('Fallback');
		return;
	}
	// End:0x214
	if((Enemy == FailedHuntEnemy) && WorldInfo.TimeSeconds == FailedHuntTime)
	{
		GoalString = "FAILED HUNT - HANG OUT";
		// End:0x1E7
		if(LineOfSightTo(Enemy))
		{
			bCanCharge = false;			
		}
		else
		{
			// End:0x208
			if(FindInventoryGoal(0.0000000))
			{
				SetAttractionState();
				return;				
			}
			else
			{
				WanderOrCamp();
				return;
			}
		}
	}
	bOldForcedCharge = bMustCharge;
	bMustCharge = false;
	enemyDist = VSize(Pawn.Location - Enemy.Location);
	AdjustedCombatStyle = CombatStyle + UTWeapon(Pawn.Weapon).SuggestAttackStyle();
	Aggression = ((((1.5000000 * FRand()) - 0.8000000) + (float(2) * AdjustedCombatStyle)) - (0.5000000 * EnemyStrength)) + (FRand() * (Normal(Enemy.Velocity - Pawn.Velocity) Dot Normal(Enemy.Location - Pawn.Location)));
	// End:0x411
	if(UTWeapon(Enemy.Weapon) != none)
	{
		Aggression += (float(2) * UTWeapon(Enemy.Weapon).SuggestDefenseStyle());
	}
	// End:0x436
	if(enemyDist > float(2000))
	{
		Aggression += 0.5000000;
	}
	// End:0x477
	if(Squad != none)
	{
		UTSquadAI(Squad).ModifyAggression(self, Aggression);
	}
	// End:0x655
	if((int(Pawn.Physics) == int(1)) || int(Pawn.Physics) == int(2))
	{
		// End:0x56A
		if(Pawn.Location.Z > (Enemy.Location.Z + float(320)))
		{
			Aggression = FMax(0.0000000, (Aggression - 1.0000000) + AdjustedCombatStyle);			
		}
		else
		{
			// End:0x5B9
			if((Skill < float(4)) && enemyDist > (0.6500000 * float(2000)))
			{
				bFarAway = true;
				Aggression += 0.5000000;				
			}
			else
			{
				// End:0x655
				if(Pawn.Location.Z < (Enemy.Location.Z - Pawn.GetCollisionHeight()))
				{
					Aggression += CombatStyle;
				}
			}
		}
	}
	// End:0xA1A
	if(Pawn.CanAttack(Enemy)!)
	{
		// End:0x6E5
		if(UTSquadAI(Squad).MustKeepEnemy(Enemy))
		{
			GoalString = "Hunt priority enemy";
			GotoState('Hunting');
			return;
		}
		// End:0x722
		if(bCanCharge!)
		{
			GoalString = "Stake Out - no charge";
			DoStakeOut();			
		}
		else
		{
			// End:0x7AB
			if((UTSquadAI(Squad).IsDefending(self) && LostContact(4.0000000)) && ClearShot(LastSeenPos, false))
			{
				GoalString = "Stake Out " $ string(LastSeenPos);
				DoStakeOut();				
			}
			else
			{
				// End:0x81D
				if((((Aggression < float(1)) && LostContact(3.0000000 + (float(2) * FRand()))!) || IsSniping()) && CanStakeOut())
				{
					GoalString = "Stake Out2";
					DoStakeOut();					
				}
				else
				{
					// End:0x9FA
					if(((((((((((Skill + Tactics) >= (3.5000000 + FRand())) && LostContact(1.0000000)!) && VSize(Enemy.Location - Pawn.Location) < float(2000)) && Pawn.Weapon != none) && Pawn.Weapon.AIRating > 0.5000000) && Pawn.Weapon.bMeleeWeapon!) && FRand() < 0.7500000) && LineOfSightTo(Enemy)!) && Enemy.LineOfSightTo(Pawn)!) && (Squad == none) || UTSquadAI(Squad).HasOtherVisibleEnemy(self)!)
					{
						GoalString = "Stake Out 3";
						DoStakeOut();						
					}
					else
					{
						GoalString = "Hunt";
						GotoState('Hunting');
					}
				}
			}
		}
		return;
	}
	BlockedPath = none;
	Focus = Enemy;
	// End:0xAAB
	if(Pawn.Weapon.bMeleeWeapon || bCanCharge && bOldForcedCharge)
	{
		GoalString = "Charge";
		DoCharge();
		return;
	}
	// End:0xB00
	if(Pawn.RecommendLongRangedAttack())
	{
		GoalString = "Long Ranged Attack";
		DoRangedAttackOn(Enemy);
		return;
	}
	// End:0xB76
	if((((bCanCharge && Skill < float(5)) && bFarAway) && Aggression > float(1)) && FRand() < 0.5000000)
	{
		GoalString = "Charge closer";
		DoCharge();
		return;
	}
	// End:0xC36
	if((UTWeapon(Pawn.Weapon).RecommendRangedAttack() || IsSniping()) || (FRand() > (0.1700000 * ((Skill + Tactics) - float(1)))) && DefendMelee(enemyDist)!)
	{
		GoalString = "Ranged Attack";
		DoRangedAttackOn(Enemy);
		return;
	}
	// End:0xC74
	if(bCanCharge)
	{
		// End:0xC74
		if(Aggression > float(1))
		{
			GoalString = "Charge 2";
			DoCharge();
			return;
		}
	}
	GoalString = "Do tactical move";
	// End:0xDA5
	if((UTWeapon(Pawn.Weapon).bRecommendSplashDamage! && FRand() < 0.7000000) && ((float(3) * Jumpiness) + (FRand() * Skill)) > float(3))
	{
		GetAxes(Pawn.Rotation, X, Y, Z);
		GoalString = "Try to Duck ";
		// End:0xD91
		if(FRand() < 0.5000000)
		{
			Y *= float(-1);
			TryToDuck(Y, true);			
		}
		else
		{
			TryToDuck(Y, false);
		}
	}
	DoTacticalMove();
	//return;	
}

function DoRangedAttackOn(Actor A)
{
	local UTVehicle V;

	V = UTVehicle(Pawn);
	// End:0x5A
	if((V != none) && V.bShouldLeaveForCombat)
	{
		LeaveVehicle(false);
	}
	Focus = A;
	LastFireTarget = Focus;
	GotoState('RangedAttack');
	//return;	
}

function ChooseAttackMode()
{
	local float EnemyStrength, WeaponRating, RetreatThreshold;

	GoalString = " ChooseAttackMode last seen " $ string(WorldInfo.TimeSeconds - LastSeenTime);
	// End:0xD4
	if(((Squad == none) || Enemy == none) || Pawn == none)
	{
		LogInternal((((("HERE 1 Squad " $ string(Squad)) $ " Enemy ") $ string(Enemy)) $ " pawn ") $ string(Pawn));
	}
	EnemyStrength = RelativeStrength(Enemy);
	// End:0x1B3
	if((((EnemyStrength > RetreatThreshold) && PlayerReplicationInfo.Team != none) && FRand() < 0.2500000) && (WorldInfo.TimeSeconds - LastInjuredVoiceMessageTime) > 45.0000000)
	{
		LastInjuredVoiceMessageTime = WorldInfo.TimeSeconds;
		SendMessage(none, 'injured', 35.0000000);
	}
	// End:0x1E1
	if(Vehicle(Pawn) != none)
	{
		VehicleFightEnemy(true, EnemyStrength);
		return;
	}
	// End:0x38C
	if(bFrustrated! && UTSquadAI(Squad).MustKeepEnemy(Enemy)!)
	{
		RetreatThreshold = Aggressiveness;
		// End:0x2AD
		if(UTWeapon(Pawn.Weapon).CurrentRating > 0.5000000)
		{
			RetreatThreshold = (RetreatThreshold + 0.3500000) - (Skill * 0.0500000);
		}
		// End:0x38C
		if(EnemyStrength > RetreatThreshold)
		{
			GoalString = "Retreat";
			// End:0x380
			if(((PlayerReplicationInfo.Team != none) && FRand() < 0.0500000) && (WorldInfo.TimeSeconds - LastInjuredVoiceMessageTime) > 45.0000000)
			{
				LastInjuredVoiceMessageTime = WorldInfo.TimeSeconds;
				SendMessage(none, 'injured', 35.0000000);
			}
			DoRetreat();
			return;
		}
	}
	// End:0x683
	if(((int(UTSquadAI(Squad).PriorityObjective(self)) == int(0)) && (Skill + Tactics) > float(2)) && (EnemyStrength > -0.3000000) || Pawn.Weapon.AIRating < 0.5000000)
	{
		// End:0x4E7
		if(Pawn.Weapon.AIRating < 0.5000000)
		{
			// End:0x495
			if(EnemyStrength > 0.3000000)
			{
				WeaponRating = 0.0000000;				
			}
			else
			{
				WeaponRating = UTWeapon(Pawn.Weapon).CurrentRating / float(2000);
			}			
		}
		else
		{
			// End:0x54C
			if(EnemyStrength > 0.3000000)
			{
				WeaponRating = UTWeapon(Pawn.Weapon).CurrentRating / float(2000);				
			}
			else
			{
				WeaponRating = UTWeapon(Pawn.Weapon).CurrentRating / float(1000);
			}
		}
		// End:0x683
		if(FindInventoryGoal(WeaponRating))
		{
			// End:0x611
			if(PickupFactory(RouteGoal) == none)
			{
				GoalString = "fallback - inventory goal is not pickup but " $ string(RouteGoal);				
			}
			else
			{
				GoalString = (("Fallback to better pickup " $ string(RouteGoal)) $ " hidden ") $ string(RouteGoal.bHidden);
			}
			GotoState('Fallback');
			return;
		}
	}
	GoalString = "ChooseAttackMode FightEnemy";
	FightEnemy(true, EnemyStrength);
	//return;	
}

function bool FindSuperPickup(float MaxDist)
{
	local Actor BestPath;
	local UTPickupFactory P;

	// End:0x7F
	if((LastSearchTime == WorldInfo.TimeSeconds) || (Pawn.bCanPickupInventory! || Vehicle(Pawn) != none) && bCheckDriverPickups!)
	{
		return false;
	}
	// End:0xF3
	if((UTDeathmatch(WorldInfo.Game) != none) && UTDeathmatch(WorldInfo.Game).WantsPickups(self)!)
	{
		return false;
	}
	LastSearchTime = WorldInfo.TimeSeconds;
	LastSearchWeight = -1.0000000;
	BestPath = FindBestSuperPickup(MaxDist);
	// End:0x2EB
	if(BestPath != none)
	{
		MoveTarget = BestPath;
		P = UTPickupFactory(RouteGoal);
		// End:0x2E9
		if(((P != none) && PlayerReplicationInfo.Team != none) && PlayerReplicationInfo.Team.TeamIndex < 4)
		{
			P.TeamOwner[PlayerReplicationInfo.Team.TeamIndex] = self;
			// End:0x2E9
			if((WorldInfo.TimeSeconds - P.LastSeekNotificationTime) > 30.0000000)
			{
				P.LastSeekNotificationTime = WorldInfo.TimeSeconds;
				SendMessage(none, 'Location', 10.0000000, none);
			}
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool FindInventoryGoal(float BestWeight)
{
	local Actor BestPath;
	local UTPickupFactory P;

	// End:0x47
	if((LastSearchTime == WorldInfo.TimeSeconds) && LastSearchWeight >= BestWeight)
	{
		return false;
	}
	// End:0xBB
	if((UTDeathmatch(WorldInfo.Game) != none) && UTDeathmatch(WorldInfo.Game).WantsPickups(self)!)
	{
		return false;
	}
	// End:0x107
	if(((Vehicle(Pawn) != none) ? bCheckDriverPickups! : Pawn.bCanPickupInventory!))
	{
		return false;
	}
	LastSearchTime = WorldInfo.TimeSeconds;
	LastSearchWeight = BestWeight;
	// End:0x177
	if((Skill > float(3)) && Enemy == none)
	{
		RespawnPredictionTime = 4.0000000;		
	}
	else
	{
		RespawnPredictionTime = 0.0000000;
	}
	BestPath = FindBestInventoryPath(BestWeight);
	// End:0x3F2
	if(BestPath != none)
	{
		MoveTarget = BestPath;
		P = UTPickupFactory(RouteGoal);
		// End:0x2BC
		if(((P != none) && P == Pawn.Anchor) && Pawn.IsOverlapping(P))
		{
			P.Touch(Pawn, Pawn.Mesh, P.Location, vect(0.0000000, 0.0000000, 1.0000000));
		}
		// End:0x3F0
		if((((P != none) && P.bIsSuperItem) && PlayerReplicationInfo.Team != none) && PlayerReplicationInfo.Team.TeamIndex < 4)
		{
			// End:0x3F0
			if((WorldInfo.TimeSeconds - P.LastSeekNotificationTime) > 30.0000000)
			{
				P.LastSeekNotificationTime = WorldInfo.TimeSeconds;
				SendMessage(none, 'Location', 10.0000000, none);
			}
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function TossFlagToPlayer(Controller OrderGiver)
{
	local UTPawn BotPawn;
	local UTPlayerReplicationInfo PRI;
	local UTCarriedObject Flag;
	local float FlagVelocityZ;

	// End:0x68
	if(UTPawn(Pawn) != none)
	{
		BotPawn = UTPawn(Pawn);
		PRI = UTPlayerReplicationInfo(BotPawn.PlayerReplicationInfo);		
	}
	else
	{
		// End:0x112
		if(UTPawn(UTVehicle(Pawn).Driver) != none)
		{
			BotPawn = UTPawn(UTVehicle(Pawn).Driver);
			PRI = UTPlayerReplicationInfo(UTVehicle(Pawn).PlayerReplicationInfo);
		}
	}
	// End:0x134
	if((BotPawn == none) || PRI == none)
	{
		return;
	}
	Flag = PRI.GetFlag();
	// End:0x16E
	if(Flag == none)
	{
		return;
	}
	Flag.Drop();
	ForcedFlagDropTime = WorldInfo.TimeSeconds;
	// End:0x32E
	if((OrderGiver != none) && OrderGiver.Pawn != none)
	{
		FlagVelocityZ = Flag.Velocity.Z;
		Flag.Velocity.Z = 0.0000000;
		Flag.Velocity = VSize(Flag.Velocity) * Normal(OrderGiver.Pawn.Location - Pawn.Location);
		Flag.Velocity.Z = FlagVelocityZ;
	}
	//return;	
}

function bool PickRetreatDestination()
{
	local Actor BestPath;

	// End:0x14
	if(FindInventoryGoal(0.0000000))
	{
		return true;
	}
	// End:0xB1
	if(((RouteGoal == none) || Pawn.Anchor == RouteGoal) || Pawn.ReachedDestination(RouteGoal))
	{
		RouteGoal = FindRandomDest();
		// End:0x9C
		if(RouteGoal == none)
		{
			return false;
		}
		BestPath = RouteCache[0];
	}
	// End:0x111
	if(BestPath == none)
	{
		BestPath = FindPathToward(RouteGoal, Pawn.bCanPickupInventory && Vehicle(Pawn) == none);
	}
	// End:0x135
	if(BestPath != none)
	{
		MoveTarget = BestPath;
		return true;
	}
	RouteGoal = none;
	return false;
	//return ReturnValue;	
}

event SoakStop(optional string problem)
{
	local UTPlayerController PC;

	LogInternal(problem);
	SoakString = problem;
	GoalString = SoakString @ GoalString;
	// End:0x83
	foreach DynamicActors(Class'UTGame.UTPlayerController', PC)
	{
		PC.SoakPause(Pawn);
		// End:0x83
		break;		
	}	
	//return;	
}

function bool FindRoamDest()
{
	local Actor BestPath;

	// End:0x43
	if(Pawn.FindAnchorFailedTime == WorldInfo.TimeSeconds)
	{
		return false;
	}
	NumRandomJumps = 0;	
	GoalString @= ("- Find roam dest " $ string(WorldInfo.TimeSeconds));
	// End:0x11D
	if(((RouteGoal != none) && Pawn.Anchor != RouteGoal) && Pawn.ReachedDestination(RouteGoal)!)
	{
		BestPath = FindPathToward(RouteGoal, false);
	}
	// End:0x1DA
	if(BestPath == none)
	{
		RouteGoal = FindRandomDest();
		// End:0x1C5
		if(RouteGoal == none)
		{
			GoalString = "Failed to find roam dest";
			// End:0x1B9
			if(bSoaking && int(Physics) != int(2))
			{
				SoakStop("COULDN'T FIND ROAM DESTINATION");
			}
			FreePoint();
			return false;
		}
		BestPath = RouteCache[0];
	}
	MoveTarget = BestPath;
	SetAttractionState();
	return true;
	//return ReturnValue;	
}

function Restart(bool bVehicleTransition)
{
	// End:0x50
	if(bVehicleTransition!)
	{
		super(Controller).Restart(bVehicleTransition);
		ResetSkill();
		GotoState('Roaming', 'DoneRoaming');
		ClearTemporaryOrders();		
	}
	else
	{
		// End:0x7E
		if(Pawn != none)
		{
			Pawn.Restart();
		}
	}
	//return;	
}

function bool CheckPathToGoalAround(Pawn P)
{
	return false;
	//return ReturnValue;	
}

function ClearPathFor(Controller C)
{
	// End:0x1A
	if(Vehicle(Pawn) != none)
	{
		return;
	}
	// End:0x47
	if(AdjustAround(C.Pawn))
	{
		return;
	}
	// End:0x9E
	if(Enemy != none)
	{
		// End:0x9B
		if(LineOfSightTo(Enemy) && Pawn.bCanStrafe)
		{
			GotoState('TacticalMove');
			return;
		}		
	}
	else
	{
		// End:0xE4
		if((Stopped()) && Pawn.bStationary!)
		{
			MoveAwayFrom(C);
		}
	}
	//return;	
}

function bool AdjustAround(Pawn Other)
{
	local Vector VelDir, OtherDir, SideDir, HitLocation, HitNormal, Adj;

	// End:0x16
	if(InLatentExecution(503)!)
	{
		return false;
	}
	VelDir = Normal(MoveTarget.Location - Pawn.Location);
	VelDir.Z = 0.0000000;
	OtherDir = Other.Location - Pawn.Location;
	OtherDir.Z = 0.0000000;
	OtherDir = Normal(OtherDir);
	// End:0x2A5
	if((VelDir Dot OtherDir) > 0.8000000)
	{
		SideDir.X = VelDir.Y;
		SideDir.Y = -1.0000000 * VelDir.X;
		// End:0x1C6
		if((SideDir Dot OtherDir) > float(0))
		{
			SideDir *= float(-1);
		}
		Adj = Pawn.Location + ((float(3) * Other.GetCollisionRadius()) * ((0.5000000 * VelDir) + SideDir));
		// End:0x28B
		if(Trace(HitLocation, HitNormal, Adj, Pawn.Location, false) != none)
		{
			Adj = HitLocation;
		}
		SetAdjustLocation(Adj, true);
		return true;		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
	local Pawn P;
	local UTVehicle V;

	// End:0x13B
	if((Vehicle(Other) != none) && Vehicle(Pawn) == none)
	{
		// End:0x13B
		if((Other == RouteGoal) || (Vehicle(RouteGoal) != none) && Other == Vehicle(RouteGoal).GetVehicleBase())
		{
			V = UTVehicle(Other);
			// End:0x139
			if(V != none)
			{
				V.TryToDrive(Pawn);
				// End:0x139
				if(Vehicle(Pawn) != none)
				{
					UTSquadAI(Squad).BotEnteredVehicle(self);
					WhatToDoNext();
				}
			}
			return true;
		}
	}
	Disable('NotifyBump');
	SetTimer(1.0000000, false, 'EnableBumps');
	P = Pawn(Other);
	// End:0x1C5
	if(((P == none) || P.Controller == none) || Enemy == P)
	{
		return false;
	}
	// End:0x217
	if((Squad != none) && UTSquadAI(Squad).SetEnemy(self, P))
	{
		WhatToDoNext();
		return false;
	}
	// End:0x230
	if(Enemy == P)
	{
		return false;
	}
	// End:0x248
	if(CheckPathToGoalAround(P))
	{
		return false;
	}
	ClearPathFor(P.Controller);
	return false;
	//return ReturnValue;	
}

function bool PriorityObjective()
{
	return int(UTSquadAI(Squad).PriorityObjective(self)) > int(0);
	//return ReturnValue;	
}

function SetFall()
{
	local Vector TestVelocity, AdjustedDest, Dir;
	local UTPawn P;
	local NavigationPoint Nav;

	// End:0x3E
	if(Pawn.bCanFly)
	{
		Pawn.SetPhysics(4);
		return;
	}
	P = UTPawn(Pawn);
	// End:0xBC
	if((P != none) && P.bNoJumpAdjust)
	{
		UTPawn(Pawn).bNoJumpAdjust = false;
		return;		
	}
	else
	{
		bPlannedJump = true;
		AdjustedDest = ((MoveTarget != none) ? MoveTarget.GetDestination(self) : GetDestinationPosition());
		Pawn.SuggestJumpVelocity(Pawn.Velocity, ((MoveTarget != none) ? MoveTarget.GetDestination(self) : GetDestinationPosition()), Pawn.Location);
		// End:0x3DB
		if((P != none) && P.bRequiresDoubleJump)
		{
			Nav = NavigationPoint(MoveTarget);
			// End:0x3A1
			if((HighJumpNodeCostModifier > 0) && Nav != none)
			{
				Dir = AdjustedDest - Location;
				Dir.Z = 0.0000000;
				AdjustedDest -= (Normal(Dir) * Nav.CylinderComponent.CollisionRadius);
				// End:0x3A1
				if(FastTrace(AdjustedDest, AdjustedDest - (vect(0.0000000, 0.0000000, 1.0000000) * (Nav.CylinderComponent.CollisionHeight + 5.0000000)))!)
				{
					Pawn.SuggestJumpVelocity(TestVelocity, AdjustedDest, Pawn.Location);
					// End:0x3A1
					if(P.bRequiresDoubleJump!)
					{
						P.Velocity = TestVelocity;
					}
				}
			}
			// End:0x3DB
			if(P.bRequiresDoubleJump)
			{
				bNotifyApex = true;
				bPendingDoubleJump = true;
			}
		}
		Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	}
	//return;	
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
	local Vector Vel2D;

	LastBlockingVehicle = Vehicle(FloorActor);
	bInDodgeMove = false;
	bPlannedJump = false;
	bNotifyFallingHitWall = false;
	// End:0x2A0
	if(MoveTarget != none)
	{
		Vel2D = Pawn.Velocity;
		Vel2D.Z = 0.0000000;
		// End:0x171
		if((Vel2D Dot (MoveTarget.Location - Pawn.Location)) < float(0))
		{
			Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
			// End:0x15F
			if(NavigationPoint(MoveTarget) != none)
			{
				Pawn.SetAnchor(NavigationPoint(MoveTarget));
			}
			MoveTimer = -1.0000000;			
		}
		else
		{
			// End:0x2A0
			if((((((NavigationPoint(MoveTarget) != none) && InLatentExecution(503)) && FRand() < 0.8500000) && FRand() < DodgeToGoalPct) && (Pawn.Location.Z + Pawn.MaxStepHeight) >= MoveTarget.Location.Z) && VSize(MoveTarget.Location - Pawn.Location) > float(800))
			{
				bNotifyPostLanded = true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

event NotifyPostLanded()
{
	bNotifyPostLanded = false;
	SetTimer(0.2500000 + (0.1500000 * FRand()), false, 'TimedDodgeToMoveTarget');
	//return;	
}

function TimedDodgeToMoveTarget()
{
	// End:0x9F
	if((((Pawn != none) && int(Pawn.Physics) == int(1)) && CurrentPath != none) && (CurrentPath.reachFlags & 257) == CurrentPath.reachFlags)
	{
		MayDodgeToMoveTarget();
	}
	//return;	
}

function bool StartMoveToward(Actor O)
{
	// End:0x140
	if(MoveTarget == none)
	{
		// End:0x72
		if((O == Enemy) && O != none)
		{
			FailedHuntTime = WorldInfo.TimeSeconds;
			FailedHuntEnemy = Enemy;
		}
		// End:0xEE
		if(bSoaking && int(Pawn.Physics) != int(2))
		{
			SoakStop("COULDN'T FIND ROUTE TO " $ O.GetHumanReadableName());
		}
		GoalString = ((("No path to " $ O.GetHumanReadableName()) @ "(") $ string(O)) $ ")";		
	}
	else
	{
		SetAttractionState();
	}
	return MoveTarget != none;
	//return ReturnValue;	
}

function bool SetRouteToGoal(Actor A)
{
	// End:0x24
	if(Pawn.bStationary)
	{
		return false;
	}
	RouteGoal = A;
	FindBestPathToward(A, false, true);
	return StartMoveToward(A);
	//return ReturnValue;	
}

event bool AllowDetourTo(NavigationPoint N)
{
	return UTSquadAI(Squad).AllowDetourTo(self, N);
	//return ReturnValue;	
}

function bool FindBestPathToward(Actor A, bool bCheckedReach, bool bAllowDetour)
{
	// End:0x36
	if(bCheckedReach! && ActorReachable(A))
	{
		MoveTarget = A;		
	}
	else
	{
		MoveTarget = FindPathToward(A, (((bAllowDetour && Pawn.bCanPickupInventory) && Vehicle(Pawn) == none) && NavigationPoint(A) != none) && bForceNoDetours!);
	}
	// End:0xD5
	if(MoveTarget != none)
	{
		return true;		
	}
	else
	{
		// End:0x16E
		if((A == Enemy) && A != none)
		{
			// End:0x133
			if(int(Pawn.Physics) == int(4))
			{
				LoseEnemy();				
			}
			else
			{
				FailedHuntTime = WorldInfo.TimeSeconds;
				FailedHuntEnemy = Enemy;
			}
		}
		// End:0x1C5
		if(bSoaking && int(Physics) != int(2))
		{
			SoakStop("COULDN'T FIND BEST PATH TO " $ string(A));
		}
	}
	return false;
	//return ReturnValue;	
}

function Vector GetDirectionHint()
{
	local Vector Result;

	Result = DirectionHint;
	DirectionHint = vect(0.0000000, 0.0000000, 0.0000000);
	return Result;
	//return ReturnValue;	
}

function bool CheckFutureSight(float DeltaTime)
{
	local Vector FutureLoc;

	// End:0x5B
	if(Pawn.Acceleration == vect(0.0000000, 0.0000000, 0.0000000))
	{
		FutureLoc = Pawn.Location;		
	}
	else
	{
		FutureLoc = Pawn.Location + ((Pawn.GroundSpeed * Normal(Pawn.Acceleration)) * DeltaTime);
	}
	// End:0x13D
	if(Pawn.Base != none)
	{
		FutureLoc += (Pawn.Base.Velocity * DeltaTime);
	}
	// End:0x19B
	if(FastTrace(FutureLoc, Pawn.Location)! && int(Pawn.Physics) != int(2))
	{
		return false;
	}
	// End:0x1CE
	if(FastTrace(GetFocalPoint() + (TrackedVelocity * DeltaTime), FutureLoc))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

event float AdjustAimError(float TargetDist, bool bInstantProj)
{
	local float aimdist, desireddist, NewAngle, aimerror, TargetRadius, TargetHeight,
		FullAcquisitionTime, LowVisibilityMult;

	local bool bDefendMelee;
	local UTMapInfo MapInfo;
	local Pawn PFocus;

	// End:0x33
	if(UTWeapon(Pawn.Weapon) == none)
	{
		return 0.0000000;
	}
	aimerror = UTWeapon(Pawn.Weapon).aimerror;
	PFocus = Pawn(Focus);
	MapInfo = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0x236
	if(((MapInfo != none) && MapInfo.VisibilityModifier < 1.0000000) && TargetDist > ((Pawn.SightRadius * 0.7500000) * MapInfo.VisibilityModifier))
	{
		LowVisibilityMult = ((TargetDist > (Pawn.SightRadius * MapInfo.VisibilityModifier)) ? 4.0000000 : 2.0000000);
		// End:0x222
		if((PFocus != none) && (PFocus.GetCollisionRadius() + PFocus.GetCollisionHeight()) > 200.0000000)
		{
			LowVisibilityMult *= 0.7500000;
		}
		aimerror *= LowVisibilityMult;
	}
	// End:0x279
	if((PFocus != none) && PFocus.IsInvisible())
	{
		aimerror *= 4.0000000;
	}
	// End:0x2DD
	if((PFocus != none) && PFocus.bStationary)
	{
		aimerror *= 0.1500000;
		return float(Rand(int(float(2) * aimerror))) - aimerror;
	}
	bDefendMelee = (Focus == Enemy) && DefendMelee(TargetDist);
	// End:0x331
	if(bDefendMelee)
	{
		aimerror *= 0.5000000;
	}
	// End:0x375
	if(VSizeSq(TrackedVelocity) < 2500.0000000)
	{
		aimerror *= (0.2000000 + (0.0600000 * (float(7) - FMin(7.0000000, Skill))));
	}
	// End:0x52C
	if((Stopped()) && WorldInfo.TimeSeconds > StopStartTime)
	{
		// End:0x3DD
		if((Skill + Accuracy) > float(4))
		{
			aimerror *= 0.7500000;
		}
		// End:0x4C1
		if((UTWeapon(Pawn.Weapon) != none) && UTWeapon(Pawn.Weapon).bSniping)
		{
			aimerror *= FClamp(((1.5000000 - (0.0800000 * FMin(Skill, 7.0000000))) - (0.8000000 * FRand())) / ((WorldInfo.TimeSeconds - StopStartTime) + 0.4000000), 0.3000000, 1.0000000);			
		}
		else
		{
			aimerror *= FClamp(((2.0000000 - (0.0800000 * FMin(Skill, 7.0000000))) - FRand()) / ((WorldInfo.TimeSeconds - StopStartTime) + 0.4000000), 0.7000000, 1.0000000);
		}
	}
	// End:0x57F
	if(bDefendMelee!)
	{
		aimerror *= (3.3000000 - (0.4000000 * (FClamp(Skill + Accuracy, 0.0000000, 8.0000000) + (0.3000000 * FRand()))));
	}
	// End:0x5F5
	if((Skill < (float(5) + (float(2) * FRand()))) && (WorldInfo.TimeSeconds - Pawn.LastPainTime) < 0.2000000)
	{
		aimerror *= 1.3000000;
	}
	// End:0x64B
	if(int(Pawn.Physics) == int(2))
	{
		aimerror *= (1.6000000 - (0.0400000 * (Skill + Accuracy)));
	}
	FullAcquisitionTime = 0.5000000 + (1.0000000 * (7.0000000 - FMin(7.0000000, Skill + ReactionTime)));
	// End:0x72C
	if(AcquireTime > (WorldInfo.TimeSeconds - FullAcquisitionTime))
	{
		// End:0x6FF
		if(Skill < 6.0000000)
		{
			aimerror *= 2.0000000;
			// End:0x6FC
			if(bInstantProj)
			{
				aimerror *= 1.2000000;
			}			
		}
		else
		{
			aimerror *= 1.5000000;
			// End:0x72C
			if(bInstantProj)
			{
				aimerror *= 1.5000000;
			}
		}
	}
	aimerror = ((2.0000000 * aimerror) * FRand()) - aimerror;
	// End:0x876
	if(Abs(aimerror) > 900.0000000)
	{
		// End:0x789
		if(bInstantProj)
		{
			desireddist = 180.0000000;			
		}
		else
		{
			desireddist = 500.0000000;
		}
		GetBoundingCylinder(TargetRadius, TargetHeight);
		desireddist += TargetRadius;
		aimdist = Tan(0.0000959 * aimerror) * TargetDist;
		// End:0x876
		if(Abs(aimdist) > desireddist)
		{
			NewAngle = Atan2(desireddist, TargetDist) / 0.0000959;
			// End:0x85C
			if(aimerror > float(0))
			{
				aimerror = NewAngle;				
			}
			else
			{
				aimerror = -1.0000000 * NewAngle;
			}
		}
	}
	return aimerror;
	//return ReturnValue;	
}

function Rotator GetAdjustedAimFor(Weapon InWeapon, Vector projStart)
{
	local Rotator FireRotation;
	local float TargetDist, projSpeed, TargetHeight;
	local Actor HitActor;
	local Vector FireSpot, FireDir, HitLocation, HitNormal;
	local bool bDefendMelee, bClean;
	local Class<UTProjectile> ProjectileClass;
	local UTWeapon W;

	// End:0x19
	if(Focus == none)
	{
		return Rotation;
	}
	W = UTWeapon(InWeapon);
	// End:0x4E
	if(W == none)
	{
		return Rotation;
	}
	ProjectileClass = Class<UTProjectile>(W.GetProjectileClass());
	// End:0xB7
	if(ProjectileClass != none)
	{
		projSpeed = ProjectileClass.default.Speed;
	}
	FireSpot = GetFocalPoint();
	TargetDist = VSize(GetFocalPoint() - Pawn.Location);
	// End:0x2C7
	if(Focus.IsStationary())
	{
		// End:0x181
		if((ProjectileClass == none) || int(ProjectileClass.default.Physics) != int(2))
		{
			FireRotation = Rotator(GetFocalPoint() - projStart);			
		}
		else
		{
			SuggestTossVelocity(FireDir, GetFocalPoint(), projStart, projSpeed, ProjectileClass.default.TossZ, 0.2000000,, ((PhysicsVolume.bWaterVolume) ? PhysicsVolume.TerminalVelocity : ProjectileClass.default.TerminalVelocity));
			FireRotation = Rotator(FireDir);
		}
		// End:0x2B1
		if(Vehicle(Pawn) == none)
		{
			FireRotation.Yaw = Pawn.Rotation.Yaw;
		}
		SetRotation(FireRotation);
		return Rotation;
	}
	// End:0x3B9
	if(((((WorldInfo.TimeSeconds - LastActionMusicUpdate) > 6.0000000) && Enemy != none) && Focus == Enemy) && UTPlayerController(Enemy.Controller) != none)
	{
		LastActionMusicUpdate = WorldInfo.TimeSeconds;
		UTPlayerController(Enemy.Controller).ClientMusicEvent(0);
	}
	bDefendMelee = (Focus == Enemy) && DefendMelee(TargetDist);
	bClean = false;
	// End:0x446
	if(Pawn(Focus) != none)
	{
		TargetHeight = Pawn(Focus).GetCollisionHeight();
	}
	// End:0x6D3
	if((ProjectileClass != none) && int(ProjectileClass.default.Physics) == int(2))
	{
		// End:0x61C
		if(((W.bRecommendSplashDamage && Pawn(Focus) != none) && (Skill >= float(4)) || bDefendMelee) && ((int(Focus.Physics) == int(2)) && (Pawn.Location.Z + float(80)) >= GetFocalPoint().Z) || ((Pawn.Location.Z + float(19)) >= GetFocalPoint().Z) && bDefendMelee || Skill > ((6.5000000 * FRand()) - 0.5000000))
		{
			FireSpot = FireSpot - (vect(0.0000000, 0.0000000, 1.0000000) * TargetHeight);
		}
		SuggestTossVelocity(FireDir, FireSpot, projStart, projSpeed, ProjectileClass.default.TossZ, 0.2000000,, ((PhysicsVolume.bWaterVolume) ? PhysicsVolume.TerminalVelocity : ProjectileClass.default.TerminalVelocity));		
	}
	else
	{
		// End:0xA47
		if(W.bRecommendSplashDamage && Pawn(Focus) != none)
		{
			// End:0x807
			if(W.bLockedAimWhileFiring)
			{
				HitActor = Trace(HitLocation, HitNormal, FireSpot - vect(0.0000000, 0.0000000, 1000.0000000), FireSpot, false);
				bClean = HitActor == none;
				// End:0x7E2
				if(bClean!)
				{
					FireSpot = HitLocation + vect(0.0000000, 0.0000000, 20.0000000);
					bClean = FastTrace(FireSpot, projStart);					
				}
				else
				{
					bClean = FastTrace(FireSpot, projStart);
				}				
			}
			else
			{
				// End:0xA47
				if(((Skill >= float(4)) || bDefendMelee) && ((int(Focus.Physics) == int(2)) && (Pawn.Location.Z + float(80)) >= GetFocalPoint().Z) || ((Pawn.Location.Z + float(19)) >= GetFocalPoint().Z) && bDefendMelee || Skill > ((6.5000000 * FRand()) - 0.5000000))
				{
					HitActor = Trace(HitLocation, HitNormal, FireSpot - (vect(0.0000000, 0.0000000, 1.0000000) * (TargetHeight + float(6))), FireSpot, false);
					bClean = HitActor == none;
					// End:0x9FA
					if(bClean!)
					{
						FireSpot = HitLocation + vect(0.0000000, 0.0000000, 3.0000000);
						bClean = FastTrace(FireSpot, projStart);						
					}
					else
					{
						bClean = (int(Focus.Physics) == int(2)) && FastTrace(FireSpot, projStart);
					}
				}
			}
		}
		// End:0xB04
		if((W.bSniping && Stopped()) && Skill > (float(5) + (float(6) * FRand())))
		{
			FireSpot.Z = GetFocalPoint().Z + (0.9000000 * TargetHeight);
			bClean = FastTrace(FireSpot, projStart);
		}
		// End:0xB6F
		if(bClean!)
		{
			FireSpot.Z = GetFocalPoint().Z;
			bClean = FastTrace(FireSpot, projStart);
		}
		// End:0xC5D
		if((((ProjectileClass != none) && int(ProjectileClass.default.Physics) == int(2)) && bClean!) && bEnemyInfoValid)
		{
			FireSpot = LastSeenPos;
			HitActor = Trace(HitLocation, HitNormal, FireSpot, projStart, false);
			// End:0xC51
			if(HitActor != none)
			{
				bCanFire = false;
				FireSpot += ((float(2) * TargetHeight) * HitNormal);
			}
			bClean = true;
		}
		// End:0xCDA
		if(bClean!)
		{
			FireSpot.Z = GetFocalPoint().Z + (0.9000000 * TargetHeight);
			bClean = FastTrace(FireSpot, projStart);
		}
		// End:0xF7C
		if((bClean! && Focus == Enemy) && bEnemyInfoValid)
		{
			FireSpot = LastSeenPos;
			// End:0xDA4
			if(Pawn.Location.Z >= LastSeenPos.Z)
			{
				FireSpot.Z -= (0.4000000 * TargetHeight);
			}
			HitActor = Trace(HitLocation, HitNormal, FireSpot, projStart, false);
			// End:0xF7C
			if(HitActor != none)
			{
				FireSpot = LastSeenPos + ((float(2) * TargetHeight) * HitNormal);
				// End:0xEFF
				if(((Pawn.Weapon != none) && UTWeapon(Pawn.Weapon).GetDamageRadius() > float(0)) && Skill >= float(4))
				{
					HitActor = Trace(HitLocation, HitNormal, FireSpot, projStart, false);
					// End:0xEFF
					if(HitActor != none)
					{
						FireSpot += ((float(2) * TargetHeight) * HitNormal);
					}
				}
				// End:0xF7C
				if((UTWeapon(Pawn.Weapon) != none) && UTWeapon(Pawn.Weapon).bFastRepeater!)
				{
					bCanFire = false;
				}
			}
		}
		FireDir = FireSpot - projStart;
	}
	FireRotation = Rotator(FireDir);
	// End:0x1015
	if(Vehicle(Pawn) == none)
	{
		FireRotation.Yaw = Pawn.Rotation.Yaw;
	}
	// End:0x1060
	if(ProjectileClass == none)
	{
		InstantWarnTarget(Focus, Pawn.Weapon, Vector(FireRotation));
	}
	ShotTarget = Pawn(Focus);
	SetRotation(FireRotation);
	return FireRotation;
	//return ReturnValue;	
}

function bool TryDuckTowardsMoveTarget(Vector Dir, Vector Y)
{
	local Vector MoveDir;

	// End:0x14A
	if(((MoveTarget != none) && InLatentExecution(503)) && (Skill + StrafingAbility) > (4.0000000 + (2.0000000 * FRand())))
	{
		MoveDir = MoveTarget.Location - Pawn.Location;
		MoveDir.Z = 0.0000000;
		MoveDir = Normal(MoveDir);
		// End:0x14A
		if(Abs(MoveDir Dot Dir) < 0.5000000)
		{
			// End:0x134
			if((MoveDir Dot Y) < 0.0000000)
			{
				Y *= float(-1);
				TryToDuck(Y, true);				
			}
			else
			{
				TryToDuck(Y, false);
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

event DelayedWarning()
{
	local Vector X, Y, Z, Dir, LineDist, FuturePos,
		HitLocation, HitNormal;

	local Actor HitActor;
	local float Dist;

	// End:0x54
	if(((Pawn == none) || WarningProjectile == none) || WarningProjectile.Velocity == vect(0.0000000, 0.0000000, 0.0000000))
	{
		return;
	}
	// End:0xBB
	if(Enemy == none)
	{
		// End:0xB9
		if(Squad != none)
		{
			UTSquadAI(Squad).SetEnemy(self, WarningProjectile.Instigator);
		}
		return;
	}
	// End:0x101
	if(UTVehicle_Hoverboard(Pawn) != none)
	{
		// End:0xFF
		if((FRand() < 0.5000000) && Skill >= 1.0000000)
		{
			LeaveVehicle(true);
		}
		return;
	}
	Dir = Normal(WarningProjectile.Velocity);
	FuturePos = Pawn.Location + ((Pawn.Velocity * VSize(WarningProjectile.Location - Pawn.Location)) / VSize(WarningProjectile.Velocity));
	LineDist = FuturePos - (WarningProjectile.Location + ((Dir Dot (FuturePos - WarningProjectile.Location)) * Dir));
	Dist = VSize(LineDist);
	// End:0x295
	if(Dist > (float(230) + Pawn.GetCollisionRadius()))
	{
		return;
	}
	// End:0x44C
	if(Dist > (1.2000000 * Pawn.GetCollisionHeight()))
	{
		// End:0x337
		if((WarningProjectile.Damage <= float(40)) && float(Pawn.Health) > WarningProjectile.Damage)
		{
			return;
		}
		// End:0x44C
		if(((int(WarningProjectile.Physics) == int(6)) && Dist > (Pawn.GetCollisionHeight() + float(100))) && WarningProjectile.IsA('UTProj_Shockball')!)
		{
			HitActor = Trace(HitLocation, HitNormal, WarningProjectile.Location + WarningProjectile.Velocity, WarningProjectile.Location, false);
			// End:0x44C
			if(HitActor == none)
			{
				return;
			}
		}
	}
	GetAxes(Pawn.Rotation, X, Y, Z);
	X.Z = 0.0000000;
	Dir = WarningProjectile.Location - Pawn.Location;
	Dir.Z = 0.0000000;
	Dir = Normal(Dir);
	// End:0x54A
	if((Dir Dot Normal(X)) < 0.7000000)
	{
		return;
	}
	// End:0x5D9
	if(TryDuckTowardsMoveTarget(Dir, Y)!)
	{
		// End:0x5C5
		if((WarningProjectile.Velocity Dot Y) > float(0))
		{
			Y *= float(-1);
			TryToDuck(Y, true);			
		}
		else
		{
			TryToDuck(Y, false);
		}
	}
	//return;	
}

function ReceiveProjectileWarning(Projectile Proj)
{
	local float ProjTime;
	local Vector X, Y, Z, enemyDir;

	LastUnderFire = WorldInfo.TimeSeconds;
	// End:0x5D
	if((WorldInfo.TimeSeconds - LastWarningTime) < 0.5000000)
	{
		return;
	}
	LastWarningTime = WorldInfo.TimeSeconds;
	// End:0xFB
	if((((Pawn.Health <= 0) || Skill < float(2)) || Enemy == none) || int(Pawn.Physics) == int(3))
	{
		return;
	}
	// End:0x460
	if(Proj.Speed > float(0))
	{
		ProjTime = Proj.GetTimeToLocation(Pawn.Location);
		// End:0x19A
		if(ProjTime < (0.3500000 - (0.0300000 * (Skill + ReactionTime))))
		{
			return;
		}
		// End:0x1D6
		if(ProjTime < (float(2) - ((0.2650000 + (FRand() * 0.2000000)) * (Skill + ReactionTime))))
		{
			return;
		}
		// End:0x257
		if((WarningProjectile != none) && (VSize(WarningProjectile.Location - Pawn.Location) / WarningProjectile.Speed) < ProjTime)
		{
			return;
		}
		// End:0x351
		if((ProjTime < 1.2000000) || WarningProjectile != none)
		{
			GetAxes(Rotation, X, Y, Z);
			enemyDir = Proj.Location - Pawn.Location;
			enemyDir.Z = 0.0000000;
			X.Z = 0.0000000;
			// End:0x351
			if((Normal(enemyDir) Dot Normal(X)) < 0.7000000)
			{
				return;
			}
		}
		// End:0x3DF
		if((Skill + ReactionTime) >= float(7))
		{
			WarningDelay = WorldInfo.TimeSeconds + FMax(0.0800000, FMax(0.3500000 - ((0.0250000 * (Skill + ReactionTime)) * (float(1) + FRand())), ProjTime - 0.6500000));			
		}
		else
		{
			WarningDelay = WorldInfo.TimeSeconds + FMax(0.0800000, FMax(0.3500000 - ((0.0200000 * (Skill + ReactionTime)) * (float(1) + FRand())), ProjTime - 0.6500000));
		}
		WarningProjectile = Proj;
	}
	//return;	
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	LastUnderFire = WorldInfo.TimeSeconds;
	// End:0x66
	if((InstigatedBy != none) && InstigatedBy != self)
	{
		DamageAttitudeTo(InstigatedBy, float(Damage));
	}
	//return;	
}

function DelayedInstantWarning()
{
	local Vector X, Y, Z, Dir;

	// End:0x6C
	if((((Pawn == none) || InstantWarningShooter == none) || InstantWarningShooter.bDeleteMe) || InstantWarningShooter.Controller == none)
	{
		return;
	}
	// End:0xBE
	if(Enemy == none)
	{
		// End:0xBC
		if(Squad != none)
		{
			UTSquadAI(Squad).SetEnemy(self, InstantWarningShooter);
		}
		return;
	}
	GetAxes(Pawn.Rotation, X, Y, Z);
	X.Z = 0.0000000;
	Dir = InstantWarningShooter.Location - Pawn.Location;
	Dir.Z = 0.0000000;
	Dir = Normal(Dir);
	// End:0x1D1
	if(((Dir Dot Normal(X)) < 0.7000000) || LineOfSightTo(InstantWarningShooter)!)
	{
		return;
	}
	// End:0x23B
	if(TryDuckTowardsMoveTarget(Dir, Y)!)
	{
		// End:0x227
		if(FRand() < 0.5000000)
		{
			Y *= float(-1);
			TryToDuck(Y, true);			
		}
		else
		{
			TryToDuck(Y, false);
		}
	}
	//return;	
}

event ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
	local float enemyDist, ProjTime, DodgeTime;
	local Vector X, Y, Z, enemyDir;

	LastUnderFire = WorldInfo.TimeSeconds;
	// End:0x5D
	if((WorldInfo.TimeSeconds - LastWarningTime) < 0.5000000)
	{
		return;
	}
	LastWarningTime = WorldInfo.TimeSeconds;
	// End:0xF5
	if((Pawn.bStationary || Pawn.bCanStrafe!) || Pawn.Health <= 0)
	{
		return;
	}
	// End:0x147
	if(Enemy == none)
	{
		// End:0x145
		if(Squad != none)
		{
			UTSquadAI(Squad).SetEnemy(self, shooter);
		}
		return;
	}
	// End:0x18D
	if(UTVehicle_Hoverboard(Pawn) != none)
	{
		// End:0x18B
		if((FRand() < 0.5000000) && Skill >= 1.0000000)
		{
			LeaveVehicle(true);
		}
		return;
	}
	// End:0x1ED
	if(((Skill < 4.0000000) || int(Pawn.Physics) == int(3)) || FRand() > ((0.2000000 * Skill) - 0.3300000))
	{
		return;
	}
	enemyDist = VSize(shooter.Location - Pawn.Location);
	// End:0x294
	if(((enemyDist > (2000.0000000 * ((Skill + StrafingAbility) - 2.0000000))) && Vehicle(shooter) == none) && Stopped()!)
	{
		return;
	}
	GetAxes(Pawn.Rotation, X, Y, Z);
	enemyDir = shooter.Location - Pawn.Location;
	enemyDir.Z = 0.0000000;
	X.Z = 0.0000000;
	// End:0x37F
	if((Normal(enemyDir) Dot Normal(X)) < 0.7000000)
	{
		return;
	}
	// End:0x403
	if((projSpeed > float(0)) && Vehicle(shooter) == none)
	{
		ProjTime = enemyDist / projSpeed;
		// End:0x403
		if(ProjTime < (0.1100000 + (0.1500000 * FRand())))
		{
			// End:0x401
			if(Stopped())
			{
				GotoState('TacticalMove');
			}
			return;
		}
	}
	// End:0x449
	if((Skill + StrafingAbility) < (2.0000000 + (3.0000000 * FRand())))
	{
		// End:0x447
		if(Stopped())
		{
			GotoState('TacticalMove');
		}
		return;
	}
	// End:0x65F
	if((projSpeed < float(0)) && shooter.Weapon != none)
	{
		DodgeTime = (shooter.Weapon.GetFireInterval(shooter.Weapon.CurrentFireMode) - 0.1500000) - (0.1000000 * FRand());
		// End:0x65F
		if(((DodgeTime > 0.0000000) && DodgeTime >= (0.3500000 - (0.0300000 * (Skill + ReactionTime)))) && DodgeTime >= (2.0000000 - ((0.2650000 + (FRand() * 0.2000000)) * (Skill + ReactionTime))))
		{
			// End:0x65D
			if(((((InstantWarningShooter == none) || InstantWarningShooter.bDeleteMe) || InstantWarningShooter.Controller == none) || IsTimerActive('DelayedInstantWarning')!) || (GetTimerRate('DelayedInstantWarning') - GetTimerCount('DelayedInstantWarning')) > DodgeTime)
			{
				InstantWarningShooter = shooter;
				SetTimer(DodgeTime, false, 'DelayedInstantWarning');
			}
			return;
		}
	}
	// End:0x698
	if((FRand() * (Skill + float(4))) < float(4))
	{
		// End:0x696
		if(Stopped())
		{
			GotoState('TacticalMove');
		}
		return;
	}
	// End:0x6C3
	if(int(Pawn.Physics) == int(2))
	{
		return;
	}
	// End:0x70D
	if((FireDir Dot Y) > float(0))
	{
		Y *= float(-1);
		// End:0x70A
		if(TryToDuck(Y, true))
		{
			return;
		}		
	}
	else
	{
		// End:0x726
		if(TryToDuck(Y, false))
		{
			return;
		}
	}
	// End:0x741
	if(Stopped())
	{
		GotoState('TacticalMove');
	}
	//return;	
}

event ReceiveRunOverWarning(UDKVehicle V, float projSpeed, Vector VehicleDir)
{
	// End:0x6A
	if(WorldInfo.GRI.OnSameTeam(V, self)!)
	{
		ReceiveWarning(V, projSpeed, VehicleDir);
		return;
	}
	// End:0x10A
	if(((Pawn.bStationary || Pawn.Health <= 0) || int(Pawn.Physics) == int(2)) || int(Pawn.Physics) == int(3))
	{
		return;
	}
	// End:0x1E3
	if(PointDistToLine(Pawn.Location, VehicleDir, V.Location) > (((V.GetCollisionRadius() + V.GetCollisionHeight()) + Pawn.GetCollisionRadius()) + Pawn.GetCollisionHeight()))
	{
		return;
	}
	ReceiveWarning(V, projSpeed, VehicleDir);
	//return;	
}

event NotifyFallingHitWall(Vector HitNormal, Actor HitActor)
{
	bNotifyFallingHitWall = false;
	TryWallDodge(HitNormal, HitActor);
	//return;	
}

event MissedDodge()
{
	local Actor HitActor;
	local Vector HitNormal, HitLocation, Extent, Vel2D;

	// End:0x9E
	if(UTPawn(Pawn).CanDoubleJump() && Abs(Pawn.Velocity.Z) < float(100))
	{
		UTPawn(Pawn).DoDoubleJump(false);
		bPendingDoubleJump = false;
	}
	Extent = Pawn.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
	Extent.Z = Pawn.GetCollisionHeight();
	HitActor = Trace(HitLocation, HitNormal, Pawn.Location - ((float(20) + (float(3) * Pawn.MaxStepHeight)) * vect(0.0000000, 0.0000000, 1.0000000)), Pawn.Location, false, Extent);
	Vel2D = Pawn.Velocity;
	Vel2D.Z = 0.0000000;
	// End:0x2D0
	if(HitActor != none)
	{
		Pawn.Acceleration = (float(-1) * Pawn.AccelRate) * Normal(Vel2D);
		Pawn.Velocity.X = 0.0000000;
		Pawn.Velocity.Z = 0.0000000;
		return;
	}
	Pawn.Acceleration = Pawn.AccelRate * Normal(Vel2D);
	//return;	
}

function bool TryWallDodge(Vector HitNormal, Actor HitActor)
{
	local Vector X, Y, Z, Dir, TargetDir, NewHitNormal,
		HitLocation, Extent;

	local float DP;
	local Actor NewHitActor;

	// End:0x50
	if((Abs(HitNormal.Z) > 0.7000000) || HitActor.bWorldGeometry!)
	{
		return false;
	}
	// End:0x9D
	if((Pawn.Velocity.Z < float(-150)) && FRand() < 0.4000000)
	{
		return false;
	}
	// End:0xCA
	if(UTPawn(Pawn).bDodging)
	{
		return false;
	}
	Extent = Pawn.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
	Extent.Z = 0.5000000 * Pawn.GetCollisionHeight();
	NewHitActor = Trace(HitLocation, NewHitNormal, Pawn.Location - (float(32) * HitNormal), Pawn.Location, false, Extent);
	// End:0x1CE
	if(NewHitActor == none)
	{
		return false;
	}
	GetAxes(Pawn.Rotation, X, Y, Z);
	Dir = HitNormal;
	Dir.Z = 0.0000000;
	Dir = Normal(Dir);
	// End:0x3B7
	if(InLatentExecution(503))
	{
		TargetDir = MoveTarget.Location - Pawn.Location;
		TargetDir.Z = 0.0000000;
		TargetDir = Normal(TargetDir);
		DP = HitNormal Dot TargetDir;
		// End:0x3B7
		if((DP >= float(0)) && VSize(MoveTarget.Location - Pawn.Location) > float(200))
		{
			// End:0x3A4
			if(DP < 0.7000000)
			{
				Dir = Normal(TargetDir + (HitNormal * (float(1) - DP)));				
			}
			else
			{
				Dir = TargetDir;
			}
		}
	}
	// End:0x45E
	if(Abs(X Dot Dir) > Abs(Y Dot Dir))
	{
		// End:0x431
		if((X Dot Dir) > float(0))
		{
			UTPawn(Pawn).CurrentDir = 3;			
		}
		else
		{
			UTPawn(Pawn).CurrentDir = 4;
		}		
	}
	else
	{
		// End:0x4A7
		if((Y Dot Dir) < float(0))
		{
			UTPawn(Pawn).CurrentDir = 1;			
		}
		else
		{
			UTPawn(Pawn).CurrentDir = 2;
		}
	}
	bPlannedJump = true;
	UTPawn(Pawn).PerformDodge(UTPawn(Pawn).CurrentDir, Dir, Normal(Dir Cross vect(0.0000000, 0.0000000, 1.0000000)));
	return true;
	//return ReturnValue;	
}

function ChangeStrafe()
{
	//return;	
}

function bool TryToDuck(Vector duckDir, bool bReversed)
{
	local Vector HitLocation, HitNormal, Extent, Start;
	local Actor HitActor;
	local bool bSuccess, bDuckLeft, bWallHit, bChangeStrafe;
	local float MinDist, Dist;

	// End:0x43
	if(UTVehicle(Pawn) != none)
	{
		return UTVehicle(Pawn).Dodge(0);
	}
	// End:0x67
	if(Pawn.bStationary)
	{
		return false;
	}
	// End:0x85
	if(Stopped())
	{
		GotoState('TacticalMove');		
	}
	else
	{
		// End:0xA6
		if(FRand() < 0.6000000)
		{
			bChangeStrafe = IsStrafing();
		}
	}
	// End:0x162
	if((((Skill < float(3)) || Pawn.PhysicsVolume.bWaterVolume) || int(Pawn.Physics) == int(2)) || Pawn.GetGravityZ() > WorldInfo.DefaultGravityZ)
	{
		return false;
	}
	// End:0x1D5
	if((Pawn.bIsCrouched || Pawn.bWantsToCrouch) || int(Pawn.Physics) != int(1))
	{
		return false;
	}
	duckDir.Z = 0.0000000;
	duckDir *= float(335);
	bDuckLeft = bReversed;
	Extent = Pawn.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
	Extent.Z = Pawn.GetCollisionHeight();
	Start = Pawn.Location + vect(0.0000000, 0.0000000, 25.0000000);
	HitActor = Trace(HitLocation, HitNormal, Start + duckDir, Start, false, Extent);
	MinDist = 150.0000000;
	Dist = VSize(HitLocation - Pawn.Location);
	// End:0x453
	if((HitActor == none) || Dist > float(150))
	{
		// End:0x3A5
		if(HitActor == none)
		{
			HitLocation = Start + duckDir;
		}
		HitActor = Trace(HitLocation, HitNormal, HitLocation - (Pawn.MaxStepHeight * vect(0.0000000, 0.0000000, 2.5000000)), HitLocation, false, Extent);
		bSuccess = (HitActor != none) && HitNormal.Z >= 0.7000000;		
	}
	else
	{
		bWallHit = (Skill + (float(2) * Jumpiness)) > float(5);
		MinDist = (30.0000000 + MinDist) - Dist;
	}
	// End:0x65A
	if(bSuccess!)
	{
		bDuckLeft = bDuckLeft!;
		duckDir *= float(-1);
		HitActor = Trace(HitLocation, HitNormal, Start + duckDir, Start, false, Extent);
		bSuccess = (HitActor == none) || VSize(HitLocation - Pawn.Location) > MinDist;
		// End:0x65A
		if(bSuccess)
		{
			// End:0x5AF
			if(HitActor == none)
			{
				HitLocation = Start + duckDir;
			}
			HitActor = Trace(HitLocation, HitNormal, HitLocation - (Pawn.MaxStepHeight * vect(0.0000000, 0.0000000, 2.5000000)), HitLocation, false, Extent);
			bSuccess = (HitActor != none) && HitNormal.Z >= 0.7000000;
		}
	}
	// End:0x682
	if(bSuccess!)
	{
		// End:0x680
		if(bChangeStrafe)
		{
			ChangeStrafe();
		}
		return false;
	}
	// End:0x6BB
	if((Skill + (float(2) * Jumpiness)) > (float(3) + (float(3) * FRand())))
	{
		bNotifyFallingHitWall = true;
	}
	// End:0x6EE
	if(bNotifyFallingHitWall && bWallHit)
	{
		bDuckLeft = bDuckLeft!;
	}
	// End:0x728
	if(bDuckLeft)
	{
		UTPawn(Pawn).CurrentDir = 1;		
	}
	else
	{
		UTPawn(Pawn).CurrentDir = 2;
	}
	bInDodgeMove = true;
	DodgeLandZ = Pawn.Location.Z;
	UTPawn(Pawn).Dodge(UTPawn(Pawn).CurrentDir);
	return true;
	//return ReturnValue;	
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> DamageType)
{
	// End:0x5B
	if(Squad != none)
	{
		UTSquadAI(Squad).NotifyKilled(Killer, Killed, KilledPawn, DamageType);
	}
	//return;	
}

function Actor FaceMoveTarget()
{
	// End:0x3A
	if((MoveTarget != Enemy) && MoveTarget != Focus)
	{
		StopFiring();
	}
	return MoveTarget;
	//return ReturnValue;	
}

function bool ShouldStrafeTo(Actor WayPoint)
{
	local NavigationPoint N;

	// End:0x49
	if((UTVehicle(Pawn) != none) && UTVehicle(Pawn).bFollowLookDir!)
	{
		return true;
	}
	// End:0x97
	if(((Skill + StrafingAbility) < float(3)) && UTPlayerReplicationInfo(PlayerReplicationInfo).bHasFlag!)
	{
		return false;
	}
	// End:0x134
	if(WayPoint == Enemy)
	{
		// End:0x10D
		if((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon)
		{
			return false;
		}
		return (Skill + StrafingAbility) > ((float(5) * FRand()) - float(1));		
	}
	else
	{
		// End:0x1F6
		if(PickupFactory(WayPoint) == none)
		{
			N = NavigationPoint(WayPoint);
			// End:0x19D
			if((N == none) || N.bNeverUseStrafing)
			{
				return false;
			}
			// End:0x1C4
			if(N.FearCost > 200)
			{
				return true;
			}
			// End:0x1F6
			if(N.bAlwaysUseStrafing && FRand() < 0.8000000)
			{
				return true;
			}
		}
	}
	// End:0x2AD
	if((Pawn(WayPoint) != none) || (UTSquadAI(Squad).SquadLeader != none) && WayPoint == UTSquadAI(Squad).SquadLeader.MoveTarget)
	{
		return (Skill + StrafingAbility) > ((float(5) * FRand()) - float(1));
	}
	// End:0x2D5
	if((Skill + StrafingAbility) < ((float(6) * FRand()) - float(1)))
	{
		return false;
	}
	// End:0x2FF
	if(bFinalStretch! && Enemy == none)
	{
		return FRand() < 0.4000000;
	}
	// End:0x333
	if((WorldInfo.TimeSeconds - LastUnderFire) < float(2))
	{
		return true;
	}
	// End:0x35F
	if((Enemy != none) && LineOfSightTo(Enemy))
	{
		return FRand() < 0.8500000;
	}
	return FRand() < 0.6000000;
	//return ReturnValue;	
}

function Actor FaceActor(float StrafingModifier)
{
	local float RelativeDir;
	local Actor SquadFace;

	// End:0xD9
	if(((((UTGameObjective(Focus) != none) && Focus == Squad.SquadObjective) && UTSquadAI(Squad).GetOrders() == 'ATTACK') && Pawn.IsFiring()) && UTGameObjective(Focus).Shootable())
	{
		return Focus;
	}
	SquadFace = UTSquadAI(Squad).SetFacingActor(self);
	// End:0x125
	if(SquadFace != none)
	{
		return SquadFace;
	}
	// End:0x168
	if(FocusOnLeader(false))
	{
		// End:0x15E
		if(Vehicle(Focus) != none)
		{
			FireWeaponAt(Focus);
		}
		return Focus;
	}
	bRecommendFastMove = false;
	// End:0x23C
	if(((Pawn.bCanStrafe! && (UTVehicle(Pawn) == none) || UTVehicle(Pawn).bSeparateTurretFocus!) || Enemy == none) || (WorldInfo.TimeSeconds - LastSeenTime) > (float(6) - StrafingModifier))
	{
		return FaceMoveTarget();
	}
	// End:0x34E
	if((((MoveTarget == Enemy) || Vehicle(Pawn) != none) || ((Skill + StrafingAbility) >= float(6)) && Pawn.Weapon.bMeleeWeapon!) || (MoveTarget != none) && VSize(MoveTarget.Location - Pawn.Location) < (float(4) * Pawn.GetCollisionRadius()))
	{
		return Enemy;
	}
	// End:0x396
	if((WorldInfo.TimeSeconds - LastSeenTime) > (float(4) - StrafingModifier))
	{
		return FaceMoveTarget();
	}
	// End:0x3DE
	if((MoveTarget == none) || (Skill > 2.5000000) && UTCarriedObject(MoveTarget) != none)
	{
		return Enemy;
	}
	RelativeDir = Normal((Enemy.Location - Pawn.Location) - (vect(0.0000000, 0.0000000, 1.0000000) * (Enemy.Location.Z - Pawn.Location.Z))) Dot Normal((MoveTarget.Location - Pawn.Location) - (vect(0.0000000, 0.0000000, 1.0000000) * (MoveTarget.Location.Z - Pawn.Location.Z)));
	// End:0x571
	if(RelativeDir > 0.8500000)
	{
		return Enemy;
	}
	// End:0x600
	if(((RelativeDir > 0.3000000) && UTBot(Enemy.Controller) != none) && MoveTarget == Enemy.Controller.MoveTarget)
	{
		return Enemy;
	}
	// End:0x62C
	if((Skill + StrafingAbility) < (float(2) + FRand()))
	{
		return FaceMoveTarget();
	}
	// End:0x6F7
	if(((((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon) && RelativeDir < 0.3000000) || (Skill + StrafingAbility) < ((float(5) + StrafingModifier) * FRand())) || ((0.4000000 * RelativeDir) + 0.8000000) < FRand())
	{
		return FaceMoveTarget();
	}
	return Enemy;
	//return ReturnValue;	
}

function bool NeedWeapon()
{
	local UTWeapon W;

	// End:0x1A
	if(Vehicle(Pawn) != none)
	{
		return false;
	}
	// End:0x91
	if(Pawn.Weapon.AIRating > 0.5000000)
	{
		return Pawn.Weapon.HasAmmo(0)!;
	}
	// End:0x12D
	foreach Pawn.InvManager.InventoryActors(Class'UTGame.UTWeapon', W)
	{
		// End:0x12C
		if((W.AIRating > 0.5000000) && W.HasAmmo(0))
		{			
			return false;
		}		
	}	
	return true;
	//return ReturnValue;	
}

event float RatePickup(Actor PickupHolder, Class<Inventory> InvClass)
{
	// End:0x8C
	if(PickupHolder.IsA('UTWeaponLocker'))
	{
		return UTWeaponLocker(PickupHolder).BotDesireability(((bCheckDriverPickups) ? Vehicle(Pawn).Driver : Pawn), self);
	}
	return InvClass.static.BotDesireability(PickupHolder, ((bCheckDriverPickups) ? Vehicle(Pawn).Driver : Pawn), self);
	//return ReturnValue;	
}

event float SuperDesireability(PickupFactory P)
{
	// End:0x27
	if(SuperPickupNotSpokenFor(UTPickupFactory(P))!)
	{
		return 0.0000000;
	}
	return P.InventoryType.static.BotDesireability(P, ((bCheckDriverPickups) ? Vehicle(Pawn).Driver : Pawn), self);
	//return ReturnValue;	
}

function bool SuperPickupNotSpokenFor(UTPickupFactory P)
{
	local UTBot CurrentOwner;

	// End:0x11
	if(P == none)
	{
		return false;
	}
	// End:0x37
	if(PlayerReplicationInfo.Team == none)
	{
		return true;
	}
	CurrentOwner = UTBot(P.TeamOwner[PlayerReplicationInfo.Team.TeamIndex]);
	// End:0x194
	if((((CurrentOwner == none) || CurrentOwner == self) || CurrentOwner.Pawn == none) || (CurrentOwner.RouteGoal != P) && CurrentOwner.MoveTarget != P)
	{
		P.TeamOwner[PlayerReplicationInfo.Team.TeamIndex] = none;
		return true;
	}
	// End:0x1FA
	if((UTSquadAI(Squad).GetOrders() == 'Defend') || CurrentOwner.MoveTarget == P)
	{
		return false;
	}
	// End:0x227
	if(UTPlayerReplicationInfo(PlayerReplicationInfo).bHasFlag)
	{
		return true;
	}
	// End:0x27E
	if((CurrentOwner.RouteCache.Length > 1) && CurrentOwner.RouteCache[1] == P)
	{
		return false;
	}
	// End:0x2CB
	if(UTSquadAI(CurrentOwner.Squad).GetOrders() == 'Defend')
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function DamageAttitudeTo(Controller Other, float Damage)
{
	// End:0xC4
	if(((((Pawn.Health > 0) && Damage > float(0)) && Other.Pawn != none) && Squad != none) && UTSquadAI(Squad).SetEnemy(self, Other.Pawn))
	{
		WhatToDoNext();
	}
	//return;	
}

function bool IsRetreating()
{
	return false;
	//return ReturnValue;	
}

function OnAIFreeze(UTSeqAct_AIFreeze FreezeAction)
{
	// End:0x7B
	if(FreezeAction.InputLinks[0].bHasImpulse)
	{
		PushState(((FreezeAction.bAllowWeaponFiring) ? 'FrozenMovement' : 'Frozen'));		
	}
	else
	{
		FreezeAction.ScriptLog(string(self) @ "received unfreeze request while not frozen");
	}
	//return;	
}

function bool IsDefending()
{
	return false;
	//return ReturnValue;	
}

function bool ShouldDefendPosition()
{
	// End:0x2C
	if((DefensePoint != none) && Enemy == none)
	{
		MoveToDefensePoint();
		return true;
	}
	return false;
	//return ReturnValue;	
}

function MoveToDefensePoint()
{
	GotoState('Defending', 'Begin');
	//return;	
}

function MoveAwayFrom(Controller C)
{
	GoalString = "MOVE AWAY FROM/ " $ GoalString;
	GotoState('Defending');
	ClearPathFor(C);
	//return;	
}

function WanderOrCamp()
{
	GotoState('Defending', 'Begin');
	//return;	
}

function EnableBumps()
{
	//return;	
}

function Celebrate()
{
	// End:0x40
	if(UTPawn(Pawn) != none)
	{
		UTPawn(Pawn).PlayVictoryAnimation();
	}
	//return;	
}

function ForceGiveWeapon()
{
	local Vector TossVel, LeaderVel;
	local Pawn LeaderPawn;

	LeaderPawn = UTSquadAI(Squad).SquadLeader.Pawn;
	// End:0xA3
	if((((Pawn == none) || Pawn.Weapon == none) || LeaderPawn == none) || LineOfSightTo(LeaderPawn)!)
	{
		return;
	}
	// End:0x248
	if(Pawn.CanThrowWeapon())
	{
		TossVel = Vector(Pawn.Rotation);
		TossVel.Z = 0.0000000;
		TossVel = Normal(TossVel);
		LeaderVel = Normal(LeaderPawn.Location - Pawn.Location);
		// End:0x1A1
		if((TossVel Dot LeaderVel) > 0.7000000)
		{
			TossVel = LeaderVel;
		}
		TossVel = (TossVel * ((Pawn.Velocity Dot TossVel) + float(500))) + vect(0.0000000, 0.0000000, 200.0000000);
		Pawn.TossInventory(Pawn.Weapon, TossVel);
		SwitchToBestWeapon();
	}
	//return;	
}

function float GetDesiredOffset()
{
	local UTSquadAI UTSquad;

	UTSquad = UTSquadAI(Squad);
	// End:0x89
	if((UTSquad.SquadLeader == none) || MoveTarget != UTSquad.SquadLeader.Pawn)
	{
		return 0.0000000;
	}
	return UTSquad.FormationSize * 0.5000000;
	//return ReturnValue;	
}

function bool LostContact(float MaxTime)
{
	// End:0x11
	if(Enemy == none)
	{
		return true;
	}
	// End:0x68
	if(Enemy.IsInvisible() && MaxTime > 2.0000000)
	{
		MaxTime = FMax(2.0000000, MaxTime - float(2));
	}
	// End:0xAC
	if((WorldInfo.TimeSeconds - FMax(LastSeenTime, AcquireTime)) > MaxTime)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool LoseEnemy()
{
	// End:0x11
	if(Enemy == none)
	{
		return true;
	}
	// End:0x92
	if(((Enemy.Health > 0) && Enemy.Controller != none) && LoseEnemyCheckTime > (WorldInfo.TimeSeconds - 0.2000000))
	{
		return false;
	}
	LoseEnemyCheckTime = WorldInfo.TimeSeconds;
	// End:0xF4
	if(UTSquadAI(Squad).LostEnemy(self))
	{
		bFrustrated = false;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function DoStakeOut()
{
	GotoState('StakeOut');
	//return;	
}

function DoCharge()
{
	// End:0x28
	if(Vehicle(Pawn) != none)
	{
		GotoState('VehicleCharging');
		return;
	}
	// End:0x92
	if(Enemy.PhysicsVolume.bWaterVolume)
	{
		// End:0x8F
		if(Pawn.bCanSwim!)
		{
			DoTacticalMove();
			return;
		}		
	}
	else
	{
		// End:0xE8
		if(Pawn.bCanFly! && Pawn.bCanWalk!)
		{
			DoTacticalMove();
			return;
		}
	}
	GotoState('Charging');
	//return;	
}

function DoTacticalMove()
{
	// End:0x69
	if(Pawn.bCanStrafe!)
	{
		// End:0x5C
		if(Pawn.HasRangedAttack())
		{
			DoRangedAttackOn(Enemy);			
		}
		else
		{
			WanderOrCamp();
		}		
	}
	else
	{
		GotoState('TacticalMove');
	}
	//return;	
}

function DoRetreat()
{
	// End:0x3C
	if(UTSquadAI(Squad).PickRetreatDestination(self))
	{
		GotoState('Retreating');
		return;
	}
	// End:0x125
	if(LineOfSightTo(Enemy))
	{
		GoalString = "No retreat because frustrated";
		bFrustrated = true;
		// End:0xF0
		if((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon)
		{
			GotoState('Charging');			
		}
		else
		{
			// End:0x119
			if(Vehicle(Pawn) != none)
			{
				GotoState('VehicleCharging');				
			}
			else
			{
				DoTacticalMove();
			}
		}
		return;
	}
	GoalString = "Stakeout because no retreat dest";
	DoStakeOut();
	//return;	
}

function bool DefendMelee(float Dist)
{
	return ((Enemy.Weapon != none) && Enemy.Weapon.bMeleeWeapon) && Dist < float(1000);
	//return ReturnValue;	
}

function bool IsStrafing()
{
	return false;
	//return ReturnValue;	
}

function bool EngageDirection(Vector StrafeDir, bool bForced)
{
	WarnInternal((((("Bot called EngageDirection in state " $ string(GetStateName())) $ " pawn ") $ string(Pawn)) $ " health ") $ string(Pawn.Health));
	return false;
	//return ReturnValue;	
}

function bool IsHunting()
{
	return false;
	//return ReturnValue;	
}

function bool FindViewSpot()
{
	return false;
	//return ReturnValue;	
}

function bool Stopped()
{
	return bPreparingMove;
	//return ReturnValue;	
}

function bool IsShootingObjective()
{
	return false;
	//return ReturnValue;	
}

function bool FocusOnLeader(bool bLeaderFiring)
{
	return (UTWeapon(Pawn.Weapon) != none) && UTWeapon(Pawn.Weapon).FocusOnLeader(bLeaderFiring);
	//return ReturnValue;	
}

function StopMovement()
{
	local Vehicle V;

	// End:0x55
	if(int(Pawn.Physics) != int(4))
	{
		Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	}
	V = Vehicle(Pawn);
	// End:0xEC
	if(V != none)
	{
		V.Steering = 0.0000000;
		V.Throttle = 0.0000000;
		V.Rise = 0.0000000;
	}
	//return;	
}

delegate bool CustomActionFunc(UTBot B)
{
	return true;
	//return ReturnValue;	
}

function PerformCustomAction(delegate<CustomActionFunc> ActionFunc)
{
	__CustomActionFunc__Delegate = ActionFunc;
	GotoState('CustomAction');
	//return;	
}

function UnderLift(LiftCenter M)
{
	local LiftExit Exit;

	bPreparingMove = false;
	PendingMover = none;
	// End:0xD4
	if((MoveTarget == none) || MoveTarget.IsA('LiftCenter'))
	{
		// End:0xD3
		foreach WorldInfo.AllNavigationPoints(Class'Engine.LiftExit', Exit)
		{
			// End:0xD2
			if((Exit.MyLiftCenter == M) && ActorReachable(Exit))
			{
				MoveTarget = Exit;				
				return;
			}			
		}		
	}
	//return;	
}

event bool HandlePathObstruction(Actor BlockedBy)
{
	local UTVehicle V, MyVehicle;
	local Pawn P;
	local Weapon Weap;

	MyVehicle = UTVehicle(Pawn);
	// End:0xAE
	if(MyVehicle != none)
	{
		// End:0x70
		if(MyVehicle.bShouldLeaveForCombat)
		{
			MyVehicle.DriverLeave(false);			
		}
		else
		{
			// End:0xAE
			if(MyVehicle.bKeyVehicle && Vehicle(BlockedBy) != none)
			{
				return true;
			}
		}
	}
	// End:0x29E
	if(Pawn.IsA('Vehicle')!)
	{
		V = UTVehicle(BlockedBy);
		// End:0x29E
		if(((V != none) && Squad != none) && UTSquadAI(Squad).VehicleDesireability(V, self) > 0.0000000)
		{
			GoalString = ((string(V) @ "is blocking path to") @ string(MoveTarget)) @ "- enter it";
			// End:0x1BE
			if(Focus == MoveTarget)
			{
				Focus = V;
			}
			MoveTarget = V;
			RouteGoal = V;
			// End:0x29C
			if(VSize(Pawn.Location - V.Location) < ((Pawn.GetCollisionRadius() + V.GetCollisionRadius()) + Pawn.VehicleCheckRadius))
			{
				EnterVehicle(V);
			}
			return true;
		}
	}
	P = Pawn(BlockedBy);
	// End:0x4DD
	if((P != none) && WorldInfo.GRI.OnSameTeam(self, P)!)
	{
		GoalString = ((string(P) @ "is blocking path to") @ string(MoveTarget)) @ " - kill it";
		Focus = P;
		Enemy = P;
		MoveTarget = P;
		SwitchToBestWeapon();
		Weap = (((Pawn.InvManager != none) && Pawn.InvManager.PendingWeapon != none) ? Pawn.InvManager.PendingWeapon : Pawn.Weapon);
		// End:0x4DD
		if((Weap != none) && Weap.CanAttack(P))
		{
			LastCanAttackCheckTime = WorldInfo.TimeSeconds;
			FireWeaponAt(P);
			MoveTimer = 1.0000000;
			return true;
		}
	}
	return ((Squad != none) ? UTSquadAI(Squad).HandlePathObstruction(self, BlockedBy) : false);
	//return ReturnValue;	
}

state Defending
{
	ignores Restart, EnemyNotVisible;

	function bool IsDefending()
	{
		return true;
		//return ReturnValue;		
	}

	function EnableBumps()
	{
		Enable('NotifyBump');
		//return;		
	}

	event MonitoredPawnAlert()
	{
		WhatToDoNext();
		//return;		
	}

	function ClearPathFor(Controller C)
	{
		MoveAwayFrom(C);
		//return;		
	}

	function MoveAwayFrom(Controller C)
	{
		local int I;
		local NavigationPoint Best, CurrentPosition;
		local float BestDot, CurrentDot;
		local Vector BlockedDir;

		Pawn.bWantsToCrouch = false;
		// End:0x35
		if(InLatentExecution(503))
		{
			return;
		}
		// End:0xC6
		if((Pawn.Anchor != none) && Pawn.ReachedDestination(Pawn.Anchor))
		{
			CurrentPosition = Pawn.Anchor;			
		}
		else
		{
			// End:0xEB
			if(DefensePoint != none)
			{
				CurrentPosition = DefensePoint;				
			}
			else
			{
				CurrentPosition = DefensivePosition;
			}
		}
		// End:0x361
		if((CurrentPosition != none) && Pawn.ReachedDestination(CurrentPosition))
		{
			BlockedDir = Normal(C.Pawn.Acceleration);
			// End:0x196
			if(BlockedDir == vect(0.0000000, 0.0000000, 0.0000000))
			{
				return;
			}
			I = 0;
			J0x1A1:

			// End:0x337 [Loop If]
			if(I < CurrentPosition.PathList.Length)
			{
				// End:0x329
				if(CurrentPosition.PathList[I].IsBlockedFor(Pawn)!)
				{
					CurrentDot = Abs(Normal(CurrentPosition.PathList[I].GetEnd().Location - Pawn.Location) Dot BlockedDir);
					// End:0x329
					if((Best == none) || CurrentDot < BestDot)
					{
						Best = CurrentPosition.PathList[I].GetEnd();
						BestDot = CurrentDot;
					}
				}
				I++;
				// [Loop Continue]
				goto J0x1A1;
			}
			// End:0x34B
			if(Best == none)
			{
				return;				
			}
			else
			{
				MoveTarget = Best;
			}			
		}
		else
		{
			RouteGoal = none;
			SetRouteGoal();
		}
		GotoState('Defending', 'Moving');
		//return;		
	}

	function SuggestDefenseRotation()
	{
		local int I;
		local Vector CenterDir;
		local Actor FormationCenter;
		local NavigationPoint DefenseAnchor;

		// End:0x7B
		if((UTHoldSpot(DefensivePosition) != none) && UTHoldSpot(DefensivePosition).LastAnchor != none)
		{
			DefenseAnchor = UTHoldSpot(DefensivePosition).LastAnchor;			
		}
		else
		{
			DefenseAnchor = DefensivePosition;
		}
		// End:0x37A
		if(DefenseAnchor.PathList.Length > 0)
		{
			Focus = none;
			FormationCenter = UTSquadAI(Squad).FormationCenter(self);
			// End:0x32B
			if(FormationCenter != none)
			{
				CenterDir = Normal(FormationCenter.Location - Pawn.Location);
				I = 0;
				J0x155:

				// End:0x32B [Loop If]
				if(I < DefenseAnchor.PathList.Length)
				{
					// End:0x31D
					if((DefenseAnchor.PathList[I].GetEnd() != none) && (CenterDir Dot Normal(DefenseAnchor.PathList[I].GetEnd().Location - Pawn.Location)) <= 0.0000000)
					{
						// End:0x31D
						if(((Rand(DefenseAnchor.PathList.Length) == 0) && float(DefenseAnchor.PathList[I].Distance) > 200.0000000) || Focus == none)
						{
							Focus = DefenseAnchor.PathList[I].GetEnd();
						}
					}
					I++;
					// [Loop Continue]
					goto J0x155;
				}
			}
			// End:0x37A
			if(Focus == none)
			{
				Focus = DefenseAnchor.PathList[0].GetEnd();
			}
		}
		//return;		
	}

	function SetRouteGoal()
	{
		local Actor NextMoveTarget;
		local bool bCanDetour;
		local UTSquadAI UTSquad;

		UTSquad = UTSquadAI(Squad);
		// End:0x1B1
		if((DefensePoint == none) || UTPlayerReplicationInfo(PlayerReplicationInfo).bHasFlag)
		{
			// End:0x135
			if((((((WorldInfo.TimeSeconds - FMax(LastSeenTime, AcquireTime)) < 5.0000000) || FRand() < 0.8500000) && DefensivePosition != none) && Pawn.ReachedDestination(DefensivePosition)) && UTSquad.AcceptableDefensivePosition(DefensivePosition, self))
			{
				CampTime = 3.0000000;
				GotoState('Defending', 'Pausing');
			}
			DefensivePosition = UTSquad.FindDefensivePositionFor(self);
			// End:0x19B
			if(DefensivePosition == none)
			{
				RouteGoal = UTSquad.FormationCenter(self);				
			}
			else
			{
				RouteGoal = DefensivePosition;
			}			
		}
		else
		{
			RouteGoal = DefensePoint;
		}
		// End:0x331
		if(RouteGoal != none)
		{
			bCanDetour = (Vehicle(Pawn) == none) || UTVehicle_Hoverboard(Pawn) != none;
			// End:0x232
			if(ActorReachable(RouteGoal))
			{
				NextMoveTarget = RouteGoal;				
			}
			else
			{
				NextMoveTarget = FindPathToward(RouteGoal, bCanDetour);
			}
			// End:0x331
			if(NextMoveTarget == none)
			{
				// End:0x296
				if((DefensePoint != none) && UTHoldSpot(DefensePoint) == none)
				{
					FreePoint();
				}
				DefensivePosition = UTSquad.FindDefensivePositionFor(self);
				// End:0x2FC
				if(DefensivePosition == none)
				{
					RouteGoal = UTSquad.FormationCenter(self);					
				}
				else
				{
					RouteGoal = DefensivePosition;
				}
				NextMoveTarget = FindPathToward(RouteGoal, bCanDetour);
			}
		}
		// End:0x365
		if(NextMoveTarget == none)
		{
			CampTime = 3.0000000;
			GotoState('Defending', 'Pausing');
		}
		Focus = NextMoveTarget;
		MoveTarget = NextMoveTarget;
		//return;		
	}

	function EndState(name NextStateName)
	{
		MonitoredPawn = none;
		SetCombatTimer();
		bShortCamp = false;
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		local UTSquadAI UTSquad;

		UTSquad = UTSquadAI(Squad);
		Pawn.bWantsToCrouch = false;
		// End:0x100
		if((Vehicle(Pawn) != none) && Pawn.GetVehicleBase() != none)
		{
			// End:0xFD
			if(Pawn.GetVehicleBase().Controller != none)
			{
				StartMonitoring(Pawn.GetVehicleBase(), UTSquad.FormationSize);
			}			
		}
		else
		{
			// End:0x217
			if(((UTSquad.SquadLeader != self) && UTSquad.SquadLeader.Pawn != none) && UTSquad.FormationCenter(self) == UTSquad.SquadLeader.Pawn)
			{
				StartMonitoring(UTSquad.SquadLeader.Pawn, UTSquad.FormationSize);				
			}
			else
			{
				MonitoredPawn = none;
			}
		}
		//return;		
	}
Begin:

	WaitForLanding();
	CampTime = ((bShortCamp) ? 0.3000000 : 3.0000000);
	bShortCamp = false;
	// End:0x5F
	if(Pawn.bStationary)
	{
		goto 'Pausing';
	}
	SetRouteGoal();
	// End:0xA1
	if(Pawn.ReachedDestination(RouteGoal))
	{
		goto 'Pausing';		
	}
	else
	{
Moving:


		Pawn.bWantsToCrouch = false;
		MoveToward(MoveTarget);
		// End:0x107
		if(Pawn.ReachedDestination(RouteGoal))
		{
			ShouldDefendPosition();
		}
	}
	LatentWhatToDoNext();
Pausing:


	// End:0x17F
	if((UTVehicle(Pawn) != none) && UTVehicle(Pawn).bShouldLeaveForCombat)
	{
		UTVehicle(Pawn).DriverLeave(false);
	}
	StopMovement();
	Pawn.bWantsToCrouch = (IsSniping()) && WorldInfo.bUseConsoleInput!;
	// End:0x273
	if(DefensePoint != none)
	{
		// End:0x270
		if(Pawn.ReachedDestination(DefensePoint))
		{
			Focus = none;
			SetFocalPoint(Pawn.Location + (Vector(DefensePoint.Rotation) * 1000.0000000));
		}		
	}
	else
	{
		// End:0x2B9
		if((DefensivePosition != none) && Pawn.ReachedDestination(DefensivePosition))
		{
			SuggestDefenseRotation();
		}
	}
	SwitchToBestWeapon();
	Sleep(0.5000000);
	// End:0x35B
	if((UTWeapon(Pawn.Weapon) != none) && UTWeapon(Pawn.Weapon).ShouldFireWithoutTarget())
	{
		Pawn.BotFire(false);
	}
	Sleep(FMax(0.1000000, CampTime - 0.5000000));
	LatentWhatToDoNext();
	stop;					
}

state Startled
{
	ignores HearNoise, SeePlayer, EnemyNotVisible;

	function Startle(Actor Feared)
	{
		GoalString = "STARTLED!";
		StartleActor = Feared;
		BeginState(GetStateName());
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		Pawn.Acceleration = Pawn.Location - StartleActor.Location;
		Pawn.Acceleration.Z = 0.0000000;
		Pawn.bIsWalking = false;
		Pawn.bWantsToCrouch = false;
		// End:0x127
		if(Pawn.Acceleration == vect(0.0000000, 0.0000000, 0.0000000))
		{
			Pawn.Acceleration = VRand();
		}
		Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
		//return;		
	}
Begin:

	Sleep(0.5000000);
	LatentWhatToDoNext();
	goto 'Begin';
	stop;				
}

state MoveToGoal
{
	function bool CheckPathToGoalAround(Pawn P)
	{
		local UTBot PBot;
		local UTSquadAI PSquad;

		PBot = UTBot(P.Controller);
		// End:0xAD
		if(((MoveTarget == none) || PBot == none) || WorldInfo.GRI.OnSameTeam(self, P.Controller)!)
		{
			return false;
		}
		PSquad = UTSquadAI(PBot.Squad);
		return (PSquad != none) && PSquad.ClearPathFor(self);
		//return ReturnValue;		
	}

	function Timer()
	{
		SetCombatTimer();
		//return;		
	}

	function EnableBumps()
	{
		Enable('NotifyBump');
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		Pawn.bWantsToCrouch = false;
		//return;		
	}
	stop;	
}

state MoveToGoalNoEnemy extends MoveToGoal
{	stop;	
}

state MoveToGoalWithEnemy extends MoveToGoal
{
	function Timer()
	{
		TimedFireWeaponAtEnemy();
		//return;		
	}
	stop;	
}

state Roaming extends MoveToGoal
{
	ignores EnemyNotVisible;

	function MayFall(bool bFloor, Vector FloorNormal)
	{
		Pawn.bCanJump = (MoveTarget != none) && (int(MoveTarget.Physics) != int(2)) || MoveTarget.IsA('DroppedPickup')!;
		//return;		
	}
Begin:

	SwitchToBestWeapon();
	WaitForLanding();
	// End:0x13E
	if((((Pawn.bCanPickupInventory && UTPickupFactory(MoveTarget) != none) && int(UTSquadAI(Squad).PriorityObjective(self)) == int(0)) && Vehicle(Pawn) == none) && UTPickupFactory(MoveTarget).ShouldCamp(self, 5.0000000))
	{
		CampTime = MoveTarget.LatentFloat;
		GoalString = "Short wait for inventory " $ string(MoveTarget);
		GotoState('Defending', 'Pausing');
	}
	MoveToward(MoveTarget, FaceActor(1.0000000), GetDesiredOffset(), ShouldStrafeTo(MoveTarget));
DoneRoaming:


	WaitForLanding();
	LatentWhatToDoNext();
	GoalString = "STUCK IN ROAMING";
	// End:0x1CB
	if(bSoaking)
	{
		SoakStop("STUCK IN ROAMING!");
	}
	stop;					
}

state Fallback extends MoveToGoalWithEnemy
{
	function bool FireWeaponAt(Actor A)
	{
		// End:0x14F
		if((((((A == Enemy) && Pawn.Weapon != none) && Pawn.Weapon.AIRating < 0.5000000) && (WorldInfo.TimeSeconds - Pawn.SpawnTime) < UTDeathmatch(WorldInfo.Game).SpawnProtectionTime) && int(UTSquadAI(Squad).PriorityObjective(self)) == int(0)) && PickupFactory(RouteGoal) != none)
		{
			return false;
		}
		return global.FireWeaponAt(A);
		//return ReturnValue;		
	}

	function bool IsRetreating()
	{
		return (Pawn.Acceleration Dot (Pawn.Location - Enemy.Location)) > float(0);
		//return ReturnValue;		
	}

	event bool NotifyBump(Actor Other, Vector HitNormal)
	{
		local Pawn P;
		local UTVehicle V;

		// End:0x13B
		if((Vehicle(Other) != none) && Vehicle(Pawn) == none)
		{
			// End:0x13B
			if((Other == RouteGoal) || (Vehicle(RouteGoal) != none) && Other == Vehicle(RouteGoal).GetVehicleBase())
			{
				V = UTVehicle(RouteGoal);
				// End:0x139
				if(V != none)
				{
					V.TryToDrive(Pawn);
					// End:0x139
					if(Vehicle(Pawn) != none)
					{
						UTSquadAI(Squad).BotEnteredVehicle(self);
						WhatToDoNext();
					}
				}
				return true;
			}
		}
		Disable('NotifyBump');
		SetTimer(1.0000000, false, 'EnableBumps');
		// End:0x1CA
		if(MoveTarget == Other)
		{
			// End:0x1C8
			if((MoveTarget == Enemy) && Pawn.HasRangedAttack())
			{
				TimedFireWeaponAtEnemy();
				DoRangedAttackOn(Enemy);
			}
			return false;
		}
		P = Pawn(Other);
		// End:0x21D
		if((P == none) || P.Controller == none)
		{
			return false;
		}
		// End:0x387
		if(((((RouteCache.Length > 0) && WorldInfo.GRI.OnSameTeam(self, P.Controller)!) && MoveTarget == RouteCache[0]) && RouteCache.Length > 1) && P.ReachedDestination(MoveTarget))
		{
			MoveTimer = (VSize(RouteCache[1].Location - Pawn.Location) / (Pawn.GroundSpeed * Pawn.DesiredSpeed)) + float(1);
			MoveTarget = RouteCache[1];
		}
		UTSquadAI(Squad).SetEnemy(self, P);
		// End:0x3ED
		if(Enemy == Other)
		{
			Focus = Enemy;
			TimedFireWeaponAtEnemy();
		}
		// End:0x405
		if(CheckPathToGoalAround(P))
		{
			return false;
		}
		AdjustAround(P);
		return false;
		//return ReturnValue;		
	}

	function MayFall(bool bFloor, Vector FloorNormal)
	{
		Pawn.bCanJump = (MoveTarget != none) && (int(MoveTarget.Physics) != int(2)) || MoveTarget.IsA('DroppedPickup')!;
		//return;		
	}

	function EnemyNotVisible()
	{
		// End:0x4B
		if(UTSquadAI(Squad).FindNewEnemyFor(self, false) || Enemy == none)
		{
			WhatToDoNext();			
		}
		else
		{
			Enable('SeePlayer');
			Disable('EnemyNotVisible');
		}
		//return;		
	}

	function EnemyChanged(bool bNewEnemyVisible)
	{
		bEnemyAcquired = false;
		SetEnemyInfo(bNewEnemyVisible);
		// End:0x43
		if(bNewEnemyVisible)
		{
			Disable('SeePlayer');
			Enable('EnemyNotVisible');
		}
		//return;		
	}
Begin:

	WaitForLanding();
Moving:


	MoveToward(MoveTarget, FaceActor(1.0000000), GetDesiredOffset(), ShouldStrafeTo(MoveTarget));
	LatentWhatToDoNext();
	// End:0x72
	if(bSoaking)
	{
		SoakStop("STUCK IN FALLBACK!");
	}
	GoalString = GoalString $ " STUCK IN FALLBACK!";
	stop;				
}

state Retreating extends Fallback
{
	function bool IsRetreating()
	{
		return true;
		//return ReturnValue;		
	}

	function Actor FaceActor(float StrafingModifier)
	{
		return global.FaceActor((((Skill + StrafingAbility) >= 5.0000000) ? FMin(WorldInfo.TimeSeconds - RetreatStartTime, 2.0000000) : 2.0000000));
		//return ReturnValue;		
	}

	function BeginState(name PreviousStateName)
	{
		Pawn.bWantsToCrouch = false;
		RetreatStartTime = WorldInfo.TimeSeconds;
		//return;		
	}
	stop;	
}

state Charging extends MoveToGoalWithEnemy
{
	ignores HearNoise, SeePlayer;

	function MayFall(bool bFloor, Vector FloorNormal)
	{
		// End:0x19
		if(MoveTarget != Enemy)
		{
			return;
		}
		Pawn.bCanJump = ActorReachable(Enemy);
		// End:0x78
		if(Pawn.bCanJump!)
		{
			MoveTimer = -1.0000000;
		}
		//return;		
	}

	function bool TryToDuck(Vector duckDir, bool bReversed)
	{
		// End:0x26
		if(Pawn.bCanStrafe!)
		{
			return false;
		}
		// End:0x50
		if(FRand() < 0.6000000)
		{
			return global.TryToDuck(duckDir, bReversed);
		}
		// End:0x7B
		if(MoveTarget == Enemy)
		{
			return TryStrafe(duckDir);
		}
		return false;
		//return ReturnValue;		
	}

	function bool StrafeFromDamage(float Damage, Class<DamageType> DamageType, bool bFindDest)
	{
		local Vector SideDir;

		// End:0x57
		if((Enemy == none) || (FRand() * Damage) < ((0.1500000 * CombatStyle) * float(Pawn.Health)))
		{
			return false;
		}
		// End:0x68
		if(bFindDest!)
		{
			return true;
		}
		SideDir = Normal(Normal(Enemy.Location - Pawn.Location) Cross vect(0.0000000, 0.0000000, 1.0000000));
		// End:0x106
		if((Pawn.Velocity Dot SideDir) > float(0))
		{
			SideDir *= float(-1);
		}
		return TryStrafe(SideDir);
		//return ReturnValue;		
	}

	function bool TryStrafe(Vector SideDir)
	{
		local Vector Extent, HitLocation, HitNormal;
		local Actor HitActor;

		Extent = Pawn.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
		Extent.Z = Pawn.GetCollisionHeight();
		HitActor = Trace(HitLocation, HitNormal, Pawn.Location + (float(200) * SideDir), Pawn.Location, false, Extent);
		// End:0x185
		if(HitActor != none)
		{
			SideDir *= float(-1);
			HitActor = Trace(HitLocation, HitNormal, Pawn.Location + (float(200) * SideDir), Pawn.Location, false, Extent);
		}
		// End:0x196
		if(HitActor != none)
		{
			return false;
		}
		// End:0x288
		if(int(Pawn.Physics) == int(1))
		{
			HitActor = Trace(HitLocation, HitNormal, (Pawn.Location + (float(200) * SideDir)) - (Pawn.MaxStepHeight * vect(0.0000000, 0.0000000, 1.0000000)), Pawn.Location + (float(200) * SideDir), false, Extent);
			// End:0x288
			if(HitActor == none)
			{
				return false;
			}
		}
		SetDestinationPosition(Pawn.Location + (float(2 * 200) * SideDir));
		GotoState('TacticalMove', 'DoStrafeMove');
		return true;
		//return ReturnValue;		
	}

	function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
	{
		local float pick;
		local Vector SideDir;
		local bool bWasOnGround;

		global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
		LastUnderFire = WorldInfo.TimeSeconds;
		bWasOnGround = int(Pawn.Physics) == int(1);
		// End:0xB6
		if(Pawn.Health <= 0)
		{
			return;
		}
		// End:0xDD
		if(StrafeFromDamage(float(Damage), DamageType, true))
		{
			return;			
		}
		else
		{
			// End:0x254
			if((bWasOnGround && MoveTarget == Enemy) && int(Pawn.Physics) == int(2))
			{
				pick = 1.0000000;
				// End:0x159
				if(bStrafeDir)
				{
					pick = -1.0000000;
				}
				SideDir = Normal(Normal(Enemy.Location - Pawn.Location) Cross vect(0.0000000, 0.0000000, 1.0000000));
				SideDir.Z = 0.0000000;
				Pawn.Velocity += (((pick * Pawn.GroundSpeed) * 0.7000000) * SideDir);
				// End:0x254
				if(FRand() < 0.2000000)
				{
					bStrafeDir = bStrafeDir!;
				}
			}
		}
		//return;		
	}

	event bool NotifyBump(Actor Other, Vector HitNormal)
	{
		// End:0xAD
		if((((Other == Enemy) && Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon!) && FRand() > (0.4000000 + (0.1000000 * Skill)))
		{
			DoRangedAttackOn(Enemy);
			return false;
		}
		return global.NotifyBump(Other, HitNormal);
		//return ReturnValue;		
	}

	function Timer()
	{
		Focus = Enemy;
		TimedFireWeaponAtEnemy();
		//return;		
	}

	function EnemyNotVisible()
	{
		WhatToDoNext();
		//return;		
	}

	function EndState(name NextStateName)
	{
		// End:0x58
		if((Pawn != none) && Pawn.JumpZ > float(0))
		{
			Pawn.bCanJump = true;
		}
		//return;		
	}
Begin:

	// End:0x69
	if(int(Pawn.Physics) == int(2))
	{
		Focus = Enemy;
		SetDestinationPosition(Enemy.Location);
		WaitForLanding();
	}
	// End:0x82
	if(Enemy == none)
	{
		LatentWhatToDoNext();
	}
	// End:0xA6
	if(FindBestPathToward(Enemy, false, true)!)
	{
		DoTacticalMove();
	}
Moving:


	// End:0xF0
	if(Pawn.Weapon.bMeleeWeapon)
	{
		FireWeaponAt(Enemy);
	}
	MoveToward(MoveTarget, FaceActor(1.0000000),, ShouldStrafeTo(MoveTarget));
	LatentWhatToDoNext();
	// End:0x155
	if(bSoaking)
	{
		SoakStop("STUCK IN CHARGING!");
	}
	stop;			
}

state VehicleCharging extends MoveToGoalWithEnemy
{
	ignores HearNoise, SeePlayer;

	function Timer()
	{
		Focus = Enemy;
		TimedFireWeaponAtEnemy();
		//return;		
	}

	function FindDestination()
	{
		local Actor HitActor;
		local Vector HitLocation, HitNormal, Cross;

		// End:0x3A
		if(MoveTarget == none)
		{
			SetDestinationPosition(Pawn.Location);
			return;
		}
		SetDestinationPosition(Pawn.Location + (float(5000) * Normal(Pawn.Location - MoveTarget.Location)));
		HitActor = Trace(HitLocation, HitNormal, GetDestinationPosition(), Pawn.Location, false);
		// End:0x10A
		if(HitActor == none)
		{
			return;
		}
		Cross = Normal((GetDestinationPosition() - Pawn.Location) Cross vect(0.0000000, 0.0000000, 1.0000000));
		SetDestinationPosition(GetDestinationPosition() + (float(1000) * Cross));
		HitActor = Trace(HitLocation, HitNormal, GetDestinationPosition(), Pawn.Location, false);
		// End:0x1D4
		if(HitActor == none)
		{
			return;
		}
		SetDestinationPosition(GetDestinationPosition() - (float(2000) * Cross));
		HitActor = Trace(HitLocation, HitNormal, GetDestinationPosition(), Pawn.Location, false);
		// End:0x259
		if(HitActor == none)
		{
			return;
		}
		SetDestinationPosition((GetDestinationPosition() + (float(1000) * Cross)) - (float(3000) * Normal(Pawn.Location - MoveTarget.Location)));
		//return;		
	}

	function EnemyNotVisible()
	{
		WhatToDoNext();
		//return;		
	}
Begin:

	// End:0x69
	if(int(Pawn.Physics) == int(2))
	{
		Focus = Enemy;
		SetDestinationPosition(Enemy.Location);
		WaitForLanding();
	}
	// End:0x82
	if(Enemy == none)
	{
		LatentWhatToDoNext();
	}
	// End:0x140
	if(int(Pawn.Physics) == int(4))
	{
		// End:0x12A
		if(VSize(Enemy.Location - Pawn.Location) < float(1200))
		{
			FindDestination();
			MoveTo(GetDestinationPosition(), none,, false);
			// End:0x12A
			if(Enemy == none)
			{
				LatentWhatToDoNext();
			}
		}
		MoveTarget = Enemy;		
	}
	else
	{
		// End:0x197
		if(FindBestPathToward(Enemy, false, true)!)
		{
			// End:0x18D
			if(Pawn.HasRangedAttack())
			{
				GotoState('RangedAttack');				
			}
			else
			{
				WanderOrCamp();
			}
		}
	}
	J0x197:

	FireWeaponAt(Enemy);
	MoveToward(MoveTarget, FaceActor(1.0000000),, ShouldStrafeTo(MoveTarget));
	LatentWhatToDoNext();
	// End:0x216
	if(bSoaking)
	{
		SoakStop("STUCK IN VEHICLECHARGING!");
	}
	stop;		
}

state TacticalMove
{
	ignores HearNoise, SeePlayer;

	function bool IsStrafing()
	{
		return true;
		//return ReturnValue;		
	}

	function SetFall()
	{
		Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		SetDestinationPosition(Pawn.Location);
		global.SetFall();
		//return;		
	}

	function bool NotifyHitWall(Vector HitNormal, Actor Wall)
	{
		local UTVehicle V;

		// End:0x13D
		if((Vehicle(Wall) != none) && Vehicle(Pawn) == none)
		{
			// End:0x13B
			if((Wall == RouteGoal) || (Vehicle(RouteGoal) != none) && Wall == Vehicle(RouteGoal).GetVehicleBase())
			{
				V = UTVehicle(Wall);
				// End:0x139
				if(V != none)
				{
					V.TryToDrive(Pawn);
					// End:0x139
					if(Vehicle(Pawn) != none)
					{
						UTSquadAI(Squad).BotEnteredVehicle(self);
						WhatToDoNext();
					}
				}
				return true;
			}
			return false;
		}
		// End:0x184
		if(int(Pawn.Physics) == int(2))
		{
			NotifyFallingHitWall(HitNormal, Wall);
			return false;
		}
		// End:0x19F
		if(Enemy == none)
		{
			WhatToDoNext();
			return false;
		}
		// End:0x22D
		if((bChangeDir || FRand() < 0.5000000) || ((Enemy.Location - Pawn.Location) Dot HitNormal) < float(0))
		{
			Focus = Enemy;
			WhatToDoNext();			
		}
		else
		{
			bChangeDir = true;
			SetDestinationPosition(Pawn.Location - ((HitNormal * FRand()) * float(500)));
		}
		return true;
		//return ReturnValue;		
	}

	function Timer()
	{
		Focus = Enemy;
		// End:0x40
		if((Enemy != none) && bNotifyApex!)
		{
			TimedFireWeaponAtEnemy();			
		}
		else
		{
			SetCombatTimer();
		}
		//return;		
	}

	function EnableBumps()
	{
		Enable('NotifyBump');
		//return;		
	}

	function EnemyNotVisible()
	{
		StopFiring();
		// End:0x41
		if((Pawn == none) || Pawn.Health <= 0)
		{
			return;
		}
		// End:0xB4
		if(Aggressiveness > (RelativeStrength(Enemy)))
		{
			// End:0xAA
			if(FastTrace(Enemy.Location, LastSeeingPos))
			{
				GotoState('TacticalMove', 'RecoverEnemy');				
			}
			else
			{
				WhatToDoNext();
			}
		}
		Disable('EnemyNotVisible');
		//return;		
	}

	function ChangeStrafe()
	{
		local Vector Dir, Dest;

		Dir = Vector(Pawn.Rotation);
		Dest = GetDestinationPosition();
		SetDestinationPosition(Dest + (float(2) * ((Pawn.Location - Dest) + (Dir * ((Dest - Pawn.Location) Dot Dir)))));
		//return;		
	}

	function PickDestination()
	{
		local Vector pickdir, enemyDir, enemyPart, Y, LookDir;

		local float strafeSize;
		local bool bFollowingPlayer;
		local Controller SquadLeader;

		// End:0x46
		if(Pawn == none)
		{
			WarnInternal(string(self) $ " Tactical move pick destination with no pawn");
			return;
		}
		bChangeDir = false;
		// End:0x126
		if((Pawn.PhysicsVolume.bWaterVolume && Pawn.bCanSwim!) && Pawn.bCanFly)
		{
			SetDestinationPosition((Pawn.Location + (float(75) * (VRand() + vect(0.0000000, 0.0000000, 1.0000000)))) + vect(0.0000000, 0.0000000, 100.0000000));
			return;
		}
		enemyDir = Normal(Enemy.Location - Pawn.Location);
		Y = enemyDir Cross vect(0.0000000, 0.0000000, 1.0000000);
		// End:0x202
		if(int(Pawn.Physics) == int(1))
		{
			Y.Z = 0.0000000;
			enemyDir.Z = 0.0000000;			
		}
		else
		{
			enemyDir.Z = FMax(0.0000000, enemyDir.Z);
		}
		SquadLeader = UTSquadAI(Squad).SquadLeader;
		bFollowingPlayer = ((PlayerController(SquadLeader) != none) && SquadLeader.Pawn != none) && VSize(Pawn.Location - SquadLeader.Pawn.Location) < float(1600);
		strafeSize = FClamp((((2.0000000 * Aggression) + float(1)) * FRand()) - 0.6500000, -0.7000000, 0.7000000);
		// End:0x3AB
		if(UTSquadAI(Squad).MustKeepEnemy(Enemy))
		{
			strafeSize = FMax((0.4000000 * FRand()) - 0.2000000, strafeSize);
		}
		enemyPart = enemyDir * strafeSize;
		strafeSize = FMax(0.0000000, 1.0000000 - Abs(strafeSize));
		pickdir = strafeSize * Y;
		// End:0x429
		if(bStrafeDir)
		{
			pickdir *= float(-1);
		}
		// End:0x589
		if(bFollowingPlayer)
		{
			LookDir = Vector(SquadLeader.Rotation);
			// End:0x589
			if((LookDir Dot ((Pawn.Location + ((enemyPart + pickdir) * float(200))) - SquadLeader.Pawn.Location)) > FMax(0.0000000, LookDir Dot ((Pawn.Location + ((enemyPart - pickdir) * float(200))) - SquadLeader.Pawn.Location)))
			{
				bStrafeDir = bStrafeDir!;
				pickdir *= float(-1);
			}
		}
		bStrafeDir = bStrafeDir!;
		// End:0x5C4
		if(EngageDirection(enemyPart + pickdir, false))
		{
			return;
		}
		// End:0x5E8
		if(EngageDirection(enemyPart - pickdir, false))
		{
			return;
		}
		bForcedDirection = true;
		StartTacticalTime = WorldInfo.TimeSeconds;
		EngageDirection(enemyPart + pickdir, true);
		//return;		
	}

	function bool EngageDirection(Vector StrafeDir, bool bForced)
	{
		local Actor HitActor;
		local Vector HitLocation, collspec, MinDest, HitNormal;
		local bool bWantJump;

		MinDest = Pawn.Location + (float(200) * StrafeDir);
		// End:0x70D
		if(bForced!)
		{
			collspec = Pawn.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
			collspec.Z = FMax(6.0000000, Pawn.GetCollisionHeight() - Pawn.MaxStepHeight);
			bWantJump = ((((Vehicle(Pawn) == none) && int(Pawn.Physics) == int(1)) && (FRand() < ((0.0500000 * Skill) + (0.6000000 * Jumpiness))) || UTWeapon(Pawn.Weapon).SplashJump() && ProficientWithWeapon()) && (Enemy.Location.Z - Enemy.GetCollisionHeight()) <= ((Pawn.Location.Z + Pawn.MaxStepHeight) - Pawn.GetCollisionHeight())) && Pawn.NeedToTurn(((Enemy == Focus) ? GetFocalPoint() : Enemy.Location))!;
			HitActor = Trace(HitLocation, HitNormal, MinDest, Pawn.Location, false, collspec);
			// End:0x350
			if((HitActor != none) && bWantJump!)
			{
				return false;
			}
			// End:0x49B
			if(int(Pawn.Physics) == int(1))
			{
				collspec.X = FMin(14.0000000, 0.5000000 * Pawn.GetCollisionRadius());
				collspec.Y = collspec.X;
				HitActor = Trace(HitLocation, HitNormal, MinDest - ((float(3) * Pawn.MaxStepHeight) * vect(0.0000000, 0.0000000, 1.0000000)), MinDest, false, collspec);
				// End:0x49B
				if(HitActor == none)
				{
					HitNormal = float(-1) * StrafeDir;
					return false;
				}
			}
			// End:0x70D
			if(bWantJump)
			{
				// End:0x558
				if((UTWeapon(Pawn.Weapon) != none) && UTWeapon(Pawn.Weapon).SplashJump())
				{
					StopFiring();
					// End:0x558
					if((Pawn == none) || Pawn.Health <= 0)
					{
						return false;
					}
				}
				bNotifyApex = true;
				bTacticalDoubleJump = true;
				bPlannedJump = true;
				DodgeLandZ = Pawn.Location.Z;
				bInDodgeMove = true;
				Pawn.SetPhysics(2);
				Pawn.SuggestJumpVelocity(Pawn.Velocity, MinDest, Pawn.Location);
				Pawn.Velocity.Z = Pawn.JumpZ;
				Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
				// End:0x6F7
				if((Skill + (float(2) * Jumpiness)) > (float(3) + (float(3) * FRand())))
				{
					bNotifyFallingHitWall = true;
				}
				SetDestinationPosition(MinDest);
				return true;
			}
		}
		SetDestinationPosition(MinDest + (StrafeDir * ((0.5000000 * float(200)) + FMin(VSize(Enemy.Location - Pawn.Location), 200.0000000 * (FRand() + FRand())))));
		return true;
		//return ReturnValue;		
	}

	event NotifyJumpApex()
	{
		// End:0x71
		if(((bTacticalDoubleJump && bPendingDoubleJump!) && FRand() < 0.4000000) && Skill > (float(2) + (float(5) * FRand())))
		{
			bTacticalDoubleJump = false;
			bNotifyApex = true;
			bPendingDoubleJump = true;			
		}
		else
		{
			// End:0xCE
			if(Pawn.CanAttack(Enemy))
			{
				LastCanAttackCheckTime = WorldInfo.TimeSeconds;
				TimedFireWeaponAtEnemy();
			}
		}
		global.NotifyJumpApex();
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		bForcedDirection = false;
		// End:0x54
		if(Skill < float(4))
		{
			Pawn.MaxDesiredSpeed = 0.4000000 + (0.0800000 * Skill);
		}
		MinHitWall += 0.1500000;
		Pawn.bAvoidLedges = true;
		Pawn.bStopAtLedges = true;
		Pawn.bCanJump = false;
		bAdjustFromWalls = false;
		Pawn.bWantsToCrouch = false;
		//return;		
	}

	function EndState(name NextStateName)
	{
		// End:0x1B
		if(bPendingDoubleJump!)
		{
			bNotifyApex = false;
		}
		bAdjustFromWalls = true;
		// End:0x38
		if(Pawn == none)
		{
			return;
		}
		SetMaxDesiredSpeed();
		Pawn.bAvoidLedges = false;
		Pawn.bStopAtLedges = false;
		MinHitWall -= 0.1500000;
		// End:0xDB
		if(Pawn.JumpZ > float(0))
		{
			Pawn.bCanJump = true;
		}
		//return;		
	}
TacticalTick:

	Sleep(0.0200000);
Begin:


	// End:0x29
	if(Enemy == none)
	{
		Sleep(0.0100000);
		goto 'FinishedStrafe';
	}
	// End:0x92
	if(int(Pawn.Physics) == int(2))
	{
		Focus = Enemy;
		SetDestinationPosition(Enemy.Location);
		WaitForLanding();
	}
	// End:0xAB
	if(Enemy == none)
	{
		goto 'FinishedStrafe';
	}
	PickDestination();
DoMove:


	// End:0xDE
	if(FocusOnLeader(false))
	{
		MoveTo(GetDestinationPosition(), Focus);		
	}
	else
	{
		// End:0x11F
		if(Pawn.bCanStrafe!)
		{
			StopFiring();
			MoveTo(GetDestinationPosition());			
		}
		else
		{
DoStrafeMove:


			MoveTo(GetDestinationPosition(), Enemy);
		}
	}
	// End:0x211
	if(bForcedDirection && (WorldInfo.TimeSeconds - StartTacticalTime) < 0.2000000)
	{
		// End:0x1D1
		if(Pawn.HasRangedAttack()! || Skill > (float(2) + (float(3) * FRand())))
		{
			bMustCharge = true;
			LatentWhatToDoNext();
		}
		GoalString = "RangedAttack from failed tactical";
		DoRangedAttackOn(Enemy);
	}
	// End:0x2CF
	if((((Enemy == none) || LineOfSightTo(Enemy)) || FastTrace(Enemy.Location, LastSeeingPos)!) || (Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon)
	{
		goto 'FinishedStrafe';
	}
RecoverEnemy:


	GoalString = "Recover Enemy";
	HidingSpot = Pawn.Location;
	StopFiring();
	Sleep(0.1000000 + (0.2000000 * FRand()));
	SetDestinationPosition(LastSeeingPos + ((float(4) * Pawn.GetCollisionRadius()) * Normal(LastSeeingPos - Pawn.Location)));
	MoveTo(GetDestinationPosition(), Enemy);
	// End:0x535
	if(FireWeaponAt(Enemy))
	{
		Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		// End:0x46F
		if((Pawn.Weapon != none) && UTWeapon(Pawn.Weapon).GetDamageRadius() > float(0))
		{
			StopFiring();
			Sleep(0.0500000);			
		}
		else
		{
			Sleep((0.1000000 + (0.3000000 * FRand())) + (0.0600000 * (float(7) - FMin(7.0000000, Skill))));
		}
		// End:0x535
		if((FRand() + 0.3000000) > Aggression)
		{
			Enable('EnemyNotVisible');
			SetDestinationPosition(HidingSpot + ((float(4) * Pawn.GetCollisionRadius()) * Normal(HidingSpot - Pawn.Location)));
			goto 'DoMove';
		}
	}
FinishedStrafe:


	LatentWhatToDoNext();
	// End:0x56F
	if(bSoaking)
	{
		SoakStop("STUCK IN TACTICAL MOVE!");
	}
	stop;					
}

state Hunting extends MoveToGoalWithEnemy
{
	ignores EnemyNotVisible;

	function bool IsHunting()
	{
		return true;
		//return ReturnValue;		
	}

	function MayFall(bool bFloor, Vector FloorNormal)
	{
		Pawn.bCanJump = ((MoveTarget == none) || int(MoveTarget.Physics) != int(2)) || MoveTarget.IsA('DroppedPickup')!;
		//return;		
	}

	function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
	{
		LastUnderFire = WorldInfo.TimeSeconds;
		global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
		// End:0xA0
		if((Pawn.Health > 0) && Damage > 0)
		{
			bFrustrated = true;
		}
		//return;		
	}

	function SeePlayer(Pawn SeenPlayer)
	{
		// End:0x89
		if(SeenPlayer == Enemy)
		{
			VisibleEnemy = Enemy;
			EnemyVisibilityTime = WorldInfo.TimeSeconds;
			bEnemyIsVisible = true;
			BlockedPath = none;
			Focus = Enemy;
			WhatToDoNext();			
		}
		else
		{
			global.SeePlayer(SeenPlayer);
		}
		//return;		
	}

	function Timer()
	{
		SetCombatTimer();
		StopFiring();
		//return;		
	}

	function PickDestination()
	{
		local Vector nextSpot, ViewSpot, Dir;
		local float PosZ;
		local bool bCanSeeLastSeen;
		local int I;

		// End:0xA8
		if(((Enemy == none) || Enemy.Health <= 0) || Enemy.IsInvisible() && (WorldInfo.TimeSeconds - LastSeenTime) > Skill)
		{
			LoseEnemy();
			WhatToDoNext();
			return;
		}
		// End:0xEF
		if(Pawn.JumpZ > float(0))
		{
			Pawn.bCanJump = true;
		}
		// End:0x1D6
		if(ActorReachable(Enemy))
		{
			BlockedPath = none;
			// End:0x1A0
			if(((LostContact(5.0000000)) && ((Enemy.Location - Pawn.Location) Dot Vector(Pawn.Rotation)) < float(0)) && LoseEnemy())
			{
				WhatToDoNext();
				return;
			}
			SetDestinationPosition(Enemy.Location);
			MoveTarget = none;
			return;
		}
		ViewSpot = Pawn.Location + (Pawn.BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000));
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);
		// End:0x441
		if((BlockedPath != none) || UTSquadAI(Squad).BeDevious(Enemy))
		{
			// End:0x40E
			if(BlockedPath == none)
			{
				// End:0x38B
				if(FindPathToward(Enemy, false) != none)
				{
					I = 0;
					J0x2D2:

					// End:0x37C [Loop If]
					if(I < RouteCache.Length)
					{
						// End:0x309
						if(RouteCache[I] == none)
						{
							// [Explicit Break]
							goto J0x37C;							
						}
						else
						{
							// End:0x36E
							if(Enemy.Controller.LineOfSightTo(RouteCache[I]))
							{
								BlockedPath = RouteCache[I];
								// [Explicit Break]
								goto J0x37C;
							}
						}
						I++;
						// [Loop Continue]
						goto J0x2D2;
					}
					J0x37C:

					bForceRefreshRoute = true;					
				}
				else
				{
					// End:0x3C9
					if(CanStakeOut())
					{
						GoalString = "Stakeout from hunt";
						GotoState('StakeOut');
						return;						
					}
					else
					{
						// End:0x3E5
						if(LoseEnemy())
						{
							WhatToDoNext();
							return;							
						}
						else
						{
							GoalString = "Retreat from hunt";
							DoRetreat();
							return;
						}
					}
				}
			}
			// End:0x441
			if(BlockedPath != none)
			{
				BlockedPath.TransientCost = 5000;
			}
		}
		// End:0x479
		if(bDirectHunt!)
		{
			UTSquadAI(Squad).MarkHuntingSpots(self);
		}
		// End:0x493
		if(FindBestPathToward(Enemy, true, true))
		{
			return;
		}
		// End:0x4EB
		if(bSoaking && int(Physics) != int(2))
		{
			SoakStop("COULDN'T FIND PATH TO ENEMY " $ string(Enemy));
		}
		MoveTarget = none;
		// End:0x520
		if(bEnemyInfoValid! && LoseEnemy())
		{
			WhatToDoNext();
			return;
		}
		SetDestinationPosition(LastSeeingPos);
		bEnemyInfoValid = false;
		// End:0x5EA
		if(FastTrace(Enemy.Location, ViewSpot) && VSize(Pawn.Location - GetDestinationPosition()) > Pawn.CylinderComponent.CollisionRadius)
		{
			SeePlayer(Enemy);
			return;
		}
		PosZ = (LastSeenPos.Z + Pawn.GetCollisionHeight()) - Enemy.GetCollisionHeight();
		nextSpot = LastSeenPos - (Normal(Enemy.Velocity) * Pawn.CylinderComponent.CollisionRadius);
		nextSpot.Z = PosZ;
		// End:0x713
		if(FastTrace(nextSpot, ViewSpot))
		{
			SetDestinationPosition(nextSpot);			
		}
		else
		{
			// End:0x7EB
			if(bCanSeeLastSeen)
			{
				Dir = Pawn.Location - LastSeenPos;
				Dir.Z = 0.0000000;
				// End:0x7D4
				if(VSize(Dir) < Pawn.GetCollisionRadius())
				{
					GoalString = "Stakeout 3 from hunt";
					GotoState('StakeOut');
					return;
				}
				SetDestinationPosition(LastSeenPos);				
			}
			else
			{
				SetDestinationPosition(LastSeenPos);
				// End:0x90C
				if(FastTrace(LastSeenPos, ViewSpot)!)
				{
					// End:0x895
					if(PickWallAdjust(Normal(LastSeenPos - ViewSpot)) || FindViewSpot())
					{
						// End:0x87C
						if(int(Pawn.Physics) == int(2))
						{
							SetFall();							
						}
						else
						{
							GotoState('Hunting', 'AdjustFromWall');
						}						
					}
					else
					{
						// End:0x8DC
						if((int(Pawn.Physics) == int(4)) && LoseEnemy())
						{
							WhatToDoNext();
							return;							
						}
						else
						{
							GoalString = "Stakeout 2 from hunt";
							GotoState('StakeOut');
							return;
						}
					}
				}
			}
		}
		//return;		
	}

	function bool FindViewSpot()
	{
		local Vector X, Y, Z;
		local bool bAlwaysTry;

		// End:0x11
		if(Enemy == none)
		{
			return false;
		}
		GetAxes(Rotation, X, Y, Z);
		bAlwaysTry = bFrustrated;
		bFrustrated = false;
		// End:0x154
		if(FastTrace(Enemy.Location, Pawn.Location + ((float(2) * Y) * Pawn.CylinderComponent.CollisionRadius)))
		{
			SetDestinationPosition(Pawn.Location + ((2.5000000 * Y) * Pawn.CylinderComponent.CollisionRadius));
			return true;
		}
		// End:0x250
		if(FastTrace(Enemy.Location, Pawn.Location - ((float(2) * Y) * Pawn.CylinderComponent.CollisionRadius)))
		{
			SetDestinationPosition(Pawn.Location - ((2.5000000 * Y) * Pawn.CylinderComponent.CollisionRadius));
			return true;
		}
		// End:0x34E
		if(bAlwaysTry)
		{
			// End:0x2DC
			if(FRand() < 0.5000000)
			{
				SetDestinationPosition(Pawn.Location - ((2.5000000 * Y) * Pawn.CylinderComponent.CollisionRadius));				
			}
			else
			{
				SetDestinationPosition(Pawn.Location - ((2.5000000 * Y) * Pawn.CylinderComponent.CollisionRadius));
			}
			return true;
		}
		return false;
		//return ReturnValue;		
	}

	function BeginState(name PreviousStateName)
	{
		Pawn.bWantsToCrouch = false;
		//return;		
	}

	function EndState(name NextStateName)
	{
		bDirectHunt = false;
		// End:0x64
		if((Pawn != none) && Pawn.JumpZ > float(0))
		{
			Pawn.bCanJump = true;
		}
		//return;		
	}
AdjustFromWall:

	MoveTo(GetDestinationPosition(), MoveTarget);
Begin:


	WaitForLanding();
	// End:0x3E
	if(CanSee(Enemy))
	{
		SeePlayer(Enemy);
	}
	PickDestination();
SpecialNavig:


	// End:0x6A
	if(MoveTarget == none)
	{
		MoveTo(GetDestinationPosition());		
	}
	else
	{
		MoveToward(MoveTarget, FaceActor(10.0000000),, (FRand() < 0.7500000) && ShouldStrafeTo(MoveTarget));
	}
	LatentWhatToDoNext();
	// End:0xDC
	if(bSoaking)
	{
		SoakStop("STUCK IN HUNTING!");
	}
	stop;				
}

state StakeOut
{
	ignores EnemyNotVisible;

	function bool CanAttack(Actor Other)
	{
		return true;
		//return ReturnValue;		
	}

	function bool WeaponFireAgain(bool bFinishedFire)
	{
		LastFireAttempt = WorldInfo.TimeSeconds;
		bFireSuccess = false;
		// End:0xCF
		if(Pawn.NeedToTurn(GetFocalPoint())!)
		{
			bCanFire = true;
			bStoppedFiring = false;
			bFireSuccess = Pawn.BotFire(bFinishedFire);
			LastFireTarget = Focus;
			return bFireSuccess;			
		}
		else
		{
			bCanFire = false;
			StopFiring();
			return false;
		}
		//return ReturnValue;		
	}

	function bool Stopped()
	{
		return true;
		//return ReturnValue;		
	}

	event SeePlayer(Pawn SeenPlayer)
	{
		// End:0xAF
		if(SeenPlayer == Enemy)
		{
			VisibleEnemy = Enemy;
			EnemyVisibilityTime = WorldInfo.TimeSeconds;
			bEnemyIsVisible = true;
			// End:0xA2
			if(FocusOnLeader(false)! && FRand() < 0.5000000)
			{
				Focus = Enemy;
				FireWeaponAt(Focus);
			}
			WhatToDoNext();			
		}
		else
		{
			// End:0x14C
			if(UTSquadAI(Squad).SetEnemy(self, SeenPlayer))
			{
				// End:0x142
				if(Enemy == SeenPlayer)
				{
					VisibleEnemy = Enemy;
					EnemyVisibilityTime = WorldInfo.TimeSeconds;
					bEnemyIsVisible = true;
				}
				WhatToDoNext();
			}
		}
		//return;		
	}

	function DoStakeOut()
	{
		FocusOnLeader(false);
		// End:0xB5
		if((FRand() < 0.3000000) || FastTrace(GetFocalPoint() + (vect(0.0000000, 0.0000000, 0.9000000) * Enemy.GetCollisionHeight()), Pawn.Location + (vect(0.0000000, 0.0000000, 0.8000000) * Pawn.GetCollisionHeight()))!)
		{
			FindNewStakeOutDir();
		}
		GotoState('StakeOut', 'Begin');
		//return;		
	}

	function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
	{
		global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
		// End:0x10D
		if((Pawn.Health > 0) && Damage > 0)
		{
			bFrustrated = true;
			// End:0x103
			if(((InstigatedBy != none) && InstigatedBy.Pawn != none) && InstigatedBy.Pawn == Enemy)
			{
				AcquireTime = WorldInfo.TimeSeconds;
			}
			WhatToDoNext();
		}
		//return;		
	}

	function Timer()
	{
		SetCombatTimer();
		//return;		
	}

	function EnableBumps()
	{
		Enable('NotifyBump');
		//return;		
	}

	function Rotator GetAdjustedAimFor(Weapon InWeapon, Vector projStart)
	{
		local Vector FireSpot;
		local Actor HitActor;
		local Vector HitLocation, HitNormal;

		FireSpot = GetFocalPoint();
		HitActor = Trace(HitLocation, HitNormal, FireSpot, projStart, false);
		// End:0xD2
		if(HitActor != none)
		{
			// End:0xA2
			if(Enemy != none)
			{
				FireSpot += ((float(2) * Enemy.GetCollisionHeight()) * HitNormal);
			}
			// End:0xD2
			if(FastTrace(FireSpot, projStart)!)
			{
				FireSpot = GetFocalPoint();
			}
		}
		SetRotation(Rotator(FireSpot - projStart));
		return Rotation;
		//return ReturnValue;		
	}

	function FindNewStakeOutDir()
	{
		local NavigationPoint N, Best;
		local Vector Dir, enemyDir;
		local float Dist, BestVal, val;

		enemyDir = Normal(Enemy.Location - Pawn.Location);
		// End:0x223
		foreach WorldInfo.AllNavigationPoints(Class'Engine.NavigationPoint', N)
		{
			Dir = N.Location - Pawn.Location;
			Dist = VSize(Dir);
			// End:0x222
			if((Dist < float(2000)) && Dist > float(200))
			{
				val = (enemyDir Dot Dir) / Dist;
				// End:0x1D2
				if((WorldInfo.Game.bTeamGame && PlayerReplicationInfo.Team != none) && PlayerReplicationInfo.Team.Size > 1)
				{
					val += FRand();
				}
				// End:0x222
				if((val > BestVal) && LineOfSightTo(N))
				{
					BestVal = val;
					Best = N;
				}
			}			
		}		
		// End:0x293
		if(Best != none)
		{
			SetFocalPoint(Best.Location + ((0.5000000 * Pawn.GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)));
		}
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		StopStartTime = WorldInfo.TimeSeconds;
		StopMovement();
		Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		Pawn.bCanJump = false;
		FocusOnLeader(false);
		// End:0x139
		if(((bEnemyInfoValid! || VSize(GetFocalPoint() - Pawn.Location) < float(200)) || ((WorldInfo.TimeSeconds - LastSeenTime) > 6.0000000) && FRand() < 0.5000000) || ClearShot(GetFocalPoint(), false)!)
		{
			FindNewStakeOutDir();
		}
		//return;		
	}

	function EndState(name NextStateName)
	{
		// End:0x58
		if((Pawn != none) && Pawn.JumpZ > float(0))
		{
			Pawn.bCanJump = true;
		}
		//return;		
	}
Begin:

	Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	Focus = none;
	// End:0x58
	if(FocusOnLeader(false))
	{
		Focus = Focus;
	}
	CheckIfShouldCrouch(Pawn.Location, GetFocalPoint(), 1.0000000);
	FinishRotation();
	// End:0xB6
	if(FocusOnLeader(false))
	{
		FireWeaponAt(Focus);		
	}
	else
	{
		// End:0x16B
		if((((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon!) && UTSquadAI(Squad).ShouldSuppressEnemy(self)) && ClearShot(GetFocalPoint(), true))
		{
			WeaponFireAgain(false);			
		}
		else
		{
			// End:0x191
			if(Vehicle(Pawn) != none)
			{
				WeaponFireAgain(false);				
			}
			else
			{
				StopFiring();
			}
		}
	}
	Sleep(1.0000000 + FRand());
	// End:0x2D8
	if((Pawn.bIsCrouched && FastTrace(GetFocalPoint(), Pawn.Location + (Pawn.EyeHeight * vect(0.0000000, 0.0000000, 1.0000000)))!) && FastTrace(GetFocalPoint(), Pawn.Location + (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000))))
	{
		Pawn.bWantsToCrouch = false;
		Sleep(0.1500000 + ((0.0500000 * (float(1) + FRand())) * (float(10) - Skill)));
	}
	LatentWhatToDoNext();
	// End:0x30D
	if(bSoaking)
	{
		SoakStop("STUCK IN STAKEOUT!");
	}
	stop;			
}

state RangedAttack
{
	ignores Bump, HearNoise, SeePlayer;

	function bool Stopped()
	{
		return bPreparingMove || InLatentExecution(503)!;
		//return ReturnValue;		
	}

	function bool IsShootingObjective()
	{
		return (Focus != none) && Focus == Squad.SquadObjective;
		//return ReturnValue;		
	}

	function ClearPathFor(Controller C)
	{
		DoTacticalMove();
		//return;		
	}

	function StopFiring()
	{
		// End:0x59
		if(((Pawn != none) && Pawn.RecommendLongRangedAttack()) && Pawn.IsFiring())
		{
			return;
		}
		global.StopFiring();
		// End:0xEB
		if(bHasFired)
		{
			// End:0xD5
			if((IsSniping()) && WorldInfo.bUseConsoleInput!)
			{
				Pawn.bWantsToCrouch = Skill > float(2);				
			}
			else
			{
				bHasFired = false;
				WhatToDoNext();
			}
		}
		//return;		
	}

	function EnemyNotVisible()
	{
		// End:0x47
		if((Focus == Enemy) && Pawn.RecommendLongRangedAttack()!)
		{
			WhatToDoNext();
		}
		//return;		
	}

	singular function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> DamageType)
	{
		// End:0x32
		if((Focus == KilledPawn) && Killed != self)
		{
			WhatToDoNext();
		}
		global.NotifyKilled(Killer, Killed, KilledPawn, DamageType);
		//return;		
	}

	function Timer()
	{
		// End:0xB5
		if((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon)
		{
			SetCombatTimer();
			StopFiring();
			// End:0xA8
			if((Pawn == none) || Pawn.Health <= 0)
			{
				return;
			}
			WhatToDoNext();			
		}
		else
		{
			// End:0xD9
			if(Focus == Enemy)
			{
				TimedFireWeaponAtEnemy();				
			}
			else
			{
				FireWeaponAt(Focus);
			}
		}
		//return;		
	}

	function DoRangedAttackOn(Actor A)
	{
		// End:0x23
		if(FocusOnLeader(false)!)
		{
			Focus = A;
		}
		GotoState('RangedAttack', 'Begin');
		//return;		
	}

	function bool FindStrafeDest()
	{
		local float Dist, TargetDist, MaxRange;
		local int Start, I;
		local bool bAllowBackwards;
		local NavigationPoint Nav;
		local UTWeapon UTWeap;

		// End:0x77
		if((Pawn.bCanStrafe! || Pawn.Weapon == none) || (Skill + StrafingAbility) < (1.5000000 + (3.5000000 * FRand())))
		{
			return false;
		}
		UTWeap = UTWeapon(Pawn.Weapon);
		MaxRange = ((UTWeap != none) ? UTWeap.GetOptimalRangeFor(Focus) : Pawn.Weapon.MaxRange());
		// End:0x30D
		if(Pawn.ValidAnchor()!)
		{
			Pawn.SetAnchor(Pawn.GetBestAnchor(Pawn, Pawn.Location, true, true, Dist));
			// End:0x1DC
			if(Pawn.Anchor == none)
			{
				return false;				
			}
			else
			{
				// End:0x30A
				if(Dist > Pawn.CylinderComponent.CollisionRadius)
				{
					// End:0x308
					if((VSize(Pawn.Anchor.Location - Focus.Location) <= MaxRange) && FastTrace(Focus.Location, Pawn.Anchor.Location))
					{
						MoveTarget = Pawn.Anchor;
						return true;						
					}
					else
					{
						return false;
					}
				}
			}			
		}
		else
		{
			// End:0x70E
			if(Pawn.Anchor.PathList.Length > 0)
			{
				TargetDist = VSize(Focus.Location - Pawn.Location);
				// End:0x426
				if(WorldInfo.GRI.OnSameTeam(Focus, self)!)
				{
					bAllowBackwards = (CombatStyle + ((UTWeap != none) ? UTWeap.SuggestAttackStyle() : 0.0000000)) <= 0.0000000;
				}
				Start = Rand(Pawn.Anchor.PathList.Length);
				I = Start;
				J0x479:

				// End:0x69F [Loop If]
				if(Pawn.Anchor.PathList[I].IsBlockedFor(Pawn)!)
				{
					Nav = Pawn.Anchor.PathList[I].GetEnd();
					// End:0x69F
					if(((Nav != Focus) && Nav.bSpecialMove!) && Nav.IsA('Teleporter')!)
					{
						Dist = VSize(Nav.Location - Focus.Location);
						// End:0x69F
						if((((Dist <= MaxRange) || Dist < TargetDist) && bAllowBackwards || Dist <= (TargetDist + 100.0000000)) && FastTrace(Focus.Location, Nav.Location))
						{
							MoveTarget = Nav;
							return true;
						}
					}
				}
				I++;
				// End:0x6F7
				if(I == Pawn.Anchor.PathList.Length)
				{
					I = 0;
				}
				// End:0x479
				if(!(I == Start))
					goto J0x479;
			}
		}
		return false;
		//return ReturnValue;		
	}

	function BeginState(name PreviousStateName)
	{
		StopStartTime = WorldInfo.TimeSeconds;
		bHasFired = false;
		StopMovement();
		// End:0x72
		if(FocusOnLeader(false)! && Focus == none)
		{
			Focus = Enemy;
		}
		// End:0xAD
		if(Focus == none)
		{
			LogInternal((GetHumanReadableName()) $ " no target in ranged attack");
		}
		//return;		
	}
Begin:

	bHasFired = false;
	// End:0x74
	if((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon)
	{
		SwitchToBestWeapon();
	}
	GoalString = GoalString @ "Ranged attack";
	Sleep(0.0000000);
	// End:0xDD
	if((Focus == none) || Focus.bDeleteMe)
	{
		LatentWhatToDoNext();
	}
	// End:0x137
	if(Enemy != none)
	{
		CheckIfShouldCrouch(Pawn.Location, Enemy.Location, 1.0000000);
	}
	// End:0x166
	if(Pawn.NeedToTurn(GetFocalPoint()))
	{
		FinishRotation();
	}
	bHasFired = true;
	// End:0x196
	if(Focus == Enemy)
	{
		TimedFireWeaponAtEnemy();		
	}
	else
	{
		FireWeaponAt(Focus);
	}
	Sleep(0.1000000);
	// End:0x280
	if((((Pawn.Weapon != none) && Pawn.Weapon.bMeleeWeapon) || Focus == none) || (((Focus != Enemy) && UTGameObjective(Focus) == none) && Enemy != none) && LineOfSightTo(Enemy))
	{
		LatentWhatToDoNext();
	}
	// End:0x2DA
	if(Enemy != none)
	{
		CheckIfShouldCrouch(Pawn.Location, Enemy.Location, 1.0000000);
	}
	// End:0x33B
	if(FindStrafeDest())
	{
		GoalString = (GoalString $ ", strafe to") @ string(MoveTarget);
		MoveToward(MoveTarget, Focus,, true, false);
		StopMovement();		
	}
	else
	{
		Sleep(FMax(Pawn.RangedAttackTime(), 0.2000000 + (((0.5000000 + (0.5000000 * FRand())) * 0.4000000) * (float(7) - Skill))));
	}
	LatentWhatToDoNext();
	// End:0x3C7
	if(bSoaking)
	{
		SoakStop("STUCK IN RANGEDATTACK!");
	}
	stop;					
}

state Dead
{
	ignores Timer, WhatToDoNext, DoRangedAttackOn, DelayedWarning, ExecuteWhatToDoNext, NotifyBump, 
		NotifyHitWall, NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, NotifyLanded, ReceiveWarning, 
		HearNoise, EnemyNotVisible, SeePlayer;

	function Celebrate()
	{
		LogInternal(string(self) $ " Celebrate while dead");
		//return;		
	}

	function bool SetRouteToGoal(Actor A)
	{
		LogInternal(string(self) $ " SetRouteToGoal while dead");
		return true;
		//return ReturnValue;		
	}

	function SetAttractionState()
	{
		LogInternal(string(self) $ " SetAttractionState while dead");
		//return;		
	}

	function EnemyChanged(bool bNewEnemyVisible)
	{
		LogInternal(string(self) $ " EnemyChanged while dead");
		//return;		
	}

	function WanderOrCamp()
	{
		LogInternal(string(self) $ " WanderOrCamp while dead");
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		// End:0x55
		if(bSpawnedByKismet || UTGame(WorldInfo.Game).TooManyBots(self))
		{
			Destroy();
			return;
		}
		// End:0x88
		if((DefensePoint != none) && UTHoldSpot(DefensePoint) == none)
		{
			FreePoint();
		}
		// End:0x130
		if(NavigationPoint(MoveTarget) != none)
		{
			NavigationPoint(MoveTarget).FearCost = (2 * NavigationPoint(MoveTarget).FearCost) + 600;
			WorldInfo.Game.bDoFearCostFallOff = true;
		}
		NextRoutePath = none;
		MonitoredPawn = none;
		WarningProjectile = none;
		PendingMover = none;
		Enemy = none;
		StopFiring();
		bFrustrated = false;
		BlockedPath = none;
		bInitLifeMessage = false;
		bPlannedJump = false;
		bInDodgeMove = false;
		bReachedGatherPoint = false;
		bFinalStretch = false;
		bWasNearObjective = false;
		bPreparingMove = false;
		bPursuingFlag = false;
		bHasSuperWeapon = false;
		ImpactJumpZ = 0.0000000;
		RouteGoal = none;
		NoVehicleGoal = none;
		SquadRouteGoal = none;
		bUsingSquadRoute = true;
		bUsePreviousSquadRoute = false;
		MoveTarget = none;
		ImpactVelocity = vect(0.0000000, 0.0000000, 0.0000000);
		LastSeenTime = -1000.0000000;
		bEnemyInfoValid = false;
		bHuntPlayer = false;
		bEnemyAcquired = false;
		bJumpOverWall = false;
		StartleActor = none;
		DefensePoint = none;
		//return;		
	}
Begin:

	// End:0x45
	if(WorldInfo.Game.bGameEnded)
	{
		GotoState('RoundEnded');
	}
	Sleep(0.2000000);
TryAgain:


	// End:0x80
	if(UTGame(WorldInfo.Game) == none)
	{
		Destroy();		
	}
	else
	{
		Sleep(0.7500000 + UTGame(WorldInfo.Game).SpawnWait(self));
		LastRespawnTime = WorldInfo.TimeSeconds;
		WorldInfo.Game.RestartPlayer(self);
		goto 'TryAgain';
	}
	J0x12F:

	Sleep(0.7500000 + FRand());
	WorldInfo.Game.RestartPlayer(self);
	goto 'TryAgain';
	stop;		
}

state FindAir
{
	ignores EnemyNotVisible, Bump, HearNoise, SeePlayer;

	function bool NotifyHeadVolumeChange(PhysicsVolume newHeadVolume)
	{
		global.NotifyHeadVolumeChange(newHeadVolume);
		// End:0x41
		if(newHeadVolume.bWaterVolume!)
		{
			WhatToDoNext();
		}
		return false;
		//return ReturnValue;		
	}

	function bool NotifyHitWall(Vector HitNormal, Actor Wall)
	{
		SetDestinationPosition(float(200) * (Normal(GetDestinationPosition() - Pawn.Location) + HitNormal));
		return true;
		//return ReturnValue;		
	}

	function Timer()
	{
		// End:0x2F
		if((Enemy != none) && LineOfSightTo(Enemy))
		{
			TimedFireWeaponAtEnemy();			
		}
		else
		{
			SetCombatTimer();
		}
		//return;		
	}

	function PickDestination(bool bNoCharge)
	{
		local Vector Dest;

		Dest = VRand();
		Dest.Z = 1.0000000;
		SetDestinationPosition(Pawn.Location + (float(200) * Dest));
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		Pawn.bWantsToCrouch = false;
		bAdjustFromWalls = false;
		//return;		
	}

	function EndState(name NextStateName)
	{
		bAdjustFromWalls = true;
		//return;		
	}
Begin:

	PickDestination(false);
DoMove:


	// End:0x2D
	if(Enemy == none)
	{
		MoveTo(GetDestinationPosition());		
	}
	else
	{
		MoveTo(GetDestinationPosition(), Enemy);
	}
	LatentWhatToDoNext();
	stop;					
}

state RoundEnded
{
	ignores SwitchToBestWeapon, DelayedWarning, ExecuteWhatToDoNext, ReceiveWarning, TakeDamage, Falling, 
		NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, HitWall, NotifyBump, KilledBy, 
		HearNoise, SeePlayer;

	function WhatToDoNext()
	{
		LogInternal(string(self) @ "WhatToDoNext while RoundEnded");
		//return;		
	}

	function Celebrate()
	{
		LogInternal(string(self) $ " Celebrate while RoundEnded");
		//return;		
	}

	function SetAttractionState()
	{
		LogInternal(string(self) $ " SetAttractionState while RoundEnded");
		//return;		
	}

	function EnemyChanged(bool bNewEnemyVisible)
	{
		LogInternal(string(self) $ " EnemyChanged while RoundEnded");
		//return;		
	}

	function WanderOrCamp()
	{
		LogInternal(string(self) $ " WanderOrCamp while RoundEnded");
		//return;		
	}

	function CelebrateVictory()
	{
		// End:0xB0
		if(UTGame(WorldInfo.Game) != none)
		{
			// End:0xB0
			if((UTGame(WorldInfo.Game).EndGameFocus == Pawn) && Pawn != none)
			{
				UTPawn(Pawn).PlayVictoryAnimation();
			}
		}
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		// End:0xB0
		if(((UTGame(WorldInfo.Game) != none) && UTGame(WorldInfo.Game).EndGameFocus == Pawn) && Pawn != none)
		{
			SetTimer(3.0000000, false, 'CelebrateVictory');
		}
		//return;		
	}
	stop;	
}

state WaitingForLanding
{
	function bool DoWaitForLanding()
	{
		// End:0x0F
		if(bJustLanded)
		{
			return false;
		}
		BeginState(GetStateName());
		return true;
		//return ReturnValue;		
	}

	event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
	{
		bJustLanded = true;
		global.NotifyLanded(HitNormal, FloorActor);
		return false;
		//return ReturnValue;		
	}

	function Timer()
	{
		// End:0x24
		if(Focus == Enemy)
		{
			TimedFireWeaponAtEnemy();			
		}
		else
		{
			SetCombatTimer();
		}
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		bJustLanded = false;
		// End:0x54
		if((MoveTarget != none) && (Enemy == none) || Focus != Enemy)
		{
			FaceActor(1.5000000);
		}
		// End:0x86
		if((Enemy == none) || Focus != Enemy)
		{
			StopFiring();
		}
		//return;		
	}
Begin:

	// End:0x6C
	if(Pawn.PhysicsVolume.bWaterVolume || int(Pawn.Physics) == int(3))
	{
		LatentWhatToDoNext();
	}
	// End:0x1A9
	if(Pawn.GetGravityZ() > (0.9000000 * WorldInfo.DefaultGravityZ))
	{
		// End:0x161
		if((MoveTarget == none) || MoveTarget.Location.Z > Pawn.Location.Z)
		{
			NotifyMissedJump();
			// End:0x15E
			if(MoveTarget != none)
			{
				MoveToward(MoveTarget, Focus,, true);
			}			
		}
		else
		{
			// End:0x197
			if(int(Pawn.Physics) != int(2))
			{
				LatentWhatToDoNext();				
			}
			else
			{
				Sleep(0.5000000);
				goto 'Begin';
			}
		}
	}
	WaitForLanding();
	LatentWhatToDoNext();
	Sleep(0.5000000);
	goto 'Begin';
	stop;			
}

state EnteringVehicle
{Begin:

	// End:0x27F
	if((((Vehicle(RouteGoal) != none) && Vehicle(Pawn) == none) && Vehicle(RouteGoal).Health > 0) && RouteGoal.bDeleteMe!)
	{
		// End:0xE7
		if(Vehicle(RouteGoal).TryToDrive(Pawn))
		{
			UTSquadAI(Squad).BotEnteredVehicle(self);			
		}
		else
		{
			// End:0x17E
			if((UTVehicle(RouteGoal) != none) && UTVehicle(RouteGoal).bPlayingSpawnEffect)
			{
				GoalString = ("Waiting for" @ string(RouteGoal)) @ "to finish spawning in";
				Sleep(0.2500000);
				goto 'Begin';				
			}
			else
			{
				// End:0x27F
				if(ActorReachable(RouteGoal))
				{
					GoalString = "Getting closer to enter vehicle" @ string(RouteGoal);
					MoveTarget = RouteGoal;
					MoveToward(RouteGoal, FaceActor(1.0000000),, ShouldStrafeTo(RouteGoal));
					// End:0x27F
					if((Vehicle(Pawn) == none) && Vehicle(RouteGoal).TryToDrive(Pawn))
					{
						UTSquadAI(Squad).BotEnteredVehicle(self);
					}
				}
			}
		}
	}
	LatentWhatToDoNext();
	// End:0x2BA
	if(bSoaking)
	{
		SoakStop("STUCK IN ENTERINGVEHICLE");
	}
	stop;		
}

state LeavingVehicle
{
	function TryLeavingVehicle()
	{
		local Vehicle V;
		local UTAirVehicle AirVehicle;

		V = Vehicle(Pawn);
		// End:0x1FB
		if(V != none)
		{
			// End:0x95
			if(IsZero(DirectionHint) && RouteGoal != none)
			{
				DirectionHint = Normal(RouteGoal.Location - V.Location);
			}
			V.DriverLeave(false);
			// End:0x1FB
			if(Vehicle(Pawn) == none)
			{
				AirVehicle = UTAirVehicle(V);
				// End:0x18C
				if(AirVehicle != none)
				{
					AirVehicle.Mesh.AddImpulse(AirVehicle.PushForce * Vector(AirVehicle.Rotation), AirVehicle.Location);
				}
				// End:0x1FB
				if((int(Pawn.Physics) == int(2)) && DoWaitForLanding())
				{
					Pawn.Velocity.Z = 0.0000000;
				}
			}
		}
		//return;		
	}
Begin:

	TryLeavingVehicle();
	// End:0x88
	if(Vehicle(Pawn) != none)
	{
		GoalString = "Failed to exit vehicle - try moving to more open area";
		FindRandomDest();
		// End:0x88
		if(RouteCache.Length > 0)
		{
			MoveToward(RouteCache[0]);
		}
	}
	LatentWhatToDoNext();
	// End:0xC2
	if(bSoaking)
	{
		SoakStop("STUCK IN LEAVINGVEHICLE");
	}
	stop;		
}

state CustomAction
{
	event EndState(name NextStateName)
	{
		__CustomActionFunc__Delegate = None;
		//return;		
	}
	J0x00:
	// End:0x24 [Loop If]
	if(CustomActionFunc(self)!)
	{
		Sleep(0.0000000);
		// [Loop Continue]
		goto J0x00;
	}
	LatentWhatToDoNext();
	// End:0x5C
	if(bSoaking)
	{
		SoakStop("STUCK IN CUSTOMACTION");
	}
	stop;				
}

state InQueue extends RoundEnded
{
	function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		PlayerReplicationInfo.bIsSpectator = true;
		//return;		
	}

	function EndState(name NextStateName)
	{
		super(Object).EndState(NextStateName);
		PlayerReplicationInfo.bIsSpectator = false;
		//return;		
	}
	stop;	
}

state ScriptedMove
{
	ignores ExecuteWhatToDoNext, HearNoise, SeeMonster, SeePlayer, WhatToDoNext;

	event bool NotifyHitWall(Vector HitNormal, Actor Wall)
	{
		// End:0xC6
		if((((Vehicle(Wall) != none) && ScriptedMoveTarget.IsA('UTVehicleFactory')) && Wall == UTVehicleFactory(ScriptedMoveTarget).ChildVehicle) && Wall.ContainsPoint(ScriptedMoveTarget.Location))
		{
			PopState();
			return false;			
		}
		else
		{
			return global.NotifyHitWall(HitNormal, Wall);
		}
		//return ReturnValue;		
	}

	event PushedState()
	{
		super.PushedState();
		Pawn.UnCrouch();
		//return;		
	}

	event PoppedState()
	{
		super.PoppedState();
		// End:0x23
		if(Pawn != none)
		{
			StopMovement();
		}
		//return;		
	}
	stop;	
}

state Frozen
{
	ignores ExecuteWhatToDoNext, HearNoise, SeeMonster, WhatToDoNext;

	event SeePlayer(Pawn SeenPlayer)
	{
		// End:0x43
		if(Pawn != none)
		{
			Pawn.TriggerEventClass(Class'Engine.SeqEvent_AISeeEnemy', SeenPlayer);
		}
		//return;		
	}

	function OnAIFreeze(UTSeqAct_AIFreeze FreezeAction)
	{
		// End:0x45
		if(FreezeAction.InputLinks[1].bHasImpulse)
		{
			PopState();			
		}
		else
		{
			FreezeAction.ScriptLog(string(self) @ "received freeze request while already frozen");
		}
		//return;		
	}

	event PushedState()
	{
		StopMovement();
		bScriptedFrozen = true;
		StopFiring();
		Focus = none;
		//return;		
	}

	event PoppedState()
	{
		bScriptedFrozen = false;
		//return;		
	}
	stop;	
}

state FrozenMovement
{
	ignores ExecuteWhatToDoNext;

	function WhatToDoNext()
	{
		// End:0x2F
		if(Enemy != none)
		{
			Focus = Enemy;
			TimedFireWeaponAtEnemy();			
		}
		else
		{
			Enemy = none;
			StopFiring();
		}
		//return;		
	}

	function Timer()
	{
		// End:0x19
		if(Enemy != none)
		{
			TimedFireWeaponAtEnemy();
		}
		//return;		
	}

	function OnAIFreeze(UTSeqAct_AIFreeze FreezeAction)
	{
		// End:0x45
		if(FreezeAction.InputLinks[1].bHasImpulse)
		{
			PopState();			
		}
		else
		{
			FreezeAction.ScriptLog(string(self) @ "received freeze request while already frozen");
		}
		//return;		
	}

	event PushedState()
	{
		// End:0x8D
		if(((Squad == none) && PlayerReplicationInfo != none) && UTTeamInfo(PlayerReplicationInfo.Team) != none)
		{
			UTTeamInfo(PlayerReplicationInfo.Team).SetBotOrders(self);
		}
		StopMovement();
		bScriptedFrozen = true;
		//return;		
	}

	event PoppedState()
	{
		bScriptedFrozen = false;
		//return;		
	}
	stop;	
}

defaultproperties
{
	LastTauntIndex=-1
	Aggressiveness=0.4000000
	LastAttractCheck=-10000.0000000
	BaseAggressiveness=0.4000000
	CombatStyle=0.2000000
	OldMessageTime=-100.0000000
	LastSearchTime=-10000.0000000
	OrderNames[0]="Defend"
	OrderNames[1]="Hold"
	OrderNames[2]="ATTACK"
	OrderNames[3]="Follow"
	OrderNames[4]="Freelance"
	OrderNames[10]="ATTACK"
	OrderNames[11]="Defend"
	OrderNames[12]="Defend"
	OrderNames[13]="ATTACK"
	OrderNames[14]="ATTACK"
	// Reference: UDKAIDecisionComponent'UTGame.Default__UTBot.TheDecider'
	// Archetype: UDKAIDecisionComponent'UDKBase.Default__UDKBot.TheDecider'
	begin object name="TheDecider"
	end object
	DecisionComponent=TheDecider
	ScriptedFireMode=255
	bIsPlayer=true
	Components[0]=TheDecider
}