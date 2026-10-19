class HaloBTGrenadeCount extends CCSBTScriptCondition;

var GripBTNode.BTConditionOperator Operator;
var int Threshold;

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool ConditionValid;
	local HaloPlayerInventoryManager HaloInvMgr;
	local int GrenadeCount;

	ConditionValid = false;
	GrenadeCount = 0;
	HaloInvMgr = HaloPlayerInventoryManager(Controller.Pawn.InvManager);
	// End:0xB8
	if(HaloInvMgr != none)
	{
		GrenadeCount = int(HaloInvMgr.FragGrenadeCount) + int(HaloInvMgr.PlasmaGrenadeCount);
	}
	switch(Operator)
	{
		// End:0xF2
		case 2:
			ConditionValid = GrenadeCount == Threshold;
			// End:0x1C7
			break;
		// End:0x119
		case 3:
			ConditionValid = GrenadeCount != Threshold;
			// End:0x1C7
			break;
		// End:0x140
		case 0:
			ConditionValid = GrenadeCount < Threshold;
			// End:0x1C7
			break;
		// End:0x167
		case 1:
			ConditionValid = GrenadeCount <= Threshold;
			// End:0x1C7
			break;
		// End:0x18E
		case 4:
			ConditionValid = GrenadeCount > Threshold;
			// End:0x1C7
			break;
		// End:0x1B5
		case 5:
			ConditionValid = GrenadeCount >= Threshold;
			// End:0x1C7
			break;
		// End:0xFFFF
		default:
			ConditionValid = false;
			// End:0x1C7
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
	Operator=GREATER_THAN_OR_EQUAL_TO
	Threshold=1
	NodeDescription="Returns true if the number of grenades in comparison to the threshold is true."
	DefaultTitle="Grenade Count"
}