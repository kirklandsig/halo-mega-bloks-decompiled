class SimplePC extends GamePlayerController
	config(Game);

var float AutoRotationAccelRate;
var float AutoRotationBrakeDecelRate;
var float MaxAutoRotationVelocity;
var float BreathAutoRotationAccelRate;
var float BreathAutoRotationBrakeDecelRate;
var float MaxBreathAutoRotationVelocity;
var float RangeBasedYawAccelStrength;
var float RangeBasedAccelMaxDistance;
var bool bLookAtDestination;
var bool bCameraBreathing;
var config bool bSmoothRotation;
var bool bApplyBackTouchToViewOffset;
var bool bFingerIsDown;
var Vector LookAtDestination;
var float LookAtDestAutoPitchAmount;
var Vector CameraBreathCenterLocation;
var Rotator CameraBreathRotator;
var Vector CameraBreathSampleLocation;
var float LastCameraBreathDeltaSelectTime;
var float TimeBetweenCameraBreathChanges;
var Vector2D AutoRotationVelocity;
var Vector2D ViewportSize;
var array<SoundCue> FootstepSounds;
var float DistanceUntilNextFootstepSound;
var config string ServerCommandline;
var float OldTurn;
var float OldLookup;
var config float RotationSmoothingFactor;
var config int DefaultInputGroup;
var MobilePlayerInput MPI;
var MobileInputZone SliderZone;
var MobileInputZone StickMoveZone;
var MobileInputZone StickLookZone;
var MobileInputZone FreeLookZone;
var int NoTapToMoves;
var float LastEnteredTapToMove;
var float TotalTimeInTapToMove;
var float TimeOfLastUserViewChange;
var Vector2D TouchCenter;
var Rotator LastOffset;
var Rotator MatineeOffset;

event InitInputSystem()
{
	super(PlayerController).InitInputSystem();
	SetupZones();
	//return;	
}

function OnConsoleCommand(SeqAct_ConsoleCommand inAction)
{
	local string Command;

	// End:0xE5
	foreach inAction.Commands(Command)
	{
		// End:0x8C
		if(WorldInfo.Game.bWaitingToStartMatch && Left(Command, 15) ComplementEqual "mobile playsong")
		{
			continue;			
		}
		else
		{
			// End:0xE4
			if(Left(Command, 4) ComplementEqual "set "! && Left(Command, 9) ComplementEqual "setnopec "!)
			{				
				ConsoleCommand(Command);
			}			
		}
	}	
	//return;	
}

simulated function ReceivedGameClass(Class<GameInfo> GameClass)
{
	super(PlayerController).ReceivedGameClass(GameClass);
	SetupZones();
	//return;	
}

function SetupZones()
{
	local float Ratio, Spacer;

	MPI = MobilePlayerInput(PlayerInput);
	StickMoveZone = MPI.FindZone("UberStickMoveZone");
	StickLookZone = MPI.FindZone("UberStickLookZone");
	FreeLookZone = MPI.FindZone("UberLookZone");
	LocalPlayer(Player).ViewportClient.GetViewportSize(ViewportSize);
	Ratio = ViewportSize.Y / ViewportSize.X;
	Spacer = float(((Ratio == 0.7500000) ? 96 : 64));
	Spacer *= (ViewportSize.X / float(1024));
	// End:0x640
	if(StickMoveZone != none)
	{
		// End:0x2C5
		if(Ratio == 0.7500000)
		{
			StickMoveZone.SizeX = ViewportSize.X * 0.1200000;
			StickMoveZone.SizeY = StickMoveZone.SizeX;
			StickMoveZone.ActiveSizeX = StickMoveZone.SizeX;
			StickMoveZone.ActiveSizeY = StickMoveZone.SizeY;
		}
		StickMoveZone.SizeX = Spacer + StickMoveZone.SizeX;
		StickMoveZone.SizeY = Spacer + StickMoveZone.SizeY;
		// End:0x38D
		if(Ratio == 0.7500000)
		{
			StickMoveZone.SizeY *= 1.5000000;
		}
		StickMoveZone.X = 0.0000000;
		StickMoveZone.Y = ViewportSize.Y - StickMoveZone.SizeY;
		StickMoveZone.CurrentCenter.X = (StickMoveZone.X + StickMoveZone.SizeX) - (StickMoveZone.ActiveSizeX * 0.5000000);
		// End:0x52E
		if(Ratio == 0.7500000)
		{
			StickMoveZone.CurrentCenter.Y = ViewportSize.Y - (StickMoveZone.SizeY * 0.3300000);			
		}
		else
		{
			StickMoveZone.CurrentCenter.Y = StickMoveZone.Y + (StickMoveZone.ActiveSizeY * 0.5000000);
		}
		StickMoveZone.CurrentLocation = StickMoveZone.CurrentCenter;
		StickMoveZone.InitialCenter = StickMoveZone.CurrentCenter;
		StickMoveZone.bCenterOnEvent = true;
	}
	// End:0xAED
	if(StickLookZone != none)
	{
		// End:0x75B
		if(Ratio == 0.7500000)
		{
			StickLookZone.SizeX = ViewportSize.X * 0.1200000;
			StickLookZone.SizeY = StickLookZone.SizeX;
			StickLookZone.ActiveSizeX = StickLookZone.SizeX;
			StickLookZone.ActiveSizeY = StickLookZone.SizeY;
		}
		StickLookZone.SizeX = Spacer + StickLookZone.SizeX;
		StickLookZone.SizeY = Spacer + StickLookZone.SizeY;
		// End:0x823
		if(Ratio == 0.7500000)
		{
			StickLookZone.SizeY *= 1.5000000;
		}
		StickLookZone.X = ViewportSize.X - StickLookZone.SizeX;
		StickLookZone.Y = ViewportSize.Y - StickLookZone.SizeY;
		StickLookZone.CurrentCenter.X = StickLookZone.X + (StickLookZone.ActiveSizeX * 0.5000000);
		// End:0x9DB
		if(Ratio == 0.7500000)
		{
			StickLookZone.CurrentCenter.Y = ViewportSize.Y - (StickLookZone.SizeY * 0.3300000);			
		}
		else
		{
			StickLookZone.CurrentCenter.Y = StickLookZone.Y + (StickLookZone.ActiveSizeY * 0.5000000);
		}
		StickLookZone.CurrentLocation = StickLookZone.CurrentCenter;
		StickLookZone.InitialCenter = StickLookZone.CurrentCenter;
		StickLookZone.bCenterOnEvent = true;
	}
	//return;	
}

simulated function PostBeginPlay()
{
	super(PlayerController).PostBeginPlay();
	LastCameraBreathDeltaSelectTime = 0.0000000;
	SetNextFootstepDistance();
	//return;	
}

function bool IsStickMoveActive()
{
	return int(StickMoveZone.State) != int(0);
	//return ReturnValue;	
}

function SetNextFootstepDistance()
{
	DistanceUntilNextFootstepSound = 200.0000000 + (FRand() * float(32));
	//return;	
}

function PlayerMove(float DeltaTime)
{
	super(PlayerController).PlayerMove(DeltaTime);
	UpdateRotation(DeltaTime);
	//return;	
}

function UpdateRotation(float DeltaTime)
{
	local float smooth;

	// End:0x129
	if(bSmoothRotation)
	{
		smooth = 1.0000000 - FMin(0.9000000, RotationSmoothingFactor * DeltaTime);
		OldTurn = (PlayerInput.aTurn * (1.0000000 - smooth)) + (OldTurn * smooth);
		OldLookup = (PlayerInput.aLookUp * (1.0000000 - smooth)) + (OldLookup * smooth);
		PlayerInput.aLookUp = OldLookup;
		PlayerInput.aTurn = OldTurn;
	}
	super(PlayerController).UpdateRotation(DeltaTime);
	//return;	
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
	local float DistToDestination;
	local Vector2D MaxVelocityScalar;
	local float YawRotationSign, PitchRotationSign, FinalYawAccelRate, FinalPitchAccelRate;
	local Vector VectorToTarget, TargetDirection;
	local Rotator NewRotation, CameraRotationYawOnly, CameraRotationPitchOnly, TargetRotationYawOnly, TargetRotationPitchOnly;

	local float RotationAccelRate, RotationBreakDecelRate, MaxRotationVelocity;

	DeltaTime = FMin(DeltaTime, 1.0000000 / 25.0000000);
	super(PlayerController).ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
	// End:0xC0
	if((PlayerInput.aTurn != 0.0000000) || PlayerInput.aLookUp != 0.0000000)
	{
		TimeOfLastUserViewChange = WorldInfo.RealTimeSeconds;
	}
	// End:0x11A
	if((WorldInfo.RealTimeSeconds - TimeOfLastUserViewChange) < 0.1000000)
	{
		bLookAtDestination = false;
		bCameraBreathing = false;
		LastCameraBreathDeltaSelectTime = 0.0000000;
	}
	UpdateCameraBreathing();
	// End:0x17E
	if(bLookAtDestination || bCameraBreathing!)
	{
		RotationAccelRate = AutoRotationAccelRate;
		RotationBreakDecelRate = AutoRotationBrakeDecelRate;
		MaxRotationVelocity = MaxAutoRotationVelocity;		
	}
	else
	{
		RotationAccelRate = BreathAutoRotationAccelRate;
		RotationBreakDecelRate = BreathAutoRotationBrakeDecelRate;
		MaxRotationVelocity = MaxBreathAutoRotationVelocity;
	}
	MaxVelocityScalar.X = 1.0000000;
	MaxVelocityScalar.Y = 1.0000000;
	// End:0x6A3
	if(bLookAtDestination || bCameraBreathing)
	{
		CameraRotationYawOnly = out_ViewRotation;
		CameraRotationYawOnly.Pitch = 0;
		CameraRotationYawOnly.Roll = 0;
		CameraRotationPitchOnly = out_ViewRotation;
		CameraRotationPitchOnly.Yaw = 0;
		CameraRotationPitchOnly.Roll = 0;
		// End:0x2D8
		if(bLookAtDestination)
		{
			VectorToTarget = LookAtDestination;			
		}
		else
		{
			VectorToTarget = CameraBreathCenterLocation - Pawn.Location;
		}
		TargetDirection = Normal(VectorToTarget);
		TargetRotationYawOnly = Rotator(TargetDirection) + CameraBreathRotator;
		TargetRotationPitchOnly = TargetRotationYawOnly;
		TargetRotationYawOnly.Pitch = 0;
		TargetRotationYawOnly.Roll = 0;
		TargetRotationPitchOnly.Yaw = 0;
		TargetRotationPitchOnly.Roll = 0;
		// End:0x409
		if(bLookAtDestination)
		{
			TargetRotationPitchOnly = RLerp(CameraRotationPitchOnly, TargetRotationPitchOnly, LookAtDestAutoPitchAmount, true);
		}
		// End:0x4A0
		if(bCameraBreathing!)
		{
			MaxVelocityScalar.X *= (1.0000000 - FMax(0.0000000, Vector(CameraRotationYawOnly) Dot Vector(TargetRotationYawOnly)));
			MaxVelocityScalar.Y *= (1.0000000 - FMax(0.0000000, Vector(CameraRotationPitchOnly) Dot Vector(TargetRotationPitchOnly)));
		}
		DistToDestination = VSize2D(VectorToTarget);
		FinalYawAccelRate = RotationAccelRate;
		FinalPitchAccelRate = RotationAccelRate;
		// End:0x55D
		if(bLookAtDestination)
		{
			FinalYawAccelRate *= (1.0000000 + ((1.0000000 - (FMin(DistToDestination, RangeBasedAccelMaxDistance) / RangeBasedAccelMaxDistance)) * RangeBasedYawAccelStrength));
			FinalPitchAccelRate *= (FMin(DistToDestination, RangeBasedAccelMaxDistance) / RangeBasedAccelMaxDistance);
		}
		CheckDistanceToDestination(DistToDestination);
		YawRotationSign = ((ClockwiseFrom_IntInt(out_ViewRotation.Yaw, TargetRotationYawOnly.Yaw)) ? -1.0000000 : 1.0000000);
		AutoRotationVelocity.X += ((YawRotationSign * FinalYawAccelRate) * DeltaTime);
		PitchRotationSign = ((ClockwiseFrom_IntInt(out_ViewRotation.Pitch, TargetRotationPitchOnly.Pitch)) ? -1.0000000 : 1.0000000);
		AutoRotationVelocity.Y += ((PitchRotationSign * FinalPitchAccelRate) * DeltaTime);		
	}
	else
	{
		// End:0x722
		if(AutoRotationVelocity.X > 0.0100000)
		{
			AutoRotationVelocity.X = FMax(0.0000000, AutoRotationVelocity.X - (RotationBreakDecelRate * DeltaTime));			
		}
		else
		{
			// End:0x7A1
			if(AutoRotationVelocity.X < -0.0100000)
			{
				AutoRotationVelocity.X = FMin(0.0000000, AutoRotationVelocity.X + (RotationBreakDecelRate * DeltaTime));				
			}
			else
			{
				AutoRotationVelocity.X = 0.0000000;
			}
		}
		// End:0x842
		if(AutoRotationVelocity.Y > 0.0100000)
		{
			AutoRotationVelocity.Y = FMax(0.0000000, AutoRotationVelocity.Y - (RotationBreakDecelRate * DeltaTime));			
		}
		else
		{
			// End:0x8C1
			if(AutoRotationVelocity.Y < -0.0100000)
			{
				AutoRotationVelocity.Y = FMin(0.0000000, AutoRotationVelocity.Y + (RotationBreakDecelRate * DeltaTime));				
			}
			else
			{
				AutoRotationVelocity.Y = 0.0000000;
			}
		}
	}
	// End:0x972
	if(AutoRotationVelocity.X > (MaxRotationVelocity * MaxVelocityScalar.X))
	{
		AutoRotationVelocity.X = MaxRotationVelocity * MaxVelocityScalar.X;		
	}
	else
	{
		// End:0xA02
		if(AutoRotationVelocity.X < (MaxRotationVelocity- * MaxVelocityScalar.X))
		{
			AutoRotationVelocity.X = MaxRotationVelocity- * MaxVelocityScalar.X;
		}
	}
	// End:0xA91
	if(AutoRotationVelocity.Y > (MaxRotationVelocity * MaxVelocityScalar.Y))
	{
		AutoRotationVelocity.Y = MaxRotationVelocity * MaxVelocityScalar.Y;		
	}
	else
	{
		// End:0xB21
		if(AutoRotationVelocity.Y < (MaxRotationVelocity- * MaxVelocityScalar.Y))
		{
			AutoRotationVelocity.Y = MaxRotationVelocity- * MaxVelocityScalar.Y;
		}
	}
	// End:0xD2D
	if((Abs(AutoRotationVelocity.X) > 0.0100000) || Abs(AutoRotationVelocity.Y) > 0.0100000)
	{
		NewRotation.Yaw = fixedTurn(out_ViewRotation.Yaw, int(float(out_ViewRotation.Yaw) + (AutoRotationVelocity.X * DeltaTime)), int(Abs(AutoRotationVelocity.X * DeltaTime)));
		NewRotation.Pitch = fixedTurn(out_ViewRotation.Pitch, int(float(out_ViewRotation.Pitch) + (AutoRotationVelocity.Y * DeltaTime)), int(Abs(AutoRotationVelocity.Y * DeltaTime)));
		NewRotation.Roll = out_ViewRotation.Roll;
		out_ViewRotation = NewRotation;
	}
	//return;	
}

simulated function CheckDistanceToDestination(float DistToDestination)
{
	//return;	
}

simulated function UpdateCameraBreathing()
{
	// End:0x2C
	if(Pawn == none)
	{
		bCameraBreathing = false;
		LastCameraBreathDeltaSelectTime = 0.0000000;
		return;
	}
	// End:0xAF
	if(IsInState('PlayerClickToMove') || CameraBreathSampleLocation != Pawn.Location)
	{
		bCameraBreathing = false;
		LastCameraBreathDeltaSelectTime = 0.0000000;
		CameraBreathSampleLocation = Pawn.Location;
		return;
	}
	//return;	
}

function ActivateControlGroup()
{
	MPI.ActivateInputGroup("UberGroup");
	//return;	
}

function OffsetMatineeTouch(int Handle, Interaction.ETouchType Type, Vector2D TouchLocation, float DeviceTimestamp, int TouchpadIndex)
{
	// End:0x22
	if((Handle != 0) || TouchpadIndex != 1)
	{
		return;
	}
	// End:0x58
	if(int(Type) == int(0))
	{
		TouchCenter = TouchLocation;
		bFingerIsDown = true;		
	}
	else
	{
		// End:0x8E
		if(int(Type) == int(3))
		{
			LastOffset = MatineeOffset;
			bFingerIsDown = false;			
		}
		else
		{
			// End:0x19C
			if(bFingerIsDown)
			{
				MatineeOffset.Yaw = int(float(LastOffset.Yaw) + (float(60) * (TouchLocation.X - TouchCenter.X)));
				MatineeOffset.Pitch = int(float(LastOffset.Pitch) + (float(-60) * (TouchLocation.Y - TouchCenter.Y)));
			}
		}
	}
	//return;	
}

event NotifyDirectorControl(bool bNowControlling, SeqAct_Interp CurrentMatinee)
{
	super(PlayerController).NotifyDirectorControl(bNowControlling, CurrentMatinee);
	// End:0x5D
	if(bNowControlling)
	{
		MPI.__OnInputTouch__Delegate = OffsetMatineeTouch;		
	}
	else
	{
		MPI.__OnInputTouch__Delegate = None;
		LastOffset.Yaw = 0;
		LastOffset.Pitch = 0;
		MatineeOffset.Yaw = 0;
		MatineeOffset.Pitch = 0;
		bFingerIsDown = false;
	}
	bApplyBackTouchToViewOffset = bNowControlling;
	//return;	
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
	super(PlayerController).GetPlayerViewPoint(out_Location, out_Rotation);
	// End:0x3E
	if(bApplyBackTouchToViewOffset)
	{
		out_Rotation += MatineeOffset;
	}
	//return;	
}

function PlayerTick(float DeltaTime)
{
	local float CurrentWalkSpeed;
	local int FootstepSoundIndex;
	local TraceHitInfo HitInfo;
	local Vector TraceStart, TraceEnd, TraceExtent, OutHitLocation, OutHitNormal;

	local Actor TraceActor;

	// End:0xAA
	if(bApplyBackTouchToViewOffset && bFingerIsDown!)
	{
		MatineeOffset.Yaw *= 0.9900000;
		MatineeOffset.Pitch *= 0.9900000;
		LastOffset.Yaw *= 0.9900000;
		LastOffset.Pitch *= 0.9900000;
	}
	// End:0xEB
	if(Pawn != none)
	{
		CurrentWalkSpeed = VSize2D(Pawn.Velocity);
	}
	// End:0x2F6
	if(CurrentWalkSpeed > 32.0000000)
	{
		DistanceUntilNextFootstepSound -= (CurrentWalkSpeed * DeltaTime);
		// End:0x2F3
		if(DistanceUntilNextFootstepSound < 0.0000000)
		{
			TraceStart = Pawn.Location;
			TraceEnd = Pawn.Location;
			TraceEnd.Z -= 100.0000000;
			TraceActor = Trace(OutHitLocation, OutHitNormal, TraceEnd, TraceStart, true, TraceExtent, HitInfo, (1 | 8) | 4);
			// End:0x2A0
			if(((TraceActor != none) && HitInfo.PhysMaterial != none) && HitInfo.PhysMaterial.ImpactSound != none)
			{
				PlaySound(HitInfo.PhysMaterial.ImpactSound);				
			}
			else
			{
				// End:0x2E9
				if(FootstepSounds.Length > 0)
				{
					FootstepSoundIndex = Rand(FootstepSounds.Length);
					PlaySound(FootstepSounds[FootstepSoundIndex]);
				}
			}
			SetNextFootstepDistance();
		}		
	}
	else
	{
		SetNextFootstepDistance();
	}
	super(PlayerController).PlayerTick(DeltaTime);
	//return;	
}

exec function SetFootstepsToStone()
{
	//return;	
}

exec function SetFootstepsToSnow()
{
	//return;	
}

defaultproperties
{
	AutoRotationAccelRate=10000.0000000
	AutoRotationBrakeDecelRate=10000.0000000
	MaxAutoRotationVelocity=300000.0000000
	BreathAutoRotationAccelRate=250.0000000
	BreathAutoRotationBrakeDecelRate=1.0000000
	MaxBreathAutoRotationVelocity=75.0000000
	RangeBasedYawAccelStrength=8.0000000
	RangeBasedAccelMaxDistance=512.0000000
	TimeBetweenCameraBreathChanges=2.0000000
	ServerCommandline="EpicCitadel?listen"
	RotationSmoothingFactor=5.0000000
	DefaultInputGroup=1
	InputClass=Class'GameFramework.MobilePlayerInput'
	// Reference: CylinderComponent'UDKBase.Default__SimplePC.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GameFramework.Default__GamePlayerController.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}