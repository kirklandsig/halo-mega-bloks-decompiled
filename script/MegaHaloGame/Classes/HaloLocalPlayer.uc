class HaloLocalPlayer extends LocalPlayer within Engine
	transient
	config(Engine);

var HaloSaveGame SaveGame;
var bool bIsFirstFrontEndLoad;
var bool bDisplayCredits;
var bool bWantsToSkipSaves;
var bool bHasSeenStartScreen;
var transient float LastSaveTime;

event string GetNickname()
{
	local string PlayerName;

	PlayerName = super.GetNickname();
	// End:0x44
	if(PlayerName == "")
	{
		PlayerName = "HaloLocalPlayer-TODO";
	}
	return PlayerName;
	//return ReturnValue;	
}

function bool SaveGameExists(int DeviceID, string LevelName)
{
	local string Filename;

	// End:0x27
	if(SaveGame == none)
	{
		SaveGame = new Class'MegaHaloGame.HaloSaveGame';
	}
	Filename = LevelName $ ".sav";
	return SaveGame.SaveGameExists(Filename, DeviceID);
	//return ReturnValue;	
}

function LoadFromFile(int DeviceID, string LevelName, int numOfPlayers)
{
	local string Filename;

	SaveGame = new Class'MegaHaloGame.HaloSaveGame';
	Filename = LevelName $ ".sav";
	SaveGame.LoadFromFile(Filename, DeviceID, LevelName, numOfPlayers);
	//return;	
}

function SaveToFile(int DeviceID, string LevelName, delegate<OnWriteSaveGameDataComplete> CallerOnWriteSaveGameDataCompleteDelegate)
{
	local string Filename;

	Filename = LevelName $ ".sav";
	// End:0x42
	if(SaveGame == none)
	{
		SaveGame = new Class'MegaHaloGame.HaloSaveGame';
	}
	SaveGame.SaveGameState();
	SaveGame.SaveToFile(Filename, DeviceID, CallerOnWriteSaveGameDataCompleteDelegate);
	//return;	
}

defaultproperties
{
	bIsFirstFrontEndLoad=true
}