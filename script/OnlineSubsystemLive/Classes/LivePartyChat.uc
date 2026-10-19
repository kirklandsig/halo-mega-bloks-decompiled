class LivePartyChat extends Object within onlinesubsystemlive
	native
	implements(OnlinePartyChatInterface);

struct native PerUserPartyChatDelegates
{
	var array< delegate<OnSendPartyGameInvitesComplete> > GameInviteDelegates;
	var array< delegate<OnPartyMemberListChanged> > PartyMemberDelegates;
	var array< delegate<OnPartyMembersInfoChanged> > PartyMemberInfoDelegates;

	structdefaultproperties
	{
		GameInviteDelegates=none
		PartyMemberDelegates=none
		PartyMemberInfoDelegates=none
	}
};

var private native const noexport Pointer VfTable_FTickableObject;
var native const transient Pointer NotificationHandle;
var PerUserPartyChatDelegates PartyChatDelegates[4];
var transient QWord TotalBandwidthUsed;
var transient int BandwidthUsed;
var transient float ElapsedTime;
var native const array<Pointer> AsyncTasks;
var array<OnlinePartyMember> CachedPartyMembers;
//var delegate<OnSendPartyGameInvitesComplete> __OnSendPartyGameInvitesComplete__Delegate;
//var delegate<OnPartyMemberListChanged> __OnPartyMemberListChanged__Delegate;
//var delegate<OnPartyMembersInfoChanged> __OnPartyMembersInfoChanged__Delegate;

// Export ULivePartyChat::execSendPartyGameInvites(FFrame&, void* const)
native function bool SendPartyGameInvites(byte LocalUserNum);

delegate OnSendPartyGameInvitesComplete(bool bWasSuccessful)
{
	//return;	
}

function AddSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate)
{
	// End:0x9E
	if((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)
	{
		// End:0x9E
		if(PartyChatDelegates[int(LocalUserNum)].GameInviteDelegates.Find(SendPartyGameInvitesCompleteDelegate) == -1)
		{
			PartyChatDelegates[int(LocalUserNum)].GameInviteDelegates.AddItem(SendPartyGameInvitesCompleteDelegate);
		}
	}
	//return;	
}

function ClearSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB0
	if((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)
	{
		RemoveIndex = PartyChatDelegates[int(LocalUserNum)].GameInviteDelegates.Find(SendPartyGameInvitesCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PartyChatDelegates[int(LocalUserNum)].GameInviteDelegates.Remove(RemoveIndex, 1);
		}
	}
	//return;	
}

// Export ULivePartyChat::execGetPartyMembersInformation(FFrame&, void* const)
native function bool GetPartyMembersInformation(out array<OnlinePartyMember> PartyMembers);

// Export ULivePartyChat::execGetPartyMemberInformation(FFrame&, void* const)
native function bool GetPartyMemberInformation(UniqueNetId MemberId, out OnlinePartyMember PartyMember);

delegate OnPartyMemberListChanged(bool bJoinedOrLeft, string PlayerName, UniqueNetId PlayerID)
{
	//return;	
}

function AddPartyMemberListChangedDelegate(byte LocalUserNum, delegate<OnPartyMemberListChanged> PartyMemberListChangedDelegate)
{
	// End:0x9E
	if((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)
	{
		// End:0x9E
		if(PartyChatDelegates[int(LocalUserNum)].PartyMemberDelegates.Find(PartyMemberListChangedDelegate) == -1)
		{
			PartyChatDelegates[int(LocalUserNum)].PartyMemberDelegates.AddItem(PartyMemberListChangedDelegate);
		}
	}
	//return;	
}

function ClearPartyMemberListChangedDelegate(byte LocalUserNum, delegate<OnPartyMemberListChanged> PartyMemberListChangedDelegate)
{
	local int RemoveIndex;

	// End:0xB0
	if((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)
	{
		RemoveIndex = PartyChatDelegates[int(LocalUserNum)].PartyMemberDelegates.Find(PartyMemberListChangedDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PartyChatDelegates[int(LocalUserNum)].PartyMemberDelegates.Remove(RemoveIndex, 1);
		}
	}
	//return;	
}

delegate OnPartyMembersInfoChanged(string PlayerName, UniqueNetId PlayerID, int CustomData1, int CustomData2, int CustomData3, int CustomData4)
{
	//return;	
}

function AddPartyMembersInfoChangedDelegate(byte LocalUserNum, delegate<OnPartyMembersInfoChanged> PartyMembersInfoChangedDelegate)
{
	// End:0x9E
	if((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)
	{
		// End:0x9E
		if(PartyChatDelegates[int(LocalUserNum)].PartyMemberInfoDelegates.Find(PartyMembersInfoChangedDelegate) == -1)
		{
			PartyChatDelegates[int(LocalUserNum)].PartyMemberInfoDelegates.AddItem(PartyMembersInfoChangedDelegate);
		}
	}
	//return;	
}

function ClearPartyMembersInfoChangedDelegate(byte LocalUserNum, delegate<OnPartyMembersInfoChanged> PartyMembersInfoChangedDelegate)
{
	local int RemoveIndex;

	// End:0xB0
	if((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)
	{
		RemoveIndex = PartyChatDelegates[int(LocalUserNum)].PartyMemberInfoDelegates.Find(PartyMembersInfoChangedDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PartyChatDelegates[int(LocalUserNum)].PartyMemberInfoDelegates.Remove(RemoveIndex, 1);
		}
	}
	//return;	
}

// Export ULivePartyChat::execSetPartyMemberCustomData(FFrame&, void* const)
native function bool SetPartyMemberCustomData(byte LocalUserNum, int Data1, int Data2, int Data3, int Data4);

function int GetPartyBandwidth()
{
	return BandwidthUsed;
	//return ReturnValue;	
}

// Export ULivePartyChat::execShowPartyUI(FFrame&, void* const)
native function bool ShowPartyUI(byte LocalUserNum);

// Export ULivePartyChat::execShowVoiceChannelUI(FFrame&, void* const)
native function bool ShowVoiceChannelUI(byte LocalUserNum);

// Export ULivePartyChat::execShowCommunitySessionsUI(FFrame&, void* const)
native function bool ShowCommunitySessionsUI(byte LocalUserNum);

// Export ULivePartyChat::execIsInPartyChat(FFrame&, void* const)
native function bool IsInPartyChat(byte LocalUserNum);
