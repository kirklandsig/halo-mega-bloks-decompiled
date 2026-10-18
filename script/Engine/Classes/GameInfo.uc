class GameInfo extends Info
	native
	config(Game)
	notplaceable;

enum EStandbyType
{
	STDBY_Rx,                       // 0
	STDBY_Tx,                       // 1
	STDBY_BadPing,                  // 2
	STDBY_MAX                       // 3
};

struct native GameClassShortName
{
	var string ShortName;
	var string GameClassName;

	structdefaultproperties
	{
		ShortName=""
		GameClassName=""
	}
};

struct native GameTypePrefix
{
	var string Prefix;
	var bool bUsesCommonPackage;
	var string GameType;
	var array<string> AdditionalGameTypes;
	var array<string> ForcedObjects;

	structdefaultproperties
	{
		Prefix=""
		bUsesCommonPackage=false
		GameType=""
		AdditionalGameTypes=none
		ForcedObjects=none
	}
};

var bool bRestartLevel;
var bool bPauseable;
var bool bTeamGame;
var bool bGameEnded;
var bool bOverTime;
var bool bDelayedStart;
var bool bWaitingToStartMatch;
var globalconfig bool bChangeLevels;
var bool bAlreadyChanged;
var globalconfig bool bAdminCanPause;
var bool bGameRestarted;
var bool bLevelChange;
var globalconfig bool bKickLiveIdlers;
var bool bUsingArbitration;
var bool bHasArbitratedHandshakeBegun;
var bool bNeedsEndGameHandshake;
var bool bIsEndGameHandshakeComplete;
var bool bHasEndGameHandshakeBegun;
var bool bFixedPlayerStart;
var bool bDoFearCostFallOff;
var bool bUseSeamlessTravel;
var bool bHasNetworkError;
var const bool bRequiresPushToTalk;
var config bool bIsStandbyCheckingEnabled;
var bool bIsStandbyCheckingOn;
var bool bHasStandbyCheatTriggered;
var string CauseEventCommand;
var string BugLocString;
var string BugRotString;
var array<PlayerController> PendingArbitrationPCs;
var array<PlayerController> ArbitrationPCs;
var globalconfig float ArbitrationHandshakeTimeout;
var globalconfig float GameDifficulty;
var globalconfig int GoreLevel;
var float GameSpeed;
var Class<Pawn> DefaultPawnClass;
var Class<HUD> HUDType;
var Class<HUD> SecondaryHUDType;
var globalconfig int MaxSpectators;
var int MaxSpectatorsAllowed;
var int NumSpectators;
var globalconfig int MaxPlayers;
var int MaxPlayersAllowed;
var int NumPlayers;
var int NumBots;
var int NumTravellingPlayers;
var int CurrentID;
var const localized string DefaultPlayerName;
var const localized string GameName;
var float FearCostFallOff;
var config int GoalScore;
var config int MaxLives;
var config int TimeLimit;
var Class<LocalMessage> DeathMessageClass;
var Class<GameMessage> GameMessageClass;
var Mutator BaseMutator;
var Class<AccessControl> AccessControlClass;
var AccessControl AccessControl;
var Class<BroadcastHandler> BroadcastHandlerClass;
var BroadcastHandler BroadcastHandler;
var Class<AutoTestManager> AutoTestManagerClass;
var AutoTestManager MyAutoTestManager;
var Class<PlayerController> PlayerControllerClass;
var Class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var Class<GameReplicationInfo> GameReplicationInfoClass;
var GameReplicationInfo GameReplicationInfo;
var CrowdPopulationManagerBase PopulationManager;
var Class<CrowdPopulationManagerBase> PopulationManagerClass;
var string GripAIManagerClassPath;
var transient Actor GripAIManagerHolder;
var globalconfig float MaxIdleTime;
var globalconfig float MaxTimeMargin;
var globalconfig float TimeMarginSlack;
var globalconfig float MinTimeMargin;
var array<PlayerReplicationInfo> InactivePRIArray;
var array< delegate<CanUnpause> > Pausers;
var OnlineSubsystem OnlineSub;
var OnlineGameInterface GameInterface;
var Class<OnlineStatsWrite> OnlineStatsWriteClass;
var int LeaderboardId;
var int ArbitratedLeaderboardId;
var protected CoverReplicator CoverReplicatorBase;
var const Class<OnlineGameSettings> OnlineGameSettingsClass;
var string ServerOptions;
var int AdjustedNetSpeed;
var float LastNetSpeedUpdateTime;
var globalconfig int TotalNetBandwidth;
var globalconfig int MinDynamicBandwidth;
var globalconfig int MaxDynamicBandwidth;
var config float StandbyRxCheatTime;
var config float StandbyTxCheatTime;
var config int BadPingThreshold;
var config float PercentMissingForRxStandby;
var config float PercentMissingForTxStandby;
var config float PercentForBadPing;
var config float JoinInProgressStandbyWaitTime;
var Material StreamingPauseIcon;
var protected const config array<config GameClassShortName> GameInfoClassAliases;
var config string DefaultGameType;
var config array<config GameTypePrefix> DefaultMapPrefixes;
var config array<config GameTypePrefix> CustomMapPrefixes;
var config int AnimTreePoolSize;
var string GwNavWorldActorClassPath;
var transient Actor GwNavWorldActor;
//var delegate<CanUnpause> __CanUnpause__Delegate;

// Export UGameInfo::execGetSupportedGameTypes(FFrame&, void* const)
native function bool GetSupportedGameTypes(const out string InFilename, out GameTypePrefix OutGameType, optional bool bCheckExt = false);

// Export UGameInfo::execGetMapCommonPackageName(FFrame&, void* const)
native function bool GetMapCommonPackageName(const out string InFilename, out string OutCommonPackageName);

event PreBeginPlay()
{
	AdjustedNetSpeed = MaxDynamicBandwidth;
	SetGameSpeed(GameSpeed);
	GameReplicationInfo = Spawn(GameReplicationInfoClass);
	WorldInfo.GRI = GameReplicationInfo;
	InitGameReplicationInfo();
	InitCrowdPopulationManager();
	SpawnGripAIManager();
	SpawnGwNavWorldActor();
	//return;	
}

function CoverReplicator GetCoverReplicator()
{
	// End:0x5E
	if((CoverReplicatorBase == none) && int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		CoverReplicatorBase = Spawn(Class'Engine.CoverReplicator');
	}
	return CoverReplicatorBase;
	//return ReturnValue;	
}

event PostBeginPlay()
{
	// End:0x2B
	if(MaxIdleTime > float(0))
	{
		MaxIdleTime = FMax(MaxIdleTime, 20.0000000);
	}
	// End:0x5E
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		UpdateGameSettings();
	}
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.DrawText("Game:" $ GameName);
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	// End:0x138
	if(WorldInfo.PopulationManager != none)
	{
		WorldInfo.PopulationManager.DisplayDebug(HUD, out_YL, out_YPos);
	}
	//return;	
}

function Reset()
{
	super(Actor).Reset();
	bGameEnded = false;
	bOverTime = false;
	InitGameReplicationInfo();
	//return;	
}

function bool ShouldReset(Actor ActorToReset)
{
	return true;
	//return ReturnValue;	
}

function ResetLevel()
{
	local Controller C;
	local Actor A;
	local Sequence GameSeq;
	local array<SequenceObject> AllSeqEvents;
	local array<int> ActivateIndices;
	local int I;

	LogInternal("Reset" @ string(self));
	// End:0xA3
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		// End:0x83
		if(PlayerController(C) != none)
		{
			PlayerController(C).ClientReset();
		}
		C.Reset();		
	}	
	// End:0x12B
	foreach AllActors(Class'Engine.Actor', A)
	{
		// End:0x12A
		if(((A != self) && A.IsA('Controller')!) && ShouldReset(A))
		{
			A.Reset();
		}		
	}	
	Reset();
	GameSeq = WorldInfo.GetGameSequence();
	// End:0x245
	if(GameSeq != none)
	{
		GameSeq.Reset();
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_LevelLoaded', true, AllSeqEvents);
		ActivateIndices[0] = 2;
		I = 0;
		J0x1D8:

		// End:0x245 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			SeqEvent_LevelLoaded(AllSeqEvents[I]).CheckActivate(WorldInfo, none, false, ActivateIndices);
			I++;
			// [Loop Continue]
			goto J0x1D8;
		}
	}
	//return;	
}

event Timer()
{
	BroadcastHandler.UpdateSentText();
	// End:0x36
	if(bDoFearCostFallOff)
	{
		DoNavFearCostFallOff();
	}
	//return;	
}

// Export UGameInfo::execShouldStartInCinematicMode(FFrame&, void* const)
native final function bool ShouldStartInCinematicMode(out int OutHidePlayer, out int OutHideHud, out int OutDisableMovement, out int OutDisableTurning, out int OutDisableInput);

// Export UGameInfo::execDoNavFearCostFallOff(FFrame&, void* const)
native final function DoNavFearCostFallOff();

function NotifyNavigationChanged(NavigationPoint N)
{
	//return;	
}

event GameEnding()
{
	// End:0x2E
	if(AccessControl != none)
	{
		AccessControl.NotifyGameEnding();
	}
	ClearOnlineDelegates();
	EndLogging("serverquit");
	//return;	
}

event KickIdler(PlayerController PC)
{
	LogInternal("Kicking idle player " $ PC.PlayerReplicationInfo.PlayerName);
	AccessControl.KickPlayer(PC, AccessControl.IdleKickReason);
	//return;	
}

event ForceKickPlayer(PlayerController PC, string KickReason)
{
	LogInternal("Force kicking player " $ PC.PlayerReplicationInfo.PlayerName);
	AccessControl.ForceKickPlayer(PC, KickReason);
	//return;	
}

function InitGameReplicationInfo()
{
	GameReplicationInfo.GameClass = Class;
	GameReplicationInfo.ReceivedGameClass();
	//return;	
}

// Export UGameInfo::execGetNetworkNumber(FFrame&, void* const)
native function string GetNetworkNumber();

function int GetNumPlayers()
{
	return NumPlayers + NumTravellingPlayers;
	//return ReturnValue;	
}

delegate bool CanUnpause()
{
	return true;
	//return ReturnValue;	
}

function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
	local int FoundIndex;

	// End:0x109
	if(AllowPausing(PC))
	{
		FoundIndex = Pausers.Find(CanUnpauseDelegate);
		// End:0xA6
		if(FoundIndex == -1)
		{
			FoundIndex = Pausers.Length;
			Pausers.Length = FoundIndex + 1;
			Pausers[FoundIndex] = CanUnpauseDelegate;
		}
		// End:0x107
		if(WorldInfo.Pauser == none)
		{
			WorldInfo.Pauser = PC.PlayerReplicationInfo;
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

event ClearPause()
{
	local int Index;
	local delegate<CanUnpause> CanUnpauseCriteriaMet;

	// End:0x8C
	if(AllowPausing()! && Pausers.Length > 0)
	{
		LogInternal(("Clearing list of UnPause delegates for" @ string(Name)) @ "because game type is not pauseable");
		Pausers.Length = 0;
	}
	Index = 0;
	J0x97:

	// End:0x107 [Loop If]
	if(Index < Pausers.Length)
	{
		CanUnpauseCriteriaMet = Pausers[Index];
		// End:0xF9
		if(CanUnpause())
		{
			Pausers.Remove(Index--, 1);
		}
		Index++;
		// [Loop Continue]
		goto J0x97;
	}
	// End:0x137
	if(Pausers.Length == 0)
	{
		WorldInfo.Pauser = none;
	}
	//return;	
}

// Export UGameInfo::execForceClearUnpauseDelegates(FFrame&, void* const)
native final function ForceClearUnpauseDelegates(Actor PauseActor);

function DebugPause()
{
	local int Index;
	local delegate<CanUnpause> CanUnpauseCriteriaMet;

	Index = 0;
	J0x0B:

	// End:0x10E [Loop If]
	if(Index < Pausers.Length)
	{
		CanUnpauseCriteriaMet = Pausers[Index];
		// End:0xA7
		if(CanUnpause())
		{
			LogInternal((("Pauser in index " $ string(Index)) $ " thinks it's ok to unpause:") @ string(CanUnpauseCriteriaMet));			
		}
		else
		{
			LogInternal((("Pauser in index " $ string(Index)) $ " thinks the game should remain paused:") @ string(CanUnpauseCriteriaMet));
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SetGameSpeed(float T)
{
	GameSpeed = FMax(T, 0.0000100);
	WorldInfo.TimeDilation = GameSpeed;
	SetTimer(WorldInfo.TimeDilation, true);
	//return;	
}

static function bool GrabOption(out string Options, out string Result)
{
	// End:0xD1
	if(Left(Options, 1) == "?")
	{
		Result = Mid(Options, 1);
		// End:0x68
		if(InStr(Result, "?") >= 0)
		{
			Result = Left(Result, InStr(Result, "?"));
		}
		Options = Mid(Options, 1);
		// End:0xC0
		if(InStr(Options, "?") >= 0)
		{
			Options = Mid(Options, InStr(Options, "?"));			
		}
		else
		{
			Options = "";
		}
		return true;		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

static function GetKeyValue(string Pair, out string Key, out string Value)
{
	// End:0x6A
	if(InStr(Pair, "=") >= 0)
	{
		Key = Left(Pair, InStr(Pair, "="));
		Value = Mid(Pair, InStr(Pair, "=") + 1);		
	}
	else
	{
		Key = Pair;
		Value = "";
	}
	//return;	
}

static function string ParseOption(string Options, string InKey)
{
	local string Pair, Key, Value;

	J0x00:
	// End:0x68 [Loop If]
	if(GrabOption(Options, Pair))
	{
		GetKeyValue(Pair, Key, Value);
		// End:0x65
		if(Key ComplementEqual InKey)
		{
			return Value;
		}
		// [Loop Continue]
		goto J0x00;
	}
	return "";
	//return ReturnValue;	
}

static function bool HasOption(string Options, string InKey)
{
	local string Pair, Key, Value;

	J0x00:
	// End:0x60 [Loop If]
	if(GrabOption(Options, Pair))
	{
		GetKeyValue(Pair, Key, Value);
		// End:0x5D
		if(Key ComplementEqual InKey)
		{
			return true;
		}
		// [Loop Continue]
		goto J0x00;
	}
	return false;
	//return ReturnValue;	
}

static function int GetIntOption(string Options, string ParseString, int CurrentValue)
{
	local string InOpt;

	InOpt = ParseOption(Options, ParseString);
	// End:0x42
	if(InOpt != "")
	{
		return int(InOpt);
	}
	return CurrentValue;
	//return ReturnValue;	
}

static event string GetDefaultGameClassPath(string MapName, string Options, string Portal)
{
	return PathName(default.Class);
	//return ReturnValue;	
}

static event Class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return default.Class;
	//return ReturnValue;	
}

event InitGame(string Options, out string ErrorMessage)
{
	local string InOpt, LeftOpt;
	local int pos;
	local Class<AccessControl> ACClass;
	local AccessControl CurAC;
	local OnlineGameSettings GameSettings;

	MaxPlayers = Clamp(GetIntOption(Options, "MaxPlayers", MaxPlayers), 0, MaxPlayersAllowed);
	MaxSpectators = Clamp(GetIntOption(Options, "MaxSpectators", MaxSpectators), 0, MaxSpectatorsAllowed);
	GameDifficulty = FMax(0.0000000, float(GetIntOption(Options, "Difficulty", int(GameDifficulty))));
	InOpt = ParseOption(Options, "GameSpeed");
	// End:0x122
	if(InOpt != "")
	{
		LogInternal("GameSpeed" @ InOpt);
		SetGameSpeed(float(InOpt));
	}
	TimeLimit = Max(0, GetIntOption(Options, "TimeLimit", TimeLimit));
	BroadcastHandler = Spawn(BroadcastHandlerClass);
	InOpt = ParseOption(Options, "AccessControl");
	// End:0x1E6
	if(InOpt != "")
	{
		ACClass = Class<AccessControl>(DynamicLoadObject(InOpt, Class'Core.Class'));
	}
	// End:0x208
	if(ACClass == none)
	{
		ACClass = AccessControlClass;
	}
	LeftOpt = ParseOption(Options, "AdminName");
	InOpt = ParseOption(Options, "AdminPassword");
	// End:0x37F
	if((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		// End:0x303
		if(WorldInfo.IsInSeamlessTravel())
		{
			// End:0x302
			foreach DynamicActors(Class'Engine.AccessControl', CurAC)
			{
				AccessControl = CurAC;
				// End:0x302
				break;				
			}			
		}
		// End:0x336
		if(AccessControl == none)
		{
			AccessControl = Spawn(ACClass);
		}
		// End:0x37F
		if((AccessControl != none) && InOpt != "")
		{
			AccessControl.SetAdminPassword(InOpt);
		}
	}
	InOpt = ParseOption(Options, "Mutator");
	// End:0x48C
	if(InOpt != "")
	{
		LogInternal("Mutators" @ InOpt);
		J0x3CD:

		// End:0x48C [Loop If]
		if(InOpt != "")
		{
			pos = InStr(InOpt, ",");
			// End:0x456
			if(pos > 0)
			{
				LeftOpt = Left(InOpt, pos);
				InOpt = Right(InOpt, (Len(InOpt) - pos) - 1);				
			}
			else
			{
				LeftOpt = InOpt;
				InOpt = "";
			}
			AddMutator(LeftOpt, true);
			// [Loop Continue]
			goto J0x3CD;
		}
	}
	InOpt = ParseOption(Options, "GamePassword");
	// End:0x51C
	if((InOpt != "") && AccessControl != none)
	{
		AccessControl.SetGamePassword(InOpt);
		LogInternal("GamePassword" @ InOpt);
	}
	bFixedPlayerStart = (ParseOption(Options, "FixedPlayerStart")) ComplementEqual "1";
	CauseEventCommand = ParseOption(Options, "causeevent");
	// End:0x5FB
	if((ParseOption(Options, "AutoTests")) ComplementEqual "1")
	{
		// End:0x5D3
		if(MyAutoTestManager == none)
		{
			MyAutoTestManager = Spawn(AutoTestManagerClass);
		}
		MyAutoTestManager.InitializeOptions(Options);
	}
	BugLocString = ParseOption(Options, "BugLoc");
	BugRotString = ParseOption(Options, "BugRot");
	// End:0x685
	if(BaseMutator != none)
	{
		BaseMutator.InitMutator(Options, ErrorMessage);
	}
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x786
	if(OnlineSub != none)
	{
		GameInterface = OnlineSub.GameInterface;
		// End:0x786
		if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
		{
			GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
			// End:0x786
			if(GameSettings != none)
			{
				bUsingArbitration = GameSettings.bUsesArbitration;
			}
		}
	}
	// End:0x815
	if(((WorldInfo.IsConsoleBuild(0) == false) && int(WorldInfo.NetMode) != int(NM_Standalone)) && GameSettings == none)
	{
		ServerOptions = Options;
		// End:0x815
		if(ProcessServerLogin()!)
		{
			RegisterServer();
		}
	}
	//return;	
}

event NotifyPendingConnectionLost()
{
	//return;	
}

function AddMutator(string mutname, optional bool bUserAdded)
{
	local Class<Mutator> mutClass;
	local Mutator mut;
	local int I;

	// End:0x1B
	if(AllowMutator(mutname)!)
	{
		return;
	}
	mutClass = Class<Mutator>(DynamicLoadObject(mutname, Class'Core.Class'));
	// End:0x5C
	if(mutClass == none)
	{
		return;
	}
	// End:0x1DD
	if((mutClass.default.GroupNames.Length > 0) && BaseMutator != none)
	{
		mut = BaseMutator;
		J0xA5:

		// End:0x1DD [Loop If]
		if(mut != none)
		{
			I = 0;
			J0xBF:

			// End:0x1B2 [Loop If]
			if(I < mut.GroupNames.Length)
			{
				// End:0x1A4
				if(mutClass.default.GroupNames.Find(mut.GroupNames[I]) != -1)
				{
					LogInternal((("Not adding " $ string(mutClass)) $ " because already have a mutator in the same group - ") $ string(mut));
					return;
				}
				I++;
				// [Loop Continue]
				goto J0xBF;
			}
			mut = mut.NextMutator;
			// [Loop Continue]
			goto J0xA5;
		}
	}
	mut = BaseMutator;
	J0x1F0:

	// End:0x2AF [Loop If]
	if(mut != none)
	{
		// End:0x284
		if(mut.Class == mutClass)
		{
			LogInternal((("Not adding " $ string(mutClass)) $ " because this mutator is already added - ") $ string(mut));
			return;
		}
		mut = mut.NextMutator;
		// [Loop Continue]
		goto J0x1F0;
	}
	mut = Spawn(mutClass);
	// End:0x2E4
	if(mut == none)
	{
		return;
	}
	mut.bUserAdded = bUserAdded;
	// End:0x333
	if(BaseMutator == none)
	{
		BaseMutator = mut;		
	}
	else
	{
		BaseMutator.AddMutator(mut);
	}
	//return;	
}

function RemoveMutator(Mutator MutatorToRemove)
{
	local Mutator M;

	// End:0x42
	if(BaseMutator == MutatorToRemove)
	{
		BaseMutator = MutatorToRemove.NextMutator;		
	}
	else
	{
		// End:0x10A
		if(BaseMutator != none)
		{
			M = BaseMutator;
			J0x64:

			// End:0x10A [Loop If]
			if(M != none)
			{
				// End:0xDF
				if(M.NextMutator == MutatorToRemove)
				{
					M.NextMutator = MutatorToRemove.NextMutator;
					// [Explicit Break]
					goto J0x10A;
				}
				M = M.NextMutator;
				// [Loop Continue]
				goto J0x64;
			}
		}
	}
	J0x10A:

	//return;	
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	local PlayerController LocalPlayer;
	local bool bSeamless;
	local string NextMap;
	local Guid NextMapGuid;
	local int OptionStart;

	bLevelChange = true;
	EndLogging("mapchange");
	bSeamless = bUseSeamlessTravel && WorldInfo.TimeSeconds < 172800.0000000;
	// End:0xB3
	if(InStr(Caps(URL), "?RESTART") != -1)
	{
		NextMap = string(WorldInfo.GetPackageName());		
	}
	else
	{
		OptionStart = InStr(URL, "?");
		// End:0xF7
		if(OptionStart == -1)
		{
			NextMap = URL;			
		}
		else
		{
			NextMap = Left(URL, OptionStart);
		}
	}
	NextMapGuid = GetPackageGuid(name(NextMap));
	LocalPlayer = ProcessClientTravel(URL, NextMapGuid, bSeamless, bAbsolute);
	LogInternal("ProcessServerTravel:" @ URL);
	WorldInfo.NextURL = URL;
	// End:0x2EC
	if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && LocalPlayer != none)
	{		
		WorldInfo.NextURL $= ((((((("?Team=" $ LocalPlayer.GetDefaultURL("Team")) $ "?Name=") $ LocalPlayer.GetDefaultURL("Name")) $ "?Class=") $ LocalPlayer.GetDefaultURL("Class")) $ "?Character=") $ LocalPlayer.GetDefaultURL("Character"));
	}
	// End:0x324
	if(AccessControl != none)
	{
		AccessControl.NotifyServerTravel(bSeamless);
	}
	ClearOnlineDelegates();
	// End:0x3A7
	if(bSeamless)
	{
		WorldInfo.SeamlessTravel(WorldInfo.NextURL, bAbsolute);
		WorldInfo.NextURL = "";		
	}
	else
	{
		// End:0x41F
		if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && int(WorldInfo.NetMode) != int(NM_ListenServer))
		{
			WorldInfo.NextSwitchCountdown = 0.0000000;
		}
	}
	//return;	
}

function PlayerController ProcessClientTravel(out string URL, Guid NextMapGuid, bool bSeamless, bool bAbsolute)
{
	local PlayerController P, LP;

	// End:0xFA
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
	{
		// End:0xA1
		if(NetConnection(P.Player) != none)
		{
			P.ClientTravel(URL, 2, bSeamless, NextMapGuid);
			// End:0xF9
			continue;
		}
		LP = P;
		P.PreClientTravel(URL, ((bAbsolute) ? 0 : 2), bSeamless);		
	}	
	return LP;
	//return ReturnValue;	
}

function bool RequiresPassword()
{
	return (AccessControl != none) && AccessControl.RequiresPassword();
	//return ReturnValue;	
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
	local bool bSpectator, bPerfTesting;

	// End:0xA7
	if(((int(WorldInfo.NetMode) != int(NM_Standalone)) && bUsingArbitration) && bHasArbitratedHandshakeBegun)
	{
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
		return;
	}
	// End:0x13A
	if((AccessControl != none) && AccessControl.IsIDBanned(UniqueId))
	{
		LogInternal(Address @ "is banned, rejecting...");
		ErrorMessage = "Engine.AccessControl.SessionBanned";
		return;
	}
	bPerfTesting = (ParseOption(Options, "AutomatedPerfTesting")) ComplementEqual "1";
	bSpectator = (bPerfTesting || (ParseOption(Options, "SpectatorOnly")) ComplementEqual "1") || (ParseOption(Options, "CauseEvent")) ComplementEqual "FlyThrough";
	// End:0x24C
	if(AccessControl != none)
	{
		AccessControl.PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage, bSpectator);
	}
	//return;	
}

// Export UGameInfo::execPauseLogin(FFrame&, void* const)
native static final function Player PauseLogin();

// Export UGameInfo::execResumeLogin(FFrame&, void* const)
native static final function ResumeLogin(Player InPlayer);

// Export UGameInfo::execRejectLogin(FFrame&, void* const)
native static final function RejectLogin(Player InPlayer, string Error);

function bool AtCapacity(bool bSpectator)
{
	// End:0x2B
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		return false;
	}
	// End:0x8C
	if(bSpectator)
	{
		return (NumSpectators >= MaxSpectators) && (int(WorldInfo.NetMode) != int(NM_ListenServer)) || NumPlayers > 0;		
	}
	else
	{
		return (MaxPlayers > 0) && (GetNumPlayers()) >= MaxPlayers;
	}
	//return ReturnValue;	
}

// Export UGameInfo::execGetNextPlayerID(FFrame&, void* const)
native final function int GetNextPlayerID();

function PlayerController SpawnPlayerController(Vector SpawnLocation, Rotator SpawnRotation)
{
	return Spawn(PlayerControllerClass,,, SpawnLocation, SpawnRotation);
	//return ReturnValue;	
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local string InName, inCharacter, InPassword;
	local byte InTeam;
	local bool bSpectator, bAdmin, bPerfTesting;
	local Rotator SpawnRotation;
	local UniqueNetId ZeroId;

	bAdmin = false;
	// End:0x88
	if(bUsingArbitration && bHasArbitratedHandshakeBegun)
	{
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
		return none;
	}
	// End:0xC8
	if(BaseMutator != none)
	{
		BaseMutator.ModifyLogin(Portal, Options);
	}
	bPerfTesting = (ParseOption(Options, "AutomatedPerfTesting")) ComplementEqual "1";
	bSpectator = bPerfTesting || (ParseOption(Options, "SpectatorOnly")) ComplementEqual "1";
	InName = Left(ParseOption(Options, "Name"), 20);
	InTeam = byte(GetIntOption(Options, "Team", 255));
	InPassword = ParseOption(Options, "Password");
	// End:0x1F9
	if(AccessControl != none)
	{
		bAdmin = AccessControl.ParseAdminOptions(Options);
	}
	// End:0x27E
	if(bAdmin! && AtCapacity(bSpectator))
	{
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".MaxedOutMessage";
		return none;
	}
	// End:0x365
	if((WorldInfo.Game.AccessControl != none) && WorldInfo.Game.AccessControl.IsIDBanned(UniqueId))
	{
		LogInternal(InName @ "is banned, rejecting...");
		ErrorMessage = "Engine.AccessControl.SessionBanned";
		return none;
	}
	// End:0x38E
	if(bAdmin && AtCapacity(false))
	{
		bSpectator = true;
	}
	InTeam = PickTeam(InTeam, none);
	StartSpot = FindPlayerStart(none, InTeam, Portal, true);
	// End:0x443
	if(StartSpot == none)
	{
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".FailedPlaceMessage";
		return none;
	}
	SpawnRotation.Yaw = StartSpot.Rotation.Yaw;
	NewPlayer = SpawnPlayerController(StartSpot.Location, SpawnRotation);
	// End:0x577
	if(NewPlayer == none)
	{
		LogInternal("Couldn't spawn player controller of class " $ string(PlayerControllerClass));
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".FailedSpawnMessage";
		return none;
	}
	NewPlayer.StartSpot = StartSpot;
	NewPlayer.PlayerReplicationInfo.PlayerID = GetNextPlayerID();
	// End:0x658
	if((AccessControl == none) || AccessControl.IsPendingAuth(UniqueId)!)
	{
		NewPlayer.PlayerReplicationInfo.SetUniqueId(UniqueId);
	}
	// End:0x766
	if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && UniqueId != ZeroId)
	{
		WorldInfo.Game.OnlineSub.GameInterface.RegisterPlayer(PlayerReplicationInfoClass.default.SessionName, UniqueId, HasOption(Options, "bIsFromInvite"));
	}
	RecalculateSkillRating();
	// End:0x7CA
	if(InName == "")
	{
		InName = DefaultPlayerName $ string(NewPlayer.PlayerReplicationInfo.PlayerID);
	}
	ChangeName(NewPlayer, InName, false);
	inCharacter = ParseOption(Options, "Character");
	NewPlayer.SetCharacter(inCharacter);
	// End:0x972
	if((bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator) || ChangeTeam(NewPlayer, int(InTeam), false)!)
	{
		NewPlayer.GotoState('Spectating');
		NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
		NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
		NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
		return NewPlayer;
	}
	// End:0x9DF
	if((AccessControl != none) && AccessControl.AdminLogin(NewPlayer, InPassword))
	{
		AccessControl.AdminEntered(NewPlayer);
	}
	// End:0xA19
	if(bDelayedStart)
	{
		NewPlayer.GotoState('PlayerWaiting');
		return NewPlayer;
	}
	return NewPlayer;
	//return ReturnValue;	
}

function StartMatch()
{
	local Actor A;

	// End:0x2E
	if(MyAutoTestManager != none)
	{
		MyAutoTestManager.StartMatch();
	}
	// End:0x67
	foreach AllActors(Class'Engine.Actor', A)
	{
		A.MatchStarting();		
	}	
	StartHumans();
	StartBots();
	bWaitingToStartMatch = false;
	StartOnlineGame();
	WorldInfo.NotifyMatchStarted();
	//return;	
}

function StartOnlineGame()
{
	local PlayerController PC;

	// End:0x139
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		// End:0x98
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x97
			if(PC.IsLocalPlayerController()!)
			{
				PC.ClientStartOnlineGame();
			}			
		}		
		GameInterface.AddStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);
		GameInterface.StartOnlineGame(PlayerReplicationInfoClass.default.SessionName);
		// End:0x136
		if(AccessControl != none)
		{
			AccessControl.NotifyStartOnlineGame();
		}		
	}
	else
	{
		GameReplicationInfo.StartMatch();
	}
	//return;	
}

function OnStartOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	local PlayerController PC;
	local string StatGuid;

	GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);
	// End:0x147
	if(bWasSuccessful && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
	{
		StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
		// End:0x147
		if(StatGuid != "")
		{
			// End:0x146
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x145
				if(PC.IsLocalPlayerController() == false)
				{
					PC.ClientRegisterHostStatGuid(StatGuid);
				}				
			}			
		}
	}
	GameReplicationInfo.StartMatch();
	//return;	
}

function StartHumans()
{
	local PlayerController P;

	// End:0xA1
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
	{
		// End:0xA0
		if(P.Pawn == none)
		{
			// End:0x6B
			if(bGameEnded)
			{				
				return;
				// End:0xA0
				continue;
			}
			// End:0xA0
			if(P.CanRestartPlayer())
			{
				RestartPlayer(P);
			}
		}		
	}	
	//return;	
}

function StartBots()
{
	local Controller P;

	// End:0xE8
	foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
	{
		// End:0xE7
		if(P.bIsPlayer && P.IsA('PlayerController')!)
		{
			// End:0xBC
			if(int(WorldInfo.NetMode) == int(NM_Standalone))
			{
				RestartPlayer(P);
				// End:0xE7
				continue;
			}
			P.GotoState('Dead', 'MPStart');
		}		
	}	
	//return;	
}

function RestartPlayer(Controller NewPlayer)
{
	local NavigationPoint StartSpot;
	local int TeamNum, Idx;
	local array<SequenceObject> Events;
	local SeqEvent_PlayerSpawned SpawnedEvent;
	local LocalPlayer LP;
	local PlayerController PC;

	// End:0xBD
	if((bRestartLevel && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && int(WorldInfo.NetMode) != int(NM_ListenServer))
	{
		WarnInternal("bRestartLevel && !server, abort from RestartPlayer" @ string(WorldInfo.NetMode));
		return;
	}
	TeamNum = (((NewPlayer.PlayerReplicationInfo == none) || NewPlayer.PlayerReplicationInfo.Team == none) ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex);
	StartSpot = FindPlayerStart(NewPlayer, byte(TeamNum));
	// End:0x261
	if(StartSpot == none)
	{
		// End:0x22B
		if(NewPlayer.StartSpot != none)
		{
			StartSpot = NewPlayer.StartSpot;
			WarnInternal("Player start not found, using last start spot");			
		}
		else
		{
			WarnInternal("Player start not found, failed to restart player");
			return;
		}
	}
	// End:0x2C0
	if(NewPlayer.Pawn == none)
	{
		NewPlayer.Pawn = SpawnDefaultPawnFor(NewPlayer, StartSpot);
	}
	// End:0x388
	if(NewPlayer.Pawn == none)
	{
		LogInternal("failed to spawn player at " $ string(StartSpot));
		NewPlayer.GotoState('Dead');
		// End:0x385
		if(PlayerController(NewPlayer) != none)
		{
			PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
		}		
	}
	else
	{
		NewPlayer.Pawn.SetAnchor(StartSpot);
		// End:0x42A
		if(PlayerController(NewPlayer) != none)
		{
			PlayerController(NewPlayer).TimeMargin = -0.1000000;
			StartSpot.AnchoredPawn = none;
		}
		NewPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
		NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
		NewPlayer.Possess(NewPlayer.Pawn, false);
		NewPlayer.Pawn.PlayTeleportEffect(true, false);
		NewPlayer.ClientSetRotation(NewPlayer.Pawn.Rotation, true);
		// End:0x5D5
		if(WorldInfo.bNoDefaultInventoryForPlayer!)
		{
			AddDefaultInventory(NewPlayer.Pawn);
		}
		SetPlayerDefaults(NewPlayer.Pawn);
		// End:0x750
		if(WorldInfo.GetGameSequence() != none)
		{
			WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'Engine.SeqEvent_PlayerSpawned', true, Events);
			Idx = 0;
			J0x675:

			// End:0x750 [Loop If]
			if(Idx < Events.Length)
			{
				SpawnedEvent = SeqEvent_PlayerSpawned(Events[Idx]);
				// End:0x742
				if((SpawnedEvent != none) && SpawnedEvent.CheckActivate(NewPlayer, NewPlayer))
				{
					SpawnedEvent.SpawnPoint = StartSpot;
					SpawnedEvent.PopulateLinkedVariableValues();
				}
				Idx++;
				// [Loop Continue]
				goto J0x675;
			}
		}
	}
	PC = PlayerController(NewPlayer);
	// End:0x88B
	if(PC != none)
	{
		LP = LocalPlayer(PC.Player);
		// End:0x88B
		if(LP != none)
		{
			LP.RemoveAllPostProcessingChains();
			LP.InsertPostProcessingChain(LP.Outer.GetWorldPostProcessChain(), -1, true);
			// End:0x88B
			if(PC.myHUD != none)
			{
				PC.myHUD.NotifyBindPostProcessEffects();
			}
		}
	}
	//return;	
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
	local Class<Pawn> DefaultPlayerClass;
	local Rotator StartRotation;
	local Pawn ResultPawn;

	DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
	StartRotation.Yaw = StartSpot.Rotation.Yaw;
	ResultPawn = Spawn(DefaultPlayerClass,,, StartSpot.Location, StartRotation);
	// End:0x108
	if(ResultPawn == none)
	{
		LogInternal((("Couldn't spawn player of type " $ string(DefaultPlayerClass)) $ " at ") $ string(StartSpot));
	}
	return ResultPawn;
	//return ReturnValue;	
}

function Class<Pawn> GetDefaultPlayerClass(Controller C)
{
	return DefaultPawnClass;
	//return ReturnValue;	
}

function ReplicateStreamingStatus(PlayerController PC)
{
	local int LevelIndex;
	local LevelStreaming TheLevel;

	// End:0x436
	if((LocalPlayer(PC.Player) == none) && ChildConnection(PC.Player) == none)
	{
		// End:0xE6
		if(WorldInfo.CommittedPersistentLevelName != 'None')
		{
			PC.ClientPrepareMapChange(WorldInfo.CommittedPersistentLevelName, true, true);
			PC.ClientCommitMapChange();
		}
		// End:0x34B
		if(WorldInfo.StreamingLevels.Length > 0)
		{
			LevelIndex = 0;
			J0x116:

			// End:0x32C [Loop If]
			if(LevelIndex < WorldInfo.StreamingLevels.Length)
			{
				TheLevel = WorldInfo.StreamingLevels[LevelIndex];
				// End:0x31E
				if(TheLevel != none)
				{
					LogInternal(((((((((((("levelStatus: " $ string(TheLevel.PackageName)) $ " ") $ string(TheLevel.bShouldBeVisible)) $ " ") $ string(TheLevel.bIsVisible)) $ " ") $ string(TheLevel.bShouldBeLoaded)) $ " ") $ string(TheLevel.LoadedLevel)) $ " ") $ string(TheLevel.bHasLoadRequestPending)) $ " ");
					PC.ClientUpdateLevelStreamingStatus(TheLevel.PackageName, TheLevel.bShouldBeLoaded, TheLevel.bShouldBeVisible, TheLevel.bShouldBlockOnLoad);
				}
				LevelIndex++;
				// [Loop Continue]
				goto J0x116;
			}
			PC.ClientFlushLevelStreaming();
		}
		// End:0x436
		if(WorldInfo.PreparingLevelNames.Length > 0)
		{
			LevelIndex = 0;
			J0x37B:

			// End:0x436 [Loop If]
			if(LevelIndex < WorldInfo.PreparingLevelNames.Length)
			{
				PC.ClientPrepareMapChange(WorldInfo.PreparingLevelNames[LevelIndex], LevelIndex == 0, LevelIndex == (WorldInfo.PreparingLevelNames.Length - 1));
				LevelIndex++;
				// [Loop Continue]
				goto J0x37B;
			}
		}
	}
	//return;	
}

function GenericPlayerInitialization(Controller C)
{
	local PlayerController PC;

	PC = PlayerController(C);
	// End:0xF8
	if(PC != none)
	{
		UpdateBestNextHosts();
		UpdateGameplayMuteList(PC);
		PC.ClientSetHUD(HUDType);
		PC.ClientSetSecondaryHUD(SecondaryHUDType);
		ReplicateStreamingStatus(PC);
		// End:0xD9
		if(CoverReplicatorBase != none)
		{
			PC.SpawnCoverReplicator();
		}
		PC.ClientSetOnlineStatus();
	}
	// End:0x12F
	if(BaseMutator != none)
	{
		BaseMutator.NotifyLogin(C);
	}
	//return;	
}

function int BestNextHostSort(PlayerController A, PlayerController B)
{
	local int Result;

	// End:0x11C
	if(((A.ConnectedPeers.Length == B.ConnectedPeers.Length) && A.PlayerReplicationInfo != none) && B.PlayerReplicationInfo != none)
	{
		Result = FCeil(float(B.PlayerReplicationInfo.StartTime)) - FCeil(float(A.PlayerReplicationInfo.StartTime));		
	}
	else
	{
		Result = A.ConnectedPeers.Length - B.ConnectedPeers.Length;
	}
	return Result;
	//return ReturnValue;	
}

function UpdateBestNextHosts()
{
	local PlayerController PC;
	local array<PlayerController> SortedPCList;
	local UniqueNetId SortedPlayerIdList[10], ZeroId;
	local int Idx, NumEntries;

	// End:0x103
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x102
		if(((PC.IsLocalPlayerController()! && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroId) && PC.IsPrimaryPlayer())
		{
			SortedPCList.AddItem(PC);
		}		
	}	
	SortedPCList.Sort(BestNextHostSort);
	NumEntries = Min(SortedPCList.Length, 10);
	Idx = 0;
	J0x145:

	// End:0x1BB [Loop If]
	if(Idx < NumEntries)
	{
		SortedPlayerIdList[Idx] = SortedPCList[Idx].PlayerReplicationInfo.UniqueId;
		Idx++;
		// [Loop Continue]
		goto J0x145;
	}
	// End:0x247
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x246
		if(PC.IsLocalPlayerController()!)
		{
			PC.ClientUpdateBestNextHosts(SortedPlayerIdList, byte(NumEntries));
		}		
	}	
	//return;	
}

event PostLogin(PlayerController NewPlayer)
{
	local string Address, StatGuid;
	local int pos, I;
	local Sequence GameSeq;
	local array<SequenceObject> AllInterpActions;
	local int HidePlayer, HideHUD, DisableMovement, DisableTurning, DisableInput;

	// End:0x45
	if(NewPlayer.PlayerReplicationInfo.bOnlySpectator)
	{
		NumSpectators++;		
	}
	else
	{
		// End:0x99
		if(WorldInfo.IsInSeamlessTravel() || NewPlayer.HasClientLoadedCurrentWorld())
		{
			NumPlayers++;			
		}
		else
		{
			NumTravellingPlayers++;
		}
	}
	UpdateGameSettingsCounts();
	Address = NewPlayer.GetPlayerNetworkAddress();
	pos = InStr(Address, ":");
	NewPlayer.PlayerReplicationInfo.SavedNetworkAddress = ((pos > 0) ? Left(Address, pos) : Address);
	FindInactivePRI(NewPlayer);
	// End:0x1C4
	if(bDelayedStart!)
	{
		bRestartLevel = false;
		// End:0x19C
		if(bWaitingToStartMatch)
		{
			StartMatch();			
		}
		else
		{
			RestartPlayer(NewPlayer);
		}
		bRestartLevel = default.bRestartLevel;
	}
	// End:0x24F
	if(NewPlayer.Pawn != none)
	{
		NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
	}
	NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);
	UpdateNetSpeeds();
	GenericPlayerInitialization(NewPlayer);
	// End:0x39F
	if((GameReplicationInfo.bMatchHasBegun && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
	{
		StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
		// End:0x39F
		if(StatGuid != "")
		{
			NewPlayer.ClientRegisterHostStatGuid(StatGuid);
		}
	}
	// End:0x3CE
	if(bRequiresPushToTalk)
	{
		NewPlayer.ClientStopNetworkedVoice();		
	}
	else
	{
		NewPlayer.ClientStartNetworkedVoice();
	}
	// End:0x44D
	if(NewPlayer.PlayerReplicationInfo.bOnlySpectator)
	{
		NewPlayer.ClientGotoState('Spectating');
	}
	GameSeq = WorldInfo.GetGameSequence();
	// End:0x523
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
		I = 0;
		J0x4C2:

		// End:0x523 [Loop If]
		if(I < AllInterpActions.Length)
		{
			SeqAct_Interp(AllInterpActions[I]).AddPlayerToDirectorTracks(NewPlayer);
			I++;
			// [Loop Continue]
			goto J0x4C2;
		}
	}
	// End:0x5B9
	if(ShouldStartInCinematicMode(HidePlayer, HideHUD, DisableMovement, DisableTurning, DisableInput))
	{
		NewPlayer.SetCinematicMode(true, HidePlayer == 1, HideHUD == 1, DisableMovement == 1, DisableTurning == 1, DisableInput == 1);
	}
	//return;	
}

function UpdateNetSpeeds()
{
	local int NewNetSpeed;
	local PlayerController PC;
	local OnlineGameSettings GameSettings;

	// End:0x68
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
	}
	// End:0xF3
	if(((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (GameSettings != none) && GameSettings.bIsLanMatch)
	{
		return;
	}
	// End:0x13B
	if((WorldInfo.TimeSeconds - LastNetSpeedUpdateTime) < 1.0000000)
	{
		SetTimer(1.0000000, false, 'UpdateNetSpeeds');
		return;
	}
	LastNetSpeedUpdateTime = WorldInfo.TimeSeconds;
	NewNetSpeed = CalculatedNetSpeed();
	LogInternal((("New Dynamic NetSpeed " $ string(NewNetSpeed)) $ " vs old ") $ string(AdjustedNetSpeed), 'DevNet');
	// End:0x247
	if(AdjustedNetSpeed != NewNetSpeed)
	{
		AdjustedNetSpeed = NewNetSpeed;
		// End:0x246
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			PC.SetNetSpeed(AdjustedNetSpeed);			
		}		
	}
	//return;	
}

function int CalculatedNetSpeed()
{
	return Clamp(TotalNetBandwidth / Max(NumPlayers, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
	//return ReturnValue;	
}

event PreExit()
{
	// End:0x2E
	if(AccessControl != none)
	{
		AccessControl.NotifyExit();
	}
	ClearOnlineDelegates();
	//return;	
}

function Logout(Controller Exiting)
{
	local PlayerController PC;
	local int PCIndex;

	PC = PlayerController(Exiting);
	// End:0x235
	if(PC != none)
	{
		// End:0xA1
		if((AccessControl != none) && AccessControl.AdminLogout(PlayerController(Exiting)))
		{
			AccessControl.AdminExited(PlayerController(Exiting));
		}
		// End:0xE6
		if(PC.PlayerReplicationInfo.bOnlySpectator)
		{
			NumSpectators--;			
		}
		else
		{
			// End:0x13A
			if(WorldInfo.IsInSeamlessTravel() || PC.HasClientLoadedCurrentWorld())
			{
				NumPlayers--;				
			}
			else
			{
				NumTravellingPlayers--;
			}
			UpdateGameSettingsCounts();
		}
		// End:0x1CD
		if((bUsingArbitration && bHasArbitratedHandshakeBegun) && bHasEndGameHandshakeBegun!)
		{
			LogInternal(("Player " $ PC.PlayerReplicationInfo.PlayerName) $ " has dropped");
		}
		UnregisterPlayer(PC);
		// End:0x235
		if(bUsingArbitration)
		{
			PCIndex = ArbitrationPCs.Find(PC);
			// End:0x235
			if(PCIndex != -1)
			{
				ArbitrationPCs.Remove(PCIndex, 1);
			}
		}
	}
	// End:0x26C
	if(BaseMutator != none)
	{
		BaseMutator.NotifyLogout(Exiting);
	}
	// End:0x285
	if(PC != none)
	{
		UpdateNetSpeeds();
	}
	//return;	
}

function UnregisterPlayer(PlayerController PC)
{
	local UniqueNetId ZeroId;

	// End:0x176
	if((((int(WorldInfo.NetMode) != int(NM_Standalone)) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none))) && PC.PlayerReplicationInfo.UniqueId != ZeroId) && GameInterface.GetGameSettings(PC.PlayerReplicationInfo.SessionName) != none)
	{
		GameInterface.UnregisterPlayer(PC.PlayerReplicationInfo.SessionName, PC.PlayerReplicationInfo.UniqueId);
	}
	//return;	
}

event AcceptInventory(Pawn PlayerPawn)
{
	//return;	
}

event AddDefaultInventory(Pawn P)
{
	P.AddDefaultInventory();
	// End:0x7B
	if(P.InvManager == none)
	{
		WarnInternal("GameInfo::AddDefaultInventory - P.InvManager == None");
	}
	//return;	
}

function Mutate(string MutateString, PlayerController Sender)
{
	// End:0x40
	if(BaseMutator != none)
	{
		BaseMutator.Mutate(MutateString, Sender);
	}
	//return;	
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	PlayerPawn.AirControl = PlayerPawn.default.AirControl;
	PlayerPawn.GroundSpeed = PlayerPawn.default.GroundSpeed;
	PlayerPawn.WaterSpeed = PlayerPawn.default.WaterSpeed;
	PlayerPawn.AirSpeed = PlayerPawn.default.AirSpeed;
	PlayerPawn.Acceleration = PlayerPawn.default.Acceleration;
	PlayerPawn.AccelRate = PlayerPawn.default.AccelRate;
	PlayerPawn.JumpZ = PlayerPawn.default.JumpZ;
	// End:0x1E2
	if(BaseMutator != none)
	{
		BaseMutator.ModifyPlayer(PlayerPawn);
	}
	PlayerPawn.PhysicsVolume.ModifyPlayer(PlayerPawn);
	//return;	
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> DamageType)
{
	local Controller C;

	// End:0x78
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		C.NotifyKilled(Killer, Killed, KilledPawn, DamageType);		
	}	
	//return;	
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, Class<DamageType> DamageType)
{
	// End:0x11F
	if((KilledPlayer != none) && KilledPlayer.bIsPlayer)
	{
		KilledPlayer.PlayerReplicationInfo.IncrementDeaths();
		KilledPlayer.PlayerReplicationInfo.SetNetUpdateTime(FMin(KilledPlayer.PlayerReplicationInfo.NetUpdateTime, WorldInfo.TimeSeconds + (0.3000000 * FRand())));
		BroadcastDeathMessage(Killer, KilledPlayer, DamageType);
	}
	// End:0x14A
	if(KilledPlayer != none)
	{
		ScoreKill(Killer, KilledPlayer);
	}
	NotifyKilled(Killer, KilledPlayer, KilledPawn, DamageType);
	//return;	
}

function bool PreventDeath(Pawn KilledPawn, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	// End:0x11
	if(BaseMutator == none)
	{
		return false;
	}
	return BaseMutator.PreventDeath(KilledPawn, Killer, DamageType, HitLocation);
	//return ReturnValue;	
}

function BroadcastDeathMessage(Controller Killer, Controller Other, Class<DamageType> DamageType)
{
	// End:0x68
	if((Killer == Other) || Killer == none)
	{
		BroadcastLocalized(self, DeathMessageClass, 1, none, Other.PlayerReplicationInfo, DamageType);		
	}
	else
	{
		BroadcastLocalized(self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, DamageType);
	}
	//return;	
}

function Kick(string S)
{
	// End:0x37
	if(AccessControl != none)
	{
		AccessControl.Kick(S);
	}
	//return;	
}

function KickBan(string S)
{
	// End:0x37
	if(AccessControl != none)
	{
		AccessControl.KickBan(S);
	}
	//return;	
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
	return true;
	//return ReturnValue;	
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
	local int OriginalDamage;

	OriginalDamage = Damage;
	// End:0x7B
	if(injured.PhysicsVolume.bNeutralZone || injured.InGodMode())
	{
		Damage = 0;
		return;
	}
	// End:0xF1
	if(BaseMutator != none)
	{
		BaseMutator.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	}
	//return;	
}

function bool CheckRelevance(Actor Other)
{
	// End:0x11
	if(BaseMutator == none)
	{
		return true;
	}
	return BaseMutator.CheckRelevance(Other);
	//return ReturnValue;	
}

function bool ShouldRespawn(PickupFactory Other)
{
	return int(WorldInfo.NetMode) != int(NM_Standalone);
	//return ReturnValue;	
}

function bool PickupQuery(Pawn Other, Class<Inventory> ItemClass, Actor Pickup)
{
	local byte bAllowPickup;

	// End:0x63
	if((BaseMutator != none) && BaseMutator.OverridePickupQuery(Other, ItemClass, Pickup, bAllowPickup))
	{
		return bool(bAllowPickup);
	}
	// End:0x8C
	if(Other.InvManager == none)
	{
		return false;		
	}
	else
	{
		return Other.InvManager.HandlePickupQuery(ItemClass, Pickup);
	}
	//return ReturnValue;	
}

function DiscardInventory(Pawn Other, optional Controller Killer)
{
	// End:0x59
	if(Other.InvManager != none)
	{
		Other.InvManager.DiscardInventory();
	}
	//return;	
}

function ChangeName(Controller Other, coerce string S, bool bNameChange)
{
	// End:0x12
	if(S == "")
	{
		return;
	}
	Other.PlayerReplicationInfo.SetPlayerName(S);
	//return;	
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	return true;
	//return ReturnValue;	
}

function byte PickTeam(byte Current, Controller C)
{
	return Current;
	//return ReturnValue;	
}

function SendPlayer(PlayerController aPlayer, string URL)
{
	aPlayer.ClientTravel(URL, 2);
	//return;	
}

function string GetNextMap()
{
	//return ReturnValue;	
}

function bool GetTravelType()
{
	return false;
	//return ReturnValue;	
}

function RestartGame()
{
	local string NextMap, TransitionMapCmdLine, URLString;
	local int URLMapLen, MapNameLen;

	// End:0x26
	if(bUsingArbitration)
	{
		// End:0x24
		if(bIsEndGameHandshakeComplete)
		{
			NotifyArbitratedMatchEnd();
		}
		return;
	}
	// End:0x5B
	if((BaseMutator != none) && BaseMutator.HandleRestartGame())
	{
		return;
	}
	// End:0x6A
	if(bGameRestarted)
	{
		return;
	}
	bGameRestarted = true;
	// End:0x433
	if(bChangeLevels && bAlreadyChanged!)
	{
		bAlreadyChanged = true;
		// End:0xFF
		if((MyAutoTestManager != none) && MyAutoTestManager.bUsingAutomatedTestingMapList)
		{
			NextMap = MyAutoTestManager.GetNextAutomatedTestingMap();			
		}
		else
		{
			NextMap = GetNextMap();
		}
		// End:0x433
		if(NextMap != "")
		{
			// End:0x18E
			if((MyAutoTestManager == none) || MyAutoTestManager.bUsingAutomatedTestingMapList!)
			{
				WorldInfo.ServerTravel(NextMap, GetTravelType());				
			}
			else
			{
				// End:0x308
				if(MyAutoTestManager.bAutomatedTestingWithOpen!)
				{
					URLString = WorldInfo.GetLocalURL();
					URLMapLen = Len(URLString);
					MapNameLen = InStr(URLString, "?");
					// End:0x247
					if(MapNameLen != -1)
					{
						URLString = Right(URLString, URLMapLen - MapNameLen);
					}
					TransitionMapCmdLine = ((NextMap $ URLString) $ "?AutomatedTestingMapIndex=") $ string(MyAutoTestManager.AutomatedTestingMapIndex);
					LogInternal(">>> Issuing server travel on " $ TransitionMapCmdLine);
					WorldInfo.ServerTravel(TransitionMapCmdLine, GetTravelType());					
				}
				else
				{
					TransitionMapCmdLine = (((("?AutomatedTestingMapIndex=" $ string(MyAutoTestManager.AutomatedTestingMapIndex)) $ "?NumberOfMatchesPlayed=") $ string(MyAutoTestManager.NumberOfMatchesPlayed)) $ "?NumMapListCyclesDone=") $ string(MyAutoTestManager.NumMapListCyclesDone);
					LogInternal((">>> Issuing open command on " $ NextMap) $ TransitionMapCmdLine);					
					ConsoleCommand(("open " $ NextMap) $ TransitionMapCmdLine);
				}
			}
			return;
		}
	}
	WorldInfo.ServerTravel("?Restart", GetTravelType());
	//return;	
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
	BroadcastHandler.Broadcast(Sender, msg, Type);
	//return;	
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
	BroadcastHandler.BroadcastTeam(Sender, msg, Type);
	//return;	
}

event BroadcastLocalized(Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	BroadcastHandler.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	//return;	
}

event BroadcastLocalizedTeam(int TeamIndex, Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	BroadcastHandler.AllowBroadcastLocalizedTeam(TeamIndex, Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	//return;	
}

function bool CheckModifiedEndGame(PlayerReplicationInfo Winner, string Reason)
{
	return (BaseMutator != none) && BaseMutator.CheckEndGame(Winner, Reason)!;
	//return ReturnValue;	
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;

	// End:0x21
	if(CheckModifiedEndGame(Winner, Reason))
	{
		return false;
	}
	// End:0x77
	foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
	{
		P.GameHasEnded();		
	}	
	return true;
	//return ReturnValue;	
}

function WriteOnlineStats()
{
	local PlayerController PC;
	local OnlineGameSettings CurrentSettings;

	// End:0x1A0
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		CurrentSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		// End:0x1A0
		if((CurrentSettings != none) && CurrentSettings.bUsesStats)
		{
			// End:0x11E
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x11D
				if(PC.IsLocalPlayerController() == false)
				{
					PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);
				}				
			}			
			// End:0x19F
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x19E
				if(PC.IsLocalPlayerController())
				{
					PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);
				}				
			}			
		}
	}
	//return;	
}

function WriteOnlinePlayerScores()
{
	local PlayerController PC;

	// End:0x6E
	if(bUsingArbitration)
	{
		// End:0x6A
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			PC.ClientWriteOnlinePlayerScores(ArbitratedLeaderboardId);			
		}				
	}
	else
	{
		// End:0xF0
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			// End:0xEF
			if(PC.IsLocalPlayerController())
			{
				PC.ClientWriteOnlinePlayerScores(LeaderboardId);
				// End:0xF0
				break;
			}			
		}		
	}
	//return;	
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
	// End:0x2F
	if(CheckEndGame(Winner, Reason)!)
	{
		bOverTime = true;
		return;
	}
	SetTimer(1.5000000, false, 'PerformEndGameHandling');
	bGameEnded = true;
	EndLogging(Reason);
	//return;	
}

function PerformEndGameHandling()
{
	// End:0x6D
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		WriteOnlineStats();
		WriteOnlinePlayerScores();
		EndOnlineGame();
		// End:0x6D
		if(bUsingArbitration)
		{
			PendingArbitrationPCs.Length = 0;
			ArbitrationPCs.Length = 0;
			NotifyArbitratedMatchEnd();
		}
	}
	//return;	
}

function EndOnlineGame()
{
	local PlayerController PC;

	GameReplicationInfo.EndGame();
	// End:0xF6
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		// End:0xB7
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			// End:0xB6
			if(PC.IsLocalPlayerController()!)
			{
				PC.ClientEndOnlineGame();
			}			
		}		
		GameInterface.EndOnlineGame(PlayerReplicationInfoClass.default.SessionName);
	}
	//return;	
}

function GameEventsPoll()
{
	//return;	
}

function EndLogging(string Reason)
{
	//return;	
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
	return (((int(WorldInfo.NetMode) == int(NM_Standalone)) && Player != none) && Player.StartSpot != none) && bWaitingToStartMatch || (Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.bWaitingPlayer;
	//return ReturnValue;	
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName, optional bool IsNewPlayer)
{
	local NavigationPoint N, BestStart;
	local Teleporter Tel;

	// End:0x79
	if(BaseMutator != none)
	{
		N = BaseMutator.FindPlayerStart(Player, InTeam, IncomingName, IsNewPlayer);
		// End:0x79
		if(N != none)
		{
			return N;
		}
	}
	// End:0xF8
	if(IncomingName != "")
	{
		// End:0xF7
		foreach WorldInfo.AllNavigationPoints(Class'Engine.Teleporter', Tel)
		{
			// End:0xF6
			if(string(Tel.Tag) ComplementEqual IncomingName)
			{				
				return Tel;
			}			
		}		
	}
	// End:0x1AB
	if((ShouldSpawnAtStartSpot(Player)) && (PlayerStart(Player.StartSpot) == none) || (RatePlayerStart(PlayerStart(Player.StartSpot), InTeam, Player)) >= 0.0000000)
	{
		return Player.StartSpot;
	}
	BestStart = ChoosePlayerStart(Player, InTeam, IsNewPlayer);
	// End:0x273
	if((BestStart == none) && Player == none)
	{
		LogInternal("Warning - PATHS NOT DEFINED or NO PLAYERSTART with positive rating");
		// End:0x272
		foreach AllActors(Class'Engine.NavigationPoint', N)
		{
			BestStart = N;
			// End:0x272
			break;			
		}		
	}
	return BestStart;
	//return ReturnValue;	
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam, optional bool IsNewPlayer)
{
	local PlayerStart P, BestStart;
	local float BestRating, NewRating;
	local byte Team;

	Team = ((((Player != none) && Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.Team != none) ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam);
	// End:0x172
	foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', P)
	{
		NewRating = RatePlayerStart(P, Team, Player);
		// End:0x171
		if(NewRating > BestRating)
		{
			BestRating = NewRating;
			BestStart = P;
		}		
	}	
	return BestStart;
	//return ReturnValue;	
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Rating;

	// End:0x2D
	if(P.bEnabled!)
	{
		return 5.0000000;		
	}
	else
	{
		Rating = 10.0000000;
		// End:0x6E
		if(P.bPrimaryStart)
		{
			Rating += 10.0000000;
		}
		// End:0xAC
		if(P.TeamIndex == int(Team))
		{
			Rating += 15.0000000;
		}
		return Rating;
	}
	//return ReturnValue;	
}

function AddObjectiveScore(PlayerReplicationInfo Scorer, int Score)
{
	// End:0x3A
	if(Scorer != none)
	{
		Scorer.Score += float(Score);
	}
	// End:0x7A
	if(BaseMutator != none)
	{
		BaseMutator.ScoreObjective(Scorer, Score);
	}
	//return;	
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
	AddObjectiveScore(Scorer, Score);
	CheckScore(Scorer);
	//return;	
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	return true;
	//return ReturnValue;	
}

function ScoreKill(Controller Killer, Controller Other)
{
	// End:0xCE
	if((Killer == Other) || Killer == none)
	{
		// End:0xCB
		if((Other != none) && Other.PlayerReplicationInfo != none)
		{
			Other.PlayerReplicationInfo.Score -= float(1);
			Other.PlayerReplicationInfo.bForceNetUpdate = true;
		}		
	}
	else
	{
		// End:0x195
		if(Killer.PlayerReplicationInfo != none)
		{
			Killer.PlayerReplicationInfo.Score += float(1);
			Killer.PlayerReplicationInfo.bForceNetUpdate = true;
			Killer.PlayerReplicationInfo.Kills++;
		}
	}
	ModifyScoreKill(Killer, Other);
	// End:0x1F9
	if((Killer != none) || MaxLives > 0)
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
	//return;	
}

function ModifyScoreKill(Controller Killer, Controller Other)
{
	// End:0x40
	if(BaseMutator != none)
	{
		BaseMutator.ScoreKill(Killer, Other);
	}
	//return;	
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	// End:0x40
	if(BaseMutator != none)
	{
		BaseMutator.DriverEnteredVehicle(V, P);
	}
	//return;	
}

function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
	// End:0x11
	if(BaseMutator == none)
	{
		return true;
	}
	return BaseMutator.CanLeaveVehicle(V, P);
	//return ReturnValue;	
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
	// End:0x40
	if(BaseMutator != none)
	{
		BaseMutator.DriverLeftVehicle(V, P);
	}
	//return;	
}

function bool PlayerCanRestartGame(PlayerController aPlayer)
{
	return true;
	//return ReturnValue;	
}

function bool PlayerCanRestart(PlayerController aPlayer)
{
	return true;
	//return ReturnValue;	
}

static function bool AllowMutator(string MutatorClassName)
{
	return Class'Engine.WorldInfo'.static.IsDemoBuild()!;
	//return ReturnValue;	
}

function bool AllowCheats(PlayerController P)
{
	return int(WorldInfo.NetMode) == int(NM_Standalone);
	//return ReturnValue;	
}

function bool AllowPausing(optional PlayerController PC)
{
	return (bPauseable || int(WorldInfo.NetMode) == int(NM_Standalone)) || bAdminCanPause && AccessControl.IsAdmin(PC);
	//return ReturnValue;	
}

event PreCommitMapChange(string PreviousMapName, string NextMapName)
{
	//return;	
}

event PostCommitMapChange()
{
	//return;	
}

function AddInactivePRI(PlayerReplicationInfo PRI, PlayerController PC)
{
	local int I;
	local PlayerReplicationInfo NewPRI, CurrentPRI;
	local bool bIsConsole;

	// End:0x2B7
	if(PRI.bFromPreviousLevel! && PRI.bOnlySpectator!)
	{
		NewPRI = PRI.Duplicate();
		WorldInfo.GRI.RemovePRI(NewPRI);
		NewPRI.RemoteRole = ROLE_None;
		NewPRI.LifeSpan = 300.0000000;
		bIsConsole = WorldInfo.IsConsoleBuild();
		I = 0;
		J0x12B:

		// End:0x26E [Loop If]
		if(I < InactivePRIArray.Length)
		{
			CurrentPRI = InactivePRIArray[I];
			// End:0x260
			if((((CurrentPRI == none) || CurrentPRI.bDeleteMe) || bIsConsole! && CurrentPRI.SavedNetworkAddress == NewPRI.SavedNetworkAddress) || bIsConsole && CurrentPRI.UniqueId == NewPRI.UniqueId)
			{
				InactivePRIArray.Remove(I, 1);
				I--;
			}
			I++;
			// [Loop Continue]
			goto J0x12B;
		}
		InactivePRIArray[InactivePRIArray.Length] = NewPRI;
		// End:0x2B7
		if(InactivePRIArray.Length > 16)
		{
			InactivePRIArray.Remove(0, InactivePRIArray.Length - 16);
		}
	}
	PRI.Destroy();
	RecalculateSkillRating();
	//return;	
}

function bool FindInactivePRI(PlayerController PC)
{
	local string NewNetworkAddress, NewName;
	local int I;
	local PlayerReplicationInfo OldPRI, CurrentPRI;
	local bool bIsConsole;

	// End:0x39
	if(PC.PlayerReplicationInfo.bOnlySpectator)
	{
		return false;
	}
	bIsConsole = WorldInfo.IsConsoleBuild();
	NewNetworkAddress = PC.PlayerReplicationInfo.SavedNetworkAddress;
	NewName = PC.PlayerReplicationInfo.PlayerName;
	I = 0;
	J0xE9:

	// End:0x40E [Loop If]
	if(I < InactivePRIArray.Length)
	{
		CurrentPRI = InactivePRIArray[I];
		// End:0x174
		if((CurrentPRI == none) || CurrentPRI.bDeleteMe)
		{
			InactivePRIArray.Remove(I, 1);
			I--;			
		}
		else
		{
			// End:0x400
			if((bIsConsole && CurrentPRI.UniqueId == PC.PlayerReplicationInfo.UniqueId) || (bIsConsole! && CurrentPRI.SavedNetworkAddress ComplementEqual NewNetworkAddress) && CurrentPRI.PlayerName ComplementEqual NewName)
			{
				OldPRI = PC.PlayerReplicationInfo;
				PC.PlayerReplicationInfo = CurrentPRI;
				PC.PlayerReplicationInfo.SetOwner(PC);
				PC.PlayerReplicationInfo.RemoteRole = ROLE_SimulatedProxy;
				PC.PlayerReplicationInfo.LifeSpan = 0.0000000;
				OverridePRI(PC, OldPRI);
				WorldInfo.GRI.AddPRI(PC.PlayerReplicationInfo);
				InactivePRIArray.Remove(I, 1);
				OldPRI.bIsInactive = true;
				OldPRI.Destroy();
				return true;
			}
		}
		I++;
		// [Loop Continue]
		goto J0xE9;
	}
	return false;
	//return ReturnValue;	
}

function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
	PC.PlayerReplicationInfo.OverrideWith(OldPRI);
	//return;	
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x157 [Loop If]
	if(I < WorldInfo.GRI.PRIArray.Length)
	{
		WorldInfo.GRI.PRIArray[I].bFromPreviousLevel = true;
		WorldInfo.GRI.PRIArray[I].bForceNetUpdate = true;
		ActorList[ActorList.Length] = WorldInfo.GRI.PRIArray[I];
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x1C4
	if(bToEntry)
	{
		ActorList[ActorList.Length] = WorldInfo.GRI;
		// End:0x1C4
		if(BroadcastHandler != none)
		{
			ActorList[ActorList.Length] = BroadcastHandler;
		}
	}
	// End:0x205
	if(BaseMutator != none)
	{
		BaseMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
	}
	// End:0x232
	if(MyAutoTestManager != none)
	{
		ActorList[ActorList.Length] = MyAutoTestManager;
	}
	// End:0x25F
	if(AccessControl != none)
	{
		ActorList[ActorList.Length] = AccessControl;
	}
	//return;	
}

// Export UGameInfo::execSwapPlayerControllers(FFrame&, void* const)
native final function SwapPlayerControllers(PlayerController OldPC, PlayerController NewPC);

event PostSeamlessTravel()
{
	local Controller C;

	// End:0x107
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		// End:0x106
		if(C.bIsPlayer)
		{
			// End:0x84
			if(PlayerController(C) == none)
			{
				HandleSeamlessTravelPlayer(C);
				// End:0x106
				continue;
			}
			// End:0xC8
			if(C.PlayerReplicationInfo.bOnlySpectator!)
			{
				NumTravellingPlayers++;
			}
			// End:0x106
			if(PlayerController(C).HasClientLoadedCurrentWorld())
			{
				HandleSeamlessTravelPlayer(C);
			}
		}		
	}	
	// End:0x14C
	if((bWaitingToStartMatch && bDelayedStart!) && (NumPlayers + NumBots) > 0)
	{
		StartMatch();
	}
	// End:0x17F
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		UpdateGameSettings();
	}
	//return;	
}

function UpdateGameSettings()
{
	//return;	
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local Rotator StartRotation;
	local NavigationPoint StartSpot;
	local PlayerController PC, NewPC;
	local PlayerReplicationInfo OldPRI;

	LogInternal(">> GameInfo::HandleSeamlessTravelPlayer:" @ string(C), 'SeamlessTravel');
	PC = PlayerController(C);
	// End:0x28C
	if((PC != none) && PC.Class != PlayerControllerClass)
	{
		// End:0x271
		if(PC.Player != none)
		{
			NewPC = SpawnPlayerController(PC.Location, PC.Rotation);
			// End:0x1BD
			if(NewPC == none)
			{
				WarnInternal(((("Failed to spawn new PlayerController for" @ PC.GetHumanReadableName()) @ "(old class") @ string(PC.Class)) $ ")");
				PC.Destroy();
				return;				
			}
			else
			{
				PC.CleanUpAudioComponents();
				PC.SeamlessTravelTo(NewPC);
				NewPC.SeamlessTravelFrom(PC);
				SwapPlayerControllers(PC, NewPC);
				PC = NewPC;
				C = NewPC;
			}			
		}
		else
		{
			PC.Destroy();
		}		
	}
	else
	{
		C.PlayerReplicationInfo.Reset();
		OldPRI = C.PlayerReplicationInfo;
		C.InitPlayerReplicationInfo();
		OldPRI.SeamlessTravelTo(C.PlayerReplicationInfo);
		OldPRI.Destroy();
	}
	// End:0x41D
	if(bTeamGame! && C.PlayerReplicationInfo.Team != none)
	{
		C.PlayerReplicationInfo.Team.Destroy();
		C.PlayerReplicationInfo.Team = none;
	}
	StartSpot = FindPlayerStart(C, C.GetTeamNum());
	// End:0x48D
	if(StartSpot == none)
	{
		WarnInternal(GameMessageClass.default.FailedPlaceMessage);		
	}
	else
	{
		StartRotation.Yaw = StartSpot.Rotation.Yaw;
		C.SetLocation(StartSpot.Location);
		C.SetRotation(StartRotation);
	}
	C.StartSpot = StartSpot;
	// End:0x6CA
	if(PC != none)
	{
		PC.CleanUpAudioComponents();
		PC.ClientInitializeDataStores();
		SetSeamlessTravelViewTarget(PC);
		// End:0x68E
		if(PC.PlayerReplicationInfo.bOnlySpectator)
		{
			PC.GotoState('Spectating');
			PC.PlayerReplicationInfo.bIsSpectator = true;
			PC.PlayerReplicationInfo.bOutOfLives = true;
			NumSpectators++;			
		}
		else
		{
			NumPlayers++;
			NumTravellingPlayers--;
			PC.GotoState('PlayerWaiting');
		}		
	}
	else
	{
		NumBots++;
		C.GotoState('RoundEnded');
	}
	GenericPlayerInitialization(C);
	LogInternal("<< GameInfo::HandleSeamlessTravelPlayer:" @ string(C), 'SeamlessTravel');
	//return;	
}

function SetSeamlessTravelViewTarget(PlayerController PC)
{
	PC.SetViewTarget(PC);
	//return;	
}

function UpdateGameSettingsCounts()
{
	local OnlineGameSettings GameSettings;

	// End:0x128
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		// End:0x128
		if((GameSettings != none) && GameSettings.bIsLanMatch)
		{
			GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - (GetNumPlayers());
			// End:0x128
			if(GameSettings.NumOpenPublicConnections < 0)
			{
				GameSettings.NumOpenPublicConnections = 0;
			}
		}
	}
	//return;	
}

function ProcessClientRegistrationCompletion(PlayerController PC, bool bWasSuccessful)
{
	//return;	
}

function StartArbitrationRegistration()
{
	//return;	
}

function StartArbitratedMatch()
{
	//return;	
}

function RegisterServerForArbitration()
{
	//return;	
}

function ArbitrationRegistrationComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function bool MatchIsInProgress()
{
	return true;
	//return ReturnValue;	
}

function NotifyArbitratedMatchEnd()
{
	local PlayerController PC;

	// End:0x79
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x78
		if(PC.IsLocalPlayerController() == false)
		{
			PC.ClientArbitratedMatchEnded();
		}		
	}	
	// End:0xF0
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xEF
		if(PC.IsLocalPlayerController())
		{
			PC.ClientArbitratedMatchEnded();
		}		
	}	
	//return;	
}

function UpdateGameplayMuteList(PlayerController PC)
{
	PC.bHasVoiceHandshakeCompleted = true;
	PC.ClientVoiceHandshakeComplete();
	//return;	
}

function RecalculateSkillRating()
{
	local int Index;
	local array<UniqueNetId> Players;
	local UniqueNetId ZeroId;

	// End:0x1C7
	if(((int(WorldInfo.NetMode) != int(NM_Standalone)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
	{
		Index = 0;
		J0x7C:

		// End:0x15B [Loop If]
		if(Index < GameReplicationInfo.PRIArray.Length)
		{
			// End:0x14D
			if(ZeroId != GameReplicationInfo.PRIArray[Index].UniqueId)
			{
				Players[Players.Length] = GameReplicationInfo.PRIArray[Index].UniqueId;
			}
			Index++;
			// [Loop Continue]
			goto J0x7C;
		}
		// End:0x1C7
		if(Players.Length > 0)
		{
			OnlineSub.GameInterface.RecalculateSkillRating(PlayerReplicationInfoClass.default.SessionName, Players);
		}
	}
	//return;	
}

event MatineeCancelled()
{
	//return;	
}

function bool ProcessServerLogin()
{
	// End:0x11B
	if(OnlineSub != none)
	{
		// End:0x11B
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
			OnlineSub.PlayerInterface.AddLoginFailedDelegate(0, OnLoginFailed);
			// End:0x119
			if(OnlineSub.PlayerInterface.AutoLogin() == false)
			{
				ClearAutoLoginDelegates();
				return false;
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function ClearAutoLoginDelegates()
{
	// End:0xC3
	if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
		OnlineSub.PlayerInterface.ClearLoginFailedDelegate(0, OnLoginFailed);
	}
	//return;	
}

function OnLoginFailed(byte LocalUserNum, OnlineSubsystem.EOnlineServerConnectionStatus ErrorCode)
{
	ClearAutoLoginDelegates();
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	ClearAutoLoginDelegates();
	RegisterServer();
	//return;	
}

function RegisterServer()
{
	local OnlineGameSettings GameSettings;

	// End:0x27A
	if(((OnlineGameSettingsClass != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
	{
		GameSettings = new OnlineGameSettingsClass;
		GameSettings.UpdateFromURL(ServerOptions, self);
		// End:0x188
		if(((AccessControl != none) && (int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || int(WorldInfo.NetMode) == int(NM_ListenServer)) && GameSettings.bIsLanMatch)
		{
			LogInternal("Disabling all authentication, due to bIsLanMatch being set to true");
			AccessControl.ClearAuthDelegates(false);
		}
		OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
		// End:0x277
		if(OnlineSub.GameInterface.CreateOnlineGame(0, PlayerReplicationInfoClass.default.SessionName, GameSettings)!)
		{
			OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
		}		
	}
	else
	{
		WarnInternal("No game settings to register with the online service. Game won't be advertised");
	}
	//return;	
}

function OnServerCreateComplete(name SessionName, bool bWasSuccessful)
{
	local OnlineGameSettings GameSettings;

	GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
	// End:0x215
	if(bWasSuccessful == false)
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		// End:0x1C9
		if((GameSettings != none) && GameSettings.bIsLanMatch == false)
		{
			WarnInternal("Failed to register game with online service. Registering as a LAN match");
			GameSettings.bIsLanMatch = true;
			GameInterface.AddCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
			// End:0x1C6
			if(GameInterface.CreateOnlineGame(0, SessionName, GameSettings)!)
			{
				GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
			}			
		}
		else
		{
			WarnInternal("Failed to register game with online service. Game won't be advertised");
		}		
	}
	else
	{
		// End:0x2DC
		if(((OnlineSub.Class.Name == 'OnlineSubsystemSteamworks') && AccessControl != none) && EqualEqual_InterfaceInterface(AccessControl.CachedAuthInt, OnlineAuthInterface(none)))
		{
			AccessControl.InitAuthHooks();
			AccessControl.OnAuthReady();
		}
		UpdateGameSettings();
	}
	//return;	
}

function TellClientsToReturnToPartyHost()
{
	local PlayerController PC;
	local OnlineGameSettings GameSettings;
	local UniqueNetId RequestingPlayerId;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x2BF
	if(OnlineSub != none)
	{
		GameInterface = OnlineSub.GameInterface;
		// End:0x2BF
		if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
		{
			GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
			// End:0x102
			if(GameSettings != none)
			{
				RequestingPlayerId = GameSettings.OwningPlayerId;				
			}
			else
			{
				// End:0x1AA
				foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
				{
					// End:0x1A9
					if(PC.IsPrimaryPlayer() && PC.PlayerReplicationInfo != none)
					{
						RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
						// End:0x1AA
						break;
					}					
				}				
			}
			// End:0x250
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x24F
				if(PC.IsLocalPlayerController()! && PC.IsPrimaryPlayer())
				{
					PC.ClientReturnToParty(RequestingPlayerId);
				}				
			}			
			// End:0x2BE
			foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x2BD
				if(PC.IsPrimaryPlayer())
				{
					PC.ClientReturnToParty(RequestingPlayerId);
					// End:0x2BE
					break;
				}				
			}			
		}
	}
	//return;	
}

function TellClientsPartyHostIsLeaving(UniqueNetId PartyHostPlayerId)
{
	local PlayerController PC;

	// End:0x7F
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x7E
		if(PC.IsPrimaryPlayer())
		{
			PC.ClientNotifyPartyHostLeaving(PartyHostPlayerId);
		}		
	}	
	//return;	
}

function TellClientsToTravelToSession(name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
	local PlayerController PC;

	// End:0xB7
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xB6
		if(PC.IsLocalPlayerController()! && PC.IsPrimaryPlayer())
		{
			PC.ClientTravelToSession(SessionName, SearchClass, PlatformSpecificInfo);
		}		
	}	
	//return;	
}

exec function DoTravelTheWorld()
{
	// End:0x3C
	if(MyAutoTestManager != none)
	{
		GotoState('TravelTheWorld');
		MyAutoTestManager.DoTravelTheWorld();
	}
	//return;	
}

// Export UGameInfo::execSetBandwidthLimit(FFrame&, void* const)
native exec function SetBandwidthLimit(float AsyncIOBandwidthLimit);

function bool IsAutomatedPerfTesting()
{
	return (MyAutoTestManager != none) && MyAutoTestManager.bAutomatedPerfTesting;
	//return ReturnValue;	
}

function bool IsCheckingForFragmentation()
{
	return (MyAutoTestManager != none) && MyAutoTestManager.bCheckingForFragmentation;
	//return ReturnValue;	
}

function bool IsCheckingForMemLeaks()
{
	return (MyAutoTestManager != none) && MyAutoTestManager.bCheckingForMemLeaks;
	//return ReturnValue;	
}

function bool IsDoingASentinelRun()
{
	return (MyAutoTestManager != none) && MyAutoTestManager.bDoingASentinelRun;
	//return ReturnValue;	
}

function bool ShouldAutoContinueToNextRound()
{
	return (MyAutoTestManager != none) && MyAutoTestManager.bAutoContinueToNextRound;
	//return ReturnValue;	
}

function bool CheckForSentinelRun()
{
	return (MyAutoTestManager != none) && MyAutoTestManager.CheckForSentinelRun();
	//return ReturnValue;	
}

simulated exec function BeginBVT(coerce optional string TagDesc)
{
	// End:0x34
	if(MyAutoTestManager == none)
	{
		MyAutoTestManager = Spawn(AutoTestManagerClass);
	}
	MyAutoTestManager.BeginSentinelRun("BVT", "", TagDesc);
	MyAutoTestManager.SetTimer(3.0000000, true, 'DoTimeBasedSentinelStatGathering');
	//return;	
}

// Export UGameInfo::execEnableStandbyCheatDetection(FFrame&, void* const)
native function EnableStandbyCheatDetection(bool bIsEnabled);

event StandbyCheatDetected(GameInfo.EStandbyType StandbyType)
{
	//return;	
}

function OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	// End:0x19
	if(ProcessServerLogin()!)
	{
		RegisterServer();
	}
	GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
	//return;	
}

event OnEngineHasLoaded()
{
	//return;	
}

function InitCrowdPopulationManager()
{
	// End:0x33
	if(PopulationManagerClass != none)
	{
		PopulationManager = Spawn(PopulationManagerClass);
	}
	//return;	
}

function SpawnGripAIManager()
{
	local Class<Actor> GripAIManagerClass;

	// End:0x8B
	if(GripAIManagerClassPath != "")
	{
		GripAIManagerClass = Class<Actor>(DynamicLoadObject(GripAIManagerClassPath, Class'Core.Class'));
		// End:0x8B
		if(GripAIManagerClass != none)
		{
			GripAIManagerHolder = Spawn(GripAIManagerClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
		}
	}
	//return;	
}

function SpawnGwNavWorldActor()
{
	local Class<Actor> GwNavWorldActorClass;

	// End:0x26
	if(WorldInfo.GwNavWorldObject == none)
	{
		return;
	}
	// End:0xB1
	if(GwNavWorldActorClassPath != "")
	{
		GwNavWorldActorClass = Class<Actor>(DynamicLoadObject(GwNavWorldActorClassPath, Class'Core.Class'));
		// End:0xB1
		if(GwNavWorldActorClass != none)
		{
			GwNavWorldActor = Spawn(GwNavWorldActorClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
		}
	}
	//return;	
}

event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
	//return;	
}

function ClearOnlineDelegates()
{
	//return;	
}

auto state PendingMatch
{
	function bool MatchIsInProgress()
	{
		return false;
		//return ReturnValue;		
	}

	function StartMatch()
	{
		// End:0x1A
		if(bUsingArbitration)
		{
			StartArbitrationRegistration();			
		}
		else
		{
			global.StartMatch();
		}
		//return;		
	}

	function StartArbitrationRegistration()
	{
		local PlayerController PC;
		local UniqueNetId HostId;
		local OnlineGameSettings GameSettings;

		// End:0x18E
		if(bHasArbitratedHandshakeBegun!)
		{
			bHasArbitratedHandshakeBegun = true;
			GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
			HostId = GameSettings.OwningPlayerId;
			PendingArbitrationPCs.Length = 0;
			// End:0x176
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x157
				if(PC.IsLocalPlayerController()!)
				{
					PC.ClientSetHostUniqueId(HostId);
					PC.ClientRegisterForArbitration();
					PendingArbitrationPCs[PendingArbitrationPCs.Length] = PC;
					// End:0x175
					continue;
				}
				ArbitrationPCs[ArbitrationPCs.Length] = PC;				
			}			
			SetTimer(ArbitrationHandshakeTimeout, false, 'ArbitrationTimeout');
		}
		//return;		
	}

	function RegisterServerForArbitration()
	{
		// End:0x92
		if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
		{
			GameInterface.AddArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
			GameInterface.RegisterForArbitration(PlayerReplicationInfoClass.default.SessionName);			
		}
		else
		{
			ArbitrationRegistrationComplete(PlayerReplicationInfoClass.default.SessionName, true);
		}
		//return;		
	}

	function ArbitrationRegistrationComplete(name SessionName, bool bWasSuccessful)
	{
		GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
		// End:0x4B
		if(bWasSuccessful)
		{
			StartArbitratedMatch();			
		}
		else
		{			
			ConsoleCommand("Disconnect");
		}
		//return;		
	}

	function ArbitrationTimeout()
	{
		local int Index;

		Index = 0;
		J0x0B:

		// End:0x81 [Loop If]
		if(Index < PendingArbitrationPCs.Length)
		{
			AccessControl.KickPlayer(PendingArbitrationPCs[Index], GameMessageClass.default.MaxedOutMessage);
			Index++;
			// [Loop Continue]
			goto J0x0B;
		}
		PendingArbitrationPCs.Length = 0;
		RegisterServerForArbitration();
		//return;		
	}

	function StartArbitratedMatch()
	{
		bNeedsEndGameHandshake = true;
		global.StartMatch();
		//return;		
	}

	function ProcessClientRegistrationCompletion(PlayerController PC, bool bWasSuccessful)
	{
		local int FoundIndex;

		FoundIndex = PendingArbitrationPCs.Find(PC);
		// End:0xBC
		if(FoundIndex != -1)
		{
			PendingArbitrationPCs.Remove(FoundIndex, 1);
			// End:0x76
			if(bWasSuccessful)
			{
				ArbitrationPCs[ArbitrationPCs.Length] = PC;				
			}
			else
			{
				AccessControl.KickPlayer(PC, GameMessageClass.default.MaxedOutMessage);
			}
		}
		// End:0xE9
		if(PendingArbitrationPCs.Length == 0)
		{
			SetTimer(0.0000000, false, 'ArbitrationTimeout');
			RegisterServerForArbitration();
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		SetTimer(0.0000000, false, 'ArbitrationTimeout');
		// End:0x64
		if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
		{
			GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
		}
		//return;		
	}
	stop;	
}

state TravelTheWorld
{	stop;	
}

defaultproperties
{
	bRestartLevel=true
	bPauseable=true
	bDelayedStart=true
	bChangeLevels=true
	GameDifficulty=1.0000000
	GameSpeed=1.0000000
	HUDType=Class'Engine.HUD'
	MaxSpectators=2
	MaxSpectatorsAllowed=32
	MaxPlayers=32
	MaxPlayersAllowed=32
	CurrentID=1
	DefaultPlayerName="Player"
	GameName="Game"
	FearCostFallOff=0.9500000
	DeathMessageClass=Class'Engine.LocalMessage'
	GameMessageClass=Class'Engine.GameMessage'
	AccessControlClass=Class'Engine.AccessControl'
	BroadcastHandlerClass=Class'Engine.BroadcastHandler'
	AutoTestManagerClass=Class'Engine.AutoTestManager'
	PlayerControllerClass=Class'Engine.PlayerController'
	PlayerReplicationInfoClass=Class'Engine.PlayerReplicationInfo'
	GameReplicationInfoClass=Class'Engine.GameReplicationInfo'
	GripAIManagerClassPath="Grip.GripAIManagerHolder"
	TimeMarginSlack=1.3500000
	MinTimeMargin=-1.0000000
	LeaderboardId=-131072
	ArbitratedLeaderboardId=-65536
	TotalNetBandwidth=32000
	MinDynamicBandwidth=4000
	MaxDynamicBandwidth=7000
	StreamingPauseIcon=Material'mainhud.Loading.LoadingSpinner_Mat'
	DefaultGameType="MegaHaloGame.HaloGameDefault"
	GwNavWorldActorClassPath="GwNavEngine.GwNavWorldActor"
	Components=none
}