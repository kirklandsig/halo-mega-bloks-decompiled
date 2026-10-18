class CCSBTSetHealth extends CCSBTScriptBehavior;

var int Health;

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	Controller.Pawn.Health = Health;
	CCSBB.SetHealth(Health);
	return 0;
	//return ReturnValue;	
}

defaultproperties
{
	Health=280
	NodeDescription="Sets the NPC Health."
	DefaultTitle="SetHealth"
}