class HaloBTRank extends CCSBTScriptCondition;

var GripBTNode.BTConditionOperator Operator;
var int CheckedRank;

function bool ExecutePre(GripBTInterface BTInterface)
{
	return ((Controller != none) && Controller.Pawn != none) && HaloAIPawn(Controller.Pawn) != none;
	//return ReturnValue;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool ConditionValid;
	local HaloAIPawn haiPawn;

	ConditionValid = false;
	haiPawn = HaloAIPawn(Controller.Pawn);
	// End:0x4E
	if(haiPawn == none)
	{
		return false;
	}
	switch(Operator)
	{
		// End:0x9D
		case 2:
			ConditionValid = haiPawn.Rank == CheckedRank;
			// End:0x1DB
			break;
		// End:0xD9
		case 3:
			ConditionValid = haiPawn.Rank != CheckedRank;
			// End:0x1DB
			break;
		// End:0x115
		case 0:
			ConditionValid = haiPawn.Rank < CheckedRank;
			// End:0x1DB
			break;
		// End:0x151
		case 1:
			ConditionValid = haiPawn.Rank <= CheckedRank;
			// End:0x1DB
			break;
		// End:0x18D
		case 4:
			ConditionValid = haiPawn.Rank > CheckedRank;
			// End:0x1DB
			break;
		// End:0x1C9
		case 5:
			ConditionValid = haiPawn.Rank >= CheckedRank;
			// End:0x1DB
			break;
		// End:0xFFFF
		default:
			ConditionValid = false;
			// End:0x1DB
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
		NodeTitle @= string(CheckedRank);		
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
	Operator=EQUAL_TO
	NodeDescription="Returns true if my rank comparison to the checked rank is true."
	DefaultTitle="Rank"
}