class GFxHaloLoadingScreen extends GFxHaloMoviePlayer
	config(UI);

var GFxObject Spinner;
var const localized string VS_Loading_Stinger;
var bool bLevelLoadComplete;
var bool bInitComplete;

function bool Start(optional bool StartPaused = false)
{
	local GFxObject tempMC;

	super(GFxMoviePlayer).Start();
	Advance(0.0000000);
	Spinner = GetVariableObject("_root.spinner");
	tempMC = GetVariableObject("_root.description.base.textField");
	tempMC.SetText(VS_Loading_Stinger);
	return true;
	//return ReturnValue;	
}

function TickLoadingScreen()
{
	// End:0x49
	if(bInitComplete!)
	{
		// End:0x49
		if(bLevelLoadComplete)
		{
			Spinner.GotoAndPlayI(2);
			bInitComplete = true;
		}
	}
	//return;	
}

function CloseLoadingScreen()
{
	// End:0x31
	if(bLevelLoadComplete)
	{
		PlayMenuSound("start");
		SendRemoteEvent('CloseLoadingScreen');
	}
	//return;	
}

function bool SendRemoteEvent(name EventName)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int I;

	GameSeq = Class'Engine.WorldInfo'.static.GetWorldInfo().GetGameSequence();
	// End:0x147
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x8B:

		// End:0x147 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x139
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == EventName)
			{
				SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(Class'Engine.WorldInfo'.static.GetWorldInfo(), none);
				return true;
			}
			I++;
			// [Loop Continue]
			goto J0x8B;
		}
	}
	WarnInternal("Unable to find Remote Event: " $ string(EventName));
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	VS_Loading_Stinger="Due to reports of increased Covenant forces in the area, you have been deployed to secure a remote base used to monitor a key Forerunner installation. Mid-flight, a swarm of Banshees attacks your Pelican sending it crashing into the trees below.\n\nNavigate the jungle on-foot and reach the base!"
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloLoadingScreen"
	MovieInfo=SwfMovie'mainhud.GFx_MainHUD'
	bDisplayWithHudOff=false
	bCaptureInput=true
}