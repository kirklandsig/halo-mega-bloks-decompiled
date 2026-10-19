class CCSBTOrientTowardTarget extends GripBTNode
	native
	dependson(CCSPawn);

var CCSPawn.ECCSAlertnessState Alertness;

defaultproperties
{
	NodeDescription="Orient toward current target."
	DefaultTitle="OrientTowardTarget"
}