class UTCheatManager extends GripCheatManager within GamePlayerController
	config(Game);

var Class<LocalMessage> LMC;
var SpeechRecognition RecogObject;

exec function ViewFlag()
{
	local AIController C;

	// End:0xFA
	foreach Outer.WorldInfo.AllControllers(Class'Engine.AIController', C)
	{
		// End:0xF9
		if((UTPlayerReplicationInfo(C.PlayerReplicationInfo) != none) && UTPlayerReplicationInfo(C.PlayerReplicationInfo).bHasFlag)
		{
			Outer.SetViewTarget(C.Pawn);			
			return;
		}		
	}	
	//return;	
}

exec function Glow(float F)
{
	local UTVehicle V;

	// End:0x8D
	foreach Outer.DynamicActors(Class'UTGame.UTVehicle', V)
	{
		V.LightEnvironment.AmbientGlow = MakeLinearColor(F, F, F, 1.0000000);		
	}	
	//return;	
}

exec function LM(string MessageClassName)
{
	LMC = Class<LocalMessage>(DynamicLoadObject(MessageClassName, Class'Core.Class'));
	//return;	
}

exec function LMS(int Switch)
{
	Outer.ReceiveLocalizedMessage(LMC, Switch, Outer.PlayerReplicationInfo, Outer.PlayerReplicationInfo);
	//return;	
}

exec function SummonV(string ClassName)
{
	local Class<Actor> NewClass;
	local Vector SpawnLoc;

	LogInternal("Fabricate " $ ClassName);
	NewClass = Class<Actor>(DynamicLoadObject("UTGameContent.UTVehicle_" $ ClassName, Class'Core.Class'));
	// End:0xCD
	if(NewClass == none)
	{
		NewClass = Class<Actor>(DynamicLoadObject(("UTGameContent.UTVehicle_" $ ClassName) $ "_Content", Class'Core.Class'));
	}
	// End:0x1DC
	if(NewClass != none)
	{
		// End:0x140
		if(Outer.Pawn != none)
		{
			SpawnLoc = Outer.Pawn.Location;			
		}
		else
		{
			SpawnLoc = Outer.Location;
		}
		Outer.Spawn(NewClass,,, (SpawnLoc + (float(72) * Vector(Outer.Rotation))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(15)));
	}
	//return;	
}

exec function AllWeapons()
{
	// End:0x66
	if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
	{
		return;
	}
	//return;	
}

exec function DoubleUp()
{
	//return;	
}

exec function AllAmmo()
{
	// End:0x10F
	if((Outer.Pawn != none) && UTInventoryManager(Outer.Pawn.InvManager) != none)
	{
		UTInventoryManager(Outer.Pawn.InvManager).AllAmmo(true);
		UTInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo = true;
	}
	//return;	
}

exec function Invisible(bool B)
{
	// End:0x74
	if(UTPawn(Outer.Pawn) != none)
	{
		UTPawn(Outer.Pawn).SetInvisible(B);
	}
	//return;	
}

exec function FreeCamera()
{
	UTPlayerController(Outer).bFreeCamera = UTPlayerController(Outer).bFreeCamera!;
	UTPlayerController(Outer).SetBehindView(UTPlayerController(Outer).bFreeCamera);
	//return;	
}

exec function ViewBot()
{
	local Controller first;
	local bool bFound;
	local AIController C;

	// End:0x122
	foreach Outer.WorldInfo.AllControllers(Class'Engine.AIController', C)
	{
		// End:0x121
		if((C.Pawn != none) && C.PlayerReplicationInfo != none)
		{
			// End:0xD4
			if(bFound || first == none)
			{
				first = C;
				// End:0xD4
				if(bFound)
				{
					// End:0x122
					break;
				}
			}
			// End:0x121
			if(C.PlayerReplicationInfo == Outer.RealViewTarget)
			{
				bFound = true;
			}
		}		
	}	
	// End:0x1D0
	if(first != none)
	{
		Outer.SetViewTarget(first);
		UTPlayerController(Outer).SetBehindView(true);
		UTPlayerController(Outer).bFreeCamera = true;
		Outer.FixFOV();		
	}
	else
	{
		ViewSelf(true);
	}
	//return;	
}

exec function KillBadGuys()
{
	local PlayerController PC;
	local UTPawn P;

	PC = UTPlayerController(Outer);
	// End:0x172
	if(PC != none)
	{
		// End:0x171
		foreach Outer.DynamicActors(Class'UTGame.UTPawn', P)
		{
			// End:0x170
			if(Outer.WorldInfo.GRI.OnSameTeam(P, PC)! && (PC.Pawn != none) && PC.Pawn != P)
			{
				P.TakeDamage(20000, PC, P.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'UTGame.UTDmgType_Rocket');
			}			
		}		
	}
	//return;	
}

exec function RBGrav(float NewGravityScaling)
{
	Outer.WorldInfo.RBPhysicsGravityScaling = NewGravityScaling;
	//return;	
}

exec function SuicideBy(string Type, optional int DeathHealth)
{
	local Class<DamageType> DamageType;

	// End:0x245
	if(Outer.Pawn != none)
	{
		// End:0x5E
		if(InStr(Type, ".") == -1)
		{
			Type = "UTGame." $ Type;
		}
		DamageType = Class<DamageType>(DynamicLoadObject(Type, Class'Core.Class'));
		// End:0x245
		if(DamageType != none)
		{
			Outer.Pawn.Health = DeathHealth;
			// End:0x1CC
			if(Outer.Pawn.IsA('UTPawn'))
			{
				UTPawn(Outer.Pawn).AccumulateDamage = float(DeathHealth-);
				UTPawn(Outer.Pawn).AccumulationTime = Outer.WorldInfo.TimeSeconds;
			}
			Outer.Pawn.Died(Outer, DamageType, Outer.Pawn.Location);
		}
	}
	//return;	
}

exec function EditWeapon(string WhichWeapon)
{
	local UTWeapon Weapon;
	local array<string> weaps;
	local string S;
	local int I;

	// End:0x59
	if(WhichWeapon != "")
	{		
		Outer.ConsoleCommand("Editactor class=" $ WhichWeapon);		
	}
	else
	{
		// End:0x10B
		foreach Outer.AllActors(Class'UTGame.UTWeapon', Weapon)
		{
			S = "" $ string(Weapon.Class);
			// End:0x10A
			if(weaps.Find(S) < 0)
			{
				weaps.Length = weaps.Length + 1;
				weaps[weaps.Length - 1] = S;
			}			
		}		
		I = 0;
		J0x117:

		// End:0x16F [Loop If]
		if(I < weaps.Length)
		{
			LogInternal((("Weapon" @ string(I)) @ "=") @ weaps[I]);
			I++;
			// [Loop Continue]
			goto J0x117;
		}
	}
	//return;	
}

exec function KillOtherBots()
{
	local UTBot B;

	UTGame(Outer.WorldInfo.Game).DesiredPlayerCount = Outer.WorldInfo.Game.NumPlayers + 1;
	// End:0x227
	foreach Outer.WorldInfo.AllControllers(Class'UTGame.UTBot', B)
	{
		// End:0x226
		if(((B.Pawn == none) || B.Pawn != Outer.ViewTarget) && (B.PlayerReplicationInfo == none) || B.PlayerReplicationInfo != Outer.RealViewTarget)
		{
			// End:0x20E
			if(B.Pawn != none)
			{
				B.Pawn.Suicide();
			}
			B.Destroy();
		}		
	}	
	//return;	
}

exec function SpawnABloodDecal()
{
	LeaveADecal(Outer.Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000));
	//return;	
}

simulated function LeaveADecal(Vector HitLoc, Vector HitNorm)
{
	local MaterialInstance MIC_Decal;
	local Actor TraceActor;
	local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

	local TraceHitInfo HitInfo;

	TraceStart = HitLoc + vect(0.0000000, 0.0000000, 15.0000000);
	TraceDest = HitLoc - vect(0.0000000, 0.0000000, 100.0000000);
	Const:
	TraceActor = Outer.Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, Outer.TRACEFLAG_PhysicsVolumes, 2);
	// End:0x2C0
	if(TraceActor != none)
	{
		MIC_Decal = new (Outer) Class'Engine.MaterialInstanceTimeVarying';
		MIC_Decal.SetParent(MaterialInstanceTimeVarying'CH_Gibs.Decals.BloodSplatter');
		Outer.WorldInfo.MyDecalManager.SpawnDecal(MIC_Decal, out_HitLocation, Rotator(out_HitNormal-), 200.0000000, 200.0000000, 10.0000000, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
		MaterialInstanceTimeVarying(MIC_Decal).SetScalarStartTime('DissolveAmount', 3.0000000);
		MaterialInstanceTimeVarying(MIC_Decal).SetScalarStartTime('BloodAlpha', 3.0000000);
		MIC_Decal.SetScalarParameterValue('DissolveAmount', 3.0000000);
		MIC_Decal.SetScalarParameterValue('BloodAlpha', 3.0000000);
	}
	//return;	
}

exec function TiltIt(bool bActive)
{
	Outer.SetControllerTiltActive(bActive);
	//return;	
}

exec function ShowStickBindings()
{
	local int BindIndex;

	LogInternal(string(Outer.PlayerInput.Bindings.Length));
	BindIndex = 0;
	J0x44:

	// End:0x332 [Loop If]
	if(BindIndex < Outer.PlayerInput.Bindings.Length)
	{
		// End:0x324
		if(((((Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_LeftX') || Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_LeftY') || Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightX') || Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightY') || Outer.PlayerInput.Bindings[BindIndex].Name == 'GBA_Look_Gamepad')
		{
			LogInternal(((" name: " $ string(Outer.PlayerInput.Bindings[BindIndex].Name)) $ " command: ") $ Outer.PlayerInput.Bindings[BindIndex].Command);
		}
		BindIndex++;
		// [Loop Continue]
		goto J0x44;
	}
	//return;	
}

exec function SetStickBind(float val)
{
	local int BindIndex;
	local string Cmd;

	LogInternal("SetStickBind");
	BindIndex = 0;
	J0x1C:

	// End:0x22D [Loop If]
	if(BindIndex < Outer.PlayerInput.Bindings.Length)
	{
		// End:0x21F
		if((Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightY') || Outer.PlayerInput.Bindings[BindIndex].Name == 'GBA_Look_Gamepad')
		{
			Cmd = ("Axis aLookup Speed=" $ string(val)) $ " DeadZone=0.3";
			Outer.PlayerInput.Bindings[BindIndex].Command = Cmd;
			LogInternal((" command: " $ Cmd) @ Outer.PlayerInput.Bindings[BindIndex].Command);
		}
		BindIndex++;
		// [Loop Continue]
		goto J0x1C;
	}
	//return;	
}

exec function KillAll(Class<Actor> aClass)
{
	local Actor A;
	local PlayerController PC;

	// End:0x85
	foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		PC.ClientMessage("Killed all " $ string(aClass));		
	}	
	// End:0xF2
	if(ClassIsChildOf(aClass, Class'Engine.AIController'))
	{
		UTGame(Outer.WorldInfo.Game).KillBots();
		return;
	}
	// End:0x128
	if(ClassIsChildOf(aClass, Class'Engine.Pawn'))
	{
		KillAllPawns(Class<Pawn>(aClass));
		return;
	}
	// End:0x19C
	foreach Outer.DynamicActors(Class'Engine.Actor', A)
	{
		// End:0x19B
		if(ClassIsChildOf(A.Class, aClass))
		{
			A.Destroy();
		}		
	}	
	//return;	
}

exec function TestUploadGameStats()
{
	local GameplayEventsWriterBase GameStats;
	local PlayerController PC;
	local TeamInfo Team;

	PC = Outer;
	Team = PC.WorldInfo.GRI.Teams[0];
	GameStats = new Class'Engine.GameplayEventsUploadAnalytics';
	UTGame(PC.WorldInfo.Game).GameplayEventsWriter = GameStats;
	GameStats.StartLogging();
	// End:0x261
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogGameIntEvent(0, 1);
	}
	// End:0x3CD
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogGameStringEvent(6, "TDM");
	}
	// End:0x539
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogGameFloatEvent(2, 1.0000000);
	}
	// End:0x6C2
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogGamePositionEvent(1, PC.Location, 1.0000000);
	}
	// End:0x839
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogTeamStringEvent(50, Team, "Ready");
	}
	// End:0x9AA
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogTeamIntEvent(4, Team, 1);
	}
	// End:0xB1F
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogTeamFloatEvent(5, Team, 1.0000000);
	}
	// End:0xCF6
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerLoginChange(100, PC, PC.PlayerReplicationInfo.PlayerName, PC.PlayerReplicationInfo.UniqueId, false);
	}
	// End:0xECD
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerLoginChange(101, PC, PC.PlayerReplicationInfo.PlayerName, PC.PlayerReplicationInfo.UniqueId, false);
	}
	// End:0x103E
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerIntEvent(109, PC, 1);
	}
	// End:0x11B3
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerFloatEvent(110, PC, 1.0000000);
	}
	// End:0x132E
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerSpawnEvent(102, PC, Class'UTGame.UTPawn', 255);
	}
	// End:0x14A7
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerPlayerEvent(104, PC, PC);
	}
	// End:0x162B
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerKillDeath(104, 200, PC, Class'UTGame.UTDamageType', PC);
	}
	// End:0x17AF
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogPlayerKillDeath(108, 200, PC, Class'UTGame.UTDamageType', PC);
	}
	// End:0x1929
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogWeaponIntEvent(152, PC, Class'UTGame.UTWeap_LinkGun', 1);
	}
	// End:0x1AA3
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogProjectileIntEvent(152, PC, Class'UTGame.UTProjectile', 1);
	}
	// End:0x1C26
	if(((Outer.WorldInfo.Game != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter != none) && UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
	{
		UTGame(Outer.WorldInfo.Game).GameplayEventsWriter.LogDamageEvent(150, PC, Class'UTGame.UTDamageType', PC, 1);
	}
	UTGame(PC.WorldInfo.Game).GameplayEventsWriter = none;
	GameStats.EndLogging();
	//return;	
}

function KillAllPawns(Class<Pawn> aClass)
{
	local Pawn P;

	UTGame(Outer.WorldInfo.Game).KillBots();
	// End:0x13D
	foreach Outer.DynamicActors(Class'Engine.Pawn', P)
	{
		// End:0x13C
		if(ClassIsChildOf(P.Class, aClass) && P.IsPlayerPawn()!)
		{
			// End:0x124
			if(P.Controller != none)
			{
				P.Controller.Destroy();
			}
			P.Destroy();
		}		
	}	
	//return;	
}
