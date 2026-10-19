class HaloAIHunterPawn extends HaloAIPawn
	config(Game);

var float ShieldUpDamageScalar;
var bool IsShieldUp;
var bool HitWallRebound;
var bool AimLocked;
var Rotator LockedRotation;
var CCSController CCSController;
var array<HaloSkelControl_Damage> DamageSkelComponents;
var float DamageControlTriggerHealth;
var float DamageControlTriggerInterval;
var AnimNodeAdditiveBlending AdditiveShieldBlendNode;
var int HitCounter;
var CameraShake FootstepCameraShake;
var float MaxFootstepCameraShakeDistance;
var ParticleSystem RicochetFxTemplate;
var float RicochetPerturbAngle;
var ParticleSystem WeakPointFXTemplate;
var export editinline ParticleSystemComponent WeakPointFXSystem;
var int TakedownHealthThreshold;
var float TakedownImpulseRadius;
var float TakedownImpulseStrength;
var float TakedownMinSpinImpulsePerBody;
var float TakedownMaxSpinImpulsePerBody;

simulated event PostBeginPlay()
{
	PlayWeakPointFX();
	AdditiveShieldBlendNode.SetBlendTarget(1.0000000, 0.2500000);
	super.PostBeginPlay();
	//return;	
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super(UTPawn).PossessedBy(C, bVehicleTransition);
	CCSController = CCSController(Controller);
	HitCounter = 0;
	//return;	
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super(HaloPawn).PostInitAnimTree(SkelComp);
	// End:0x1D9
	if(SkelComp == Mesh)
	{
		DamageSkelComponents.AddItem(HaloSkelControl_Damage(Mesh.FindSkelControl('LTSpikeDamageControl')));
		DamageSkelComponents.AddItem(HaloSkelControl_Damage(Mesh.FindSkelControl('SShieldDamageControl')));
		DamageSkelComponents.AddItem(HaloSkelControl_Damage(Mesh.FindSkelControl('RTSpikeDamageControl')));
		DamageSkelComponents.AddItem(HaloSkelControl_Damage(Mesh.FindSkelControl('AShieldTopDamageControl')));
		DamageSkelComponents.AddItem(HaloSkelControl_Damage(Mesh.FindSkelControl('AShieldDamageControl')));
		DamageSkelComponents.AddItem(HaloSkelControl_Damage(Mesh.FindSkelControl('ATailDamageControl')));
		AdditiveShieldBlendNode = AnimNodeAdditiveBlending(SkelComp.FindAnimNode('AdditiveShieldBlend'));
	}
	//return;	
}

simulated function PlaySound180Melee()
{
	SetSwitch('Character_Type', AkCharacterType);
	SetSwitch('Weapon_Type', 'COV_FuelRod');
	PlayEnemyAkEvent(AkEvent'Melee.Play_Melee_Swing');
	//return;	
}

simulated function PlaySoundChargeMelee()
{
	SetSwitch('Character_Type', AkCharacterType);
	PlayEnemyAkEvent(AkEvent'Enemy_Vocals.Play_ENM_Charge');
	//return;	
}

simulated function AltPullTrigger()
{
	// End:0x41
	if(Weapon != none)
	{
		Weapon.PlayAkEvent(AkEvent'Weapons.Play_WEP_COV_Hunter_Cannon_Charge',,,,,, 1.0000000);
	}
	AimLocked = true;
	LockedRotation = CCSController.AimingRot;
	super.AltPullTrigger();
	//return;	
}

simulated function AltReleaseTrigger()
{
	super.AltReleaseTrigger();
	AimLocked = false;
	//return;	
}

simulated event Tick(float DeltaTime)
{
	// End:0x71
	if(AimLocked && CCSController != none)
	{
		CCSController.SetDesiredRotation(LockedRotation);
		CCSController.AimingRot = LockedRotation;
	}
	super.Tick(DeltaTime);
	//return;	
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	// End:0x156
	if((((HitWallRebound && (HitNormal Dot Vector(Rotation)) < 0.0000000) && (Wall.bStatic == true) || Wall.bWorldGeometry == true) && int(Mesh.RootMotionRotationMode) != int(0)) && CCSController != none)
	{
		StopCustomAnimation();
		CCSController.NotifyEvent(EventBroadcastClass, 5, Location);
		SetPhysics(2);
		Velocity += ((vect(-1.0000000, 0.0000000, 0.0000000) >> Rotation) * 1000.0000000);
		Velocity.Z = 500.0000000;
		HitWallRebound = false;
	}
	super(Actor).HitWall(HitNormal, Wall, WallComp);
	//return;	
}

simulated function RaiseShield()
{
	IsShieldUp = true;
	//return;	
}

simulated function LowerShield()
{
	//return;	
}

simulated function EnableHitWallRebound()
{
	HitWallRebound = true;
	//return;	
}

simulated function DisableHitWallRebound()
{
	HitWallRebound = false;
	//return;	
}

simulated event PlayFootStepSound(int FootDown)
{
	PlayWalkStepNow();
	//return;	
}

simulated function PlayFootstepCameraShake(PlayerController PC, float distanceSq)
{
	local float magnitude, maxShakeDistanceSq;

	maxShakeDistanceSq = MaxFootstepCameraShakeDistance * MaxFootstepCameraShakeDistance;
	magnitude = (maxShakeDistanceSq - distanceSq) / maxShakeDistanceSq;
	// End:0xAF
	if((FootstepCameraShake != none) && PC != none)
	{
		PC.PlayerCamera.PlayCameraShake(FootstepCameraShake, magnitude);
	}
	//return;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Vector toHit;
	local HaloSkelControl_Damage scDamage;

	toHit = HitLocation - Location;
	// End:0x89
	if(IsShieldUp && (toHit Dot Vector(Rotation)) > float(0))
	{
		SpawnRicochetFX(HitLocation, Momentum, Damage);
		Damage *= ShieldUpDamageScalar;		
	}
	else
	{
		SpawnDefaultHitFX(HitLocation, Momentum, Damage);
	}
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	// End:0x177
	if((float(Health) < DamageControlTriggerHealth) && DamageSkelComponents.Length > 0)
	{
		scDamage = DamageSkelComponents[0];
		scDamage.BreakApartAtBone();
		DamageSkelComponents.Remove(0, 1);
		DamageControlTriggerHealth -= DamageControlTriggerInterval;
	}
	HitCounter += 1;
	SetTimer(2.0000000, true, 'DecrementHitCounter');
	// End:0x1DA
	if(HitCounter >= 1)
	{
		AdditiveShieldBlendNode.SetBlendTarget(1.0000000, 0.2500000);
		IsShieldUp = true;
	}
	//return;	
}

function SpawnDefaultHitFX(Vector fxLoc, Vector fxFwd, int Damage)
{
	//return;	
}

function SpawnRicochetFX(Vector HitLoc, Vector HitDir, int Damage)
{
	local Vector HitNorm, SpawnDir;
	local editinline ParticleSystemComponent FX;

	HitNorm = HitLoc - Location;
	// End:0x45
	if(IsZero(HitNorm))
	{
		HitNorm = Vector(Rotation);		
	}
	else
	{
		HitNorm = Normal(HitNorm);
	}
	// End:0x7F
	if(IsZero(HitDir))
	{
		SpawnDir = HitNorm;		
	}
	else
	{
		SpawnDir = HitDir - ((2.0000000 * (HitNorm Dot HitDir)) * HitNorm);
	}
	// End:0x105
	if(RicochetPerturbAngle > 0.0000000)
	{
		SpawnDir = VRandCone(SpawnDir, (RicochetPerturbAngle * float(65536)) / float(360));
	}
	FX = WorldInfo.MyEmitterPool.SpawnEmitter(RicochetFxTemplate, HitLoc, Rotator(SpawnDir), self);
	// End:0x1A6
	if(FX != none)
	{
		FX.SetFloatParameter('Damage', float(Damage));
	}
	//return;	
}

function DecrementHitCounter()
{
	// End:0x1B
	if(HitCounter > 0)
	{
		HitCounter -= 1;
	}
	//return;	
}

function DoneDefending()
{
	AdditiveShieldBlendNode.SetBlendTarget(0.0000000, 0.2500000);
	HitCounter = 0;
	IsShieldUp = false;
	//return;	
}

function PlayWeakPointFX()
{
	WeakPointFXSystem = WorldInfo.MyEmitterPool.SpawnEmitter(WeakPointFXTemplate, Location, Rotation, self);
	WeakPointFXSystem.SetActorParameter('BoneSocketActor', self);
	//return;	
}

function bool ReadyForTakedown()
{
	// End:0x22
	if(Health <= TakedownHealthThreshold)
	{
		return super(HaloPawn).ReadyForTakedown();
	}
	return false;
	//return ReturnValue;	
}

simulated function Destroyed()
{
	WeakPointFXSystem.DeactivateSystem();
	//return;	
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
{
	WeakPointFXSystem.DeactivateSystem();
	super.PlayDying(DamageType, HitLoc, Killer);
	//return;	
}

state TakedownAsTarget
{
	simulated function Takedown_DieNow()
	{
		local Vector weakPt;

		super.Takedown_DieNow();
		// End:0x57
		if(!Mesh.GetSocketWorldLocationAndRotation(TargetNodes[0], weakPt))
		{
			weakPt = Location;
		}
		Mesh.AddRadialImpulse(weakPt, TakedownImpulseRadius, TakedownImpulseStrength, 1, true);
		// End:0xFE
		if(Mesh.PhysicsAssetInstance != none)
		{
			Mesh.PhysicsAssetInstance.AddRandomSpinToEachBody(TakedownMinSpinImpulsePerBody, TakedownMaxSpinImpulsePerBody);
		}
		//return;		
	}
	stop;	
}

state RelaxWeapon
{
	event BeginState(name PrevStateName)
	{
		StopFire(0);
		OnAnimDone();
		//return;		
	}
	stop;	
}

defaultproperties
{
	IsShieldUp=true
	DamageControlTriggerHealth=2700.0000000
	DamageControlTriggerInterval=400.0000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloAIHunterPawn.FootstepCameraShake1'
	begin object name="FootstepCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=1000.0000000,Frequency=2.0000000),Yaw=(Amplitude=100.0000000,Frequency=1.0000000))
	end object
	FootstepCameraShake=FootstepCameraShake1
	MaxFootstepCameraShakeDistance=2000.0000000
	RicochetFxTemplate=ParticleSystem'WP_COV_HUNTER.Effects.V_COV_Hunter_ShieldHit'
	WeakPointFXTemplate=ParticleSystem'FX_COV_Hunter.Effects.FX_COV_AchilliesGLOW'
	TakedownHealthThreshold=700
	TakedownImpulseRadius=750.0000000
	TakedownImpulseStrength=500.0000000
	TakedownMinSpinImpulsePerBody=3.1415927
	TakedownMaxSpinImpulsePerBody=18.8495560
	RotationSpeed=0.0001000
	DefaultWeapon=Class'MegaHaloGame.HaloWeapon_FuelRodCannon'
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
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIHunterPawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	// Archetype: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIPawn.HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0"
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIHunterPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
		ImpulseXScalar=50.0000000
		ImpulseYScalar=50.0000000
		ImpulseZScalar=150.0000000
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=34,MaxTotalValue=34)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloAIHunterPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloAIPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIHunterPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	AkCharacterType="COV_Hunter"
	MeleeImpactSoundEvent=AkEvent'Melee.Play_Melee_Weapon_Impact'
	ZoneCaptureRate=0.7500000
	EventBroadcastClass=Class'MegaHaloGame.HaloAIHunterPawn'
	GibPhysics=PhysicsAsset'Halo_Hunter_Physics.Hunter_Physics_Gib'
	GibMesh=SkeletalMesh'Halo_Hunter_Mesh.Hunter_Frag'
	CurMeleeDesc=(DamageAngle=120.0000000,DamageRange=300.0000000,bIsFullBodyAnim=true,bUseRootMotion=true)
	MeleeMomentum=240000.0000000
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIHunterPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	TargetNodes[0]="TargetPoint_WeakSpot"
	TargetNodes[1]="TargetPoint_Front"
	DefaultHitFxTemplate=ParticleSystem'FX_COV_Hunter.Effects.FX_Cov_HnterHIT'
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIHunterPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIHunterPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIHunterPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIHunterPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIHunterPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIHunterPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIHunterPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloAIHunterPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloAIPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	NavDataFamily=GwNavNavdataFamily'EngineGwNav.HunterFamily'
	MaxStepHeight=25.0000000
	WalkableFloorZ=0.3000000
	bIgnoreForces=true
	bDirectHitWall=true
	GroundSpeed=450.0000000
	Health=2800
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIHunterPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Halo_Hunter_Mesh.NS_Hunter'
		AnimTreeTemplate=AnimTree'Halo_Hunter_AnimTree.Hunter_AnimTree'
		PhysicsAsset=PhysicsAsset'Halo_Hunter_Physics.Hunter_Physics_Rag'
		AnimSets[0]=AnimSet'Halo_Hunter_Anims.Hunter_AnimSet'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIHunterPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloAIHunterPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloAIPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=340.0000000
		CollisionRadius=180.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	PassiveObjectiveWeight=0.0000000
	PassiveSecondaryWeight=0.0000000
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIHunterPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIHunterPawn.AmbientSoundComponent2'
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
	RotationRate=(Pitch=20000,Yaw=15000,Roll=20000)
}