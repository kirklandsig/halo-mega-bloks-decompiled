class HaloPowerCorePawn extends HaloDestructibleActor;

var float MaxCooldownWarningTime;
var float AttackWarningCooldown;
var AkEvent UnderAttackSound;
var AkEvent KOSound;
var AkEvent KOVOSound;
var float BeamIntensity;
var export editinline ParticleSystemComponent HealthParticleComponent;
var Vector HealthParticleColor;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	switch(Tag)
	{
		// End:0x3F
		case 'HaloPowerCorePawnAlpha':
			UnderAttackSound = AkEvent'Dialog.Play_VO_Alpha_Under_Attack';
			// End:0x89
			break;
		// End:0x61
		case 'HaloPowerCorePawnBravo':
			UnderAttackSound = AkEvent'Dialog.Play_VO_Bravo_Under_Attack';
			// End:0x89
			break;
		// End:0x83
		case 'HaloPowerCorePawnCharlie':
			UnderAttackSound = AkEvent'Dialog.Play_VO_Charlie_Under_Attack';
			// End:0x89
			break;
		// End:0xFFFF
		default:
			// End:0x89
			break;
			break;
	}
	HealthParticleComponent.ActivateSystem();
	UpdateHealthParticleColor();
	//return;	
}

simulated event Tick(float DeltaTime)
{
	super(Actor).Tick(DeltaTime);
	AttackWarningCooldown -= DeltaTime;
	// End:0x49
	if(AttackWarningCooldown < 0.0000000)
	{
		AttackWarningCooldown = 0.0000000;
	}
	//return;	
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	UpdateHealthParticleColor();
	// End:0x92
	if((AttackWarningCooldown <= 0.0000000) && UnderAttackSound != none)
	{
		PlayAkEvent(UnderAttackSound);
	}
	AttackWarningCooldown = MaxCooldownWarningTime;
	// End:0xFD
	if((float(Health) <= 0.0000000) && KOSound != none)
	{
		PlayAkEvent(KOSound);
		PlayAkEvent(KOVOSound);
	}
	// End:0x136
	if(Health <= 0)
	{
		SetPhysics(0);
		SetHidden(true);
		LifeSpan = FMin(LifeSpan, 1.0000000);
	}
	//return;	
}

function UpdateHealthParticleColor()
{
	local float HP;

	HP = FClamp(float(Health) / float(HealthMax), 0.0000000, 1.0000000);
	HealthParticleColor.X = BeamIntensity * FClamp((1.0000000 - HP) * 2.0000000, 0.0000000, 1.0000000);
	HealthParticleColor.Y = BeamIntensity * FClamp(HP * 2.0000000, 0.0000000, 1.0000000);
	HealthParticleColor.Z = 0.0000000;
	HealthParticleComponent.SetVectorParameter('Color', HealthParticleColor);
	//return;	
}

defaultproperties
{
	MaxCooldownWarningTime=15.0000000
	KOSound=AkEvent'Objects.Play_AMB_PowerCore_Destroy'
	KOVOSound=AkEvent'Dialog.Play_VO_Generator_Lost'
	BeamIntensity=4.0000000
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloPowerCorePawn.ParticleSystemComponent1'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent1'
	begin object name="ParticleSystemComponent1" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=25000.0000000
		CachedMaxDrawDistance=25000.0000000
	end object
	HealthParticleComponent=ParticleSystemComponent1
	TeamNum=3
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloPowerCorePawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloDestructibleActor.targetableComponent'
	begin object name="targetableComponent"
		OutterThreatRadius=100000.0000000
		AITargetType=HaloTargetType.TARGET_PASSIVE_OBJECTIVE
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Destructible'MegaHaloGame.Default__HaloPowerCorePawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Destructible'MegaHaloGame.Default__HaloDestructibleActor.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloPowerCorePawn.NeedleTargetComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTargetComponent'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloDestructibleActor.NeedleTargetComponent'
	begin object name="NeedleTargetComponent"
	end object
	MyNeedleTargetComponent=NeedleTargetComponent
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloPowerCorePawn.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloDestructibleActor.ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0"
		ReplacementPrimitive=none
	end object
	ParticleComponent=ParticleSystemComponent0
	Health=2500
	HealthMax=2500
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloPowerCorePawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloDestructibleActor.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=10,MaxTotalValue=20)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloDestructibleBlokSpawnerComponent'MegaHaloGame.Default__HaloPowerCorePawn.DestructibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DestructibleBlokSpawnerComponent'
	// Archetype: HaloDestructibleBlokSpawnerComponent'MegaHaloGame.Default__HaloDestructibleActor.DestructibleBlokSpawnerComponent'
	begin object name="DestructibleBlokSpawnerComponent"
	end object
	DestructibleBlokSpawner=DestructibleBlokSpawnerComponent
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloPowerCorePawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	// Archetype: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloDestructibleActor.HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0"
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloPowerCorePawn.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloDestructibleActor.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'UNSC_PowerCore.Mesh.UNSC_PowerCore'
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloPowerCorePawn.SkeletalMeshComponent0.SkeletalMeshAnimSequence'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloDestructibleActor.SkeletalMeshAnimSequence'
		begin object name="SkeletalMeshAnimSequence"
		end object
		Animations=SkeletalMeshAnimSequence
		bHasPhysicsAssetInstance=true
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPowerCorePawn.MyLightEnvironment'
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPowerCorePawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDestructibleActor.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[0]=MyLightEnvironment
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloPowerCorePawn.KAssetSkelMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'KAssetSkelMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloDestructibleActor.KAssetSkelMeshComponent'
	begin object name="KAssetSkelMeshComponent"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPowerCorePawn.MyLightEnvironment'
	end object
	Components[1]=KAssetSkelMeshComponent
	Components[2]=targetableComponent
	Components[3]=HaloTargetableComponent
	Components[4]=NeedleTargetComponent
	Components[5]=SkeletalMeshComponent0
	Components[6]=ParticleSystemComponent0
	Components[7]=CollectibleBlokSpawnerComponent
	Components[8]=DestructibleBlokSpawnerComponent
	Components[9]=HaloCameraEncounterTargetableComponent0
	Components[10]=ParticleSystemComponent1
	CollisionComponent=SkeletalMeshComponent0
}