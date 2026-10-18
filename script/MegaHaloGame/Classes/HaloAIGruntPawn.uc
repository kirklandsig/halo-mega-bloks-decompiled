class HaloAIGruntPawn extends HaloAIPawn
	config(Game);

var AnimNodeBlend FleeNode;
var array<HaloProjectile_Grenade> KamikazeGrenades;
var bool TryToEnter;

simulated event Tick(float Delta)
{
	local int BlendTarget;
	local HaloVehicle MyVehicle;

	super.Tick(Delta);
	// End:0xA6
	if(FleeNode != none)
	{
		BlendTarget = 0;
		// End:0x77
		if(GetIsPanicking())
		{
			BlendTarget = 1;
			// End:0x77
			if(FleeNode.Child2WeightTarget == 0.0000000)
			{
				NotifyStartFleeing();
			}
		}
		FleeNode.SetBlendTarget(float(BlendTarget), 0.0000000);
	}
	// End:0x100
	if(TryToEnter)
	{
		// End:0xFF
		foreach DynamicActors(Class'MegaHaloGame.HaloVehicle', MyVehicle)
		{
			// End:0xFE
			if(MyVehicle.DriverEnter(self))
			{
				TryToEnter = false;				
				return;
			}			
		}		
	}
	//return;	
}

simulated event NotifyStartFleeing()
{
	// End:0x1C
	if(KamikazeGrenades.Length == 0)
	{
		PlayEnemySfx(9);
	}
	//return;	
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super(HaloPawn).PostInitAnimTree(SkelComp);
	FleeNode = AnimNodeBlend(SkelComp.FindAnimNode('FleeNode'));
	//return;	
}

simulated event ArmKamikazeGrenades()
{
	local HaloProjectile_Grenade NewProjectile;

	InvManager.SetCurrentWeapon(none);
	NewProjectile = Spawn(Class'MegaHaloGame.HaloProjectile_PlasmaGrenade',,, Mesh.GetBoneLocation(WeaponSocket),,, true);
	NewProjectile.SetCollision(false, false);
	NewProjectile.SetHardAttach(true);
	NewProjectile.SetPhysics(0);
	NewProjectile.SetBase(self,, Mesh, WeaponSocket);
	KamikazeGrenades.AddItem(NewProjectile);
	NewProjectile = Spawn(Class'MegaHaloGame.HaloProjectile_PlasmaGrenade',,, Mesh.GetBoneLocation(WeaponSocket2),,, true);
	NewProjectile.SetCollision(false, false);
	NewProjectile.SetHardAttach(true);
	NewProjectile.SetPhysics(0);
	NewProjectile.SetBase(self,, Mesh, WeaponSocket2);
	KamikazeGrenades.AddItem(NewProjectile);
	//return;	
}

simulated event DropKamikazeGrenades()
{
	local HaloProjectile_Grenade grenade;

	// End:0xF2
	foreach KamikazeGrenades(grenade)
	{
		grenade.SetBase(none);
		grenade.SetPhysics(2);
		grenade.Speed = GroundSpeed;
		grenade.ExplodeFromTouchDelay /= 4.0000000;
		grenade.Init(Vector(Rotation) + Normal(grenade.Location - Location));		
	}	
	KamikazeGrenades.Length = 0;
	//return;	
}

simulated event DetonateKamikazeGrenades()
{
	local HaloProjectile_Grenade grenade;
	local array<HaloProjectile_Grenade> DetonatingGrenades;

	DetonatingGrenades = KamikazeGrenades;
	KamikazeGrenades.Length = 0;
	// End:0x56
	foreach DetonatingGrenades(grenade)
	{
		grenade.ExplodeNow();		
	}	
	//return;	
}

simulated event Destroyed()
{
	local HaloProjectile_Grenade grenade;

	// End:0x51
	foreach KamikazeGrenades(grenade)
	{
		grenade.bSuppressExplosionFX = true;
		grenade.Destroy();		
	}	
	//return;	
}

state Dying
{
	simulated event BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		DropKamikazeGrenades();
		//return;		
	}
	stop;	
}

defaultproperties
{
	DefaultWeapon=Class'MegaHaloGame.HaloWeapon_Pistol'
	DamageScale=0.6000000
	EnemyAkEvents[0]=AkEvent'Enemy_Vocals.Play_ENM_See_Enemy'
	EnemyAkEvents[1]=AkEvent'Enemy_Vocals.Play_ENM_Threaten'
	EnemyAkEvents[2]=AkEvent'Enemy_Vocals.Play_ENM_Reload'
	EnemyAkEvents[4]=AkEvent'Enemy_Vocals.Play_ENM_Pain'
	EnemyAkEvents[6]=AkEvent'Enemy_Vocals.Play_ENM_Die'
	EnemyAkEvents[7]=AkEvent'Enemy_Vocals.Play_ENM_Grenade_Dodge'
	EnemyAkEvents[8]=AkEvent'Enemy_Vocals.Play_ENM_Roadkill_Dodge'
	EnemyAkEvents[9]=AkEvent'Enemy_Vocals.Play_ENM_Flee'
	EnemyAkEvents[10]=AkEvent'Enemy_Vocals.Play_ENM_Grenade_Stuck'
	DefaultGrenadeCountMax=0
	DeathBehaviors[0]=(DamageTypeName="HaloDamageType_Crushed",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=0.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[1]=(DamageTypeName="HaloDamageType_Grenade",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[2]=(DamageTypeName="HaloDamageType_PlasmaGrenade",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[3]=(DamageTypeName="HaloDamageType_Melee",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[4]=(DamageTypeName="None",DeathAnimName="Grunt_DramaDeath",DistanceAnimThreshold=1500.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[5]=(DamageTypeName="None",DeathAnimName="death_R",DistanceAnimThreshold=0.0000000,bIsDirectional=true,AnimHitDirection=90.0000000,bSnapDirection=true,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[6]=(DamageTypeName="None",DeathAnimName="death_L",DistanceAnimThreshold=0.0000000,bIsDirectional=true,AnimHitDirection=-90.0000000,bSnapDirection=true,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[7]=(DamageTypeName="None",DeathAnimName="death_var_03",DistanceAnimThreshold=0.0000000,bIsDirectional=true,AnimHitDirection=0.0000000,bSnapDirection=true,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[8]=(DamageTypeName="None",DeathAnimName="Grunt_Death_Front_00",DistanceAnimThreshold=0.0000000,bIsDirectional=true,AnimHitDirection=0.0000000,bSnapDirection=true,GibHealthThreshold=-40.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIGruntPawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	// Archetype: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIPawn.HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0"
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIGruntPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
		ImpulseXScalar=50.0000000
		ImpulseYScalar=50.0000000
		ImpulseZScalar=150.0000000
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=7,MaxTotalValue=7)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloAIGruntPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloAIPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIGruntPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	AkCharacterType="COV_Grunt"
	ZoneCaptureRate=0.7500000
	EventBroadcastClass=Class'MegaHaloGame.HaloAIGruntPawn'
	GibPhysics=PhysicsAsset'Halo_Grunt_Physics.Grunt_Physics_Gib'
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIGruntPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIGruntPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIGruntPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIGruntPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIGruntPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIGruntPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIGruntPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIGruntPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloAIGruntPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloAIPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	GroundSpeed=400.0000000
	Health=75
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIGruntPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Halo_Grunt.Grunt_Mesh'
		AnimTreeTemplate=AnimTree'Halo_Grunt_Anim.Grunt_AnimTree'
		PhysicsAsset=PhysicsAsset'Halo_Grunt_Physics.Grunt_Physics_Rag'
		AnimSets[0]=AnimSet'Halo_Grunt_Anim.GruntAnimSet'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIGruntPawn.MyLightEnvironment'
		Scale=1.0000000
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloAIGruntPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloAIPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionRadius=60.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	PassiveSecondaryWeight=0.0000000
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIGruntPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIGruntPawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2"
	end object
	Components[6]=AmbientSoundComponent2
	Components[7]=targetableComponent
	Components[8]=HaloTargetableComponent
	Components[9]=CollectibleBlokSpawnerComponent
	Components[10]=NeedleTarget
	Components[11]=HaloCameraEncounterTargetableComponent0
	CollisionComponent=CollisionCylinder
}