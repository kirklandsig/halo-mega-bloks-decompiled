class GripBTOr extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 2;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Returns true if one of its child conditions is true."
	DefaultTitle="Or"
}