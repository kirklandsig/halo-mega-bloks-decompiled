class SeqAct_StartObjective_RepairBuild extends SeqAct_StartObjective;

var HaloObjective.EObjectiveMarker Marker;
var bool bDraw;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var float RepathDelay;
var array<Actor> Repairs;
var int MinRepairs;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_RepairBuild';
	//return;	
}

function SetObjectiveProperties()
{
	local Actor RBObject;
	local RepairData RBMarker;
	local HaloObjective_RepairBuild RepBuild;

	RepBuild = HaloObjective_RepairBuild(Objective);
	// End:0x2A2
	if(RepBuild != none)
	{
		// End:0x1EB
		foreach Repairs(RBObject)
		{
			RBMarker.bHasBeenRepaired = false;
			RBMarker.RepairObject.Actor = RBObject;
			RBMarker.RepairObject.Marker = Marker;
			RBMarker.RepairObject.bDraw = bDraw;
			RBMarker.RepairObject.bShowHealth = bShowHealth;
			RBMarker.RepairObject.bShowDistance = bShowDistance;
			RBMarker.RepairObject.bClampToScreen = bClampToScreen;
			RepBuild.Repairs.AddItem(RBMarker);			
		}		
		MinRepairs = Clamp(MinRepairs, 0, Repairs.Length);
		RepBuild.MinRepairs = ((MinRepairs == 0) ? Repairs.Length : MinRepairs);
		RepBuild.RepathTimer = RepathDelay;
		RepBuild.RepathDelay = RepathDelay;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_RepairBuild!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	Marker=EObjectiveMarker.OMN_Use
	bDraw=true
	bShowDistance=true
	bClampToScreen=true
	RepathDelay=5.0000000
	ObjectiveName="Repair/Build"
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Repairs",LinkVar="None",PropertyName="Repairs",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Min Repairs",LinkVar="None",PropertyName="MinRepairs",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Repair/Build Objective"
}