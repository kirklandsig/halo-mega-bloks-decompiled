class PartyBeaconHost extends PartyBeacon
	native
	config(Engine);

enum EPartyBeaconHostState
{
	PBHS_AllowReservations,         // 0
	PBHS_DenyReservations,          // 1
	PBHS_MAX                        // 2
};

struct native ClientBeaconConnection
{
	var UniqueNetId PartyLeader;
	var float ElapsedHeartbeatTime;
	var native transient Pointer Socket;

	structdefaultproperties
	{
		PartyLeader=(Uid=())
		ElapsedHeartbeatTime=0.0000000
	}
};

var const array<ClientBeaconConnection> Clients;
var const int NumTeams;
var const int NumPlayersPerTeam;
var const int NumReservations;
var const int NumConsumedReservations;
var const array<PartyReservation> Reservations;
var name OnlineSessionName;
var config int ConnectionBacklog;
var const int ForceTeamNum;
var const int ReservedHostTeamNum;
var bool bBestFitTeamAssignment;
var const PartyBeaconHost.EPartyBeaconHostState BeaconState;
//var delegate<OnReservationChange> __OnReservationChange__Delegate;
//var delegate<OnReservationsFull> __OnReservationsFull__Delegate;
//var delegate<OnClientCancellationReceived> __OnClientCancellationReceived__Delegate;

// Export UPartyBeaconHost::execPauseReservationRequests(FFrame&, void* const)
native function PauseReservationRequests(bool bPause);

// Export UPartyBeaconHost::execInitHostBeacon(FFrame&, void* const)
native function bool InitHostBeacon(int InNumTeams, int InNumPlayersPerTeam, int InNumReservations, name InSessionName, optional int InForceTeamNum = 0);

// Export UPartyBeaconHost::execAddPartyReservationEntry(FFrame&, void* const)
native function PartyBeacon.EPartyReservationResult AddPartyReservationEntry(UniqueNetId PartyLeader, const out array<PlayerReservation> PlayerMembers, int TeamNum, bool bIsHost);

// Export UPartyBeaconHost::execUpdatePartyReservationEntry(FFrame&, void* const)
native function PartyBeacon.EPartyReservationResult UpdatePartyReservationEntry(UniqueNetId PartyLeader, const out array<PlayerReservation> PlayerMembers);

// Export UPartyBeaconHost::execGetExistingReservation(FFrame&, void* const)
native function int GetExistingReservation(const out UniqueNetId PartyLeader);

// Export UPartyBeaconHost::execHandlePlayerLogout(FFrame&, void* const)
native function HandlePlayerLogout(UniqueNetId PlayerID, bool bMaintainParty);

delegate OnReservationChange()
{
	//return;	
}

delegate OnReservationsFull()
{
	//return;	
}

delegate OnClientCancellationReceived(UniqueNetId PartyLeader)
{
	//return;	
}

// Export UPartyBeaconHost::execDestroyBeacon(FFrame&, void* const)
native event DestroyBeacon();

// Export UPartyBeaconHost::execTellClientsToTravel(FFrame&, void* const)
native function TellClientsToTravel(name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80]);

// Export UPartyBeaconHost::execTellClientsHostIsReady(FFrame&, void* const)
native function TellClientsHostIsReady();

// Export UPartyBeaconHost::execTellClientsHostHasCancelled(FFrame&, void* const)
native function TellClientsHostHasCancelled();

function bool AreReservationsFull()
{
	return NumConsumedReservations == NumReservations;
	//return ReturnValue;	
}

event RegisterPartyMembers()
{
	local int Index, PartyIndex;
	local OnlineSubsystem OnlineSub;
	local OnlineRecentPlayersList PlayersList;
	local array<UniqueNetId> Members;
	local PlayerReservation PlayerRes;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x244
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
	{
		PartyIndex = 0;
		J0x7A:

		// End:0x244 [Loop If]
		if(PartyIndex < Reservations.Length)
		{
			Index = 0;
			J0x9D:

			// End:0x19E [Loop If]
			if(Index < Reservations[PartyIndex].PartyMembers.Length)
			{
				PlayerRes = Reservations[PartyIndex].PartyMembers[Index];
				OnlineSub.GameInterface.RegisterPlayer(OnlineSessionName, PlayerRes.NetId, false);
				Members.AddItem(PlayerRes.NetId);
				Index++;
				// [Loop Continue]
				goto J0x9D;
			}
			PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
			// End:0x236
			if(PlayersList != none)
			{
				PlayersList.AddPartyToRecentParties(Reservations[PartyIndex].PartyLeader, Members);
			}
			PartyIndex++;
			// [Loop Continue]
			goto J0x7A;
		}
	}
	//return;	
}

event UnregisterPartyMembers()
{
	local int Index, PartyIndex;
	local OnlineSubsystem OnlineSub;
	local PlayerReservation PlayerRes;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x182
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
	{
		PartyIndex = 0;
		J0x7A:

		// End:0x182 [Loop If]
		if(PartyIndex < Reservations.Length)
		{
			Index = 0;
			J0x9D:

			// End:0x174 [Loop If]
			if(Index < Reservations[PartyIndex].PartyMembers.Length)
			{
				PlayerRes = Reservations[PartyIndex].PartyMembers[Index];
				OnlineSub.GameInterface.UnregisterPlayer(OnlineSessionName, PlayerRes.NetId);
				Index++;
				// [Loop Continue]
				goto J0x9D;
			}
			PartyIndex++;
			// [Loop Continue]
			goto J0x7A;
		}
	}
	//return;	
}

event UnregisterParty(UniqueNetId PartyLeader)
{
	local int PlayerIndex, PartyIndex;
	local OnlineSubsystem OnlineSub;
	local PlayerReservation PlayerRes;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x1BD
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
	{
		PartyIndex = 0;
		J0x7A:

		// End:0x1BD [Loop If]
		if(PartyIndex < Reservations.Length)
		{
			// End:0x1AF
			if(Reservations[PartyIndex].PartyLeader == PartyLeader)
			{
				PlayerIndex = 0;
				J0xD8:

				// End:0x1AF [Loop If]
				if(PlayerIndex < Reservations[PartyIndex].PartyMembers.Length)
				{
					PlayerRes = Reservations[PartyIndex].PartyMembers[PlayerIndex];
					OnlineSub.GameInterface.UnregisterPlayer(OnlineSessionName, PlayerRes.NetId);
					PlayerIndex++;
					// [Loop Continue]
					goto J0xD8;
				}
			}
			PartyIndex++;
			// [Loop Continue]
			goto J0x7A;
		}
	}
	//return;	
}

// Export UPartyBeaconHost::execAppendReservationSkillsToSearch(FFrame&, void* const)
native function AppendReservationSkillsToSearch(OnlineGameSearch Search);

function GetPlayers(out array<UniqueNetId> Players)
{
	local int PlayerIndex, PartyIndex;
	local PlayerReservation PlayerRes;

	PartyIndex = 0;
	J0x0B:

	// End:0xE2 [Loop If]
	if(PartyIndex < Reservations.Length)
	{
		PlayerIndex = 0;
		J0x2E:

		// End:0xD4 [Loop If]
		if(PlayerIndex < Reservations[PartyIndex].PartyMembers.Length)
		{
			PlayerRes = Reservations[PartyIndex].PartyMembers[PlayerIndex];
			Players.AddItem(PlayerRes.NetId);
			PlayerIndex++;
			// [Loop Continue]
			goto J0x2E;
		}
		PartyIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function GetPartyLeaders(out array<UniqueNetId> PartyLeaders)
{
	local int PartyIndex;

	PartyIndex = 0;
	J0x0B:

	// End:0x64 [Loop If]
	if(PartyIndex < Reservations.Length)
	{
		PartyLeaders.AddItem(Reservations[PartyIndex].PartyLeader);
		PartyIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

// Export UPartyBeaconHost::execGetMaxAvailableTeamSize(FFrame&, void* const)
native function int GetMaxAvailableTeamSize();

function DumpReservations()
{
	local int PartyIndex, MemberIndex;
	local UniqueNetId NetId;
	local PlayerReservation PlayerRes;

	LogInternal("Debug info for Beacon: " $ string(BeaconName), 'DevBeacon');
	LogInternal("Session that reservations are for: " $ string(OnlineSessionName), 'DevBeacon');
	LogInternal("Number of teams: " $ string(NumTeams), 'DevBeacon');
	LogInternal("Number players per team: " $ string(NumPlayersPerTeam), 'DevBeacon');
	LogInternal("Number total reservations: " $ string(NumReservations), 'DevBeacon');
	LogInternal("Number consumed reservations: " $ string(NumConsumedReservations), 'DevBeacon');
	LogInternal("Number of party reservations: " $ string(Reservations.Length), 'DevBeacon');
	LogInternal("Reserved host team: " $ string(ReservedHostTeamNum), 'DevBeacon');
	PartyIndex = 0;
	J0x1AB:

	// End:0x40A [Loop If]
	if(PartyIndex < Reservations.Length)
	{
		NetId = Reservations[PartyIndex].PartyLeader;
		LogInternal("  Party leader: " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId), 'DevBeacon');
		LogInternal("  Party team: " $ string(Reservations[PartyIndex].TeamNum), 'DevBeacon');
		LogInternal("  Party size: " $ string(Reservations[PartyIndex].PartyMembers.Length), 'DevBeacon');
		MemberIndex = 0;
		J0x2D0:

		// End:0x3FC [Loop If]
		if(MemberIndex < Reservations[PartyIndex].PartyMembers.Length)
		{
			PlayerRes = Reservations[PartyIndex].PartyMembers[MemberIndex];
			LogInternal((((("  Party member: " $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(PlayerRes.NetId)) $ " skill: ") $ string(PlayerRes.Skill)) $ " xp: ") $ string(PlayerRes.XpLevel), 'DevBeacon');
			MemberIndex++;
			// [Loop Continue]
			goto J0x2D0;
		}
		PartyIndex++;
		// [Loop Continue]
		goto J0x1AB;
	}
	LogInternal("", 'DevBeacon');
	//return;	
}
