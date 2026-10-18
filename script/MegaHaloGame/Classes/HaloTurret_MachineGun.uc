class HaloTurret_MachineGun extends HaloTurret
	abstract
	config(GwNavEngine);

function bool DriverEnter(Pawn P)
{
	// End:0x8D
	if(super(UTVehicle).DriverEnter(P))
	{
		Seats[0].Gun.Spread[0] = MannedFireSpread;
		Seats[0].Gun.EndFire(0);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function DriverLeft()
{
	Seats[0].Gun.Spread[0] = UnmannedFireSpread;
	Seats[0].Gun.EndFire(0);
	Target = none;
	super(UTVehicle).DriverLeft();
	//return;	
}

function UpdateAI(float DeltaTime)
{
	local HaloPawn potentialTarget, NewTarget;
	local Actor TraceActor;
	local float ClosestRange, rawRange, vRange, hRange, dotVal, AngleBetween;

	local Vector HitLocation, HitNormal, fireLoc, FlatLoc, FlatTargetLoc, FlatLookAt,
		FlatForward;

	local Rotator FireRot, FlatRot;

	ClosestRange = 1000000.0000000;
	// End:0x56
	if(Health <= 0)
	{
		Seats[0].Gun.EndFire(0);
		return;
	}
	Mesh.GetSocketWorldLocationAndRotation(Seats[0].GunSocket[0], fireLoc, FireRot);
	FlatLoc = fireLoc;
	FlatLoc.Z = 0.0000000;
	FlatRot = Rotation;
	FlatRot.Pitch = 0;
	FlatForward = Vector(FlatRot);
	// End:0x51D
	if(Seats[0].Gun.IsFiring()! && (CurBurstCD == float(0)) || ContinuousTracking)
	{
		// End:0x4E1
		foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloPawn', potentialTarget, fireLoc, Seats[0].Gun.WeaponRange)
		{
			rawRange = 10000000.0000000;
			TraceActor = none;
			// End:0x4E0
			if(((potentialTarget != none) && potentialTarget.Health > 0) && int(potentialTarget.GetTeamNum()) != int(GetTeamNum()))
			{
				FlatTargetLoc = potentialTarget.Location;
				FlatTargetLoc.Z = 0.0000000;
				FlatLookAt = FlatTargetLoc - FlatLoc;
				dotVal = FlatForward Dot Normal(FlatLookAt);
				AngleBetween = Acos(dotVal) * 57.2957802;
				// End:0x4E0
				if(AngleBetween <= AITargetingMaxAngle)
				{
					TraceActor = Trace(HitLocation, HitNormal, potentialTarget.Location, fireLoc, true);
					// End:0x4E0
					if((potentialTarget == TraceActor) || potentialTarget.DrivenVehicle == TraceActor)
					{
						vRange = Abs(fireLoc.Z - potentialTarget.Location.Z);
						hRange = VSize(FlatTargetLoc - FlatLoc);
						// End:0x4E0
						if((vRange <= AttackVerticalRange) && hRange <= AttackHorizontalRange)
						{
							rawRange = VSize(potentialTarget.Location - fireLoc);
							// End:0x4E0
							if(rawRange < ClosestRange)
							{
								ClosestRange = rawRange;
								NewTarget = potentialTarget;
							}
						}
					}
				}
			}			
		}		
		// End:0x51D
		if((NewTarget != none) && NewTarget != Target)
		{
			Target = NewTarget;
		}
	}
	// End:0x682
	if(Target != none)
	{
		// End:0x5F9
		if(Seats[0].Gun.IsFiring())
		{
			// End:0x5F6
			if((CurBurstTime >= MaxBurstTime) || Target.Health <= 0)
			{
				Seats[0].Gun.EndFire(0);
				CurBurstCD = BurstCooldown;
				Target = none;
				return;
			}			
		}
		else
		{
			// End:0x682
			if((Normal(Target.Location - fireLoc) Dot Vector(FireRot)) >= 0.9900000)
			{
				CurBurstTime = 0.0000000;
				Seats[0].Gun.StartFire(0);
				return;
			}
		}
	}
	// End:0x6F1
	if(Target == none)
	{
		LastAttackTime = WorldInfo.TimeSeconds;
		Seats[0].Gun.EndFire(0);
		return;
	}
	//return;	
}

function Rotator GetWeaponAim(UTVehicleWeapon VWeapon)
{
	return GetAdjustedAim();
	//return ReturnValue;	
}

defaultproperties
{
	AttackHorizontalRange=3500.0000000
	AttackVerticalRange=7000.0000000
	TargetInterpTime=2.5000000
	UnmannedFireSpread=0.1500000
	MaxBurstTime=1.7500000
	BurstCooldown=1.0000000
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloTurret_MachineGun.BlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloTurret.BlokSpawnerComponent'
	begin object name="BlokSpawnerComponent"
	end object
	BlokSpawner=BlokSpawnerComponent
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloTurret_MachineGun.MyHaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloTurret.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent"
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloTurret_MachineGun.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloTurret.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	bStickDeflectionThrottle=true
	bLookSteerOnNormalControls=true
	bLookSteerOnSimpleControls=true
	bReducedFallingCollisionDamage=true
	DeflectionReverseThresh=-0.3000000
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret_MachineGun.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	MaxDesireability=0.4000000
	LookSteerSensitivity=1.5000000
	LookSteerDamping=0.0700000
	ConsoleSteerScale=1.1000000
	StolenAnnouncementIndex=5
	DamageSmokeThreshold=0.5000000
	SpawnRadius=125.0000000
	TeamBeaconOffset=(X=60.0000000,Y=0.0000000,Z=0.0000000)
	DefaultFOV=80.0000000
	CameraLag=0.0700000
	ObjectiveGetOutDist=1500.0000000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloTurret_MachineGun.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloTurret.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	bLookSteerOnAllPlatforms=true
	// Reference: UDKVehicleSimCar'MegaHaloGame.Default__HaloTurret_MachineGun.SimObject'
	begin object name="SimObject" class=UDKBase.UDKVehicleSimCar
	end object
	SimObj=SimObject
	bCanFlip=true
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloTurret_MachineGun.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'MegaHaloGame.Default__HaloTurret.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloTurret_MachineGun.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'MegaHaloGame.Default__HaloTurret.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	HeavySuspensionShiftPercent=0.7500000
	UprightLiftStrength=20.0000000
	UprightTime=1.2500000
	bSeparateTurretFocus=true
	bHasHandbrake=true
	ExitRadius=200.0000000
	MomentumMult=0.5000000
	NonPreferredVehiclePathMultiplier=1.5000000
	GroundSpeed=0.0000000
	AirSpeed=0.0000000
	Health=500
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloTurret_MachineGun.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloTurret.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret_MachineGun.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloTurret_MachineGun.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloTurret.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloTurret_MachineGun.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloTurret.targetableComponent'
	begin object name="targetableComponent"
	end object
	Components[4]=targetableComponent
	Components[5]=MyHaloTargetableComponent
	Components[6]=BlokSpawnerComponent
	Components[7]=NeedleTarget
	Components[8]=SimObject
	CollisionComponent=SVehicleMesh
}