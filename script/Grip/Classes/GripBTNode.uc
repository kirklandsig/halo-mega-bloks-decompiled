class GripBTNode extends GripBTObject
	abstract
	native;

enum BTEvaluationResult
{
	EVR_READY,                      // 0
	EVR_NOT_READY,                  // 1
	EVR_OVER,                       // 2
	EVR_MAX                         // 3
};

enum BTExecutionResult
{
	ER_SUCCESS,                     // 0
	ER_FAILURE,                     // 1
	ER_INPROGRESS,                  // 2
	ER_INTERRUPTING,                // 3
	ER_SUCCESSFULLY_INTERRUPTED,    // 4
	ER_READY,                       // 5
	ER_NOT_READY,                   // 6
	ER_MAX                          // 7
};

enum BTConditionOperator
{
	LESS_THAN,                      // 0
	LESS_THAN_OR_EQUAL_TO,          // 1
	EQUAL_TO,                       // 2
	NOT_EQUAL_TO,                   // 3
	GREATER_THAN,                   // 4
	GREATER_THAN_OR_EQUAL_TO,       // 5
	BTConditionOperator_MAX         // 6
};

var GripBTNode ParentNode;
var editfixedsize export editinline array<export editinline NodeChild> Children;
var float RandomWeight;
var name NodeName;
var editconst string NodeDescription;
var string Comment;
var name DefaultTitle;
var GripBTNode.BTExecutionResult LastExecutionResult;
var GripBTNode.BTEvaluationResult LastEvaluationResult;
var int DummyVarJustSoBaseClassDontEndWithAByteToAvoidCompilerWarning;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 0;
	//return ReturnValue;	
}

defaultproperties
{
	RandomWeight=1.0000000
	DefaultTitle="[DEFAULT_TITLE]"
}