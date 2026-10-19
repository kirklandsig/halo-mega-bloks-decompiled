class HaloGameConquest extends HaloGameDefault
	config(Game)
	implements(HaloSaveInterface);

var float CheckpointId;
var PlayerStart CheckpointRespawnPoint;
var bool bHasSentCheckpointLoadedEvent;
var bool bASyncWasLoading;
var array<JsonObject> PersistedActorCache;
var array<Actor> UnloadedPersistableActorsCache;

event InitGame(string Options, out string ErrorMessage)
{
	CheckpointId = -1.0000000;
	LogInternal(string(self) $ ": HaloGameConquest::InitGame");
	super.InitGame(Options, ErrorMessage);
	// End:0x11F
	if((ParseOption(Options, "StartingPawnClass")) != "")
	{
		LogInternal("Setting DefaultPawnClass to " $ (ParseOption(Options, "StartingPawnClass")));
		DefaultPawnClass = Class<Pawn>(Class'MegaHaloGame.HaloSaveGame'.static.GetArchetypeFromName(ParseOption(Options, "StartingPawnClass")));
	}
	//return;	
}

function PostBeginPlay()
{
	LogInternal(string(self) $ ": HaloGameConquest::PostBeginPlay");
	super.PostBeginPlay();
	//return;	
}

function StartMatch()
{
	local HaloPlayerPawnController aPC;

	LogInternal(string(self) $ ": HaloGameConquest::StartMatch");
	super.StartMatch();
	// End:0xFD
	foreach WorldInfo.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', aPC)
	{
		// End:0xFC
		if(HaloLocalPlayer(aPC.Player).SaveGame != none)
		{
			HaloLocalPlayer(aPC.Player).SaveGame.LoadGameState();
		}		
	}	
	//return;	
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	// End:0x54
	if(IsAsyncLoadingActive())
	{
		// End:0x45
		if(!bHasSentCheckpointLoadedEvent)
		{
			SendCheckPointLoadedEvent();
			bHasSentCheckpointLoadedEvent = true;
		}
		bASyncWasLoading = true;		
	}
	else
	{
		// End:0x77
		if(bASyncWasLoading)
		{
			ApplyPersistedDataToLevelActors();
			bASyncWasLoading = false;
		}
	}
	//return;	
}

function ApplyPersistedDataToLevelActors()
{
	local Actor Actor;
	local JsonObject ActorData;
	local string actorName;
	local HaloSaveInterface saveGameStateInterface;
	local array<JsonObject> foundActorData;

	// End:0x197
	if(PersistedActorCache.Length > 0)
	{
		// End:0x167
		foreach PersistedActorCache(ActorData)
		{
			actorName = ActorData.GetStringValue("Name");
			Actor = Actor(FindObject(actorName, Class'Engine.Actor'));
			// End:0x166
			if(Actor != none)
			{
				saveGameStateInterface = HaloSaveInterface(Actor);
				// End:0x14D
				if(NotEqual_InterfaceInterface(saveGameStateInterface, HaloSaveInterface(none)))
				{
					LogInternal("Applying persisted data settings over new streamed in world object: " $ actorName);
					saveGameStateInterface.Deserialize(ActorData);
				}
				foundActorData.AddItem(ActorData);				
			}			
		}		
		// End:0x196
		foreach foundActorData(ActorData)
		{
			PersistedActorCache.RemoveItem(ActorData);			
		}		
	}
	//return;	
}

function SendCheckPointLoadedEvent()
{
	local string cpEvent;

	// End:0x8C
	if(CheckpointId != float(-1))
	{
		cpEvent = Repl("CPLoad_" $ string(CheckpointId), "000", "");
		LogInternal("Game fully loaded, sending remote event " $ cpEvent);
		SendRemoteEvent(name(cpEvent));
	}
	//return;	
}

function Logout(Controller Exiting)
{
	LogInternal((((string(self) $ ": HaloGameConquest::Logout: Controller ") $ string(Exiting)) $ " leaving map ") $ WorldInfo.GetMapName(true));
	// End:0xE8
	if(WorldInfo.GetMapName(true) != "Main_Menu")
	{
		HaloLocalPlayer(HaloPlayerPawnController(Exiting).Player).SaveGame = none;
	}
	super(GameInfo).Logout(Exiting);
	//return;	
}

exec function SaveCheckpoint(float cpId, optional delegate<OnWriteSaveGameDataComplete> CallerOnWriteSaveGameDataCompleteDelegate)
{
	local HaloPlayerPawnController PC;

	CheckpointId = cpId;
	// End:0x167
	if(CurrentRespawnPoint != none)
	{
		// End:0x163
		foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
		{
			LogInternal((((string(PC) $ ": SaveCheckpoint called for checkpoint ") $ string(CheckpointId)) $ " and CurrentRespawnPoint") $ string(CurrentRespawnPoint));
			HaloLocalPlayer(PC.Player).SaveToFile(PC.GetDeviceId(), string(WorldInfo.GetPackageName()), CallerOnWriteSaveGameDataCompleteDelegate);			
		}				
	}
	else
	{
		WarnInternal("ERROR: No CurrentRespawnPoint is set, not saving!");
	}
	//return;	
}

exec function DebugLogCheckpoint()
{
	local HaloPlayerPawnController aPC;

	LogInternal("DebugLogCheckpoint called");
	// End:0xE7
	foreach WorldInfo.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', aPC)
	{
		// End:0xE6
		if(HaloLocalPlayer(aPC.Player).SaveGame != none)
		{
			HaloLocalPlayer(aPC.Player).SaveGame.SaveToLog();
		}		
	}	
	//return;	
}

exec function bool RestoreCheckpoint()
{
	local HaloPlayerPawnController aPC;

	LogInternal("RestoreCheckpoint called");
	// End:0xD8
	foreach WorldInfo.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', aPC)
	{
		HaloLocalPlayer(aPC.Player).LoadFromFile(aPC.GetDeviceId(), string(WorldInfo.GetPackageName()), StartPlayerCount);		
	}	
	return true;
	//return ReturnValue;	
}

function JsonObject Serialize()
{
	local JsonObject serializedGameData, serializedObjData;
	local HaloPlayerPawnController HPC;
	local HaloMission mission;
	local HaloObjective Objective;
	local int I;

	serializedGameData = new Class'Engine.JsonObject';
	// End:0x67D
	if(serializedGameData != none)
	{
		serializedGameData.SetStringValue("Name", PathName(self));
		serializedGameData.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
		serializedObjData = super.Serialize();
		// End:0xF1
		if(serializedObjData != none)
		{
			serializedGameData.SetObject("ParentData", serializedObjData);
		}
		serializedGameData.SetFloatValue("CheckpointId", CheckpointId);
		serializedGameData.SetStringValue("CurrentRespawnPointName", string(CurrentRespawnPoint.Name));
		I = 0;
		// End:0x381
		foreach WorldInfo.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', HPC)
		{
			// End:0x380
			if(LocalPlayer(HPC.Player) != none)
			{
				serializedObjData = HPC.Serialize();
				// End:0x380
				if(serializedObjData != none)
				{
					serializedObjData.SetIntValue("LocalPlayer.ControllerId", LocalPlayer(HPC.Player).ControllerId);
					serializedGameData.SetObject("HaloPlayerPawnController_" $ string(I), serializedObjData);
					// End:0x375
					if(HPC.IsPrimaryPlayer())
					{
						serializedGameData.SetStringValue("CharacterRole", PathName(HPC.Pawn.Class));
					}
					I++;
				}
			}			
		}		
		serializedGameData.SetIntValue("HaloPlayerPawnControllerCount", I);
		I = 0;
		// End:0x468
		foreach CompletedMissions(mission)
		{
			serializedObjData = mission.Serialize();
			serializedGameData.SetObject("CompletedMission_" $ string(I), serializedObjData);
			I++;			
		}		
		serializedGameData.SetIntValue("CompletedMissionCount", I);
		I = 0;
		// End:0x549
		foreach CompletedObjectives(Objective)
		{
			serializedObjData = Objective.Serialize();
			serializedGameData.SetObject("CompletedObjective_" $ string(I), serializedObjData);
			I++;			
		}		
		serializedGameData.SetIntValue("CompletedObjectiveCount", I);
		// End:0x600
		if(TheConstructionManager != none)
		{
			serializedObjData = TheConstructionManager.Serialize();
			serializedGameData.SetObject("ConstructionManager", serializedObjData);
		}
		// End:0x67D
		if(TheCustomizationManager != none)
		{
			serializedObjData = TheCustomizationManager.Serialize();
			serializedGameData.SetObject("VehicleCustomizationManager", serializedObjData);
		}
	}
	return serializedGameData;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	local JsonObject serializedObjData;
	local HaloPlayerPawnController PC;
	local HaloMission mission;
	local HaloObjective Objective;
	local int objCnt, I;

	LogInternal("Deserializing HaloGameConquest");
	serializedObjData = Data.GetObject("ParentData");
	// End:0x7A
	if(serializedObjData != none)
	{
		super.Deserialize(serializedObjData);
	}
	objCnt = Data.GetIntValue("HaloPlayerPawnControllerCount");
	I = 0;
	J0xCD:

	// End:0x1D9 [Loop If]
	if(I < objCnt)
	{
		serializedObjData = Data.GetObject("HaloPlayerPawnController_" $ string(I));
		// End:0x1CA
		foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
		{
			// End:0x1C9
			if(PC.IsPrimaryPlayer())
			{
				PC.Deserialize(serializedObjData);
			}			
		}		
		I++;
		// [Loop Continue]
		goto J0xCD;
	}
	// End:0x2D6
	if(Data.GetStringValue("CharacterRole") != "")
	{
		DefaultPawnClass = Class<Pawn>(Class'MegaHaloGame.HaloSaveGame'.static.GetArchetypeFromName(Data.GetStringValue("CharacterRole")));
		LogInternal((("Starting as character role/class " $ string(DefaultPawnClass)) $ " ") $ Data.GetStringValue("CharacterRole"));
	}
	CompletedMissions.Length = 0;
	objCnt = Data.GetIntValue("CompletedMissionCount");
	I = 0;
	J0x32D:

	// End:0x43A [Loop If]
	if(I < objCnt)
	{
		serializedObjData = Data.GetObject("CompletedMission_" $ string(I));
		mission = new Class'MegaHaloGame.HaloMission';
		mission.Deserialize(serializedObjData);
		LogInternal("Loaded in with completed mission: " $ string(mission.missionName));
		CompletedMissions.AddItem(mission);
		I++;
		// [Loop Continue]
		goto J0x32D;
	}
	CompletedObjectives.Length = 0;
	objCnt = Data.GetIntValue("CompletedObjectiveCount");
	I = 0;
	J0x493:

	// End:0x5A4 [Loop If]
	if(I < objCnt)
	{
		serializedObjData = Data.GetObject("CompletedObjective_" $ string(I));
		Objective = new Class'MegaHaloGame.HaloObjective';
		Objective.Deserialize(serializedObjData);
		LogInternal("Loaded in with completed objective: " $ string(Objective.ObjectiveName));
		CompletedObjectives.AddItem(Objective);
		I++;
		// [Loop Continue]
		goto J0x493;
	}
	serializedObjData = Data.GetObject("ConstructionManager");
	// End:0x62A
	if((serializedObjData != none) && TheConstructionManager != none)
	{
		TheConstructionManager.Deserialize(serializedObjData);
	}
	serializedObjData = Data.GetObject("VehicleCustomizationManager");
	// End:0x6B8
	if((serializedObjData != none) && TheCustomizationManager != none)
	{
		TheCustomizationManager.Deserialize(serializedObjData);
	}
	SpawnPointToJumpTo = name(Data.GetStringValue("CurrentRespawnPointName"));
	LogInternal((string(self) $ ": Initial load spawn point: ") $ string(SpawnPointToJumpTo));
	CheckpointId = Data.GetFloatValue("CheckpointId");
	LogInternal((string(self) $ ": Initial check point: ") $ string(CheckpointId));
	//return;	
}
