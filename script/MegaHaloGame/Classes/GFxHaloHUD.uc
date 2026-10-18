class GFxHaloHUD extends GFxHaloHUDBase
	transient
	config(Game);

var GFxTransitionScreen Screen;
var GFxHaloVehicleCustomizationMenu VCMovie;
var GFxHaloBlokConstructionMenu BCMovie;
var GFxHaloMinimapHUD HudMovie;
var GFxProjectedUI InventoryMovie;
var Class<GFxHaloMinimapHUD> MinimapHUDClass;

exec function MinimapZoomIn()
{
	HudMovie.MinimapZoomIn();
	//return;	
}

exec function MinimapZoomOut()
{
	HudMovie.MinimapZoomOut();
	//return;	
}

singular event Destroyed()
{
	RemoveMovies();
	super(Actor).Destroyed();
	//return;	
}

function ToggleUIVisible()
{
	bVisible = bVisible!;
	SetMenuVisible(HudMovie);
	SetMenuVisible(VCMovie);
	SetMenuVisible(BCMovie);
	SetMenuVisible(PauseMenu);
	//return;	
}

function RemoveMovies()
{
	// End:0x3A
	if(HudMovie != none)
	{
		HudMovie.Close(true);
		HudMovie = none;
	}
	// End:0x74
	if(InventoryMovie != none)
	{
		InventoryMovie.Close(true);
		InventoryMovie = none;
	}
	// End:0xAE
	if(VCMovie != none)
	{
		VCMovie.Close(true);
		VCMovie = none;
	}
	// End:0xE8
	if(BCMovie != none)
	{
		BCMovie.Close(true);
		BCMovie = none;
	}
	// End:0x122
	if(Screen != none)
	{
		Screen.Close(true);
		Screen = none;
	}
	super.RemoveMovies();
	//return;	
}

simulated function PostBeginPlay()
{
	local HaloVehicle HV;

	super(UTHUDBase).PostBeginPlay();
	CreateHUDMovie();
	// End:0x56
	foreach UTPlayerOwner.AllActors(Class'MegaHaloGame.HaloVehicle', HV)
	{
		AddPostRenderedActor(HV);		
	}	
	//return;	
}

function CreateHUDMovie()
{
	HudMovie = new MinimapHUDClass;
	HudMovie.SetTimingMode(1);
	HudMovie.Init(Class'Engine.Engine'.static.GetEngine().GamePlayers[HudMovie.LocalPlayerOwnerIndex]);
	HudMovie.InitToHUD(self);
	HudMovie.ToggleCrosshair(true);
	//return;	
}

function InitializeScreen()
{
	// End:0x47
	if(Screen == none)
	{
		Screen = new Class'MegaHaloGame.GFxTransitionScreen';
		Screen.ExternalInterface = self;
	}
	Screen.Init(LocalPlayer(PlayerOwner.Player));
	//return;	
}

function FadeScreenToBlack(float FadeTime)
{
	InitializeScreen();
	Screen.FadeToBlack(FadeTime);
	//return;	
}

function FadeScreenToClear(float FadeTime)
{
	InitializeScreen();
	Screen.FadeToClear(FadeTime);
	//return;	
}

function bool ScreenIsFading()
{
	// End:0x2F
	if(Screen != none)
	{
		return Screen.bFading;
	}
	return false;
	//return ReturnValue;	
}

function bool ScreenIsBlack()
{
	// End:0x3A
	if(Screen != none)
	{
		// End:0x3A
		if(Screen.GetScreenAlpha() >= 100.0000000)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool ScreenIsClear()
{
	// End:0x3A
	if(Screen != none)
	{
		// End:0x3A
		if(Screen.GetScreenAlpha() > 0.0000000)
		{
			return false;
		}
	}
	return true;
	//return ReturnValue;	
}

function DoneFading()
{
	// End:0x3A
	if(Screen != none)
	{
		Screen.Close();
		Screen = none;
	}
	//return;	
}

function ToggleVCMenu()
{
	// End:0x55
	if((VCMovie != none) && VCMovie.bMovieIsOpen)
	{
		VCMovie.CloseMenu();		
	}
	else
	{
		// End:0x7C
		if(VCMovie == none)
		{
			VCMovie = new Class'MegaHaloGame.GFxHaloVehicleCustomizationMenu';
		}
		VCMovie.PC = HaloPlayerPawnController(PlayerOwner);
		VCMovie.Init(LocalPlayer(PlayerOwner.Player));
		SetMenuVisible(VCMovie);
		SetVisible(false);
		bPauseMenuEnabled = false;
	}
	//return;	
}

function CompleteVCMenuClose()
{
	// End:0x53
	if((VCMovie != none) && VCMovie.bMovieIsOpen)
	{
		VCMovie.Close(false);
	}
	SetVisible(true);
	bPauseMenuEnabled = true;
	//return;	
}

function ToggleBCMenu()
{
	// End:0x55
	if((BCMovie != none) && BCMovie.bMovieIsOpen)
	{
		BCMovie.CloseMenu();		
	}
	else
	{
		// End:0x7C
		if(BCMovie == none)
		{
			BCMovie = new Class'MegaHaloGame.GFxHaloBlokConstructionMenu';
		}
		BCMovie.PC = HaloPlayerPawnController(PlayerOwner);
		BCMovie.Init(LocalPlayer(PlayerOwner.Player));
		SetMenuVisible(BCMovie);
		SetVisible(false);
		bPauseMenuEnabled = false;
	}
	//return;	
}

function CompleteBCMenuClose()
{
	// End:0x53
	if((BCMovie != none) && BCMovie.bMovieIsOpen)
	{
		BCMovie.Close(false);
	}
	SetVisible(true);
	bPauseMenuEnabled = true;
	//return;	
}

function int GetLocalPlayerOwnerIndex()
{
	return HudMovie.LocalPlayerOwnerIndex;
	//return ReturnValue;	
}

function SetVisible(bool bNewVisible)
{
	HudMovie.ToggleCrosshair(bNewVisible);
	super(UTHUDBase).SetVisible(bNewVisible);
	HudMovie.SetPause(bNewVisible!);
	SetMenuVisible(HudMovie);
	//return;	
}

function DisplayHit(Vector HitDir, int Damage, Class<DamageType> DamageType)
{
	//return;	
}

function CloseOtherMenus()
{
	// End:0x54
	if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
	{
		InventoryMovie.StartCloseAnimation();
		return;
	}
	// End:0xB4
	if((Screen != none) && Screen.bMovieIsOpen)
	{
		Screen.Close();
		Screen = none;
		return;
	}
	//return;	
}

function ResolutionChanged()
{
	local bool bNeedInventoryMovie, bNeedVCMovie, bNeedBCMovie;

	bNeedInventoryMovie = (InventoryMovie != none) && InventoryMovie.bMovieIsOpen;
	bNeedVCMovie = (VCMovie != none) && VCMovie.bMovieIsOpen;
	bNeedBCMovie = (BCMovie != none) && BCMovie.bMovieIsOpen;
	super.ResolutionChanged();
	CreateHUDMovie();
	// End:0xDC
	if(bNeedInventoryMovie)
	{
		ToggleInventory();
	}
	// End:0xF3
	if(bNeedVCMovie)
	{
		ToggleVCMenu();
	}
	// End:0x10A
	if(bNeedBCMovie)
	{
		ToggleBCMenu();
	}
	//return;	
}

event PostRender()
{
	super.PostRender();
	// End:0xF7
	if(HudMovie != none)
	{
		Canvas.PushMaskRegion(Canvas.OrgX, Canvas.OrgY, Canvas.ClipX, Canvas.ClipY);
		HudMovie.TickHud(RenderDelta);
		Canvas.PopMaskRegion();
	}
	// End:0x171
	if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
	{
		InventoryMovie.Tick(RenderDelta);
		InventoryMovie.UpdatePos();
	}
	// End:0x1CC
	if((VCMovie != none) && VCMovie.bMovieIsOpen)
	{
		VCMovie.Tick(RenderDelta);
	}
	// End:0x227
	if((BCMovie != none) && BCMovie.bMovieIsOpen)
	{
		BCMovie.Tick(RenderDelta);
	}
	// End:0x282
	if((Screen != none) && Screen.bMovieIsOpen)
	{
		Screen.Tick(RenderDelta);
	}
	// End:0x2A8
	if(bShowHUD && bEnableActorOverlays)
	{
		DrawHUD();
	}
	// End:0x2BF
	if(bShowMobileHud)
	{
		DrawInputZoneOverlays();
	}
	//return;	
}

event DrawHUD()
{
	local Vector ViewPoint;
	local Rotator ViewRotation;
	local float XL, YL, YPos;

	PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
	Canvas.Font = GetFontSizeIndex(0);
	DrawActorOverlays(ViewPoint, ViewRotation);
	// End:0xA8
	if(bCrosshairOnFriendly)
	{
		bGreenCrosshair = CheckCrosshairOnFriendly();
		bCrosshairOnFriendly = false;		
	}
	else
	{
		bGreenCrosshair = false;
	}
	// End:0xF6
	if(HudMovie.bDrawWeaponCrosshairs)
	{
		PlayerOwner.DrawHUD(self);
	}
	// End:0x257
	if(bShowDebugInfo)
	{
		Canvas.Font = GetFontSizeIndex(0);
		Canvas.DrawColor = ConsoleColor;
		Canvas.StrLen("X", XL, YL);
		YPos = 0.0000000;
		PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);
		// End:0x255
		if((ShouldDisplayDebug('AI')) && Pawn(PlayerOwner.ViewTarget) != none)
		{
			DrawRoute(Pawn(PlayerOwner.ViewTarget));
		}
		return;
	}
	//return;	
}

function LocalizedMessage(Class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
	//return;	
}

function AddConsoleMessage(string M, Class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
	//return;	
}

exec function ToggleInventory()
{
	// End:0x55
	if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
	{
		InventoryMovie.StartCloseAnimation();		
	}
	else
	{
		// End:0x1C4
		if(PlayerOwner.Pawn != none)
		{
			// End:0xA0
			if(InventoryMovie == none)
			{
				InventoryMovie = new Class'UTGame.GFxProjectedUI';
			}
			InventoryMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
			InventoryMovie.SetTimingMode(1);
			InventoryMovie.Start();
			// End:0x1B9
			if(WorldInfo.bPlayersOnly!)
			{				
				PlayerOwner.ConsoleCommand("playersonly");
			}
			SetVisible(false);
		}
	}
	//return;	
}

function CompleteCloseInventory()
{
	// End:0x58
	if(WorldInfo.bPlayersOnly)
	{		
		PlayerOwner.ConsoleCommand("playersonly");
	}
	SetTimer(0.1000000, false, 'CompleteCloseTimer');
	//return;	
}

function CompleteCloseTimer()
{
	// End:0x53
	if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
	{
		InventoryMovie.Close(false);
	}
	SetVisible(true);
	//return;	
}

function DisplayText(SeqAct_DisplayTextToHUD Action)
{
	// End:0x1B9
	if(HudMovie != none)
	{
		HudMovie.DBGText_clearText();
		HudMovie.DBGText_setPosition(Action.XPosition, Action.YPosition);
		HudMovie.DBGText_formatTextSize(Action.FontSize);
		HudMovie.DBGText_formatTextColor(Action.R, Action.G, Action.B);
		HudMovie.DBGText_formatTextAlign(Action.Alignment);
		HudMovie.DBGText_setText(Action.Text);
	}
	//return;	
}

function DisplayMessage(SeqAct_DisplayMessage Action)
{
	// End:0x89
	if(HudMovie != none)
	{
		HudMovie.ShowGameMessage(Action.Title, Action.Subtitle, Action.DisplayTime);
	}
	//return;	
}

exec function ShowCompassPath(bool bShow)
{
	// End:0x39
	if(HudMovie != none)
	{
		HudMovie.bShowNavMarkers = bShow;
	}
	//return;	
}

defaultproperties
{
	MinimapHUDClass=Class'MegaHaloGame.GFxHaloMinimapHUD'
	bEnableActorOverlays=true
}