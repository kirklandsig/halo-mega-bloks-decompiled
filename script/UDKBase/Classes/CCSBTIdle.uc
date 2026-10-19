class CCSBTIdle extends GripBTNode
	native
	dependson(CCSPawn);

var CCSPawn.ECCSAlertnessState Alertness;

defaultproperties
{
	NodeDescription="Sets NPC in a relaxed idle state."
	DefaultTitle="Idle"
}