class CCSAFMoveToActor extends GripAFActionHandle
	native
	dependson(CCSPawn);

var Actor Target;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSAlertnessState Alertness;

defaultproperties
{
	MovementType=CCSMovementType_Walk
}