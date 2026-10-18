class SeqAct_StartObjective_ClearZone extends SeqAct_StartObjective;

var ObjectiveMarkerData Zone;
var int EnemyCountToEnableEnemyMarkers;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_ClearZone';
	//return;	
}

function SetObjectiveProperties()
{
	local HaloObjective_ClearZone ClearZone;

	ClearZone = HaloObjective_ClearZone(Objective);
	// End:0x7E
	if(ClearZone != none)
	{
		ClearZone.Zone = Zone;
		ClearZone.EnemyCountToEnableEnemyMarkers = EnemyCountToEnableEnemyMarkers;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_ClearZone!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	Zone=(Actor=none,Marker=EObjectiveMarker.OMN_Location,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=true,bClampToScreen=true)
	EnemyCountToEnableEnemyMarkers=5
	ObjectiveName="Clear Zone"
	ObjName="Start Clear Zone Objective"
}