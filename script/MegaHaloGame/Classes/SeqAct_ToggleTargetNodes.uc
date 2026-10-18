class SeqAct_ToggleTargetNodes extends SequenceAction;

var array<name> TargetNodes;

event Activated()
{
	local int Index, nodeIndex;
	local HaloPawn aPawn;

	// End:0x133
	if(InputLinks[0].bHasImpulse == true)
	{
		Index = 0;
		J0x30:

		// End:0x130 [Loop If]
		if(Index < Targets.Length)
		{
			aPawn = HaloPawn(Targets[Index]);
			// End:0x122
			if(aPawn != none)
			{
				nodeIndex = 0;
				J0x88:

				// End:0x122 [Loop If]
				if(nodeIndex < TargetNodes.Length)
				{
					// End:0x114
					if(aPawn.TargetNodes.Find(TargetNodes[nodeIndex]) == -1)
					{
						aPawn.TargetNodes.AddItem(TargetNodes[nodeIndex]);
					}
					nodeIndex++;
					// [Loop Continue]
					goto J0x88;
				}
			}
			Index++;
			// [Loop Continue]
			goto J0x30;
		}		
	}
	else
	{
		// End:0x266
		if(InputLinks[1].bHasImpulse == true)
		{
			Index = 0;
			J0x163:

			// End:0x263 [Loop If]
			if(Index < Targets.Length)
			{
				aPawn = HaloPawn(Targets[Index]);
				// End:0x255
				if(aPawn != none)
				{
					nodeIndex = 0;
					J0x1BB:

					// End:0x255 [Loop If]
					if(nodeIndex < TargetNodes.Length)
					{
						// End:0x247
						if(aPawn.TargetNodes.Find(TargetNodes[nodeIndex]) != -1)
						{
							aPawn.TargetNodes.RemoveItem(TargetNodes[nodeIndex]);
						}
						nodeIndex++;
						// [Loop Continue]
						goto J0x1BB;
					}
				}
				Index++;
				// [Loop Continue]
				goto J0x163;
			}			
		}
		else
		{
			// End:0x3CF
			if(InputLinks[2].bHasImpulse == true)
			{
				Index = 0;
				J0x297:

				// End:0x3CF [Loop If]
				if(Index < Targets.Length)
				{
					aPawn = HaloPawn(Targets[Index]);
					// End:0x3C1
					if(aPawn != none)
					{
						nodeIndex = 0;
						J0x2EF:

						// End:0x3C1 [Loop If]
						if(nodeIndex < TargetNodes.Length)
						{
							// End:0x37E
							if(aPawn.TargetNodes.Find(TargetNodes[nodeIndex]) == -1)
							{
								aPawn.TargetNodes.AddItem(TargetNodes[nodeIndex]);								
							}
							else
							{
								aPawn.TargetNodes.RemoveItem(TargetNodes[nodeIndex]);
							}
							nodeIndex++;
							// [Loop Continue]
							goto J0x2EF;
						}
					}
					Index++;
					// [Loop Continue]
					goto J0x297;
				}
			}
		}
	}
	//return;	
}

defaultproperties
{
	InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Toggle Target Nodes"
}