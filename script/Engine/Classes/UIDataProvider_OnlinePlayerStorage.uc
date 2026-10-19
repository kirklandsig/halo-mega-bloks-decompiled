class UIDataProvider_OnlinePlayerStorage extends UIDataProvider_OnlinePlayerDataBase
	transient
	native
	config(Game);

struct native PlayerStorageArrayProvider
{
	var int PlayerStorageId;
	var UIDataProvider_OnlinePlayerStorageArray Provider;

	structdefaultproperties
	{
		PlayerStorageId=0
		Provider=none
	}
};

var OnlinePlayerStorage Profile;
var const name ProviderName;
var bool bWasErrorLastRead;
var bool bIsExternalUIOpen;
var bool bNeedsDeferredRefresh;
var array<PlayerStorageArrayProvider> PlayerStorageArrayProviders;
var config int DeviceStorageSizeNeeded;

function bool ReadData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, int DeviceID, OnlinePlayerStorage PlayerStorage)
{
	return PlayerInterface.ReadPlayerStorage(LocalUserNum, PlayerStorage, DeviceID);
	//return ReturnValue;	
}

function bool WriteData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, int DeviceID, OnlinePlayerStorage PlayerStorage)
{
	return PlayerInterface.WritePlayerStorage(LocalUserNum, PlayerStorage, DeviceID);
	//return ReturnValue;	
}

function bool GetData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
	local OnlinePlayerStorage CachedStorage;

	CachedStorage = PlayerInterface.GetPlayerStorage(LocalUserNum);
	// End:0x8A
	if(CachedStorage != none)
	{
		Profile = CachedStorage;
		PlayerInterface.ReadPlayerStorage(LocalUserNum, Profile);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function AddReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
	PlayerInterface.AddReadPlayerStorageCompleteDelegate(LocalUserNum, OnReadStorageComplete);
	//return;	
}

function ClearReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
	PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocalUserNum, OnReadStorageComplete);
	//return;	
}

event OnRegister(LocalPlayer InPlayer)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	super.OnRegister(InPlayer);
	// End:0x1DE
	if(PlayerControllerId != -1)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x11D
		if(OnlineSub != none)
		{
			PlayerInterface = OnlineSub.PlayerInterface;
			// End:0x11D
			if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
			{
				PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
				AddReadCompleteDelegate(PlayerInterface, byte(PlayerControllerId));
				GetData(PlayerInterface, byte(PlayerControllerId));
				RefreshStorageData();
			}
		}
		// End:0x1DE
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
		{
			OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(OnStorageDeviceChange);
			OnlineSub.SystemInterface.AddExternalUIChangeDelegate(OnExternalUIChange);
		}
	}
	//return;	
}

event OnUnregister()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x190
	if(OnlineSub != none)
	{
		PlayerInterface = OnlineSub.PlayerInterface;
		// End:0xCF
		if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
		{
			PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
			ClearReadCompleteDelegate(PlayerInterface, byte(PlayerControllerId));
		}
		// End:0x190
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
		{
			OnlineSub.SystemInterface.ClearStorageDeviceChangeDelegate(OnStorageDeviceChange);
			OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnExternalUIChange);
		}
	}
	super.OnUnregister();
	//return;	
}

function OnReadStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// End:0x108
	if(bWasSuccessful == true)
	{
		// End:0x22
		if(!bWasErrorLastRead)
		{			
		}
		else
		{
			OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
			// End:0x105
			if(OnlineSub != none)
			{
				PlayerInterface = OnlineSub.PlayerInterface;
				// End:0x105
				if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
				{
					bWasErrorLastRead = false;
					// End:0x105
					if((ReadData(PlayerInterface, byte(PlayerControllerId), Profile.DeviceID, Profile)) == false)
					{
						bWasErrorLastRead = true;
					}
				}
			}
		}		
	}
	else
	{
		bWasErrorLastRead = true;
		LogInternal("Failed to read online storage data", 'DevOnline');
	}
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;
	local OnlineSubsystem.ELoginStatus LoginStatus;
	local UniqueNetId NetId;

	// End:0x13F
	if(int(LocalUserNum) == PlayerControllerId)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x135
		if(OnlineSub != none)
		{
			PlayerInterface = OnlineSub.PlayerInterface;
			// End:0x135
			if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
			{
				LoginStatus = PlayerInterface.GetLoginStatus(byte(PlayerControllerId));
				PlayerInterface.GetUniquePlayerId(byte(PlayerControllerId), NetId);
				// End:0x135
				if(int(LoginStatus) == int(0))
				{
					Profile.SetToDefaults();
				}
			}
		}
		RefreshStorageData();
	}
	//return;	
}

function RefreshStorageData()
{
	local OnlineSubsystem OnlineSub;
	local bool bFoundCachedData;

	// End:0x181
	if(!bIsExternalUIOpen)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x17E
		if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
		{
			bFoundCachedData = GetData(OnlineSub.PlayerInterface, byte(PlayerControllerId));
			// End:0x17E
			if(!bFoundCachedData || bFoundCachedData && !OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
			{
				ShowDeviceSelection();
			}
		}		
	}
	else
	{
		bNeedsDeferredRefresh = true;
	}
	//return;	
}

function ShowDeviceSelection()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x141
	if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
	{
		OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
		OnlineSub.PlayerInterfaceEx.ShowDeviceSelectionUI(byte(PlayerControllerId), DeviceStorageSizeNeeded);
	}
	//return;	
}

function OnDeviceSelectionComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local string Ignored;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
	// End:0x1E8
	if(bWasSuccessful)
	{
		Profile.DeviceID = OnlineSub.PlayerInterfaceEx.GetDeviceSelectionResults(byte(PlayerControllerId), Ignored);
		LogInternal(((((("OnDeviceSelectionComplete(" $ string(bWasSuccessful)) $ ") for ControllerId (") $ string(PlayerControllerId)) $ ") with DeviceId (") $ string(Profile.DeviceID)) $ ")", 'DevOnline');
		// End:0x1E5
		if((ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), Profile.DeviceID, Profile)) == false)
		{
		}		
	}
	else
	{
		Profile.DeviceID = -1;
	}
	//return;	
}

function OnStorageDeviceChange()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xFE
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
	{
		// End:0xFE
		if(!OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
		{
			Profile.DeviceID = -1;
			RefreshStorageData();
		}
	}
	//return;	
}

function OnExternalUIChange(bool bIsOpening)
{
	bIsExternalUIOpen = bIsOpening;
	// End:0x3D
	if(!bIsOpening && bNeedsDeferredRefresh)
	{
		RefreshStorageData();
	}
	//return;	
}

defaultproperties
{
	ProviderName="PlayerStorageData"
}