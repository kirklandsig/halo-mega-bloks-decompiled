class HaloAIFlightNode extends SplineActor;

var bool bTrackTarget;
var HaloAIFlightController.EAIFlightBehaviors Behavior;
var float FireRate;
var float FireOffset;
var float RouteFlightSpeed;
var float ChaseDistance;
var float FollowMinDistance;
var float FollowMaxDistance;
var float SplineTime;

defaultproperties
{
	Behavior=EAIFlightBehaviors.FB_Active_Patrol
	RouteFlightSpeed=700.0000000
	SplineTime=3.0000000
}