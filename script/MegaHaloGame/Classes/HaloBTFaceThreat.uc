class HaloBTFaceThreat extends CCSBTScriptBehavior;

var Vector ThreatLocation;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagThreatLocationAsUsed();
	//return;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x43
	if(CCSBB == none)
	{
		return 1;
	}
	ThreatLocation = CCSBB.GetThreatLocation();
	Controller.SetFocalPoint(ThreatLocation);
	return 0;
	//return ReturnValue;	
}

function ExecutePost(GripBTInterface BTInterface)
{
	//return;	
}

defaultproperties
{
	NodeDescription="Sets the desired rotation to face the threat."
	DefaultTitle="Face Threat"
}