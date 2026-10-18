class SeqAct_VehicleTargetOfInterest extends SequenceAction;

var Actor TargetOfInterest;
var float inTime;
var float viewTime;
var float outTime;
var Vector SeatOffsetAdjustment;

event Activated()
{
	local HaloVehicle aVehicle;
	local int Index;

	// End:0xDA
	if(InputLinks[0].bHasImpulse == true)
	{
		Index = 0;
		J0x30:

		// End:0xD7 [Loop If]
		if(Index < Targets.Length)
		{
			aVehicle = HaloVehicle(Targets[Index]);
			// End:0xC9
			if(aVehicle != none)
			{
				aVehicle.TargetOfInterestSet(TargetOfInterest, inTime, viewTime, outTime, SeatOffsetAdjustment);
			}
			Index++;
			// [Loop Continue]
			goto J0x30;
		}		
	}
	else
	{
		// End:0x18D
		if(InputLinks[1].bHasImpulse == true)
		{
			Index = 0;
			J0x10A:

			// End:0x18D [Loop If]
			if(Index < Targets.Length)
			{
				aVehicle = HaloVehicle(Targets[Index]);
				// End:0x17F
				if(aVehicle != none)
				{
					aVehicle.TargetOfInterestRemove(TargetOfInterest);
				}
				Index++;
				// [Loop Continue]
				goto J0x10A;
			}
		}
	}
	//return;	
}

defaultproperties
{
	inTime=1.0000000
	viewTime=2.0000000
	outTime=1.0000000
	InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SequenceVariable',LinkedVariables=none,LinkDesc="Target Of Interest",LinkVar="None",PropertyName="TargetOfInterest",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Target Of Interest"
}