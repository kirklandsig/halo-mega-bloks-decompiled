class Projectile extends Actor
	abstract
	native
	notplaceable;

var float Speed;
var float MaxSpeed;
var bool bSwitchToZeroCollision;
var bool bBlockedByInstigator;
var bool bBegunPlay;
var bool bRotationFollowsVelocity;
var bool bIgnoreFoliageTouch;
var Actor ZeroCollider;
var export editinline PrimitiveComponent ZeroColliderComponent;
var float Damage;
var float DamageRadius;
var float MomentumTransfer;
var Class<DamageType> MyDamageType;
var SoundCue SpawnSound;
var SoundCue ImpactSound;
var Controller InstigatorController;
var Actor ImpactedActor;
var float NetCullDistanceSquared;
var export editinline CylinderComponent CylinderComponent;
var float AISpeedOverride;

event bool EncroachingOn(Actor Other)
{
	// End:0x1A
	if(Brush(Other) != none)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

event PreBeginPlay()
{
	// End:0x37
	if(Instigator != none)
	{
		InstigatorController = Instigator.Controller;
	}
	super.PreBeginPlay();
	// End:0x10C
	if(((!bDeleteMe && InstigatorController != none) && InstigatorController.ShotTarget != none) && InstigatorController.ShotTarget.Controller != none)
	{
		InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning(self);
	}
	//return;	
}

simulated event PostBeginPlay()
{
	bBegunPlay = true;
	//return;	
}

// Export UProjectile::execInit(FFrame&, void* const)
native function Init(Vector Direction);

simulated function bool ReturnToNspacePool()
{
	return Destroy();
	//return ReturnValue;	
}

// Export UProjectile::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function bool CanSplash()
{
	return bBegunPlay;
	//return ReturnValue;	
}

function Reset()
{
	ReturnToNspacePool();
	//return;	
}

simulated function bool ProjectileHurtRadius(Vector HurtOrigin, Vector HitNormal)
{
	local Vector AltOrigin, TraceHitLocation, TraceHitNormal;
	local Actor TraceHitActor;

	// End:0x0F
	if(bHurtEntry)
	{
		return false;
	}
	AltOrigin = HurtOrigin;
	// End:0x14F
	if((ImpactedActor != none) && ImpactedActor.bWorldGeometry)
	{
		AltOrigin = HurtOrigin + ((2.0000000 * Class'Engine.Pawn'.default.MaxStepHeight) * HitNormal);
		TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, AltOrigin, HurtOrigin, false,,, 1);
		// End:0x11F
		if(TraceHitActor == none)
		{
			AltOrigin = HurtOrigin + (Class'Engine.Pawn'.default.MaxStepHeight * HitNormal);			
		}
		else
		{
			AltOrigin = HurtOrigin + (0.5000000 * (TraceHitLocation - HurtOrigin));
		}
	}
	return HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, AltOrigin);
	//return ReturnValue;	
}

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage)
{
	local bool bCausedDamage, bResult;

	// End:0x45
	if(bHurtEntry)
	{
		return false;
	}
	bCausedDamage = false;
	// End:0x73
	if(InstigatedByController == none)
	{
		InstigatedByController = InstigatorController;
	}
	// End:0x115
	if((ImpactedActor != none) && ImpactedActor != self)
	{
		ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, true, self);
		bCausedDamage = ImpactedActor.bProjTarget;
	}
	bResult = super.HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);
	return bResult || bCausedDamage;
	//return ReturnValue;	
}

singular simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x35
	if((Other == none) || Other.bDeleteMe)
	{
		return;
	}
	// End:0x5E
	if(bIgnoreFoliageTouch && InteractiveFoliageActor(Other) != none)
	{
		return;
	}
	// End:0x111
	if((Other.StopsProjectile(self) && (Role == ROLE_Authority) || bBegunPlay) && bBlockedByInstigator || Other != Instigator)
	{
		ImpactedActor = Other;
		ProcessTouch(Other, HitLocation, HitNormal);
		ImpactedActor = none;
	}
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// End:0xC9
	if(Other != Instigator)
	{
		// End:0xAD
		if(!Other.bStatic && DamageRadius == 0.0000000)
		{
			Other.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		}
		Explode(HitLocation, HitNormal);
	}
	//return;	
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;

	super.HitWall(HitNormal, Wall, WallComp);
	// End:0xEA
	if(Wall.bWorldGeometry)
	{
		HitStaticMesh = StaticMeshComponent(WallComp);
		// End:0xEA
		if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
		{
			NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
			// End:0xEA
			if(NewKActor != none)
			{
				Wall = NewKActor;
			}
		}
	}
	ImpactedActor = Wall;
	// End:0x191
	if(!Wall.bStatic && DamageRadius == float(0))
	{
		Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
	}
	Explode(Location, HitNormal);
	ImpactedActor = none;
	//return;	
}

simulated event EncroachedBy(Actor Other)
{
	HitWall(Normal(Location - Other.Location), Other, none);
	//return;	
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	// End:0x5D
	if((Damage > float(0)) && DamageRadius > float(0))
	{
		// End:0x41
		if(Role == ROLE_Authority)
		{
			MakeNoise(1.0000000);
		}
		ProjectileHurtRadius(HitLocation, HitNormal);
	}
	ReturnToNspacePool();
	//return;	
}

final simulated function RandSpin(float spinRate)
{
	RotationRate.Yaw = int(((spinRate * float(2)) * FRand()) - spinRate);
	RotationRate.Pitch = int(((spinRate * float(2)) * FRand()) - spinRate);
	RotationRate.Roll = int(((spinRate * float(2)) * FRand()) - spinRate);
	//return;	
}

function bool IsStationary()
{
	return false;
	//return ReturnValue;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	Explode(Location, vect(0.0000000, 0.0000000, 1.0000000));
	//return;	
}

simulated function float GetTimeToLocation(Vector TargetLoc)
{
	return VSize(TargetLoc - Location) / Speed;
	//return ReturnValue;	
}

static simulated function float StaticGetTimeToLocation(Vector TargetLoc, Vector StartLoc, Controller RequestedBy)
{
	return VSize(TargetLoc - StartLoc) / default.Speed;
	//return ReturnValue;	
}

static simulated function float GetRange()
{
	// End:0x1C
	if(default.LifeSpan == 0.0000000)
	{
		return 15000.0000000;		
	}
	else
	{
		return default.MaxSpeed * default.LifeSpan;
	}
	//return ReturnValue;	
}

simulated function ApplyFluidSurfaceImpact(FluidSurfaceActor Fluid, Vector HitLocation)
{
	super.ApplyFluidSurfaceImpact(Fluid, HitLocation);
	// End:0x119
	if(CanSplash())
	{
		// End:0x119
		if((((WorldInfo.NetMode != NM_DedicatedServer) && Instigator != none) && Instigator.IsPlayerPawn()) && Instigator.IsLocallyControlled())
		{
			WorldInfo.MyEmitterPool.SpawnEmitter(Fluid.ProjectileEntryEffect, HitLocation, Rotator(vect(0.0000000, 0.0000000, 1.0000000)), self);
		}
	}
	//return;	
}

defaultproperties
{
	Speed=2000.0000000
	MaxSpeed=2000.0000000
	bBlockedByInstigator=true
	DamageRadius=220.0000000
	MyDamageType=Class'Engine.DamageType'
	NetCullDistanceSquared=400000000.0000000
	// Reference: CylinderComponent'Engine.Default__Projectile.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=0.0000000
		CollisionRadius=0.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Physics=PHYS_Projectile
	RemoteRole=ROLE_SimulatedProxy
	CollisionType=COLLIDE_CustomDefault
	bNetTemporary=true
	bReplicateInstigator=true
	bGameRelevant=true
	bCanBeDamaged=true
	bCollideActors=true
	bCollideWorld=true
	NetPriority=2.5000000
	LifeSpan=14.0000000
	CollisionComponent=CollisionCylinder
}