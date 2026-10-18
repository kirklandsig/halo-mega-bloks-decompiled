class GFxHaloCheatMenu extends GFxHaloMoviePlayer
	config(UI);

var bool bHasBeenInitialized;
var GFxObject MenuMC;

function Init(optional LocalPlayer Player)
{
	super(GFxMoviePlayer).Init(Player);
	// End:0x53
	if(Start())
	{
		// End:0x49
		if(bHasBeenInitialized == false)
		{
			ExternalInterface = self;
			bHasBeenInitialized = true;
		}
		OpenMenu();
	}
	//return;	
}

function RegisterMenu(GFxObject MC)
{
	MenuMC = MC;
	//return;	
}

function OpenMenu()
{
	MenuMC.ActionScriptVoid("openMenu");
	//return;	
}

function CloseMenu()
{
	MenuMC.ActionScriptVoid("closeMenu");
	//return;	
}

function ResumeGame()
{
	local GFxHaloHUD theHUD;

	theHUD = GFxHaloHUD(GetPC().myHUD);
	// End:0x60
	if(theHUD != none)
	{
		theHUD.CompleteCheatMenuClose();
	}
	//return;	
}

function Tick(float DeltaTime)
{
	//return;	
}

function ToggleGodMode()
{
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x102
	if(Game != none)
	{
		// End:0x101
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x100
			if((PC != none) && PC.CheatManager != none)
			{
				PC.CheatManager.God();
			}			
		}		
	}
	//return;	
}

function GiveBloks()
{
	local HaloGameDefault Game;
	local HaloCheatManager CheatManager;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x10A
	if(Game != none)
	{
		// End:0x109
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x108
			if(PC != none)
			{
				CheatManager = HaloCheatManager(PC.CheatManager);
				// End:0x108
				if(CheatManager != none)
				{
					CheatManager.BigBucks();
					// [Explicit Continue]
					goto J0x109;
				}
			}			
		}
		J0x109:
		
	}
	//return;	
}

function GiveVehicle(string VehicleClassString)
{
	local HaloGameDefault Game;
	local HaloCheatManager CheatManager;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x110
	if(Game != none)
	{
		// End:0x10F
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x10E
			if(PC != none)
			{
				CheatManager = HaloCheatManager(PC.CheatManager);
				// End:0x10E
				if(CheatManager != none)
				{
					CheatManager.GiveVehicle(VehicleClassString);
				}
			}			
		}		
	}
	//return;	
}

function CompleteCurrentObjective()
{
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xC7
	if(Game != none)
	{
		// End:0xC6
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0xC5
			if(PC != none)
			{
				PC.CompleteObjective();
			}			
		}		
	}
	//return;	
}

function GiveWeapon(string WeaponClassString)
{
	local HaloGameDefault Game;
	local HaloCheatManager CheatManager;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x110
	if(Game != none)
	{
		// End:0x10F
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x10E
			if(PC != none)
			{
				CheatManager = HaloCheatManager(PC.CheatManager);
				// End:0x10E
				if(CheatManager != none)
				{
					CheatManager.GiveWeapon(WeaponClassString);
				}
			}			
		}		
	}
	//return;	
}

function GiveFragGrenades(int Count)
{
	local HaloPawn Pawn;
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x111
	if(Game != none)
	{
		// End:0x110
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x10F
			if(PC != none)
			{
				Pawn = HaloPawn(PC.Pawn);
				// End:0x10F
				if(Pawn != none)
				{
					Pawn.AddFragGrenadesToInventory(Count, false);
				}
			}			
		}		
	}
	//return;	
}

function GivePlasmaGrenades(int Count)
{
	local HaloPawn Pawn;
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x111
	if(Game != none)
	{
		// End:0x110
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x10F
			if(PC != none)
			{
				Pawn = HaloPawn(PC.Pawn);
				// End:0x10F
				if(Pawn != none)
				{
					Pawn.AddPlasmaGrenadesToInventory(Count, false);
				}
			}			
		}		
	}
	//return;	
}

function CompleteBesieged()
{
	//return;	
}

function GoToNextObjective()
{
	//return;	
}

function GoToPrevObjective()
{
	//return;	
}

function ToggleGhostMode()
{
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x185
	if(Game != none)
	{
		// End:0x184
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x183
			if((PC != none) && PC.CheatManager != none)
			{
				// End:0x14F
				if(PC.CheatManager.Outer.bCheatFlying)
				{
					PC.CheatManager.Walk();					
				}
				else
				{
					PC.CheatManager.Ghost();
				}
			}			
		}		
	}
	//return;	
}

function ToggleSafeFall()
{
	local HaloGameDefault Game;
	local HaloCheatManager CheatManager;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x107
	if(Game != none)
	{
		// End:0x106
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x105
			if(PC != none)
			{
				CheatManager = HaloCheatManager(PC.CheatManager);
				// End:0x105
				if(CheatManager != none)
				{
					CheatManager.ToggleFallingSaves();
				}
			}			
		}		
	}
	//return;	
}

function Suicide()
{
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xC7
	if(Game != none)
	{
		// End:0xC6
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0xC5
			if(PC != none)
			{
				PC.Suicide();
			}			
		}		
	}
	//return;	
}

function KillAI()
{
	local HaloGameDefault Game;
	local HaloCheatManager CheatManager;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x107
	if(Game != none)
	{
		// End:0x106
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x105
			if(PC != none)
			{
				CheatManager = HaloCheatManager(PC.CheatManager);
				// End:0x105
				if(CheatManager != none)
				{
					CheatManager.KillAllEnemies();
				}
			}			
		}		
	}
	//return;	
}

function ConstructionCheatComplete()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xB0
	if((Game != none) && Game.TheConstructionManager != none)
	{
		Game.TheConstructionManager.CheatComplete();
	}
	//return;	
}

function ToggleUIVisibility()
{
	local GFxHaloHUD theHUD;

	theHUD = GFxHaloHUD(GetPC().myHUD);
	// End:0x60
	if(theHUD != none)
	{
		theHUD.ToggleUIVisible();
	}
	//return;	
}

defaultproperties
{
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloCheatMenu"
	MovieInfo=SwfMovie'CheatMenu.GFx_DBGMenu'
	bAutoPlay=true
	bOnlyOwnerFocusable=true
	bDiscardNonOwnerInput=true
	TimingMode=GFxTimingMode.TM_Real
}