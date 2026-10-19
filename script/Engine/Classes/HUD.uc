class HUD extends Actor
	transient
	native
	config(Game)
	notplaceable;

struct native ConsoleMessage
{
	var string Text;
	var Color TextColor;
	var float MessageLife;
	var PlayerReplicationInfo PRI;

	structdefaultproperties
	{
		Text=""
		TextColor=(R=0,G=0,B=0,A=0)
		MessageLife=0.0000000
		PRI=none
	}
};

struct native HudLocalizedMessage
{
	var Class<LocalMessage> Message;
	var string StringMessage;
	var int Switch;
	var float EndOfLife;
	var float Lifetime;
	var float PosY;
	var Color DrawColor;
	var int FontSize;
	var Font StringFont;
	var float DX;
	var float DY;
	var bool Drawn;
	var int Count;
	var Object OptionalObject;

	structdefaultproperties
	{
		Message=none
		StringMessage=""
		Switch=0
		EndOfLife=0.0000000
		Lifetime=0.0000000
		PosY=0.0000000
		DrawColor=(R=0,G=0,B=0,A=0)
		FontSize=0
		StringFont=none
		DX=0.0000000
		DY=0.0000000
		Drawn=false
		Count=0
		OptionalObject=none
	}
};

struct native KismetDrawTextInfo
{
	var string MessageText;
	var string AppendedText;
	var Font MessageFont;
	var Vector2D MessageFontScale;
	var Vector2D MessageOffset;
	var Color MessageColor;
	var float MessageEndTime;

	structdefaultproperties
	{
		MessageText=""
		AppendedText=""
		MessageFont=none
		MessageFontScale=(X=0.0000000,Y=0.0000000)
		MessageOffset=(X=0.0000000,Y=0.0000000)
		MessageColor=(R=0,G=0,B=0,A=0)
		MessageEndTime=0.0000000
	}
};

var const Color WhiteColor;
var const Color GreenColor;
var const Color RedColor;
var PlayerController PlayerOwner;
var transient bool bLostFocusPaused;
var config bool bShowHUD;
var bool bShowScores;
var bool bShowDebugInfo;
var bool bShowBadConnectionAlert;
var config bool bShowDirectorInfoDebug;
var config bool bShowDirectorInfoHUD;
var globalconfig bool bMessageBeep;
var bool bShowOverlays;
var globalconfig float HudCanvasScale;
var array<Actor> PostRenderedActors;
var array<ConsoleMessage> ConsoleMessages;
var const Color ConsoleColor;
var config int ConsoleMessageCount;
var globalconfig int ConsoleFontSize;
var globalconfig int MessageFontOffset;
var int MaxHUDAreaMessageCount;
var transient HudLocalizedMessage LocalMessages[8];
var float ConsoleMessagePosX;
var float ConsoleMessagePosY;
var Canvas Canvas;
var transient float LastHUDRenderTime;
var transient float RenderDelta;
var transient float SizeX;
var transient float SizeY;
var transient float CenterX;
var transient float CenterY;
var transient float RatioX;
var transient float RatioY;
var globalconfig array<config name> DebugDisplay;
var array<KismetDrawTextInfo> KismetTextInfo;

// Export UHUD::execDraw3DLine(FFrame&, void* const)
native final function Draw3DLine(Vector Start, Vector End, Color LineColor);

// Export UHUD::execDraw2DLine(FFrame&, void* const)
native final function Draw2DLine(int X1, int Y1, int X2, int Y2, Color LineColor);

event PostBeginPlay()
{
	super.PostBeginPlay();
	PlayerOwner = PlayerController(Owner);
	NotifyBindPostProcessEffects();
	//return;	
}

// Export UHUD::execDrawActorOverlays(FFrame&, void* const)
native function DrawActorOverlays(Vector ViewPoint, Rotator ViewRotation);

function RemovePostRenderedActor(Actor A)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x69 [Loop If]
	if(I < PostRenderedActors.Length)
	{
		// End:0x5B
		if(PostRenderedActors[I] == A)
		{
			PostRenderedActors[I] = none;
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function AddPostRenderedActor(Actor A)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x54 [Loop If]
	if(I < PostRenderedActors.Length)
	{
		// End:0x46
		if(PostRenderedActors[I] == A)
		{
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	I = 0;
	J0x5F:

	// End:0xBD [Loop If]
	if(I < PostRenderedActors.Length)
	{
		// End:0xAF
		if(PostRenderedActors[I] == none)
		{
			PostRenderedActors[I] = A;
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x5F;
	}
	PostRenderedActors[PostRenderedActors.Length] = A;
	//return;	
}

exec function ToggleHUD()
{
	bShowHUD = !bShowHUD;
	//return;	
}

exec function ShowHUD()
{
	ToggleHUD();
	//return;	
}

exec function ShowScores()
{
	SetShowScores(!bShowScores);
	//return;	
}

exec function SetShowScores(bool bNewValue)
{
	bShowScores = bNewValue;
	//return;	
}

exec function ShowDebug(optional name DebugType)
{
	local bool bRemoved;

	// End:0x32
	if(DebugType == 'None')
	{
		bShowDebugInfo = !bShowDebugInfo;		
	}
	else
	{
		// End:0x6B
		if(bShowDebugInfo)
		{
			// End:0x6B
			if(-1 != DebugDisplay.RemoveItem(DebugType))
			{
				bRemoved = true;
			}
		}
		// End:0x98
		if(!bRemoved)
		{
			DebugDisplay[DebugDisplay.Length] = DebugType;
		}
		bShowDebugInfo = true;
		SaveConfig();
	}
	//return;	
}

function bool ShouldDisplayDebug(name DebugType)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x54 [Loop If]
	if(I < DebugDisplay.Length)
	{
		// End:0x46
		if(DebugDisplay[I] == DebugType)
		{
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

exec function ToggleDirectorInfoHUD()
{
	bShowDirectorInfoHUD = !bShowDirectorInfoHUD;
	//return;	
}

exec function ToggleDirectorInfoDebug()
{
	bShowDirectorInfoDebug = !bShowDirectorInfoDebug;
	//return;	
}

function ShowDebugInfo(out float out_YL, out float out_YPos)
{
	PlayerOwner.ViewTarget.DisplayDebug(self, out_YL, out_YPos);
	// End:0xA4
	if(ShouldDisplayDebug('Game'))
	{
		WorldInfo.Game.DisplayDebug(self, out_YL, out_YPos);
	}
	// End:0x11A
	if((ShouldDisplayDebug('AI')) && Pawn(PlayerOwner.ViewTarget) != none)
	{
		DrawRoute(Pawn(PlayerOwner.ViewTarget));
	}
	//return;	
}

function DrawRoute(Pawn Target)
{
	local int I;
	local Controller C;
	local Vector Start, RealStart, Dest;
	local bool bPath;
	local Actor FirstRouteCache;
	local Pylon FoundPylon;

	C = Target.Controller;
	// End:0x39
	if(C == none)
	{
		return;
	}
	// End:0xB2
	if(C.CurrentPath != none)
	{
		Start = C.CurrentPath.Start.Location;		
	}
	else
	{
		Start = Target.Location;
	}
	RealStart = Start;
	// End:0x1A6
	if(C.bAdjusting)
	{
		Draw3DLine(C.Pawn.Location, C.GetAdjustLocation(), MakeColor(255, 0, 255, 255));
		Start = C.GetAdjustLocation();
	}
	Dest = C.GetDestinationPosition();
	// End:0x207
	foreach WorldInfo.AllNavigationPoints(Class'Engine.Pylon', FoundPylon)
	{
		// End:0x207
		break;		
	}	
	// End:0x444
	if(FoundPylon != none)
	{
		// End:0x270
		if(C.NavigationHandle == none)
		{
			C.NavigationHandle = new (C) Class'Engine.NavigationHandle';
		}
		Class'Engine.NavMeshPath_Toward'.static.TowardPoint(C.NavigationHandle, Dest);
		Class'Engine.NavMeshGoal_At'.static.AtLocation(C.NavigationHandle, Dest);
		C.NavigationHandle.bVisualPathDebugging = true;
		// End:0x3CE
		if(C.NavigationHandle.FindPath())
		{
			DrawDebugCoordinateSystem(Dest, rot(0, 0, 0), 25.0000000, true);
			C.NavigationHandle.DrawPathCache(,, true);			
		}
		else
		{
			DrawDebugCoordinateSystem(Dest, rot(0, 0, 0), 25.0000000, true);
			DrawDebugBox(Target.Location, Target.GetCollisionExtent(), 255, 0, 0, true);
		}
		return;
	}
	// End:0x493
	if(C.RouteCache.Length > 0)
	{
		FirstRouteCache = C.RouteCache[0];
	}
	// End:0x762
	if((C == PlayerOwner) || (C.MoveTarget == FirstRouteCache) && C.MoveTarget != none)
	{
		// End:0x5D3
		if((C == PlayerOwner) && Dest != vect(0.0000000, 0.0000000, 0.0000000))
		{
			// End:0x5B0
			if(C.PointReachable(Dest))
			{
				Draw3DLine(C.Pawn.Location, Dest, MakeColor(255, 255, 255, 255));
				return;
			}
			C.FindPathTo(Dest);
		}
		// End:0x75F
		if(C.RouteCache.Length > 0)
		{
			I = 0;
			J0x603:

			// End:0x724 [Loop If]
			if(I < C.RouteCache.Length)
			{
				// End:0x661
				if(C.RouteCache[I] == none)
				{
					// [Explicit Break]
					goto J0x724;
				}
				bPath = true;
				Draw3DLine(Start, C.RouteCache[I].Location, MakeColor(0, 255, 0, 255));
				Start = C.RouteCache[I].Location;
				I++;
				// [Loop Continue]
				goto J0x603;
			}
			J0x724:

			// End:0x75F
			if(bPath)
			{
				Draw3DLine(RealStart, Dest, MakeColor(255, 255, 255, 255));
			}
		}		
	}
	else
	{
		// End:0x7C0
		if(Target.Velocity != vect(0.0000000, 0.0000000, 0.0000000))
		{
			Draw3DLine(RealStart, Dest, MakeColor(255, 255, 255, 255));
		}
	}
	// End:0x7D9
	if(C == PlayerOwner)
	{
		return;
	}
	Draw3DLine(Target.Location + (Target.BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000)), C.GetFocalPoint(), MakeColor(255, 0, 0, 255));
	//return;	
}

function PreCalcValues()
{
	SizeX = float(Canvas.SizeX);
	SizeY = float(Canvas.SizeY);
	CenterX = SizeX * 0.5000000;
	CenterY = SizeY * 0.5000000;
	RatioX = SizeX / 1024.0000000;
	RatioY = SizeY / 768.0000000;
	//return;	
}

event PostRender()
{
	local float XL, YL, YPos;

	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
	// End:0x9B
	if((SizeX != float(Canvas.SizeX)) || SizeY != float(Canvas.SizeY))
	{
		PreCalcValues();
	}
	// End:0xE5
	if(PlayerOwner != none)
	{
		PlayerOwner.DrawDebugTextList(Canvas, RenderDelta);
		DrawGwNavDebug();
	}
	// End:0x1BA
	if(bShowDebugInfo)
	{
		Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
		Canvas.DrawColor = ConsoleColor;
		Canvas.StrLen("X", XL, YL);
		YPos = 0.0000000;
		ShowDebugInfo(YL, YPos);		
	}
	else
	{
		// End:0x1FE
		if(bShowHUD)
		{
			// End:0x1FE
			if(!bShowScores)
			{
				DrawHUD();
				DisplayConsoleMessages();
				DisplayLocalMessages();
				DisplayKismetMessages();
			}
		}
	}
	// End:0x215
	if(bShowBadConnectionAlert)
	{
		DisplayBadConnectionAlert();
	}
	LastHUDRenderTime = WorldInfo.TimeSeconds;
	//return;	
}

// Export UHUD::execDrawGwNavDebug(FFrame&, void* const)
native function DrawGwNavDebug();

function DrawHUD()
{
	local Vector ViewPoint;
	local Rotator ViewRotation;

	// End:0x95
	if(bShowOverlays && PlayerOwner != none)
	{
		Canvas.Font = GetFontSizeIndex(0);
		PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
		DrawActorOverlays(ViewPoint, ViewRotation);
	}
	PlayerOwner.DrawHUD(self);
	//return;	
}

function DisplayBadConnectionAlert()
{
	//return;	
}

function ClearMessage(out HudLocalizedMessage M)
{
	M.Message = none;
	M.StringFont = none;
	//return;	
}

function Message(PlayerReplicationInfo PRI, coerce string msg, name MsgType, optional float Lifetime)
{
	local string ThePlayerName;

	// End:0x2D
	if(bMessageBeep)
	{
		PlayerOwner.PlayBeepSound();
	}
	// End:0xBC
	if((MsgType == 'Say') || MsgType == 'TeamSay')
	{
		ThePlayerName = ((PRI != none) ? PRI.PlayerName : "");
		msg = (ThePlayerName $ ": ") $ msg;
	}
	AddConsoleMessage(msg, Class'Engine.LocalMessage', PRI, Lifetime);
	//return;	
}

function DisplayConsoleMessages()
{
	local int Idx, XPos, YPos;
	local float XL, YL;

	// End:0x12
	if(ConsoleMessages.Length == 0)
	{
		return;
	}
	Idx = 0;
	J0x1D:

	// End:0xD2 [Loop If]
	if(Idx < ConsoleMessages.Length)
	{
		// End:0xC4
		if((ConsoleMessages[Idx].Text == "") || ConsoleMessages[Idx].MessageLife < WorldInfo.TimeSeconds)
		{
			ConsoleMessages.Remove(Idx--, 1);
		}
		Idx++;
		// [Loop Continue]
		goto J0x1D;
	}
	XPos = int(((ConsoleMessagePosX * HudCanvasScale) * float(Canvas.SizeX)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeX)));
	YPos = int(((ConsoleMessagePosY * HudCanvasScale) * float(Canvas.SizeY)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeY)));
	Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
	Canvas.DrawColor = ConsoleColor;
	Canvas.TextSize("A", XL, YL);
	YPos -= int(YL * float(ConsoleMessages.Length));
	YPos -= int(YL);
	Idx = 0;
	J0x2AD:

	// End:0x45A [Loop If]
	if(Idx < ConsoleMessages.Length)
	{
		// End:0x2F5
		if(ConsoleMessages[Idx].Text == "")
		{			
		}
		else
		{
			// End:0x31B
			if((ShouldShowConsoleMessage(ConsoleMessages[Idx])) == false)
			{				
			}
			else
			{
				Canvas.StrLen(ConsoleMessages[Idx].Text, XL, YL);
				Canvas.SetPos(float(XPos), float(YPos));
				Canvas.DrawColor = ConsoleMessages[Idx].TextColor;
				Canvas.DrawText(ConsoleMessages[Idx].Text, false);
				YPos += int(YL);
			}
		}
		Idx++;
		// [Loop Continue]
		goto J0x2AD;
	}
	//return;	
}

function bool ShouldShowConsoleMessage(const ConsoleMessage InConsoleMessage)
{
	return true;
	//return ReturnValue;	
}

function AddConsoleMessage(string M, Class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
	local int Idx, MsgIdx;

	MsgIdx = -1;
	// End:0x60
	if(bMessageBeep && InMessageClass.default.bBeep)
	{
		PlayerOwner.PlayBeepSound();
	}
	// End:0x8F
	if(ConsoleMessages.Length < ConsoleMessageCount)
	{
		MsgIdx = ConsoleMessages.Length;		
	}
	else
	{
		Idx = 0;
		J0x9A:

		// End:0x115 [Loop If]
		if((Idx < ConsoleMessages.Length) && MsgIdx == -1)
		{
			// End:0x107
			if(ConsoleMessages[Idx].Text == "")
			{
				MsgIdx = Idx;
			}
			Idx++;
			// [Loop Continue]
			goto J0x9A;
		}
	}
	// End:0x1B4
	if((MsgIdx == ConsoleMessageCount) || MsgIdx == -1)
	{
		Idx = 0;
		J0x14C:

		// End:0x19E [Loop If]
		if(Idx < (ConsoleMessageCount - 1))
		{
			ConsoleMessages[Idx] = ConsoleMessages[Idx + 1];
			Idx++;
			// [Loop Continue]
			goto J0x14C;
		}
		MsgIdx = ConsoleMessageCount - 1;
	}
	// End:0x1E3
	if(MsgIdx >= ConsoleMessages.Length)
	{
		ConsoleMessages.Length = MsgIdx + 1;
	}
	ConsoleMessages[MsgIdx].Text = M;
	// End:0x279
	if(Lifetime != 0.0000000)
	{
		ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + Lifetime;		
	}
	else
	{
		ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + InMessageClass.default.Lifetime;
	}
	ConsoleMessages[MsgIdx].TextColor = InMessageClass.static.GetConsoleColor(PRI);
	ConsoleMessages[MsgIdx].PRI = PRI;
	//return;	
}

function LocalizedMessage(Class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
	local int I, LocalMessagesArrayCount, MessageCount;

	// End:0x24
	if((InMessageClass == none) || CriticalString == "")
	{
		return;
	}
	// End:0x74
	if(bMessageBeep && InMessageClass.default.bBeep)
	{
		PlayerOwner.PlayBeepSound();
	}
	// End:0xC0
	if(!InMessageClass.default.bIsSpecial)
	{
		AddConsoleMessage(CriticalString, InMessageClass, RelatedPRI_1);
		return;
	}
	LocalMessagesArrayCount = 8;
	I = LocalMessagesArrayCount;
	// End:0x226
	if(InMessageClass.default.bIsUnique)
	{
		I = 0;
		J0x10C:

		// End:0x223 [Loop If]
		if(I < LocalMessagesArrayCount)
		{
			// End:0x215
			if(LocalMessages[I].Message == InMessageClass)
			{
				// End:0x212
				if(InMessageClass.default.bCountInstances && LocalMessages[I].StringMessage ComplementEqual CriticalString)
				{
					MessageCount = ((LocalMessages[I].Count == 0) ? 2 : LocalMessages[I].Count + 1);
				}
				// [Explicit Break]
				goto J0x223;
			}
			I++;
			// [Loop Continue]
			goto J0x10C;
		}
		J0x223:
		
	}
	else
	{
		// End:0x331
		if(InMessageClass.default.bIsPartiallyUnique)
		{
			I = 0;
			J0x253:

			// End:0x331 [Loop If]
			if(I < LocalMessagesArrayCount)
			{
				// End:0x323
				if((LocalMessages[I].Message == InMessageClass) && InMessageClass.static.PartiallyDuplicates(Switch, LocalMessages[I].Switch, OptionalObject, LocalMessages[I].OptionalObject))
				{
					// [Explicit Break]
					goto J0x331;
				}
				I++;
				// [Loop Continue]
				goto J0x253;
			}
		}
	}
	J0x331:

	// End:0x3A7
	if(I == LocalMessagesArrayCount)
	{
		I = 0;
		J0x353:

		// End:0x3A7 [Loop If]
		if(I < LocalMessagesArrayCount)
		{
			// End:0x399
			if(LocalMessages[I].Message == none)
			{
				// [Explicit Break]
				goto J0x3A7;
			}
			I++;
			// [Loop Continue]
			goto J0x353;
		}
	}
	J0x3A7:

	// End:0x41B
	if(I == LocalMessagesArrayCount)
	{
		I = 0;
		J0x3C9:

		// End:0x41B [Loop If]
		if(I < (LocalMessagesArrayCount - 1))
		{
			LocalMessages[I] = LocalMessages[I + 1];
			I++;
			// [Loop Continue]
			goto J0x3C9;
		}
	}
	ClearMessage(LocalMessages[I]);
	AddLocalizedMessage(I, InMessageClass, CriticalString, Switch, Position, Lifetime, FontSize, DrawColor, MessageCount, OptionalObject);
	//return;	
}

function AddLocalizedMessage(int Index, Class<LocalMessage> InMessageClass, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional int MessageCount, optional Object OptionalObject)
{
	LocalMessages[Index].Message = InMessageClass;
	LocalMessages[Index].Switch = Switch;
	LocalMessages[Index].EndOfLife = Lifetime + WorldInfo.TimeSeconds;
	LocalMessages[Index].StringMessage = CriticalString;
	LocalMessages[Index].Lifetime = Lifetime;
	LocalMessages[Index].PosY = Position;
	LocalMessages[Index].DrawColor = DrawColor;
	LocalMessages[Index].FontSize = FontSize;
	LocalMessages[Index].Count = MessageCount;
	LocalMessages[Index].OptionalObject = OptionalObject;
	//return;	
}

function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage)
{
	ScreenX = 0.5000000 * Canvas.ClipX;
	ScreenY = ((PosY * HudCanvasScale) * Canvas.ClipY) + (((1.0000000 - HudCanvasScale) * 0.5000000) * Canvas.ClipY);
	ScreenX -= (InMessage.DX * 0.5000000);
	ScreenY -= (InMessage.DY * 0.5000000);
	//return;	
}

function DrawMessage(int I, float PosY, out float DX, out float DY)
{
	local float FadeValue, ScreenX, ScreenY;

	FadeValue = FMin(1.0000000, LocalMessages[I].EndOfLife - WorldInfo.TimeSeconds);
	Canvas.DrawColor = LocalMessages[I].DrawColor;
	Canvas.DrawColor.A = byte(FadeValue * float(Canvas.DrawColor.A));
	Canvas.Font = LocalMessages[I].StringFont;
	GetScreenCoords(PosY, ScreenX, ScreenY, LocalMessages[I]);
	DX = LocalMessages[I].DX / Canvas.ClipX;
	DY = LocalMessages[I].DY / Canvas.ClipY;
	DrawMessageText(LocalMessages[I], ScreenX, ScreenY);
	LocalMessages[I].Drawn = true;
	//return;	
}

function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
	local FontRenderInfo FontInfo;

	Canvas.SetPos(ScreenX, ScreenY);
	FontInfo.bClipText = true;
	Canvas.DrawText(LocalMessage.StringMessage, false,,, FontInfo);
	//return;	
}

function DisplayLocalMessages()
{
	local float PosY, DY, DX;
	local int I, J, LocalMessagesArrayCount, AreaMessageCount;
	local float FadeValue;
	local int FontSize;

	// End:0x26
	if(LocalMessages[0].Message == none)
	{
		return;
	}
	Canvas.Reset(true);
	LocalMessagesArrayCount = 8;
	I = 0;
	J0x5D:

	// End:0x428 [Loop If]
	if(I < LocalMessagesArrayCount)
	{
		// End:0xA3
		if(LocalMessages[I].Message == none)
		{
			// [Explicit Break]
			goto J0x428;
		}
		LocalMessages[I].Drawn = false;
		// End:0x327
		if(LocalMessages[I].StringFont == none)
		{
			FontSize = LocalMessages[I].FontSize + MessageFontOffset;
			LocalMessages[I].StringFont = GetFontSizeIndex(FontSize);
			Canvas.Font = LocalMessages[I].StringFont;
			Canvas.TextSize(LocalMessages[I].StringMessage, DX, DY);
			LocalMessages[I].DX = DX;
			LocalMessages[I].DY = DY;
			// End:0x327
			if(LocalMessages[I].StringFont == none)
			{
				J = I;
				J0x2AA:

				// End:0x2FC [Loop If]
				if(J < (LocalMessagesArrayCount - 1))
				{
					LocalMessages[J] = LocalMessages[J + 1];
					J++;
					// [Loop Continue]
					goto J0x2AA;
				}
				ClearMessage(LocalMessages[J]);
				I--;
				// [Explicit Continue]
				goto J0x41A;
			}
		}
		FadeValue = LocalMessages[I].EndOfLife - WorldInfo.TimeSeconds;
		// End:0x41A
		if(FadeValue <= 0.0000000)
		{
			J = I;
			J0x39D:

			// End:0x3EF [Loop If]
			if(J < (LocalMessagesArrayCount - 1))
			{
				LocalMessages[J] = LocalMessages[J + 1];
				J++;
				// [Loop Continue]
				goto J0x39D;
			}
			ClearMessage(LocalMessages[J]);
			I--;			
		}
		J0x41A:

		I++;
		// [Loop Continue]
		goto J0x5D;
	}
	J0x428:

	I = 0;
	J0x433:

	// End:0x650 [Loop If]
	if(I < LocalMessagesArrayCount)
	{
		// End:0x479
		if(LocalMessages[I].Message == none)
		{
			// [Explicit Break]
			goto J0x650;
		}
		// End:0x4A6
		if(LocalMessages[I].Drawn)
		{			
		}
		else
		{
			PosY = LocalMessages[I].PosY;
			AreaMessageCount = 0;
			J = I;
			J0x4F4:

			// End:0x5E6 [Loop If]
			if(J < LocalMessagesArrayCount)
			{
				// End:0x58B
				if(LocalMessages[J].Drawn || LocalMessages[I].PosY != LocalMessages[J].PosY)
				{					
				}
				else
				{
					DrawMessage(J, PosY, DX, DY);
					PosY += DY;
					AreaMessageCount++;
				}
				J++;
				// [Loop Continue]
				goto J0x4F4;
			}
			// End:0x642
			if(AreaMessageCount > MaxHUDAreaMessageCount)
			{
				LocalMessages[I].EndOfLife = WorldInfo.TimeSeconds;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x433;
	}
	J0x650:

	//return;	
}

function DisplayKismetMessages()
{
	local int KismetTextIdx;

	KismetTextIdx = 0;
	J0x0B:

	// End:0x1B3 [Loop If]
	if(KismetTextIdx < KismetTextInfo.Length)
	{
		// End:0xB4
		if((KismetTextInfo[KismetTextIdx].MessageEndTime > float(0)) && KismetTextInfo[KismetTextIdx].MessageEndTime <= WorldInfo.TimeSeconds)
		{
			KismetTextInfo.Remove(KismetTextIdx, 1);			
		}
		else
		{
			DrawText(KismetTextInfo[KismetTextIdx].MessageText $ KismetTextInfo[KismetTextIdx].AppendedText, KismetTextInfo[KismetTextIdx].MessageOffset, KismetTextInfo[KismetTextIdx].MessageFont, KismetTextInfo[KismetTextIdx].MessageFontScale, KismetTextInfo[KismetTextIdx].MessageColor);
			++KismetTextIdx;
		}
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function DrawText(string Text, Vector2D Position, Font TextFont, Vector2D FontScale, Color TextColor, const optional out FontRenderInfo RenderInfo)
{
	local float XL, YL;

	Canvas.Font = TextFont;
	Canvas.TextSize(Text, XL, YL);
	Canvas.SetPos(((Canvas.ClipX / float(2)) - (XL / float(2))) + Position.X, ((Canvas.ClipY / float(3)) - (YL / float(2))) + Position.Y);
	Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);
	Canvas.super(HUD).DrawText(Text, false, FontScale.X, FontScale.Y, RenderInfo);
	//return;	
}

static function Font GetFontSizeIndex(int FontSize)
{
	// End:0x32
	if(FontSize == 0)
	{
		return Class'Engine.Engine'.static.GetTinyFont();		
	}
	else
	{
		// End:0x64
		if(FontSize == 1)
		{
			return Class'Engine.Engine'.static.GetSmallFont();			
		}
		else
		{
			// End:0x97
			if(FontSize == 2)
			{
				return Class'Engine.Engine'.static.GetMediumFont();				
			}
			else
			{
				// End:0xCA
				if(FontSize == 3)
				{
					return Class'Engine.Engine'.static.GetLargeFont();					
				}
				else
				{
					return Class'Engine.Engine'.static.GetLargeFont();
				}
			}
		}
	}
	//return ReturnValue;	
}

function PlayerOwnerDied()
{
	//return;	
}

function NotifyBindPostProcessEffects()
{
	//return;	
}

event OnLostFocusPause(bool bEnable)
{
	// End:0x1B
	if(bLostFocusPaused == bEnable)
	{
		return;
	}
	// End:0x83
	if(int(WorldInfo.NetMode) != int(NM_Client))
	{
		bLostFocusPaused = bEnable;
		PlayerOwner.SetPause(bEnable);
	}
	//return;	
}

defaultproperties
{
	WhiteColor=(R=255,G=255,B=255,A=255)
	GreenColor=(R=255,G=0,B=255,A=0)
	RedColor=(R=0,G=255,B=255,A=0)
	bShowHUD=true
	bMessageBeep=true
	HudCanvasScale=0.9500000
	ConsoleColor=(R=216,G=153,B=255,A=253)
	ConsoleMessageCount=4
	ConsoleFontSize=5
	MaxHUDAreaMessageCount=3
	ConsoleMessagePosY=0.8000000
	DebugDisplay[0]="AI"
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	TickGroup=ETickingGroup.TG_DuringAsyncWork
	bHidden=true
}