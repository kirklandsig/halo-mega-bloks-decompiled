class GripBTDummyAction extends GripBTNode
	native;

var GripBTNode.BTExecutionResult NextExecutionResult;
var bool NextPreConditionResult;
var bool Interruptible;
var float Duration;

defaultproperties
{
	NextExecutionResult=ER_INPROGRESS
	NextPreConditionResult=true
	Interruptible=true
	Duration=30.0000000
	NodeDescription="Special test node. Behavior that is always in progress. Terminate when push for finish."
	DefaultTitle="DummyAction"
}