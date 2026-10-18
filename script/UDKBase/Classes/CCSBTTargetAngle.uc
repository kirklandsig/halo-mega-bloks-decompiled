class CCSBTTargetAngle extends GripBTBooleanCondition
	native;

var bool Front;
var bool Right;
var bool Behind;
var bool Left;

defaultproperties
{
	NodeDescription="Returns true if the target is in one of the specified quadrants."
	DefaultTitle="Target Angle"
}