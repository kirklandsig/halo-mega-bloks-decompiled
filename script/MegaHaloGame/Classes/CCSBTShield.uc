class CCSBTShield extends CCSBTScriptCondition;

var GripBTNode.BTConditionOperator Operator;
var int Threshold;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool ConditionValid;
	local int Shield;
	local HaloPawn hPawn;

	hPawn = HaloPawn(Controller.Pawn);
	// End:0x42
	if(hPawn == none)
	{
		return false;
	}
	Shield = int(hPawn.GetCurrentShield());
	switch(Operator)
	{
		// End:0xA7
		case 2:
			ConditionValid = Shield == Threshold;
			// End:0x17C
			break;
		// End:0xCE
		case 3:
			ConditionValid = Shield != Threshold;
			// End:0x17C
			break;
		// End:0xF5
		case 0:
			ConditionValid = Shield < Threshold;
			// End:0x17C
			break;
		// End:0x11C
		case 1:
			ConditionValid = Shield <= Threshold;
			// End:0x17C
			break;
		// End:0x143
		case 4:
			ConditionValid = Shield > Threshold;
			// End:0x17C
			break;
		// End:0x16A
		case 5:
			ConditionValid = Shield >= Threshold;
			// End:0x17C
			break;
		// End:0xFFFF
		default:
			ConditionValid = false;
			// End:0x17C
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
	NodeDescription="Returns true if the Threshold comparison to current Shield is true."
	DefaultTitle="Shield"
}