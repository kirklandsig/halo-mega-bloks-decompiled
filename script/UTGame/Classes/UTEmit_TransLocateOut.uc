class UTEmit_TransLocateOut extends UTReplicatedEmitter;

var float TLTrailKillWindow;
var ParticleSystem FirstPersonTemplate;

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// End:0xA1
	if(Owner != none)
	{
		Owner.TakeDamage(Damage, EventInstigator, Owner.Location - (Location - HitLocation), Momentum * 0.2500000, DamageType, HitInfo, DamageCauser);
	}
	return;
	//return;	
}

simulated function PostBeginPlay()
{
	// End:0x3F
	if(ParticleSystemComponent != none)
	{
		ParticleSystemComponent.__OnSystemFinished__Delegate = OnParticleSystemFinished;
	}
	SetTimer(TLTrailKillWindow, false);
	//return;	
}

simulated function Timer()
{
	CollisionComponent.SetActorCollision(false, false);
	RemoteRole = ROLE_None;
	// End:0x5A
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		Destroy();
	}
	//return;	
}

auto state FirstTick
{
	simulated function Tick(float DeltaTime)
	{
		// End:0x99
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x85
			if((Pawn(Owner) != none) && Pawn(Owner).IsFirstPerson())
			{
				SetTemplate(FirstPersonTemplate, true);				
			}
			else
			{
				SetTemplate(EmitterTemplate, true);
			}
		}
		GotoState('None');
		//return;		
	}
	stop;	
}

defaultproperties
{
	TLTrailKillWindow=0.1000000
	FirstPersonTemplate=ParticleSystem'Envy_Effects.Particles.P_Player_Spawn_Blue'
	EmitterTemplate=ParticleSystem'WP_Translocator.Particles.P_WP_Translocator_Teleport'
	// Reference: ParticleSystemComponent'UTGame.Default__UTEmit_TransLocateOut.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	// Archetype: ParticleSystemComponent'UTGame.Default__UTReplicatedEmitter.ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0"
		ReplacementPrimitive=none
	end object
	ParticleSystemComponent=ParticleSystemComponent0
	Components[0]=ParticleSystemComponent0
	// Reference: CylinderComponent'UTGame.Default__UTEmit_TransLocateOut.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=44.0000000
		CollisionRadius=21.0000000
		ReplacementPrimitive=none
	end object
	Components[1]=CollisionCylinder
	TickGroup=TG_PostAsyncWork
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bProjTarget=true
	CollisionComponent=CollisionCylinder
}