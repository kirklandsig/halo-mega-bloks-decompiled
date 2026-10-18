class GripBTSequenceOr extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Run children in linear order until one returns Success."
	DefaultTitle="Sequence"
}