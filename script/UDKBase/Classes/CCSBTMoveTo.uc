class CCSBTMoveTo extends GripBTNode
	abstract
	native;

var bool DummyVarToAvoidUnrealScriptCompilerErrorWhenDeclaringAnEnumVarAsFirstVariable;
var CCSPawn.ECCSMovementSpeed Speed;
var CCSPawn.ECCSAlertnessState Alertness;
var CCSPawn.ECCSMovementType MovementType;
var float ShootChance;
var float ChargedShotChance;
var int FireBurstPerShot;
var float DelayBetweenBursts;
var float PrimaryAttackRange;
var float SecondaryAttackRange;
var float PrimaryTargetWeight;
var float PlayerSecondaryWeight;
var float ObjectiveSecondaryWeight;
var float ReactiveSecondaryWeight;

defaultproperties
{
	ShootChance=0.2500000
	FireBurstPerShot=3
	DelayBetweenBursts=0.4000000
	PrimaryAttackRange=5000.0000000
	SecondaryAttackRange=5000.0000000
	PrimaryTargetWeight=1.0000000
	PlayerSecondaryWeight=1.0000000
	ObjectiveSecondaryWeight=1.0000000
	ReactiveSecondaryWeight=1.0000000
	NodeDescription="Move to base node."
}