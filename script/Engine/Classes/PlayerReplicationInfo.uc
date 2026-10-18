class PlayerReplicationInfo extends ReplicationInfo
	native
	nativereplication
	notplaceable;

struct native AutomatedTestingDatum
{
	var int NumberOfMatchesPlayed;
	var int NumMapListCyclesDone;

	structdefaultproperties
	{
		NumberOfMatchesPlayed=0
		NumMapListCyclesDone=0
	}
};

var repnotify float Score;
var int Deaths;
var byte Ping;
var transient AudioDevice.ETTSSpeaker TTSSpeaker;
var int NumLives;
var repnotify string PlayerName;
var string OldName;
var int PlayerID;
var repnotify editinline TeamInfo Team;
var bool bAdmin;
var bool bIsSpectator;
var bool bOnlySpectator;
var bool bWaitingPlayer;
var bool bReadyToPlay;
var bool bOutOfLives;
var bool bBot;
var bool bHasBeenWelcomed;
var repnotify bool bIsInactive;
var bool bFromPreviousLevel;
var int StartTime;
var const localized string StringSpectating;
var const localized string StringUnknown;
var int Kills;
var Class<GameMessage> GameMessageClass;
var float ExactPing;
var string SavedNetworkAddress;
var repnotify UniqueNetId UniqueId;
var const name SessionName;
var AutomatedTestingDatum AutomatedTestingData;
var int StatConnectionCounts;
var int StatPingTotals;
var int StatPingMin;
var int StatPingMax;
var int StatPKLTotal;
var int StatPKLMin;
var int StatPKLMax;
var int StatMaxInBPS;
var int StatAvgInBPS;
var int StatMaxOutBPS;
var int StatAvgOutBPS;
var transient Texture2D Avatar;

replication
{
	// Pos:0x000
	if(bNetDirty)
		Deaths, PlayerName, 
		Score, StartTime, 
		Team, UniqueId, 
		bAdmin, bFromPreviousLevel, 
		bIsSpectator, bOnlySpectator, 
		bOutOfLives, bReadyToPlay, 
		bWaitingPlayer;

	// Pos:0x00A
	if(bNetDirty && bNetOwner!)
		Ping;

	// Pos:0x025
	if(bNetInitial)
		PlayerID, bBot, 
		bIsInactive;
}

simulated event PostBeginPlay()
{
	// End:0x59
	if(WorldInfo.GRI != none)
	{
		WorldInfo.GRI.AddPRI(self);
	}
	// End:0x6F
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	// End:0x93
	if(AIController(Owner) != none)
	{
		bBot = true;
	}
	StartTime = WorldInfo.GRI.ElapsedTime;
	//return;	
}

simulated function ClientInitialize(Controller C)
{
	local Actor A;
	local PlayerController PlayerOwner;

	SetOwner(C);
	PlayerOwner = PlayerController(C);
	// End:0x88
	if(PlayerOwner != none)
	{
		// End:0x88
		if(Team != default.Team)
		{
			// End:0x87
			foreach AllActors(Class'Engine.Actor', A)
			{
				A.NotifyLocalPlayerTeamReceived();				
			}			
		}
	}
	//return;	
}

function SetPlayerTeam(TeamInfo NewTeam)
{
	bForceNetUpdate = Team != NewTeam;
	Team = NewTeam;
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	local Pawn P;
	local PlayerController PC;
	local int WelcomeMessageNum;
	local Actor A;
	local UniqueNetId ZeroId;

	// End:0xFD
	if(VarName == 'Team')
	{
		// End:0x77
		foreach DynamicActors(Class'Engine.Pawn', P)
		{
			// End:0x76
			if(P.PlayerReplicationInfo == self)
			{
				P.NotifyTeamChanged();
				// End:0x77
				break;
			}			
		}		
		// End:0xF9
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0xF8
			if(PC.PlayerReplicationInfo == self)
			{
				// End:0xF4
				foreach AllActors(Class'Engine.Actor', A)
				{
					A.NotifyLocalPlayerTeamReceived();					
				}				
				// End:0xF9
				break;
			}			
		}				
	}
	else
	{
		// End:0x283
		if(VarName == 'PlayerName')
		{
			// End:0x123
			if(IsInvalidName())
			{
				return;
			}
			// End:0x16B
			if(WorldInfo.TimeSeconds < float(2))
			{
				bHasBeenWelcomed = true;
				OldName = PlayerName;
				return;
			}
			// End:0x1D7
			if(bHasBeenWelcomed)
			{
				// End:0x1D4
				if(ShouldBroadCastWelcomeMessage())
				{
					// End:0x1D3
					foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
					{
						PC.ReceiveLocalizedMessage(GameMessageClass, 2, self);						
					}					
				}				
			}
			else
			{
				// End:0x1F3
				if(bOnlySpectator)
				{
					WelcomeMessageNum = 16;					
				}
				else
				{
					WelcomeMessageNum = 1;
				}
				bHasBeenWelcomed = true;
				// End:0x26D
				if(ShouldBroadCastWelcomeMessage())
				{
					// End:0x26C
					foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
					{
						PC.ReceiveLocalizedMessage(GameMessageClass, WelcomeMessageNum, self);						
					}					
				}
			}
			OldName = PlayerName;			
		}
		else
		{
			// End:0x2C5
			if(VarName == 'UniqueId')
			{
				// End:0x2C2
				if(UniqueId != ZeroId)
				{
					RegisterPlayerWithSession();
				}				
			}
			else
			{
				// End:0x346
				if(VarName == 'bIsInactive')
				{
					WorldInfo.GRI.RemovePRI(self);
					WorldInfo.GRI.AddPRI(self);
				}
			}
		}
	}
	//return;	
}

// Export UPlayerReplicationInfo::execUpdatePing(FFrame&, void* const)
native final function UpdatePing(float TimeStamp);

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
	return bIsInactive! && int(WorldInfo.NetMode) != int(NM_Standalone);
	//return ReturnValue;	
}

simulated event Destroyed()
{
	local PlayerController PC;
	local UniqueNetId ZeroId;

	// End:0x59
	if(WorldInfo.GRI != none)
	{
		WorldInfo.GRI.RemovePRI(self);
	}
	// End:0xB5
	if(ShouldBroadCastWelcomeMessage(true))
	{
		// End:0xB4
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			PC.ReceiveLocalizedMessage(GameMessageClass, 4, self);			
		}		
	}
	// End:0xDD
	if(UniqueId != ZeroId)
	{
		UnregisterPlayerFromSession();
	}
	super(Actor).Destroyed();
	//return;	
}

function Reset()
{
	super(Actor).Reset();
	Score = 0.0000000;
	Kills = 0;
	Deaths = 0;
	bReadyToPlay = false;
	NumLives = 0;
	bOutOfLives = false;
	bForceNetUpdate = true;
	//return;	
}

simulated function string GetHumanReadableName()
{
	return PlayerName;
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
	local float XS, YS;

	// End:0x4D
	if(Team == none)
	{
		HUD.Canvas.SetDrawColor(255, 255, 0);		
	}
	else
	{
		// End:0xAF
		if(Team.TeamIndex == 0)
		{
			HUD.Canvas.SetDrawColor(255, 0, 0);			
		}
		else
		{
			HUD.Canvas.SetDrawColor(64, 64, 255);
		}
	}
	HUD.Canvas.SetPos(4.0000000, YPos);
	HUD.Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
	HUD.Canvas.StrLen(PlayerName, XS, YS);
	HUD.Canvas.DrawText(PlayerName);
	HUD.Canvas.SetPos(4.0000000 + XS, YPos);
	HUD.Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
	HUD.Canvas.SetDrawColor(255, 255, 0);
	YPos += YS;
	HUD.Canvas.SetPos(4.0000000, YPos);
	// End:0x52C
	if((PlayerController(Owner) != none) && PlayerController(HUD.Owner).ViewTarget != PlayerController(HUD.Owner).Pawn)
	{
		HUD.Canvas.SetDrawColor(128, 128, 255);
		HUD.Canvas.DrawText((((((((("      bIsSpec:" @ string(bIsSpectator)) @ "OnlySpec:") $ string(bOnlySpectator)) @ "Waiting:") $ string(bWaitingPlayer)) @ "Ready:") $ string(bReadyToPlay)) @ "OutOfLives:") $ string(bOutOfLives));
		YPos += YL;
		HUD.Canvas.SetPos(4.0000000, YPos);
	}
	//return;	
}

event SetPlayerName(string S)
{
	PlayerName = S;
	// End:0x7A
	if((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer))
	{
		ReplicatedEvent('PlayerName');
	}
	OldName = PlayerName;
	bForceNetUpdate = true;
	//return;	
}

function SetWaitingPlayer(bool B)
{
	bIsSpectator = B;
	bWaitingPlayer = B;
	bForceNetUpdate = true;
	//return;	
}

function PlayerReplicationInfo Duplicate()
{
	local PlayerReplicationInfo NewPRI;

	NewPRI = Spawn(Class);
	CopyProperties(NewPRI);
	return NewPRI;
	//return ReturnValue;	
}

function OverrideWith(PlayerReplicationInfo PRI)
{
	bIsSpectator = PRI.bIsSpectator;
	bOnlySpectator = PRI.bOnlySpectator;
	bWaitingPlayer = PRI.bWaitingPlayer;
	bReadyToPlay = PRI.bReadyToPlay;
	bOutOfLives = PRI.bOutOfLives || bOutOfLives;
	Team = PRI.Team;
	//return;	
}

function CopyProperties(PlayerReplicationInfo PRI)
{
	PRI.Score = Score;
	PRI.Deaths = Deaths;
	PRI.Ping = Ping;
	PRI.NumLives = NumLives;
	PRI.PlayerName = PlayerName;
	PRI.PlayerID = PlayerID;
	PRI.StartTime = StartTime;
	PRI.Kills = Kills;
	PRI.bOutOfLives = bOutOfLives;
	PRI.SavedNetworkAddress = SavedNetworkAddress;
	PRI.Team = Team;
	PRI.UniqueId = UniqueId;
	PRI.AutomatedTestingData = AutomatedTestingData;
	//return;	
}

function IncrementDeaths(optional int Amt = 1)
{
	Deaths += Amt;
	//return;	
}

function SeamlessTravelTo(PlayerReplicationInfo NewPRI)
{
	CopyProperties(NewPRI);
	NewPRI.bOnlySpectator = bOnlySpectator;
	//return;	
}

simulated function SetUniqueId(UniqueNetId PlayerUniqueId)
{
	UniqueId = PlayerUniqueId;
	//return;	
}

// Export UPlayerReplicationInfo::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function bool IsInvalidName()
{
	local LocalPlayer LocPlayer;
	local PlayerController PC;
	local string ProfileName;
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x211
	if(OnlineSub != none)
	{
		PC = PlayerController(Owner);
		// End:0x211
		if(PC != none)
		{
			LocPlayer = LocalPlayer(PC.Player);
			// End:0x211
			if(((LocPlayer != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
			{
				// End:0x211
				if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) == int(2))
				{
					ProfileName = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
					// End:0x211
					if(ProfileName != PlayerName)
					{
						PC.SetName(ProfileName);
						return true;
					}
				}
			}
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function RegisterPlayerWithSession()
{
	local OnlineSubsystem Online;
	local OnlineRecentPlayersList PlayersList;
	local UniqueNetId ZeroId;

	Online = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x1B7
	if((((UniqueId != ZeroId && Online != none) && NotEqual_InterfaceInterface(Online.GameInterface, OnlineGameInterface(none))) && SessionName != 'None') && Online.GameInterface.GetGameSettings(SessionName) != none)
	{
		Online.GameInterface.RegisterPlayer(SessionName, UniqueId, false);
		// End:0x1B7
		if(bNetOwner!)
		{
			PlayersList = OnlineRecentPlayersList(Online.GetNamedInterface('RecentPlayersList'));
			// End:0x1B7
			if(PlayersList != none)
			{
				PlayersList.AddPlayerToRecentPlayers(UniqueId);
			}
		}
	}
	//return;	
}

simulated function UnregisterPlayerFromSession()
{
	local OnlineSubsystem OnlineSub;
	local UniqueNetId ZeroId;

	// End:0x1D5
	if((UniqueId != ZeroId && int(WorldInfo.NetMode) == int(NM_Client)) && SessionName != 'None')
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x1D5
		if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && OnlineSub.GameInterface.GetGameSettings(SessionName) != none) && WorldInfo.PeerHostMigration.bHostMigrationEnabled && int(WorldInfo.PeerHostMigration.HostMigrationProgress) != int(0)!)
		{
			OnlineSub.GameInterface.UnregisterPlayer(SessionName, UniqueId);
		}
	}
	//return;	
}

simulated function bool IsPrimaryPlayer()
{
	return true;
	//return ReturnValue;	
}

defaultproperties
{
	StringSpectating="Spectating"
	StringUnknown="Unknown"
	GameMessageClass=Class'Engine.GameMessage'
	SessionName="Game"
	TickGroup=ETickingGroup.TG_DuringAsyncWork
	NetUpdateFrequency=1.0000000
}