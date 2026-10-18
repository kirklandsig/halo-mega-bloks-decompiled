class GripBTTree extends GripBTPriority
	native;

var editfixedsize export editinline array<export editinline GripBTNode> AllTreeNodes;
var transient bool bBeingEdited;

defaultproperties
{
	NodeDescription="Priority node that is the root node of all behavior trees."
}