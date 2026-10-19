class OnlineRecentPlayersList extends Object
	config(Engine);

struct RecentParty
{
	var UniqueNetId PartyLeader;
	var array<UniqueNetId> PartyMembers;

	structdefaultproperties
	{
		PartyLeader=(Uid=())
		PartyMembers=none
	}
};

struct CurrentPlayerMet
{
	var int TeamNum;
	var int Skill;
	var UniqueNetId NetId;

	structdefaultproperties
	{
		TeamNum=0
		Skill=0
		NetId=(Uid=())
	}
};

var array<UniqueNetId> RecentPlayers;
var array<RecentParty> RecentParties;
var RecentParty LastParty;
var config int MaxRecentPlayers;
var config int MaxRecentParties;
var int RecentPlayersAddIndex;
var int RecentPartiesAddIndex;
var private array<CurrentPlayerMet> CurrentPlayers;

function AddPlayerToRecentPlayers(UniqueNetId NewPlayer)
{
	local int FindIndex;

	FindIndex = RecentPlayers.Find('Uid', NewPlayer.Uid);
	// End:0xCB
	if(FindIndex == -1)
	{
		// End:0x71
		if(RecentPlayersAddIndex >= MaxRecentPlayers)
		{
			RecentPlayersAddIndex = 0;
		}
		// End:0xA3
		if((RecentPlayersAddIndex + 1) >= RecentPlayers.Length)
		{
			RecentPlayers.Length = RecentPlayersAddIndex + 1;
		}
		RecentPlayers[RecentPlayersAddIndex] = NewPlayer;
		RecentPlayersAddIndex++;
	}
	//return;	
}

function ClearRecentPlayers()
{
	RecentPlayersAddIndex = 0;
	RecentPlayers.Length = 0;
	//return;	
}

function AddPartyToRecentParties(UniqueNetId PartyLeader, const out array<UniqueNetId> PartyMembers)
{
	local int FindIndex;

	FindIndex = RecentParties.Find('PartyLeader', PartyLeader);
	// End:0xFB
	if(FindIndex == -1)
	{
		// End:0x5E
		if(RecentPartiesAddIndex >= MaxRecentParties)
		{
			RecentPartiesAddIndex = 0;
		}
		// End:0x90
		if((RecentPartiesAddIndex + 1) >= RecentParties.Length)
		{
			RecentParties.Length = RecentPartiesAddIndex + 1;
		}
		RecentParties[RecentPartiesAddIndex].PartyLeader = PartyLeader;
		RecentParties[RecentPartiesAddIndex].PartyMembers = PartyMembers;
		RecentPartiesAddIndex++;
	}
	//return;	
}

function ClearRecentParties()
{
	RecentPartiesAddIndex = 0;
	RecentParties.Length = 0;
	//return;	
}

function GetPlayersFromRecentParties(out array<UniqueNetId> Players)
{
	local int PartyIndex, MemberIndex, AddMemberAt;

	Players.Length = 0;
	AddMemberAt = 0;
	PartyIndex = 0;
	J0x22:

	// End:0xF1 [Loop If]
	if(PartyIndex < RecentParties.Length)
	{
		MemberIndex = 0;
		J0x45:

		// End:0xE3 [Loop If]
		if(MemberIndex < RecentParties[PartyIndex].PartyMembers.Length)
		{
			Players.Length = AddMemberAt + 1;
			Players[AddMemberAt] = RecentParties[PartyIndex].PartyMembers[MemberIndex];
			MemberIndex++;
			// [Loop Continue]
			goto J0x45;
		}
		PartyIndex++;
		// [Loop Continue]
		goto J0x22;
	}
	//return;	
}

function GetPlayersFromCurrentPlayers(out array<UniqueNetId> Players)
{
	local int PlayerIndex;

	Players.Length = 0;
	PlayerIndex = 0;
	J0x17:

	// End:0x70 [Loop If]
	if(PlayerIndex < CurrentPlayers.Length)
	{
		Players.AddItem(CurrentPlayers[PlayerIndex].NetId);
		PlayerIndex++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

function int GetSkillForCurrentPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	PlayerIndex = 0;
	J0x0B:

	// End:0x93 [Loop If]
	if(PlayerIndex < CurrentPlayers.Length)
	{
		// End:0x85
		if(CurrentPlayers[PlayerIndex].NetId == Player)
		{
			return CurrentPlayers[PlayerIndex].Skill;
		}
		PlayerIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	return 0;
	//return ReturnValue;	
}

function int GetTeamForCurrentPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	PlayerIndex = 0;
	J0x0B:

	// End:0x93 [Loop If]
	if(PlayerIndex < CurrentPlayers.Length)
	{
		// End:0x85
		if(CurrentPlayers[PlayerIndex].NetId == Player)
		{
			return CurrentPlayers[PlayerIndex].TeamNum;
		}
		PlayerIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	return 255;
	//return ReturnValue;	
}

function SetLastParty(UniqueNetId PartyLeader, const out array<UniqueNetId> PartyMembers)
{
	LastParty.PartyLeader = PartyLeader;
	LastParty.PartyMembers = PartyMembers;
	//return;	
}

function bool ShowRecentPlayerList(byte LocalUserNum, string Title, string Description)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xC9
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, none))
	{
		return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, RecentPlayers, Title, Description);
	}
	return false;
	//return ReturnValue;	
}

function bool ShowRecentPartiesPlayerList(byte LocalUserNum, string Title, string Description)
{
	local OnlineSubsystem OnlineSub;
	local array<UniqueNetId> Players;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xDC
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, none))
	{
		GetPlayersFromRecentParties(Players);
		return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, Players, Title, Description);
	}
	return false;
	//return ReturnValue;	
}

function bool ShowLastPartyPlayerList(byte LocalUserNum, string Title, string Description)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xDC
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, none))
	{
		return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, LastParty.PartyMembers, Title, Description);
	}
	return false;
	//return ReturnValue;	
}

function bool ShowCurrentPlayersList(byte LocalUserNum, string Title, string Description)
{
	local OnlineSubsystem OnlineSub;
	local array<UniqueNetId> Players;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xDC
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, none))
	{
		GetPlayersFromCurrentPlayers(Players);
		return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, Players, Title, Description);
	}
	return false;
	//return ReturnValue;	
}

function DumpPlayersList(const out array<CurrentPlayerMet> Players)
{
	local OnlineSubsystem OnlineSub;
	local int PlayerIdx, TeamNum;
	local UniqueNetId NetId;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x155
	if(OnlineSub != none)
	{
		PlayerIdx = 0;
		J0x43:

		// End:0x155 [Loop If]
		if(PlayerIdx < Players.Length)
		{
			NetId = Players[PlayerIdx].NetId;
			TeamNum = Players[PlayerIdx].TeamNum;
			LogInternal(((((("DumpPlayersList: " $ " TeamNum=") $ string(TeamNum)) $ " PlayerIdx=") $ string(PlayerIdx)) $ " UniqueId=") $ OnlineSub.UniqueNetIdToString(NetId), 'DevOnline');
			PlayerIdx++;
			// [Loop Continue]
			goto J0x43;
		}
	}
	//return;	
}

function DumpCurrentPlayers()
{
	DumpPlayersList(CurrentPlayers);
	//return;	
}

function SetCurrentPlayersList(const array<CurrentPlayerMet> Players)
{
	DumpPlayersList(Players);
	CurrentPlayers = Players;
	//return;	
}

function int GetCurrentPlayersListCount()
{
	return CurrentPlayers.Length;
	//return ReturnValue;	
}

defaultproperties
{
	MaxRecentPlayers=100
	MaxRecentParties=5
}