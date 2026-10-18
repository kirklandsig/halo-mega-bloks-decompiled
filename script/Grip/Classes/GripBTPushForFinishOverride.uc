class GripBTPushForFinishOverride extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Decorator that prevent Push For Finish downward propagation. Typically used with Sequences and NIS's to force certain nodes to run even under interrupt."
	DefaultTitle="PF Override"
}