class SeqAct_EnterHighwayMode extends SequenceAction;

var HaloVehicle Vehicle;
var Class<HaloVehicle> vehicleType;

event Activated()
{
	local HaloPlayerGroup thePlayerGroup;
	local int I;

	// End:0x20E
	if((Vehicle != none) && Vehicle.IsA(vehicleType.Name))
	{
		Vehicle.PushState('HighwayMode');
		thePlayerGroup = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetPlayerGroup();
		I = 0;
		J0xDA:

		// End:0x1C9 [Loop If]
		if(I < thePlayerGroup.PlayerControllers.Length)
		{
			// End:0x1BB
			if(thePlayerGroup.PlayerControllers[I].Pawn.IsA('HaloPawn'))
			{
				Vehicle.PassengerEnter(thePlayerGroup.PlayerControllers[I].Pawn, 1);
			}
			I++;
			// [Loop Continue]
			goto J0xDA;
		}
		// End:0x20E
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
	ObjName="Enter HighwayMode"
}