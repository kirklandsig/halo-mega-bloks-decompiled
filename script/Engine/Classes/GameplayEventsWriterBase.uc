class GameplayEventsWriterBase extends GameplayEvents
	native;

const GAMEEVENT_MATCH_STARTED = 0;
const GAMEEVENT_MATCH_ENDED = 1;
const GAMEEVENT_ROUND_STARTED = 2;
const GAMEEVENT_ROUND_ENDED = 3;
const GAMEEVENT_GAME_CLASS = 6;
const GAMEEVENT_GAME_OPTION_URL = 7;
const GAMEEVENT_GAME_MAPNAME = 8;
const GAMEEVENT_MEMORYUSAGE_POLL = 35;
const GAMEEVENT_FRAMERATE_POLL = 36;
const GAMEEVENT_NETWORKUSAGEIN_POLL = 37;
const GAMEEVENT_NETWORKUSAGEOUT_POLL = 38;
const GAMEEVENT_PING_POLL = 39;
const GAMEEVENT_RENDERTHREAD_POLL = 40;
const GAMEEVENT_GAMETHREAD_POLL = 41;
const GAMEEVENT_GPUFRAMETIME_POLL = 42;
const GAMEEVENT_FRAMETIME_POLL = 43;
const GAMEEVENT_TEAM_CREATED = 50;
const GAMEEVENT_TEAM_GAME_SCORE = 51;
const GAMEEVENT_TEAM_MATCH_WON = 4;
const GAMEEVENT_TEAM_ROUND_WON = 5;
const GAMEEVENT_TEAM_ROUND_STALEMATE = 52;
const GAMEEVENT_PLAYER_LOGIN = 100;
const GAMEEVENT_PLAYER_LOGOUT = 101;
const GAMEEVENT_PLAYER_SPAWN = 102;
const GAMEEVENT_PLAYER_MATCH_WON = 103;
const GAMEEVENT_PLAYER_KILL = 104;
const GAMEEVENT_PLAYER_LOCATION_POLL = 105;
const GAMEEVENT_PLAYER_TEAMCHANGE = 106;
const GAMEEVENT_PLAYER_KILL_STREAK = 107;
const GAMEEVENT_PLAYER_DEATH = 108;
const GAMEEVENT_PLAYER_ROUND_WON = 109;
const GAMEEVENT_PLAYER_ROUND_STALEMATE = 110;
const GAMEEVENT_WEAPON_DAMAGE = 150;
const GAMEEVENT_WEAPON_DAMAGE_MELEE = 151;
const GAMEEVENT_WEAPON_FIRED = 152;
const GAMEEVENT_PLAYER_KILL_NORMAL = 200;
const GAMEEVENT_GENERIC_PARAM_LIST_START = 300;
const GAMEEVENT_GENERIC_PARAM_LIST_END = 400;
const GAMEEVENT_GAME_SPECIFIC = 1000;
const GAMEEVENT_MAX_EVENTID = 0x0000FFFF;

var const GameInfo Game;

function bool IsSessionInProgress()
{
	return CurrentSessionInfo.bGameplaySessionInProgress;
	//return ReturnValue;	
}

event StartPolling(float HearbeatDelta)
{
	local WorldInfo WI;

	WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x9F
	if((WI != none) && WI.Game != none)
	{
		WI.Game.SetTimer(HearbeatDelta, true, 'Poll', self);
	}
	//return;	
}

event StopPolling()
{
	local WorldInfo WI;

	WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x9C
	if((WI != none) && WI.Game != none)
	{
		WI.Game.ClearTimer('Poll', self);
	}
	//return;	
}

function Poll()
{
	local WorldInfo WI;

	WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0xF6
	if(WI.Pauser == none)
	{
		// End:0xEC
		if((WI.Game != none) && !WI.Game.bWaitingToStartMatch)
		{
			LogAllPlayerPositionsEvent(105);
			WI.Game.GameEventsPoll();
		}
		LogSystemPollEvents();
	}
	//return;	
}

event int GetGameTypeId()
{
	return 0;
	//return ReturnValue;	
}

event int GetPlaylistId()
{
	return -1;
	//return ReturnValue;	
}

function StartLogging(optional float HeartbeatDelta)
{
	//return;	
}

function ResetLogging(optional float HeartbeatDelta)
{
	//return;	
}

function EndLogging()
{
	//return;	
}

function LogGameIntEvent(int EventID, int Value)
{
	//return;	
}

function LogGameStringEvent(int EventID, string Value)
{
	//return;	
}

function LogGameFloatEvent(int EventID, float Value)
{
	//return;	
}

function LogGamePositionEvent(int EventID, const out Vector Position, float Value)
{
	//return;	
}

function LogTeamIntEvent(int EventID, TeamInfo Team, int Value)
{
	//return;	
}

function LogTeamFloatEvent(int EventID, TeamInfo Team, float Value)
{
	//return;	
}

function LogTeamStringEvent(int EventID, TeamInfo Team, string Value)
{
	//return;	
}

function LogPlayerIntEvent(int EventID, Controller Player, int Value)
{
	//return;	
}

function LogPlayerFloatEvent(int EventID, Controller Player, float Value)
{
	//return;	
}

function LogPlayerStringEvent(int EventID, Controller Player, string EventString)
{
	//return;	
}

function LogPlayerSpawnEvent(int EventID, Controller Player, Class<Pawn> PawnClass, int TeamID)
{
	//return;	
}

function LogPlayerLoginChange(int EventID, Controller Player, string PlayerName, UniqueNetId PlayerID, bool bSplitScreen)
{
	//return;	
}

function LogAllPlayerPositionsEvent(int EventID)
{
	//return;	
}

function LogPlayerKillDeath(int EventID, int KillType, Controller Killer, Class<DamageType> dmgType, Controller Dead)
{
	//return;	
}

function LogPlayerPlayerEvent(int EventID, Controller Player, Controller Target)
{
	//return;	
}

function LogWeaponIntEvent(int EventID, Controller Player, Class<Weapon> WeaponClass, int Value)
{
	//return;	
}

function LogDamageEvent(int EventID, Controller Player, Class<DamageType> dmgType, Controller Target, int Amount)
{
	//return;	
}

function LogProjectileIntEvent(int EventID, Controller Player, Class<Projectile> Proj, int Value)
{
	//return;	
}

function LogSystemPollEvents()
{
	//return;	
}

function RecordAIPathFail(Controller AI, coerce string Reason, Vector Dest)
{
	//return;	
}

function int RecordCoverLinkFireLinks(CoverLink Link, Controller Player)
{
	//return ReturnValue;	
}
