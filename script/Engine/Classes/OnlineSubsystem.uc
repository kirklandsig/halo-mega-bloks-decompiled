class OnlineSubsystem extends Object
	abstract
	native
	config(Engine);

enum ELoginStatus
{
	LS_NotLoggedIn,                 // 0
	LS_UsingLocalProfile,           // 1
	LS_LoggedIn,                    // 2
	LS_MAX                          // 3
};

enum EFeaturePrivilegeLevel
{
	FPL_Disabled,                   // 0
	FPL_EnabledFriendsOnly,         // 1
	FPL_Enabled,                    // 2
	FPL_MAX                         // 3
};

enum ENetworkNotificationPosition
{
	NNP_TopLeft,                    // 0
	NNP_TopCenter,                  // 1
	NNP_TopRight,                   // 2
	NNP_CenterLeft,                 // 3
	NNP_Center,                     // 4
	NNP_CenterRight,                // 5
	NNP_BottomLeft,                 // 6
	NNP_BottomCenter,               // 7
	NNP_BottomRight,                // 8
	NNP_MAX                         // 9
};

enum EOnlineGameState
{
	OGS_NoSession,                  // 0
	OGS_Pending,                    // 1
	OGS_Starting,                   // 2
	OGS_InProgress,                 // 3
	OGS_Ending,                     // 4
	OGS_Ended,                      // 5
	OGS_MAX                         // 6
};

enum EOnlineEnumerationReadState
{
	OERS_NotStarted,                // 0
	OERS_InProgress,                // 1
	OERS_Done,                      // 2
	OERS_Failed,                    // 3
	OERS_MAX                        // 4
};

enum EOnlineFriendState
{
	OFS_Offline,                    // 0
	OFS_Online,                     // 1
	OFS_Away,                       // 2
	OFS_Busy,                       // 3
	OFS_MAX                         // 4
};

enum EOnlineContentType
{
	OCT_Downloaded,                 // 0
	OCT_SaveGame,                   // 1
	OCT_MAX                         // 2
};

enum EOnlineServerConnectionStatus
{
	OSCS_NotConnected,              // 0
	OSCS_Connected,                 // 1
	OSCS_ConnectionDropped,         // 2
	OSCS_NoNetworkConnection,       // 3
	OSCS_ServiceUnavailable,        // 4
	OSCS_UpdateRequired,            // 5
	OSCS_ServersTooBusy,            // 6
	OSCS_DuplicateLoginDetected,    // 7
	OSCS_InvalidUser,               // 8
	OSCS_MAX                        // 9
};

enum ENATType
{
	NAT_Unknown,                    // 0
	NAT_Open,                       // 1
	NAT_Moderate,                   // 2
	NAT_Strict,                     // 3
	NAT_MAX                         // 4
};

enum ELanBeaconState
{
	LANB_NotUsingLanBeacon,         // 0
	LANB_Hosting,                   // 1
	LANB_Searching,                 // 2
	LANB_MAX                        // 3
};

enum EOnlineAccountCreateStatus
{
	OACS_CreateSuccessful,          // 0
	OACS_UnknownError,              // 1
	OACS_InvalidUserName,           // 2
	OACS_InvalidPassword,           // 3
	OACS_InvalidUniqueUserName,     // 4
	OACS_UniqueUserNameInUse,       // 5
	OACS_ServiceUnavailable,        // 6
	OACS_MAX                        // 7
};

enum EOnlineNewsType
{
	ONT_Unknown,                    // 0
	ONT_GameNews,                   // 1
	ONT_ContentAnnouncements,       // 2
	ONT_Misc,                       // 3
	ONT_MAX                         // 4
};

struct native UniqueNetId
{
	var QWord Uid;

	structdefaultproperties
	{
		Uid=()
	}
};

struct native FriendsQuery
{
	var UniqueNetId UniqueId;
	var bool bIsFriend;

	structdefaultproperties
	{
		UniqueId=(Uid=())
		bIsFriend=false
	}
};

struct native OnlineFriend
{
	var const UniqueNetId UniqueId;
	var const QWord SessionId;
	var const string NickName;
	var const string PresenceInfo;
	var const OnlineSubsystem.EOnlineFriendState FriendState;
	var const bool bIsOnline;
	var const bool bIsPlaying;
	var const bool bIsPlayingThisGame;
	var const bool bIsJoinable;
	var const bool bHasVoiceSupport;
	var bool bHaveInvited;
	var const bool bHasInvitedYou;

	structdefaultproperties
	{
		UniqueId=(Uid=())
		SessionId=()
		NickName=""
		PresenceInfo=""
		FriendState=EOnlineFriendState.OFS_Offline
		bIsOnline=false
		bIsPlaying=false
		bIsPlayingThisGame=false
		bIsJoinable=false
		bHasVoiceSupport=false
		bHaveInvited=false
		bHasInvitedYou=false
	}
};

struct native OnlineContent
{
	var OnlineSubsystem.EOnlineContentType ContentType;
	var byte UserIndex;
	var bool bIsCorrupt;
	var int DeviceID;
	var int LicenseMask;
	var string FriendlyName;
	var string Filename;
	var string ContentPath;
	var array<string> ContentPackages;
	var array<string> ContentFiles;

	structdefaultproperties
	{
		ContentType=EOnlineContentType.OCT_Downloaded
		UserIndex=0
		bIsCorrupt=false
		DeviceID=0
		LicenseMask=0
		FriendlyName=""
		Filename=""
		ContentPath=""
		ContentPackages=none
		ContentFiles=none
	}
};

struct native OnlineCrossTitleContent extends OnlineContent
{
	var int TitleId;
};

struct native OnlineRegistrant
{
	var const UniqueNetId PlayerNetId;

	structdefaultproperties
	{
		PlayerNetId=(Uid=())
	}
};

struct native OnlineArbitrationRegistrant extends OnlineRegistrant
{
	var const QWord MachineId;
	var const int Trustworthiness;
};

struct SpeechRecognizedWord
{
	var int WordId;
	var string WordText;
	var float Confidence;

	structdefaultproperties
	{
		WordId=0
		WordText=""
		Confidence=0.0000000
	}
};

struct native OnlinePlayerScore
{
	var UniqueNetId PlayerID;
	var int TeamID;
	var int Score;

	structdefaultproperties
	{
		PlayerID=(Uid=())
		TeamID=0
		Score=0
	}
};

struct native LocalTalker
{
	var bool bHasVoice;
	var bool bHasNetworkedVoice;
	var bool bIsRecognizingSpeech;
	var bool bWasTalking;
	var bool bIsTalking;
	var bool bIsRegistered;

	structdefaultproperties
	{
		bHasVoice=false
		bHasNetworkedVoice=false
		bIsRecognizingSpeech=false
		bWasTalking=false
		bIsTalking=false
		bIsRegistered=false
	}
};

struct native RemoteTalker
{
	var UniqueNetId TalkerId;
	var float LastNotificationTime;
	var bool bWasTalking;
	var bool bIsTalking;
	var bool bIsRegistered;

	structdefaultproperties
	{
		TalkerId=(Uid=())
		LastNotificationTime=0.0000000
		bWasTalking=false
		bIsTalking=false
		bIsRegistered=false
	}
};

struct native OnlineFriendMessage
{
	var UniqueNetId SendingPlayerId;
	var string SendingPlayerNick;
	var bool bIsFriendInvite;
	var bool bIsGameInvite;
	var bool bWasAccepted;
	var bool bWasDenied;
	var string Message;

	structdefaultproperties
	{
		SendingPlayerId=(Uid=())
		SendingPlayerNick=""
		bIsFriendInvite=false
		bIsGameInvite=false
		bWasAccepted=false
		bWasDenied=false
		Message=""
	}
};

struct native NamedInterface
{
	var name InterfaceName;
	var Object InterfaceObject;

	structdefaultproperties
	{
		InterfaceName="None"
		InterfaceObject=none
	}
};

struct native NamedInterfaceDef
{
	var name InterfaceName;
	var string InterfaceClassName;

	structdefaultproperties
	{
		InterfaceName="None"
		InterfaceClassName=""
	}
};

struct native EmsFile
{
	var string Hash;
	var string DLName;
	var string Filename;
	var int FileSize;

	structdefaultproperties
	{
		Hash=""
		DLName=""
		Filename=""
		FileSize=0
	}
};

struct native TitleFile
{
	var string Filename;
	var OnlineSubsystem.EOnlineEnumerationReadState AsyncState;
	var array<byte> Data;

	structdefaultproperties
	{
		Filename=""
		AsyncState=EOnlineEnumerationReadState.OERS_NotStarted
		Data=none
	}
};

struct native CommunityContentFile
{
	var int ContentId;
	var int FileId;
	var int ContentType;
	var int FileSize;
	var UniqueNetId Owner;
	var int DownloadCount;
	var float AverageRating;
	var int RatingCount;
	var int LastRatingGiven;
	var string LocalFilePath;

	structdefaultproperties
	{
		ContentId=0
		FileId=0
		ContentType=0
		FileSize=0
		Owner=(Uid=())
		DownloadCount=0
		AverageRating=0.0000000
		RatingCount=0
		LastRatingGiven=0
		LocalFilePath=""
	}
};

struct native CommunityContentMetadata
{
	var int ContentType;
	var array<SettingsProperty> MetadataItems;

	structdefaultproperties
	{
		ContentType=0
		MetadataItems=none
	}
};

struct native NamedSession
{
	var name SessionName;
	var native const transient Pointer SessionInfo;
	var OnlineGameSettings GameSettings;
	var array<OnlineRegistrant> Registrants;
	var array<OnlineArbitrationRegistrant> ArbitrationRegistrants;

	structdefaultproperties
	{
		SessionName="None"
		GameSettings=none
		Registrants=none
		ArbitrationRegistrants=none
	}
};

struct native AchievementDetails
{
	var const int Id;
	var const string AchievementName;
	var const string Description;
	var const string HowTo;
	var Surface Image;
	var const byte MonthEarned;
	var const byte DayEarned;
	var const byte YearEarned;
	var const byte DayOfWeekEarned;
	var const int GamerPoints;
	var const bool bIsSecret;
	var const bool bWasAchievedOnline;
	var const bool bWasAchievedOffline;

	structdefaultproperties
	{
		Id=0
		AchievementName=""
		Description=""
		HowTo=""
		Image=none
		MonthEarned=0
		DayEarned=0
		YearEarned=0
		DayOfWeekEarned=0
		GamerPoints=0
		bIsSecret=false
		bWasAchievedOnline=false
		bWasAchievedOffline=false
	}
};

struct native OnlinePartyMember
{
	var const UniqueNetId UniqueId;
	var const string NickName;
	var const byte LocalUserNum;
	var const OnlineSubsystem.ENATType NatType;
	var const int TitleId;
	var const bool bIsLocal;
	var const bool bIsInPartyVoice;
	var const bool bIsTalking;
	var const bool bIsInGameSession;
	var const bool bIsPlayingThisGame;
	var const QWord SessionId;
	var const int Data1;
	var const int Data2;
	var const int Data3;
	var const int Data4;

	structdefaultproperties
	{
		UniqueId=(Uid=())
		NickName=""
		LocalUserNum=0
		NatType=ENATType.NAT_Unknown
		TitleId=0
		bIsLocal=false
		bIsInPartyVoice=false
		bIsTalking=false
		bIsInGameSession=false
		bIsPlayingThisGame=false
		SessionId=()
		Data1=0
		Data2=0
		Data3=0
		Data4=0
	}
};

struct native SocialPostPrivileges
{
	var const bool bCanPostImage;
	var const bool bCanPostLink;

	structdefaultproperties
	{
		bCanPostImage=false
		bCanPostLink=false
	}
};

struct native SocialPostImageFlags
{
	var bool bIsUserGeneratedImage;
	var bool bIsGameGeneratedImage;
	var bool bIsAchievementImage;
	var bool bIsMediaImage;

	structdefaultproperties
	{
		bIsUserGeneratedImage=false
		bIsGameGeneratedImage=false
		bIsAchievementImage=false
		bIsMediaImage=false
	}
};

struct native SocialPostImageInfo
{
	var SocialPostImageFlags Flags;
	var string MessageText;
	var string TitleText;
	var string PictureCaption;
	var string PictureDescription;

	structdefaultproperties
	{
		Flags=(bIsUserGeneratedImage=false,bIsGameGeneratedImage=false,bIsAchievementImage=false,bIsMediaImage=false)
		MessageText=""
		TitleText=""
		PictureCaption=""
		PictureDescription=""
	}
};

struct native SocialPostLinkInfo extends SocialPostImageInfo
{
	var string TitleURL;
	var string PictureURL;
};

var private native const noexport Pointer VfTable_FTickableObject;
var OnlineAccountInterface AccountInterface;
var OnlinePlayerInterface PlayerInterface;
var OnlinePlayerInterfaceEx PlayerInterfaceEx;
var OnlineSystemInterface SystemInterface;
var OnlineGameInterface GameInterface;
var OnlineContentInterface ContentInterface;
var OnlineVoiceInterface VoiceInterface;
var OnlineStatsInterface StatsInterface;
var OnlineNewsInterface NewsInterface;
var OnlinePartyChatInterface PartyChatInterface;
var OnlineTitleFileInterface TitleFileInterface;
var OnlineTitleFileCacheInterface TitleFileCacheInterface;
var UserCloudFileInterface UserCloudInterface;
var SharedCloudFileInterface SharedCloudInterface;
var OnlineSocialInterface SocialInterface;
var OnlineAuthInterface AuthInterface;
var private array<NamedInterface> NamedInterfaces;
var config array<config NamedInterfaceDef> NamedInterfaceDefs;
var protected const array<NamedSession> Sessions;
var config bool bUseBuildIdOverride;
var config int BuildIdOverride;
var config string IniLocPatcherClassName;
var transient IniLocPatcher Patcher;
var config float AsyncMinCompletionTime;

// Export UOnlineSubsystem::execInit(FFrame&, void* const)
native event bool Init();

event bool PostInit()
{
	local Class<IniLocPatcher> IniLocPatcherClass;

	// End:0xC4
	if(IniLocPatcherClassName != "")
	{
		LogInternal(("Loading " $ IniLocPatcherClassName) $ " for INI/Loc patching", 'DevMCP');
		IniLocPatcherClass = Class<IniLocPatcher>(DynamicLoadObject(IniLocPatcherClassName, Class'Core.Class'));
		Patcher = new IniLocPatcherClass;
		// End:0xC2
		if(Patcher != none)
		{
			Patcher.Init();			
		}
		else
		{
			return false;
		}
	}
	return true;
	//return ReturnValue;	
}

event Exit()
{
	//return;	
}

event bool SetAccountInterface(Object NewInterface)
{
	AccountInterface = OnlineAccountInterface(NewInterface);
	return NotEqual_InterfaceInterface(AccountInterface, OnlineAccountInterface(none));
	//return ReturnValue;	
}

event bool SetPlayerInterface(Object NewInterface)
{
	PlayerInterface = OnlinePlayerInterface(NewInterface);
	return NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none));
	//return ReturnValue;	
}

event bool SetPlayerInterfaceEx(Object NewInterface)
{
	PlayerInterfaceEx = OnlinePlayerInterfaceEx(NewInterface);
	return NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none));
	//return ReturnValue;	
}

event bool SetSystemInterface(Object NewInterface)
{
	SystemInterface = OnlineSystemInterface(NewInterface);
	return NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none));
	//return ReturnValue;	
}

event bool SetGameInterface(Object NewInterface)
{
	GameInterface = OnlineGameInterface(NewInterface);
	return NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none));
	//return ReturnValue;	
}

event bool SetContentInterface(Object NewInterface)
{
	ContentInterface = OnlineContentInterface(NewInterface);
	return NotEqual_InterfaceInterface(ContentInterface, OnlineContentInterface(none));
	//return ReturnValue;	
}

event bool SetVoiceInterface(Object NewInterface)
{
	VoiceInterface = OnlineVoiceInterface(NewInterface);
	return NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none));
	//return ReturnValue;	
}

event bool SetStatsInterface(Object NewInterface)
{
	StatsInterface = OnlineStatsInterface(NewInterface);
	return NotEqual_InterfaceInterface(StatsInterface, OnlineStatsInterface(none));
	//return ReturnValue;	
}

event bool SetNewsInterface(Object NewInterface)
{
	NewsInterface = OnlineNewsInterface(NewInterface);
	return NotEqual_InterfaceInterface(NewsInterface, OnlineNewsInterface(none));
	//return ReturnValue;	
}

event bool SetPartyChatInterface(Object NewInterface)
{
	PartyChatInterface = OnlinePartyChatInterface(NewInterface);
	return NotEqual_InterfaceInterface(PartyChatInterface, OnlinePartyChatInterface(none));
	//return ReturnValue;	
}

event bool SetTitleFileInterface(Object NewInterface)
{
	TitleFileInterface = OnlineTitleFileInterface(NewInterface);
	return NotEqual_InterfaceInterface(TitleFileInterface, OnlineTitleFileInterface(none));
	//return ReturnValue;	
}

event bool SetTitleFileCacheInterface(Object NewInterface)
{
	TitleFileCacheInterface = OnlineTitleFileCacheInterface(NewInterface);
	return NotEqual_InterfaceInterface(TitleFileCacheInterface, OnlineTitleFileCacheInterface(none));
	//return ReturnValue;	
}

event bool SetSocialInterface(Object InSocialInterface)
{
	SocialInterface = OnlineSocialInterface(InSocialInterface);
	return NotEqual_InterfaceInterface(SocialInterface, OnlineSocialInterface(none));
	//return ReturnValue;	
}

event bool SetAuthInterface(Object InAuthInterface)
{
	AuthInterface = OnlineAuthInterface(InAuthInterface);
	return NotEqual_InterfaceInterface(AuthInterface, OnlineAuthInterface(none));
	//return ReturnValue;	
}

event bool SetUserCloudInterface(Object InCloudInterface)
{
	UserCloudInterface = UserCloudFileInterface(InCloudInterface);
	return NotEqual_InterfaceInterface(UserCloudInterface, UserCloudFileInterface(none));
	//return ReturnValue;	
}

event bool SetSharedCloudInterface(Object InCloudInterface)
{
	SharedCloudInterface = SharedCloudFileInterface(InCloudInterface);
	return NotEqual_InterfaceInterface(SharedCloudInterface, SharedCloudFileInterface(none));
	//return ReturnValue;	
}

event SetNamedInterface(name InterfaceName, Object NewInterface)
{
	local int InterfaceIndex;

	InterfaceIndex = NamedInterfaces.Find('InterfaceName', InterfaceName);
	// End:0x98
	if(InterfaceIndex == -1)
	{
		InterfaceIndex = NamedInterfaces.Length;
		NamedInterfaces.Length = NamedInterfaces.Length + 1;
		NamedInterfaces[InterfaceIndex].InterfaceName = InterfaceName;
	}
	NamedInterfaces[InterfaceIndex].InterfaceObject = NewInterface;
	//return;	
}

event Object GetNamedInterface(name InterfaceName)
{
	local int InterfaceIndex;

	InterfaceIndex = NamedInterfaces.Find('InterfaceName', InterfaceName);
	// End:0x63
	if(InterfaceIndex != -1)
	{
		return NamedInterfaces[InterfaceIndex].InterfaceObject;
	}
	return none;
	//return ReturnValue;	
}

// Export UOnlineSubsystem::execUniqueNetIdToString(FFrame&, void* const)
native static final function string UniqueNetIdToString(const out UniqueNetId IdToConvert);

// Export UOnlineSubsystem::execStringToUniqueNetId(FFrame&, void* const)
native static final function bool StringToUniqueNetId(string UniqueNetIdString, out UniqueNetId out_UniqueId);

event UniqueNetId GetPlayerUniqueNetIdFromIndex(int UserIndex)
{
	local UniqueNetId ReturnVal, NullId;

	// End:0x6E
	if(EqualEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)) || PlayerInterface.GetUniquePlayerId(byte(UserIndex), ReturnVal)!)
	{
		ReturnVal = NullId;
	}
	return ReturnVal;
	//return ReturnValue;	
}

// Export UOnlineSubsystem::execGetBuildUniqueId(FFrame&, void* const)
native function int GetBuildUniqueId();

// Export UOnlineSubsystem::execGetNumSupportedLogins(FFrame&, void* const)
native static final function int GetNumSupportedLogins();

// Export UOnlineSubsystem::execInitMarketPlace(FFrame&, void* const)
native function InitMarketPlace();

// Export UOnlineSubsystem::execShowMarketplaceUI(FFrame&, void* const)
native function ShowMarketplaceUI();

// Export UOnlineSubsystem::execCheckPurchaseCompleted(FFrame&, void* const)
native function bool CheckPurchaseCompleted();

// Export UOnlineSubsystem::execEnumerateOffers(FFrame&, void* const)
native function EnumerateOffers();

// Export UOnlineSubsystem::execConsumeAssets(FFrame&, void* const)
native function int ConsumeAssets(int Amount);

// Export UOnlineSubsystem::execGetQuantityForSelection(FFrame&, void* const)
native function int GetQuantityForSelection(int Selection);

static function DumpGameSettings(const OnlineGameSettings GameSettings)
{
	LogInternal("    OnlineGameSettings: " $ string(GameSettings));
	LogInternal("      OwningPlayerName: " $ GameSettings.OwningPlayerName);
	LogInternal("      OwningPlayerId: " $ UniqueNetIdToString(GameSettings.OwningPlayerId));
	LogInternal("      PingInMs: " $ string(GameSettings.PingInMs));
	LogInternal("      NumPublicConnections: " $ string(GameSettings.NumPublicConnections));
	LogInternal("      NumOpenPublicConnections: " $ string(GameSettings.NumOpenPublicConnections));
	LogInternal("      NumPrivateConnections: " $ string(GameSettings.NumPrivateConnections));
	LogInternal("      NumOpenPrivateConnections: " $ string(GameSettings.NumOpenPrivateConnections));
	LogInternal("      bIsLanMatch: " $ string(GameSettings.bIsLanMatch));
	LogInternal("      bIsDedicated: " $ string(GameSettings.bIsDedicated));
	LogInternal("      bUsesStats: " $ string(GameSettings.bUsesStats));
	LogInternal("      bUsesArbitration: " $ string(GameSettings.bUsesArbitration));
	LogInternal("      bAntiCheatProtected: " $ string(GameSettings.bAntiCheatProtected));
	LogInternal("      bShouldAdvertise: " $ string(GameSettings.bShouldAdvertise));
	LogInternal("      bAllowJoinInProgress: " $ string(GameSettings.bAllowJoinInProgress));
	LogInternal("      bAllowInvites: " $ string(GameSettings.bAllowInvites));
	LogInternal("      bUsesPresence: " $ string(GameSettings.bUsesPresence));
	LogInternal("      bWasFromInvite: " $ string(GameSettings.bWasFromInvite));
	LogInternal("      bAllowJoinViaPresence: " $ string(GameSettings.bAllowJoinViaPresence));
	LogInternal("      bAllowJoinViaPresenceFriendsOnly: " $ string(GameSettings.bAllowJoinViaPresenceFriendsOnly));
	LogInternal("      GameState: " $ string(GameSettings.GameState));
	//return;	
}

function DumpSessionState()
{
	local int Index, PlayerIndex;
	local UniqueNetId NetId, ZeroId;

	NetId = ZeroId;
	ZeroId = NetId;
	LogInternal("Unreal online session state");
	LogInternal("-------------------------------------------------------------");
	LogInternal("");
	LogInternal("Number of sessions: " $ string(Sessions.Length));
	Index = 0;
	J0xBF:

	// End:0x373 [Loop If]
	if(Index < Sessions.Length)
	{
		LogInternal("  Session: " $ string(Sessions[Index].SessionName));
		DumpGameSettings(Sessions[Index].GameSettings);
		LogInternal("");
		LogInternal("    Number of players: " $ string(Sessions[Index].Registrants.Length));
		PlayerIndex = 0;
		J0x198:

		// End:0x250 [Loop If]
		if(PlayerIndex < Sessions[Index].Registrants.Length)
		{
			NetId = Sessions[Index].Registrants[PlayerIndex].PlayerNetId;
			LogInternal("      Player: " $ UniqueNetIdToString(NetId));
			PlayerIndex++;
			// [Loop Continue]
			goto J0x198;
		}
		LogInternal("    Number of arbitrated players: " $ string(Sessions[Index].ArbitrationRegistrants.Length));
		PlayerIndex = 0;
		J0x2AD:

		// End:0x365 [Loop If]
		if(PlayerIndex < Sessions[Index].ArbitrationRegistrants.Length)
		{
			NetId = Sessions[Index].ArbitrationRegistrants[PlayerIndex].PlayerNetId;
			LogInternal("      Player: " $ UniqueNetIdToString(NetId));
			PlayerIndex++;
			// [Loop Continue]
			goto J0x2AD;
		}
		Index++;
		// [Loop Continue]
		goto J0xBF;
	}
	//return;	
}

static function DumpNetIds(const out array<UniqueNetId> Players, string DebugLabel)
{
	local int PlayerIdx;
	local UniqueNetId NetId;

	PlayerIdx = 0;
	J0x0B:

	// End:0x9F [Loop If]
	if(PlayerIdx < Players.Length)
	{
		NetId = Players[PlayerIdx];
		LogInternal(((((DebugLabel $ ": ") $ " PlayerIdx=") $ string(PlayerIdx)) $ " UniqueId=") $ UniqueNetIdToString(NetId));
		PlayerIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function DumpVoiceRegistration()
{
	//return;	
}

function SetDebugSpewLevel(int DebugSpewLevel)
{
	//return;	
}

defaultproperties
{
	NamedInterfaceDefs[0]=(InterfaceName="RecentPlayersList",InterfaceClassName="Engine.OnlineRecentPlayersList")
}