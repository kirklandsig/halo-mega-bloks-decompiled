class HaloCollectibleBlok_1Peg_Std_Silver extends HaloCollectibleBlok;

defaultproperties
{
	CollectionMaterial=MaterialInstanceTimeVarying'FX_Bricks.Materials.MITV_Collect_2PEG_FadeOUT'
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloCollectibleBlok_1Peg_Std_Silver.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloCollectibleBlok.ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0"
		Template=ParticleSystem'FX_Bricks.Effects.CollectBrickFX_2_Peg_Std'
		ReplacementPrimitive=none
	end object
	FollowParticleComponent=ParticleSystemComponent0
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloCollectibleBlok_1Peg_Std_Silver.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'MegaHaloGame.Default__HaloCollectibleBlok.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		StaticMesh=StaticMesh'FX_Bricks.Meshes.1_Peg_Std_Silver'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloCollectibleBlok_1Peg_Std_Silver.MyLightEnvironment'
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloCollectibleBlok_1Peg_Std_Silver.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloCollectibleBlok.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	Components[0]=StaticMeshComponent0
	Components[1]=ParticleSystemComponent0
	CollisionComponent=StaticMeshComponent0
}