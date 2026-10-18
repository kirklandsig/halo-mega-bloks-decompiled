class GripBTCooldown extends GripBTNode
	native;

var float MinCooldown;
var float MaxCooldown;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Prevents child execution for a given period after execution."
	DefaultTitle="Cooldown"
}