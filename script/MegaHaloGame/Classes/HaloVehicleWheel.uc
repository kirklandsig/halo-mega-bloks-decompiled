class HaloVehicleWheel extends UDKVehicleWheel;

var SkeletalMesh WheelMeshRef;
var bool MirrorRenderMesh;
var float SuspensionShiftPercent;
var float TimeToWaitBetweenSuspensionSounds;
var float bTimeSinceLastContractSoundPlayed;
var float bTimeSinceLastExpandSoundPlayed;
var float MaxLongSlipRatio;
var float MaxLatSlipAngle;

defaultproperties
{
	SuspensionShiftPercent=0.5000000
	TimeToWaitBetweenSuspensionSounds=0.2500000
	MaxLongSlipRatio=1.5000000
	MaxLatSlipAngle=0.2500000
	bUseMaterialSpecificEffects=true
	MinSpinVelForParticles=2.5000000
	bPoweredWheel=true
	SteerFactor=1.0000000
	WheelRadius=72.0000000
	SuspensionTravel=50.0000000
	SuspensionSpeed=100.0000000
	LongSlipFactor=0.8000000
	LatSlipFactor=2.0000000
	HandbrakeLongSlipFactor=2.0000000
	HandbrakeLatSlipFactor=2.7500000
	ParkedSlipFactor=1.4000000
}