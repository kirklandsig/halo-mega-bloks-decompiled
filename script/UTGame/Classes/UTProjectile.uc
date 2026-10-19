class UTProjectile extends UDKProjectile
	abstract;

var bool bSuppressSounds;
var bool bImportantAmbientSound;
var bool bAdvanceExplosionEffect;
var bool bSuppressExplosionFX;
var bool bWaitForEffects;
var bool bAttachExplosionToVehicles;
var SoundCue AmbientSound;
var SoundCue ExplosionSound;
var export editinline ParticleSystemComponent ProjEffects;
var ParticleSystem ProjFlightTemplate;
var ParticleSystem ProjExplosionTemplate;
var MaterialInterface ExplosionDecal;
var float DecalWidth;
var float DecalHeight;
var float DurationOfDecal;
var name DecalDissolveParamName;
var float MaxEffectDistance;
var float TossZ;
var float GlobalCheckRadiusTweak;
var Class<PointLightComponent> ProjectileLightClass;
var export editinline PointLightComponent ProjectileLight;
var Class<UDKExplosionLight> ExplosionLightClass;
var float MaxExplosionLightDistance;

simulated event CreateProjectileLight()
{
	// End:0x24
	if(WorldInfo.bDropDetail)
	{
		return;
	}
	ProjectileLight = new (self) ProjectileLightClass;
	AttachComponent(ProjectileLight);
	//return;	
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
	HitWall(HitNormal, FloorActor, none);
	//return;	
}

simulated function bool CanSplash()
{
	return false;
	//return ReturnValue;	
}

event PreBeginPlay()
{
	local UTWeaponPawn WeaponPawn;

	// End:0x6C
	if(UTDummyPawn(Instigator) != none)
	{
		RemoteRole = ROLE_None;
		bSuppressSounds = UTDummyPawn(Instigator).FireAction.bSuppressSounds;
	}
	WeaponPawn = UTWeaponPawn(Instigator);
	// End:0xC2
	if(WeaponPawn != none)
	{
		InstigatorBaseVehicle = WeaponPawn.MyVehicle;		
	}
	else
	{
		// End:0x11F
		if((Instigator != none) && Instigator.DrivenVehicle != none)
		{
			InstigatorBaseVehicle = Instigator.DrivenVehicle;
		}
	}
	super(Projectile).PreBeginPlay();
	//return;	
}

simulated function PostBeginPlay()
{
	local editinline AudioComponent AmbientComponent;

	// End:0xE2
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x37
		if(!bWideCheck)
		{
			CheckRadius *= GlobalCheckRadiusTweak;
		}
		bWideCheck = bWideCheck || (((CheckRadius > float(0)) && Instigator != none) && UTPlayerController(Instigator.Controller) != none) && UTPlayerController(Instigator.Controller).AimingHelp(false);
	}
	super(Projectile).PostBeginPlay();
	// End:0x10A
	if(bDeleteMe || bShuttingDown)
	{
		return;
	}
	// End:0x206
	if(((AmbientSound != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressSounds)
	{
		// End:0x206
		if(bImportantAmbientSound || !WorldInfo.bDropDetail && int(WorldInfo.GetDetailMode()) != int(0))
		{
			AmbientComponent = CreateAudioComponent(AmbientSound, true, true);
			// End:0x206
			if(AmbientComponent != none)
			{
				AmbientComponent.bShouldRemainActiveIfDropped = true;
			}
		}
	}
	SpawnFlightEffects();
	// End:0x259
	if(WorldInfo.IsConsoleBuild(3))
	{
		LifeSpan = FMin(LifeSpan, 0.5000000 * default.LifeSpan);
	}
	//return;	
}

simulated event SetInitialState()
{
	bScriptInitialized = true;
	// End:0x46
	if((int(Role) < int(ROLE_Authority)) && AccelRate != 0.0000000)
	{
		GotoState('WaitingForVelocity');		
	}
	else
	{
		GotoState(((InitialState != 'None') ? InitialState : 'Auto'));
	}
	//return;	
}

function Init(Vector Direction)
{
	SetRotation(Rotator(Direction));
	Velocity = Speed * Direction;
	Velocity.Z += TossZ;
	Acceleration = AccelRate * Normal(Velocity);
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// End:0x32
	if(DamageRadius > 0.0000000)
	{
		Explode(HitLocation, HitNormal);		
	}
	else
	{
		Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		ShutDown();
	}
	//return;	
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	// End:0x6C
	if((Damage > float(0)) && DamageRadius > float(0))
	{
		// End:0x41
		if(int(Role) == int(ROLE_Authority))
		{
			MakeNoise(1.0000000);
		}
		// End:0x6C
		if(!bShuttingDown)
		{
			ProjectileHurtRadius(HitLocation, HitNormal);
		}
	}
	SpawnExplosionEffects(HitLocation, HitNormal);
	ShutDown();
	//return;	
}

simulated function SpawnFlightEffects()
{
	// End:0x14D
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && ProjFlightTemplate != none)
	{
		ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
		ProjEffects.SetAbsolute(false, false, false);
		ProjEffects.SetLODLevel(((WorldInfo.bDropDetail) ? 1 : 0));
		ProjEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
		ProjEffects.bUpdateComponentInTick = true;
		AttachComponent(ProjEffects);
	}
	//return;	
}

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
	//return;	
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
	local Vector LightLoc, LightHitLocation, LightHitNormal, Direction;
	local editinline ParticleSystemComponent ProjExplosion;
	local Actor EffectAttachActor;
	local MaterialInstanceTimeVarying MITV_Decal;

	// End:0x65D
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x56
		if(ProjectileLight != none)
		{
			DetachComponent(ProjectileLight);
			ProjectileLight = none;
		}
		// End:0x618
		if((ProjExplosionTemplate != none) && EffectIsRelevant(Location, false, MaxEffectDistance))
		{
			EffectAttachActor = none;
			// End:0x10C
			if(!bAdvanceExplosionEffect)
			{
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, Rotator(HitNormal), EffectAttachActor);				
			}
			else
			{
				Direction = Normal(Velocity - ((2.0000000 * HitNormal) * (Velocity Dot HitNormal))) * vect(1.0000000, 1.0000000, 0.0000000);
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, Rotator(Direction), EffectAttachActor);
				ProjExplosion.SetVectorParameter('Velocity', Direction);
				ProjExplosion.SetVectorParameter('HitNormal', HitNormal);
			}
			SetExplosionEffectParameters(ProjExplosion);
			// End:0x618
			if((!WorldInfo.bDropDetail && (ExplosionLightClass != none) || ExplosionDecal != none) && ShouldSpawnExplosionLight(HitLocation, HitNormal))
			{
				// End:0x45F
				if(ExplosionLightClass != none)
				{
					// End:0x3A5
					if(Trace(LightHitLocation, LightHitNormal, HitLocation + ((0.2500000 * ExplosionLightClass.default.TimeShift[0].Radius) * HitNormal), HitLocation, false) == none)
					{
						LightLoc = HitLocation + ((0.2500000 * ExplosionLightClass.default.TimeShift[0].Radius) * (vect(1.0000000, 0.0000000, 0.0000000) >> ProjExplosion.Rotation));						
					}
					else
					{
						LightLoc = HitLocation + ((0.5000000 * VSize(HitLocation - LightHitLocation)) * (vect(1.0000000, 0.0000000, 0.0000000) >> ProjExplosion.Rotation));
					}
					UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ExplosionLightClass, LightLoc, EffectAttachActor);
				}
				// End:0x618
				if((ExplosionDecal != none) && Pawn(ImpactedActor) == none)
				{
					// End:0x5A2
					if(MaterialInstanceTimeVarying(ExplosionDecal) != none)
					{
						// End:0x59F
						if(Terrain(ImpactedActor) == none)
						{
							MITV_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
							MITV_Decal.SetParent(ExplosionDecal);
							WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, Rotator(-HitNormal), DecalWidth, DecalHeight, 10.0000000, false);
							MITV_Decal.SetScalarStartTime(DecalDissolveParamName, DurationOfDecal);
						}						
					}
					else
					{
						WorldInfo.MyDecalManager.SpawnDecal(ExplosionDecal, HitLocation, Rotator(-HitNormal), DecalWidth, DecalHeight, 10.0000000, true);
					}
				}
			}
		}
		// End:0x651
		if((ExplosionSound != none) && !bSuppressSounds)
		{
			PlaySound(ExplosionSound, true);
		}
		bSuppressExplosionFX = true;
	}
	//return;	
}

simulated function bool ShouldSpawnExplosionLight(Vector HitLocation, Vector HitNormal)
{
	local PlayerController P;
	local float Dist;

	// End:0x14A
	foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
	{
		Dist = VSize(P.ViewTarget.Location - Location);
		// End:0x149
		if(((P.Pawn == Instigator) || Dist < ExplosionLightClass.default.Radius) || (Dist < MaxExplosionLightDistance) && (Vector(P.Rotation) Dot (Location - P.ViewTarget.Location)) > float(0))
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

simulated function ShutDown()
{
	local Vector HitLocation, HitNormal;

	bShuttingDown = true;
	HitNormal = Normal(Velocity * float(-1));
	Trace(HitLocation, HitNormal, Location + (HitNormal * float(-32)), Location + (HitNormal * float(32)), true, vect(0.0000000, 0.0000000, 0.0000000));
	SetPhysics(0);
	// End:0xB9
	if(ProjEffects != none)
	{
		ProjEffects.DeactivateSystem();
	}
	// End:0x10F
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX)
	{
		SpawnExplosionEffects(Location, HitNormal);
	}
	HideProjectile();
	SetCollision(false, false);
	// End:0x1FC
	if(bWaitForEffects)
	{
		// End:0x198
		if(bNetTemporary)
		{
			// End:0x16F
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
			// End:0x1DF
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
		ReturnToNspacePool();
	}
	//return;	
}

event TornOff()
{
	ShutDown();
	super(Actor).TornOff();
	//return;	
}

simulated function HideProjectile()
{
	local editinline MeshComponent ComponentIt;

	// End:0x40
	foreach ComponentList(Class'Engine.MeshComponent', ComponentIt)
	{
		ComponentIt.SetHidden(true);		
	}	
	//return;	
}

simulated function Destroyed()
{
	// End:0x61
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX)
	{
		SpawnExplosionEffects(Location, Vector(Rotation) * float(-1));
	}
	// End:0xCB
	if(ProjEffects != none)
	{
		DetachComponent(ProjEffects);
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
		ProjEffects = none;
	}
	super(Actor).Destroyed();
	//return;	
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
	// End:0xAA
	if(PSC == ProjEffects)
	{
		// End:0x4F
		if(bWaitForEffects)
		{
			// End:0x43
			if(bShuttingDown)
			{
				LifeSpan = 0.0100000;				
			}
			else
			{
				bWaitForEffects = false;
			}
		}
		DetachComponent(ProjEffects);
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
		ProjEffects = none;
	}
	//return;	
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
	out_CamLoc = Location + (CylinderComponent.CollisionHeight * vect(0.0000000, 0.0000000, 1.0000000));
	return true;
	//return ReturnValue;	
}

event Actor GetHomingTarget(UTProjectile Seeker, Controller InstigatedBy)
{
	return self;
	//return ReturnValue;	
}

simulated function Pawn GetPawnOwner()
{
	//return ReturnValue;	
}

static final function float CalculateTravelTime(float Dist, float MoveSpeed, float MaxMoveSpeed, float AccelMag)
{
	local float ProjTime, AccelTime, AccelDist;

	// End:0x2B
	if(AccelMag == 0.0000000)
	{
		return Dist / MoveSpeed;		
	}
	else
	{
		ProjTime = (-MoveSpeed + Sqrt(Square(MoveSpeed) - ((2.0000000 * AccelMag) * -Dist))) / AccelMag;
		AccelTime = (MaxMoveSpeed - MoveSpeed) / AccelMag;
		// End:0x12A
		if(ProjTime > AccelTime)
		{
			AccelDist = (MoveSpeed * AccelTime) + ((0.5000000 * AccelMag) * Square(AccelTime));
			ProjTime = AccelTime + ((Dist - AccelDist) / MaxMoveSpeed);
		}
		return ProjTime;
	}
	//return ReturnValue;	
}

static simulated function float StaticGetTimeToLocation(Vector TargetLoc, Vector StartLoc, Controller RequestedBy)
{
	return CalculateTravelTime(VSize(TargetLoc - StartLoc), default.Speed, default.MaxSpeed, default.AccelRate);
	//return ReturnValue;	
}

simulated function float GetTimeToLocation(Vector TargetLoc)
{
	return CalculateTravelTime(VSize(TargetLoc - Location), Speed, MaxSpeed, AccelRate);
	//return ReturnValue;	
}

static simulated function float GetRange()
{
	local float AccelTime;

	// End:0x1C
	if(default.LifeSpan == 0.0000000)
	{
		return 15000.0000000;		
	}
	else
	{
		// End:0x47
		if(default.AccelRate == 0.0000000)
		{
			return default.Speed * default.LifeSpan;			
		}
		else
		{
			AccelTime = (default.MaxSpeed - default.Speed) / default.AccelRate;
			// End:0xE8
			if(AccelTime < default.LifeSpan)
			{
				return ((((0.5000000 * default.AccelRate) * AccelTime) * AccelTime) + (default.Speed * AccelTime)) + (default.MaxSpeed * (default.LifeSpan - AccelTime));				
			}
			else
			{
				return (((0.5000000 * default.AccelRate) * default.LifeSpan) * default.LifeSpan) + (default.Speed * default.LifeSpan);
			}
		}
	}
	//return ReturnValue;	
}

state WaitingForVelocity
{
	simulated function Tick(float DeltaTime)
	{
		// End:0x61
		if(!IsZero(Velocity))
		{
			Acceleration = AccelRate * Normal(Velocity);
			GotoState(((InitialState != 'None') ? InitialState : 'Auto'));
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bAttachExplosionToVehicles=true
	DurationOfDecal=24.0000000
	DecalDissolveParamName="DissolveAmount"
	MaxEffectDistance=10000.0000000
	GlobalCheckRadiusTweak=0.5000000
	MaxExplosionLightDistance=4000.0000000
	TerminalVelocity=3500.0000000
	CustomGravityScaling=1.0000000
	bSwitchToZeroCollision=true
	bBlockedByInstigator=false
	DamageRadius=0.0000000
	// Reference: CylinderComponent'UTGame.Default__UTProjectile.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UDKBase.Default__UDKProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	bCollideComplex=true
	CollisionComponent=CollisionCylinder
}