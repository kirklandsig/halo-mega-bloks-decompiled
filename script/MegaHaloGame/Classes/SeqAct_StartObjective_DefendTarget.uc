class SeqAct_StartObjective_DefendTarget extends SeqAct_StartObjective;

var HaloObjective.EObjectiveMarker Marker;
var bool bDraw;
var bool bDrawTagSymbol;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var array<Actor> VIPs;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_DefendTarget';
	//return;	
}

function SetObjectiveProperties()
{
	local Actor VIP;
	local VIPData VIPMarker;
	local HaloObjective_DefendTarget DefTarget;

	DefTarget = HaloObjective_DefendTarget(Objective);
	// End:0x21A
	if(DefTarget != none)
	{
		// End:0x216
		foreach VIPs(VIP)
		{
			// End:0x215
			if(VIP != none)
			{
				VIPMarker.VIP.Actor = VIP;
				VIPMarker.VIP.Marker = Marker;
				VIPMarker.VIP.bDraw = bDraw;
				VIPMarker.VIP.bDrawTagSymbol = bDrawTagSymbol;
				VIPMarker.VIP.bShowHealth = bShowHealth;
				VIPMarker.VIP.bShowDistance = bShowDistance;
				VIPMarker.VIP.bClampToScreen = bClampToScreen;
				DefTarget.VIPs.AddItem(VIPMarker);
			}			
		}				
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_DefendTarget!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	Marker=OMN_Defend
	bDraw=true
	bShowHealth=true
	bClampToScreen=true
	ObjectiveName="Defend Target"
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkedVariables=none,LinkDesc="VIPs",LinkVar="None",PropertyName="VIPs",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Defend Target Objective"
}