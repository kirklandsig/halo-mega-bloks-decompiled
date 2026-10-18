class GripBTScriptCondition extends GripBTScriptNode
	abstract
	native;

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return false;
	//return ReturnValue;	
}

function GripBTObject.BTNodeFamily GetFamily()
{
	return 2;
	//return ReturnValue;	
}
