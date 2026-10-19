class PlayerController extends Controller
	native
	nativereplication
	config(Game)
	notplaceable
	dependson(OnlineSubsystem, OnlineGameSearch, SeqAct_ControlMovieTexture);

const MAXPOSITIONERRORSQUARED = 3.0;
const MAXNEARZEROVELOCITYSQUARED = 9.0;
const MAXVEHICLEPOSITIONERRORSQUARED = 900.0;
const CLIENTADJUSTUPDATECOST = 180.0;
const MAXCLIENTUPDATEINTERVAL = 0.25;

enum EInputTypes
{
	IT_XAxis,                       // 0
	IT_YAxis,                       // 1
	IT_MAX                          // 2
};

enum EInputMatchAction
{
	IMA_GreaterThan,                // 0
	IMA_LessThan,                   // 1
	IMA_MAX                         // 2
};

enum EProgressMessageType
{
	PMT_Clear,                      // 0
	PMT_Information,                // 1
	PMT_AdminMessage,               // 2
	PMT_DownloadProgress,           // 3
	PMT_ConnectionFailure,          // 4
	PMT_PeerConnectionFailure,      // 5
	PMT_PeerHostMigrationFailure,   // 6
	PMT_SocketFailure,              // 7
	PMT_MAX                         // 8
};

struct native ClientAdjustment
{
	var float TimeStamp;
	var Actor.EPhysics newPhysics;
	var Vector NewLoc;
	var Vector NewVel;
	var Actor NewBase;
	var Vector NewFloor;
	var byte bAckGoodMove;

	structdefaultproperties
	{
		TimeStamp=0.0000000
		newPhysics=PHYS_None
		NewLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		NewVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		NewBase=none
		NewFloor=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		bAckGoodMove=0
	}
};

struct native ConnectedPeerInfo
{
	var UniqueNetId PlayerID;
	var OnlineSubsystem.ENATType NatType;
	var bool bLostConnectionToHost;

	structdefaultproperties
	{
		PlayerID=(Uid=())
		NatType=NAT_Unknown
		bLostConnectionToHost=false
	}
};

struct native InputEntry
{
	var PlayerController.EInputTypes Type;
	var float Value;
	var float TimeDelta;
	var PlayerController.EInputMatchAction Action;

	structdefaultproperties
	{
		Type=IT_XAxis
		Value=0.0000000
		TimeDelta=0.0000000
		Action=IMA_GreaterThan
	}
};

struct native InputMatchRequest
{
	var array<InputEntry> Inputs;
	var Actor MatchActor;
	var name MatchFuncName;
	var delegate<InputMatchDelegate> MatchDelegate;
	var name FailedFuncName;
	var name RequestName;
	var transient int MatchIdx;
	var transient float LastMatchTime;

	structdefaultproperties
	{
		Inputs=none
		MatchActor=none
		MatchFuncName="None"
		MatchDelegate=None
		FailedFuncName="None"
		RequestName="None"
		MatchIdx=0
		LastMatchTime=0.0000000
	}
};

struct native DebugTextInfo
{
	var Actor SrcActor;
	var Vector SrcActorOffset;
	var Vector SrcActorDesiredOffset;
	var string DebugText;
	var transient float TimeRemaining;
	var float Duration;
	var Color TextColor;
	var bool bAbsoluteLocation;
	var bool bKeepAttachedToActor;
	var Vector OrigActorLocation;
	var Font Font;

	structdefaultproperties
	{
		SrcActor=none
		SrcActorOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		SrcActorDesiredOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		DebugText=""
		TimeRemaining=0.0000000
		Duration=0.0000000
		TextColor=(R=0,G=0,B=0,A=0)
		bAbsoluteLocation=false
		bKeepAttachedToActor=false
		OrigActorLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Font=none
	}
};

var const Player Player;
var editinline Camera PlayerCamera;
var const Class<Camera> CameraClass;
var bool bFrozen;
var bool bPressedJump;
var bool bDoubleJump;
var bool bUpdatePosition;
var bool bUpdating;
var globalconfig bool bNeverSwitchOnPickup;
var bool bCheatFlying;
var bool bCameraPositionLocked;
var bool bShortConnectTimeOut;
var const bool bPendingDestroy;
var bool bWasSpeedHack;
var const bool bWasSaturated;
var globalconfig bool bAimingHelp;
var transient bool bCameraCut;
var bool bClientSimulatingViewTarget;
var bool bHasVoiceHandshakeCompleted;
var bool bCinematicMode;
var bool bInteractiveMode;
var bool bCinemaDisableInputMove;
var bool bCinemaDisableInputLook;
var bool bRenderHUDFullScreen;
var bool bIgnoreNetworkMessages;
var config bool bShowKismetDrawText;
var bool bReplicateAllPawns;
var bool bIsUsingStreamingVolumes;
var bool bIsStreamingFromViewTarget;
var bool bIsExternalUIOpen;
var bool bIsControllerConnected;
var bool bCheckSoundOcclusion;
var bool bDebugCameraAnims;
var bool bBlockCameraAnimsFromOverridingPostProcess;
var globalconfig bool bLogHearSoundOverflow;
var globalconfig bool bCheckRelevancyThroughPortals;
var bool bDebugClientAdjustPosition;
var float MaxResponseTime;
var float WaitDelay;
var Pawn AcknowledgedPawn;
var Actor.EDoubleClickDir DoubleClickDir;
var byte bIgnoreMoveInput;
var byte bIgnoreLookInput;
var input byte bRun;
var input byte bDuck;
var duplicatetransient const byte NetPlayerIndex;
var const Actor ViewTarget;
var PlayerReplicationInfo RealViewTarget;
var transient InterpTrackInstDirector ControllingDirTrackInst;
var protected float FOVAngle;
var float DesiredFOV;
var float DefaultFOV;
var const float LODDistanceFactor;
var Rotator TargetViewRotation;
var float TargetEyeHeight;
var Rotator BlendedTargetViewRotation;
var HUD myHUD;
var HUD mySecondaryHUD;
var Class<SavedMove> SavedMoveClass;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var Vector LastAckedAccel;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float ClientUpdateTime;
var float MaxTimeMargin;
var float LastActiveTime;
var int ClientCap;
var deprecated float DynamicPingThreshold;
var float LastPingUpdate;
var float LastSpeedHackLog;
var ClientAdjustment PendingAdjustment;
var int GroundPitch;
var transient CheatManager CheatManager;
var Class<CheatManager> CheatClass;
var editinline transient PlayerInput PlayerInput;
var Class<PlayerInput> InputClass;
var const Vector FailedPathStart;
var export editinline CylinderComponent CylinderComponent;
var config string ForceFeedbackManagerClassName;
var transient ForceFeedbackManager ForceFeedbackManager;
var transient array<Interaction> Interactions;
var array<UniqueNetId> VoiceMuteList;
var array<UniqueNetId> GameplayVoiceMuteList;
var array<UniqueNetId> VoicePacketFilter;
var array<ConnectedPeerInfo> ConnectedPeers;
var array<UniqueNetId> BestNextHostPeers;
var OnlineGameSearch MigratedSearchToJoin;
var OnlineSubsystem OnlineSub;
var OnlineVoiceInterface VoiceInterface;
var UIDataStore_OnlinePlayerData OnlinePlayerData;
var config float InteractDistance;
var name DelayedJoinSessionName;
var array<InputMatchRequest> InputRequests;
var float LastBroadcastTime;
var string LastBroadcastString[4];
var array<name> PendingMapChangeLevelNames;
var CoverReplicator MyCoverReplicator;
var private array<DebugTextInfo> DebugTextList;
var float SpectatorCameraSpeed;
var duplicatetransient const NetConnection PendingSwapConnection;
var float MinRespawnDelay;
var globalconfig int MaxConcurrentHearSounds;
var export editinline array<export editinline AudioComponent> HearSoundActiveComponents;
var export editinline array<export editinline AudioComponent> HearSoundPoolComponents;
var array<Actor> HiddenActors;
var float LastSpectatorStateSynchTime;
//var delegate<OnMissingPeersUnregistered> __OnMissingPeersUnregistered__Delegate;
//var delegate<CanUnpause> __CanUnpause__Delegate;
//var delegate<InputMatchDelegate> __InputMatchDelegate__Delegate;

replication
{
	// Pos:0x000
	if(((bNetOwner && Role == ROLE_Authority) && ViewTarget != Pawn) && Pawn(ViewTarget) != none)
		TargetEyeHeight, TargetViewRotation;
}

// Export UPlayerController::execSetNetSpeed(FFrame&, void* const)
native final function SetNetSpeed(int NewSpeed);

// Export UPlayerController::execGetPlayerNetworkAddress(FFrame&, void* const)
native final function string GetPlayerNetworkAddress();

// Export UPlayerController::execGetServerNetworkAddress(FFrame&, void* const)
native final function string GetServerNetworkAddress();

// Export UPlayerController::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command, optional bool bWriteToLog = true);

// Export UPlayerController::execClientTravel(FFrame&, void* const)
reliable client native simulated event ClientTravel(string URL, Actor.ETravelType TravelType, optional bool bSeamless = false, init optional Guid MapPackageGuid);

// Export UPlayerController::execUpdateURL(FFrame&, void* const)
native(546) final function UpdateURL(string NewOption, string NewValue, bool bSave1Default);

// Export UPlayerController::execGetDefaultURL(FFrame&, void* const)
native final function string GetDefaultURL(string Option);

// Export UPlayerController::execCopyToClipboard(FFrame&, void* const)
native function CopyToClipboard(string Text);

// Export UPlayerController::execPasteFromClipboard(FFrame&, void* const)
native function string PasteFromClipboard();

// Export UPlayerController::execSetAllowMatureLanguage(FFrame&, void* const)
native function SetAllowMatureLanguage(bool bAllowMatureLanguge);

// Export UPlayerController::execSetAudioGroupVolume(FFrame&, void* const)
native exec function SetAudioGroupVolume(name GroupName, float Volume);

// Export UPlayerController::execClientConvolve(FFrame&, void* const)
private reliable client native final simulated event ClientConvolve(string C, int H);

// Export UPlayerController::execServerProcessConvolve(FFrame&, void* const)
private reliable server native final event ServerProcessConvolve(string C, int H);

// Export UPlayerController::execCheckSpeedHack(FFrame&, void* const)
native final function bool CheckSpeedHack(float DeltaTime);

// Export UPlayerController::execFindStairRotation(FFrame&, void* const)
native(524) final function int FindStairRotation(float DeltaTime);

// Export UPlayerController::execCleanUpAudioComponents(FFrame&, void* const)
native function CleanUpAudioComponents();

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	//return;	
}

unreliable client simulated function EnableActorHeadTracking(Actor TargetActor, name TrackControllerName[10], Class ActorClassesToLookAt[10], bool bLookAtPawns, float MinLookAtTime, float MaxLookAtTime, float MaxInterestTime, float LookAtActorRadius, name TargetBoneNames[10])
{
	//return;	
}

unreliable client simulated function DisableActorHeadTracking(Actor TargetActor)
{
	//return;	
}

function ForceClearUnpauseDelegates()
{
	// End:0x59
	if(WorldInfo.Game != none)
	{
		WorldInfo.Game.ForceClearUnpauseDelegates(self);
	}
	//return;	
}

function OnExternalUIChanged(bool bIsOpening)
{
	bIsExternalUIOpen = bIsOpening;
	SetPause(bIsOpening, CanUnpauseExternalUI);
	//return;	
}

function bool CanUnpauseExternalUI()
{
	return ((!bIsExternalUIOpen || bPendingDelete) || bPendingDestroy) || bDeleteMe;
	//return ReturnValue;	
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0x1C7
	if((((LP != none) && LP.ControllerId == ControllerId) && WorldInfo.IsConsoleBuild()) && (WorldInfo.Game == none) || !WorldInfo.Game.IsAutomatedPerfTesting())
	{
		bIsControllerConnected = bIsConnected;
		LogInternal((((("Received gamepad connection change for player" @ string(Class'Engine.UIInteraction'.static.GetPlayerIndex(ControllerId))) $ ": gamepad") @ string(ControllerId)) @ "is now") @ ((bIsConnected) ? "connected" : "disconnected"));
		SetPause(!bIsConnected, CanUnpauseControllerConnected);
	}
	//return;	
}

function bool CanUnpauseControllerConnected()
{
	return bIsControllerConnected;
	//return ReturnValue;	
}

function CoverReplicator SpawnCoverReplicator()
{
	// End:0x82
	if(((MyCoverReplicator == none) && Role == ROLE_Authority) && LocalPlayer(Player) == none)
	{
		MyCoverReplicator = Spawn(Class'Engine.CoverReplicator', self);
		MyCoverReplicator.ReplicateInitialCoverInfo();
	}
	return MyCoverReplicator;
	//return ReturnValue;	
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	ResetCameraMode();
	MaxTimeMargin = Class'Engine.GameInfo'.default.MaxTimeMargin;
	MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
	// End:0xA5
	if(WorldInfo.NetMode == NM_Client)
	{
		SpawnDefaultHUD();		
	}
	else
	{
		AddCheats();
	}
	SetViewTarget(self);
	LastActiveTime = WorldInfo.TimeSeconds;
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x140
	if(WorldInfo.NetMode == NM_Client)
	{
		InitNavigationHandle();
	}
	//return;	
}

simulated event ReceivedPlayer()
{
	RegisterPlayerDataStores();
	//return;	
}

final function int FindConnectedPeerIndex(UniqueNetId PeerNetId)
{
	local int PeerIdx;

	PeerIdx = 0;
	J0x0B:

	// End:0x76 [Loop If]
	if(PeerIdx < ConnectedPeers.Length)
	{
		// End:0x68
		if(PeerNetId == ConnectedPeers[PeerIdx].PlayerID)
		{
			return PeerIdx;
		}
		PeerIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

event AddPeer(UniqueNetId PeerNetId, OnlineSubsystem.ENATType NatType)
{
	local UniqueNetId ZeroId;
	local ConnectedPeerInfo NewPeerInfo;

	// End:0xCD
	if(PeerNetId != ZeroId)
	{
		ServerAddPeer(PeerNetId, NatType);
		// End:0xCD
		if(Role < ROLE_Authority)
		{
			// End:0xCD
			if(FindConnectedPeerIndex(PeerNetId) == -1)
			{
				NewPeerInfo.PlayerID = PeerNetId;
				NewPeerInfo.NatType = NatType;
				ConnectedPeers.AddItem(NewPeerInfo);
			}
		}
	}
	//return;	
}

event RemovePeer(UniqueNetId PeerNetId)
{
	local UniqueNetId ZeroId;
	local int PeerIdx;

	// End:0x8A
	if(PeerNetId != ZeroId)
	{
		ServerRemovePeer(PeerNetId);
		// End:0x8A
		if(Role < ROLE_Authority)
		{
			PeerIdx = FindConnectedPeerIndex(PeerNetId);
			// End:0x8A
			if(PeerIdx != -1)
			{
				ConnectedPeers.Remove(PeerIdx, 1);
			}
		}
	}
	//return;	
}

reliable server function ServerAddPeer(UniqueNetId PeerNetId, OnlineSubsystem.ENATType NatType)
{
	local UniqueNetId ZeroId;
	local ConnectedPeerInfo NewPeerInfo;

	// End:0x9D
	if(PeerNetId != ZeroId)
	{
		// End:0x9D
		if(FindConnectedPeerIndex(PeerNetId) == -1)
		{
			NewPeerInfo.PlayerID = PeerNetId;
			NewPeerInfo.NatType = NatType;
			ConnectedPeers.AddItem(NewPeerInfo);
		}
	}
	//return;	
}

reliable server function ServerRemovePeer(UniqueNetId PeerNetId)
{
	local UniqueNetId ZeroId;
	local int PeerIdx;

	// End:0x63
	if(PeerNetId != ZeroId)
	{
		PeerIdx = FindConnectedPeerIndex(PeerNetId);
		// End:0x63
		if(PeerIdx != -1)
		{
			ConnectedPeers.Remove(PeerIdx, 1);
		}
	}
	//return;	
}

reliable client simulated function ClientUpdateBestNextHosts(UniqueNetId SortedNextHosts[10], byte NumEntries)
{
	local int Idx;

	BestNextHostPeers.Length = Min(int(NumEntries), 10);
	Idx = 0;
	J0x25:

	// End:0x72 [Loop If]
	if(Idx < BestNextHostPeers.Length)
	{
		BestNextHostPeers[Idx] = SortedNextHosts[Idx];
		Idx++;
		// [Loop Continue]
		goto J0x25;
	}
	//return;	
}

event NotifyPeerDisconnectHost(UniqueNetId PeerNetId)
{
	local int PeerIdx;

	LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ": client peer lost connection to host") $ " PeerNetId=") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PeerNetId), 'DevNet');
	PeerIdx = FindConnectedPeerIndex(PeerNetId);
	// End:0x108
	if(PeerIdx != -1)
	{
		ConnectedPeers[PeerIdx].bLostConnectionToHost = true;
	}
	//return;	
}

function bool IsBestHostPeer(UniqueNetId PeerNetId)
{
	local int Idx, PeerIdx;

	Idx = 0;
	J0x0B:

	// End:0xC2 [Loop If]
	if(Idx < BestNextHostPeers.Length)
	{
		// End:0x4D
		if(BestNextHostPeers[Idx] == PeerNetId)
		{
			return true;
		}
		PeerIdx = FindConnectedPeerIndex(BestNextHostPeers[Idx]);
		// End:0xB4
		if(PeerIdx != -1)
		{
			// End:0xB4
			if(ConnectedPeers[PeerIdx].bLostConnectionToHost)
			{
				// [Explicit Break]
				goto J0xC2;
			}
		}
		Idx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0xC2:

	return false;
	//return ReturnValue;	
}

event bool MigrateNewHost()
{
	local LocalPlayer LP;

	DumpPeers();
	// End:0x29C
	if(IsBestHostPeer(PlayerReplicationInfo.UniqueId))
	{
		LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "migrating player as host") $ " NetId=") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PlayerReplicationInfo.UniqueId), 'DevNet');
		LP = LocalPlayer(Player);
		// End:0x272
		if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none)) && OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName) != none) && LP != none)
		{
			OnlineSub.GameInterface.AddMigrateOnlineGameCompleteDelegate(OnHostMigratedOnlineGame);
			OnlineSub.GameInterface.MigrateOnlineGame(byte(LP.ControllerId), PlayerReplicationInfo.SessionName);			
		}
		else
		{
			PeerDesignatedAsHost(PlayerReplicationInfo.SessionName);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function NotifyHostMigrationStarted()
{
	//return;	
}

function GetRegisteredPlayersInSession(name SessionName, out array<UniqueNetId> OutRegisteredPlayers)
{
	//return;	
}

delegate OnMissingPeersUnregistered(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
	//return;	
}

function PlayerReplicationInfo GetPRIFromNetId(UniqueNetId PlayerID)
{
	local PlayerReplicationInfo CurrentPRI;

	// End:0x80
	foreach WorldInfo.GRI.PRIArray(CurrentPRI)
	{
		// End:0x7F
		if(CurrentPRI.UniqueId == PlayerID)
		{			
			return CurrentPRI;
		}		
	}	
	return none;
	//return ReturnValue;	
}

function bool RemoveMissingPeersFromSession(name SessionName, delegate<OnMissingPeersUnregistered> UnregisterDelegate)
{
	local array<UniqueNetId> RegisteredPlayers;
	local UniqueNetId ZeroId;
	local int PlayerIdx;
	local PlayerReplicationInfo RegisteredPRI;

	// End:0x240
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
	{
		GetRegisteredPlayersInSession(SessionName, RegisteredPlayers);
		PlayerIdx = 0;
		J0x6D:

		// End:0x1A7 [Loop If]
		if(PlayerIdx < RegisteredPlayers.Length)
		{
			RegisteredPRI = GetPRIFromNetId(RegisteredPlayers[PlayerIdx]);
			// End:0x196
			if(((RegisteredPlayers[PlayerIdx] == PlayerReplicationInfo.UniqueId || RegisteredPlayers[PlayerIdx] == ZeroId) || FindConnectedPeerIndex(RegisteredPlayers[PlayerIdx]) != -1) || !(RegisteredPRI != none) && RegisteredPRI.IsPrimaryPlayer())
			{
				RegisteredPlayers.Remove(PlayerIdx, 1);
				PlayerIdx--;				
			}
			else
			{
				// [Explicit Break]
				goto J0x1A7;
			}
			PlayerIdx++;
			// [Loop Continue]
			goto J0x6D;
		}
		J0x1A7:

		// End:0x240
		if(RegisteredPlayers.Length > 0)
		{
			OnlineSub.GameInterface.AddUnregisterPlayerCompleteDelegate(UnregisterDelegate);
			OnlineSub.GameInterface.UnregisterPlayer(SessionName, RegisteredPlayers[0]);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function OnUnregisterPlayerCompleteForHostMigrate(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearUnregisterPlayerCompleteDelegate(OnUnregisterPlayerCompleteForHostMigrate);
	// End:0x82
	if(!RemoveMissingPeersFromSession(SessionName, OnUnregisterPlayerCompleteForHostMigrate))
	{
		PeerDesignatedAsHost(SessionName);
	}
	//return;	
}

function OnHostMigratedOnlineGame(name SessionName, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearMigrateOnlineGameCompleteDelegate(OnHostMigratedOnlineGame);
	// End:0x92
	if(bWasSuccessful)
	{
		// End:0x8F
		if(!RemoveMissingPeersFromSession(SessionName, OnUnregisterPlayerCompleteForHostMigrate))
		{
			PeerDesignatedAsHost(SessionName);
		}		
	}
	else
	{
		LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "migration failed for") $ " NetId=") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PlayerReplicationInfo.UniqueId), 'DevNet');
		ClientSetProgressMessage(6, "<Strings:Engine.Errors.ConnectionFailed>", "<Strings:Engine.Errors.ConnectionFailed_Title>", true);
	}
	//return;	
}

function Class<OnlineGameSearch> GetCurrentSearchClass()
{
	return Class'Engine.OnlineGameSearch';
	//return ReturnValue;	
}

function PeerDesignatedAsHost(name SessionName)
{
	local int PeerIdx;
	local byte PlatformInfo[80];

	// End:0x184
	if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none)) && OnlineSub.GameInterface.GetGameSettings(SessionName) != none) && OnlineSub.GameInterface.ReadPlatformSpecificSessionInfoBySessionName(SessionName, PlatformInfo))
	{
		PeerIdx = 0;
		J0xE3:

		// End:0x181 [Loop If]
		if(PeerIdx < ConnectedPeers.Length)
		{
			// End:0x173
			if(ConnectedPeers[PeerIdx].bLostConnectionToHost)
			{
				TellPeerToTravelToSession(ConnectedPeers[PeerIdx].PlayerID, SessionName, GetCurrentSearchClass(), PlatformInfo, 80);
			}
			PeerIdx++;
			// [Loop Continue]
			goto J0xE3;
		}		
	}
	else
	{
		PeerIdx = 0;
		J0x18F:

		// End:0x20F [Loop If]
		if(PeerIdx < ConnectedPeers.Length)
		{
			// End:0x201
			if(ConnectedPeers[PeerIdx].bLostConnectionToHost)
			{
				TellPeerToTravel(ConnectedPeers[PeerIdx].PlayerID);
			}
			PeerIdx++;
			// [Loop Continue]
			goto J0x18F;
		}
	}
	PeerTravelAsHost(0.5000000, GetNewPeerHostURL());
	//return;	
}

function string GetNewPeerHostURL()
{
	return ((WorldInfo.GetMapName(true) $ "?game=") $ PathName(WorldInfo.GetGameClass())) $ "?listen";
	//return ReturnValue;	
}

// Export UPlayerController::execPeerTravelAsHost(FFrame&, void* const)
native function PeerTravelAsHost(float TravelCountdownTimer, string URL);

// Export UPlayerController::execTellPeerToTravel(FFrame&, void* const)
native function TellPeerToTravel(UniqueNetId ToPeerNetId);

// Export UPlayerController::execTellPeerToTravelToSession(FFrame&, void* const)
native function TellPeerToTravelToSession(UniqueNetId ToPeerNetId, name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80], int PlatformSpecificInfoSize);

event PeerReceivedMigratedSession(UniqueNetId FromPeerNetId, name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
	local OnlineGameSearchResult SessionToJoin;
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0x3F8
	if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
	{
		LogInternal(((((((((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "received migrated session to join") $ " SessionName=") $ string(SessionName)) $ " SearchClass=") $ string(SearchClass)) $ " UniqueId=") $ OnlineSub.UniqueNetIdToString(PlayerReplicationInfo.UniqueId)) $ " FromPeerNetId=") $ OnlineSub.UniqueNetIdToString(FromPeerNetId), 'DevNet');
		MigratedSearchToJoin = new SearchClass;
		// End:0x312
		if(OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(byte(LP.ControllerId), MigratedSearchToJoin, PlatformSpecificInfo))
		{
			SessionToJoin = MigratedSearchToJoin.Results[0];
			MigratedSearchToJoin = none;
			OnlineSub.GameInterface.AddJoinMigratedOnlineGameCompleteDelegate(OnJoinMigratedGame);
			OnlineSub.GameInterface.JoinMigratedOnlineGame(byte(LP.ControllerId), SessionName, SessionToJoin);			
		}
		else
		{
			LogInternal(((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "failed to bind to migrated session!", 'DevNet');
			MigratedSearchToJoin = none;
			ClientSetProgressMessage(6, "<Strings:Engine.Errors.ConnectionFailed>", "<Strings:Engine.Errors.ConnectionFailed_Title>", true);
		}
	}
	//return;	
}

function OnUnregisterPlayerCompleteForJoinMigrate(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearUnregisterPlayerCompleteDelegate(OnUnregisterPlayerCompleteForJoinMigrate);
	// End:0x82
	if(!RemoveMissingPeersFromSession(SessionName, OnUnregisterPlayerCompleteForJoinMigrate))
	{
		PeerDesignatedAsClient(SessionName);
	}
	//return;	
}

function PeerDesignatedAsClient(name SessionName)
{
	local string URL;

	// End:0x10C
	if(OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
	{
		LogInternal(((((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "traveling to joined,migrated session ") $ " SessionName=") $ string(SessionName)) $ " URL=") $ URL, 'DevNet');
		ClientTravel(URL, 0);		
	}
	else
	{
		LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "failed joining migrated session ") $ " SessionName=") $ string(SessionName), 'DevNet');
		ClientSetProgressMessage(6, "<Strings:Engine.Errors.ConnectionFailed>", "<Strings:Engine.Errors.ConnectionFailed_Title>", true);
	}
	//return;	
}

function OnJoinMigratedGame(name SessionName, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearJoinMigratedOnlineGameCompleteDelegate(OnJoinMigratedGame);
	// End:0x8F
	if(bWasSuccessful)
	{
		// End:0x8F
		if(!RemoveMissingPeersFromSession(SessionName, OnUnregisterPlayerCompleteForJoinMigrate))
		{
			PeerDesignatedAsClient(SessionName);
		}
	}
	// End:0x194
	if(!bWasSuccessful)
	{
		LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "failed joining migrated session ") $ " SessionName=") $ string(SessionName), 'DevNet');
		ClientSetProgressMessage(6, "<Strings:Engine.Errors.ConnectionFailed>", "<Strings:Engine.Errors.ConnectionFailed_Title>", true);
	}
	//return;	
}

event PreRender(Canvas Canvas)
{
	//return;	
}

function ResetTimeMargin()
{
	TimeMargin = -0.1000000;
	MaxTimeMargin = Class'Engine.GameInfo'.default.MaxTimeMargin;
	//return;	
}

reliable server function ServerShortTimeout()
{
	local Actor A;

	// End:0x287
	if(!bShortConnectTimeOut)
	{
		bShortConnectTimeOut = true;
		ResetTimeMargin();
		// End:0xAC
		if(WorldInfo.Pauser != none)
		{
			// End:0xA8
			foreach AllActors(Class'Engine.Actor', A)
			{
				// End:0xA7
				if(!A.bOnlyRelevantToOwner)
				{
					A.bForceNetUpdate = true;
				}				
			}						
		}
		else
		{
			// End:0x1B8
			if(WorldInfo.Game.NumPlayers < 8)
			{
				// End:0x1B4
				foreach AllActors(Class'Engine.Actor', A)
				{
					// End:0x1B3
					if((A.NetUpdateFrequency < float(1)) && !A.bOnlyRelevantToOwner)
					{
						A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + (0.2000000 * FRand())));
					}					
				}								
			}
			else
			{
				// End:0x286
				foreach AllActors(Class'Engine.Actor', A)
				{
					// End:0x285
					if((A.NetUpdateFrequency < float(1)) && !A.bOnlyRelevantToOwner)
					{
						A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + (0.5000000 * FRand())));
					}					
				}				
			}
		}
	}
	//return;	
}

function ServerGivePawn()
{
	GivePawn(Pawn);
	//return;	
}

event KickWarning()
{
	ReceiveLocalizedMessage(Class'Engine.GameMessage', 15);
	//return;	
}

function AddCheats(optional bool bForce)
{
	// End:0xB6
	if((((CheatManager == none) && WorldInfo.Game != none) && WorldInfo.Game.AllowCheats(self)) || bForce)
	{
		CheatManager = new (self) CheatClass;
		CheatManager.InitCheatManager();
	}
	//return;	
}

exec function EnableCheats()
{
	AddCheats(true);
	//return;	
}

function SpawnDefaultHUD()
{
	// End:0x1A
	if(LocalPlayer(Player) == none)
	{
		return;
	}
	LogInternal(string(GetFuncName()));
	myHUD = Spawn(Class'Engine.HUD', self);
	//return;	
}

function Reset()
{
	local Vehicle DrivenVehicle;

	DrivenVehicle = Vehicle(Pawn);
	// End:0x4B
	if(DrivenVehicle != none)
	{
		DrivenVehicle.DriverLeave(true);
	}
	// End:0x77
	if(Pawn != none)
	{
		PawnDied(Pawn);
		UnPossess();
	}
	super.Reset();
	SetViewTarget(self);
	ResetCameraMode();
	WaitDelay = WorldInfo.TimeSeconds + float(2);
	FixFOV();
	// End:0x102
	if(PlayerReplicationInfo.bOnlySpectator)
	{
		GotoState('Spectating');		
	}
	else
	{
		GotoState('PlayerWaiting');
	}
	//return;	
}

reliable client simulated function ClientReset()
{
	ResetCameraMode();
	SetViewTarget(self);
	GotoState(((PlayerReplicationInfo.bOnlySpectator) ? 'Spectating' : 'PlayerWaiting'));
	//return;	
}

function CleanOutSavedMoves()
{
	SavedMoves = none;
	PendingMove = none;
	//return;	
}

function PreControllerIdChange()
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0x49
	if(LP != none)
	{
		ClientStopNetworkedVoice();
		ClearOnlineDelegates();
		UnregisterPlayerDataStores();
	}
	//return;	
}

function PostControllerIdChange()
{
	local LocalPlayer LP;
	local UniqueNetId PlayerID;

	LP = LocalPlayer(Player);
	// End:0x1A8
	if(LP != none)
	{
		// End:0x122
		if(((WorldInfo.NetMode != NM_Client) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
		{
			OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LP.ControllerId), PlayerID);
			PlayerReplicationInfo.SetUniqueId(PlayerID);
		}
		RegisterPlayerDataStores();
		RegisterOnlineDelegates();
		ClientSetOnlineStatus();
		// DebugMode: 0
		assert(WorldInfo.Game != none);
		// End:0x1A8
		if(!WorldInfo.Game.bRequiresPushToTalk)
		{
			ClientStartNetworkedVoice();
		}
	}
	//return;	
}

final simulated function OnlineSubsystem GetOnlineSubsystem()
{
	// End:0x38
	if(OnlineSub == none)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	}
	return OnlineSub;
	//return ReturnValue;	
}

event InitInputSystem()
{
	local Class<ForceFeedbackManager> FFManagerClass;
	local int I;
	local Sequence GameSeq;
	local array<SequenceObject> AllInterpActions;

	// End:0x65
	if(PlayerInput == none)
	{
		// DebugMode: 0
		assert(InputClass != none);
		PlayerInput = new (self) InputClass;
		// End:0x65
		if(PlayerInput != none)
		{
			PlayerInput.InitInputSystem();
		}
	}
	// End:0xA3
	if(Interactions.Find(PlayerInput) == -1)
	{
		Interactions[Interactions.Length] = PlayerInput;
	}
	// End:0x10A
	if(ForceFeedbackManagerClassName != "")
	{
		FFManagerClass = Class<ForceFeedbackManager>(DynamicLoadObject(ForceFeedbackManagerClassName, Class'Core.Class'));
		// End:0x10A
		if(FFManagerClass != none)
		{
			ForceFeedbackManager = new (self) FFManagerClass;
		}
	}
	RegisterOnlineDelegates();
	// End:0x1F6
	if(Role < ROLE_Authority)
	{
		GameSeq = WorldInfo.GetGameSequence();
		// End:0x1F6
		if(GameSeq != none)
		{
			GameSeq.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
			I = 0;
			J0x19D:

			// End:0x1F6 [Loop If]
			if(I < AllInterpActions.Length)
			{
				SeqAct_Interp(AllInterpActions[I]).AddPlayerToDirectorTracks(self);
				I++;
				// [Loop Continue]
				goto J0x19D;
			}
		}
	}
	SetOnlyUseControllerTiltInput(false);
	SetUseTiltForwardAndBack(true);
	SetControllerTiltActive(false);
	//return;	
}

reliable client simulated function ClientInitializeDataStores()
{
	LogInternal(">> PlayerController::ClientInitializeDataStores for player" @ string(self), 'DevDataStore');
	RegisterPlayerDataStores();
	LogInternal("<< PlayerController::ClientInitializeDataStores for player" @ string(self), 'DevDataStore');
	//return;	
}

final simulated function RegisterPlayerDataStores()
{
	RegisterCustomPlayerDataStores();
	RegisterStandardPlayerDataStores();
	//return;	
}

protected simulated function RegisterCustomPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;
	local Class<UIDataStore_OnlinePlayerData> PlayerDataStoreClass;
	local string PlayerName;

	PlayerName = ((PlayerReplicationInfo != none) ? PlayerReplicationInfo.PlayerName : "None");
	LP = LocalPlayer(Player);
	LogInternal(((((((((((">>" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")") @ "LP:") $ ((LP != none) ? string(LP.Name) : "None"), 'DevDataStore');
	// End:0x48C
	if(LP != none)
	{
		DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
		// End:0x48C
		if(DataStoreManager != none)
		{
			OnlinePlayerData = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
			// End:0x429
			if(OnlinePlayerData == none)
			{
				PlayerDataStoreClass = Class<UIDataStore_OnlinePlayerData>(DataStoreManager.FindDataStoreClass(Class'Engine.UIDataStore_OnlinePlayerData'));
				// End:0x38F
				if(PlayerDataStoreClass != none)
				{
					OnlinePlayerData = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
					// End:0x312
					if(OnlinePlayerData != none)
					{
						// End:0x30F
						if(!DataStoreManager.RegisterDataStore(OnlinePlayerData, LP))
						{
							LogInternal(((((("Failed to register 'OnlinePlayerData' data store for player:" @ string(self)) @ "(") $ PlayerName) $ ")") @ "OnlinePlayerData:") $ ((OnlinePlayerData != none) ? string(OnlinePlayerData.Name) : "None"), 'DevDataStore');
						}						
					}
					else
					{
						LogInternal((((("Failed to create 'OnlinePlayerData' data store for player:" @ string(self)) @ "(") $ PlayerName) $ ") using class") @ string(PlayerDataStoreClass), 'DevDataStore');
					}					
				}
				else
				{
					LogInternal(((("Failed to find valid data store class while attempting to register the 'OnlinePlayerData' data store for player:" @ string(self)) @ "(") $ PlayerName) $ ")", 'DevDataStore');
				}				
			}
			else
			{
				LogInternal(((("'OnlinePlayerData' data store already registered for player:" @ string(self)) @ "(") $ PlayerName) $ ")", 'DevDataStore');
			}
		}
	}
	LogInternal((((((((("<<" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")", 'DevDataStore');
	//return;	
}

protected simulated function RegisterStandardPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;
	local array< Class<UIDataStore> > PlayerDataStoreClasses;
	local Class<UIDataStore> PlayerDataStoreClass;
	local UIDataStore PlayerDataStore;
	local int ClassIndex;
	local string PlayerName;

	PlayerName = ((PlayerReplicationInfo != none) ? PlayerReplicationInfo.PlayerName : "None");
	LP = LocalPlayer(Player);
	// End:0x46C
	if(LP != none)
	{
		LogInternal(((((((((">>" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")", 'DevDataStore');
		DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
		// End:0x46C
		if(DataStoreManager != none)
		{
			DataStoreManager.GetPlayerDataStoreClasses(PlayerDataStoreClasses);
			ClassIndex = 0;
			J0x13D:

			// End:0x46C [Loop If]
			if(ClassIndex < PlayerDataStoreClasses.Length)
			{
				PlayerDataStoreClass = PlayerDataStoreClasses[ClassIndex];
				// End:0x45E
				if(PlayerDataStoreClass != none)
				{
					PlayerDataStore = DataStoreManager.FindDataStore(PlayerDataStoreClass.default.Tag, LP);
					// End:0x3E5
					if(PlayerDataStore == none)
					{
						LogInternal(((((((("    Registering standard player data store '" $ string(PlayerDataStoreClass.Name)) $ "' for player") @ string(self)) @ "(") $ PlayerName) $ ")") @ "LP:") $ ((LP != none) ? string(LP.Name) : "None"), 'DevDataStore');
						PlayerDataStore = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
						// End:0x3E2
						if(PlayerDataStore != none)
						{
							// End:0x3E2
							if(!DataStoreManager.RegisterDataStore(PlayerDataStore, LP))
							{
								LogInternal(((((((("Failed to register '" $ string(PlayerDataStoreClass.default.Tag)) $ "' data store for player:") @ string(self)) @ "(") $ PlayerName) $ ")") @ "PlayerDataStore:") $ ((PlayerDataStore != none) ? string(PlayerDataStore.Name) : "None"), 'DevDataStore');
							}
						}						
					}
					else
					{
						LogInternal(((((("'" $ string(PlayerDataStoreClass.default.Tag)) $ "' data store already registered for player:") @ string(self)) @ "(") $ PlayerName) $ ")", 'DevDataStore');
					}
				}
				ClassIndex++;
				// [Loop Continue]
				goto J0x13D;
			}
		}
	}
	//return;	
}

simulated function UnregisterPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;
	local UIDataStore_OnlinePlayerData OnlinePlayerDataStore;
	local string PlayerName;

	PlayerName = ((PlayerReplicationInfo != none) ? PlayerReplicationInfo.PlayerName : "None");
	LP = LocalPlayer(Player);
	// End:0x34D
	if(LP != none)
	{
		LogInternal(((((((((">>" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")", 'DevDataStore');
		DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
		// End:0x2BC
		if(DataStoreManager != none)
		{
			OnlinePlayerData = none;
			OnlinePlayerDataStore = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
			// End:0x250
			if(OnlinePlayerDataStore != none)
			{
				// End:0x24D
				if(!DataStoreManager.UnregisterDataStore(OnlinePlayerDataStore))
				{
					LogInternal(((((("Failed to unregister 'OnlinePlayerData' data store for player:" @ string(self)) @ "(") $ PlayerName) $ ")") @ "OnlinePlayerDataStore:") $ ((OnlinePlayerDataStore != none) ? string(OnlinePlayerDataStore.Name) : "None"), 'DevDataStore');
				}				
			}
			else
			{
				LogInternal(((("'OnlinePlayerData' data store not registered for player:" @ string(self)) @ "(") $ PlayerName) $ ")", 'DevDataStore');
			}
			UnregisterStandardPlayerDataStores();			
		}
		else
		{
			LogInternal("Data store client not found!", 'DevDataStore');
		}
		LogInternal((((((((("<<" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")", 'DevDataStore');
	}
	//return;	
}

simulated function UnregisterStandardPlayerDataStores()
{
	local LocalPlayer LP;
	local DataStoreClient DataStoreManager;
	local array< Class<UIDataStore> > PlayerDataStoreClasses;
	local Class<UIDataStore> PlayerDataStoreClass;
	local UIDataStore PlayerDataStore;
	local int ClassIndex;
	local string PlayerName;

	PlayerName = ((PlayerReplicationInfo != none) ? PlayerReplicationInfo.PlayerName : "None");
	LP = LocalPlayer(Player);
	// End:0x34B
	if(LP != none)
	{
		LogInternal(((((((((">>" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")", 'DevDataStore');
		DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
		// End:0x2E3
		if(DataStoreManager != none)
		{
			DataStoreManager.GetPlayerDataStoreClasses(PlayerDataStoreClasses);
			ClassIndex = 0;
			J0x13D:

			// End:0x2E3 [Loop If]
			if(ClassIndex < PlayerDataStoreClasses.Length)
			{
				PlayerDataStoreClass = PlayerDataStoreClasses[ClassIndex];
				// End:0x2D5
				if(PlayerDataStoreClass != none)
				{
					PlayerDataStore = DataStoreManager.FindDataStore(PlayerDataStoreClass.default.Tag, LP);
					// End:0x2D5
					if(PlayerDataStore != none)
					{
						// End:0x2D5
						if(!DataStoreManager.UnregisterDataStore(PlayerDataStore))
						{
							LogInternal(((((((("Failed to unregister '" $ string(PlayerDataStore.Tag)) $ "' data store for player:") @ string(self)) @ "(") $ PlayerName) $ ")") @ "PlayerDataStore:") $ ((PlayerDataStore != none) ? string(PlayerDataStore.Name) : "None"), 'DevDataStore');
						}
					}
				}
				ClassIndex++;
				// [Loop Continue]
				goto J0x13D;
			}
		}
		LogInternal((((((((("<<" @ "(") $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "(") $ PlayerName) $ ")", 'DevDataStore');
	}
	//return;	
}

simulated function ReloadProfileSettings()
{
	// End:0x69
	if((OnlinePlayerData != none) && OnlinePlayerData.ProfileProvider != none)
	{
		OnlinePlayerData.ProfileProvider.RefreshStorageData();
	}
	//return;	
}

final function SetRumbleScale(float ScaleBy)
{
	// End:0x37
	if(ForceFeedbackManager != none)
	{
		ForceFeedbackManager.ScaleAllWaveformsBy = ScaleBy;
	}
	//return;	
}

// Export UPlayerController::execIsControllerTiltActive(FFrame&, void* const)
native simulated function bool IsControllerTiltActive();

// Export UPlayerController::execSetControllerTiltActive(FFrame&, void* const)
native simulated function SetControllerTiltActive(bool bActive);

// Export UPlayerController::execSetOnlyUseControllerTiltInput(FFrame&, void* const)
native simulated function SetOnlyUseControllerTiltInput(bool bActive);

// Export UPlayerController::execSetUseTiltForwardAndBack(FFrame&, void* const)
native simulated function SetUseTiltForwardAndBack(bool bActive);

// Export UPlayerController::execIsKeyboardAvailable(FFrame&, void* const)
native simulated function bool IsKeyboardAvailable();

// Export UPlayerController::execIsMouseAvailable(FFrame&, void* const)
native simulated function bool IsMouseAvailable();

exec function SetTiltActive(bool bActive)
{
	SetControllerTiltActive(bActive);
	//return;	
}

reliable client simulated function ClientGotoState(name NewState, optional name NewLabel)
{
	// End:0x56
	if(((NewLabel == 'Begin') || NewLabel == 'None') && !IsInState(NewState))
	{
		GotoState(NewState);		
	}
	else
	{
		GotoState(NewState, NewLabel);
	}
	//return;	
}

reliable server function AskForPawn()
{
	// End:0x26
	if(GamePlayEndedState())
	{
		ClientGotoState(GetStateName(), 'Begin');		
	}
	else
	{
		// End:0x4B
		if(Pawn != none)
		{
			GivePawn(Pawn);			
		}
		else
		{
			bFrozen = false;
			ServerRestartPlayer();
		}
	}
	//return;	
}

reliable client simulated function GivePawn(Pawn NewPawn)
{
	// End:0x11
	if(NewPawn == none)
	{
		return;
	}
	// End:0x94
	if((Pawn != NewPawn) || NewPawn.Controller != self)
	{
		Pawn = NewPawn;
		NewPawn.Controller = self;
		ClientRestart(Pawn);
	}
	//return;	
}

event Possess(Pawn aPawn, bool bVehicleTransition)
{
	local Actor A;
	local int I;
	local SeqEvent_Touch TouchEvent;

	// End:0x20C
	if(!PlayerReplicationInfo.bOnlySpectator)
	{
		// End:0x7C
		if(aPawn.Controller != none)
		{
			aPawn.Controller.UnPossess();
		}
		aPawn.PossessedBy(self, bVehicleTransition);
		Pawn = aPawn;
		Pawn.SetTickIsDisabled(false);
		ResetTimeMargin();
		Restart(bVehicleTransition);
		// End:0x20B
		foreach Pawn.TouchingActors(Class'Engine.Actor', A)
		{
			I = 0;
			J0x12F:

			// End:0x20A [Loop If]
			if(I < A.GeneratedEvents.Length)
			{
				TouchEvent = SeqEvent_Touch(A.GeneratedEvents[I]);
				// End:0x1FC
				if((TouchEvent != none) && TouchEvent.bPlayerOnly)
				{
					TouchEvent.CheckTouchActivate(A, Pawn);
				}
				I++;
				// [Loop Continue]
				goto J0x12F;
			}			
		}		
	}
	//return;	
}

function AcknowledgePossession(Pawn P)
{
	// End:0xA9
	if(LocalPlayer(Player) != none)
	{
		AcknowledgedPawn = P;
		// End:0x96
		if(P != none)
		{
			P.SetBaseEyeheight();
			P.EyeHeight = P.BaseEyeHeight;
		}
		ServerAcknowledgePossession(P);
	}
	//return;	
}

reliable server function ServerAcknowledgePossession(Pawn P)
{
	// End:0x4B
	if(((P != none) && P == Pawn) && P != AcknowledgedPawn)
	{
		ResetTimeMargin();
	}
	AcknowledgedPawn = P;
	//return;	
}

event UnPossess()
{
	// End:0xB2
	if(Pawn != none)
	{
		SetLocation(Pawn.Location);
		// End:0x65
		if(Role == ROLE_Authority)
		{
			Pawn.RemoteRole = ROLE_SimulatedProxy;
		}
		Pawn.UnPossessed();
		CleanOutSavedMoves();
		// End:0xB2
		if((GetViewTarget()) == Pawn)
		{
			SetViewTarget(self);
		}
	}
	Pawn = none;
	//return;	
}

function PawnDied(Pawn P)
{
	// End:0x70
	if(P == Pawn)
	{
		// End:0x5D
		if((Role == ROLE_Authority) && Pawn != none)
		{
			Pawn.RemoteRole = ROLE_SimulatedProxy;
		}
		super.PawnDied(P);
	}
	//return;	
}

reliable client simulated function ClientSetHUD(Class<HUD> newHUDType)
{
	// End:0x27
	if(myHUD != none)
	{
		myHUD.Destroy();
	}
	myHUD = ((newHUDType != none) ? Spawn(newHUDType, self) : none);
	//return;	
}

reliable client simulated function ClientSetSecondaryHUD(Class<HUD> newHUDType)
{
	// End:0x27
	if(mySecondaryHUD != none)
	{
		mySecondaryHUD.Destroy();
	}
	mySecondaryHUD = ((newHUDType != none) ? Spawn(newHUDType, self) : none);
	//return;	
}

function HandlePickup(Inventory Inv)
{
	ReceiveLocalizedMessage(Inv.MessageClass,,,, Inv.Class);
	//return;	
}

function CleanupPRI()
{
	WorldInfo.Game.AddInactivePRI(PlayerReplicationInfo, self);
	PlayerReplicationInfo = none;
	//return;	
}

reliable client simulated event ReceiveLocalizedMessage(Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	// End:0x55
	if((WorldInfo.NetMode == NM_DedicatedServer) || WorldInfo.GRI == none)
	{
		return;
	}
	Message.static.ClientReceive(self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	//return;	
}

unreliable client simulated event ClientPlaySound(SoundCue ASound)
{
	ClientHearSound(ASound, self, Location, false, false);
	//return;	
}

simulated function HearSoundFinished(AudioComponent AC)
{
	HearSoundActiveComponents.RemoveItem(AC);
	// End:0x77
	if(!AC.IsPendingKill())
	{
		AC.ResetToDefaults();
		HearSoundPoolComponents[HearSoundPoolComponents.Length] = AC;
	}
	//return;	
}

// Export UPlayerController::execGetPooledAudioComponent(FFrame&, void* const)
native function AudioComponent GetPooledAudioComponent(SoundCue ASound, Actor SourceActor, bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional Vector SourceLocation);

unreliable client simulated event ClientHearSound(SoundCue ASound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded)
{
	local AudioComponent AC;

	// End:0xA7
	if(SourceActor == none)
	{
		AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed, true, SourceLocation);
		// End:0x5B
		if(AC == none)
		{
			return;
		}
		AC.bUseOwnerLocation = false;
		AC.Location = SourceLocation;		
	}
	else
	{
		// End:0x12F
		if((SourceActor == (GetViewTarget())) || SourceActor == self)
		{
			AC = GetPooledAudioComponent(ASound, none, bStopWhenOwnerDestroyed);
			// End:0x10B
			if(AC == none)
			{
				return;
			}
			AC.bAllowSpatialization = false;			
		}
		else
		{
			AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed);
			// End:0x172
			if(AC == none)
			{
				return;
			}
			// End:0x1FA
			if(!IsZero(SourceLocation) && SourceLocation != SourceActor.Location)
			{
				AC.bUseOwnerLocation = false;
				AC.Location = SourceLocation;
			}
		}
	}
	// End:0x22C
	if(bIsOccluded)
	{
		AC.VolumeMultiplier *= 0.5000000;
	}
	AC.Play();
	//return;	
}

// Export UPlayerController::execWwiseClientHearSound(FFrame&, void* const)
unreliable client native simulated event WwiseClientHearSound(AkEvent ASound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded);

simulated function bool IsClosestLocalPlayerToActor(Actor TheActor)
{
	local PlayerController PC;
	local float MyDist;

	// End:0x11
	if(ViewTarget == none)
	{
		return false;
	}
	MyDist = VSize(ViewTarget.Location - TheActor.Location);
	// End:0x118
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x117
		if(((PC != self) && PC.ViewTarget != none) && VSize(PC.ViewTarget.Location - TheActor.Location) < MyDist)
		{			
			return false;
		}		
	}	
	return true;
	//return ReturnValue;	
}

reliable client simulated event Kismet_ClientPlaySound(SoundCue ASound, Actor SourceActor, float VolumeMultiplier, float PitchMultiplier, float FadeInTime, bool bSuppressSubtitles, bool bSuppressSpatialization)
{
	local AudioComponent AC;

	// End:0x237
	if((SourceActor != none) && IsClosestLocalPlayerToActor(SourceActor))
	{
		// End:0xD7
		if((ASound.FaceFXAnimName != "") && SourceActor.PlayActorFaceFXAnim(ASound.FaceFXAnimSetRef, ASound.FaceFXGroupName, ASound.FaceFXAnimName, ASound, none))
		{			
		}
		else
		{
			AC = SourceActor.CreateAudioComponent(ASound, false, true);
			// End:0x237
			if(AC != none)
			{
				AC.VolumeMultiplier = VolumeMultiplier;
				AC.PitchMultiplier = PitchMultiplier;
				AC.bAutoDestroy = true;
				AC.SubtitlePriority = 10000.0000000;
				AC.bSuppressSubtitles = bSuppressSubtitles;
				AC.FadeIn(FadeInTime, 1.0000000);
				// End:0x237
				if(bSuppressSpatialization)
				{
					AC.bAllowSpatialization = false;
				}
			}
		}
	}
	//return;	
}

reliable client simulated event Kismet_ClientStopSound(SoundCue ASound, Actor SourceActor, float FadeOutTime)
{
	local AudioComponent AC, CheckAC;

	// End:0x22
	if(SourceActor == none)
	{
		SourceActor = WorldInfo;
	}
	// End:0x99
	foreach SourceActor.AllOwnedComponents(Class'Engine.AudioComponent', CheckAC)
	{
		// End:0x98
		if(CheckAC.SoundCue == ASound)
		{
			AC = CheckAC;
			// End:0x99
			break;
		}		
	}	
	// End:0xD6
	if(AC != none)
	{
		AC.FadeOut(FadeOutTime, 0.0000000);
	}
	//return;	
}

reliable client simulated function ClientPlayActorFaceFXAnim(Actor SourceActor, FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay, AkEvent AkEventToPlay)
{
	// End:0x5B
	if(SourceActor != none)
	{
		SourceActor.PlayActorFaceFXAnim(AnimSet, GroupName, SeqName, SoundCueToPlay, AkEventToPlay);
	}
	//return;	
}

reliable client simulated event ClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
	// End:0x53
	if((WorldInfo.NetMode == NM_DedicatedServer) || WorldInfo.GRI == none)
	{
		return;
	}
	// End:0x7D
	if(Type == 'None')
	{
		Type = 'Event';
	}
	TeamMessage(PlayerReplicationInfo, S, Type, MsgLifeTime);
	//return;	
}

private final simulated function bool CanCommunicate()
{
	return true;
	//return ReturnValue;	
}

private final simulated function bool AllowTTSMessageFrom(PlayerReplicationInfo PRI)
{
	return true;
	//return ReturnValue;	
}

// Export UPlayerController::execCreateTTSSoundCue(FFrame&, void* const)
private native final simulated function SoundCue CreateTTSSoundCue(string StrToSpeak, PlayerReplicationInfo PRI);

exec function Talk()
{
	local Console PlayerConsole;
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0xE0
	if(((LP != none) && CanCommunicate()) && LP.ViewportClient.ViewportConsole != none)
	{
		PlayerConsole = LocalPlayer(Player).ViewportClient.ViewportConsole;
		PlayerConsole.StartTyping("Say ");
	}
	//return;	
}

exec function TeamTalk()
{
	local Console PlayerConsole;
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0xE4
	if(((LP != none) && CanCommunicate()) && LP.ViewportClient.ViewportConsole != none)
	{
		PlayerConsole = LocalPlayer(Player).ViewportClient.ViewportConsole;
		PlayerConsole.StartTyping("TeamSay ");
	}
	//return;	
}

simulated function SpeakTTS(coerce string S, optional PlayerReplicationInfo PRI)
{
	local SoundCue Cue;
	local AudioComponent AC;

	Cue = CreateTTSSoundCue(S, PRI);
	// End:0xB9
	if(Cue != none)
	{
		AC = CreateAudioComponent(Cue, false, true,,, true);
		AC.bAllowSpatialization = false;
		AC.bAutoDestroy = true;
		AC.Play();
	}
	//return;	
}

reliable client simulated event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime)
{
	local bool bIsUserCreated;

	// End:0x21F
	if(CanCommunicate())
	{
		// End:0xB0
		if((((Type == 'Say') || Type == 'TeamSay') && PRI != none) && AllowTTSMessageFrom(PRI))
		{
			// End:0xB0
			if(!bIsUserCreated || bIsUserCreated && CanViewUserCreatedContent())
			{
				SpeakTTS(S, PRI);
			}
		}
		// End:0x102
		if(myHUD != none)
		{
			myHUD.Message(PRI, S, Type, MsgLifeTime);
		}
		// End:0x188
		if(((Type == 'Say') || Type == 'TeamSay') && PRI != none)
		{
			S = (PRI.PlayerName $ ": ") $ S;
			bIsUserCreated = true;
		}
		// End:0x21F
		if(Player != none)
		{
			// End:0x21F
			if(!bIsUserCreated || bIsUserCreated && CanViewUserCreatedContent())
			{
				LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText(S);
			}
		}
	}
	//return;	
}

function PlayBeepSound()
{
	//return;	
}

function RegisterOnlineDelegates()
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0x2C1
	if((OnlineSub != none) && LP != none)
	{
		VoiceInterface = OnlineSub.VoiceInterface;
		// End:0x125
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, none))
		{
			OnlineSub.SystemInterface.AddExternalUIChangeDelegate(OnExternalUIChanged);
			OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChanged);
		}
		// End:0x1C0
		if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
		{
			OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(byte(LP.ControllerId), OnGameInviteAccepted);
		}
		// End:0x2C1
		if(NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, none))
		{
			OnlineSub.PartyChatInterface.AddPartyMemberListChangedDelegate(byte(LP.ControllerId), OnPartyMemberListChanged);
			OnlineSub.PartyChatInterface.AddPartyMembersInfoChangedDelegate(byte(LP.ControllerId), OnPartyMembersInfoChanged);
		}
	}
	//return;	
}

function OnPartyMemberListChanged(bool bJoinedOrLeft, string PlayerName, UniqueNetId PlayerID)
{
	//return;	
}

function OnPartyMembersInfoChanged(string PlayerName, UniqueNetId PlayerID, int CustomData1, int CustomData2, int CustomData3, int CustomData4)
{
	//return;	
}

event ClearOnlineDelegates()
{
	local LocalPlayer LP;

	LogInternal((((("Clearing online delegates for" @ string(self)) @ "(") $ "Player:") $ ((Player != none) ? string(Player.Name) : "None")) $ ")", 'DevOnline');
	LP = LocalPlayer(Player);
	// End:0x339
	if((Role < ROLE_Authority) || LP != none)
	{
		// End:0x339
		if(OnlineSub != none)
		{
			// End:0x18E
			if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, none))
			{
				OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnExternalUIChanged);
				OnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChanged);
			}
			// End:0x339
			if(LP != none)
			{
				// End:0x238
				if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
				{
					OnlineSub.GameInterface.ClearGameInviteAcceptedDelegate(byte(LP.ControllerId), OnGameInviteAccepted);
				}
				// End:0x339
				if(NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, none))
				{
					OnlineSub.PartyChatInterface.ClearPartyMemberListChangedDelegate(byte(LP.ControllerId), OnPartyMemberListChanged);
					OnlineSub.PartyChatInterface.ClearPartyMembersInfoChangedDelegate(byte(LP.ControllerId), OnPartyMembersInfoChanged);
				}
			}
		}
	}
	//return;	
}

function CleanupPawn()
{
	local Vehicle DrivenVehicle;
	local Pawn Driver;

	DrivenVehicle = Vehicle(Pawn);
	// End:0xEC
	if(DrivenVehicle != none)
	{
		Driver = DrivenVehicle.Driver;
		DrivenVehicle.DriverLeave(true);
		// End:0xE9
		if(Driver != none)
		{
			Driver.Health = 0;
			Driver.Died(self, Class'Engine.DmgType_Suicided', Driver.Location);
		}		
	}
	else
	{
		// End:0x162
		if(Pawn != none)
		{
			Pawn.Health = 0;
			Pawn.Died(self, Class'Engine.DmgType_Suicided', Pawn.Location);
		}
	}
	//return;	
}

event Destroyed()
{
	local int EffectIdx;
	local LocalPlayer LPlayer;
	local MaterialEffect Effect;
	local MaterialInstanceConstant MIC;

	ClientPlayForceFeedbackWaveform(none, none);
	// End:0x44
	if((Role < ROLE_Authority) || LocalPlayer(Player) != none)
	{
		ClearOnlineDelegates();
	}
	// End:0x5D
	if(Pawn != none)
	{
		CleanupPawn();
	}
	// End:0x8F
	if(myHUD != none)
	{
		myHUD.Destroy();
		myHUD = none;
	}
	// End:0xC1
	if(PlayerCamera != none)
	{
		PlayerCamera.Destroy();
		PlayerCamera = none;
	}
	ForceClearUnpauseDelegates();
	UnregisterPlayerDataStores();
	LPlayer = LocalPlayer(Player);
	// End:0x2A9
	if((LPlayer != none) && LPlayer.PlayerPostProcess != none)
	{
		EffectIdx = 0;
		J0x131:

		// End:0x2A9 [Loop If]
		if(EffectIdx < LPlayer.PlayerPostProcess.Effects.Length)
		{
			Effect = MaterialEffect(LPlayer.PlayerPostProcess.Effects[EffectIdx]);
			// End:0x29B
			if((Effect != none) && Effect.Material != none)
			{
				MIC = MaterialInstanceConstant(Effect.Material);
				// End:0x29B
				if((MIC != none) && MIC.Parent != none)
				{
					Effect.Material = MIC.Parent;
				}
			}
			EffectIdx++;
			// [Loop Continue]
			goto J0x131;
		}
	}
	super.Destroyed();
	//return;	
}

function FixFOV()
{
	FOVAngle = default.DefaultFOV;
	DesiredFOV = default.DefaultFOV;
	DefaultFOV = default.DefaultFOV;
	//return;	
}

function SetFOV(float NewFOV)
{
	DesiredFOV = NewFOV;
	FOVAngle = NewFOV;
	//return;	
}

function ResetFOV()
{
	DesiredFOV = DefaultFOV;
	FOVAngle = DefaultFOV;
	//return;	
}

exec function FOV(float F)
{
	// End:0x39
	if(PlayerCamera != none)
	{
		PlayerCamera.SetFOV(F);
		return;
	}
	// End:0xCD
	if(((F >= 80.0000000) || WorldInfo.NetMode == NM_Standalone) || PlayerReplicationInfo.bOnlySpectator)
	{
		DefaultFOV = FClamp(F, 80.0000000, 100.0000000);
		DesiredFOV = DefaultFOV;
	}
	//return;	
}

exec function Mutate(string MutateString)
{
	ServerMutate(MutateString);
	//return;	
}

reliable server function ServerMutate(string MutateString)
{
	// End:0x2B
	if(WorldInfo.NetMode == NM_Client)
	{
		return;
	}
	WorldInfo.Game.Mutate(MutateString, self);
	//return;	
}

function bool AllowTextMessage(string msg)
{
	local int I;

	// End:0x4F
	if((WorldInfo.NetMode == NM_Standalone) || PlayerReplicationInfo.bAdmin)
	{
		return true;
	}
	// End:0xA9
	if((WorldInfo.Pauser == none) && (WorldInfo.TimeSeconds - LastBroadcastTime) < float(2))
	{
		return false;
	}
	// End:0x151
	if((WorldInfo.TimeSeconds - LastBroadcastTime) < float(5))
	{
		msg = Left(msg, Clamp(Len(msg) - 4, 8, 64));
		I = 0;
		J0x110:

		// End:0x151 [Loop If]
		if(I < 4)
		{
			// End:0x143
			if(LastBroadcastString[I] ~= msg)
			{
				return false;
			}
			I++;
			// [Loop Continue]
			goto J0x110;
		}
	}
	I = 3;
	J0x15D:

	// End:0x1A4 [Loop If]
	if(I > 0)
	{
		LastBroadcastString[I] = LastBroadcastString[I - 1];
		I--;
		// [Loop Continue]
		goto J0x15D;
	}
	LastBroadcastTime = WorldInfo.TimeSeconds;
	return true;
	//return ReturnValue;	
}

exec function Say(string msg)
{
	msg = Left(msg, 128);
	// End:0x40
	if(AllowTextMessage(msg))
	{
		ServerSay(msg);
	}
	//return;	
}

unreliable server function ServerSay(string msg)
{
	local PlayerController PC;

	// End:0xBB
	if(PlayerReplicationInfo.bAdmin && Left(msg, 1) == "#")
	{
		msg = Right(msg, Len(msg) - 1);
		// End:0xB8
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			PC.ClientAdminMessage(msg);			
		}		
		return;
	}
	WorldInfo.Game.Broadcast(self, msg, 'Say');
	//return;	
}

reliable client simulated function ClientAdminMessage(string msg)
{
	local LocalPlayer LP;

	LP = LocalPlayer(Player);
	// End:0xD9
	if(LP != none)
	{
		LP.ViewportClient.ClearProgressMessages();
		LP.ViewportClient.SetProgressTime(6.0000000);
		LP.ViewportClient.SetProgressMessage(2, msg);
	}
	//return;	
}

exec function TeamSay(string msg)
{
	msg = Left(msg, 128);
	// End:0x40
	if(AllowTextMessage(msg))
	{
		ServerTeamSay(msg);
	}
	//return;	
}

unreliable server function ServerTeamSay(string msg)
{
	LastActiveTime = WorldInfo.TimeSeconds;
	// End:0x8B
	if(!WorldInfo.GRI.GameClass.default.bTeamGame)
	{
		Say(msg);
		return;
	}
	WorldInfo.Game.BroadcastTeam(self, msg, 'TeamSay');
	//return;	
}

event PreClientTravel(string PendingURL, Actor.ETravelType TravelType, bool bIsSeamlessTravel)
{
	local UIInteraction UIController;
	local GameUISceneClient GameSceneClient;

	UIController = GetUIController();
	// End:0xEF
	if((UIController != none) && IsPrimaryPlayer())
	{
		GameSceneClient = UIController.SceneClient;
		// End:0xA5
		if(GameSceneClient != none)
		{
			GameSceneClient.NotifyClientTravel(self, PendingURL, TravelType, bIsSeamlessTravel);
		}
		// End:0xEF
		if(PlayerInput != none)
		{
			PlayerInput.PreClientTravel(PendingURL, TravelType, bIsSeamlessTravel);
		}
	}
	//return;	
}

exec function Camera(name NewMode)
{
	ServerCamera(NewMode);
	//return;	
}

reliable server function ServerCamera(name NewMode)
{
	// End:0x2D
	if(NewMode == '1st')
	{
		NewMode = 'FirstPerson';		
	}
	else
	{
		// End:0x57
		if(NewMode == '3rd')
		{
			NewMode = 'ThirdPerson';
		}
	}
	SetCameraMode(NewMode);
	// End:0xA5
	if(PlayerCamera != none)
	{
		LogInternal("#### " $ string(PlayerCamera.CameraStyle));
	}
	//return;	
}

reliable client simulated function ClientSetCameraMode(name NewCamMode)
{
	// End:0x37
	if(PlayerCamera != none)
	{
		PlayerCamera.CameraStyle = NewCamMode;
	}
	//return;	
}

function SetCameraMode(name NewCamMode)
{
	// End:0x73
	if(PlayerCamera != none)
	{
		PlayerCamera.CameraStyle = NewCamMode;
		// End:0x73
		if(WorldInfo.NetMode == NM_DedicatedServer)
		{
			ClientSetCameraMode(NewCamMode);
		}
	}
	//return;	
}

event ResetCameraMode()
{
	// End:0x3C
	if(Pawn != none)
	{
		SetCameraMode(Pawn.GetDefaultCameraMode(self));		
	}
	else
	{
		SetCameraMode('FirstPerson');
	}
	//return;	
}

reliable client simulated event ClientSetCameraFade(bool bEnableFading, optional Color FadeColor, optional Vector2D FadeAlpha, optional float FadeTime, optional bool bFadeAudio)
{
	// End:0x1E5
	if(PlayerCamera != none)
	{
		PlayerCamera.bEnableFading = bEnableFading;
		// End:0x12C
		if(PlayerCamera.bEnableFading)
		{
			PlayerCamera.FadeColor = FadeColor;
			PlayerCamera.FadeAlpha = FadeAlpha;
			PlayerCamera.FadeTime = FadeTime;
			PlayerCamera.FadeTimeRemaining = FadeTime;
			PlayerCamera.bFadeAudio = bFadeAudio;			
		}
		else
		{
			PlayerCamera.FadeAmount = PlayerCamera.FadeAlpha.Y;
			PlayerCamera.FadeColor = FadeColor;
			// End:0x1E5
			if(PlayerCamera.bFadeAudio)
			{
				PlayerCamera.ApplyAudioFade();
			}
		}
	}
	//return;	
}

function bool UsingFirstPersonCamera()
{
	return ((PlayerCamera == none) || PlayerCamera.CameraStyle == 'FirstPerson') && LocalPlayer(Player) != none;
	//return ReturnValue;	
}

function ForceDeathUpdate()
{
	LastUpdateTime = WorldInfo.TimeSeconds - float(10);
	//return;	
}

unreliable server function DualServerMove(float TimeStamp0, Vector InAccel0, byte PendingFlags, int View0, float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
{
	ServerMove(TimeStamp0, InAccel0, vect(1.0000000, 2.0000000, 3.0000000), PendingFlags, ClientRoll, View0);
	ServerMove(TimeStamp, InAccel, ClientLoc, NewFlags, ClientRoll, View);
	//return;	
}

unreliable server function OldServerMove(float OldTimeStamp, byte OldAccelX, byte OldAccelY, byte OldAccelZ, byte OldMoveFlags)
{
	local Vector Accel;

	// End:0x19
	if(AcknowledgedPawn != Pawn)
	{
		return;
	}
	// End:0x278
	if(CurrentTimeStamp < (OldTimeStamp - 0.0010000))
	{
		Accel.X = float(OldAccelX);
		// End:0xCA
		if(Accel.X > float(127))
		{
			Accel.X = -1.0000000 * (Accel.X - float(128));
		}
		Accel.Y = float(OldAccelY);
		// End:0x15D
		if(Accel.Y > float(127))
		{
			Accel.Y = -1.0000000 * (Accel.Y - float(128));
		}
		Accel.Z = float(OldAccelZ);
		// End:0x1F0
		if(Accel.Z > float(127))
		{
			Accel.Z = -1.0000000 * (Accel.Z - float(128));
		}
		Accel *= float(20);
		OldTimeStamp = FMin(OldTimeStamp, CurrentTimeStamp + MaxResponseTime);
		MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldMoveFlags, Accel, rot(0, 0, 0));
		CurrentTimeStamp = OldTimeStamp;
	}
	//return;	
}

function float GetServerMoveDeltaTime(float TimeStamp)
{
	local float DeltaTime;

	DeltaTime = FMin(MaxResponseTime, TimeStamp - CurrentTimeStamp);
	// End:0x51
	if(Pawn == none)
	{
		bWasSpeedHack = false;
		ResetTimeMargin();		
	}
	else
	{
		// End:0x185
		if(!CheckSpeedHack(DeltaTime))
		{
			// End:0x13B
			if(!bWasSpeedHack)
			{
				// End:0x10E
				if((WorldInfo.TimeSeconds - LastSpeedHackLog) > float(20))
				{
					LogInternal("Possible speed hack by " $ PlayerReplicationInfo.PlayerName);
					LastSpeedHackLog = WorldInfo.TimeSeconds;
				}
				ClientMessage("Speed Hack Detected!", 'CriticalEvent');				
			}
			else
			{
				bWasSpeedHack = true;
			}
			DeltaTime = 0.0000000;
			Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);			
		}
		else
		{
			DeltaTime *= Pawn.CustomTimeDilation;
			bWasSpeedHack = false;
		}
	}
	return DeltaTime;
	//return ReturnValue;	
}

function ServerMoveHandleClientError(float TimeStamp, Vector Accel, Vector ClientLoc)
{
	local float ClientErr;
	local Vector LocDiff;

	// End:0x20
	if(ClientLoc == vect(1.0000000, 2.0000000, 3.0000000))
	{
		return;		
	}
	else
	{
		// End:0x77
		if((WorldInfo.TimeSeconds - LastUpdateTime) < (180.0000000 / float(Player.CurrentNetSpeed)))
		{
			return;
		}
	}
	// End:0xA7
	if(Pawn == none)
	{
		LocDiff = Location - ClientLoc;		
	}
	else
	{
		// End:0x123
		if(Pawn.bForceRMVelocity && int(Pawn.default.Mesh.RootMotionMode) == 2)
		{
			LocDiff = vect(0.0000000, 0.0000000, 0.0000000);			
		}
		else
		{
			// End:0x1AC
			if(((int(Pawn.Physics) != 0) && (WorldInfo.TimeSeconds - LastUpdateTime) > 1.0000000) && IsZero(Accel))
			{
				LocDiff = vect(1000.0000000, 1000.0000000, 1000.0000000);				
			}
			else
			{
				LocDiff = Pawn.Location - ClientLoc;
			}
		}
	}
	ClientErr = LocDiff Dot LocDiff;
	// End:0x529
	if(ClientErr > 3.0000000)
	{
		// End:0x294
		if(Pawn == none)
		{
			PendingAdjustment.newPhysics = Physics;
			PendingAdjustment.NewLoc = Location;
			PendingAdjustment.NewVel = Velocity;			
		}
		else
		{
			PendingAdjustment.newPhysics = Pawn.Physics;
			PendingAdjustment.NewVel = Pawn.Velocity;
			PendingAdjustment.NewBase = Pawn.Base;
			// End:0x443
			if(((InterpActor(Pawn.Base) != none) || Vehicle(Pawn.Base) != none) || DynamicBlockingVolume(Pawn.Base) != none)
			{
				PendingAdjustment.NewLoc = Pawn.Location - Pawn.Base.Location;				
			}
			else
			{
				PendingAdjustment.NewLoc = Pawn.Location;
			}
			PendingAdjustment.NewFloor = Pawn.Floor;
		}
		LastUpdateTime = WorldInfo.TimeSeconds;
		PendingAdjustment.TimeStamp = TimeStamp;
		PendingAdjustment.bAckGoodMove = 0;		
	}
	else
	{
		PendingAdjustment.TimeStamp = TimeStamp;
		PendingAdjustment.bAckGoodMove = 1;
	}
	//return;	
}

unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
{
	local float DeltaTime;
	local Rotator DeltaRot, Rot, ViewRot;
	local Vector Accel;
	local int MaxPitch, ViewPitch, ViewYaw;

	// End:0x19
	if(CurrentTimeStamp >= TimeStamp)
	{
		return;
	}
	// End:0x5A
	if(AcknowledgedPawn != Pawn)
	{
		InAccel = vect(0.0000000, 0.0000000, 0.0000000);
		GivePawn(Pawn);
	}
	ViewPitch = View & 65535;
	ViewYaw = View >> 16;
	Accel = InAccel * 0.1000000;
	DeltaTime = GetServerMoveDeltaTime(TimeStamp);
	CurrentTimeStamp = TimeStamp;
	ServerTimeStamp = WorldInfo.TimeSeconds;
	ViewRot.Pitch = ViewPitch;
	ViewRot.Yaw = ViewYaw;
	ViewRot.Roll = 0;
	// End:0x1AA
	if(InAccel != vect(0.0000000, 0.0000000, 0.0000000))
	{
		LastActiveTime = WorldInfo.TimeSeconds;
	}
	SetRotation(ViewRot);
	// End:0x1CF
	if(AcknowledgedPawn != Pawn)
	{
		return;
	}
	// End:0x43A
	if(Pawn != none)
	{
		Rot.Roll = 256 * int(ClientRoll);
		Rot.Yaw = ViewYaw;
		// End:0x296
		if((int(Pawn.Physics) == 3) || int(Pawn.Physics) == 4)
		{
			MaxPitch = 2;			
		}
		else
		{
			MaxPitch = 0;
		}
		// End:0x3C4
		if((ViewPitch > (MaxPitch * Pawn.MaxPitchLimit)) && ViewPitch < (65536 - (MaxPitch * Pawn.MaxPitchLimit)))
		{
			// End:0x374
			if(ViewPitch < 32768)
			{
				Rot.Pitch = MaxPitch * Pawn.MaxPitchLimit;				
			}
			else
			{
				Rot.Pitch = 65536 - (MaxPitch * Pawn.MaxPitchLimit);
			}			
		}
		else
		{
			Rot.Pitch = ViewPitch;
		}
		DeltaRot = Rotation - Rot;
		Pawn.FaceRotation(Rot, DeltaTime);
	}
	// End:0x49F
	if((WorldInfo.Pauser == none) && DeltaTime > float(0))
	{
		MoveAutonomous(DeltaTime, MoveFlags, Accel, DeltaRot);
	}
	ServerMoveHandleClientError(TimeStamp, Accel, ClientLoc);
	//return;	
}

event SendClientAdjustment()
{
	// End:0x3B
	if(AcknowledgedPawn != Pawn)
	{
		PendingAdjustment.TimeStamp = 0.0000000;
		return;
	}
	// End:0x8B
	if(int(PendingAdjustment.bAckGoodMove) == 1)
	{
		ClientAckGoodMove(PendingAdjustment.TimeStamp);		
	}
	else
	{
		// End:0x481
		if((Pawn == none) || int(Pawn.Physics) != 8)
		{
			// End:0x303
			if(PendingAdjustment.NewVel == vect(0.0000000, 0.0000000, 0.0000000))
			{
				// End:0x212
				if(((GetStateName() == 'PlayerWalking') && Pawn != none) && int(Pawn.Physics) == 1)
				{
					VeryShortClientAdjustPosition(PendingAdjustment.TimeStamp, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewBase);					
				}
				else
				{
					ShortClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewBase);
				}				
			}
			else
			{
				ClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z, PendingAdjustment.NewBase);
			}			
		}
		else
		{
			LongClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z, PendingAdjustment.NewBase, PendingAdjustment.NewFloor.X, PendingAdjustment.NewFloor.Y, PendingAdjustment.NewFloor.Z);
		}
	}
	PendingAdjustment.TimeStamp = 0.0000000;
	PendingAdjustment.bAckGoodMove = 0;
	//return;	
}

unreliable server function ServerDrive(float InForward, float InStrafe, float aUp, bool InJump, int View)
{
	local Rotator ViewRotation;

	ViewRotation.Pitch = View & 65535;
	ViewRotation.Yaw = View >> 16;
	ViewRotation.Roll = 0;
	SetRotation(ViewRotation);
	ProcessDrive(InForward, InStrafe, aUp, InJump);
	//return;	
}

function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
	ClientGotoState(GetStateName(), 'Begin');
	//return;	
}

function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
	// End:0x65
	if((Pawn != none) && Pawn.Acceleration != newAccel)
	{
		Pawn.Acceleration = newAccel;
	}
	//return;	
}

function MoveAutonomous(float DeltaTime, byte CompressedFlags, Vector newAccel, Rotator DeltaRot)
{
	local Actor.EDoubleClickDir DoubleClickMove;

	// End:0x35
	if((Pawn != none) && Pawn.bHardAttach)
	{
		return;
	}
	DoubleClickMove = SavedMoveClass.static.SetFlags(CompressedFlags, self);
	HandleWalking();
	ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
	// End:0xD3
	if(Pawn != none)
	{
		Pawn.AutonomousPhysics(DeltaTime);		
	}
	else
	{
		AutonomousPhysics(DeltaTime);
	}
	bDoubleJump = false;
	//return;	
}

unreliable client simulated function VeryShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
	local Vector Floor;

	// End:0x37
	if(Pawn != none)
	{
		Floor = Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp, 'PlayerWalking', 1, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
	//return;	
}

unreliable client simulated function ShortClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
	local Vector Floor;

	// End:0x37
	if(Pawn != none)
	{
		Floor = Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
	//return;	
}

reliable client simulated function ClientCapBandwidth(int Cap)
{
	ClientCap = Cap;
	// End:0x63
	if((Player != none) && Player.CurrentNetSpeed > Cap)
	{
		SetNetSpeed(Cap);
	}
	//return;	
}

unreliable client simulated function ClientAckGoodMove(float TimeStamp)
{
	UpdatePing(TimeStamp);
	CurrentTimeStamp = TimeStamp;
	ClearAckedMoves();
	//return;	
}

unreliable client simulated function ClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local Vector Floor;

	// End:0x37
	if(Pawn != none)
	{
		Floor = Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, Floor.X, Floor.Y, Floor.Z);
	//return;	
}

final function UpdatePing(float TimeStamp)
{
	// End:0xC4
	if(PlayerReplicationInfo != none)
	{
		PlayerReplicationInfo.UpdatePing(TimeStamp);
		// End:0xC4
		if((WorldInfo.TimeSeconds - LastPingUpdate) > float(4))
		{
			LastPingUpdate = WorldInfo.TimeSeconds;
			ServerUpdatePing(int(float(1000) * PlayerReplicationInfo.ExactPing));
		}
	}
	//return;	
}

function bool SkipPositionUpdateForRM()
{
	local SavedMove CurrentMove;

	// End:0x1EE
	if((Pawn != none) && int(Pawn.default.Mesh.RootMotionMode) == 2)
	{
		// End:0x13D
		if((((int(Pawn.Physics) != 2) && Pawn.Mesh != none) && int(Pawn.Mesh.RootMotionMode) != 2) && !Pawn.bRootMotionFromInterpCurve)
		{
			LogInternal("- skipping position update for root motion", 'PlayerMove');
			return true;
		}
		CurrentMove = SavedMoves;
		J0x150:

		// End:0x1EE [Loop If]
		if(CurrentMove != none)
		{
			// End:0x1C3
			if(CurrentMove.bForceRMVelocity)
			{
				LogInternal("- skipping position update for upcoming root motion", 'PlayerMove');
				return true;
			}
			CurrentMove = CurrentMove.NextMove;
			// [Loop Continue]
			goto J0x150;
		}
	}
	return false;
	//return ReturnValue;	
}

unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
	local Vector NewLocation, NewVelocity, NewFloor;
	local Actor MoveActor;
	local SavedMove CurrentMove;
	local Actor TheViewTarget;
	local Vector OldLoc;

	OldLoc = ((Pawn != none) ? Pawn.Location : Location);
	UpdatePing(TimeStamp);
	// End:0x17D
	if(Pawn != none)
	{
		// End:0xC4
		if(Pawn.bTearOff)
		{
			Pawn = none;
			// End:0xC2
			if(!GamePlayEndedState() && !IsInState('Dead'))
			{
				GotoState('Dead');
			}
			return;
		}
		MoveActor = Pawn;
		TheViewTarget = GetViewTarget();
		// End:0x17A
		if((TheViewTarget != Pawn) && (TheViewTarget == self) || (Pawn(TheViewTarget) != none) && Pawn(TheViewTarget).Health <= 0)
		{
			ResetCameraMode();
			SetViewTarget(Pawn);
		}		
	}
	else
	{
		MoveActor = self;
		// End:0x26F
		if(GetStateName() != NewState)
		{
			LogInternal((("- state change:" @ string(GetStateName())) @ "->") @ string(NewState), 'PlayerMove');
			// End:0x1F7
			if(NewState == 'RoundEnded')
			{
				GotoState(NewState);				
			}
			else
			{
				// End:0x24A
				if(IsInState('Dead'))
				{
					// End:0x245
					if((NewState != 'PlayerWalking') && NewState != 'PlayerSwimming')
					{
						GotoState(NewState);
					}
					return;					
				}
				else
				{
					// End:0x26F
					if(NewState == 'Dead')
					{
						GotoState(NewState);
					}
				}
			}
		}
	}
	// End:0x288
	if(CurrentTimeStamp >= TimeStamp)
	{
		return;
	}
	CurrentTimeStamp = TimeStamp;
	NewLocation.X = NewLocX;
	NewLocation.Y = NewLocY;
	NewLocation.Z = NewLocZ;
	NewVelocity.X = NewVelX;
	NewVelocity.Y = NewVelY;
	NewVelocity.Z = NewVelZ;
	CurrentMove = SavedMoves;
	J0x392:

	// End:0x7AD [Loop If]
	if(CurrentMove != none)
	{
		// End:0x79F
		if(CurrentMove.TimeStamp <= CurrentTimeStamp)
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			// End:0x76A
			if(CurrentMove.TimeStamp == CurrentTimeStamp)
			{
				LastAckedAccel = CurrentMove.Acceleration;
				FreeMoves.Clear();
				// End:0x668
				if((((InterpActor(NewBase) != none) || Vehicle(NewBase) != none) || DynamicBlockingVolume(NewBase) != none) && NewBase == CurrentMove.EndBase)
				{
					// End:0x665
					if(((GetStateName() == NewState) && IsInState('PlayerWalking')) && (int(MoveActor.Physics) == 1) || int(MoveActor.Physics) == 2)
					{
						// End:0x5DB
						if(VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 3.0000000)
						{
							CurrentMove = none;
							return;							
						}
						else
						{
							// End:0x665
							if((((Vehicle(NewBase) != none) && VSizeSq(Velocity) < 9.0000000) && VSizeSq(NewVelocity) < 9.0000000) && VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 900.0000000)
							{
								CurrentMove = none;
								return;
							}
						}
					}					
				}
				else
				{
					// End:0x75C
					if(((((VSizeSq(CurrentMove.SavedLocation - NewLocation) < 3.0000000) && VSizeSq(CurrentMove.SavedVelocity - NewVelocity) < 9.0000000) && GetStateName() == NewState) && IsInState('PlayerWalking')) && (int(MoveActor.Physics) == 1) || int(MoveActor.Physics) == 2)
					{
						CurrentMove = none;
						return;
					}
				}
				CurrentMove = none;				
			}
			else
			{
				FreeMoves.Clear();
				CurrentMove = SavedMoves;
			}			
		}
		else
		{
			CurrentMove = none;
		}
		// [Loop Continue]
		goto J0x392;
	}
	// End:0x8EF
	if(MoveActor.bHardAttach)
	{
		// End:0x8ED
		if((MoveActor.Base == none) || MoveActor.Base.bWorldGeometry)
		{
			// End:0x8A1
			if(NewBase != none)
			{
				MoveActor.SetLocation(NewLocation);
				MoveActor.SetPhysics(newPhysics);
				MoveActor.SetBase(NewBase);
			}
			// End:0x8E8
			if(MoveActor.Base == none)
			{
				MoveActor.SetHardAttach(false);				
			}
			else
			{
				return;
			}			
		}
		else
		{
			return;
		}
	}
	NewFloor.X = NewFloorX;
	NewFloor.Y = NewFloorY;
	NewFloor.Z = NewFloorZ;
	// End:0x9D9
	if(MoveActor.Base != NewBase)
	{
		LogInternal(("- base mismatch:" @ string(MoveActor.Base)) @ string(NewBase), 'PlayerMove');
	}
	// End:0xA5C
	if(MoveActor.Location != NewLocation)
	{
		LogInternal("- location mismatch, delta:" @ string(VSize(MoveActor.Location - NewLocation)), 'PlayerMove');
	}
	// End:0xB28
	if(MoveActor.Velocity != NewVelocity)
	{
		LogInternal((((("- velocity mismatch, delta:" @ string(VSize(NewVelocity - MoveActor.Velocity))) @ "client:") @ string(VSize(MoveActor.Velocity))) @ "server:") @ string(VSize(NewVelocity)), 'PlayerMove');
	}
	// End:0xB37
	if(SkipPositionUpdateForRM())
	{
		return;
	}
	// End:0xBAC
	if(((InterpActor(NewBase) != none) || Vehicle(NewBase) != none) || DynamicBlockingVolume(NewBase) != none)
	{
		NewLocation += NewBase.Location;
	}
	MoveActor.bCanTeleport = false;
	// End:0xE00
	if(((((!MoveActor.SetLocation(NewLocation) && Pawn(MoveActor) != none) && Pawn(MoveActor).CylinderComponent.CollisionHeight > Pawn(MoveActor).CrouchHeight) && !Pawn(MoveActor).bIsCrouched) && int(newPhysics) == 1) && int(MoveActor.Physics) != 10)
	{
		MoveActor.SetPhysics(newPhysics);
		// End:0xDB2
		if(!MoveActor.SetLocation(NewLocation + (vect(0.0000000, 0.0000000, 1.0000000) * Pawn(MoveActor).MaxStepHeight)))
		{
			Pawn(MoveActor).ForceCrouch();
			MoveActor.SetLocation(NewLocation);			
		}
		else
		{
			MoveActor.MoveSmooth(vect(0.0000000, 0.0000000, -1.0000000) * Pawn(MoveActor).MaxStepHeight);
		}
	}
	MoveActor.bCanTeleport = true;
	// End:0xE81
	if((int(MoveActor.Physics) != 10) && int(newPhysics) != 10)
	{
		MoveActor.SetPhysics(newPhysics);
	}
	// End:0xEBC
	if(MoveActor != self)
	{
		MoveActor.SetBase(NewBase, NewFloor);
	}
	MoveActor.Velocity = NewVelocity;
	UpdateStateFromAdjustment(NewState);
	bUpdatePosition = true;
	// End:0x108B
	if(bDebugClientAdjustPosition)
	{
		DrawDebugBox(OldLoc, vect(2.0000000, 2.0000000, 2.0000000), 0, 120, 0, true);
		DrawDebugBox(Pawn.Location, vect(3.0000000, 3.0000000, 3.0000000), 255, 255, 255, true);
		DrawDebugLine(Pawn.Location, OldLoc, 255, 255, 255, true);
		LogInternal((((((((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "!!!!!!!!!!!!!!") @ string(SavedMoves)) @ "Pawn.Rotation:'") $ string(Pawn.Rotation)) $ "'") @ "WorldInfo.TimeSeconds:'") $ string(WorldInfo.TimeSeconds)) $ "'");
	}
	//return;	
}

function UpdateStateFromAdjustment(name NewState)
{
	// End:0x1F
	if(GetStateName() != NewState)
	{
		GotoState(NewState);
	}
	//return;	
}

unreliable server function ServerUpdatePing(int NewPing)
{
	PlayerReplicationInfo.Ping = byte(Min(int(0.2500000 * float(NewPing)), 250));
	//return;	
}

function ClearAckedMoves()
{
	local SavedMove CurrentMove;

	CurrentMove = SavedMoves;
	J0x13:

	// End:0x140 [Loop If]
	if(CurrentMove != none)
	{
		// End:0x13A
		if(CurrentMove.TimeStamp <= CurrentTimeStamp)
		{
			// End:0xA2
			if(CurrentMove.TimeStamp == CurrentTimeStamp)
			{
				LastAckedAccel = CurrentMove.Acceleration;
			}
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = SavedMoves;			
		}
		else
		{
			// [Explicit Break]
			goto J0x140;
		}
		// [Loop Continue]
		goto J0x13;
	}
	J0x140:

	//return;	
}

function ClientUpdatePosition()
{
	local SavedMove CurrentMove;
	local int realbRun, realbDuck;
	local bool bRealJump, bRealPreciseDestination, bRealForceMaxAccel, bRealRootMotionFromInterpCurve;
	local SkeletalMeshComponent.ERootMotionMode RealRootMotionMode;
	local Vector OldLoc;

	bUpdatePosition = false;
	// End:0x48
	if((Pawn != none) && int(Pawn.Physics) == 10)
	{
		return;
	}
	// End:0x135
	if(bDebugClientAdjustPosition)
	{
		LogInternal((((((((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "!!!!!!!!!!!!!!") @ string(SavedMoves)) @ "Pawn.Rotation:'") $ string(Pawn.Rotation)) $ "'") @ "WorldInfo.TimeSeconds:'") $ string(WorldInfo.TimeSeconds)) $ "'");
	}
	realbRun = int(bRun);
	realbDuck = int(bDuck);
	bRealJump = bPressedJump;
	bUpdating = true;
	bRealPreciseDestination = bPreciseDestination;
	// End:0x235
	if(Pawn != none)
	{
		bRealForceMaxAccel = Pawn.bForceMaxAccel;
		bRealRootMotionFromInterpCurve = Pawn.bRootMotionFromInterpCurve;
		RealRootMotionMode = Pawn.Mesh.RootMotionMode;
	}
	ClearAckedMoves();
	CurrentMove = SavedMoves;
	J0x252:

	// End:0x599 [Loop If]
	if(CurrentMove != none)
	{
		// End:0x2B1
		if((PendingMove == CurrentMove) && Pawn != none)
		{
			PendingMove.SetInitialPosition(Pawn);
		}
		// End:0x377
		if(bDebugClientAdjustPosition)
		{
			LogInternal(CurrentMove.GetDebugString());
			LogInternal((("Old" @ string(Pawn.Location)) @ string(Pawn.bRootMotionFromInterpCurve)) @ string(Pawn.RootMotionInterpCurrentTime));
			OldLoc = Pawn.Location;
		}
		CurrentMove.PrepMoveFor(Pawn);
		MoveAutonomous(CurrentMove.Delta, CurrentMove.CompressedFlags(), CurrentMove.Acceleration, rot(0, 0, 0));
		CurrentMove.ResetMoveFor(Pawn);
		// End:0x56E
		if(bDebugClientAdjustPosition)
		{
			LogInternal((("New" @ string(Pawn.Location)) @ string(Pawn.bRootMotionFromInterpCurve)) @ string(Pawn.RootMotionInterpCurrentTime));
			DrawDebugBox(OldLoc, vect(4.0000000, 4.0000000, 4.0000000), 120, 0, 0, true);
			DrawDebugBox(Pawn.Location, vect(5.0000000, 5.0000000, 5.0000000), 0, 0, 120, true);
			DrawDebugLine(OldLoc + vect(0.0000000, 0.0000000, 2.0000000), Pawn.Location + vect(0.0000000, 0.0000000, 2.0000000), 0, 120, 0, true);
		}
		CurrentMove = CurrentMove.NextMove;
		// [Loop Continue]
		goto J0x252;
	}
	bUpdating = false;
	bDuck = byte(realbDuck);
	bRun = byte(realbRun);
	bPressedJump = bRealJump;
	bPreciseDestination = bRealPreciseDestination;
	// End:0x699
	if(Pawn != none)
	{
		Pawn.bForceMaxAccel = bRealForceMaxAccel;
		Pawn.bRootMotionFromInterpCurve = bRealRootMotionFromInterpCurve;
		Pawn.Mesh.RootMotionMode = RealRootMotionMode;
	}
	//return;	
}

final function SavedMove GetFreeMove()
{
	local SavedMove S, first;
	local int I;

	// End:0x1BF
	if(FreeMoves == none)
	{
		S = SavedMoves;
		J0x22:

		// End:0x1AD [Loop If]
		if(S != none)
		{
			I++;
			// End:0x182
			if(I > 100)
			{
				first = SavedMoves;
				SavedMoves = SavedMoves.NextMove;
				first.Clear();
				first.NextMove = none;
				J0xC6:

				// End:0x16D [Loop If]
				if(SavedMoves != none)
				{
					S = SavedMoves;
					SavedMoves = SavedMoves.NextMove;
					S.Clear();
					S.NextMove = FreeMoves;
					FreeMoves = S;
					// [Loop Continue]
					goto J0xC6;
				}
				PendingMove = none;
				return first;
			}
			S = S.NextMove;
			// [Loop Continue]
			goto J0x22;
		}
		return new (self) SavedMoveClass;		
	}
	else
	{
		S = FreeMoves;
		FreeMoves = FreeMoves.NextMove;
		S.NextMove = none;
		return S;
	}
	//return ReturnValue;	
}

function int CompressAccel(int C)
{
	// End:0x29
	if(C >= 0)
	{
		C = Min(C, 127);		
	}
	else
	{
		C = Min(int(Abs(float(C))), 127) + 128;
	}
	return C;
	//return ReturnValue;	
}

function ReplicateMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
	local SavedMove NewMove, OldMove, AlmostLastMove, LastMove;
	local byte ClientRoll;
	local float NetMoveDelta;

	// End:0x11
	if(Player == none)
	{
		return;
	}
	MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
	DeltaTime = ((Pawn != none) ? Pawn.CustomTimeDilation : CustomTimeDilation) * FMin(DeltaTime, MaxResponseTime);
	// End:0x19E
	if(SavedMoves != none)
	{
		LastMove = SavedMoves;
		AlmostLastMove = LastMove;
		OldMove = none;
		J0xDC:

		// End:0x19E [Loop If]
		if(LastMove.NextMove != none)
		{
			// End:0x160
			if(((OldMove == none) && Pawn != none) && LastMove.IsImportantMove(LastAckedAccel))
			{
				OldMove = LastMove;
			}
			AlmostLastMove = LastMove;
			LastMove = LastMove.NextMove;
			// [Loop Continue]
			goto J0xDC;
		}
	}
	NewMove = GetFreeMove();
	// End:0x1C3
	if(NewMove == none)
	{
		return;
	}
	NewMove.SetMoveFor(self, DeltaTime, newAccel, DoubleClickMove);
	bDoubleJump = false;
	ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
	// End:0x574
	if((PendingMove != none) && PendingMove.CanCombineWith(NewMove, Pawn, MaxResponseTime))
	{
		Pawn.SetLocation(PendingMove.GetStartLocation());
		Pawn.Velocity = PendingMove.StartVelocity;
		// End:0x3B3
		if(PendingMove.StartBase != Pawn.Base)
		{
			Pawn.SetBase(PendingMove.StartBase);
		}
		Pawn.Floor = PendingMove.StartFloor;
		NewMove.Delta += PendingMove.Delta;
		NewMove.SetInitialPosition(Pawn);
		// End:0x569
		if(LastMove == PendingMove)
		{
			// End:0x4CD
			if(SavedMoves == PendingMove)
			{
				SavedMoves.NextMove = FreeMoves;
				FreeMoves = SavedMoves;
				SavedMoves = none;				
			}
			else
			{
				PendingMove.NextMove = FreeMoves;
				FreeMoves = PendingMove;
				// End:0x54A
				if(AlmostLastMove != none)
				{
					AlmostLastMove.NextMove = none;
					LastMove = AlmostLastMove;
				}
			}
			FreeMoves.Clear();
		}
		PendingMove = none;
	}
	// End:0x5BC
	if(Pawn != none)
	{
		Pawn.AutonomousPhysics(NewMove.Delta);		
	}
	else
	{
		AutonomousPhysics(DeltaTime);
	}
	NewMove.PostUpdate(self);
	// End:0x60D
	if(SavedMoves == none)
	{
		SavedMoves = NewMove;		
	}
	else
	{
		LastMove.NextMove = NewMove;
	}
	// End:0x7A5
	if(PendingMove == none)
	{
		// End:0x6E1
		if(((Player.CurrentNetSpeed > 10000) && WorldInfo.GRI != none) && WorldInfo.GRI.PRIArray.Length <= 10)
		{
			NetMoveDelta = 0.0110000;			
		}
		else
		{
			NetMoveDelta = FMax(0.0222000, (2.0000000 * WorldInfo.MoveRepSize) / float(Player.CurrentNetSpeed));
		}
		// End:0x7A5
		if(((WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation) < NetMoveDelta)
		{
			PendingMove = NewMove;
			return;
		}
	}
	ClientUpdateTime = WorldInfo.TimeSeconds;
	ClientRoll = byte((Rotation.Roll >> 8) & 255);
	CallServerMove(NewMove, ((Pawn == none) ? Location : Pawn.Location), ClientRoll, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535), OldMove);
	PendingMove = none;
	//return;	
}

function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
	local Vector BuildAccel;
	local byte OldAccelX, OldAccelY, OldAccelZ;

	// End:0x14B
	if(OldMove != none)
	{
		BuildAccel = (0.0500000 * OldMove.Acceleration) + vect(0.5000000, 0.5000000, 0.5000000);
		OldAccelX = byte(CompressAccel(int(BuildAccel.X)));
		OldAccelY = byte(CompressAccel(int(BuildAccel.Y)));
		OldAccelZ = byte(CompressAccel(int(BuildAccel.Z)));
		OldServerMove(OldMove.TimeStamp, OldAccelX, OldAccelY, OldAccelZ, OldMove.CompressedFlags());
	}
	// End:0x2BA
	if(PendingMove != none)
	{
		DualServerMove(PendingMove.TimeStamp, PendingMove.Acceleration * float(10), PendingMove.CompressedFlags(), ((PendingMove.Rotation.Yaw & 65535) << 16) + (PendingMove.Rotation.Pitch & 65535), NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);		
	}
	else
	{
		ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
	}
	// End:0x394
	if((PlayerCamera != none) && PlayerCamera.bUseClientSideCameraUpdates)
	{
		PlayerCamera.bShouldSendClientSideCameraUpdate = true;
	}
	//return;	
}

unreliable server function ServerUpdateCamera(Vector CamLoc, int CamPitchAndYaw)
{
	local TPOV NewPOV;

	NewPOV.Location = CamLoc;
	NewPOV.Rotation.Yaw = (CamPitchAndYaw >> 16) & 65535;
	NewPOV.Rotation.Pitch = CamPitchAndYaw & 65535;
	// End:0x2B5
	if(PlayerCamera.bDebugClientSideCamera)
	{
		DrawDebugSphere(PlayerCamera.CameraCache.POV.Location, 10.0000000, 10, 0, 255, 0);
		DrawDebugSphere(NewPOV.Location, 10.0000000, 10, 255, 255, 0);
		DrawDebugLine(PlayerCamera.CameraCache.POV.Location, PlayerCamera.CameraCache.POV.Location + (float(100) * Vector(PlayerCamera.CameraCache.POV.Rotation)), 0, 255, 0);
		DrawDebugLine(NewPOV.Location, NewPOV.Location + (float(100) * Vector(NewPOV.Rotation)), 255, 255, 0);		
	}
	else
	{
		PlayerCamera.FillCameraCache(NewPOV);
	}
	//return;	
}

function HandleWalking()
{
	// End:0x3F
	if(Pawn != none)
	{
		Pawn.SetWalking(int(bRun) != 0);
	}
	//return;	
}

reliable server function ServerRestartGame()
{
	//return;	
}

exec function Speech(name Type, int Index, string Callsign)
{
	ServerSpeech(Type, Index, Callsign);
	//return;	
}

reliable server function ServerSpeech(name Type, int Index, string Callsign)
{
	//return;	
}

exec function RestartLevel()
{
	// End:0x41
	if(WorldInfo.NetMode == NM_Standalone)
	{
		ClientTravel("?restart", TRAVEL_Relative);
	}
	//return;	
}

exec function LocalTravel(string URL)
{
	// End:0x40
	if(WorldInfo.NetMode == NM_Standalone)
	{
		ClientTravel(URL, 2);
	}
	//return;	
}

function PauseRumbleForAllPlayers(optional bool bShouldPauseRumble = true)
{
	local PlayerController PC;

	// End:0x63
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		PC.ClientPauseRumble(bShouldPauseRumble);		
	}	
	//return;	
}

reliable client simulated function ClientPauseRumble(bool bShouldPauseRumble)
{
	// End:0x38
	if(ForceFeedbackManager != none)
	{
		ForceFeedbackManager.PauseWaveform(bShouldPauseRumble);
	}
	//return;	
}

delegate bool CanUnpause()
{
	return WorldInfo.Pauser == PlayerReplicationInfo;
	//return ReturnValue;	
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
	local bool bResult;

	// End:0x13F
	if(WorldInfo.NetMode != NM_Client)
	{
		// End:0xBB
		if(bPause)
		{
			bFire = 0;
			bResult = WorldInfo.Game.SetPause(self, CanUnpauseDelegate);
			// End:0xB8
			if(bResult)
			{
				PauseRumbleForAllPlayers();
			}			
		}
		else
		{
			WorldInfo.Game.ClearPause();
			// End:0x13F
			if(WorldInfo.Pauser == none)
			{
				WorldInfo.bGameplayFramePause = false;
				PauseRumbleForAllPlayers(false);
			}
		}
	}
	return bResult;
	//return ReturnValue;	
}

final simulated function bool IsPaused()
{
	return WorldInfo.Pauser != none;
	//return ReturnValue;	
}

exec function Pause()
{
	ServerPause();
	//return;	
}

reliable server function ServerPause()
{
	// End:0x1E
	if(!IsPaused())
	{
		SetPause(true);		
	}
	else
	{
		SetPause(false);
	}
	//return;	
}

event ConditionalPause(bool bDesiredPauseState)
{
	// End:0x2E
	if(bDesiredPauseState != IsPaused())
	{
		SetPause(bDesiredPauseState);
	}
	//return;	
}

reliable server function ServerUTrace()
{
	// End:0x62
	if((WorldInfo.NetMode != NM_Standalone) && (PlayerReplicationInfo == none) || !PlayerReplicationInfo.bAdmin)
	{
		return;
	}
	UTrace();
	//return;	
}

exec function UTrace()
{
	ConsoleCommand("hidelog");
	// End:0x3B
	if(Role != ROLE_Authority)
	{
		ServerUTrace();
	}
	SetUTracing(!IsUTracing());
	LogInternal((("UTracing changed to " $ string(IsUTracing())) $ " at ") $ string(WorldInfo.TimeSeconds), 'UTrace');
	//return;	
}

exec function ThrowWeapon()
{
	// End:0x37
	if((Pawn == none) || Pawn.Weapon == none)
	{
		return;
	}
	ServerThrowWeapon();
	//return;	
}

reliable server function ServerThrowWeapon()
{
	// End:0x42
	if(Pawn.CanThrowWeapon())
	{
		Pawn.ThrowActiveWeapon();
	}
	//return;	
}

exec function PrevWeapon()
{
	// End:0x26
	if(WorldInfo.Pauser != none)
	{
		return;
	}
	// End:0x57
	if(Pawn.Weapon == none)
	{
		SwitchToBestWeapon();
		return;
	}
	// End:0xAF
	if(Pawn.InvManager != none)
	{
		Pawn.InvManager.PrevWeapon();
	}
	//return;	
}

exec function NextWeapon()
{
	// End:0x26
	if(WorldInfo.Pauser != none)
	{
		return;
	}
	// End:0x57
	if(Pawn.Weapon == none)
	{
		SwitchToBestWeapon();
		return;
	}
	// End:0xAF
	if(Pawn.InvManager != none)
	{
		Pawn.InvManager.NextWeapon();
	}
	//return;	
}

exec function StartFire(optional byte FireModeNum)
{
	// End:0x3B
	if(WorldInfo.Pauser == PlayerReplicationInfo)
	{
		SetPause(false);
		return;
	}
	// End:0xA9
	if(((Pawn != none) && !bCinematicMode) && !WorldInfo.bPlayersOnly)
	{
		Pawn.StartFire(FireModeNum);
	}
	//return;	
}

exec function StopFire(optional byte FireModeNum)
{
	// End:0x38
	if(Pawn != none)
	{
		Pawn.StopFire(FireModeNum);
	}
	//return;	
}

exec function StartAltFire(optional byte FireModeNum)
{
	StartFire(1);
	//return;	
}

exec function StopAltFire(optional byte FireModeNum)
{
	StopFire(1);
	//return;	
}

function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList, optional Class triggerClass = Class'Engine.Trigger')
{
	local int Idx;
	local Vector CameraLoc;
	local Rotator CameraRot;
	local Trigger checkTrigger;
	local SeqEvent_Used UseSeq;
	local bool aimingRequirementsSatisfied;

	// End:0x384
	if(Pawn != none)
	{
		GetPlayerViewPoint(CameraLoc, CameraRot);
		// End:0x383
		foreach Pawn.CollidingActors(Class'Engine.Trigger', checkTrigger, interactDistanceToCheck)
		{
			// End:0x382
			if(checkTrigger.IsA(triggerClass.Name))
			{
				Idx = 0;
				J0xB5:

				// End:0x382 [Loop If]
				if(Idx < checkTrigger.GeneratedEvents.Length)
				{
					UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
					// End:0x374
					if(((UseSeq != none) && !bUsuableOnly || checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger, Pawn, true)) && (Normal(checkTrigger.Location - CameraLoc) Dot Vector(CameraRot)) >= minDot)
					{
						aimingRequirementsSatisfied = false;
						// End:0x320
						if(VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance)
						{
							aimingRequirementsSatisfied = ((!UseSeq.bAimToInteract && !UseSeq.bAllowPawnFacingToInteract) || UseSeq.bAimToInteract && IsAimingAt(checkTrigger, 0.9800000)) || UseSeq.bAllowPawnFacingToInteract && PawnIsFacing(checkTrigger, 0.7070000);
						}
						// End:0x374
						if(aimingRequirementsSatisfied)
						{
							out_useList[out_useList.Length] = checkTrigger;
							Idx = checkTrigger.GeneratedEvents.Length;
						}
					}
					Idx++;
					// [Loop Continue]
					goto J0xB5;
				}
			}			
		}		
	}
	//return;	
}

exec function Use()
{
	// End:0x1E
	if(Role < ROLE_Authority)
	{
		PerformedUseAction();
	}
	ServerUse();
	//return;	
}

unreliable server function ServerUse()
{
	PerformedUseAction();
	//return;	
}

function bool PerformedUseAction()
{
	// End:0x4E
	if(WorldInfo.Pauser == PlayerReplicationInfo)
	{
		// End:0x4C
		if(Role == ROLE_Authority)
		{
			SetPause(false);
		}
		return true;
	}
	// End:0x5F
	if(Pawn == none)
	{
		return true;
	}
	// End:0x75
	if(Role < ROLE_Authority)
	{
		return false;
	}
	// End:0xB7
	if(Vehicle(Pawn) != none)
	{
		return Vehicle(Pawn).DriverLeave(false);
	}
	// End:0xC6
	if(FindVehicleToDrive())
	{
		return true;
	}
	return TriggerInteracted();
	//return ReturnValue;	
}

function bool FindVehicleToDrive()
{
	local Vehicle V, Best;
	local Vector ViewDir, PawnLoc2D, VLoc2D;
	local float NewDot, BestDot;

	// End:0x7A
	if((Vehicle(Pawn.Base) != none) && Vehicle(Pawn.Base).TryToDrive(Pawn))
	{
		return true;
	}
	PawnLoc2D = Pawn.Location;
	PawnLoc2D.Z = 0.0000000;
	ViewDir = Vector(Pawn.Rotation);
	// End:0x24A
	foreach Pawn.OverlappingActors(Class'Engine.Vehicle', V, Pawn.VehicleCheckRadius)
	{
		VLoc2D = V.Location;
		VLoc2D.Z = 0.0000000;
		NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
		// End:0x249
		if((Best == none) || NewDot > BestDot)
		{
			// End:0x249
			if(FastTrace(V.Location, Pawn.Location))
			{
				Best = V;
				BestDot = NewDot;
			}
		}		
	}	
	return (Best != none) && Best.TryToDrive(Pawn);
	//return ReturnValue;	
}

function bool TriggerInteracted()
{
	local Actor A;
	local int Idx;
	local float Weight;
	local bool bInserted;
	local Vector CameraLoc;
	local Rotator CameraRot;
	local array<Trigger> useList;
	local array<Actor> sortedList;
	local array<float> weightList;

	// End:0x2F2
	if(Pawn != none)
	{
		GetTriggerUseList(InteractDistance, 60.0000000, 0.0000000, true, useList);
		// End:0x2F2
		if(useList.Length > 0)
		{
			GetPlayerViewPoint(CameraLoc, CameraRot);
			J0x63:

			// End:0x28A [Loop If]
			if(useList.Length > 0)
			{
				A = useList[useList.Length - 1];
				useList.Length = useList.Length - 1;
				Weight = Normal(A.Location - CameraLoc) Dot Vector(CameraRot);
				Weight += (1.0000000 - (VSize(A.Location - Pawn.Location) / InteractDistance));
				bInserted = false;
				Idx = 0;
				J0x162:

				// End:0x22A [Loop If]
				if((Idx < sortedList.Length) && !bInserted)
				{
					// End:0x21C
					if(weightList[Idx] < Weight)
					{
						sortedList.Insert(Idx, 1);
						weightList.Insert(Idx, 1);
						sortedList[Idx] = A;
						weightList[Idx] = Weight;
						bInserted = true;
					}
					Idx++;
					// [Loop Continue]
					goto J0x162;
				}
				// End:0x287
				if(!bInserted)
				{
					Idx = sortedList.Length;
					sortedList[Idx] = A;
					weightList[Idx] = Weight;
				}
				// [Loop Continue]
				goto J0x63;
			}
			Idx = 0;
			J0x295:

			// End:0x2F2 [Loop If]
			if(Idx < sortedList.Length)
			{
				// End:0x2E4
				if(sortedList[Idx].UsedBy(Pawn))
				{
					return true;
				}
				Idx++;
				// [Loop Continue]
				goto J0x295;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

exec function Suicide()
{
	ServerSuicide();
	//return;	
}

reliable server function ServerSuicide()
{
	// End:0xA2
	if((Pawn != none) && ((WorldInfo.TimeSeconds - Pawn.LastStartTime) > float(10)) || WorldInfo.NetMode == NM_Standalone)
	{
		Pawn.Suicide();
	}
	//return;	
}

exec function SetName(coerce string S)
{
	local string NewName;
	local LocalPlayer LocPlayer;

	// End:0x1EA
	if(S != "")
	{
		LocPlayer = LocalPlayer(Player);
		// End:0x1AE
		if(((LocPlayer != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none)) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
		{
			// End:0x1AE
			if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) == 2) && OnlineSub.GameInterface.GetGameSettings('Game') != none)
			{
				S = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
			}
		}
		NewName = S;
		ServerChangeName(NewName);
		UpdateURL("Name", NewName, true);
		SaveConfig();
	}
	//return;	
}

reliable server function ServerChangeName(coerce string S)
{
	// End:0x4F
	if(S != "")
	{
		WorldInfo.Game.ChangeName(self, S, true);
	}
	//return;	
}

exec function SwitchTeam()
{
	// End:0x6D
	if((PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex == 1)
	{
		ServerChangeTeam(0);		
	}
	else
	{
		ServerChangeTeam(1);
	}
	//return;	
}

exec function ChangeTeam(optional string TeamName)
{
	local int N;

	// End:0x23
	if(TeamName ~= "blue")
	{
		N = 1;		
	}
	else
	{
		// End:0xB6
		if((((TeamName ~= "red") || PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex > 1)
		{
			N = 0;			
		}
		else
		{
			N = 1 - PlayerReplicationInfo.Team.TeamIndex;
		}
	}
	ServerChangeTeam(N);
	//return;	
}

reliable server function ServerChangeTeam(int N)
{
	local TeamInfo OldTeam;

	OldTeam = PlayerReplicationInfo.Team;
	WorldInfo.Game.ChangeTeam(self, N, true);
	// End:0xFA
	if(WorldInfo.Game.bTeamGame && PlayerReplicationInfo.Team != OldTeam)
	{
		// End:0xFA
		if(Pawn != none)
		{
			Pawn.PlayerChangedTeam();
		}
	}
	//return;	
}

exec function SwitchLevel(string URL)
{
	// End:0x7E
	if((WorldInfo.NetMode == NM_Standalone) || WorldInfo.NetMode == NM_ListenServer)
	{
		WorldInfo.ServerTravel(URL);
	}
	//return;	
}

reliable client simulated event ClientSetProgressMessage(PlayerController.EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
	// End:0x7F
	if(LocalPlayer(Player) != none)
	{
		LocalPlayer(Player).ViewportClient.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);		
	}
	else
	{
		WarnInternal((("Discarded progress message due to no viewport:" @ string(MessageType)) @ Message) @ Title);
	}
	//return;	
}

function Restart(bool bVehicleTransition)
{
	super.Restart(bVehicleTransition);
	ServerTimeStamp = 0.0000000;
	ResetTimeMargin();
	EnterStartState();
	ClientRestart(Pawn);
	SetViewTarget(Pawn);
	ResetCameraMode();
	//return;	
}

// Export UPlayerController::execServerNotifyLoadedWorld(FFrame&, void* const)
reliable server native final event ServerNotifyLoadedWorld(name WorldPackageName);

event NotifyLoadedWorld(name WorldPackageName, bool bFinalDest)
{
	local PlayerStart P;
	local Rotator SpawnRotation;

	SetViewTarget(self);
	// End:0xBF
	foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', P)
	{
		SetLocation(P.Location);
		SpawnRotation.Yaw = P.Rotation.Yaw;
		SetRotation(SpawnRotation);
		// End:0xBF
		break;		
	}	
	//return;	
}

// Export UPlayerController::execHasClientLoadedCurrentWorld(FFrame&, void* const)
native final function bool HasClientLoadedCurrentWorld();

// Export UPlayerController::execForceSingleNetUpdateFor(FFrame&, void* const)
native final function ForceSingleNetUpdateFor(Actor Target);

function EnterStartState()
{
	local name NewState;

	// End:0xD6
	if(Pawn.PhysicsVolume.bWaterVolume)
	{
		// End:0xAB
		if(Pawn.HeadVolume.bWaterVolume)
		{
			Pawn.BreathTime = Pawn.UnderWaterTime;
		}
		NewState = Pawn.WaterMovementState;		
	}
	else
	{
		NewState = Pawn.LandMovementState;
	}
	// End:0x125
	if(GetStateName() == NewState)
	{
		BeginState(NewState);		
	}
	else
	{
		GotoState(NewState);
	}
	//return;	
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
	ResetPlayerMovementInput();
	CleanOutSavedMoves();
	Pawn = NewPawn;
	// End:0x6F
	if((Pawn != none) && Pawn.bTearOff)
	{
		UnPossess();
		Pawn = none;
	}
	AcknowledgePossession(Pawn);
	// End:0xA1
	if(Pawn == none)
	{
		GotoState('WaitingForPawn');
		return;
	}
	Pawn.ClientRestart();
	// End:0xFC
	if(Role < ROLE_Authority)
	{
		SetViewTarget(Pawn);
		ResetCameraMode();
		EnterStartState();
	}
	CleanOutSavedMoves();
	//return;	
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
	SetViewTarget(EndGameFocus);
	GotoState('RoundEnded');
	ClientGameEnded(EndGameFocus, bIsWinner);
	//return;	
}

reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
	SetViewTarget(EndGameFocus);
	GotoState('RoundEnded');
	//return;	
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
	//return;	
}

event PlayerTick(float DeltaTime)
{
	// End:0x25
	if(!bShortConnectTimeOut)
	{
		bShortConnectTimeOut = true;
		ServerShortTimeout();
	}
	// End:0xB8
	if(Pawn != AcknowledgedPawn)
	{
		// End:0xA5
		if(Role < ROLE_Authority)
		{
			// End:0xA5
			if((AcknowledgedPawn != none) && AcknowledgedPawn.Controller == self)
			{
				AcknowledgedPawn.Controller = none;
			}
		}
		AcknowledgePossession(Pawn);
	}
	PlayerInput.PlayerInput(DeltaTime);
	// End:0xF7
	if(bUpdatePosition)
	{
		ClientUpdatePosition();
	}
	PlayerMove(DeltaTime);
	AdjustFOV(DeltaTime);
	//return;	
}

function PlayerMove(float DeltaTime)
{
	//return;	
}

function bool AimingHelp(bool bInstantHit)
{
	return (WorldInfo.NetMode == NM_Standalone) && bAimingHelp;
	//return ReturnValue;	
}

event CameraLookAtFinished(SeqAct_CameraLookAt Action)
{
	//return;	
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	local Vector FireDir, AimSpot, HitLocation, HitNormal, OldAim, AimOffset;

	local Actor BestTarget, HitActor;
	local float bestAim, bestDist;
	local bool bNoZAdjust, bInstantHit;
	local Rotator BaseAimRot, AimRot;

	bInstantHit = (W == none) || W.bInstantHit;
	BaseAimRot = ((Pawn != none) ? Pawn.GetBaseAimRotation() : Rotation);
	FireDir = Vector(BaseAimRot);
	HitActor = Trace(HitLocation, HitNormal, StartFireLoc + (W.GetTraceRange() * FireDir), StartFireLoc, true);
	// End:0x1A6
	if((HitActor != none) && HitActor.bProjTarget)
	{
		BestTarget = HitActor;
		bNoZAdjust = true;
		OldAim = HitLocation;
		bestDist = VSize(BestTarget.Location - Pawn.Location);		
	}
	else
	{
		bestAim = 0.9000000;
		// End:0x1ED
		if(AimingHelp(bInstantHit))
		{
			bestAim = AimHelpDot(bInstantHit);			
		}
		else
		{
			// End:0x209
			if(bInstantHit)
			{
				bestAim = 1.0000000;
			}
		}
		BestTarget = PickTarget(Class'Engine.Pawn', bestAim, bestDist, FireDir, StartFireLoc, W.WeaponRange);
		// End:0x27A
		if(BestTarget == none)
		{
			return BaseAimRot;
		}
		OldAim = StartFireLoc + (FireDir * bestDist);
	}
	ShotTarget = Pawn(BestTarget);
	// End:0x2E2
	if(!AimingHelp(bInstantHit))
	{
		return BaseAimRot;
	}
	FireDir = BestTarget.Location - StartFireLoc;
	AimSpot = StartFireLoc + (bestDist * Normal(FireDir));
	AimOffset = AimSpot - OldAim;
	// End:0x4F4
	if(ShotTarget != none)
	{
		// End:0x3B6
		if(bNoZAdjust)
		{
			AimSpot.Z = OldAim.Z;			
		}
		else
		{
			// End:0x467
			if(AimOffset.Z < float(0))
			{
				AimSpot.Z = ShotTarget.Location.Z + (0.4000000 * ShotTarget.CylinderComponent.CollisionHeight);				
			}
			else
			{
				AimSpot.Z = ShotTarget.Location.Z - (0.7000000 * ShotTarget.CylinderComponent.CollisionHeight);
			}
		}		
	}
	else
	{
		AimSpot.Z = OldAim.Z;
	}
	// End:0x615
	if(!bNoZAdjust)
	{
		AimRot = Rotator(AimSpot - StartFireLoc);
		// End:0x5C2
		if(FOVAngle < (DefaultFOV - float(8)))
		{
			AimRot.Yaw = (AimRot.Yaw + 200) - Rand(400);			
		}
		else
		{
			AimRot.Yaw = (AimRot.Yaw + 375) - Rand(750);
		}
		return AimRot;
	}
	return Rotator(AimSpot - StartFireLoc);
	//return ReturnValue;	
}

function float AimHelpDot(bool bInstantHit)
{
	// End:0x23
	if(FOVAngle < (DefaultFOV - float(8)))
	{
		return 0.9900000;
	}
	// End:0x36
	if(bInstantHit)
	{
		return 0.9700000;
	}
	return 0.9300000;
	//return ReturnValue;	
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
	return bUpdating;
	//return ReturnValue;	
}

function AdjustFOV(float DeltaTime)
{
	// End:0xE7
	if(FOVAngle != DesiredFOV)
	{
		// End:0x73
		if(FOVAngle > DesiredFOV)
		{
			FOVAngle = FOVAngle - FMax(7.0000000, (0.9000000 * DeltaTime) * (FOVAngle - DesiredFOV));			
		}
		else
		{
			FOVAngle = FOVAngle - FMin(-7.0000000, (0.9000000 * DeltaTime) * (FOVAngle - DesiredFOV));
		}
		// End:0xE7
		if(Abs(FOVAngle - DesiredFOV) <= float(10))
		{
			FOVAngle = DesiredFOV;
		}
	}
	//return;	
}

event float GetFOVAngle()
{
	return ((PlayerCamera != none) ? PlayerCamera.GetFOVAngle() : FOVAngle);
	//return ReturnValue;	
}

// Export UPlayerController::execIsLocalPlayerController(FFrame&, void* const)
native function bool IsLocalPlayerController();

// Export UPlayerController::execIsLocalController(FFrame&, void* const)
native function bool IsLocalController();

// Export UPlayerController::execSetViewTarget(FFrame&, void* const)
native function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams);

final function SetViewTargetWithBlend(Actor NewViewTarget, optional float BlendTime = 0.3500000, optional Camera.EViewTargetBlendFunction BlendFunc = 1, optional float BlendExp = 2.0000000, optional bool bLockOutgoing = false)
{
	local ViewTargetTransitionParams TransitionParams;

	TransitionParams.BlendTime = BlendTime;
	TransitionParams.BlendFunction = BlendFunc;
	TransitionParams.BlendExp = BlendExp;
	TransitionParams.bLockOutgoing = bLockOutgoing;
	SetViewTarget(NewViewTarget, TransitionParams);
	//return;	
}

reliable client simulated event ClientSetViewTarget(Actor A, optional ViewTargetTransitionParams TransitionParams)
{
	// End:0x45
	if(!bClientSimulatingViewTarget)
	{
		// End:0x29
		if(A == none)
		{
			ServerVerifyViewTarget();
		}
		SetViewTarget(A, TransitionParams);
	}
	//return;	
}

// Export UPlayerController::execGetViewTarget(FFrame&, void* const)
native function Actor GetViewTarget();

reliable server function ServerVerifyViewTarget()
{
	local Actor TheViewTarget;

	TheViewTarget = GetViewTarget();
	// End:0x25
	if(TheViewTarget == self)
	{
		return;
	}
	ClientSetViewTarget(TheViewTarget);
	//return;	
}

event SpawnPlayerCamera()
{
	// End:0x95
	if(CameraClass != none)
	{
		PlayerCamera = Spawn(CameraClass, self);
		// End:0x65
		if(PlayerCamera != none)
		{
			PlayerCamera.InitializeFor(self);			
		}
		else
		{
			LogInternal("Couldn't Spawn Camera Actor for Player!!");
		}		
	}
	//return;	
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
	local Actor TheViewTarget;

	// End:0xA1
	if(PlayerCamera == none)
	{
		// End:0xA1
		if(CameraClass != none)
		{
			PlayerCamera = Spawn(CameraClass, self);
			// End:0x74
			if(PlayerCamera != none)
			{
				PlayerCamera.InitializeFor(self);				
			}
			else
			{
				LogInternal("Couldn't Spawn Camera Actor for Player!!");
			}
		}
	}
	// End:0xE4
	if(PlayerCamera != none)
	{
		PlayerCamera.GetCameraViewPoint(out_Location, out_Rotation);		
	}
	else
	{
		TheViewTarget = GetViewTarget();
		// End:0x15A
		if(TheViewTarget != none)
		{
			out_Location = TheViewTarget.Location;
			out_Rotation = TheViewTarget.Rotation;			
		}
		else
		{
			super.GetPlayerViewPoint(out_Location, out_Rotation);
		}
	}
	//return;	
}

function ViewShake(float DeltaTime)
{
	//return;	
}

function UpdateRotation(float DeltaTime)
{
	local Rotator DeltaRot, NewRotation, ViewRotation;

	ViewRotation = Rotation;
	// End:0x4E
	if(Pawn != none)
	{
		Pawn.SetDesiredRotation(ViewRotation);
	}
	DeltaRot.Yaw = int(PlayerInput.aTurn);
	DeltaRot.Pitch = int(PlayerInput.aLookUp);
	ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
	SetRotation(ViewRotation);
	ViewShake(DeltaTime);
	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;
	// End:0x198
	if(Pawn != none)
	{
		Pawn.FaceRotation(NewRotation, DeltaTime);
	}
	//return;	
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
	// End:0x49
	if(PlayerCamera != none)
	{
		PlayerCamera.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
	}
	// End:0x95
	if(Pawn != none)
	{
		Pawn.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);		
	}
	else
	{
		out_ViewRotation += DeltaRot;
		out_ViewRotation = LimitViewRotation(out_ViewRotation, -16384.0000000, 16383.0000000);
	}
	//return;	
}

event Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
{
	ViewRotation.Pitch = ViewRotation.Pitch & 65535;
	// End:0x125
	if((float(ViewRotation.Pitch) > ViewPitchMax) && float(ViewRotation.Pitch) < (float(65535) + ViewPitchMin))
	{
		// End:0xF4
		if(ViewRotation.Pitch < 32768)
		{
			ViewRotation.Pitch = int(ViewPitchMax);			
		}
		else
		{
			ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
		}
	}
	return ViewRotation;
	//return ReturnValue;	
}

function CheckJumpOrDuck()
{
	// End:0x47
	if(bPressedJump && Pawn != none)
	{
		Pawn.DoJump(bUpdating);
	}
	//return;	
}

function AdjustPlayerWalkingMoveAccel(out Vector newAccel)
{
	//return;	
}

function bool IsSpectating()
{
	return false;
	//return ReturnValue;	
}

unreliable server function ServerSetSpectatorLocation(Vector NewLoc)
{
	// End:0x77
	if(WorldInfo.TimeSeconds != LastSpectatorStateSynchTime)
	{
		ClientGotoState(GetStateName());
		ClientSetViewTarget(GetViewTarget());
		LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
	}
	//return;	
}

unreliable server function ServerViewNextPlayer()
{
	// End:0x18
	if(IsSpectating())
	{
		ViewAPlayer(1);
	}
	//return;	
}

unreliable server function ServerViewPrevPlayer()
{
	// End:0x1C
	if(IsSpectating())
	{
		ViewAPlayer(-1);
	}
	//return;	
}

function PlayerReplicationInfo GetNextViewablePlayer(int Dir)
{
	local int I, CurrentIndex, NewIndex;
	local PlayerReplicationInfo PRI;

	CurrentIndex = -1;
	// End:0xDA
	if(RealViewTarget != none)
	{
		I = 0;
		J0x29:

		// End:0xDA [Loop If]
		if(I < WorldInfo.GRI.PRIArray.Length)
		{
			// End:0xCC
			if(RealViewTarget == WorldInfo.GRI.PRIArray[I])
			{
				CurrentIndex = I;
				// [Explicit Break]
				goto J0xDA;
			}
			I++;
			// [Loop Continue]
			goto J0x29;
		}
	}
	J0xDA:

	NewIndex = CurrentIndex + Dir;
	J0xF8:

	// End:0x282 [Loop If]
	if((NewIndex >= 0) && NewIndex < WorldInfo.GRI.PRIArray.Length)
	{
		PRI = WorldInfo.GRI.PRIArray[NewIndex];
		// End:0x261
		if((((PRI != none) && Controller(PRI.Owner) != none) && Controller(PRI.Owner).Pawn != none) && WorldInfo.Game.CanSpectate(self, PRI))
		{
			return PRI;
		}
		NewIndex = NewIndex + Dir;
		// [Loop Continue]
		goto J0xF8;
	}
	CurrentIndex = ((NewIndex < 0) ? WorldInfo.GRI.PRIArray.Length : -1);
	NewIndex = CurrentIndex + Dir;
	J0x2F4:

	// End:0x47E [Loop If]
	if((NewIndex >= 0) && NewIndex < WorldInfo.GRI.PRIArray.Length)
	{
		PRI = WorldInfo.GRI.PRIArray[NewIndex];
		// End:0x45D
		if((((PRI != none) && Controller(PRI.Owner) != none) && Controller(PRI.Owner).Pawn != none) && WorldInfo.Game.CanSpectate(self, PRI))
		{
			return PRI;
		}
		NewIndex = NewIndex + Dir;
		// [Loop Continue]
		goto J0x2F4;
	}
	return none;
	//return ReturnValue;	
}

function ViewAPlayer(int Dir)
{
	local PlayerReplicationInfo PRI;

	PRI = GetNextViewablePlayer(Dir);
	// End:0x40
	if(PRI != none)
	{
		SetViewTarget(PRI);
	}
	//return;	
}

unreliable server function ServerViewSelf(optional ViewTargetTransitionParams TransitionParams)
{
	// End:0x40
	if(IsSpectating())
	{
		ResetCameraMode();
		SetViewTarget(self, TransitionParams);
		ClientSetViewTarget(self, TransitionParams);
	}
	//return;	
}

function bool CanRestartPlayer()
{
	return (((PlayerReplicationInfo != none) && !PlayerReplicationInfo.bOnlySpectator) && HasClientLoadedCurrentWorld()) && PendingSwapConnection == none;
	//return ReturnValue;	
}

function DrawHUD(HUD H)
{
	// End:0x37
	if(Pawn != none)
	{
		Pawn.DrawHUD(H);
	}
	// End:0x6E
	if(PlayerInput != none)
	{
		PlayerInput.DrawHUD(H);
	}
	//return;	
}

event AdjustHUDRenderSize(out int X, out int Y, out int SizeX, out int SizeY, const int FullScreenSizeX, const int FullScreenSizeY)
{
	// End:0x49
	if(bRenderHUDFullScreen)
	{
		X = 0;
		Y = 0;
		SizeX = FullScreenSizeX;
		SizeY = FullScreenSizeY;
	}
	//return;	
}

function OnToggleInput(SeqAct_ToggleInput inAction)
{
	local bool bNewValue;

	// End:0x31
	if(Role < ROLE_Authority)
	{
		WarnInternal("Not supported on client");
		return;
	}
	// End:0xDB
	if(inAction.InputLinks[0].bHasImpulse)
	{
		// End:0xA0
		if(inAction.bToggleMovement)
		{
			IgnoreMoveInput(false);
			ClientIgnoreMoveInput(false);
		}
		// End:0xD8
		if(inAction.bToggleTurning)
		{
			IgnoreLookInput(false);
			ClientIgnoreLookInput(false);
		}		
	}
	else
	{
		// End:0x185
		if(inAction.InputLinks[1].bHasImpulse)
		{
			// End:0x14A
			if(inAction.bToggleMovement)
			{
				IgnoreMoveInput(true);
				ClientIgnoreMoveInput(true);
			}
			// End:0x182
			if(inAction.bToggleTurning)
			{
				IgnoreLookInput(true);
				ClientIgnoreLookInput(true);
			}			
		}
		else
		{
			// End:0x27F
			if(inAction.InputLinks[2].bHasImpulse)
			{
				// End:0x21E
				if(inAction.bToggleMovement)
				{
					bNewValue = !IsMoveInputIgnored();
					IgnoreMoveInput(bNewValue);
					ClientIgnoreMoveInput(bNewValue);
				}
				// End:0x27F
				if(inAction.bToggleTurning)
				{
					bNewValue = !IsLookInputIgnored();
					IgnoreLookInput(bNewValue);
					ClientIgnoreLookInput(bNewValue);
				}
			}
		}
	}
	//return;	
}

reliable client simulated function ClientIgnoreMoveInput(bool bIgnore)
{
	IgnoreMoveInput(bIgnore);
	//return;	
}

reliable client simulated function ClientIgnoreLookInput(bool bIgnore)
{
	IgnoreLookInput(bIgnore);
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	super.DisplayDebug(HUD, out_YL, out_YPos);
	// End:0x171
	if(HUD.ShouldDisplayDebug('Camera'))
	{
		// End:0x9C
		if(PlayerCamera != none)
		{
			PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);			
		}
		else
		{
			HUD.Canvas.SetDrawColor(255, 0, 0);
			HUD.Canvas.DrawText("NO CAMERA");
			out_YPos += out_YL;
			HUD.Canvas.SetPos(4.0000000, out_YPos);
		}
	}
	// End:0x2D4
	if(HUD.ShouldDisplayDebug('Input'))
	{
		HUD.Canvas.SetDrawColor(255, 0, 0);
		HUD.Canvas.DrawText((((("Input ignoremove " $ string(bIgnoreMoveInput)) $ " ignore look ") $ string(bIgnoreLookInput)) $ " aForward ") $ string(PlayerInput.aForward));
		out_YPos += out_YL;
		HUD.Canvas.SetPos(4.0000000, out_YPos);
	}
	//return;	
}

function OnDrawText(SeqAct_DrawText inAction)
{
	// End:0x80
	if(inAction.InputLinks[0].bHasImpulse)
	{
		ClientDrawKismetText(inAction.DrawTextInfo, inAction.DisplayTimeSeconds);		
	}
	else
	{
		ClientClearKismetText(inAction.DrawTextInfo.MessageOffset);
	}
	//return;	
}

reliable client final simulated function ClientDrawKismetText(KismetDrawTextInfo DrawTextInfo, float DisplayTime)
{
	// End:0x11
	if(!bShowKismetDrawText)
	{
		return;
	}
	// End:0x6B
	if(DisplayTime > float(0))
	{
		DrawTextInfo.MessageEndTime = WorldInfo.TimeSeconds + DisplayTime;		
	}
	else
	{
		DrawTextInfo.MessageEndTime = -1.0000000;
	}
	myHUD.KismetTextInfo.AddItem(DrawTextInfo);
	//return;	
}

reliable client final simulated function ClientClearKismetText(Vector2D MessageOffset)
{
	local int RemoveIdx;

	RemoveIdx = myHUD.KismetTextInfo.Find('MessageOffset', MessageOffset);
	// End:0x7B
	if(RemoveIdx != -1)
	{
		myHUD.KismetTextInfo.Remove(RemoveIdx, 1);
	}
	//return;	
}

simulated function OnSetCameraTarget(SeqAct_SetCameraTarget inAction)
{
	local Actor RealCameraTarget;

	RealCameraTarget = inAction.CameraTarget;
	// End:0x5F
	if(RealCameraTarget == none)
	{
		RealCameraTarget = ((Pawn != none) ? Pawn : self);		
	}
	else
	{
		// End:0xB3
		if(RealCameraTarget.IsA('Controller'))
		{
			RealCameraTarget = Controller(RealCameraTarget).Pawn;
		}
	}
	SetViewTarget(RealCameraTarget, inAction.TransitionParams);
	//return;	
}

simulated function OnToggleHUD(SeqAct_ToggleHUD inAction)
{
	// End:0x13E
	if(myHUD != none)
	{
		// End:0x6A
		if(inAction.InputLinks[0].bHasImpulse)
		{
			myHUD.bShowHUD = true;			
		}
		else
		{
			// End:0xC5
			if(inAction.InputLinks[1].bHasImpulse)
			{
				myHUD.bShowHUD = false;				
			}
			else
			{
				// End:0x13E
				if(inAction.InputLinks[2].bHasImpulse)
				{
					myHUD.bShowHUD = !myHUD.bShowHUD;
				}
			}
		}
	}
	//return;	
}

unreliable server function ServerCauseEvent(name EventName)
{
	local array<SequenceObject> AllConsoleEvents;
	local SeqEvent_Console ConsoleEvt;
	local Sequence GameSeq;
	local int Idx;
	local bool bFoundEvt;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x14F
	if((GameSeq != none) && EventName != 'None')
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_Console', true, AllConsoleEvents);
		Idx = 0;
		J0x8E:

		// End:0x14F [Loop If]
		if(Idx < AllConsoleEvents.Length)
		{
			ConsoleEvt = SeqEvent_Console(AllConsoleEvents[Idx]);
			// End:0x141
			if((ConsoleEvt != none) && EventName == ConsoleEvt.ConsoleEventName)
			{
				bFoundEvt = true;
				ConsoleEvt.CheckActivate(self, Pawn);
			}
			Idx++;
			// [Loop Continue]
			goto J0x8E;
		}
	}
	// End:0x168
	if(!bFoundEvt)
	{
		ListConsoleEvents();
	}
	//return;	
}

exec function CauseEvent(optional name EventName)
{
	ServerCauseEvent(EventName);
	//return;	
}

exec function CE(optional name EventName)
{
	ServerCauseEvent(EventName);
	//return;	
}

exec function ListConsoleEvents()
{
	local array<SequenceObject> ConsoleEvents;
	local SeqEvent_Console ConsoleEvt;
	local Sequence GameSeq;
	local int Idx;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x1C6
	if(GameSeq != none)
	{
		LogInternal("Console events:");
		ClientMessage("Console events:",, 15.0000000);
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_Console', true, ConsoleEvents);
		Idx = 0;
		J0xAA:

		// End:0x1C6 [Loop If]
		if(Idx < ConsoleEvents.Length)
		{
			ConsoleEvt = SeqEvent_Console(ConsoleEvents[Idx]);
			// End:0x1B8
			if((ConsoleEvt != none) && ConsoleEvt.bEnabled)
			{
				LogInternal(("-" @ string(ConsoleEvt.ConsoleEventName)) @ ConsoleEvt.EventDesc);
				ClientMessage(("-" @ string(ConsoleEvt.ConsoleEventName)) @ ConsoleEvt.EventDesc,, 15.0000000);
			}
			Idx++;
			// [Loop Continue]
			goto J0xAA;
		}
	}
	//return;	
}

exec function ListCE()
{
	ListConsoleEvents();
	//return;	
}

exec function RemoteEvent(optional name EventName)
{
	ServerRemoteEvent(EventName);
	//return;	
}

exec function RE(optional name EventName)
{
	ServerRemoteEvent(EventName);
	//return;	
}

unreliable server function ServerRemoteEvent(name EventName)
{
	local array<SequenceObject> AllRemoteEvents;
	local SeqEvent_RemoteEvent RemoteEvt;
	local Sequence GameSeq;
	local int Idx;
	local bool bFoundEvt;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x14D
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllRemoteEvents);
		// End:0x14D
		if(EventName != 'None')
		{
			Idx = 0;
			J0x8C:

			// End:0x14D [Loop If]
			if(Idx < AllRemoteEvents.Length)
			{
				RemoteEvt = SeqEvent_RemoteEvent(AllRemoteEvents[Idx]);
				// End:0x13F
				if((RemoteEvt != none) && EventName == RemoteEvt.EventName)
				{
					bFoundEvt = true;
					RemoteEvt.CheckActivate(self, Pawn);
				}
				Idx++;
				// [Loop Continue]
				goto J0x8C;
			}
		}
	}
	// End:0x276
	if(!bFoundEvt)
	{
		LogInternal("Remote events:");
		ClientMessage("Remote events:",, 15.0000000);
		Idx = 0;
		J0x19A:

		// End:0x276 [Loop If]
		if(Idx < AllRemoteEvents.Length)
		{
			RemoteEvt = SeqEvent_RemoteEvent(AllRemoteEvents[Idx]);
			// End:0x268
			if((RemoteEvt != none) && RemoteEvt.bEnabled)
			{
				LogInternal("-" @ string(RemoteEvt.EventName));
				ClientMessage("-" @ string(RemoteEvt.EventName),, 15.0000000);
			}
			Idx++;
			// [Loop Continue]
			goto J0x19A;
		}
	}
	//return;	
}

exec function ShowPlayerState()
{
	LogInternal("Dumping state stack for" @ string(self));
	DumpStateStack();
	//return;	
}

exec function ShowGameState()
{
	// End:0xDF
	if(WorldInfo.Game != none)
	{
		LogInternal((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ": Dumping state stack for") @ string(WorldInfo.Game));
		WorldInfo.Game.DumpStateStack();		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ": No GameInfo found!");
	}
	//return;	
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
	ClientPlayForceFeedbackWaveform(DamageType.default.DamagedFFWaveform);
	//return;	
}

function OnForceFeedback(SeqAct_ForceFeedback Action)
{
	// End:0x63
	if(Action.InputLinks[0].bHasImpulse)
	{
		ClientPlayForceFeedbackWaveform(Action.FFWaveform);		
	}
	else
	{
		// End:0xC2
		if(Action.InputLinks[1].bHasImpulse)
		{
			ClientStopForceFeedbackWaveform(Action.FFWaveform);
		}
	}
	//return;	
}

event PlayRumble(const AnimNotify_Rumble TheAnimNotify)
{
	// End:0x65
	if(TheAnimNotify.PredefinedWaveForm != none)
	{
		ClientPlayForceFeedbackWaveform(TheAnimNotify.PredefinedWaveForm.default.TheWaveForm);		
	}
	else
	{
		ClientPlayForceFeedbackWaveform(TheAnimNotify.WaveForm);
	}
	//return;	
}

reliable client simulated event ClientPlayForceFeedbackWaveform(ForceFeedbackWaveform FFWaveform, optional Actor FFWaveformInstigator)
{
	// End:0x60
	if(((PlayerInput != none) && !PlayerInput.bUsingGamepad) && !WorldInfo.IsConsoleBuild(0))
	{
		return;
	}
	// End:0xC0
	if(((ForceFeedbackManager != none) && PlayerReplicationInfo != none) && IsForceFeedbackAllowed())
	{
		ForceFeedbackManager.PlayForceFeedbackWaveform(FFWaveform, FFWaveformInstigator);
	}
	//return;	
}

reliable client final simulated event ClientStopForceFeedbackWaveform(optional ForceFeedbackWaveform FFWaveform)
{
	// End:0x38
	if(ForceFeedbackManager != none)
	{
		ForceFeedbackManager.StopForceFeedbackWaveform(FFWaveform);
	}
	//return;	
}

simulated function bool IsForceFeedbackAllowed()
{
	return (ForceFeedbackManager != none) && ForceFeedbackManager.bAllowsForceFeedback;
	//return ReturnValue;	
}

function OnToggleCinematicMode(SeqAct_ToggleCinematicMode Action)
{
	local bool bNewCinematicMode;

	// End:0x31
	if(Role < ROLE_Authority)
	{
		WarnInternal("Not supported on client");
		return;
	}
	// End:0x77
	if(Action.InputLinks[0].bHasImpulse)
	{
		bNewCinematicMode = true;		
	}
	else
	{
		// End:0xBD
		if(Action.InputLinks[1].bHasImpulse)
		{
			bNewCinematicMode = false;			
		}
		else
		{
			// End:0x10C
			if(Action.InputLinks[2].bHasImpulse)
			{
				bNewCinematicMode = !bCinematicMode;
			}
		}
	}
	SetCinematicMode(bNewCinematicMode, Action.bHidePlayer, Action.bHideHUD, Action.bDisableMovement, Action.bDisableTurning, Action.bDisableInput);
	//return;	
}

function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons)
{
	local bool bAdjustMoveInput, bAdjustLookInput;

	bCinematicMode = bInCinematicMode;
	// End:0x63
	if(bCinematicMode)
	{
		// End:0x60
		if((Pawn != none) && bHidePlayer)
		{
			Pawn.SetHidden(true);
		}		
	}
	else
	{
		// End:0x92
		if(Pawn != none)
		{
			Pawn.SetHidden(false);
		}
	}
	bAdjustMoveInput = bAffectsMovement && bCinematicMode != bCinemaDisableInputMove;
	bAdjustLookInput = bAffectsTurning && bCinematicMode != bCinemaDisableInputLook;
	// End:0x128
	if(bAdjustMoveInput)
	{
		IgnoreMoveInput(bCinematicMode);
		bCinemaDisableInputMove = bCinematicMode;
	}
	// End:0x15E
	if(bAdjustLookInput)
	{
		IgnoreLookInput(bCinematicMode);
		bCinemaDisableInputLook = bCinematicMode;
	}
	ClientSetCinematicMode(bCinematicMode, bAdjustMoveInput, bAdjustLookInput, bAffectsHUD);
	//return;	
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
	bCinematicMode = bInCinematicMode;
	// End:0x5F
	if((myHUD != none) && bAffectsHUD)
	{
		myHUD.bShowHUD = !bCinematicMode;
	}
	// End:0x80
	if(bAffectsMovement)
	{
		IgnoreMoveInput(bCinematicMode);
	}
	// End:0xA1
	if(bAffectsTurning)
	{
		IgnoreLookInput(bCinematicMode);
	}
	//return;	
}

function IgnoreMoveInput(bool bNewMoveInput)
{
	bIgnoreMoveInput = byte(Max(int(bIgnoreMoveInput) + ((bNewMoveInput) ? 1 : -1), 0));
	//return;	
}

event bool IsMoveInputIgnored()
{
	return int(bIgnoreMoveInput) > 0;
	//return ReturnValue;	
}

function IgnoreLookInput(bool bNewLookInput)
{
	bIgnoreLookInput = byte(Max(int(bIgnoreLookInput) + ((bNewLookInput) ? 1 : -1), 0));
	//return;	
}

event bool IsLookInputIgnored()
{
	return int(bIgnoreLookInput) > 0;
	//return ReturnValue;	
}

function ResetPlayerMovementInput()
{
	bIgnoreMoveInput = default.bIgnoreMoveInput;
	bIgnoreLookInput = default.bIgnoreLookInput;
	//return;	
}

function OnConsoleCommand(SeqAct_ConsoleCommand inAction)
{
	local string Command;

	// End:0x85
	foreach inAction.Commands(Command)
	{
		// End:0x84
		if(!(Left(Command, 4) ~= "set ") && !(Left(Command, 9) ~= "setnopec "))
		{			
			ConsoleCommand(Command);
		}		
	}	
	//return;	
}

reliable client simulated event ClientForceGarbageCollection()
{
	WorldInfo.ForceGarbageCollection();
	//return;	
}

event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
	ClientUpdateLevelStreamingStatus(LevelObject.PackageName, bNewShouldBeLoaded, bNewShouldBeVisible, bNewShouldBlockOnLoad);
	//return;	
}

// Export UPlayerController::execClientUpdateLevelStreamingStatus(FFrame&, void* const)
reliable client native simulated function ClientUpdateLevelStreamingStatus(name PackageName, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad);

// Export UPlayerController::execServerUpdateLevelVisibility(FFrame&, void* const)
reliable server native final event ServerUpdateLevelVisibility(name PackageName, bool bIsVisible);

reliable client simulated event ClientPrepareMapChange(name LevelName, bool bFirst, bool bLast)
{
	local PlayerController PC;

	// End:0x38
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x34
		if(PC != self)
		{			
			return;
			// End:0x37
			continue;
		}
		// End:0x38
		break;		
	}	
	// End:0x66
	if(bFirst)
	{
		PendingMapChangeLevelNames.Length = 0;
		ClearTimer('DelayedPrepareMapChange');
	}
	PendingMapChangeLevelNames[PendingMapChangeLevelNames.Length] = LevelName;
	// End:0x9B
	if(bLast)
	{
		DelayedPrepareMapChange();
	}
	//return;	
}

function DelayedPrepareMapChange()
{
	// End:0x38
	if(WorldInfo.IsPreparingMapChange())
	{
		SetTimer(0.0100000, false, 'DelayedPrepareMapChange');		
	}
	else
	{
		WorldInfo.PrepareMapChange(PendingMapChangeLevelNames);
	}
	//return;	
}

reliable client simulated event ClientCommitMapChange()
{
	// End:0x2D
	if(IsTimerActive('DelayedPrepareMapChange'))
	{
		SetTimer(0.0100000, false, 'ClientCommitMapChange');		
	}
	else
	{
		// End:0x53
		if(Pawn != none)
		{
			SetViewTarget(Pawn);			
		}
		else
		{
			SetViewTarget(self);
		}
		WorldInfo.CommitMapChange();
	}
	//return;	
}

reliable client simulated event ClientCancelPendingMapChange()
{
	WorldInfo.CancelPendingMapChange();
	//return;	
}

// Export UPlayerController::execClientFlushLevelStreaming(FFrame&, void* const)
reliable client native final simulated event ClientFlushLevelStreaming();

reliable client simulated event ClientSetBlockOnAsyncLoading()
{
	WorldInfo.bRequestedBlockOnAsyncLoading = true;
	//return;	
}

reliable client simulated function ClientWaitForLevelsVisible(SeqAct_WaitForLevelsVisible inAction)
{
	inAction.CheckLevelsVisible();
	//return;	
}

exec function SaveClassConfig(coerce string ClassName)
{
	local Class saveClass;

	LogInternal("SaveClassConfig:" @ ClassName);
	saveClass = Class<Object>(DynamicLoadObject(ClassName, Class'Core.Class'));
	// End:0xA6
	if(saveClass != none)
	{
		LogInternal("- Saving config on:" @ string(saveClass));
		saveClass.static.StaticSaveConfig();		
	}
	else
	{
		LogInternal("- Failed to find class:" @ ClassName);
	}
	//return;	
}

exec function SaveActorConfig(coerce name actorName)
{
	local Actor ChkActor;

	LogInternal("SaveActorConfig:" @ string(actorName));
	// End:0xB6
	foreach AllActors(Class'Engine.Actor', ChkActor)
	{
		// End:0xB5
		if((ChkActor != none) && ChkActor.Name == actorName)
		{
			LogInternal("- Saving config on:" @ string(ChkActor));
			ChkActor.SaveConfig();
		}		
	}	
	//return;	
}

final function UIInteraction GetUIController()
{
	local LocalPlayer LP;
	local UIInteraction Result;

	LP = LocalPlayer(Player);
	// End:0x8E
	if((LP != none) && LP.ViewportClient != none)
	{
		Result = LP.ViewportClient.UIController;
	}
	return Result;
	//return ReturnValue;	
}

// Export UPlayerController::execIsPlayerMuted(FFrame&, void* const)
native final function bool IsPlayerMuted(const out UniqueNetId Sender);

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	HearSoundActiveComponents.Length = 0;
	HearSoundPoolComponents.Length = 0;
	// End:0x45
	if(myHUD != none)
	{
		ActorList[ActorList.Length] = myHUD;
	}
	//return;	
}

function SeamlessTravelTo(PlayerController NewPC)
{
	//return;	
}

function SeamlessTravelFrom(PlayerController OldPC)
{
	OldPC.PlayerReplicationInfo.Reset();
	OldPC.PlayerReplicationInfo.SeamlessTravelTo(PlayerReplicationInfo);
	OldPC.bIsPlayer = false;
	OldPC.PlayerReplicationInfo.Destroy();
	OldPC.PlayerReplicationInfo = none;
	//return;	
}

reliable client simulated function ClientSetOnlineStatus()
{
	//return;	
}

// Export UPlayerController::execGetPlayerControllerFromNetId(FFrame&, void* const)
native static function PlayerController GetPlayerControllerFromNetId(UniqueNetId PlayerNetId);

reliable client simulated function ClientVoiceHandshakeComplete()
{
	local int PeerIdx;

	bHasVoiceHandshakeCompleted = true;
	PeerIdx = 0;
	J0x17:

	// End:0x93 [Loop If]
	if(PeerIdx < ConnectedPeers.Length)
	{
		ServerAddPeer(ConnectedPeers[PeerIdx].PlayerID, ConnectedPeers[PeerIdx].NatType);
		PeerIdx++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

reliable client simulated event ClientMutePlayer(UniqueNetId PlayerNetId)
{
	local LocalPlayer LocPlayer;

	// End:0x52
	if(VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
	{
		VoicePacketFilter.AddItem(PlayerNetId);
	}
	// End:0xE7
	if(NotEqual_InterfaceInterface(VoiceInterface, none))
	{
		LocPlayer = LocalPlayer(Player);
		// End:0xE7
		if(LocPlayer != none)
		{
			VoiceInterface.MuteRemoteTalker(byte(LocPlayer.ControllerId), PlayerNetId);
		}
	}
	//return;	
}

reliable client simulated event ClientUnmutePlayer(UniqueNetId PlayerNetId)
{
	local LocalPlayer LocPlayer;
	local int RemoveIndex;

	RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
	// End:0x64
	if(RemoveIndex != -1)
	{
		VoicePacketFilter.Remove(RemoveIndex, 1);
	}
	// End:0xF9
	if(NotEqual_InterfaceInterface(VoiceInterface, none))
	{
		LocPlayer = LocalPlayer(Player);
		// End:0xF9
		if(LocPlayer != none)
		{
			VoiceInterface.UnmuteRemoteTalker(byte(LocPlayer.ControllerId), PlayerNetId);
		}
	}
	//return;	
}

function GameplayMutePlayer(UniqueNetId PlayerNetId)
{
	// End:0x52
	if(GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1)
	{
		GameplayVoiceMuteList.AddItem(PlayerNetId);
	}
	// End:0xA4
	if(VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
	{
		VoicePacketFilter.AddItem(PlayerNetId);
	}
	ClientMutePlayer(PlayerNetId);
	//return;	
}

function GameplayUnmutePlayer(UniqueNetId PlayerNetId)
{
	local int RemoveIndex;
	local PlayerController Other;

	RemoveIndex = GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid);
	// End:0x64
	if(RemoveIndex != -1)
	{
		GameplayVoiceMuteList.Remove(RemoveIndex, 1);
	}
	Other = GetPlayerControllerFromNetId(PlayerNetId);
	// End:0x1AB
	if(Other != none)
	{
		// End:0x1AB
		if((VoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1) && Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
		{
			RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
			// End:0x198
			if(RemoveIndex != -1)
			{
				VoicePacketFilter.Remove(RemoveIndex, 1);
			}
			ClientUnmutePlayer(PlayerNetId);
		}
	}
	//return;	
}

reliable server event ServerMutePlayer(UniqueNetId PlayerNetId)
{
	local PlayerController Other;

	// End:0x52
	if(VoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1)
	{
		VoiceMuteList.AddItem(PlayerNetId);
	}
	// End:0xA4
	if(VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
	{
		VoicePacketFilter.AddItem(PlayerNetId);
	}
	ClientMutePlayer(PlayerNetId);
	Other = GetPlayerControllerFromNetId(PlayerNetId);
	// End:0x1C6
	if(Other != none)
	{
		// End:0x189
		if(Other.VoicePacketFilter.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
		{
			Other.VoicePacketFilter.AddItem(PlayerReplicationInfo.UniqueId);
		}
		Other.ClientMutePlayer(PlayerReplicationInfo.UniqueId);
	}
	//return;	
}

reliable server event ServerUnmutePlayer(UniqueNetId PlayerNetId)
{
	local PlayerController Other;
	local int RemoveIndex;

	RemoveIndex = VoiceMuteList.Find('Uid', PlayerNetId.Uid);
	// End:0x64
	if(RemoveIndex != -1)
	{
		VoiceMuteList.Remove(RemoveIndex, 1);
	}
	Other = GetPlayerControllerFromNetId(PlayerNetId);
	// End:0x359
	if(Other != none)
	{
		// End:0x147
		if((GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1) && Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
		{
			ClientUnmutePlayer(PlayerNetId);
		}
		// End:0x359
		if((Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1) && Other.GameplayVoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
		{
			RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
			// End:0x279
			if(RemoveIndex != -1)
			{
				VoicePacketFilter.Remove(RemoveIndex, 1);
			}
			RemoveIndex = Other.VoicePacketFilter.Find('Uid', PlayerReplicationInfo.UniqueId.Uid);
			// End:0x31C
			if(RemoveIndex != -1)
			{
				Other.VoicePacketFilter.Remove(RemoveIndex, 1);
			}
			Other.ClientUnmutePlayer(PlayerReplicationInfo.UniqueId);
		}
	}
	//return;	
}

event NotifyDirectorControl(bool bNowControlling, SeqAct_Interp CurrentMatinee)
{
	// End:0x53
	if((!bNowControlling && WorldInfo.NetMode == NM_Client) && bClientSimulatingViewTarget)
	{
		ServerVerifyViewTarget();
	}
	//return;	
}

// Export UPlayerController::execSetShowSubtitles(FFrame&, void* const)
native simulated exec function SetShowSubtitles(bool bValue);

// Export UPlayerController::execIsShowingSubtitles(FFrame&, void* const)
native simulated function bool IsShowingSubtitles();

reliable client simulated event ClientWasKicked()
{
	//return;	
}

reliable client simulated function ClientRegisterForArbitration()
{
	// End:0xCD
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
	{
		OnlineSub.GameInterface.AddArbitrationRegistrationCompleteDelegate(OnArbitrationRegisterComplete);
		OnlineSub.GameInterface.RegisterForArbitration('Game');		
	}
	else
	{
		ServerRegisteredForArbitration(true);
	}
	//return;	
}

function OnArbitrationRegisterComplete(name SessionName, bool bWasSuccessful)
{
	OnlineSub.GameInterface.ClearArbitrationRegistrationCompleteDelegate(OnArbitrationRegisterComplete);
	ServerRegisteredForArbitration(bWasSuccessful);
	//return;	
}

reliable server function ServerRegisteredForArbitration(bool bWasSuccessful)
{
	WorldInfo.Game.ProcessClientRegistrationCompletion(self, bWasSuccessful);
	//return;	
}

function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
	local OnlineGameSettings GameInviteSettings;

	// End:0x35C
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
	{
		GameInviteSettings = InviteResult.GameSettings;
		// End:0x352
		if(GameInviteSettings != none)
		{
			// End:0x345
			if(InviteHasEnoughSpace(GameInviteSettings))
			{
				// End:0x338
				if(CanAllPlayersPlayOnline())
				{
					// End:0x233
					if(WorldInfo.NetMode != NM_Standalone)
					{
						// End:0x1AC
						if(OnlineSub.GameInterface.GetGameSettings('Game').bUsesArbitration)
						{
							ClientWriteOnlinePlayerScores(((WorldInfo.GRI.GameClass != none) ? WorldInfo.GRI.GameClass.default.ArbitratedLeaderboardId : 0));
						}
						OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
						OnlineSub.GameInterface.EndOnlineGame('Game');						
					}
					else
					{
						OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
						// End:0x335
						if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Game'))
						{
							OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
							NotifyInviteFailed();
						}
					}					
				}
				else
				{
					NotifyNotAllPlayersCanJoinInvite();
				}				
			}
			else
			{
				NotifyNotEnoughSpaceInInvite();
			}			
		}
		else
		{
			NotifyInviteFailed();
		}
	}
	//return;	
}

function bool InviteHasEnoughSpace(OnlineGameSettings InviteSettings)
{
	local int NumLocalPlayers;
	local PlayerController PC;

	// End:0x2B
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		NumLocalPlayers++;		
	}	
	return (InviteSettings.NumOpenPrivateConnections + InviteSettings.NumOpenPublicConnections) >= NumLocalPlayers;
	//return ReturnValue;	
}

function bool CanAllPlayersPlayOnline()
{
	local PlayerController PC;
	local LocalPlayer LocPlayer;

	// End:0x12B
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		LocPlayer = LocalPlayer(PC.Player);
		// End:0x127
		if(LocPlayer != none)
		{
			// End:0x124
			if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) != 2) || int(OnlineSub.PlayerInterface.CanPlayOnline(byte(LocPlayer.ControllerId))) == 0)
			{				
				return false;
			}
			// End:0x12A
			continue;
		}		
		return false;		
	}	
	return true;
	//return ReturnValue;	
}

function ClearInviteDelegates()
{
	OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
	OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyForInviteComplete);
	OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
	//return;	
}

function OnEndForInviteComplete(name SessionName, bool bWasSuccessful)
{
	OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyForInviteComplete);
	OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
	//return;	
}

function OnDestroyForInviteComplete(name SessionName, bool bWasSuccessful)
{
	// End:0x112
	if(bWasSuccessful)
	{
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
		// End:0x10F
		if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), SessionName))
		{
			OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
			NotifyInviteFailed();
		}		
	}
	else
	{
		NotifyInviteFailed();
	}
	//return;	
}

function string ModifyClientURL(string URL)
{
	return URL;
	//return ReturnValue;	
}

function OnInviteJoinComplete(name SessionName, bool bWasSuccessful)
{
	local string URL;

	// End:0x120
	if(bWasSuccessful)
	{
		// End:0x11D
		if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
		{
			// End:0x11D
			if(OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
			{				
				URL $= "?bIsFromInvite";
				URL = ModifyClientURL(URL);
				LogInternal(("Resulting url is (" $ URL) $ ")");
				ClientTravel(URL, 0);
			}
		}		
	}
	else
	{
		NotifyInviteFailed();
	}
	ClearInviteDelegates();
	//return;	
}

function NotifyInviteFailed()
{
	LogInternal("Invite handling failed");
	ClearInviteDelegates();
	//return;	
}

function NotifyNotAllPlayersCanJoinInvite()
{
	LogInternal("Not all local players have permission to join the game invite");
	//return;	
}

function NotifyNotEnoughSpaceInInvite()
{
	LogInternal("Not enough space for all local players in the game invite");
	//return;	
}

reliable client simulated function ClientArbitratedMatchEnded()
{
	ConsoleCommand("Disconnect");
	//return;	
}

reliable client simulated function ClientWriteOnlinePlayerScores(int LeaderboardId)
{
	local GameReplicationInfo GRI;
	local int Index;
	local array<OnlinePlayerScore> PlayerScores;
	local UniqueNetId ZeroUniqueId;
	local bool bIsTeamGame;
	local int ScoreIndex;

	GRI = WorldInfo.GRI;
	// End:0x4DD
	if(((GRI != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, none))
	{
		bIsTeamGame = ((GRI.GameClass != none) ? GRI.GameClass.default.bTeamGame : false);
		Index = 0;
		J0xF0:

		// End:0x478 [Loop If]
		if(Index < GRI.PRIArray.Length)
		{
			// End:0x46A
			if(GRI.PRIArray[Index].UniqueId != ZeroUniqueId)
			{
				// End:0x345
				if(bIsTeamGame)
				{
					// End:0x342
					if(GRI.PRIArray[Index].Team != none)
					{
						ScoreIndex = PlayerScores.Length;
						PlayerScores.Length = ScoreIndex + 1;
						PlayerScores[ScoreIndex].PlayerID = GRI.PRIArray[Index].UniqueId;
						PlayerScores[ScoreIndex].TeamID = GRI.PRIArray[Index].Team.TeamIndex;
						PlayerScores[ScoreIndex].Score = int(GRI.PRIArray[Index].Team.Score);
					}					
				}
				else
				{
					ScoreIndex = PlayerScores.Length;
					PlayerScores.Length = ScoreIndex + 1;
					PlayerScores[ScoreIndex].PlayerID = GRI.PRIArray[Index].UniqueId;
					PlayerScores[ScoreIndex].TeamID = Index;
					PlayerScores[ScoreIndex].Score = int(GRI.PRIArray[Index].Score);
				}
			}
			Index++;
			// [Loop Continue]
			goto J0xF0;
		}
		OnlineSub.StatsInterface.WriteOnlinePlayerScores(PlayerReplicationInfo.SessionName, LeaderboardId, PlayerScores);
	}
	//return;	
}

reliable client simulated function ClientWriteLeaderboardStats(Class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete = false)
{
	//return;	
}

reliable client simulated function ClientSetHostUniqueId(UniqueNetId InHostId)
{
	//return;	
}

reliable client simulated function ClientStopNetworkedVoice()
{
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);
	// End:0xC8
	if(((LocPlayer != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, none))
	{
		OnlineSub.VoiceInterface.StopNetworkedVoice(byte(LocPlayer.ControllerId));
	}
	//return;	
}

reliable client simulated function ClientStartNetworkedVoice()
{
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);
	// End:0xC8
	if(((LocPlayer != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, none))
	{
		OnlineSub.VoiceInterface.StartNetworkedVoice(byte(LocPlayer.ControllerId));
	}
	//return;	
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
	Action.ScriptLog("Cannot use Destroy action on players");
	//return;	
}

exec function ConsoleKey(name Key)
{
	// End:0x78
	if(LocalPlayer(Player) != none)
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.InputKey(0, Key, 0);
	}
	//return;	
}

exec function SendToConsole(string Command)
{
	// End:0x73
	if(LocalPlayer(Player) != none)
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.ConsoleCommand(Command);
	}
	//return;	
}

final simulated function DrawDebugTextList(Canvas Canvas, float RenderDelta)
{
	local Vector CameraLoc, ScreenLoc, Offset, WorldTextLoc;
	local Rotator CameraRot;
	local int Idx;

	// End:0x5D0
	if(DebugTextList.Length > 0)
	{
		GetPlayerViewPoint(CameraLoc, CameraRot);
		Canvas.SetDrawColor(255, 255, 255);
		Idx = 0;
		J0x5D:

		// End:0x5D0 [Loop If]
		if(Idx < DebugTextList.Length)
		{
			// End:0xBB
			if(DebugTextList[Idx].SrcActor == none)
			{
				DebugTextList.Remove(Idx--, 1);				
			}
			else
			{
				// End:0x166
				if(DebugTextList[Idx].TimeRemaining != -1.0000000)
				{
					DebugTextList[Idx].TimeRemaining -= RenderDelta;
					// End:0x166
					if(DebugTextList[Idx].TimeRemaining <= 0.0000000)
					{
						DebugTextList.Remove(Idx--, 1);
						// [Explicit Continue]
						goto J0x5C2;
					}
				}
				// End:0x1DA
				if(DebugTextList[Idx].Font != none)
				{
					Canvas.Font = DebugTextList[Idx].Font;					
				}
				else
				{
					Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
				}
				// End:0x2FA
				if(DebugTextList[Idx].bAbsoluteLocation)
				{
					WorldTextLoc = VLerp(DebugTextList[Idx].SrcActorOffset, DebugTextList[Idx].SrcActorDesiredOffset, 1.0000000 - (DebugTextList[Idx].TimeRemaining / DebugTextList[Idx].Duration));					
				}
				else
				{
					Offset = VLerp(DebugTextList[Idx].SrcActorOffset, DebugTextList[Idx].SrcActorDesiredOffset, 1.0000000 - (DebugTextList[Idx].TimeRemaining / DebugTextList[Idx].Duration));
					// End:0x438
					if(DebugTextList[Idx].bKeepAttachedToActor)
					{
						WorldTextLoc = DebugTextList[Idx].SrcActor.Location + (Offset >> CameraRot);						
					}
					else
					{
						WorldTextLoc = DebugTextList[Idx].OrigActorLocation + (Offset >> CameraRot);
					}
				}
				// End:0x5C2
				if(((WorldTextLoc - CameraLoc) Dot Vector(CameraRot)) > 0.0000000)
				{
					ScreenLoc = Canvas.Project(WorldTextLoc);
					Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
					Canvas.DrawColor = DebugTextList[Idx].TextColor;
					Canvas.DrawText(DebugTextList[Idx].DebugText);
				}
			}
			J0x5C2:

			Idx++;
			// [Loop Continue]
			goto J0x5D;
		}
	}
	//return;	
}

reliable client simulated event AddDebugText(string DebugText, optional Actor SrcActor, optional float Duration = -1.0000000, optional Vector Offset, optional Vector DesiredOffset, optional Color TextColor, optional bool bSkipOverwriteCheck, optional bool bAbsoluteLocation, optional bool bKeepAttachedToActor = true, optional Font InFont)
{
	local int Idx;

	// End:0x133
	if((((int(TextColor.R) == 0) && int(TextColor.G) == 0) && int(TextColor.B) == 0) && int(TextColor.A) == 0)
	{
		TextColor.R = 255;
		TextColor.G = 255;
		TextColor.B = 255;
		TextColor.A = 255;
	}
	// End:0x436
	if(SrcActor != none)
	{
		// End:0x169
		if(Len(DebugText) == 0)
		{
			RemoveDebugText(SrcActor);			
		}
		else
		{
			// End:0x1E2
			if(!bSkipOverwriteCheck)
			{
				Idx = DebugTextList.Find('SrcActor', SrcActor);
				// End:0x1DF
				if(Idx == -1)
				{
					Idx = DebugTextList.Length;
					DebugTextList.Length = Idx + 1;
				}				
			}
			else
			{
				Idx = DebugTextList.Length;
				DebugTextList.Length = Idx + 1;
			}
			DebugTextList[Idx].SrcActor = SrcActor;
			DebugTextList[Idx].SrcActorOffset = Offset;
			DebugTextList[Idx].SrcActorDesiredOffset = DesiredOffset;
			DebugTextList[Idx].DebugText = DebugText;
			DebugTextList[Idx].TimeRemaining = Duration;
			DebugTextList[Idx].Duration = Duration;
			DebugTextList[Idx].TextColor = TextColor;
			DebugTextList[Idx].bAbsoluteLocation = bAbsoluteLocation;
			DebugTextList[Idx].bKeepAttachedToActor = bKeepAttachedToActor;
			DebugTextList[Idx].OrigActorLocation = SrcActor.Location;
			DebugTextList[Idx].Font = InFont;
		}
	}
	//return;	
}

reliable client final simulated event RemoveDebugText(Actor SrcActor)
{
	local int Idx;

	Idx = DebugTextList.Find('SrcActor', SrcActor);
	// End:0x51
	if(Idx != -1)
	{
		DebugTextList.Remove(Idx, 1);
	}
	//return;	
}

reliable client final simulated event RemoveAllDebugStrings()
{
	DebugTextList.Length = 0;
	//return;	
}

reliable client simulated function ClientRegisterHostStatGuid(string StatGuid)
{
	// End:0xDB
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, none))
	{
		OnlineSub.StatsInterface.AddRegisterHostStatGuidCompleteDelegate(OnRegisterHostStatGuidComplete);
		// End:0xDB
		if(OnlineSub.StatsInterface.RegisterHostStatGuid(StatGuid) == false)
		{
			OnRegisterHostStatGuidComplete(false);
		}
	}
	//return;	
}

function OnRegisterHostStatGuidComplete(bool bWasSuccessful)
{
	local string StatGuid;

	OnlineSub.StatsInterface.ClearRegisterHostStatGuidCompleteDelegateDelegate(OnRegisterHostStatGuidComplete);
	// End:0xA5
	if(bWasSuccessful)
	{
		StatGuid = OnlineSub.StatsInterface.GetClientStatGuid();
		ServerRegisterClientStatGuid(StatGuid);
	}
	//return;	
}

reliable server function ServerRegisterClientStatGuid(string StatGuid)
{
	// End:0xA2
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, none))
	{
		OnlineSub.StatsInterface.RegisterStatGuid(PlayerReplicationInfo.UniqueId, StatGuid);
	}
	//return;	
}

reliable client simulated function ClientStartOnlineGame()
{
	local OnlineGameSettings GameSettings;

	// End:0x16A
	if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none)) && IsPrimaryPlayer())
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
		// End:0x16A
		if((GameSettings != none) && (int(GameSettings.GameState) == 1) || int(GameSettings.GameState) == 5)
		{
			OnlineSub.GameInterface.StartOnlineGame(PlayerReplicationInfo.SessionName);
		}
	}
	//return;	
}

reliable client simulated function ClientEndOnlineGame()
{
	local OnlineGameSettings GameSettings;

	// End:0x13F
	if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none)) && IsPrimaryPlayer())
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
		// End:0x13F
		if((GameSettings != none) && int(GameSettings.GameState) == 3)
		{
			OnlineSub.GameInterface.EndOnlineGame(PlayerReplicationInfo.SessionName);
		}
	}
	//return;	
}

function bool CanViewUserCreatedContent()
{
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);
	// End:0xD1
	if(((LocPlayer != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
	{
		return int(OnlineSub.PlayerInterface.CanDownloadUserContent(byte(LocPlayer.ControllerId))) == 2;
	}
	return true;
	//return ReturnValue;	
}

function IncrementNumberOfMatchesPlayed()
{
	LogInternal("  Num Matches Played: " $ string(PlayerReplicationInfo.AutomatedTestingData.NumberOfMatchesPlayed));
	PlayerReplicationInfo.AutomatedTestingData.NumberOfMatchesPlayed++;
	//return;	
}

event SoakPause(Pawn P)
{
	LogInternal("Soak pause by " $ string(P));
	SetViewTarget(P);
	SetPause(true);
	myHUD.bShowDebugInfo = true;
	//return;	
}

exec function PathStep(optional int Cnt)
{
	Pawn.IncrementPathStep(Max(1, Cnt), myHUD.Canvas);
	//return;	
}

exec function PathChild(optional int Cnt)
{
	Pawn.IncrementPathChild(Max(1, Cnt), myHUD.Canvas);
	//return;	
}

exec function PathClear()
{
	Pawn.ClearPathStep();
	//return;	
}

reliable client simulated function ClientTravelToSession(name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
	local OnlineGameSearch Search;
	local LocalPlayer LP;
	local OnlineGameSearchResult SessionToJoin;

	LP = LocalPlayer(Player);
	// End:0x2D2
	if(LP != none)
	{
		Search = new SearchClass;
		// End:0x2D2
		if(OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(byte(LP.ControllerId), Search, PlatformSpecificInfo))
		{
			SessionToJoin = Search.Results[0];
			LogInternal(((((((("(PlayerController.ClientTravelToSession): " $ " SessionName=") $ string(SessionName)) $ " SearchClass=") $ string(SearchClass)) $ " UniqueId=") $ OnlineSub.UniqueNetIdToString(PlayerReplicationInfo.UniqueId)) $ " Session.OwnerId=") $ OnlineSub.UniqueNetIdToString(SessionToJoin.GameSettings.OwningPlayerId));
			PreJoinUpdateGameSettings(SessionName, SessionToJoin.GameSettings);
			OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinTravelToSessionComplete);
			OnlineSub.GameInterface.JoinOnlineGame(byte(LP.ControllerId), SessionName, SessionToJoin);
		}
	}
	//return;	
}

simulated function PreJoinUpdateGameSettings(name SessionName, OnlineGameSettings GameSettings)
{
	//return;	
}

function OnJoinTravelToSessionComplete(name SessionName, bool bWasSuccessful)
{
	local string URL;

	// End:0xA0
	if(bWasSuccessful)
	{
		// End:0xA0
		if(OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
		{
			LogInternal(("Resulting url for 'Game' is (" $ URL) $ ")");
			ClientTravel(URL, 0);
		}
	}
	//return;	
}

reliable client simulated function ClientReturnToParty(UniqueNetId RequestingPlayerId)
{
	local string URL;

	WorldInfo.ToggleHostMigration(false);
	// End:0x204
	if(IsPrimaryPlayer())
	{
		// End:0x1E4
		if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none)) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
		{
			// End:0x1C1
			if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
			{
				// End:0x15D
				if(IsPartyLeader())
				{
					URL = (((GetPartyMapName()) $ "?game=") $ (GetPartyGameTypeName())) $ "?listen";
					WorldInfo.ServerTravel(URL, true, true);					
				}
				else
				{
					// End:0x1BE
					if(OnlineSub.GameInterface.GetResolvedConnectString('Party', URL))
					{
						ClientTravel(URL, 0);
					}
				}				
			}
			else
			{				
				ConsoleCommand("disconnect");
			}			
		}
		else
		{			
			ConsoleCommand("disconnect");
		}
	}
	//return;	
}

reliable client simulated function ClientNotifyPartyHostLeaving(UniqueNetId PartyHostPlayerId)
{
	// End:0xE5
	if((PlayerReplicationInfo != none) && PlayerReplicationInfo.UniqueId != PartyHostPlayerId)
	{
		LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Party host is leaving: ") $ " PartyHostPlayerId=") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PartyHostPlayerId));
	}
	//return;	
}

reliable server function ServerNotifyPartyHostLeaving(UniqueNetId PartyHostPlayerId)
{
	// End:0x61
	if(WorldInfo.Game != none)
	{
		WorldInfo.Game.TellClientsPartyHostIsLeaving(PartyHostPlayerId);
	}
	//return;	
}

final simulated function bool IsPrimaryPlayer()
{
	local int SSIndex;

	return !IsSplitscreenPlayer(SSIndex) || SSIndex == 0;
	//return ReturnValue;	
}

final simulated function bool IsSplitscreenPlayer(optional out int out_SplitscreenPlayerIndex)
{
	local bool bResult;
	local LocalPlayer LP;
	local NetConnection RemoteConnection;
	local ChildConnection ChildRemoteConnection;

	out_SplitscreenPlayerIndex = int(NetPlayerIndex);
	// End:0x1E6
	if(Player != none)
	{
		LP = LocalPlayer(Player);
		// End:0xE3
		if(LP != none)
		{
			// End:0xE0
			if(LP.Outer.GamePlayers.Length > 1)
			{
				out_SplitscreenPlayerIndex = LP.Outer.GamePlayers.Find(LP);
				bResult = true;
			}			
		}
		else
		{
			RemoteConnection = NetConnection(Player);
			// End:0x13E
			if(RemoteConnection.Children.Length > 0)
			{
				out_SplitscreenPlayerIndex = 0;
				bResult = true;				
			}
			else
			{
				ChildRemoteConnection = ChildConnection(RemoteConnection);
				// End:0x1E6
				if(ChildRemoteConnection != none)
				{
					// End:0x1DA
					if(ChildRemoteConnection.Parent != none)
					{
						out_SplitscreenPlayerIndex = ChildRemoteConnection.Parent.Children.Find(ChildRemoteConnection) + 1;
					}
					bResult = true;
				}
			}
		}
	}
	return bResult;
	//return ReturnValue;	
}

simulated function PlayerReplicationInfo GetSplitscreenPlayerByIndex(optional int PlayerIndex = 1)
{
	local PlayerReplicationInfo Result;
	local LocalPlayer LP, SplitPlayer;
	local NetConnection MasterConnection, RemoteConnection;
	local ChildConnection ChildRemoteConnection;

	// End:0x6C7
	if(Player != none)
	{
		// End:0x6C4
		if(IsSplitscreenPlayer())
		{
			LP = LocalPlayer(Player);
			RemoteConnection = NetConnection(Player);
			// End:0x269
			if(LP != none)
			{
				// End:0x16D
				if((PlayerIndex >= 0) && PlayerIndex < LP.ViewportClient.Outer.GamePlayers.Length)
				{
					SplitPlayer = LP.ViewportClient.Outer.GamePlayers[PlayerIndex];
					Result = SplitPlayer.Actor.PlayerReplicationInfo;					
				}
				else
				{
					WarnInternal((((((((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ":") @ "requested player at invalid index!") @ "PlayerIndex:'") $ string(PlayerIndex)) $ "'") @ "NumLocalPlayers:'") $ string(LP.ViewportClient.Outer.GamePlayers.Length)) $ "'");
				}				
			}
			else
			{
				// End:0x61D
				if(RemoteConnection != none)
				{
					// End:0x322
					if(WorldInfo.NetMode == NM_Client)
					{
						WarnInternal((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ":") @ "CALLED ON CLIENT WITH VALID REMOTE NETCONNECTION!");						
					}
					else
					{
						ChildRemoteConnection = ChildConnection(RemoteConnection);
						// End:0x47F
						if(ChildRemoteConnection != none)
						{
							MasterConnection = ChildRemoteConnection.Parent;
							// End:0x3C4
							if(PlayerIndex == 0)
							{
								Result = MasterConnection.Actor.PlayerReplicationInfo;								
							}
							else
							{
								PlayerIndex--;
								// End:0x47C
								if((PlayerIndex >= 0) && PlayerIndex < MasterConnection.Children.Length)
								{
									ChildRemoteConnection = MasterConnection.Children[PlayerIndex];
									Result = ChildRemoteConnection.Actor.PlayerReplicationInfo;
								}
							}							
						}
						else
						{
							// End:0x584
							if(RemoteConnection.Children.Length > 0)
							{
								// End:0x4C9
								if(PlayerIndex == 0)
								{
									Result = PlayerReplicationInfo;									
								}
								else
								{
									PlayerIndex--;
									// End:0x581
									if((PlayerIndex >= 0) && PlayerIndex < RemoteConnection.Children.Length)
									{
										ChildRemoteConnection = RemoteConnection.Children[PlayerIndex];
										Result = ChildRemoteConnection.Actor.PlayerReplicationInfo;
									}
								}								
							}
							else
							{
								LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ":") @ string(Player)) @ "IS NOT THE PRIMARY CONNECTION AND HAS NO CHILD CONNECTIONS!");
							}
						}
					}					
				}
				else
				{
					LogInternal(((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ":") @ string(Player)) @ "IS NOT A LOCALPLAYER AND NOT A REMOTECONNECTION! (No valid Player reference)");
				}
			}
		}		
	}
	else
	{
		LogInternal((((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ ":") @ "NULL value for Player!");
	}
	return Result;
	//return ReturnValue;	
}

simulated function int GetSplitscreenPlayerCount()
{
	local LocalPlayer LP;
	local NetConnection RemoteConnection;
	local int Result;

	// End:0x227
	if(IsSplitscreenPlayer())
	{
		// End:0x1BA
		if(Player != none)
		{
			LP = LocalPlayer(Player);
			RemoteConnection = NetConnection(Player);
			// End:0xBA
			if(LP != none)
			{
				Result = LP.ViewportClient.Outer.GamePlayers.Length;				
			}
			else
			{
				// End:0x141
				if(RemoteConnection != none)
				{
					// End:0x112
					if(ChildConnection(RemoteConnection) != none)
					{
						RemoteConnection = ChildConnection(RemoteConnection).Parent;
					}
					Result = RemoteConnection.Children.Length + 1;					
				}
				else
				{
					LogInternal(((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "NOT A LOCALPLAYER AND NOT A REMOTECONNECTION!");
				}
			}			
		}
		else
		{
			LogInternal(((((("(" $ string(Name)) $ ") PlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "called without a valid Player value!");
		}
	}
	return Result;
	//return ReturnValue;	
}

reliable client simulated function ClientControlMovieTexture(TextureMovie MovieTexture, SeqAct_ControlMovieTexture.EMovieControlType Mode)
{
	// End:0x9D
	if(MovieTexture != none)
	{
		switch(Mode)
		{
			// End:0x49
			case 0:
				MovieTexture.Play();
				// End:0x9D
				break;
			// End:0x70
			case 1:
				MovieTexture.Stop();
				// End:0x9D
				break;
			// End:0x97
			case 2:
				MovieTexture.Pause();
				// End:0x9D
				break;
			// End:0xFFFF
			default:
				// End:0x9D
				break;
				break;
		}
	}
	//return;	
}

reliable client simulated event ClientSetForceMipLevelsToBeResident(MaterialInterface Material, float ForceDuration, optional int CinematicTextureGroups)
{
	// End:0x52
	if((Material != none) && IsPrimaryPlayer())
	{
		Material.SetForceMipLevelsToBeResident(false, false, ForceDuration, CinematicTextureGroups);
	}
	//return;	
}

reliable client simulated event ClientPrestreamTextures(Actor ForcedActor, float ForceDuration, bool bEnableStreaming, optional int CinematicTextureGroups = 0)
{
	// End:0x5E
	if((ForcedActor != none) && IsPrimaryPlayer())
	{
		ForcedActor.PrestreamTextures(ForceDuration, bEnableStreaming, CinematicTextureGroups);
	}
	//return;	
}

// Export UPlayerController::execClientAddTextureStreamingLoc(FFrame&, void* const)
reliable client native final simulated event ClientAddTextureStreamingLoc(Vector InLoc, float Duration, bool bOverrideLocation);

simulated function bool IsPartyLeader()
{
	local OnlineGameSettings PartySettings;

	// End:0xF2
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
		// End:0xF2
		if(PartySettings != none)
		{
			// End:0xF2
			if(PlayerReplicationInfo != none)
			{
				return PartySettings.OwningPlayerId == PlayerReplicationInfo.UniqueId;
			}
		}
	}
	return (WorldInfo.NetMode != NM_Client) && IsPrimaryPlayer();
	//return ReturnValue;	
}

static function string GetPartyMapName()
{
	//return ReturnValue;	
}

static function string GetPartyGameTypeName()
{
	//return ReturnValue;	
}

event bool GetAchievementProgression(int AchievementId, out float CurrentValue, out float MaxValue)
{
	//return ReturnValue;	
}

simulated function OnFlyThroughHasEnded(SeqAct_FlyThroughHasEnded inAction)
{
	local PlayerController PC;

	// End:0x9C
	if(WorldInfo.Game.IsDoingASentinelRun())
	{
		// End:0x9B
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{			
			PC.ConsoleCommand("quit");			
		}		
	}
	//return;	
}

function Sentinel_SetupForGamebasedTravelTheWorld()
{
	//return;	
}

function Sentinel_PreAcquireTravelTheWorldPoints()
{
	//return;	
}

function Sentinel_PostAcquireTravelTheWorldPoints()
{
	//return;	
}

delegate InputMatchDelegate()
{
	//return;	
}

protected simulated function DoForceFeedbackForScreenShake(CameraShake ShakeData, float ShakeScale)
{
	//return;	
}

unreliable client simulated function ClientPlayCameraShake(CameraShake Shake, optional float Scale = 1.0000000, optional bool bTryForceFeedback, optional Camera.ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
	// End:0x8C
	if(PlayerCamera != none)
	{
		PlayerCamera.PlayCameraShake(Shake, Scale, PlaySpace, UserPlaySpaceRot);
		// End:0x8C
		if(bTryForceFeedback)
		{
			DoForceFeedbackForScreenShake(Shake, Scale);
		}
	}
	//return;	
}

unreliable client simulated function ClientStopCameraShake(CameraShake Shake)
{
	// End:0x37
	if(PlayerCamera != none)
	{
		PlayerCamera.StopCameraShake(Shake);
	}
	//return;	
}

function OnCameraShake(SeqAct_CameraShake inAction)
{
	// End:0x2D6
	if(inAction.InputLinks[0].bHasImpulse)
	{
		// End:0x1EA
		if(inAction.bRadialShake)
		{
			// End:0x1A6
			if(inAction.LocationActor != none)
			{
				Class'Engine.Camera'.static.PlayWorldCameraShake(inAction.Shake, inAction.LocationActor, inAction.LocationActor.Location, inAction.RadialShake_InnerRadius, inAction.RadialShake_OuterRadius, inAction.RadialShake_Falloff, inAction.bDoControllerVibration, inAction.bOrientTowardRadialEpicenter);				
			}
			else
			{
				WarnInternal(string(self) @ "Location actor needed for bRadialFalloff camera shake.");
				return;
			}			
		}
		else
		{
			ClientPlayCameraShake(inAction.Shake, inAction.ShakeScale, inAction.bDoControllerVibration, inAction.PlaySpace, ((inAction.LocationActor == none) ? rot(0, 0, 0) : inAction.LocationActor.Rotation));
		}		
	}
	else
	{
		ClientStopCameraShake(inAction.Shake);
	}
	//return;	
}

unreliable client simulated event ClientPlayCameraAnim(CameraAnim AnimToPlay, optional float Scale = 1.0000000, optional float Rate = 1.0000000, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional Camera.ECameraAnimPlaySpace Space = 0, optional Rotator CustomPlaySpace)
{
	local CameraAnimInst AnimInst;

	// End:0xEE
	if(PlayerCamera != none)
	{
		AnimInst = PlayerCamera.PlayCameraAnim(AnimToPlay, Rate, Scale, BlendInTime, BlendOutTime, bLoop, bRandomStartTime);
		// End:0xEE
		if((AnimInst != none) && int(Space) != 0)
		{
			AnimInst.SetPlaySpace(Space, CustomPlaySpace);
		}
	}
	//return;	
}

reliable client simulated event ClientStopCameraAnim(CameraAnim AnimToStop, optional bool bImmediate)
{
	// End:0x42
	if(PlayerCamera != none)
	{
		PlayerCamera.StopAllCameraAnimsByType(AnimToStop, bImmediate);
	}
	//return;	
}

exec function DebugCameraAnims()
{
	bDebugCameraAnims = !bDebugCameraAnims;
	// End:0x46
	if(bDebugCameraAnims == false)
	{
		WorldInfo.FlushPersistentDebugLines();
	}
	//return;	
}

unreliable client simulated event ClientSpawnCameraLensEffect(Class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
	// End:0x37
	if(PlayerCamera != none)
	{
		PlayerCamera.AddCameraLensEffect(LensEffectEmitterClass);
	}
	//return;	
}

function OnSetSoundMode(SeqAct_SetSoundMode Action)
{
	local AudioDevice Audio;

	Audio = Class'Engine.Engine'.static.GetAudioDevice();
	// End:0x112
	if(Audio != none)
	{
		// End:0xEA
		if(Action.InputLinks[0].bHasImpulse && Action.SoundMode != none)
		{
			Audio.SetSoundMode(Action.SoundMode.Name);			
		}
		else
		{
			Audio.SetSoundMode('Default');
		}
	}
	//return;	
}

// Export UPlayerController::execHasPeerConnection(FFrame&, void* const)
native function bool HasPeerConnection(const out UniqueNetId PeerNetId);

exec function BugItGo(coerce float X, coerce float Y, coerce float Z, coerce int Pitch, coerce int Yaw, coerce int Roll)
{
	local Vector TheLocation;
	local Rotator TheRotation;

	TheLocation.X = X;
	TheLocation.Y = Y;
	TheLocation.Z = Z;
	TheRotation.Pitch = Pitch;
	TheRotation.Yaw = Yaw;
	TheRotation.Roll = Roll;
	BugItWorker(TheLocation, TheRotation);
	//return;	
}

function BugItGoString(string TheLocation, string TheRotation)
{
	BugItWorker(Vector(TheLocation), Rotator(TheRotation));
	//return;	
}

function BugItWorker(Vector TheLocation, Rotator TheRotation)
{
	LogInternal(("BugItGo to:" @ string(TheLocation)) @ string(TheRotation));
	// End:0x58
	if(CheatManager != none)
	{
		CheatManager.Ghost();
	}
	ViewTarget.SetLocation(TheLocation);
	Pawn.FaceRotation(TheRotation, 0.0000000);
	SetRotation(TheRotation);
	//return;	
}

exec event BugIt(optional string ScreenShotDescription)
{
	local Vector ViewLocation;
	local Rotator ViewRotation;
	local string GoString, LocString;

	ConsoleCommand("bugscreenshot " $ ScreenShotDescription);
	GetPlayerViewPoint(ViewLocation, ViewRotation);
	// End:0x83
	if(Pawn != none)
	{
		ViewLocation = Pawn.Location;
	}
	BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
	LogOutBugItGoToLogFile(ScreenShotDescription, GoString, LocString);
	//return;	
}

exec function LogLoc()
{
	local Vector ViewLocation;
	local Rotator ViewRotation;
	local string GoString, LocString;

	GetPlayerViewPoint(ViewLocation, ViewRotation);
	// End:0x53
	if(Pawn != none)
	{
		ViewLocation = Pawn.Location;
	}
	BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
	//return;	
}

exec event BugItAI(optional string ScreenShotDescription)
{
	local Vector ViewLocation;
	local Rotator ViewRotation;
	local string GoString, LocString;

	GetPlayerViewPoint(ViewLocation, ViewRotation);
	// End:0x54
	if(Pawn != none)
	{
		ViewLocation = Pawn.Location;
	}
	BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);	
	ConsoleCommand("debugai");
	SetTimer(0.1000000, false, 'DisableDebugAI');
	LogOutBugItAIGoToLogFile(ScreenShotDescription, GoString, LocString);
	//return;	
}

exec event BugItStringCreator(const out Vector ViewLocation, const out Rotator ViewRotation, out string GoString, out string LocString)
{
	GoString = (((((((((("BugItGo " $ string(ViewLocation.X)) $ " ") $ string(ViewLocation.Y)) $ " ") $ string(ViewLocation.Z)) $ " ") $ string(ViewRotation.Pitch)) $ " ") $ string(ViewRotation.Yaw)) $ " ") $ string(ViewRotation.Roll);
	LogInternal(GoString);
	LocString = (("?BugLoc=" $ string(ViewLocation)) $ "?BugRot=") $ string(ViewRotation);
	LogInternal(LocString);
	//return;	
}

event OnEngineInitialTick()
{
	// End:0x4C
	if(WorldInfo.IsConsoleBuild(3))
	{		
		ConsoleCommand("mobile stoploading");
	}
	//return;	
}

function DebugLogPRIs()
{
	local int PlayerIndex;
	local UniqueNetId NetId;

	// End:0x245
	if((WorldInfo != none) && WorldInfo.GRI != none)
	{
		LogInternal("  Number of PRI players: " $ string(WorldInfo.GRI.PRIArray.Length));
		PlayerIndex = 0;
		J0x96:

		// End:0x240 [Loop If]
		if(PlayerIndex < WorldInfo.GRI.PRIArray.Length)
		{
			NetId = WorldInfo.GRI.PRIArray[PlayerIndex].UniqueId;
			LogInternal(((((("    Player: " $ WorldInfo.GRI.PRIArray[PlayerIndex].PlayerName) $ " UID (") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId)) $ ") PC (") $ string(WorldInfo.GRI.PRIArray[PlayerIndex].Owner)) $ ")");
			PlayerIndex++;
			// [Loop Continue]
			goto J0x96;
		}
		LogInternal("");
	}
	//return;	
}

exec function DumpOnlineSessionState()
{
	// End:0x31
	if(CheatManager != none)
	{
		CheatManager.DumpOnlineSessionState();		
	}
	else
	{
		DebugLogPRIs();
		// End:0x69
		if(OnlineSub != none)
		{
			OnlineSub.DumpSessionState();
		}
	}
	//return;	
}

exec function DumpVoiceMutingState()
{
	local UniqueNetId NetId;
	local PlayerController PC;
	local int MuteIndex;

	LogInternal("");
	LogInternal("Voice state");
	LogInternal("-------------------------------------------------------------");
	LogInternal("");
	// End:0x8A
	if(OnlineSub != none)
	{
		OnlineSub.DumpVoiceRegistration();
	}
	LogInternal("Muting state");
	// End:0x36E
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		LogInternal("  Player: " $ PC.PlayerReplicationInfo.PlayerName);
		LogInternal("    Gameplay mutes: ");
		MuteIndex = 0;
		J0x137:

		// End:0x1D9 [Loop If]
		if(MuteIndex < PC.GameplayVoiceMuteList.Length)
		{
			NetId = PC.GameplayVoiceMuteList[MuteIndex];
			LogInternal("      " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
			MuteIndex++;
			// [Loop Continue]
			goto J0x137;
		}
		LogInternal("    System mutes: ");
		MuteIndex = 0;
		J0x1FB:

		// End:0x29D [Loop If]
		if(MuteIndex < PC.VoiceMuteList.Length)
		{
			NetId = PC.VoiceMuteList[MuteIndex];
			LogInternal("      " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
			MuteIndex++;
			// [Loop Continue]
			goto J0x1FB;
		}
		LogInternal("    Voice packet filter: ");
		MuteIndex = 0;
		J0x2C6:

		// End:0x368 [Loop If]
		if(MuteIndex < PC.VoicePacketFilter.Length)
		{
			NetId = PC.VoicePacketFilter[MuteIndex];
			LogInternal("      " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
			MuteIndex++;
			// [Loop Continue]
			goto J0x2C6;
		}
		LogInternal("");		
	}	
	//return;	
}

exec function DumpPeers()
{
	local UniqueNetId NetId;
	local PlayerController PC;
	local int PeerIdx;
	local ConnectedPeerInfo PeerInfo;

	LogInternal("");
	LogInternal("Peer List");
	// End:0x309
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x308
		if((WorldInfo.NetMode == NM_Client) || !PC.IsLocalPlayerController())
		{
			LogInternal(((("  Player: " $ PC.PlayerReplicationInfo.PlayerName) $ "(") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PC.PlayerReplicationInfo.UniqueId)) $ ")");
			LogInternal("    Peer connections: ");
			PeerIdx = 0;
			J0x15E:

			// End:0x242 [Loop If]
			if(PeerIdx < PC.ConnectedPeers.Length)
			{
				PeerInfo = PC.ConnectedPeers[PeerIdx];
				LogInternal((("      " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PeerInfo.PlayerID)) $ " HostLost=") $ string(PeerInfo.bLostConnectionToHost));
				PeerIdx++;
				// [Loop Continue]
				goto J0x15E;
			}
			LogInternal("    Best Hosts:");
			PeerIdx = 0;
			J0x261:

			// End:0x303 [Loop If]
			if(PeerIdx < PC.BestNextHostPeers.Length)
			{
				NetId = PC.BestNextHostPeers[PeerIdx];
				LogInternal("      " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
				PeerIdx++;
				// [Loop Continue]
				goto J0x261;
			}
			LogInternal("");
		}		
	}	
	//return;	
}

function DisableDebugAI()
{
	ConsoleCommand("debugai");
	//return;	
}

// Export UPlayerController::execLogOutBugItGoToLogFile(FFrame&, void* const)
private native final function LogOutBugItGoToLogFile(const string InScreenShotDesc, const string InGoString, const string InLocString);

// Export UPlayerController::execLogOutBugItAIGoToLogFile(FFrame&, void* const)
private native final function LogOutBugItAIGoToLogFile(const string InScreenShotDesc, const string InGoString, const string InLocString);

simulated function ReceivedGameClass(Class<GameInfo> GameClass)
{
	// End:0x2E
	if(PlayerInput != none)
	{
		PlayerInput.ClientInitInputSystem();
	}
	//return;	
}

event bool NotifyDisconnect(string Command)
{
	return false;
	//return ReturnValue;	
}

event SetMatineeConstantCameraAnim(bool bOn, byte Type, float Rate)
{
	//return;	
}

state PlayerWalking
{
	ignores Bump, HearNoise, SeePlayer;

	event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		// End:0x69
		if(NewVolume.bWaterVolume && Pawn.bCollideWorld)
		{
			GotoState(Pawn.WaterMovementState);
		}
		//return;		
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		// End:0x11
		if(Pawn == none)
		{
			return;
		}
		// End:0x60
		if(Role == ROLE_Authority)
		{
			Pawn.SetRemoteViewPitch(Rotation.Pitch);
		}
		Pawn.Acceleration = newAccel;
		CheckJumpOrDuck();
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z, newAccel;
		local Actor.EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation;
		local bool bSaveJump;

		// End:0x20
		if(Pawn == none)
		{
			GotoState('Dead');			
		}
		else
		{
			GetAxes(Pawn.Rotation, X, Y, Z);
			newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
			newAccel.Z = 0.0000000;
			newAccel = Pawn.AccelRate * Normal(newAccel);
			// End:0x130
			if(IsLocalPlayerController())
			{
				AdjustPlayerWalkingMoveAccel(newAccel);
			}
			DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
			OldRotation = Rotation;
			UpdateRotation(DeltaTime);
			bDoubleJump = false;
			// End:0x200
			if(bPressedJump && Pawn.CannotJumpNow())
			{
				bSaveJump = true;
				bPressedJump = false;				
			}
			else
			{
				bSaveJump = false;
			}
			// End:0x25D
			if(Role < ROLE_Authority)
			{
				ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);				
			}
			else
			{
				ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
			}
			bPressedJump = bSaveJump;
		}
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		DoubleClickDir = 0;
		bPressedJump = false;
		GroundPitch = 0;
		// End:0xDC
		if(Pawn != none)
		{
			Pawn.ShouldCrouch(false);
			// End:0xDC
			if((int(Pawn.Physics) != 2) && int(Pawn.Physics) != 10)
			{
				Pawn.SetPhysics(Pawn.WalkingPhysics);
			}
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		GroundPitch = 0;
		// End:0x6E
		if(Pawn != none)
		{
			Pawn.SetRemoteViewPitch(0);
			// End:0x6E
			if(int(bDuck) == 0)
			{
				Pawn.ShouldCrouch(false);
			}
		}
		//return;		
	}
Begin:

	stop;				
}

state PlayerClimbing
{
	ignores Bump, HearNoise, SeePlayer;

	event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		// End:0x48
		if(NewVolume.bWaterVolume)
		{
			GotoState(Pawn.WaterMovementState);			
		}
		else
		{
			GotoState(Pawn.LandMovementState);
		}
		//return;		
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		// End:0x11
		if(Pawn == none)
		{
			return;
		}
		// End:0x60
		if(Role == ROLE_Authority)
		{
			Pawn.SetRemoteViewPitch(Rotation.Pitch);
		}
		Pawn.Acceleration = newAccel;
		// End:0x10A
		if(bPressedJump)
		{
			Pawn.DoJump(bUpdating);
			// End:0x10A
			if(int(Pawn.Physics) == 2)
			{
				GotoState(Pawn.LandMovementState);
			}
		}
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z, newAccel;
		local Rotator OldRotation, ViewRotation;

		GetAxes(Rotation, X, Y, Z);
		// End:0x115
		if(Pawn.OnLadder != none)
		{
			newAccel = PlayerInput.aForward * Pawn.OnLadder.ClimbDir;
			// End:0x112
			if(Pawn.OnLadder.bAllowLadderStrafing)
			{
				newAccel += (PlayerInput.aStrafe * Y);
			}			
		}
		else
		{
			newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
		}
		newAccel = Pawn.AccelRate * Normal(newAccel);
		ViewRotation = Rotation;
		SetRotation(ViewRotation);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime);
		// End:0x237
		if(Role < ROLE_Authority)
		{
			ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);			
		}
		else
		{
			ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
		}
		bPressedJump = false;
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		Pawn.ShouldCrouch(false);
		bPressedJump = false;
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x4F
		if(Pawn != none)
		{
			Pawn.SetRemoteViewPitch(0);
			Pawn.ShouldCrouch(false);
		}
		//return;		
	}
	stop;	
}

state PlayerDriving
{
	ignores ProcessMove, Bump, HearNoise, SeePlayer;

	function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
	{
		local Vehicle CurrentVehicle;

		CurrentVehicle = Vehicle(Pawn);
		// End:0x86
		if(CurrentVehicle != none)
		{
			bPressedJump = InJump;
			CurrentVehicle.SetInputs(InForward, -InStrafe, InUp);
			CheckJumpOrDuck();
		}
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		UpdateRotation(DeltaTime);
		ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
		// End:0x14F
		if(Role < ROLE_Authority)
		{
			ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
		}
		bPressedJump = false;
		//return;		
	}

	unreliable server function ServerUse()
	{
		local Vehicle CurrentVehicle;

		CurrentVehicle = Vehicle(Pawn);
		CurrentVehicle.DriverLeave(false);
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		CleanOutSavedMoves();
		//return;		
	}

	event EndState(name NextStateName)
	{
		CleanOutSavedMoves();
		//return;		
	}
	stop;	
}

state PlayerSwimming
{
	ignores Bump, HearNoise, SeePlayer;

	event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
	{
		// End:0x54
		if(Pawn.PhysicsVolume.bWaterVolume)
		{
			Pawn.SetPhysics(3);			
		}
		else
		{
			GotoState(Pawn.LandMovementState);
		}
		return bUpdating;
		//return ReturnValue;		
	}

	event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		local Actor HitActor;
		local Vector HitLocation, HitNormal, Checkpoint, X, Y, Z;

		// End:0x47
		if(!Pawn.bCollideActors)
		{
			GotoState(Pawn.LandMovementState);
		}
		// End:0x43F
		if(int(Pawn.Physics) != 10)
		{
			// End:0x416
			if(!NewVolume.bWaterVolume)
			{
				Pawn.SetPhysics(2);
				// End:0x413
				if(Pawn.Velocity.Z > float(0))
				{
					GetAxes(Rotation, X, Y, Z);
					Pawn.bUpAndOut = ((X Dot Pawn.Acceleration) > float(0)) && (Pawn.Acceleration.Z > float(0)) || Rotation.Pitch > 2048;
					// End:0x283
					if(Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal))
					{
						Pawn.Velocity.Z = Pawn.OutofWaterZ;
						GotoState(Pawn.LandMovementState);						
					}
					else
					{
						// End:0x309
						if((Pawn.Velocity.Z > float(160)) || !Pawn.TouchingWaterVolume())
						{
							GotoState(Pawn.LandMovementState);							
						}
						else
						{
							Checkpoint = Pawn.Location;
							Checkpoint.Z -= (Pawn.CylinderComponent.CollisionHeight + 6.0000000);
							HitActor = Trace(HitLocation, HitNormal, Checkpoint, Pawn.Location, false);
							// End:0x408
							if(HitActor != none)
							{
								GotoState(Pawn.LandMovementState);								
							}
							else
							{
								SetTimer(0.7000000, false);
							}
						}
					}
				}				
			}
			else
			{
				ClearTimer();
				Pawn.SetPhysics(3);
			}			
		}
		else
		{
			// End:0x486
			if(!NewVolume.bWaterVolume)
			{
				GotoState(Pawn.LandMovementState);
			}
		}
		//return;		
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		Pawn.Acceleration = newAccel;
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Rotator OldRotation;
		local Vector X, Y, Z, newAccel;

		// End:0x20
		if(Pawn == none)
		{
			GotoState('Dead');			
		}
		else
		{
			GetAxes(Rotation, X, Y, Z);
			newAccel = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
			newAccel = Pawn.AccelRate * Normal(newAccel);
			OldRotation = Rotation;
			UpdateRotation(DeltaTime);
			// End:0x178
			if(Role < ROLE_Authority)
			{
				ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);				
			}
			else
			{
				ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
			}
			bPressedJump = false;
		}
		//return;		
	}

	event Timer()
	{
		// End:0x72
		if(!Pawn.PhysicsVolume.bWaterVolume && Role == ROLE_Authority)
		{
			GotoState(Pawn.LandMovementState);
		}
		ClearTimer();
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		ClearTimer();
		// End:0x4F
		if(int(Pawn.Physics) != 10)
		{
			Pawn.SetPhysics(3);
		}
		//return;		
	}
Begin:

	stop;				
}

state PlayerFlying
{
	ignores Bump, HearNoise, SeePlayer;

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;

		GetAxes(Rotation, X, Y, Z);
		Pawn.Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
		Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
		// End:0x192
		if(bCheatFlying && Pawn.Acceleration == vect(0.0000000, 0.0000000, 0.0000000))
		{
			Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		}
		UpdateRotation(DeltaTime);
		// End:0x1FC
		if(Role < ROLE_Authority)
		{
			ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));			
		}
		else
		{
			ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
		}
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		Pawn.SetPhysics(4);
		//return;		
	}
	stop;	
}

state BaseSpectating
{
	function bool IsSpectating()
	{
		return true;
		//return ReturnValue;		
	}

	function bool LimitSpectatorVelocity()
	{
		// End:0xAF
		if(Location.Z > WorldInfo.StallZ)
		{
			Velocity.Z = FMin(SpectatorCameraSpeed, (WorldInfo.StallZ - Location.Z) - 2.0000000);
			return true;			
		}
		else
		{
			// End:0x15B
			if(Location.Z < WorldInfo.KillZ)
			{
				Velocity.Z = FMin(SpectatorCameraSpeed, (WorldInfo.KillZ - Location.Z) + 2.0000000);
				return true;
			}
		}
		return false;
		//return ReturnValue;		
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local float VelSize;

		Acceleration = Normal(newAccel) * SpectatorCameraSpeed;
		VelSize = VSize(Velocity);
		// End:0x94
		if(VelSize > float(0))
		{
			Velocity = Velocity - ((Velocity - (Normal(Acceleration) * VelSize)) * FMin(DeltaTime * float(8), 1.0000000));
		}
		Velocity = Velocity + (Acceleration * DeltaTime);
		// End:0xF6
		if(VSize(Velocity) > SpectatorCameraSpeed)
		{
			Velocity = Normal(Velocity) * SpectatorCameraSpeed;
		}
		LimitSpectatorVelocity();
		// End:0x182
		if(VSize(Velocity) > float(0))
		{
			MoveSmooth((float(1 + int(bRun)) * Velocity) * DeltaTime);
			// End:0x182
			if(LimitSpectatorVelocity())
			{
				MoveSmooth((Velocity.Z * vect(0.0000000, 0.0000000, 1.0000000)) * DeltaTime);
			}
		}
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;

		GetAxes(Rotation, X, Y, Z);
		Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
		UpdateRotation(DeltaTime);
		// End:0x108
		if(Role < ROLE_Authority)
		{
			ReplicateMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));			
		}
		else
		{
			ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
		}
		//return;		
	}

	unreliable server function ServerSetSpectatorLocation(Vector NewLoc)
	{
		SetLocation(NewLoc);
		// End:0x75
		if((WorldInfo.TimeSeconds - LastSpectatorStateSynchTime) > 2.0000000)
		{
			ClientGotoState(GetStateName());
			LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
		}
		//return;		
	}

	function ReplicateMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
		ServerSetSpectatorLocation(Location);
		// End:0x95
		if((PlayerCamera != none) && PlayerCamera.bUseClientSideCameraUpdates)
		{
			PlayerCamera.bShouldSendClientSideCameraUpdate = true;
		}
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		bCollideWorld = true;
		//return;		
	}

	event EndState(name NextStateName)
	{
		bCollideWorld = false;
		//return;		
	}
	stop;	
}

state Spectating extends BaseSpectating
{
	ignores NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, ThrowWeapon, Suicide, RestartLevel;

	exec function StartFire(optional byte FireModeNum)
	{
		ServerViewNextPlayer();
		//return;		
	}

	exec function StartAltFire(optional byte FireModeNum)
	{
		ResetCameraMode();
		ServerViewSelf();
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		// End:0x3A
		if(Pawn != none)
		{
			SetLocation(Pawn.Location);
			UnPossess();
		}
		bCollideWorld = true;
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0xA6
		if(PlayerReplicationInfo != none)
		{
			// End:0x85
			if(PlayerReplicationInfo.bOnlySpectator)
			{
				LogInternal("WARNING - Spectator only player leaving spectating state to go to " $ string(NextStateName));
			}
			PlayerReplicationInfo.bIsSpectator = false;
		}
		bCollideWorld = false;
		//return;		
	}
	stop;	
}

auto state PlayerWaiting extends BaseSpectating
{
	ignores ServerSuicide, Suicide, SwitchToBestWeapon, PrevWeapon, NextWeapon, 
		PhysicsVolumeChange, TakeDamage, NotifyBump, HearNoise, SeePlayer;

	function Jump() {}

	reliable server function ServerChangeTeam(int N)
	{
		WorldInfo.Game.ChangeTeam(self, N, true);
		//return;		
	}

	reliable server function ServerRestartPlayer()
	{
		// End:0x2E
		if(WorldInfo.TimeSeconds < WaitDelay)
		{
			return;
		}
		// End:0x59
		if(WorldInfo.NetMode == NM_Client)
		{
			return;
		}
		// End:0xB4
		if(WorldInfo.Game.bWaitingToStartMatch)
		{
			PlayerReplicationInfo.bReadyToPlay = true;			
		}
		else
		{
			WorldInfo.Game.RestartPlayer(self);
		}
		//return;		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		ServerRestartPlayer();
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x2F
		if(PlayerReplicationInfo != none)
		{
			PlayerReplicationInfo.SetWaitingPlayer(false);
		}
		bCollideWorld = false;
		//return;		
	}

	simulated event BeginState(name PreviousStateName)
	{
		// End:0x2F
		if(PlayerReplicationInfo != none)
		{
			PlayerReplicationInfo.SetWaitingPlayer(true);
		}
		bCollideWorld = true;
		//return;		
	}
	stop;	
}

state WaitingForPawn extends BaseSpectating
{
	ignores KilledBy, HearNoise, SeePlayer;

	exec function StartFire(optional byte FireModeNum)
	{
		AskForPawn();
		//return;		
	}

	reliable client simulated function ClientGotoState(name NewState, optional name NewLabel)
	{
		// End:0x34
		if(NewState == 'RoundEnded')
		{
			global.ClientGotoState(NewState, NewLabel);
		}
		//return;		
	}

	unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
	{
		// End:0x25
		if(NewState == 'RoundEnded')
		{
			GotoState(NewState);
		}
		//return;		
	}

	event PlayerTick(float DeltaTime)
	{
		global.PlayerTick(DeltaTime);
		// End:0x78
		if(Pawn != none)
		{
			Pawn.Controller = self;
			Pawn.BecomeViewTarget(self);
			ClientRestart(Pawn);			
		}
		else
		{
			// End:0xB6
			if(!IsTimerActive() || GetTimerCount() > 1.0000000)
			{
				SetTimer(0.2000000, true);
				AskForPawn();
			}
		}
		//return;		
	}

	function ReplicateMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
		//return;		
	}

	event Timer()
	{
		AskForPawn();
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		SetTimer(0.2000000, true);
		AskForPawn();
		//return;		
	}

	event EndState(name NextStateName)
	{
		ResetCameraMode();
		SetTimer(0.0000000, false);
		//return;		
	}
	stop;	
}

state RoundEnded
{
	ignores LongClientAdjustPosition, Use, ThrowWeapon, ServerRestartPlayer, Suicide, TakeDamage, 
		Falling, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, HitWall, NotifyBump, 
		KilledBy, HearNoise, SeePlayer;

	function bool IsSpectating()
	{
		return true;
		//return ReturnValue;		
	}

	event Possess(Pawn aPawn, bool bVehicleTransition)
	{
		global.Possess(aPawn, bVehicleTransition);
		// End:0x4B
		if(Pawn != none)
		{
			Pawn.TurnOff();
		}
		//return;		
	}

	reliable server function ServerRestartGame()
	{
		// End:0x6C
		if(WorldInfo.Game.PlayerCanRestartGame(self))
		{
			WorldInfo.Game.ResetLevel();
		}
		//return;		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		// End:0x17
		if(Role < ROLE_Authority)
		{
			return;
		}
		// End:0x33
		if(!bFrozen)
		{
			ServerRestartGame();			
		}
		else
		{
			// End:0x4F
			if(!IsTimerActive())
			{
				SetTimer(1.5000000, false);
			}
		}
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;
		local Rotator DeltaRot, ViewRotation;

		GetAxes(Rotation, X, Y, Z);
		ViewRotation = Rotation;
		DeltaRot.Yaw = int(PlayerInput.aTurn);
		DeltaRot.Pitch = int(PlayerInput.aLookUp);
		ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
		SetRotation(ViewRotation);
		ViewShake(DeltaTime);
		// End:0x13D
		if(Role < ROLE_Authority)
		{
			ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));			
		}
		else
		{
			ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
		}
		bPressedJump = false;
		//return;		
	}

	unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
	{
		global.ServerMove(TimeStamp, InAccel, ClientLoc, NewFlags, ClientRoll, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
		//return;		
	}

	function FindGoodView()
	{
		local Rotator GoodRotation;

		GoodRotation = Rotation;
		GetViewTarget().FindGoodEndView(self, GoodRotation);
		SetRotation(GoodRotation);
		//return;		
	}

	event Timer()
	{
		bFrozen = false;
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		local Pawn P;

		FOVAngle = DesiredFOV;
		bFire = 0;
		// End:0x57
		if(Pawn != none)
		{
			Pawn.TurnOff();
			StopFiring();
		}
		// End:0x86
		if(myHUD != none)
		{
			myHUD.SetShowScores(true);
		}
		bFrozen = true;
		FindGoodView();
		SetTimer(5.0000000, false);
		// End:0xE0
		foreach DynamicActors(Class'Engine.Pawn', P)
		{
			P.TurnOff();			
		}		
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x2F
		if(myHUD != none)
		{
			myHUD.SetShowScores(false);
		}
		//return;		
	}
Begin:

	stop;				
}

state Dead
{
	ignores ThrowWeapon, PrevWeapon, NextWeapon, KilledBy, HearNoise, SeePlayer;

	simulated event ReplicatedEvent(name VarName)
	{
		// End:0x54
		if(((VarName == 'Pawn') && Pawn != none) && Pawn != AcknowledgedPawn)
		{
			ClientRestart(Pawn);
		}
		global.ReplicatedEvent(VarName);
		//return;		
	}

	function bool IsDead()
	{
		return true;
		//return ReturnValue;		
	}

	reliable server function ServerRestartPlayer()
	{
		// End:0x3C
		if(!WorldInfo.Game.PlayerCanRestart(self))
		{
			return;
		}
		super.ServerRestartPlayer();
		//return;		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		// End:0x49
		if(bFrozen)
		{
			// End:0x47
			if(!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
			{
				bFrozen = false;
			}
			return;
		}
		ServerRestartPlayer();
		//return;		
	}

	exec function Use()
	{
		StartFire(0);
		//return;		
	}

	exec function Jump()
	{
		StartFire(0);
		//return;		
	}

	unreliable server function ServerMove(float TimeStamp, Vector Accel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
	{
		global.ServerMove(TimeStamp, Accel, ClientLoc, 0, ClientRoll, View);
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;
		local Rotator DeltaRot, ViewRotation;

		// End:0x15E
		if(!bFrozen)
		{
			// End:0x34
			if(bPressedJump)
			{
				StartFire(0);
				bPressedJump = false;
			}
			GetAxes(Rotation, X, Y, Z);
			ViewRotation = Rotation;
			DeltaRot.Yaw = int(PlayerInput.aTurn);
			DeltaRot.Pitch = int(PlayerInput.aLookUp);
			ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
			SetRotation(ViewRotation);
			// End:0x15B
			if(Role < ROLE_Authority)
			{
				ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
			}			
		}
		else
		{
			// End:0x197
			if(!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
			{
				bFrozen = false;
			}
		}
		ViewShake(DeltaTime);
		//return;		
	}

	function FindGoodView()
	{
		local Vector CameraLoc;
		local Rotator CameraRot, ViewRotation;
		local int tries, besttry;
		local float bestDist, newdist;
		local int startYaw;
		local Actor TheViewTarget;

		ViewRotation = Rotation;
		ViewRotation.Pitch = 56000;
		tries = 0;
		besttry = 0;
		bestDist = 0.0000000;
		startYaw = ViewRotation.Yaw;
		TheViewTarget = GetViewTarget();
		tries = 0;
		J0x9F:

		// End:0x1A2 [Loop If]
		if(tries < 16)
		{
			CameraLoc = TheViewTarget.Location;
			SetRotation(ViewRotation);
			GetPlayerViewPoint(CameraLoc, CameraRot);
			newdist = VSize(CameraLoc - TheViewTarget.Location);
			// End:0x171
			if(newdist > bestDist)
			{
				bestDist = newdist;
				besttry = tries;
			}
			ViewRotation.Yaw += 4096;
			tries++;
			// [Loop Continue]
			goto J0x9F;
		}
		ViewRotation.Yaw = startYaw + (besttry * 4096);
		SetRotation(ViewRotation);
		//return;		
	}

	event Timer()
	{
		// End:0x11
		if(!bFrozen)
		{
			return;
		}
		bFrozen = false;
		bPressedJump = false;
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		// End:0x55
		if((Pawn != none) && Pawn.Controller == self)
		{
			Pawn.Controller = none;
		}
		Pawn = none;
		FOVAngle = DesiredFOV;
		Enemy = none;
		bFrozen = true;
		bPressedJump = false;
		FindGoodView();
		SetTimer(MinRespawnDelay, false);
		CleanOutSavedMoves();
		//return;		
	}

	event EndState(name NextStateName)
	{
		CleanOutSavedMoves();
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		// End:0x66
		if(!PlayerReplicationInfo.bOutOfLives)
		{
			ResetCameraMode();
		}
		bPressedJump = false;
		// End:0xA1
		if(myHUD != none)
		{
			myHUD.SetShowScores(false);
		}
		//return;		
	}
Begin:

	// End:0x46
	if(LocalPlayer(Player) != none)
	{
		// End:0x46
		if(myHUD != none)
		{
			myHUD.PlayerOwnerDied();
		}
	}
	stop;		
}

defaultproperties
{
	CameraClass=Class'Engine.Camera'
	bInteractiveMode=true
	bRenderHUDFullScreen=true
	bShowKismetDrawText=true
	bIsUsingStreamingVolumes=true
	bCheckRelevancyThroughPortals=true
	MaxResponseTime=0.1250000
	FOVAngle=85.0000000
	DesiredFOV=85.0000000
	DefaultFOV=85.0000000
	LODDistanceFactor=1.0000000
	SavedMoveClass=Class'Engine.SavedMove'
	LastSpeedHackLog=-100.0000000
	CheatClass=Class'Engine.CheatManager'
	InputClass=Class'Engine.PlayerInput'
	// Reference: CylinderComponent'Engine.Default__PlayerController.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	InteractDistance=512.0000000
	SpectatorCameraSpeed=600.0000000
	MinRespawnDelay=1.0000000
	MaxConcurrentHearSounds=32
	bIsPlayer=true
	bCanDoSpecial=true
	Components[0]=CollisionCylinder
	NetPriority=3.0000000
	CollisionComponent=CollisionCylinder
}