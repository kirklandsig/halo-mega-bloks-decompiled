class MobileProjectile extends Projectile;

var float AccelRate;
var bool bShuttingDown;
var bool bInitOnSpawnWithRotation;
var bool bSuppressExplosionFX;
var export editinline ParticleSystemComponent ProjEffects;
var ParticleSystem ProjFlightTemplate;
var ParticleSystem ProjExplosionTemplate;
var float MaxEffectDistance;
var SoundCue ExplosionSound;
var array< Class<Actor> > ActorsToIgnoreWhenHit;

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
	HitWall(HitNormal, FloorActor, none);
	//return;	
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x28
	if(bDeleteMe || bShuttingDown)
	{
		return;
	}
	SpawnFlightEffects();
	// End:0x54
	if(bInitOnSpawnWithRotation)
	{
		Init(Vector(Rotation));
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
	Acceleration = AccelRate * Normal(Velocity);
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// End:0x37
	if(ActorsToIgnoreWhenHit.Find(Other.Class) != -1)
	{
		return;
	}
	// End:0x69
	if(DamageRadius > 0.0000000)
	{
		Explode(HitLocation, HitNormal);		
	}
	else
	{
		PlaySound(ImpactSound);
		Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		ShutDown();
	}
	//return;	
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	// End:0x8B
	if((Damage > float(0)) && DamageRadius > float(0))
	{
		// End:0x41
		if(int(Role) == int(ROLE_Authority))
		{
			MakeNoise(1.0000000);
		}
		// End:0x6C
		if(bShuttingDown!)
		{
			ProjectileHurtRadius(HitLocation, HitNormal);
		}
		SpawnExplosionEffects(HitLocation, HitNormal);		
	}
	else
	{
		PlaySound(ImpactSound);
	}
	ShutDown();
	//return;	
}

simulated function SpawnFlightEffects()
{
	// End:0x18E
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && ProjFlightTemplate != none)
	{
		ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate, true);
		ProjEffects.SetAbsolute(false, false, false);
		ProjEffects.SetLODLevel(((WorldInfo.bDropDetail) ? 1 : 0));
		ProjEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
		ProjEffects.bUpdateComponentInTick = true;
		ProjEffects.SetTickGroup(4);
		AttachComponent(ProjEffects);
		ProjEffects.ActivateSystem(true);
	}
	// End:0x1B6
	if(SpawnSound != none)
	{
		PlaySound(SpawnSound);
	}
	//return;	
}

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
	//return;	
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
	local editinline ParticleSystemComponent ProjExplosion;
	local Actor EffectAttachActor;

	// End:0x11A
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x10E
		if(EffectIsRelevant(Location, false, MaxEffectDistance))
		{
			// End:0xE6
			if(ProjExplosionTemplate != none)
			{
				EffectAttachActor = ImpactedActor;
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, Rotator(HitNormal), EffectAttachActor);
				SetExplosionEffectParameters(ProjExplosion);
			}
			// End:0x10E
			if(ExplosionSound != none)
			{
				PlaySound(ExplosionSound, true);
			}
		}
		bSuppressExplosionFX = true;
	}
	//return;	
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
	HideProjectile();
	SetCollision(false, false);
	Destroy();
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
	// End:0x6A
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
	// End:0x72
	if(PSC == ProjEffects)
	{
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

simulated function Pawn GetPawnOwner()
{
	//return ReturnValue;	
}

state WaitingForVelocity
{
	simulated function Tick(float DeltaTime)
	{
		// End:0x61
		if(IsZero(Velocity)!)
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
	AccelRate=15000.0000000
	bInitOnSpawnWithRotation=true
	MaxSpeed=5000.0000000
	Damage=10.0000000
	DamageRadius=0.0000000
	MomentumTransfer=500.0000000
	// Reference: CylinderComponent'UDKBase.Default__MobileProjectile.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Projectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	DrawScale=2.0000000
	LifeSpan=2.0000000
	CollisionComponent=CollisionCylinder
}