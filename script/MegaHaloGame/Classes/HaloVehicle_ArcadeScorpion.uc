class HaloVehicle_ArcadeScorpion extends HaloVehicle
	abstract
	config(GwNavEngine);

var UTAnimBlendByWeapon BladeBlend;
var bool bBrakeLightOn;
var bool bReverseLightOn;
var bool bHeadlightsOn;
var repnotify bool bBladesExtended;
var repnotify bool bLeftBladeBroken;
var repnotify bool bRightBladeBroken;
var bool bScriptedBoosters;
var repnotify bool bSelfDestructArmed;
var bool bWasThrottle;
var bool bAISelfDestruct;
var bool bInstantBrakeEnabled;
var float BladeBreakPoint;
var name BrakeLightParameterName;
var name ReverseLightParameterName;
var name HeadLightParameterName;
var name RightBladeStartSocket;
var name RightBladeEndSocket;
var name LeftBladeStartSocket;
var name LeftBladeEndSocket;
var Class<DamageType> BladeDamageType;
var SoundCue BladeBreakSound;
var SoundCue BladeExtendSound;
var SoundCue BladeRetractSound;
var float BoosterForceMagnitude;
var Controller SelfDestructInstigator;
var float BoosterCheckRadius;
var float BoostChargeDuration;
var TextureCoordinates BoostToolTipIconCoords;
var TextureCoordinates EjectToolTipIconCoords;
var Class<UTDamageType> SelfDestructDamageType;
var float BoostReleaseTime;
var float BoostReleaseDelay;
var CameraAnim RedBoostCamAnim;
var CameraAnim BlueBoostCamAnim;
var float BoosterFOVAngle;
var UTAnimBlendByWeapon BoosterBlend;
var float ThrottleStartTime;
var float BoostUprightTorqueFactor;
var float BoostUprightMaxTorque;
var float DefaultUprightTorqueFactor;
var float DefaultUprightMaxTorque;
var export editinline PointLightComponent LeftBoosterLight;
var export editinline PointLightComponent RightBoosterLight;
var RB_ConstraintActor BladeVictimConstraint[2];
var StaticMesh ScorpionHood;
var float SelfDestructSpeedSquared;
var float LockSuspensionTravel;
var float LockSuspensionStiffness;
var float BoostSteerFactors[3];
var ParticleSystem SelfDestructExplosionTemplate;
var Class<UTGib> HatchGibClass;
var StaticMesh BrokenBladeMesh;
var float LastBladeBoostTime;
var array<name> TurretControls;
var editinline array<editinline UDKSkelControl_TurretConstrained> TurretControllers;
var Rotator TurretRotation;
var float TurretInterpRate;
var float WheelSteerSensitivity;
var float MaxWheelSteerAngle;
var float WheelSteeringMultiplier;
var float WheelRollMultiplier;
var float WheelSteeringShakeAmplitude;
var float WheelRollShakeAmplitude;
var AkEvent BrakeHitEvent;
var AkEvent BrakeReleaseEvent;
var MaterialInstanceConstant LeftTreadMaterial;
var MaterialInstanceConstant RightTreadMaterial;

replication
{
	// Pos:0x000
	if(bNetDirty)
		bBladesExtended, bLeftBladeBroken, 
		bRightBladeBroken, bSelfDestructArmed;
}

function bool ReadyToSelfDestruct()
{
	return bBoostersActivated && VSizeSq(Velocity) > SelfDestructSpeedSquared;
	//return ReturnValue;	
}

simulated function PostBeginPlay()
{
	local int I;

	super.PostBeginPlay();
	SetTimer(0.0010000, false, 'SetPostBeginWheelParameters', self);
	// End:0x4A
	if(SimObj.bAutoDrive)
	{
		SetDriving(true);
	}
	// End:0xC6
	if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bDeleteMe) && DamageMaterialInstance[0] != none)
	{
		DamageMaterialInstance[0].SetScalarParameterValue('Green_Glows_Headlights', 0.0000000);
	}
	BladeBlend = UTAnimBlendByWeapon(Mesh.Animations.FindAnimNode('BladeNode'));
	BoosterBlend = UTAnimBlendByWeapon(Mesh.Animations.FindAnimNode('BoosterNode'));
	I = 0;
	J0x171:

	// End:0x27F [Loop If]
	if(I < Mesh.GetNumElements())
	{
		// End:0x209
		if(Mesh.GetMaterial(I) == MaterialInstanceConstant'Scorpion.Materials.MIC.MI_UNSC_ScorpionTreads_L_Mat')
		{
			LeftTreadMaterial = Mesh.CreateAndSetMaterialInstanceConstant(I);			
		}
		else
		{
			// End:0x271
			if(Mesh.GetMaterial(I) == MaterialInstanceConstant'Scorpion.Materials.MIC.MI_UNSC_ScorpionTreads_R_Mat')
			{
				RightTreadMaterial = Mesh.CreateAndSetMaterialInstanceConstant(I);
			}
		}
		I++;
		// [Loop Continue]
		goto J0x171;
	}
	//return;	
}

simulated function SetPostBeginWheelParameters()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xB1 [Loop If]
	if(I < Wheels.Length)
	{
		Wheels[I].WheelControl.bShouldTickOwner = true;
		Wheels[I].WheelControl.bAddRotation = false;
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

event RanInto(Actor Other)
{
	local float BoostRemaining;

	// End:0x115
	if(((bBoostersActivated && !bAISelfDestruct) && Other == Controller.Enemy) && UTBot(Controller) != none)
	{
		DeactivateRocketBoosters();
		bBoostersActivated = false;
		BoostRemaining = (MaxBoostDuration - WorldInfo.TimeSeconds) + BoostStartTime;
		BoostChargeTime = WorldInfo.TimeSeconds - FMin(BoostChargeDuration - 2.0000000, (BoostRemaining * BoostChargeDuration) / MaxBoostDuration);
	}
	super(UTVehicle).RanInto(Other);
	//return;	
}

function PancakeOther(Pawn Other)
{
	local float BoostRemaining;

	// End:0x115
	if(((bBoostersActivated && !bAISelfDestruct) && Other == Controller.Enemy) && UTBot(Controller) != none)
	{
		DeactivateRocketBoosters();
		bBoostersActivated = false;
		BoostRemaining = (MaxBoostDuration - WorldInfo.TimeSeconds) + BoostStartTime;
		BoostChargeTime = WorldInfo.TimeSeconds - FMin(BoostChargeDuration - 2.0000000, (BoostRemaining * BoostChargeDuration) / MaxBoostDuration);
	}
	super(UTVehicle).PancakeOther(Other);
	//return;	
}

simulated function bool CanBeBaseForPawn(Pawn aPawn)
{
	return bCanBeBaseForPawns && !bDriving;
	//return ReturnValue;	
}

function bool DriverEnter(Pawn P)
{
	// End:0x59
	if(super.DriverEnter(P))
	{
		// End:0x57
		if(HaloPawn(P) != none)
		{
			HaloPawn(P).EnterVehicle(0);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool PassengerEnter(Pawn aPawn, int SeatIndex)
{
	// End:0x6A
	if(super.PassengerEnter(aPawn, SeatIndex))
	{
		// End:0x68
		if(HaloPawn(aPawn) != none)
		{
			HaloPawn(aPawn).EnterVehicle(SeatIndex);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function StopVehicleSounds()
{
	super.StopVehicleSounds();
	//return;	
}

simulated event SuspensionHeavyShift(float Delta)
{
	// End:0x24
	if(Delta > float(0))
	{
		VehiclePlaySuspensionShiftSound(Delta);
	}
	//return;	
}

simulated function GetRotation(out Rotator CameraRotation)
{
	//return;	
}

simulated function GetPlayerInput(out PlayerInput Player, optional bool Accel = false, optional bool Brake = false, optional bool Strafe = false)
{
	// End:0x13C
	if(Player.bUsingGamepad)
	{
		Player.aTurn = Player.aStrafe;
		Player.aStrafe = 0.0000000;
		Player.aLookUp = -Player.aBaseY * 0.3000000;
		// End:0x13C
		if(Player.bInvertMouse == true)
		{
			Player.aLookUp = -Player.aLookUp;
		}
	}
	//return;	
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
	super.SetInputs(InForward, InStrafe, InUp);
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

simulated function DeactivateHandbrake()
{
	bOutputHandbrake = false;
	bHoldingDownHandbrake = false;
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

simulated function bool DisableVehicle()
{
	local bool bResult;

	bResult = super.DisableVehicle();
	// End:0x31
	if(SelfDestructInstigator != none)
	{
		SelfDestruct(none);
		return true;
	}
	return bResult;
	//return ReturnValue;	
}

simulated function BlowupVehicle()
{
	// End:0x23
	if(bBoostersActivated)
	{
		bBoostersActivated = false;
		DeactivateRocketBoosters();
	}
	super.BlowupVehicle();
	//return;	
}

event SelfDestruct(Actor ImpactedActor)
{
	Health = -100000;
	KillerController = SelfDestructInstigator;
	BlowupVehicle();
	// End:0x93
	if(ImpactedActor != none)
	{
		ImpactedActor.TakeDamage(600, SelfDestructInstigator, GetTargetLocation(), float(200000) * Normal(Velocity), SelfDestructDamageType,, self);
	}
	HurtRadius(600.0000000, 600.0000000, SelfDestructDamageType, 200000.0000000, GetTargetLocation(), ImpactedActor, SelfDestructInstigator);
	BoostStartTime = WorldInfo.TimeSeconds;
	//return;	
}

function bool TryToDrive(Pawn P)
{
	local Vector X, Y, Z;
	local bool bFreedSeat, bEnteredVehicle;
	local int SeatIndex;

	// End:0x0F
	if(bPlayingSpawnEffect)
	{
		return false;
	}
	// End:0x100
	if(((bIsInverted && bMustBeUpright) && !bVehicleOnGround) && VSize(Velocity) <= 5.0000000)
	{
		// End:0xFE
		if(bCanFlip)
		{
			bIsUprighting = true;
			UprightStartTime = WorldInfo.TimeSeconds;
			GetAxes(Rotation, X, Y, Z);
			bFlipRight = ((P.Location - Location) Dot Y) > float(0);
		}
		return false;
	}
	// End:0x134
	if(!CanEnterVehicle(P) || Vehicle(P) != none)
	{
		return false;
	}
	// End:0x34B
	if(!bIsDisabled && (((int(Team) == 128) || !bTeamLocked) || !WorldInfo.Game.bTeamGame) || WorldInfo.GRI.OnSameTeam(self, P))
	{
		// End:0x22D
		if(bEnteringUnlocks)
		{
			bTeamLocked = false;
			// End:0x22D
			if(ParentFactory != none)
			{
				ParentFactory.VehicleTaken();
			}
		}
		SeatIndex = CheckEntryRadii(P);
		// End:0x34B
		if(SeatIndex != -1)
		{
			// End:0x2DD
			if(!AnySeatAvailable())
			{
				// End:0x2CC
				if(WorldInfo.GRI.OnSameTeam(self, P))
				{
					bFreedSeat = KickOutBot(SeatIndex);
				}
				// End:0x2DD
				if(!bFreedSeat)
				{
					return false;
				}
			}
			bEnteredVehicle = ((SeatIndex == 0) ? DriverEnter(P) : PassengerEnter(P, SeatIndex));
			// End:0x340
			if(bEnteredVehicle)
			{
				SetTexturesToBeResident(true);
			}
			return bEnteredVehicle;
		}
	}
	VehicleLocked(P);
	return false;
	//return ReturnValue;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x2E
	if(VarName == 'bBladesExtended')
	{
		SetBladesExtended(bBladesExtended);		
	}
	else
	{
		// End:0x53
		if(VarName == 'bLeftBladeBroken')
		{
			BreakOffBlade(true);			
		}
		else
		{
			// End:0x78
			if(VarName == 'bRightBladeBroken')
			{
				BreakOffBlade(false);				
			}
			else
			{
				// End:0xB6
				if(VarName == 'bBoostersActivated')
				{
					// End:0xA9
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
					// End:0xDA
					if(VarName == 'bSelfDestructArmed')
					{
						PlaySelfDestruct();						
					}
					else
					{
						super(UTVehicle).ReplicatedEvent(VarName);
					}
				}
			}
		}
	}
	//return;	
}

simulated function bool OverrideBeginFire(byte FireModeNum)
{
	// End:0x46
	if(int(FireModeNum) == int(1))
	{
		// End:0x44
		if((int(Role) == int(ROLE_Authority)) && !bBladesExtended)
		{
			SetBladesExtended(true);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool OverrideEndFire(byte FireModeNum)
{
	// End:0x44
	if(int(FireModeNum) == int(1))
	{
		// End:0x42
		if((int(Role) == int(ROLE_Authority)) && bBladesExtended)
		{
			SetBladesExtended(false);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function SetBladesExtended(bool bExtended)
{
	local int I;

	bBladesExtended = bExtended;
	// End:0x72
	if(bBladesExtended)
	{
		BladeBlend.AnimFire('Blades_out', true,,, 'Blades_out_idle');
		PlaySound(BladeExtendSound, true);		
	}
	else
	{
		I = 0;
		J0x7D:

		// End:0xEB [Loop If]
		if(I < 2)
		{
			// End:0xDD
			if(BladeVictimConstraint[I] != none)
			{
				BladeVictimConstraint[I].Destroy();
				BladeVictimConstraint[I] = none;
			}
			I++;
			// [Loop Continue]
			goto J0x7D;
		}
		BladeBlend.AnimStopFire();
		PlaySound(BladeRetractSound, true);
	}
	//return;	
}

simulated function PlaySelfDestruct()
{
	local UTGib HatchGib;
	local SkelControlBase SkelControl;

	DeadVehicleLifeSpan = BurnOutTime + 0.0100000;
	UDKVehicleSimCar(SimObj).bDriverlessBraking = false;
	SkelControl = Mesh.FindSkelControl('Hatch');
	// End:0x1FE
	if(SkelControl != none)
	{
		SkelControl.BoneScale = 0.0000000;
		HatchGib = Spawn(HatchGibClass, self,, Mesh.GetBoneLocation('Hatch_Slide'), rot(0, 0, 0));
		// End:0x1FE
		if(HatchGib != none)
		{
			HatchGib.Velocity = 0.2500000 * Velocity;
			HatchGib.Velocity.Z = 400.0000000;
			HatchGib.GibMeshComp.WakeRigidBody();
			HatchGib.GibMeshComp.SetRBLinearVelocity(HatchGib.Velocity, false);
		}
	}
	BigExplosionTemplates.Length = 1;
	BigExplosionTemplates[0].Template = SelfDestructExplosionTemplate;
	BigExplosionTemplates[0].MinDistance = 0.0000000;
	//return;	
}

simulated function DisplayHud(UTHUD HUD, Canvas Canvas, Vector2D HudPOS, optional int SeatIndex)
{
	local PlayerController PC;

	super(UTVehicle).DisplayHud(HUD, Canvas, HudPOS, SeatIndex);
	PC = PlayerController(Seats[0].SeatPawn.Controller);
	// End:0x32C
	if(PC != none)
	{
		// End:0x202
		if(((Throttle > 0.0000000) && !bBoostersActivated) && (WorldInfo.TimeSeconds - BoostChargeTime) > BoostChargeDuration)
		{
			HUD.DrawToolTip(Canvas, PC, "GBA_Jump", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.9500000, BoostToolTipIconCoords.U, BoostToolTipIconCoords.V, BoostToolTipIconCoords.UL, BoostToolTipIconCoords.VL, Canvas.ClipY / float(720));			
		}
		else
		{
			// End:0x32C
			if(ReadyToSelfDestruct())
			{
				HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.9500000, EjectToolTipIconCoords.U, EjectToolTipIconCoords.V, EjectToolTipIconCoords.UL, EjectToolTipIconCoords.VL, Canvas.ClipY / float(720));
			}
		}
	}
	//return;	
}

function DriverLeft()
{
	// End:0xA6
	if(ReadyToSelfDestruct())
	{
		SelfDestructInstigator = ((Driver != none) ? Driver.Controller : none);
		bShouldEject = true;
		BoostStartTime = (WorldInfo.TimeSeconds - MaxBoostDuration) + 1.0000000;
		bSelfDestructArmed = true;
		PlaySelfDestruct();		
	}
	else
	{
		// End:0xBE
		if(bBladesExtended)
		{
			SetBladesExtended(false);
		}
	}
	super.DriverLeft();
	//return;	
}

simulated event BladeHit(Actor HitActor, Vector HitLocation, bool bLeftBlade)
{
	local TraceHitInfo HitInfo;
	local Vector VelDir;
	local Pawn P;
	local int Index;

	// End:0x4DA
	if(HitActor.bBlockActors)
	{
		// End:0x91
		if(Vehicle(HitActor) != none)
		{
			// End:0x8E
			if(HitActor.IsA('UTVehicle_Hoverboard'))
			{
				P = Vehicle(HitActor).Driver;
			}			
		}
		else
		{
			P = Pawn(HitActor);
		}
		// End:0x10F
		if(P == none)
		{
			// End:0x10C
			if(int(Role) == int(ROLE_Authority))
			{
				// End:0xEC
				if(bLeftBlade)
				{
					bLeftBladeBroken = true;					
				}
				else
				{
					bRightBladeBroken = true;
				}
				BreakOffBlade(bLeftBlade);
			}			
		}
		else
		{
			// End:0x174
			if(int(Role) == int(ROLE_Authority))
			{
				P.TakeDamage(1000, Controller, HitLocation, Velocity * 100.0000000, BladeDamageType);
			}
			// End:0x4DA
			if(((((P.Health <= 0) && !P.bDeleteMe) && int(P.Physics) == int(10)) && P.Mesh != none) && P.Mesh.PhysicsAssetInstance != none)
			{
				VelDir = Normal(Velocity);
				P.CheckHitInfo(HitInfo, P.Mesh, VelDir, HitLocation);
				// End:0x35B
				if(HitInfo.BoneName == 'None')
				{
					P.CheckHitInfo(HitInfo, P.Mesh, Normal(P.Location - HitLocation), HitLocation);
				}
				// End:0x4DA
				if(HitInfo.BoneName != 'None')
				{
					Index = 0;
					// End:0x40F
					if(BladeVictimConstraint[Index] != none)
					{
						Index = 1;
						// End:0x40F
						if(BladeVictimConstraint[Index] != none)
						{
							Index = 0;
							BladeVictimConstraint[Index].Destroy();
							BladeVictimConstraint[Index] = none;
						}
					}
					BladeVictimConstraint[Index] = Spawn(Class'Engine.RB_ConstraintActorSpawnable',,, HitLocation);
					BladeVictimConstraint[Index].InitConstraint(self, P, 'None', HitInfo.BoneName, 200.0000000);
					BladeVictimConstraint[Index].LifeSpan = 1.0000000 + (float(4) * FRand());
				}
			}
		}
	}
	//return;	
}

function bool FindAutoExit(Pawn ExitingDriver)
{
	local Vector X, Y, Z;
	local float PlaceDist;

	// End:0xB6
	if(bBoostersActivated)
	{
		GetAxes(Rotation, X, Y, Z);
		Y *= float(-1);
		PlaceDist = 150.0000000 + (float(4) * ExitingDriver.GetCollisionHeight());
		// End:0xB6
		if(TryExitPos(ExitingDriver, (GetTargetLocation()) + (PlaceDist * Z), false))
		{
			return true;
		}
	}
	return super(UTVehicle).FindAutoExit(ExitingDriver);
	//return ReturnValue;	
}

function byte ChooseFireMode()
{
	local UTVehicle V;
	local float Dist;
	local Vector FacingDir, enemyDir;

	// End:0x2E
	if(bAISelfDestruct)
	{
		// End:0x2B
		if(!bTryToBoost)
		{
			bAISelfDestruct = false;			
		}
		else
		{
			return 0;
		}
	}
	// End:0x3A4
	if(((Pawn(Controller.Focus) != none) && Controller.MoveTarget == Controller.Focus) && Controller.InLatentExecution(Controller.503))
	{
		V = UTVehicle(Controller.Focus);
		// End:0x2F0
		if(V == none)
		{
			Dist = VSize(Controller.GetFocalPoint() - Location);
			// End:0x2ED
			if((Dist < 1200.0000000) && Controller.LineOfSightTo(Controller.Focus))
			{
				// End:0x2EA
				if(((WorldInfo.TimeSeconds - LastBladeBoostTime) > float(5)) && Dist > 200.0000000)
				{
					LastBladeBoostTime = WorldInfo.TimeSeconds;
					FacingDir = Vector(Rotation);
					FacingDir.Z = 0.0000000;
					enemyDir = Controller.Focus.Location - Location;
					enemyDir.Z = 0.0000000;
					bTryToBoost = ((Normal(FacingDir) Dot Normal(enemyDir)) > 0.9300000) && FRand() < 0.5000000;
				}
				return 1;
			}			
		}
		else
		{
			// End:0x3A4
			if(((V.Health > 300) || V.ImportantVehicle()) && Controller.LineOfSightTo(Controller.Focus))
			{
				bTryToBoost = true;
				bAISelfDestruct = true;
				SetTimer(0.3000000, true, 'CheckScriptedSelfDestruct');
			}
		}
	}
	return 0;
	//return ReturnValue;	
}

function bool TooCloseToAttack(Actor Other)
{
	// End:0x34
	if((Pawn(Other) != none) && Vehicle(Other) == none)
	{
		return false;
	}
	return super(UTVehicle).TooCloseToAttack(Other);
	//return ReturnValue;	
}

function IncomingMissile(Projectile P)
{
	local UTBot B;

	B = UTBot(Controller);
	// End:0xCF
	if((((Health < 200) && B != none) && B.Skill > (4.0000000 + (4.0000000 * FRand()))) && VSize(P.Location - Location) < VSize(P.Velocity))
	{
		DriverLeave(false);
	}
	//return;	
}

simulated function TeamChanged()
{
	super(UTVehicle).TeamChanged();
	bBrakeLightOn = false;
	bReverseLightOn = false;
	bHeadlightsOn = false;
	//return;	
}

function OnSelfDestruct(UTSeqAct_SelfDestruct Action)
{
	bScriptedBoosters = true;
	SetTimer(0.5000000, true, 'CheckScriptedSelfDestruct');
	//return;	
}

function CheckScriptedSelfDestruct()
{
	// End:0x38
	if(ReadyToSelfDestruct())
	{
		DriverLeave(true);
		ClearTimer('CheckScriptedSelfDestruct');
		bAISelfDestruct = false;
	}
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
	// End:0x137
	if(((Abs(RigidCollisionData.ContactInfos[0].ContactNormal.Z) < WalkableFloorZ) || Abs(RigidCollisionData.ContactInfos[0].ContactNormal Dot Vector(Rotation)) > 0.8000000) || (VSizeSq(Mesh.GetRootBodyInstance().PreviousVelocity) * (GetCollisionDamageModifier(RigidCollisionData.ContactInfos))) > float(5))
	{
		super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	}
	//return;	
}

function float GetCollisionDamageModifier(const out array<RigidBodyContactInfo> ContactInfos)
{
	return 0.0000000;
	//return ReturnValue;	
}

simulated function BreakOffBlade(bool bLeftBlade)
{
	local SkelControlBase SkelControl;
	local Vector BoneLoc;

	PlaySound(BladeBreakSound, true);
	SkelControl = Mesh.FindSkelControl(((bLeftBlade) ? 'LeftBlade' : 'RightBlade'));
	BoneLoc = Mesh.GetBoneLocation(((bLeftBlade) ? 'Blade_L2' : 'Blade_R2'));
	// End:0xE4
	if(SkelControl != none)
	{
		SkelControl.BoneScale = 0.0000000;		
	}
	else
	{
		WarnInternal((("Failed to find skeletal controller named" @ string(((bLeftBlade) ? 'LeftBlade' : 'RightBlade'))) @ "for mesh") @ string(Mesh));
	}
	// End:0x1C8
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !IsZero(BoneLoc))
	{
		SpawnGibVehicle(BoneLoc, Rotation, BrokenBladeMesh, BoneLoc, true, vect(0.0000000, 0.0000000, 0.0000000), none, none);
	}
	//return;	
}

simulated function CauseMuzzleFlashLight(int SeatIndex)
{
	super(UTVehicle).CauseMuzzleFlashLight(SeatIndex);
	// End:0x35
	if(SeatIndex == 0)
	{
		VehicleEvent('MuzzleFlash');
	}
	//return;	
}

simulated function SetBurnOut()
{
	super(UTVehicle).SetBurnOut();
	// End:0x4D
	if(DeathExplosion != none)
	{
		DeathExplosion.ParticleSystemComponent.DeactivateSystem();
	}
	VehicleEvent('NoDamageSmoke');
	//return;	
}

function bool RecommendCharge(UTBot B, Pawn Enemy)
{
	local UTVehicle V;

	// End:0x24
	if(Enemy.bCanFly)
	{
		return false;
	}
	V = UTVehicle(Enemy);
	return ((V == none) || V.ImportantVehicle()) || V.Health > 300;
	//return ReturnValue;	
}

function bool CriticalChargeAttack(UTBot B)
{
	return (UTVehicle(B.Enemy) != none) && RecommendCharge(B, B.Enemy);
	//return ReturnValue;	
}

simulated function bool CanEnterVehicle(Pawn P)
{
	return super.CanEnterVehicle(P);
	//return ReturnValue;	
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

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp, SkelControlBase SkelCtrl)
{
	local SkelControlWheel WheelCtrl;
	local int I;

	WheelCtrl = SkelControlWheel(SkelCtrl);
	I = 0;
	J0x27:

	// End:0x149 [Loop If]
	if(I < Wheels.Length)
	{
		// End:0x13B
		if(Wheels[I].WheelControl == WheelCtrl)
		{
			WheelCtrl.WheelRoll = (((Wheels[I].SuspensionTravel - Wheels[I].SuspensionPosition) * WheelRollMultiplier) * Wheels[I].SteerFactor) + (((FRand() * 2.0000000) - 1.0000000) * WheelRollShakeAmplitude);
			// [Explicit Break]
			goto J0x149;
		}
		I++;
		// [Loop Continue]
		goto J0x27;
	}
	J0x149:

	//return;	
}

function Vector GetTurretSocketLocation()
{
	local Vector TurretLocation;

	// End:0x39
	if(Mesh.GetSocketWorldLocationAndRotation('turretSocket', TurretLocation))
	{		
	}
	else
	{
		WarnInternal("Socket 'turretSocket' not found!");
	}
	return TurretLocation;
	//return ReturnValue;	
}

simulated function InstantBrake()
{
	// End:0x1F6
	if(bDriving && bInstantBrakeEnabled)
	{
		// End:0x1BA
		if(((Abs(Throttle) <= 0.0500000) || (Throttle < 0.0500000) && ForwardVel > SVehicleSimCar(SimObj).StopThreshold) || (Throttle > -0.0500000) && ForwardVel < -SVehicleSimCar(SimObj).StopThreshold)
		{
			SVehicleSimTank(SimObj).LeftTrackVel = 0.0000000;
			SVehicleSimTank(SimObj).RightTrackVel = 0.0000000;
			SVehicleSimTank(SimObj).LeftTrackTorque = 0.0000000;
			SVehicleSimTank(SimObj).RightTrackTorque = 0.0000000;
			// End:0x1B7
			if(!bOutputHandbrake)
			{
				LogInternal("HIT THE BREAKS");
				PlayBrakeHitSound();
				bOutputHandbrake = true;
			}			
		}
		else
		{
			// End:0x1F6
			if(bOutputHandbrake)
			{
				LogInternal("LET GO OF THE BREAKS");
				PlayBrakeReleaseSound();
				bOutputHandbrake = false;
			}
		}
	}
	//return;	
}

simulated function PlayBrakeHitSound()
{
	// End:0x28
	if(BrakeHitEvent != none)
	{
		PlayAkEvent(BrakeHitEvent);
	}
	//return;	
}

simulated function PlayBrakeReleaseSound()
{
	// End:0x28
	if(BrakeReleaseEvent != none)
	{
		PlayAkEvent(BrakeReleaseEvent);
	}
	//return;	
}

simulated function Tick(float DeltaTime)
{
	local float LeftThrottleMult, RightThrottleMult;
	local int I;
	local HaloPlayerPawnController HPC;
	local Rotator AutoAimRotator;

	InstantBrake();
	// End:0x137
	if(Controller != none)
	{
		TurretRotation = Instigator.GetViewRotation();
		HPC = HaloPlayerPawnController(Controller);
		// End:0xBB
		if(HPC != none)
		{
			AutoAimRotator = FindBestAutoAimTargetRotation(0);
			TurretRotation.Pitch = AutoAimRotator.Pitch;
		}
		I = 0;
		J0xC6:

		// End:0x137 [Loop If]
		if(I < TurretControllers.Length)
		{
			// End:0x129
			if(TurretControllers[I] != none)
			{
				TurretControllers[I].DesiredBoneRotation = TurretRotation;
			}
			I++;
			// [Loop Continue]
			goto J0xC6;
		}
	}
	// End:0x265
	if((none != LeftTreadMaterial) && none != RightTreadMaterial)
	{
		LeftThrottleMult = ((Steering > 0.0075000) ? SVehicleSimTank(SimObj).InsideTrackTorqueFactor : 1.0000000);
		RightThrottleMult = ((Steering < -0.0075000) ? SVehicleSimTank(SimObj).InsideTrackTorqueFactor : 1.0000000);
		LeftTreadMaterial.SetScalarParameterValue('TreadSpeed', Throttle * LeftThrottleMult);
		RightTreadMaterial.SetScalarParameterValue('TreadSpeed', Throttle * RightThrottleMult);
	}
	super.Tick(DeltaTime);
	//return;	
}

simulated function Rotator GetAdjustedAim()
{
	local Vector StartLocation;
	local Rotator StartRotation;
	local float Width, Height;

	GetBarrelLocationAndRotation(0, StartLocation, StartRotation);
	GetBoundingCylinder(Width, Height);
	StartLocation -= (Vector(StartRotation) * Width);
	// End:0xB0
	if(Controller != none)
	{
		return Controller.GetAdjustedAimFor(Seats[0].Gun, StartLocation);
	}
	return StartRotation;
	//return ReturnValue;	
}

function Rotator GetWeaponAim(UTVehicleWeapon VWeapon)
{
	local Rotator barrelRot;
	local Vector barrelLoc;
	local int SeatIndex;

	SeatIndex = 0;
	J0x0B:

	// End:0xD9 [Loop If]
	if(SeatIndex < Seats.Length)
	{
		// End:0xCB
		if((Seats[SeatIndex].GunClass != none) && VWeapon.IsA(Seats[SeatIndex].GunClass.Name))
		{
			GetBarrelLocationAndRotation(SeatIndex, barrelLoc, barrelRot);
		}
		SeatIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	return barrelRot;
	//return ReturnValue;	
}

defaultproperties
{
	BladeBreakPoint=0.8000000
	BoostReleaseDelay=0.1500000
	SelfDestructSpeedSquared=810000.0000000
	LockSuspensionTravel=37.0000000
	LockSuspensionStiffness=62.5000000
	BoostSteerFactors[0]=10.0000000
	BoostSteerFactors[1]=4.0000000
	BoostSteerFactors[2]=1.2000000
	TurretInterpRate=2.0000000
	WheelSteerSensitivity=60.0000000
	MaxWheelSteerAngle=45.0000000
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.BlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloVehicle.BlokSpawnerComponent'
	begin object name="BlokSpawnerComponent"
	end object
	BlokSpawner=BlokSpawnerComponent
	EntryPoints[0]=(Radius=120.0000000,SocketName="driverEntry",ToolTipCoords=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),EnterPawnAnimName="Scorpion_D_Enter",ExitPawnAnimName="Scorpion_D_Exit",SeatIndex=0)
	EntryPoints[1]=(Radius=100.0000000,SocketName="driverEntry_L",ToolTipCoords=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),EnterPawnAnimName="scorpion_d_enter_L",ExitPawnAnimName="scorpion_d_exit_L",SeatIndex=0)
	EntryPoints[2]=(Radius=100.0000000,SocketName="driverEntry_R",ToolTipCoords=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000),EnterPawnAnimName="scorpion_d_enter_R",ExitPawnAnimName="scorpion_d_exit_R",SeatIndex=0)
	AkVehicleType="UNSC_Scorpion"
	AkObjectType="UNSC_Scorpion"
	AkPitchType="RPM"
	AKMinPitch=500
	AKMaxPitch=15000
	SkidLoopEnabled=false
	bAutoBrakeEnabled=false
	EngineBone="Hull"
	ExhaustBone="B_Base_Armor_SB"
	VehicleGears[0]=(MinPercent=0.0000000,MaxPercent=100.0000000,GearRatio=(Points=((InVal=0.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=EInterpCurveMode.CIM_Linear),(InVal=900.0000000,OutVal=100.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=EInterpCurveMode.CIM_Linear)),InterpMethod=EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents))
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.SuspensionWaveform1'
	begin object name="SuspensionWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=50,RightAmplitude=50,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	SuspensionWaveform=SuspensionWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.CrashWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloVehicle.CrashWaveform1'
	begin object name="CrashWaveform1"
	end object
	CrashWaveform=CrashWaveform1
	RocketGroundSpeed=900.0000000
	RocketAirSpeed=900.0000000
	XSensitivity=15.0000000
	CameraLookSteerXSensitivity=0.5000000
	CameraLookSteerYSensitivity=0.5000000
	CameraSteerInterpRate=5.0000000
	AutoAimAnglePitchMax=60.0000000
	AutoAimAnglePitchMin=-9.0000000
	AutoAimAngleYawDiff=10.0000000
	DriveVehicleMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Drive Scorpion"
	RideInVehicleMessage="Riding Is Not Supported On This Vehicle"
	ManTurretMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Operate Machine Gun"
	FlipVehicleMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Flip Scorpion"
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.MyHaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloVehicle.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent"
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloVehicle.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	bLookSteerOnNormalControls=true
	bLookSteerOnSimpleControls=true
	bReducedFallingCollisionDamage=true
	DeflectionReverseThresh=-0.3000000
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	MaxDesireability=0.4000000
	LookSteerSensitivity=0.3000000
	LookSteerDamping=0.1000000
	LookSteerDeadZone=0.2500000
	ConsoleSteerScale=1.1000000
	StolenAnnouncementIndex=5
	DamageSmokeThreshold=0.5000000
	SpawnRadius=125.0000000
	TeamBeaconOffset=(X=60.0000000,Y=0.0000000,Z=0.0000000)
	DefaultFOV=80.0000000
	CameraLag=0.0700000
	CustomGravityScaling=1.5000000
	ObjectiveGetOutDist=2000.0000000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	bLookSteerOnAllPlatforms=true
	// Reference: SVehicleSimTank'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.SimObject'
	begin object name="SimObject" class=Engine.SVehicleSimTank
	end object
	SimObj=SimObject
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.RRWheel01'
	begin object name="RRWheel01" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[0]=RRWheel01
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.RRWheel03'
	begin object name="RRWheel03" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[1]=RRWheel03
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.LRWheel01'
	begin object name="LRWheel01" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[2]=LRWheel01
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.LRWheel03'
	begin object name="LRWheel03" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[3]=LRWheel03
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.RFWheel01'
	begin object name="RFWheel01" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[4]=RFWheel01
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.RFWheel03'
	begin object name="RFWheel03" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[5]=RFWheel03
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.LFWheel01'
	begin object name="LFWheel01" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[6]=LFWheel01
	// Reference: HaloVehicleArcadeScorpionWheel'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.LFWheel03'
	begin object name="LFWheel03" class=MegaHaloGame.HaloVehicleArcadeScorpionWheel
	end object
	Wheels[7]=LFWheel03
	COMOffset=(X=-75.0000000,Y=0.0000000,Z=-100.0000000)
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'MegaHaloGame.Default__HaloVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'MegaHaloGame.Default__HaloVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	HeavySuspensionShiftPercent=0.7500000
	MaxSpeed=2500.0000000
	UprightLiftStrength=280.0000000
	UprightTorqueStrength=500.0000000
	UprightTime=1.2500000
	bTurnInPlace=true
	bSeparateTurretFocus=true
	ExitRadius=400.0000000
	MomentumMult=0.3000000
	NonPreferredVehiclePathMultiplier=1.5000000
	GroundSpeed=2500.0000000
	AirSpeed=750.0000000
	Health=4000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.CollisionCylinder'
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
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloVehicle_ArcadeScorpion.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloVehicle.targetableComponent'
	begin object name="targetableComponent"
	end object
	Components[5]=targetableComponent
	Components[6]=MyHaloTargetableComponent
	Components[7]=NeedleTarget
	Components[8]=SimObject
	CollisionComponent=SVehicleMesh
}