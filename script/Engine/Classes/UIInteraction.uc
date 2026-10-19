class UIInteraction extends Interaction within GameViewportClient
	transient
	native
	config(UI);

struct native transient UIKeyRepeatData
{
	var init name CurrentRepeatKey;
	var init Double NextRepeatTime;

	structdefaultproperties
	{
		CurrentRepeatKey="None"
		NextRepeatTime=()
	}
};

struct native transient UIAxisEmulationData extends UIKeyRepeatData
{
	var init bool bEnabled;
};

var private native const noexport Pointer VfTable_FExec;
var private native const noexport Pointer VfTable_FGlobalDataStoreClientManager;
var private native const noexport Pointer VfTable_FCallbackEventDevice;
var UIManager UIManager;
var Class<UIManager> UIManagerClass;
var Class<GameUISceneClient> SceneClientClass;
var const transient GameUISceneClient SceneClient;
var transient array<name> SupportedDoubleClickKeys;
var private const transient DataStoreClient DataStoreManager;
var const transient bool bProcessInput;
var const config float UIJoystickDeadZone;
var const config float UIAxisMultiplier;
var const config float AxisRepeatDelay;
var const config float MouseButtonRepeatDelay;
var const config float DoubleClickTriggerSeconds;
var const config int DoubleClickPixelTolerance;
var const transient UIKeyRepeatData MouseButtonRepeatInfo;
var const config array<config UIAxisEmulationDefinition> ConfiguredAxisEmulationDefinitions;
var native const transient map{VOID,VOID} AxisEmulationDefinitions;
var transient UIAxisEmulationData AxisInputEmulation[4];

// Export UUIInteraction::execGetPlayerCount(FFrame&, void* const)
native static final function int GetPlayerCount();

// Export UUIInteraction::execGetPlayerIndex(FFrame&, void* const)
native static final function int GetPlayerIndex(int ControllerId);

// Export UUIInteraction::execGetPlayerControllerId(FFrame&, void* const)
native static final function int GetPlayerControllerId(int PlayerIndex);

// Export UUIInteraction::execGetDataStoreClient(FFrame&, void* const)
native static final function DataStoreClient GetDataStoreClient();

static final function LocalPlayer GetLocalPlayer(int PlayerIndex)
{
	local UIInteraction CurrentUIController;
	local LocalPlayer Result;

	CurrentUIController = Class'Engine.UIRoot'.static.GetCurrentUIController();
	// End:0xFE
	if(((CurrentUIController != none) && PlayerIndex >= 0) && PlayerIndex < CurrentUIController.Outer.Outer.GamePlayers.Length)
	{
		Result = CurrentUIController.Outer.Outer.GamePlayers[PlayerIndex];
	}
	return Result;
	//return ReturnValue;	
}

function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
	local UIAxisEmulationData Empty;

	// End:0x64
	if((PlayerIndex >= 0) && PlayerIndex < 4)
	{
		Empty.CurrentRepeatKey = 'None';
		AxisInputEmulation[PlayerIndex] = Empty;
	}
	// End:0xA4
	if(SceneClient != none)
	{
		SceneClient.NotifyPlayerAdded(PlayerIndex, AddedPlayer);
	}
	// End:0xE4
	if(UIManager != none)
	{
		UIManager.NotifyPlayerAdded(PlayerIndex, AddedPlayer);
	}
	//return;	
}

function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
	local int PlayerCount, NextPlayerIndex, I;
	local UIAxisEmulationData Empty;

	// End:0x1AF
	if((PlayerIndex >= 0) && PlayerIndex < 4)
	{
		PlayerCount = GetPlayerCount();
		I = PlayerIndex;
		J0x48:

		// End:0x16C [Loop If]
		if(I < PlayerCount)
		{
			NextPlayerIndex = I + 1;
			AxisInputEmulation[I].NextRepeatTime = AxisInputEmulation[NextPlayerIndex].NextRepeatTime;
			AxisInputEmulation[I].CurrentRepeatKey = AxisInputEmulation[NextPlayerIndex].CurrentRepeatKey;
			AxisInputEmulation[I].bEnabled = AxisInputEmulation[NextPlayerIndex].bEnabled;
			I++;
			// [Loop Continue]
			goto J0x48;
		}
		Empty.CurrentRepeatKey = 'None';
		AxisInputEmulation[PlayerCount] = Empty;
	}
	// End:0x1EF
	if(SceneClient != none)
	{
		SceneClient.NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
	}
	// End:0x22F
	if(UIManager != none)
	{
		UIManager.NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
	}
	//return;	
}

static final event OnlineSubsystem.ELoginStatus GetLoginStatus(int ControllerId)
{
	local OnlineSubsystem.ELoginStatus Result;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	Result = 0;
	// End:0xD4
	if(ControllerId != -1)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0xD4
		if(OnlineSub != none)
		{
			PlayerInterface = OnlineSub.PlayerInterface;
			// End:0xD4
			if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
			{
				Result = PlayerInterface.GetLoginStatus(byte(ControllerId));
			}
		}
	}
	return Result;
	//return ReturnValue;	
}

final function OnlineSubsystem.ELoginStatus GetLowestLoginStatusOfControllers()
{
	local OnlineSubsystem.ELoginStatus Result, LoginStatus;
	local int PlayerIndex;

	Result = 2;
	PlayerIndex = 0;
	J0x17:

	// End:0xFB [Loop If]
	if(PlayerIndex < Outer.Outer.GamePlayers.Length)
	{
		LoginStatus = GetLoginStatus(Outer.Outer.GamePlayers[PlayerIndex].ControllerId);
		// End:0xED
		if(int(LoginStatus) < int(Result))
		{
			Result = LoginStatus;
		}
		PlayerIndex++;
		// [Loop Continue]
		goto J0x17;
	}
	return Result;
	//return ReturnValue;	
}

static final event bool HasLinkConnection()
{
	local bool bResult;
	local OnlineSubsystem OnlineSub;
	local OnlineSystemInterface SystemInterface;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xAB
	if(OnlineSub != none)
	{
		SystemInterface = OnlineSub.SystemInterface;
		// End:0xAB
		if(NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
		{
			bResult = SystemInterface.HasLinkConnection();
		}
	}
	return bResult;
	//return ReturnValue;	
}

static final event bool IsLoggedIn(int ControllerId, optional bool bRequireOnlineLogin)
{
	local bool bResult;
	local OnlineSubsystem.ELoginStatus LoginStatus;

	LoginStatus = GetLoginStatus(ControllerId);
	bResult = (int(LoginStatus) == int(2)) || (int(LoginStatus) == int(1)) && !bRequireOnlineLogin;
	return bResult;
	//return ReturnValue;	
}

static final function int GetLoggedInPlayerCount(optional bool bRequireOnlineLogin)
{
	local int ControllerId, Result;

	ControllerId = 0;
	J0x0C:

	// End:0x55 [Loop If]
	if(ControllerId < 4)
	{
		// End:0x47
		if(IsLoggedIn(ControllerId, bRequireOnlineLogin))
		{
			Result++;
		}
		ControllerId++;
		// [Loop Continue]
		goto J0x0C;
	}
	return Result;
	//return ReturnValue;	
}

static final function int GetNumGuestsLoggedIn()
{
	local OnlineSubsystem OnlineSub;
	local int ControllerId, GuestCount;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xE6
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		ControllerId = 0;
		J0x7A:

		// End:0xE6 [Loop If]
		if(ControllerId < 4)
		{
			// End:0xD8
			if(OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerId)))
			{
				GuestCount++;
			}
			ControllerId++;
			// [Loop Continue]
			goto J0x7A;
		}
	}
	return GuestCount;
	//return ReturnValue;	
}

static final function bool IsGamepadConnected(int ControllerId)
{
	local bool bResult;
	local OnlineSubsystem OnlineSub;
	local OnlineSystemInterface SystemInterface;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xB4
	if(OnlineSub != none)
	{
		SystemInterface = OnlineSub.SystemInterface;
		// End:0xB4
		if(NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
		{
			bResult = SystemInterface.IsControllerConnected(ControllerId);
		}
	}
	return bResult;
	//return ReturnValue;	
}

static final function int GetConnectedGamepadCount(optional array<bool> ControllerConnectionStatusOverrides)
{
	local int I, Result;

	I = 0;
	J0x0C:

	// End:0x87 [Loop If]
	if(I < 4)
	{
		// End:0x58
		if(I < ControllerConnectionStatusOverrides.Length)
		{
			// End:0x55
			if(ControllerConnectionStatusOverrides[I])
			{
				Result++;
			}			
		}
		else
		{
			// End:0x79
			if(IsGamepadConnected(I))
			{
				Result++;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0C;
	}
	return Result;
	//return ReturnValue;	
}

static final event OnlineSubsystem.ENATType GetNATType()
{
	local OnlineSubsystem OnlineSub;
	local OnlineSystemInterface SystemInterface;
	local OnlineSubsystem.ENATType Result;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0xAA
	if(OnlineSub != none)
	{
		SystemInterface = OnlineSub.SystemInterface;
		// End:0xAA
		if(NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
		{
			Result = SystemInterface.GetNATType();
		}
	}
	return Result;
	//return ReturnValue;	
}

function NotifyGameSessionEnded()
{
	// End:0x2E
	if(SceneClient != none)
	{
		SceneClient.NotifyGameSessionEnded();
	}
	// End:0x5C
	if(DataStoreManager != none)
	{
		DataStoreManager.super(DataStoreClient).NotifyGameSessionEnded();
	}
	//return;	
}

defaultproperties
{
	UIManagerClass=Class'Engine.UIManager'
	SceneClientClass=Class'Engine.GameUISceneClient'
	UIJoystickDeadZone=0.9000000
	UIAxisMultiplier=1.0000000
	AxisRepeatDelay=0.2000000
	MouseButtonRepeatDelay=0.1500000
	DoubleClickTriggerSeconds=0.5000000
	DoubleClickPixelTolerance=1
	ConfiguredAxisEmulationDefinitions[0]=(AxisInputKey="MouseX",AdjacentAxisInputKey="MouseY",bEmulateButtonPress=false,InputKeyToEmulate="None",InputKeyToEmulate[1]="None")
	ConfiguredAxisEmulationDefinitions[1]=(AxisInputKey="MouseY",AdjacentAxisInputKey="MouseX",bEmulateButtonPress=false,InputKeyToEmulate="None",InputKeyToEmulate[1]="None")
	ConfiguredAxisEmulationDefinitions[2]=(AxisInputKey="XboxTypeS_LeftX",AdjacentAxisInputKey="XboxTypeS_LeftY",bEmulateButtonPress=true,InputKeyToEmulate="Gamepad_LeftStick_Right",InputKeyToEmulate[1]="Gamepad_LeftStick_Left")
	ConfiguredAxisEmulationDefinitions[3]=(AxisInputKey="XboxTypeS_LeftY",AdjacentAxisInputKey="XboxTypeS_LeftX",bEmulateButtonPress=true,InputKeyToEmulate="Gamepad_LeftStick_Up",InputKeyToEmulate[1]="Gamepad_LeftStick_Down")
	ConfiguredAxisEmulationDefinitions[4]=(AxisInputKey="XboxTypeS_RightX",AdjacentAxisInputKey="XboxTypeS_RightY",bEmulateButtonPress=true,InputKeyToEmulate="Gamepad_RightStick_Right",InputKeyToEmulate[1]="Gamepad_RightStick_Left")
	ConfiguredAxisEmulationDefinitions[5]=(AxisInputKey="XboxTypeS_RightY",AdjacentAxisInputKey="XboxTypeS_RightX",bEmulateButtonPress=true,InputKeyToEmulate="Gamepad_RightStick_Down",InputKeyToEmulate[1]="Gamepad_RightStick_Up")
	AxisInputEmulation[0]=(bEnabled=true,CurrentRepeatKey="None",NextRepeatTime=())
	AxisInputEmulation[1]=(bEnabled=true,CurrentRepeatKey="None",NextRepeatTime=())
	AxisInputEmulation[2]=(bEnabled=true,CurrentRepeatKey="None",NextRepeatTime=())
	AxisInputEmulation[3]=(bEnabled=true,CurrentRepeatKey="None",NextRepeatTime=())
}