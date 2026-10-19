class HaloBlokPickup extends HaloDroppedItemPickup;

var int BlokValue;
var float OnFootCollectionRadius;
var float InVehicleCollectionRadius;
var StaticMesh BlokMesh;
var ParticleSystem BlokParticles;
var Class<HaloCollectibleBlok> BlokClass;
var float OnFootCollectionRadiusSq;
var float InVehicleCollectionRadiusSq;
var float ZSpawnOffset;
var float BobCycleSize;
var float BobCycleDuration;
var Rotator MeshRotation;
var float BobCycleTimer;
var Pawn Pawn;
var export editinline HaloBlokCollectorComponent Collector;

event PostBeginPlay()
{
	RemoveCylinder();
	InitRotation();
	InitBobCycle();
	InitMeshAndParticles();
	OnFootCollectionRadiusSq = Square(OnFootCollectionRadius);
	InVehicleCollectionRadiusSq = Square(InVehicleCollectionRadius);
	//return;	
}

function RemoveCylinder()
{
	local editinline CylinderComponent CC;

	CC = CylinderComponent(CollisionComponent);
	// End:0x3E
	if(CC != none)
	{
		DetachComponent(CC);
	}
	CollisionComponent = none;
	//return;	
}

function InitRotation()
{
	MeshRotation.Roll = 0;
	MeshRotation.Pitch = int(float(45) * 182.0444031);
	MeshRotation.Yaw = int(RandRange(0.0000000, 360.0000000) * 182.0444031);
	PickupMesh.SetRotation(MeshRotation);
	//return;	
}

function InitBobCycle()
{
	BobMesh(RandRange(0.0000000, BobCycleDuration));
	//return;	
}

function InitMeshAndParticles()
{
	local Vector Offset;

	StaticMeshComponent(PickupMesh).SetStaticMesh(BlokMesh);
	Offset.Z = ZSpawnOffset;
	PickupParticles.SetTranslation(Offset);
	PickupParticles.SetTemplate(BlokParticles);
	PickupParticles.ActivateSystem();
	//return;	
}

function DroppedFrom(Pawn P)
{
	//return;	
}

function GiveTo(Pawn P)
{
	local HaloPlayerPawnController HPPC;

	HPPC = HaloPlayerPawnController(P.Controller);
	// End:0xA1
	if(HPPC != none)
	{
		// End:0xA1
		if(HPPC.BlokCollector != none)
		{
			HPPC.BlokCollector.AddToBank(BlokValue);
		}
	}
	PickedUpBy(P);
	//return;	
}

function float BotDesireability(Pawn Bot, Controller C)
{
	return MaxDesireability;
	//return ReturnValue;	
}

function BobMesh(float DeltaTime)
{
	local Vector NewLocation;
	local float SineVal, DeltaZ;

	BobCycleTimer += DeltaTime;
	J0x14:

	// End:0x42 [Loop If]
	if(BobCycleTimer >= BobCycleDuration)
	{
		BobCycleTimer -= BobCycleDuration;
		// [Loop Continue]
		goto J0x14;
	}
	SineVal = Sin(((BobCycleTimer / BobCycleDuration) * float(2)) * 3.1415927);
	DeltaZ = SineVal * BobCycleSize;
	NewLocation.X = Location.X;
	NewLocation.Y = Location.Y;
	NewLocation.Z = (Location.Z + ZSpawnOffset) + DeltaZ;
	PickupMesh.SetTranslation(NewLocation);
	//return;	
}

function RotateMesh(float DeltaTime)
{
	MeshRotation.Yaw += int((45.0000000 * DeltaTime) * 182.0444031);
	PickupMesh.SetRotation(MeshRotation);
	//return;	
}

function bool CanFindAPawnToFollow()
{
	local float DistSq, minDistSq, AttractRadiusSq;
	local Pawn PawnToFollow;
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC, PCToFollow;
	local editinline HaloBlokCollectorComponent CollectorToFollow;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x174
	if(Game != none)
	{
		minDistSq = ((OnFootCollectionRadiusSq > InVehicleCollectionRadiusSq) ? OnFootCollectionRadiusSq : InVehicleCollectionRadiusSq);
		// End:0x173
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x172
			if((PC != none) && PC.Pawn != none)
			{
				DistSq = VSizeSq(PC.Pawn.Location - Location);
				// End:0x172
				if(DistSq < minDistSq)
				{
					minDistSq = DistSq;
					PCToFollow = PC;
				}
			}			
		}		
	}
	// End:0x2F0
	if(PCToFollow != none)
	{
		PawnToFollow = ((PCToFollow.Pawn.Health > 0) ? PCToFollow.Pawn : none);
		// End:0x2F0
		if(PawnToFollow != none)
		{
			CollectorToFollow = PCToFollow.BlokCollector;
			// End:0x2F0
			if(CollectorToFollow != none)
			{
				AttractRadiusSq = ((PCToFollow.Pawn.IsA('HaloVehicle')) ? Square(CollectorToFollow.InVehicleAttractionRadius) : Square(CollectorToFollow.OnFootAttractionRadius));
				// End:0x2F0
				if(minDistSq < AttractRadiusSq)
				{
					Pawn = PawnToFollow;
					Collector = CollectorToFollow;
					return true;
				}
			}
		}
	}
	return false;
	//return ReturnValue;	
}

function bool SpawnCollectibleBlok()
{
	local HaloCollectibleBlok Blok;

	Blok = RequestBlok(BlokClass);
	// End:0x16D
	if(Blok != none)
	{
		Blok.Value = BlokValue;
		Blok.Pawn = Pawn;
		Blok.Collector = Collector;
		Blok.GotoState('Following');
		Blok.StaticMeshComponent.SetRBPosition(PickupMesh.Translation);
		Blok.StaticMeshComponent.SetRBRotation(PickupMesh.Rotation);
	}
	return Blok != none;
	//return ReturnValue;	
}

function HaloCollectibleBlok RequestBlok(Class<HaloCollectibleBlok> BlokType)
{
	local HaloGameDefault Game;
	local HaloCollectibleBlok HCB;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0xBF
	if(Game != none)
	{
		// End:0xBF
		if(Game.TheRAM != none)
		{
			HCB = HaloCollectibleBlok(Game.TheRAM.RequestActor(BlokType, self));
			return HCB;
		}
	}
	return none;
	//return ReturnValue;	
}

auto state Pickup
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.RemovePostRenderedActor(self);
		SetTickIsDisabled(false);
		//return;		
	}

	function bool ValidTouch(Pawn Other)
	{
		local HaloPlayerPawnController HPPC;

		HPPC = HaloPlayerPawnController(Other.Controller);
		return ((HPPC != none) && HPPC.BlokCollector != none) && super.ValidTouch(Other);
		//return ReturnValue;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x22
		if(CanFindAPawnToFollow())
		{
			// End:0x1F
			if(SpawnCollectibleBlok())
			{
				Destroy();
				return;
			}			
		}
		else
		{
			BobMesh(DeltaTime);
			RotateMesh(DeltaTime);
		}
		// End:0x6A
		if(PlayerCanSeeMe() == false)
		{
			// End:0x6A
			if(PlayerCanSeeMe(true) == false)
			{
				GotoState('Dormant');
			}
		}
		//return;		
	}
	stop;	
}

state Dormant
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.AddPostRenderedActor(self);
		SetTickIsDisabled(true);
		//return;		
	}

	simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
	{
		GotoState('Pickup');
		//return;		
	}
	stop;	
}

defaultproperties
{
	BlokValue=100
	OnFootCollectionRadius=300.0000000
	InVehicleCollectionRadius=900.0000000
	BlokMesh=StaticMesh'FX_Bricks.Meshes.1_Peg_Std'
	BlokParticles=ParticleSystem'FX_Bricks.Effects.FX_crumb_Block_Small'
	BlokClass=Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Bronze'
	ZSpawnOffset=60.0000000
	BobCycleSize=10.0000000
	BobCycleDuration=3.0000000
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloBlokPickup.BlokPickup'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokPickup'
	begin object name="BlokPickup" class=Engine.StaticMeshComponent
		StaticMesh=StaticMesh'FX_Bricks.Meshes.1_Peg_Std'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloBlokPickup.DroppedPickupLightEnvironment'
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		RBChannel=RBCC_Nothing
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		CollideActors=false
		AbsoluteTranslation=true
		AbsoluteRotation=true
		AbsoluteScale=true
	end object
	PickupMesh=BlokPickup
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloBlokPickup.Particle'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Particle'
	begin object name="Particle" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_Bricks.Effects.FX_crumb_Block_Small'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
		AbsoluteScale=true
	end object
	PickupParticles=Particle
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloBlokPickup.DroppedPickupLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DroppedPickupLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedItemPickup.DroppedPickupLightEnvironment'
	begin object name="DroppedPickupLightEnvironment"
	end object
	MyLightEnvironment=DroppedPickupLightEnvironment
	Components[0]=none
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloBlokPickup.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloDroppedItemPickup.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	Components[1]=CollisionCylinder
	Components[2]=BlokPickup
	Components[3]=Particle
	bCollideActors=false
	LifeSpan=0.0000000
	CollisionComponent=CollisionCylinder
}