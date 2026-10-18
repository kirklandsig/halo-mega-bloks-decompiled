class HaloObjective_WaypointRace extends HaloObjective
	config(HUDMarkers);

struct RaceWaypoint
{
	var ObjectiveMarkerData WayPoint;
	var bool bWaypointIsTimed;
	var float WaypointTimeLimit;

	structdefaultproperties
	{
		WayPoint=(Actor=none,Marker=EObjectiveMarker.OMN_None,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=false,bClampToScreen=true)
		bWaypointIsTimed=true
		WaypointTimeLimit=15.0000000
	}
};

var array<RaceWaypoint> RaceWaypoints;
var float TimeElapsed;

function TickMarkers()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xB7 [Loop If]
	if(I < RaceWaypoints.Length)
	{
		// End:0xA9
		if(RaceWaypoints[I].WayPoint.Actor == none)
		{
			RemoveObjectiveMarker(RaceWaypoints[I].WayPoint);
			RaceWaypoints.Remove(I--, 1);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickStatus(float DeltaTime)
{
	// End:0x60
	if((IsAtNextWaypoint()) == true)
	{
		// End:0x2D
		if(RaceWaypoints.Length == 0)
		{
			Complete();			
		}
		else
		{
			TimeElapsed = 0.0000000;
			RaceWaypoints.Remove(0, 1);
			UpdateCompassWaypoint();
		}
		CreateObjectiveMarkers();		
	}
	else
	{
		// End:0x7D
		if(RaceWaypoints.Length == 0)
		{
			Complete();			
		}
		else
		{
			// End:0xEC
			if(RaceWaypoints[0].bWaypointIsTimed == true)
			{
				TimeElapsed += DeltaTime;
				// End:0xEC
				if(TimeElapsed > RaceWaypoints[0].WaypointTimeLimit)
				{
					Fail();
				}
			}
		}
	}
	//return;	
}

function bool IsAtNextWaypoint()
{
	local Actor WP;
	local HaloPlayerPawnController PC;

	// End:0x128
	if(RaceWaypoints.Length > 0)
	{
		WP = RaceWaypoints[0].WayPoint.Actor;
		// End:0x128
		if(WP != none)
		{
			// End:0x127
			foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
			{
				// End:0x126
				if((PC != none) && PC.Pawn != none)
				{
					// End:0x126
					if(WP.Touching.Find(PC.Pawn) != -1)
					{						
						return true;
					}
				}				
			}			
		}
	}
	return false;
	//return ReturnValue;	
}

function Actor GetNavigationPoint()
{
	// End:0x42
	if(RaceWaypoints.Length > 0)
	{
		return RaceWaypoints[0].WayPoint.Actor;
	}
	return none;
	//return ReturnValue;	
}

function CreateObjectiveMarkers()
{
	ClearObjectiveMarkers();
	// End:0x42
	if(RaceWaypoints.Length > 0)
	{
		CreateObjectiveMarker(RaceWaypoints[0].WayPoint);
	}
	//return;	
}

defaultproperties
{
	IconFrame="location"
}