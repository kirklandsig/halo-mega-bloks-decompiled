class HaloAIJackalPawn extends HaloAIPawn
	config(Game);

var AnimNodeBlend ShieldNode;
var HaloHandheldPlasmaShield PlasmaShield;
var bool StartWithPlasmaShield;

simulated function Destroyed()
{
	// End:0x27
	if(PlasmaShield != none)
	{
		PlasmaShield.Destroy();
	}
	//return;	
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x21
	if(StartWithPlasmaShield)
	{
		GivePlasmaShield();
	}
	//return;	
}

simulated function GivePlasmaShield()
{
	// End:0xC1
	if(PlasmaShield == none)
	{
		PlasmaShield = Spawn(Class'MegaHaloGame.HaloHandheldPlasmaShield', self,, Mesh.GetBoneLocation(WeaponSocket2),,, true);
		PlasmaShield.SetHardAttach(true);
		PlasmaShield.SetPhysics(0);
		PlasmaShield.SetBase(self,, Mesh, WeaponSocket2);
	}
	//return;	
}

simulated function bool IsShieldUp()
{
	return (PlasmaShield != none) && PlasmaShield.currentHealth > float(0);
	//return ReturnValue;	
}

simulated event Tick(float Delta)
{
	local int BlendTarget;

	super.Tick(Delta);
	// End:0xDD
	if(ShieldNode != none)
	{
		BlendTarget = 0;
		// End:0x7C
		if(IsShieldUp()!)
		{
			BlendTarget = 1;
			// End:0x79
			if(ShieldNode.Child2WeightTarget == 0.0000000)
			{
				NotifyShieldDown();
			}			
		}
		else
		{
			// End:0xAE
			if(ShieldNode.Child2WeightTarget == 1.0000000)
			{
				NotifyShieldUp();
			}
		}
		ShieldNode.SetBlendTarget(float(BlendTarget), 0.0000000);
	}
	//return;	
}

simulated event NotifyShieldDown()
{
	//return;	
}

simulated event NotifyShieldUp()
{
	//return;	
}

function float GetCurrentShield()
{
	// End:0x2E
	if(PlasmaShield != none)
	{
		return PlasmaShield.currentHealth;
	}
	return 0.0000000;
	//return ReturnValue;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Class<HaloDamageType> HaloDamageType;
	local Vector toHit;

	HaloDamageType = Class<HaloDamageType>(DamageType);
	toHit = HitLocation - Location;
	// End:0x8D
	if(((HaloDamageType == Class'MegaHaloGame.HaloDamageType_Grenade') && IsShieldUp()) && (toHit Dot Vector(Rotation)) > float(0))
	{
		Damage = 0;
	}
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	//return;	
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super(HaloPawn).PostInitAnimTree(SkelComp);
	ShieldNode = AnimNodeBlend(SkelComp.FindAnimNode('ShieldNode'));
	//return;	
}

state Dying
{
	simulated event BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		// End:0x3A
		if(PlasmaShield != none)
		{
			PlasmaShield.Destroy();
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	StartWithPlasmaShield=true
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
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIJackalPawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	// Archetype: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIPawn.HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0"
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIJackalPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=9,MaxTotalValue=9)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloAIJackalPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloAIPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIJackalPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	AkCharacterType="COV_Jackal"
	ZoneCaptureRate=0.7500000
	EventBroadcastClass=Class'MegaHaloGame.HaloAIJackalPawn'
	GibPhysics=PhysicsAsset'Jackal.Jackal_Physics_Gib'
	GibMesh=SkeletalMesh'Jackal.Jackal_Frag'
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIJackalPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIJackalPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIJackalPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIJackalPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIJackalPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIJackalPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIJackalPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIJackalPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloAIJackalPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloAIPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	GroundSpeed=500.0000000
	Health=120
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIJackalPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Jackal.Jackal'
		AnimTreeTemplate=AnimTree'Halo_Jackal_AnimTree.JackalAnimTree'
		PhysicsAsset=PhysicsAsset'Jackal.Jackal_Physics_Rag'
		AnimSets[0]=AnimSet'Halo_Jackal_Anims.JackalAnimSet'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIJackalPawn.MyLightEnvironment'
		Scale=1.5500000
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloAIJackalPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloAIPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionRadius=45.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	PassiveObjectiveWeight=2.0000000
	PassiveSecondaryWeight=8.0000000
	AggressiveStationaryWeight=10.0000000
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIJackalPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIJackalPawn.AmbientSoundComponent2'
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