class UTGameViewportClient extends UDKGameViewportClient within Engine
	transient
	config(Game);

var const localized string LevelActionMessages[6];
var const localized string UTFrontEndString;
var Font LoadingScreenMapNameFont;
var Font LoadingScreenGameTypeNameFont;
var Font LoadingScreenHintMessageFont;
var string ProgressMessageSceneClassName;

event PostRender(Canvas Canvas)
{
	local int I;
	local Engine.ETransitionType OldTransitionType;
	local AudioDevice AD;

	OldTransitionType = Outer.TransitionType;
	// End:0x2A3
	if(int(Outer.TransitionType) == int(0))
	{
		I = 0;
		J0x5C:

		// End:0x1CF [Loop If]
		if(I < Outer.GamePlayers.Length)
		{
			// End:0x1C1
			if(Outer.GamePlayers[I].Actor != none)
			{
				// End:0x1C1
				if((int(Outer.GamePlayers[I].Actor.WorldInfo.NetMode) == int(NM_Client)) && int(Outer.GamePlayers[I].Actor.Role) == int(ROLE_Authority))
				{
					Outer.TransitionType = 2;
					// [Explicit Break]
					goto J0x1CF;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x5C;
		}
		J0x1CF:

		AD = Class'Engine.Engine'.static.GetAudioDevice();
		// End:0x2A3
		if(AD != none)
		{
			// End:0x257
			if(int(Outer.TransitionType) != int(0))
			{
				AD.TransientMasterVolume = 0.0000000;				
			}
			else
			{
				// End:0x2A3
				if(AD.TransientMasterVolume == 0.0000000)
				{
					AD.TransientMasterVolume = 1.0000000;
				}
			}
		}
	}
	super(GameViewportClient).PostRender(Canvas);
	Outer.TransitionType = OldTransitionType;
	//return;	
}

function DrawTransition(Canvas Canvas)
{
	local int pos;
	local string MapName, Desc, ParseStr;
	local Class<UTGame> GameClass;
	local string HintMessage;
	local bool bAllowHints;
	local string GameClassName;

	// End:0x4EE
	if(int(Outer.TransitionType) == int(2))
	{
		bAllowHints = true;
		// End:0x8A
		if("UDKFrontEndMap" == Outer.TransitionDescription)
		{
			MapName = UTFrontEndString;
			bAllowHints = false;			
		}
		else
		{
			MapName = Outer.TransitionDescription;
		}
		Class'Engine.Engine'.static.RemoveAllOverlays();
		pos = InStr(MapName, "-");
		// End:0x12D
		if(pos != -1)
		{
			MapName = Right(MapName, (Len(MapName) - pos) - 1);
		}
		pos = InStr(MapName, "|");
		// End:0x179
		if(pos != -1)
		{
			MapName = Left(MapName, pos);
		}
		GameClass = Class<UTGame>(FindObject(Outer.TransitionGameType, Class'Core.Class'));
		Desc = "";
		// End:0x34D
		if(GameClass == none)
		{
			pos = InStr(Outer.TransitionGameType, ".");
			// End:0x34A
			if(pos != -1)
			{
				ParseStr = Right(Outer.TransitionGameType, (Len(Outer.TransitionGameType) - pos) - 1);
				pos = InStr(ParseStr, "_Content");
				// End:0x34A
				if(pos != -1)
				{
					ParseStr = Left(ParseStr, pos);
					ParseStr = "UTGame." $ ParseStr;
					GameClass = Class<UTGame>(FindObject(ParseStr, Class'Core.Class'));
					// End:0x34A
					if(GameClass != none)
					{
						Desc = GameClass.default.GameName;
					}
				}
			}			
		}
		else
		{
			Desc = GameClass.default.GameName;
		}
		Class'Engine.Engine'.static.AddOverlay(LoadingScreenGameTypeNameFont, Desc, 0.1822000, 0.4350000, 1.0000000, 1.0000000, false);
		Class'Engine.Engine'.static.AddOverlay(LoadingScreenMapNameFont, MapName, 0.1822000, 0.4600000, 2.0000000, 2.0000000, false);
		// End:0x4EB
		if(bAllowHints)
		{
			GameClassName = "";
			// End:0x453
			if(GameClass != none)
			{
				GameClassName = string(GameClass.Name);
			}
			HintMessage = LoadRandomLocalizedHintMessage(string(Class'UTGame.UTDeathmatch'.Name), GameClassName);
			// End:0x4EB
			if(Len(HintMessage) > 0)
			{
				Class'Engine.Engine'.static.AddOverlayWrapped(LoadingScreenHintMessageFont, HintMessage, 0.1822000, 0.5850000, 1.0000000, 1.0000000, 0.7000000);
			}
		}		
	}
	else
	{
		// End:0x68B
		if(int(Outer.TransitionType) == int(5))
		{
			Canvas.Font = Class'UTGame.UTHUD'.static.GetFontSizeIndex(3);
			Canvas.SetPos(0.0000000, 0.0000000);
			Canvas.SetDrawColor(0, 0, 0, 255);
			Canvas.DrawRect(float(Canvas.SizeX), float(Canvas.SizeY));
			Canvas.SetDrawColor(255, 0, 0, 255);
			Canvas.SetPos(100.0000000, 200.0000000);
			Canvas.DrawText("Precaching...");
		}
	}
	//return;	
}

function RenderHeader(Canvas Canvas)
{
	Canvas.Font = Class'UTGame.UTHUD'.static.GetFontSizeIndex(3);
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(100.0000000, 100.0000000);
	Canvas.DrawText("Tell Josh Adams if you see this");
	//return;	
}

function UpdateActiveSplitscreenType()
{
	// End:0xC2
	if((Outer.GamePlayers.Length == 0) || (Outer.GamePlayers[0].Actor != none) && Outer.GamePlayers[0].Actor.IsA('UTEntryPlayerController'))
	{
		ActiveSplitscreenType = 0;		
	}
	else
	{
		super(GameViewportClient).UpdateActiveSplitscreenType();
	}
	//return;	
}

event SetProgressMessage(PlayerController.EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
	switch(MessageType)
	{
		// End:0x42
		case 4:
			NotifyConnectionError(MessageType, Message, Title);
			// End:0xAE
			break;
		// End:0x79
		case 0:
			super(GameViewportClient).SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
			// End:0xAE
			break;
		// End:0xFFFF
		default:
			super(GameViewportClient).SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
			// End:0xAE
			break;
			break;
	}
	//return;	
}

function NotifyConnectionError(PlayerController.EProgressMessageType MessageType, optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
	local WorldInfo WI;

	WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
	LogInternal((((((((((("(" $ string(Name)) $ ") UTGameViewportClient::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Message:'") $ Message) $ "'") @ "Title:'") $ Title) $ "'");
	// End:0x16A
	if(WI.Game != none)
	{
		WI.Game.bHasNetworkError = true;
	}
	Class'UTGame.UTPlayerController'.static.SetFrontEndErrorMessage(Title, Message);
	// End:0x236
	if(UTPlayerController(Outer.GamePlayers[0].Actor) != none)
	{
		UTPlayerController(Outer.GamePlayers[0].Actor).QuitToMainMenu();		
	}
	else
	{
		Class'Engine.Engine'.static.StopMovie(true);		
		ConsoleCommand("Disconnect");
	}
	//return;	
}

defaultproperties
{
	LevelActionMessages[1]="Paused..."
	LevelActionMessages[2]="Loading..."
	LevelActionMessages[3]="Saving..."
	LevelActionMessages[4]="Connecting to..."
	LevelActionMessages[5]="Precaching..."
	UTFrontEndString="Main Menu"
	LoadingScreenMapNameFont=MultiFont'UI_Fonts_Final.menus.Fonts_AmbexHeavyOblique'
	LoadingScreenGameTypeNameFont=MultiFont'UI_Fonts_Final.menus.Fonts_AmbexHeavyOblique'
	LoadingScreenHintMessageFont=MultiFont'UI_Fonts_Final.HUD.MF_Medium'
	HintLocFileName="UTGameUI"
	UIControllerClass=Class'UTGame.UTGameInteraction'
}