class HaloGameDefault extends UDKGame
	config(Game);

const MAIN_MENU = "Main_Menu";

enum EGameplayMode
{
	GM_None,                        // 0
	GM_InCombat,                    // 1
	GM_MAX                          // 2
};

var config bool bIsDemoMode;
var bool bOverrideGameplayMode;
var bool bHaveChosenInitialRespawnPoint;
var bool bAlwaysFindNearestEnabledRespawnPoint;
var HaloUpgradeManager TheUpgradeManager;
var HaloPlayerGroup TheMainPlayerGroup;
var HaloVehicleCustomizationManager TheCustomizationManager;
var HaloConstructionManager TheConstructionManager;
var HaloDroppedPickupManager ThePickupManager;
var DynamicPackageGroupLoader TheDynamicLoader;
var HaloRecyclableActorManager TheRAM;
var float GameplayModeCheckIntervalSecs;
var float SecsToExitCombatMode;
var HaloGameDefault.EGameplayMode CurrentGameplayMode;
var float SecsWaitingToChangeGameplayMode;
var int MaxDroppedGrenades;
var array<HaloDroppedGrenade> DroppedGrenadesList;
var HaloMission PrimaryMission;
var HaloMission BonusMission;
var name MissionToJumpTo;
var name SpawnPointToJumpTo;
var array<LevelStreamingVolume> LevelStreamingVolumeList;
var float LevelStreamingVolumeWarningDistance;
var SeqAct_DisplayMessage TwoPlayerVolumeWarningMessage;
var float TwoPlayerVolumeWarningMessageTime;
var int StartPlayerCount;
var PlayerStart CurrentRespawnPoint;
var float AlternateRespawnRadius;
var array<HaloMission> CompletedMissions;
var array<HaloObjective> CompletedObjectives;
var array<HaloProjectile_Grenade> ActiveGrenades;

event PreBeginPlay()
{
	super(GameInfo).PreBeginPlay();
	// End:0x3D
	if(TheDynamicLoader == none)
	{
		TheDynamicLoader = Spawn(Class'Engine.DynamicPackageGroupLoader', self,,,,, true);
	}
	// End:0x70
	if(TheUpgradeManager == none)
	{
		TheUpgradeManager = Spawn(Class'MegaHaloGame.HaloUpgradeManager', self,,,,, true);
	}
	// End:0xA3
	if(TheCustomizationManager == none)
	{
		TheCustomizationManager = Spawn(Class'MegaHaloGame.HaloVehicleCustomizationManager', self,,,,, true);
	}
	// End:0xD6
	if(TheConstructionManager == none)
	{
		TheConstructionManager = Spawn(Class'MegaHaloGame.HaloConstructionManager', self,,,,, true);
	}
	// End:0x109
	if(ThePickupManager == none)
	{
		ThePickupManager = Spawn(Class'MegaHaloGame.HaloDroppedPickupManager', self,,,,, true);
	}
	// End:0x13C
	if(TheMainPlayerGroup == none)
	{
		TheMainPlayerGroup = Spawn(Class'MegaHaloGame.HaloPlayerGroup', self,,,,, true);
	}
	// End:0x16F
	if(TheRAM == none)
	{
		TheRAM = Spawn(Class'MegaHaloGame.HaloRecyclableActorManager', self,,,,, true);
	}
	//return;	
}

event PostBeginPlay()
{
	super(GameInfo).PostBeginPlay();
	ChangeGameplayMode(0);
	SetTimer(GameplayModeCheckIntervalSecs, false, 'CheckForGameplayModeChange');
	InitHaloLevelStreamingVolumes();
	//return;	
}

event Destroyed()
{
	// End:0x27
	if(TheUpgradeManager != none)
	{
		TheUpgradeManager.Destroy();
	}
	// End:0x4E
	if(TheCustomizationManager != none)
	{
		TheCustomizationManager.Destroy();
	}
	// End:0x75
	if(TheConstructionManager != none)
	{
		TheConstructionManager.Destroy();
	}
	// End:0x9C
	if(TheMainPlayerGroup != none)
	{
		TheMainPlayerGroup.Destroy();
	}
	// End:0xC3
	if(TheRAM != none)
	{
		TheRAM.Destroy();
	}
	super(Actor).Destroyed();
	//return;	
}

event PostLogin(PlayerController NewPlayer)
{
	local LocalPlayer LP;

	// End:0x5A
	if((TheMainPlayerGroup != none) && HaloPlayerPawnController(NewPlayer) != none)
	{
		TheMainPlayerGroup.AddPlayerController(HaloPlayerPawnController(NewPlayer));
	}
	LP = LocalPlayer(NewPlayer.Player);
	NewPlayer.bIsUsingStreamingVolumes = ((LP != none) && LP.Outer.GamePlayers.Find(LP) == 0) && int(WorldInfo.NetMode) != int(NM_Client);
	super(GameInfo).PostLogin(NewPlayer);
	//return;	
}

simulated function HaloUpgradeManager GetUpgradeManager()
{
	return TheUpgradeManager;
	//return ReturnValue;	
}

simulated function HaloPlayerGroup GetPlayerGroup()
{
	return TheMainPlayerGroup;
	//return ReturnValue;	
}

simulated function HaloVehicleCustomizationManager GetCustomizationManager()
{
	return TheCustomizationManager;
	//return ReturnValue;	
}

simulated function HaloConstructionManager GetConstructionManager()
{
	return TheConstructionManager;
	//return ReturnValue;	
}

simulated function HaloRecyclableActorManager GetRecyclableActorManager()
{
	return TheRAM;
	//return ReturnValue;	
}

event OnGameplayModeExit(HaloGameDefault.EGameplayMode ExitingMode, HaloGameDefault.EGameplayMode UpcomingMode)
{
	switch(ExitingMode)
	{
		// End:0x1B
		case 0:
			// End:0x26
			break;
		// End:0x23
		case 1:
			// End:0x26
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

event OnGameplayModeEnter(HaloGameDefault.EGameplayMode NewMode, HaloGameDefault.EGameplayMode ExitingMode)
{
	switch(NewMode)
	{
		// End:0x2E
		case 0:
			SendRemoteEvent('EnteredGameplayMode_Exploration');
			// End:0x4C
			break;
		// End:0x49
		case 1:
			SendRemoteEvent('EnteredGameplayMode_Combat');
			// End:0x4C
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function CheckForGameplayModeChange()
{
	// End:0x12
	if(bOverrideGameplayMode == true)
	{
		return;
	}
	switch(CurrentGameplayMode)
	{
		// End:0x95
		case 0:
			// End:0x92
			if((TheMainPlayerGroup.GetMaxPlayerPawnHeatLevel() > 0) || TheMainPlayerGroup.IsAnyNearbyEnemyAlertedToPlayerPresence())
			{
				PostGlobalAkEvent(AkEvent'PrototypeMusic.Set_Switch_Combat');
				ChangeGameplayMode(1);
			}
			// End:0x147
			break;
		// End:0x144
		case 1:
			// End:0x132
			if((TheMainPlayerGroup.GetMaxPlayerPawnHeatLevel() <= 0) && TheMainPlayerGroup.IsAnyNearbyEnemyAlertedToPlayerPresence()!)
			{
				SecsWaitingToChangeGameplayMode += GameplayModeCheckIntervalSecs;
				// End:0x12F
				if(SecsWaitingToChangeGameplayMode > SecsToExitCombatMode)
				{
					PostGlobalAkEvent(AkEvent'PrototypeMusic.Set_Switch_Explore');
					ChangeGameplayMode(0);
				}				
			}
			else
			{
				SecsWaitingToChangeGameplayMode = 0.0000000;
			}
			// End:0x147
			break;
		// End:0xFFFF
		default:
			break;
	}
	SetTimer(GameplayModeCheckIntervalSecs, false, 'CheckForGameplayModeChange');
	//return;	
}

simulated function ChangeGameplayMode(HaloGameDefault.EGameplayMode NextMode)
{
	local HaloGameDefault.EGameplayMode PrevMode;

	PrevMode = CurrentGameplayMode;
	OnGameplayModeExit(PrevMode, NextMode);
	CurrentGameplayMode = NextMode;
	SecsWaitingToChangeGameplayMode = 0.0000000;
	OnGameplayModeEnter(NextMode, PrevMode);
	//return;	
}

function bool SetMission(HaloMission newMission, bool bIsPrimaryMission)
{
	local HaloMission existingMission;

	// End:0x112
	if((((bIsPrimaryMission && PrimaryMission != none) && newMission != none) && newMission.missionName == PrimaryMission.missionName) || (BonusMission != none) && newMission.missionName == BonusMission.missionName)
	{
		WarnInternal(("Mission to " $ string(newMission.missionName)) $ " has already started!");
		return false;
	}
	// End:0x1D3
	foreach CompletedMissions(existingMission)
	{
		// End:0x1D2
		if(existingMission.missionName == newMission.missionName)
		{
			WarnInternal(("Mission to " $ string(newMission.missionName)) $ " has already been completed, not starting again!");			
			return false;
		}		
	}	
	// End:0x2B6
	if(bIsPrimaryMission)
	{
		// End:0x2A0
		if(newMission != none)
		{
			// End:0x2A0
			if(PrimaryMission != none)
			{
				WarnInternal(((("Setting Primary Mission to " $ string(newMission.missionName)) $ " while ") $ string(PrimaryMission.missionName)) $ " is still active");
				PrimaryMission.Term();
			}
		}
		PrimaryMission = newMission;		
	}
	else
	{
		// End:0x373
		if(newMission != none)
		{
			// End:0x373
			if(BonusMission != none)
			{
				WarnInternal(((("Setting Bonus Mission to " $ string(newMission.missionName)) $ " while ") $ string(BonusMission.missionName)) $ " is still active");
				BonusMission.Term();
			}
		}
		BonusMission = newMission;
	}
	return true;
	//return ReturnValue;	
}

function TickMissions(float DeltaTime)
{
	// End:0x3A
	if(BonusMission != none)
	{
		BonusMission.Tick(DeltaTime);		
	}
	else
	{
		// End:0x71
		if(PrimaryMission != none)
		{
			PrimaryMission.Tick(DeltaTime);
		}
	}
	//return;	
}

function HaloMission GetActiveMission()
{
	// End:0x19
	if(BonusMission != none)
	{
		return BonusMission;
	}
	return PrimaryMission;
	//return ReturnValue;	
}

function bool JumpToMission()
{
	// End:0x61
	if(MissionToJumpTo != 'None')
	{
		LogInternal("Jumping to mission " $ string(MissionToJumpTo));
		return SendRemoteEvent(name("Start_" $ string(MissionToJumpTo)));		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

function bool SendRemoteEvent(name EventName)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int I;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x11B
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x75:

		// End:0x11B [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x10D
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == EventName)
			{
				SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(WorldInfo, none);
				return true;
			}
			I++;
			// [Loop Continue]
			goto J0x75;
		}
	}
	WarnInternal("Unable to find Remote Event: " $ string(EventName));
	return false;
	//return ReturnValue;	
}

event InitGame(string Options, out string ErrorMessage)
{
	local string opt;

	super(GameInfo).InitGame(Options, ErrorMessage);
	// End:0xC2
	if((ParseOption(Options, "MissionToJumpTo")) != "")
	{
		LogInternal("Overriding MissionToJumpTo with " $ (ParseOption(Options, "MissionToJumpTo")));
		MissionToJumpTo = name(ParseOption(Options, "MissionToJumpTo"));
	}
	// End:0x174
	if((ParseOption(Options, "SpawnPointToJumpTo")) != "")
	{
		LogInternal("Overriding SpawnPointToJumpTo with " $ (ParseOption(Options, "SpawnPointToJumpTo")));
		SpawnPointToJumpTo = name(ParseOption(Options, "SpawnPointToJumpTo"));
	}
	opt = ParseOption(Options, "NumPlayers");
	// End:0x1C2
	if(opt != "")
	{
		StartPlayerCount = int(opt);
	}
	//return;	
}

function StartMatch()
{
	super(GameInfo).StartMatch();
	AddInitialPlayers();
	//return;	
}

function AddInitialPlayers()
{
	local int Index, PlayerCount, ControllerId;
	local PlayerController aPC;
	local LocalPlayer localPC, NewPC;
	local string OutError;

	PlayerCount = 0;
	// End:0x8B
	foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', aPC)
	{
		// End:0x7F
		if(localPC == none)
		{
			localPC = LocalPlayer(aPC.Player);
		}
		PlayerCount++;		
	}	
	Index = PlayerCount;
	J0x9F:

	// End:0x35E [Loop If]
	if(Index < StartPlayerCount)
	{
		NewPC = none;
		ControllerId = 0;
		J0xCC:

		// End:0x1AF [Loop If]
		if(ControllerId < 4)
		{
			// End:0x1A1
			if((localPC.ViewportClient.FindPlayerByControllerId(ControllerId) == none) && Class'Engine.UIInteraction'.static.IsLoggedIn(ControllerId))
			{
				NewPC = localPC.ViewportClient.CreatePlayer(ControllerId, OutError, false);
				// [Explicit Break]
				goto J0x1AF;
			}
			ControllerId++;
			// [Loop Continue]
			goto J0xCC;
		}
		J0x1AF:

		// End:0x2AB
		if(NewPC == none)
		{
			ControllerId = 0;
			J0x1C9:

			// End:0x2AB [Loop If]
			if(ControllerId < 4)
			{
				// End:0x29D
				if((localPC.ViewportClient.FindPlayerByControllerId(ControllerId) == none) && Class'Engine.UIInteraction'.static.IsGamepadConnected(ControllerId))
				{
					NewPC = localPC.ViewportClient.CreatePlayer(ControllerId, OutError, false);
					// [Explicit Break]
					goto J0x2AB;
				}
				ControllerId++;
				// [Loop Continue]
				goto J0x1C9;
			}
		}
		J0x2AB:

		// End:0x350
		if((NewPC == none) && localPC.ViewportClient.FindPlayerByControllerId(Index) == none)
		{
			NewPC = localPC.ViewportClient.CreatePlayer(Index, OutError, false);
		}
		Index++;
		// [Loop Continue]
		goto J0x9F;
	}
	//return;	
}

event Tick(float DeltaTime)
{
	super(Actor).Tick(DeltaTime);
	TickMissions(DeltaTime);
	TickHaloLevelStreamingVolumes(DeltaTime);
	//return;	
}

function AddDefaultInventory(Pawn PlayerPawn)
{
	super(GameInfo).AddDefaultInventory(PlayerPawn);
	// End:0xD8
	if(PlayerPawn.IsHumanControlled() || (HaloPawn(PlayerPawn) != none) && (HaloPawn(PlayerPawn).IntendedDeploymentController != none) || HaloPawn(PlayerPawn).bIsIntendedForPlayerControl == true)
	{
		PlayerPawn.CreateInventory(Class'MegaHaloGame.HaloWeapon_TargetDesignator', false);
	}
	//return;	
}

function RestartPlayer(Controller aPlayer)
{
	super(GameInfo).RestartPlayer(aPlayer);
	// End:0x53
	if(HaloPlayerPawnController(aPlayer) != none)
	{
		HaloPlayerPawnController(aPlayer).CameraReset();
	}
	//return;	
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam, optional bool IsNewPlayer)
{
	local Vector playerPos;
	local float closestDistSq;
	local PlayerStart PS;
	local float psDistSq;
	local PlayerController aPC;

	LogInternal((((("ChoosePlayerStart: MissionToJumpTo=" $ string(MissionToJumpTo)) $ " SpawnPointToJumpTo=") $ string(SpawnPointToJumpTo)) $ " bHaveChosenInitialRespawnPoint=") $ string(bHaveChosenInitialRespawnPoint));
	closestDistSq = 25000000094208.0000000;
	// End:0x440
	if(bHaveChosenInitialRespawnPoint!)
	{
		// End:0x26F
		foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', PS)
		{
			// End:0x16F
			if((SpawnPointToJumpTo != 'None') && string(PS.Name) == string(SpawnPointToJumpTo))
			{
				LogInternal("Using loaded respawn point " $ string(PS));
				CurrentRespawnPoint = PS;
				// End:0x26F
				break;
				// End:0x26E
				continue;
			}
			// End:0x26E
			if((MissionToJumpTo != 'None') && (PS.Tag == MissionToJumpTo) || (HaloPlayerSpawnPoint(PS) != none) && HaloPlayerSpawnPoint(PS).missionName == MissionToJumpTo)
			{
				LogInternal((("Using mission tagged respawn point " $ string(PS)) $ " for mission ") $ string(MissionToJumpTo));
				CurrentRespawnPoint = PS;
				// End:0x26F
				break;
			}			
		}		
		// End:0x316
		if(CurrentRespawnPoint == none)
		{
			WarnInternal((((" !!! No respawn point found for MissionToJumpTo == '" $ string(MissionToJumpTo)) $ "' and SpawnPointToJumpTo = '") $ string(SpawnPointToJumpTo)) $ "'. Falling back to primary start.");
		}
		// End:0x431
		if(CurrentRespawnPoint == none)
		{
			// End:0x3D9
			foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', PS)
			{
				// End:0x3D8
				if(PS.bPrimaryStart && PS.bClaimedAsPrimaryStart!)
				{
					PS.bClaimedAsPrimaryStart = true;
					CurrentRespawnPoint = PS;
					// End:0x3D9
					break;
				}				
			}			
			// End:0x431
			if(CurrentRespawnPoint == none)
			{
				WarnInternal(" !!! No PRIMARY respawn points found.  The level needs at least one.");
			}
		}
		bHaveChosenInitialRespawnPoint = true;		
	}
	else
	{
		// End:0x625
		if(bAlwaysFindNearestEnabledRespawnPoint || CurrentRespawnPoint == none)
		{
			// End:0x547
			foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', aPC)
			{
				// End:0x546
				if(aPC.IsPrimaryPlayer() == true)
				{
					// End:0x51B
					if(aPC.Pawn != none)
					{
						playerPos = aPC.Pawn.Location;						
					}
					else
					{
						playerPos = aPC.Location;
					}
					// End:0x547
					break;
				}				
			}			
			// End:0x624
			foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', PS)
			{
				psDistSq = VSizeSq(playerPos - PS.Location);
				// End:0x623
				if(PS.bEnabled && (psDistSq < closestDistSq) || CurrentRespawnPoint == none)
				{
					CurrentRespawnPoint = PS;
					closestDistSq = psDistSq;
				}				
			}			
		}
	}
	return CurrentRespawnPoint;
	//return ReturnValue;	
}

function Class<Pawn> GetDefaultPlayerClass(Controller C)
{
	local HaloPlayerPawnController HC;

	HC = HaloPlayerPawnController(C);
	// End:0x70
	if((HC != none) && HC.PawnClass != none)
	{
		return HC.PawnClass;
	}
	return super(GameInfo).GetDefaultPlayerClass(C);
	//return ReturnValue;	
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
	local Class<Pawn> DefaultPlayerClass;
	local array<Vector> startLocations;
	local Rotator StartRotation;
	local Pawn ResultPawn;
	local Rotator rightTurnRot;
	local Vector rightDir, fwdDir;
	local int I;

	DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
	StartRotation.Yaw = StartSpot.Rotation.Yaw;
	rightTurnRot.Yaw = int(float(-90) * 182.0444031);
	fwdDir = Vector(StartRotation);
	rightDir = fwdDir << rightTurnRot;
	startLocations.Length = 9;
	startLocations[0] = StartSpot.Location;
	startLocations[1] = StartSpot.Location + ((rightDir * AlternateRespawnRadius) * 0.5000000);
	startLocations[2] = StartSpot.Location - ((rightDir * AlternateRespawnRadius) * 0.5000000);
	startLocations[3] = StartSpot.Location - ((fwdDir * AlternateRespawnRadius) * 0.5000000);
	startLocations[4] = StartSpot.Location + ((fwdDir * AlternateRespawnRadius) * 0.5000000);
	startLocations[5] = StartSpot.Location + (rightDir * AlternateRespawnRadius);
	startLocations[6] = StartSpot.Location - (rightDir * AlternateRespawnRadius);
	startLocations[7] = StartSpot.Location - (fwdDir * AlternateRespawnRadius);
	startLocations[8] = StartSpot.Location + (fwdDir * AlternateRespawnRadius);
	I = 0;
	J0x331:

	// End:0x3A6 [Loop If]
	if((I < startLocations.Length) && ResultPawn == none)
	{
		ResultPawn = Spawn(DefaultPlayerClass,,, startLocations[I], StartRotation);
		I++;
		// [Loop Continue]
		goto J0x331;
	}
	// End:0x41D
	if(ResultPawn == none)
	{
		WarnInternal(((("Couldn't spawn player of type " $ string(DefaultPlayerClass)) $ " at ") $ string(StartSpot)) $ ": May need to clear up the area!");
	}
	return ResultPawn;
	//return ReturnValue;	
}

function JsonObject Serialize()
{
	return none;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	//return;	
}

function bool HasCompletedMission(name missionName)
{
	local HaloMission msn;

	// End:0x47
	foreach CompletedMissions(msn)
	{
		// End:0x46
		if(msn.missionName == missionName)
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

function bool HasCompletedObjective(name ObjectiveName)
{
	local HaloObjective Obj;

	// End:0x47
	foreach CompletedObjectives(Obj)
	{
		// End:0x46
		if(Obj.ObjectiveName == ObjectiveName)
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
	local Box mapBounds;
	local HaloPawn HP;
	local CCSController AIController;
	local Vector pos;

	// End:0x341
	if(((LevelObject != none) && bNewShouldBeLoaded!) && bNewShouldBeVisible!)
	{
		mapBounds = LevelObject.GetLevelBounds();
		// End:0x341
		if(int(mapBounds.IsValid) != int(0))
		{
			mapBounds.Max.Z += 150.0000000;
			// End:0x340
			foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloPawn', HP)
			{
				AIController = CCSController(HP.Controller);
				// End:0x33F
				if(AIController != none)
				{
					pos = HP.Location;
					// End:0x33F
					if((((((pos.X > mapBounds.Min.X) && pos.X <= mapBounds.Max.X) && pos.Y > mapBounds.Min.Y) && pos.Y <= mapBounds.Max.Y) && pos.Z > mapBounds.Min.Z) && pos.Z <= mapBounds.Max.Z)
					{
					}
				}				
			}			
		}
	}
	super(GameInfo).LevelStreamingStatusChanged(LevelObject, bNewShouldBeLoaded, bNewShouldBeVisible, bNewShouldBlockOnLoad);
	//return;	
}

function InitHaloLevelStreamingVolumes()
{
	local LevelStreamingVolume aVolume;

	// End:0x30
	foreach AllActors(Class'Engine.LevelStreamingVolume', aVolume)
	{
		LevelStreamingVolumeList.AddItem(aVolume);		
	}	
	TwoPlayerVolumeWarningMessage = new Class'MegaHaloGame.SeqAct_DisplayMessage';
	// End:0xB2
	if(TwoPlayerVolumeWarningMessage != none)
	{
		TwoPlayerVolumeWarningMessage.Title = "Stay near your squad!";
		TwoPlayerVolumeWarningMessage.DisplayTime = 0.2500000;
	}
	//return;	
}

function TickHaloLevelStreamingVolumes(float DeltaTime)
{
	local PlayerController aPC, primaryPC;
	local array<PlayerController> otherPCs;
	local Vector aLocation;
	local Rotator ARotation;
	local name Result;
	local array<LevelStreamingVolume> validVolumeList;
	local LevelStreamingVolume aVolume, bVolume;
	local HaloLevelStreamingVolume hVolume;

	// End:0xC3
	foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', aPC)
	{
		// End:0xC2
		if(HaloPlayerPawnController(aPC) != none)
		{
			// End:0x87
			if(aPC.IsPrimaryPlayer() == true)
			{
				primaryPC = aPC;
				// End:0xC2
				continue;
			}
			// End:0xC2
			if(aPC.bIsUsingStreamingVolumes == false)
			{
				otherPCs.AddItem(aPC);
			}
		}		
	}	
	// End:0xD6
	if(otherPCs.Length == 0)
	{
		return;
	}
	// End:0x161
	if((primaryPC.ViewTarget != none) && primaryPC.bIsStreamingFromViewTarget == true)
	{
		aLocation = primaryPC.ViewTarget.Location;		
	}
	else
	{
		primaryPC.GetPlayerViewPoint(aLocation, ARotation);
	}
	// End:0x25D
	foreach LevelStreamingVolumeList(aVolume)
	{
		// End:0x25C
		if(aVolume.EncompassesPoint(aLocation) == true)
		{
			validVolumeList.AddItem(aVolume);
			hVolume = HaloLevelStreamingVolume(aVolume);
			// End:0x25C
			if(hVolume != none)
			{
				// End:0x25B
				foreach hVolume.RoamingVolumes(bVolume)
				{
					validVolumeList.AddItem(bVolume);					
				}				
			}
		}		
	}	
	// End:0x494
	foreach otherPCs(aPC)
	{
		// End:0x29E
		if(aPC.IsDead() == true)
		{
			continue;			
		}
		else
		{
			// End:0x329
			if((aPC.ViewTarget != none) && aPC.bIsStreamingFromViewTarget == true)
			{
				aLocation = aPC.ViewTarget.Location;				
			}
			else
			{
				aPC.GetPlayerViewPoint(aLocation, ARotation);
			}
			Result = TestValidLevelStreamingVolumes(aLocation, validVolumeList);
			// End:0x457
			if(Result == 'Edge')
			{
				// End:0x454
				if((TwoPlayerVolumeWarningMessage != none) && TwoPlayerVolumeWarningMessageTime < WorldInfo.TimeSeconds)
				{
					TwoPlayerVolumeWarningMessageTime = (WorldInfo.TimeSeconds + 1.0500000) + TwoPlayerVolumeWarningMessage.DisplayTime;
					HaloPlayerPawnController(aPC).DisplayMessage(TwoPlayerVolumeWarningMessage);
				}				
			}
			else
			{
				// End:0x493
				if(Result == 'outside')
				{
					TetherPlayerToLevelStreamingVolumes(primaryPC, aPC, validVolumeList);
				}
			}			
		}
	}	
	//return;	
}

function name TestValidLevelStreamingVolumes(const Vector aLocation, const out array<LevelStreamingVolume> aVolumeList)
{
	local int Index;
	local float Distance;

	Index = 0;
	J0x0B:

	// End:0xCA [Loop If]
	if(Index < LevelStreamingVolumeList.Length)
	{
		// End:0xBC
		if(aVolumeList.Find(LevelStreamingVolumeList[Index]) == -1)
		{
			Distance = ClosestDistanceToLevelStreamingVolume(LevelStreamingVolumeList[Index], aLocation);
			// End:0xBC
			if(Distance < LevelStreamingVolumeWarningDistance)
			{
				return ((Distance > 1.0000000) ? 'Edge' : 'outside');
			}
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	return 'Inside';
	//return ReturnValue;	
}

function float ClosestDistanceToLevelStreamingVolume(const LevelStreamingVolume aVolume, const Vector aLocation)
{
	local Vector aPoint, bPoint, Extent, Loc;

	Loc = aLocation;
	// End:0xB1
	if(aVolume.BrushComponent != none)
	{
		// End:0xB1
		if(int(aVolume.BrushComponent.ClosestPointOnComponentToPoint(Loc, Extent, aPoint, bPoint)) == int(1))
		{
			return VSize(aLocation - bPoint);
		}
	}
	return 0.0000000;
	//return ReturnValue;	
}

function TetherPlayerToLevelStreamingVolumes(PlayerController Primary, PlayerController Other, const out array<LevelStreamingVolume> aVolumeList)
{
	local Vector bestLocation;
	local Rotator bestRotation;

	// End:0x13C
	if(HaloPlayerPawnController(Primary).FindANearbyBreadcrumbSpot(bestLocation, Other.Pawn.GetCollisionExtent()) == true)
	{
		// End:0x13C
		if((TestValidLevelStreamingVolumes(bestLocation, aVolumeList)) != 'Inside')
		{
			bestLocation = ((Primary.Pawn != none) ? Primary.Pawn.Location : Primary.Location);
			bestLocation.Z += float(500);
		}
	}
	bestRotation.Yaw = Rotator(Primary.Pawn.Location - bestLocation).Yaw;
	Other.SetLocation(bestLocation);
	Other.SetRotation(bestRotation);
	Other.OnTeleport(none);
	Other.Pawn.SetLocation(bestLocation);
	Other.Pawn.SetRotation(bestRotation);
	Other.Pawn.PlayTeleportEffect(true, true);
	//return;	
}

static event Class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	// End:0x3C
	if(InStr(Caps(Options), Caps("GameType=Besieged")) != -1)
	{
		return Class'MegaHaloGame.HaloGameBesieged';		
	}
	else
	{
		// End:0x75
		if(InStr(Caps(Options), Caps("GameType=Conquest")) != -1)
		{
			return Class'MegaHaloGame.HaloGameConquest';
		}
	}
	return super(SimpleGame).SetGameType(MapName, Options, Portal);
	//return ReturnValue;	
}

defaultproperties
{
	bIsDemoMode=true
	GameplayModeCheckIntervalSecs=1.0000000
	SecsToExitCombatMode=5.0000000
	MaxDroppedGrenades=10
	LevelStreamingVolumeWarningDistance=1000.0000000
	StartPlayerCount=1
	AlternateRespawnRadius=500.0000000
	DefaultPawnClass=Class'MegaHaloGame.HaloSpartanSoldierPawn'
	HUDType=Class'MegaHaloGame.GFxHaloHUD'
	PlayerControllerClass=Class'MegaHaloGame.HaloPlayerPawnController'
	PlayerReplicationInfoClass=Class'UTGame.UTPlayerReplicationInfo'
}