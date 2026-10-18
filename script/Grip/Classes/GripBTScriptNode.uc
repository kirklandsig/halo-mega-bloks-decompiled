class GripBTScriptNode extends GripBTNode
	abstract
	native;

var Object Owner;
var bool ConditionCache;
var transient int NodeTitleOverride;

function Initialize()
{
	//return;	
}

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return true;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	//return ReturnValue;	
}

event GripBTNode.BTExecutionResult ExecutePass(GripBTInterface BTInterface, bool FirstExecution, bool PushToFinish)
{
	//return ReturnValue;	
}

defaultproperties
{
	NodeTitleOverride=-1
}