class SeqAct_StartObjective_FleeFromTarget extends SeqAct_StartObjective;

var float InnerRadius;
var float OuterRadius;
var float GracePeriod;
var HaloObjective.EObjectiveMarker Marker;
var bool bDraw;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var Actor FleeFromTarget;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_FleeFromTarget';
	//return;	
}

function SetObjectiveProperties()
{
	local ObjectiveMarkerData FFTMarker;
	local HaloObjective_FleeFromTarget Flee;

	Flee = HaloObjective_FleeFromTarget(Objective);
	// End:0x1BA
	if(Flee != none)
	{
		FFTMarker.Actor = FleeFromTarget;
		FFTMarker.Marker = Marker;
		FFTMarker.bDraw = bDraw;
		FFTMarker.bShowHealth = bShowHealth;
		FFTMarker.bShowDistance = bShowDistance;
		FFTMarker.bClampToScreen = bClampToScreen;
		Flee.FleeTarget = FFTMarker;
		Flee.InnerRadius = InnerRadius;
		Flee.OuterRadius = OuterRadius;
		Flee.GracePeriod = GracePeriod;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_FleeFromTarget!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	InnerRadius=100.0000000
	OuterRadius=500.0000000
	GracePeriod=3.0000000
	Marker=OMN_Flee
	bDraw=true
	bShowHealth=true
	bShowDistance=true
	bClampToScreen=true
	ObjectiveName="Flee From Target"
	bUseNavigation=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="FleeFromTarget",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Flee From Target Objective"
}