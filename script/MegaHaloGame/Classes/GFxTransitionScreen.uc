class GFxTransitionScreen extends GFxHaloMoviePlayer
	config(UI);

var bool bIsInit;
var bool bFading;
var GFxObject Fullscreen;
var float FadeTime;
var float FadeEnd;
var byte FadeGoal;

function Init(optional LocalPlayer Player)
{
	super(GFxMoviePlayer).Init(Player);
	// End:0x90
	if(Start())
	{
		// End:0x90
		if(!bIsInit)
		{
			Fullscreen = GetVariableObject("_root.FullScreen");
			Fullscreen.SetVisible(false);
			SetPriority(100);
			bIsInit = true;
		}
	}
	//return;	
}

function FadeToBlack(float Time)
{
	LogInternal("FADE TO BLACK");
	FadeTime = Time;
	FadeEnd = GetPC().WorldInfo.TimeSeconds + FadeTime;
	FadeGoal = 100;
	bFading = true;
	Fullscreen.SetFloat("_alpha", 0.0000000);
	Fullscreen.SetVisible(true);
	//return;	
}

function FadeToClear(float Time)
{
	LogInternal("FADE TO CLEAR");
	FadeTime = Time;
	FadeEnd = GetPC().WorldInfo.TimeSeconds + FadeTime;
	FadeGoal = 0;
	bFading = true;
	Fullscreen.SetFloat("_alpha", 100.0000000);
	Fullscreen.SetVisible(true);
	//return;	
}

function float GetScreenAlpha()
{
	return Fullscreen.GetFloat("_alpha");
	//return ReturnValue;	
}

function Tick(float DeltaTime)
{
	local float pctComplete;

	// End:0x19C
	if(bFading)
	{
		pctComplete = 1.0000000 - ((FadeEnd - GetPC().WorldInfo.TimeSeconds) / FadeTime);
		pctComplete = FClamp(pctComplete, 0.0000000, 1.0000000);
		// End:0xDB
		if(int(FadeGoal) == int(0))
		{
			Fullscreen.SetFloat("_alpha", 100.0000000 - (float(100) * pctComplete));			
		}
		else
		{
			Fullscreen.SetFloat("_alpha", 100.0000000 * pctComplete);
		}
		// End:0x19C
		if(pctComplete >= 1.0000000)
		{
			bFading = false;
			// End:0x19C
			if(int(FadeGoal) == int(0))
			{
				Fullscreen.SetVisible(false);
				// End:0x19C
				if(ExternalInterface != none)
				{
					GFxHaloHUD(ExternalInterface).DoneFading();
				}
			}
		}
	}
	//return;	
}

defaultproperties
{
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxTransitionScreen"
	MovieInfo=SwfMovie'UI_Screen.GFx_TransitionScreen'
	bAllowInput=false
	bAutoPlay=true
	bOnlyOwnerFocusable=true
	bDiscardNonOwnerInput=true
	TimingMode=TM_Real
}