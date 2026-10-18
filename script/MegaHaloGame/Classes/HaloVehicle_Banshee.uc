class HaloVehicle_Banshee extends UTAirVehicle
	abstract
	config(GwNavEngine);

var repnotify Vector TurretFlashLocation;
var repnotify Rotator TurretWeaponRotation;
var repnotify byte TurretFlashCount;
var repnotify byte TurretFiringMode;
var bool bFreelanceStart;
var array<int> JetEffectIndices;
var ParticleSystem TurretBeamTemplate;
var UTSkelControl_JetThruster JetControl;
var name JetScalingParam;
var name AkVehicleType;
var name AkObjectType;
var name AkPitchType;
var int AKMinPitch;
var int AKMaxPitch;

replication
{
	// Pos:0x000
	if(bNetDirty)
		TurretFlashLocation;

	// Pos:0x00A
	if(IsSeatControllerReplicationViewer(1)! || bDemoRecording)
		TurretFiringMode, TurretFlashCount, 
		TurretWeaponRotation;
}

event Tick(float DeltaTime)
{
	local UTBot Bot;
	local float JetScale;
	local int I, JetIndex;
	local Vector HitLocation, HitNormal;
	local Actor HitActor;

	super(Actor).Tick(DeltaTime);
	// End:0x3BB
	if(bDriving)
	{
		// End:0x129
		if(Controller == none)
		{
			// End:0x126
			if((((Seats.Length > 1) && Seats[1].SeatPawn != none) && Seats[1].SeatPawn.Controller != none) && Location.Z < WorldInfo.StallZ)
			{
				Rise = FClamp((-1.0000000 * Velocity.Z) / (GetMaxRiseForce()), -1.0000000, 1.0000000);
			}			
		}
		else
		{
			Bot = UTBot(Controller);
			// End:0x3BB
			if(Bot != none)
			{
				// End:0x1BE
				if(Bot.bScriptedFrozen)
				{
					Rise = FClamp((-1.0000000 * Velocity.Z) / (GetMaxRiseForce()), 0.0000000, 1.0000000);					
				}
				else
				{
					// End:0x3BB
					if(Bot.InLatentExecution(Bot.503)!)
					{
						// End:0x338
						if(Rise < 0.0000000)
						{
							// End:0x335
							if(Velocity.Z < 0.0000000)
							{
								// End:0x26A
								if(Velocity.Z < -1000.0000000)
								{
									Rise = -0.0010000;
								}
								HitActor = Trace(HitLocation, HitNormal, Location - vect(0.0000000, 0.0000000, 2000.0000000), Location, false);
								// End:0x335
								if(HitActor != none)
								{
									// End:0x335
									if(((Location.Z - HitLocation.Z) / (-1.0000000 * Velocity.Z)) < 0.8500000)
									{
										Rise = 1.0000000;
									}
								}
							}							
						}
						else
						{
							// End:0x3BB
							if(Rise == 0.0000000)
							{
								// End:0x3BB
								if(FastTrace(Location - vect(0.0000000, 0.0000000, 500.0000000), Location)!)
								{
									Rise = FClamp((-1.0000000 * Velocity.Z) / (GetMaxRiseForce()), 0.0000000, 1.0000000);
								}
							}
						}
					}
				}
			}
		}
	}
	// End:0x51A
	if(LastRenderTime > (WorldInfo.TimeSeconds - 0.2000000))
	{
		// End:0x51A
		if(JetControl != none)
		{
			JetScale = FClamp(1.0000000 - JetControl.ControlStrength, 0.2000000, 1.0000000);
			I = 0;
			J0x443:

			// End:0x51A [Loop If]
			if(I < JetEffectIndices.Length)
			{
				JetIndex = JetEffectIndices[I];
				// End:0x50C
				if((JetIndex < VehicleEffects.Length) && VehicleEffects[JetIndex].EffectRef != none)
				{
					VehicleEffects[JetIndex].EffectRef.SetFloatParameter(JetScalingParam, JetScale);
				}
				I++;
				// [Loop Continue]
				goto J0x443;
			}
		}
	}
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
	super(UTVehicle).RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	// End:0xD0
	if(IsTimerActive('ResetTurningSpeed')!)
	{
		SetTimer(0.7000000, false, 'ResetTurningSpeed');
		MaxSpeed = default.MaxSpeed / 2.0000000;
		MaxAngularVelocity = default.MaxAngularVelocity / 4.0000000;
		// End:0xD0
		if(UDKVehicleSimChopper(SimObj) != none)
		{
			UDKVehicleSimChopper(SimObj).bRecentlyHit = true;
		}
	}
	//return;	
}

simulated function ResetTurningSpeed()
{
	MaxSpeed = default.MaxSpeed;
	MaxAngularVelocity = default.MaxAngularVelocity;
	// End:0x68
	if(UDKVehicleSimChopper(SimObj) != none)
	{
		UDKVehicleSimChopper(SimObj).bRecentlyHit = false;
	}
	//return;	
}

function bool ImportantVehicle()
{
	return bFreelanceStart!;
	//return ReturnValue;	
}

function bool DriverEnter(Pawn P)
{
	local UTBot B;

	// End:0x1A
	if(super(UTVehicle).DriverEnter(P)!)
	{
		return false;
	}
	B = UTBot(Controller);
	bFreelanceStart = ((B != none) && B.Squad != none) && UTSquadAI(B.Squad).bFreelance;
	return true;
	//return ReturnValue;	
}

function DriverLeft()
{
	super(UTVehicle).DriverLeft();
	SetDriving((NumPassengers()) > 0);
	//return;	
}

function PassengerLeave(int SeatIndex)
{
	super(UTVehicle).PassengerLeave(SeatIndex);
	SetDriving((NumPassengers()) > 0);
	//return;	
}

function bool PassengerEnter(Pawn P, int SeatIndex)
{
	// End:0x23
	if(super(UTVehicle).PassengerEnter(P, SeatIndex)!)
	{
		return false;
	}
	SetDriving(true);
	return true;
	//return ReturnValue;	
}

simulated function SitDriver(UTPawn UTP, int SeatIndex)
{
	// End:0x59
	if((int(Role) < int(ROLE_Authority)) && SeatIndex == 1)
	{
		Seats[0].Gun.ForceEndFire();
	}
	super(UTVehicle).SitDriver(UTP, SeatIndex);
	//return;	
}

function bool RecommendLongRangedAttack()
{
	return true;
	//return ReturnValue;	
}

simulated function VehicleWeaponImpactEffects(Vector HitLocation, int SeatIndex)
{
	local editinline ParticleSystemComponent E;

	super(UTVehicle).VehicleWeaponImpactEffects(HitLocation, SeatIndex);
	// End:0xCE
	if((SeatIndex == 1) && IsZero(HitLocation)!)
	{
		E = WorldInfo.MyEmitterPool.SpawnEmitter(TurretBeamTemplate, GetEffectLocation(SeatIndex));
		E.SetVectorParameter('ShockBeamEnd', HitLocation);
	}
	//return;	
}

simulated function Vector GetCameraStart(int SeatIndex)
{
	local Vector CamStart;

	// End:0xA2
	if((SeatIndex == 1) && Seats[SeatIndex].CameraTag != 'None')
	{
		// End:0xA2
		if(Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].CameraTag, CamStart))
		{
			return CamStart;
		}
	}
	return super(UTVehicle).GetCameraStart(SeatIndex);
	//return ReturnValue;	
}

simulated function VehicleCalcCamera(float DeltaTime, int SeatIndex, out Vector out_CamLoc, out Rotator out_CamRot, out Vector CamStart, optional bool bPivotOnly)
{
	// End:0x89
	if(SeatIndex == 1)
	{
		out_CamLoc = GetCameraStart(SeatIndex);
		out_CamRot = Seats[SeatIndex].SeatPawn.GetViewRotation();
		CamStart = out_CamLoc;		
	}
	else
	{
		super(UTVehicle).VehicleCalcCamera(DeltaTime, SeatIndex, out_CamLoc, out_CamRot, CamStart, bPivotOnly);
	}
	//return;	
}

simulated function bool ShouldClamp()
{
	return false;
	//return ReturnValue;	
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

defaultproperties
{
	AkVehicleType="COV_Banshee"
	AkObjectType="COV_Banshee"
	AkPitchType="Thrust"
	AKMaxPitch=100
	PushForce=50000.0000000
	bOverrideAVRiLLocks=true
	bLimitCameraZLookingUp=true
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle_Banshee.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTAirVehicle.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	RespawnTime=45.0000000
	HUDExtent=140.0000000
	SpawnRadius=180.0000000
	CameraLag=0.0500000
	LookForwardDist=290.0000000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloVehicle_Banshee.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UTGame.Default__UTAirVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: UDKVehicleSimChopper'MegaHaloGame.Default__HaloVehicle_Banshee.SimObject'
	begin object name="SimObject" class=UDKBase.UDKVehicleSimChopper
	end object
	SimObj=SimObject
	COMOffset=(X=-50.0000000,Y=0.0000000,Z=-40.0000000)
	bStayUpright=true
	StayUprightRollResistAngle=5.0000000
	StayUprightPitchResistAngle=5.0000000
	StayUprightStiffness=1200.0000000
	StayUprightDamping=20.0000000
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloVehicle_Banshee.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UTGame.Default__UTAirVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloVehicle_Banshee.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UTGame.Default__UTAirVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	UprightLiftStrength=30.0000000
	UprightTorqueStrength=30.0000000
	GroundSpeed=1600.0000000
	AirSpeed=2000.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicle_Banshee.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTAirVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicle_Banshee.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicle_Banshee.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTAirVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=SimObject
	CollisionComponent=SVehicleMesh
}