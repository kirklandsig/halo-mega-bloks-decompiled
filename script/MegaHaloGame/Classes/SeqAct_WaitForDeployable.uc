class SeqAct_WaitForDeployable extends SequenceAction;

var DeployableInfo DeployableItem;
var HaloDeploymentMonitor HDM;
var bool bHasBeenDeployed;
var Actor DeployedItem;

event Activated()
{
	local Object Obj;
	local HaloPlayerPawnController PC;

	HDM = new Class'MegaHaloGame.HaloDeploymentMonitor';
	HDM.DeployableItem = DeployableItem;
	HDM.ParentSeq = self;
	// End:0xCB
	foreach Targets(Obj)
	{
		PC = HaloPlayerPawnController(Obj);
		// End:0xCA
		if(PC != none)
		{
			PC.AddDeploymentMonitor(HDM);
		}		
	}	
	OutputLinks[0].bHasImpulse = true;
	//return;	
}

function HasBeenDeployed(Actor NewlyDeployedItem)
{
	// End:0x3A
	if(bHasBeenDeployed == false)
	{
		DeployedItem = NewlyDeployedItem;
		bHasBeenDeployed = true;
		ForceActivateOutput(1);
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Deployed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Deployed Item",LinkVar="None",PropertyName="DeployedItem",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Wait for Deployable"
}