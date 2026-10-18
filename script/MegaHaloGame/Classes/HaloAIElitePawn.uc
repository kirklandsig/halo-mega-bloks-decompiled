class HaloAIElitePawn extends HaloAIPawn
	config(Game);

defaultproperties
{
	EnemyAkEvents[0]=AkEvent'Enemy_Vocals.Play_ENM_See_Enemy'
	EnemyAkEvents[1]=AkEvent'Enemy_Vocals.Play_ENM_Threaten'
	EnemyAkEvents[2]=AkEvent'Enemy_Vocals.Play_ENM_Reload'
	EnemyAkEvents[4]=AkEvent'Enemy_Vocals.Play_ENM_Pain'
	EnemyAkEvents[6]=AkEvent'Enemy_Vocals.Play_ENM_Die'
	EnemyAkEvents[7]=AkEvent'Enemy_Vocals.Play_ENM_Grenade_Dodge'
	EnemyAkEvents[8]=AkEvent'Enemy_Vocals.Play_ENM_Roadkill_Dodge'
	EnemyAkEvents[9]=AkEvent'Enemy_Vocals.Play_ENM_Flee'
	EnemyAkEvents[10]=AkEvent'Enemy_Vocals.Play_ENM_Grenade_Stuck'
	DefaultGrenadeChance=1.0000000
	DeathBehaviors[0]=(DamageTypeName="HaloDamageType_Crushed",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=0.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[1]=(DamageTypeName="HaloDamageType_Grenade",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[2]=(DamageTypeName="HaloDamageType_PlasmaGrenade",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[3]=(DamageTypeName="HaloDamageType_Melee",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[4]=(DamageTypeName="None",DeathAnimName="Elite_Drama_Death",DistanceAnimThreshold=1500.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[5]=(DamageTypeName="None",DeathAnimName="Elite_Death_Stinger",DistanceAnimThreshold=0.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIElitePawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	// Archetype: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIPawn.HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0"
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	KnockdownIgnoredDamageTypes[0]=Class'MegaHaloGame.HaloDamageType_Melee'
	KnockdownBehaviors[0]=(DamageType=none,AnimName="hit_L",MinRecoverTime=1.0000000,MaxRecoverTime=1.0000000,bIsDirectional=true,AnimHitDirection=-90.0000000,bSnapDirection=false,rDirection=(Pitch=0,Yaw=0,Roll=0))
	KnockdownBehaviors[1]=(DamageType=none,AnimName="hit_front",MinRecoverTime=1.0000000,MaxRecoverTime=1.0000000,bIsDirectional=true,AnimHitDirection=0.0000000,bSnapDirection=false,rDirection=(Pitch=0,Yaw=0,Roll=0))
	KnockdownBehaviors[2]=(DamageType=none,AnimName="hit_R",MinRecoverTime=1.0000000,MaxRecoverTime=1.0000000,bIsDirectional=true,AnimHitDirection=90.0000000,bSnapDirection=false,rDirection=(Pitch=0,Yaw=0,Roll=0))
	KnockdownBehaviors[3]=(DamageType=none,AnimName="hit_back",MinRecoverTime=1.0000000,MaxRecoverTime=1.0000000,bIsDirectional=true,AnimHitDirection=180.0000000,bSnapDirection=false,rDirection=(Pitch=0,Yaw=0,Roll=0))
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIElitePawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
		ImpulseXScalar=50.0000000
		ImpulseYScalar=50.0000000
		ImpulseZScalar=150.0000000
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=15,MaxTotalValue=15)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloSuitShieldComponent'MegaHaloGame.Default__HaloAIElitePawn.SuitShieldComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SuitShieldComponent'
	begin object name="SuitShieldComponent" class=MegaHaloGame.HaloSuitShieldComponent
		ShieldShellMaterialBasis=MaterialInstanceConstant'ShieldEffect.M_COV_Shield_INST'
		ShieldExpirationBurstFXTemplate=ParticleSystem'FX_COV_SHIELDS.Effects.COV_SHIELD_BURST'
		ShieldRestorationBurstFXTemplate=ParticleSystem'FX_COV_SHIELDS.Effects.COV_SHIELD_RENEW'
		ShieldExpirationFXTemplate=ParticleSystem'FX_COV_SHIELDS.Effects.COV_SHIELD_FAILING'
		ShieldDepletedStartEvent=none
		ShieldDepletedStopEvent=none
		ShieldChargeEvent=none
	end object
	SuitShield=SuitShieldComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloAIElitePawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloAIPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIElitePawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	AkCharacterType="COV_Elite"
	ZoneCaptureRate=1.5000000
	EventBroadcastClass=Class'MegaHaloGame.HaloAIElitePawn'
	GibPhysics=PhysicsAsset'Halo_Elite_Physics.Elite_Physics_Gib'
	GibMesh=SkeletalMesh'Halo_Elite_Mesh.Elite_Frag'
	CurMeleeDesc=(AnimName="Melee_Rifle")
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIElitePawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	TargetNodes[0]="Target_Node"
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIElitePawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIElitePawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIElitePawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIElitePawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIElitePawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIElitePawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIElitePawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloAIElitePawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloAIPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	GroundSpeed=600.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIElitePawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Halo_Elite_Mesh.Elite'
		AnimTreeTemplate=AnimTree'Halo_Elite_Anim.Elite_AnimTree'
		PhysicsAsset=PhysicsAsset'Halo_Elite_Physics.Elite_Physics_Rag'
		AnimSets[0]=AnimSet'Halo_Elite_Anim.EliteAnimSet'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIElitePawn.MyLightEnvironment'
		Scale=1.0000000
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloAIElitePawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloAIPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=160.0000000
		CollisionRadius=60.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	PassiveObjectiveWeight=0.1000000
	PassiveSecondaryWeight=0.1000000
	AggressiveMobileWeight=10.0000000
	AggressiveStationaryWeight=0.5000000
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIElitePawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIElitePawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2"
	end object
	Components[6]=AmbientSoundComponent2
	Components[7]=targetableComponent
	Components[8]=HaloTargetableComponent
	Components[9]=CollectibleBlokSpawnerComponent
	Components[10]=NeedleTarget
	Components[11]=HaloCameraEncounterTargetableComponent0
	Components[12]=SuitShieldComponent
	CollisionComponent=CollisionCylinder
}