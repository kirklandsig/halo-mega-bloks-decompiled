class GameViewportClient extends ScriptViewportClient within Engine
	transient
	native
	config(Engine);

enum ESplitScreenType
{
	eSST_NONE,                      // 0
	eSST_2P_HORIZONTAL,             // 1
	eSST_2P_VERTICAL,               // 2
	eSST_3P_FAVOR_TOP,              // 3
	eSST_3P_FAVOR_BOTTOM,           // 4
	eSST_4P,                        // 5
	eSST_MAX                        // 6
};

enum ESafeZoneType
{
	eSZ_TOP,                        // 0
	eSZ_BOTTOM,                     // 1
	eSZ_LEFT,                       // 2
	eSZ_RIGHT,                      // 3
	eSZ_MAX                         // 4
};

enum ESetMode
{
	SetMode_Toggle,                 // 0
	SetMode_Enable,                 // 1
	SetMode_Disable,                // 2
	SetMode_MAX                     // 3
};

struct native ShowFlags_Mirror
{
	var native const QWord flags0;
	var native const QWord flags1;
};

struct ExportShowFlags_Mirror extends ShowFlags_Mirror
{
};

struct native TitleSafeZoneArea
{
	var float MaxPercentX;
	var float MaxPercentY;
	var float RecommendedPercentX;
	var float RecommendedPercentY;

	structdefaultproperties
	{
		MaxPercentX=0.0000000
		MaxPercentY=0.0000000
		RecommendedPercentX=0.0000000
		RecommendedPercentY=0.0000000
	}
};

struct native PerPlayerSplitscreenData
{
	var float SizeX;
	var float SizeY;
	var float OriginX;
	var float OriginY;

	structdefaultproperties
	{
		SizeX=0.0000000
		SizeY=0.0000000
		OriginX=0.0000000
		OriginY=0.0000000
	}
};

struct native SplitscreenData
{
	var array<PerPlayerSplitscreenData> PlayerData;

	structdefaultproperties
	{
		PlayerData=none
	}
};

struct native DebugDisplayProperty
{
	var Object Obj;
	var name PropertyName;
	var bool bSpecialProperty;

	structdefaultproperties
	{
		Obj=none
		PropertyName="None"
		bSpecialProperty=false
	}
};

var private native const noexport Pointer VfTable_FExec;
var const Pointer Viewport;
var const Pointer ViewportFrame;
var init protected array<init Interaction> GlobalInteractions;
var Class<UIInteraction> UIControllerClass;
var UIInteraction UIController;
var Console ViewportConsole;
var const ExportShowFlags_Mirror ShowFlags;
var const localized string LoadingMessage;
var const localized string SavingMessage;
var const localized string ConnectingMessage;
var const localized string PausedMessage;
var const localized string PrecachingMessage;
var bool bShowTitleSafeZone;
var transient bool bDisplayHardwareMouseCursor;
var transient bool bOverrideDiffuseAndSpecular;
var transient bool bIsPlayInEditorViewport;
var transient bool bShowSystemMouseCursor;
var bool bDisableWorldRendering;
var config bool bDebugNoGFxUI;
var TitleSafeZoneArea TitleSafeZone;
var array<SplitscreenData> SplitscreenInfo;
var protected GameViewportClient.ESplitScreenType DesiredSplitscreenType;
var protected GameViewportClient.ESplitScreenType ActiveSplitscreenType;
var const GameViewportClient.ESplitScreenType Default2PSplitType;
var const GameViewportClient.ESplitScreenType Default3PSplitType;
var string ProgressMessage[2];
var float ProgressTimeOut;
var float ProgressFadeTime;
var array<DebugDisplayProperty> DebugProperties;
var native const Pointer ScaleformInteraction;
//var delegate<HandleInputKey> __HandleInputKey__Delegate;
//var delegate<HandleInputAxis> __HandleInputAxis__Delegate;
//var delegate<HandleInputChar> __HandleInputChar__Delegate;

delegate bool HandleInputKey(int ControllerId, name Key, Object.EInputEvent EventType, float AmountDepressed, optional bool bGamepad)
{
	//return ReturnValue;	
}

delegate bool HandleInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
	//return ReturnValue;	
}

delegate bool HandleInputChar(int ControllerId, string Unicode)
{
	//return ReturnValue;	
}

// Export UGameViewportClient::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command);

// Export UGameViewportClient::execGetViewportSize(FFrame&, void* const)
native final function GetViewportSize(out Vector2D out_ViewportSize);

// Export UGameViewportClient::execIsFullScreenViewport(FFrame&, void* const)
native final function bool IsFullScreenViewport();

// Export UGameViewportClient::execGetMousePosition(FFrame&, void* const)
native final function Vector2D GetMousePosition();

// Export UGameViewportClient::execShouldForceFullscreenViewport(FFrame&, void* const)
native final function bool ShouldForceFullscreenViewport();

// Export UGameViewportClient::execGetNumCustomInteractions(FFrame&, void* const)
native function int GetNumCustomInteractions();

// Export UGameViewportClient::execGetCustomInteractionClass(FFrame&, void* const)
native function Class<UIInteraction> GetCustomInteractionClass(int InIndex);

// Export UGameViewportClient::execSetCustomInteractionObject(FFrame&, void* const)
native function SetCustomInteractionObject(Interaction InInteraction);

// Export UGameViewportClient::execNotifySplitscreenLayoutChanged(FFrame&, void* const)
native function NotifySplitscreenLayoutChanged();

// Export UGameViewportClient::execForceUpdateMouseCursor(FFrame&, void* const)
native function ForceUpdateMouseCursor(bool bSetCursor);

// Export UGameViewportClient::execSetMouse(FFrame&, void* const)
native function SetMouse(int X, int Y);

event LocalPlayer CreatePlayer(int ControllerId, out string OutError, bool bSpawnActor)
{
	local LocalPlayer NewPlayer;
	local int InsertIndex;

	LogInternal(((("Creating new player with ControllerId" @ string(ControllerId)) @ "(") $ string(Outer.GamePlayers.Length)) @ "existing players)", 'PlayerManagement');
	// DebugMode: 0
	assert(Outer.LocalPlayerClass != none);
	NewPlayer = new (Outer) Outer.LocalPlayerClass;
	NewPlayer.ViewportClient = self;
	NewPlayer.ControllerId = ControllerId;
	InsertIndex = AddLocalPlayer(NewPlayer);
	// End:0x20B
	if(bSpawnActor && InsertIndex != -1)
	{
		// End:0x1EC
		if(Outer.GetCurrentWorldInfo().NetMode != NM_Client)
		{
			// End:0x1E9
			if(!NewPlayer.SpawnPlayActor("", OutError))
			{
				RemoveLocalPlayer(NewPlayer);
				NewPlayer = none;
			}			
		}
		else
		{
			NewPlayer.SendSplitJoin();
		}
	}
	// End:0x250
	if(OutError != "")
	{
		LogInternal("Player creation failed with error:" @ OutError);		
	}
	else
	{
		LogInternal(((((((("Successfully created new player with ControllerId" @ string(ControllerId)) $ ":") @ string(NewPlayer)) @ "- inserted into GamePlayers array at index") @ string(InsertIndex)) @ "(") $ string(Outer.GamePlayers.Length)) @ "existing players)", 'PlayerManagement');
		// End:0x365
		if((NewPlayer != none) && InsertIndex != -1)
		{
			NotifyPlayerAdded(InsertIndex, NewPlayer);
		}
	}
	return NewPlayer;
	//return ReturnValue;	
}

event bool RemovePlayer(LocalPlayer ExPlayer)
{
	local int OldIndex, I;
	local array<int> IDMappings;

	// End:0x37A
	if(ExPlayer.Actor.Role == ROLE_Authority)
	{
		LogInternal(((((((("Removing player" @ string(ExPlayer)) @ " with ControllerId") @ string(ExPlayer.ControllerId)) @ "at index") @ string(Outer.GamePlayers.Find(ExPlayer))) @ "(") $ string(Outer.GamePlayers.Length)) @ "existing players)", 'PlayerManagement');
		ExPlayer.ViewportClient = none;
		OldIndex = RemoveLocalPlayer(ExPlayer);
		// End:0x183
		if(OldIndex != -1)
		{
			NotifyPlayerRemoved(OldIndex, ExPlayer);
		}
		// End:0x23F
		if(OldIndex != Outer.GamePlayers.Length)
		{
			I = 0;
			J0x1BB:

			// End:0x23F [Loop If]
			if(I < Outer.GamePlayers.Length)
			{
				// End:0x218
				if(I < OldIndex)
				{
					IDMappings.AddItem(I);					
				}
				else
				{
					IDMappings.AddItem(I + 1);
				}
				I++;
				// [Loop Continue]
				goto J0x1BB;
			}
		}
		// End:0x262
		if(IDMappings.Length > 0)
		{
			FixupOwnerReferences(IDMappings);
		}
		// End:0x2B3
		if(ExPlayer.Actor != none)
		{
			ExPlayer.Actor.Destroy();
		}
		LogInternal(((((((("Finished removing player " @ string(ExPlayer)) @ " with ControllerId") @ string(ExPlayer.ControllerId)) @ "at index") @ string(OldIndex)) @ "(") $ string(Outer.GamePlayers.Length)) @ "remaining players)", 'PlayerManagement');
		return true;		
	}
	else
	{
		LogInternal(((((("Not removing player" @ string(ExPlayer)) @ " with ControllerId") @ string(ExPlayer.ControllerId)) @ "because player does not have appropriate role (") $ string(GetEnum(Enum'Engine.Actor.ENetRole', int(ExPlayer.Actor.Role)))) $ ")", 'PlayerManagement');
		return false;
	}
	//return ReturnValue;	
}

final event LocalPlayer FindPlayerByControllerId(int ControllerId)
{
	local int PlayerIndex;

	PlayerIndex = 0;
	J0x0B:

	// End:0xBA [Loop If]
	if(PlayerIndex < Outer.GamePlayers.Length)
	{
		// End:0xAC
		if(Outer.GamePlayers[PlayerIndex].ControllerId == ControllerId)
		{
			return Outer.GamePlayers[PlayerIndex];
		}
		PlayerIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	return none;
	//return ReturnValue;	
}

exec function DebugCreatePlayer(int ControllerId)
{
	local string Error;

	CreatePlayer(ControllerId, Error, true);
	//return;	
}

exec function SSSwapControllers()
{
	local int Idx, TmpControllerID;

	TmpControllerID = Outer.GamePlayers[0].ControllerId;
	Idx = 0;
	J0x4A:

	// End:0x106 [Loop If]
	if(Idx < (Outer.GamePlayers.Length - 1))
	{
		Outer.GamePlayers[Idx].ControllerId = Outer.GamePlayers[Idx + 1].ControllerId;
		++Idx;
		// [Loop Continue]
		goto J0x4A;
	}
	Outer.GamePlayers[Outer.GamePlayers.Length - 1].ControllerId = TmpControllerID;
	//return;	
}

exec function DebugRemovePlayer(int ControllerId)
{
	local LocalPlayer ExPlayer;

	ExPlayer = FindPlayerByControllerId(ControllerId);
	// End:0x3F
	if(ExPlayer != none)
	{
		RemovePlayer(ExPlayer);
	}
	//return;	
}

exec function SetSplit(int Mode)
{
	SetSplitscreenConfiguration(ESplitScreenType(Mode));
	//return;	
}

exec function ShowTitleSafeArea()
{
	bShowTitleSafeZone = !bShowTitleSafeZone;
	//return;	
}

exec function SetConsoleTarget(int PlayerIndex)
{
	// End:0xB7
	if(ViewportConsole != none)
	{
		// End:0x97
		if((PlayerIndex >= 0) && PlayerIndex < Outer.GamePlayers.Length)
		{
			ViewportConsole.ConsoleTargetPlayer = Outer.GamePlayers[PlayerIndex];			
		}
		else
		{
			ViewportConsole.ConsoleTargetPlayer = none;
		}
	}
	//return;	
}

event bool Init(out string OutError)
{
	local PlayerManagerInteraction PlayerInteraction;
	local int NumCustomInteractions;
	local Class<UIInteraction> CustomInteractionClass;
	local UIInteraction CustomInteraction;
	local int Idx;

	// DebugMode: 0
	assert(Outer.ConsoleClass != none);
	ActiveSplitscreenType = DesiredSplitscreenType;
	ViewportConsole = new (self) Outer.ConsoleClass;
	// End:0xD4
	if((InsertInteraction(ViewportConsole)) == -1)
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ string(ViewportConsole);
		return false;
	}
	NumCustomInteractions = GetNumCustomInteractions();
	Idx = 0;
	J0xF3:

	// End:0x1CF [Loop If]
	if(Idx < NumCustomInteractions)
	{
		CustomInteractionClass = GetCustomInteractionClass(Idx);
		CustomInteraction = new (self) CustomInteractionClass;
		// End:0x1AE
		if((InsertInteraction(CustomInteraction)) == -1)
		{
			OutError = "Failed to add interaction to GlobalInteractions array:" @ string(CustomInteraction);
			return false;
		}
		SetCustomInteractionObject(CustomInteraction);
		Idx++;
		// [Loop Continue]
		goto J0xF3;
	}
	// DebugMode: 0
	assert(UIControllerClass != none);
	UIController = new (self) UIControllerClass;
	// End:0x266
	if((InsertInteraction(UIController)) == -1)
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ string(UIController);
		return false;
	}
	PlayerInteraction = new (self) Class'Engine.PlayerManagerInteraction';
	// End:0x2ED
	if((InsertInteraction(PlayerInteraction)) == -1)
	{
		OutError = "Failed to add interaction to GlobalInteractions array:" @ string(PlayerInteraction);
		return false;
	}
	// End:0x306
	if(bDebugNoGFxUI)
	{
		DebugSetUISystemEnabled(true, false);
	}
	return CreateInitialPlayer(OutError);
	//return ReturnValue;	
}

function bool CreateInitialPlayer(out string OutError)
{
	local int ControllerId;
	local bool bFoundInitialGamepad, bResult;

	ControllerId = 0;
	J0x0B:

	// End:0x8F [Loop If]
	if(ControllerId < 4)
	{
		// End:0x81
		if(UIController.IsLoggedIn(ControllerId))
		{
			bFoundInitialGamepad = true;
			bResult = (CreatePlayer(ControllerId, OutError, false)) != none;
			// [Explicit Break]
			goto J0x8F;
		}
		ControllerId++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8F:

	// End:0x13D
	if(!bFoundInitialGamepad || !bResult)
	{
		ControllerId = 0;
		J0xBA:

		// End:0x13D [Loop If]
		if(ControllerId < 4)
		{
			// End:0x12F
			if(UIController.IsGamepadConnected(ControllerId))
			{
				bFoundInitialGamepad = true;
				bResult = (CreatePlayer(ControllerId, OutError, false)) != none;
				// [Explicit Break]
				goto J0x13D;
			}
			ControllerId++;
			// [Loop Continue]
			goto J0xBA;
		}
	}
	J0x13D:

	// End:0x180
	if(!bFoundInitialGamepad || !bResult)
	{
		bResult = (CreatePlayer(0, OutError, false)) != none;
	}
	return bResult;
	//return ReturnValue;	
}

event int InsertInteraction(Interaction NewInteraction, optional int InIndex = -1)
{
	local int Result;

	Result = -1;
	// End:0x12C
	if(NewInteraction != none)
	{
		// End:0x4E
		if(InIndex == -1)
		{
			InIndex = GlobalInteractions.Length;
		}
		// End:0xF9
		if(InIndex >= 0)
		{
			Result = Clamp(InIndex, 0, GlobalInteractions.Length);
			GlobalInteractions.Insert(Result, 1);
			GlobalInteractions[Result] = NewInteraction;
			NewInteraction.Init();
			NewInteraction.OnInitialize();			
		}
		else
		{
			WarnInternal("Invalid insertion index specified:" @ string(InIndex));
		}
	}
	return Result;
	//return ReturnValue;	
}

event GameSessionEnded()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x5A [Loop If]
	if(I < GlobalInteractions.Length)
	{
		GlobalInteractions[I].NotifyGameSessionEnded();
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SetSplitscreenConfiguration(GameViewportClient.ESplitScreenType SplitType)
{
	DesiredSplitscreenType = SplitType;
	//return;	
}

function GameViewportClient.ESplitScreenType GetSplitscreenConfiguration()
{
	return ActiveSplitscreenType;
	//return ReturnValue;	
}

function UpdateActiveSplitscreenType()
{
	local GameViewportClient.ESplitScreenType SplitType;

	SplitType = DesiredSplitscreenType;
	switch(Outer.GamePlayers.Length)
	{
		// End:0x40
		case 0:
		// End:0x53
		case 1:
			SplitType = 0;
			// End:0xEF
			break;
		// End:0x98
		case 2:
			// End:0x95
			if((int(SplitType) != 1) && int(SplitType) != 2)
			{
				SplitType = Default2PSplitType;
			}
			// End:0xEF
			break;
		// End:0xDD
		case 3:
			// End:0xDA
			if((int(SplitType) != 3) && int(SplitType) != 4)
			{
				SplitType = Default3PSplitType;
			}
			// End:0xEF
			break;
		// End:0xFFFF
		default:
			SplitType = 5;
			// End:0xEF
			break;
			break;
	}
	ActiveSplitscreenType = SplitType;
	//return;	
}

event LayoutPlayers()
{
	local int Idx;
	local GameViewportClient.ESplitScreenType SplitType, PreviousSplitType;

	PreviousSplitType = GetSplitscreenConfiguration();
	UpdateActiveSplitscreenType();
	SplitType = GetSplitscreenConfiguration();
	Idx = 0;
	J0x3D:

	// End:0x47E [Loop If]
	if(Idx < Outer.GamePlayers.Length)
	{
		// End:0x318
		if((int(SplitType) < SplitscreenInfo.Length) && Idx < SplitscreenInfo[int(SplitType)].PlayerData.Length)
		{
			Outer.GamePlayers[Idx].Size.X = SplitscreenInfo[int(SplitType)].PlayerData[Idx].SizeX;
			Outer.GamePlayers[Idx].Size.Y = SplitscreenInfo[int(SplitType)].PlayerData[Idx].SizeY;
			Outer.GamePlayers[Idx].Origin.X = SplitscreenInfo[int(SplitType)].PlayerData[Idx].OriginX;
			Outer.GamePlayers[Idx].Origin.Y = SplitscreenInfo[int(SplitType)].PlayerData[Idx].OriginY;			
		}
		else
		{
			Outer.GamePlayers[Idx].Size.X = 0.0000000;
			Outer.GamePlayers[Idx].Size.Y = 0.0000000;
			Outer.GamePlayers[Idx].Origin.X = 0.0000000;
			Outer.GamePlayers[Idx].Origin.Y = 0.0000000;
		}
		Idx++;
		// [Loop Continue]
		goto J0x3D;
	}
	// End:0x4A3
	if(int(PreviousSplitType) != int(SplitType))
	{
		NotifySplitscreenLayoutChanged();
	}
	//return;	
}

event GetSubtitleRegion(out Vector2D MinPos, out Vector2D MaxPos)
{
	MaxPos.X = 1.0000000;
	MaxPos.Y = ((Outer.GamePlayers.Length == 1) ? 0.9000000 : 0.5000000);
	//return;	
}

final function int ConvertLocalPlayerToGamePlayerIndex(LocalPlayer LPlayer)
{
	return Outer.GamePlayers.Find(LPlayer);
	//return ReturnValue;	
}

final function bool HasTopSafeZone(int LocalPlayerIndex)
{
	switch(GetSplitscreenConfiguration())
	{
		// End:0x19
		case 0:
		// End:0x20
		case 2:
			return true;
		// End:0x25
		case 1:
		// End:0x3E
		case 3:
			return ((LocalPlayerIndex == 0) ? true : false);
		// End:0x43
		case 4:
		// End:0x5D
		case 5:
			return ((LocalPlayerIndex < 2) ? true : false);
		// End:0xFFFF
		default:
			return false;
			break;
	}
	//return ReturnValue;	
}

final function bool HasBottomSafeZone(int LocalPlayerIndex)
{
	switch(GetSplitscreenConfiguration())
	{
		// End:0x19
		case 0:
		// End:0x20
		case 2:
			return true;
		// End:0x25
		case 1:
		// End:0x3E
		case 3:
			return ((LocalPlayerIndex == 0) ? false : true);
		// End:0x43
		case 4:
		// End:0x5C
		case 5:
			return ((LocalPlayerIndex > 1) ? true : false);
		// End:0xFFFF
		default:
			return false;
			break;
	}
	//return ReturnValue;	
}

final function bool HasLeftSafeZone(int LocalPlayerIndex)
{
	switch(GetSplitscreenConfiguration())
	{
		// End:0x19
		case 0:
		// End:0x20
		case 1:
			return true;
		// End:0x39
		case 2:
			return ((LocalPlayerIndex == 0) ? true : false);
		// End:0x53
		case 3:
			return ((LocalPlayerIndex < 2) ? true : false);
		// End:0x58
		case 4:
		// End:0x83
		case 5:
			return (((LocalPlayerIndex == 0) || LocalPlayerIndex == 2) ? true : false);
		// End:0xFFFF
		default:
			return false;
			break;
	}
	//return ReturnValue;	
}

final function bool HasRightSafeZone(int LocalPlayerIndex)
{
	switch(GetSplitscreenConfiguration())
	{
		// End:0x19
		case 0:
		// End:0x20
		case 1:
			return true;
		// End:0x25
		case 2:
		// End:0x3E
		case 4:
			return ((LocalPlayerIndex > 0) ? true : false);
		// End:0x57
		case 3:
			return ((LocalPlayerIndex == 1) ? false : true);
		// End:0x82
		case 5:
			return (((LocalPlayerIndex == 0) || LocalPlayerIndex == 2) ? false : true);
		// End:0xFFFF
		default:
			return false;
			break;
	}
	//return ReturnValue;	
}

final function GetPixelSizeOfScreen(out float out_Width, out float out_Height, Canvas Canvas, int LocalPlayerIndex)
{
	switch(GetSplitscreenConfiguration())
	{
		// End:0x6B
		case 0:
			out_Width = Canvas.ClipX;
			out_Height = Canvas.ClipY;
			return;
		// End:0xC8
		case 1:
			out_Width = Canvas.ClipX;
			out_Height = Canvas.ClipY * float(2);
			return;
		// End:0x125
		case 2:
			out_Width = Canvas.ClipX * float(2);
			out_Height = Canvas.ClipY;
			return;
		// End:0x1C2
		case 3:
			// End:0x164
			if(LocalPlayerIndex == 0)
			{
				out_Width = Canvas.ClipX;				
			}
			else
			{
				out_Width = Canvas.ClipX * float(2);
			}
			out_Height = Canvas.ClipY * float(2);
			return;
		// End:0x260
		case 4:
			// End:0x202
			if(LocalPlayerIndex == 2)
			{
				out_Width = Canvas.ClipX;				
			}
			else
			{
				out_Width = Canvas.ClipX * float(2);
			}
			out_Height = Canvas.ClipY * float(2);
			return;
		// End:0x2C3
		case 5:
			out_Width = Canvas.ClipX * float(2);
			out_Height = Canvas.ClipY * float(2);
			return;
		// End:0xFFFF
		default:
			//return;
			break;
	}	
}

final function CalculateSafeZoneValues(out float out_Horizontal, out float out_Vertical, Canvas Canvas, int LocalPlayerIndex, bool bUseMaxPercent)
{
	local float ScreenWidth, ScreenHeight, XSafeZoneToUse, YSafeZoneToUse;

	XSafeZoneToUse = ((bUseMaxPercent) ? TitleSafeZone.MaxPercentX : TitleSafeZone.RecommendedPercentX);
	YSafeZoneToUse = ((bUseMaxPercent) ? TitleSafeZone.MaxPercentY : TitleSafeZone.RecommendedPercentY);
	GetPixelSizeOfScreen(ScreenWidth, ScreenHeight, Canvas, LocalPlayerIndex);
	out_Horizontal = (ScreenWidth * (float(1) - XSafeZoneToUse)) / 2.0000000;
	out_Vertical = (ScreenHeight * (float(1) - YSafeZoneToUse)) / 2.0000000;
	//return;	
}

final function bool CalculateDeadZoneForAllSides(LocalPlayer LPlayer, Canvas Canvas, out float fTopSafeZone, out float fBottomSafeZone, out float fLeftSafeZone, out float fRightSafeZone, optional bool bUseMaxPercent)
{
	local bool bHasTopSafeZone, bHasBottomSafeZone, bHasRightSafeZone, bHasLeftSafeZone;
	local int LocalPlayerIndex;
	local float HorizSafeZoneValue, VertSafeZoneValue;

	// End:0x1F4
	if(LPlayer != none)
	{
		LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
		// End:0x1F4
		if(LocalPlayerIndex != -1)
		{
			bHasTopSafeZone = HasTopSafeZone(LocalPlayerIndex);
			bHasBottomSafeZone = HasBottomSafeZone(LocalPlayerIndex);
			bHasLeftSafeZone = HasLeftSafeZone(LocalPlayerIndex);
			bHasRightSafeZone = HasRightSafeZone(LocalPlayerIndex);
			// End:0x1F4
			if(((bHasTopSafeZone || bHasBottomSafeZone) || bHasLeftSafeZone) || bHasRightSafeZone)
			{
				CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
				// End:0x14D
				if(bHasTopSafeZone)
				{
					fTopSafeZone = VertSafeZoneValue;					
				}
				else
				{
					fTopSafeZone = 0.0000000;
				}
				// End:0x17F
				if(bHasBottomSafeZone)
				{
					fBottomSafeZone = VertSafeZoneValue;					
				}
				else
				{
					fBottomSafeZone = 0.0000000;
				}
				// End:0x1B1
				if(bHasLeftSafeZone)
				{
					fLeftSafeZone = HorizSafeZoneValue;					
				}
				else
				{
					fLeftSafeZone = 0.0000000;
				}
				// End:0x1E3
				if(bHasRightSafeZone)
				{
					fRightSafeZone = HorizSafeZoneValue;					
				}
				else
				{
					fRightSafeZone = 0.0000000;
				}
				return true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

event Tick(float DeltaTime)
{
	//return;	
}

function DrawTitleSafeArea(Canvas Canvas)
{
	Canvas.SetDrawColor(255, 0, 0, 255);
	Canvas.SetPos((Canvas.ClipX * (float(1) - TitleSafeZone.MaxPercentX)) / 2.0000000, (Canvas.ClipY * (float(1) - TitleSafeZone.MaxPercentY)) / 2.0000000);
	Canvas.DrawBox(Canvas.ClipX * TitleSafeZone.MaxPercentX, Canvas.ClipY * TitleSafeZone.MaxPercentY);
	Canvas.SetDrawColor(255, 255, 0, 255);
	Canvas.SetPos((Canvas.ClipX * (float(1) - TitleSafeZone.RecommendedPercentX)) / 2.0000000, (Canvas.ClipY * (float(1) - TitleSafeZone.RecommendedPercentY)) / 2.0000000);
	Canvas.DrawBox(Canvas.ClipX * TitleSafeZone.RecommendedPercentX, Canvas.ClipY * TitleSafeZone.RecommendedPercentY);
	//return;	
}

event PostRender(Canvas Canvas)
{
	// End:0x20
	if(bShowTitleSafeZone)
	{
		DrawTitleSafeArea(Canvas);
	}
	// End:0x57
	if(ViewportConsole != none)
	{
		ViewportConsole.PostRender_Console(Canvas);
	}
	DrawTransition(Canvas);
	//return;	
}

function DisplayProgressMessage(Canvas Canvas)
{
	local int I, LineCount;
	local float FontDX, FontDY, X, Y;
	local byte Alpha;
	local float TimeLeft;

	TimeLeft = ProgressTimeOut - Class'Engine.Engine'.static.GetCurrentWorldInfo().TimeSeconds;
	Alpha = ((TimeLeft >= ProgressFadeTime) ? 255 : byte((float(255) * TimeLeft) / ProgressFadeTime));
	LineCount = 0;
	I = 0;
	J0xA0:

	// End:0xE3 [Loop If]
	if(I < 2)
	{
		// End:0xD5
		if(ProgressMessage[I] != "")
		{
			LineCount++;
		}
		I++;
		// [Loop Continue]
		goto J0xA0;
	}
	Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
	Canvas.TextSize("A", FontDX, FontDY);
	X = 0.5000000 * float(Canvas.SizeX);
	Y = 0.5000000 * float(Canvas.SizeY);
	Y -= (FontDY * (float(LineCount) / 2.0000000));
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	I = 0;
	J0x288:

	// End:0x3CF [Loop If]
	if(I < 2)
	{
		// End:0x3C1
		if(ProgressMessage[I] != "")
		{
			Canvas.DrawColor.A = Alpha;
			Canvas.TextSize(ProgressMessage[I], FontDX, FontDY);
			Canvas.SetPos(X - (FontDX / 2.0000000), Y);
			Canvas.DrawText(ProgressMessage[I]);
			Y += FontDY;
		}
		I++;
		// [Loop Continue]
		goto J0x288;
	}
	//return;	
}

function DrawTransition(Canvas Canvas)
{
	switch(Outer.TransitionType)
	{
		// End:0x4C
		case 2:
			DrawTransitionMessage(Canvas, LoadingMessage);
			// End:0xDF
			break;
		// End:0x70
		case 3:
			DrawTransitionMessage(Canvas, SavingMessage);
			// End:0xDF
			break;
		// End:0x94
		case 4:
			DrawTransitionMessage(Canvas, ConnectingMessage);
			// End:0xDF
			break;
		// End:0xB8
		case 5:
			DrawTransitionMessage(Canvas, PrecachingMessage);
			// End:0xDF
			break;
		// End:0xDC
		case 1:
			DrawTransitionMessage(Canvas, PausedMessage);
			// End:0xDF
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function DrawTransitionMessage(Canvas Canvas, string Message)
{
	local float XL, YL;

	Canvas.Font = Class'Engine.Engine'.static.GetLargeFont();
	Canvas.bCenter = false;
	Canvas.StrLen(Message, XL, YL);
	Canvas.SetPos((0.5000000 * (Canvas.ClipX - XL)) + float(1), ((0.6600000 * Canvas.ClipY) - (YL * 0.5000000)) + float(1));
	Canvas.SetDrawColor(0, 0, 0);
	Canvas.DrawText(Message, false);
	Canvas.SetPos(0.5000000 * (Canvas.ClipX - XL), (0.6600000 * Canvas.ClipY) - (YL * 0.5000000));
	Canvas.SetDrawColor(0, 0, 255);
	Canvas.DrawText(Message, false);
	//return;	
}

final function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
	local int InteractionIndex;

	LayoutPlayers();
	InteractionIndex = 0;
	J0x15:

	// End:0x8F [Loop If]
	if(InteractionIndex < GlobalInteractions.Length)
	{
		// End:0x81
		if(GlobalInteractions[InteractionIndex] != none)
		{
			GlobalInteractions[InteractionIndex].NotifyPlayerAdded(PlayerIndex, AddedPlayer);
		}
		InteractionIndex++;
		// [Loop Continue]
		goto J0x15;
	}
	//return;	
}

final function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
	local int InteractionIndex;

	LayoutPlayers();
	InteractionIndex = GlobalInteractions.Length - 1;
	J0x21:

	// End:0x92 [Loop If]
	if(InteractionIndex >= 0)
	{
		// End:0x84
		if(GlobalInteractions[InteractionIndex] != none)
		{
			GlobalInteractions[InteractionIndex].NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
		}
		InteractionIndex--;
		// [Loop Continue]
		goto J0x21;
	}
	//return;	
}

private final function int AddLocalPlayer(LocalPlayer NewPlayer)
{
	local int InsertIndex;

	InsertIndex = -1;
	// End:0x79
	if(NewPlayer != none)
	{
		InsertIndex = Outer.GamePlayers.Length;
		Outer.GamePlayers[InsertIndex] = NewPlayer;
	}
	return InsertIndex;
	//return ReturnValue;	
}

private final function int RemoveLocalPlayer(LocalPlayer ExistingPlayer)
{
	local int Index;

	Index = Outer.GamePlayers.Find(ExistingPlayer);
	// End:0x72
	if(Index != -1)
	{
		Outer.GamePlayers.Remove(Index, 1);
	}
	return Index;
	//return ReturnValue;	
}

event SetProgressMessage(PlayerController.EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
	local WorldInfo WI;

	WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
	// End:0x4C
	if(int(MessageType) == 0)
	{
		ClearProgressMessages();		
	}
	else
	{
		// End:0x2E6
		if((int(MessageType) == 4) || int(MessageType) == 7)
		{
			// End:0x1AE
			if(((WI != none) && WI.NetMode == NM_Client) && WI.BeginHostMigration())
			{
				LogInternal((((((((((("(" $ string(Name)) $ ") GameViewportClient::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "MessageType=") $ string(MessageType)) @ "Message=") $ Message) @ ": host migration started.. ") $ string(WI.PeerHostMigration.HostMigrationProgress), 'DevNet');				
			}
			else
			{
				// End:0x2E3
				if(!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
				{
					LogInternal(((((((((("(" $ string(Name)) $ ") GameViewportClient::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "MessageType=") $ string(MessageType)) @ "Message=") $ Message) @ ": host migration not enabled.. handling connection error.", 'DevNet');
					NotifyConnectionError(MessageType, Message, Title);
				}
			}			
		}
		else
		{
			// End:0x36F
			if(int(MessageType) == 6)
			{
				Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages = false;
				NotifyConnectionError(MessageType, Message, Title);				
			}
			else
			{
				// End:0x3AC
				if(Title != "")
				{
					ProgressMessage[0] = Title;
					ProgressMessage[1] = Message;					
				}
				else
				{
					ProgressMessage[1] = "";
					ProgressMessage[0] = Message;
				}
			}
		}
	}
	// End:0x475
	if(!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
	{
		Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages = bIgnoreFutureNetworkMessages;
	}
	//return;	
}

function NotifyConnectionError(PlayerController.EProgressMessageType MessageType, optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
	local WorldInfo WI;

	WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
	LogInternal((((((((((((((((("(" $ string(Name)) $ ") GameViewportClient::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Title:'") $ Title) $ "'") @ "Message:'") $ Message) $ "'") @ "NetMode:'") $ string(GetEnum(Enum'Engine.WorldInfo.ENetMode', int(WI.NetMode)))) $ "'") @ "Map:'") $ WI.GetURLMap()) $ "'", 'DevNet');
	// End:0x22C
	if(WI.NetMode != NM_Standalone)
	{
		// End:0x20A
		if(WI.Game != none)
		{
			WI.Game.bHasNetworkError = true;
		}		
		ConsoleCommand("start ?failed");
	}
	//return;	
}

exec event SetProgressTime(float T)
{
	ProgressTimeOut = T + Class'Engine.Engine'.static.GetCurrentWorldInfo().TimeSeconds;
	//return;	
}

exec function ClearProgressMessages()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x3F [Loop If]
	if(I < 2)
	{
		ProgressMessage[I] = "";
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

// Export UGameViewportClient::execGetPlayerOwner(FFrame&, void* const)
native final function LocalPlayer GetPlayerOwner(int PlayerIndex);

// Export UGameViewportClient::execFixupOwnerReferences(FFrame&, void* const)
native final function FixupOwnerReferences(array<int> IDMappings);

function OnPrimaryPlayerSwitch(LocalPlayer OldPrimaryPlayer, LocalPlayer NewPrimaryPlayer)
{
	//return;	
}

function BecomePrimaryPlayer(int PlayerIndex)
{
	local array<LocalPlayer> OtherPlayers;
	local LocalPlayer PlayerOwner, NextPlayer, OriginalPrimaryPlayer;
	local int NumPlayersRemoved, I, Count;
	local array<int> IDMappings;

	// End:0x45E
	if(((UIController != none) && PlayerIndex > 0) && PlayerIndex < UIController.GetPlayerCount())
	{
		OriginalPrimaryPlayer = GetPlayerOwner(0);
		PlayerOwner = GetPlayerOwner(PlayerIndex);
		// End:0x107
		if(PlayerOwner == none)
		{
			LogInternal(("GameViewportClient:BecomePrimaryPlayer has failed to find the player owner for index" @ string(PlayerIndex)) @ "ABORTING!!!");
			return;
		}
		// End:0x3C5
		if(PlayerOwner != none)
		{
			NextPlayer = OriginalPrimaryPlayer;
			NumPlayersRemoved = 0;
			J0x134:

			// End:0x20A [Loop If]
			if((NextPlayer != none) && NextPlayer != PlayerOwner)
			{
				UIController.NotifyPlayerRemoved(0, NextPlayer);
				UIController.Outer.Outer.GamePlayers.Remove(0, 1);
				OtherPlayers.AddItem(NextPlayer);
				NextPlayer = GetPlayerOwner(0);
				NumPlayersRemoved++;
				// [Loop Continue]
				goto J0x134;
			}
			I = 0;
			J0x215:

			// End:0x29B [Loop If]
			if(I < UIController.Outer.Outer.GamePlayers.Length)
			{
				IDMappings.AddItem(I + NumPlayersRemoved);
				I++;
				// [Loop Continue]
				goto J0x215;
			}
			Count = 0;
			J0x2A6:

			// End:0x3C5 [Loop If]
			if(OtherPlayers.Length > 0)
			{
				NextPlayer = OtherPlayers[0];
				UIController.Outer.Outer.GamePlayers.AddItem(NextPlayer);
				UIController.NotifyPlayerAdded(UIController.Outer.Outer.GamePlayers.Length - 1, NextPlayer);
				OtherPlayers.Remove(0, 1);
				IDMappings.AddItem(Count);
				Count++;
				// [Loop Continue]
				goto J0x2A6;
			}
		}
		NextPlayer = GetPlayerOwner(0);
		// End:0x45E
		if(OriginalPrimaryPlayer != NextPlayer)
		{
			LayoutPlayers();
			FixupOwnerReferences(IDMappings);
			NextPlayer.Actor.ReloadProfileSettings();
			OnPrimaryPlayerSwitch(OriginalPrimaryPlayer, NextPlayer);
		}
	}
	//return;	
}

// Export UGameViewportClient::execDebugSetUISystemEnabled(FFrame&, void* const)
native function DebugSetUISystemEnabled(bool bOldUISystemActive, bool bGFxUISystemActive);

simulated event SetHardwareMouseCursorVisibility(bool bIsVisible)
{
	local Vector2D ViewportSize;

	// End:0x83
	if(bIsVisible && !bDisplayHardwareMouseCursor)
	{
		GetViewportSize(ViewportSize);
		SetMouse(int(ViewportSize.X / float(2)), int(ViewportSize.Y / float(2)));
	}
	bDisplayHardwareMouseCursor = bIsVisible;
	ForceUpdateMouseCursor(true);
	//return;	
}

defaultproperties
{
	UIControllerClass=Class'Engine.UIInteraction'
	LoadingMessage="LOADING"
	SavingMessage="SAVING"
	ConnectingMessage="CONNECTING"
	PausedMessage="PAUSED"
	PrecachingMessage="PRECACHING"
	TitleSafeZone=(MaxPercentX=0.9000000,MaxPercentY=0.9000000,RecommendedPercentX=0.8000000,RecommendedPercentY=0.8000000)
	SplitscreenInfo[0]=(PlayerData=((SizeX=1.0000000,SizeY=1.0000000,OriginX=0.0000000,OriginY=0.0000000)))
	SplitscreenInfo[1]=(PlayerData=((SizeX=1.0000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=1.0000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000)))
	SplitscreenInfo[2]=(PlayerData=((SizeX=0.5000000,SizeY=1.0000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=1.0000000,OriginX=0.5000000,OriginY=0.0000000)))
	SplitscreenInfo[3]=(PlayerData=((SizeX=1.0000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.5000000)))
	SplitscreenInfo[4]=(PlayerData=((SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.0000000),(SizeX=1.0000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000)))
	SplitscreenInfo[5]=(PlayerData=((SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.5000000)))
	Default2PSplitType=eSST_2P_HORIZONTAL
	Default3PSplitType=eSST_3P_FAVOR_TOP
	ProgressTimeOut=8.0000000
	ProgressFadeTime=1.0000000
}