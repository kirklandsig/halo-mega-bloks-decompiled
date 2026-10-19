class CCSAFMoveTo extends GripAFActionHandle
	native
	dependson(CCSPawn);

var Vector Target;
var CCSPawn.ECCSMovementType MovementType;
var CCSPawn.ECCSAlertnessState Alertness;

defaultproperties
{
	MovementType=CCSMovementType_Walk
}