class CCSATAnimNodeSlot extends AnimNodeSlot
	native;

event float ActivateInput(name InputName, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride, optional float StartTime)
{
	local AnimNode ChildNode;
	local AnimNodeSequence SequenceNode;
	local int ChildIdx;

	ChildIdx = 0;
	J0x10:

	// End:0x9D [Loop If]
	if(ChildIdx < Children.Length)
	{
		// End:0x8F
		if(InputName == Children[ChildIdx].Name)
		{
			ChildNode = Children[ChildIdx].Anim;
			// [Explicit Break]
			goto J0x9D;
		}
		ChildIdx++;
		// [Loop Continue]
		goto J0x10;
	}
	J0x9D:

	SequenceNode = AnimNodeSequence(ChildNode);
	// End:0x176
	if(SequenceNode != none)
	{
		LogInternal("CCSAnimNodeSlot - Play Custom Anim" @ string(SequenceNode.AnimSeqName));
		return PlayCustomAnim(SequenceNode.AnimSeqName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);		
	}
	else
	{
		// End:0x1E1
		if(ChildNode != none)
		{
			LogInternal("CCSAnimNodeSlot - Activate Child " @ string(ChildIdx));
			ActivateChild(ChildIdx, BlendInTime);
			return BlendInTime;			
		}
		else
		{
			LogInternal("CCSAnimNodeSlot - Input not found " @ string(InputName));
		}
	}
	return 0.0000000;
	//return ReturnValue;	
}

// Export UCCSATAnimNodeSlot::execActivateChild(FFrame&, void* const)
native function ActivateChild(int ChildIdx, float BlendTime);
