class HaloVehicle extends UTVehicle
	abstract
	config(GwNavEngine)
	implements(HaloVehicleInterface,IHaloDeployable);

enum HornState
{
	InactiveHorn,                   // 0
	ActiveHorn,                     // 1
	CooldownHorn,                   // 2
	HornState_MAX                   // 3
};

struct EntryPoint
{
	var float Radius;
	var name SocketName;
	var TextureCoordinates ToolTipCoords;
	var name EnterPawnAnimName;
	var name ExitPawnAnimName;
	var int SeatIndex;

	structdefaultproperties
	{
		Radius=0.0000000
		SocketName="None"
		ToolTipCoords=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000)
		EnterPawnAnimName="None"
		ExitPawnAnimName="None"
		SeatIndex=0
	}
};

struct EnteringPlayer
{
	var PlayerController PC;
	var int Seat;

	structdefaultproperties
	{
		PC=none
		Seat=0
	}
};

struct VehicleGear
{
	var float MinPercent;
	var float MaxPercent;
	var InterpCurveFloat GearRatio;

	structdefaultproperties
	{
		MinPercent=0.0000000
		MaxPercent=0.0000000
		GearRatio=(Points=none,InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents)
	}
};

struct VehicleTargetOfInterest
{
	var Actor Target;
	var float YawBuffer;
	var float ElapsedTime;
	var float BlendInTime;
	var float BlendViewTime;
	var float BlendOutTime;
	var float BlendPct;
	var Vector SeatOffsetAdjustment;
	var Rotator Rotation;

	structdefaultproperties
	{
		Target=none
		YawBuffer=20.0000000
		ElapsedTime=0.0000000
		BlendInTime=0.0000000
		BlendViewTime=0.0000000
		BlendOutTime=0.0000000
		BlendPct=0.0000000
		SeatOffsetAdjustment=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Rotation=(Pitch=0,Yaw=0,Roll=0)
	}
};

struct HaloDynamicHandlingVariables
{
	var float EngineBrakeFactor;
	var float WheelLatExtremumSlip;
	var float WheelLatExtremumValue;
	var float WheelLatAsymptoteSlip;
	var float WheelLatAsymptoteValue;
	var bool ApplyChanges;

	structdefaultproperties
	{
		EngineBrakeFactor=0.0000000
		WheelLatExtremumSlip=0.0000000
		WheelLatExtremumValue=0.0000000
		WheelLatAsymptoteSlip=0.0000000
		WheelLatAsymptoteValue=0.0000000
		ApplyChanges=false
	}
};

var GFxHaloMinimapHUD.PlayerPawnType PawnType;
var HaloVehicle.HornState CurrentHornState;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
var export editinline HaloCollectibleBlokSpawnerComponent BlokSpawner;
var array<EntryPoint> EntryPoints;
var array<EnteringPlayer> EnteringPlayers;
var name AkVehicleType;
var name AkObjectType;
var name AkPitchType;
var int AKMinPitch;
var int AKMaxPitch;
var bool bIsSuspensionContracting;
var bool bIsSkidding;
var bool SkidLoopEnabled;
var bool HornEnabled;
var bool EnginePitchEnabled;
var bool EngineFeedbackEnabled;
var bool CanBoost;
var repnotify bool bBoostersActivated;
var bool bSteeringLimited;
var bool bBoostChargeIsDelayed;
var bool bTryToBoost;
var bool BoostFeedbackEnabled;
var bool bAutoBrakeEnabled;
var bool AutoAimEnabled;
var bool KidFriendlyControls;
var name EngineBone;
var name ExhaustBone;
var AkEvent SkidStartEvent;
var AkEvent SkidStopEvent;
var AkEvent BoostStartEvent;
var AkEvent BoostStopEvent;
var const int AkBreakTiny;
var const int AkBreakSmall;
var const int AkBreakMedium;
var const int AkBreakLarge;
var const int AkBreakMega;
var name PreviousMaterial;
var float PreviousVel;
var array<float> AverageAccel;
var int CurrentAccelIndex;
var float AccelerationStartSkidLimit;
var float AccelerationStopSkidLimit;
var float MaxHornDuration;
var float HornCooldownDuration;
var float HeavyCrashLimit;
var float MediumCrashLimit;
var float LightCrashLimit;
var AkEvent SuspensionContractEvent;
var AkEvent SuspensionExpandEvent;
var AkEvent EnterVehicleEvent;
var AkEvent ExitVehicleEvent;
var array<VehicleGear> VehicleGears;
var int CurrentGear;
var float CurrentRPMPitch;
var int PreviousRPMPitch;
var int PreviousSkidValue;
var float MaxRPMChangeRatePerSecond;
var ForceFeedbackWaveform SuspensionWaveform;
var ForceFeedbackWaveform CrashWaveform;
var float PlayEngineFeedbackDelay;
var float EngineIdleForceFeedback;
var float EngineRunningForceFeedback;
var float MinForwardVelToDrift;
var float MinLatSlipToBeDrifting;
var float BoostAmount;
var float MaxBoostDuration;
var float BoostChargeTime;
var float BoostChargeDelay;
var float BoostStartTime;
var float RocketGroundSpeed;
var float RocketAirSpeed;
var float BoostFeedbackMagnitude;
var float PlayBoostFeedbackDelay;
var float StopBoostFeedbackDelay;
var float LookdownPitch;
var float LookdownPitchBuffer;
var float LookupPitchBuffer;
var VehicleTargetOfInterest TargetOfInterest;
var float XSensitivity;
var float CameraLookSteerXSensitivity;
var float CameraLookSteerYSensitivity;
var float CameraIdleInterpRate;
var float CameraSteerInterpRate;
var Class<UTWeaponPawn> SeatPawnClass;
var float AutoAimDistance;
var float AutoAimAnglePitchMax;
var float AutoAimAnglePitchMin;
var float AutoAimAngleYawDiff;
var HVCCAddon HVCC_AttachedAddon;
var HVCCWheelSet HVCC_AttachedWheelSet;
var HVCCSkin HVCC_AttachedSkin;
var name DeployableName;
var Actor DeployableBase;
var array< Class<HaloVCustomizationComponent> > DeployedCustomizations;
var export editinline array<export editinline SkeletalMeshComponent> WheelMeshes;
var const localized string DriveVehicleMessage;
var const localized string RideInVehicleMessage;
var const localized string ManTurretMessage;
var const localized string FlipVehicleMessage;
var array<int> AISeatIndexOrder;
var HaloDynamicHandlingVariables NormalHandlingVariables;
var HaloDynamicHandlingVariables BrakingHandlingVariables;
var HaloDynamicHandlingVariables PowerSlideHandlingVariables;
var export editinline HaloTargetableComponent_Vehicle HaloTargetableComponent;
var export editinline HaloNeedleTargetComponent NeedleTargetComponent;

replication
{
	// Pos:0x000
	if(bNetDirty)
		bBoostersActivated;
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local int I;
	local editinline HaloVehicleWheel myWheel;
	local Rotator attachRot;

	super(SVehicle).PostInitAnimTree(SkelComp);
	// End:0x205
	if(SkelComp == Mesh)
	{
		I = 0;
		J0x35:

		// End:0x205 [Loop If]
		if(I < Wheels.Length)
		{
			myWheel = HaloVehicleWheel(Wheels[I]);
			// End:0x1F7
			if((myWheel != none) && myWheel.WheelMeshRef != none)
			{
				attachRot.Yaw = int(((myWheel.MirrorRenderMesh) ? 180.0000000 * 182.0444031 : 0.0000000));
				WheelMeshes[I] = new (self) Class'Engine.SkeletalMeshComponent';
				// End:0x1F7
				if(WheelMeshes[I] != none)
				{
					WheelMeshes[I].SetSkeletalMesh(myWheel.WheelMeshRef);
					Mesh.AttachComponent(WheelMeshes[I], myWheel.BoneName, myWheel.BoneOffset, attachRot);
				}
			}
			I++;
			// [Loop Continue]
			goto J0x35;
		}
	}
	//return;	
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x38
	if(HaloTargetableComponent != none)
	{
		HaloTargetableComponent.PostBeginPlay();
	}
	//return;	
}

simulated function SwapCustomization(HaloVCustomizationComponent Customization)
{
	// End:0x42
	if(Customization.IsA('HVCCWheelSet'))
	{
		SwapWheelSet(HVCCWheelSet(Customization));		
	}
	else
	{
		// End:0x84
		if(Customization.IsA('HVCCAddon'))
		{
			SwapAddon(HVCCAddon(Customization));			
		}
		else
		{
			// End:0xC3
			if(Customization.IsA('HVCCSkin'))
			{
				SwapSkin(HVCCSkin(Customization));
			}
		}
	}
	Customization.ParentVehicle = self;
	Customization.OnAttach();
	//return;	
}

simulated function SwapWheelSet(HVCCWheelSet wheelSet)
{
	//return;	
}

simulated function SwapAddon(HVCCAddon Attachment)
{
	local bool bValidBone, bValidSocket;

	// End:0x46
	if(HVCC_AttachedAddon != none)
	{
		HVCC_AttachedAddon.OnDetach();
		HVCC_AttachedAddon.Destroy();
	}
	// End:0x1E4
	if((Mesh != none) && Attachment.HVCParentBoneName != 'None')
	{
		bValidSocket = Mesh.GetSocketByName(Attachment.HVCParentBoneName) != none;
		bValidBone = Mesh.MatchRefBone(Attachment.HVCParentBoneName) != -1;
		// End:0x1E4
		if(!bValidBone && !bValidSocket)
		{
			LogInternal((((((((string(WorldInfo.TimeSeconds) @ string(Class)) @ string(GetFuncName())) @ "bone or socket") @ string(Attachment.HVCParentBoneName)) @ "not found on actor") @ string(self)) @ "with mesh") @ string(Mesh));
		}
	}
	// End:0x487
	if(bValidBone || bValidSocket)
	{
		Attachment.SetCollision(false, false);
		// End:0x2EF
		if(bValidBone && !bValidSocket)
		{
			Attachment.SetLocation(Mesh.GetBoneLocation(Attachment.HVCParentBoneName));
			Attachment.SetRotation(QuatToRotator(Mesh.GetBoneQuaternion(Attachment.HVCParentBoneName)));
		}
		Attachment.SetBase(self,, Mesh, Attachment.HVCParentBoneName);
		Attachment.SetRelativeRotation(Attachment.RelativeRotation + Attachment.HVCAttachmentRotation);
		Attachment.SetRelativeLocation(Attachment.RelativeLocation + Attachment.HVCAttachmentOffset);
		Attachment.SetCollision(true, false, true);
		Attachment.CollisionComponent.SetNotifyRigidBodyCollision(true);
		Attachment.CollisionComponent.ScriptRigidBodyCollisionThreshold = 1.0000000;
		HVCC_AttachedAddon = Attachment;
	}
	//return;	
}

simulated function SwapSkin(HVCCSkin newSkin)
{
	// End:0x46
	if(HVCC_AttachedSkin != none)
	{
		HVCC_AttachedSkin.OnDetach();
		HVCC_AttachedSkin.Destroy();
	}
	HVCC_AttachedSkin = newSkin;
	//return;	
}

function HideCurrentCustomization(Class<HaloVCustomizationComponent> HVCC_Class)
{
	// End:0x37
	if(ClassIsChildOf(HVCC_Class, Class'MegaHaloGame.HVCCAddon'))
	{
		HVCC_AttachedAddon.Hide();
	}
	//return;	
}

function ShowCurrentCustomization(Class<HaloVCustomizationComponent> HVCC_Class)
{
	// End:0x37
	if(ClassIsChildOf(HVCC_Class, Class'MegaHaloGame.HVCCAddon'))
	{
		HVCC_AttachedAddon.show();
	}
	//return;	
}

function ShowAllCurrentCustomizations()
{
	ShowCurrentCustomization(Class'MegaHaloGame.HVCCAddon');
	//return;	
}

function UseAddonAbility()
{
	// End:0x2E
	if(HVCC_AttachedAddon != none)
	{
		HVCC_AttachedAddon.UseSpecialAbility();
	}
	//return;	
}

function CancelAddonAbility()
{
	// End:0x2E
	if(HVCC_AttachedAddon != none)
	{
		HVCC_AttachedAddon.CancelSpecialAbility();
	}
	//return;	
}

simulated function UTGib SpawnGibVehicle(Vector SpawnLocation, Rotator SpawnRotation, StaticMesh TheMesh, Vector HitLocation, bool bSpinGib, Vector ImpulseDirection, ParticleSystem PS_OnBreak, ParticleSystem PS_Trail)
{
	local UTGib Gib;

	Gib = super.SpawnGibVehicle(SpawnLocation, SpawnRotation, TheMesh, HitLocation, bSpinGib, ImpulseDirection, PS_OnBreak, PS_Trail);
	// End:0x16B
	if(Gib != none)
	{
		// End:0xB5
		if(UTGib_VehiclePiece(Gib) != none)
		{
			UTGib_VehiclePiece(Gib).AkObjectType = AkObjectType;
		}
		SetRTPCValue('Impulse_Value', float(AkBreakMedium));
		PlayAkEvent(AkEvent'Objects.Play_Object_Destroyed');
		// End:0x16B
		if(HVCC_AttachedSkin != none)
		{
			Gib.GibMeshComp.SetMaterial(HVCC_AttachedSkin.DamageMeshElementIndex, HVCC_AttachedSkin.SkinMaterial);
		}
	}
	return Gib;
	//return ReturnValue;	
}

function KickOutAll()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xAF [Loop If]
	if(I < Seats.Length)
	{
		// End:0xA1
		if(Seats[I].SeatPawn.Controller != none)
		{
			Seats[I].SeatPawn.DriverLeave(false);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function StartEngineSound()
{
	local Vector frontLoc, rearLoc;

	super(SVehicle).StartEngineSound();
	PreviousRPMPitch = 0;
	CurrentRPMPitch = 0.0000000;
	SetSwitch('Vehicle_Type', AkVehicleType);
	SetSwitch('Local_Player', ((Driver.Controller.IsLocalPlayerController()) ? 'Yes' : 'No'));
	SetRTPCValue(AkPitchType, float(AKMinPitch));
	// End:0x109
	if(EngineBone != 'None')
	{
		frontLoc = Mesh.GetBoneLocation(EngineBone);		
	}
	else
	{
		WarnInternal("No engine bone set to play engine sound for " $ string(self));
		frontLoc = Location;
	}
	// End:0x19E
	if(ExhaustBone != 'None')
	{
		rearLoc = Mesh.GetBoneLocation(ExhaustBone);		
	}
	else
	{
		WarnInternal("No exhaust bone set to play exhaust sound for " $ string(self));
		rearLoc = Location;
	}
	PlayAkEvent(AkEvent'Vehicles.Play_Engine',,,, frontLoc);
	PlayAkEvent(AkEvent'Vehicles.Play_Exhaust',,,, rearLoc);
	//return;	
}

simulated function StopEngineSound()
{
	super(SVehicle).StopEngineSound();
	PlayAkEvent(AkEvent'Vehicles.Stop_Engine');
	PlayAkEvent(AkEvent'Vehicles.Stop_Exhaust');
	//return;	
}

simulated function StartSkidSound()
{
	// End:0x28
	if(SkidStartEvent != none)
	{
		PlayAkEvent(SkidStartEvent);
	}
	//return;	
}

simulated function StopSkidSound()
{
	// End:0x28
	if(SkidStopEvent != none)
	{
		PlayAkEvent(SkidStopEvent);
	}
	//return;	
}

simulated function StartBoostSound()
{
	// End:0x28
	if(BoostStartEvent != none)
	{
		PlayAkEvent(BoostStartEvent);
	}
	//return;	
}

simulated function StopBoostSound()
{
	// End:0x28
	if(BoostStopEvent != none)
	{
		PlayAkEvent(BoostStopEvent);
	}
	//return;	
}

simulated function VehiclePlayEnterSound()
{
	super(SVehicle).VehiclePlayEnterSound();
	// End:0x54
	if(EnterVehicleEvent != none)
	{
		SetRTPCValue('Grip', 0.0000000);
		UpdateSkidMaterial();
		PlayAkEvent(EnterVehicleEvent);
	}
	//return;	
}

simulated function VehiclePlayExitSound()
{
	super(SVehicle).VehiclePlayExitSound();
	// End:0x32
	if(ExitVehicleEvent != none)
	{
		PlayAkEvent(ExitVehicleEvent);
	}
	//return;	
}

function VehiclePlayCollisionSound(Actor otherActor)
{
	local int I;

	// End:0x6E
	if(HaloPawn(otherActor) != none)
	{
		SetSwitch('Object_Type', AkObjectType);
		SetRTPCValue('Impulse_Value', float(AkBreakSmall));
		PlayAkEvent(AkEvent'Objects.Play_Object_Impact');		
	}
	else
	{
		I = GetCrashIntensityLevel();
		// End:0xE4
		if(I >= 0)
		{
			SetSwitch('Object_Type', AkObjectType);
			SetRTPCValue('Impulse_Value', float(I));
			PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
		}
	}
	//return;	
}

function float Sign(float theValue)
{
	// End:0x17
	if(theValue == float(0))
	{
		return 0.0000000;
	}
	return theValue / Abs(theValue);
	//return ReturnValue;	
}

function UpdateSuspensionSounds(float DeltaSeconds)
{
	local editinline HaloVehicleWheel myWheel;
	local int I, suspensionShift;
	local float maxSuspPos;
	local bool bIsExpanding;

	I = 0;
	J0x0B:

	// End:0x239 [Loop If]
	if(I < Wheels.Length)
	{
		myWheel = HaloVehicleWheel(Wheels[I]);
		// End:0x22B
		if(myWheel != none)
		{
			myWheel.bTimeSinceLastContractSoundPlayed += DeltaSeconds;
			myWheel.bTimeSinceLastExpandSoundPlayed += DeltaSeconds;
			// End:0x22B
			if(Abs(myWheel.DesiredSuspensionPosition - myWheel.SuspensionPosition) > (myWheel.SuspensionTravel * myWheel.SuspensionShiftPercent))
			{
				maxSuspPos = myWheel.SuspensionTravel + float(5);
				bIsExpanding = myWheel.DesiredSuspensionPosition < myWheel.SuspensionPosition;
				suspensionShift = Min(100, int((float(100) * Abs(myWheel.DesiredSuspensionPosition - myWheel.SuspensionPosition)) / maxSuspPos));
				PlaySuspensionShiftSound(myWheel, suspensionShift, bIsExpanding);
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function PlaySuspensionShiftSound(HaloVehicleWheel myWheel, int suspensionShift, bool bIsExpanding)
{
	SetSwitch('Vehicle_Type', AkVehicleType);
	// End:0x1AD
	if(suspensionShift > 0)
	{
		SetRTPCValue('Suspension', float(suspensionShift));
		// End:0x103
		if(bIsExpanding)
		{
			// End:0x100
			if(myWheel.bTimeSinceLastExpandSoundPlayed > myWheel.TimeToWaitBetweenSuspensionSounds)
			{
				// End:0xDC
				if(SuspensionExpandEvent != none)
				{
					PlayAkEvent(SuspensionExpandEvent,,,, myWheel.WheelPosition);
				}
				myWheel.bTimeSinceLastExpandSoundPlayed = 0.0000000;
			}			
		}
		else
		{
			// End:0x1AD
			if(myWheel.bTimeSinceLastContractSoundPlayed > myWheel.TimeToWaitBetweenSuspensionSounds)
			{
				// End:0x189
				if(SuspensionContractEvent != none)
				{
					PlayAkEvent(SuspensionContractEvent,,,, myWheel.WheelPosition);
				}
				myWheel.bTimeSinceLastContractSoundPlayed = 0.0000000;
			}
		}
	}
	//return;	
}

function VehiclePlaySuspensionShiftSound(float Delta)
{
	//return;	
}

function int GetCrashIntensityLevel()
{
	local int Intensity;
	local float F;

	F = VSize(Mesh.GetRootBodyInstance().PreviousVelocity);
	// End:0x66
	if(F >= HeavyCrashLimit)
	{
		Intensity = 70;		
	}
	else
	{
		// End:0x8C
		if(F >= MediumCrashLimit)
		{
			Intensity = 50;			
		}
		else
		{
			// End:0xB2
			if(F >= LightCrashLimit)
			{
				Intensity = 30;				
			}
			else
			{
				Intensity = -1;
			}
		}
	}
	return Intensity;
	//return ReturnValue;	
}

function Tick(float DeltaSeconds)
{
	// End:0x7B
	if(bDriving || Abs(ForwardVel) > 0.0100000)
	{
		UpdateEngineForceFeedback();
		UpdateEngineGearPitch(DeltaSeconds);
		UpdateSkidConditions();
		UpdateBoost(DeltaSeconds);
		UpdateTargetOfInterest(DeltaSeconds);
		BroadcastThreat();
	}
	UpdateSuspensionSounds(DeltaSeconds);
	// End:0x110
	if((!bStayUpright && bWasChassisTouchingGroundLastTick) && !bChassisTouchingGround)
	{
		SetSwitch('Object_Type', AkObjectType);
		SetRTPCValue('Impulse_Value', float(AkBreakSmall));
		PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
	}
	TickNeedleTargetComponent(DeltaSeconds);
	super(Actor).Tick(DeltaSeconds);
	//return;	
}

simulated function GetRotation(out Rotator CameraRotation)
{
	local float Pitch, LookDown, downbuffer, upbuffer;

	CameraRotation.Yaw = Mesh.GetRotation().Yaw;
	LookDown = -LookdownPitch * 182.0444031;
	downbuffer = LookdownPitchBuffer * 182.0444031;
	upbuffer = LookupPitchBuffer * 182.0444031;
	Pitch = float(Mesh.GetRotation().Pitch) + LookDown;
	// End:0x12B
	if(Pitch < (LookDown - downbuffer))
	{
		Pitch = Pitch + downbuffer;		
	}
	else
	{
		// End:0x16E
		if(Pitch > (LookDown + upbuffer))
		{
			Pitch = Pitch - upbuffer;			
		}
		else
		{
			Pitch = LookDown;
		}
	}
	CameraRotation.Pitch = int(Pitch);
	CameraRotation.Roll = 0;
	//return;	
}

simulated function GetPlayerInput(out PlayerInput Player, optional bool Accel = false, optional bool Brake = false, optional bool Strafe = false)
{
	//return;	
}

simulated function UpdateEngineGearPitch(float DeltaSeconds)
{
	local float DesiredPitch, PitchDifference, MaxRPMChangeRate, CurrentRPMPitchInt;

	// End:0x20E
	if(EnginePitchEnabled)
	{
		// End:0x31
		if(bDriving)
		{
			DesiredPitch = GetCurrentPitch();			
		}
		else
		{
			// End:0x54
			if(CurrentRPMPitch > float(0))
			{
				DesiredPitch = 0.0000000;				
			}
			else
			{
				return;
			}
		}
		PitchDifference = DesiredPitch - CurrentRPMPitch;
		MaxRPMChangeRate = MaxRPMChangeRatePerSecond * DeltaSeconds;
		// End:0xC5
		if(PitchDifference >= float(0))
		{
			CurrentRPMPitch += FMin(PitchDifference, MaxRPMChangeRate);			
		}
		else
		{
			CurrentRPMPitch += FMax(PitchDifference, -MaxRPMChangeRate);
		}
		CurrentRPMPitch = FMax(FMin(CurrentRPMPitch, 100.0000000), 0.0000000);
		CurrentRPMPitchInt = float(int(CurrentRPMPitch));
		// End:0x198
		if(bVehicleOnGround)
		{
			// End:0x169
			if(ShouldUpshift(DesiredPitch))
			{
				CurrentGear = Min(CurrentGear + 1, VehicleGears.Length - 1);				
			}
			else
			{
				// End:0x198
				if(ShouldDownshift(DesiredPitch))
				{
					CurrentGear = Max(CurrentGear - 1, 0);
				}
			}
		}
		// End:0x20E
		if(float(PreviousRPMPitch) != CurrentRPMPitchInt)
		{
			PreviousRPMPitch = int(CurrentRPMPitchInt);
			SetRTPCValue(AkPitchType, (float((AKMaxPitch - AKMinPitch) * PreviousRPMPitch) / 100.0000000) + float(AKMinPitch));
		}
	}
	//return;	
}

simulated function UpdateSkidValue()
{
	//return;	
}

simulated function float GetCurrentPitch()
{
	local float Pitch;
	local InterpCurveFloat Gear;

	Gear = VehicleGears[CurrentGear].GearRatio;
	Pitch = EvalInterpCurveFloat(Gear, Abs(ForwardVel));
	return Pitch;
	//return ReturnValue;	
}

simulated function bool ShouldUpshift(float DesiredPitch)
{
	local bool B;

	B = (DesiredPitch > VehicleGears[CurrentGear].MaxPercent) && ForwardVel >= float(0);
	return B;
	//return ReturnValue;	
}

simulated function bool ShouldDownshift(float DesiredPitch)
{
	local bool B;

	B = DesiredPitch < VehicleGears[CurrentGear].MinPercent;
	return B;
	//return ReturnValue;	
}

simulated function BlowupVehicle()
{
	super.BlowupVehicle();
	SetCollision(false, false, true);
	SetCollisionType(1);
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
	VehiclePlayCollisionSound(OtherComponent.Owner);
	// End:0x176
	if((OtherComponent != none) && OtherComponent.Owner != none)
	{
		// End:0xC9
		if(OtherComponent.Owner.IsA('HaloDestructibleActor'))
		{
			HandleHDACollision(HaloDestructibleActor(OtherComponent.Owner));			
		}
		else
		{
			// End:0x176
			if(OtherComponent.Owner.IsA('HaloTurret') && HaloTurret(OtherComponent.Owner).Health > 0)
			{
				FakeTurretCollision(HaloTurret(OtherComponent.Owner));
			}
		}
	}
	super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	//return;	
}

function FakeTurretCollision(HaloTurret Other)
{
	local float Speed;
	local Vector Momentum, HitDir;

	VehiclePlayCollisionSound(Other);
	// End:0x164
	if(Other != none)
	{
		Speed = VSize(Velocity);
		Momentum = Velocity * Mass;
		Other.TakeDamage(int((Speed * Mass) * 0.0025000), GetCollisionDamageInstigator(), Other.Location, Momentum, CrushedDamageType);
		// End:0x164
		if(Mesh != none)
		{
			HitDir = Location - Other.Location;
			HitDir.Z = 0.0000000;
			HitDir = Normal(HitDir);
			PlayHDACollisionForcefeedback(Speed, -HitDir);
		}
	}
	//return;	
}

function HandleHDACollision(HaloDestructibleActor Other)
{
	local float Speed;
	local Vector Momentum, HitDir;

	VehiclePlayCollisionSound(Other);
	// End:0x164
	if(Other != none)
	{
		Speed = VSize(Velocity);
		Momentum = Velocity * Mass;
		Other.TakeDamage(int((Speed * Mass) * 0.0025000), GetCollisionDamageInstigator(), Other.Location, Momentum, CrushedDamageType);
		// End:0x164
		if(Mesh != none)
		{
			HitDir = Location - Other.Location;
			HitDir.Z = 0.0000000;
			HitDir = Normal(HitDir);
			PlayHDACollisionForcefeedback(Speed, -HitDir);
		}
	}
	//return;	
}

simulated function PlayHDACollisionForcefeedback(float Speed, Vector HitDir)
{
	local PlayerController PC;
	local VehicleSeat Seat;
	local WaveformSample WS;
	local ForceFeedbackWaveform FFW;
	local int nLAmp, nRAmp;
	local float SpeedPct, DirDot, fLAmp, fRAmp;
	local Vector F, R, U;

	GetAxes(Rotation, F, R, U);
	DirDot = FClamp(R Dot HitDir, -1.0000000, 1.0000000);
	fRAmp = (1.0000000 + DirDot) / 2.0000000;
	fLAmp = 1.0000000 - fRAmp;
	SpeedPct = FClamp(Speed / MaxSpeed, 0.0000000, 1.0000000);
	nLAmp = Clamp(int((fLAmp * SpeedPct) * 100.0000000), 0, 100);
	nRAmp = Clamp(int((fRAmp * SpeedPct) * 100.0000000), 0, 100);
	WS.LeftAmplitude = byte(nLAmp);
	WS.RightAmplitude = byte(nRAmp);
	WS.LeftFunction = 2;
	WS.RightFunction = 2;
	WS.Duration = 1.0000000;
	FFW = new Class'Engine.ForceFeedbackWaveform';
	FFW.Samples.AddItem(WS);
	// End:0x2B6
	foreach Seats(Seat)
	{
		// End:0x2B5
		if(Seat.SeatPawn != none)
		{
			PC = PlayerController(Seat.SeatPawn.Controller);
			// End:0x2B5
			if(PC != none)
			{
				PC.ClientPlayForceFeedbackWaveform(FFW);
			}
		}		
	}	
	//return;	
}

simulated function PlayHornSound()
{
	SetSwitch('Vehicle_Type', AkVehicleType);
	SetSwitch('Local_Player', ((Instigator.Controller.IsLocalPlayerController()) ? 'Yes' : 'No'));
	PlayAkEvent(AkEvent'Vehicles.Play_Horn');
	//return;	
}

simulated function StopHornSound()
{
	SetSwitch('Vehicle_Type', AkVehicleType);
	PlayAkEvent(AkEvent'Vehicles.Stop_Horn');
	//return;	
}

simulated function AttemptPlayHornSound()
{
	// End:0x74
	if(HornEnabled && (MaxHornDuration == float(0)) || int(CurrentHornState) == int(0))
	{
		PlayHornSound();
		CurrentHornState = 1;
		// End:0x74
		if(MaxHornDuration != float(0))
		{
			SetTimer(MaxHornDuration, false, 'DisableHorn');
		}
	}
	//return;	
}

simulated function AttemptStopHornSound()
{
	// End:0x5E
	if(HornEnabled && int(CurrentHornState) == int(1))
	{
		StopHornSound();
		CurrentHornState = 0;
		// End:0x5E
		if(MaxHornDuration != float(0))
		{
			ClearTimer('DisableHorn');
		}
	}
	//return;	
}

simulated function DisableHorn()
{
	StopHornSound();
	CurrentHornState = 2;
	// End:0x3E
	if(MaxHornDuration != float(0))
	{
		SetTimer(HornCooldownDuration, false, 'EnableHorn');
	}
	//return;	
}

simulated function EnableHorn()
{
	CurrentHornState = 0;
	//return;	
}

simulated function UpdateSkidConditions()
{
	local int Grip, MaxGrip;
	local editinline HaloVehicleWheel myWheel;
	local int I;

	// End:0x1F1
	if(SkidLoopEnabled)
	{
		UpdateSkidMaterial();
		MaxGrip = 0;
		I = 0;
		J0x2D:

		// End:0x1D3 [Loop If]
		if(I < Wheels.Length)
		{
			myWheel = HaloVehicleWheel(Wheels[I]);
			// End:0x1C5
			if(myWheel.bWheelOnGround)
			{
				// End:0x117
				if((WheelIsDrifting(I)) && Abs(ForwardVel) > MinForwardVelToDrift)
				{
					Grip = Min(100, int((float(100) * Abs(myWheel.LatSlipAngle)) / myWheel.MaxLatSlipAngle));					
				}
				else
				{
					// End:0x19B
					if(Abs(myWheel.LongSlipRatio) > SquealThreshold)
					{
						Grip = Min(100, int((float(100) * Abs(myWheel.LongSlipRatio)) / myWheel.MaxLongSlipRatio));
					}
				}
				// End:0x1C5
				if(Grip > MaxGrip)
				{
					MaxGrip = Grip;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x2D;
		}
		SetRTPCValue('Grip', float(MaxGrip));
	}
	//return;	
}

simulated function float GetCurrentAcceleration()
{
	local float Accel, Sum;
	local int I;

	AverageAccel[CurrentAccelIndex++] = ForwardVel - PreviousVel;
	// End:0x4D
	if(CurrentAccelIndex >= AverageAccel.Length)
	{
		CurrentAccelIndex = 0;
	}
	// End:0xCD
	if(bVehicleOnGround)
	{
		I = 0;
		J0x65:

		// End:0xA9 [Loop If]
		if(I < AverageAccel.Length)
		{
			Sum += AverageAccel[I];
			I++;
			// [Loop Continue]
			goto J0x65;
		}
		Accel = Sum / float(AverageAccel.Length);		
	}
	else
	{
		Accel = 0.0000000;
	}
	PreviousVel = ForwardVel;
	return Accel;
	//return ReturnValue;	
}

simulated function UpdateSkidMaterial()
{
	local name MaterialValue;

	MaterialValue = GetValueForMaterialName(CurrentTireMaterial);
	// End:0x47
	if(MaterialValue == 'Unknown')
	{
		MaterialValue = 'Concrete';
	}
	// End:0xF0
	if(PreviousMaterial != MaterialValue)
	{
		// End:0x91
		if(PreviousMaterial == 'Water')
		{
			PlayAkEvent(AkEvent'Vehicles.Play_VEH_Wheel_Skid_Water_Exit');			
		}
		else
		{
			// End:0xC1
			if(MaterialValue == 'Water')
			{
				PlayAkEvent(AkEvent'Vehicles.Play_VEH_Wheel_Skid_Water_Enter');
			}
		}
		PreviousMaterial = MaterialValue;
		SetSwitch('Surface', MaterialValue);
	}
	//return;	
}

simulated function bool ShouldStartSkidLoop(float Accel)
{
	local bool B;

	B = ((bHasBeenDriven && bVehicleOnGround) && bDriving) && (IsUnderHeavyAcceleration(Accel)) || IsDrifting();
	return B;
	//return ReturnValue;	
}

simulated function bool ShouldStopSkidLoop(float Accel)
{
	local bool B;

	B = (!bVehicleOnGround || !bDriving) || (IsEasingOffAcceleration(Accel)) && !IsDrifting();
	return B;
	//return ReturnValue;	
}

simulated function bool IsUnderHeavyAcceleration(float Accel)
{
	local bool B;

	B = ((OutputGas > 0.0000000) || OutputBrake > 0.0000000) && Abs(Accel) > AccelerationStartSkidLimit;
	return B;
	//return ReturnValue;	
}

simulated function bool IsEasingOffAcceleration(float Accel)
{
	local bool B;

	B = ((OutputGas == 0.0000000) && OutputBrake == 0.0000000) || Abs(Accel) < AccelerationStopSkidLimit;
	return B;
	//return ReturnValue;	
}

simulated function StartBoosting()
{
	ServerBoost();
	//return;	
}

simulated function StopBoosting()
{
	DeactivateRocketBoosters();
	//return;	
}

reliable server function ServerBoost()
{
	bTryToBoost = true;
	//return;	
}

simulated function bool IsDrifting()
{
	local bool B;

	B = (Abs(ForwardVel) > MinForwardVelToDrift) && (WheelIsDrifting(0)) || WheelIsDrifting(1);
	return B;
	//return ReturnValue;	
}

simulated function bool WheelIsDrifting(int Wheel)
{
	local bool B;

	B = Abs(Wheels[Wheel].LatSlipAngle) > MinLatSlipToBeDrifting;
	return B;
	//return ReturnValue;	
}

simulated event Destroyed()
{
	StopVehicleSounds();
	// End:0x38
	if(NeedleTargetComponent != none)
	{
		NeedleTargetComponent.OnOwnerDestroyed();
	}
	// End:0x5F
	if(HVCC_AttachedAddon != none)
	{
		HVCC_AttachedAddon.Destroy();
	}
	// End:0x86
	if(HVCC_AttachedWheelSet != none)
	{
		HVCC_AttachedWheelSet.Destroy();
	}
	// End:0xAD
	if(HVCC_AttachedSkin != none)
	{
		HVCC_AttachedSkin.Destroy();
	}
	super.Destroyed();
	//return;	
}

function DriverLeft()
{
	StopVehicleSounds();
	CancelAddonAbility();
	super.DriverLeft();
	//return;	
}

simulated function bool DisableVehicle()
{
	local bool B;

	StopVehicleSounds();
	B = super.DisableVehicle();
	return B;
	//return ReturnValue;	
}

simulated function StopVehicleSounds()
{
	StopEngineSound();
	StopHornSound();
	StopSkidSound();
	StopBoostSound();
	super.StopVehicleSounds();
	//return;	
}

function PlayPlayerEngineFeedback(HaloPlayerPawnController HPPC)
{
	// End:0xDC
	if((HPPC != none) && LocalPlayer(HPPC.Player) != none)
	{
		// End:0x76
		if(EngineFeedbackEnabled)
		{
			HPPC.InitiatePlayEngineFeedback(PlayEngineFeedbackDelay);			
		}
		else
		{
			// End:0xDC
			if(bBoostersActivated)
			{
				HPPC.InitiatePlayEngineFeedback(PlayBoostFeedbackDelay);
				HPPC.UpdateEngineWaveform(BoostFeedbackMagnitude, BoostFeedbackMagnitude);
			}
		}
	}
	//return;	
}

simulated function PlaySuspensionForceFeedback()
{
	local PlayerController PC;
	local int I;

	// End:0xD7
	if(SuspensionWaveform != none)
	{
		I = 0;
		J0x1A:

		// End:0xD7 [Loop If]
		if(I < EnteringPlayers.Length)
		{
			PC = EnteringPlayers[I].PC;
			// End:0xC9
			if((PC != none) && LocalPlayer(PC.Player) != none)
			{
				PC.ClientPlayForceFeedbackWaveform(SuspensionWaveform);
			}
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

simulated function PlayCrashForceFeedback()
{
	local PlayerController PC;
	local int I;

	// End:0xD7
	if(CrashWaveform != none)
	{
		I = 0;
		J0x1A:

		// End:0xD7 [Loop If]
		if(I < EnteringPlayers.Length)
		{
			PC = EnteringPlayers[I].PC;
			// End:0xC9
			if((PC != none) && LocalPlayer(PC.Player) != none)
			{
				PC.ClientPlayForceFeedbackWaveform(CrashWaveform);
			}
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

simulated function UpdateEngineForceFeedback()
{
	local HaloPlayerPawnController HPPC;
	local int I;
	local float Left, Right;

	// End:0x162
	if(bDriving && EngineFeedbackEnabled)
	{
		I = 0;
		J0x27:

		// End:0x162 [Loop If]
		if(I < Seats.Length)
		{
			HPPC = HaloPlayerPawnController(GetControllerForSeatIndex(I));
			// End:0x154
			if((HPPC != none) && LocalPlayer(HPPC.Player) != none)
			{
				Left = (VSize(Velocity) / EngineRunningForceFeedback) + EngineIdleForceFeedback;
				Right = Left;
				Left = FMax(FMin(Left, 100.0000000), 0.0000000);
				Right = FMax(FMin(Right, 100.0000000), 0.0000000);
				HPPC.UpdateEngineWaveform(Left, Right);
			}
			I++;
			// [Loop Continue]
			goto J0x27;
		}
	}
	//return;	
}

function bool DriverEnter(Pawn P)
{
	local bool B;

	B = super.DriverEnter(P);
	PlayPlayerEngineFeedback(HaloPlayerPawnController(GetControllerForSeatIndex(0)));
	return B;
	//return ReturnValue;	
}

function bool PassengerEnter(Pawn aPawn, int SeatIndex)
{
	local bool B;

	B = super.PassengerEnter(aPawn, SeatIndex);
	PlayPlayerEngineFeedback(HaloPlayerPawnController(GetControllerForSeatIndex(SeatIndex)));
	return B;
	//return ReturnValue;	
}

simulated function SetEngineFeedback(bool Enabled)
{
	EngineFeedbackEnabled = Enabled;
	//return;	
}

simulated function bool IsEngineFeedbackEnabled()
{
	return EngineFeedbackEnabled;
	//return ReturnValue;	
}

simulated function UpdateBoost(float DeltaSeconds)
{
	// End:0x13D
	if(CanBoost)
	{
		// End:0x33
		if(bTryToBoost)
		{
			// End:0x33
			if(!bBoostersActivated)
			{
				ActivateRocketBoosters();
			}
		}
		bTryToBoost = false;
		// End:0x13D
		if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
		{
			// End:0xD3
			if(bBoostersActivated)
			{
				// End:0xD0
				if(BoostAmount > float(0))
				{
					BoostAmount -= (DeltaSeconds * (100.0000000 / MaxBoostDuration));
					// End:0xD0
					if(BoostAmount <= float(0))
					{
						BoostAmount = 0.0000000;
						DeactivateRocketBoosters();
					}
				}				
			}
			else
			{
				// End:0x13D
				if(!bBoostChargeIsDelayed && BoostAmount < float(100))
				{
					BoostAmount += (DeltaSeconds * (100.0000000 / BoostChargeTime));
					// End:0x13D
					if(BoostAmount > float(100))
					{
						BoostAmount = 100.0000000;
					}
				}
			}
		}
	}
	//return;	
}

simulated event ActivateRocketBoosters()
{
	local PlayerController PC;

	// End:0xFC
	if(CanBoost && BoostAmount > float(0))
	{
		bBoostersActivated = true;
		bSteeringLimited = true;
		AirSpeed = RocketAirSpeed;
		GroundSpeed = RocketGroundSpeed;
		ChangeSteeringRadius(true);
		StartBoostSound();
		PC = PlayerController(Seats[0].SeatPawn.Controller);
		// End:0xE8
		if(PC != none)
		{
			PC.StopFire();
		}
		PlayBoostForceFeedback();
		ResetRechargeTimer();
	}
	//return;	
}

simulated event DeactivateRocketBoosters()
{
	// End:0xA1
	if(CanBoost && BoostAmount < float(100))
	{
		bBoostersActivated = false;
		bSteeringLimited = false;
		AirSpeed = default.AirSpeed;
		GroundSpeed = default.GroundSpeed;
		ChangeSteeringRadius(false);
		StopBoostSound();
		StopBoostForceFeedback();
		bBoostChargeIsDelayed = true;
		SetTimer(BoostChargeDelay, false, 'ResetRechargeTimer', self);
	}
	//return;	
}

simulated function ResetRechargeTimer()
{
	bBoostChargeIsDelayed = false;
	ClearTimer('ResetRechargeTimer');
	//return;	
}

simulated function ChangeSteeringRadius(bool BoostOn)
{
	//return;	
}

simulated function PlayBoostForceFeedback()
{
	local HaloPlayerPawnController HPPC;
	local VehicleSeat Seat;

	// End:0xE3
	if(!EngineFeedbackEnabled && BoostFeedbackEnabled)
	{
		// End:0xE2
		foreach Seats(Seat)
		{
			HPPC = HaloPlayerPawnController(Seat.SeatPawn.Controller);
			// End:0xE1
			if(HPPC != none)
			{
				HPPC.UpdateEngineWaveform(BoostFeedbackMagnitude, BoostFeedbackMagnitude);
				HPPC.InitiatePlayEngineFeedback(PlayBoostFeedbackDelay);
			}			
		}		
	}
	//return;	
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
	// End:0x66
	if(bBoostersActivated)
	{
		// End:0x57
		if(InForward < 0.0000000)
		{
			// End:0x45
			if(ForwardVel <= 0.0000000)
			{
				InForward = 0.0000000;				
			}
			else
			{
				InForward = -1.0000000;
			}			
		}
		else
		{
			InForward = 1.0000000;
		}
	}
	super.SetInputs(InForward, InStrafe, InUp);
	//return;	
}

simulated function StopBoostForceFeedback()
{
	local HaloPlayerPawnController HPPC;
	local VehicleSeat Seat;

	// End:0xD2
	if(BoostFeedbackEnabled)
	{
		// End:0xD1
		foreach Seats(Seat)
		{
			HPPC = HaloPlayerPawnController(Seat.SeatPawn.Controller);
			// End:0xD0
			if(HPPC != none)
			{
				HPPC.InitiateStopEngineFeedback(PlayBoostFeedbackDelay);
				HPPC.UpdateEngineWaveform(BoostFeedbackMagnitude, BoostFeedbackMagnitude);
			}			
		}		
	}
	//return;	
}

simulated function DrivingStatusChanged()
{
	super.DrivingStatusChanged();
	// End:0x2D
	if(bDriving)
	{
		VehicleEvent('StartEngine');		
	}
	else
	{
		VehicleEvent('StopEngine');
	}
	//return;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	// End:0x6B
	if(super.Died(Killer, DamageType, HitLocation))
	{
		VehicleEvent('StopEngine');
		// End:0x69
		if(NeedleTargetComponent != none)
		{
			NeedleTargetComponent.OnDeath();
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function name GetValueForMaterialName(name MaterialName)
{
	local name Value;

	switch(MaterialName)
	{
		// End:0x1F
		case 'Grass':
		// End:0x2B
		case 'Grass_Material':
		// End:0x4D
		case 'PM_Grass':
			Value = 'Grass';
			// End:0x15A
			break;
		// End:0x59
		case 'Dirt':
		// End:0x65
		case 'Dirt_Material':
		// End:0x87
		case 'PM_Dirt':
			Value = 'Dirt';
			// End:0x15A
			break;
		// End:0x93
		case 'Water':
		// End:0x9F
		case 'Water_Material':
		// End:0xC1
		case 'PM_Water':
			Value = 'Water';
			// End:0x15A
			break;
		// End:0xCD
		case 'Snow':
		// End:0xD9
		case 'Snow_Material':
		// End:0xFB
		case 'PM_Snow':
			Value = 'Snow';
			// End:0x15A
			break;
		// End:0x107
		case 'Concrete':
		// End:0x113
		case 'Concrete_Material':
		// End:0x11F
		case 'PM_Concrete':
		// End:0x141
		case 'None':
			Value = 'Concrete';
			// End:0x15A
			break;
		// End:0xFFFF
		default:
			Value = 'Unknown';
			// End:0x15A
			break;
			break;
	}
	return Value;
	//return ReturnValue;	
}

simulated function int CheckEntryRadii(Pawn P, optional out int entryPointIdx)
{
	local Vector EntryLoc;
	local Rotator EntryRot;
	local int I, Dist, bestSeat, bestDist;

	bestSeat = -1;
	bestDist = 2147483647;
	I = 0;
	J0x2A:

	// End:0x19A [Loop If]
	if(I < EntryPoints.Length)
	{
		// End:0x18C
		if(SeatAvailable(I))
		{
			Mesh.GetSocketWorldLocationAndRotation(EntryPoints[I].SocketName, EntryLoc, EntryRot);
			Dist = int(VSize(P.Location - EntryLoc));
			// End:0x18C
			if((float(Dist) <= EntryPoints[I].Radius) && Dist <= bestDist)
			{
				bestSeat = EntryPoints[I].SeatIndex;
				bestDist = Dist;
				entryPointIdx = I;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x2A;
	}
	return bestSeat;
	//return ReturnValue;	
}

event Vector GetAIEntryLocation(int SeatIndex)
{
	local int I;
	local Vector EntryLoc;
	local Rotator EntryRot;

	I = 0;
	J0x0B:

	// End:0xC7 [Loop If]
	if(I < EntryPoints.Length)
	{
		// End:0xB9
		if(EntryPoints[I].SeatIndex == SeatIndex)
		{
			Mesh.GetSocketWorldLocationAndRotation(EntryPoints[I].SocketName, EntryLoc, EntryRot);
			return EntryLoc;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return ReturnValue;	
}

function int GetFirstEntryPoint(int SeatIndex)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x6F [Loop If]
	if(I < EntryPoints.Length)
	{
		// End:0x61
		if(EntryPoints[I].SeatIndex == SeatIndex)
		{
			return I;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

function int GetValidExitPointIndex(int SeatIndex)
{
	local int I;
	local Vector ExitPos;
	local Rotator throwAwayRot;

	I = 0;
	J0x0B:

	// End:0x117 [Loop If]
	if(I < EntryPoints.Length)
	{
		// End:0x109
		if(EntryPoints[I].SeatIndex == SeatIndex)
		{
			Mesh.GetSocketWorldLocationAndRotation(EntryPoints[I].SocketName, ExitPos, throwAwayRot);
			ExitPos = ExitPos;
			// End:0x109
			if(CheckExitPos(Seats[SeatIndex].StoragePawn, ExitPos, true))
			{
				return I;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

simulated function bool SeatAvailable(int SeatIndex)
{
	return ((SeatIndex >= 0) && SeatIndex < Seats.Length) && (Seats[SeatIndex].SeatPawn == none) || Seats[SeatIndex].SeatPawn.Controller == none;
	//return ReturnValue;	
}

simulated function bool CanEnterVehicle(Pawn P)
{
	local int SeatIndex;

	// End:0xA6
	if((((P.Controller != none) && HaloPlayerPawnController(P.Controller) != none) && HaloPlayerPawnController(P.Controller).bIsAimingTargetDesignator) || bHidden)
	{
		return false;
	}
	SeatIndex = CheckEntryRadii(P);
	return (((SeatIndex != -1) && SeatIndex < Seats.Length) && SeatAvailable(SeatIndex)) && super.CanEnterVehicle(P);
	//return ReturnValue;	
}

simulated function bool ShouldShowUseable(PlayerController PC, float Dist)
{
	local UTPlayerController UTPC;

	UTPC = UTPlayerController(PC);
	return (CanEnterVehicle(PC.Pawn)) && (UTPC.CheckVehicleToDrive(false) == self) || (bRequestedEntryWithFlag && UTPC.bJustFoundVehicle) && UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag;
	//return ReturnValue;	
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	BlokSpawner.TryToThrowBloks((float(Health) / float(HealthMax)) * 100.0000000);
	SetSwitch('Object_Type', AkObjectType);
	// End:0x1DB
	if(Health <= 0)
	{
		StopEngineSound();
		StopHornSound();
		CurrentHornState = 0;
		// End:0xFB
		if(HVCC_AttachedAddon != none)
		{
			HVCC_AttachedAddon.Destroy();
		}
		SetRTPCValue('Impulse_Value', float(AkBreakMega));
		PlayAkEvent(AkEvent'Objects.Play_Object_Destroyed');
		SetSwitch('Explosion_Type', 'Explosion_Concussive');
		SetSwitch('Explosion_Size', 'Explosion_Large');
		PlayAkEvent(AkEvent'Foley.Play_Explosion');
		StartBurnOut();
		WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionTemplate, Location);		
	}
	else
	{
		// End:0x229
		if(Damage > 1)
		{
			SetRTPCValue('Impulse_Value', float(Min(Damage * 2, 100)));
			PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
		}
	}
	//return;	
}

simulated function bool AttachWeapon(HaloWeapon NewWeapon, int SeatIndex)
{
	// End:0x5F
	if((SeatIndex > -1) && SeatIndex < Seats.Length)
	{
		Seats[SeatIndex].Gun = NewWeapon;
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function DetachWeapon(int SeatIndex)
{
	// End:0x55
	if((SeatIndex > -1) && SeatIndex < Seats.Length)
	{
		Seats[SeatIndex].Gun = none;
	}
	//return;	
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local float Dist;
	local bool bShowUseable;
	local UTHUDBase HUD;
	local int entrySeatIndex;

	HUD = UTHUDBase(PC.myHUD);
	Dist = VSize(CameraPosition - Location);
	EnteringPlayers.Length = 0;
	// End:0x568
	if(!bPlayingSpawnEffect && (UTPawn(PC.Pawn) != none) || UTVehicle_Hoverboard(PC.Pawn) != none)
	{
		// End:0x4D2
		if(bShowUseable || ShouldShowUseable(PC, Dist))
		{
			bShowUseable = true;
			// End:0x273
			if(bRequestedEntryWithFlag && UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag)
			{
				HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.6000000, DropFlagIconCoords.U, DropFlagIconCoords.V, DropFlagIconCoords.UL, DropFlagIconCoords.VL, Canvas.ClipY / float(720));				
			}
			else
			{
				// End:0x390
				if(bIsInverted && bCanFlip)
				{
					EnteringPlayers.Add(1);
					EnteringPlayers[EnteringPlayers.Length - 1].PC = PC;
					EnteringPlayers[EnteringPlayers.Length - 1].Seat = 99;
					// End:0x38D
					if(HaloPlayerPawnController(PC) != none)
					{
						HaloPlayerPawnController(PC).ActionableVehicleEntry.Vehicle = self;
						HaloPlayerPawnController(PC).ActionableVehicleEntry.Seat = 99;
					}					
				}
				else
				{
					entrySeatIndex = CheckEntryRadii(PC.Pawn);
					EnteringPlayers.Add(1);
					EnteringPlayers[EnteringPlayers.Length - 1].PC = PC;
					EnteringPlayers[EnteringPlayers.Length - 1].Seat = entrySeatIndex;
					// End:0x4CF
					if(HaloPlayerPawnController(PC) != none)
					{
						HaloPlayerPawnController(PC).ActionableVehicleEntry.Vehicle = self;
						HaloPlayerPawnController(PC).ActionableVehicleEntry.Seat = entrySeatIndex;
					}
				}
			}			
		}
		else
		{
			// End:0x522
			if(!WorldInfo.GRI.GameClass.default.bTeamGame)
			{
				return;
			}
			// End:0x559
			if(bRequestedEntryWithFlag)
			{
				UTPlayerController(PC).bJustFoundVehicle = false;
			}
			bRequestedEntryWithFlag = false;
		}		
	}
	else
	{
		// End:0x5B8
		if(!WorldInfo.GRI.GameClass.default.bTeamGame)
		{
			return;
		}
		// End:0x5EF
		if(bRequestedEntryWithFlag)
		{
			UTPlayerController(PC).bJustFoundVehicle = false;
		}
		bRequestedEntryWithFlag = false;
	}
	//return;	
}

simulated function float GetCamInterpRate()
{
	local float F;

	F = Abs(GetCameraToVehicleAngle());
	// End:0x58
	if(F > (3.1415927 / 2.0000000))
	{
		F = (3.1415927 / 2.0000000) - (F / 4.0000000);
	}
	F = CameraIdleInterpRate + (F * CameraSteerInterpRate);
	return F;
	//return ReturnValue;	
}

simulated function float PercentOfTopSpeed()
{
	local float F;

	F = Abs(ForwardVel) / MaxSpeed;
	return F;
	//return ReturnValue;	
}

simulated function float GetJoystickAngle(float Forward, float Strafe)
{
	local float Angle;

	// End:0x79
	if(Forward == float(0))
	{
		// End:0x3B
		if(Strafe > float(0))
		{
			Angle = 3.1415927 / 2.0000000;			
		}
		else
		{
			// End:0x67
			if(Strafe < float(0))
			{
				Angle = -3.1415927 / 2.0000000;				
			}
			else
			{
				Angle = 0.0000000;
			}
		}		
	}
	else
	{
		Angle = Atan(Strafe / Forward);
		// End:0xDE
		if(Forward < float(0))
		{
			// End:0xCE
			if(Strafe > float(0))
			{
				Angle += 3.1415927;				
			}
			else
			{
				Angle -= 3.1415927;
			}
		}
	}
	return Angle;
	//return ReturnValue;	
}

simulated function float GetCameraToVehicleAngle()
{
	local Vector v1, v2;
	local float Angle;

	v1 = Normal(Vector(Instigator.GetViewRotation()));
	v2 = Normal(Vector(Mesh.GetRotation()));
	Angle = Acos(v1 Dot v2);
	v1 = v1 Cross vect(0.0000000, 0.0000000, 1.0000000);
	// End:0xD2
	if((v1 Dot v2) < float(0))
	{
		Angle *= float(-1);
	}
	return Angle;
	//return ReturnValue;	
}

simulated function float GetCameraToVehicleYawAngle()
{
	local float Angle1, Angle2, Angle3;

	Angle1 = float(Instigator.GetViewRotation().Yaw % 65536) * 0.0000959;
	Angle2 = float(Mesh.GetRotation().Yaw % 65536) * 0.0000959;
	Angle3 = GetBoundedCircularAngle(Angle1 - Angle2);
	return Angle3;
	//return ReturnValue;	
}

simulated function bool IsAngleToRight(float Angle1, float Angle2)
{
	local float Result;
	local bool B;

	Result = GetBoundedCircularAngle(Angle1 - Angle2);
	B = Result >= float(0);
	return B;
	//return ReturnValue;	
}

simulated function float GetBoundedCircularAngle(float Angle)
{
	J0x00:
	// End:0x2D [Loop If]
	if(Angle > 3.1415927)
	{
		Angle -= (2.0000000 * 3.1415927);
		// [Loop Continue]
		goto J0x00;
	}
	J0x2D:

	// End:0x5C [Loop If]
	if(Angle < -3.1415927)
	{
		Angle += (2.0000000 * 3.1415927);
		// [Loop Continue]
		goto J0x2D;
	}
	return Angle;
	//return ReturnValue;	
}

simulated function float GetCircularAngle(float XVal, float YVal)
{
	local float Angle;

	// End:0x34
	if(XVal != float(0))
	{
		Angle = Atan(YVal / XVal);		
	}
	else
	{
		// End:0x5E
		if(YVal > float(0))
		{
			Angle = 3.1415927 / 2.0000000;			
		}
		else
		{
			Angle = -3.1415927 / 2.0000000;
		}
	}
	// End:0xE5
	if(XVal < 0.0000000)
	{
		Angle *= -1.0000000;
		// End:0xC9
		if(YVal > 0.0000000)
		{
			Angle = 3.1415927 - Angle;			
		}
		else
		{
			Angle = -3.1415927 - Angle;
		}
	}
	return Angle;
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;
	local int I;
	local Vector EntryLoc;
	local Rotator EntryRot;

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(128, 128, 255);
	Canvas.DrawText("Mass " $ string(Mesh.BodyInstance.GetBodyMass()));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	I = 0;
	J0xFD:

	// End:0x1BD [Loop If]
	if(I < EntryPoints.Length)
	{
		Mesh.GetSocketWorldLocationAndRotation(EntryPoints[I].SocketName, EntryLoc, EntryRot);
		DrawDebugSphere(EntryLoc, EntryPoints[I].Radius, 8, 0, 255, 0);
		I++;
		// [Loop Continue]
		goto J0xFD;
	}
	// End:0x2D0
	if((HVCC_AttachedAddon != none) && HVCC_AttachedAddon.IsA('HVCCAddon_MagWinch'))
	{
		DrawDebugCone(HVCC_AttachedAddon.Location, Vector(HVCC_AttachedAddon.Rotation), HVCCAddon_MagWinch(HVCC_AttachedAddon).MaxWinchRange, HVCCAddon_MagWinch(HVCC_AttachedAddon).MaxWinchRotDif * 0.0174533, HVCCAddon_MagWinch(HVCC_AttachedAddon).MaxWinchRotDif * 0.0174533, 16, MakeColor(255, 0, 0));
	}
	super(SVehicle).DisplayDebug(HUD, out_YL, out_YPos);
	//return;	
}

function InitializeSeats()
{
	local int I;
	local HaloWeaponPawn HWP;

	// End:0x6B
	if(Seats.Length == 0)
	{
		LogInternal(("WARNING: Vehicle (" $ string(self)) $ ") **MUST** have at least one seat defined");
		self.Destroy();
		return;
	}
	I = 0;
	J0x76:

	// End:0x8A2 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x60B
		if(I > 0)
		{
			Seats[I].SeatPawn = Spawn(SeatPawnClass);
			Seats[I].SeatPawn.SetBase(self);
			Seats[I].Gun = UTVehicleWeapon(Seats[I].SeatPawn.InvManager.CreateInventory(Seats[I].GunClass));
			// End:0x224
			if(Seats[I].Gun != none)
			{
				Seats[I].Gun.SetBase(self);
			}
			Seats[I].SeatPawn.EyeHeight = Seats[I].SeatPawn.BaseEyeHeight;
			UTWeaponPawn(Seats[I].SeatPawn).MyVehicleWeapon = UTVehicleWeapon(Seats[I].Gun);
			UTWeaponPawn(Seats[I].SeatPawn).MyVehicle = self;
			UTWeaponPawn(Seats[I].SeatPawn).MySeatIndex = I;
			// End:0x441
			if(Seats[I].ViewPitchMin != 0.0000000)
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMin = Seats[I].ViewPitchMin;				
			}
			else
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMin = ViewPitchMin;
			}
			// End:0x52D
			if(Seats[I].ViewPitchMax != 0.0000000)
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMax = Seats[I].ViewPitchMax;				
			}
			else
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMax = ViewPitchMax;
			}
			HWP = HaloWeaponPawn(Seats[I].SeatPawn);
			// End:0x608
			if(HWP != none)
			{
				HWP.CameraYawRate = Seats[I].SeatCameraYawRate;
			}			
		}
		else
		{
			Seats[I].SeatPawn = self;
			Seats[I].Gun = UTVehicleWeapon(InvManager.CreateInventory(Seats[I].GunClass));
			// End:0x70E
			if(Seats[I].Gun != none)
			{
				Seats[I].Gun.SetBase(self);
			}
		}
		Seats[I].SeatPawn.DriverDamageMult = Seats[I].DriverDamageMult;
		Seats[I].SeatPawn.bDriverIsVisible = Seats[I].bSeatVisible;
		// End:0x894
		if(Seats[I].Gun != none)
		{
			UTVehicleWeapon(Seats[I].Gun).SeatIndex = I;
			UTVehicleWeapon(Seats[I].Gun).MyVehicle = self;
		}
		I++;
		// [Loop Continue]
		goto J0x76;
	}
	//return;	
}

simulated function AttachDriver(Pawn P)
{
	OldPositions.Length = 0;
	EyeHeight = BaseEyeHeight;
	AttachDriverToSeat(P, 0);
	//return;	
}

function AttachDriverToSeat(Pawn P, int SeatIndex)
{
	local HaloPawn HP;
	local name SeatBone;
	local Vector SeatOffset;
	local name AnimName;
	local int entryPointIdx;

	HP = HaloPawn(P);
	// End:0x164
	if(HP != none)
	{
		// End:0xA3
		if(Seats.Length > SeatIndex)
		{
			SeatBone = Seats[SeatIndex].SeatBone;
			SeatOffset = Seats[SeatIndex].SeatOffset;
		}
		// End:0x129
		if(EntryPoints.Length > SeatIndex)
		{
			entryPointIdx = -1;
			CheckEntryRadii(P, entryPointIdx);
			// End:0x129
			if(entryPointIdx != -1)
			{
				AnimName = EntryPoints[entryPointIdx].EnterPawnAnimName;
			}
		}
		HP.AttachToVehicle(self, SeatBone, SeatOffset, AnimName);
	}
	//return;	
}

function AttachDriverNow(HaloPawn P)
{
	AttachDriver(P);
	//return;	
}

event bool DriverLeave(bool bForceLeave)
{
	local HaloPawn HaloDriver;
	local name AnimName;
	local int EntryIdx;

	// End:0x17
	if(bBoostersActivated)
	{
		DeactivateRocketBoosters();
	}
	// End:0x3A
	if(bIsSkidding)
	{
		bIsSkidding = false;
		StopSkidSound();
	}
	// End:0x10F
	if(!bForceLeave)
	{
		HaloDriver = HaloPawn(Driver);
		// End:0x10F
		if(HaloDriver != none)
		{
			// End:0xDC
			if(EntryPoints.Length > 0)
			{
				EntryIdx = GetValidExitPointIndex(0);
				// End:0xDC
				if(EntryIdx != -1)
				{
					AnimName = EntryPoints[EntryIdx].ExitPawnAnimName;
				}
			}
			HaloDriver.DriverLeave(AnimName, Controller);
			return true;
		}
	}
	return super.DriverLeave(bForceLeave);
	//return ReturnValue;	
}

function DriverLeaveNow()
{
	DriverLeave(false);
	//return;	
}

function bool CheckExitPos(Pawn ExitingDriver, Vector ExitPos, bool bMustFindGround)
{
	local Vector Slice, HitLocation, HitNormal, StartLocation, NewActorPos;

	local Actor HitActor;

	Slice = ExitingDriver.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
	Slice.Z = 2.0000000;
	StartLocation = GetTargetLocation();
	// End:0xAB
	if(Trace(HitLocation, HitNormal, ExitPos, StartLocation, false, Slice) != none)
	{
		return false;
	}
	HitActor = Trace(HitLocation, HitNormal, ExitPos - (ExitingDriver.GetCollisionHeight() * vect(0.0000000, 0.0000000, 5.0000000)), ExitPos, true, Slice);
	// End:0x149
	if(HitActor == none)
	{
		// End:0x136
		if(bMustFindGround)
		{
			return false;
		}
		HitLocation = ExitPos;
	}
	NewActorPos = HitLocation + ((ExitingDriver.GetCollisionHeight() + ExitingDriver.MaxStepHeight) * vect(0.0000000, 0.0000000, 1.0000000));
	// End:0x1EC
	if(PointCheckComponent(Mesh, NewActorPos, ExitingDriver.GetCollisionExtent()))
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local HaloPawn HaloDriver;

	// End:0x23
	if(ExitingDriver == none)
	{
		ExitingDriver = Driver;
	}
	// End:0x34
	if(ExitingDriver == none)
	{
		return false;
	}
	HaloDriver = HaloPawn(ExitingDriver);
	// End:0x84
	if(HaloDriver != none)
	{
		// End:0x84
		if(HaloDriver.PlaceExitingDriver(self))
		{
			return true;
		}
	}
	return FindAutoExit(ExitingDriver);
	//return ReturnValue;	
}

function bool IsValidEnemyTarget(const Pawn Target, const Pawn Enemy)
{
	// End:0xD1
	if((((((Enemy != none) && Target != none) && Enemy != Target) && int(Enemy.GetTeamNum()) != int(Target.GetTeamNum())) && Enemy.bHidden == false) && Enemy.Health > 0)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function float ScoreEnemyTarget(const Vector aLocation, float MaxDistance, float maxAnglePitch, float minAnglePitch, float maxAngleYaw, const Vector bLocation, const Rotator BRotation)
{
	local Vector aDirection;
	local Rotator aYaw, bYaw, aPitch, bPitch;
	local float Score, Distance, YawAngle, PitchAngle, adjustedAngle;

	Score = 0.0000000;
	aDirection = aLocation - bLocation;
	Distance = VSize(aDirection);
	aYaw.Yaw = Rotator(aDirection).Yaw;
	bYaw.Yaw = BRotation.Yaw;
	YawAngle = RDiff(aYaw, bYaw);
	maxAngleYaw = maxAngleYaw - ((maxAngleYaw - -maxAngleYaw) * (Distance / MaxDistance));
	aPitch.Pitch = Rotator(aDirection).Pitch;
	bPitch.Pitch = BRotation.Pitch;
	PitchAngle = RDiff(aPitch, bPitch);
	maxAnglePitch = maxAnglePitch - ((maxAnglePitch - -maxAnglePitch) * (Distance / MaxDistance));
	// End:0x2A3
	if(((Distance < MaxDistance) && YawAngle < maxAngleYaw) && PitchAngle < maxAnglePitch)
	{
		adjustedAngle = (180.0000000 - YawAngle) / float(180);
		Score = adjustedAngle + (((1.0000000 - (Distance / MaxDistance)) * adjustedAngle) * 0.6500000);
	}
	return Score;
	//return ReturnValue;	
}

function Rotator FindBestAutoAimTargetRotation(const int SeatIndex)
{
	local Pawn aPawn, bestPawn;
	local Actor Target;
	local float MaxDistance, Score, bestScore;
	local Vector aLocation, toBest;
	local Rotator ARotation, bestRotation;

	MaxDistance = AutoAimDistance;
	Target = Seats[SeatIndex].StoragePawn;
	GetBarrelLocationAndRotation(SeatIndex, aLocation, ARotation);
	// End:0x93
	if(CCSController(Controller) != none)
	{
		bestRotation = ARotation;
	}
	bestScore = 0.0000000;
	aPawn = Target.WorldInfo.PawnList;
	J0xDF:

	// End:0x1E6 [Loop If]
	if(aPawn != none)
	{
		Score = ScoreEnemyTarget(aPawn.Location, MaxDistance, AutoAimAnglePitchMax, AutoAimAnglePitchMin, AutoAimAngleYawDiff, aLocation, ARotation);
		// End:0x1BB
		if(Score > bestScore)
		{
			// End:0x1BB
			if(IsValidEnemyTarget(Pawn(Target), aPawn))
			{
				bestScore = Score;
				bestPawn = aPawn;
			}
		}
		aPawn = aPawn.NextPawn;
		// [Loop Continue]
		goto J0xDF;
	}
	// End:0x36C
	if(bestPawn == none)
	{
		Target = self;
		ARotation = Target.Rotation;
		aPawn = Target.WorldInfo.PawnList;
		J0x265:

		// End:0x36C [Loop If]
		if(aPawn != none)
		{
			Score = ScoreEnemyTarget(aPawn.Location, MaxDistance, AutoAimAnglePitchMax, AutoAimAnglePitchMin, AutoAimAngleYawDiff, aLocation, ARotation);
			// End:0x341
			if(Score > bestScore)
			{
				// End:0x341
				if(IsValidEnemyTarget(Pawn(Target), aPawn))
				{
					bestScore = Score;
					bestPawn = aPawn;
				}
			}
			aPawn = aPawn.NextPawn;
			// [Loop Continue]
			goto J0x265;
		}
	}
	// End:0x3C3
	if(bestPawn != none)
	{
		toBest = bestPawn.Location - aLocation;
		bestRotation = Rotator(toBest);
	}
	return bestRotation;
	//return ReturnValue;	
}

simulated function BroadcastThreat()
{
	local HaloAIPawn enemyPawn;
	local CCSController enemyPawnController;

	// End:0x125
	if(bDriving)
	{
		// End:0x124
		foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloAIPawn', enemyPawn, Location, VSize(Velocity * 1.0000000))
		{
			// End:0x123
			if((enemyPawn != none) && (Velocity Dot (enemyPawn.Location - Location)) > 0.9396926)
			{
				enemyPawnController = CCSController(enemyPawn.Controller);
				// End:0x123
				if(enemyPawnController != none)
				{
					enemyPawnController.NotifyThreatened(self, self.Velocity, 2);
				}
			}			
		}		
	}
	//return;	
}

simulated event bool GwNavBotEnterVehicle(Pawn Bot)
{
	local int entrySeat;
	local float Dist;
	local Vector EntryLoc;
	local Rotator EntryRot;

	entrySeat = GetFirstAvailableSeat();
	// End:0x29
	if(entrySeat == -1)
	{
		return false;
	}
	Mesh.GetSocketWorldLocationAndRotation(EntryPoints[entrySeat].SocketName, EntryLoc, EntryRot);
	Dist = VSize(Bot.Location - EntryLoc);
	// End:0x160
	if((HaloAIPawn(Bot) != none) && Dist <= EntryPoints[entrySeat].Radius)
	{
		HaloAIPawn(Bot).AttemptToEnter = self;
		HaloAIPawn(Bot).SeatToEnter = entrySeat;
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated event bool GwNavBotExitVehicle(Pawn WeaponPawn)
{
	local HaloWeaponPawn HaloWeaponPawn;

	HaloWeaponPawn = HaloWeaponPawn(WeaponPawn);
	// End:0x2D
	if(HaloWeaponPawn == none)
	{
		return false;
	}
	// End:0xA2
	if(HaloAIPawn(HaloWeaponPawn.Driver) != none)
	{
		HaloAIPawn(HaloWeaponPawn.Driver).AttemptToExit = HaloWeaponPawn;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	return DeployableCategory;
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	DeployableCategory = newCategory;
	//return;	
}

function name GetDeployableName()
{
	return DeployableName;
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	DeployableName = NewName;
	//return;	
}

function Actor GetDeployableBase()
{
	return DeployableBase;
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	DeployableBase = NewBase;
	//return;	
}

function Actor GetDeployable()
{
	return self;
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	return DeployedCustomizations;
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	DeployedCustomizations = Customizations;
	//return;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	DisableVehicle();
	super.FellOutOfWorld(dmgType);
	//return;	
}

simulated function EntryAnnouncement(Controller C)
{
	super.EntryAnnouncement(C);
	// End:0x29
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	// End:0x61
	if(C != none)
	{
		SetTeamNum(C.GetTeamNum());
	}
	//return;	
}

event int GetFirstAvailableSeat()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x5B [Loop If]
	if(I < AISeatIndexOrder.Length)
	{
		// End:0x4D
		if(SeatAvailable(AISeatIndexOrder[I]))
		{
			return I;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

simulated function TargetOfInterestSet(const Actor Target, optional float inTime = 1.0000000, optional float viewTime = 2.0000000, optional float outTime = 1.0000000, optional Vector SeatOffsetAdjustment)
{
	// End:0x186
	if(TargetOfInterest.Target == none)
	{
		TargetOfInterest.Target = Target;
		TargetOfInterest.ElapsedTime = 0.0000000;
		TargetOfInterest.BlendPct = 0.0000000;
		TargetOfInterest.BlendInTime = inTime;
		TargetOfInterest.BlendViewTime = ((viewTime == -1.0000000) ? inTime + 999999.0000000 : inTime + viewTime);
		TargetOfInterest.BlendOutTime = (inTime + viewTime) + outTime;
		TargetOfInterest.SeatOffsetAdjustment = SeatOffsetAdjustment;
	}
	//return;	
}

simulated function TargetOfInterestRemove(const Actor Target)
{
	// End:0xBE
	if(TargetOfInterest.Target == Target)
	{
		TargetOfInterest.Target = none;
		// End:0xBE
		if(TargetOfInterest.ElapsedTime < TargetOfInterest.BlendViewTime)
		{
			TargetOfInterest.ElapsedTime = TargetOfInterest.BlendViewTime;
		}
	}
	//return;	
}

simulated function UpdateTargetOfInterest(float DeltaTime)
{
	TargetOfInterest.ElapsedTime = FMin(TargetOfInterest.ElapsedTime + DeltaTime, TargetOfInterest.BlendOutTime);
	// End:0xC4
	if(TargetOfInterest.ElapsedTime == TargetOfInterest.BlendOutTime)
	{
		TargetOfInterest.BlendPct = 1.0000000;		
	}
	else
	{
		// End:0x179
		if(TargetOfInterest.ElapsedTime < TargetOfInterest.BlendInTime)
		{
			TargetOfInterest.BlendPct = FCubicInterp(0.0000000, 0.0000000, 1.0000000, 0.0000000, TargetOfInterest.ElapsedTime / TargetOfInterest.BlendInTime);			
		}
		else
		{
			// End:0x1DB
			if(TargetOfInterest.ElapsedTime < TargetOfInterest.BlendViewTime)
			{
				TargetOfInterest.BlendPct = 1.0000000;				
			}
			else
			{
				TargetOfInterest.BlendPct = 1.0000000 - FCubicInterp(0.0000000, 0.0000000, 1.0000000, 0.0000000, (TargetOfInterest.ElapsedTime - TargetOfInterest.BlendViewTime) / (TargetOfInterest.BlendOutTime - TargetOfInterest.BlendViewTime));
			}
		}
	}
	//return;	
}

simulated function Rotator TargetOfInterestEvalRotation(const Vector CameraLocation, const Rotator CameraRotation)
{
	local Rotator oRotation, BRotation;
	local float diffYaw;

	// End:0x47
	if(TargetOfInterest.ElapsedTime == TargetOfInterest.BlendOutTime)
	{
		return CameraRotation;
	}
	oRotation = CameraRotation;
	// End:0x24C
	if(TargetOfInterest.Target != none)
	{
		BRotation = Rotator(TargetOfInterest.Target.Location - CameraLocation);
		diffYaw = float(NormalizeRotAxis(BRotation.Yaw - CameraRotation.Yaw));
		// End:0x1C5
		if(Abs(diffYaw) > (90.0000000 * 182.0444031))
		{
			diffYaw = ((diffYaw > 0.0000000) ? (180.0000000 * 182.0444031) - diffYaw : (-180.0000000 * 182.0444031) - diffYaw);
			BRotation.Yaw = int(float(CameraRotation.Yaw) + diffYaw);
		}
		BRotation.Yaw = ClampRotAxisFromBase(BRotation.Yaw, CameraRotation.Yaw, int(TargetOfInterest.YawBuffer * 182.0444031));		
	}
	else
	{
		BRotation.Yaw = NormalizeRotAxis(CameraRotation.Yaw + TargetOfInterest.Rotation.Yaw);
		BRotation.Pitch = NormalizeRotAxis(CameraRotation.Pitch + TargetOfInterest.Rotation.Pitch);
	}
	oRotation = RLerp(CameraRotation, BRotation, TargetOfInterest.BlendPct, true);
	// End:0x3CB
	if(TargetOfInterest.Target != none)
	{
		TargetOfInterest.Rotation = oRotation - CameraRotation;
	}
	return oRotation;
	//return ReturnValue;	
}

simulated function Vector TargetOfInterestEvalSeatOffset(int SeatIndex)
{
	// End:0x88
	if((TargetOfInterest.ElapsedTime == TargetOfInterest.BlendOutTime) || IsZero(TargetOfInterest.SeatOffsetAdjustment))
	{
		return Seats[SeatIndex].CameraBaseOffset;
	}
	return VLerp(Seats[SeatIndex].CameraBaseOffset, Seats[SeatIndex].CameraBaseOffset + TargetOfInterest.SeatOffsetAdjustment, TargetOfInterest.BlendPct);
	//return ReturnValue;	
}

simulated function VehicleCalcCamera(float DeltaTime, int SeatIndex, out Vector out_CamLoc, out Rotator out_CamRot, out Vector CamStart, optional bool bPivotOnly)
{
	super.VehicleCalcCamera(DeltaTime, SeatIndex, out_CamLoc, out_CamRot, CamStart, bPivotOnly);
	out_CamRot = TargetOfInterestEvalRotation(out_CamLoc, out_CamRot);
	//return;	
}

simulated function Vector GetCameraFocus(int SeatIndex)
{
	local Vector CamStart, HitLocation, HitNormal, Offset;
	local Actor HitActor;

	// End:0xFB
	if(!bDeadVehicle && Seats[SeatIndex].CameraTag != 'None')
	{
		Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].CameraTag, CamStart);
		HitActor = Trace(HitLocation, HitNormal, CamStart, Location, false, vect(12.0000000, 12.0000000, 12.0000000));
		// End:0xF8
		if(HitActor != none)
		{
			CamStart = HitLocation;
		}		
	}
	else
	{
		CamStart = Location;
	}
	Offset = TargetOfInterestEvalSeatOffset(SeatIndex);
	CamStart += (Offset >> Rotation);
	return CamStart;
	//return ReturnValue;	
}

simulated function int GetDriverTeamNum()
{
	local HaloPawn P;

	P = HaloPawn(Driver);
	// End:0x4C
	if(P != none)
	{
		return int(P.TeamNum);
	}
	return int(Team);
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	return NeedleTargetComponent;
	//return ReturnValue;	
}

simulated function TickNeedleTargetComponent(float DeltaTime)
{
	// End:0x6A
	if(NeedleTargetComponent != none)
	{
		// End:0x4B
		if(int(Role) == int(ROLE_Authority))
		{
			NeedleTargetComponent.Tick(DeltaTime);
		}
		NeedleTargetComponent.UpdateStickyAttachments();
	}
	//return;	
}

function ApplyNormalVariables()
{
	local editinline SVehicleSimCar SimCar;

	SimCar = SVehicleSimCar(SimObj);
	// End:0x174
	if((SimCar != none) && NormalHandlingVariables.ApplyChanges)
	{
		SimCar.EngineBrakeFactor = NormalHandlingVariables.EngineBrakeFactor;
		SimCar.WheelLatExtremumSlip = NormalHandlingVariables.WheelLatExtremumSlip;
		SimCar.WheelLatExtremumValue = NormalHandlingVariables.WheelLatExtremumValue;
		SimCar.WheelLatAsymptoteSlip = NormalHandlingVariables.WheelLatAsymptoteSlip;
		SimCar.WheelLatAsymptoteValue = NormalHandlingVariables.WheelLatAsymptoteValue;
	}
	//return;	
}

function ApplyBrakingVariables()
{
	local editinline SVehicleSimCar SimCar;

	SimCar = SVehicleSimCar(SimObj);
	// End:0x174
	if((SimCar != none) && BrakingHandlingVariables.ApplyChanges)
	{
		SimCar.EngineBrakeFactor = BrakingHandlingVariables.EngineBrakeFactor;
		SimCar.WheelLatExtremumSlip = BrakingHandlingVariables.WheelLatExtremumSlip;
		SimCar.WheelLatExtremumValue = BrakingHandlingVariables.WheelLatExtremumValue;
		SimCar.WheelLatAsymptoteSlip = BrakingHandlingVariables.WheelLatAsymptoteSlip;
		SimCar.WheelLatAsymptoteValue = BrakingHandlingVariables.WheelLatAsymptoteValue;
	}
	//return;	
}

function ApplyPowerslideVariables()
{
	local editinline SVehicleSimCar SimCar;

	SimCar = SVehicleSimCar(SimObj);
	// End:0x174
	if((SimCar != none) && BrakingHandlingVariables.ApplyChanges)
	{
		SimCar.EngineBrakeFactor = PowerSlideHandlingVariables.EngineBrakeFactor;
		SimCar.WheelLatExtremumSlip = PowerSlideHandlingVariables.WheelLatExtremumSlip;
		SimCar.WheelLatExtremumValue = PowerSlideHandlingVariables.WheelLatExtremumValue;
		SimCar.WheelLatAsymptoteSlip = PowerSlideHandlingVariables.WheelLatAsymptoteSlip;
		SimCar.WheelLatAsymptoteValue = PowerSlideHandlingVariables.WheelLatAsymptoteValue;
	}
	//return;	
}

state HighwayMode
{
	ignores TakeDamage, PassengerLeave, BeginState;

	simulated function bool CanEnterVehicle(Pawn P)
	{
		return ((((((!bDeleteMe && AnySeatAvailable()) && !bAttachDriver || !P.bIsCrouched) && P.DrivenVehicle == none) && P.Controller != none) && P.Controller.bIsPlayer) && !P.IsA('Vehicle')) && Health > 0;
		//return ReturnValue;		
	}

	event bool DriverLeave(bool bForceLeave)
	{
		return false;
		//return ReturnValue;		
	}

	function bool PassengerEnter(Pawn aPawn, int SeatIndex)
	{
		local bool B;
		local Vector EntryLoc, toSocketVec;
		local Rotator EntryRot;

		// End:0x12F
		if(((SeatIndex < Seats.Length) && (GetFirstEntryPoint(SeatIndex)) != -1) && SeatAvailable(SeatIndex))
		{
			Mesh.GetSocketWorldLocationAndRotation(EntryPoints[GetFirstEntryPoint(SeatIndex)].SocketName, EntryLoc, EntryRot);
			toSocketVec = EntryLoc - Location;
			aPawn.SetLocation(EntryLoc + (Normal(toSocketVec) * EntryPoints[GetFirstEntryPoint(SeatIndex)].Radius));
		}
		B = super(HaloVehicle).PassengerEnter(aPawn, SeatIndex);
		return B;
		//return ReturnValue;		
	}
	stop;	
}

defaultproperties
{
	PawnType=PPT_Warthog
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloVehicle.BlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokSpawnerComponent'
	begin object name="BlokSpawnerComponent" class=MegaHaloGame.HaloCollectibleBlokSpawnerComponent
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=5,MaxTotalValue=10)
	end object
	BlokSpawner=BlokSpawnerComponent
	AkPitchType="Thrust"
	AKMaxPitch=100
	SkidLoopEnabled=true
	EnginePitchEnabled=true
	bAutoBrakeEnabled=true
	KidFriendlyControls=true
	AkBreakTiny=10
	AkBreakSmall=25
	AkBreakMedium=40
	AkBreakLarge=60
	AkBreakMega=100
	PreviousMaterial="Unknown"
	AverageAccel[0]=0.0000000
	AverageAccel[1]=0.0000000
	AverageAccel[2]=0.0000000
	AverageAccel[3]=0.0000000
	AverageAccel[4]=0.0000000
	AverageAccel[5]=0.0000000
	AverageAccel[6]=0.0000000
	AverageAccel[7]=0.0000000
	AverageAccel[8]=0.0000000
	AverageAccel[9]=0.0000000
	AccelerationStartSkidLimit=14.0000000
	AccelerationStopSkidLimit=7.0000000
	MaxHornDuration=5.0000000
	HornCooldownDuration=10.0000000
	HeavyCrashLimit=2500.0000000
	MediumCrashLimit=1250.0000000
	LightCrashLimit=250.0000000
	SuspensionContractEvent=AkEvent'Vehicles.Play_Suspension_Contract'
	SuspensionExpandEvent=AkEvent'Vehicles.Play_Suspension_Expand'
	EnterVehicleEvent=AkEvent'Vehicles.Play_Enter_Vehicle'
	ExitVehicleEvent=AkEvent'Vehicles.Play_Exit_Vehicle'
	VehicleGears[0]=(MinPercent=0.0000000,MaxPercent=100.0000000,GearRatio=(Points=((InVal=0.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear),(InVal=4000.0000000,OutVal=100.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear)),InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents))
	MaxRPMChangeRatePerSecond=50.0000000
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloVehicle.CrashWaveform1'
	begin object name="CrashWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=80,RightAmplitude=80,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	CrashWaveform=CrashWaveform1
	EngineIdleForceFeedback=20.0000000
	EngineRunningForceFeedback=50.0000000
	MinForwardVelToDrift=20.0000000
	MinLatSlipToBeDrifting=0.1000000
	BoostAmount=100.0000000
	MaxBoostDuration=10.0000000
	BoostChargeTime=5.0000000
	BoostChargeDelay=1.0000000
	RocketGroundSpeed=3000.0000000
	RocketAirSpeed=3000.0000000
	BoostFeedbackMagnitude=40.0000000
	LookdownPitch=6.0000000
	LookdownPitchBuffer=20.0000000
	LookupPitchBuffer=10.0000000
	TargetOfInterest=(Target=none,YawBuffer=20.0000000,ElapsedTime=0.0000000,BlendInTime=0.0000000,BlendViewTime=0.0000000,BlendOutTime=0.0000000,BlendPct=0.0000000,SeatOffsetAdjustment=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0))
	XSensitivity=1.5000000
	CameraLookSteerXSensitivity=0.7500000
	CameraLookSteerYSensitivity=1.0000000
	CameraIdleInterpRate=1.5000000
	CameraSteerInterpRate=1.7500000
	SeatPawnClass=Class'MegaHaloGame.HaloWeaponPawn'
	AutoAimDistance=30000.0000000
	DriveVehicleMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Drive Vehicle"
	RideInVehicleMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Ride In Vehicle"
	ManTurretMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Operate Turret"
	FlipVehicleMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Flip Vehicle"
	AISeatIndexOrder[0]=0
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloVehicle.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent" class=MegaHaloGame.HaloTargetableComponent_Vehicle
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloVehicle.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	begin object name="NeedleTarget" class=MegaHaloGame.HaloNeedleTargetComponent
	end object
	NeedleTargetComponent=NeedleTarget
	bUsingLookSteer=true
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTVehicle.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	HornSounds[0]=none
	RanOverDamageType=Class'MegaHaloGame.HaloDamageType_RanOver'
	BurnOutTime=0.1000000
	Team=1
	bDisableDriverlessReset=true
	VehicleSounds[0]=(SoundStartTag="None",SoundEndTag="None",SoundTemplate=none,SoundRef=none)
	WaterEffectType="PM_Water"
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloVehicle.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UTGame.Default__UTVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloVehicle.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UTGame.Default__UTVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloVehicle.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UTGame.Default__UTVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	MaxSpeed=3000.0000000
	SquealThreshold=0.1000000
	SquealLatThreshold=0.0200000
	LatAngleVolumeMult=5.0000000
	EngineStartOffsetSecs=0.0000000
	EngineStopOffsetSecs=0.0000000
	ExitRadius=100.0000000
	CrushedDamageType=Class'MegaHaloGame.HaloDamageType_Crushed'
	GroundSpeed=1500.0000000
	AirSpeed=1500.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicle.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicle.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=BlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloVehicle.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		BaseThreatVal=5000
	end object
	Components[5]=targetableComponent
	Components[6]=MyHaloTargetableComponent
	Components[7]=NeedleTarget
	CollisionComponent=SVehicleMesh
}