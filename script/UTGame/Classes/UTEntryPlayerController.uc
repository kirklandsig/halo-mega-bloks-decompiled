class UTEntryPlayerController extends UTPlayerController
	config(Game);

var PostProcessChain EntryPostProcessChain;
var array<PostProcessChain> OldPostProcessChain;
var LocalPlayer OldPlayer;

event InitInputSystem()
{
	super(PlayerController).InitInputSystem();
	AddOnlineDelegates(false);
	CameraAnimPlayer = new (self) Class'Engine.CameraAnimInst';
	// End:0xF8
	if(EntryPostProcessChain != none)
	{
		// End:0x99
		if(OldPostProcessChain.Length == 0)
		{
			OldPostProcessChain = LocalPlayer(Player).PlayerPostProcessChains;
			OldPlayer = LocalPlayer(Player);
		}
		LocalPlayer(Player).RemoveAllPostProcessingChains();
		LocalPlayer(Player).InsertPostProcessingChain(EntryPostProcessChain, -1, false);
	}
	//return;	
}

simulated function RestorePostProcessing()
{
	local int PPIdx;

	// End:0xBF
	if((OldPlayer != none) && EntryPostProcessChain != none)
	{
		OldPlayer.RemoveAllPostProcessingChains();
		PPIdx = 0;
		J0x4A:

		// End:0xA8 [Loop If]
		if(PPIdx < OldPostProcessChain.Length)
		{
			OldPlayer.InsertPostProcessingChain(OldPostProcessChain[PPIdx], -1, true);
			PPIdx++;
			// [Loop Continue]
			goto J0x4A;
		}
		OldPostProcessChain.Length = 0;
		OldPlayer = none;
	}
	//return;	
}

simulated event Destroyed()
{
	RestorePostProcessing();
	super.Destroyed();
	//return;	
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
	local LocalPlayer LocPlayer;

	LocPlayer = LocalPlayer(Player);
	// End:0x93
	if((WorldInfo.IsConsoleBuild() && LocPlayer != none) && LocPlayer.ControllerId == ControllerId)
	{
		bIsControllerConnected = bIsConnected;
	}
	//return;	
}

function OnGameInviteReceived(byte LocalUserNum, string RequestingNick)
{
	//return;	
}

function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
	//return;	
}

function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
	//return;	
}

exec function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
	local bool bInvalidConnectionStatus;

	switch(ConnectionStatus)
	{
		// End:0xCB
		case 7:
			LogInternal("Detected another user logging-in with this profile.");
			SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.DuplicateLogin_Title>", "<Strings:UTGameUI.Errors.DuplicateLogin_Message>");
			bInvalidConnectionStatus = true;
			// End:0x1E5
			break;
		// End:0xD0
		case 2:
		// End:0xD5
		case 3:
		// End:0xDA
		case 5:
		// End:0x15A
		case 6:
			SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.ConnectionLost_Title>", "<Strings:UTGameUI.Errors.ConnectionLost_Message>");
			bInvalidConnectionStatus = true;
			// End:0x1E5
			break;
		// End:0x1E2
		case 4:
			SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.ServiceUnavailable_Title>", "<Strings:UTGameUI.Errors.ServiceUnavailable_Message>");
			bInvalidConnectionStatus = true;
			// End:0x1E5
			break;
		// End:0xFFFF
		default:
			break;
	}
	LogInternal((((((((((("(" $ string(Name)) $ ") UTEntryPlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "ConnectionStatus:'") $ string(GetEnum(Enum'Engine.OnlineSubsystem.EOnlineServerConnectionStatus', int(ConnectionStatus)))) $ "'") @ "bInvalidConnectionStatus:'") $ string(bInvalidConnectionStatus)) $ "'", 'DevOnline');
	// End:0x2BE
	if(bInvalidConnectionStatus)
	{
		QuitToMainMenu();
	}
	//return;	
}

exec function OnLinkStatusChanged(bool bConnected)
{
	local string ErrorDisplay;
	local UIDataStore_Registry Registry;

	Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
	LogInternal(((((((("(" $ string(Name)) $ ") UTEntryPlayerController::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "bConnected:'") $ string(bConnected)) $ "'", 'DevNet');
	// End:0x187
	if(bConnected!)
	{
		// End:0x187
		if(Registry.GetData("FrontEndError_Display", ErrorDisplay)! || int(ErrorDisplay) == 0)
		{
			SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.Error_Title>", "<Strings:UTGameUI.Errors.NetworkLinkLost_Message>");
			QuitToMainMenu();
		}
	}
	//return;	
}

function QuitToMainMenu()
{
	LogInternal("UTEntryPlayerController::QuitToMainMenu() - Quitting to main menu.");
	// End:0xA0
	if(GetURLMap() == "UDKFrontEndMap")
	{
		OnlineSub.GameInterface.DestroyOnlineGame('Game');		
	}
	else
	{
		super.QuitToMainMenu();
	}
	//return;	
}

function SetPawnConstructionScene(bool bShow)
{
	//return;	
}

function ShowMidGameMenu(optional name TabTag, optional bool bEnableInput)
{
	//return;	
}

function ShowScoreboard()
{
	//return;	
}

defaultproperties
{
	EntryPostProcessChain=PostProcessChain'FX_HitEffects.UTMenuPostProcess'
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTEntryPlayerController.ForceFeedbackWaveform7'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform7'
	begin object name="ForceFeedbackWaveform7"
	end object
	CameraShakeShortWaveForm=ForceFeedbackWaveform7
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTEntryPlayerController.ForceFeedbackWaveform8'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform8'
	begin object name="ForceFeedbackWaveform8"
	end object
	CameraShakeLongWaveForm=ForceFeedbackWaveform8
	// Reference: CylinderComponent'UTGame.Default__UTEntryPlayerController.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTPlayerController.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}