class SeqAct_StartObjective_WaypointRace extends SeqAct_StartObjective;

var array<RaceWaypoint> RaceWaypoints;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_WaypointRace';
	//return;	
}

function SetObjectiveProperties()
{
	local HaloObjective_WaypointRace WaypointRace;

	WaypointRace = HaloObjective_WaypointRace(Objective);
	// End:0x56
	if(WaypointRace != none)
	{
		WaypointRace.RaceWaypoints = RaceWaypoints;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_WaypointRace");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	ObjectiveName="Waypoint Race"
	ObjName="Start Waypoint Race Objective"
}