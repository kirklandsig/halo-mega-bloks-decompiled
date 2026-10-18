class CCSBTHealth extends CCSBTScriptCondition;

var GripBTNode.BTConditionOperator Operator;
var int Threshold;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagHealthAsUsed();
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool ConditionValid;
	local int Health;
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x42
	if(CCSBB == none)
	{
		return false;
	}
	ConditionValid = false;
	Health = CCSBB.GetHealth();
	switch(Operator)
	{
		// End:0xB1
		case 2:
			ConditionValid = Health == Threshold;
			// End:0x186
			break;
		// End:0xD8
		case 3:
			ConditionValid = Health != Threshold;
			// End:0x186
			break;
		// End:0xFF
		case 0:
			ConditionValid = Health < Threshold;
			// End:0x186
			break;
		// End:0x126
		case 1:
			ConditionValid = Health <= Threshold;
			// End:0x186
			break;
		// End:0x14D
		case 4:
			ConditionValid = Health > Threshold;
			// End:0x186
			break;
		// End:0x174
		case 5:
			ConditionValid = Health >= Threshold;
			// End:0x186
			break;
		// End:0xFFFF
		default:
			ConditionValid = false;
			// End:0x186
			break;
			break;
	}
	return ConditionValid;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	// End:0x12D
	if(NodeName == 'None')
	{
		NodeTitle = string(DefaultTitle);
		switch(Operator)
		{
			// End:0x5F
			case 0:				
				NodeTitle @= "<";
				// End:0x10A
				break;
			// End:0x80
			case 1:				
				NodeTitle @= "<=";
				// End:0x10A
				break;
			// End:0xA0
			case 2:				
				NodeTitle @= "=";
				// End:0x10A
				break;
			// End:0xC1
			case 3:				
				NodeTitle @= "!=";
				// End:0x10A
				break;
			// End:0xE1
			case 4:				
				NodeTitle @= ">";
				// End:0x10A
				break;
			// End:0x102
			case 5:				
				NodeTitle @= ">=";
				// End:0x10A
				break;
			// End:0xFFFF
			default:
				// DebugMode: 0
				assert(false);
				break;
		}		
		NodeTitle @= string(Threshold);		
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
	Threshold=100
	NodeDescription="Returns true if the Threshold comparison to current Health is true."
	DefaultTitle="Health"
}