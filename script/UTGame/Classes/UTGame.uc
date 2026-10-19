class UTGame extends UDKGame
	config(Game)
	dependson(UTCharInfo);

enum EVoiceChannel
{
	VC_Spectators,                  // 0
	VC_Team1,                       // 1
	VC_Team2,                       // 2
	VC_MAX                          // 3
};

struct GameMapCycle
{
	var name GameClassName;
	var array<string> Maps;

	structdefaultproperties
	{
		GameClassName="None"
		Maps=none
	}
};

struct ActiveBotInfo
{
	var string BotName;
	var bool bInUse;

	structdefaultproperties
	{
		BotName=""
		bInUse=false
	}
};

var bool bExportMenuData;
var bool bWeaponStay;
var bool bTeamScoreRounds;
var bool bSoaking;
var bool bPlayersVsBots;
var bool bCustomBots;
var bool bAutoNumBots;
var globalconfig bool bPlayersMustBeReady;
var globalconfig bool bForceRespawn;
var bool bTempForceRespawn;
var globalconfig bool bWaitForNetPlayers;
var bool bShouldWaitForNetPlayers;
var config bool bWarmupRound;
var bool bFirstBlood;
var bool bQuickStart;
var bool bSkipPlaySound;
var bool bStartedCountDown;
var bool bFinalStartup;
var bool bOverTimeBroadcast;
var bool bMustHaveMultiplePlayers;
var bool bPlayerBecameActive;
var bool bMustJoinBeforeStart;
var bool bDemoMode;
var bool bUndrivenVehicleDamage;
var bool bStartWithLockerWeaps;
var bool bAllowHoverboard;
var bool bConsoleServer;
var bool bAllowKeyboardAndMouse;
var bool bScoreDeaths;
var bool bPlayedTenKills;
var bool bPlayedFiveKills;
var bool bPlayedOneKill;
var bool bMidGameHasMap;
var config bool bForceMidGameMenuAtStart;
var bool bNecrisLocked;
var bool bIgnoreTeamForVoiceChat;
var bool bUseClassicHUD;
var config bool bLogGameplayEvents;
var string Acronym;
var const localized string Description;
var globalconfig int ServerSkillLevel;
var globalconfig float EndTimeDelay;
var globalconfig float BotRatio;
var config int NetWait;
var config int ClientProcessingTimeout;
var globalconfig int MinNetPlayers;
var globalconfig int RestartWait;
var config int WarmupTime;
var int WarmupRemaining;
var byte StartupStage;
var byte WeaponTauntUsed[20];
var int DesiredPlayerCount;
var float SpawnProtectionTime;
var int DefaultMaxLives;
var config int LateEntryLives;
var int PendingMatchElapsedTime;
var int CountDown;
var float AdjustedDifficulty;
var int PlayerKills;
var int PlayerDeaths;
var NavigationPoint LastPlayerStartSpot;
var NavigationPoint LastStartSpot;
var float EndTime;
var int EndMessageWait;
var transient int EndMessageCounter;
var string RulesMenuType;
var string GameUMenuType;
var Actor EndGameFocus;
var int ResetCountDown;
var config int ResetTimeDelay;
var UTVehicle VehicleList;
var UTTeamInfo EnemyRoster;
var string EnemyRosterName;
var array< Class<Inventory> > DefaultInventory;
var Class<UTVictoryMessage> VictoryMessageClass;
var array<string> MapPrefixes;
var Class<PlayerController> ConsolePlayerControllerClass;
var string DemoPrefix;
var Class<UTBot> BotClass;
var globalconfig array<config GameMapCycle> GameSpecificMapCycles;
var globalconfig int MapCycleIndex;
var globalconfig array<config ActiveBotInfo> ActiveBots;
var NavigationPoint ScriptedStartSpot;
var const localized string EndOfMatchRulesTemplateStr_Scoring;
var const localized string EndOfMatchRulesTemplateStr_ScoringSingle;
var const localized string EndOfMatchRulesTemplateStr_Time;
var SpeechRecognition SpeechRecognitionData;
var float LastEncouragementTime;
var float LastManDownTime;
var Pawn Sniper;
var name MidgameScorePanelTag;
var config string GameplayEventsWriterClassName;
var transient GameplayEventsWriterBase GameplayEventsWriter;
var array<name> SpreeStatEvents;

function PostBeginPlay()
{
	super(GameInfo).PostBeginPlay();
	// End:0x3A
	if(WorldInfo.IsConsoleBuild(3))
	{
		bUseClassicHUD = true;
	}
	// End:0x7A
	if(bPlayersVsBots)
	{
		UTGameReplicationInfo(GameReplicationInfo).BotDifficulty = int(GameDifficulty);
	}
	// End:0x131
	if(((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
	{
		OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
	}
	//return;	
}

static function bool UseLowGore(WorldInfo WI)
{
	return (default.GoreLevel > 0) && int(WI.NetMode) != int(NM_DedicatedServer);
	//return ReturnValue;	
}

static function bool AllowMutator(string MutatorClassName)
{
	// End:0x40
	if(!default.bTeamGame && MutatorClassName ~= "UTGame.UTMutator_FriendlyFire")
	{
		return false;
	}
	// End:0x82
	if(!default.bWeaponStay && MutatorClassName ~= "UTGame.UTMutator_WeaponsRespawn")
	{
		return false;
	}
	// End:0xAD
	if(MutatorClassName ~= "UTGame.UTMutator_Survival")
	{
		return false;
	}
	// End:0xD6
	if(MutatorClassName ~= "UTGame.UTMutator_NoOrbs")
	{
		return false;
	}
	return super(GameInfo).AllowMutator(MutatorClassName);
	//return ReturnValue;	
}

static event Class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	local string ThisMapPrefix;
	local int I, pos;
	local Class<GameInfo> NewGameType;
	local string GameOption;

	// End:0x4B
	if((Left(MapName, 9) ~= "EnvyEntry") || Left(MapName, 14) ~= "UDKFrontEndMap")
	{
		return Class'UTGame.UTEntryGame';
	}
	GameOption = ParseOption(Options, "Game");
	// End:0x88
	if(GameOption != "")
	{
		return default.Class;
	}
	MapName = StripPlayOnPrefix(MapName);
	pos = InStr(MapName, "-");
	ThisMapPrefix = Left(MapName, pos);
	I = 0;
	J0xE9:

	// End:0x13A [Loop If]
	if(I < default.MapPrefixes.Length)
	{
		// End:0x12C
		if(default.MapPrefixes[I] ~= ThisMapPrefix)
		{
			return default.Class;
		}
		I++;
		// [Loop Continue]
		goto J0xE9;
	}
	I = 0;
	J0x145:

	// End:0x205 [Loop If]
	if(I < default.DefaultMapPrefixes.Length)
	{
		// End:0x1F7
		if(default.DefaultMapPrefixes[I].Prefix ~= ThisMapPrefix)
		{
			NewGameType = Class<GameInfo>(DynamicLoadObject(default.DefaultMapPrefixes[I].GameType, Class'Core.Class'));
			// End:0x1F7
			if(NewGameType != none)
			{
				return NewGameType;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x145;
	}
	I = 0;
	J0x210:

	// End:0x2D0 [Loop If]
	if(I < default.CustomMapPrefixes.Length)
	{
		// End:0x2C2
		if(default.CustomMapPrefixes[I].Prefix ~= ThisMapPrefix)
		{
			NewGameType = Class<GameInfo>(DynamicLoadObject(default.CustomMapPrefixes[I].GameType, Class'Core.Class'));
			// End:0x2C2
			if(NewGameType != none)
			{
				return NewGameType;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x210;
	}
	return Class'UTGame.UTGame';
	//return ReturnValue;	
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	local UTPlayerReplicationInfo UTPRI;
	local UDKVehicleBase UTV;

	// End:0x40
	if(BaseMutator != none)
	{
		BaseMutator.DriverEnteredVehicle(V, P);
	}
	UTPRI = ((V != none) ? UTPlayerReplicationInfo(V.PlayerReplicationInfo) : none);
	// End:0x13C
	if(UTPRI != none)
	{
		UTV = UDKVehicleBase(V);
		// End:0xEF
		if(UTV == none)
		{
			UTV = UDKVehicleBase(V.GetVehicleBase());
		}
		// End:0x13C
		if(UTV != none)
		{
			UTPRI.StartDrivingStat(UTV.GetVehicleDrivingStatName());
		}
	}
	//return;	
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
	local UTPlayerReplicationInfo UTPRI;

	// End:0x40
	if(BaseMutator != none)
	{
		BaseMutator.DriverLeftVehicle(V, P);
	}
	UTPRI = UTPlayerReplicationInfo(P.PlayerReplicationInfo);
	// End:0xE1
	if((UTPRI != none) && UDKVehicleBase(V) != none)
	{
		UTPRI.StopDrivingStat(UDKVehicleBase(V).GetVehicleDrivingStatName());
	}
	//return;	
}

function bool AllowBecomeActivePlayer(PlayerController P)
{
	// End:0xD9
	if((((((P.PlayerReplicationInfo == none) || !GameReplicationInfo.bMatchHasBegun) || bMustJoinBeforeStart) || NumPlayers >= MaxPlayers) || MaxLives > 0) || P.IsInState('RoundEnded'))
	{
		P.ReceiveLocalizedMessage(GameMessageClass, 13);
		return false;
	}
	return true;
	//return ReturnValue;	
}

function Reset()
{
	local Controller C;
	local int I;

	super(GameInfo).Reset();
	bOverTimeBroadcast = false;
	FindNewObjectives(none);
	// End:0xC8
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		// End:0xC7
		if((C.PlayerReplicationInfo != none) && !C.PlayerReplicationInfo.bOnlySpectator)
		{
			RestartPlayer(C);
		}		
	}	
	GameReplicationInfo.RemainingTime = 60 * TimeLimit;
	// End:0x156
	if(GameReplicationInfo.RemainingTime == GameReplicationInfo.RemainingMinute)
	{
		GameReplicationInfo.RemainingTime--;
	}
	GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
	I = 0;
	J0x19E:

	// End:0x1D2 [Loop If]
	if(I < 20)
	{
		WeaponTauntUsed[I] = 0;
		I++;
		// [Loop Continue]
		goto J0x19E;
	}
	//return;	
}

function FindNewObjectives(UTGameObjective DisabledObjective)
{
	//return;	
}

function NotifyNavigationChanged(NavigationPoint N)
{
	local UTBot B;

	// End:0x7B
	if(!N.bBlocked)
	{
		// End:0x7A
		foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
		{
			B.bForceRefreshRoute = true;			
		}		
	}
	//return;	
}

static function string ParseKillMessage(string KillerName, string VictimName, string DeathMessage)
{
	return Repl(Repl(DeathMessage, "`k", KillerName), "`o", VictimName);
	//return ReturnValue;	
}

function bool SkipPlaySound()
{
	return bQuickStart || bSkipPlaySound;
	//return ReturnValue;	
}

function SetGameSpeed(float T)
{
	local float UTTimeDilation;

	UTTimeDilation = ((bConsoleServer) ? 0.9500000 : 1.0500000);
	GameSpeed = FMax(T, 0.0000100);
	WorldInfo.TimeDilation = UTTimeDilation * GameSpeed;
	SetTimer(WorldInfo.TimeDilation, true);
	//return;	
}

function BroadcastDeathMessage(Controller Killer, Controller Other, Class<DamageType> DamageType)
{
	local UTBot B;

	// End:0x68
	if((Killer == Other) || Killer == none)
	{
		BroadcastLocalized(self, DeathMessageClass, 1, none, Other.PlayerReplicationInfo, DamageType);		
	}
	else
	{
		BroadcastLocalized(self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, DamageType);
		// End:0x20F
		if(PlayerController(Other) != none)
		{
			// End:0x20C
			if(((((UTPlayerController(Killer) == none) || UTPlayerController(Killer).bAutoTaunt) && Other.PlayerReplicationInfo != none) && UTPlayerReplicationInfo(Killer.PlayerReplicationInfo) != none) && UTPlayerReplicationInfo(Killer.PlayerReplicationInfo).VoiceClass != none)
			{
				Killer.SendMessage(Other.PlayerReplicationInfo, 'Taunt', 10.0000000, DamageType);
			}			
		}
		else
		{
			// End:0x50C
			if(bTeamGame && NumBots > 0)
			{
				// End:0x43B
				if(UTPlayerController(Killer) != none)
				{
					// End:0x438
					if(((((Other.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo.Team != none) && (WorldInfo.TimeSeconds - LastEncouragementTime) > float(20)) && FRand() < 0.6000000)
					{
						// End:0x437
						foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
						{
							// End:0x436
							if(((B.PlayerReplicationInfo != none) && B.PlayerReplicationInfo.Team == Killer.PlayerReplicationInfo.Team) && FRand() < 0.3300000)
							{
								B.SendMessage(Other.PlayerReplicationInfo, 'ENCOURAGEMENT', 0.0000000, DamageType);
								// End:0x437
								break;
							}							
						}						
					}					
				}
				else
				{
					B = UTBot(Other);
					// End:0x50C
					if((((B != none) && FRand() < 0.2000000) && Other.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo.Team != none)
					{
						B.SendMessage(none, 'MANDOWN', 20.0000000, DamageType);
					}
				}
			}
		}
	}
	//return;	
}

function ScoreKill(Controller Killer, Controller Other)
{
	local PlayerReplicationInfo OtherPRI;
	local UTPawn KillerPawn;
	local UTGameReplicationInfo GRI;

	OtherPRI = Other.PlayerReplicationInfo;
	// End:0xB5
	if(OtherPRI != none)
	{
		OtherPRI.NumLives++;
		// End:0xB5
		if((MaxLives > 0) && OtherPRI.NumLives >= MaxLives)
		{
			OtherPRI.bOutOfLives = true;
		}
	}
	super(GameInfo).ScoreKill(Killer, Other);
	// End:0xF3
	if((Killer == none) || Other == none)
	{
		return;
	}
	GRI = UTGameReplicationInfo(GameReplicationInfo);
	// End:0x230
	if((GRI.bStoryMode && !bTeamGame) && Killer.IsA('PlayerController') || Other.IsA('PlayerController'))
	{
		// End:0x1DE
		if(Killer.IsA('AIController'))
		{
			AdjustSkill(AIController(Killer), PlayerController(Other), false);
		}
		// End:0x230
		if(Other.IsA('AIController'))
		{
			AdjustSkill(AIController(Other), PlayerController(Killer), true);
		}
	}
	KillerPawn = UTPawn(Killer.Pawn);
	// End:0x2B3
	if((KillerPawn != none) && KillerPawn.bKillsAffectHead)
	{
		KillerPawn.SetBigHead();
	}
	//return;	
}

function AdjustSkill(AIController B, PlayerController P, bool bWinner)
{
	local float AdjustmentFactor;

	AdjustmentFactor = FClamp(0.5000000 / FMax(1.0000000, float(PlayerKills + PlayerDeaths)), 0.1000000, 0.2500000);
	// End:0x7B
	if(bWinner)
	{
		PlayerKills += 1;
		AdjustedDifficulty = FMin(7.0000000, AdjustedDifficulty + AdjustmentFactor);		
	}
	else
	{
		PlayerDeaths += 1;
		AdjustedDifficulty = FMax(0.0000000, AdjustedDifficulty - AdjustmentFactor);
	}
	AdjustedDifficulty = FClamp(AdjustedDifficulty, GameDifficulty - 1.2500000, GameDifficulty + 1.2500000);
	// End:0x169
	if(bWinner == (B.Skill < AdjustedDifficulty))
	{
		B.Skill = AdjustedDifficulty;
		UTBot(B).ResetSkill();
	}
	//return;	
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, Class<DamageType> DamageType)
{
	local bool bEnemyKill;
	local UTPlayerReplicationInfo KillerPRI, KilledPRI;
	local UTVehicle V;

	// End:0x49
	if(UTBot(KilledPlayer) != none)
	{
		UTBot(KilledPlayer).WasKilledBy(Killer);
	}
	// End:0x89
	if(Killer != none)
	{
		KillerPRI = UTPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	}
	// End:0xC9
	if(KilledPlayer != none)
	{
		KilledPRI = UTPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);
	}
	bEnemyKill = (((KillerPRI != none) && KillerPRI != KilledPRI) && KilledPRI != none) && !bTeamGame || KillerPRI.Team != KilledPRI.Team;
	// End:0x1CE
	if((KillerPRI != none) && UTVehicle(KilledPawn) != none)
	{
		KillerPRI.IncrementVehicleKillStat(UTVehicle(KilledPawn).GetVehicleKillStatName());
	}
	// End:0x42D
	if(KilledPRI != none)
	{
		KilledPRI.LastKillerPRI = KillerPRI;
		// End:0x263
		if(Class<UTDamageType>(DamageType) != none)
		{
			Class<UTDamageType>(DamageType).static.ScoreKill(KillerPRI, KilledPRI, KilledPawn);			
		}
		else
		{
			// End:0x2B6
			if((KillerPRI == KilledPRI) || KillerPRI == none)
			{
				KilledPRI.IncrementSuicideStat('SUICIDES_ENVIRONMENT');				
			}
			else
			{
				KillerPRI.IncrementKillStat('KILLS_ENVIRONMENT');
				KilledPRI.IncrementDeathStat('DEATHS_ENVIRONMENT');
			}
		}
		// End:0x34A
		if(KilledPRI.spree > 4)
		{
			EndSpree(KillerPRI, KilledPRI);			
		}
		else
		{
			KilledPRI.spree = 0;
		}
		// End:0x42D
		if(KillerPRI != none)
		{
			KillerPRI.IncrementKills(bEnemyKill);
			// End:0x42D
			if(bEnemyKill)
			{
				V = UTVehicle(KilledPawn);
				// End:0x42D
				if(!bFirstBlood)
				{
					bFirstBlood = true;
					BroadcastLocalizedMessage(Class'UTGame.UTFirstBloodMessage', 0, KillerPRI);
					KillerPRI.IncrementEventStat('EVENT_FIRSTBLOOD');
				}
			}
		}
	}
	super(GameInfo).Killed(Killer, KilledPlayer, KilledPawn, DamageType);
	// End:0x558
	if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(KilledPlayer) != none)
	{
		V = VehicleList;
		J0x4B1:

		// End:0x558 [Loop If]
		if(V != none)
		{
			// End:0x52D
			if(WorldInfo.GRI.OnSameTeam(KilledPlayer, V))
			{
				V.PlayerStartTime = 0.0000000;
			}
			V = V.NextVehicle;
			// [Loop Continue]
			goto J0x4B1;
		}
	}
	//return;	
}

function bool ForceRespawn()
{
	return ((bForceRespawn || bTempForceRespawn) || MaxLives > 0) || DefaultMaxLives > 0;
	//return ReturnValue;	
}

event InitGame(string Options, out string ErrorMessage)
{
	local string InOpt;
	local int I;

	// End:0x3A
	if(WorldInfo.TimeSeconds == 0.0000000)
	{
		MapCycleIndex = -1;
		SaveConfig();
	}
	I = 0;
	J0x45:

	// End:0x94 [Loop If]
	if(I < ActiveBots.Length)
	{
		ActiveBots[I].bInUse = false;
		I++;
		// [Loop Continue]
		goto J0x45;
	}
	super(GameInfo).InitGame(Options, ErrorMessage);
	InOpt = ParseOption(Options, "ForceRespawn");
	// End:0x101
	if(InOpt != "")
	{
		bForceRespawn = bool(InOpt);
	}
	InOpt = ParseOption(Options, "ClassicHUD");
	// End:0x146
	if(InOpt != "")
	{
		bUseClassicHUD = true;
	}
	InOpt = ParseOption(Options, "CauseEvent");
	// End:0x1AD
	if(InOpt ~= "FlyThrough")
	{
		bFixedPlayerStart = true;
		bForceRespawn = true;
		bQuickStart = true;
	}
	SetGameSpeed(GameSpeed);
	MaxLives = Max(0, GetIntOption(Options, "MaxLives", MaxLives));
	// End:0x211
	if(MaxLives > 0)
	{
		bTempForceRespawn = true;		
	}
	else
	{
		// End:0x23F
		if(DefaultMaxLives > 0)
		{
			bTempForceRespawn = true;
			MaxLives = DefaultMaxLives;
		}
	}
	// End:0x259
	if(DefaultMaxLives > 0)
	{
		TimeLimit = 0;
	}
	GoalScore = ((!IsAutomatedPerfTesting()) ? Max(0, GetIntOption(Options, "GoalScore", GoalScore)) : 0);
	InOpt = ParseOption(Options, "Console");
	// End:0x33A
	if((InOpt != "") || WorldInfo.IsConsoleBuild())
	{
		WorldInfo.bUseConsoleInput = true;
		bConsoleServer = true;
		PlayerControllerClass = ConsolePlayerControllerClass;
	}
	// End:0x393
	if(WorldInfo.IsConsoleBuild())
	{
		bAllowKeyboardAndMouse = true;
		// End:0x393
		if(bAllowKeyboardAndMouse)
		{
			LogInternal("KeyboardAndMouse Enabled");
		}
	}
	InOpt = ParseOption(Options, "DemoMode");
	// End:0x3E0
	if(InOpt != "")
	{
		bDemoMode = bool(InOpt);
	}
	bAutoNumBots = int(WorldInfo.NetMode) == int(NM_Standalone);
	InOpt = ParseOption(Options, "bAutoNumBots");
	// End:0x462
	if(InOpt != "")
	{
		bAutoNumBots = bool(InOpt);
	}
	// End:0x516
	if(bTeamGame && int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		InOpt = ParseOption(Options, "VsBots");
		// End:0x4FD
		if(InOpt != "")
		{
			BotRatio = float(InOpt);
			bPlayersVsBots = BotRatio > float(0);
		}
		// End:0x516
		if(bPlayersVsBots)
		{
			bAutoNumBots = false;
		}
	}
	// End:0x541
	if(HasOption(Options, "NumPlay"))
	{
		bAutoNumBots = false;
	}
	DesiredPlayerCount = ((bAutoNumBots) ? LevelRecommendedPlayers() : Clamp(GetIntOption(Options, "NumPlay", 1), 1, 32));
	InOpt = ParseOption(Options, "PlayersMustBeReady");
	// End:0x5DD
	if(InOpt != "")
	{
		bPlayersMustBeReady = bool(InOpt);
	}
	InOpt = ParseOption(Options, "MinNetPlayers");
	// End:0x62E
	if(InOpt != "")
	{
		MinNetPlayers = int(InOpt);
	}
	bShouldWaitForNetPlayers = bWaitForNetPlayers && int(WorldInfo.NetMode) != int(NM_Standalone);
	InOpt = ParseOption(Options, "QuickStart");
	// End:0x6B3
	if(InOpt != "")
	{
		bQuickStart = true;
	}
	bQuickStart = bQuickStart || IsAutomatedPerfTesting();
	AdjustedDifficulty = GameDifficulty;
	// End:0x78E
	if(int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		InOpt = ParseOption(Options, "WarmupTime");
		// End:0x78B
		if(InOpt != "")
		{
			WarmupTime = int(InOpt);
			WarmupRemaining = WarmupTime;
			bWarmupRound = WarmupTime > 0;
		}		
	}
	else
	{
		bWarmupRound = false;
	}
	DemoPrefix = ParseOption(Options, "demo");
	//return;	
}

function GenericPlayerInitialization(Controller C)
{
	// End:0x3A
	if(!bUseClassicHUD)
	{
		HUDType = ((bTeamGame) ? Class'UTGame.UTGFxTeamHUDWrapper' : Class'UTGame.UTGFxHudWrapper');
	}
	super(GameInfo).GenericPlayerInitialization(C);
	//return;	
}

function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
	// End:0x3B
	if(!PC.IsLocalPlayerController())
	{
		return false;
	}
	return super(GameInfo).SetPause(PC, CanUnpauseDelegate);
	//return ReturnValue;	
}

function int LevelRecommendedPlayers()
{
	local UTMapInfo MapInfo;

	MapInfo = UTMapInfo(WorldInfo.GetMapInfo());
	return ((MapInfo != none) ? Min(12, (MapInfo.RecommendedPlayersMax + MapInfo.RecommendedPlayersMin) / 2) : 1);
	//return ReturnValue;	
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local PlayerController NewPlayer, PC;
	local Controller C;
	local bool bDedicatedServerSpectator;

	// End:0x90
	if(((NumPlayers == 0) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && HasOption(Options, "dedicated"))
	{
		bDedicatedServerSpectator = true;		
		Options $= "?SpectatorOnly=1";
	}
	// End:0x166
	if(MaxLives > 0)
	{
		// End:0x165
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			// End:0x164
			if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
			{
				Options = "?SpectatorOnly=1" $ Options;
				// End:0x165
				break;
			}			
		}		
	}
	NewPlayer = super(GameInfo).Login(Portal, Options, UniqueId, ErrorMessage);
	// End:0x248
	if(UTPlayerController(NewPlayer) != none)
	{
		// End:0x211
		if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
		{
			UTPlayerController(NewPlayer).bLateComer = true;
		}
		// End:0x248
		if(bDedicatedServerSpectator)
		{
			UTPlayerController(NewPlayer).bDedicatedServerSpectator = true;
		}
	}
	// End:0x30B
	if((!bUseClassicHUD && NewPlayer != none) && Class'Engine.Engine'.static.IsSplitScreen())
	{
		bUseClassicHUD = true;
		HUDType = default.HUDType;
		// End:0x30A
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x309
			if(PC != NewPlayer)
			{
				PC.ClientSetHUD(default.HUDType);
			}			
		}		
	}
	return NewPlayer;
	//return ReturnValue;	
}

function bool ShouldRespawn(PickupFactory Other)
{
	return true;
	//return ReturnValue;	
}

function bool WantFastSpawnFor(AIController B)
{
	return NumBots < 4;
	//return ReturnValue;	
}

function float SpawnWait(AIController B)
{
	// End:0x3D
	if(B.PlayerReplicationInfo.bOutOfLives)
	{
		return 999.0000000;
	}
	// End:0x9D
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		// End:0x82
		if(WantFastSpawnFor(B))
		{
			return 0.0000000;
		}
		return FMax(2.0000000, float(NumBots - 4)) * FRand();
	}
	return ((bPlayersVsBots) ? 0.5000000 : FRand());
	//return ReturnValue;	
}

function bool TooManyBots(Controller botToRemove)
{
	// End:0x60
	if((int(WorldInfo.NetMode) != int(NM_Standalone)) && bPlayersVsBots)
	{
		return NumBots > Min(16, int(BotRatio * float(NumPlayers)));
	}
	// End:0x7B
	if(bPlayerBecameActive)
	{
		bPlayerBecameActive = false;
		return true;
	}
	return (NumBots + NumPlayers) > DesiredPlayerCount;
	//return ReturnValue;	
}

function RestartGame()
{
	// End:0x0F
	if(bGameRestarted)
	{
		return;
	}
	// End:0x3D
	if(EndTime > WorldInfo.TimeSeconds)
	{
		return;
	}
	super(GameInfo).RestartGame();
	//return;	
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;
	local bool bLastMan;

	// End:0xE8
	if(bOverTime)
	{
		// End:0x29
		if((NumBots + NumPlayers) == 0)
		{
			return true;
		}
		bLastMan = true;
		// End:0xD8
		foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
		{
			// End:0xD7
			if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
			{
				bLastMan = false;
				// End:0xD8
				break;
			}			
		}		
		// End:0xE8
		if(bLastMan)
		{
			return true;
		}
	}
	bLastMan = Reason ~= "LastMan";
	// End:0x139
	if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
	{
		return false;
	}
	// End:0x26C
	if(Winner == none)
	{
		// End:0x26B
		foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
		{
			// End:0x26A
			if((P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives) && (Winner == none) || P.PlayerReplicationInfo.Score >= Winner.Score)
			{
				Winner = P.PlayerReplicationInfo;
			}			
		}		
	}
	// End:0x3C8
	if(!bLastMan)
	{
		// End:0x3C7
		foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
		{
			// End:0x3C6
			if(((P.bIsPlayer && Winner != P.PlayerReplicationInfo) && P.PlayerReplicationInfo.Score == Winner.Score) && !P.PlayerReplicationInfo.bOutOfLives)
			{
				// End:0x3C3
				if(!bOverTimeBroadcast)
				{
					StartupStage = 7;
					PlayStartupMessage();
					bOverTimeBroadcast = true;
				}				
				return false;
			}			
		}		
	}
	EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
	GameReplicationInfo.Winner = Winner;
	SetEndGameFocus(Winner);
	return true;
	//return ReturnValue;	
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;
	local Vehicle V;

	EndGameFocus = Controller(Winner.Owner).Pawn;
	// End:0xFB
	if((EndGameFocus == none) && Controller(Winner.Owner) != none)
	{
		RestartPlayer(Controller(Winner.Owner));
		EndGameFocus = Controller(Winner.Owner).Pawn;
	}
	V = Vehicle(EndGameFocus);
	// End:0x19A
	if(((V != none) && !V.bAttachDriver) && V.Driver != none)
	{
		EndGameFocus = V.Driver;
	}
	// End:0x1CA
	if(EndGameFocus != none)
	{
		EndGameFocus.bAlwaysRelevant = true;
	}
	// End:0x276
	foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
	{
		P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo == Winner);		
	}	
	//return;	
}

function bool AtCapacity(bool bSpectator)
{
	local Controller C;
	local bool bForcedSpectator;

	// End:0x2B
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		return false;
	}
	// End:0x4F
	if(bPlayersVsBots)
	{
		MaxPlayers = Min(MaxPlayers, 16);
	}
	// End:0x73
	if(MaxLives <= 0)
	{
		return super(GameInfo).AtCapacity(bSpectator);
	}
	// End:0x11E
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		// End:0x11D
		if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
		{
			bForcedSpectator = true;
			// End:0x11E
			break;
		}		
	}	
	// End:0x143
	if(!bForcedSpectator)
	{
		return super(GameInfo).AtCapacity(bSpectator);
	}
	return ((GetNumPlayers()) + NumSpectators) >= (MaxPlayers + MaxSpectators);
	//return ReturnValue;	
}

event PostLogin(PlayerController NewPlayer)
{
	local UTPlayerController PC;
	local UTGameReplicationInfo GRI;

	super(GameInfo).PostLogin(NewPlayer);
	PC = UTPlayerController(NewPlayer);
	// End:0x15E
	if(PC != none)
	{
		PC.PlayStartupMessage(StartupStage);
		PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);
		GRI = UTGameReplicationInfo(GameReplicationInfo);
		// End:0x15E
		if(((bForceMidGameMenuAtStart && !GRI.bStoryMode) && !GRI.bMatchHasBegun) && (NetWait - PendingMatchElapsedTime) > 5)
		{
			UTPlayerReplicationInfo(PC.PlayerReplicationInfo).ShowMidGameMenu(true);
		}
	}
	Pausers.Length = 0;
	WorldInfo.Pauser = none;
	//return;	
}

function UpdateGameSettingsCounts()
{
	local int TotalOpenConnections, TotalConnections;
	local OnlineGameSettings GameSettings;

	// End:0x68
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
	}
	// End:0x322
	if((GameSettings != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameSettings.NumPublicConnections = Clamp(GameSettings.NumPublicConnections, 0, MaxPlayers);
		GameSettings.NumPrivateConnections = Clamp(GameSettings.NumPrivateConnections, 0, MaxPlayers - GameSettings.NumPublicConnections);
		GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - (GetNumPlayers());
		// End:0x1D8
		if(GameSettings.NumOpenPublicConnections < 0)
		{
			GameSettings.NumOpenPublicConnections = 0;
		}
		TotalOpenConnections = GameSettings.NumOpenPublicConnections + GameSettings.NumOpenPrivateConnections;
		TotalConnections = GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections;
		GameSettings.SetStringSettingValue(12, ((TotalOpenConnections == 0) ? 1 : 0), false);
		GameSettings.SetStringSettingValue(13, ((TotalOpenConnections == TotalConnections) ? 1 : 0), false);
		GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, GameSettings);
	}
	//return;	
}

function AssignHoverboard(UTPawn P)
{
	// End:0x39
	if(P != none)
	{
		P.bHasHoverboard = bAllowHoverboard;
	}
	//return;	
}

function int GetHandicapNeed(Pawn Other)
{
	return 0;
	//return ReturnValue;	
}

function RestartPlayer(Controller aPlayer)
{
	local UTVehicle V, Best;
	local Vector ViewDir;
	local float bestDist, Dist;
	local UTPlayerController PC;

	PC = UTPlayerController(aPlayer);
	// End:0x6F
	if(PC != none)
	{
		// End:0x6F
		if((bMustJoinBeforeStart && PC != none) && PC.bLateComer)
		{
			return;
		}
	}
	// End:0xA8
	if(aPlayer.PlayerReplicationInfo.bOutOfLives)
	{
		return;
	}
	// End:0x13A
	if(UTBot(aPlayer) != none)
	{
		// End:0xF3
		if(TooManyBots(aPlayer))
		{
			aPlayer.Destroy();
			return;			
		}
		else
		{
			// End:0x13A
			if(UTGameReplicationInfo(GameReplicationInfo).bStoryMode)
			{
				CampaignSkillAdjust(UTBot(aPlayer));
			}
		}
	}
	super(GameInfo).RestartPlayer(aPlayer);
	// End:0x173
	if(aPlayer.Pawn == none)
	{
		return;
	}
	AssignHoverboard(UTPawn(aPlayer.Pawn));
	// End:0x4A6
	if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(aPlayer) != none)
	{
		bestDist = 2000.0000000;
		ViewDir = Vector(aPlayer.Pawn.Rotation);
		V = VehicleList;
		J0x248:

		// End:0x454 [Loop If]
		if(V != none)
		{
			// End:0x2AB
			if(!bTeamGame && V.bTeamLocked)
			{
				V.bTeamLocked = false;
			}
			// End:0x429
			if(V.bTeamLocked && WorldInfo.GRI.OnSameTeam(aPlayer, V))
			{
				Dist = VSize(V.Location - aPlayer.Pawn.Location);
				// End:0x3EC
				if((ViewDir Dot (V.Location - aPlayer.Pawn.Location)) < float(0))
				{
					Dist *= float(2);
				}
				// End:0x429
				if(Dist < bestDist)
				{
					Best = V;
					bestDist = Dist;
				}
			}
			V = V.NextVehicle;
			// [Loop Continue]
			goto J0x248;
		}
		// End:0x4A6
		if(Best != none)
		{
			Best.PlayerStartTime = WorldInfo.TimeSeconds + float(8);
		}
	}
	// End:0x4C9
	if(PC != none)
	{
		SetupPlayerMuteList(PC, false);
	}
	//return;	
}

function CampaignSkillAdjust(UTBot aBot)
{
	aBot.Skill = AdjustedDifficulty;
	//return;	
}

function AddDefaultInventory(Pawn PlayerPawn)
{
	local int I;
	local UTWeaponLocker Locker, BestLocker;
	local float Dist, bestDist;

	I = 0;
	J0x0B:

	// End:0xA8 [Loop If]
	if(I < DefaultInventory.Length)
	{
		// End:0x9A
		if(PlayerPawn.FindInventoryType(DefaultInventory[I]) == none)
		{
			PlayerPawn.CreateInventory(DefaultInventory[I], I > 0);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x1FE
	if(bStartWithLockerWeaps)
	{
		// End:0x167
		foreach DynamicActors(Class'UTGame.UTWeaponLocker', Locker)
		{
			Dist = VSize(PlayerPawn.Location - Locker.Location);
			// End:0x166
			if((BestLocker == none) || bestDist > Dist)
			{
				bestDist = Dist;
				BestLocker = Locker;
			}			
		}		
		// End:0x1FE
		if(BestLocker != none)
		{
			BestLocker.Touch(PlayerPawn, none, BestLocker.Location, Normal(BestLocker.Location - PlayerPawn.Location));
		}
	}
	PlayerPawn.AddDefaultInventory();
	//return;	
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
	return (ViewTarget != none) && (int(WorldInfo.NetMode) == int(NM_Standalone)) || Viewer.PlayerReplicationInfo.bOnlySpectator;
	//return ReturnValue;	
}

function ChangeName(Controller Other, string S, bool bNameChange)
{
	local Controller aPlayer;

	// End:0x43
	if(Other.PlayerReplicationInfo.PlayerName ~= S)
	{
		return;
	}
	// End:0x6C
	if(Len(S) > 15)
	{
		S = Left(S, 15);
	}
	// End:0x20C
	foreach WorldInfo.AllControllers(Class'Engine.Controller', aPlayer)
	{
		// End:0x20B
		if(aPlayer.bIsPlayer && aPlayer.PlayerReplicationInfo.PlayerName ~= S)
		{
			// End:0x20B
			if(PlayerController(Other) != none)
			{
				PlayerController(Other).ReceiveLocalizedMessage(GameMessageClass, 8);
				// End:0x208
				if(Other.PlayerReplicationInfo.PlayerName ~= DefaultPlayerName)
				{
					Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName $ string(Other.PlayerReplicationInfo.PlayerID));
				}				
				return;
			}
		}		
	}	
	Other.PlayerReplicationInfo.SetPlayerName(S);
	//return;	
}

function DiscardInventory(Pawn Other, optional Controller Killer)
{
	local UTPlayerReplicationInfo UTPRI;

	UTPRI = UTPlayerReplicationInfo(Other.PlayerReplicationInfo);
	// End:0xAD
	if((UTPRI == none) && Other.DrivenVehicle != none)
	{
		UTPRI = UTPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo);
	}
	// End:0x11E
	if((UTPRI != none) && UTPRI.bHasFlag)
	{
		UTPRI.GetFlag().Drop(Killer);
	}
	super(GameInfo).DiscardInventory(Other);
	//return;	
}

function Logout(Controller Exiting)
{
	local int I;
	local UTPlayerReplicationInfo PRI;
	local UTPlayerController ExitingPC;

	PRI = UTPlayerReplicationInfo(Exiting.PlayerReplicationInfo);
	// End:0x89
	if(PRI.bHasFlag)
	{
		PRI.GetFlag().Drop();
	}
	ExitingPC = UTPlayerController(Exiting);
	// End:0xC7
	if(ExitingPC != none)
	{
		RemovePlayerFromMuteLists(ExitingPC);
	}
	super(GameInfo).Logout(Exiting);
	// End:0x1C6
	if(Exiting.IsA('UTBot') && !UTBot(Exiting).bSpawnedByKismet)
	{
		I = ActiveBots.Find('BotName', Exiting.PlayerReplicationInfo.PlayerName);
		// End:0x1BB
		if(I != -1)
		{
			ActiveBots[I].bInUse = false;
		}
		NumBots--;
	}
	// End:0x1E0
	if(NeedPlayers())
	{
		AddBot();
	}
	// End:0x1FA
	if(MaxLives > 0)
	{
		CheckMaxLives(none);
	}
	//return;	
}

exec function KillBots()
{
	local UTBot B;

	DesiredPlayerCount = NumPlayers;
	bPlayersVsBots = false;
	// End:0x67
	foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
	{
		KillBot(B);		
	}	
	//return;	
}

exec function KillOthers()
{
	local UTBot B, ViewedBot;
	local PlayerController PC;

	DesiredPlayerCount = NumPlayers;
	bPlayersVsBots = false;
	// End:0xD4
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xD3
		if(Pawn(PC.ViewTarget) != none)
		{
			ViewedBot = UTBot(Pawn(PC.ViewTarget).Controller);
			DesiredPlayerCount = NumPlayers + 1;
			// End:0xD4
			break;
		}		
	}	
	// End:0x134
	foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
	{
		// End:0x133
		if(B != ViewedBot)
		{
			KillBot(B);
		}		
	}	
	//return;	
}

exec function KillThis()
{
	local PlayerController PC;
	local UTBot ViewedBot;

	// End:0xC1
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xC0
		if(Pawn(PC.ViewTarget) != none)
		{
			ViewedBot = UTBot(Pawn(PC.ViewTarget).Controller);
			// End:0xBD
			if(ViewedBot != none)
			{
				KillBot(ViewedBot);
			}
			// End:0xC1
			break;
		}		
	}	
	//return;	
}

function KillBot(UTBot B)
{
	// End:0x11
	if(B == none)
	{
		return;
	}
	// End:0x113
	if((Vehicle(B.Pawn) != none) && Vehicle(B.Pawn).Driver != none)
	{
		Vehicle(B.Pawn).Driver.KilledBy(Vehicle(B.Pawn).Driver);		
	}
	else
	{
		// End:0x189
		if(B.Pawn != none)
		{
			B.Pawn.KilledBy(B.Pawn);
		}
	}
	// End:0x1B0
	if(B != none)
	{
		B.Destroy();
	}
	//return;	
}

function bool NeedPlayers()
{
	// End:0x12
	if(bMustJoinBeforeStart)
	{
		return false;		
	}
	else
	{
		// End:0x4A
		if(bPlayersVsBots)
		{
			return NumBots < Min(16, int(BotRatio * float(NumPlayers)));			
		}
		else
		{
			return (NumPlayers + NumBots) < DesiredPlayerCount;
		}
	}
	//return ReturnValue;	
}

exec function AddBots(int Num)
{
	local int AddCount;

	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers + NumBots) + Num, 1, 32);
	J0x39:

	// End:0x9E [Loop If]
	if((((NumPlayers + NumBots) < DesiredPlayerCount) && (AddBot()) != none) && AddCount < 8)
	{
		LogInternal("added bot");
		AddCount++;
		// [Loop Continue]
		goto J0x39;
	}
	//return;	
}

exec function UTBot AddNamedBot(string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers + NumBots) + 1, 1, 32);
	return AddBot(BotName, bUseTeamIndex, TeamIndex);
	//return ReturnValue;	
}

function UTBot AddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local UTBot NewBot;
	local int I;

	// End:0xA3
	if(BotName == "")
	{
		I = ActiveBots.Find('bInUse', false);
		// End:0xA0
		if(I != -1)
		{
			BotName = ActiveBots[I].BotName;
			ActiveBots[I].bInUse = true;
		}		
	}
	else
	{
		I = ActiveBots.Find('BotName', BotName);
		// End:0x108
		if(I != -1)
		{
			ActiveBots[I].bInUse = true;
		}
	}
	NewBot = SpawnBot(BotName, bUseTeamIndex, TeamIndex);
	// End:0x161
	if(NewBot == none)
	{
		WarnInternal("Failed to spawn bot.");
		return none;
	}
	NewBot.PlayerReplicationInfo.PlayerID = GetNextPlayerID();
	NumBots++;
	// End:0x1E9
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		RestartPlayer(NewBot);		
	}
	else
	{
		NewBot.GotoState('Dead', 'MPStart');
	}
	return NewBot;
	//return ReturnValue;	
}

function UTBot SpawnBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local UTBot NewBot;
	local UTTeamInfo BotTeam;
	local CharacterInfo BotInfo;

	BotTeam = GetBotTeam(,, bUseTeamIndex, TeamIndex);
	BotInfo = BotTeam.GetBotInfo(BotName);
	NewBot = Spawn(BotClass);
	// End:0xEC
	if(NewBot != none)
	{
		InitializeBot(NewBot, BotTeam, BotInfo);
		// End:0xEC
		if(BaseMutator != none)
		{
			BaseMutator.NotifyLogin(NewBot);
		}
	}
	return NewBot;
	//return ReturnValue;	
}

function InitializeBot(UTBot NewBot, UTTeamInfo BotTeam, const out CharacterInfo BotInfo)
{
	NewBot.Initialize(AdjustedDifficulty, BotInfo);
	BotTeam.AddToTeam(NewBot);
	ChangeName(NewBot, BotInfo.CharName, false);
	BotTeam.SetBotOrders(NewBot);
	//return;	
}

function UTTeamInfo GetBotTeam(optional int TeamBots, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local Class<UTTeamInfo> RosterClass;

	// End:0x1C
	if(EnemyRoster != none)
	{
		return EnemyRoster;
	}
	// End:0x8F
	if(EnemyRosterName != "")
	{
		RosterClass = Class<UTTeamInfo>(DynamicLoadObject(EnemyRosterName, Class'Core.Class'));
		// End:0x8F
		if(RosterClass != none)
		{
			EnemyRoster = Spawn(RosterClass);
		}
	}
	// End:0xC2
	if(EnemyRoster == none)
	{
		EnemyRoster = Spawn(Class'UTGame.UTDMRoster');
	}
	EnemyRoster.Initialize(TeamIndex);
	return EnemyRoster;
	//return ReturnValue;	
}

function InitGameReplicationInfo()
{
	local UTGameReplicationInfo GRI;
	local UTMutator M;

	super(GameInfo).InitGameReplicationInfo();
	GRI = UTGameReplicationInfo(GameReplicationInfo);
	GRI.GoalScore = GoalScore;
	GRI.TimeLimit = TimeLimit;
	GameReplicationInfo.RemainingTime = 60 * TimeLimit;
	GRI.MinNetPlayers = MinNetPlayers;
	GRI.bConsoleServer = WorldInfo.bUseConsoleInput || WorldInfo.IsConsoleBuild();
	GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
	GRI.bRequireReady = bPlayersMustBeReady;
	M = GetBaseUTMutator();
	J0x196:

	// End:0x277 [Loop If]
	if(M != none)
	{		
		GRI.MutatorList $= ((GRI.MutatorList == "") ? PathName(M.Class) : "?" $ PathName(M.Class));
		M = M.GetNextUTMutator();
		// [Loop Continue]
		goto J0x196;
	}
	GRI.RulesString = "";
	GRI.AddGameRule(GetMapTypeRule());
	GRI.AddGameRule(GetEndGameConditionRule());
	GRI.AddGameRule(" ");
	//return;	
}

function string GetMapTypeRule()
{
	return (GameName @ " - ") @ WorldInfo.GetMapName();
	//return ReturnValue;	
}

function string GetEndGameConditionRule()
{
	return GetEndOfMatchRules(GoalScore, TimeLimit);
	//return ReturnValue;	
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
	local float InstigatorSkill;
	local UTVehicle V;
	local Class<UTDamageType> UTDamage;

	// End:0x1D1
	if(InstigatedBy != none)
	{
		UTDamage = Class<UTDamageType>(DamageType);
		// End:0x191
		if(InstigatedBy != injured.Controller)
		{
			// End:0xD6
			if(((WorldInfo.TimeSeconds - injured.SpawnTime) < SpawnProtectionTime) && !DamageType.default.bCausedByWorld)
			{
				Damage = 0;
				return;
			}
			V = UTVehicle(injured);
			// End:0x18E
			if(((V != none) && !V.bHasBeenDriven) && !bUndrivenVehicleDamage)
			{
				Damage = 0;
				super(GameInfo).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
				return;
			}			
		}
		else
		{
			// End:0x1D1
			if((UTDamage != none) && UTDamage.default.bDontHurtInstigator)
			{
				Damage = 0;
				return;
			}
		}
	}
	super(GameInfo).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	// End:0x22B
	if(InstigatedBy == none)
	{
		return;
	}
	// End:0x5AF
	if(WorldInfo.Game.GameDifficulty < 4.5000000)
	{
		// End:0x331
		if((((WorldInfo.Game.GameDifficulty < float(4)) && injured.IsPlayerPawn()) && injured.Controller == InstigatedBy) && int(WorldInfo.NetMode) == int(NM_Standalone))
		{
			Damage *= 0.5000000;
		}
		// End:0x5AF
		if((AIController(InstigatedBy) != none) && int(WorldInfo.NetMode) == int(NM_Standalone))
		{
			InstigatorSkill = AIController(InstigatedBy).Skill;
			// End:0x5AF
			if((InstigatorSkill < 4.5000000) && injured.IsHumanControlled())
			{
				// End:0x57F
				if((((InstigatedBy.Pawn != none) && InstigatedBy.Pawn.Weapon != none) && InstigatedBy.Pawn.Weapon.bMeleeWeapon) || ((injured.Weapon != none) && injured.Weapon.bMeleeWeapon) && VSize(injured.Location - InstigatedBy.Pawn.Location) < float(600))
				{
					Damage = int(float(Damage) * (0.6400000 + (0.0800000 * InstigatorSkill)));					
				}
				else
				{
					Damage = int(float(Damage) * (0.2000000 + (0.1500000 * InstigatorSkill)));
				}
			}
		}
	}
	// End:0x620
	if(InstigatedBy.Pawn != none)
	{
		Damage = int(float(Damage) * InstigatedBy.Pawn.GetDamageScaling());
	}
	//return;	
}

function NotifySpree(UTPlayerReplicationInfo Other, int Num)
{
	local PlayerController PC;

	// End:0x38
	if((((Num % 5) != 0) || Num == 0) || Num > 30)
	{
		return;
	}
	Num = (Num / 5) - 1;
	Other.IncrementEventStat(SpreeStatEvents[Num]);
	// End:0xF5
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		PC.ReceiveLocalizedMessage(Class'UTGame.UTKillingSpreeMessage', Num, Other);		
	}	
	// End:0x1B2
	if((UTPlayerController(Other.Owner) == none) || UTPlayerController(Other.Owner).bAutoTaunt)
	{
		Controller(Other.Owner).SendMessage(none, 'Taunt', 10.0000000, none);
	}
	//return;	
}

function EndSpree(UTPlayerReplicationInfo Killer, UTPlayerReplicationInfo Other)
{
	local PlayerController PC;

	// End:0x11
	if(Other == none)
	{
		return;
	}
	Other.spree = 0;
	// End:0x68
	if(Killer != none)
	{
		Killer.IncrementEventStat('EVENT_ENDSPREE');
	}
	// End:0x138
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xFB
		if((Killer == Other) || Killer == none)
		{
			PC.ReceiveLocalizedMessage(Class'UTGame.UTKillingSpreeMessage', 1, none, Other);
			// End:0x137
			continue;
		}
		PC.ReceiveLocalizedMessage(Class'UTGame.UTKillingSpreeMessage', 0, Other, Killer);		
	}	
	//return;	
}

function UpdateGameplayMuteList(PlayerController PC)
{
	local UTPlayerController UTPC;

	UTPC = UTPlayerController(PC);
	// End:0x3F
	if(UTPC != none)
	{
		SetupPlayerMuteList(UTPC, false);
	}
	super(GameInfo).UpdateGameplayMuteList(PC);
	//return;	
}

function SetupPlayerMuteList(UTPlayerController PC, bool bForceSpectatorChannel)
{
	local TeamInfo MyTeam;
	local int MyVoiceChannel;
	local TeamInfo OtherTeam;
	local UTPlayerController OtherPC;
	local int OtherVoiceChannel;
	local UniqueNetId ZeroUniqueNetId;

	// End:0x46F
	if((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroUniqueNetId)
	{
		MyTeam = PC.PlayerReplicationInfo.Team;
		MyVoiceChannel = 0;
		// End:0x15D
		if(!bForceSpectatorChannel && !PC.PlayerReplicationInfo.bIsSpectator)
		{
			MyVoiceChannel = 1;
			// End:0x15D
			if((!bIgnoreTeamForVoiceChat && MyTeam != none) && MyTeam.TeamIndex > 0)
			{
				MyVoiceChannel = 2;
			}
		}
		// End:0x46B
		foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', OtherPC)
		{
			// End:0x46A
			if((OtherPC != PC) && OtherPC.PlayerReplicationInfo != none)
			{
				// End:0x46A
				if(OtherPC.PlayerReplicationInfo.UniqueId != ZeroUniqueNetId)
				{
					OtherVoiceChannel = 0;
					// End:0x305
					if(!bForceSpectatorChannel && !OtherPC.PlayerReplicationInfo.bIsSpectator)
					{
						OtherVoiceChannel = 1;
						OtherTeam = OtherPC.PlayerReplicationInfo.Team;
						// End:0x305
						if((!bIgnoreTeamForVoiceChat && OtherTeam != none) && OtherTeam.TeamIndex > 0)
						{
							OtherVoiceChannel = 2;
						}
					}
					// End:0x3C3
					if(OtherVoiceChannel != MyVoiceChannel)
					{
						PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
						OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);						
					}
					else
					{
						PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
						OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
					}
					// End:0x46A
					continue;
				}
			}			
		}				
	}
	//return;	
}

function RemovePlayerFromMuteLists(UTPlayerController PC)
{
	local UTPlayerController CurPC;

	// End:0xAE
	if(PC != none)
	{
		// End:0xAD
		foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', CurPC)
		{
			// End:0xAC
			if(CurPC != PC)
			{
				CurPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}			
		}		
	}
	//return;	
}

function ResetAllPlayerMuteListsToSpectatorChannel()
{
	local UTPlayerController PC;

	// End:0x49
	foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
	{
		SetupPlayerMuteList(PC, true);		
	}	
	//return;	
}

function StartMatch()
{
	local bool bTemp;
	local UTPlayerController PC;

	// End:0x80
	if(((GameplayEventsWriter != none) && !GameplayEventsWriter.IsSessionInProgress()) && !Class'Engine.WorldInfo'.static.IsMenuLevel())
	{
		GameplayEventsWriter.StartLogging(0.5000000);
	}
	// End:0x8F
	if(CheckForSentinelRun())
	{
		return;
	}
	GotoState('MatchInProgress');
	GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
	super(GameInfo).StartMatch();
	bTemp = bMustJoinBeforeStart;
	bMustJoinBeforeStart = false;
	AddInitialBots();
	bMustJoinBeforeStart = bTemp;
	LogInternal("START MATCH");
	// End:0x17D
	foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
	{
		SetupPlayerMuteList(PC, false);		
	}	
	// End:0x200
	if(CauseEventCommand != "")
	{
		// End:0x1FF
		foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
		{			
			PC.ConsoleCommand("ce " $ CauseEventCommand);
			// End:0x1FF
			break;			
		}		
	}
	// End:0x277
	if((BugLocString != "") || BugRotString != "")
	{
		// End:0x277
		if(PC.CheatManager != none)
		{
			PC.BugItGoString(BugLocString, BugRotString);
		}
	}
	//return;	
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Sequence GameSequence;
	local array<SequenceObject> Events;
	local int I;

	// End:0x191
	if(((((Reason ~= "triggered") || Reason ~= "LastMan") || Reason ~= "TimeLimit") || Reason ~= "FragLimit") || Reason ~= "TeamScoreLimit")
	{
		super(GameInfo).EndGame(Winner, Reason);
		// End:0x191
		if(bGameEnded)
		{
			GameSequence = WorldInfo.GetGameSequence();
			// End:0x183
			if(GameSequence != none)
			{
				GameSequence.FindSeqObjectsByClass(Class'UTGame.UTSeqEvent_GameEnded', true, Events);
				I = 0;
				J0x126:

				// End:0x183 [Loop If]
				if(I < Events.Length)
				{
					UTSeqEvent_GameEnded(Events[I]).CheckActivate(self, none);
					I++;
					// [Loop Continue]
					goto J0x126;
				}
			}
			GotoState('MatchOver');
		}
	}
	//return;	
}

function EndLogging(string Reason)
{
	// End:0x2E
	if(GameplayEventsWriter != none)
	{
		GameplayEventsWriter.EndLogging();
	}
	super(GameInfo).EndLogging(Reason);
	//return;	
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName, optional bool IsNewPlayer)
{
	local NavigationPoint Best;

	// End:0x33
	if(ScriptedStartSpot != none)
	{
		Best = ScriptedStartSpot;
		ScriptedStartSpot = none;		
	}
	else
	{
		// End:0x90
		if((Player != none) && Player.StartSpot != none)
		{
			LastPlayerStartSpot = Player.StartSpot;
		}
		Best = super(GameInfo).FindPlayerStart(Player, InTeam, IncomingName, IsNewPlayer);
		// End:0xEB
		if(Best != none)
		{
			LastStartSpot = Best;
		}
	}
	return Best;
	//return ReturnValue;	
}

function bool DominatingVictory()
{
	return (PlayerReplicationInfo(GameReplicationInfo.Winner).Deaths == 0) && PlayerReplicationInfo(GameReplicationInfo.Winner).Score >= float(5);
	//return ReturnValue;	
}

function bool IsAWinner(PlayerController C)
{
	// End:0x26
	if(C.PlayerReplicationInfo == none)
	{
		return false;
	}
	return C.PlayerReplicationInfo.bOnlySpectator || C.PlayerReplicationInfo == GameReplicationInfo.Winner;
	//return ReturnValue;	
}

function PlayEndOfMatchMessage()
{
	local UTPlayerController PC;

	// End:0xB5
	if(DominatingVictory())
	{
		// End:0xB1
		foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
		{
			// End:0x85
			if(IsAWinner(PC))
			{
				PC.ClientPlayAnnouncement(VictoryMessageClass, 0);
				// End:0xB0
				continue;
			}
			PC.ClientPlayAnnouncement(VictoryMessageClass, 1);			
		}				
	}
	else
	{
		PlayRegularEndOfMatchMessage();
	}
	//return;	
}

function PlayRegularEndOfMatchMessage()
{
	local UTPlayerController PC;

	// End:0x105
	foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
	{
		// End:0x104
		if((PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOnlySpectator)
		{
			// End:0xD8
			if(IsAWinner(PC))
			{
				PC.ClientPlayAnnouncement(VictoryMessageClass, 2);
				// End:0x104
				continue;
			}
			PC.ClientPlayAnnouncement(VictoryMessageClass, 3);
		}		
	}	
	//return;	
}

function PlayStartupMessage()
{
	local UTPlayerController P;

	// End:0x5D
	foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', P)
	{
		P.PlayStartupMessage(StartupStage);		
	}	
	//return;	
}

function bool JustStarted(float MaxElapsedTime)
{
	return float(GameReplicationInfo.ElapsedTime) < MaxElapsedTime;
	//return ReturnValue;	
}

function EndRound(Actor EndRoundFocus)
{
	local Controller C;

	// End:0x6D
	if(!bGameEnded)
	{
		// End:0x6C
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			C.RoundHasEnded(EndRoundFocus);			
		}		
	}
	GotoState('RoundOver');
	//return;	
}

function bool MatchIsInProgress()
{
	return false;
	//return ReturnValue;	
}

function AddInitialBots()
{
	local int AddCount;

	J0x00:
	// End:0x42 [Loop If]
	if(((NeedPlayers()) && (AddBot()) != none) && AddCount < 16)
	{
		AddCount++;
		// [Loop Continue]
		goto J0x00;
	}
	//return;	
}

function int CalculatedNetSpeed()
{
	local int ModifiedNetBandwidth;

	ModifiedNetBandwidth = TotalNetBandwidth;
	// End:0x2F
	if(IsConsoleDedicatedServer())
	{
		ModifiedNetBandwidth *= float(2);
	}
	return Clamp(ModifiedNetBandwidth / Max(NumPlayers, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
	//return ReturnValue;	
}

function bool IsConsoleDedicatedServer()
{
	local UTPlayerController PC;

	// End:0x45
	foreach LocalPlayerControllers(Class'UTGame.UTPlayerController', PC)
	{
		// End:0x44
		if(PC.bDedicatedServerSpectator)
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam, optional bool IsNewPlayer)
{
	local PlayerStart P, BestStart;
	local float BestRating, NewRating;
	local array<PlayerStart> PlayerStarts;
	local int I, RandStart;
	local byte Team;

	Team = ((((Player != none) && Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.Team != none) ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam);
	// End:0x146
	foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', P)
	{
		// End:0x145
		if(P.bEnabled)
		{
			PlayerStarts[PlayerStarts.Length] = P;
		}		
	}	
	// End:0x162
	if(bFixedPlayerStart)
	{
		RandStart = 0;		
	}
	else
	{
		RandStart = Rand(PlayerStarts.Length);
	}
	I = RandStart;
	J0x18B:

	// End:0x256 [Loop If]
	if(I < PlayerStarts.Length)
	{
		P = PlayerStarts[I];
		NewRating = RatePlayerStart(P, Team, Player);
		// End:0x20B
		if(NewRating >= float(30))
		{
			return P;
		}
		// End:0x248
		if(NewRating > BestRating)
		{
			BestRating = NewRating;
			BestStart = P;
		}
		I++;
		// [Loop Continue]
		goto J0x18B;
	}
	I = 0;
	J0x261:

	// End:0x32B [Loop If]
	if(I < RandStart)
	{
		P = PlayerStarts[I];
		NewRating = RatePlayerStart(P, Team, Player);
		// End:0x2E0
		if(NewRating >= float(30))
		{
			return P;
		}
		// End:0x31D
		if(NewRating > BestRating)
		{
			BestRating = NewRating;
			BestStart = P;
		}
		I++;
		// [Loop Continue]
		goto J0x261;
	}
	return BestStart;
	//return ReturnValue;	
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Score, NextDist;
	local Controller OtherPlayer;
	local bool bTwoPlayerGame;

	Score = float(((P.bPrimaryStart) ? 30 : 20));
	// End:0x74
	if((P == LastStartSpot) || P == LastPlayerStartSpot)
	{
		Score -= 15.0000000;
	}
	bTwoPlayerGame = (NumPlayers + NumBots) == 2;
	// End:0x67B
	if(Player != none)
	{
		// End:0x67A
		foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherPlayer)
		{
			// End:0x679
			if(OtherPlayer.bIsPlayer && OtherPlayer.Pawn != none)
			{
				// End:0x307
				if((Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < (P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight)) && VSize2D(P.Location - OtherPlayer.Pawn.Location) < (P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius))
				{					
					return -10.0000000;
				}
				NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
				// End:0x534
				if(((NextDist < float(3000)) && !WorldInfo.GRI.OnSameTeam(Player, OtherPlayer)) && FastTrace(P.Location, OtherPlayer.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * OtherPlayer.Pawn.CylinderComponent.CollisionHeight)))
				{
					// End:0x510
					if((OtherPlayer.PlayerReplicationInfo != none) && UTPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
					{
						Score -= float(7);
					}
					Score -= (float(5) - (0.0010000 * NextDist));
					// End:0x679
					continue;
				}
				// End:0x5E2
				if(((NextDist < float(1500)) && OtherPlayer.PlayerReplicationInfo != none) && UTPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
				{
					Score -= float(7);
					// End:0x679
					continue;
				}
				// End:0x679
				if(bTwoPlayerGame)
				{
					Score += FMin(2.0000000, 0.0010000 * NextDist);
					// End:0x679
					if(FastTrace(P.Location, OtherPlayer.Pawn.Location))
					{
						Score -= float(5);
					}
				}
			}			
		}		
	}
	return FMax(Score, 0.2000000);
	//return ReturnValue;	
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
	local Controller C;
	local PlayerReplicationInfo Living;
	local bool bNoneLeft;

	// End:0x225
	if(MaxLives > 0)
	{
		// End:0x57
		if((Scorer != none) && !Scorer.bOutOfLives)
		{
			Living = Scorer;
		}
		bNoneLeft = true;
		// End:0x1CB
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			// End:0x1CA
			if((((C.PlayerReplicationInfo != none) && C.bIsPlayer) && !C.PlayerReplicationInfo.bOutOfLives) && !C.PlayerReplicationInfo.bOnlySpectator)
			{
				// End:0x18F
				if(Living == none)
				{
					Living = C.PlayerReplicationInfo;
					// End:0x1CA
					continue;
				}
				// End:0x1CA
				if(C.PlayerReplicationInfo != Living)
				{
					bNoneLeft = false;
					// End:0x1CB
					break;
				}
			}			
		}		
		// End:0x225
		if(bNoneLeft)
		{
			// End:0x207
			if(Living != none)
			{
				EndGame(Living, "LastMan");				
			}
			else
			{
				EndGame(Scorer, "LastMan");
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	local Controller C;

	// End:0x18
	if(CheckMaxLives(Scorer))
	{
		return false;
	}
	// End:0x410
	if(Scorer != none)
	{
		// End:0x2A2
		if(bScoreDeaths && GoalScore > 0)
		{
			// End:0x115
			if(Scorer.Score == float(GoalScore - 10))
			{
				// End:0x112
				if(!bPlayedTenKills && GoalScore > 19)
				{
					UTGameReplicationInfo(GameReplicationInfo).SortPRIArray();
					// End:0x112
					if(Scorer == GameReplicationInfo.PRIArray[0])
					{
						bPlayedTenKills = true;
						BroadcastLocalized(self, Class'UTGame.UTKillsRemainingMessage', 0);
					}
				}				
			}
			else
			{
				// End:0x1E5
				if(Scorer.Score == float(GoalScore - 5))
				{
					// End:0x1E2
					if(!bPlayedFiveKills && GoalScore > 9)
					{
						UTGameReplicationInfo(GameReplicationInfo).SortPRIArray();
						// End:0x1E2
						if(Scorer == GameReplicationInfo.PRIArray[0])
						{
							bPlayedFiveKills = true;
							BroadcastLocalized(self, Class'UTGame.UTKillsRemainingMessage', 1);
						}
					}					
				}
				else
				{
					// End:0x2A2
					if((Scorer.Score == float(GoalScore - 1)) && !bPlayedOneKill)
					{
						UTGameReplicationInfo(GameReplicationInfo).SortPRIArray();
						// End:0x2A2
						if(Scorer == GameReplicationInfo.PRIArray[0])
						{
							bPlayedOneKill = true;
							BroadcastLocalized(self, Class'UTGame.UTKillsRemainingMessage', 2);
						}
					}
				}
			}
		}
		// End:0x302
		if((GoalScore > 0) && Scorer.Score >= float(GoalScore))
		{
			EndGame(Scorer, "fraglimit");			
		}
		else
		{
			// End:0x410
			if(bOverTime)
			{
				// End:0x3F1
				foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
				{
					// End:0x3F0
					if(((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo != Scorer) && C.PlayerReplicationInfo.Score >= Scorer.Score)
					{						
						return false;
					}					
				}				
				EndGame(Scorer, "fraglimit");
			}
		}
	}
	return true;
	//return ReturnValue;	
}

function RegisterVehicle(UTVehicle V)
{
	V.NextVehicle = VehicleList;
	VehicleList = V;
	//return;	
}

function ActivateVehicleFactory(UTVehicleFactory VF)
{
	local UTGameObjective O, Best;
	local float bestDist, newdist;

	// End:0x30
	if(!bTeamGame)
	{
		VF.bStartNeutral = true;
	}
	// End:0x76
	if(VF.bStartNeutral)
	{
		VF.Activate(255);		
	}
	else
	{
		// End:0x143
		foreach WorldInfo.AllNavigationPoints(Class'UTGame.UTGameObjective', O)
		{
			newdist = VSize(VF.Location - O.Location);
			// End:0x142
			if((Best == none) || newdist < bestDist)
			{
				Best = O;
				bestDist = newdist;
			}			
		}		
		// End:0x193
		if(Best != none)
		{
			VF.Activate(Best.DefenderTeamIndex);			
		}
		else
		{
			VF.Activate(255);
		}
	}
	//return;	
}

function ViewObjective(PlayerController PC)
{
	local int I, Index, Score;
	local Controller C;

	// End:0x3C
	if(WorldInfo.GRI.PRIArray.Length == 0)
	{
		return;
	}
	Score = -1;
	Index = -1;
	I = 0;
	J0x65:

	// End:0x222 [Loop If]
	if(I < WorldInfo.GRI.PRIArray.Length)
	{
		// End:0x214
		if(WorldInfo.GRI.PRIArray[I].Score > float(Score))
		{
			C = Controller(WorldInfo.GRI.PRIArray[I].Owner);
			// End:0x214
			if((C != none) && C.Pawn != none)
			{
				Score = int(WorldInfo.GRI.PRIArray[I].Score);
				Index = I;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x65;
	}
	// End:0x237
	if(Index == -1)
	{
		return;
	}
	// End:0x31A
	if((Index >= 0) && Index < WorldInfo.GRI.PRIArray.Length)
	{
		PC.SetViewTarget(Controller(WorldInfo.GRI.PRIArray[Index].Owner).Pawn);
	}
	//return;	
}

function AddMutator(string mutname, optional bool bUserAdded)
{
	// End:0x36
	if(InStr(mutname, ".") < 0)
	{
		mutname = "UTGame." $ mutname;
	}
	super(GameInfo).AddMutator(mutname, bUserAdded);
	//return;	
}

function bool AllowClientToTeleport(UTPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
	return true;
	//return ReturnValue;	
}

function ShowPathTo(PlayerController P, int TeamNum)
{
	//return;	
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	local UTBot B;

	// End:0x55
	foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
	{
		B.KilledVehicleClass = none;		
	}	
	super(GameInfo).GetSeamlessTravelActorList(bToEntry, ActorList);
	//return;	
}

event PostSeamlessTravel()
{
	local int I;
	local UTPlayerReplicationInfo PRI;

	super(GameInfo).PostSeamlessTravel();
	// End:0x171
	if((UTGameReplicationInfo(WorldInfo.GRI) != none) && UTGameReplicationInfo(WorldInfo.GRI).bStoryMode)
	{
		I = 0;
		J0x84:

		// End:0x171 [Loop If]
		if(I < WorldInfo.GRI.PRIArray.Length)
		{
			PRI = UTPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]);
			// End:0x163
			if((PRI != none) && PRI.Owner == none)
			{
				PRI.Destroy();
			}
			I++;
			// [Loop Continue]
			goto J0x84;
		}
	}
	//return;	
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local UTBot B;
	local UTPlayerController PC;
	local string BotName;
	local int BotTeamIndex;

	B = UTBot(C);
	// End:0x10F
	if((B != none) && B.Class != BotClass)
	{
		BotName = B.PlayerReplicationInfo.PlayerName;
		BotTeamIndex = int(B.GetTeamNum());
		B.Destroy();
		C = AddBot(BotName, BotTeamIndex != 255, BotTeamIndex);		
	}
	else
	{
		super(GameInfo).HandleSeamlessTravelPlayer(C);
		// End:0x183
		if((B != none) && B.Squad == none)
		{
			GetBotTeam().AddToTeam(B);
		}
		PC = UTPlayerController(C);
		// End:0x1D6
		if(PC != none)
		{
			PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);
		}
	}
	//return;	
}

function Actor GetAutoObjectiveFor(UTPlayerController PC)
{
	//return ReturnValue;	
}

function UTMutator GetBaseUTMutator()
{
	local Mutator M;
	local UTMutator UTMut;

	M = BaseMutator;
	J0x13:

	// End:0x82 [Loop If]
	if(M != none)
	{
		UTMut = UTMutator(M);
		// End:0x57
		if(UTMut != none)
		{
			return UTMut;
		}
		M = M.NextMutator;
		// [Loop Continue]
		goto J0x13;
	}
	return none;
	//return ReturnValue;	
}

function ProcessSpeechRecognition(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words)
{
	local UTMutator UTMut;

	UTMut = GetBaseUTMutator();
	// End:0x54
	if(UTMut != none)
	{
		UTMut.ProcessSpeechRecognition(Speaker, Words);
	}
	//return;	
}

function WriteOnlinePlayerScores()
{
	local int Index, Count;
	local PlayerReplicationInfo PRI;
	local array<OnlinePlayerScore> PlayerScores;
	local UniqueNetId ZeroId;

	// End:0x285
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
	{
		Index = 0;
		J0x51:

		// End:0x1DF [Loop If]
		if(Index < GameReplicationInfo.PRIArray.Length)
		{
			PRI = GameReplicationInfo.PRIArray[Index];
			// End:0x1D1
			if((PRI != none) && PRI.UniqueId != ZeroId)
			{
				Count++;
				PlayerScores.Length = Count;
				PlayerScores[Count - 1].PlayerID = PRI.UniqueId;
				PlayerScores[Count - 1].Score = int(PRI.Score);
				PlayerScores[Count - 1].TeamID = 255;
			}
			Index++;
			// [Loop Continue]
			goto J0x51;
		}
		// End:0x25A
		if(PlayerScores.Length > 0)
		{
			OnlineSub.StatsInterface.WriteOnlinePlayerScores('Game', ((bUsingArbitration) ? ArbitratedLeaderboardId : LeaderboardId), PlayerScores);			
		}
		else
		{
			WarnInternal("There were no playerscores to write out");
		}
	}
	//return;	
}

function int GetCurrentMapCycleIndex(const out array<string> MapList)
{
	return MapList.Find(string(WorldInfo.GetPackageName()));
	//return ReturnValue;	
}

function string GetNextMap()
{
	local int GameIndex;
	local array<string> MapList;

	GameIndex = Class'UTGame.UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name);
	// End:0x1EC
	if(GameIndex != -1)
	{
		// End:0xF9
		if(MapCycleIndex == -1)
		{
			MapList = Class'UTGame.UTGame'.default.GameSpecificMapCycles[GameIndex].Maps;
			MapCycleIndex = GetCurrentMapCycleIndex(MapList);
			// End:0xF9
			if(MapCycleIndex == -1)
			{
				MapCycleIndex = 0;
			}
		}
		MapCycleIndex = (((MapCycleIndex + 1) < Class'UTGame.UTGame'.default.GameSpecificMapCycles[GameIndex].Maps.Length) ? MapCycleIndex + 1 : 0);
		Class'UTGame.UTGame'.default.MapCycleIndex = MapCycleIndex;
		Class'UTGame.UTGame'.static.StaticSaveConfig();
		return Class'UTGame.UTGame'.default.GameSpecificMapCycles[GameIndex].Maps[MapCycleIndex];
	}
	return "";
	//return ReturnValue;	
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	local Controller C;

	// End:0x78
	if(!IsInState('MatchOver'))
	{
		// End:0x69
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			C.GameHasEnded();			
		}		
		GotoState('MatchOver');
	}
	super(GameInfo).ProcessServerTravel(URL, bAbsolute);
	// End:0x115
	if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) && WorldInfo.IsInSeamlessTravel())
	{
		WorldInfo.SetSeamlessTravelMidpointPause(true);
		SetTimer(7.0000000, false, 'ContinueSeamlessTravel');
	}
	//return;	
}

function ContinueSeamlessTravel()
{
	WorldInfo.SetSeamlessTravelMidpointPause(false);
	//return;	
}

static function string GetEndOfMatchRules(int InGoalScore, int InTimeLimit)
{
	local string Work;

	// End:0x3F
	if(InGoalScore > 0)
	{
		Work = ((InGoalScore == 1) ? default.EndOfMatchRulesTemplateStr_ScoringSingle : default.EndOfMatchRulesTemplateStr_Scoring);		
	}
	else
	{
		Work = default.EndOfMatchRulesTemplateStr_Time;
	}
	Work = Repl(Work, "`g", string(InGoalScore));
	Work = Repl(Work, "`t", string(InTimeLimit));
	return Work;
	//return ReturnValue;	
}

function bool GetLocationFor(Pawn StatusPawn, out Actor LocationObject, out int MessageIndex, int LocationSpeechOffset)
{
	local UTPickupFactory F;
	local UTGameObjective Best, O;
	local float NewDistSq, BestDistSq;
	local UTBot B;

	B = UTBot(StatusPawn.Controller);
	// End:0x230
	if(B != none)
	{
		O = ((B.Squad != none) ? UTGameObjective(B.Squad.SquadObjective) : UTGameObjective(B.SquadRouteGoal));
		// End:0x113
		if(O == none)
		{
			O = UTGameObjective(B.RouteGoal);
		}
		// End:0x197
		if(O != none)
		{
			// End:0x194
			if(O.bHasLocationSpeech)
			{
				MessageIndex = O.GetLocationMessageIndex(B, StatusPawn);
				LocationObject = O;
				return true;
			}			
		}
		else
		{
			F = UTPickupFactory(StatusPawn.Controller.RouteGoal);
			// End:0x230
			if((F != none) && F.bHasLocationSpeech)
			{
				MessageIndex = 0;
				LocationObject = F;
				return true;
			}
		}
	}
	// End:0x34F
	foreach WorldInfo.AllNavigationPoints(Class'UTGame.UTGameObjective', O)
	{
		// End:0x34E
		if(O.bHasLocationSpeech)
		{
			// End:0x2B6
			if(LocationSpeechOffset >= O.LocationSpeech.Length)
			{				
				return false;
			}
			NewDistSq = VSizeSq(StatusPawn.Location - O.Location);
			// End:0x34E
			if((Best == none) || NewDistSq < BestDistSq)
			{
				Best = O;
				BestDistSq = NewDistSq;
			}
		}		
	}	
	// End:0x3AF
	if(Best != none)
	{
		MessageIndex = Best.GetLocationMessageIndex(B, StatusPawn);
		LocationObject = Best;
		return true;
	}
	MessageIndex = 10;
	return true;
	//return ReturnValue;	
}

function bool AllowCheats(PlayerController P)
{
	return int(WorldInfo.NetMode) == int(NM_Standalone);
	//return ReturnValue;	
}

function UpdateGameSettings()
{
	local string MapName, GameTypeName;
	local OnlineGameSettings GameSettings;

	// End:0x68
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
	}
	// End:0x1D3
	if((GameSettings != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		MapName = WorldInfo.GetMapName(true);
		GameTypeName = PathName(WorldInfo.GetGameClass());
		GameSettings.SetPropertyFromStringByName('CustomMapName', MapName);
		GameSettings.SetPropertyFromStringByName('CustomGameMode', GameTypeName);
		GameSettings.SetStringSettingValue(7, ((RequiresPassword()) ? 1 : 0), false);
		GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, GameSettings);
	}
	//return;	
}

function WriteOnlineStats()
{
	local OnlineGameSettings CurSettings;
	local PlayerController PC;

	// End:0x68
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		CurSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
	}
	// End:0xFC
	if((CurSettings == none) || !CurSettings.bUsesStats)
	{
		// End:0xFB
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);			
		}		
	}
	super(GameInfo).WriteOnlineStats();
	//return;	
}

function ClearOnlineDelegates()
{
	// End:0xDB
	if(OnlineSub != none)
	{
		// End:0x8A
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
		{
			OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
		}
		// End:0xDB
		if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
		{
			GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
		}
	}
	//return;	
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
	local OnlineGameSettings CurSettings;

	// End:0x1BC
	if(((int(ConnectionStatus) != int(1)) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none))) && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		CurSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		// End:0x1BC
		if((CurSettings != none) && int(CurSettings.GameState) != int(0))
		{
			// End:0x14D
			if(int(CurSettings.GameState) != int(3))
			{
				GameInterface.DestroyOnlineGame(PlayerReplicationInfoClass.default.SessionName);				
			}
			else
			{
				GameInterface.AddEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
				GameInterface.EndOnlineGame(PlayerReplicationInfoClass.default.SessionName);
			}
		}
	}
	//return;	
}

function OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	GameInterface.DestroyOnlineGame(PlayerReplicationInfoClass.default.SessionName);
	GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
	//return;	
}

auto state PendingMatch
{
	ignores ScoreFlag, ScoreKill, CheckScore, CheckLives;

	function RestartPlayer(Controller aPlayer)
	{
		// End:0x3E
		if(UTGameReplicationInfo(GameReplicationInfo).bWarmupRound)
		{
			global.RestartPlayer(aPlayer);
		}
		//return;		
	}

	function Timer()
	{
		local PlayerController P;
		local bool bReady;
		local UTBot B;

		global.Timer();
		// End:0xA4
		if(NumPlayers == 0)
		{
			bShouldWaitForNetPlayers = bWaitForNetPlayers && int(WorldInfo.NetMode) != int(NM_Standalone);
			// End:0xA1
			if(bWarmupRound)
			{
				WarmupRemaining = WarmupTime;
				GameReplicationInfo.RemainingTime = WarmupRemaining;
			}			
		}
		else
		{
			// End:0x107
			foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
			{
				// End:0x106
				if(TooManyBots(B))
				{
					B.Destroy();
				}				
			}			
			AddInitialBots();
			// End:0x1F3
			if(bWarmupRound)
			{
				// End:0x1A1
				if(WarmupRemaining > 0)
				{
					WarmupRemaining--;
					GameReplicationInfo.RemainingTime = WarmupRemaining;
					// End:0x19C
					if((WarmupRemaining % 60) == 0)
					{
						GameReplicationInfo.RemainingMinute = WarmupRemaining;
					}
					return;					
				}
				else
				{
					// End:0x1F3
					if(WarmupRemaining == 0)
					{
						WarmupRemaining = -1;
						UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
						ResetLevel();
					}
				}
			}
		}
		// End:0x29F
		if(bShouldWaitForNetPlayers)
		{
			// End:0x236
			if((NumPlayers >= MinNetPlayers) && NumPlayers > 0)
			{
				PendingMatchElapsedTime++;				
			}
			else
			{
				PendingMatchElapsedTime = 0;
			}
			// End:0x293
			if((NumPlayers == MaxPlayers) || PendingMatchElapsedTime > NetWait)
			{
				bShouldWaitForNetPlayers = false;
				CountDown = default.CountDown;				
			}
			else
			{
				PlayStartupMessage();
				return;
			}
		}
		bReady = true;
		StartupStage = 1;
		// End:0x3FE
		if(!bStartedCountDown && bPlayersMustBeReady || int(WorldInfo.NetMode) == int(NM_Standalone))
		{
			// End:0x3FD
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
			{
				// End:0x3FC
				if((((P.PlayerReplicationInfo != none) && P.bIsPlayer) && P.PlayerReplicationInfo.bWaitingPlayer) && !P.PlayerReplicationInfo.bReadyToPlay)
				{
					bReady = false;
				}				
			}			
		}
		// End:0x4A8
		if(bReady)
		{
			// End:0x466
			if(!bStartedCountDown)
			{
				// End:0x45A
				if(DemoPrefix != "")
				{					
					ConsoleCommand(("demorec" @ DemoPrefix) $ "-%td");
				}
				bStartedCountDown = true;
			}
			CountDown--;
			// End:0x48D
			if(CountDown <= 0)
			{
				StartMatch();				
			}
			else
			{
				StartupStage = byte(int(5) - CountDown);
			}
		}
		PlayStartupMessage();
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		// End:0x5D
		if(bWarmupRound)
		{
			GameReplicationInfo.RemainingTime = WarmupRemaining;
			GameReplicationInfo.RemainingMinute = WarmupRemaining;
		}
		bWaitingToStartMatch = true;
		UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = bWarmupRound;
		StartupStage = 0;
		//return;		
	}

	function EndState(name NextStateName)
	{
		UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
		//return;		
	}
Begin:

	// End:0x77
	if((int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_ListenServer)) && !IsConsoleDedicatedServer())
	{
		Sleep(0.0000000);
		AddInitialBots();
	}
	// End:0xBD
	if((DesiredPlayerCount <= 1) && int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		bQuickStart = true;
	}
	// End:0x114
	if(bQuickStart)
	{
		// End:0x10A
		if(DemoPrefix != "")
		{			
			ConsoleCommand(("demorec" @ DemoPrefix) $ "-%td");
		}
		StartMatch();
	}
	stop;				
}

state MatchInProgress
{
	function bool MatchIsInProgress()
	{
		return true;
		//return ReturnValue;		
	}

	function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
	{
		local bool bSuccess;
		local UTPlayerController UTPC;

		bSuccess = global.ChangeTeam(Other, Num, bNewTeam);
		UTPC = UTPlayerController(Other);
		// End:0x70
		if(UTPC != none)
		{
			SetupPlayerMuteList(UTPC, false);
		}
		return bSuccess;
		//return ReturnValue;		
	}

	function Timer()
	{
		local PlayerController P;

		global.Timer();
		// End:0x2F
		if(!bFinalStartup)
		{
			bFinalStartup = true;
			PlayStartupMessage();
		}
		// End:0x120
		if(ForceRespawn())
		{
			// End:0x11F
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
			{
				// End:0x11E
				if(((P.Pawn == none) && !P.PlayerReplicationInfo.bOnlySpectator) && !P.IsTimerActive('DoForcedRespawn'))
				{
					P.ServerRestartPlayer();
				}				
			}			
		}
		// End:0x13A
		if(NeedPlayers())
		{
			AddBot();
		}
		// End:0x160
		if(bOverTime)
		{
			EndGame(none, "TimeLimit");			
		}
		else
		{
			// End:0x1CD
			if(TimeLimit > 0)
			{
				GameReplicationInfo.bStopCountDown = false;
				// End:0x1CA
				if(GameReplicationInfo.RemainingTime <= 0)
				{
					EndGame(none, "TimeLimit");
				}				
			}
			else
			{
				// End:0x203
				if((MaxLives > 0) && (NumPlayers + NumBots) != 1)
				{
					CheckMaxLives(none);
				}
			}
		}
		//return;		
	}

	function BeginState(name PreviousStateName)
	{
		local PlayerReplicationInfo PRI;

		// End:0xA0
		if(PreviousStateName != 'RoundOver')
		{
			// End:0x51
			foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
			{
				PRI.StartTime = 0;				
			}			
			GameReplicationInfo.ElapsedTime = 0;
			bWaitingToStartMatch = false;
			StartupStage = 5;
			PlayStartupMessage();
			StartupStage = 6;
		}
		//return;		
	}
	stop;	
}

state MatchOver
{
	ignores ScoreKill, RestartPlayer;

	function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
	{
		Damage = 0;
		Momentum = vect(0.0000000, 0.0000000, 0.0000000);
		//return;		
	}

	function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
	{
		Other.PlayerReplicationInfo.bOutOfLives = true;
		return true;
		//return ReturnValue;		
	}

	event PostLogin(PlayerController NewPlayer)
	{
		global.PostLogin(NewPlayer);
		NewPlayer.GameHasEnded(EndGameFocus);
		//return;		
	}

	function Timer()
	{
		local PlayerController PC;
		local Sequence GameSequence;
		local array<SequenceObject> AllInterpActions;
		local SeqAct_Interp InterpAction;
		local int I, J;
		local bool bIsInCinematic;

		global.Timer();
		// End:0x5E
		if(!bGameRestarted && WorldInfo.TimeSeconds > (EndTime + float(RestartWait)))
		{
			RestartGame();
		}
		// End:0x2CF
		if(EndGameFocus != none)
		{
			EndGameFocus.bAlwaysRelevant = true;
			GameSequence = WorldInfo.GetGameSequence();
			// End:0x261
			if(GameSequence != none)
			{
				GameSequence.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
				I = 0;
				J0x103:

				// End:0x261 [Loop If]
				if((I < AllInterpActions.Length) && !bIsInCinematic)
				{
					InterpAction = SeqAct_Interp(AllInterpActions[I]);
					// End:0x253
					if((InterpAction.InterpData != none) && InterpAction.GroupInst.Length > 0)
					{
						J = 0;
						J0x1A8:

						// End:0x253 [Loop If]
						if(J < InterpAction.InterpData.InterpGroups.Length)
						{
							// End:0x245
							if(InterpGroupDirector(InterpAction.InterpData.InterpGroups[J]) != none)
							{
								bIsInCinematic = true;
								// [Explicit Break]
								goto J0x253;
							}
							J++;
							// [Loop Continue]
							goto J0x1A8;
						}
					}
					J0x253:

					I++;
					// [Loop Continue]
					goto J0x103;
				}
			}
			// End:0x2CF
			if(!bIsInCinematic)
			{
				// End:0x2CE
				foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
				{
					PC.ClientSetViewTarget(EndGameFocus);					
				}				
			}
		}
		EndMessageCounter++;
		// End:0x2FB
		if(EndMessageCounter == EndMessageWait)
		{
			PlayEndOfMatchMessage();
		}
		//return;		
	}

	function bool NeedPlayers()
	{
		return false;
		//return ReturnValue;		
	}

	function BeginState(name PreviousStateName)
	{
		local Pawn P;

		ResetAllPlayerMuteListsToSpectatorChannel();
		GameReplicationInfo.bStopCountDown = true;
		// End:0x81
		foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
		{
			P.TurnOff();			
		}		
		//return;		
	}

	function ResetLevel()
	{
		RestartGame();
		//return;		
	}
	stop;	
}

state RoundOver extends MatchOver
{
	event BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		ResetCountDown = Max(2, ResetTimeDelay);
		//return;		
	}

	function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
	{
		return global.ChangeTeam(Other, Num, bNewTeam);
		//return ReturnValue;		
	}

	function ResetLevel()
	{
		GotoState('None');
		global.ResetLevel();
		GotoState('MatchInProgress');
		ResetCountDown = 0;
		//return;		
	}

	event Timer()
	{
		global.Timer();
		ResetCountDown--;
		// End:0x2E
		if(ResetCountDown == 1)
		{
			ResetLevel();
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bExportMenuData=true
	bWeaponStay=true
	bWaitForNetPlayers=true
	bAllowKeyboardAndMouse=true
	Acronym="???"
	EndTimeDelay=4.0000000
	BotRatio=1.0000000
	NetWait=15
	ClientProcessingTimeout=30
	MinNetPlayers=1
	RestartWait=30
	SpawnProtectionTime=2.0000000
	LateEntryLives=1
	CountDown=4
	EndMessageWait=1
	DefaultInventory[0]=Class'UTGame.UTWeap_LinkGun'
	VictoryMessageClass=Class'UTGame.UTVictoryMessage'
	ConsolePlayerControllerClass=Class'UTGame.UTConsolePlayerController'
	BotClass=Class'UTGame.UTBot'
	GameSpecificMapCycles[0]=(GameClassName="UTVehicleCTFGame_Content",Maps=("VCTF-Necropolis","VCTF-SandStorm"))
	SpeechRecognitionData=SpeechRecognition'SpeechRecognition.Alphabet'
	LastEncouragementTime=-20.0000000
	MidgameScorePanelTag="DMPanel"
	SpreeStatEvents[0]="SPREE_KILLINGSPREE"
	SpreeStatEvents[1]="SPREE_RAMPAGE"
	SpreeStatEvents[2]="SPREE_DOMINATING"
	SpreeStatEvents[3]="SPREE_UNSTOPPABLE"
	SpreeStatEvents[4]="SPREE_GODLIKE"
	SpreeStatEvents[5]="SPREE_MASSACRE"
	bPauseable=false
	bDelayedStart=true
	bUseSeamlessTravel=true
	bRequiresPushToTalk=true
	DefaultPawnClass=Class'UTGame.UTPawn'
	HUDType=Class'UTGame.UTHUD'
	MaxPlayersAllowed=64
	GoalScore=25
	TimeLimit=20
	DeathMessageClass=Class'UTGame.UTDeathMessage'
	PlayerControllerClass=Class'UTGame.UTPlayerController'
	PlayerReplicationInfoClass=Class'UTGame.UTPlayerReplicationInfo'
	GameReplicationInfoClass=Class'UTGame.UTGameReplicationInfo'
	PopulationManagerClass=Class'UTGame.UTPopulationManager'
}