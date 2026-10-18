class CCSBTTimeSinceEvent extends GripBTFloatCondition
	native;

var CCSBlackboard.EEventType RelevantEvent;
var Class<Actor> RelevantActorClass;
var float MaxDistance;

defaultproperties
{
	RelevantActorClass=Class'Engine.Actor'
	MaxDistance=10000.0000000
	NodeDescription="Returns true if a specific event was received within the time threshold and distance threshold."
	DefaultTitle="Time Since Event"
}