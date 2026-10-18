class GripBTDynamicPriority extends GripBTNode
	native;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Looks downward at the value of its corresponding Weight decorator children to determine which sub-branch is the highest value, then selects that branch for execution."
	DefaultTitle="DynamicPriority"
}