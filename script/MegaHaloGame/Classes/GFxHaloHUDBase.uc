class GFxHaloHUDBase extends UTHUDBase
	transient
	config(Game);

var GFxHaloPauseMenu PauseMenu;
var GFxHaloCheatMenu CheatMenu;
var bool bVisible;
var bool bPauseMenuEnabled;

function ResolutionChanged()
{
	local bool bNeedPauseMenu, bNeedCheatMenu;

	bNeedPauseMenu = (PauseMenu != none) && PauseMenu.bMovieIsOpen;
	bNeedCheatMenu = (CheatMenu != none) && CheatMenu.bMovieIsOpen;
	RemoveMovies();
	// End:0x97
	if(bNeedPauseMenu)
	{
		TogglePauseMenu();
	}
	// End:0xAE
	if(bNeedCheatMenu)
	{
		ToggleCheatMenu();
	}
	//return;	
}

function RemoveMovies()
{
	// End:0x3A
	if(PauseMenu != none)
	{
		PauseMenu.Close(true);
		PauseMenu = none;
	}
	// End:0x74
	if(CheatMenu != none)
	{
		CheatMenu.Close(true);
		CheatMenu = none;
	}
	//return;	
}

function SetMenuVisible(GFxMoviePlayer menu)
{
	local GFxObject Root;

	// End:0x78
	if(menu != none)
	{
		Root = menu.GetVariableObject("_root");
		// End:0x78
		if(Root != none)
		{
			Root.SetVisible(bVisible);
		}
	}
	//return;	
}

function TogglePauseMenu()
{
	// End:0x55
	if((PauseMenu != none) && PauseMenu.bMovieIsOpen)
	{
		PauseMenu.CloseMenu();		
	}
	else
	{
		// End:0x1D1
		if(bPauseMenuEnabled)
		{
			CloseOtherMenus();
			PlayerOwner.SetPause(true);
			// End:0x147
			if(PauseMenu == none)
			{
				PauseMenu = new Class'MegaHaloGame.GFxHaloPauseMenu';
				PauseMenu.MovieInfo = SwfMovie'PauseMenu.GFx_PauseMenu';
				PauseMenu.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
				PauseMenu.bDiscardNonOwnerInput = true;
				PauseMenu.SetTimingMode(1);
			}
			SetVisible(false);
			SetMenuVisible(PauseMenu);
			PauseMenu.Start();
			// End:0x1D1
			if(WorldInfo.IsPlayInMobilePreview()!)
			{
				PauseMenu.AddFocusIgnoreKey('Escape');
			}
		}
	}
	//return;	
}

function CloseOtherMenus()
{
	//return;	
}

function CompletePauseMenuClose()
{
	PlayerOwner.SetPause(false);
	PauseMenu.Close(false);
	SetVisible(true);
	//return;	
}

exec function ShowCheatMenu()
{
	// End:0x2E
	if(PlayerOwner.bCinematicMode!)
	{
		ToggleCheatMenu();
	}
	//return;	
}

function ToggleCheatMenu()
{
	// End:0xA9
	if((CheatMenu != none) && CheatMenu.bMovieIsOpen)
	{
		CheatMenu.CloseMenu();
		// End:0xA6
		if(int(Role) >= int(ROLE_Authority))
		{
			PlayerOwner.IgnoreMoveInput(false);
			PlayerOwner.ClientIgnoreMoveInput(false);
		}		
	}
	else
	{
		// End:0xD0
		if(CheatMenu == none)
		{
			CheatMenu = new Class'MegaHaloGame.GFxHaloCheatMenu';
		}
		CheatMenu.Init(LocalPlayer(PlayerOwner.Player));
		SetVisible(false);
		// End:0x175
		if(int(Role) >= int(ROLE_Authority))
		{
			PlayerOwner.IgnoreMoveInput(true);
			PlayerOwner.ClientIgnoreMoveInput(true);
		}
	}
	//return;	
}

function CompleteCheatMenuClose()
{
	CheatMenu.Close(false);
	SetVisible(bPauseMenuEnabled);
	// End:0x88
	if(int(Role) >= int(ROLE_Authority))
	{
		PlayerOwner.IgnoreMoveInput(false);
		PlayerOwner.ClientIgnoreMoveInput(false);
	}
	//return;	
}

event PostRender()
{
	super.PostRender();
	// End:0xA9
	if(bVisible!)
	{
		Canvas.OrgX = -1280.0000000;
		Canvas.OrgY = -720.0000000;
		Canvas.ClipX = 0.0000000;
		Canvas.ClipY = 0.0000000;
	}
	// End:0xFB
	if((PauseMenu != none) && PauseMenu.bMovieIsOpen)
	{
		PauseMenu.Tick();
	}
	// End:0x156
	if((CheatMenu != none) && CheatMenu.bMovieIsOpen)
	{
		CheatMenu.Tick(RenderDelta);
	}
	//return;	
}

defaultproperties
{
	bVisible=true
	bPauseMenuEnabled=true
}