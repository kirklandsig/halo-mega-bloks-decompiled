class CCSBTLastDamageSourceWasPlayer extends CCSBTScriptCondition;

var HaloAIPawn HaloPawn;
var bool Negate;

function bool ExecutePre(GripBTInterface BTInterface)
{
	HaloPawn = HaloAIPawn(Controller.Pawn);
	return (Controller != none) && HaloPawn != none;
	//return ReturnValue;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool Result;

	Result = false;
	HaloPawn = HaloAIPawn(Controller.Pawn);
	// End:0x76
	if(HaloPawn != none)
	{
		Result = HaloPawn.LastDamageSourceWasPlayer();
	}
	// End:0x9A
	if(Negate)
	{
		Result = !Result;
	}
	return Result;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	// End:0x8C
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
		NodeTitle @= "true";		
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
	NodeDescription="Returns true if the last damage source was not a turret."
	DefaultTitle="Last Damage Source Was Player"
}