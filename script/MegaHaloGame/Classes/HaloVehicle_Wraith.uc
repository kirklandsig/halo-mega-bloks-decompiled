class HaloVehicle_Wraith extends HaloVehicle
	abstract
	config(GwNavEngine);

enum BankDirection
{
	BankLeft,                       // 0
	BankForward,                    // 1
	BankRight,                      // 2
	BankDirection_MAX               // 3
};

var float JumpForceMag;
var float MaxJumpZVel;
var float JumpCheckTraceDist;
var float JumpDelay;
var float LastJumpTime;
var float DuckForceMag;
var repnotify bool bDoBikeJump;
var repnotify bool bHoldingDuck;
var bool bPressingAltFire;
var bool bWasThrottle;
var bool bTossRotValid;
var SoundCue JumpSound;
var SoundCue DuckSound;
var float BladeBlur;
var float DesiredBladeBlur;
var int FanEffectIndex;
var name FanEffectParameterName;
var name FlameJetEffectParameterName;
var float FlameJetValue;
var float DesiredFlameJetValue;
var protected float FullWheelSuspensionTravel;
var protected float CrouchedWheelSuspensionTravel;
var protected float SuspensionTravelAdjustSpeed;
var protected float FullWheelSuspensionStiffness;
var protected float CrouchedWheelSuspensionStiffness;
var protected float BoneOffsetZAdjust;
var float BoosterFOVAngle;
var UTAnimBlendByWeapon BoosterBlend;
var float BoosterForceMagnitude;
var float BoosterCheckRadius;
var float BoostChargeDuration;
var float BoostReleaseTime;
var float BoostReleaseDelay;
var float ThrottleStartTime;
var float BoostUprightTorqueFactor;
var float BoostUprightMaxTorque;
var float DefaultUprightTorqueFactor;
var float DefaultUprightMaxTorque;
var float LockSuspensionTravel;
var float LockSuspensionStiffness;
var float BoostSteerFactors[3];
var float BoostTurnTorque;
var float NonBoostTurnTorque;
var float ReverseSpeedPercentage;
var AkEvent PlayBankLeftEvent;
var AkEvent PlayBankRightEvent;
var AkEvent StopBankLeftEvent;
var AkEvent StopBankRightEvent;
var float BankSteeringLimit;
var array<name> TurretControls;
var editinline array<editinline UDKSkelControl_TurretConstrained> TurretControllers;
var Rotator TurretRotation;
var Rotator CurrentSuggestedTossRot;
var Vector CurrentSuggestedTossVel;
var HaloVehicle_Wraith.BankDirection LastBankDirection;

replication
{
	// Pos:0x000
	if((!bNetOwner || bDemoRecording) && int(Role) == int(ROLE_Authority))
		bDoBikeJump, bHoldingDuck;
}

simulated function PlayBankLeftSound()
{
	// End:0x28
	if(PlayBankLeftEvent != none)
	{
		PlayAkEvent(PlayBankLeftEvent);
	}
	//return;	
}

simulated function PlayBankRightSound()
{
	// End:0x28
	if(PlayBankRightEvent != none)
	{
		PlayAkEvent(PlayBankRightEvent);
	}
	//return;	
}

simulated function StopBankLeftSound()
{
	// End:0x28
	if(StopBankLeftEvent != none)
	{
		PlayAkEvent(StopBankLeftEvent);
	}
	//return;	
}

simulated function StopBankRightSound()
{
	// End:0x28
	if(StopBankRightEvent != none)
	{
		PlayAkEvent(StopBankRightEvent);
	}
	//return;	
}

simulated function GetRotation(out Rotator CameraRotation)
{
	//return;	
}

simulated function GetPlayerInput(out PlayerInput Player, optional bool Accel = false, optional bool Brake = false, optional bool Strafe = false)
{
	// End:0x170
	if(Player.bUsingGamepad)
	{
		// End:0x65
		if(Strafe)
		{
			Player.aTurn = 0.0000000;			
		}
		else
		{
			Player.aTurn = Player.aStrafe;
			Player.aStrafe = 0.0000000;
		}
		Player.aLookUp = -Player.aBaseY * 0.3000000;
		// End:0x170
		if(Player.bInvertMouse == true)
		{
			Player.aLookUp = -Player.aLookUp;
		}
	}
	//return;	
}

simulated function bool CanBeBaseForPawn(Pawn aPawn)
{
	return bCanBeBaseForPawns && !bDriving;
	//return ReturnValue;	
}

function bool DriverEnter(Pawn P)
{
	// End:0x18
	if(super.DriverEnter(P))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool OverrideBeginFire(byte FireModeNum)
{
	// End:0x22
	if(int(FireModeNum) == int(1))
	{
		bPressingAltFire = true;
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool OverrideEndFire(byte FireModeNum)
{
	// End:0x22
	if(int(FireModeNum) == int(1))
	{
		bPressingAltFire = false;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super(UTVehicle).PossessedBy(C, bVehicleTransition);
	bHoldingDuck = false;
	LastJumpTime = 0.0000000;
	bDoBikeJump = false;
	bPressingAltFire = false;
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x3E
	if(VarName == 'bBoostersActivated')
	{
		// End:0x31
		if(bBoostersActivated)
		{
			ActivateRocketBoosters();			
		}
		else
		{
			DeactivateRocketBoosters();
		}		
	}
	else
	{
		super(UTVehicle).ReplicatedEvent(VarName);
	}
	//return;	
}

simulated event EnableFullSteering()
{
	local editinline SVehicleSimCar SimCar;

	bSteeringLimited = false;
	SimCar = SVehicleSimCar(SimObj);
	SimCar.MaxSteerAngleCurve.Points[0].OutVal = SVehicleSimCar(default.SimObj).MaxSteerAngleCurve.Points[0].OutVal;
	SimCar.MaxSteerAngleCurve.Points[1].OutVal = SVehicleSimCar(default.SimObj).MaxSteerAngleCurve.Points[1].OutVal;
	SimCar.MaxSteerAngleCurve.Points[2].OutVal = SVehicleSimCar(default.SimObj).MaxSteerAngleCurve.Points[2].OutVal;
	//return;	
}

simulated function LockWheels()
{
	local editinline SVehicleSimCar SimCar;

	bSteeringLimited = true;
	SimCar = SVehicleSimCar(SimObj);
	Wheels[0].SuspensionTravel = LockSuspensionTravel;
	Wheels[1].SuspensionTravel = LockSuspensionTravel;
	SimCar.WheelSuspensionStiffness = LockSuspensionStiffness;
	SimCar.MaxSteerAngleCurve.Points[0].OutVal = BoostSteerFactors[0];
	SimCar.MaxSteerAngleCurve.Points[1].OutVal = BoostSteerFactors[1];
	SimCar.MaxSteerAngleCurve.Points[2].OutVal = BoostSteerFactors[2];
	//return;	
}

simulated function UnlockWheels()
{
	local editinline SVehicleSimCar SimCar;

	bSteeringLimited = false;
	SimCar = SVehicleSimCar(SimObj);
	Wheels[0].SuspensionTravel = default.Wheels[0].SuspensionTravel;
	Wheels[1].SuspensionTravel = default.Wheels[1].SuspensionTravel;
	SimCar.WheelSuspensionStiffness = SVehicleSimCar(default.SimObj).WheelSuspensionStiffness;
	//return;	
}

simulated function MantaJumpEffect()
{
	//return;	
}

simulated function MantaDuckEffect()
{
	//return;	
}

simulated function InitializeTurrets()
{
	local int I;
	local UTSkelControl_TurretConstrained Turret;

	I = 0;
	J0x0B:

	// End:0xD3 [Loop If]
	if(I < TurretControls.Length)
	{
		Turret = UTSkelControl_TurretConstrained(Mesh.FindSkelControl(TurretControls[I]));
		// End:0xC5
		if(Turret != none)
		{
			TurretControllers[I] = Turret;
			Turret.InitTurret(Rotation, Mesh);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	TurretRotation = Rotation;
	//return;	
}

function byte ChooseFireMode()
{
	local UTBot B;

	B = UTBot(Controller);
	// End:0x1B2
	if((((((((B != none) && B.Skill > (1.7000000 + FRand())) && Pawn(Controller.Focus) != none) && Vehicle(Controller.Focus) == none) && Controller.MoveTarget == Controller.Focus) && Controller.InLatentExecution(Controller.503)) && VSize(Controller.GetFocalPoint() - Location) < float(800)) && Controller.LineOfSightTo(Controller.Focus))
	{
		return 1;
	}
	return 0;
	//return ReturnValue;	
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
	Rise = 1.0000000;
	return true;
	//return ReturnValue;	
}

function IncomingMissile(Projectile P)
{
	local UTBot B;

	B = UTBot(Controller);
	// End:0xC0
	if(((B != none) && B.Skill > (4.0000000 + (4.0000000 * FRand()))) && VSize(P.Location - Location) < VSize(P.Velocity))
	{
		DriverLeave(false);		
	}
	else
	{
		super(UTVehicle).IncomingMissile(P);
	}
	//return;	
}

simulated function DrivingStatusChanged()
{
	bPressingAltFire = false;
	super.DrivingStatusChanged();
	//return;	
}

simulated function float GetChargePower()
{
	return FClamp(WorldInfo.TimeSeconds - LastJumpTime, 0.0000000, JumpDelay) / JumpDelay;
	//return ReturnValue;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
	// End:0x82
	if(Abs(RigidCollisionData.ContactInfos[0].ContactNormal.Z) < WalkableFloorZ)
	{
		super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	}
	//return;	
}

simulated function bool ShouldClamp()
{
	return false;
	//return ReturnValue;	
}

function bool TooCloseToAttack(Actor Other)
{
	local float OtherRadius, OtherHeight;

	// End:0x37
	if((Pawn(Other) != none) && Vehicle(Other) == none)
	{
		return false;		
	}
	else
	{
		// End:0x52
		if(super(UTVehicle).TooCloseToAttack(Other))
		{
			return true;			
		}
		else
		{
			Other.GetBoundingCylinder(OtherRadius, OtherHeight);
			return VSize2D(Other.Location - Location) < ((OtherRadius + CylinderComponent.CollisionRadius) + 150.0000000);
		}
	}
	//return ReturnValue;	
}

function bool RecommendCharge(UTBot B, Pawn Enemy)
{
	// End:0x2C
	if(B.Skill < (float(1) + FRand()))
	{
		return false;
	}
	// End:0x82
	if(Vehicle(Enemy) == none)
	{
		return VSize(Location - Enemy.Location) < (1000.0000000 + (3000.0000000 * FRand()));
	}
	return false;
	//return ReturnValue;	
}

simulated function StopVehicleSounds()
{
	switch(LastBankDirection)
	{
		// End:0x25
		case 0:
			StopBankLeftSound();
			// End:0x3A
			break;
		// End:0x34
		case 2:
			StopBankRightSound();
		// End:0xFFFF
		default:
			// End:0x3A
			break;
			break;
	}
	LastBankDirection = 1;
	super.StopVehicleSounds();
	//return;	
}

simulated function ChangeSteeringRadius(bool BoostOn)
{
	local editinline UDKVehicleSimHover Hovermobile;

	Hovermobile = UDKVehicleSimHover(SimObj);
	// End:0x8B
	if(Hovermobile != none)
	{
		// End:0x63
		if(BoostOn)
		{
			Hovermobile.TurnTorqueFactor = BoostTurnTorque;			
		}
		else
		{
			Hovermobile.TurnTorqueFactor = NonBoostTurnTorque;
		}
	}
	//return;	
}

simulated function float GetCurrentPitch()
{
	local float Pitch;
	local InterpCurveFloat Gear;

	// End:0x68
	if(bVehicleOnGround)
	{
		Gear = VehicleGears[CurrentGear].GearRatio;
		Pitch = EvalInterpCurveFloat(Gear, Abs(ForwardVel));		
	}
	else
	{
		Pitch = Abs(ForwardVel);
	}
	return Pitch;
	//return ReturnValue;	
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
	// End:0x4D
	if((!bBoostersActivated && ForwardVel < 0.0000000) && InForward < 0.0000000)
	{
		InForward *= ReverseSpeedPercentage;
	}
	super.SetInputs(InForward, InStrafe, InUp);
	//return;	
}

function Rotator GetWeaponAim(UTVehicleWeapon VWeapon)
{
	local Rotator barrelRot;
	local Vector barrelLoc;
	local int SeatIndex;

	// End:0x24
	if(CCSController(Controller) != none)
	{
		return FindBestAutoAimTargetRotation(0);
	}
	SeatIndex = 0;
	J0x2F:

	// End:0x119 [Loop If]
	if(SeatIndex < Seats.Length)
	{
		// End:0x10B
		if((Seats[SeatIndex].GunClass != none) && VWeapon.IsA(Seats[SeatIndex].GunClass.Name))
		{
			// End:0x101
			if(!bTossRotValid)
			{
				GetBarrelLocationAndRotation(SeatIndex, barrelLoc, barrelRot);				
			}
			else
			{
				return CurrentSuggestedTossRot;
			}
		}
		SeatIndex++;
		// [Loop Continue]
		goto J0x2F;
	}
	return barrelRot;
	//return ReturnValue;	
}

simulated function Tick(float DeltaSeconds)
{
	local int I;
	local HaloPlayerPawnController HPC;
	local CCSController AIController;
	local Rotator AutoAimRotator;

	// End:0x261
	if(bDriving)
	{
		switch(LastBankDirection)
		{
			// End:0x55
			case 0:
				// End:0x52
				if(OutputSteering < BankSteeringLimit)
				{
					LastBankDirection = 1;
					StopBankLeftSound();
				}
				// End:0xF1
				break;
			// End:0x8C
			case 2:
				// End:0x89
				if(OutputSteering > -BankSteeringLimit)
				{
					LastBankDirection = 1;
					StopBankRightSound();
				}
				// End:0xF1
				break;
			// End:0xFFFF
			default:
				// End:0xBF
				if(OutputSteering >= BankSteeringLimit)
				{
					LastBankDirection = 0;
					PlayBankLeftSound();					
				}
				else
				{
					// End:0xEE
					if(OutputSteering <= -BankSteeringLimit)
					{
						LastBankDirection = 2;
						PlayBankRightSound();
					}
				}
				// End:0xF1
				break;
				break;
		}
		// End:0x261
		if(Controller != none)
		{
			HPC = HaloPlayerPawnController(Controller);
			// End:0x1A5
			if(HPC != none)
			{
				TurretRotation = Instigator.GetViewRotation();
				AutoAimRotator = FindBestAutoAimTargetRotation(0);
				TurretRotation.Pitch = AutoAimRotator.Pitch;				
			}
			else
			{
				AIController = CCSController(Controller);
				// End:0x1E5
				if(AIController != none)
				{
					TurretRotation = FindBestAutoAimTargetRotation(0);
				}
			}
			I = 0;
			J0x1F0:

			// End:0x261 [Loop If]
			if(I < TurretControllers.Length)
			{
				// End:0x253
				if(TurretControllers[I] != none)
				{
					TurretControllers[I].DesiredBoneRotation = TurretRotation;
				}
				I++;
				// [Loop Continue]
				goto J0x1F0;
			}
		}
	}
	super.Tick(DeltaSeconds);
	//return;	
}

event ExecuteVehicleCommand(GwNavVehicle.EHaloVehicleCommand Cmd)
{
	switch(Cmd)
	{
		// End:0x25
		case 0:
			ActivateRocketBoosters();
			// End:0x62
			break;
		// End:0x37
		case 1:
			DeactivateRocketBoosters();
			// End:0x62
			break;
		// End:0x4B
		case 2:
			StartFire(0);
			// End:0x62
			break;
		// End:0x5F
		case 3:
			StopFire(0);
			// End:0x62
			break;
		// End:0xFFFF
		default:
			break;
	}
	super(GwNavVehicle).ExecuteVehicleCommand(Cmd);
	//return;	
}

defaultproperties
{
	JumpCheckTraceDist=175.0000000
	JumpDelay=3.0000000
	FullWheelSuspensionTravel=145.0000000
	CrouchedWheelSuspensionTravel=100.0000000
	SuspensionTravelAdjustSpeed=100.0000000
	FullWheelSuspensionStiffness=20.0000000
	CrouchedWheelSuspensionStiffness=20.0000000
	BoneOffsetZAdjust=45.0000000
	BoostTurnTorque=2500.0000000
	NonBoostTurnTorque=5000.0000000
	ReverseSpeedPercentage=0.6000000
	BankSteeringLimit=0.1500000
	TurretControls[0]="BigGunController"
	LastBankDirection=BankDirection.BankForward
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloVehicle_Wraith.BlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloVehicle.BlokSpawnerComponent'
	begin object name="BlokSpawnerComponent"
	end object
	BlokSpawner=BlokSpawnerComponent
	EntryPoints[0]=(Radius=500.0000000,SocketName="EntryPoint_R",ToolTipCoords=(U=96.0000000,V=249.0000000,UL=77.0000000,VL=64.0000000),EnterPawnAnimName="None",ExitPawnAnimName="None",SeatIndex=0)
	EntryPoints[1]=(Radius=500.0000000,SocketName="EntryPoint_L",ToolTipCoords=(U=96.0000000,V=249.0000000,UL=77.0000000,VL=64.0000000),EnterPawnAnimName="None",ExitPawnAnimName="None",SeatIndex=0)
	AkVehicleType="COV_Ghost"
	AkObjectType="VEH_Ghost"
	SkidLoopEnabled=false
	CanBoost=true
	BoostFeedbackEnabled=true
	bAutoBrakeEnabled=false
	EngineBone="Ghost_Windshield"
	ExhaustBone="Ghost_Tail_Bottom"
	VehicleGears[0]=(MinPercent=0.0000000,MaxPercent=100.0000000,GearRatio=(Points=((InVal=0.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=EInterpCurveMode.CIM_Linear),(InVal=2400.0000000,OutVal=100.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=EInterpCurveMode.CIM_Linear)),InterpMethod=EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents))
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloVehicle_Wraith.CrashWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloVehicle.CrashWaveform1'
	begin object name="CrashWaveform1"
	end object
	CrashWaveform=CrashWaveform1
	MaxBoostDuration=14.0000000
	BoostChargeTime=3.0000000
	BoostChargeDelay=1.5000000
	RocketGroundSpeed=3500.0000000
	RocketAirSpeed=3500.0000000
	LookdownPitch=4096.0000000
	CameraSteerInterpRate=20.0000000
	AutoAimAnglePitchMax=45.0000000
	AutoAimAnglePitchMin=-9.0000000
	AutoAimAngleYawDiff=30.0000000
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloVehicle_Wraith.MyHaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloVehicle.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent"
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloVehicle_Wraith.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloVehicle.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	bRagdollDriverOnDarkwalkerHorn=true
	bNoZSmoothing=false
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle_Wraith.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	MaxDesireability=0.6000000
	DamageSmokeThreshold=0.5000000
	SpawnRadius=125.0000000
	CollisionDamageMult=0.0001000
	DefaultFOV=90.0000000
	CameraLag=0.0200000
	bEjectKilledBodies=true
	bHomingTarget=true
	bTakeWaterDamageWhileDriving=false
	MaxGroundEffectDist=256.0000000
	GroundEffectDistParameterName="DistToGround"
	CustomGravityScaling=0.8000000
	ObjectiveGetOutDist=750.0000000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloVehicle_Wraith.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	bLookSteerOnAllPlatforms=true
	// Reference: UDKVehicleSimHover'MegaHaloGame.Default__HaloVehicle_Wraith.SimObject'
	begin object name="SimObject" class=UDKBase.UDKVehicleSimHover
	end object
	SimObj=SimObject
	// Reference: HaloVehicleWraithWheel'MegaHaloGame.Default__HaloVehicle_Wraith.BRThruster'
	begin object name="BRThruster" class=MegaHaloGame.HaloVehicleWraithWheel
	end object
	Wheels[0]=BRThruster
	// Reference: HaloVehicleWraithWheel'MegaHaloGame.Default__HaloVehicle_Wraith.BLThruster'
	begin object name="BLThruster" class=MegaHaloGame.HaloVehicleWraithWheel
	end object
	Wheels[1]=BLThruster
	// Reference: HaloVehicleWraithWheel'MegaHaloGame.Default__HaloVehicle_Wraith.FLThruster'
	begin object name="FLThruster" class=MegaHaloGame.HaloVehicleWraithWheel
	end object
	Wheels[2]=FLThruster
	// Reference: HaloVehicleWraithWheel'MegaHaloGame.Default__HaloVehicle_Wraith.FRThruster'
	begin object name="FRThruster" class=MegaHaloGame.HaloVehicleWraithWheel
	end object
	Wheels[3]=FRThruster
	bStayUpright=true
	bCanFlip=true
	StayUprightRollResistAngle=5.0000000
	StayUprightPitchResistAngle=5.0000000
	StayUprightStiffness=450.0000000
	StayUprightDamping=20.0000000
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloVehicle_Wraith.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'MegaHaloGame.Default__HaloVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloVehicle_Wraith.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'MegaHaloGame.Default__HaloVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	MaxSpeed=3500.0000000
	UprightLiftStrength=30.0000000
	UprightTorqueStrength=30.0000000
	bDriverIsVisible=true
	bTurnInPlace=true
	bSeparateTurretFocus=true
	bFollowLookDir=true
	bScriptedRise=true
	ExitRadius=160.0000000
	MomentumMult=1.5000000
	bCanStrafe=true
	MeleeRange=-100.0000000
	GroundSpeed=2500.0000000
	AirSpeed=2500.0000000
	Health=500
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicle_Wraith.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle_Wraith.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicle_Wraith.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	ViewPitchMin=-4096.0000000
	ViewPitchMax=-4096.0000000
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=BlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloVehicle_Wraith.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloVehicle.targetableComponent'
	begin object name="targetableComponent"
	end object
	Components[5]=targetableComponent
	Components[6]=MyHaloTargetableComponent
	Components[7]=NeedleTarget
	Components[8]=SimObject
	CollisionComponent=SVehicleMesh
}