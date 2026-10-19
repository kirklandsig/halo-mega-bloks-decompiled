class HaloObjective_UseObject extends HaloObjective
	config(HUDMarkers);

var ObjectiveMarkerData UseObject;

function TickMarkers()
{
	//return;	
}

function TickStatus(float DeltaTime)
{
	local Actor ObjectToUse;
	local SequenceEvent SeqEv;
	local SeqEvent_Used SeqEv_Used;

	ObjectToUse = UseObject.Actor;
	// End:0xC1
	if(ObjectToUse != none)
	{
		// End:0xC0
		foreach ObjectToUse.GeneratedEvents(SeqEv)
		{
			SeqEv_Used = SeqEvent_Used(SeqEv);
			// End:0xBF
			if((SeqEv_Used != none) && SeqEv_Used.Instigator != none)
			{
				Complete();				
				return;
			}			
		}		
	}
	//return;	
}

function Actor GetNavigationPoint()
{
	return UseObject.Actor;
	//return ReturnValue;	
}

function CreateObjectiveMarkers()
{
	ClearObjectiveMarkers();
	CreateObjectiveMarker(UseObject);
	//return;	
}

defaultproperties
{
	UseObject=(Actor=none,Marker=OMN_Use,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=true,bClampToScreen=true)
	IconFrame="use"
}