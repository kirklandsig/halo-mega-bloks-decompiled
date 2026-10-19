class HaloAkEventMap extends Object;

struct AkEventMapping
{
	var string EventName;
	var AkEvent Event;

	structdefaultproperties
	{
		EventName=""
		Event=none
	}
};

var array<AkEventMapping> SoundMap;

function AkEvent LookUpAkEvent(string EventName)
{
	local int Idx;

	Idx = SoundMap.Find('EventName', EventName);
	// End:0x63
	if(Idx != -1)
	{
		return SoundMap[Idx].Event;
	}
	return none;
	//return ReturnValue;	
}

function PlayAkEvent(string EventName, optional Actor SoundOwner)
{
	local AkEvent Event;

	Event = LookUpAkEvent(EventName);
	// End:0xB4
	if(Event != none)
	{
		// End:0x6D
		if(SoundOwner != none)
		{
			SoundOwner.PlayAkEvent(Event);			
		}
		else
		{
			Class'Engine.WorldInfo'.static.GetWorldInfo().PlayAkEvent(Event);
		}		
	}
	else
	{
		LogInternal("HaloSoundMap.PlayAkEvent did not find a mapping for " $ EventName);
	}
	//return;	
}

function PostAkEvent(string EventName, optional Actor SoundOwner)
{
	local AkEvent Event;

	Event = LookUpAkEvent(EventName);
	// End:0xA8
	if(Event != none)
	{
		// End:0x67
		if(SoundOwner != none)
		{
			SoundOwner.PostAkEvent(Event);			
		}
		else
		{
			Class'Engine.WorldInfo'.static.GetWorldInfo().PostAkEvent(Event);
		}		
	}
	else
	{
		LogInternal("HaloSoundMap.PostAkEvent did not find a mapping for " $ EventName);
	}
	//return;	
}
