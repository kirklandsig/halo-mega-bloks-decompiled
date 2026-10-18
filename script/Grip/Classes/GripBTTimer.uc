class GripBTTimer extends GripBTNode
	native;

var float MinDuration;
var float MaxDuration;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Plays its child node for a certain amount of time, or until child Succeeds or Fails."
	DefaultTitle="Timer"
}