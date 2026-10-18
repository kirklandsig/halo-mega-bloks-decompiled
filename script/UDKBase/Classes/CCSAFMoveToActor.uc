class CCSAFMoveToActor extends GripAFActionHandle
	native;

var Actor Target;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSAlertnessState Alertness;

defaultproperties
{
	MovementType=ECCSMovementType.CCSMovementType_Walk
}