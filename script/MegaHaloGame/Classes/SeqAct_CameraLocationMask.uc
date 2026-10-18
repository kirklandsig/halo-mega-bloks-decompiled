class SeqAct_CameraLocationMask extends SequenceAction;

var LocationMaskStruct MaskParams;
var Actor TargetActor;

event Activated()
{
	local HaloPlayerPawnController PC;

	MaskParams.Name = Name;
	PC = HaloPlayerPawnController(GetController(TargetActor));
	// End:0xE6
	if(PC != none)
	{
		// End:0xAB
		if(InputLinks[0].bHasImpulse == true)
		{
			PC.CameraSetLocationMask(MaskParams);			
		}
		else
		{
			PC.CameraRemoveLocationMask(MaskParams.Name);
		}
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Remove",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Actor",LinkVar="None",PropertyName="TargetActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Location Mask"
}