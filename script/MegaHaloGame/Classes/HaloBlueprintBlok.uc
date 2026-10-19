class HaloBlueprintBlok extends KActorSpawnable;

var export editinline ParticleSystemComponent SpawningParticleSystem;
var export editinline ParticleSystemComponent FollowingParticleSystem;
var MaterialInterface FadingMaterial;
var AkEvent PickupSound;
var float MaxSecondsBeforeFollowingPawn;
var float SecondsSinceSpawn;
var float FadeDuration;
var float FadeTimer;
var float CollectRadius;
var Vector InitialCollectionVelocity;
var Pawn Pawn;
var export editinline HaloBlokCollectorComponent Collector;

function bool CanBeCollected()
{
	local Vector PawnLocation;

	PawnLocation = Pawn.Location;
	PawnLocation.Z += (Pawn.CylinderComponent.CollisionHeight * 0.5000000);
	// End:0xA6
	if(VSizeSq(Location - PawnLocation) < CollectRadius)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function FollowPawn()
{
	local Vector PawnLocation, Chase, nChase, Retard, nRetard;

	PawnLocation = Pawn.Location;
	PawnLocation.Z += (Pawn.CylinderComponent.CollisionHeight * 0.5000000);
	Chase = PawnLocation - Location;
	nChase = Normal(Chase);
	Retard = Velocity - (nChase * (Velocity Dot nChase));
	nRetard = Normal(Retard);
	StaticMeshComponent.RetardRBLinearVelocity(nRetard, Collector.CorrectionScalar);
	StaticMeshComponent.AddForce(Collector.AttractionScalar * nChase);
	//return;	
}

function InterpolateToPawn(float DeltaTime)
{
	local float IVScalar, LerpScalar;
	local Vector PawnLocation, Chase, Delta;

	IVScalar = FClamp(FadeTimer / FadeDuration, 0.0000000, FadeDuration);
	LerpScalar = 1.0000000 - IVScalar;
	PawnLocation = Pawn.Location;
	PawnLocation.Z += (Pawn.CylinderComponent.CollisionHeight * 0.5000000);
	Chase = PawnLocation - Location;
	Delta = ((InitialCollectionVelocity * IVScalar) * DeltaTime) + (Chase * LerpScalar);
	StaticMeshComponent.SetRBPosition(Location + Delta);
	//return;	
}

event OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex)
{
	//return;	
}

simulated event Destroyed()
{
	WarnInternal(string(self) $ " has been destroyed instead of recycled, notifying the RAM");
	HaloRecyclableActorManager(Owner).RemoveActor(self);
	super(KActor).Destroyed();
	//return;	
}

auto state Inactive
{
	event BeginState(name PreviousStateName)
	{
		SetHidden(true);
		StaticMeshComponent.SetHidden(true);
		SetTickIsDisabled(true);
		SetPhysics(0);
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		StaticMeshComponent.SetRBCollidesWithChannel(9, false);
		//return;		
	}

	event EndState(name NextStateName)
	{
		SetHidden(false);
		StaticMeshComponent.SetHidden(false);
		SetTickIsDisabled(false);
		SetPhysics(10);
		StaticMeshComponent.SetRBLinearVelocity(vect(0.0000000, 0.0000000, 0.0000000), false);
		StaticMeshComponent.SetRBAngularVelocity(vect(0.0000000, 0.0000000, 0.0000000), false);
		//return;		
	}
	stop;	
}

state Spawning
{
	event BeginState(name PreviousStateName)
	{
		SecondsSinceSpawn = 0.0000000;
		StaticMeshComponent.SetRBCollidesWithChannel(0, true);
		StaticMeshComponent.SetRBCollidesWithChannel(15, true);
		StaticMeshComponent.SetRBCollidesWithChannel(9, true);
		SpawningParticleSystem.ActivateSystem();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		super(Actor).Tick(DeltaTime);
		SecondsSinceSpawn += DeltaTime;
		// End:0x4C
		if(SecondsSinceSpawn >= MaxSecondsBeforeFollowingPawn)
		{
			GotoState('Following');
		}
		//return;		
	}

	event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
	{
		GotoState('Following');
		//return;		
	}

	event EndState(name NextStateName)
	{
		SpawningParticleSystem.DeactivateSystem();
		//return;		
	}
	stop;	
}

state Following
{
	event BeginState(name PreviousStateName)
	{
		// End:0x39
		if(Collector != none)
		{
			CollectRadius = Square(Collector.CollectionRadius);
		}
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		StaticMeshComponent.SetRBCollidesWithChannel(9, false);
		FollowingParticleSystem.ActivateSystem();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x31
		if((Pawn == none) || Collector == none)
		{
			GotoState('Fading');			
		}
		else
		{
			// End:0x4F
			if(CanBeCollected())
			{
				GotoState('Fading');				
			}
			else
			{
				FollowPawn();
			}
		}
		super(Actor).Tick(DeltaTime);
		//return;		
	}

	event EndState(name NextStateName)
	{
		FollowingParticleSystem.DeactivateSystem();
		//return;		
	}
	stop;	
}

state Fading
{
	event BeginState(name PreviousStateName)
	{
		local int I;
		local MaterialInstanceTimeVarying MITV;

		I = 0;
		J0x0B:

		// End:0xE7 [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			MITV = new (StaticMeshComponent) Class'Engine.MaterialInstanceTimeVarying';
			MITV.SetParent(FadingMaterial);
			MITV.SetDuration(FadeDuration);
			StaticMeshComponent.SetMaterial(I, MITV);
			I++;
			// [Loop Continue]
			goto J0x0B;
		}
		FadeTimer = FadeDuration;
		// End:0x137
		if(Pawn != none)
		{
			Pawn.PlayAkEvent(PickupSound);
		}
		InitialCollectionVelocity = Velocity;
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		StaticMeshComponent.SetRBCollidesWithChannel(9, false);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		FadeTimer -= DeltaTime;
		// End:0x53
		if(FadeTimer <= 0.0000000)
		{
			HaloRecyclableActorManager(Owner).ReleaseActor(self);			
		}
		else
		{
			// End:0x8E
			if(Pawn == none)
			{
				HaloRecyclableActorManager(Owner).ReleaseActor(self);				
			}
			else
			{
				InterpolateToPawn(DeltaTime);
			}
		}
		super(Actor).Tick(DeltaTime);
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
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloBlueprintBlok.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_Bricks.Effects.CollectBrickFX_2_Peg_Std'
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	SpawningParticleSystem=ParticleSystemComponent0
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloBlueprintBlok.ParticleSystemComponent1'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent1'
	begin object name="ParticleSystemComponent1" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_Bricks.Effects.CollectBrickFX_2_Peg_Std'
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	FollowingParticleSystem=ParticleSystemComponent1
	FadingMaterial=MaterialInstanceTimeVarying'FX_Bricks.Materials.MITV_Collect_2PEG_FadeOUT'
	MaxSecondsBeforeFollowingPawn=5.0000000
	FadeDuration=1.0000000
	bWakeOnLevelStart=true
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloBlueprintBlok.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__KActorSpawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		StaticMesh=StaticMesh'FX_Bricks.Meshes.1_Peg_Std_Silver'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloBlueprintBlok.MyLightEnvironment'
		RBChannel=RBCC_Untitled1
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
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloBlueprintBlok.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__KActorSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	GwNavObstacleComponentClassPath=""
	Components[0]=StaticMeshComponent0
	Components[1]=ParticleSystemComponent0
	Components[2]=ParticleSystemComponent1
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