class GripBTNumericCondition extends GripBTNode
	native;

var GripBTNode.BTConditionOperator Operator;
var int Threshold;
var int Value;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 2;
	//return ReturnValue;	
}
