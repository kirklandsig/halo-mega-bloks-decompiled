class SeqAct_CameraAllowEncounters extends SequenceAction;

event Activated()
{
	local HaloPlayerPawnController PC;
	local int Index;

	// End:0xC9
	if(InputLinks[0].bHasImpulse == true)
	{
		Index = 0;
		J0x30:

		// End:0xC6 [Loop If]
		if(Index < Targets.Length)
		{
			PC = HaloPlayerPawnController(GetController(Actor(Targets[Index])));
			// End:0xB8
			if(PC != none)
			{
				PC.CameraEncounterDisableRemove(Name);
			}
			Index++;
			// [Loop Continue]
			goto J0x30;
		}		
	}
	else
	{
		// End:0x18F
		if(InputLinks[1].bHasImpulse == true)
		{
			Index = 0;
			J0xF9:

			// End:0x18F [Loop If]
			if(Index < Targets.Length)
			{
				PC = HaloPlayerPawnController(GetController(Actor(Targets[Index])));
				// End:0x181
				if(PC != none)
				{
					PC.CameraEncounterDisableAdd(Name);
				}
				Index++;
				// [Loop Continue]
				goto J0xF9;
			}
		}
	}
	//return;	
}

defaultproperties
{
	InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Allow Encounters"
}