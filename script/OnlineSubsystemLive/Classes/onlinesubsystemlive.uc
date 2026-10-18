class onlinesubsystemlive extends OnlineSubsystemCommonImpl
	native
	config(Engine)
	implements(OnlinePlayerInterface,OnlinePlayerInterfaceEx,OnlineSystemInterface,OnlineGameInterface,OnlineContentInterface,OnlineVoiceInterface,OnlineStatsInterface,OnlineTitleFileInterface,OnlineSocialInterface);

struct native FriendsListCache
{
	var array<OnlineFriend> Friends;
	var OnlineSubsystem.EOnlineEnumerationReadState ReadState;
	var array< delegate<OnReadFriendsComplete> > ReadFriendsDelegates;
	var array< delegate<OnFriendsChange> > FriendsChangeDelegates;

	structdefaultproperties
	{
		Friends=none
		ReadState=EOnlineEnumerationReadState.OERS_NotStarted
		ReadFriendsDelegates=none
		FriendsChangeDelegates=none
	}
};

struct native LoginStatusDelegates
{
	var array< delegate<OnLoginStatusChange> > Delegates;

	structdefaultproperties
	{
		Delegates=none
	}
};

struct native CachedLoginState
{
	var const OnlineSubsystem.ELoginStatus LoginStatus;
	var const UniqueNetId OnlineXuid;
	var const UniqueNetId OfflineXuid;

	structdefaultproperties
	{
		LoginStatus=ELoginStatus.LS_NotLoggedIn
		OnlineXuid=(Uid=())
		OfflineXuid=(Uid=())
	}
};

struct native OnlineSaveGameDataMapping
{
	var string InternalFileName;
	var array<byte> SaveGameData;
	var OnlineSubsystem.EOnlineEnumerationReadState ReadWriteState;

	structdefaultproperties
	{
		InternalFileName=""
		SaveGameData=none
		ReadWriteState=EOnlineEnumerationReadState.OERS_NotStarted
	}
};

struct native OnlineSaveGame extends OnlineContent
{
	var array<OnlineSaveGameDataMapping> SaveGames;
	var byte BindRefCount;
	var bool bIsBound;
	var bool bIsValid;
};

struct native OnlineCrossTitleSaveGame extends OnlineSaveGame
{
	var int TitleId;
};

struct native ContentListCache
{
	var array<OnlineContent> SaveGameContent;
	var OnlineSubsystem.EOnlineEnumerationReadState SaveGameReadState;
	var array< delegate<OnReadContentComplete> > SaveGameReadCompleteDelegates;
	var array<OnlineContent> Content;
	var OnlineSubsystem.EOnlineEnumerationReadState ReadState;
	var array< delegate<OnContentChange> > ContentChangeDelegates;
	var array< delegate<OnReadContentComplete> > ReadCompleteDelegates;
	var int NewDownloadCount;
	var int TotalDownloadCount;
	var array< delegate<OnQueryAvailableDownloadsComplete> > QueryDownloadsDelegates;
	var array< delegate<OnReadSaveGameDataComplete> > ReadSaveGameDataCompleteDelegates;
	var array< delegate<OnWriteSaveGameDataComplete> > WriteSaveGameDataCompleteDelegates;
	var array<OnlineSaveGame> SaveGames;
	var array< delegate<OnReadCrossTitleContentComplete> > SaveGameReadCrossTitleCompleteDelegates;
	var OnlineSubsystem.EOnlineEnumerationReadState SaveGameCrossTitleReadState;
	var array< delegate<OnReadCrossTitleContentComplete> > ReadCrossTitleCompleteDelegates;
	var OnlineSubsystem.EOnlineEnumerationReadState ReadCrossTitleState;
	var array<OnlineCrossTitleContent> CrossTitleSaveGameContent;
	var array<OnlineCrossTitleContent> CrossTitleContent;
	var array<OnlineCrossTitleSaveGame> CrossTitleSaveGames;
	var array< delegate<OnReadCrossTitleSaveGameDataComplete> > ReadCrossTitleSaveGameDataCompleteDelegates;

	structdefaultproperties
	{
		SaveGameContent=none
		SaveGameReadState=EOnlineEnumerationReadState.OERS_NotStarted
		SaveGameReadCompleteDelegates=none
		Content=none
		ReadState=EOnlineEnumerationReadState.OERS_NotStarted
		ContentChangeDelegates=none
		ReadCompleteDelegates=none
		NewDownloadCount=0
		TotalDownloadCount=0
		QueryDownloadsDelegates=none
		ReadSaveGameDataCompleteDelegates=none
		WriteSaveGameDataCompleteDelegates=none
		SaveGames=none
		SaveGameReadCrossTitleCompleteDelegates=none
		SaveGameCrossTitleReadState=EOnlineEnumerationReadState.OERS_NotStarted
		ReadCrossTitleCompleteDelegates=none
		ReadCrossTitleState=EOnlineEnumerationReadState.OERS_NotStarted
		CrossTitleSaveGameContent=none
		CrossTitleContent=none
		CrossTitleSaveGames=none
		ReadCrossTitleSaveGameDataCompleteDelegates=none
	}
};

struct native DeviceIdCache
{
	var int DeviceID;
	var delegate<OnDeviceSelectionComplete> DeviceSelectionMulticast;
	var array< delegate<OnDeviceSelectionComplete> > DeviceSelectionDelegates;

	structdefaultproperties
	{
		DeviceID=0
		DeviceSelectionMulticast=None
		DeviceSelectionDelegates=none
	}
};

struct native CrossTitleProfileEntry
{
	var int TitleId;
	var OnlineProfileSettings Profile;

	structdefaultproperties
	{
		TitleId=0
		Profile=none
	}
};

struct native ProfileSettingsCache
{
	var OnlineProfileSettings Profile;
	var array< delegate<OnReadProfileSettingsComplete> > ReadDelegates;
	var array< delegate<OnWriteProfileSettingsComplete> > WriteDelegates;
	var array< delegate<OnProfileDataChanged> > ProfileDataChangedDelegates;
	var array< delegate<OnReadCrossTitleProfileSettingsComplete> > CrossTitleReadDelegates;
	var array<CrossTitleProfileEntry> CrossTitleProfileCache;

	structdefaultproperties
	{
		Profile=none
		ReadDelegates=none
		WriteDelegates=none
		ProfileDataChangedDelegates=none
		CrossTitleReadDelegates=none
		CrossTitleProfileCache=none
	}
};

struct native PlayerStorageSettingsCacheLocal
{
	var OnlinePlayerStorage PlayerStorage;
	var array< delegate<OnReadPlayerStorageComplete> > ReadDelegates;
	var array< delegate<OnWritePlayerStorageComplete> > WriteDelegates;

	structdefaultproperties
	{
		PlayerStorage=none
		ReadDelegates=none
		WriteDelegates=none
	}
};

struct native PlayerStorageSettingsCacheRemote
{
	var OnlinePlayerStorage PlayerStorage;
	var array< delegate<OnReadPlayerStorageForNetIdComplete> > ReadDelegates;

	structdefaultproperties
	{
		PlayerStorage=none
		ReadDelegates=none
	}
};

struct native TalkerPriority
{
	var int CurrentPriority;
	var int LastPriority;

	structdefaultproperties
	{
		CurrentPriority=0
		LastPriority=0
	}
};

struct native LiveRemoteTalker extends RemoteTalker
{
	var TalkerPriority LocalPriorities[4];
};

struct native PerUserDelegateLists
{
	var array< delegate<OnRecognitionComplete> > SpeechRecognitionDelegates;
	var array< delegate<OnUnlockAchievementComplete> > AchievementDelegates;
	var array< delegate<OnReadAchievementsComplete> > AchievementReadDelegates;
	var array< delegate<OnPostImageCompleted> > PostImageDelegates;
	var array< delegate<OnPostImageCompleted> > PostLinkDelegates;

	structdefaultproperties
	{
		SpeechRecognitionDelegates=none
		AchievementDelegates=none
		AchievementReadDelegates=none
		PostImageDelegates=none
		PostLinkDelegates=none
	}
};

struct native InviteData
{
	var array< delegate<OnGameInviteAccepted> > InviteDelegates;
	var native const transient Pointer InviteData;
	var const OnlineGameSearch InviteSearch;

	structdefaultproperties
	{
		InviteDelegates=none
		InviteSearch=none
	}
};

struct native CachedAchievements
{
	var int PlayerNum;
	var int TitleId;
	var array<AchievementDetails> Achievements;
	var OnlineSubsystem.EOnlineEnumerationReadState ReadState;
	var private const Surface TempImage;

	structdefaultproperties
	{
		PlayerNum=0
		TitleId=0
		Achievements=none
		ReadState=EOnlineEnumerationReadState.OERS_NotStarted
		TempImage=none
	}
};

var native const transient Pointer NotificationHandle;
var const OnlineGameSearch GameSearch;
var const OnlineSubsystem.ELanBeaconState LanBeaconState;
var const byte LanNonce[8];
var config OnlineSubsystem.ENetworkNotificationPosition CurrentNotificationPosition;
var byte bWasKeyboardInputCanceled;
var const byte QoSPacket[512];
var byte DelayedInviteUserMask;
var const config int LanAnnouncePort;
var const config int LanGameUniqueId;
var const config int LanPacketPlatformMask;
var float LanQueryTimeLeft;
var config float LanQueryTimeout;
var native const transient Pointer LanBeacon;
var const config int NumLogins;
var native const array<Pointer> AsyncTasks;
var FriendsListCache FriendsCache[4];
var array< delegate<OnLoginChange> > LoginChangeDelegates;
var LoginStatusDelegates PlayerLoginStatusDelegates[4];
var const CachedLoginState LastLoginState[4];
var ContentListCache ContentCache[4];
var array< delegate<OnContentChange> > AnyContentChangeDelegates;
var string KeyboardInputResults;
var DeviceIdCache DeviceCache[4];
var ProfileSettingsCache ProfileCache[4];
var transient PlayerStorageSettingsCacheLocal PlayerStorageCacheLocal[4];
var native transient Map_Mirror PlayerStorageCacheRemote;
var LocalTalker LocalTalkers[4];
var array<LiveRemoteTalker> RemoteTalkers;
var array< delegate<OnPlayerTalkingStateChange> > TalkingDelegates;
var PerUserDelegateLists PerUserDelegates[4];
var const OnlineStatsRead CurrentStatsRead;
var const bool bIsInSignInUI;
var config bool bShouldLogArbitrationData;
var config bool bShouldLogStatsData;
var config bool bShouldUseMcp;
var transient bool bIsCountingDownSigninNotification;
var array< delegate<OnLoginCancelled> > LoginCancelledDelegates;
var array< delegate<OnLoginFailed> > LoginFailedDelegates;
var array< delegate<OnLogoutCompleted> > LogoutCompletedDelegates;
var array< delegate<OnCreateOnlineGameComplete> > CreateOnlineGameCompleteDelegates;
var array< delegate<OnUpdateOnlineGameComplete> > UpdateOnlineGameCompleteDelegates;
var array< delegate<OnDestroyOnlineGameComplete> > DestroyOnlineGameCompleteDelegates;
var array< delegate<OnJoinOnlineGameComplete> > JoinOnlineGameCompleteDelegates;
var array< delegate<OnMigrateOnlineGameComplete> > MigrateOnlineGameCompleteDelegates;
var array< delegate<OnJoinMigratedOnlineGameComplete> > JoinMigratedOnlineGameCompleteDelegates;
var array< delegate<OnRecalculateSkillRatingComplete> > RecalculateSkillRatingCompleteDelegates;
var array< delegate<OnStartOnlineGameComplete> > StartOnlineGameCompleteDelegates;
var array< delegate<OnEndOnlineGameComplete> > EndOnlineGameCompleteDelegates;
var array< delegate<OnFindOnlineGamesComplete> > FindOnlineGamesCompleteDelegates;
var array< delegate<OnCancelFindOnlineGamesComplete> > CancelFindOnlineGamesCompleteDelegates;
var array< delegate<OnQosStatusChanged> > QosStatusChangedDelegates;
var array< delegate<OnRegisterPlayerComplete> > RegisterPlayerCompleteDelegates;
var array< delegate<OnUnregisterPlayerComplete> > UnregisterPlayerCompleteDelegates;
var array< delegate<OnArbitrationRegistrationComplete> > ArbitrationRegistrationCompleteDelegates;
var array< delegate<OnReadOnlineStatsComplete> > ReadOnlineStatsCompleteDelegates;
var array< delegate<OnExternalUIChange> > ExternalUIChangeDelegates;
var array< delegate<OnControllerChange> > ControllerChangeDelegates;
var int LastInputDeviceConnectedMask;
var array< delegate<OnConnectionStatusChange> > ConnectionStatusChangeDelegates;
var array< delegate<OnStorageDeviceChange> > StorageDeviceChangeDelegates;
var array< delegate<OnConnectionStatusChange> > LinkStatusChangeDelegates;
var array< delegate<OnFlushOnlineStatsComplete> > FlushOnlineStatsDelegates;
var array< delegate<OnKeyboardInputComplete> > KeyboardInputDelegates;
var array< delegate<OnReadTitleFileComplete> > ReadTitleFileCompleteDelegates;
var array< delegate<OnQuerySocialPostPrivilegesCompleted> > QuerySocialPostPrivilegesDelegates;
var InviteData InviteCache[4];
var array< delegate<OnMutingChange> > MutingChangeDelegates;
var array< delegate<OnJoinFriendGameComplete> > JoinFriendGameCompleteDelegates;
var array<TitleFile> TitleManagedFiles;
var array<CachedAchievements> AchievementList;
var transient float SigninCountDownCounter;
var float SigninCountDownDelay;
var config int DebugLogLevel;
var config float VoiceNotificationDelta;
var config float MaxElapsedAsyncTaskTime;
var config array<config string> LspNames;
var const localized string CloseGuideString;
var const localized string DeleteMessageString;
//var delegate<OnLoginChange> __OnLoginChange__Delegate;
//var delegate<OnLoginCancelled> __OnLoginCancelled__Delegate;
//var delegate<OnMutingChange> __OnMutingChange__Delegate;
//var delegate<OnFriendsChange> __OnFriendsChange__Delegate;
//var delegate<OnLoginFailed> __OnLoginFailed__Delegate;
//var delegate<OnLogoutCompleted> __OnLogoutCompleted__Delegate;
//var delegate<OnLoginStatusChange> __OnLoginStatusChange__Delegate;
//var delegate<OnKeyboardInputComplete> __OnKeyboardInputComplete__Delegate;
//var delegate<OnLinkStatusChange> __OnLinkStatusChange__Delegate;
//var delegate<OnExternalUIChange> __OnExternalUIChange__Delegate;
//var delegate<OnControllerChange> __OnControllerChange__Delegate;
//var delegate<OnConnectionStatusChange> __OnConnectionStatusChange__Delegate;
//var delegate<OnStorageDeviceChange> __OnStorageDeviceChange__Delegate;
//var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;
//var delegate<OnFindOnlineGamesComplete> __OnFindOnlineGamesComplete__Delegate;
//var delegate<OnCreateOnlineGameComplete> __OnCreateOnlineGameComplete__Delegate;
//var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;
//var delegate<OnDestroyOnlineGameComplete> __OnDestroyOnlineGameComplete__Delegate;
//var delegate<OnCancelFindOnlineGamesComplete> __OnCancelFindOnlineGamesComplete__Delegate;
//var delegate<OnQosStatusChanged> __OnQosStatusChanged__Delegate;
//var delegate<OnJoinOnlineGameComplete> __OnJoinOnlineGameComplete__Delegate;
//var delegate<OnRegisterPlayerComplete> __OnRegisterPlayerComplete__Delegate;
//var delegate<OnUnregisterPlayerComplete> __OnUnregisterPlayerComplete__Delegate;
//var delegate<OnRecalculateSkillRatingComplete> __OnRecalculateSkillRatingComplete__Delegate;
//var delegate<OnMigrateOnlineGameComplete> __OnMigrateOnlineGameComplete__Delegate;
//var delegate<OnJoinMigratedOnlineGameComplete> __OnJoinMigratedOnlineGameComplete__Delegate;
//var delegate<OnReadProfileSettingsComplete> __OnReadProfileSettingsComplete__Delegate;
//var delegate<OnWriteProfileSettingsComplete> __OnWriteProfileSettingsComplete__Delegate;
//var delegate<OnReadPlayerStorageComplete> __OnReadPlayerStorageComplete__Delegate;
//var delegate<OnReadPlayerStorageForNetIdComplete> __OnReadPlayerStorageForNetIdComplete__Delegate;
//var delegate<OnWritePlayerStorageComplete> __OnWritePlayerStorageComplete__Delegate;
//var delegate<OnDeviceSelectionComplete> __OnDeviceSelectionComplete__Delegate;
//var delegate<OnUnlockAchievementComplete> __OnUnlockAchievementComplete__Delegate;
//var delegate<OnProfileDataChanged> __OnProfileDataChanged__Delegate;
//var delegate<OnStartOnlineGameComplete> __OnStartOnlineGameComplete__Delegate;
//var delegate<OnEndOnlineGameComplete> __OnEndOnlineGameComplete__Delegate;
//var delegate<OnArbitrationRegistrationComplete> __OnArbitrationRegistrationComplete__Delegate;
//var delegate<OnReadFriendsComplete> __OnReadFriendsComplete__Delegate;
//var delegate<OnGameInviteAccepted> __OnGameInviteAccepted__Delegate;
//var delegate<OnContentChange> __OnContentChange__Delegate;
//var delegate<OnReadContentComplete> __OnReadContentComplete__Delegate;
//var delegate<OnReadCrossTitleContentComplete> __OnReadCrossTitleContentComplete__Delegate;
//var delegate<OnReadCrossTitleSaveGameDataComplete> __OnReadCrossTitleSaveGameDataComplete__Delegate;
//var delegate<OnQueryAvailableDownloadsComplete> __OnQueryAvailableDownloadsComplete__Delegate;
//var delegate<OnReadSaveGameDataComplete> __OnReadSaveGameDataComplete__Delegate;
//var delegate<OnWriteSaveGameDataComplete> __OnWriteSaveGameDataComplete__Delegate;
//var delegate<OnPlayerTalkingStateChange> __OnPlayerTalkingStateChange__Delegate;
//var delegate<OnRecognitionComplete> __OnRecognitionComplete__Delegate;
//var delegate<OnReadOnlineStatsComplete> __OnReadOnlineStatsComplete__Delegate;
//var delegate<OnFlushOnlineStatsComplete> __OnFlushOnlineStatsComplete__Delegate;
//var delegate<OnAddFriendByNameComplete> __OnAddFriendByNameComplete__Delegate;
//var delegate<OnFriendInviteReceived> __OnFriendInviteReceived__Delegate;
//var delegate<OnReceivedGameInvite> __OnReceivedGameInvite__Delegate;
//var delegate<OnJoinFriendGameComplete> __OnJoinFriendGameComplete__Delegate;
//var delegate<OnFriendMessageReceived> __OnFriendMessageReceived__Delegate;
//var delegate<OnRegisterHostStatGuidComplete> __OnRegisterHostStatGuidComplete__Delegate;
//var delegate<OnReadAchievementsComplete> __OnReadAchievementsComplete__Delegate;
//var delegate<OnReadCrossTitleProfileSettingsComplete> __OnReadCrossTitleProfileSettingsComplete__Delegate;
//var delegate<OnQuerySocialPostPrivilegesCompleted> __OnQuerySocialPostPrivilegesCompleted__Delegate;
//var delegate<OnPostImageCompleted> __OnPostImageCompleted__Delegate;
//var delegate<OnPostLinkCompleted> __OnPostLinkCompleted__Delegate;
//var delegate<OnRequestTitleFileListComplete> __OnRequestTitleFileListComplete__Delegate;

delegate OnLoginChange(byte LocalUserNum)
{
	//return;	
}

delegate OnLoginCancelled()
{
	//return;	
}

delegate OnMutingChange()
{
	//return;	
}

delegate OnFriendsChange()
{
	//return;	
}

// Export Uonlinesubsystemlive::execInit(FFrame&, void* const)
native event bool Init();

// Export Uonlinesubsystemlive::execExit(FFrame&, void* const)
native event Exit();

// Export Uonlinesubsystemlive::execInitMarketPlace(FFrame&, void* const)
native function InitMarketPlace();

// Export Uonlinesubsystemlive::execShowMarketplaceUI(FFrame&, void* const)
native function ShowMarketplaceUI();

// Export Uonlinesubsystemlive::execCheckPurchaseCompleted(FFrame&, void* const)
native function bool CheckPurchaseCompleted();

// Export Uonlinesubsystemlive::execEnumerateOffers(FFrame&, void* const)
native function EnumerateOffers();

// Export Uonlinesubsystemlive::execConsumeAssets(FFrame&, void* const)
native function int ConsumeAssets(int Amount);

// Export Uonlinesubsystemlive::execGetQuantityForSelection(FFrame&, void* const)
native function int GetQuantityForSelection(int Selection);

// Export Uonlinesubsystemlive::execShowLoginUI(FFrame&, void* const)
native function bool ShowLoginUI(optional bool bShowOnlineOnly = false);

// Export Uonlinesubsystemlive::execLogin(FFrame&, void* const)
native function bool Login(byte LocalUserNum, string LoginName, string Password, optional bool bWantsLocalOnly);

// Export Uonlinesubsystemlive::execAutoLogin(FFrame&, void* const)
native function bool AutoLogin();

delegate OnLoginFailed(byte LocalUserNum, OnlineSubsystem.EOnlineServerConnectionStatus ErrorCode)
{
	//return;	
}

function AddLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginFailedDelegate)
{
	// End:0x36
	if(LoginFailedDelegates.Find(LoginFailedDelegate) == -1)
	{
		LoginFailedDelegates.AddItem(LoginFailedDelegate);
	}
	//return;	
}

function ClearLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginFailedDelegate)
{
	local int RemoveIndex;

	RemoveIndex = LoginFailedDelegates.Find(LoginFailedDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		LoginFailedDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execLogout(FFrame&, void* const)
native function bool Logout(byte LocalUserNum);

delegate OnLogoutCompleted(bool bWasSuccessful)
{
	//return;	
}

function AddLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate)
{
	// End:0x36
	if(LogoutCompletedDelegates.Find(LogoutDelegate) == -1)
	{
		LogoutCompletedDelegates.AddItem(LogoutDelegate);
	}
	//return;	
}

function ClearLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate)
{
	local int RemoveIndex;

	RemoveIndex = LogoutCompletedDelegates.Find(LogoutDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		LogoutCompletedDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetLoginStatus(FFrame&, void* const)
native function OnlineSubsystem.ELoginStatus GetLoginStatus(byte LocalUserNum);

// Export Uonlinesubsystemlive::execIsGuestLogin(FFrame&, void* const)
native function bool IsGuestLogin(byte LocalUserNum);

// Export Uonlinesubsystemlive::execIsLocalLogin(FFrame&, void* const)
native function bool IsLocalLogin(byte LocalUserNum);

// Export Uonlinesubsystemlive::execGetUniquePlayerId(FFrame&, void* const)
native function bool GetUniquePlayerId(byte LocalUserNum, out UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execGetPlayerNickname(FFrame&, void* const)
native function string GetPlayerNickname(byte LocalUserNum);

// Export Uonlinesubsystemlive::execCanPlayOnline(FFrame&, void* const)
native function OnlineSubsystem.EFeaturePrivilegeLevel CanPlayOnline(byte LocalUserNum);

// Export Uonlinesubsystemlive::execCanCommunicate(FFrame&, void* const)
native function OnlineSubsystem.EFeaturePrivilegeLevel CanCommunicate(byte LocalUserNum);

// Export Uonlinesubsystemlive::execCanDownloadUserContent(FFrame&, void* const)
native function OnlineSubsystem.EFeaturePrivilegeLevel CanDownloadUserContent(byte LocalUserNum);

// Export Uonlinesubsystemlive::execCanPurchaseContent(FFrame&, void* const)
native function OnlineSubsystem.EFeaturePrivilegeLevel CanPurchaseContent(byte LocalUserNum);

// Export Uonlinesubsystemlive::execCanViewPlayerProfiles(FFrame&, void* const)
native function OnlineSubsystem.EFeaturePrivilegeLevel CanViewPlayerProfiles(byte LocalUserNum);

// Export Uonlinesubsystemlive::execCanShowPresenceInformation(FFrame&, void* const)
native function OnlineSubsystem.EFeaturePrivilegeLevel CanShowPresenceInformation(byte LocalUserNum);

// Export Uonlinesubsystemlive::execIsFriend(FFrame&, void* const)
native function bool IsFriend(byte LocalUserNum, UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execAreAnyFriends(FFrame&, void* const)
native function bool AreAnyFriends(byte LocalUserNum, out array<FriendsQuery> Query);

// Export Uonlinesubsystemlive::execIsMuted(FFrame&, void* const)
native function bool IsMuted(byte LocalUserNum, UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execShowFriendsUI(FFrame&, void* const)
native function bool ShowFriendsUI(byte LocalUserNum);

// Export Uonlinesubsystemlive::execShowFriendsInviteUI(FFrame&, void* const)
native function bool ShowFriendsInviteUI(byte LocalUserNum, UniqueNetId PlayerID);

function AddLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate)
{
	// End:0x36
	if(LoginChangeDelegates.Find(LoginDelegate) == -1)
	{
		LoginChangeDelegates.AddItem(LoginDelegate);
	}
	//return;	
}

function ClearLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate)
{
	local int RemoveIndex;

	RemoveIndex = LoginChangeDelegates.Find(LoginDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		LoginChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

delegate OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
	//return;	
}

function AddLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.Find(LoginStatusDelegate) == -1)
		{
			PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.AddItem(LoginStatusDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddLoginStatusChangeDelegate()");
	}
	//return;	
}

function ClearLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.Find(LoginStatusDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearLoginStatusChangeDelegate()");
	}
	//return;	
}

function AddLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
	// End:0x36
	if(LoginCancelledDelegates.Find(CancelledDelegate) == -1)
	{
		LoginCancelledDelegates.AddItem(CancelledDelegate);
	}
	//return;	
}

function ClearLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
	local int RemoveIndex;

	RemoveIndex = LoginCancelledDelegates.Find(CancelledDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		LoginCancelledDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function AddMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate)
{
	// End:0x36
	if(MutingChangeDelegates.Find(MutingDelegate) == -1)
	{
		MutingChangeDelegates.AddItem(MutingDelegate);
	}
	//return;	
}

function ClearMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate)
{
	local int RemoveIndex;

	RemoveIndex = MutingChangeDelegates.Find(MutingDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		MutingChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function AddFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(FriendsCache[int(LocalUserNum)].FriendsChangeDelegates.Find(FriendsDelegate) == -1)
		{
			FriendsCache[int(LocalUserNum)].FriendsChangeDelegates.AddItem(FriendsDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddFriendsChangeDelegate()");
	}
	//return;	
}

function ClearFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = FriendsCache[int(LocalUserNum)].FriendsChangeDelegates.Find(FriendsDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			FriendsCache[int(LocalUserNum)].FriendsChangeDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadFriendsCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execShowFeedbackUI(FFrame&, void* const)
native function bool ShowFeedbackUI(byte LocalUserNum, UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execShowGamerCardUI(FFrame&, void* const)
native function bool ShowGamerCardUI(byte LocalUserNum, UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execShowMessagesUI(FFrame&, void* const)
native function bool ShowMessagesUI(byte LocalUserNum);

// Export Uonlinesubsystemlive::execShowAchievementsUI(FFrame&, void* const)
native function bool ShowAchievementsUI(byte LocalUserNum);

// Export Uonlinesubsystemlive::execShowGuideUI(FFrame&, void* const)
native function bool ShowGuideUI();

// Export Uonlinesubsystemlive::execShowPlayersUI(FFrame&, void* const)
native function bool ShowPlayersUI(byte LocalUserNum);

// Export Uonlinesubsystemlive::execShowKeyboardUI(FFrame&, void* const)
native function bool ShowKeyboardUI(byte LocalUserNum, string TitleText, string DescriptionText, optional bool bIsPassword = false, optional bool bShouldValidate = true, optional string DefaultText, optional int MaxResultLength = 256);

delegate OnKeyboardInputComplete(bool bWasSuccessful)
{
	//return;	
}

function AddKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate)
{
	// End:0x36
	if(KeyboardInputDelegates.Find(InputDelegate) == -1)
	{
		KeyboardInputDelegates.AddItem(InputDelegate);
	}
	//return;	
}

function ClearKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate)
{
	local int RemoveIndex;

	RemoveIndex = KeyboardInputDelegates.Find(InputDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		KeyboardInputDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function string GetKeyboardInputResults(out byte bWasCanceled)
{
	bWasCanceled = bWasKeyboardInputCanceled;
	return KeyboardInputResults;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execHasLinkConnection(FFrame&, void* const)
native function bool HasLinkConnection();

delegate OnLinkStatusChange(bool bIsConnected)
{
	//return;	
}

function AddLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
	local int AddIndex;

	// End:0x69
	if(LinkStatusChangeDelegates.Find(LinkStatusDelegate) == -1)
	{
		AddIndex = LinkStatusChangeDelegates.Length;
		LinkStatusChangeDelegates.Length = LinkStatusChangeDelegates.Length + 1;
		LinkStatusChangeDelegates[AddIndex] = LinkStatusDelegate;
	}
	//return;	
}

function ClearLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
	local int RemoveIndex;

	RemoveIndex = LinkStatusChangeDelegates.Find(LinkStatusDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		LinkStatusChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

delegate OnExternalUIChange(bool bIsOpening)
{
	//return;	
}

function AddExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
	local int AddIndex;

	// End:0x69
	if(ExternalUIChangeDelegates.Find(ExternalUIDelegate) == -1)
	{
		AddIndex = ExternalUIChangeDelegates.Length;
		ExternalUIChangeDelegates.Length = ExternalUIChangeDelegates.Length + 1;
		ExternalUIChangeDelegates[AddIndex] = ExternalUIDelegate;
	}
	//return;	
}

function ClearExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ExternalUIChangeDelegates.Find(ExternalUIDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ExternalUIChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function OnlineSubsystem.ENetworkNotificationPosition GetNetworkNotificationPosition()
{
	return CurrentNotificationPosition;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execSetNetworkNotificationPosition(FFrame&, void* const)
native function SetNetworkNotificationPosition(OnlineSubsystem.ENetworkNotificationPosition NewPos);

delegate OnControllerChange(int ControllerId, bool bIsConnected)
{
	//return;	
}

function AddControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
	local int AddIndex;

	// End:0x69
	if(ControllerChangeDelegates.Find(ControllerChangeDelegate) == -1)
	{
		AddIndex = ControllerChangeDelegates.Length;
		ControllerChangeDelegates.Length = ControllerChangeDelegates.Length + 1;
		ControllerChangeDelegates[AddIndex] = ControllerChangeDelegate;
	}
	//return;	
}

function ClearControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ControllerChangeDelegates.Find(ControllerChangeDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ControllerChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execIsControllerConnected(FFrame&, void* const)
native function bool IsControllerConnected(int ControllerId);

delegate OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
	//return;	
}

function AddConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
	local int AddIndex;

	// End:0x69
	if(ConnectionStatusChangeDelegates.Find(ConnectionStatusDelegate) == -1)
	{
		AddIndex = ConnectionStatusChangeDelegates.Length;
		ConnectionStatusChangeDelegates.Length = ConnectionStatusChangeDelegates.Length + 1;
		ConnectionStatusChangeDelegates[AddIndex] = ConnectionStatusDelegate;
	}
	//return;	
}

function ClearConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ConnectionStatusChangeDelegates.Find(ConnectionStatusDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ConnectionStatusChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetNATType(FFrame&, void* const)
native function OnlineSubsystem.ENATType GetNATType();

// Export Uonlinesubsystemlive::execGetLocale(FFrame&, void* const)
native function int GetLocale();

delegate OnStorageDeviceChange()
{
	//return;	
}

function AddStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
	// End:0x36
	if(StorageDeviceChangeDelegates.Find(StorageDeviceChangeDelegate) == -1)
	{
		StorageDeviceChangeDelegates.AddItem(StorageDeviceChangeDelegate);
	}
	//return;	
}

function ClearStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
	local int RemoveIndex;

	RemoveIndex = StorageDeviceChangeDelegates.Find(StorageDeviceChangeDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		StorageDeviceChangeDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

delegate OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
	//return;	
}

// Export Uonlinesubsystemlive::execReadTitleFile(FFrame&, void* const)
native function bool ReadTitleFile(string FileToRead);

function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
	// End:0x36
	if(ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate) == -1)
	{
		ReadTitleFileCompleteDelegates.AddItem(ReadTitleFileCompleteDelegate);
	}
	//return;	
}

function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ReadTitleFileCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetTitleFileContents(FFrame&, void* const)
native function bool GetTitleFileContents(string Filename, out array<byte> FileContents);

function OnlineSubsystem.EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
	local int FileIndex;

	FileIndex = TitleManagedFiles.Find('Filename', Filename);
	// End:0x63
	if(FileIndex != -1)
	{
		return TitleManagedFiles[FileIndex].AsyncState;
	}
	return 3;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execClearDownloadedFiles(FFrame&, void* const)
native function bool ClearDownloadedFiles();

// Export Uonlinesubsystemlive::execClearDownloadedFile(FFrame&, void* const)
native function bool ClearDownloadedFile(string Filename);

delegate OnFindOnlineGamesComplete(bool bWasSuccessful)
{
	//return;	
}

function OnlineGameSearch GetGameSearch()
{
	return GameSearch;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execCreateOnlineGame(FFrame&, void* const)
native function bool CreateOnlineGame(byte HostingPlayerNum, name SessionName, OnlineGameSettings NewGameSettings);

delegate OnCreateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
	// End:0x36
	if(CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate) == -1)
	{
		CreateOnlineGameCompleteDelegates.AddItem(CreateOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		CreateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execUpdateOnlineGame(FFrame&, void* const)
native function bool UpdateOnlineGame(name SessionName, OnlineGameSettings UpdatedGameSettings, optional bool bShouldRefreshOnlineData = false);

delegate OnUpdateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
	// End:0x36
	if(UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate) == -1)
	{
		UpdateOnlineGameCompleteDelegates.AddItem(UpdateOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		UpdateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function OnlineGameSettings GetGameSettings(name SessionName)
{
	local int SessionIndex;

	SessionIndex = Sessions.Find('SessionName', SessionName);
	// End:0x63
	if(SessionIndex != -1)
	{
		return Sessions[SessionIndex].GameSettings;
	}
	return none;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execDestroyOnlineGame(FFrame&, void* const)
native function bool DestroyOnlineGame(name SessionName);

delegate OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
	// End:0x36
	if(DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate) == -1)
	{
		DestroyOnlineGameCompleteDelegates.AddItem(DestroyOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		DestroyOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execFindOnlineGames(FFrame&, void* const)
native function bool FindOnlineGames(byte SearchingPlayerNum, OnlineGameSearch SearchSettings);

function AddFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
	// End:0x36
	if(FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate) == -1)
	{
		FindOnlineGamesCompleteDelegates.AddItem(FindOnlineGamesCompleteDelegate);
	}
	//return;	
}

function ClearFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		FindOnlineGamesCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execCancelFindOnlineGames(FFrame&, void* const)
native function bool CancelFindOnlineGames();

delegate OnCancelFindOnlineGamesComplete(bool bWasSuccessful)
{
	//return;	
}

function AddCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
	// End:0x36
	if(CancelFindOnlineGamesCompleteDelegates.Find(CancelFindOnlineGamesCompleteDelegate) == -1)
	{
		CancelFindOnlineGamesCompleteDelegates.AddItem(CancelFindOnlineGamesCompleteDelegate);
	}
	//return;	
}

function ClearCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = CancelFindOnlineGamesCompleteDelegates.Find(CancelFindOnlineGamesCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		CancelFindOnlineGamesCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

delegate OnQosStatusChanged(int NumComplete, int NumTotal)
{
	//return;	
}

function AddQosStatusChangedDelegate(delegate<OnQosStatusChanged> QosStatusChangedDelegate)
{
	// End:0x36
	if(QosStatusChangedDelegates.Find(QosStatusChangedDelegate) == -1)
	{
		QosStatusChangedDelegates.AddItem(QosStatusChangedDelegate);
	}
	//return;	
}

function ClearQosStatusChangedDelegate(delegate<OnQosStatusChanged> QosStatusChangedDelegate)
{
	local int RemoveIndex;

	RemoveIndex = QosStatusChangedDelegates.Find(QosStatusChangedDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		QosStatusChangedDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadPlatformSpecificSessionInfo(FFrame&, void* const)
native function bool ReadPlatformSpecificSessionInfo(const out OnlineGameSearchResult DesiredGame, out byte PlatformSpecificInfo[80]);

// Export Uonlinesubsystemlive::execReadPlatformSpecificSessionInfoBySessionName(FFrame&, void* const)
native function bool ReadPlatformSpecificSessionInfoBySessionName(name SessionName, out byte PlatformSpecificInfo[80]);

// Export Uonlinesubsystemlive::execBindPlatformSpecificSessionToSearch(FFrame&, void* const)
native function bool BindPlatformSpecificSessionToSearch(byte SearchingPlayerNum, OnlineGameSearch SearchSettings, byte PlatformSpecificInfo[80]);

// Export Uonlinesubsystemlive::execFreeSearchResults(FFrame&, void* const)
native function bool FreeSearchResults(optional OnlineGameSearch Search);

function bool QueryNonAdvertisedData(int StartAt, int NumberToQuery)
{
	LogInternal("Ignored on Live");
	return false;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execJoinOnlineGame(FFrame&, void* const)
native function bool JoinOnlineGame(byte PlayerNum, name SessionName, const out OnlineGameSearchResult DesiredGame);

delegate OnJoinOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
	// End:0x36
	if(JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate) == -1)
	{
		JoinOnlineGameCompleteDelegates.AddItem(JoinOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		JoinOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetResolvedConnectString(FFrame&, void* const)
native function bool GetResolvedConnectString(name SessionName, out string ConnectInfo);

// Export Uonlinesubsystemlive::execRegisterPlayer(FFrame&, void* const)
native function bool RegisterPlayer(name SessionName, UniqueNetId PlayerID, bool bWasInvited);

// Export Uonlinesubsystemlive::execRegisterPlayers(FFrame&, void* const)
native function bool RegisterPlayers(name SessionName, const out array<UniqueNetId> Players);

delegate OnRegisterPlayerComplete(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
	//return;	
}

function AddRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate)
{
	// End:0x36
	if(RegisterPlayerCompleteDelegates.Find(RegisterPlayerCompleteDelegate) == -1)
	{
		RegisterPlayerCompleteDelegates.AddItem(RegisterPlayerCompleteDelegate);
	}
	//return;	
}

function ClearRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = RegisterPlayerCompleteDelegates.Find(RegisterPlayerCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		RegisterPlayerCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execUnregisterPlayer(FFrame&, void* const)
native function bool UnregisterPlayer(name SessionName, UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execUnregisterPlayers(FFrame&, void* const)
native function bool UnregisterPlayers(name SessionName, const out array<UniqueNetId> Players);

delegate OnUnregisterPlayerComplete(name SessionName, UniqueNetId PlayerID, bool bWasSuccessful)
{
	//return;	
}

function AddUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate)
{
	// End:0x36
	if(UnregisterPlayerCompleteDelegates.Find(UnregisterPlayerCompleteDelegate) == -1)
	{
		UnregisterPlayerCompleteDelegates.AddItem(UnregisterPlayerCompleteDelegate);
	}
	//return;	
}

function ClearUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = UnregisterPlayerCompleteDelegates.Find(UnregisterPlayerCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		UnregisterPlayerCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execRecalculateSkillRating(FFrame&, void* const)
native function bool RecalculateSkillRating(name SessionName, const out array<UniqueNetId> Players);

delegate OnRecalculateSkillRatingComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddRecalculateSkillRatingCompleteDelegate(delegate<OnUpdateOnlineGameComplete> RecalculateSkillRatingCompleteDelegate)
{
	// End:0x36
	if(RecalculateSkillRatingCompleteDelegates.Find(RecalculateSkillRatingCompleteDelegate) == -1)
	{
		RecalculateSkillRatingCompleteDelegates.AddItem(RecalculateSkillRatingCompleteDelegate);
	}
	//return;	
}

function ClearRecalculateSkillRatingCompleteDelegate(delegate<OnUpdateOnlineGameComplete> RecalculateSkillRatingCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = RecalculateSkillRatingCompleteDelegates.Find(RecalculateSkillRatingCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		RecalculateSkillRatingCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execMigrateOnlineGame(FFrame&, void* const)
native function bool MigrateOnlineGame(byte HostingPlayerNum, name SessionName);

delegate OnMigrateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddMigrateOnlineGameCompleteDelegate(delegate<OnMigrateOnlineGameComplete> MigrateOnlineGameCompleteDelegate)
{
	// End:0x36
	if(MigrateOnlineGameCompleteDelegates.Find(MigrateOnlineGameCompleteDelegate) == -1)
	{
		MigrateOnlineGameCompleteDelegates.AddItem(MigrateOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearMigrateOnlineGameCompleteDelegate(delegate<OnMigrateOnlineGameComplete> MigrateOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = MigrateOnlineGameCompleteDelegates.Find(MigrateOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		MigrateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execJoinMigratedOnlineGame(FFrame&, void* const)
native function bool JoinMigratedOnlineGame(byte PlayerNum, name SessionName, const out OnlineGameSearchResult DesiredGame);

delegate OnJoinMigratedOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddJoinMigratedOnlineGameCompleteDelegate(delegate<OnJoinMigratedOnlineGameComplete> JoinMigratedOnlineGameCompleteDelegate)
{
	// End:0x36
	if(JoinMigratedOnlineGameCompleteDelegates.Find(JoinMigratedOnlineGameCompleteDelegate) == -1)
	{
		JoinMigratedOnlineGameCompleteDelegates.AddItem(JoinMigratedOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearJoinMigratedOnlineGameCompleteDelegate(delegate<OnJoinMigratedOnlineGameComplete> JoinMigratedOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = JoinMigratedOnlineGameCompleteDelegates.Find(JoinMigratedOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		JoinMigratedOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadProfileSettings(FFrame&, void* const)
native function bool ReadProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings);

delegate OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
	//return;	
}

function AddReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ProfileCache[int(LocalUserNum)].ReadDelegates.Find(ReadProfileSettingsCompleteDelegate) == -1)
		{
			ProfileCache[int(LocalUserNum)].ReadDelegates.AddItem(ReadProfileSettingsCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to SetReadProfileSettingsCompleteDelegate()");
	}
	//return;	
}

function ClearReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ProfileCache[int(LocalUserNum)].ReadDelegates.Find(ReadProfileSettingsCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ProfileCache[int(LocalUserNum)].ReadDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadProfileSettingsCompleteDelegate()");
	}
	//return;	
}

function OnlineProfileSettings GetProfileSettings(byte LocalUserNum)
{
	// End:0x53
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		return ProfileCache[int(LocalUserNum)].Profile;
	}
	return none;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execWriteProfileSettings(FFrame&, void* const)
native function bool WriteProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings);

delegate OnWriteProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
	//return;	
}

function AddWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ProfileCache[int(LocalUserNum)].WriteDelegates.Find(WriteProfileSettingsCompleteDelegate) == -1)
		{
			ProfileCache[int(LocalUserNum)].WriteDelegates.AddItem(WriteProfileSettingsCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddWriteProfileSettingsCompleteDelegate()");
	}
	//return;	
}

function ClearWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ProfileCache[int(LocalUserNum)].WriteDelegates.Find(WriteProfileSettingsCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ProfileCache[int(LocalUserNum)].WriteDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearWriteProfileSettingsCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadPlayerStorage(FFrame&, void* const)
native function bool ReadPlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage, optional int DeviceID = -1);

delegate OnReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
	//return;	
}

function AddReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PlayerStorageCacheLocal[int(LocalUserNum)].ReadDelegates.Find(ReadPlayerStorageCompleteDelegate) == -1)
		{
			PlayerStorageCacheLocal[int(LocalUserNum)].ReadDelegates.AddItem(ReadPlayerStorageCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadPlayerStorageCompleteDelegate()");
	}
	//return;	
}

function ClearReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PlayerStorageCacheLocal[int(LocalUserNum)].ReadDelegates.Find(ReadPlayerStorageCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PlayerStorageCacheLocal[int(LocalUserNum)].ReadDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadPlayerStorageCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadPlayerStorageForNetId(FFrame&, void* const)
native function bool ReadPlayerStorageForNetId(byte LocalUserNum, UniqueNetId NetId, OnlinePlayerStorage PlayerStorage);

delegate OnReadPlayerStorageForNetIdComplete(UniqueNetId NetId, bool bWasSuccessful)
{
	//return;	
}

// Export Uonlinesubsystemlive::execAddReadPlayerStorageForNetIdCompleteDelegate(FFrame&, void* const)
native function AddReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate);

// Export Uonlinesubsystemlive::execClearReadPlayerStorageForNetIdCompleteDelegate(FFrame&, void* const)
native function ClearReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate);

function OnlinePlayerStorage GetPlayerStorage(byte LocalUserNum)
{
	// End:0x56
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		return PlayerStorageCacheLocal[int(LocalUserNum)].PlayerStorage;		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to GetPlayerStorage()");
	}
	return none;
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execWritePlayerStorage(FFrame&, void* const)
native function bool WritePlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage, optional int DeviceID = -1);

delegate OnWritePlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
	//return;	
}

function AddWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PlayerStorageCacheLocal[int(LocalUserNum)].WriteDelegates.Find(WritePlayerStorageCompleteDelegate) == -1)
		{
			PlayerStorageCacheLocal[int(LocalUserNum)].WriteDelegates.AddItem(WritePlayerStorageCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddWritePlayerStorageCompleteDelegate()");
	}
	//return;	
}

function ClearWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PlayerStorageCacheLocal[int(LocalUserNum)].WriteDelegates.Find(WritePlayerStorageCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PlayerStorageCacheLocal[int(LocalUserNum)].WriteDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearWritePlayerStorageCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execSetOnlineStatus(FFrame&, void* const)
native function SetOnlineStatus(byte LocalUserNum, int PresenceMode, const out array<LocalizedStringSetting> LocalizedStringSettings, const out array<SettingsProperty> Properties);

// Export Uonlinesubsystemlive::execShowInviteUI(FFrame&, void* const)
native function bool ShowInviteUI(byte LocalUserNum, optional string InviteText);

// Export Uonlinesubsystemlive::execShowContentMarketplaceUI(FFrame&, void* const)
native function bool ShowContentMarketplaceUI(byte LocalUserNum, optional int CategoryMask = -1, optional int OfferId);

// Export Uonlinesubsystemlive::execShowMembershipMarketplaceUI(FFrame&, void* const)
native function bool ShowMembershipMarketplaceUI(byte LocalUserNum);

// Export Uonlinesubsystemlive::execShowDeviceSelectionUI(FFrame&, void* const)
native function bool ShowDeviceSelectionUI(byte LocalUserNum, int SizeNeeded, optional bool bManageStorage);

delegate OnDeviceSelectionComplete(bool bWasSuccessful)
{
	//return;	
}

function AddDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate)
{
	local int AddIndex;

	// End:0x131
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x12E
		if(DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Find(DeviceDelegate) == -1)
		{
			AddIndex = DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Length;
			DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Length = DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Length + 1;
			DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates[AddIndex] = DeviceDelegate;
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to SetDeviceSelectionDoneDelegate()");
	}
	//return;	
}

function ClearDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Find(DeviceDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearDeviceSelectionDoneDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetDeviceSelectionResults(FFrame&, void* const)
native function int GetDeviceSelectionResults(byte LocalPlayerNum, out string DeviceName);

// Export Uonlinesubsystemlive::execIsDeviceValid(FFrame&, void* const)
native function bool IsDeviceValid(int DeviceID, optional int SizeNeeded);

// Export Uonlinesubsystemlive::execUnlockAchievement(FFrame&, void* const)
native function bool UnlockAchievement(byte LocalUserNum, int AchievementId, optional float PercentComplete = 100.0000000);

delegate OnUnlockAchievementComplete(bool bWasSuccessful)
{
	//return;	
}

function AddUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Find(UnlockAchievementCompleteDelegate) == -1)
		{
			PerUserDelegates[int(LocalUserNum)].AchievementDelegates.AddItem(UnlockAchievementCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddUnlockAchievementCompleteDelegate()");
	}
	//return;	
}

function ClearUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Find(UnlockAchievementCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearUnlockAchievementCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execUnlockGamerPicture(FFrame&, void* const)
native function bool UnlockGamerPicture(byte LocalUserNum, int PictureId);

delegate OnProfileDataChanged()
{
	//return;	
}

function AddProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ProfileCache[int(LocalUserNum)].ProfileDataChangedDelegates.Find(ProfileDataChangedDelegate) == -1)
		{
			ProfileCache[int(LocalUserNum)].ProfileDataChangedDelegates.AddItem(ProfileDataChangedDelegate);
		}		
	}
	else
	{
		LogInternal(("Invalid user id (" $ string(LocalUserNum)) $ ") specified for AddProfileDataChangedDelegate()");
	}
	//return;	
}

function ClearProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ProfileCache[int(LocalUserNum)].ProfileDataChangedDelegates.Find(ProfileDataChangedDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ProfileCache[int(LocalUserNum)].ProfileDataChangedDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		LogInternal(("Invalid user id (" $ string(LocalUserNum)) $ ") specified for ClearProfileDataChangedDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execStartOnlineGame(FFrame&, void* const)
native function bool StartOnlineGame(name SessionName);

delegate OnStartOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
	// End:0x36
	if(StartOnlineGameCompleteDelegates.Find(StartOnlineGameCompleteDelegate) == -1)
	{
		StartOnlineGameCompleteDelegates.AddItem(StartOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = StartOnlineGameCompleteDelegates.Find(StartOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		StartOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execEndOnlineGame(FFrame&, void* const)
native function bool EndOnlineGame(name SessionName);

delegate OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
	// End:0x36
	if(EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate) == -1)
	{
		EndOnlineGameCompleteDelegates.AddItem(EndOnlineGameCompleteDelegate);
	}
	//return;	
}

function ClearEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		EndOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execRegisterForArbitration(FFrame&, void* const)
native function bool RegisterForArbitration(name SessionName);

delegate OnArbitrationRegistrationComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate)
{
	// End:0x36
	if(ArbitrationRegistrationCompleteDelegates.Find(ArbitrationRegistrationCompleteDelegate) == -1)
	{
		ArbitrationRegistrationCompleteDelegates.AddItem(ArbitrationRegistrationCompleteDelegate);
	}
	//return;	
}

function ClearArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ArbitrationRegistrationCompleteDelegates.Find(ArbitrationRegistrationCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ArbitrationRegistrationCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function array<OnlineArbitrationRegistrant> GetArbitratedPlayers(name SessionName)
{
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execAcceptGameInvite(FFrame&, void* const)
native function bool AcceptGameInvite(byte LocalUserNum, name SessionName);

// Export Uonlinesubsystemlive::execReadFriendsList(FFrame&, void* const)
native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

delegate OnReadFriendsComplete(bool bWasSuccessful)
{
	//return;	
}

function AddReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(FriendsCache[int(LocalUserNum)].ReadFriendsDelegates.Find(ReadFriendsCompleteDelegate) == -1)
		{
			FriendsCache[int(LocalUserNum)].ReadFriendsDelegates.AddItem(ReadFriendsCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadFriendsCompleteDelegate()");
	}
	//return;	
}

function ClearReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = FriendsCache[int(LocalUserNum)].ReadFriendsDelegates.Find(ReadFriendsCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			FriendsCache[int(LocalUserNum)].ReadFriendsDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadFriendsCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetFriendsList(FFrame&, void* const)
native function OnlineSubsystem.EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt);

delegate OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
	//return;	
}

function AddGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(InviteCache[int(LocalUserNum)].InviteDelegates.Find(GameInviteAcceptedDelegate) == -1)
		{
			InviteCache[int(LocalUserNum)].InviteDelegates.AddItem(GameInviteAcceptedDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddGameInviteAcceptedDelegate()");
	}
	//return;	
}

function ClearGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = InviteCache[int(LocalUserNum)].InviteDelegates.Find(GameInviteAcceptedDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			InviteCache[int(LocalUserNum)].InviteDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearGameInviteAcceptedDelegate()");
	}
	//return;	
}

delegate OnContentChange()
{
	//return;	
}

function AddContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255)
{
	// End:0x53
	if(int(LocalUserNum) == int(255))
	{
		// End:0x50
		if(AnyContentChangeDelegates.Find(ContentDelegate) == -1)
		{
			AnyContentChangeDelegates.AddItem(ContentDelegate);
		}		
	}
	else
	{
		// End:0xF4
		if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
		{
			// End:0xF1
			if(ContentCache[int(LocalUserNum)].ContentChangeDelegates.Find(ContentDelegate) == -1)
			{
				ContentCache[int(LocalUserNum)].ContentChangeDelegates.AddItem(ContentDelegate);
			}			
		}
		else
		{
			WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddContentChangeDelegate()");
		}
	}
	//return;	
}

function ClearContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255)
{
	local int RemoveIndex;

	// End:0x65
	if(int(LocalUserNum) == int(255))
	{
		RemoveIndex = AnyContentChangeDelegates.Find(ContentDelegate);
		// End:0x62
		if(RemoveIndex != -1)
		{
			AnyContentChangeDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		// End:0x118
		if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
		{
			RemoveIndex = ContentCache[int(LocalUserNum)].ContentChangeDelegates.Find(ContentDelegate);
			// End:0x115
			if(RemoveIndex != -1)
			{
				ContentCache[int(LocalUserNum)].ContentChangeDelegates.Remove(RemoveIndex, 1);
			}			
		}
		else
		{
			WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearContentChangeDelegate()");
		}
	}
	//return;	
}

delegate OnReadContentComplete(bool bWasSuccessful)
{
	//return;	
}

function AddReadContentComplete(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadContentComplete> ReadContentCompleteDelegate)
{
	// End:0x12C
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0xB5
		if(int(ContentType) == int(0))
		{
			// End:0xB2
			if(ContentCache[int(LocalUserNum)].ReadCompleteDelegates.Find(ReadContentCompleteDelegate) == -1)
			{
				ContentCache[int(LocalUserNum)].ReadCompleteDelegates.AddItem(ReadContentCompleteDelegate);
			}			
		}
		else
		{
			// End:0x129
			if(ContentCache[int(LocalUserNum)].SaveGameReadCompleteDelegates.Find(ReadContentCompleteDelegate) == -1)
			{
				ContentCache[int(LocalUserNum)].SaveGameReadCompleteDelegates.AddItem(ReadContentCompleteDelegate);
			}
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadContentComplete()");
	}
	//return;	
}

function ClearReadContentComplete(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadContentComplete> ReadContentCompleteDelegate)
{
	local int RemoveIndex;

	// End:0x150
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0xC7
		if(int(ContentType) == int(0))
		{
			RemoveIndex = ContentCache[int(LocalUserNum)].ReadCompleteDelegates.Find(ReadContentCompleteDelegate);
			// End:0xC4
			if(RemoveIndex != -1)
			{
				ContentCache[int(LocalUserNum)].ReadCompleteDelegates.Remove(RemoveIndex, 1);
			}			
		}
		else
		{
			RemoveIndex = ContentCache[int(LocalUserNum)].SaveGameReadCompleteDelegates.Find(ReadContentCompleteDelegate);
			// End:0x14D
			if(RemoveIndex != -1)
			{
				ContentCache[int(LocalUserNum)].SaveGameReadCompleteDelegates.Remove(RemoveIndex, 1);
			}
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadContentComplete()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadContentList(FFrame&, void* const)
native function bool ReadContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, optional int DeviceID = -1);

// Export Uonlinesubsystemlive::execClearContentList(FFrame&, void* const)
native function ClearContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType);

// Export Uonlinesubsystemlive::execGetContentList(FFrame&, void* const)
native function OnlineSubsystem.EOnlineEnumerationReadState GetContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, out array<OnlineContent> ContentList);

// Export Uonlinesubsystemlive::execReadCrossTitleContentList(FFrame&, void* const)
native function bool ReadCrossTitleContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, optional int TitleId = 0, optional int DeviceID = -1);

// Export Uonlinesubsystemlive::execClearCrossTitleContentList(FFrame&, void* const)
native function ClearCrossTitleContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType);

// Export Uonlinesubsystemlive::execGetCrossTitleContentList(FFrame&, void* const)
native function OnlineSubsystem.EOnlineEnumerationReadState GetCrossTitleContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, out array<OnlineCrossTitleContent> ContentList);

delegate OnReadCrossTitleContentComplete(bool bWasSuccessful)
{
	//return;	
}

function AddReadCrossTitleContentCompleteDelegate(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadCrossTitleContentComplete> ReadCrossTitleContentCompleteDelegate)
{
	// End:0x12C
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0xB5
		if(int(ContentType) == int(0))
		{
			// End:0xB2
			if(ContentCache[int(LocalUserNum)].ReadCrossTitleCompleteDelegates.Find(ReadCrossTitleContentCompleteDelegate) == -1)
			{
				ContentCache[int(LocalUserNum)].ReadCrossTitleCompleteDelegates.AddItem(ReadCrossTitleContentCompleteDelegate);
			}			
		}
		else
		{
			// End:0x129
			if(ContentCache[int(LocalUserNum)].SaveGameReadCrossTitleCompleteDelegates.Find(ReadCrossTitleContentCompleteDelegate) == -1)
			{
				ContentCache[int(LocalUserNum)].SaveGameReadCrossTitleCompleteDelegates.AddItem(ReadCrossTitleContentCompleteDelegate);
			}
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadCrossTitleContentComplete()");
	}
	//return;	
}

function ClearReadCrossTitleContentCompleteDelegate(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadCrossTitleContentComplete> ReadCrossTitleContentCompleteDelegate)
{
	local int RemoveIndex;

	// End:0x150
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0xC7
		if(int(ContentType) == int(0))
		{
			RemoveIndex = ContentCache[int(LocalUserNum)].ReadCrossTitleCompleteDelegates.Find(ReadCrossTitleContentCompleteDelegate);
			// End:0xC4
			if(RemoveIndex != -1)
			{
				ContentCache[int(LocalUserNum)].ReadCrossTitleCompleteDelegates.Remove(RemoveIndex, 1);
			}			
		}
		else
		{
			RemoveIndex = ContentCache[int(LocalUserNum)].SaveGameReadCrossTitleCompleteDelegates.Find(ReadCrossTitleContentCompleteDelegate);
			// End:0x14D
			if(RemoveIndex != -1)
			{
				ContentCache[int(LocalUserNum)].SaveGameReadCrossTitleCompleteDelegates.Remove(RemoveIndex, 1);
			}
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadCrossTitleContentComplete()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadCrossTitleSaveGameData(FFrame&, void* const)
native function bool ReadCrossTitleSaveGameData(byte LocalUserNum, int DeviceID, int TitleId, string FriendlyName, string Filename, string SaveFileName);

// Export Uonlinesubsystemlive::execGetCrossTitleSaveGameData(FFrame&, void* const)
native function bool GetCrossTitleSaveGameData(byte LocalUserNum, int DeviceID, int TitleId, string FriendlyName, string Filename, string SaveFileName, out byte bIsValid, out array<byte> SaveGameData);

delegate OnReadCrossTitleSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, int TitleId, string FriendlyName, string Filename, string SaveFileName)
{
	//return;	
}

function AddReadCrossTitleSaveGameDataComplete(byte LocalUserNum, delegate<OnReadCrossTitleSaveGameDataComplete> ReadCrossTitleSaveGameDataCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ContentCache[int(LocalUserNum)].ReadCrossTitleSaveGameDataCompleteDelegates.Find(ReadCrossTitleSaveGameDataCompleteDelegate) == -1)
		{
			ContentCache[int(LocalUserNum)].ReadCrossTitleSaveGameDataCompleteDelegates.AddItem(ReadCrossTitleSaveGameDataCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadCrossTitleSaveGameDataComplete()");
	}
	//return;	
}

function ClearReadCrossTitleSaveGameDataComplete(byte LocalUserNum, delegate<OnReadCrossTitleSaveGameDataComplete> ReadCrossTitleSaveGameDataCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ContentCache[int(LocalUserNum)].ReadCrossTitleSaveGameDataCompleteDelegates.Find(ReadCrossTitleSaveGameDataCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ContentCache[int(LocalUserNum)].ReadCrossTitleSaveGameDataCompleteDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadCrossTitleContentComplete()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execClearCrossTitleSaveGames(FFrame&, void* const)
native function bool ClearCrossTitleSaveGames(byte LocalUserNum);

// Export Uonlinesubsystemlive::execQueryAvailableDownloads(FFrame&, void* const)
native function bool QueryAvailableDownloads(byte LocalUserNum, optional int CategoryMask = -1);

delegate OnQueryAvailableDownloadsComplete(bool bWasSuccessful)
{
	//return;	
}

function AddQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ContentCache[int(LocalUserNum)].QueryDownloadsDelegates.Find(QueryDownloadsDelegate) == -1)
		{
			ContentCache[int(LocalUserNum)].QueryDownloadsDelegates.AddItem(QueryDownloadsDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddQueryAvailableDownloadsComplete()");
	}
	//return;	
}

function ClearQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ContentCache[int(LocalUserNum)].QueryDownloadsDelegates.Find(QueryDownloadsDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ContentCache[int(LocalUserNum)].QueryDownloadsDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearQueryAvailableDownloadsComplete()");
	}
	//return;	
}

function GetAvailableDownloadCounts(byte LocalUserNum, out int NewDownloads, out int TotalDownloads)
{
	// End:0x91
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		NewDownloads = ContentCache[int(LocalUserNum)].NewDownloadCount;
		TotalDownloads = ContentCache[int(LocalUserNum)].TotalDownloadCount;		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to GetAvailableDownloadCounts()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execReadSaveGameData(FFrame&, void* const)
native function bool ReadSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName);

// Export Uonlinesubsystemlive::execGetSaveGameData(FFrame&, void* const)
native function bool GetSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName, out byte bIsValid, out array<byte> SaveGameData);

delegate OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	//return;	
}

function AddReadSaveGameDataComplete(byte LocalUserNum, delegate<OnReadSaveGameDataComplete> ReadSaveGameDataCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ContentCache[int(LocalUserNum)].ReadSaveGameDataCompleteDelegates.Find(ReadSaveGameDataCompleteDelegate) == -1)
		{
			ContentCache[int(LocalUserNum)].ReadSaveGameDataCompleteDelegates.AddItem(ReadSaveGameDataCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadSaveGameDataComplete()");
	}
	//return;	
}

function ClearReadSaveGameDataComplete(byte LocalUserNum, delegate<OnReadSaveGameDataComplete> ReadSaveGameDataCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ContentCache[int(LocalUserNum)].ReadSaveGameDataCompleteDelegates.Find(ReadSaveGameDataCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ContentCache[int(LocalUserNum)].ReadSaveGameDataCompleteDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadSaveGameDataComplete()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execWriteSaveGameData(FFrame&, void* const)
native function bool WriteSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName, const out array<byte> SaveGameData);

delegate OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	//return;	
}

function AddWriteSaveGameDataComplete(byte LocalUserNum, delegate<OnWriteSaveGameDataComplete> WriteSaveGameDataCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ContentCache[int(LocalUserNum)].WriteSaveGameDataCompleteDelegates.Find(WriteSaveGameDataCompleteDelegate) == -1)
		{
			ContentCache[int(LocalUserNum)].WriteSaveGameDataCompleteDelegates.AddItem(WriteSaveGameDataCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddWriteSaveGameDataComplete()");
	}
	//return;	
}

function ClearWriteSaveGameDataComplete(byte LocalUserNum, delegate<OnWriteSaveGameDataComplete> WriteSaveGameDataCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ContentCache[int(LocalUserNum)].WriteSaveGameDataCompleteDelegates.Find(WriteSaveGameDataCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ContentCache[int(LocalUserNum)].WriteSaveGameDataCompleteDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearWriteSaveGameDataComplete()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execDeleteSaveGame(FFrame&, void* const)
native function bool DeleteSaveGame(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename);

// Export Uonlinesubsystemlive::execSaveGameExists(FFrame&, void* const)
native function bool SaveGameExists(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename);

// Export Uonlinesubsystemlive::execClearSaveGames(FFrame&, void* const)
native function bool ClearSaveGames(byte LocalUserNum);

// Export Uonlinesubsystemlive::execRegisterLocalTalker(FFrame&, void* const)
native function bool RegisterLocalTalker(byte LocalUserNum);

// Export Uonlinesubsystemlive::execUnregisterLocalTalker(FFrame&, void* const)
native function bool UnregisterLocalTalker(byte LocalUserNum);

// Export Uonlinesubsystemlive::execRegisterRemoteTalker(FFrame&, void* const)
native function bool RegisterRemoteTalker(UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execUnregisterRemoteTalker(FFrame&, void* const)
native function bool UnregisterRemoteTalker(UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execIsLocalPlayerTalking(FFrame&, void* const)
native function bool IsLocalPlayerTalking(byte LocalUserNum);

// Export Uonlinesubsystemlive::execIsRemotePlayerTalking(FFrame&, void* const)
native function bool IsRemotePlayerTalking(UniqueNetId PlayerID);

// Export Uonlinesubsystemlive::execIsHeadsetPresent(FFrame&, void* const)
native function bool IsHeadsetPresent(byte LocalUserNum);

// Export Uonlinesubsystemlive::execSetRemoteTalkerPriority(FFrame&, void* const)
native function bool SetRemoteTalkerPriority(byte LocalUserNum, UniqueNetId PlayerID, int Priority);

// Export Uonlinesubsystemlive::execMuteRemoteTalker(FFrame&, void* const)
native function bool MuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID, optional bool bIsSystemWide);

// Export Uonlinesubsystemlive::execUnmuteRemoteTalker(FFrame&, void* const)
native function bool UnmuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID, optional bool bIsSystemWide);

delegate OnPlayerTalkingStateChange(UniqueNetId Player, bool bIsTalking)
{
	//return;	
}

function AddPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
	local int AddIndex;

	// End:0x69
	if(TalkingDelegates.Find(TalkerDelegate) == -1)
	{
		AddIndex = TalkingDelegates.Length;
		TalkingDelegates.Length = TalkingDelegates.Length + 1;
		TalkingDelegates[AddIndex] = TalkerDelegate;
	}
	//return;	
}

function ClearPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
	local int RemoveIndex;

	RemoveIndex = TalkingDelegates.Find(TalkerDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		TalkingDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execStartNetworkedVoice(FFrame&, void* const)
native function StartNetworkedVoice(byte LocalUserNum);

// Export Uonlinesubsystemlive::execStopNetworkedVoice(FFrame&, void* const)
native function StopNetworkedVoice(byte LocalUserNum);

// Export Uonlinesubsystemlive::execStartSpeechRecognition(FFrame&, void* const)
native function bool StartSpeechRecognition(byte LocalUserNum);

// Export Uonlinesubsystemlive::execStopSpeechRecognition(FFrame&, void* const)
native function bool StopSpeechRecognition(byte LocalUserNum);

// Export Uonlinesubsystemlive::execGetRecognitionResults(FFrame&, void* const)
native function bool GetRecognitionResults(byte LocalUserNum, out array<SpeechRecognizedWord> Words);

delegate OnRecognitionComplete()
{
	//return;	
}

function AddRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PerUserDelegates[int(LocalUserNum)].SpeechRecognitionDelegates.Find(RecognitionDelegate) == -1)
		{
			PerUserDelegates[int(LocalUserNum)].SpeechRecognitionDelegates.AddItem(RecognitionDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddRecognitionCompleteDelegate()");
	}
	//return;	
}

function ClearRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PerUserDelegates[int(LocalUserNum)].SpeechRecognitionDelegates.Find(RecognitionDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PerUserDelegates[int(LocalUserNum)].SpeechRecognitionDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearRecognitionCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execSelectVocabulary(FFrame&, void* const)
native function bool SelectVocabulary(byte LocalUserNum, int VocabularyId);

// Export Uonlinesubsystemlive::execSetSpeechRecognitionObject(FFrame&, void* const)
native function bool SetSpeechRecognitionObject(byte LocalUserNum, SpeechRecognition SpeechRecogObj);

// Export Uonlinesubsystemlive::execReadOnlineStats(FFrame&, void* const)
native function bool ReadOnlineStats(const out array<UniqueNetId> Players, OnlineStatsRead StatsRead);

// Export Uonlinesubsystemlive::execReadOnlineStatsForFriends(FFrame&, void* const)
native function bool ReadOnlineStatsForFriends(byte LocalUserNum, OnlineStatsRead StatsRead);

// Export Uonlinesubsystemlive::execReadOnlineStatsByRank(FFrame&, void* const)
native function bool ReadOnlineStatsByRank(OnlineStatsRead StatsRead, optional int StartIndex = 1, optional int NumToRead = 100);

// Export Uonlinesubsystemlive::execReadOnlineStatsByRankAroundPlayer(FFrame&, void* const)
native function bool ReadOnlineStatsByRankAroundPlayer(byte LocalUserNum, OnlineStatsRead StatsRead, optional int NumRows = 10);

delegate OnReadOnlineStatsComplete(bool bWasSuccessful)
{
	//return;	
}

function AddReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate)
{
	local int AddIndex;

	__OnReadOnlineStatsComplete__Delegate = MulticastReadOnlineStatsComplete;
	// End:0x84
	if(ReadOnlineStatsCompleteDelegates.Find(ReadOnlineStatsCompleteDelegate) == -1)
	{
		AddIndex = ReadOnlineStatsCompleteDelegates.Length;
		ReadOnlineStatsCompleteDelegates.Length = ReadOnlineStatsCompleteDelegates.Length + 1;
		ReadOnlineStatsCompleteDelegates[AddIndex] = ReadOnlineStatsCompleteDelegate;
	}
	//return;	
}

function ClearReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ReadOnlineStatsCompleteDelegates.Find(ReadOnlineStatsCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ReadOnlineStatsCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function MulticastReadOnlineStatsComplete(bool bWasSuccessful)
{
	local int Index;
	local delegate<OnReadOnlineStatsComplete> Subscriber;

	Index = 0;
	J0x0B:

	// End:0x6B [Loop If]
	if(Index < ReadOnlineStatsCompleteDelegates.Length)
	{
		Subscriber = ReadOnlineStatsCompleteDelegates[Index];
		OnReadOnlineStatsComplete(bWasSuccessful);
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

// Export Uonlinesubsystemlive::execFreeStats(FFrame&, void* const)
native function FreeStats(OnlineStatsRead StatsRead);

// Export Uonlinesubsystemlive::execWriteOnlineStats(FFrame&, void* const)
native function bool WriteOnlineStats(name SessionName, UniqueNetId Player, OnlineStatsWrite StatsWrite);

// Export Uonlinesubsystemlive::execFlushOnlineStats(FFrame&, void* const)
native function bool FlushOnlineStats(name SessionName);

delegate OnFlushOnlineStatsComplete(name SessionName, bool bWasSuccessful)
{
	//return;	
}

function AddFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
	// End:0x36
	if(FlushOnlineStatsDelegates.Find(FlushOnlineStatsCompleteDelegate) == -1)
	{
		FlushOnlineStatsDelegates.AddItem(FlushOnlineStatsCompleteDelegate);
	}
	//return;	
}

function ClearFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = FlushOnlineStatsDelegates.Find(FlushOnlineStatsCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		FlushOnlineStatsDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execWriteOnlinePlayerScores(FFrame&, void* const)
native function bool WriteOnlinePlayerScores(name SessionName, int LeaderboardId, const out array<OnlinePlayerScore> PlayerScores);

function bool AddFriend(byte LocalUserNum, UniqueNetId NewFriend, optional string Message)
{
	return ShowFriendsInviteUI(LocalUserNum, NewFriend);
	//return ReturnValue;	
}

function bool AddFriendByName(byte LocalUserNum, string FriendName, optional string Message)
{
	//return ReturnValue;	
}

delegate OnAddFriendByNameComplete(bool bWasSuccessful)
{
	//return;	
}

function AddAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate)
{
	//return;	
}

function ClearAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate)
{
	//return;	
}

function bool AcceptFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer)
{
	//return ReturnValue;	
}

function bool DenyFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer)
{
	//return ReturnValue;	
}

function bool RemoveFriend(byte LocalUserNum, UniqueNetId FormerFriend)
{
	return ShowGamerCardUI(LocalUserNum, FormerFriend);
	//return ReturnValue;	
}

delegate OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
	//return;	
}

function AddFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate)
{
	//return;	
}

function ClearFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate)
{
	//return;	
}

// Export Uonlinesubsystemlive::execSendMessageToFriend(FFrame&, void* const)
native function bool SendMessageToFriend(byte LocalUserNum, UniqueNetId Friend, string Message);

// Export Uonlinesubsystemlive::execSendGameInviteToFriend(FFrame&, void* const)
native function bool SendGameInviteToFriend(byte LocalUserNum, UniqueNetId Friend, optional string Text);

// Export Uonlinesubsystemlive::execSendGameInviteToFriends(FFrame&, void* const)
native function bool SendGameInviteToFriends(byte LocalUserNum, array<UniqueNetId> Friends, optional string Text);

delegate OnReceivedGameInvite(byte LocalUserNum, string InviterName)
{
	//return;	
}

function AddReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate)
{
	//return;	
}

function ClearReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate)
{
	//return;	
}

// Export Uonlinesubsystemlive::execJoinFriendGame(FFrame&, void* const)
native function bool JoinFriendGame(byte LocalUserNum, UniqueNetId Friend);

delegate OnJoinFriendGameComplete(bool bWasSuccessful)
{
	//return;	
}

function AddJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate)
{
	// End:0x36
	if(JoinFriendGameCompleteDelegates.Find(JoinFriendGameCompleteDelegate) == -1)
	{
		JoinFriendGameCompleteDelegates.AddItem(JoinFriendGameCompleteDelegate);
	}
	//return;	
}

function ClearJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = JoinFriendGameCompleteDelegates.Find(JoinFriendGameCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		JoinFriendGameCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function GetFriendMessages(byte LocalUserNum, out array<OnlineFriendMessage> FriendMessages)
{
	//return;	
}

delegate OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
	//return;	
}

function AddFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate)
{
	//return;	
}

function ClearFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate)
{
	//return;	
}

function string GetHostStatGuid()
{
	//return ReturnValue;	
}

function bool RegisterHostStatGuid(const out string HostStatGuid)
{
	//return ReturnValue;	
}

delegate OnRegisterHostStatGuidComplete(bool bWasSuccessful)
{
	//return;	
}

function AddRegisterHostStatGuidCompleteDelegate(delegate<OnFlushOnlineStatsComplete> RegisterHostStatGuidCompleteDelegate)
{
	//return;	
}

function ClearRegisterHostStatGuidCompleteDelegateDelegate(delegate<OnFlushOnlineStatsComplete> RegisterHostStatGuidCompleteDelegate)
{
	//return;	
}

function string GetClientStatGuid()
{
	//return ReturnValue;	
}

function bool RegisterStatGuid(UniqueNetId PlayerID, const out string ClientStatGuid)
{
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execCalcAggregateSkill(FFrame&, void* const)
native function CalcAggregateSkill(array<Double> Mus, array<Double> Sigmas, out Double OutAggregateMu, out Double OutAggregateSigma);

function bool MuteAll(byte LocalUserNum, bool bAllowFriends)
{
	//return ReturnValue;	
}

function bool UnmuteAll(byte LocalUserNum)
{
	//return ReturnValue;	
}

function bool DeleteMessage(byte LocalUserNum, int MessageIndex)
{
	//return ReturnValue;	
}

// Export Uonlinesubsystemlive::execReadAchievements(FFrame&, void* const)
native function bool ReadAchievements(byte LocalUserNum, optional int TitleId = 0, optional bool bShouldReadText = true, optional bool bShouldReadImages = false);

delegate OnReadAchievementsComplete(int TitleId)
{
	//return;	
}

function AddReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.Find(ReadAchievementsCompleteDelegate) == -1)
		{
			PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.AddItem(ReadAchievementsCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadAchievementsComplete()");
	}
	//return;	
}

function ClearReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.Find(ReadAchievementsCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadAchievementsCompleteDelegate()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execGetAchievements(FFrame&, void* const)
native function OnlineSubsystem.EOnlineEnumerationReadState GetAchievements(byte LocalUserNum, out array<AchievementDetails> Achievements, optional int TitleId = 0);

// Export Uonlinesubsystemlive::execShowCustomPlayersUI(FFrame&, void* const)
native function bool ShowCustomPlayersUI(byte LocalUserNum, const out array<UniqueNetId> Players, string Title, string Description);

// Export Uonlinesubsystemlive::execUnlockAvatarAward(FFrame&, void* const)
native function bool UnlockAvatarAward(byte LocalUserNum, int AvatarItemId);

// Export Uonlinesubsystemlive::execReadCrossTitleProfileSettings(FFrame&, void* const)
native function bool ReadCrossTitleProfileSettings(byte LocalUserNum, int TitleId, OnlineProfileSettings ProfileSettings);

delegate OnReadCrossTitleProfileSettingsComplete(byte LocalUserNum, int TitleId, bool bWasSuccessful)
{
	//return;	
}

function AddReadCrossTitleProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadCrossTitleProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(ProfileCache[int(LocalUserNum)].CrossTitleReadDelegates.Find(ReadProfileSettingsCompleteDelegate) == -1)
		{
			ProfileCache[int(LocalUserNum)].CrossTitleReadDelegates.AddItem(ReadProfileSettingsCompleteDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddReadCrossTitleProfileSettingsCompleteDelegate()");
	}
	//return;	
}

function ClearReadCrossTitleProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadCrossTitleProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = ProfileCache[int(LocalUserNum)].CrossTitleReadDelegates.Find(ReadProfileSettingsCompleteDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			ProfileCache[int(LocalUserNum)].CrossTitleReadDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearReadCrossTitleProfileSettingsCompleteDelegate()");
	}
	//return;	
}

function OnlineProfileSettings GetCrossTitleProfileSettings(byte LocalUserNum, int TitleId)
{
	local int ProfileIndex;

	// End:0xCB
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		ProfileIndex = ProfileCache[int(LocalUserNum)].CrossTitleProfileCache.Find('TitleId', TitleId);
		// End:0xCB
		if(ProfileIndex != -1)
		{
			return ProfileCache[int(LocalUserNum)].CrossTitleProfileCache[ProfileIndex].Profile;
		}
	}
	return none;
	//return ReturnValue;	
}

function ClearCrossTitleProfileSettings(byte LocalUserNum, int TitleId)
{
	local int ProfileIndex;

	// End:0xB9
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		ProfileIndex = ProfileCache[int(LocalUserNum)].CrossTitleProfileCache.Find('TitleId', TitleId);
		// End:0xB9
		if(ProfileIndex != -1)
		{
			ProfileCache[int(LocalUserNum)].CrossTitleProfileCache.Remove(ProfileIndex, 1);
		}
	}
	//return;	
}

// Export Uonlinesubsystemlive::execQuerySocialPostPrivileges(FFrame&, void* const)
native function bool QuerySocialPostPrivileges();

delegate OnQuerySocialPostPrivilegesCompleted(bool bWasSuccessful, SocialPostPrivileges PostPrivileges)
{
	//return;	
}

function AddQuerySocialPostPrivilegesCompleted(delegate<OnQuerySocialPostPrivilegesCompleted> PostPrivilegesDelegate)
{
	// End:0x36
	if(QuerySocialPostPrivilegesDelegates.Find(PostPrivilegesDelegate) == -1)
	{
		QuerySocialPostPrivilegesDelegates.AddItem(PostPrivilegesDelegate);
	}
	//return;	
}

function ClearQuerySocialPostPrivilegesCompleted(delegate<OnQuerySocialPostPrivilegesCompleted> PostPrivilegesDelegate)
{
	local int RemoveIndex;

	RemoveIndex = QuerySocialPostPrivilegesDelegates.Find(PostPrivilegesDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		QuerySocialPostPrivilegesDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

// Export Uonlinesubsystemlive::execPostImage(FFrame&, void* const)
native function bool PostImage(byte LocalUserNum, const out SocialPostImageInfo PostImageInfo, const array<byte> FullImage);

delegate OnPostImageCompleted(byte LocalUserNum, bool bWasSuccessful)
{
	//return;	
}

function AddPostImageCompleted(byte LocalUserNum, delegate<OnPostImageCompleted> PostImageDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PerUserDelegates[int(LocalUserNum)].PostImageDelegates.Find(PostImageDelegate) == -1)
		{
			PerUserDelegates[int(LocalUserNum)].PostImageDelegates.AddItem(PostImageDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddPostImageCompleted()");
	}
	//return;	
}

function ClearPostImageCompleted(byte LocalUserNum, delegate<OnPostImageCompleted> PostImageDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PerUserDelegates[int(LocalUserNum)].PostImageDelegates.Find(PostImageDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PerUserDelegates[int(LocalUserNum)].PostImageDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearPostImageCompleted()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execPostLink(FFrame&, void* const)
native function bool PostLink(byte LocalUserNum, const out SocialPostLinkInfo PostLinkInfo);

delegate OnPostLinkCompleted(byte LocalUserNum, bool bWasSuccessful)
{
	//return;	
}

function AddPostLinkCompleted(byte LocalUserNum, delegate<OnPostLinkCompleted> PostLinkDelegate)
{
	// End:0xA1
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		// End:0x9E
		if(PerUserDelegates[int(LocalUserNum)].PostLinkDelegates.Find(PostLinkDelegate) == -1)
		{
			PerUserDelegates[int(LocalUserNum)].PostLinkDelegates.AddItem(PostLinkDelegate);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to AddPostLinkCompleted()");
	}
	//return;	
}

function ClearPostLinkCompleted(byte LocalUserNum, delegate<OnPostLinkCompleted> PostLinkDelegate)
{
	local int RemoveIndex;

	// End:0xB3
	if((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))
	{
		RemoveIndex = PerUserDelegates[int(LocalUserNum)].PostLinkDelegates.Find(PostLinkDelegate);
		// End:0xB0
		if(RemoveIndex != -1)
		{
			PerUserDelegates[int(LocalUserNum)].PostLinkDelegates.Remove(RemoveIndex, 1);
		}		
	}
	else
	{
		WarnInternal(("Invalid index (" $ string(LocalUserNum)) $ ") passed to ClearPostLinkCompleted()");
	}
	//return;	
}

// Export Uonlinesubsystemlive::execShowCustomMessageUI(FFrame&, void* const)
native function bool ShowCustomMessageUI(byte LocalUserNum, const out array<UniqueNetId> Recipients, string MessageTitle, string NonEditableMessage, optional string EditableMessage);

// Export Uonlinesubsystemlive::execGetBuildUniqueId(FFrame&, void* const)
native function int GetBuildUniqueId();

function RequestTitleFileList()
{
	//return;	
}

delegate OnRequestTitleFileListComplete(bool bWasSuccessful, string ResultStr)
{
	//return;	
}

function AddRequestTitleFileListCompleteDelegate(delegate<OnRequestTitleFileListComplete> RequestTitleFileListDelegate)
{
	//return;	
}

function ClearRequestTitleFileListCompleteDelegate(delegate<OnRequestTitleFileListComplete> RequestTitleFileListDelegate)
{
	//return;	
}

function DumpSessionState()
{
	super(OnlineSubsystem).DumpSessionState();
	DumpLiveSessionState();
	//return;	
}

// Export Uonlinesubsystemlive::execDumpLiveSessionState(FFrame&, void* const)
native function DumpLiveSessionState();

// Export Uonlinesubsystemlive::execDumpVoiceRegistration(FFrame&, void* const)
native function DumpVoiceRegistration();

// Export Uonlinesubsystemlive::execSetDebugSpewLevel(FFrame&, void* const)
native function SetDebugSpewLevel(int DebugSpewLevel);

defaultproperties
{
	LanAnnouncePort=14001
	SigninCountDownDelay=1.0000000
	VoiceNotificationDelta=0.2000000
}