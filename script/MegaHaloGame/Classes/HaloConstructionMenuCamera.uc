class HaloConstructionMenuCamera extends Camera
	transient;

var private Vector ForcedLocation;
var private Rotator ForcedRotation;
var private Vector ForcedDesiredLocation;
var private Rotator ForcedDesiredRotation;
var private float ForcedFOV;
var bool bUseStartLocation;
var bool bUpdatedPosition;
var bool bCameraInterp;
var bool bLocked;
var bool bInterpolatingToStart;
var bool bHasBeenInitialized;
var Vector StartLocation;
var Rotator StartRotation;
var Vector BoxExtent;
var Vector ObjLocation;
var Rotator ObjRotation;
var Rotator ObjOriginRotation;
var Vector FocusPos;
var float DefaultDeg;
var float CurrentDeg;
var float XScale;
var float YScale;
var float MinRatio;
var float HeightOffset;
var Vector2D DesiredScreenPos;
var Vector DesiredScreenWorldPos;
var HaloPlayerPawnController Controller;
var float X1;
var float X2;
var float Y1;
var float Y2;
var AkEvent ActivateSound;

function UpdateViewTarget(out TViewTarget outViewTarget, float DeltaTime)
{
	outViewTarget.POV.Location = ForcedLocation;
	outViewTarget.POV.Rotation = ForcedRotation;
	outViewTarget.POV.FOV = ForcedFOV;
	//return;	
}

function SetBounds(BoxSphereBounds Extent, Vector objloc, Rotator objrot, Rotator objoriginrot, optional HaloPlayerPawnController HPPC)
{
	BoxExtent = Extent.BoxExtent;
	ObjLocation = objloc;
	ObjRotation = objrot;
	ObjOriginRotation = objoriginrot;
	FocusPos = ObjLocation;
	Controller = HPPC;
	// End:0x152
	if(BoxExtent.X >= BoxExtent.Y)
	{
		// End:0x14F
		if((BoxExtent.Y / BoxExtent.X) < MinRatio)
		{
			BoxExtent.Y = BoxExtent.X * MinRatio;
		}		
	}
	else
	{
		// End:0x1DE
		if((BoxExtent.X / BoxExtent.Y) < MinRatio)
		{
			BoxExtent.X = BoxExtent.Y * MinRatio;
		}
	}
	InitCamera();
	//return;	
}

function InitCamera()
{
	local float rad, X, Y;
	local Vector NewPos, myloc;
	local Rotator myrot;
	local float Angle, adjacent, hypotenuse, offsetScale;
	local Vector Direction;
	local Vector2D ScreenPos;
	local Vector ScreenCenter;

	CurrentDeg = DefaultDeg;
	rad = CurrentDeg * 0.0174533;
	X = Cos(rad);
	Y = Sin(rad);
	NewPos.X = (BoxExtent.X * X) * XScale;
	NewPos.Y = (BoxExtent.Y * Y) * YScale;
	NewPos.Z = 0.0000000;
	NewPos = NewPos >> ObjOriginRotation;
	NewPos = NewPos >> ObjRotation;
	NewPos.X += ObjLocation.X;
	NewPos.Y += ObjLocation.Y;
	NewPos.Z = ObjLocation.Z + HeightOffset;
	myloc = NewPos;
	myrot = Rotator(FocusPos - myloc);
	ForcedLocation = myloc;
	ForcedRotation = myrot;
	UpdateCamera(0.0000000);
	// End:0x4E5
	if((Controller != none) && LocalPlayer(Controller.Player) != none)
	{
		ScreenPos.X = 0.5000000;
		ScreenPos.Y = 0.5000000;
		LocalPlayer(Controller.Player).DeProject(ScreenPos, ScreenCenter, Direction);
		LocalPlayer(Controller.Player).DeProject(DesiredScreenPos, DesiredScreenWorldPos, Direction);
		adjacent = VSize(ScreenCenter - myloc);
		hypotenuse = VSize(DesiredScreenWorldPos - myloc);
		hypotenuse = ((hypotenuse == 0.0000000) ? 1.0000000 : hypotenuse);
		Angle = Acos(adjacent / hypotenuse);
		adjacent = VSize(FocusPos - myloc);
		offsetScale = Tan(Angle) * adjacent;
		// End:0x4B2
		if(DesiredScreenPos.X > 0.5000000)
		{
			offsetScale *= -1.0000000;
		}
		X1 = VSize(FocusPos - myloc);
		Y1 = offsetScale;
	}
	bHasBeenInitialized = true;
	// End:0x55F
	if(bUseStartLocation == true)
	{
		ForcedLocation = StartLocation;
		ForcedDesiredLocation = StartLocation;
		ForcedRotation = StartRotation;
		ForcedDesiredRotation = StartRotation;
		UpdateCamera(0.0000000);		
	}
	else
	{
		UpdatePosition(DefaultDeg);
	}
	PlayAkEvent(ActivateSound);
	//return;	
}

function UpdatePosition(float degChange)
{
	local float rad, X, Y;
	local Vector NewPos, myloc;
	local Rotator myrot;

	// End:0x24
	if((bLocked == true) || bHasBeenInitialized == false)
	{
		return;
	}
	CurrentDeg += degChange;
	ReRangeCurrentDeg();
	rad = CurrentDeg * 0.0174533;
	X = Cos(rad);
	Y = Sin(rad);
	NewPos.X = (BoxExtent.X * X) * XScale;
	NewPos.Y = (BoxExtent.Y * Y) * YScale;
	NewPos.Z = 0.0000000;
	NewPos = NewPos >> ObjOriginRotation;
	NewPos = NewPos >> ObjRotation;
	NewPos.X += ObjLocation.X;
	NewPos.Y += ObjLocation.Y;
	NewPos.Z = ObjLocation.Z + HeightOffset;
	myloc = NewPos;
	myrot = Rotator(FocusPos - myloc);
	myloc += (GetCameraWorldOffset(myloc, myrot));
	// End:0x2CF
	if(bCameraInterp == true)
	{
		ForcedDesiredLocation = myloc;
		ForcedDesiredRotation = myrot;		
	}
	else
	{
		ForcedLocation = myloc;
		ForcedRotation = myrot;
	}
	bUpdatedPosition = true;
	//return;	
}

function Vector GetCameraWorldOffset(Vector myloc, Rotator myrot)
{
	local Vector camRight, CamOffset;

	// End:0x9A
	if(X1 != 0.0000000)
	{
		X2 = VSize(FocusPos - myloc);
		Y2 = (X2 * Y1) / X1;
		camRight = Normal(GetRotatorAxis(myrot, 1));
		CamOffset = camRight * Y2;
	}
	return CamOffset;
	//return ReturnValue;	
}

function UpdateFocusPos(Vector pos, optional bool updateObjOrigin = false, optional float minDeg = -1.0000000, optional float maxDeg = -1.0000000)
{
	FocusPos = pos;
	// End:0x4D
	if(updateObjOrigin == true)
	{
		ObjLocation = FocusPos;
	}
	// End:0x95
	if((minDeg != float(-1)) && maxDeg != float(-1))
	{
		HandleDegreeRange(minDeg, maxDeg);
	}
	UpdatePosition(0.0000000);
	//return;	
}

function HandleDegreeRange(float minDeg, float maxDeg)
{
	local float minDiff, MaxDiff;

	ReRangeCurrentDeg();
	// End:0xC5
	if(minDeg > maxDeg)
	{
		// End:0xC2
		if((CurrentDeg < minDeg) && CurrentDeg > maxDeg)
		{
			minDiff = minDeg - CurrentDeg;
			MaxDiff = CurrentDeg - maxDeg;
			CurrentDeg = ((minDiff <= MaxDiff) ? minDeg : maxDeg);
		}		
	}
	else
	{
		// End:0x1CA
		if((CurrentDeg < minDeg) || CurrentDeg > maxDeg)
		{
			// End:0x152
			if(CurrentDeg < minDeg)
			{
				minDiff = minDeg - CurrentDeg;
				MaxDiff = CurrentDeg + (360.0000000 - maxDeg);				
			}
			else
			{
				minDiff = (360.0000000 - CurrentDeg) + minDeg;
				MaxDiff = CurrentDeg - maxDeg;
			}
			CurrentDeg = ((minDiff <= MaxDiff) ? minDeg : maxDeg);
		}
	}
	//return;	
}

function ReRangeCurrentDeg()
{
	J0x00:
	// End:0x2A [Loop If]
	if(CurrentDeg >= float(360))
	{
		CurrentDeg -= float(360);
		// [Loop Continue]
		goto J0x00;
	}
	J0x2A:

	// End:0x50 [Loop If]
	if(CurrentDeg < float(0))
	{
		CurrentDeg += float(360);
		// [Loop Continue]
		goto J0x2A;
	}
	//return;	
}

function Tick(float DeltaTime)
{
	// End:0xB6
	if((bCameraInterp == true) && bLocked == false)
	{
		ForcedLocation = VInterpTo(ForcedLocation, ForcedDesiredLocation, DeltaTime, ((bUpdatedPosition) ? 7.5000000 : 4.7500000));
		ForcedRotation = RInterpTo(ForcedRotation, ForcedDesiredRotation, DeltaTime, ((bUpdatedPosition) ? 7.5000000 : 4.7500000));		
	}
	else
	{
		// End:0x167
		if(bInterpolatingToStart == true)
		{
			ForcedLocation = VInterpTo(ForcedLocation, ForcedDesiredLocation, DeltaTime, 2.0000000);
			ForcedRotation = RInterpTo(ForcedRotation, ForcedDesiredRotation, DeltaTime, 2.0000000);
			// End:0x167
			if(VSizeSq(ForcedLocation - ForcedDesiredLocation) < 1000.0000000)
			{
				bInterpolatingToStart = false;
				bLocked = false;
			}
		}
	}
	bUpdatedPosition = false;
	//return;	
}

function CalculateAndInterpToNearestStartDegree()
{
	CurrentDeg = 0.0000000;
	bLocked = false;
	bInterpolatingToStart = true;
	UpdatePosition(DefaultDeg);
	bLocked = true;
	//return;	
}

function bool IsMoveable()
{
	return (bLocked == false) && bInterpolatingToStart == false;
	//return ReturnValue;	
}

defaultproperties
{
	ForcedFOV=90.0000000
	bCameraInterp=true
	XScale=0.7500000
	YScale=0.7500000
	MinRatio=1.0000000
	HeightOffset=1000.0000000
	DesiredScreenPos=(X=0.5000000,Y=0.6300000)
}