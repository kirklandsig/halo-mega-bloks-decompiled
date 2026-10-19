class UIDataStore_OnlinePlayerData extends UIDataStore_Remote
	transient
	native
	config(Engine);

var UIDataProvider_OnlineFriends FriendsProvider;
var int PlayerControllerId;
var string PlayerNick;
var config string ProfileSettingsClassName;
var Class<OnlineProfileSettings> ProfileSettingsClass;
var UIDataProvider_OnlineProfileSettings ProfileProvider;
var config string ProfileProviderClassName;
var Class<UIDataProvider_OnlineProfileSettings> ProfileProviderClass;
var config string PlayerStorageClassName;
var Class<OnlinePlayerStorage> PlayerStorageClass;
var UIDataProvider_OnlinePlayerStorage StorageProvider;
var config string StorageProviderClassName;
var Class<UIDataProvider_OnlinePlayerStorage> StorageProviderClass;
var UIDataProvider_OnlineFriendMessages FriendMessagesProvider;
var UIDataProvider_PlayerAchievements AchievementsProvider;
var config string FriendsProviderClassName;
var Class<UIDataProvider_OnlineFriends> FriendsProviderClass;
var config string FriendMessagesProviderClassName;
var Class<UIDataProvider_OnlineFriendMessages> FriendMessagesProviderClass;
var config string AchievementsProviderClassName;
var Class<UIDataProvider_PlayerAchievements> AchievementsProviderClass;
var config string PartyChatProviderClassName;
var Class<UIDataProvider_OnlinePartyChatList> PartyChatProviderClass;
var UIDataProvider_OnlinePartyChatList PartyChatProvider;

event OnRegister(LocalPlayer InPlayer)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// End:0x1F9
	if(InPlayer != none)
	{
		PlayerControllerId = InPlayer.ControllerId;
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x171
		if(OnlineSub != none)
		{
			PlayerInterface = OnlineSub.PlayerInterface;
			// End:0xE8
			if(NotEqual_InterfaceInterface(PlayerInterface, none))
			{
				PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
			}
			// End:0x16E
			if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, none))
			{
				OnlineSub.PlayerInterfaceEx.AddProfileDataChangedDelegate(byte(PlayerControllerId), OnPlayerDataChange);
			}			
		}
		else
		{
			// End:0x1DA
			if((ProfileProvider != none) && ProfileProvider.Profile != none)
			{
				ProfileProvider.Profile.SetToDefaults();
			}
		}
		RegisterDelegates();
		OnLoginChange(byte(PlayerControllerId));
	}
	//return;	
}

event OnUnregister()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// End:0x154
	if(PlayerControllerId != -1)
	{
		ClearDelegates();
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x154
		if(OnlineSub != none)
		{
			PlayerInterface = OnlineSub.PlayerInterface;
			// End:0xCE
			if(NotEqual_InterfaceInterface(PlayerInterface, none))
			{
				PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
			}
			// End:0x154
			if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, none))
			{
				OnlineSub.PlayerInterfaceEx.ClearProfileDataChangedDelegate(byte(PlayerControllerId), OnPlayerDataChange);
			}
		}
	}
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// End:0x18B
	if(int(LocalUserNum) == PlayerControllerId)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x17D
		if(OnlineSub != none)
		{
			PlayerInterface = OnlineSub.PlayerInterface;
			// End:0x109
			if(NotEqual_InterfaceInterface(PlayerInterface, none) && int(PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > 0)
			{
				PlayerNick = PlayerInterface.GetPlayerNickname(byte(PlayerControllerId));				
			}
			else
			{
				PlayerNick = "";
				ProfileProvider.Profile.SetToDefaults();
				StorageProvider.Profile.SetToDefaults();
			}
		}
		RefreshSubscribers();
	}
	//return;	
}

function OnPlayerDataChange()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xC5
	if(OnlineSub != none)
	{
		// End:0xC5
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
		{
			PlayerNick = OnlineSub.PlayerInterface.GetPlayerNickname(byte(PlayerControllerId));
			RefreshSubscribers();
		}
	}
	//return;	
}

function RegisterDelegates()
{
	//return;	
}

function ClearDelegates()
{
	//return;	
}

event OnlineProfileSettings GetCachedPlayerProfile(int ControllerId)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;
	local OnlineProfileSettings Result;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xB5
	if(OnlineSub != none)
	{
		PlayerInterface = OnlineSub.PlayerInterface;
		// End:0xB5
		if(NotEqual_InterfaceInterface(PlayerInterface, none))
		{
			Result = PlayerInterface.GetProfileSettings(byte(ControllerId));
		}
	}
	return Result;
	//return ReturnValue;	
}

event OnlinePlayerStorage GetCachedPlayerStorage(int ControllerId)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;
	local OnlinePlayerStorage Result;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xB5
	if(OnlineSub != none)
	{
		PlayerInterface = OnlineSub.PlayerInterface;
		// End:0xB5
		if(NotEqual_InterfaceInterface(PlayerInterface, none))
		{
			Result = PlayerInterface.GetPlayerStorage(byte(ControllerId));
		}
	}
	return Result;
	//return ReturnValue;	
}

defaultproperties
{
	PlayerControllerId=-1
	PlayerNick="PlayerNickNameHere"
	ProfileSettingsClassName="MegaHaloGame.HaloProfileSettings"
	PlayerStorageClassName="MegaHaloGame.HaloPlayerPersistentData"
	StorageProviderClassName="MegaHaloGame.HaloDataProvider_PlayerStorage"
	FriendsProviderClassName="Engine.UIDataProvider_OnlineFriends"
	FriendMessagesProviderClassName="Engine.UIDataProvider_OnlineFriendMessages"
	PartyChatProviderClassName="Engine.UIDataProvider_OnlinePartyChatList"
	Tag="OnlinePlayerData"
}