class HaloAkEventActor extends Keypoint;

struct RTPCStruct
{
	var name Parameter;
	var float Value;

	structdefaultproperties
	{
		Parameter="None"
		Value=0.0000000
	}
};

var AkEvent PlaySoundEvent;
var AkEvent StopSoundEvent;
var bool bAutoPlay;
var bool bDestroyOnStopEvent;
var bool bRemoveRTPCArrayAfterSet;
var array<RTPCStruct> RTPCValues;
var float LoopDuration;

simulated function PostBeginPlay()
{
	SetRTPCValues();
	// End:0x2A
	if(bAutoPlay)
	{
		SetTimer(0.0010000, false, 'PlayEvent', self);
	}
	super(Actor).PostBeginPlay();
	//return;	
}

simulated function SetEvents(AkEvent E1, optional AkEvent E2 = none)
{
	PlaySoundEvent = E1;
	StopSoundEvent = E2;
	//return;	
}

simulated function SetPlayEvent(AkEvent E)
{
	PlaySoundEvent = E;
	//return;	
}

simulated function SetStopEvent(AkEvent E)
{
	StopSoundEvent = E;
	//return;	
}

simulated function SetLoopDuration(float Duration)
{
	LoopDuration = Duration;
	//return;	
}

simulated function PlayEvent()
{
	// End:0x52
	if(PlaySoundEvent != none)
	{
		PlayAkEvent(PlaySoundEvent);
		// End:0x52
		if(LoopDuration > 0.0000000)
		{
			SetTimer(LoopDuration, false, 'StopEvent', self);
		}
	}
	//return;	
}

simulated function StopEvent()
{
	// End:0x4E
	if(StopSoundEvent != none)
	{
		PlayAkEvent(StopSoundEvent);
		// End:0x4E
		if(bDestroyOnStopEvent)
		{
			LoopDuration = 0.0000000;
			Destroyed();
		}
	}
	//return;	
}

simulated function SetLocationAndPlay(Vector NewLocation)
{
	PlayEvent();
	SetLocation(NewLocation);
	//return;	
}

simulated function PushRTPCValue(name P, float V)
{
	local RTPCStruct S;

	S.Parameter = P;
	S.Value = V;
	RTPCValues[RTPCValues.Length] = S;
	//return;	
}

simulated function SetRTPCValues()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x87 [Loop If]
	if(I < RTPCValues.Length)
	{
		SetRTPCValue(RTPCValues[I].Parameter, RTPCValues[I].Value);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0xA0
	if(bRemoveRTPCArrayAfterSet)
	{
		RTPCValues.Length = 0;
	}
	//return;	
}

simulated event Destroyed()
{
	// End:0x1D
	if(LoopDuration > 0.0000000)
	{
		StopEvent();
	}
	super(Actor).Destroyed();
	//return;	
}

defaultproperties
{
	bStatic=false
}