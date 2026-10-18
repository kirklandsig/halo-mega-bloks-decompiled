class GripBTEventCondition extends GripBTBooleanCondition
	native;

enum EventLifetime
{
	EVENTLIFETIME_TRANSIENT,        // 0
	EVENTLIFETIME_CONSUMABLE,       // 1
	EVENTLIFETIME_PERSISTENT,       // 2
	EVENTLIFETIME_MAX               // 3
};

var GripBTEventCondition.EventLifetime Lifetime;
var string EventType;

defaultproperties
{
	EventType="GlobalEvent"
	NodeDescription="Returns true if the Event Condition is true."
}