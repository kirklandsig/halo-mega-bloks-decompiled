class GFxHaloPauseMenu extends GFxHaloMoviePlayer
	config(UI);

var GFxObject menu;
var GFxHaloObjectiveMap ObjectiveMap;
var HaloMission ActiveMission;
var HaloObjective ActiveObjective;
var const localized string ObjectiveDescriptionNotSet;
var string MissingMissionImagePath;
var const localized string MissionNameNotSet;
var const localized string MissionDescriptionNotSet;
var Halo3DMapActor MapActor;

function bool Start(optional bool StartPaused = false)
{
	super(GFxMoviePlayer).Start();
	Advance(0.0000000);
	OpenMenu();
	return true;
	//return ReturnValue;	
}

function RegisterMenu(GFxObject MC)
{
	menu = MC;
	//return;	
}

function InitializeMap(GFxHaloObjectiveMap Map)
{
	ObjectiveMap = Map;
	ObjectiveMap.Init();
	//return;	
}

function OpenMenu()
{
	InitializeLevelInfo();
	menu.ActionScriptVoid("openMenu");
	PostAkEvent(AkEvent'Global.Pause_Master');
	Create3DMap();
	//return;	
}

function CloseMenu()
{
	menu.ActionScriptVoid("closeMenu");
	Destroy3DMap();
	//return;	
}

event OnClose()
{
	Destroy3DMap();
	//return;	
}

function Create3DMap()
{
	local Vector MapLocation;

	MapLocation.X = 0.0000000;
	MapLocation.Y = 0.0000000;
	MapLocation.Z = 0.0000000;
	LogInternal("Spawning Map Actor...");
	MapActor = Class'Engine.WorldInfo'.static.GetWorldInfo().Spawn(Class'MegaHaloGame.Halo3DMapActor', GetPC(),, MapLocation,,, true);
	// End:0x14A
	if(MapActor != none)
	{
		LogInternal("Map Actor Spawned");
		SetExternalTexture("mapR2T", MapActor.SceneCapture.TextureTarget);
	}
	//return;	
}

function Destroy3DMap()
{
	// End:0x32
	if(MapActor != none)
	{
		MapActor.Destroy();
		MapActor = none;
	}
	//return;	
}

function ToggleZoom()
{
	// End:0x2E
	if(ObjectiveMap != none)
	{
		ObjectiveMap.ToggleZoom();
	}
	//return;	
}

function ResumeGame()
{
	GFxHaloHUDBase(GetPC().myHUD).CompletePauseMenuClose();
	PostAkEvent(AkEvent'Global.Resume_Master');
	//return;	
}

function QuitGame()
{
	local HaloGameDefault Game;

	PostAkEvent(AkEvent'Global.Resume_Master');
	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xE5
	if(Game != none)
	{
		// End:0xAF
		if(Game.bIsDemoMode)
		{
			ConsoleCommand("open Main_Menu_VSLICE");			
		}
		else
		{
			ConsoleCommand("open " $ Game."Main_Menu");
		}		
	}
	else
	{
		WarnInternal("Game is not of type HaloGameDefault");
	}
	//return;	
}

function SaveGame()
{
	local HaloGameConquest Game;

	Game = HaloGameConquest(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x103
	if(Game != none)
	{
		// End:0xB2
		if(Game.bIsDemoMode)
		{
			QuitGame();
			menu.ActionScriptVoid("saveComplete");			
		}
		else
		{
			Game.SaveCheckpoint(Game.CheckpointId, NotifyMenu_SaveComplete);
		}		
	}
	else
	{
		WarnInternal("Game is not of type HaloGameConquest and thus not savable");
		QuitGame();
		menu.ActionScriptVoid("saveComplete");
	}
	//return;	
}

function NotifyMenu_SaveComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xBC
	if(OnlineSub != none)
	{
		// End:0xBC
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(LocalUserNum, NotifyMenu_SaveComplete);
		}
	}
	QuitGame();
	menu.ActionScriptVoid("saveComplete");
	//return;	
}

function InitializeLevelInfo()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xCE
	if(Game != none)
	{
		ActiveMission = Game.GetActiveMission();
		// End:0xCE
		if(ActiveMission != none)
		{
			// End:0xCD
			foreach ActiveMission.Objectives(ActiveObjective)
			{
				// End:0xCC
				if(ActiveObjective != none)
				{					
					return;
				}				
			}			
		}
	}
	//return;	
}

function string GetMissionName()
{
	// End:0x53
	if(ActiveMission != none)
	{
		// End:0x53
		if(ActiveMission.DisplayName != "")
		{
			return ActiveMission.DisplayName;
		}
	}
	return MissionNameNotSet;
	//return ReturnValue;	
}

function string GetMissionImage()
{
	// End:0x61
	if(ActiveMission != none)
	{
		// End:0x61
		if(ActiveMission.DisplayImagePath != name(""))
		{
			return "img://" $ string(ActiveMission.DisplayImagePath);
		}
	}
	return MissingMissionImagePath;
	//return ReturnValue;	
}

function string GetMissionDescription()
{
	// End:0x53
	if(ActiveMission != none)
	{
		// End:0x53
		if(ActiveMission.DisplayDescription != "")
		{
			return ActiveMission.DisplayDescription;
		}
	}
	return MissionDescriptionNotSet;
	//return ReturnValue;	
}

function string GetObjectiveDescription()
{
	// End:0x53
	if(ActiveObjective != none)
	{
		// End:0x53
		if(ActiveObjective.DisplayDescription != "")
		{
			return ActiveObjective.DisplayDescription;
		}
	}
	return ObjectiveDescriptionNotSet;
	//return ReturnValue;	
}

function int GetUnlockedVehicleCustomizationCount()
{
	local HaloGameDefault Game;
	local HaloVehicleCustomizationManager HVCM;
	local int I;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x162
	if(Game != none)
	{
		HVCM = Game.TheCustomizationManager;
		// End:0x162
		if(HVCM != none)
		{
			I = 0;
			J0x98:

			// End:0x162 [Loop If]
			if(I < HVCM.HVCC_MasterAddonArray.Length)
			{
				// End:0x154
				if(HVCM.HVCC_MasterAddonArray[I].ClassToSpawn == Class'MegaHaloGame.HVCCAddon_MagWinch')
				{
					// End:0x152
					if(HVCM.HVCC_MasterAddonArray[I].Unlocked)
					{
						return 1;						
					}
					else
					{
						return 0;
					}
				}
				I++;
				// [Loop Continue]
				goto J0x98;
			}
		}
	}
	return 0;
	//return ReturnValue;	
}

function int GetUnlockedBlueprintCount()
{
	local HaloGameDefault Game;
	local HaloConstructionManager HCM;
	local int Count;

	Count = 0;
	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xF6
	if(Game != none)
	{
		HCM = Game.TheConstructionManager;
		// End:0xF6
		if(HCM != none)
		{
			// End:0xC7
			if(HCM.IsBlueprintUnlockedFromType(0))
			{
				Count++;
			}
			// End:0xF6
			if(HCM.IsBlueprintUnlockedFromType(2))
			{
				Count++;
			}
		}
	}
	return Count;
	//return ReturnValue;	
}

function InvertControls()
{
	local PlayerController PC;

	PC = GetPC();
	// End:0x61
	if(PC != none)
	{
		PC.PlayerInput.InvertMouse();
		SaveSettingsToProfile();
	}
	//return;	
}

function bool GetInvertControls()
{
	local PlayerController PC;

	PC = GetPC();
	// End:0x58
	if(PC != none)
	{
		return PC.PlayerInput.bInvertMouse;
	}
	return false;
	//return ReturnValue;	
}

function ToggleMarkAutoAimTargets()
{
	local HaloPlayerPawnController HPPC;

	HPPC = HaloPlayerPawnController(GetPC());
	// End:0x7C
	if(HPPC != none)
	{
		HPPC.bMarkAutoAimTargets = ((HPPC.bMarkAutoAimTargets) ? false : true);
		SaveSettingsToProfile();
	}
	//return;	
}

function bool GetMarkAutoAimTargets()
{
	local HaloPlayerPawnController HPPC;

	HPPC = HaloPlayerPawnController(GetPC());
	// End:0x4C
	if(HPPC != none)
	{
		return HPPC.bMarkAutoAimTargets;
	}
	return false;
	//return ReturnValue;	
}

function ToggleEncounterCamera()
{
	local HaloPlayerPawnController PC;

	PC = HaloPlayerPawnController(GetPC());
	// End:0x55
	if(PC != none)
	{
		PC.CameraEncounterViewToggle();
		SaveSettingsToProfile();
	}
	//return;	
}

function bool GetEncounterCamera()
{
	local HaloPlayerPawnController PC;

	PC = HaloPlayerPawnController(GetPC());
	// End:0x4C
	if(PC != none)
	{
		return PC.CameraEncounterViewIsEnabled();
	}
	return false;
	//return ReturnValue;	
}

function SaveSettingsToProfile()
{
	local HaloPlayerPawnController HPPC;
	local HaloGameDefault Game;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x2DA
	if(Game != none)
	{
		// End:0x2DA
		if(Game.bIsDemoMode!)
		{
			HPPC = HaloPlayerPawnController(GetPC());
			// End:0x2DA
			if(HPPC != none)
			{
				LogInternal((((("SAVING NOW ###### " $ string(int(HPPC.PlayerInput.bInvertMouse))) $ " ") $ string(int(HPPC.bMarkAutoAimTargets))) $ " ") $ string(int(HPPC.CameraEncounterViewIsEnabled())));
				HPPC.ProfileSettings.SetProfileSettingValueId(2, int(HPPC.PlayerInput.bInvertMouse));
				HPPC.ProfileSettings.SetProfileSettingValueId(HPPC.ProfileSettings.34, int(HPPC.bMarkAutoAimTargets));
				HPPC.ProfileSettings.SetProfileSettingValueId(HPPC.ProfileSettings.36, int(HPPC.CameraEncounterViewIsEnabled()));
				HPPC.ClientSaveAllPlayerData(true, true);
			}
		}
	}
	//return;	
}

function Tick()
{
	//return;	
}

function int GetCurrentBlokTotal()
{
	//return ReturnValue;	
}

function PurchaseBloks()
{
	//return;	
}

function SpendBloks()
{
	//return;	
}

function NotifyMenu_UpdateBlokTotal()
{
	menu.ActionScriptVoid("updateBlokTotal");
	//return;	
}

defaultproperties
{
	ObjectiveDescriptionNotSet="Objective Description ID not set"
	MissingMissionImagePath="img://UI_GlobalTextures.MissionImg_NotSet"
	MissionNameNotSet="Mission Name ID not set"
	MissionDescriptionNotSet="Mission Description ID not set"
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloPauseMenu"
	bPauseGameWhileActive=true
	bCaptureInput=true
}