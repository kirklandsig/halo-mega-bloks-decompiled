class HaloBTTargetInActiveCamo extends CCSBTScriptCondition;

var bool Negate;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagTargetsAsUsed();
	//return;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool ConditionValid;
	local CCSBlackboard CCSBB;
	local CCSTargetData currentTarget;
	local HaloPawn TargetPawn;
	local float targetCamo;

	ConditionValid = false;
	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x4E
	if(CCSBB == none)
	{
		return false;
	}
	currentTarget = CCSBB.GetCurrentTarget();
	// End:0xFC
	if(HaloPawn(currentTarget.Pawn) != none)
	{
		TargetPawn = HaloPawn(currentTarget.Pawn);
		targetCamo = TargetPawn.Camo;		
	}
	else
	{
		// End:0x181
		if(HaloPawn(currentTarget.Actor) != none)
		{
			TargetPawn = HaloPawn(currentTarget.Actor);
			targetCamo = TargetPawn.Camo;			
		}
		else
		{
			return false;
		}
	}
	ConditionValid = targetCamo == 1.0000000;
	// End:0x1C6
	if(Negate)
	{
		ConditionValid = targetCamo != 1.0000000;
	}
	return ConditionValid;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	// End:0x5A
	if(NodeName == 'None')
	{
		NodeTitle = string(DefaultTitle);
		// End:0x57
		if(Negate)
		{
			NodeTitle = "Not In Active Camo";
		}		
	}
	else
	{
		NodeTitle = string(NodeName);
	}
	return NodeTitle;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Returns true if the current target is in Active Camo."
	DefaultTitle="In Active Camo"
}