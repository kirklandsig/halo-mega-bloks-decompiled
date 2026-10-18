class HaloCollectibleBlok extends KActorSpawnable;

var int Value;
var float CollectionTime;
var float ExpirationTime;
var float ExpirationTimer;
var float CollectRadius;
var Vector InitialCollectionVelocity;
var Pawn Pawn;
var export editinline HaloBlokCollectorComponent Collector;
var AkEvent FlyBlocksEvent;
var AkEvent PickupBlockEvent;
var MaterialInterface CollectionMaterial;
var export editinline ParticleSystemComponent FollowParticleComponent;

function bool HaveAPawnToFollow()
{
	// End:0x48
	if(((Pawn == none) || Pawn.Health <= 0) || Collector == none)
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function FindPawnToFollow()
{
	local float DistSq, minDistSq, AttractRadiusSq;
	local Pawn PawnToFollow;
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC, PCToFollow;
	local editinline HaloBlokCollectorComponent CollectorToFollow;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x1AE
	if(Game != none)
	{
		// End:0x1AD
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x1AC
			if((PC != none) && PC.Pawn != none)
			{
				// End:0x125
				if(PCToFollow == none)
				{
					minDistSq = VSizeSq(PC.Pawn.Location - Location);
					PCToFollow = PC;					
				}
				else
				{
					DistSq = VSizeSq(PC.Pawn.Location - Location);
					// End:0x1AC
					if(DistSq < minDistSq)
					{
						minDistSq = DistSq;
						PCToFollow = PC;
					}
				}
			}			
		}		
	}
	// End:0x33D
	if(PCToFollow != none)
	{
		PawnToFollow = ((PCToFollow.Pawn.Health > 0) ? PCToFollow.Pawn : none);
		// End:0x33D
		if(PawnToFollow != none)
		{
			CollectorToFollow = PCToFollow.BlokCollector;
			// End:0x33D
			if(CollectorToFollow != none)
			{
				AttractRadiusSq = ((PCToFollow.Pawn.IsA('HaloVehicle')) ? Square(CollectorToFollow.InVehicleAttractionRadius) : Square(CollectorToFollow.OnFootAttractionRadius));
				// End:0x33D
				if(minDistSq < AttractRadiusSq)
				{
					Pawn = PCToFollow.Pawn;
					Collector = CollectorToFollow;
				}
			}
		}
	}
	//return;	
}

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

	IVScalar = FClamp(ExpirationTimer / CollectionTime, 0.0000000, CollectionTime);
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
		StaticMeshComponent.SetRBLinearVelocity(vect(0.0000000, 0.0000000, 0.0000000), false);
		StaticMeshComponent.SetRBAngularVelocity(vect(0.0000000, 0.0000000, 0.0000000), false);
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		SetHidden(true);
		SetTickIsDisabled(true);
		SetPhysics(0);
		Pawn = none;
		Collector = none;
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
			GotoState('Rising');
		}
		//return;		
	}
	stop;	
}

state Rising
{
	event BeginState(name PreviousStateName)
	{
		StaticMeshComponent.SetRBCollidesWithChannel(0, true);
		StaticMeshComponent.SetRBCollidesWithChannel(15, true);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x1A
		if((HaveAPawnToFollow()) == false)
		{
			FindPawnToFollow();
		}
		// End:0x6A
		if(Velocity.Z <= float(0))
		{
			// End:0x5C
			if(HaveAPawnToFollow())
			{
				GotoState('Following');				
			}
			else
			{
				GotoState('PhysicsSim');
			}
		}
		super(Actor).Tick(DeltaTime);
		//return;		
	}
	stop;	
}

state PhysicsSim
{
	event BeginState(name PreviousStateName)
	{
		Pawn = none;
		Collector = none;
		ExpirationTimer = ExpirationTime;
		StaticMeshComponent.SetRBCollidesWithChannel(0, true);
		StaticMeshComponent.SetRBCollidesWithChannel(15, true);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		ExpirationTimer -= DeltaTime;
		// End:0x53
		if(ExpirationTimer <= 0.0000000)
		{
			HaloRecyclableActorManager(Owner).ReleaseActor(self);			
		}
		else
		{
			FindPawnToFollow();
			// End:0xA6
			if(HaveAPawnToFollow())
			{
				Pawn.PlayAkEvent(FlyBlocksEvent);
				GotoState('Following');
			}
		}
		super(Actor).Tick(DeltaTime);
		//return;		
	}
	stop;	
}

state Following
{
	event BeginState(name PreviousStateName)
	{
		CollectRadius = Square(Collector.CollectionRadius);
		FollowParticleComponent.ActivateSystem();
		FollowParticleComponent.SetFloatParameter('Hush', 1.0000000);
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x38
		if(HaveAPawnToFollow())
		{
			// End:0x2B
			if(CanBeCollected())
			{
				GotoState('Collected');				
			}
			else
			{
				FollowPawn();
			}			
		}
		else
		{
			GotoState('PhysicsSim');
		}
		super(Actor).Tick(DeltaTime);
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x36
		if(NextStateName == 'PhysicsSim')
		{
			FollowParticleComponent.DeactivateSystem();
		}
		//return;		
	}
	stop;	
}

state Collected
{
	event BeginState(name PreviousStateName)
	{
		local MaterialInstanceTimeVarying MITV;

		Collector.AddToBank(Value);
		Pawn.PlayAkEvent(PickupBlockEvent);
		// End:0x10D
		if(CollectionMaterial != none)
		{
			MITV = new (StaticMeshComponent) Class'Engine.MaterialInstanceTimeVarying';
			// End:0x10D
			if(MITV != none)
			{
				MITV.SetParent(CollectionMaterial);
				MITV.SetDuration(CollectionTime);
				StaticMeshComponent.SetMaterial(0, MITV);
			}
		}
		InitialCollectionVelocity = Velocity;
		ExpirationTimer = CollectionTime;
		StaticMeshComponent.SetRBCollidesWithChannel(0, false);
		StaticMeshComponent.SetRBCollidesWithChannel(15, false);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		ExpirationTimer -= DeltaTime;
		// End:0x53
		if(ExpirationTimer <= 0.0000000)
		{
			HaloRecyclableActorManager(Owner).ReleaseActor(self);			
		}
		else
		{
			FollowParticleComponent.SetFloatParameter('Hush', ExpirationTimer / CollectionTime);
			// End:0xCA
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
		StaticMeshComponent.SetMaterial(0, none);
		FollowParticleComponent.DeactivateSystem();
		//return;		
	}
	stop;	
}

defaultproperties
{
	CollectionTime=1.0000000
	ExpirationTime=30.0000000
	FlyBlocksEvent=AkEvent'UIHUD.Play_Pickup_Blocks_Fly'
	PickupBlockEvent=AkEvent'UIHUD.Play_Pickup_Blocks'
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloCollectibleBlok.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	FollowParticleComponent=ParticleSystemComponent0
	bWakeOnLevelStart=true
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloCollectibleBlok.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__KActorSpawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloCollectibleBlok.MyLightEnvironment'
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
		bIgnoreRadialImpulse=true
		bIgnoreRadialForce=true
		bIgnoreForceField=true
		RBCollideWithChannels=(Default=false,GameplayPhysics=false,EffectPhysics=false,BlockingVolume=false)
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloCollectibleBlok.MyLightEnvironment'
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