class HaloBTDistanceFromTether extends CCSBTScriptCondition;

var GripBTNode.BTConditionOperator Operator;
var float ThresholdMultiplier;
var bool Radial;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagTetherAsUsed();
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
	local HaloAIPawn haiPawn;
	local float distanceFromTetherSquared, scaledTetherThresholdSquared;
	local CCSBlackboard CCSBB;
	local Vector PawnLocation, tetherLocation;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x42
	if(CCSBB == none)
	{
		return false;
	}
	tetherLocation = CCSBB.GetCurrentTether();
	ConditionValid = false;
	haiPawn = HaloAIPawn(Controller.Pawn);
	// End:0xB9
	if(haiPawn == none)
	{
		return false;
	}
	PawnLocation = haiPawn.Location;
	// End:0x132
	if(Radial)
	{
		PawnLocation.Z = 0.0000000;
		tetherLocation.Z = 0.0000000;
	}
	scaledTetherThresholdSquared = ((haiPawn.TetherDistance * ThresholdMultiplier) * haiPawn.TetherDistance) * ThresholdMultiplier;
	distanceFromTetherSquared = VSizeSq(tetherLocation - PawnLocation);
	switch(Operator)
	{
		// End:0x1EA
		case 2:
			ConditionValid = distanceFromTetherSquared == scaledTetherThresholdSquared;
			// End:0x2BF
			break;
		// End:0x211
		case 3:
			ConditionValid = distanceFromTetherSquared != scaledTetherThresholdSquared;
			// End:0x2BF
			break;
		// End:0x238
		case 0:
			ConditionValid = distanceFromTetherSquared < scaledTetherThresholdSquared;
			// End:0x2BF
			break;
		// End:0x25F
		case 1:
			ConditionValid = distanceFromTetherSquared <= scaledTetherThresholdSquared;
			// End:0x2BF
			break;
		// End:0x286
		case 4:
			ConditionValid = distanceFromTetherSquared > scaledTetherThresholdSquared;
			// End:0x2BF
			break;
		// End:0x2AD
		case 5:
			ConditionValid = distanceFromTetherSquared >= scaledTetherThresholdSquared;
			// End:0x2BF
			break;
		// End:0xFFFF
		default:
			ConditionValid = false;
			// End:0x2BF
			break;
			break;
	}
	return ConditionValid;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	// End:0x142
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
		NodeTitle @= (string(ThresholdMultiplier) @ "* Tether Distance");		
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
	ThresholdMultiplier=1.0000000
	Radial=true
	NodeDescription="Returns true if the current distance from tether comparison to max tether distance is true."
	DefaultTitle="Distance from Tether"
}