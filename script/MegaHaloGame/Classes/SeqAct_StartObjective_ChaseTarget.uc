class SeqAct_StartObjective_ChaseTarget extends SeqAct_StartObjective;

var float InnerRadius;
var float OuterRadius;
var float GracePeriod;
var HaloObjective.EObjectiveMarker Marker;
var bool bDraw;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var Actor ChaseTarget;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_ChaseTarget';
	//return;	
}

function SetObjectiveProperties()
{
	local ObjectiveMarkerData CTMarker;
	local HaloObjective_ChaseTarget Chase;

	Chase = HaloObjective_ChaseTarget(Objective);
	// End:0x1BA
	if(Chase != none)
	{
		CTMarker.Actor = ChaseTarget;
		CTMarker.Marker = Marker;
		CTMarker.bDraw = bDraw;
		CTMarker.bShowHealth = bShowHealth;
		CTMarker.bShowDistance = bShowDistance;
		CTMarker.bClampToScreen = bClampToScreen;
		Chase.ChaseTarget = CTMarker;
		Chase.InnerRadius = InnerRadius;
		Chase.OuterRadius = OuterRadius;
		Chase.GracePeriod = GracePeriod;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_ChaseTarget!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	InnerRadius=100.0000000
	OuterRadius=500.0000000
	GracePeriod=3.0000000
	Marker=OMN_Chase
	bDraw=true
	bShowHealth=true
	bShowDistance=true
	bClampToScreen=true
	ObjectiveName="Chase Target"
	bUseNavigation=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="ChaseTarget",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Chase Target Objective"
}