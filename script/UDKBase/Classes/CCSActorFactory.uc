class CCSActorFactory extends GwNavActorFactoryAI
	native
	config(Editor)
	editinlinenew
	collapsecategories
	dependson(CCSSystemConfig);

var CCSBTTree BehaviorTree;
var CCSSystemConfigData Config;
var bool SpawningVehicle;
var float VehicleMoveToRadius;

defaultproperties
{
	Config=(MaxAwareRadius=10000.0000000,MaxSightRadius=4300.0000000,MaxBehindSightRadius=400.0000000,MaxHearingRadius=4300.0000000,VisionCone=180.0000000,PassiveObjectiveWeight=-1.0000000,PassiveSecondaryWeight=-1.0000000,AggressiveMobileWeight=-1.0000000,AggressiveStationaryWeight=-1.0000000,CoverQueryRadius=5000.0000000,TargetSelection=CCSTargetPlayer,Movement=CCSMovementGwNav)
	VehicleMoveToRadius=2000.0000000
	ControllerClass=Class'UDKBase.CCSController'
}