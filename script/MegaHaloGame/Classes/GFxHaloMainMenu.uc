class GFxHaloMainMenu extends GFxHaloMoviePlayer
	config(Levels);

struct CampaignMissionInfo
{
	var string DisplayName;
	var string DisplayDescription;
	var name LevelToLoad;
	var name MissionOptions;

	structdefaultproperties
	{
		DisplayName=""
		DisplayDescription=""
		LevelToLoad="None"
		MissionOptions="None"
	}
};

struct LevelInfo
{
	var string DisplayName;
	var string DisplayDescription;
	var name LevelToLoad;

	structdefaultproperties
	{
		DisplayName=""
		DisplayDescription=""
		LevelToLoad="None"
	}
};

struct TestLevelInfo
{
	var string DisplayName;
	var string DisplayDescription;
	var name LevelToLoad;

	structdefaultproperties
	{
		DisplayName=""
		DisplayDescription=""
		LevelToLoad="None"
	}
};

var GFxObject menu;
var bool bIsDemoMode;
var bool bOnTitleScreen;
var bool bIsInStartupProcess;
var bool bHasInactiveControllers;
var transient bool bAllowGuestLogin;
var transient bool bRestartFrontEndAfterStartSequence;
var bool InvertCamera;
var config array<config CampaignMissionInfo> CampaignMissionsArray;
var config array<config LevelInfo> LevelsArray;
var config array<config TestLevelInfo> TestLevelsArray;
var transient OnlineSubsystem OnlineSub;
var transient int PressedStartControllerId;
var GFxClikWidget StartButton;

function bool Start(optional bool StartPaused = false)
{
	local HaloLocalPlayer HaloLocPlay;
	local HaloPlayerPawnController PC;
	local HaloGameDefault Game;

	PC = HaloPlayerPawnController(GetPC());
	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xA2
	if(Game != none)
	{
		bIsDemoMode = Game.bIsDemoMode;
	}
	super(GFxMoviePlayer).Start();
	PlayAkEvent(AkEvent'Music.Play_PrototypeMenu');
	Advance(0.0000000);
	HaloLocPlay = HaloLocalPlayer(GetPC().Player);
	HaloLocPlay.bIsFirstFrontEndLoad = false;
	// End:0x152
	if(PC != none)
	{
		PC.bIsReturningToMainMenu = false;
	}
	bOnTitleScreen = true;
	bIsInStartupProcess = true;
	bRestartFrontEndAfterStartSequence = false;
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x2C8
	if(OnlineSub != none)
	{
		// End:0x1E3
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
		{
		}
		// End:0x25E
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
		}
		// End:0x293
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
		{
		}
		// End:0x2C8
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
		}
	}
	return true;
	//return ReturnValue;	
}

function RegisterMenu(GFxObject MC)
{
	menu = MC;
	//return;	
}

event OnClose()
{
	// End:0x17F
	if(OnlineSub != none)
	{
		// End:0x44
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
		{
		}
		// End:0xBF
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
		}
		// End:0xF4
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
		{
		}
		// End:0x17F
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			OnlineSub.ContentInterface.ClearSaveGames(byte(GetLP().ControllerId));
		}
	}
	//return;	
}

function BeginFadeOutSequence()
{
	PlayAkEvent(AkEvent'Music.Stop_PrototypeMenu');
	//return;	
}

function bool SavedGameExists()
{
	local HaloPlayerPawnController PC;
	local name Level;

	PC = HaloPlayerPawnController(GetPC());
	Level = CampaignMissionsArray[0].LevelToLoad;
	return HaloLocalPlayer(PC.Player).SaveGameExists(PC.GetDeviceId(), string(Level));
	//return ReturnValue;	
}

function PlayNow(optional int NumPlayers = 1)
{
	local name Level;
	local HaloPlayerPawnController PC;

	Level = CampaignMissionsArray[0].LevelToLoad;
	PC = HaloPlayerPawnController(GetPC());
	HaloLocalPlayer(PC.Player).LoadFromFile(PC.GetDeviceId(), string(Level), NumPlayers);
	//return;	
}

function array<string> GetMissionNames()
{
	local array<string> returnArray;
	local CampaignMissionInfo tempMissionData;

	// End:0x41
	foreach CampaignMissionsArray(tempMissionData)
	{
		returnArray.AddItem(tempMissionData.DisplayName);		
	}	
	return returnArray;
	//return ReturnValue;	
}

function string GetMissionDescription(int SelectedIndex)
{
	return CampaignMissionsArray[SelectedIndex].DisplayDescription;
	//return ReturnValue;	
}

function LoadMission(int SelectedIndex, optional int NumPlayers = 1)
{
	local name Level, mission;
	local string LoadLevelCommandStr;

	Level = CampaignMissionsArray[SelectedIndex].LevelToLoad;
	mission = CampaignMissionsArray[SelectedIndex].MissionOptions;
	LogInternal("----- LOAD -----");
	LogInternal("LEVEL: " $ string(Level));
	LogInternal("MISSION: " $ string(mission));
	LogInternal("PLAYERS: " $ string(NumPlayers));
	LoadLevelCommandStr = ((((("open " $ string(Level)) $ "?GameType=Conquest?MissionToJumpTo=") $ string(mission)) $ "?NumPlayers=") $ string(NumPlayers)) $ "?SpawnPointToJumpTo=?StartingPawnClass=";
	ConsoleCommand(LoadLevelCommandStr);
	//return;	
}

function array<string> GetLevelNames()
{
	local array<string> returnArray;
	local LevelInfo tempLevelData;

	// End:0x41
	foreach LevelsArray(tempLevelData)
	{
		returnArray.AddItem(tempLevelData.DisplayName);		
	}	
	return returnArray;
	//return ReturnValue;	
}

function string GetLevelDescription(int SelectedIndex)
{
	return LevelsArray[SelectedIndex].DisplayDescription;
	//return ReturnValue;	
}

function LoadLevel(int SelectedIndex, optional int NumPlayers = 1)
{
	local name Level;
	local string LoadLevelCommandStr;

	Level = LevelsArray[SelectedIndex].LevelToLoad;
	LogInternal("----- LOAD NON-MISSION LEVEL-----");
	LogInternal("LEVEL: " $ string(Level));
	LogInternal("PLAYERS: " $ string(NumPlayers));
	LoadLevelCommandStr = ((("open " $ string(Level)) $ "?GameType=Besieged?NumPlayers=") $ string(NumPlayers)) $ "?MissionToJumpTo=?SpawnPointToJumpTo=?StartingPawnClass=";
	ConsoleCommand(LoadLevelCommandStr);
	//return;	
}

function array<string> GetTestNames()
{
	local array<string> returnArray;
	local TestLevelInfo tempLevelData;

	// End:0x41
	foreach TestLevelsArray(tempLevelData)
	{
		returnArray.AddItem(tempLevelData.DisplayName);		
	}	
	return returnArray;
	//return ReturnValue;	
}

function string GetTestDescription(int SelectedIndex)
{
	return TestLevelsArray[SelectedIndex].DisplayDescription;
	//return ReturnValue;	
}

function LoadTest(int SelectedIndex, optional int NumPlayers = 1)
{
	local name Level;
	local HaloPlayerPawnController PC;
	local string LoadLevelCommandStr;

	Level = TestLevelsArray[SelectedIndex].LevelToLoad;
	LogInternal("----- LOAD -----");
	LogInternal("TEST LEVEL: " $ string(Level));
	LogInternal("PLAYERS: " $ string(NumPlayers));
	// End:0x13B
	if(!bIsDemoMode && Level == 'Streaming_Test_Persistent')
	{
		PC = HaloPlayerPawnController(GetPC());
		HaloLocalPlayer(PC.Player).LoadFromFile(PC.GetDeviceId(), string(Level), NumPlayers);		
	}
	else
	{
		LoadLevelCommandStr = ((("open " $ string(Level)) $ "?GameType=Conquest?NumPlayers=") $ string(NumPlayers)) $ "?MissionToJumpTo=?SpawnPointToJumpTo=?StartingPawnClass=";
	}
	ConsoleCommand(LoadLevelCommandStr);
	//return;	
}

function StartInitialLogin(int ControllerIdx)
{
	local int PlayerIndex;
	local GameViewportClient VPClient;
	local Engine Eng;
	local bool bWasPlayerFound;

	PressedStartControllerId = ControllerIdx;
	LogInternal("StartInitialLogin: " $ string(PressedStartControllerId));
	ConditionalShowLoginUI(ControllerIdx, true);
	Eng = Class'Engine.Engine'.static.GetEngine();
	PlayerIndex = 0;
	J0x80:

	// End:0x115 [Loop If]
	if(PlayerIndex < Eng.GamePlayers.Length)
	{
		// End:0x107
		if(Eng.GamePlayers[PlayerIndex].ControllerId == PressedStartControllerId)
		{
			bWasPlayerFound = true;
			// [Explicit Break]
			goto J0x115;
		}
		PlayerIndex++;
		// [Loop Continue]
		goto J0x80;
	}
	J0x115:

	// DebugMode: 0
	assert(bWasPlayerFound);
	VPClient = Eng.GamePlayers[PlayerIndex].ViewportClient;
	// End:0x1CA
	if(VPClient != none)
	{
		LogInternal("VPClient setting to " $ string(PlayerIndex));
		VPClient.BecomePrimaryPlayer(PlayerIndex);		
	}
	else
	{
		LogInternal("VPClient was NULL!");
	}
	AdvanceFromStartScreen();
	//return;	
}

function bool ConditionalShowLoginUI(int ControllerId, optional bool bAllowGuest)
{
	local HaloPlayerPawnController PC;

	PC = HaloPlayerPawnController(GetPC());
	// End:0x1D2
	if((PC != none) && !bIsDemoMode)
	{
		// End:0x1D2
		if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			// End:0x1D2
			if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId))) == int(0)) && int(GetPC().Role) == int(ROLE_Authority))
			{
				PC.bProfileSettingsReadComplete = false;
				// End:0x184
				if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
				{
					OnlineSub.PlayerInterface.ShowLoginUI(!bAllowGuest);					
				}
				else
				{
					OnlineSub.PlayerInterface.Login(byte(PressedStartControllerId), "Player1", "", true);
				}
				return true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

function AdvanceFromStartScreen()
{
	// End:0x29
	if(PressedStartControllerId != -1)
	{
		bIsInStartupProcess = true;
		PerformProfileAndPlayerStorageChecks();
	}
	//return;	
}

function PerformProfileAndPlayerStorageChecks()
{
	local bool bIsBlockingForRead;
	local HaloPlayerPawnController PC;
	local HaloLocalPlayer LP;

	PC = HaloPlayerPawnController(GetPC());
	// End:0x54D
	if(((((PC != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PressedStartControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PressedStartControllerId)))
	{
		LP = HaloLocalPlayer(PC.Player);
		// End:0x23D
		if((!PC.bProfileSettingsReadComplete || int(PC.ProfileSettings.AsyncState) == int(0)) || int(PC.ProfileSettings.AsyncState) == int(1))
		{
			OnlineSub.PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(PressedStartControllerId), OnReadProfileSettingsComplete);
			bIsBlockingForRead = true;			
		}
		else
		{
			// End:0x403
			if((((((LP != none) && !LP.bHasSeenStartScreen) && PC.OnlinePlayerData != none) && PC.OnlinePlayerData.StorageProvider != none) && PC.PersistentData != none) && int(PC.PersistentData.AsyncState) < int(3))
			{
				LP.bHasSeenStartScreen = true;
				OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
				PC.OnlinePlayerData.StorageProvider.RefreshStorageData();
				bIsBlockingForRead = true;				
			}
			else
			{
				// End:0x54D
				if((PC.PersistentData != none) && (int(PC.PersistentData.AsyncState) == int(0)) || int(PC.PersistentData.AsyncState) == int(1))
				{
					OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
					PC.OnlinePlayerData.StorageProvider.RefreshStorageData();
					bIsBlockingForRead = true;
				}
			}
		}
	}
	// End:0x566
	if(!bIsBlockingForRead)
	{
		PerformPostReadChecks();
	}
	//return;	
}

function OnReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
	OnlineSub.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
	CheckForReadsAndAdvance();
	//return;	
}

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
	OnlineSub.PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(PressedStartControllerId), OnReadProfileSettingsComplete);
	CheckForReadsAndAdvance();
	//return;	
}

function CheckForReadsAndAdvance()
{
	local HaloPlayerPawnController PC;

	PC = HaloPlayerPawnController(GetPC());
	// End:0x152
	if(PC != none)
	{
		// End:0x152
		if(((int(PC.ProfileSettings.AsyncState) == int(1)) || int(PC.ProfileSettings.AsyncState) == int(0)) || (PC.PersistentData != none) && (int(PC.PersistentData.AsyncState) == int(1)) || int(PC.PersistentData.AsyncState) == int(0))
		{
			return;
		}
	}
	PerformPostReadChecks();
	//return;	
}

function PerformPostReadChecks()
{
	local HaloPlayerPawnController HPPC, IterPC;
	local HaloLocalPlayer LP;

	HPPC = HaloPlayerPawnController(GetPC());
	// End:0x1F2
	if(HPPC != none)
	{
		// End:0x146
		foreach HPPC.WorldInfo.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', IterPC)
		{
			LP = HaloLocalPlayer(IterPC.Player);
			// End:0x145
			if((LP != none) && !LP.bHasSeenStartScreen)
			{
				LP.bHasSeenStartScreen = true;
				IterPC.OnlinePlayerData.StorageProvider.RefreshStorageData();
			}			
		}		
		// End:0x1F2
		if(bIsDemoMode || (int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PressedStartControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PressedStartControllerId)))
		{
			AdvanceToMainMenu();
		}
	}
	//return;	
}

function AdvanceToMainMenu()
{
	local HaloPlayerPawnController OtherPC;

	// End:0x34
	if(bRestartFrontEndAfterStartSequence)
	{
		PressedStartControllerId = -1;
		bRestartFrontEndAfterStartSequence = false;
		NotifyMenu_RestartFrontEnd();
		return;
	}
	NotifyMenu_LoginComplete();
	PressedStartControllerId = -1;
	// End:0x14A
	if(Class'Engine.Engine'.static.GetEngine().GamePlayers.Length > 1)
	{
		OtherPC = HaloPlayerPawnController(Class'Engine.Engine'.static.GetEngine().GamePlayers[1].Actor);
		// End:0x14A
		if(OtherPC != none)
		{
			SetSecondaryController(Class'Engine.Engine'.static.GetEngine().GamePlayers[1].ControllerId);
		}
	}
	bOnTitleScreen = false;
	PerformEnterMainMenuSequence();
	//return;	
}

function NotifyMenu_LoginComplete()
{
	LogInternal("NotifyMenu_LoginComplete");
	menu.ActionScriptVoid("initialLoginComplete");
	bOnTitleScreen = false;
	bIsInStartupProcess = false;
	//return;	
}

function NotifyMenu_RestartFrontEnd()
{
	menu.ActionScriptVoid("restartMenu");
	bOnTitleScreen = true;
	bIsInStartupProcess = true;
	bRestartFrontEndAfterStartSequence = false;
	//return;	
}

function SetSecondaryController(int SecondaryController)
{
	//return;	
}

function PerformEnterMainMenuSequence()
{
	// End:0x17
	if(PerformLoggedInPlayerCheck())
	{
		PerformPostControllerCheckSequence();
	}
	//return;	
}

function bool PerformLoggedInPlayerCheck()
{
	// End:0x13
	if((GetLocalPlayerCount()) > 2)
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function int GetLocalPlayerCount()
{
	local int LocalCount;
	local HaloPlayerPawnController PC;

	// End:0x78
	foreach GetPC().WorldInfo.AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		// End:0x77
		if(PC.IsLocalPlayerController())
		{
			LocalCount++;
		}		
	}	
	return LocalCount;
	//return ReturnValue;	
}

function PerformPostControllerCheckSequence()
{
	//return;	
}

function UpdatePlayersAndControllers(bool bShouldPerformChecks)
{
	local int ControllerIndex, NumLogins;
	local HaloPlayerPawnController PC;
	local bool bDidCreateRemovePlayer, bWasControllerFound;
	local string Ignored;
	local WorldInfo WI;
	local LocalPlayer LP;
	local bool bIsSignedIn;
	local int NumLocalPlayers;

	WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
	// End:0x62D
	if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(WI.NetMode) != int(NM_Client))
	{
		bHasInactiveControllers = false;
		NumLocalPlayers = GetNumLocalPlayers();
		NumLogins = OnlineSub.GetNumSupportedLogins();
		ControllerIndex = 0;
		J0x125:

		// End:0x5EA [Loop If]
		if(ControllerIndex < NumLogins)
		{
			bWasControllerFound = false;
			bIsSignedIn = int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) > int(0);
			// End:0x465
			if(OnlineSub.SystemInterface.IsControllerConnected(ControllerIndex) || bIsSignedIn)
			{
				// End:0x331
				if(!bIsSignedIn && bOnTitleScreen)
				{
					// End:0x32E
					if(NumLocalPlayers > 1)
					{
						// End:0x32D
						foreach WI.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
						{
							LP = LocalPlayer(PC.Player);
							// End:0x32C
							if(((LP != none) && LP.ControllerId == ControllerIndex) && LP != (GetLP()))
							{
								LP.ViewportClient.RemovePlayer(LP);
								bDidCreateRemovePlayer = true;
								bWasControllerFound = false;
								// End:0x32D
								break;
							}							
						}						
					}					
				}
				else
				{
					// End:0x3E3
					foreach WI.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
					{
						LP = LocalPlayer(PC.Player);
						// End:0x3E2
						if((LP != none) && LP.ControllerId == ControllerIndex)
						{
							bWasControllerFound = true;
							// End:0x3E3
							break;
						}						
					}					
				}
				// End:0x462
				if(!bWasControllerFound)
				{
					// End:0x456
					if(bIsSignedIn)
					{
						LP.ViewportClient.CreatePlayer(ControllerIndex, Ignored, true);
						bDidCreateRemovePlayer = true;						
					}
					else
					{
						bHasInactiveControllers = true;
					}
				}				
			}
			else
			{
				// End:0x5DC
				if((!bIsInStartupProcess && NumLocalPlayers > 1) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) == int(0))
				{
					// End:0x5DB
					foreach WI.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
					{
						LP = LocalPlayer(PC.Player);
						// End:0x5DA
						if(((LP != none) && LP.ControllerId == ControllerIndex) && LP != (GetLP()))
						{
							LP.ViewportClient.RemovePlayer(LP);
							bDidCreateRemovePlayer = true;
							// End:0x5DB
							break;
						}						
					}					
				}
			}
			ControllerIndex++;
			// [Loop Continue]
			goto J0x125;
		}
		// End:0x62D
		if(((GetNumLocalPlayers() >= 2) && !bOnTitleScreen) && PressedStartControllerId == -1)
		{
			bHasInactiveControllers = false;
		}
	}
	// End:0x6B6
	if(bShouldPerformChecks && !bOnTitleScreen)
	{
		// End:0x6AC
		if(bDidCreateRemovePlayer && !IsAllowedToCreatePlayers())
		{
			// End:0x6AB
			foreach WI.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
			{
				NotifyMenu_RestartFrontEnd();				
				return;				
			}			
		}
		PerformLoggedInPlayerCheck();
	}
	UpdateGuestStatus();
	//return;	
}

final function int GetNumLocalPlayers()
{
	local HaloPlayerPawnController PC;
	local int Count;
	local HaloPlayerPawnController PlayerOwner;

	PlayerOwner = HaloPlayerPawnController(GetPC());
	// End:0x5D
	foreach PlayerOwner.LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		Count++;		
	}	
	return Count;
	//return ReturnValue;	
}

function bool IsAllowedToCreatePlayers()
{
	// End:0x2C
	if(int(GetPC().Role) == int(ROLE_Authority))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function UpdateGuestStatus()
{
	local int ControllerIndex, NumLogins;
	local WorldInfo WI;
	local int NumLoggedInPlayers;

	bAllowGuestLogin = false;
	WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
	// End:0x254
	if(((int(GetPC().Role) == int(ROLE_Authority)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		bAllowGuestLogin = false;
		// End:0x254
		if(bHasInactiveControllers || WI.GRI.PRIArray.Length > 1)
		{
			NumLogins = OnlineSub.GetNumSupportedLogins();
			ControllerIndex = 0;
			J0x130:

			// End:0x254 [Loop If]
			if(ControllerIndex < NumLogins)
			{
				// End:0x246
				if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) == int(2))
				{
					NumLoggedInPlayers++;
					// End:0x246
					if(int(OnlineSub.PlayerInterface.CanPlayOnline(byte(ControllerIndex))) == int(2))
					{
						// End:0x23A
						if(OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerIndex)))
						{
							bAllowGuestLogin = false;							
						}
						else
						{
							bAllowGuestLogin = true;
						}
					}
				}
				ControllerIndex++;
				// [Loop Continue]
				goto J0x130;
			}
		}
	}
	bAllowGuestLogin = (NumLoggedInPlayers < 2) && bAllowGuestLogin;
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	local HaloLocalPlayer LP;

	// End:0xCA
	if(PressedStartControllerId != -1)
	{
		// End:0xC7
		if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			// End:0xC7
			if(int(LocalUserNum) == PressedStartControllerId)
			{
				// End:0xC7
				if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
				{
					bRestartFrontEndAfterStartSequence = true;
				}
			}
		}		
	}
	else
	{
		// End:0x148
		if(!bOnTitleScreen)
		{
			LP = HaloLocalPlayer(GetPC().Player);
			// End:0x13B
			if(LP != none)
			{
				LP.bIsFirstFrontEndLoad = true;
			}
			NotifyMenu_RestartFrontEnd();			
		}
		else
		{
			// End:0x19B
			if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
			{
				NotifyMenu_RestartFrontEnd();
			}
		}
	}
	UpdateGuestStatus();
	UpdatePlayersAndControllers(!bOnTitleScreen);
	//return;	
}

function bool GetInvertCamera()
{
	return InvertCamera;
	//return ReturnValue;	
}

function SetInvertCamera(bool IsEnabled)
{
	InvertCamera = IsEnabled;
	//return;	
}

defaultproperties
{
	CampaignMissionsArray[0]=(DisplayName="VS Demo Playthrough",DisplayDescription="Vertical Slice Demo",LevelToLoad="VerticalSlicePersistent",MissionOptions="Demo_Missions")
	CampaignMissionsArray[1]=(DisplayName="Cluster 1 - Start",DisplayDescription="Full Conquest 2 Playthrough",LevelToLoad="VerticalSlicePersistent",MissionOptions="Full_Missions")
	CampaignMissionsArray[2]=(DisplayName="Cluster 1 - Besieged",DisplayDescription="Start Besieged Gameplay",LevelToLoad="VerticalSlicePersistent",MissionOptions="Besieged_Cluster_1")
	CampaignMissionsArray[3]=(DisplayName="Cluster 2 - Start",DisplayDescription="Cluster 2 Playthrough",LevelToLoad="VerticalSlicePersistent",MissionOptions="Mission_Cluster2_SecureArtifact")
	CampaignMissionsArray[4]=(DisplayName="Cluster 2 - Besieged",DisplayDescription="Start Besieged Gameplay",LevelToLoad="VerticalSlicePersistent",MissionOptions="Mission_Cluster2_ThreeRings")
	LevelsArray[0]=(DisplayName="Besieged Green-Light",DisplayDescription="Original Green-Light Demo",LevelToLoad="_Besieged_01_Persistent")
	LevelsArray[1]=(DisplayName="Besieged Three Rings",DisplayDescription="New Besieged design test",LevelToLoad="Besieged_ThreeRings")
	TestLevelsArray[0]=(DisplayName="Save Game Prototype Level",DisplayDescription="",LevelToLoad="Streaming_Test_Persistent")
	TestLevelsArray[1]=(DisplayName="Firing_Range",DisplayDescription="",LevelToLoad="FiringRange")
	TestLevelsArray[2]=(DisplayName="Metrics",DisplayDescription="",LevelToLoad="Metrics_Spartan_Traversal")
	TestLevelsArray[3]=(DisplayName="Player_Vehicles",DisplayDescription="",LevelToLoad="Vehicle_Test02")
	PressedStartControllerId=-1
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloMainMenu"
	MovieInfo=SwfMovie'MainMenu.GFx_MainMenu'
	bCaptureInput=true
	TimingMode=TM_Real
	WidgetBindings[0]=(WidgetName="StartButton",WidgetClass=Class'GFxUI.GFxClikWidget')
}