class HaloDestructibleBlok extends KActorSpawnable;

var float ExpirationTime;
var float ExpirationTimer;
var export editinline ParticleSystemComponent ParticleComponent;
var Actor DestructibleOwner;
var name AkObjectType;
var bool bPlayedCollisionSound;

event OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex)
{
	//return;	
}

simulated event Destroyed()
{
	WarnInternal(string(self) $ " has been destroyed instead of recycled, notifying the RAM");
	HaloRecyclableActorManager(Owner).ReleaseComponent(StaticMeshComponent.LightEnvironment, self);
	HaloRecyclableActorManager(Owner).RemoveActor(self);
	super(KActor).Destroyed();
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData Collision, int ContactIndex)
{
	//return;	
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	super(Actor).HitWall(HitNormal, Wall, WallComp);
	//return;	
}

auto state Inactive
{
	event BeginState(name PreviousStateName)
	{
		StaticMeshComponent.SetRBLinearVelocity(vect(0.0000000, 0.0000000, 0.0000000), false);
		StaticMeshComponent.SetRBAngularVelocity(vect(0.0000000, 0.0000000, 0.0000000), false);
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		StaticMeshComponent.SetRBCollidesWithChannel(9, false);
		SetHidden(true);
		SetTickIsDisabled(true);
		SetPhysics(0);
		bPlayedCollisionSound = false;
		//return;		
	}

	event EndState(name NextStateName)
	{
		SetHidden(false);
		SetTickIsDisabled(false);
		SetPhysics(10);
		//return;		
	}
	stop;	
}

state Spawning
{
	event Tick(float DeltaTime)
	{
		super(Actor).Tick(DeltaTime);
		// End:0x33
		if(IsZero(Velocity) == false)
		{
			GotoState('Moving');
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		StaticMeshComponent.SetRBCollidesWithChannel(0, true);
		StaticMeshComponent.SetRBCollidesWithChannel(15, true);
		StaticMeshComponent.SetRBCollidesWithChannel(9, true);
		//return;		
	}
	stop;	
}

state Moving
{
	event Tick(float DeltaTime)
	{
		super(Actor).Tick(DeltaTime);
		// End:0x47
		if(StaticMeshComponent.RigidBodyIsAwake() == false)
		{
			GotoState('Dying');
		}
		//return;		
	}

	event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
	{
		// End:0x4B
		if((OtherComponent == none) || OtherComponent.Owner != DestructibleOwner)
		{
			GotoState('Dying');
		}
		//return;		
	}
	stop;	
}

state Dying
{
	event BeginState(name PreviousStateName)
	{
		local int I;
		local Texture ColorMap, NormalMap;
		local MaterialInterface BaseMaterial;
		local MaterialInstanceTimeVarying MITV;

		I = 0;
		J0x0B:

		// End:0x1DD [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			BaseMaterial = StaticMeshComponent.GetMaterial(I);
			BaseMaterial.GetTextureParameterValue('CLR_Texture', ColorMap);
			BaseMaterial.GetTextureParameterValue('NRM_Texture', NormalMap);
			MITV = new (StaticMeshComponent) Class'Engine.MaterialInstanceTimeVarying';
			MITV.SetParent(MaterialInstanceTimeVarying'Shared_Destruction_Materials.Materials.Master.Destruct_BlokDestroy_MITV');
			MITV.SetDuration(ExpirationTime);
			MITV.SetTextureParameterValue('CLR_Texture', ColorMap);
			MITV.SetTextureParameterValue('NRM_Texture', NormalMap);
			StaticMeshComponent.SetMaterial(I, MITV);
			I++;
			// [Loop Continue]
			goto J0x0B;
		}
		ExpirationTimer = ExpirationTime;
		ParticleComponent.DeactivateSystem();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		ExpirationTimer -= DeltaTime;
		// End:0x97
		if(ExpirationTimer <= 0.0000000)
		{
			HaloRecyclableActorManager(Owner).ReleaseComponent(StaticMeshComponent.LightEnvironment, self);
			HaloRecyclableActorManager(Owner).ReleaseActor(self);
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		local int I;

		I = 0;
		J0x0B:

		// End:0x6F [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			StaticMeshComponent.SetMaterial(I, none);
			I++;
			// [Loop Continue]
			goto J0x0B;
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	ExpirationTime=5.0000000
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloDestructibleBlok.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	ParticleComponent=ParticleSystemComponent0
	bWakeOnLevelStart=true
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloDestructibleBlok.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__KActorSpawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDestructibleBlok.MyLightEnvironment'
		RBChannel=ERBCollisionChannel.RBCC_Untitled1
		CastShadow=false
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		CanBlockCamera=false
		bNotifyRigidBodyCollision=true
		bIgnoreRadialImpulse=true
		bIgnoreRadialForce=true
		bIgnoreForceField=true
		RBCollideWithChannels=(Default=false,GameplayPhysics=false,EffectPhysics=false,BlockingVolume=false)
		ScriptRigidBodyCollisionThreshold=0.1000000
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDestructibleBlok.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__KActorSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	GwNavObstacleComponentClassPath=""
	Components[0]=StaticMeshComponent0
	Components[1]=ParticleSystemComponent0
	bIgnoreRigidBodyPawns=true
	bOrientOnSlope=true
	bIgnoreEncroachers=true
	bCanStepUpOn=false
	bBlocksNavigation=false
	bCollideActors=false
	bBlockActors=false
	bPathColliding=false
	CollisionComponent=StaticMeshComponent0
}