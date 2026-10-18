class GripBTFloatCondition extends GripBTNode
	native;

var GripBTNode.BTConditionOperator Operator;
var float Threshold;
var float Value;

function GripBTObject.BTNodeFamily GetFamily()
{
	return 2;
	//return ReturnValue;	
}
