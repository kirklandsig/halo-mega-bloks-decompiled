class SeqAct_StartObjective_Takedown extends SeqAct_StartObjective;

var HaloObjective.EObjectiveMarker Marker;
var bool bDraw;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var float RepathDelay;
var array<Actor> TakedownTargets;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_Takedown';
	//return;	
}

function SetObjectiveProperties()
{
	local Actor TDTarget;
	local ObjectiveMarkerData TDMarker;
	local HaloObjective_Takedown Takedown;

	Takedown = HaloObjective_Takedown(Objective);
	// End:0x1BD
	if(Takedown != none)
	{
		// End:0x169
		foreach TakedownTargets(TDTarget)
		{
			// End:0x168
			if(TDTarget != none)
			{
				TDMarker.Actor = TDTarget;
				TDMarker.Marker = Marker;
				TDMarker.bDraw = bDraw;
				TDMarker.bShowHealth = bShowHealth;
				TDMarker.bShowDistance = bShowDistance;
				TDMarker.bClampToScreen = bClampToScreen;
				Takedown.TakedownTargets.AddItem(TDMarker);
			}			
		}		
		Takedown.RepathTimer = RepathDelay;
		Takedown.RepathDelay = RepathDelay;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_Takedown!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	Marker=OMN_Takedown
	bDraw=true
	bShowHealth=true
	bClampToScreen=true
	RepathDelay=5.0000000
	ObjectiveName="Takedown"
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Targets",LinkVar="None",PropertyName="TakedownTargets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Takedown Objective"
}