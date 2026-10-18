class SeqAct_StartObjective_GoToLocation extends SeqAct_StartObjective;

var HaloObjective.EObjectiveMarker Marker;
var HaloObjective.EObjectivePlayerCount PlayerCount;
var bool bDraw;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var float RepathDelay;
var Class<Pawn> PlayerPawnType;
var array<ObjectiveMarkerData> NPCs;
var int MinNPCCount;
var array<Actor> Locations;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_GoToLocation';
	//return;	
}

function SetObjectiveProperties()
{
	local Actor GTLLocation;
	local LocationData GTLMarker;
	local HaloObjective_GoToLocation GoToLoc;

	GoToLoc = HaloObjective_GoToLocation(Objective);
	// End:0x308
	if(GoToLoc != none)
	{
		// End:0x1FA
		foreach Locations(GTLLocation)
		{
			// End:0x1F9
			if(GTLLocation != none)
			{
				GTLMarker.bHasBeenVisited = false;
				GTLMarker.Location.Actor = GTLLocation;
				GTLMarker.Location.Marker = Marker;
				GTLMarker.Location.bDraw = bDraw;
				GTLMarker.Location.bShowHealth = bShowHealth;
				GTLMarker.Location.bShowDistance = bShowDistance;
				GTLMarker.Location.bClampToScreen = bClampToScreen;
				GoToLoc.Locations.AddItem(GTLMarker);
			}			
		}		
		GoToLoc.RepathTimer = RepathDelay;
		GoToLoc.RepathDelay = RepathDelay;
		GoToLoc.PlayerCount = PlayerCount;
		GoToLoc.PlayerPawnType = ((PlayerPawnType == none) ? Class'Engine.Pawn' : PlayerPawnType);
		GoToLoc.NPCs = NPCs;
		GoToLoc.MinNPCCount = MinNPCCount;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_UseObject");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	Marker=EObjectiveMarker.OMN_Location
	PlayerCount=EObjectivePlayerCount.OPC_All
	bDraw=true
	bShowDistance=true
	bClampToScreen=true
	RepathDelay=5.0000000
	PlayerPawnType=Class'Engine.Pawn'
	ObjectiveName="Go To Location"
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Locations",LinkVar="None",PropertyName="Locations",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Go To Location Objective"
}