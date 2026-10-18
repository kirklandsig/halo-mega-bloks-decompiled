class GFxHaloMapMenu extends GFxHaloMoviePlayer
	config(UI);

var PlayerController PlayerOwner;
var GFxObject MenuMC;
var GFxHaloObjectiveMap ObjectiveMap;

function bool Start(optional bool StartPaused = false)
{
	super(GFxMoviePlayer).Start();
	Advance(0.0000000);
	OpenMenu();
	AddCaptureKey('XboxTypeS_A');
	AddCaptureKey('XboxTypeS_B');
	AddCaptureKey('XboxTypeS_X');
	AddCaptureKey('XboxTypeS_Y');
	AddCaptureKey('XboxTypeS_Start');
	AddCaptureKey('XboxTypeS_Back');
	return true;
	//return ReturnValue;	
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

function RegisterMenu(GFxHaloMinimap MC)
{
	MenuMC = MC;
	//return;	
}

function InitializeMap(GFxHaloObjectiveMap Map)
{
	ObjectiveMap = Map;
	ObjectiveMap.Init();
	//return;	
}

function ToggleZoom()
{
	// End:0x2E
	if(ObjectiveMap != none)
	{
		ObjectiveMap.ToggleZoom();
	}
	//return;	
}

function ResumeGame()
{
	//return;	
}

function Tick()
{
	local Vector2D StickVector;

	StickVector.X = PlayerOwner.PlayerInput.RawJoyRight;
	StickVector.Y = PlayerOwner.PlayerInput.RawJoyUp;
	// End:0x116
	if((StickVector.X != 0.0000000) || StickVector.Y != 0.0000000)
	{
		ObjectiveMap.Pan(StickVector);
	}
	StickVector.Y = PlayerOwner.PlayerInput.RawJoyLookUp;
	// End:0x1C7
	if(StickVector.Y != 0.0000000)
	{
		ObjectiveMap.Zoom(StickVector.Y);
	}
	//return;	
}

defaultproperties
{
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloMapMenu"
	bPauseGameWhileActive=true
}