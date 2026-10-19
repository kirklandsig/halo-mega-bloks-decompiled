class FracturedStaticMeshPart extends FracturedStaticMeshActor
	native
	notplaceable;

var float DestroyPartRadiusFactor;
var transient FracturedStaticMeshActor BaseFracturedMeshActor;
var bool bHasBeenRecycled;
var bool bChangeRBChannelWhenAsleep;
var bool bCompositeThatExplodesOnImpact;
var float LastSpawnTime;
var int PartPoolIndex;
var float FracPartGravScale;
var PrimitiveComponent.ERBCollisionChannel AsleepRBChannel;
var Vector OldVelocity;
var float CurrentVibrationLevel;
var float LastImpactSoundTime;

// Export UFracturedStaticMeshPart::execInitialize(FFrame&, void* const)
native simulated function Initialize();

// Export UFracturedStaticMeshPart::execRecyclePart(FFrame&, void* const)
native simulated function RecyclePart(bool bAddToFreePool);

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	FracturedStaticMeshComponent.AddImpulse(Normal(Momentum) * DamageType.default.KDamageImpulse, HitLocation);
	//return;	
}

simulated function TryToCleanUp()
{
	// End:0x7C
	if((BaseFracturedMeshActor == none) || (WorldInfo.TimeSeconds - BaseFracturedMeshActor.SkinnedComponent.LastRenderTime) > 1.0000000)
	{
		RecyclePart(true);		
	}
	else
	{
		SetTimer(2.0000000, false, 'TryToCleanUp');
	}
	//return;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	RecyclePart(true);
	//return;	
}

simulated event Explode()
{
	// End:0x24
	if(!bHasBeenRecycled)
	{
		super.Explode();
		RecyclePart(true);
	}
	//return;	
}

simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{
	// End:0x3C
	if(bCompositeThatExplodesOnImpact)
	{
		super.BreakOffPartsInRadius(Origin, Radius, RBStrength, bWantPhysChunksAndParticles);
	}
	//return;	
}

defaultproperties
{
	DestroyPartRadiusFactor=10.0000000
	FracPartGravScale=2.0000000
	AsleepRBChannel=ERBCollisionChannel.RBCC_GameplayPhysics
	// Reference: FracturedStaticMeshComponent'Engine.Default__FracturedStaticMeshPart.FracturedStaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FracturedStaticMeshComponent0'
	// Archetype: FracturedStaticMeshComponent'Engine.Default__FracturedStaticMeshActor.FracturedStaticMeshComponent0'
	begin object name="FracturedStaticMeshComponent0"
		bUseSkinnedRendering=true
		bUseVisibleVertsForBounds=true
		bInitialVisibilityValue=false
		bUseDynamicIndexBuffer=false
		bUseDynamicIBWithHiddenFragments=false
		ReplacementPrimitive=none
		RBChannel=ERBCollisionChannel.RBCC_FracturedMeshPart
		bAcceptsDynamicDecals=false
		bForceDirectLightMap=false
		bCastDynamicShadow=false
		bUsePrecomputedShadows=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bSkipRBGeomCreation=true
		RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,FracturedMeshPart=true)
	end object
	FracturedStaticMeshComponent=FracturedStaticMeshComponent0
	SkinnedComponent=none
	Components[0]=FracturedStaticMeshComponent0
	Physics=EPhysics.PHYS_RigidBody
	TickGroup=ETickingGroup.TG_PostAsyncWork
	bNoDelete=false
	bWorldGeometry=false
	bNetInitialRotation=true
	bMovable=true
	bBlockActors=false
	bNoEncroachCheck=true
	bPathColliding=false
	LifeSpan=15.0000000
	CollisionComponent=FracturedStaticMeshComponent0
}