class HaloVehicleMenuCamera extends Camera
	transient;

var Vector ForcedLocation;
var Rotator ForcedRotation;
var float ForcedFOV;

function UpdateViewTarget(out TViewTarget outViewTarget, float DeltaTime)
{
	outViewTarget.POV.Location = ForcedLocation;
	outViewTarget.POV.Rotation = ForcedRotation;
	outViewTarget.POV.FOV = ForcedFOV;
	//return;	
}

defaultproperties
{
	ForcedFOV=90.0000000
	FreeCamDistance=2000.0000000
	FreeCamOffset=(X=5000.0000000,Y=0.0000000,Z=0.0000000)
}