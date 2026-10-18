class HaloBTThrowGrenade extends CCSBTScriptBehavior;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagTargetsAsUsed();
	//return;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local HaloAIPawn haiPawn;
	local CCSBlackboard CCSBB;
	local CCSTargetData currentTarget;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x43
	if(CCSBB == none)
	{
		return 1;
	}
	currentTarget = CCSBB.GetCurrentTarget();
	haiPawn = HaloAIPawn(Controller.Pawn);
	// End:0xAF
	if(haiPawn == none)
	{
		return 1;
	}
	// End:0x10F
	if(currentTarget.Pawn != none)
	{
		Controller.TargetObj = currentTarget.Pawn;		
	}
	else
	{
		// End:0x16F
		if(currentTarget.Actor != none)
		{
			Controller.TargetObj = currentTarget.Actor;			
		}
		else
		{
			return 1;
		}
	}
	haiPawn.ThrowGrenade();
	return 0;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Throws a grenade"
	DefaultTitle="Throw Grenade"
}