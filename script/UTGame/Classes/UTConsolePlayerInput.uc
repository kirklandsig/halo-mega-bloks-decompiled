class UTConsolePlayerInput extends UTPlayerInput within UTConsolePlayerController
	transient
	config(Input);

var float SensitivityMultiplier;
var float TurningAccelerationMultiplier;
var config bool bAutoCenterPitch;
var config bool bAutoCenterVehiclePitch;
var config bool bViewAccelerationEnabled;
var protected config bool bDebugViewAcceleration;
var config bool bTargetFrictionEnabled;
var protected config bool bDebugTargetFriction;
var protected bool bAppliedTargetFriction;
var private bool bIsLookingUp;
var private bool bIsLookingDown;
var float LastTurnTime;
var globalconfig float AutoCenterDelay;
var globalconfig float AutoVehicleCenterSpeed;
var globalconfig float SlowTurnScaling;
var config float ViewAccel_YawThreshold;
var config float ViewAccel_DiagonalThreshold;
var config float ViewAccel_BaseMultiplier;
var private float ViewAccel_CurrMutliplier;
var config float ViewAccel_TimeToHoldBeforeFastAcceleration;
var private float ViewAccel_TimeHeld;
var config float ViewAccel_Twitchy;
var config float Dodge_Threshold;
var private Pawn LastFrictionTarget;
var private float LastFrictionTargetTime;
var private float LastDistToTarget;
var private float LastDistMultiplier;
var private float LastDistFromAimZ;
var private float LastDistFromAimY;
var private float LastFrictionMultiplier;
var private float LastAdhesionAmtY;
var private float LastAdhesionAmtZ;
var private float LastTargetRadius;
var private float LastTargetHeight;
var private float LastDistFromAimYa;
var private float LastDistFromAimZa;
var private float LastAdjustY;
var private float LastAdjustZ;
var private Vector LastCamLoc;
var private Rotator LastDeltaRot;
var config float LeftThumbStickDeadZoneThreshold;
var config float RightThumbStickDeadZoneThreshold;
var config float MagicScaleForSensitivityMiddle;
var config float MagicScaleForSensitivityEdge;
var config float ViewAccel_RampSpeed;
var config float ViewAccel_MaxTurnSpeed;
var config float ViewAccel_PitchThreshold;
var config float ViewAccel_LookingUpOrDownBoundary;
var config float ViewAccel_BackToCenterBoundary;
var config float ViewAccel_BackToCenterSpeed;
var config float AutoPitchCenterSpeed;
var config float AutoPitchStopAdjustingValue;
var config float HoverBoardPitchMultiplier;

simulated event PostBeginPlay()
{
	ViewAccel_CurrMutliplier = ViewAccel_BaseMultiplier;
	//return;	
}

function PreProcessInput(float DeltaTime)
{
	local UTWeapon UW;
	local bool bUsingTiltController;

	super(PlayerInput).PreProcessInput(DeltaTime);
	RawJoyLookRight = aMouseX;
	RawJoyLookUp = aMouseY;
	// End:0x5F
	if(Outer.Pawn == none)
	{
		return;
	}
	// End:0x23A
	if(bUsingGamepad!)
	{
		// End:0x1BD
		if((UTGameReplicationInfo(Outer.WorldInfo.GRI) != none) && UTGameReplicationInfo(Outer.WorldInfo.GRI).bAllowKeyboardAndMouse!)
		{
			RawJoyLookRight = 0.0000000;
			RawJoyLookUp = 0.0000000;
			aBaseX = 0.0000000;
			aBaseY = 0.0000000;
			aBaseZ = 0.0000000;
			aMouseX = 0.0000000;
			aMouseY = 0.0000000;
			aForward = 0.0000000;
			aTurn = 0.0000000;
			aStrafe = 0.0000000;
			aUp = 0.0000000;
			aLookUp = 0.0000000;
		}
		aTurn *= 1.5000000;
		aLookUp *= 1.5000000;
		aMouseX *= 1.5000000;
		aMouseY *= 1.5000000;
		// End:0x23A
		if(Outer.WorldInfo.IsConsoleBuild(3)!)
		{
			return;
		}
	}
	bUsingTiltController = false;
	// End:0x26C
	if(Outer.Pawn == none)
	{
		return;
	}
	bUsingTiltController = UTConsolePlayerController(Outer.Pawn.Controller).IsControllerTiltActive();
	UW = UTWeapon(Outer.Pawn.Weapon);
	// End:0x340
	if(bViewAccelerationEnabled && bUsingTiltController!)
	{
		ApplyViewAcceleration(DeltaTime);
	}
	// End:0x384
	if(bTargetFrictionEnabled)
	{
		// End:0x384
		if(UW != none)
		{
			bAppliedTargetFriction = false;
			ApplyTargetFriction(DeltaTime, UW);
		}
	}
	// End:0x410
	if(bAppliedTargetFriction! && (UW != none) && int(UW.GetZoomedState()) != int(3))
	{
		// End:0x3F0
		if(bAutoCenterPitch)
		{
			ApplyViewAutoPitchCentering(DeltaTime);
		}
		// End:0x410
		if(bAutoCenterVehiclePitch)
		{
			ApplyViewAutoVehiclePitchCentering(DeltaTime);
		}
	}
	// End:0x49D
	if((UW != none) && int(UW.GetZoomedState()) == int(3))
	{
		aTurn *= UW.ZoomedTurnSpeedScalePct;
		aLookUp *= UW.ZoomedTurnSpeedScalePct;
	}
	aTurn *= TurningAccelerationMultiplier;
	aTurn *= SensitivityMultiplier;
	aLookUp *= SensitivityMultiplier;
	// End:0x51A
	if(UTVehicle_Hoverboard(Outer.Pawn) != none)
	{
		aLookUp *= HoverBoardPitchMultiplier;
	}
	//return;	
}

function ApplyViewAutoPitchCentering(float DeltaTime)
{
	local float AmountToAdjustPitch, CurrentPitch;

	// End:0xCB
	if(((Abs(RawJoyLookUp) > float(0)) || Outer.Pawn.IsFiring()) || int(Outer.Pawn.Physics) == int(2))
	{
		LastTurnTime = Outer.WorldInfo.TimeSeconds;
		return;
	}
	// End:0x2D8
	if(((Outer.WorldInfo.TimeSeconds - LastTurnTime) > AutoCenterDelay) && VSize(Outer.Pawn.Velocity) > 10.0000000)
	{
		CurrentPitch = float(NormalizeRotAxis(Outer.Rotation.Pitch));
		AmountToAdjustPitch = FInterpTo(CurrentPitch, 0.0000000, DeltaTime, AutoPitchCenterSpeed) - CurrentPitch;
		// End:0x2D8
		if(Abs(AmountToAdjustPitch) > AutoPitchStopAdjustingValue)
		{
			// End:0x270
			if(AmountToAdjustPitch < AutoPitchStopAdjustingValue)
			{
				// End:0x247
				if(bInvertMouse == false)
				{
					aLookUp += FMin(-1.0000000 * AmountToAdjustPitch, AutoPitchCenterSpeed);					
				}
				else
				{
					aLookUp -= FMin(-1.0000000 * AmountToAdjustPitch, AutoPitchCenterSpeed);
				}				
			}
			else
			{
				// End:0x2D8
				if(AmountToAdjustPitch > AutoPitchStopAdjustingValue)
				{
					// End:0x2B9
					if(bInvertMouse == false)
					{
						aLookUp -= FMin(AmountToAdjustPitch, AutoPitchCenterSpeed);						
					}
					else
					{
						aLookUp += FMin(AmountToAdjustPitch, AutoPitchCenterSpeed);
					}
				}
			}
		}
	}
	//return;	
}

function ApplyViewAutoVehiclePitchCentering(float DeltaTime)
{
	local int VehicleYaw, CameraYaw;
	local float OldaBaseY, ForwardMag, AmountToAdjustPitch, CurrentPitch;

	// End:0x4AD
	if(((UTVehicle(Outer.Pawn) != none) && UTVehicle(Outer.Pawn).bFollowLookDir!) && UTVehicle(Outer.Pawn).bShouldAutoCenterViewPitch)
	{
		// End:0x13D
		if((aTurn != float(0)) || Outer.Pawn.IsFiring())
		{
			LastTurnTime = Outer.WorldInfo.TimeSeconds;			
		}
		else
		{
			// End:0x428
			if((Outer.WorldInfo.TimeSeconds - LastTurnTime) > AutoCenterDelay)
			{
				ForwardMag = (aForward * aForward) + (aBaseY * aBaseY);
				// End:0x428
				if(UTVehicle(Outer.Pawn).bStickDeflectionThrottle && UTVehicle(Outer.Pawn).bUsingLookSteer!)
				{
					ForwardMag += (aStrafe * aStrafe);
					// End:0x428
					if(ForwardMag != float(0))
					{
						VehicleYaw = Outer.Pawn.Rotation.Yaw & 65535;
						CameraYaw = Outer.Rotation.Yaw & 65535;
						// End:0x3AA
						if(ClockwiseFrom_IntInt(CameraYaw, VehicleYaw))
						{
							// End:0x350
							if(CameraYaw < VehicleYaw)
							{
								CameraYaw += 65536;
							}
							// End:0x3A7
							if((CameraYaw - VehicleYaw) > 2048)
							{
								aTurn = -0.1250000 - ((0.5000000 * float(CameraYaw - VehicleYaw)) / AutoVehicleCenterSpeed);
							}							
						}
						else
						{
							// End:0x3D1
							if(VehicleYaw < CameraYaw)
							{
								VehicleYaw += 65536;
							}
							// End:0x428
							if((VehicleYaw - CameraYaw) > 2048)
							{
								aTurn = 0.1250000 + ((0.5000000 * float(VehicleYaw - CameraYaw)) / AutoVehicleCenterSpeed);
							}
						}
					}
				}
			}
		}
		// End:0x4AD
		if(aStrafe != float(0))
		{
			OldaBaseY = aBaseY;
			aBaseY = FMin(Sqrt(Square(aStrafe) + Square(aBaseY)), 1.0000000);
			// End:0x49A
			if(OldaBaseY < float(0))
			{
				aBaseY *= float(-1);
			}
			RawJoyUp = aBaseY;
		}
	}
	// End:0x835
	if(((UTVehicle(Outer.Pawn) != none) && VSize(Outer.Pawn.Velocity) != float(0)) && UTVehicle(Outer.Pawn).bShouldAutoCenterViewPitch)
	{
		// End:0x628
		if(((Abs(RawJoyLookUp) > 0.2000000) || Outer.Pawn.IsFiring()) || int(Outer.Pawn.Physics) == int(2))
		{
			LastTurnTime = Outer.WorldInfo.TimeSeconds;
			return;
		}
		// End:0x835
		if(((Outer.WorldInfo.TimeSeconds - LastTurnTime) > AutoCenterDelay) && VSize(Outer.Pawn.Velocity) > 10.0000000)
		{
			CurrentPitch = float(NormalizeRotAxis(Outer.Rotation.Pitch));
			AmountToAdjustPitch = FInterpTo(CurrentPitch, 0.0000000, DeltaTime, AutoPitchCenterSpeed) - CurrentPitch;
			// End:0x835
			if(Abs(AmountToAdjustPitch) > AutoPitchStopAdjustingValue)
			{
				// End:0x7CD
				if(AmountToAdjustPitch < AutoPitchStopAdjustingValue)
				{
					// End:0x7A4
					if(bInvertMouse == false)
					{
						aLookUp += FMin(-1.0000000 * AmountToAdjustPitch, AutoPitchCenterSpeed);						
					}
					else
					{
						aLookUp -= FMin(-1.0000000 * AmountToAdjustPitch, AutoPitchCenterSpeed);
					}					
				}
				else
				{
					// End:0x835
					if(AmountToAdjustPitch > AutoPitchStopAdjustingValue)
					{
						// End:0x816
						if(bInvertMouse == false)
						{
							aLookUp -= FMin(AmountToAdjustPitch, AutoPitchCenterSpeed);							
						}
						else
						{
							aLookUp += FMin(AmountToAdjustPitch, AutoPitchCenterSpeed);
						}
					}
				}
			}
		}
	}
	//return;	
}

function ApplyViewAcceleration(float DeltaTime)
{
	local float CurrentPitch;
	local UTWeapon UW;

	UW = UTWeapon(Outer.Pawn.Weapon);
	CurrentPitch = float(NormalizeRotAxis(Outer.Rotation.Pitch));
	// End:0xBC
	if(CurrentPitch < (float(-1) * ViewAccel_LookingUpOrDownBoundary))
	{
		bIsLookingDown = true;		
	}
	else
	{
		// End:0xDF
		if(CurrentPitch > ViewAccel_LookingUpOrDownBoundary)
		{
			bIsLookingUp = true;
		}
	}
	// End:0x153
	if(((bIsLookingDown == true) && RawJoyLookUp < (float(-1) * ViewAccel_PitchThreshold)) || (bIsLookingUp == true) && RawJoyLookUp > ViewAccel_PitchThreshold)
	{
		aLookUp *= ViewAccel_BackToCenterSpeed;		
	}
	else
	{
		// End:0x2F2
		if((Abs(aTurn) > ViewAccel_YawThreshold) || Square(Abs(RawJoyLookRight) + Square(Abs(RawJoyLookUp / 0.7500000))) > ViewAccel_DiagonalThreshold)
		{
			// End:0x278
			if(((ViewAccel_TimeHeld > ViewAccel_TimeToHoldBeforeFastAcceleration) && bAppliedTargetFriction!) && Outer.Pawn.IsFiring()! || (UW != none) && UW.CanViewAccelerationWhenFiring())
			{
				ViewAccel_CurrMutliplier += ViewAccel_RampSpeed;
				aTurn *= FMin(FMax(ViewAccel_CurrMutliplier, ViewAccel_BaseMultiplier), ViewAccel_MaxTurnSpeed);				
			}
			else
			{
				aTurn = ((aTurn < float(0)) ? float(-1) * Square(aTurn) : Square(aTurn));
				aTurn /= MagicScaleForSensitivityEdge;
				ViewAccel_CurrMutliplier = aTurn;
				ViewAccel_TimeHeld += DeltaTime;
			}			
		}
		else
		{
			aTurn = ((aTurn < float(0)) ? float(-1) * Square(aTurn) : Square(aTurn));
			aTurn /= MagicScaleForSensitivityMiddle;
			ViewAccel_CurrMutliplier = ViewAccel_BaseMultiplier;
			ViewAccel_TimeHeld = 0.0000000;
		}
	}
	// End:0x3D3
	if(((bIsLookingDown || bIsLookingUp) && CurrentPitch < ViewAccel_BackToCenterBoundary) && CurrentPitch > (float(-1) * ViewAccel_BackToCenterBoundary))
	{
		bIsLookingDown = false;
		bIsLookingUp = false;
	}
	//return;	
}

function ApplyTargetAdhesion(float DeltaTime, UTWeapon W, out int out_YawRot, out int out_PitchRot)
{
	local Vector RealTargetLoc, TargetLoc, CamToTarget, AimLoc, CamLoc, ClosestY,
		ClosestZ, X, Y, Z;

	local Rotator CamRot, DeltaRot;
	local float DistToTarget, DistFromAimZ, DistFromAimY, AdhesionAmtY, AdhesionAmtZ, TargetRadius,
		TargetHeight, Pct;

	local int AdjustY, AdjustZ;
	local Pawn AdhesionTarget;

	// End:0x37
	if((W == none) || W.bTargetAdhesionEnabled!)
	{
		return;
	}
	CamLoc = Outer.CalcViewLocation;
	CamRot = Outer.CalcViewRotation;
	GetAxes(CamRot, X, Y, Z);
	AdhesionTarget = LastFrictionTarget;
	// End:0x18B
	if((AdhesionTarget == none) || (Outer.WorldInfo.TimeSeconds - LastFrictionTargetTime) > W.TargetAdhesionTimeMax)
	{
		AdhesionTarget = Outer.GetTargetAdhesionFrictionTarget(W.TargetAdhesionDistanceMax, CamLoc, CamRot);
	}
	// End:0x91F
	if(AdhesionTarget != none)
	{
		AdhesionTarget.GetBoundingCylinder(TargetRadius, TargetHeight);
		TargetRadius *= 0.6500000;
		TargetHeight *= 0.6500000;
		RealTargetLoc = AdhesionTarget.Location + (W.TargetFrictionOffset >> CamRot);
		// End:0x91F
		if((((W.TargetAdhesionTargetVelocityMin == 0.0000000) || VSize(AdhesionTarget.Velocity) > W.TargetAdhesionTargetVelocityMin) && (W.TargetAdhesionPlayerVelocityMin == 0.0000000) || VSize(Outer.Pawn.Velocity) > W.TargetAdhesionPlayerVelocityMin) && ((RealTargetLoc - CamLoc) Dot Vector(CamRot)) > 0.0000000)
		{
			CamToTarget = RealTargetLoc - CamLoc;
			DistToTarget = VSize(CamToTarget);
			AimLoc = CamLoc + (X * DistToTarget);
			TargetLoc = RealTargetLoc;
			TargetLoc.Z = AimLoc.Z;
			DistFromAimY = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc, ClosestY);
			ClosestY = TargetLoc + (Normal(ClosestY - TargetLoc) * TargetRadius);
			TargetLoc = RealTargetLoc;
			TargetLoc.X = AimLoc.X;
			TargetLoc.Y = AimLoc.Y;
			DistFromAimZ = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc, ClosestZ);
			ClosestZ = TargetLoc + (Normal(ClosestZ - TargetLoc) * TargetRadius);
			DeltaRot.Yaw = Rotator(ClosestY - CamLoc).Yaw - CamRot.Yaw;
			DeltaRot.Pitch = Rotator(ClosestZ - CamLoc).Pitch - CamRot.Pitch;
			DeltaRot = Normalize(DeltaRot);
			// End:0x91F
			if(((DistToTarget <= W.TargetAdhesionDistanceMax) && (DistFromAimY > TargetRadius) || DistFromAimZ > TargetHeight) && Outer.LineOfSightTo(AdhesionTarget, CamLoc))
			{
				// End:0x807
				if(DistFromAimY > TargetRadius)
				{
					Pct = 1.0000000 - ((DistFromAimY - TargetRadius) / W.TargetAdhesionAimDistY);
					// End:0x807
					if(Pct > 0.0000000)
					{
						Pct = FMin(Pct, 0.8000000);
						AdhesionAmtY = GetRangeValueByPct(W.TargetAdhesionScaleRange, Pct);
						AdjustY = int(float(DeltaRot.Yaw) * (AdhesionAmtY * DeltaTime));
						out_YawRot += AdjustY;
					}
				}
				// End:0x91F
				if(DistFromAimZ > TargetHeight)
				{
					Pct = 1.0000000 - ((DistFromAimZ - TargetHeight) / W.TargetAdhesionAimDistZ);
					// End:0x91F
					if(Pct > 0.0000000)
					{
						Pct = FMin(Pct, 0.8000000);
						AdhesionAmtZ = GetRangeValueByPct(W.TargetAdhesionScaleRange, Pct);
						AdjustZ = int(float(DeltaRot.Pitch) * (AdhesionAmtZ * DeltaTime));
						out_PitchRot += AdjustZ;
					}
				}
			}
		}
	}
	LastAdhesionAmtY = AdhesionAmtY;
	LastAdhesionAmtZ = AdhesionAmtZ;
	LastDistFromAimZa = DistFromAimZ;
	LastDistFromAimYa = DistFromAimY;
	LastDeltaRot = DeltaRot;
	LastAdjustY = float(AdjustY);
	LastAdjustZ = float(AdjustZ);
	//return;	
}

function AdjustMouseSensitivity(float FOVScale)
{
	aMouseX *= (float(60) * FOVScale);
	aMouseY *= (float(60) * FOVScale);
	//return;	
}

function ApplyTargetFriction(float DeltaTime, UTWeapon W)
{
	local Pawn FrictionTarget;
	local Vector CamLoc, X, Y, Z, CamToTarget, AimLoc,
		TargetLoc, RealTargetLoc;

	local Rotator CamRot;
	local float DistToTarget, DistMultiplier, DistFromAimZ, DistFromAimY, TargetRadius, TargetHeight,
		FrictionMultiplier;

	// End:0x4C
	if((Outer.Pawn == none) || W.bTargetFrictionEnabled!)
	{
		return;
	}
	CamLoc = Outer.CalcViewLocation;
	CamRot = Outer.CalcViewRotation;
	GetAxes(CamRot, X, Y, Z);
	FrictionTarget = Outer.GetTargetAdhesionFrictionTarget(W.TargetFrictionDistanceMax, CamLoc, CamRot);
	// End:0x79A
	if(FrictionTarget != none)
	{
		RealTargetLoc = FrictionTarget.Location + (W.TargetFrictionOffset >> CamRot);
		CamToTarget = RealTargetLoc - CamLoc;
		DistToTarget = VSize(CamToTarget);
		AimLoc = CamLoc + (X * DistToTarget);
		FrictionTarget.GetBoundingCylinder(TargetRadius, TargetHeight);
		// End:0x2B9
		if(bDebugTargetFriction)
		{
			Outer.DrawDebugCylinder(FrictionTarget.Location + (vect(0.0000000, 0.0000000, 1.0000000) * TargetHeight), FrictionTarget.Location - (vect(0.0000000, 0.0000000, 1.0000000) * TargetHeight), TargetRadius, 12, 255, 0, 0);
		}
		TargetLoc = RealTargetLoc;
		TargetLoc.Z = AimLoc.Z;
		DistFromAimY = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc);
		TargetLoc = RealTargetLoc;
		TargetLoc.X = AimLoc.X;
		TargetLoc.Y = AimLoc.Y;
		DistFromAimZ = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc);
		DistMultiplier = 0.0000000;
		// End:0x613
		if((DistToTarget >= W.TargetFrictionDistanceMin) && DistToTarget <= W.TargetFrictionDistanceMax)
		{
			// End:0x517
			if(DistToTarget <= W.TargetFrictionDistancePeak)
			{
				DistMultiplier = FClamp((DistToTarget - W.TargetFrictionDistanceMin) / (W.TargetFrictionDistancePeak - W.TargetFrictionDistanceMin), 0.0000000, 1.0000000);				
			}
			else
			{
				DistMultiplier = FClamp(1.0000000 - ((DistToTarget - W.TargetFrictionDistancePeak) / (W.TargetFrictionDistanceMax - W.TargetFrictionDistancePeak)), 0.0000000, 1.0000000);
			}
			TargetRadius *= (1.0000000 + (W.TargetFrictionPeakRadiusScale * DistMultiplier));
			TargetHeight *= (1.0000000 + (W.TargetFrictionPeakHeightScale * DistMultiplier));
		}
		// End:0x678
		if((VSize(FrictionTarget.Velocity) > float(200)) && int(W.GetZoomedState()) == int(3))
		{
			TargetRadius *= 0.0500000;
		}
		// End:0x79A
		if((DistFromAimY < TargetRadius) && DistFromAimZ < TargetHeight)
		{
			FrictionMultiplier = GetRangeValueByPct(W.TargetFrictionMultiplierRange, 1.0000000 - (DistFromAimY / TargetRadius));
			// End:0x79A
			if(FrictionMultiplier > 0.0000000)
			{
				bAppliedTargetFriction = true;
				aTurn *= (1.0000000 - FrictionMultiplier);
				aLookUp *= (1.0000000 - FrictionMultiplier);
				LastFrictionTargetTime = Outer.WorldInfo.TimeSeconds;
				LastFrictionTarget = FrictionTarget;
			}
		}
	}
	LastDistToTarget = DistToTarget;
	LastDistMultiplier = DistMultiplier;
	LastDistFromAimZ = DistFromAimZ;
	LastDistFromAimY = DistFromAimY;
	LastFrictionMultiplier = FrictionMultiplier;
	LastTargetRadius = TargetRadius;
	LastTargetHeight = TargetHeight;
	LastCamLoc = CamLoc;
	//return;	
}

exec function DebugViewAcceleration()
{
	// End:0xA5
	if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
	{
		bDebugViewAcceleration = bDebugViewAcceleration!;
		Outer.ClientMessage("bDebugViewAcceleration is now: " $ string(bDebugViewAcceleration));
	}
	//return;	
}

exec function DebugTargetAdhesion()
{
	// End:0xE2
	if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
	{
		Outer.bDebugTargetAdhesion = Outer.bDebugTargetAdhesion!;
		Outer.ClientMessage("bDebugTargetAdhesion is now: " $ string(Outer.bDebugTargetAdhesion));
	}
	//return;	
}

exec function DebugTargetFriction()
{
	// End:0xA3
	if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
	{
		bDebugTargetFriction = bDebugTargetFriction!;
		Outer.ClientMessage("bDebugTargetFriction is now: " $ string(bDebugTargetFriction));
	}
	//return;	
}

exec function SmartJump()
{
	local UTPawn P;

	P = UTPawn(Outer.Pawn);
	// End:0x86
	if((P != none) && P.bFeigningDeath)
	{
		P.FeignDeath();		
	}
	else
	{
		// End:0xAE
		if(RawJoyRight < Dodge_Threshold-)
		{
			ForcedDoubleClick = 1;			
		}
		else
		{
			// End:0xD4
			if(RawJoyRight > Dodge_Threshold)
			{
				ForcedDoubleClick = 2;				
			}
			else
			{
				Jump();
			}
		}
	}
	//return;	
}

exec function Jump()
{
	SmartJump();
	//return;	
}

function Actor.EDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
	// End:0x4C
	if(int(Outer.DoubleClickDir) != int(0))
	{
		ForcedDoubleClick = 0;
		return super(PlayerInput).CheckForDoubleClickMove(DeltaTime);		
	}
	else
	{
		Outer.DoubleClickDir = ForcedDoubleClick;
		ForcedDoubleClick = 0;
		return Outer.DoubleClickDir;
	}
	//return ReturnValue;	
}

defaultproperties
{
	SensitivityMultiplier=1.0000000
	TurningAccelerationMultiplier=1.0000000
	bAutoCenterPitch=true
	bAutoCenterVehiclePitch=true
	bViewAccelerationEnabled=true
	bTargetFrictionEnabled=true
	AutoCenterDelay=2.0000000
	AutoVehicleCenterSpeed=12000.0000000
	SlowTurnScaling=0.1000000
	ViewAccel_YawThreshold=0.9900000
	ViewAccel_DiagonalThreshold=0.9900000
	ViewAccel_BaseMultiplier=1.1000000
	ViewAccel_TimeToHoldBeforeFastAcceleration=0.1250000
	ViewAccel_Twitchy=0.9800000
	Dodge_Threshold=0.8000000
	MagicScaleForSensitivityMiddle=2.4000001
	MagicScaleForSensitivityEdge=1.5000000
	ViewAccel_RampSpeed=0.1000000
	ViewAccel_MaxTurnSpeed=3.0000000
	ViewAccel_PitchThreshold=0.6600000
	ViewAccel_LookingUpOrDownBoundary=12000.0000000
	ViewAccel_BackToCenterBoundary=3000.0000000
	ViewAccel_BackToCenterSpeed=2.8000000
	AutoPitchCenterSpeed=0.2000000
	AutoPitchStopAdjustingValue=5.0000000
	HoverBoardPitchMultiplier=0.5000000
	bUsingGamepad=true
}