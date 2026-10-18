class CCSBTSetGroundSpeed extends CCSBTScriptBehavior;

var float GroundSpeed;

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	Controller.Pawn.GroundSpeed = GroundSpeed;
	return 0;
	//return ReturnValue;	
}

defaultproperties
{
	GroundSpeed=600.0000000
	NodeDescription="Sets the NPC's ground speed."
	DefaultTitle="Set Ground Speed"
}