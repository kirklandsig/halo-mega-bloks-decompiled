class SeqAct_ExitHighwayMode extends SequenceAction;

var HaloVehicle Vehicle;

event Activated()
{
	// End:0x74
	if(Vehicle != none)
	{
		Vehicle.PopState();
		// End:0x74
		if(OutputLinks[1].bHasImpulse!)
		{
			OutputLinks[0].bHasImpulse = true;
		}
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	bAutoActivateOutputLinks=false
	InputLinks[0]=(LinkDesc="Vehicle Input",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	OutputLinks[0]=(Links=none,LinkDesc="Succeeded",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="HaloVehicle",LinkVar="None",PropertyName="Vehicle",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Exit HighwayMode"
}