class GFxHaloCompass extends GFxObject within GFxMoviePlayer;

var WorldInfo ThisWorld;
var GFxHaloMinimapHUD HUD;
var HaloPlayerPawnController PlayerOwner;
var float FadeRate;
var float Springiness;
var float SpringDampening;
var float CompassAngle;
var float CompassVelocity;
var float CompassAlpha;
var GFxObject CompassNeedle;

function Init(string baseClip, GFxHaloMinimapHUD HudMovie)
{
	ThisWorld = Outer.GetPC().WorldInfo;
	HUD = HudMovie;
	CompassNeedle = Outer.GetVariableObject(("_root." $ baseClip) $ ".compass.needle");
	//return;	
}

function TransitionIn()
{
	CompassAlpha = ((checkValidity()) ? 100.0000000 : 0.0000000);
	SetFloat("_alpha", CompassAlpha);
	GotoAndPlay("transIn");
	//return;	
}

function TransitionOut()
{
	GotoAndPlay("transOut");
	//return;	
}

function bool checkValidity()
{
	return (((PlayerOwner != none) && PlayerOwner.Pawn != none) && PlayerOwner.PlayerCamera != none) && PlayerOwner.CompassHasPath();
	//return ReturnValue;	
}

function Update(float DeltaTime)
{
	local float desiredAngle, Acceleration;
	local Rotator CameraRot, navRot, distRot;

	// End:0x14E
	if(checkValidity())
	{
		CameraRot = PlayerOwner.PlayerCamera.ViewTarget.POV.Rotation;
		navRot = Rotator(Normal(PlayerOwner.GetCurrentCompassTarget() - PlayerOwner.Pawn.Location));
		distRot = navRot - CameraRot;
		desiredAngle = float(distRot.Yaw);
		// End:0x14B
		if(CompassAlpha < 100.0000000)
		{
			CompassAlpha += (FadeRate * DeltaTime);
		}		
	}
	else
	{
		desiredAngle = 0.0000000;
		// End:0x18F
		if(CompassAlpha > 0.0000000)
		{
			CompassAlpha -= (FadeRate * DeltaTime);
		}
	}
	// End:0x1B4
	if(CompassAlpha > 100.0000000)
	{
		CompassAlpha = 100.0000000;		
	}
	else
	{
		// End:0x1D6
		if(CompassAlpha < 0.0000000)
		{
			CompassAlpha = 0.0000000;
		}
	}
	// End:0x211
	if(GetFloat("_alpha") != CompassAlpha)
	{
		SetFloat("_alpha", CompassAlpha);
	}
	Acceleration = (Springiness * float(NormalizeRotAxis(int(desiredAngle - CompassAngle)))) - (SpringDampening * CompassVelocity);
	CompassAngle += ((CompassVelocity * DeltaTime) + (((0.5000000 * Acceleration) * DeltaTime) * DeltaTime));
	CompassVelocity += (Acceleration * DeltaTime);
	CompassNeedle.SetFloat("_rotation", float(int(CompassAngle) & 65535) * (360.0000000 / 65536.0000000));
	//return;	
}

defaultproperties
{
	FadeRate=150.0000000
	Springiness=9.0000000
	SpringDampening=3.0000000
}