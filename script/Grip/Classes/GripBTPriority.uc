class GripBTPriority extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Find the highest priority behavior node able to run."
	DefaultTitle="Priority"
}