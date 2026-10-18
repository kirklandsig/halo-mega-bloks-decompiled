class CCSAFMoveTo extends GripAFActionHandle
	native;

var Vector Target;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSAlertnessState Alertness;

defaultproperties
{
	MovementType=ECCSMovementType.CCSMovementType_Walk
}