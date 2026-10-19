class HaloSaveGame extends Object
	native;

const SAVEGAMESTATE_REVISION = 1;

var string PersistentMapFileName;
var array<string> StreamingMapFileNames;
var array<string> SerializedWorldData;
var transient int NumPlayers;
var transient bool InitialLoad;

static function Object GetArchetypeFromName(string ObjectArchetypeName)
{
	local WorldInfo WorldInfo;

	WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x3A
	if(WorldInfo == none)
	{
		return none;
	}
	// End:0x7D
	if(WorldInfo.IsConsoleBuild())
	{
		return FindObject(ObjectArchetypeName, Class'Core.Object');		
	}
	else
	{
		return DynamicLoadObject(ObjectArchetypeName, Class'Core.Object');
	}
	//return ReturnValue;	
}

// Export UHaloSaveGame::execBasicSerializeObject(FFrame&, void* const)
native static final function array<byte> BasicSerializeObject(Object Obj, int Version);

// Export UHaloSaveGame::execBasicDeserializeObject(FFrame&, void* const)
native static final function bool BasicDeserializeObject(Object Obj, int Version, array<byte> InSaveGameData);

function bool SaveToFile(string Filename, int DeviceID, delegate<OnWriteSaveGameDataComplete> CallerOnWriteSaveGameDataCompleteDelegate)
{
	local array<byte> SaveData;
	local OnlineSubsystem OnlineSub;

	SaveData = Class'MegaHaloGame.HaloSaveGame'.static.BasicSerializeObject(self, 1);
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x1D8
	if(OnlineSub != none)
	{
		// End:0x1D8
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			OnlineSub.ContentInterface.DeleteSaveGame(0, DeviceID, Filename, Filename);
			OnlineSub.ContentInterface.AddWriteSaveGameDataComplete(0, OnWriteSaveGameDataComplete);
			OnlineSub.ContentInterface.AddWriteSaveGameDataComplete(0, CallerOnWriteSaveGameDataCompleteDelegate);
			OnlineSub.ContentInterface.WriteSaveGameData(0, DeviceID, Filename, Filename, Filename, SaveData);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x179
	if(OnlineSub != none)
	{
		// End:0x179
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			OnlineSub.ContentInterface.ClearWriteSaveGameDataComplete(LocalUserNum, OnWriteSaveGameDataComplete);
			LogInternal((((((((((("Write save game was successful " $ string(bWasSuccessful)) $ " for user ") $ string(LocalUserNum)) $ " on device ") $ string(DeviceID)) $ " for package ") $ FriendlyName) $ " with file ") $ Filename) $ " and save file ") $ SaveFileName);
		}
	}
	//return;	
}

function bool SaveGameExists(string Filename, int DeviceID)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x8B
	if(OnlineSub != none)
	{
		return OnlineSub.ContentInterface.SaveGameExists(0, DeviceID, Filename, Filename);
	}
	return false;
	//return ReturnValue;	
}

function bool LoadFromFile(string Filename, int DeviceID, string LevelName, int numOfPlayers)
{
	local OnlineSubsystem OnlineSub;

	PersistentMapFileName = LevelName;
	NumPlayers = numOfPlayers;
	InitialLoad = true;
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x15D
	if(OnlineSub != none)
	{
		OnlineSub.ContentInterface.AddReadSaveGameDataComplete(0, OnReadSaveGameDataComplete);
		LogInternal((("Calling ReadSaveGameData for file " $ Filename) $ " on device ") $ string(DeviceID));
		OnlineSub.ContentInterface.ReadSaveGameData(0, DeviceID, Filename, Filename, Filename);
		return true;
	}
	WarnInternal("OnlineSub not setup for LoadFromFile!");
	return false;
	//return ReturnValue;	
}

function OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	local array<byte> SaveData;
	local byte bIsValid;
	local HaloGameDefault Game;
	local OnlineSubsystem OnlineSub;
	local string StartingPawnClass;
	local name SpawnPointToJumpTo;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x409
	if(OnlineSub != none)
	{
		// End:0x3CF
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(LocalUserNum, OnReadSaveGameDataComplete);
			LogInternal((((((((((("Read save game was successful " $ string(bWasSuccessful)) $ " for user ") $ string(LocalUserNum)) $ " on device ") $ string(DeviceID)) $ " for package ") $ FriendlyName) $ " with file ") $ Filename) $ " and save file ") $ SaveFileName);
			OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum, DeviceID, FriendlyName, Filename, SaveFileName, bIsValid, SaveData);
			LogInternal("SaveData bIsValid = " $ string(bool(bIsValid)));
			LogInternal("SaveData.Length = " $ string(SaveData.Length));
			OnlineSub.ContentInterface.ClearContentList(LocalUserNum, 1);
			Class'MegaHaloGame.HaloSaveGame'.static.BasicDeserializeObject(self, 1, SaveData);
			LoadGameState(StartingPawnClass, SpawnPointToJumpTo);
			Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);			
			Game.ConsoleCommand(((((((("open " $ PersistentMapFileName) $ "?GameType=Conquest?NumPlayers=") $ string(NumPlayers)) $ "?StartingPawnClass=") $ StartingPawnClass) $ "?SpawnPointToJumpTo=") $ string(SpawnPointToJumpTo)) $ "?MissionToJumpTo=");			
		}
		else
		{
			WarnInternal("OnlineSub not setup for OnlineSub.ContentInterface!");
		}		
	}
	else
	{
		WarnInternal("OnlineSub not setup for OnReadSaveGameDataComplete!");
	}
	//return;	
}

function SaveToLog()
{
	local int I;

	SaveGameState();
	LogInternal("=============================");
	LogInternal("== BEGIN SERIALIZED DATA");
	LogInternal("=============================");
	LogInternal(PersistentMapFileName);
	I = 0;
	J0x82:

	// End:0xBE [Loop If]
	if(I < StreamingMapFileNames.Length)
	{
		LogInternal(StreamingMapFileNames[I]);
		++I;
		// [Loop Continue]
		goto J0x82;
	}
	I = 0;
	J0xC9:

	// End:0x105 [Loop If]
	if(I < SerializedWorldData.Length)
	{
		LogInternal(SerializedWorldData[I]);
		++I;
		// [Loop Continue]
		goto J0xC9;
	}
	LogInternal("=============================");
	LogInternal("== END SERIALIZED DATA");
	LogInternal("=============================");
	//return;	
}

function SaveGameState()
{
	local WorldInfo WorldInfo;
	local Actor aActor;
	local JsonObject JSON;
	local string JsonString;
	local HaloSaveInterface saveGameStateInterface;
	local int I;

	LogInternal("HaloSaveGame::SaveGameState");
	SerializedWorldData.Length = 0;
	StreamingMapFileNames.Length = 0;
	WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x72
	if(WorldInfo == none)
	{
		return;
	}
	PersistentMapFileName = string(WorldInfo.GetPackageName());
	// End:0x208
	if(WorldInfo.StreamingLevels.Length > 0)
	{
		I = 0;
		J0xCD:

		// End:0x208 [Loop If]
		if(I < WorldInfo.StreamingLevels.Length)
		{
			// End:0x1FA
			if((WorldInfo.StreamingLevels[I] != none) && WorldInfo.StreamingLevels[I].bIsVisible || WorldInfo.StreamingLevels[I].bHasLoadRequestPending)
			{
				StreamingMapFileNames.AddItem(string(WorldInfo.StreamingLevels[I].PackageName));
			}
			++I;
			// [Loop Continue]
			goto J0xCD;
		}
	}
	// End:0x39D
	foreach WorldInfo.DynamicActors(Class'Engine.Actor', aActor, Class'MegaHaloGame.HaloSaveInterface')
	{
		saveGameStateInterface = HaloSaveInterface(aActor);
		// End:0x39C
		if(NotEqual_InterfaceInterface(saveGameStateInterface, HaloSaveInterface(none)))
		{
			// End:0x2EC
			if((((HaloPlayerPawnController(saveGameStateInterface) != none) || HaloPlayerInventoryManager(saveGameStateInterface) != none) || HaloVehicleCustomizationManager(saveGameStateInterface) != none) || HaloConstructionManager(saveGameStateInterface) != none)
			{
				continue;				
			}
			LogInternal("Serializing: " $ string(saveGameStateInterface));
			JSON = saveGameStateInterface.Serialize();
			// End:0x39C
			if(JSON != none)
			{
				JsonString = Class'Engine.JsonObject'.static.EncodeJson(JSON);
				// End:0x39C
				if(JsonString != "")
				{
					SerializedWorldData.AddItem(JsonString);
				}
			}
		}		
	}	
	//return;	
}

function LoadGameState(optional out string StartingPawnClass, optional out name SpawnPointToJumpTo)
{
	local WorldInfo WorldInfo;
	local int I;
	local JsonObject JsonObject;
	local string ObjectName;
	local HaloSaveInterface saveGameStateInterface;
	local Object Archetype, aObject;

	LogInternal("HaloSaveGame::LoadGameState");
	WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x84
	if(WorldInfo == none)
	{
		WarnInternal("ERROR: worldInfo could not be found!");
		return;
	}
	I = 0;
	J0x8F:

	// End:0x5DF [Loop If]
	if(I < SerializedWorldData.Length)
	{
		// End:0x5D1
		if(SerializedWorldData[I] != "")
		{
			JsonObject = Class'Engine.JsonObject'.static.DecodeJson(SerializedWorldData[I]);
			// End:0x5D1
			if(JsonObject != none)
			{
				ObjectName = JsonObject.GetStringValue("Name");
				aObject = FindObject(ObjectName, Class'Core.Object');
				LogInternal(((">>> looking for:" $ ObjectName) $ ", found:") $ string(aObject));
				// End:0x55D
				if(aObject == none)
				{
					Archetype = GetArchetypeFromName(JsonObject.GetStringValue("ObjectArchetype"));
					// End:0x55D
					if(Archetype != none)
					{
						// End:0x3E3
						if(ClassIsChildOf(Archetype.Class, Class'Engine.GameInfo') == true)
						{
							StartingPawnClass = JsonObject.GetStringValue("CharacterRole");
							SpawnPointToJumpTo = name(JsonObject.GetStringValue("CurrentRespawnPointName"));
							// End:0x38E
							if(!InitialLoad && WorldInfo.Game.Class == Archetype.Class)
							{
								LogInternal(((">>> setting world info:" $ ObjectName) $ ", type:") $ string(Archetype.Class));
								aObject = WorldInfo.Game;								
							}
							else
							{
								LogInternal(((">>> grabbing initial world info:" $ StartingPawnClass) $ ", spawn point:") $ string(SpawnPointToJumpTo));
								goto J0x5D1;
							}							
						}
						else
						{
							// End:0x4E6
							if(ClassIsChildOf(Archetype.Class, Class'Engine.Actor') == true)
							{
								aObject = none;
								// End:0x4E3
								if(HaloGameConquest(WorldInfo.Game) != none)
								{
									LogInternal(((">>> caching actor:" $ ObjectName) $ ", type:") $ string(Archetype.Class));
									HaloGameConquest(WorldInfo.Game).PersistedActorCache.AddItem(JsonObject);
								}								
							}
							else
							{
								LogInternal(((">>> creating:" $ ObjectName) $ ", type:") $ string(Archetype.Class));
								aObject = new Archetype.Class;
							}
						}
					}
				}
				// End:0x5D1
				if(aObject != none)
				{
					saveGameStateInterface = HaloSaveInterface(aObject);
					// End:0x5D1
					if(NotEqual_InterfaceInterface(saveGameStateInterface, HaloSaveInterface(none)))
					{
						saveGameStateInterface.Deserialize(JsonObject);
					}
				}
			}
		}
		J0x5D1:

		++I;
		// [Loop Continue]
		goto J0x8F;
	}
	InitialLoad = false;
	//return;	
}
