class HaloProjectile extends UTProjectile;

enum ETargetSearchMode
{
	TargetSearchMode_None,          // 0
	TargetSearchMode_Cone,          // 1
	TargetSearchMode_Trace,         // 2
	TargetSearchMode_Custom,        // 3
	TargetSearchMode_MAX            // 4
};

var HaloRecyclableActorManager MyRAM;
var byte TeamNum;
var HaloProjectile.ETargetSearchMode TargetSearchMode;
var HaloProjectile.ETargetSearchMode TargetSearchModeOverrideForAI;
var float TargetSearchRange;
var float TargetAngularSearchRange;
var export editinline HaloTargetableComponent SeekTargetsComponent;
var Vector SeekTargetOffset;
var float SeekingTurnRate;
var AkEvent PlayProjectileSoundEvent;
var AkEvent StopProjectileSoundEvent;
var AkEvent ProjectileTravelSoundEvent;
var AkEvent ProjectileImpactSoundEvent;
var bool bIsPlayingProjectileTravelSound;
var AkEvent BounceSoundEvent;
var AkEvent ExplodeSoundEvent;
var name AkExplosionType;
var name AkExplosionSize;
var name akWeaponType;
var name AkObjectType;

simulated function PreBeginPlay()
{
	LifeSpan = 0.0000000;
	MyRAM = HaloRecyclableActorManager(Owner);
	// End:0x44
	if(MyRAM == none)
	{
		super.PreBeginPlay();
	}
	SetSwitch('Surface', 'Concrete');
	//return;	
}

simulated function PostBeginPlay()
{
	local HaloPawn P;

	// End:0x2C
	if(MyRAM != none)
	{
		bSuppressExplosionFX = true;
		GotoState('Inactive');		
	}
	else
	{
		StartProjectileSound();
		super.PostBeginPlay();
		P = HaloPawn(Instigator);
		// End:0x93
		if(P != none)
		{
			TeamNum = P.TeamNum;
		}
	}
	//return;	
}

simulated function BeginReplay(Pawn NewInstigator, Vector NewLocation)
{
	local UTWeaponPawn WeaponPawn;
	local HaloPawn P;
	local editinline AudioComponent AmbientComponent;

	Instigator = NewInstigator;
	Damage = default.Damage;
	Speed = default.Speed;
	TargetSearchMode = default.TargetSearchMode;
	SetLocation(NewLocation);
	SetCollision(default.bCollideActors, default.bBlockActors);
	bCollideWorld = true;
	SetPhysics(6);
	SeekTarget = none;
	SeekTargetOffset = vect(0.0000000, 0.0000000, 0.0000000);
	bShuttingDown = false;
	bSuppressExplosionFX = false;
	GotoState('None');
	// End:0x135
	if(UTDummyPawn(Instigator) != none)
	{
		RemoteRole = ROLE_None;
		bSuppressSounds = UTDummyPawn(Instigator).FireAction.bSuppressSounds;
	}
	WeaponPawn = UTWeaponPawn(Instigator);
	// End:0x18B
	if(WeaponPawn != none)
	{
		InstigatorBaseVehicle = WeaponPawn.MyVehicle;		
	}
	else
	{
		// End:0x1EB
		if((Instigator != none) && Instigator.DrivenVehicle != none)
		{
			InstigatorBaseVehicle = Instigator.DrivenVehicle;			
		}
		else
		{
			InstigatorBaseVehicle = none;
		}
	}
	// End:0x230
	if(Instigator != none)
	{
		InstigatorController = Instigator.Controller;		
	}
	else
	{
		InstigatorController = none;
	}
	// End:0x306
	if(((!bDeleteMe && InstigatorController != none) && InstigatorController.ShotTarget != none) && InstigatorController.ShotTarget.Controller != none)
	{
		InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning(self);
	}
	StartProjectileSound();
	P = HaloPawn(Instigator);
	// End:0x366
	if(P != none)
	{
		TeamNum = P.TeamNum;		
	}
	else
	{
		TeamNum = 0;
	}
	// End:0x454
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x3A9
		if(!bWideCheck)
		{
			CheckRadius *= GlobalCheckRadiusTweak;
		}
		bWideCheck = bWideCheck || (((CheckRadius > float(0)) && Instigator != none) && UTPlayerController(Instigator.Controller) != none) && UTPlayerController(Instigator.Controller).AimingHelp(false);
	}
	// End:0x550
	if(((AmbientSound != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressSounds)
	{
		// End:0x550
		if(bImportantAmbientSound || !WorldInfo.bDropDetail && int(WorldInfo.GetDetailMode()) != int(0))
		{
			AmbientComponent = CreateAudioComponent(AmbientSound, true, true);
			// End:0x550
			if(AmbientComponent != none)
			{
				AmbientComponent.bShouldRemainActiveIfDropped = true;
			}
		}
	}
	SpawnFlightEffects();
	//return;	
}

function Init(Vector Direction)
{
	super.Init(Direction);
	FindTargetActor();
	// End:0x47
	if(default.LifeSpan > 0.0000000)
	{
		SetTimer(default.LifeSpan, false, 'ExplodeNow');
	}
	//return;	
}

simulated function ExplodeNow()
{
	Explode(Location, Vector(Rotation));
	//return;	
}

function InitForAI(Actor weaponOwner)
{
	local Class<HaloDamageType> HaloDamageClass;
	local HaloAIPawn ownerAIPawn;

	HaloDamageClass = Class<HaloDamageType>(MyDamageType);
	// End:0x54
	if(HaloDamageClass != none)
	{
		Damage *= HaloDamageClass.default.FromAIScaler;
	}
	ownerAIPawn = HaloAIPawn(weaponOwner);
	// End:0xA8
	if(ownerAIPawn != none)
	{
		Damage *= ownerAIPawn.DamageScale;
	}
	// End:0xCE
	if(AISpeedOverride > 0.0000000)
	{
		Speed = AISpeedOverride;
	}
	TargetSearchMode = TargetSearchModeOverrideForAI;
	//return;	
}

simulated function bool ReturnToNspacePool()
{
	// End:0x31
	if(MyRAM != none)
	{
		MyRAM.ReleaseActor(self);
		return true;
	}
	return Destroy();
	//return ReturnValue;	
}

simulated function Destroyed()
{
	GotoState('Inactive');
	//return;	
}

function FindTargetActor()
{
	switch(TargetSearchMode)
	{
		// End:0x25
		case 1:
			FindTargetActorByCone();
			// End:0x4C
			break;
		// End:0x37
		case 2:
			FindTargetActorByTrace();
			// End:0x4C
			break;
		// End:0x49
		case 3:
			FindTargetActorCustom();
			// End:0x4C
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function FindTargetActorByCone()
{
	local Actor TestActor;
	local editinline HaloTargetableComponent TestTarget;
	local int TestTeamNum;
	local float BestAngle, TestAngle;
	local Vector ToTestActor;

	// End:0x24D
	if(SeekTarget == none)
	{
		BestAngle = TargetAngularSearchRange;
		// End:0x24C
		foreach VisibleCollidingActors(Class'Engine.Actor', TestActor, TargetSearchRange, Location)
		{
			// End:0x6C
			if(TestActor == Instigator)
			{
				continue;				
			}
			TestTarget = HaloTargetableComponent(TestActor.GetComponentOfType(Class'MegaHaloGame.HaloTargetableComponent'));
			// End:0xBA
			if(TestTarget == none)
			{
				continue;				
			}
			// End:0xE0
			if(TestTarget.IsDead())
			{
				continue;				
			}
			TestTeamNum = int(TestTarget.GetTeamNum());
			// End:0x139
			if((TestTeamNum == 0) || TestTeamNum == int(TeamNum))
			{
				continue;				
			}
			ToTestActor = TestActor.Location - Location;
			// End:0x24B
			if(VSizeSq(ToTestActor) > 0.1000000)
			{
				TestAngle = RDiff(Rotation, Rotator(ToTestActor));
				// End:0x24B
				if(TestAngle < BestAngle)
				{
					SeekTarget = TestActor;
					SeekTargetsComponent = TestTarget;
					SeekTargetOffset = TestTarget.GetAimLocation(Location) - TestActor.Location;
					BestAngle = TestAngle;
				}
			}			
		}		
	}
	//return;	
}

function FindTargetActorByTrace()
{
	local Vector TraceStart, TraceEnd;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local HaloPawn P;
	local HaloVehicleInterface VI;
	local int hitTeamNum;

	TraceStart = Location;
	TraceEnd = Location + (TargetSearchRange * Vector(Rotation));
	HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);
	P = HaloPawn(HitActor);
	// End:0xCB
	if(P != none)
	{
		hitTeamNum = int(P.TeamNum);		
	}
	else
	{
		VI = HaloVehicleInterface(HitActor);
		// End:0x134
		if(NotEqual_InterfaceInterface(VI, HaloVehicleInterface(none)))
		{
			hitTeamNum = VI.GetDriverTeamNum();			
		}
		else
		{
			return;
		}
	}
	// End:0x162
	if((hitTeamNum <= 0) || hitTeamNum == int(TeamNum))
	{
		return;
	}
	SeekTarget = Pawn(HitActor);
	// End:0x1C0
	if(SeekTarget != none)
	{
		SeekTargetOffset = HitLocation - HitActor.Location;
	}
	//return;	
}

function FindTargetActorCustom()
{
	//return;	
}

function Tick(float DeltaTime)
{
	TickTargetSeeking(DeltaTime);
	super(Actor).Tick(DeltaTime);
	//return;	
}

function TickTargetSeeking(float DeltaTime)
{
	local Vector ToTarget;
	local Rotator NewRot;

	// End:0x49
	if((SeekTargetsComponent != none) && SeekTargetsComponent.IsDead())
	{
		SeekTarget = none;
		SeekTargetsComponent = none;
	}
	// End:0x156
	if(SeekTarget != none)
	{
		ToTarget = (SeekTarget.Location + SeekTargetOffset) - Location;
		// End:0xDA
		if((int(TargetSearchMode) == int(2)) && (ToTarget Dot Vector(Rotation)) < 0.0000000)
		{
			SeekTarget = none;			
		}
		else
		{
			// End:0x156
			if(VSizeSq(ToTarget) > 0.1000000)
			{
				NewRot = RInterpTo(Rotation, Rotator(ToTarget), DeltaTime, SeekingTurnRate, true);
				SetRotation(NewRot);
				Velocity = Vector(NewRot) * Speed;
			}
		}
	}
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local array<ImpactInfo> ImpactList;
	local Vector DirTrace, StartTrace, EndTrace, velocityOut, shieldCenterToHit;

	local bool processed;
	local Pawn HitPawn;
	local HaloDestructibleActor HitShield;

	HitPawn = Pawn(Other);
	HitShield = HaloDestructibleActor(Other);
	processed = false;
	// End:0x82
	if(DamageRadius > 0.0000000)
	{
		Explode(HitLocation, HitNormal);
		processed = true;		
	}
	else
	{
		// End:0x1CD
		if((HitShield != none) && HitShield.bPassShotsFromWithin)
		{
			velocityOut.X = Velocity.X;
			velocityOut.Y = Velocity.Y;
			velocityOut.Z = 0.0000000;
			shieldCenterToHit = HitShield.Location - HitLocation;
			shieldCenterToHit.Z = 0.0000000;
			// End:0x1CA
			if((Normal(velocityOut) Dot Normal(shieldCenterToHit)) < float(0))
			{
				processed = true;
			}			
		}
		else
		{
			// End:0x3AC
			if((HitPawn != none) && HitPawn.Mesh != none)
			{
				// End:0x224
				if(SeekTarget == HitPawn)
				{
					SeekTarget = none;
				}
				// End:0x251
				if(VSizeSq(Velocity) > 0.1000000)
				{
					DirTrace = Normal(Velocity);					
				}
				else
				{
					DirTrace = vect(0.0000000, 0.0000000, -1.0000000);
				}
				StartTrace = Location - (100.0000000 * DirTrace);
				EndTrace = Location + (100.0000000 * DirTrace);
				// End:0x3AC
				if(TraceAllPhysicsAssetInteractions(HitPawn.Mesh, EndTrace, StartTrace, ImpactList))
				{
					// End:0x3AC
					if(ImpactList.Length > 0)
					{
						HitPawn.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, ImpactList[0].HitInfo, self);
						ShutDown();
						PlayImpactSound('Concrete');
						processed = true;
					}
				}
			}
		}
	}
	// End:0x435
	if(!processed)
	{
		Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		PlayImpactSound('Concrete');
		ShutDown();
	}
	//return;	
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
	LastRenderTime = WorldInfo.TimeSeconds;
	super.SpawnExplosionEffects(HitLocation, HitNormal);
	// End:0x70
	if(!bSuppressSounds)
	{
		PlayExplosionSound();
		PlayImpactSound('Concrete');
	}
	//return;	
}

simulated function StartProjectileSound()
{
	// End:0x69
	if(PlayProjectileSoundEvent != none)
	{
		SetSwitch('Weapon_Type', akWeaponType);
		PlayAkEvent(PlayProjectileSoundEvent);
		PlayAkEvent(ProjectileTravelSoundEvent);
		bIsPlayingProjectileTravelSound = true;
	}
	//return;	
}

simulated function StopProjectileSound()
{
	// End:0x44
	if(StopProjectileSoundEvent != none)
	{
		SetSwitch('Weapon_Type', akWeaponType);
		PlayAkEvent(StopProjectileSoundEvent);
	}
	//return;	
}

simulated function PlayBounceSound(name Material)
{
	// End:0x60
	if(BounceSoundEvent != none)
	{
		SetSwitch('Object_Type', AkObjectType);
		SetSwitch('Surface', Material);
		PlayAkEvent(BounceSoundEvent);
	}
	//return;	
}

simulated function PlayImpactSound(name Surface)
{
	SetSwitch('Weapon_Type', akWeaponType);
	SetSwitch('Surface', Surface);
	PlayAkEvent(ProjectileImpactSoundEvent);
	//return;	
}

simulated function PlayExplosionSound()
{
	// End:0x60
	if(ExplodeSoundEvent != none)
	{
		SetSwitch('Explosion_Type', AkExplosionType);
		SetSwitch('Explosion_Size', AkExplosionSize);
		PlayAkEvent(ExplodeSoundEvent);
	}
	//return;	
}

simulated function ShutDown()
{
	local Vector HitLocation, HitNormal;

	bShuttingDown = true;
	HitNormal = Normal(Velocity * float(-1));
	Trace(HitLocation, HitNormal, Location + (HitNormal * float(-32)), Location + (HitNormal * float(32)), true, vect(0.0000000, 0.0000000, 0.0000000));
	// End:0xB4
	if(ProjEffects != none)
	{
		ProjEffects.DeactivateSystem();
	}
	// End:0x10A
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX)
	{
		SpawnExplosionEffects(Location, HitNormal);
	}
	HideProjectile();
	SetCollision(false, false);
	SeekTarget = none;
	// End:0x207
	if(bWaitForEffects)
	{
		SetPhysics(0);
		// End:0x1A3
		if(bNetTemporary)
		{
			// End:0x17A
			if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
			{
				ReturnToNspacePool();				
			}
			else
			{
				RemoteRole = ROLE_None;
				LifeSpan = FMax(LifeSpan, 2.0000000);
			}			
		}
		else
		{
			bTearOff = true;
			// End:0x1EA
			if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
			{
				LifeSpan = 0.1500000;				
			}
			else
			{
				LifeSpan = FMax(LifeSpan, 2.0000000);
			}
		}		
	}
	else
	{
		GotoState('DestroyMeLater');
	}
	//return;	
}

simulated state Inactive
{
	ignores Tick;

	simulated event BeginState(name PrevStateName)
	{
		// End:0x23
		if(bIsPlayingProjectileTravelSound)
		{
			StopProjectileSound();
			bIsPlayingProjectileTravelSound = false;
		}
		ClearTimer('ExplodeNow');
		// End:0x98
		if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX)
		{
			SpawnExplosionEffects(Location, Vector(Rotation) * float(-1));
		}
		// End:0x102
		if(ProjEffects != none)
		{
			DetachComponent(ProjEffects);
			WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
			ProjEffects = none;
		}
		SetPhysics(0);
		SetHidden(true);
		SetTickIsDisabled(true);
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		SetHidden(false);
		SetTickIsDisabled(false);
		//return;		
	}
	stop;	
}

simulated state DestroyMeLater
{Begin:

	SetPhysics(0);
	Sleep(0.1500000);
	ReturnToNspacePool();
	stop;					
}

defaultproperties
{
	PlayProjectileSoundEvent=AkEvent'Weapons.Play_Projectile_Launch'
	StopProjectileSoundEvent=AkEvent'Weapons.Stop_Projectile_Travel'
	ProjectileTravelSoundEvent=AkEvent'Weapons.Play_Projectile_Travel'
	ProjectileImpactSoundEvent=AkEvent'Weapons.Play_Projectile_Impact'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}