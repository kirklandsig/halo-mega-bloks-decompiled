class GripBTAnd extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 2;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Returns true if both child conditions are true."
	DefaultTitle="And"
}