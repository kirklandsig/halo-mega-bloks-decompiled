class CCSBTThreatType extends CCSBTScriptCondition;

var CCSBlackboard.EThreatType TargetThreatType;
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
	CCSBB.FlagThreatLocationAsUsed();
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool Result;
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x52
	if(CCSBB == none)
	{
		return int(TargetThreatType) == int(0);
	}
	Result = int(CCSBB.GetThreatType()) == int(TargetThreatType);
	// End:0xAF
	if(Negate)
	{
		Result = Result!;
	}
	return Result;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	// End:0x91
	if(NodeName == 'None')
	{
		NodeTitle = string(DefaultTitle);
		// End:0x55
		if(Negate)
		{			
			NodeTitle @= "!=";			
		}
		else
		{			
			NodeTitle @= "==";
		}		
		NodeTitle @= string(TargetThreatType);		
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
	NodeDescription="Returns true if the last threat to the AI was the specified threat."
	DefaultTitle="Threat Type"
}