class ForceFeedbackManager extends Object within PlayerController
	abstract
	transient
	native;

var bool bAllowsForceFeedback;
var bool bIsPaused;
var ForceFeedbackWaveform FFWaveform;
var int CurrentSample;
var float ElapsedTime;
var float ScaleAllWaveformsBy;
var Actor WaveformInstigator;
var ForceFeedbackWaveform PrevWaveformLoop;
var Actor PrevInstigator;

simulated function PlayForceFeedbackWaveform(ForceFeedbackWaveform WaveForm, Actor WaveInstigator)
{
	// End:0x15B
	if(((WaveForm != none) && WaveForm.Samples.Length > 0) && bAllowsForceFeedback == true)
	{
		FFWaveform = WaveForm;
		WaveformInstigator = WaveInstigator;
		CurrentSample = 0;
		ElapsedTime = 0.0000000;
		bIsPaused = false;
		// End:0x15B
		if(PrevWaveformLoop != WaveForm)
		{
			// End:0xF6
			if(WaveForm.bIsLooping)
			{
				PrevWaveformLoop = WaveForm;
				PrevInstigator = WaveInstigator;				
			}
			else
			{
				// End:0x15B
				if(PrevWaveformLoop != none)
				{
					Outer.SetTimer(WaveForm.Samples[0].Duration, false, 'ReturnToLoop', self);
				}
			}
		}
	}
	//return;	
}

simulated function StopForceFeedbackWaveform(optional ForceFeedbackWaveform WaveForm)
{
	// End:0x2E
	if(PrevWaveformLoop == WaveForm)
	{
		PrevWaveformLoop = none;
		PrevInstigator = none;
	}
	// End:0x6C
	if((WaveForm == none) || WaveForm == FFWaveform)
	{
		FFWaveform = none;
		WaveformInstigator = none;
	}
	//return;	
}

simulated function ReturnToLoop()
{
	PlayForceFeedbackWaveform(PrevWaveformLoop, PrevInstigator);
	//return;	
}

simulated function PauseWaveform(optional bool bPause)
{
	bIsPaused = bPause;
	//return;	
}

defaultproperties
{
	bAllowsForceFeedback=true
	ScaleAllWaveformsBy=1.0000000
}