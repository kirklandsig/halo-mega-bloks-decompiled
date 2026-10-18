class GripBTLoop extends GripBTNode
	native;

var int TimesToLoop;

function SetIteration(int iter)
{
	TimesToLoop = iter;
	//return;	
}

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Play child node a specified number of times."
	DefaultTitle="Loop"
}