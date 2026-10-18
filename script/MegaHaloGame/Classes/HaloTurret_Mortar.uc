class HaloTurret_Mortar extends HaloTurret
	abstract
	config(GwNavEngine);

var float AttackMinHorizontalRange;
var float TossZHint;
var bool bValidToss;
var Rotator ValidTossRot;
var Vector ValidTossVec;

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
	super(UTVehicle).DriverLeft();
	//return;	
}

function UpdateAI(float DeltaTime)
{
	local HaloPawn potentialTarget, NewTarget;
	local float FurthestRange, rawRange, vRange, hRange, dotVal, AngleBetween;

	local Vector roofCheck, fireLoc, FlatLoc, FlatTargetLoc, FlatLookAt, FlatForward,
		mortarTargetLoc;

	local Rotator FireRot, FlatRot;

	FurthestRange = 0.0000000;
	// End:0x56
	if(Health <= 0)
	{
		Seats[0].Gun.EndFire(0);
		return;
	}
	Mesh.GetSocketWorldLocationAndRotation('Turret_Fire', fireLoc, FireRot);
	FlatLoc = fireLoc;
	FlatLoc.Z = 0.0000000;
	FlatRot = Rotation;
	FlatRot.Pitch = 0;
	FlatForward = Vector(FlatRot);
	// End:0x50D
	if(Seats[0].Gun.IsFiring()! && CurBurstCD == float(0))
	{
		// End:0x4D1
		foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloPawn', potentialTarget, fireLoc, Seats[0].Gun.WeaponRange)
		{
			rawRange = 0.0000000;
			// End:0x4D0
			if(((potentialTarget != none) && potentialTarget.Health > 0) && int(potentialTarget.GetTeamNum()) != int(GetTeamNum()))
			{
				FlatTargetLoc = potentialTarget.Location;
				FlatTargetLoc.Z = 0.0000000;
				FlatLookAt = FlatTargetLoc - FlatLoc;
				dotVal = FlatForward Dot Normal(FlatLookAt);
				AngleBetween = Acos(dotVal) * 57.2957802;
				// End:0x4D0
				if(AngleBetween <= AITargetingMaxAngle)
				{
					roofCheck = potentialTarget.Location;
					roofCheck.Z = roofCheck.Z + 1000.0000000;
					// End:0x4D0
					if(FastTrace(roofCheck, potentialTarget.Location))
					{
						vRange = Abs(fireLoc.Z - potentialTarget.Location.Z);
						hRange = VSize(FlatTargetLoc - FlatLoc);
						// End:0x4D0
						if(((vRange <= AttackVerticalRange) && hRange <= AttackHorizontalRange) && hRange >= AttackMinHorizontalRange)
						{
							rawRange = VSize(potentialTarget.Location - fireLoc);
							// End:0x4D0
							if(rawRange > FurthestRange)
							{
								FurthestRange = rawRange;
								NewTarget = potentialTarget;
							}
						}
					}
				}
			}			
		}		
		// End:0x50D
		if((NewTarget != none) && NewTarget != Target)
		{
			Target = NewTarget;
		}
	}
	// End:0x73C
	if(Target != none)
	{
		// End:0x5CD
		if(Target.Health <= 0)
		{
			Target = none;
			// End:0x5CB
			if(Seats[0].Gun.IsFiring())
			{
				Seats[0].Gun.EndFire(0);
				CurBurstCD = BurstCooldown;
			}
			return;
		}
		// End:0x69A
		if(Seats[0].Gun.IsFiring())
		{
			// End:0x697
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
			// End:0x73C
			if(CalculateTargetLocation(mortarTargetLoc, DeltaTime))
			{
				// End:0x73C
				if(bValidToss && (Normal(mortarTargetLoc - fireLoc) Dot Vector(FireRot)) >= 0.9900000)
				{
					CurBurstTime = 0.0000000;
					Seats[0].Gun.StartFire(0);
					return;
				}
			}
		}
	}
	// End:0x7AB
	if(Target == none)
	{
		LastAttackTime = WorldInfo.TimeSeconds;
		Seats[0].Gun.EndFire(0);
		return;
	}
	//return;	
}

simulated function bool CalculateTargetLocation(out Vector Loc, float DeltaTime)
{
	local Vector tossDirection, fireLoc;
	local Rotator FireRot;
	local Class<HaloProjectile> turretProj;

	// End:0x22E
	if(Target != none)
	{
		turretProj = Class<HaloProjectile>(Seats[0].Gun.WeaponProjectiles[0]);
		Mesh.GetSocketWorldLocationAndRotation('Turret_Fire', fireLoc, FireRot);
		bValidToss = SuggestTossVelocity(tossDirection, Target.Location, fireLoc, turretProj.default.Speed, turretProj.default.TossZ, TossZHint,, ((PhysicsVolume.bWaterVolume) ? PhysicsVolume.TerminalVelocity : turretProj.default.TerminalVelocity), WorldInfo.GetGravityZ() * turretProj.default.CustomGravityScaling);
		// End:0x1F2
		if(bValidToss)
		{
			ValidTossVec = tossDirection;
			ValidTossRot = Rotator(ValidTossVec);
		}
		tossDirection = Normal(tossDirection);
		Loc = fireLoc + (tossDirection * 1000.0000000);
		return true;
	}
	tossDirection = Normal(tossDirection);
	Loc = fireLoc + (tossDirection * 1000.0000000);
	return false;
	//return ReturnValue;	
}

simulated function Rotator GetAdjustedAim()
{
	local Vector tossDirection, fireLoc;
	local Rotator FireRot;
	local Class<HaloProjectile> turretProj;

	turretProj = Class<HaloProjectile>(Seats[0].Gun.WeaponProjectiles[0]);
	Mesh.GetSocketWorldLocationAndRotation('Turret_Fire', fireLoc, FireRot);
	// End:0x201
	if(bValidToss!)
	{
		bValidToss = SuggestTossVelocity(tossDirection, Target.Location, fireLoc, turretProj.default.Speed, turretProj.default.TossZ, TossZHint,, ((PhysicsVolume.bWaterVolume) ? PhysicsVolume.TerminalVelocity : turretProj.default.TerminalVelocity), WorldInfo.GetGravityZ() * turretProj.default.CustomGravityScaling);
		// End:0x1F2
		if(bValidToss)
		{
			ValidTossVec = tossDirection;
			ValidTossRot = Rotator(ValidTossVec);
		}
		return Rotator(tossDirection);		
	}
	else
	{
		return ValidTossRot;
	}
	//return ReturnValue;	
}

function Rotator GetWeaponAim(UTVehicleWeapon VWeapon)
{
	// End:0x1A
	if(VWeapon != none)
	{
		return GetAdjustedAim();
	}
	//return ReturnValue;	
}

simulated function DisplayTurretDebug()
{
	local Vector fireLoc, cylStart, cylEnd;
	local Rotator FireRot;

	GetBarrelLocationAndRotation(0, fireLoc, FireRot);
	cylStart = fireLoc;
	cylEnd = fireLoc;
	cylStart.Z -= AttackVerticalRange;
	cylEnd.Z += AttackVerticalRange;
	DrawDebugCylinder(cylStart, cylEnd, AttackMinHorizontalRange, 16, 0, 255, 0);
	super.DisplayTurretDebug();
	//return;	
}

function SetUpgrade(HaloUpgrade aUpgrade)
{
	local HaloUpgrade_Mortar Up;

	super.SetUpgrade(aUpgrade);
	Up = HaloUpgrade_Mortar(aUpgrade);
	// End:0x40
	if(Up == none)
	{
		return;
	}
	AttackMinHorizontalRange = Up.AttackRangeMin;
	//return;	
}

defaultproperties
{
	AttackMinHorizontalRange=3072.0000000
	TossZHint=0.7000000
	AttackHorizontalRange=10240.0000000
	AttackVerticalRange=7000.0000000
	UnmannedFireSpread=0.0000100
	MaxBurstTime=0.1000000
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloTurret_Mortar.BlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloTurret.BlokSpawnerComponent'
	begin object name="BlokSpawnerComponent"
	end object
	BlokSpawner=BlokSpawnerComponent
	AkExplosionSize="Explosion_Large"
	AkObjectType="UNSC_Mortar"
	TurretRecoilAnimName="mortar_fire"
	TurretAnimNodeName="FullBodySlot"
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloTurret_Mortar.MyHaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloTurret.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent"
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloTurret_Mortar.NeedleTarget'
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
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret_Mortar.MyLightEnvironment'
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
	DamageSmokeThreshold=0.2500000
	SpawnRadius=125.0000000
	TeamBeaconOffset=(X=60.0000000,Y=0.0000000,Z=0.0000000)
	DefaultFOV=80.0000000
	CameraLag=0.0700000
	ObjectiveGetOutDist=1500.0000000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloTurret_Mortar.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloTurret.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	bLookSteerOnAllPlatforms=true
	// Reference: UDKVehicleSimCar'MegaHaloGame.Default__HaloTurret_Mortar.SimObject'
	begin object name="SimObject" class=UDKBase.UDKVehicleSimCar
	end object
	SimObj=SimObject
	bCanFlip=true
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloTurret_Mortar.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'MegaHaloGame.Default__HaloTurret.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloTurret_Mortar.MyStayUprightConstraintInstance'
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
	Health=750
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloTurret_Mortar.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloTurret.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret_Mortar.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloTurret_Mortar.CollisionCylinder'
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
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloTurret_Mortar.targetableComponent'
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