class UTDMSquad extends UTSquadAI;

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
	local string EnemyList;
	local int I;
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);
	EnemyList = "     Enemies: ";
	I = 0;
	J0x73:

	// End:0xE8 [Loop If]
	if(I < 8)
	{
		// End:0xDA
		if(Enemies[I] != none)
		{
			EnemyList = EnemyList @ Enemies[I].GetHumanReadableName();
		}
		I++;
		// [Loop Continue]
		goto J0x73;
	}
	Canvas.DrawText(EnemyList, false);
	YPos += YL;
	Canvas.SetPos(4.0000000, YPos);
	//return;	
}

function bool IsDefending(UTBot B)
{
	return false;
	//return ReturnValue;	
}

function AddBot(UTBot B)
{
	super.AddBot(B);
	SquadLeader = B;
	//return;	
}

function RemoveBot(UTBot B)
{
	// End:0x26
	if(B.Squad != self)
	{
		return;
	}
	Destroy();
	//return;	
}

function bool ShouldDeferTo(Controller C)
{
	return false;
	//return ReturnValue;	
}

function bool CheckSquadObjectives(UTBot B)
{
	return false;
	//return ReturnValue;	
}

function bool WaitAtThisPosition(Pawn P)
{
	return false;
	//return ReturnValue;	
}

function bool NearFormationCenter(Pawn P)
{
	return true;
	//return ReturnValue;	
}

function bool BeDevious(Pawn Enemy)
{
	return (SquadMembers.Skill >= float(4)) && FRand() < (0.8000000 - (0.1500000 * float(WorldInfo.Game.NumBots)));
	//return ReturnValue;	
}

function name GetOrders()
{
	return CurrentOrders;
	//return ReturnValue;	
}

function bool SetEnemy(UTBot B, Pawn NewEnemy)
{
	local bool bResult;

	// End:0xD0
	if((((NewEnemy == none) || NewEnemy.Health <= 0) || NewEnemy.Controller == none) || (UTBot(NewEnemy.Controller) != none) && UTBot(NewEnemy.Controller).Squad == self)
	{
		return false;
	}
	// End:0xEA
	if(AddEnemy(NewEnemy)!)
	{
		return false;
	}
	bResult = FindNewEnemyFor(B, (B.Enemy != none) && B.LineOfSightTo(SquadMembers.Enemy));
	// End:0x1DE
	if(bResult && B.Enemy == NewEnemy)
	{
		B.AcquireTime = WorldInfo.TimeSeconds;
	}
	return bResult;
	//return ReturnValue;	
}

function bool FriendlyToward(Pawn Other)
{
	return false;
	//return ReturnValue;	
}

function bool AllowContinueOnFoot(UTBot B, UTVehicle V)
{
	return (B.Enemy == none) && super.AllowContinueOnFoot(B, V);
	//return ReturnValue;	
}

function float VehicleDesireability(UTVehicle V, UTBot B)
{
	// End:0x47
	if(WorldInfo.TimeSeconds < V.VehicleLostTime)
	{
		return 0.0000000;
	}
	// End:0xB3
	if(UTPlayerReplicationInfo(B.PlayerReplicationInfo).bHasFlag && V.bCanCarryFlag!)
	{
		return 0.0000000;
	}
	// End:0x105
	if(float(V.Health) < (float(V.HealthMax) * 0.1250000))
	{
		return 0.0000000;
	}
	return V.BotDesireability(self, 255, SquadObjective);
	//return ReturnValue;	
}

function bool AssignSquadResponsibility(UTBot B)
{
	local Pawn PlayerPawn;
	local Controller C;
	local Actor MoveTarget;
	local UTVehicleFactory VFactory;
	local UTVehicle V;

	// End:0xA0
	if(B.NeedWeapon() && B.FindInventoryGoal(0.0000000))
	{
		B.GoalString = "Need weapon or ammo";
		B.SetAttractionState();
		return true;
	}
	// End:0xB8
	if(CheckVehicle(B))
	{
		return true;
	}
	// End:0x3C6
	if(B.Skill > 1.2500000)
	{
		B.RespawnPredictionTime = ((B.Skill > 5.0000000) ? 2.0000000 : 0.0000000);
		// End:0x2B6
		foreach WorldInfo.AllNavigationPoints(Class'UTGame.UTVehicleFactory', VFactory)
		{
			V = UTVehicle(VFactory.ChildVehicle);
			// End:0x2B5
			if((((V != none) && V.bHasBeenDriven! || V.bStationary) && (VehicleDesireability(V, B)) > 0.0000000) || ((V == none) && VFactory.RespawnProgress < B.RespawnPredictionTime) && VFactory.IsInState('Active'))
			{
				VFactory.bTransientEndPoint = true;
			}			
		}		
		// End:0x3C6
		if(B.FindSuperPickup((((WorldInfo.Game.NumPlayers + WorldInfo.Game.NumBots) < 4) ? 6000.0000000 : 3500.0000000)))
		{
			B.GoalString = "Get super item" @ string(B.RouteGoal);
			B.SetAttractionState();
			return true;
		}
	}
	// End:0x555
	if(B.Pawn.bStationary)
	{
		// End:0x553
		if((Vehicle(B.Pawn) != none) && (WorldInfo.TimeSeconds - FMax(B.AcquireTime, B.LastSeenTime)) > 20.0000000)
		{
			// End:0x52E
			if(B.Pawn.IsA('UTVehicle'))
			{
				UTVehicle(B.Pawn).VehicleLostTime = WorldInfo.TimeSeconds + 30.0000000;
			}
			B.LeaveVehicle(true);
			return true;			
		}
		else
		{
			return false;
		}
	}
	// End:0xC17
	if(B.Enemy == none)
	{
		// End:0x9BE
		if(((B.Skill >= 5.0000000) && (WorldInfo.Game.NumPlayers + WorldInfo.Game.NumBots) <= 3) && (B.Pawn.Weapon.AIRating > 0.7000000) || UTWeapon(B.Pawn.Weapon).bSniping)
		{
			// End:0x9BD
			foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
			{
				// End:0x9BC
				if((C.bIsPlayer && C != B) && C.Pawn != none)
				{
					PlayerPawn = C.Pawn;
					// End:0x8FE
					if(((WorldInfo.TimeSeconds - PlayerPawn.noise1time) < float(5)) || (WorldInfo.TimeSeconds - PlayerPawn.noise2time) < float(5))
					{
						B.bHuntPlayer = true;
						// End:0x8F8
						if(((WorldInfo.TimeSeconds - PlayerPawn.noise1time) < float(2)) || (WorldInfo.TimeSeconds - PlayerPawn.noise2time) < float(2))
						{
							B.LastKnownPosition = PlayerPawn.Location;
						}
						// End:0x9BD
						break;
						// End:0x9BC
						continue;
					}
					// End:0x9BC
					if((VSize(B.LastKnownPosition - PlayerPawn.Location) < float(800)) || VSize(B.LastKillerPosition - PlayerPawn.Location) < float(800))
					{
						B.bHuntPlayer = true;
						// End:0x9BD
						break;
					}
				}				
			}			
		}
		// End:0xA52
		if(B.FindInventoryGoal(0.0000000))
		{
			B.GoalString = "Get pickup";
			B.bHuntPlayer = false;
			B.SetAttractionState();
			return true;
		}
		// End:0xBF4
		if(B.bHuntPlayer)
		{
			B.bHuntPlayer = false;
			B.GoalString = "Hunt Player";
			// End:0xAFB
			if(B.ActorReachable(PlayerPawn))
			{
				MoveTarget = PlayerPawn;				
			}
			else
			{
				MoveTarget = B.FindPathToward(PlayerPawn, B.Pawn.bCanPickupInventory);
			}
			// End:0xBF4
			if(MoveTarget != none)
			{
				B.MoveTarget = MoveTarget;
				// End:0xBD3
				if(B.CanSee(PlayerPawn))
				{
					SetEnemy(B, PlayerPawn);
				}
				B.SetAttractionState();
				return true;
			}
		}
		return B.FindRoamDest();		
	}
	else
	{
		// End:0xD66
		if(((((B.Skill + B.Tactics) > 3.0000000) && B.LastSeenTime < (WorldInfo.TimeSeconds - 10.0000000)) && B.Pawn.FindInventoryType(Class'UTGame.UTTimedPowerup', true) == none) && B.FindInventoryGoal(0.0005000))
		{
			B.GoalString = "Get pickup 2";
			B.SetAttractionState();
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	CurrentOrders="Freelance"
}