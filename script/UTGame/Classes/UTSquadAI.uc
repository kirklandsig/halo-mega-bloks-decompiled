class UTSquadAI extends UDKSquadAI;

const NEAROBJECTIVEDIST = 2000.0;

var Controller SquadLeader;
var UTPlayerReplicationInfo LeaderPRI;
var UTSquadAI NextSquad;
var int Size;
var UTBot SquadMembers;
var const localized string SupportString;
var const localized string DefendString;
var const localized string AttackString;
var const localized string HoldString;
var const localized string FreelanceString;
var const localized string SupportStringTrailer;
var name CurrentOrders;
var Pawn Enemies[8];
var int MaxSquadSize;
var bool bFreelance;
var bool bFreelanceAttack;
var bool bFreelanceDefend;
var bool bRoamingSquad;
var bool bAddTransientCosts;
var bool bShouldUseGatherPoints;
var float FormationSize;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		CurrentOrders, LeaderPRI, 
		bFreelance;
}

function Reset()
{
	local int I;

	super(Actor).Reset();
	bForceNetUpdate = true;
	SquadObjective = none;
	I = 0;
	J0x2C:

	// End:0x5F [Loop If]
	if(I < 8)
	{
		Enemies[I] = none;
		I++;
		// [Loop Continue]
		goto J0x2C;
	}
	//return;	
}

function CriticalObjectiveWarning(Pawn NewEnemy)
{
	local UTBot M;

	// End:0x1A
	if(ValidEnemy(NewEnemy)!)
	{
		return;
	}
	AddEnemy(NewEnemy);
	// End:0x47
	if(MustKeepEnemy(NewEnemy)!)
	{
		return;
	}
	M = SquadMembers;
	J0x5A:

	// End:0xCC [Loop If]
	if(M != none)
	{
		// End:0xA1
		if(M.Enemy == none)
		{
			FindNewEnemyFor(M, false);
		}
		M = M.NextSquadMember;
		// [Loop Continue]
		goto J0x5A;
	}
	//return;	
}

function bool ShouldSuppressEnemy(UTBot B)
{
	return (((UTWeapon(B.Pawn.Weapon) == none) || UTWeapon(B.Pawn.Weapon).bSniping!) && FRand() < 0.7000000) && (WorldInfo.TimeSeconds - B.LastSeenTime) < 4.0000000;
	//return ReturnValue;	
}

function bool AllowDetourTo(UTBot B, NavigationPoint N)
{
	return true;
	//return ReturnValue;	
}

function Destroyed()
{
	// End:0x4D
	if(Team != none)
	{
		UTTeamInfo(Team).AI.RemoveSquad(self);
	}
	// End:0xB4
	if((SquadObjective != none) && UTGameObjective(SquadObjective).DefenseSquad == self)
	{
		UTGameObjective(SquadObjective).DefenseSquad = none;
	}
	super(Actor).Destroyed();
	//return;	
}

function bool AllowImpactJumpBy(UTBot B)
{
	return true;
	//return ReturnValue;	
}

function Actor SetFacingActor(UTBot B)
{
	return none;
	//return ReturnValue;	
}

function UTVehicle GetLinkVehicle(UTBot B)
{
	local UTVehicle V;

	// End:0x32
	if(UDKVehicleBase(SquadLeader.Pawn) == none)
	{
		return none;		
	}
	else
	{
		V = UTVehicle(SquadLeader.Pawn.GetVehicleBase());
		// End:0xDF
		if((V != none) && (B.Enemy == none) || V.bKeyVehicle)
		{
			return V;			
		}
		else
		{
			return none;
		}
	}
	//return ReturnValue;	
}

function Rotator GetFacingRotation()
{
	local Rotator Rot;

	// End:0x3A
	if(SquadObjective == none)
	{
		Rot = SquadLeader.Rotation;		
	}
	else
	{
		// End:0xA4
		if(int(SquadObjective.DefenderTeamIndex) == Team.TeamIndex)
		{
			Rot.Yaw = Rand(65536);			
		}
		else
		{
			// End:0x12A
			if(SquadLeader.Pawn != none)
			{
				Rot = Rotator(SquadObjective.Location - SquadLeader.Pawn.Location);				
			}
			else
			{
				Rot.Yaw = Rand(65536);
			}
		}
	}
	Rot.Pitch = 0;
	Rot.Roll = 0;
	return Rot;
	//return ReturnValue;	
}

function Actor FormationCenter(Controller C)
{
	// End:0x5E
	if((SquadObjective != none) && int(SquadObjective.DefenderTeamIndex) == Team.TeamIndex)
	{
		return SquadObjective;
	}
	return SquadLeader.Pawn;
	//return ReturnValue;	
}

function bool LostEnemy(UTBot B)
{
	local Pawn Lost;
	local bool bFound;
	local UTBot M;

	// End:0xD2
	if((B.Enemy.Health <= 0) || B.Enemy.Controller == none)
	{
		B.Enemy = none;
		RemoveEnemy(B.Enemy);
		FindNewEnemyFor(B, false);
		return true;
	}
	// End:0xFF
	if(MustKeepEnemy(B.Enemy))
	{
		return false;
	}
	Lost = B.Enemy;
	B.Enemy = none;
	M = SquadMembers;
	J0x15A:

	// End:0x213 [Loop If]
	if(M != none)
	{
		// End:0x1E8
		if(((M != B) && M.Enemy == Lost) && M.LostContact(5.0000000)!)
		{
			bFound = true;
			// [Explicit Break]
			goto J0x213;
		}
		M = M.NextSquadMember;
		// [Loop Continue]
		goto J0x15A;
	}
	J0x213:

	// End:0x24B
	if(bFound)
	{
		B.Enemy = Lost;		
	}
	else
	{
		RemoveEnemy(Lost);
		FindNewEnemyFor(B, false);
	}
	return B.Enemy != Lost;
	//return ReturnValue;	
}

function bool MustKeepEnemy(Pawn E)
{
	return false;
	//return ReturnValue;	
}

function bool AddEnemy(Pawn NewEnemy)
{
	local int I;
	local UTBot M;
	local bool bCurrentEnemy;

	I = 0;
	J0x0B:

	// End:0x4C [Loop If]
	if(I < 8)
	{
		// End:0x3E
		if(Enemies[I] == NewEnemy)
		{
			return false;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	I = 0;
	J0x57:

	// End:0xAD [Loop If]
	if(I < 8)
	{
		// End:0x9F
		if(Enemies[I] == none)
		{
			Enemies[I] = NewEnemy;
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x57;
	}
	I = 0;
	J0xB8:

	// End:0x1A2 [Loop If]
	if(I < 8)
	{
		bCurrentEnemy = false;
		M = SquadMembers;
		J0xE7:

		// End:0x166 [Loop If]
		if(M != none)
		{
			// End:0x13B
			if(M.Enemy == Enemies[I])
			{
				bCurrentEnemy = true;
				// [Explicit Break]
				goto J0x166;
			}
			M = M.NextSquadMember;
			// [Loop Continue]
			goto J0xE7;
		}
		J0x166:

		// End:0x194
		if(bCurrentEnemy!)
		{
			Enemies[I] = NewEnemy;
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0xB8;
	}
	return false;
	//return ReturnValue;	
}

function bool ValidEnemy(Pawn NewEnemy)
{
	return ((((NewEnemy != none) && NewEnemy.bAmbientCreature!) && NewEnemy.Health > 0) && NewEnemy.Controller != none) && FriendlyToward(NewEnemy)!;
	//return ReturnValue;	
}

function bool SetEnemy(UTBot B, Pawn NewEnemy)
{
	local UTBot M;
	local bool bResult;

	// End:0x48
	if((NewEnemy == B.Enemy) || ValidEnemy(NewEnemy)!)
	{
		return false;
	}
	// End:0x62
	if(AddEnemy(NewEnemy)!)
	{
		return false;
	}
	// End:0x17B
	if(MustKeepEnemy(NewEnemy))
	{
		M = SquadMembers;
		J0x8B:

		// End:0x17B [Loop If]
		if(M != none)
		{
			// End:0x150
			if((M != B) && M.Enemy != NewEnemy)
			{
				FindNewEnemyFor(M, (M.Enemy != none) && M.LineOfSightTo(M.Enemy));
			}
			M = M.NextSquadMember;
			// [Loop Continue]
			goto J0x8B;
		}
	}
	bResult = FindNewEnemyFor(B, (B.Enemy != none) && B.LineOfSightTo(B.Enemy));
	// End:0x26F
	if(bResult && B.Enemy == NewEnemy)
	{
		B.AcquireTime = WorldInfo.TimeSeconds;
	}
	return bResult;
	//return ReturnValue;	
}

function byte PriorityObjective(UTBot B)
{
	return 0;
	//return ReturnValue;	
}

function bool IsOnSquad(Controller C)
{
	// End:0x43
	if(UTBot(C) != none)
	{
		return UTBot(C).Squad == self;
	}
	return C == SquadLeader;
	//return ReturnValue;	
}

function RemoveEnemy(Pawn E)
{
	local UTBot B;
	local int I;

	I = 0;
	J0x0B:

	// End:0x5F [Loop If]
	if(I < 8)
	{
		// End:0x51
		if(Enemies[I] == E)
		{
			Enemies[I] = none;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x98
	if(WorldInfo.Game.bGameEnded)
	{
		return;
	}
	B = SquadMembers;
	J0xAB:

	// End:0x28B [Loop If]
	if(B != none)
	{
		// End:0x260
		if(B.Enemy == E)
		{
			B.Enemy = none;
			FindNewEnemyFor(B, false);
			// End:0x260
			if(((B.Pawn != none) && B.Enemy == none) && B.bIgnoreEnemyChange!)
			{
				// End:0x241
				if((B.InLatentExecution(B.503) && NavigationPoint(B.MoveTarget) != none) && B.bPreparingMove!)
				{
					B.GotoState('Roaming');					
				}
				else
				{
					B.WhatToDoNext();
				}
			}
		}
		B = B.NextSquadMember;
		// [Loop Continue]
		goto J0xAB;
	}
	//return;	
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> DamageType)
{
	local UTBot B;
	local bool bPreviousRouteInUse;

	// End:0x11
	if(Killed == none)
	{
		return;
	}
	// End:0xD1
	if(Killed == SquadLeader)
	{
		B = SquadMembers;
		J0x3B:

		// End:0xA6 [Loop If]
		if(B != none)
		{
			// End:0x7B
			if(B.bUsePreviousSquadRoute)
			{
				bPreviousRouteInUse = true;
				// [Explicit Break]
				goto J0xA6;
			}
			B = B.NextSquadMember;
			// [Loop Continue]
			goto J0x3B;
		}
		J0xA6:

		// End:0xD1
		if(bPreviousRouteInUse!)
		{
			PendingSquadRouteMaker = UTBot(SquadLeader);
		}
	}
	// End:0x14B
	if(((Team != none) && Killed.PlayerReplicationInfo != none) && Killed.PlayerReplicationInfo.Team == Team)
	{
		return;
	}
	RemoveEnemy(KilledPawn);
	B = UTBot(Killer);
	// End:0x25A
	if(((((B != none) && B.Squad == self) && B.Enemy == none) && B.Pawn != none) && AllowTaunt(B))
	{
		B.Focus = KilledPawn;
		B.Celebrate();
	}
	//return;	
}

function bool FindNewEnemyFor(UTBot B, bool bSeeEnemy)
{
	local int I;
	local Pawn BestEnemy, OldEnemy;
	local bool bSeeNew;
	local float BestThreat, NewThreat;

	// End:0x26
	if(B.Pawn == none)
	{
		return true;
	}
	// End:0xB6
	if(((B.Enemy != none) && MustKeepEnemy(B.Enemy)) && B.LineOfSightTo(B.Enemy))
	{
		return false;
	}
	BestEnemy = B.Enemy;
	OldEnemy = B.Enemy;
	// End:0x1F3
	if(BestEnemy != none)
	{
		// End:0x18D
		if((BestEnemy.Health < 0) || BestEnemy.Controller == none)
		{
			B.Enemy = none;
			BestEnemy = none;			
		}
		else
		{
			// End:0x1C3
			if((ModifyThreat(0.0000000, BestEnemy, bSeeEnemy, B)) > float(5))
			{
				return false;
			}
			BestThreat = AssessThreat(B, BestEnemy, bSeeEnemy);
		}
	}
	I = 0;
	J0x1FE:

	// End:0x550 [Loop If]
	if(I < 8)
	{
		// End:0x52D
		if((((Enemies[I] != none) && Enemies[I].Health > 0) && Enemies[I].Controller != none) && B.bBetrayTeam || WorldInfo.GRI.OnSameTeam(Enemies[I], B)!)
		{
			// End:0x397
			if(BestEnemy == none)
			{
				BestEnemy = Enemies[I];
				bSeeEnemy = B.CanSee(Enemies[I]);
				BestThreat = AssessThreat(B, BestEnemy, bSeeEnemy);				
			}
			else
			{
				// End:0x52A
				if(Enemies[I] != BestEnemy)
				{
					// End:0x45E
					if(VSize(Enemies[I].Location - B.Pawn.Location) < float(1500))
					{
						bSeeNew = B.LineOfSightTo(Enemies[I]);						
					}
					else
					{
						bSeeNew = B.CanSee(Enemies[I]);
					}
					NewThreat = AssessThreat(B, Enemies[I], bSeeNew);
					// End:0x52A
					if(NewThreat > BestThreat)
					{
						BestEnemy = Enemies[I];
						BestThreat = NewThreat;
						bSeeEnemy = bSeeNew;
					}
				}
			}			
		}
		else
		{
			Enemies[I] = none;
		}
		I++;
		// [Loop Continue]
		goto J0x1FE;
	}
	B.Enemy = BestEnemy;
	// End:0x5F5
	if((B.Enemy != OldEnemy) && B.Enemy != none)
	{
		B.EnemyChanged(bSeeEnemy);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function float ModifyThreat(float Current, Pawn NewThreat, bool bThreatVisible, UTBot B)
{
	return Current;
	//return ReturnValue;	
}

function bool UnderFire(Pawn NewThreat, UTBot Ignored)
{
	local UTBot B;

	B = SquadMembers;
	J0x13:

	// End:0x216 [Loop If]
	if(B != none)
	{
		// End:0x1EB
		if((((((B != Ignored) && B.Pawn != none) && B.Enemy == NewThreat) && B.Focus == NewThreat) && VSize((Ignored.Pawn.Location - NewThreat.Location) + NewThreat.Velocity) > VSize((B.Pawn.Location - NewThreat.Location) + NewThreat.Velocity)) && B.LineOfSightTo(B.Enemy))
		{
			return true;
		}
		B = B.NextSquadMember;
		// [Loop Continue]
		goto J0x13;
	}
	return false;
	//return ReturnValue;	
}

function float AssessThreat(UTBot B, Pawn NewThreat, bool bThreatVisible)
{
	local float ThreatValue, Dist;
	local bool bCloseThreat;

	ThreatValue = 0.5000000;
	Dist = VSize(NewThreat.Location - B.Pawn.Location);
	// End:0xB5
	if(Dist < float(2500))
	{
		bCloseThreat = true;
		ThreatValue += ((float(2500) - Dist) / float(2500));
	}
	// End:0x183
	if((B.Pawn != none) && B.Pawn.Weapon != none)
	{
		ThreatValue += UTWeapon(B.Pawn.Weapon).RelativeStrengthVersus(NewThreat, Dist);
	}
	// End:0x19E
	if(bThreatVisible)
	{
		ThreatValue += float(1);
	}
	// End:0x1F3
	if((UTVehicle(NewThreat) != none) && UTVehicle(NewThreat).bKeyVehicle)
	{
		ThreatValue += 0.2500000;
	}
	// End:0x27C
	if(NewThreat == B.Enemy)
	{
		// End:0x279
		if(bThreatVisible && bCloseThreat)
		{
			ThreatValue += (0.1000000 * FMax(0.0000000, 5.0000000 - B.Skill));
		}		
	}
	else
	{
		// End:0x3B5
		if(B.Enemy != none)
		{
			// End:0x2C1
			if(bThreatVisible!)
			{
				ThreatValue -= float(5);				
			}
			else
			{
				// End:0x316
				if((WorldInfo.TimeSeconds - B.LastSeenTime) > float(2))
				{
					ThreatValue += float(1);
				}
			}
			// End:0x3A5
			if(Dist > (0.7000000 * VSize(B.Enemy.Location - B.Pawn.Location)))
			{
				ThreatValue -= 0.2500000;
			}
			ThreatValue -= 0.2000000;
		}
	}
	ThreatValue = ModifyThreat(ThreatValue, NewThreat, bThreatVisible, B);
	return ThreatValue;
	//return ReturnValue;	
}

function bool ShouldDeferTo(Controller C)
{
	return C == SquadLeader;
	//return ReturnValue;	
}

function bool WaitAtThisPosition(Pawn P)
{
	// End:0x82
	if((UTBot(P.Controller).NeedWeapon() || PlayerController(SquadLeader) == none) || SquadLeader.Pawn == none)
	{
		return false;
	}
	return CloseToLeader(P);
	//return ReturnValue;	
}

function bool WanderNearLeader(UTBot B)
{
	// End:0xC2
	if(((((Vehicle(B.Pawn) != none) || B.NeedWeapon()) || PlayerController(SquadLeader) == none) || SquadLeader.Pawn == none) || CloseToLeader(B.Pawn)!)
	{
		return false;
	}
	// End:0xEB
	if(B.FindInventoryGoal(0.0005000))
	{
		return true;
	}
	//return ReturnValue;	
}

function bool NearFormationCenter(Pawn P)
{
	local Actor Center;

	Center = FormationCenter(P.Controller);
	// End:0x43
	if(Center == none)
	{
		return true;
	}
	// End:0xA0
	if(Center == SquadLeader.Pawn)
	{
		// End:0x9E
		if(PlayerController(SquadLeader) != none)
		{
			return CloseToLeader(P);			
		}
		else
		{
			return false;
		}
	}
	// End:0xF0
	if(VSize(Center.Location - P.Location) > FormationSize)
	{
		return false;
	}
	return P.Controller.LineOfSightTo(Center);
	//return ReturnValue;	
}

function bool CloseToLeader(Pawn P)
{
	local float Dist;

	// End:0x37
	if((P == none) || SquadLeader.Pawn == none)
	{
		return true;
	}
	// End:0xCC
	if(Vehicle(P) == none)
	{
		// End:0xC9
		if((UTVehicle(SquadLeader.Pawn) != none) && UTVehicle(SquadLeader.Pawn).OpenPositionFor(P))
		{
			return false;
		}		
	}
	else
	{
		// End:0x118
		if((PlayerController(SquadLeader) != none) && Vehicle(SquadLeader.Pawn) == none)
		{
			return false;			
		}
		else
		{
			// End:0x1DB
			if((P.bCanFly && VolumePathNode(P.Anchor) != none) && P.Anchor.GetReachSpecTo(SquadLeader.Pawn.Anchor) != none)
			{
				return true;
			}
		}
	}
	// End:0x263
	if((P.GetVehicleBase() == SquadLeader.Pawn) || SquadLeader.Pawn.GetVehicleBase() == P)
	{
		return true;
	}
	// End:0x31C
	if(((P.Base != none) && SquadLeader.Pawn.Base != none) && SquadLeader.Pawn.Base != P.Base)
	{
		return false;
	}
	Dist = VSize(P.Location - SquadLeader.Pawn.Location);
	// End:0x394
	if(Dist > FormationSize)
	{
		return false;
	}
	// End:0x3F8
	if(PhysicsVolume.bWaterVolume)
	{
		// End:0x3F5
		if(VSize(SquadLeader.Pawn.Velocity) > float(0))
		{
			return false;
		}		
	}
	else
	{
		// End:0x49C
		if(VSize(SquadLeader.Pawn.Velocity) > (SquadLeader.Pawn.WalkingPct * SquadLeader.Pawn.GroundSpeed))
		{
			return false;
		}
	}
	return P.Controller.LineOfSightTo(SquadLeader.Pawn);
	//return ReturnValue;	
}

function MergeWith(UTSquadAI S)
{
	// End:0x60
	if(SquadObjective != S.SquadObjective)
	{
		SquadObjective = S.SquadObjective;
		bForceNetUpdate = true;
	}
	//return;	
}

function Initialize(UTTeamInfo T, UTGameObjective O, Controller C)
{
	Team = T;
	SetLeader(C);
	SetObjective(O, false);
	//return;	
}

function bool ShouldUseAlternatePaths()
{
	return false;
	//return ReturnValue;	
}

function SetAlternatePathTo(NavigationPoint NewRouteObjective, UTBot RouteMaker)
{
	local UTBot M;

	// End:0x208
	if((ShouldUseAlternatePaths()) && (RouteObjective != NewRouteObjective) || PendingSquadRouteMaker != none)
	{
		// End:0x12B
		if(RouteObjective != NewRouteObjective)
		{
			SquadRoutes.Length = 0;
			SquadRouteIteration = 0;
			RouteObjective = NewRouteObjective;
			M = SquadMembers;
			J0x8B:

			// End:0x128 [Loop If]
			if(M != none)
			{
				M.bUsingSquadRoute = true;
				M.bFinalStretch = false;
				M.bReachedGatherPoint = false;
				M = M.NextSquadMember;
				// [Loop Continue]
				goto J0x8B;
			}			
		}
		else
		{
			PreviousObjectiveRouteCache = ObjectiveRouteCache;
			M = SquadMembers;
			J0x151:

			// End:0x1E9 [Loop If]
			if(M != none)
			{
				// End:0x1BE
				if((M != RouteMaker) && M.Pawn != none)
				{
					M.bUsePreviousSquadRoute = true;
				}
				M = M.NextSquadMember;
				// [Loop Continue]
				goto J0x151;
			}
		}
		RouteMaker.BuildSquadRoute();
	}
	//return;	
}

function bool TryToIntercept(UTBot B, Pawn P, Actor RouteGoal)
{
	// End:0xC5
	if((((P == B.Enemy) && B.Pawn.RecommendLongRangedAttack()) && P != none) && B.LineOfSightTo(P))
	{
		B.FightEnemy(false, 0.0000000);
		return true;
	}
	// End:0x154
	if(((P == none) || NavigationPoint(RouteGoal) == none) || (B.Skill + B.Tactics) < float(4))
	{
		return FindPathToObjective(B, P);
	}
	B.MoveTarget = none;
	// End:0x2AF
	if(B.ActorReachable(P))
	{
		B.GoalString = "almost to " $ string(P);
		// End:0x218
		if(B.Enemy != P)
		{
			SetEnemy(B, P);
		}
		// End:0x266
		if(B.Enemy != none)
		{
			B.FightEnemy(true, 0.0000000);
			return true;			
		}
		else
		{
			B.MoveTarget = P;
			B.SetAttractionState();
			return true;
		}
	}
	B.MoveTarget = B.FindPathToIntercept(P, RouteGoal, true);
	// End:0x3CF
	if(B.MoveTarget == none)
	{
		// End:0x3CC
		if(P == B.Enemy)
		{
			B.FailedHuntEnemy = B.Enemy;
			B.FailedHuntTime = WorldInfo.TimeSeconds;
		}		
	}
	else
	{
		// End:0x426
		if(B.Pawn.ReachedDestination(B.MoveTarget))
		{
			return false;
		}
	}
	return B.StartMoveToward(P);
	//return ReturnValue;	
}

function bool CloseEnoughToObjective(UTBot B, Actor O)
{
	return ((B.Pawn.Location.Z - O.Location.Z) < 500.0000000) && ((VSize(B.Pawn.Location - O.Location) < ((UTVehicle(B.Pawn) != none) ? UTVehicle(B.Pawn).ObjectiveGetOutDist : 1000.0000000)) && B.LineOfSightTo(O)) || B.ActorReachable(O);
	//return ReturnValue;	
}

function bool LeaveVehicleToReachObjective(UTBot B, Actor O)
{
	local Vehicle OldVehicle;

	// End:0x141
	if(CloseEnoughToObjective(B, O))
	{
		OldVehicle = Vehicle(B.Pawn);
		B.MoveTarget = none;
		B.DirectionHint = Normal(O.Location - OldVehicle.Location);
		B.NoVehicleGoal = O;
		B.RouteGoal = O;
		B.LeaveVehicle(true);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool MustCompleteOnFoot(Actor O, optional Pawn P)
{
	local UTGameObjective Objective;

	// End:0x1E
	if(UTCarriedObject(O) != none)
	{
		return true;		
	}
	else
	{
		Objective = UTGameObjective(O);
		return (Objective != none) && Objective.GetFlag() != none;
	}
	//return ReturnValue;	
}

function LeaveVehicleAtParkingSpot(UTBot B, Actor O)
{
	// End:0x236
	if((B.Pawn.bStationary! && UTVehicle(B.Pawn) != none) && UTVehicle(B.Pawn).bKeyVehicle)
	{
		// End:0x1BC
		if(Team.Size == UTVehicle(B.Pawn).NumPassengers())
		{
			B.NoVehicleGoal = O;
			B.RouteGoal = O;
			UTVehicle(B.Pawn).bKeyVehicle = false;
			B.LeaveVehicle(true);			
		}
		else
		{
			// End:0x208
			if(B.Enemy != none)
			{
				B.FightEnemy(false, 0.0000000);				
			}
			else
			{
				B.GotoState('Defending', 'Pausing');
			}
		}		
	}
	else
	{
		B.NoVehicleGoal = O;
		B.RouteGoal = O;
		B.LeaveVehicle(true);
	}
	//return;	
}

function bool FindPathToObjective(UTBot B, Actor O)
{
	local Vehicle V;
	local UTGameObjective Objective;
	local int I, RouteIndex;
	local float GatherWaitTime;
	local UTBot M;
	local bool bDoneGathering;
	local NavigationPoint N;

	// End:0x65
	if(O == none)
	{
		O = SquadObjective;
		// End:0x65
		if(O == none)
		{
			B.GoalString = "No SquadObjective";
			return false;
		}
	}
	Objective = UTGameObjective(O);
	// End:0x232
	if(Objective != none)
	{
		// End:0x1A7
		if(B.Pawn.bStationary)
		{
			V = B.Pawn.GetVehicleBase();
			// End:0x156
			if(V == none)
			{
				V = Vehicle(B.Pawn);
				// End:0x156
				if(V == none)
				{
					return false;
				}
			}
			// End:0x1A2
			if(Objective.ReachedParkingSpot(V))
			{
				LeaveVehicleAtParkingSpot(B, O);
				return true;				
			}
			else
			{
				return false;
			}			
		}
		else
		{
			// End:0x232
			if(Vehicle(B.Pawn) != none)
			{
				// End:0x232
				if(Objective.ReachedParkingSpot(B.Pawn))
				{
					LeaveVehicleAtParkingSpot(B, O);
					return true;
				}
			}
		}
	}
	// End:0x530
	if((UTVehicle(B.Pawn) != none) && MustCompleteOnFoot(O, B.Pawn))
	{
		// End:0x4A9
		if(VSize(O.Location - B.Pawn.Location) <= B.Pawn.GetCollisionRadius())
		{
			N = NavigationPoint(O);
			// End:0x42E
			if(N != none)
			{
				I = 0;
				J0x359:

				// End:0x42E [Loop If]
				if(I < N.PathList.Length)
				{
					// End:0x420
					if(N.PathList[I].GetEnd() != none)
					{
						N.PathList[I].GetEnd().bTransientEndPoint = true;
					}
					I++;
					// [Loop Continue]
					goto J0x359;
				}
			}
			B.FindRandomDest();
			B.MoveTarget = B.RouteCache[0];
			B.SetAttractionState();
			return true;			
		}
		else
		{
			// End:0x50F
			if(UTVehicle(B.Pawn).bKeyVehicle && CloseEnoughToObjective(B, O))
			{
				return false;				
			}
			else
			{
				// End:0x530
				if(LeaveVehicleToReachObjective(B, O))
				{
					return true;
				}
			}
		}
	}
	// End:0x5F4
	if((Vehicle(B.Pawn) != none) && Objective != none)
	{
		I = 0;
		J0x579:

		// End:0x5F4 [Loop If]
		if(I < Objective.VehicleParkingSpots.Length)
		{
			Objective.VehicleParkingSpots[I].bTransientEndPoint = true;
			I++;
			// [Loop Continue]
			goto J0x579;
		}
	}
	// End:0x6A5
	if((O != RouteObjective) || (UTVehicle(B.Pawn) != none) && UTVehicle(B.Pawn).ImportantVehicle())
	{
		return B.SetRouteToGoal(O);
	}
	// End:0xC43
	if((B.bUsePreviousSquadRoute! && B.bFinalStretch!) && bShouldUseGatherPoints)
	{
		// End:0x88A
		if((B.bReachedGatherPoint! && (B.Enemy == none) || B.LostContact(1.0000000)) && B.Pawn.ValidAnchor())
		{
			RouteIndex = ObjectiveRouteCache.Find(B.Pawn.Anchor);
			// End:0x88A
			if((RouteIndex != -1) && float(RouteIndex) > (float(ObjectiveRouteCache.Length) * 0.7000000))
			{
				B.bReachedGatherPoint = true;
				B.GatherTime = WorldInfo.TimeSeconds;
			}
		}
		// End:0xC43
		if(B.bReachedGatherPoint)
		{
			GatherWaitTime = (((B.Enemy == none) || B.LineOfSightTo(B.Enemy)!) ? 8.0000000 : 3.0000000);
			bDoneGathering = true;
			// End:0xA84
			if((WorldInfo.TimeSeconds - B.GatherTime) <= GatherWaitTime)
			{
				M = SquadMembers;
				J0x990:

				// End:0xA84 [Loop If]
				if(M != none)
				{
					// End:0xA59
					if(((M.bReachedGatherPoint! && M.bFinalStretch!) && M.Pawn != none) && M.Pawn.bStationary!)
					{
						bDoneGathering = false;
						// [Explicit Break]
						goto J0xA84;
					}
					M = M.NextSquadMember;
					// [Loop Continue]
					goto J0x990;
				}
			}
			J0xA84:

			// End:0xB02
			if(bDoneGathering)
			{
				M = SquadMembers;
				J0xAA4:

				// End:0xAFF [Loop If]
				if(M != none)
				{
					M.bFinalStretch = true;
					M = M.NextSquadMember;
					// [Loop Continue]
					goto J0xAA4;
				}				
			}
			else
			{
				// End:0xBB7
				if(B.Enemy != none)
				{
					// End:0xB6C
					if(B.LostContact(7.0000000))
					{
						B.LoseEnemy();
					}
					// End:0xBB7
					if(B.Enemy != none)
					{
						B.FightEnemy(false, 0.0000000);
						return true;
					}
				}
				B.GoalString = "Wait for more friendly attackers before continuing on path to" @ string(O);
				B.WanderOrCamp();
				return true;
			}
		}
	}
	B.MoveTarget = B.FindPathToSquadRoute((B.Pawn.bCanPickupInventory && Vehicle(B.Pawn) == none) && B.bForceNoDetours!);
	return B.StartMoveToward(O);
	//return ReturnValue;	
}

event SetLeader(Controller C)
{
	SquadLeader = C;
	// End:0x7C
	if(LeaderPRI != C.PlayerReplicationInfo)
	{
		LeaderPRI = UTPlayerReplicationInfo(C.PlayerReplicationInfo);
		bForceNetUpdate = true;
	}
	// End:0xB0
	if(UTBot(C) != none)
	{
		AddBot(UTBot(C));
	}
	//return;	
}

function RemovePlayer(PlayerController P)
{
	local UTGameObjective NewObjective;

	// End:0x19
	if(SquadLeader != P)
	{
		return;
	}
	// End:0x2D
	if(SquadMembers == none)
	{
		Destroy();
		return;
	}
	NewObjective = UTTeamInfo(Team).AI.GetPriorityAttackObjectiveFor(self, none);
	// End:0xAC
	if(NewObjective != SquadObjective)
	{
		SquadObjective = NewObjective;
		bForceNetUpdate = true;
	}
	PickNewLeader();
	//return;	
}

function RemoveBot(UTBot B)
{
	local UTBot Prev;

	// End:0x26
	if(B.Squad != self)
	{
		return;
	}
	B.Squad = none;
	Size--;
	// End:0xA7
	if(SquadMembers == B)
	{
		SquadMembers = B.NextSquadMember;
		// End:0xA4
		if(SquadMembers == none)
		{
			Destroy();
			return;
		}		
	}
	else
	{
		Prev = SquadMembers;
		J0xBA:

		// End:0x160 [Loop If]
		if(Prev != none)
		{
			// End:0x135
			if(Prev.NextSquadMember == B)
			{
				Prev.NextSquadMember = B.NextSquadMember;
				// [Explicit Break]
				goto J0x160;
			}
			Prev = Prev.NextSquadMember;
			// [Loop Continue]
			goto J0xBA;
		}
	}
	J0x160:

	// End:0x181
	if(SquadLeader == B)
	{
		PickNewLeader();
	}
	//return;	
}

function AddBot(UTBot B)
{
	// End:0x26
	if(B.Squad == self)
	{
		return;
	}
	// End:0x90
	if(B.Squad != none)
	{
		UTSquadAI(B.Squad).RemoveBot(B);
	}
	Size++;
	B.NextSquadMember = SquadMembers;
	SquadMembers = B;
	B.Squad = self;
	// End:0x161
	if(UTPlayerReplicationInfo(B.PlayerReplicationInfo) != none)
	{
		UTPlayerReplicationInfo(B.PlayerReplicationInfo).Squad = self;
	}
	//return;	
}

function SetDefenseScriptFor(UTBot B)
{
	local UTDefensePoint OldPoint, S;
	local bool bPrioritizeSameGroup, bAutoPointsInUse, bAllDefenseGroupsCovered;
	local int NumChecked;
	local UTBot OtherBot;
	local array<name> DefendedGroups;
	local UTGameObjective UTObjective;

	// End:0x1D0
	if(((B.DefensePoint != none) && SquadObjective == B.DefensePoint.DefendedObjective) && B.DefensePoint.bOnlyOnFoot! || Vehicle(B.Pawn) == none)
	{
		// End:0x1D0
		if(((B.Enemy != none) || (WorldInfo.TimeSeconds - FMax(B.LastSeenTime, B.AcquireTime)) < 5.0000000) || B.Pawn.ReachedDestination(B.DefensePoint.GetMoveTarget())!)
		{
			return;
		}
	}
	// End:0x256
	if((B.DefensePoint != none) && B.DefensePoint.DefendedObjective != SquadObjective)
	{
		B.FreePoint();
	}
	// End:0x41A
	foreach WorldInfo.AllControllers(Class'UTGame.UTBot', OtherBot)
	{
		// End:0x419
		if(((OtherBot.PlayerReplicationInfo != none) && OtherBot.PlayerReplicationInfo.Team == Team) && OtherBot != B)
		{
			// End:0x3C5
			if((OtherBot.DefensePoint != none) && DefendedGroups.Find(OtherBot.DefensePoint.DefenseGroup) == -1)
			{
				DefendedGroups[DefendedGroups.Length] = OtherBot.DefensePoint.DefenseGroup;
				// End:0x419
				continue;
			}
			// End:0x419
			if((OtherBot.DefensivePosition != none) && OtherBot.IsDefending())
			{
				bAutoPointsInUse = true;
			}
		}		
	}	
	// End:0x4AF
	if(B.DefensePoint != none)
	{
		OldPoint = B.DefensePoint;
		B.DefensePoint.FreePoint();
		bPrioritizeSameGroup = FRand() < 0.8500000;
	}
	NumChecked = 1;
	bAllDefenseGroupsCovered = true;
	UTObjective = UTGameObjective(SquadObjective);
	S = UTObjective.DefensePoints;
	J0x50A:

	// End:0x62C [Loop If]
	if(S != none)
	{
		// End:0x601
		if((S != OldPoint) && DefendedGroups.Find(S.DefenseGroup) == -1)
		{
			bAllDefenseGroupsCovered = false;
			// End:0x601
			if(S.HigherPriorityThan(B.DefensePoint, B, bAutoPointsInUse, bPrioritizeSameGroup, NumChecked))
			{
				B.DefensePoint = S;
			}
		}
		S = S.NextDefensePoint;
		// [Loop Continue]
		goto J0x50A;
	}
	// End:0x75C
	if(bAllDefenseGroupsCovered && bAutoPointsInUse)
	{
		NumChecked = 1;
		S = UTObjective.DefensePoints;
		J0x67B:

		// End:0x75C [Loop If]
		if(S != none)
		{
			// End:0x731
			if((S != OldPoint) && S.HigherPriorityThan(B.DefensePoint, B, bAutoPointsInUse, bPrioritizeSameGroup, NumChecked))
			{
				B.DefensePoint = S;
			}
			S = S.NextDefensePoint;
			// [Loop Continue]
			goto J0x67B;
		}
	}
	// End:0x7BD
	if(B.DefensePoint != none)
	{
		B.DefensePoint.CurrentUser = B;
	}
	//return;	
}

function SetObjective(UTGameObjective O, bool bForceUpdate)
{
	local UTBot M;
	local UTGameObjective UTObjective;

	// End:0xC5
	if(SquadObjective == O)
	{
		// End:0x28
		if(SquadObjective == none)
		{
			return;
		}
		// End:0xB1
		if((int(O.DefenderTeamIndex) == Team.TeamIndex) && O.DefenseSquad == none)
		{
			O.DefenseSquad = self;
		}
		// End:0xC2
		if(bForceUpdate!)
		{
			return;
		}		
	}
	else
	{
		UTObjective = UTGameObjective(SquadObjective);
		// End:0x17B
		if(((UTObjective != none) && int(UTObjective.DefenderTeamIndex) == Team.TeamIndex) && UTObjective.DefenseSquad == self)
		{
			UTObjective.DefenseSquad = none;
		}
		bForceNetUpdate = true;
		SquadObjective = O;
		// End:0x27A
		if(SquadObjective != none)
		{
			// End:0x232
			if((int(O.DefenderTeamIndex) == Team.TeamIndex) && O.DefenseSquad == none)
			{
				O.DefenseSquad = self;
			}
			RouteObjective = none;
			// End:0x27A
			if(UTBot(SquadLeader) != none)
			{
				SetAlternatePathTo(O, UTBot(SquadLeader));
			}
		}
	}
	M = SquadMembers;
	J0x28D:

	// End:0x2FE [Loop If]
	if(M != none)
	{
		// End:0x2D3
		if(M.Pawn != none)
		{
			Retask(M);
		}
		M = M.NextSquadMember;
		// [Loop Continue]
		goto J0x28D;
	}
	//return;	
}

function Retask(UTBot B)
{
	// End:0x163
	if(((Vehicle(B.Pawn) != none) && B.Pawn.bStationary) && B.Pawn.GetVehicleBase() == none)
	{
		Vehicle(B.Pawn).DriverLeave(false);
		B.bPreparingMove = false;
		B.MoveTarget = none;
		B.RouteGoal = none;
		B.WhatToDoNext();		
	}
	else
	{
		// End:0x2D0
		if(B.InLatentExecution(B.503))
		{
			// End:0x204
			if(B.bPreparingMove)
			{
				B.bPreparingMove = false;
				B.WhatToDoNext();				
			}
			else
			{
				// End:0x276
				if((int(B.Pawn.Physics) == int(2)) && UDKTrajectoryReachSpec(B.CurrentPath) != none)
				{
					return;					
				}
				else
				{
					// End:0x2CD
					if(B.MoveTimer > 0.3000000)
					{
						B.MoveTimer = 0.0500000 + (0.1500000 * FRand());
					}
				}
			}			
		}
		else
		{
			B.ReTaskTime = (WorldInfo.TimeSeconds + 0.0500000) + (0.1500000 * FRand());
			GotoState('Retasking');
		}
	}
	//return;	
}

function name GetOrders()
{
	local name NewOrders;

	// End:0x2E
	if(PlayerController(SquadLeader) != none)
	{
		NewOrders = 'Human';		
	}
	else
	{
		// End:0x73
		if((bFreelance && bFreelanceAttack!) && bFreelanceDefend!)
		{
			NewOrders = 'Freelance';			
		}
		else
		{
			// End:0xDD
			if((SquadObjective != none) && int(SquadObjective.DefenderTeamIndex) == Team.TeamIndex)
			{
				NewOrders = 'Defend';				
			}
			else
			{
				NewOrders = 'ATTACK';
			}
		}
	}
	// End:0x126
	if(NewOrders != CurrentOrders)
	{
		bForceNetUpdate = true;
		CurrentOrders = NewOrders;
	}
	return CurrentOrders;
	//return ReturnValue;	
}

simulated function string GetOrderStringFor(UTPlayerReplicationInfo PRI)
{
	// End:0x96
	if((LeaderPRI != none) && LeaderPRI.bBot!)
	{
		// End:0x61
		if(PRI.bHolding)
		{
			return HoldString;
		}
		return (SupportString @ LeaderPRI.PlayerName) @ SupportStringTrailer;
	}
	// End:0xC1
	if(bFreelance || SquadObjective == none)
	{
		return FreelanceString;		
	}
	else
	{
		GetOrders();
		// End:0x10D
		if(CurrentOrders == 'Defend')
		{
			return DefendString @ SquadObjective.GetHumanReadableName();
		}
		// End:0x14F
		if(CurrentOrders == 'ATTACK')
		{
			return AttackString @ SquadObjective.GetHumanReadableName();
		}
	}
	return string(CurrentOrders);
	//return ReturnValue;	
}

simulated function string GetShortOrderStringFor(UTPlayerReplicationInfo PRI)
{
	// End:0x6B
	if((LeaderPRI != none) && LeaderPRI.bBot!)
	{
		// End:0x61
		if(PRI.bHolding)
		{
			return HoldString;
		}
		return SupportString;
	}
	// End:0x96
	if(bFreelance || SquadObjective == none)
	{
		return FreelanceString;		
	}
	else
	{
		GetOrders();
		// End:0xC1
		if(CurrentOrders == 'Defend')
		{
			return DefendString;
		}
		// End:0xE2
		if(CurrentOrders == 'ATTACK')
		{
			return AttackString;
		}
	}
	return string(CurrentOrders);
	//return ReturnValue;	
}

function int GetSize()
{
	// End:0x28
	if(PlayerController(SquadLeader) != none)
	{
		return Size + 1;		
	}
	else
	{
		return Size;
	}
	//return ReturnValue;	
}

function PickNewLeader()
{
	local UTBot B;

	B = SquadMembers;
	J0x13:

	// End:0x126 [Loop If]
	if(B != none)
	{
		// End:0xFB
		if(B.PlayerReplicationInfo.bOutOfLives! && ((B.Pawn == none) || B.Pawn.bStationary!) || B.Pawn.GetVehicleBase() == none)
		{
			// [Explicit Break]
			goto J0x126;
		}
		B = B.NextSquadMember;
		// [Loop Continue]
		goto J0x13;
	}
	J0x126:

	// End:0x1BE
	if(B == none)
	{
		B = SquadMembers;
		J0x148:

		// End:0x1BE [Loop If]
		if(B != none)
		{
			// End:0x193
			if(B.PlayerReplicationInfo.bOutOfLives!)
			{
				// [Explicit Break]
				goto J0x1BE;
			}
			B = B.NextSquadMember;
			// [Loop Continue]
			goto J0x148;
		}
	}
	J0x1BE:

	// End:0x242
	if(SquadLeader != B)
	{
		SquadLeader = B;
		// End:0x205
		if(SquadLeader == none)
		{
			LeaderPRI = none;			
		}
		else
		{
			LeaderPRI = UTPlayerReplicationInfo(SquadLeader.PlayerReplicationInfo);
		}
		bForceNetUpdate = true;
	}
	//return;	
}

function bool TellBotToFollow(UTBot B, Controller C)
{
	local Pawn Leader;
	local UTGameObjective O, Best;
	local float newdist, bestDist;
	local UTTeamAI TeamAI;

	// End:0x50
	if((C == none) || C.bDeleteMe)
	{
		PickNewLeader();
		C = SquadLeader;
	}
	// End:0x69
	if(B == C)
	{
		return false;
	}
	B.GoalString = "Follow Leader";
	Leader = C.Pawn;
	// End:0xD0
	if(Leader == none)
	{
		return false;
	}
	// End:0x5B0
	if(CloseToLeader(B.Pawn))
	{
		// End:0x18C
		if(B.bInitLifeMessage!)
		{
			B.bInitLifeMessage = true;
			B.SendMessage(SquadLeader.PlayerReplicationInfo, 'GOTYOURBACK', 10.0000000);
		}
		// End:0x4EA
		if(B.Enemy == none)
		{
			TeamAI = UTTeamInfo(Team).AI;
			O = TeamAI.Objectives;
			J0x209:

			// End:0x3B8 [Loop If]
			if(O != none)
			{
				// End:0x38D
				if((O.bIsDisabled! && O.Shootable()) && (Best == none) || int(Best.DefensePriority) < int(O.DefensePriority))
				{
					newdist = VSize(B.Pawn.Location - O.Location);
					// End:0x38D
					if(((Best == none) || newdist < bestDist) && B.LineOfSightTo(O))
					{
						Best = O;
						bestDist = newdist;
					}
				}
				O = O.NextObjective;
				// [Loop Continue]
				goto J0x209;
			}
			// End:0x47E
			if(Best != none)
			{
				// End:0x43A
				if(int(Best.DefenderTeamIndex) != Team.TeamIndex)
				{
					// End:0x437
					if(Best.TellBotHowToDisable(B))
					{
						return true;
					}					
				}
				else
				{
					// End:0x47E
					if((bestDist < float(1600)) && Best.TellBotHowToHeal(B))
					{
						return true;
					}
				}
			}
			// End:0x4C6
			if(B.FindInventoryGoal(0.0004000))
			{
				B.SetAttractionState();
				return true;
			}
			B.WanderOrCamp();
			return true;			
		}
		else
		{
			// End:0x5AB
			if((UTWeapon(B.Pawn.Weapon) != none) && UTWeapon(B.Pawn.Weapon).FocusOnLeader(false))
			{
				B.FightEnemy(false, 0.0000000);
				return true;
			}
		}
		return false;		
	}
	else
	{
		// End:0x5E0
		if(B.SetRouteToGoal(Leader))
		{
			return true;			
		}
		else
		{
			B.GoalString = "Can't reach leader";
			return false;
		}
	}
	//return ReturnValue;	
}

function bool AllowTaunt(UTBot B)
{
	return FRand() < (0.5000000 - (0.0600000 * B.Skill));
	//return ReturnValue;	
}

function AddTransientCosts(UTBot B, float F)
{
	local UTBot S;

	S = SquadMembers;
	J0x13:

	// End:0x122 [Loop If]
	if(S != none)
	{
		// End:0xF7
		if(((S != B) && NavigationPoint(S.MoveTarget) != none) && S.InLatentExecution(S.503))
		{
			NavigationPoint(S.MoveTarget).TransientCost = int(float(1000) * F);
		}
		S = S.NextSquadMember;
		// [Loop Continue]
		goto J0x13;
	}
	//return;	
}

function bool AssignSquadResponsibility(UTBot B)
{
	// End:0x33
	if(PendingSquadRouteMaker == B)
	{
		SetAlternatePathTo(SquadObjective, B);
	}
	// End:0x9C
	if(((GetOrders()) == 'Defend') && B.Pawn.bStationary!)
	{
		SetDefenseScriptFor(B);		
	}
	else
	{
		// End:0x10E
		if((B.DefensePoint != none) && UTHoldSpot(B.DefensePoint) == none)
		{
			B.FreePoint();
		}
	}
	// End:0x133
	if(bAddTransientCosts)
	{
		AddTransientCosts(B, 1.0000000);
	}
	// End:0x14B
	if(CheckSquadObjectives(B))
	{
		return true;
	}
	// End:0x252
	if((B.Enemy == none) && B.Pawn.bStationary!)
	{
		// End:0x1F2
		if(B.FindInventoryGoal(0.0000000))
		{
			B.SetAttractionState();
			return true;
		}
		// End:0x252
		if(((B == SquadLeader) && bRoamingSquad) || (GetOrders()) == 'Freelance')
		{
			return B.FindRoamDest();
		}
	}
	return false;
	//return ReturnValue;	
}

function float MaxVehicleDist(Pawn P)
{
	// End:0x7B
	if((SquadObjective != none) && MustCompleteOnFoot(SquadObjective, P))
	{
		return FMin(3000.0000000, VSize(SquadObjective.Location - P.Location));		
	}
	else
	{
		return 3000.0000000;
	}
	//return ReturnValue;	
}

function bool AllowContinueOnFoot(UTBot B, UTVehicle V)
{
	local int I;
	local UTBot OtherB;
	local UTSquadAI S;
	local UTTeamAI TeamAI;

	// End:0x24
	if(V.bShouldLeaveForCombat)
	{
		return true;
	}
	// End:0x48
	if(V.bKeyVehicle)
	{
		return false;
	}
	// End:0xC3
	if((GetOrders()) == 'Defend')
	{
		// End:0xC3
		if((B.Enemy != none) && B.LineOfSightTo(B.Enemy))
		{
			return false;
		}
	}
	// End:0x321
	if(((CurrentOrders != 'ATTACK') && B.IsInState('Defending')) && (B.DefensePoint != none) || B.DefensivePosition != none)
	{
		// End:0x284
		if(((B.DefensePoint != none) && VSize(B.DefensePoint.Location - V.Location) < 1000.0000000) && FastTrace(B.DefensePoint.Location, V.Location))
		{
			B.DefensivePosition = B.Pawn.Anchor;
			return false;			
		}
		else
		{
			// End:0x321
			if(AcceptableDefensivePosition(B.Pawn.Anchor, B))
			{
				B.DefensivePosition = B.Pawn.Anchor;
				return false;
			}
		}
	}
	// End:0x5FD
	if(V.ImportantVehicle())
	{
		// End:0x354
		if(SquadObjective == none)
		{
			return false;
		}
		V.NoPassengerObjective = SquadObjective;
		I = 1;
		J0x387:

		// End:0x500 [Loop If]
		if(I < V.Seats.Length)
		{
			// End:0x4F2
			if(V.Seats[I].SeatPawn != none)
			{
				OtherB = UTBot(V.Seats[I].SeatPawn.Controller);
				// End:0x4F2
				if((OtherB != none) && OtherB != B)
				{
					OtherB.RouteGoal = SquadObjective;
					OtherB.NoVehicleGoal = SquadObjective;
					OtherB.LeaveVehicle(true);
					return false;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x387;
		}
		// End:0x52B
		if((Size > 1) && PlayerController(SquadLeader) == none)
		{
			return false;
		}
		TeamAI = UTTeamInfo(Team).AI;
		S = TeamAI.Squads;
		J0x584:

		// End:0x5FD [Loop If]
		if(S != none)
		{
			// End:0x5D2
			if((S != self) && S.SquadObjective == SquadObjective)
			{
				return false;
			}
			S = S.NextSquad;
			// [Loop Continue]
			goto J0x584;
		}
	}
	return true;
	//return ReturnValue;	
}

function bool NeverBail(Pawn P)
{
	return (UTVehicle(P) != none) && UTVehicle(P).bKeyVehicle;
	//return ReturnValue;	
}

function BotEnteredVehicle(UTBot B)
{
	// End:0xC7
	if(PlayerController(SquadLeader) != none)
	{
		// End:0xC4
		if((SquadLeader.Pawn != none) && B.Pawn.GetVehicleBase() == SquadLeader.Pawn)
		{
			B.SendMessage(none, 'InPosition', 10.0000000);
		}		
	}
	else
	{
		// End:0x144
		if(B.Pawn.bStationary && B.Pawn.GetVehicleBase() != none)
		{
			PickNewLeader();
		}
	}
	//return;	
}

function bool IsOnPathToSquadObjective(Actor Goal)
{
	local NavigationPoint Nav;
	local UTGameObjective UTObjective;

	// End:0x1C
	if(Goal == SquadObjective)
	{
		return true;		
	}
	else
	{
		Nav = NavigationPoint(Goal);
		// End:0x130
		if(Nav != none)
		{
			UTObjective = UTGameObjective(SquadObjective);
			// End:0x130
			if(((UTObjective.VehicleParkingSpots.Find(Nav) != -1) || UTObjective.Shootable() && UTObjective.ShootSpots.Find(Nav) != -1) || (UTObjective == RouteObjective) && ObjectiveRouteCache.Find(Nav) != -1)
			{
				return true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

function bool GetOnHoverboard(UTBot B)
{
	local UTPawn P;

	P = UTPawn(B.Pawn);
	// End:0x5F
	if(P != none)
	{
		P.ServerHoverboard();
	}
	return true;
	//return ReturnValue;	
}

function bool EnterAndExitVehicle(UTBot B)
{
	local UTVehicle V;

	V = UTVehicle(B.RouteGoal);
	// End:0xC0
	if((V != none) && V.TryToDrive(B.Pawn))
	{
		Vehicle(B.Pawn).DriverLeave(false);
	}
	return true;
	//return ReturnValue;	
}

function bool GotoVehicle(UTVehicle SquadVehicle, UTBot B)
{
	local Actor BestEntry, BestPath;

	BestEntry = SquadVehicle.GetMoveTargetFor(B.Pawn);
	// End:0x166
	if((SquadVehicle.bHasCustomEntryRadius && SquadVehicle.InCustomEntryRadius(B.Pawn)) || B.Pawn.ReachedDestination(BestEntry))
	{
		// End:0x13C
		if(Vehicle(B.Pawn) != none)
		{
			B.LeaveVehicle(true);
			return true;
		}
		B.EnterVehicle(SquadVehicle);
		return true;
	}
	// End:0x2C5
	if(B.ActorReachable(BestEntry))
	{
		// End:0x1D9
		if(Vehicle(B.Pawn) != none)
		{
			B.LeaveVehicle(true);
			return true;
		}
		B.RouteGoal = SquadVehicle;
		B.MoveTarget = BestEntry;
		SquadVehicle.SetReservation(B);
		B.GoalString = (("Go to vehicle 1 " $ string(BestEntry)) $ " to ") $ string(SquadVehicle);
		B.SetAttractionState();
		return true;
	}
	BestPath = B.FindPathToward(BestEntry, B.Pawn.bCanPickupInventory);
	// End:0x429
	if(BestPath != none)
	{
		B.RouteGoal = SquadVehicle;
		SquadVehicle.SetReservation(B);
		B.MoveTarget = BestPath;
		B.GoalString = (("Go to vehicle 2 through " $ string(BestPath)) $ " to ") $ string(SquadVehicle);
		B.SetAttractionState();
		return true;
	}
	// End:0x5ED
	if((VSize(BestEntry.Location - B.Pawn.Location) < float(1200)) && B.LineOfSightTo(BestEntry))
	{
		// End:0x501
		if(Vehicle(B.Pawn) != none)
		{
			B.LeaveVehicle(true);
			return true;
		}
		B.RouteGoal = SquadVehicle;
		SquadVehicle.SetReservation(B);
		B.MoveTarget = BestEntry;
		B.GoalString = (("Go to vehicle 3 " $ string(BestEntry)) $ " to ") $ string(SquadVehicle);
		B.SetAttractionState();
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool CheckVehicle(UTBot B)
{
	local UTVehicle V, SquadVehicle;
	local Vehicle BotVehicle;
	local float newdist, bestDist, NewRating, BestRating, BaseRadius;

	local UTBot S;
	local PlayerController PC;
	local bool bSkip, bVisible;
	local UTSquadAI Squad;
	local UTTeamAI TeamAI;

	// End:0x2F
	if(UTHoldSpot(B.DefensePoint) != none)
	{
		return false;
	}
	// End:0x1D6
	if(B.NoVehicleGoal != none)
	{
		// End:0xE6
		if(B.NoVehicleGoal.IsA('UTCarriedObject'))
		{
			B.NoVehicleGoal = UTCarriedObject(B.NoVehicleGoal).LastAnchor;
		}
		// End:0x1B6
		if((Vehicle(B.Pawn) == none) && (B.RouteGoal == B.NoVehicleGoal) || (B.NoVehicleGoal == SquadObjective) && IsOnPathToSquadObjective(B.RouteGoal))
		{
			return false;			
		}
		else
		{
			B.NoVehicleGoal = none;
		}
	}
	// End:0x239
	if((B.PendingMover != none) && IsZero(B.PendingMover.Velocity)!)
	{
		return false;
	}
	// End:0x2F9
	if((UTVehicle(B.Pawn) != none) && UTVehicle(B.Pawn).CriticalChargeAttack(B))
	{
		B.GoalString = "Charge";
		B.DoCharge();
		return true;
	}
	// End:0x4DF
	if(((Vehicle(B.Pawn) == none) && Vehicle(B.RouteGoal) != none) && NavigationPoint(B.MoveTarget) != none)
	{
		// End:0x4DF
		if(VSize(B.Pawn.Location - B.RouteGoal.Location) < ((B.Pawn.GetCollisionRadius() + Vehicle(B.RouteGoal).GetCollisionRadius()) + (B.Pawn.VehicleCheckRadius * 1.5000000)))
		{
			B.MoveTarget = B.RouteGoal;
		}
	}
	V = UTVehicle(B.MoveTarget);
	// End:0xDBD
	if((((Vehicle(B.Pawn) == none) && V != none) && V.Health > 0) && V.bDeleteMe!)
	{
		// End:0x6D0
		if(V.PlayerStartTime > WorldInfo.TimeSeconds)
		{
			// End:0x6CF
			foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x6CE
				if(((PC.PlayerReplicationInfo.Team == Team) && PC.Pawn != none) && (Vehicle(PC.Pawn) == none) || UTVehicle_Hoverboard(PC.Pawn) != none)
				{
					bSkip = true;
					// End:0x6CF
					break;
				}				
			}			
		}
		// End:0xDBD
		if(bSkip!)
		{
			// End:0xB8D
			if((((V.Health < V.HealthMax) && WorldInfo.Game.bTeamGame) && (B.Enemy == none) || B.LineOfSightTo(B.Enemy)!) && B.CanAttack(V))
			{
				// End:0x888
				if(WorldInfo.GRI.OnSameTeam(V, self)!)
				{
					B.RouteGoal = V;
					B.PerformCustomAction(EnterAndExitVehicle);
					return true;
				}
				// End:0xB8D
				if(V.TeamLink(Team.TeamIndex))
				{
					// End:0xA07
					if((UTWeapon(B.Pawn.Weapon) != none) && UTWeapon(B.Pawn.Weapon).CanHeal(V))
					{
						B.GoalString = "Heal " $ string(V);
						B.LastCanAttackCheckTime = WorldInfo.TimeSeconds;
						B.DoRangedAttackOn(V);
						return true;						
					}
					else
					{
						B.SwitchToBestWeapon();
						// End:0xB8D
						if((UTWeapon(B.Pawn.InvManager.PendingWeapon) != none) && UTWeapon(B.Pawn.InvManager.PendingWeapon).CanHeal(V))
						{
							B.GoalString = "Heal " $ string(V);
							B.LastCanAttackCheckTime = WorldInfo.TimeSeconds;
							B.DoRangedAttackOn(V);
							return true;
						}
					}
				}
			}
			// End:0xBF4
			if(V.GetVehicleBase() != none)
			{
				BaseRadius = V.GetVehicleBase().GetCollisionRadius();				
			}
			else
			{
				BaseRadius = V.GetCollisionRadius();
			}
			// End:0xDBD
			if(((VSize(B.Pawn.Location - V.Location) < ((B.Pawn.GetCollisionRadius() + BaseRadius) + B.Pawn.VehicleCheckRadius)) || V.bHasCustomEntryRadius && V.InCustomEntryRadius(B.Pawn)) || B.Pawn.ReachedDestination(V))
			{
				B.EnterVehicle(V);
				return true;
			}
		}
	}
	// End:0xE00
	if(B.LastSearchTime == WorldInfo.TimeSeconds)
	{
		return false;
	}
	BotVehicle = Vehicle(B.Pawn);
	// End:0x1306
	if(BotVehicle != none)
	{
		// End:0x118E
		if(NeverBail(BotVehicle)!)
		{
			// End:0xF15
			if(int(BotVehicle.StuckCount) > int(3))
			{
				// End:0xEF0
				if(BotVehicle.IsA('UTVehicle'))
				{
					UTVehicle(BotVehicle).VehicleLostTime = WorldInfo.TimeSeconds + float(20);
				}
				B.LeaveVehicle(true);
				return true;				
			}
			else
			{
				// End:0x1070
				if(((float(BotVehicle.Health) < (float(BotVehicle.HealthMax) * 0.1250000)) && BotVehicle.bStationary!) && (B.Skill + B.Tactics) > (4.0000000 + (7.0000000 * FRand())))
				{
					// End:0x104B
					if(BotVehicle.IsA('UTVehicle'))
					{
						UTVehicle(BotVehicle).VehicleLostTime = WorldInfo.TimeSeconds + float(10);
					}
					B.LeaveVehicle(true);
					return true;					
				}
				else
				{
					V = UTVehicle(BotVehicle);
					// End:0x10CD
					if(V == none)
					{
						V = UTVehicle(BotVehicle.GetVehicleBase());
					}
					// End:0x118E
					if((((V != none) && B.Enemy != none) && V.ShouldLeaveForCombat(B)) && B.LineOfSightTo(B.Enemy))
					{
						B.LeaveVehicle(true);
						return true;
					}
				}
			}
		}
		V = UTVehicle(BotVehicle.GetVehicleBase());
		// End:0x12B3
		if(V != none)
		{
			// End:0x12B1
			if(((V.Driver == none) && ((SquadLeader == B) || SquadLeader.RouteGoal == none) || SquadLeader.RouteGoal != V) && V.IsDriverSeat(BotVehicle)!)
			{
				B.LeaveVehicle(true);
				return true;
			}
			return false;
		}
		V = UTVehicle(BotVehicle);
		// End:0x1306
		if((V == none) || V.bShouldLeaveForCombat!)
		{
			return false;
		}
	}
	V = UTVehicle(SquadLeader.Pawn);
	// End:0x14BB
	if(((((V != none) && VSize(V.Location - B.Pawn.Location) < 4000.0000000) && V.OpenPositionFor(B.Pawn)) && (V.NoPassengerObjective == none) || V.NoPassengerObjective != SquadObjective) && V.bCanCarryFlag || UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag!)
	{
		SquadVehicle = V;		
	}
	else
	{
		// End:0x14E7
		if(PlayerController(SquadLeader) != none)
		{
			return CheckHoverboard(B);
		}
	}
	bestDist = MaxVehicleDist(B.Pawn);
	// End:0x172E
	if(SquadVehicle == none)
	{
		S = SquadMembers;
		J0x153B:

		// End:0x172E [Loop If]
		if(S != none)
		{
			V = UTVehicle(S.Pawn);
			// End:0x1703
			if(((((V != none) && VSize(V.Location - B.Pawn.Location) < bestDist) && V.OpenPositionFor(B.Pawn)) && (V.NoPassengerObjective == none) || V.NoPassengerObjective != SquadObjective) && V.bCanCarryFlag || UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag!)
			{
				SquadVehicle = V;
				// [Explicit Break]
				goto J0x172E;
			}
			S = S.NextSquadMember;
			// [Loop Continue]
			goto J0x153B;
		}
	}
	J0x172E:

	// End:0x1919
	if(SquadVehicle == none)
	{
		V = UTVehicle(SquadLeader.RouteGoal);
		// End:0x1919
		if((((((V != none) && V.Occupied()!) && VSize(V.Location - B.Pawn.Location) < bestDist) && V.OpenPositionFor(B.Pawn)) && (V.NoPassengerObjective == none) || V.NoPassengerObjective != SquadObjective) && V.bCanCarryFlag || UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag!)
		{
			SquadVehicle = V;
		}
	}
	// End:0x1A35
	if(SquadVehicle == none)
	{
		V = UTVehicle(B.RouteGoal);
		// End:0x1A35
		if((((V != none) && V.Occupied()!) && VSize(V.Location - B.Pawn.Location) < (bestDist * 1.2000000)) && (VehicleDesireability(V, B)) > 0.0000000)
		{
			SquadVehicle = V;
		}
	}
	// End:0x1D28
	if((SquadVehicle == none) && Team != none)
	{
		TeamAI = UTTeamInfo(Team).AI;
		Squad = TeamAI.Squads;
		J0x1AAE:

		// End:0x1D28 [Loop If]
		if(Squad != none)
		{
			// End:0x1CFD
			if(Squad.SquadLeader != none)
			{
				V = UTVehicle(Squad.SquadLeader.Pawn);
				// End:0x1CFD
				if(((((((V != none) && V.bKeyVehicle) && V.NoPassengerObjective != Squad.SquadObjective) && VSize(V.Location - B.Pawn.Location) < 4000.0000000) && (Squad.GetOrders() == (GetOrders())) || PlayerController(Squad.SquadLeader) != none) && V.OpenPositionFor(B.Pawn)) && V.NumPassengers() < (Team.Size / 2))
				{
					SquadVehicle = V;
					// [Explicit Break]
					goto J0x1D28;
				}
			}
			Squad = Squad.NextSquad;
			// [Loop Continue]
			goto J0x1AAE;
		}
	}
	J0x1D28:

	// End:0x1E3F
	if((SquadVehicle != none) && SquadVehicle.PlayerStartTime > WorldInfo.TimeSeconds)
	{
		// End:0x1E3E
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x1E3D
			if(((PC.PlayerReplicationInfo.Team == Team) && PC.Pawn != none) && Vehicle(PC.Pawn) == none)
			{
				SquadVehicle = none;
				// End:0x1E3E
				break;
			}			
		}		
	}
	// End:0x21D3
	if(SquadVehicle == none)
	{
		GetOrders();
		V = UTGame(WorldInfo.Game).VehicleList;
		J0x1E9E:

		// End:0x21D3 [Loop If]
		if(V != none)
		{
			newdist = VSize(B.Pawn.Location - V.Location);
			// End:0x21A8
			if(newdist < bestDist)
			{
				bVisible = V.FastTrace(V.Location, B.Pawn.Location + (B.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)));
				// End:0x1FFD
				if(bVisible!)
				{
					newdist *= 1.5000000;
				}
				// End:0x21A8
				if(newdist < bestDist)
				{
					NewRating = VehicleDesireability(V, B);
					// End:0x21A8
					if(NewRating > 0.0000000)
					{
						NewRating += ((bestDist / newdist) * 0.0100000);
						// End:0x21A8
						if((NewRating > BestRating) && ((V.bTeamLocked || V.bKeyVehicle) || bVisible) || (V.ParentFactory != none) && VSize(V.Location - V.ParentFactory.Location) < V.GetCollisionRadius())
						{
							SquadVehicle = V;
							BestRating = NewRating;
						}
					}
				}
			}
			V = V.NextVehicle;
			// [Loop Continue]
			goto J0x1E9E;
		}
	}
	// End:0x21F6
	if(SquadVehicle == none)
	{
		return CheckHoverboard(B);
	}
	return GotoVehicle(SquadVehicle, B);
	//return ReturnValue;	
}

function bool CheckHoverboard(UTBot B)
{
	local UTPawn P;

	P = UTPawn(B.Pawn);
	// End:0x597
	if((((((((((((((P != none) && P.bHasHoverboard) && P.Anchor != none) && UTGameObjective(P.Anchor) == none) && (WorldInfo.TimeSeconds - B.LastTryHoverboardTime) > 4.0000000) && UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag || B.NeedWeapon()!) && ShouldUseHoverboard(B)) && B.Pawn.IsFiring()!) && B.IsShootingObjective()!) && B.IsDefending()! || ((B.DefensePoint == none) || VSize(B.DefensePoint.Location - P.Location) > 1600.0000000) && (B.DefensivePosition == none) || VSize(B.DefensivePosition.Location - P.Location) > 1600.0000000) && (SquadObjective == none) || (VSize(SquadObjective.Location - P.Location) > 1200.0000000) && B.ActorReachable(SquadObjective)!) && P.HoverboardClass.default.CylinderComponent.CollisionRadius <= P.Anchor.MaxPathSize.Radius) && P.HoverboardClass.default.CylinderComponent.CollisionHeight <= P.Anchor.MaxPathSize.Height) && LiftCenter(P.Anchor) == none)
	{
		B.LastTryHoverboardTime = WorldInfo.TimeSeconds;
		B.GoalString = "Get on hoverboard";
		B.PerformCustomAction(GetOnHoverboard);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool ShouldUseHoverboard(UTBot B)
{
	local UTBot EnemyBot;

	// End:0x29
	if(B.LostContact(2.0000000))
	{
		return true;
	}
	// End:0xB1
	if((WorldInfo.TimeSeconds - FMax(B.LastUnderFire, UTPawn(B.Pawn).AccumulationTime)) < 2.0000000)
	{
		return false;
	}
	// End:0x229
	foreach WorldInfo.AllControllers(Class'UTGame.UTBot', EnemyBot)
	{
		// End:0x228
		if(((EnemyBot.Enemy == B.Pawn) && EnemyBot.Focus == B.Pawn) && UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag! || VSize(EnemyBot.Pawn.Location - B.Pawn.Location) < float(3000))
		{			
			return false;
		}		
	}	
	return ((PlayerController(B.Enemy.Controller) != none) && VSize(B.Enemy.Location - B.Pawn.Location) > float(1600)) && (Vector(B.Enemy.Controller.Rotation) Dot (B.Pawn.Location - B.Enemy.Location)) < 0.7500000;
	//return ReturnValue;	
}

function float VehicleDesireability(UTVehicle V, UTBot B)
{
	local float Result;

	// End:0x6C
	if(UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag && V.bCanCarryFlag!)
	{
		return 0.0000000;
	}
	// End:0x10D
	if(int(V.AIPurpose) != int(2))
	{
		// End:0xDE
		if(CurrentOrders == 'Defend')
		{
			// End:0xDB
			if(int(V.AIPurpose) != int(1))
			{
				return 0.0000000;
			}			
		}
		else
		{
			// End:0x10D
			if(int(V.AIPurpose) != int(0))
			{
				return 0.0000000;
			}
		}
	}
	// End:0x1C2
	if(((float(V.Health) < (float(V.HealthMax) * 0.1250000)) && B.Enemy != none) && B.LineOfSightTo(B.Enemy))
	{
		return 0.0000000;
	}
	Result = V.BotDesireability(self, ((Team != none) ? Team.TeamIndex : 255), SquadObjective);
	// End:0x29D
	if(V.SpokenFor(B))
	{
		return Result * V.ReservationCostMultiplier(B.Pawn);		
	}
	else
	{
		return Result;
	}
	//return ReturnValue;	
}

function bool OverrideFollowPlayer(UTBot B)
{
	local UTGameObjective PickedObjective;
	local UTTeamAI TeamAI;

	TeamAI = UTTeamInfo(Team).AI;
	PickedObjective = TeamAI.GetPriorityAttackObjectiveFor(self, B);
	// End:0x75
	if(PickedObjective == none)
	{
		return false;
	}
	// End:0x138
	if(PickedObjective.BotNearObjective(B))
	{
		// End:0x10F
		if(int(PickedObjective.DefenderTeamIndex) == Team.TeamIndex)
		{
			return PickedObjective.TellBotHowToHeal(B);			
		}
		else
		{
			return PickedObjective.TellBotHowToDisable(B);
		}
	}
	// End:0x17D
	if(int(PickedObjective.DefenderTeamIndex) == Team.TeamIndex)
	{
		return false;
	}
	// End:0x1F0
	if(PickedObjective.Shootable() && B.LineOfSightTo(PickedObjective))
	{
		return PickedObjective.TellBotHowToDisable(B);
	}
	return false;
	//return ReturnValue;	
}

function bool ShouldCheckSuperVehicle(UTBot B)
{
	local UTVehicle BotVehicle;

	BotVehicle = UTVehicle(B.Pawn);
	return (BotVehicle == none) || BotVehicle.ImportantVehicle()!;
	//return ReturnValue;	
}

function bool CheckSuperItem(UTBot B, float SuperDist)
{
	local bool bFoundSomething, bReallyNeedVehicle;
	local int I;
	local UTVehicleFactory VFactory;
	local UTVehicle V, ChildVehicle;
	local UTGame Game;
	local float Dist;
	local UTTeamAI TeamAI;

	TeamAI = UTTeamInfo(Team).AI;
	// End:0x74
	if(TeamAI.bFoundSuperItems!)
	{
		TeamAI.FindSuperItems();
	}
	B.RespawnPredictionTime = ((B.Skill > 5.0000000) ? 2.0000000 : 0.0000000);
	// End:0x5DF
	if(ShouldCheckSuperVehicle(B))
	{
		bReallyNeedVehicle = (Vehicle(B.Pawn) == none) || (UTVehicle(B.Pawn) != none) && UTVehicle(B.Pawn).bShouldLeaveForCombat;
		I = 0;
		J0x18E:

		// End:0x367 [Loop If]
		if(I < TeamAI.ImportantVehicleFactories.Length)
		{
			VFactory = TeamAI.ImportantVehicleFactories[I];
			ChildVehicle = UTVehicle(VFactory.ChildVehicle);
			// End:0x359
			if(((((ChildVehicle != none) && ChildVehicle.bHasBeenDriven!) && ChildVehicle.SpokenFor(B)!) && (VehicleDesireability(ChildVehicle, B)) > 0.0000000) && bReallyNeedVehicle || ChildVehicle.bKeyVehicle)
			{
				VFactory.bTransientEndPoint = true;
				bFoundSomething = true;
				// End:0x359
				if(UTVehicle(VFactory.ChildVehicle).bKeyVehicle)
				{
					SuperDist = 16000.0000000;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x18E;
		}
		Game = UTGame(WorldInfo.Game);
		// End:0x5DF
		if(Game != none)
		{
			V = Game.VehicleList;
			J0x3CF:

			// End:0x5DF [Loop If]
			if(V != none)
			{
				// End:0x5B4
				if(((V.bKeyVehicle && V.bHasBeenDriven!) && V.ParentFactory == none) && (VehicleDesireability(V, B)) > 0.0000000)
				{
					// End:0x51D
					if(V.ValidAnchor()!)
					{
						V.SetAnchor(B.Pawn.GetBestAnchor(V, V.Location, false, true, Dist));
					}
					// End:0x583
					if(V.Anchor != none)
					{
						V.Anchor.bTransientEndPoint = true;
						bFoundSomething = true;
					}
					// End:0x5B4
					if(V.bKeyVehicle)
					{
						SuperDist = 16000.0000000;
					}
				}
				V = V.NextVehicle;
				// [Loop Continue]
				goto J0x3CF;
			}
		}
	}
	// End:0x747
	if(bFoundSomething! && B.Skill > 3.5000000)
	{
		I = 0;
		J0x623:

		// End:0x747 [Loop If]
		if(I < TeamAI.NumSuperPickups)
		{
			// End:0x739
			if(((TeamAI.SuperPickups[I] != none) && TeamAI.SuperPickups[I].ReadyToPickup(B.RespawnPredictionTime)) && B.SuperPickupNotSpokenFor(TeamAI.SuperPickups[I]))
			{
				bFoundSomething = true;
				// [Explicit Break]
				goto J0x747;
			}
			I++;
			// [Loop Continue]
			goto J0x623;
		}
	}
	J0x747:

	return bFoundSomething && B.FindSuperPickup(SuperDist);
	//return ReturnValue;	
}

function bool CheckSquadObjectives(UTBot B)
{
	local Actor DesiredPosition;
	local bool bInPosition, bCheckSuperPickups, bMovingToSuperPickup;
	local float SuperDist;
	local Vehicle V;
	local UTGameObjective UTObjective;

	// End:0x13C
	if((((WorldInfo.TimeSeconds - B.Pawn.CreationTime) < 5.0000000) && B.NeedWeapon()) && B.FindInventoryGoal(0.0004000))
	{
		B.GoalString = "Need weapon or ammo";
		B.NoVehicleGoal = B.RouteGoal;
		B.SetAttractionState();
		return true;
	}
	// End:0x154
	if(CheckVehicle(B))
	{
		return true;
	}
	// End:0x231
	if(B.NeedWeapon() && B.FindInventoryGoal(0.0000000))
	{
		B.GoalString = "Need weapon or ammo";
		B.NoVehicleGoal = B.RouteGoal;
		B.SetAttractionState();
		return true;
	}
	// End:0x2D1
	if((PlayerController(SquadLeader) != none) && SquadLeader.Pawn != none)
	{
		// End:0x2D1
		if(UTHoldSpot(B.DefensePoint) == none)
		{
			// End:0x2B4
			if(OverrideFollowPlayer(B))
			{
				return true;
			}
			return TellBotToFollow(B, SquadLeader);
		}
	}
	// End:0x513
	if(B.Pawn.bStationary && Vehicle(B.Pawn) != none)
	{
		// End:0x45F
		if(UTHoldSpot(B.DefensePoint) != none)
		{
			// End:0x45C
			if((UTHoldSpot(B.DefensePoint).HoldVehicle != B.Pawn) && UTHoldSpot(B.DefensePoint).HoldVehicle != B.Pawn.GetVehicleBase())
			{
				B.LeaveVehicle(true);
				return true;
			}			
		}
		else
		{
			// End:0x513
			if((UTVehicle(B.Pawn) != none) && UTVehicle(B.Pawn).bKeyVehicle)
			{
				// End:0x511
				if(B.DefensePoint != none)
				{
					B.FreePoint();
				}
				return false;
			}
		}
	}
	V = Vehicle(B.Pawn);
	// End:0xD88
	if(B.Skill > 0.5000000)
	{
		// End:0x5B2
		if(B.Pawn.bCanPickupInventory)
		{
			bCheckSuperPickups = true;			
		}
		else
		{
			// End:0x696
			if((((V != none) && V.Driver != none) && V.Driver.bCanPickupInventory) && (UTVehicle(V) == none) || UTVehicle(V).bKeyVehicle!)
			{
				bCheckSuperPickups = true;
				B.bCheckDriverPickups = true;
			}
		}
		// End:0xD88
		if(bCheckSuperPickups)
		{
			// End:0x702
			if((UTHoldSpot(B.DefensePoint) != none) || int(PriorityObjective(B)) > int(0))
			{
				SuperDist = 800.0000000;				
			}
			else
			{
				// End:0x770
				if(((((GetOrders()) == 'Freelance') || bFreelanceAttack) || bFreelanceDefend) && B.HasTimedPowerup()!)
				{
					SuperDist = 10000000.0000000;					
				}
				else
				{
					// End:0x7F2
					if(CurrentOrders == 'ATTACK')
					{
						SuperDist = ((((SquadObjective == none) && B == SquadLeader) && B.Skill >= 4.0000000) ? 6000.0000000 : 3000.0000000);						
					}
					else
					{
						// End:0x841
						if((CurrentOrders == 'Defend') && B.Enemy != none)
						{
							SuperDist = 1200.0000000;							
						}
						else
						{
							SuperDist = 3200.0000000;
						}
					}
				}
			}
			bMovingToSuperPickup = ((((PickupFactory(B.RouteGoal) != none) && PickupFactory(B.RouteGoal).bIsSuperItem) && B.RouteDist < (1.1000000 * SuperDist)) && PickupFactory(B.RouteGoal).ReadyToPickup(2.0000000)) && B.RatePickup(B.RouteGoal, PickupFactory(B.RouteGoal).InventoryType) > float(0);
			// End:0xD67
			if((bMovingToSuperPickup && B.FindBestPathToward(B.RouteGoal, false, true)) || B.Pawn.ValidAnchor() && CheckSuperItem(B, SuperDist))
			{
				B.bCheckDriverPickups = false;
				B.GoalString = "Get super item" @ string(B.RouteGoal);
				// End:0xD46
				if((((V != none) && V.bCanPickupInventory!) && (B.Pawn.Anchor == none) || B.Pawn.Anchor.bFlyingPreferred!) && (B.MoveTarget == B.RouteGoal) || (B.RouteCache.Length > 1) && B.RouteCache[1] == B.RouteGoal)
				{
					// End:0xCE6
					if((PickupFactory(B.RouteGoal) == none) && UTVehicle(V) != none)
					{
						UTVehicle(V).VehicleLostTime = WorldInfo.TimeSeconds + 5.0000000;
					}
					B.NoVehicleGoal = B.RouteGoal;
					B.LeaveVehicle(true);					
				}
				else
				{
					B.SetAttractionState();
				}
				return true;
			}
			B.bCheckDriverPickups = false;
		}
	}
	UTObjective = UTGameObjective(SquadObjective);
	// End:0xFAF
	if(B.DefensePoint != none)
	{
		DesiredPosition = B.DefensePoint.GetMoveTarget();
		bInPosition = (B.Pawn == DesiredPosition) || B.Pawn.ReachedDestination(DesiredPosition);
		// End:0xF88
		if(bInPosition && Vehicle(DesiredPosition) != none)
		{
			// End:0xF46
			if(((V != none) && B.Pawn != DesiredPosition) && B.Pawn.GetVehicleBase() != DesiredPosition)
			{
				B.LeaveVehicle(true);
				return true;
			}
			// End:0xF88
			if(V == none)
			{
				B.EnterVehicle(Vehicle(DesiredPosition));
				return true;
			}
		}
		// End:0xFAC
		if(B.ShouldDefendPosition())
		{
			return true;
		}		
	}
	else
	{
		// End:0xFDE
		if(SquadObjective == none)
		{
			return TellBotToFollow(B, SquadLeader);			
		}
		else
		{
			// End:0x106E
			if(((GetOrders()) == 'Freelance') && (UTVehicle(B.Pawn) == none) || UTVehicle(B.Pawn).bKeyVehicle!)
			{
				return false;				
			}
			else
			{
				// End:0x1179
				if(int(UTObjective.DefenderTeamIndex) != Team.TeamIndex)
				{
					// End:0x1110
					if(UTObjective.bIsDisabled)
					{
						B.GoalString = "Objective already disabled";
						return false;
					}
					B.GoalString = "Disable Objective " $ string(SquadObjective);
					return UTObjective.TellBotHowToDisable(B);
				}
				// End:0x11FE
				if((B.DefensivePosition != none) && AcceptableDefensivePosition(B.DefensivePosition, B))
				{
					DesiredPosition = B.DefensivePosition;					
				}
				else
				{
					// End:0x1240
					if(UTObjective.bBlocked)
					{
						DesiredPosition = FindDefensivePositionFor(B);						
					}
					else
					{
						DesiredPosition = UTObjective;
					}
				}
				bInPosition = (VSize(DesiredPosition.Location - B.Pawn.Location) < 2000.0000000) && B.LineOfSightTo(UTObjective) || UTObjective.bHasAlternateTargetLocation && B.LineOfSightTo(UTObjective,, true);
			}
		}
	}
	// End:0x1538
	if(B.Enemy != none)
	{
		// End:0x1398
		if(B.LostContact(5.0000000))
		{
			B.LoseEnemy();
		}
		// End:0x1538
		if(B.Enemy != none)
		{
			// End:0x1538
			if(B.LineOfSightTo(B.Enemy) || (((WorldInfo.TimeSeconds - B.LastSeenTime) < float(3)) && (SquadObjective == none) || UTGameObjective(SquadObjective).TeamLink(Team.TeamIndex)!) && (UTVehicle(B.Pawn) == none) || UTVehicle(B.Pawn).bKeyVehicle!)
			{
				B.FightEnemy(false, 0.0000000);
				return true;
			}
		}
	}
	// End:0x1761
	if(bInPosition)
	{
		B.GoalString = "Near defense position" @ string(DesiredPosition);
		// End:0x15FC
		if(B.bInitLifeMessage!)
		{
			B.bInitLifeMessage = true;
			B.SendMessage(none, 'InPosition', 25.0000000);
		}
		// End:0x1642
		if(B.DefensePoint != none)
		{
			B.MoveToDefensePoint();			
		}
		else
		{
			// End:0x166F
			if(UTObjective.TellBotHowToHeal(B))
			{
				return true;
			}
			// End:0x1740
			if((B.Enemy != none) && B.LineOfSightTo(B.Enemy) || (WorldInfo.TimeSeconds - B.LastSeenTime) < float(3))
			{
				B.FightEnemy(false, 0.0000000);
				return true;
			}
			B.WanderOrCamp();
		}
		return true;
	}
	// End:0x179A
	if(B.Pawn.bStationary)
	{
		return false;
	}
	B.GoalString = "Follow path to " $ string(DesiredPosition);
	// End:0x194F
	if((DesiredPosition == UTObjective) && UTObjective.bAllowOnlyShootable)
	{
		// End:0x1861
		if(B.ActorReachable(UTObjective))
		{
			B.MoveTarget = UTObjective;			
		}
		else
		{
			UTObjective.MarkShootSpotsFor(B.Pawn);
			// End:0x1922
			if(B.Pawn.Anchor != none)
			{
				B.Pawn.Anchor.bTransientEndPoint = false;
			}
			B.FindBestPathToward(DesiredPosition, true, true);
		}		
	}
	else
	{
		B.FindBestPathToward(DesiredPosition, false, true);
	}
	// End:0x19A6
	if(B.StartMoveToward(DesiredPosition))
	{
		return true;
	}
	// End:0x1AE0
	if((B.DefensePoint != none) && DesiredPosition == B.DefensePoint)
	{
		B.FreePoint();
		// End:0x1AE0
		if((UTObjective != none) && VSize(B.Pawn.Location - UTObjective.Location) > float(1200))
		{
			B.FindBestPathToward(UTObjective, false, true);
			// End:0x1AE0
			if(B.StartMoveToward(UTObjective))
			{
				return true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

function float BotSuitability(UTBot B)
{
	return 1.0000000;
	//return ReturnValue;	
}

function UTBot PickBotToReassign()
{
	local UTBot B, Best;
	local float val, BestVal, Suitability, BestSuitability;

	B = SquadMembers;
	J0x13:

	// End:0x1BC [Loop If]
	if(B != none)
	{
		// End:0x191
		if(B.PlayerReplicationInfo.bOutOfLives!)
		{
			val = VSize(B.Pawn.Location - SquadObjective.Location);
			// End:0xE1
			if(B == SquadLeader)
			{
				val -= 10000000.0000000;
			}
			Suitability = BotSuitability(B);
			// End:0x191
			if(((Best == none) || Suitability > BestSuitability) || (Suitability == BestSuitability) && val > BestVal)
			{
				Best = B;
				BestVal = val;
				BestSuitability = Suitability;
			}
		}
		B = B.NextSquadMember;
		// [Loop Continue]
		goto J0x13;
	}
	return Best;
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
	local string EnemyList;
	local int I;
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);
	// End:0xF1
	if(SquadObjective == none)
	{
		Canvas.DrawText((((("     ORDERS " $ string(GetOrders())) $ " on ") $ (GetItemName(string(self)))) $ " no objective. Leader ") $ SquadLeader.GetHumanReadableName(), false);		
	}
	else
	{
		Canvas.DrawText((((((("     ORDERS " $ string(GetOrders())) $ " on ") $ (GetItemName(string(self)))) $ " objective ") $ SquadObjective.GetHumanReadableName()) $ ". Leader ") $ SquadLeader.GetHumanReadableName(), false);
	}
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	EnemyList = "     Enemies: ";
	I = 0;
	J0x20C:

	// End:0x281 [Loop If]
	if(I < 8)
	{
		// End:0x273
		if(Enemies[I] != none)
		{
			EnemyList = EnemyList @ Enemies[I].GetHumanReadableName();
		}
		I++;
		// [Loop Continue]
		goto J0x20C;
	}
	Canvas.DrawText(EnemyList, false);
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	//return;	
}

function bool BeDevious(Pawn Enemy)
{
	return ((SquadMembers.Skill >= float(4)) && FRand() < 0.6500000) && PlayerController(Enemy.Controller) != none;
	//return ReturnValue;	
}

function bool PickRetreatDestination(UTBot B)
{
	return B.PickRetreatDestination();
	//return ReturnValue;	
}

function bool ClearPathFor(Controller C)
{
	local UTBot B;
	local bool bForceDefer;
	local Vector Dir;

	bForceDefer = ShouldDeferTo(C);
	B = SquadMembers;
	J0x31:

	// End:0x279 [Loop If]
	if(B != none)
	{
		// End:0x24E
		if((B != C) && B.Pawn != none)
		{
			Dir = B.Pawn.Location - C.Pawn.Location;
			// End:0x24E
			if((Abs(Dir.Z) < (B.Pawn.GetCollisionHeight() + C.Pawn.GetCollisionHeight())) && VSize2D(Dir) < (8.0000000 * B.Pawn.GetCollisionRadius()))
			{
				// End:0x24E
				if((bForceDefer || B.IsDefending()) || B.Stopped())
				{
					B.ClearPathFor(C);
				}
			}
		}
		B = B.NextSquadMember;
		// [Loop Continue]
		goto J0x31;
	}
	return bForceDefer;
	//return ReturnValue;	
}

function bool IsDefending(UTBot B)
{
	// End:0x1A
	if((GetOrders()) == 'Defend')
	{
		return true;
	}
	return B.DefensePoint != none;
	//return ReturnValue;	
}

function bool FriendlyToward(Pawn Other)
{
	local UTTeamAI TeamAI;

	TeamAI = UTTeamInfo(Team).AI;
	// End:0x42
	if(Team == none)
	{
		return false;
	}
	return TeamAI.FriendlyToward(Other);
	//return ReturnValue;	
}

function float GetMaxDefenseDistanceFrom(Actor Center, UTBot B)
{
	return ((Pawn(Center) != none) ? FormationSize : 2000.0000000);
	//return ReturnValue;	
}

function NavigationPoint FindDefensivePositionFor(UTBot B)
{
	local PathNode N, Best;
	local int Num;
	local float CurrentRating, BestRating;
	local Actor Center;

	Center = FormationCenter(B);
	// End:0x54
	if(Center == none)
	{
		Center = B.Pawn;
	}
	// End:0x194
	foreach WorldInfo.RadiusNavigationPoints(Class'Engine.PathNode', N, Center.Location, GetMaxDefenseDistanceFrom(Center, B))
	{
		CurrentRating = RateDefensivePosition(N, B, Center);
		// End:0x13C
		if(CurrentRating > BestRating)
		{
			BestRating = CurrentRating;
			Best = N;
			Num = 1;
			// End:0x193
			continue;
		}
		// End:0x193
		if(CurrentRating == BestRating)
		{
			Num++;
			// End:0x193
			if((Best == none) || Rand(Num) == 0)
			{
				Best = N;
			}
		}		
	}	
	return Best;
	//return ReturnValue;	
}

function float RateDefensivePosition(NavigationPoint N, UTBot CurrentBot, Actor Center)
{
	local float Rating, Dist;
	local UTBot B;
	local int I;
	local ReachSpec ReverseSpec;
	local bool bNeedSpecialMove;
	local UTPawn P;

	// End:0x18D
	if((((N.bDestinationOnly || N.IsA('Teleporter')) || N.IsA('PortalMarker')) || N.bFlyingPreferred && CurrentBot.Pawn.bCanFly!) || FastTrace(N.Location, Center.GetTargetLocation())! && Center.bHasAlternateTargetLocation! || FastTrace(N.Location, Center.GetTargetLocation(,, true))!)
	{
		return -1.0000000;
	}
	P = UTPawn(CurrentBot.Pawn);
	// End:0x3B0
	if((P == none) || P.bCanDoubleJump!)
	{
		bNeedSpecialMove = true;
		I = 0;
		J0x20A:

		// End:0x39D [Loop If]
		if(I < N.PathList.Length)
		{
			// End:0x38F
			if(N.PathList[I].GetEnd() != none)
			{
				ReverseSpec = N.PathList[I].GetEnd().GetReachSpecTo(N);
				// End:0x38F
				if(((ReverseSpec != none) && ReverseSpec.IsBlockedFor(P)!) && ((ReverseSpec.reachFlags & 16) == 0) || (P != none) && P.bCanDoubleJump)
				{
					bNeedSpecialMove = false;
					// [Explicit Break]
					goto J0x39D;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x20A;
		}
		J0x39D:

		// End:0x3B0
		if(bNeedSpecialMove)
		{
			return -1.0000000;
		}
	}
	Rating = 1.0000000;
	B = SquadMembers;
	J0x3D2:

	// End:0x511 [Loop If]
	if(B != none)
	{
		// End:0x4E6
		if(B != CurrentBot)
		{
			// End:0x45B
			if((B.DefensePoint == N) || B.DefensivePosition == N)
			{
				return -1.0000000;				
			}
			else
			{
				// End:0x4E6
				if(B.Pawn != none)
				{
					Rating *= (0.0020000 * VSize(B.Pawn.Location - N.Location));
				}
			}
		}
		B = B.NextSquadMember;
		// [Loop Continue]
		goto J0x3D2;
	}
	Dist = VSize(N.Location - Center.Location);
	// End:0x57F
	if(Dist < 400.0000000)
	{
		return 0.0002500 * Dist;
	}
	return Rating;
	//return ReturnValue;	
}

function bool AcceptableDefensivePosition(NavigationPoint N, UTBot B)
{
	local Actor Center;

	Center = FormationCenter(B);
	// End:0x57
	if(Center == none)
	{
		Center = B.Pawn;		
	}
	else
	{
		// End:0xE0
		if(((Vehicle(B.Pawn) != none) && UTGameObjective(Center) != none) && UTGameObjective(Center).VehicleParkingSpots.Find(N) != -1)
		{
			return true;
		}
	}
	return (VSize(N.Location - Center.Location) <= (GetMaxDefenseDistanceFrom(Center, B))) && (RateDefensivePosition(N, B, Center)) > float(0);
	//return ReturnValue;	
}

function bool HandlePathObstruction(UTBot B, Actor BlockedBy)
{
	local int I;
	local UTGameObjective UTObjective;

	// End:0x191
	if(((B.MoveTarget == B.RouteGoal) && SquadObjective != none) && Vehicle(B.Pawn) != none)
	{
		UTObjective = UTGameObjective(SquadObjective);
		I = 0;
		J0xA8:

		// End:0x191 [Loop If]
		if(I < UTObjective.VehicleParkingSpots.Length)
		{
			// End:0x183
			if(B.RouteGoal == UTObjective.VehicleParkingSpots[I])
			{
				B.bPreparingMove = true;
				B.MoveTimer = -1.0000000;
				LeaveVehicleAtParkingSpot(B, UTObjective);
				return true;
			}
			I++;
			// [Loop Continue]
			goto J0xA8;
		}
	}
	return false;
	//return ReturnValue;	
}

function MarkHuntingSpots(UTBot B)
{
	//return;	
}

function ModifyAggression(UTBot B, out float Aggression)
{
	local UTBot M;

	M = SquadMembers;
	J0x13:

	// End:0x182 [Loop If]
	if(M != none)
	{
		// End:0x157
		if((((M != B) && M.Pawn != none) && VSize(B.Pawn.Location - M.Pawn.Location) < 2000.0000000) && FastTrace(M.Pawn.Location, B.Pawn.Location,, true))
		{
			Aggression -= 0.5000000;
			return;
		}
		M = M.NextSquadMember;
		// [Loop Continue]
		goto J0x13;
	}
	//return;	
}

function bool HasOtherVisibleEnemy(UTBot B)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x124 [Loop If]
	if(I < 8)
	{
		// End:0x101
		if(((Enemies[I] != none) && Enemies[I].Health > 0) && Enemies[I].Controller != none)
		{
			// End:0xFE
			if((Enemies[I] != B.Enemy) && B.LineOfSightTo(Enemies[I]))
			{
				return true;
			}			
		}
		else
		{
			Enemies[I] = none;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

state Retasking
{
	function Tick(float DeltaTime)
	{
		local UTBot M;
		local bool bStillTicking;

		M = SquadMembers;
		J0x13:

		// End:0x108 [Loop If]
		if(M != none)
		{
			// End:0xDD
			if((M.Pawn != none) && M.ReTaskTime > float(0))
			{
				// End:0xD1
				if(WorldInfo.TimeSeconds > M.ReTaskTime)
				{
					M.WhatToDoNext();					
				}
				else
				{
					bStillTicking = true;
				}
			}
			M = M.NextSquadMember;
			// [Loop Continue]
			goto J0x13;
		}
		// End:0x125
		if(bStillTicking!)
		{
			GotoState('None');
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	SupportString="supporting"
	DefendString="defending"
	AttackString="attacking"
	HoldString="holding"
	FreelanceString="Sweeper"
	MaxSquadSize=2
	bRoamingSquad=true
	FormationSize=1100.0000000
	MaxSquadRoutes=5
	NetUpdateFrequency=1.0000000
}