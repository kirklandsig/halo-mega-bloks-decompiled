class HaloBTAITargetType extends CCSBTScriptCondition;

var bool Negate;
var bool PassiveObjective;
var bool PassiveSecondary;
var bool AggressiveMobile;
var bool AggressiveStationary;

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

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x42
	if(CCSBB == none)
	{
		return false;
	}
	currentTarget = CCSBB.GetCurrentTarget();
	ConditionValid = false;
	// End:0xB9
	if(PassiveObjective && int(currentTarget.AITargetType) == int(1))
	{
		ConditionValid = true;
	}
	// End:0xFB
	if(PassiveSecondary && int(currentTarget.AITargetType) == int(2))
	{
		ConditionValid = true;
	}
	// End:0x13D
	if(AggressiveMobile && int(currentTarget.AITargetType) == int(3))
	{
		ConditionValid = true;
	}
	// End:0x17F
	if(AggressiveStationary && int(currentTarget.AITargetType) == int(4))
	{
		ConditionValid = true;
	}
	// End:0x1A3
	if(Negate)
	{
		ConditionValid = !ConditionValid;
	}
	return ConditionValid;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;
	local int numChecks;

	numChecks = 0;
	// End:0x240
	if(NodeName == 'None')
	{
		NodeTitle = string(DefaultTitle);
		// End:0x64
		if(Negate)
		{			
			NodeTitle @= "is NOT";			
		}
		else
		{			
			NodeTitle @= "is";
		}
		// End:0xBE
		if(PassiveObjective)
		{			
			NodeTitle @= "Passive Objective";
			numChecks += 1;
		}
		// End:0x127
		if(PassiveSecondary)
		{
			// End:0xF3
			if(numChecks > 0)
			{				
				NodeTitle @= "OR";
			}			
			NodeTitle @= "Passive Secondary";
			numChecks += 1;
		}
		// End:0x190
		if(AggressiveMobile)
		{
			// End:0x15C
			if(numChecks > 0)
			{				
				NodeTitle @= "OR";
			}			
			NodeTitle @= "Aggressive Mobile";
			numChecks += 1;
		}
		// End:0x1FD
		if(AggressiveStationary)
		{
			// End:0x1C5
			if(numChecks > 0)
			{				
				NodeTitle @= "OR";
			}			
			NodeTitle @= "Aggressive Stationary";
			numChecks += 1;
		}
		// End:0x23D
		if(numChecks == 0)
		{			
			NodeTitle @= "INVALID (will always fail)";
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
	NodeDescription="Returns true if the current AI target matches one of the specified target types."
	DefaultTitle="AI Target Type"
}