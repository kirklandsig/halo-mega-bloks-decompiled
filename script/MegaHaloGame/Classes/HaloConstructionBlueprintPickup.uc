class HaloConstructionBlueprintPickup extends HaloDroppedItemPickup;

var HaloConstructionManager.EHaloConstructionTypes ConstructionType;
var export editinline ParticleSystemComponent BlueprintParticleComponent;
var AkEvent PlayIdleSound;
var AkEvent StopIdleSound;
var AkEvent ActivateSound;
var ParticleSystem DeathParticleSystem;
var export editinline HaloBlueprintBlokSpawnerComponent BlokSpawner;

event PostBeginPlay()
{
	// End:0x44
	if(BlueprintParticleComponent.Template != none)
	{
		BlueprintParticleComponent.ActivateSystem();
	}
	PlayAkEvent(PlayIdleSound);
	//return;	
}

singular event Destroyed()
{
	local editinline ParticleSystemComponent PSC;

	PSC = WorldInfo.MyEmitterPool.SpawnEmitter(DeathParticleSystem, Location, Rotation);
	PSC.CastShadow = false;
	PSC.bCastDynamicShadow = false;
	PSC.bCastStaticShadow = false;
	PSC.bAcceptsDynamicDominantLightShadows = false;
	BlokSpawner.ThrowBloks();
	super(UTDroppedItemPickup).Destroyed();
	//return;	
}

function DroppedFrom(Pawn P)
{
	//return;	
}

function GiveTo(Pawn P)
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	Game.GetConstructionManager().AddBlueprint(self);
	PlayAkEvent(ActivateSound);
	PlayAkEvent(StopIdleSound);
	PickedUpBy(P);
	//return;	
}

auto state Pickup
{
	ignores BeginState;

	function bool ValidTouch(Pawn Other)
	{
		local HaloGameDefault Game;

		Game = HaloGameDefault(WorldInfo.Game);
		return (Game.GetConstructionManager() != none) && super.ValidTouch(Other);
		//return ReturnValue;		
	}

	event Tick(float DeltaTime)
	{
		super(Actor).Tick(DeltaTime);
		//return;		
	}
	stop;	
}

defaultproperties
{
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionBlueprintPickup.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'fx_blueprint_Catch.Effects.FX_Blueprint_Block_Lrg_ALT'
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	BlueprintParticleComponent=ParticleSystemComponent0
	PlayIdleSound=AkEvent'UIHUD.Play_Pickup_Blueprint_Loop'
	StopIdleSound=AkEvent'UIHUD.Stop_Pickup_Blueprint_Loop'
	ActivateSound=AkEvent'UIHUD.Play_Pickup_Blueprint'
	DeathParticleSystem=ParticleSystem'fx_blueprint_Catch.Effects.FX_Blueprint_Block_Lrg_END'
	// Reference: HaloBlueprintBlokSpawnerComponent'MegaHaloGame.Default__HaloConstructionBlueprintPickup.HaloBlueprintBlokSpawnerComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloBlueprintBlokSpawnerComponent0'
	begin object name="HaloBlueprintBlokSpawnerComponent0" class=MegaHaloGame.HaloBlueprintBlokSpawnerComponent
	end object
	BlokSpawner=HaloBlueprintBlokSpawnerComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloConstructionBlueprintPickup.DroppedPickupLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DroppedPickupLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedItemPickup.DroppedPickupLightEnvironment'
	begin object name="DroppedPickupLightEnvironment"
	end object
	MyLightEnvironment=DroppedPickupLightEnvironment
	Components[0]=none
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloConstructionBlueprintPickup.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloDroppedItemPickup.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=100.0000000
		CollisionRadius=200.0000000
		ReplacementPrimitive=none
	end object
	Components[1]=CollisionCylinder
	Components[2]=DroppedPickupLightEnvironment
	Components[3]=ParticleSystemComponent0
	Components[4]=CollisionCylinder
	Components[5]=HaloBlueprintBlokSpawnerComponent0
	LifeSpan=0.0000000
	CollisionComponent=CollisionCylinder
}