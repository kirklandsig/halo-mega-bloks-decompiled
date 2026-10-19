class HaloDataProvider_PlayerStorage extends UIDataProvider_OnlinePlayerStorage
	transient
	config(Game);

var HaloLocalPlayer LocPlayer;
var bool bIsShowingDeviceSelection;

event OnRegister(LocalPlayer InPlayer)
{
	LocPlayer = HaloLocalPlayer(InPlayer);
	super.OnRegister(InPlayer);
	//return;	
}

function RefreshStorageData()
{
	local OnlineSubsystem OnlineSub;

	// End:0x250
	if(LocPlayer.bHasSeenStartScreen)
	{
		// End:0x244
		if(!bIsExternalUIOpen)
		{
			OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
			// End:0x241
			if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
			{
				// End:0x200
				if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
				{
					// End:0x1BC
					if((LocPlayer != none) && !LocPlayer.bWantsToSkipSaves)
					{
						// End:0x178
						if(!OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
						{
							ShowDeviceSelection();							
						}
						else
						{
							ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), -1, Profile);
						}						
					}
					else
					{
						ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), -1, Profile);
					}					
				}
				else
				{
					ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), -1, Profile);
				}
			}			
		}
		else
		{
			bNeedsDeferredRefresh = true;
		}
	}
	//return;	
}

function OnDeviceSelectionComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local string Ignored;
	local bool bHasEnoughSpace;

	bNeedsDeferredRefresh = false;
	bIsShowingDeviceSelection = false;
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
	// End:0x303
	if(bWasSuccessful && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
	{
		LocPlayer.bWantsToSkipSaves = false;
		Profile.DeviceID = OnlineSub.PlayerInterfaceEx.GetDeviceSelectionResults(byte(PlayerControllerId), Ignored);
		bHasEnoughSpace = OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded);
		LogInternal(((((((("OnDeviceSelectionComplete(" $ string(bWasSuccessful)) $ ") for ControllerId (") $ string(PlayerControllerId)) $ ") with DeviceId (") $ string(Profile.DeviceID)) $ ") bHasEnoughSpace(") $ string(bHasEnoughSpace)) $ ")", 'DevOnline');
		// End:0x300
		if(bHasEnoughSpace)
		{
			// End:0x2FD
			if((ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), Profile.DeviceID, Profile)) == false)
			{
			}			
		}		
	}
	else
	{
		// End:0x398
		if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
		{			
		}
		else
		{
			LocPlayer.bWantsToSkipSaves = true;
		}
	}
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	local OnlineSubsystem OnlineSub;
	local OnlineSubsystem.ELoginStatus LoginStatus;

	// End:0x178
	if(int(LocalUserNum) == PlayerControllerId)
	{
		// End:0x6A
		if(LocPlayer != none)
		{
			LocPlayer.bWantsToSkipSaves = false;
			LocPlayer.bHasSeenStartScreen = false;
		}
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x178
		if(OnlineSub != none)
		{
			// End:0x178
			if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
			{
				LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId));
				// End:0x178
				if(int(LoginStatus) == int(0))
				{
					Profile.SetToDefaults();
					Profile.DeviceID = -1;
				}
			}
		}
	}
	//return;	
}

function ShowDeviceSelection()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x1ED
	if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
	{
		// End:0x1E2
		if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
		{
			bIsShowingDeviceSelection = true;
			OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
			OnlineSub.PlayerInterfaceEx.ShowDeviceSelectionUI(byte(PlayerControllerId), DeviceStorageSizeNeeded);			
		}
		else
		{
			OnDeviceSelectionComplete(false);
		}
	}
	//return;	
}

function OnStorageDeviceChange()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x1F4
	if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
	{
		// End:0x1F4
		if(((!bIsShowingDeviceSelection && LocPlayer.bHasSeenStartScreen) && !LocPlayer.bWantsToSkipSaves) && !OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
		{
			// End:0x1F4
			if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
			{
			}
		}
	}
	//return;	
}
