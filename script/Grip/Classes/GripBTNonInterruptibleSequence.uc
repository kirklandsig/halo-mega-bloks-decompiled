class GripBTNonInterruptibleSequence extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Play children in linear order. Return Success if all children finish successfully and In Progress while children are running. If one child returns Fail remaining children will attempt to run regardless."
	DefaultTitle="NIS"
}