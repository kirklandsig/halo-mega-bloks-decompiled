class CCSBTDistanceFromClosestVisibleEnemy extends CCSBTScriptCondition;

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
	CCSBB.FlagClosestVisibleEnemyAsUsed();
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool ConditionValid;
	local float distanceSquared;
	local CCSBlackboard CCSBB;
	local CCSTargetData closestVisibleEnemy;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x42
	if(CCSBB == none)
	{
		return false;
	}
	closestVisibleEnemy = CCSBB.GetClosestVisibleEnemy();
	// End:0x8F
	if(closestVisibleEnemy.Pawn == none)
	{
		return false;
	}
	distanceSquared = VSizeSq(closestVisibleEnemy.Position - Controller.Pawn.Location);
	switch(Operator)
	{
		// End:0x133
		case 2:
			ConditionValid = distanceSquared == float(Threshold * Threshold);
			// End:0x249
			break;
		// End:0x167
		case 3:
			ConditionValid = distanceSquared != float(Threshold * Threshold);
			// End:0x249
			break;
		// End:0x19B
		case 0:
			ConditionValid = distanceSquared < float(Threshold * Threshold);
			// End:0x249
			break;
		// End:0x1CF
		case 1:
			ConditionValid = distanceSquared <= float(Threshold * Threshold);
			// End:0x249
			break;
		// End:0x203
		case 4:
			ConditionValid = distanceSquared > float(Threshold * Threshold);
			// End:0x249
			break;
		// End:0x237
		case 5:
			ConditionValid = distanceSquared >= float(Threshold * Threshold);
			// End:0x249
			break;
		// End:0xFFFF
		default:
			ConditionValid = false;
			// End:0x249
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
	Threshold=500
	NodeDescription="Returns true if the Threshold comparison to distance from the closest visible enemy is true."
	DefaultTitle="Distance From Closest Visible Enemy"
}