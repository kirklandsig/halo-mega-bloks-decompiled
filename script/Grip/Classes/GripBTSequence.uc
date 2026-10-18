class GripBTSequence extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Play children in linear order. Return Success if all children finish successfully, Fail if any child fails, and In Progress while children are running."
	DefaultTitle="Sequence"
}