class HaloBTTetherInVehicle extends CCSBTScriptCondition;

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
	return false;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	NodeTitle = "Tether";
	// End:0x6F
	if(NodeName == 'None')
	{
		// End:0x56
		if(Negate)
		{			
			NodeTitle @= "Is NOT";			
		}
		else
		{			
			NodeTitle @= "Is";
		}
	}	
	NodeTitle @= string(DefaultTitle);
	return NodeTitle;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Returns true if my tether is in a vehicle."
	DefaultTitle="Tether In Vehicle"
}