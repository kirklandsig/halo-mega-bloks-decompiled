class GripBTRandom extends GripBTNode
	native;

var bool RunAll;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Randomly select one child based on weighted random values."
	DefaultTitle="Random"
}