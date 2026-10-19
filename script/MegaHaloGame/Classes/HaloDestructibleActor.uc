class HaloDestructibleActor extends UDKCover;

struct HaloDestructibleSkeletalMeshData
{
	var bool bHasBeenShown;
	var float PercentHealthToSwapToMesh;
	var SkeletalMesh MeshToSwapTo;
	var ParticleSystem FXToActivate;
	var AkEvent AkEventIn;
	var AkEvent AkEventOut;
	var PhysicsAsset PhysicsAsset;
	var name StageAnimName;
	var bool bLooping;

	structdefaultproperties
	{
		bHasBeenShown=false
		PercentHealthToSwapToMesh=0.0000000
		MeshToSwapTo=none
		FXToActivate=none
		AkEventIn=none
		AkEventOut=none
		PhysicsAsset=none
		StageAnimName="None"
		bLooping=true
	}
};

var name AkObjectType;
var ParticleSystem ExplosionTemplate;
var byte TeamNum;
var export editinline UDKTargetableComponent MyTargetableComponent;
var export editinline HaloTargetableComponent_Destructible MyHaloTargetableComponent;
var export editinline HaloNeedleTargetComponent MyNeedleTargetComponent;
var export editinline ParticleSystemComponent ParticleComponent;
var name ImpactAnimationName;
var bool bCanBeHitByMelee;
var bool bBlocksRam;
var bool bPassShotsFromWithin;
var bool ExplodeOnDeath;
var bool bExplDoFullDamage;
var bool bIsShaking;
var const bool bAutoPlay;
var bool bProximityMaterialHasIntensity;
var bool IsLockActor;
var bool bWasMoving;
var bool bDamageLoopPlaying;
var int Health;
var int HealthMax;
var float ExplBaseDamage;
var float ExplDamageRadius;
var Class<DamageType> ExplDamageType;
var float ExplMomentum;
var export editinline HaloCollectibleBlokSpawnerComponent CollectibleBlokSpawner;
var export editinline HaloDestructibleBlokSpawnerComponent DestructibleBlokSpawner;
var array<HaloDestructibleSkeletalMeshData> SkeletalMeshes;
var StaticMesh PersistentMesh;
var DynamicSMActor_Spawnable PersistentActor;
var string GwNavObstacleComponentClassPath;
var AkEvent PlayLoopEvent;
var AkEvent StopLoopEvent;
var export editinline GwNavObstacleComponent ObstacleComponent;
var float ProximityRadius;
var float ProximityRadiusSq;
var float ProximityTransitionDuration;
var float ProximityIntensity;
var MaterialInstanceConstant ProximityMaterial;
var Class<DamageType> KeyDamageType;
var export editinline HaloCameraEncounterTargetableComponent CameraEncounterTargetableComponent;
var Vector prevLocation;
//var delegate<SortFunc> __SortFunc__Delegate;

simulated function PostBeginPlay()
{
	local Class<GwNavObstacleComponent> GwNavObstacleComponentClass;

	// End:0x20
	if(bAutoPlay)
	{
		SetTimer(0.0010000, false, 'PlayInitialSounds', self);
	}
	super(KAsset).PostBeginPlay();
	SkeletalMeshComponent.SetNotifyRigidBodyCollision(true);
	SkeletalMeshComponent.ScriptRigidBodyCollisionThreshold = 1.0000000;
	ProximityRadiusSq = Square(ProximityRadius);
	ProximityMaterial = SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(0);
	// End:0x145
	if(ProximityMaterial != none)
	{
		bProximityMaterialHasIntensity = ProximityMaterial.GetScalarParameterValue('GridIntensity', ProximityIntensity);
		// End:0x145
		if(bProximityMaterialHasIntensity)
		{
			ProximityIntensity = 0.0000000;
			ProximityMaterial.SetScalarParameterValue('GridIntensity', ProximityIntensity);
		}
	}
	SkeletalMeshes.Sort(SortFunc);
	DestructibleBlokSpawner.SortWaves();
	DestructibleBlokSpawner.AkObjectType = AkObjectType;
	// End:0x224
	if(GwNavObstacleComponentClassPath != "")
	{
		GwNavObstacleComponentClass = Class<GwNavObstacleComponent>(DynamicLoadObject(GwNavObstacleComponentClassPath, Class'Core.Class'));
		// End:0x224
		if(GwNavObstacleComponentClass != none)
		{
			ObstacleComponent = new (self) GwNavObstacleComponentClass;
			AttachComponent(ObstacleComponent);
		}
	}
	RequestDynamicLightEnvironmentComponent();
	// End:0x25C
	if(MyHaloTargetableComponent != none)
	{
		MyHaloTargetableComponent.PostBeginPlay();
	}
	//return;	
}

function RequestDynamicLightEnvironmentComponent()
{
	local HaloGameDefault Game;
	local editinline DynamicLightEnvironmentComponent DLEC;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x16C
	if(Game != none)
	{
		// End:0x16C
		if(Game.TheRAM != none)
		{
			// End:0x16C
			if(Game.TheRAM.IsComponentInstanced(SkeletalMeshComponent.LightEnvironment) == false)
			{
				DLEC = DynamicLightEnvironmentComponent(Game.TheRAM.RequestComponent(Class'Engine.DynamicLightEnvironmentComponent', self));
				// End:0x16C
				if(DLEC != none)
				{
					DetachComponent(SkeletalMeshComponent.LightEnvironment);
					SkeletalMeshComponent.SetLightEnvironment(DLEC);
				}
			}
		}
	}
	//return;	
}

event Destroyed()
{
	ReleaseDynamicLightEnvironmentComponent();
	// End:0x38
	if(MyNeedleTargetComponent != none)
	{
		MyNeedleTargetComponent.OnOwnerDestroyed();
	}
	super(Actor).Destroyed();
	//return;	
}

function ReleaseDynamicLightEnvironmentComponent()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0xB7
	if(Game != none)
	{
		// End:0xB7
		if(Game.TheRAM != none)
		{
			Game.TheRAM.ReleaseComponent(SkeletalMeshComponent.LightEnvironment, self);
		}
	}
	//return;	
}

delegate int SortFunc(HaloDestructibleSkeletalMeshData A, HaloDestructibleSkeletalMeshData B)
{
	return ((A.PercentHealthToSwapToMesh >= B.PercentHealthToSwapToMesh) ? 1 : -1);
	//return ReturnValue;	
}

simulated function PlayInitialSounds()
{
	PlaySoundLoop();
	PlayInIndexSound(0);
	//return;	
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> ThisDamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// End:0x27
	if((int(Role) < int(ROLE_Authority)) || bHidden)
	{
		return;
	}
	// End:0x58
	if((Damage > 0) && Health <= 0)
	{
		LifeSpan = 0.0001000;
		return;
	}
	// End:0x56E
	if(!IsLockActor || ThisDamageType == KeyDamageType)
	{
		Damage = Max(Damage, 0);
		super(KAsset).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, ThisDamageType, HitInfo, DamageCauser);
		Health -= Damage;
		HandleDestruction(Momentum);
		UpdateParticleComponentParams();
		PlayImpactAnimation();
		UpdateRTPCHealthValue();
		// End:0x42D
		if(Health <= 0)
		{
			LifeSpan = 0.0001000;
			WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionTemplate, Location);
			StopSoundLoop();
			// End:0x214
			if(PersistentMesh != none)
			{
				PersistentActor = Spawn(Class'MegaHaloGame.HaloDynamicSMActor_Spawnable',,, Location, Rotation,, true);
				// End:0x214
				if(PersistentActor != none)
				{
					PersistentActor.SetStaticMesh(PersistentMesh);
				}
			}
			// End:0x267
			if(ExplodeOnDeath == true)
			{
				HurtRadius(ExplBaseDamage, ExplDamageRadius, ExplDamageType, ExplMomentum, Location, self,, bExplDoFullDamage);
			}
			// End:0x2B6
			if(AkObjectType == 'BubbleShield')
			{
				SetSwitch('Equipment_Type', AkObjectType);
				PlayAkEvent(AkEvent'Equipment.Play_Equipment_Destroyed');				
			}
			else
			{
				SetSwitch('Object_Type', AkObjectType);
				SetRTPCValue('Impulse_Value', float(Min(Damage * 2, 100)));
				PlayAkEvent(AkEvent'Objects.Play_Object_Destroyed');
				// End:0x3F2
				if(((AkObjectType == 'PowerCube') || AkObjectType == 'UNSC_Powercube') || AkObjectType == 'COV_Powercube')
				{
					PlayAkEvent(AkEvent'Objects.Stop_FX_PowerCube_Damage_Loop');
					bDamageLoopPlaying = false;
					SetSwitch('Explosion_Type', ((AkObjectType == 'COV_Powercube') ? 'Explosion_Plasma' : 'Explosion_Concussive'));
					SetSwitch('Explosion_Size', 'Explosion_Large');
					PlayAkEvent(AkEvent'Foley.Play_Explosion');
				}
			}
			KillCoverLinks();
			// End:0x42A
			if(MyNeedleTargetComponent != none)
			{
				MyNeedleTargetComponent.OnDeath();
			}			
		}
		else
		{
			// End:0x47C
			if(AkObjectType == 'BubbleShield')
			{
				SetSwitch('Equipment_Type', AkObjectType);
				PlayAkEvent(AkEvent'Equipment.Play_Equipment_Impact');				
			}
			else
			{
				// End:0x4EF
				if(HaloProjectile(DamageCauser) == none)
				{
					SetSwitch('Object_Type', AkObjectType);
					SetRTPCValue('Impulse_Value', float(Min(Damage * 2, 100)));
					PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
				}
			}
			// End:0x56E
			if(!bDamageLoopPlaying && ((AkObjectType == 'PowerCube') || AkObjectType == 'UNSC_Powercube') || AkObjectType == 'COV_Powercube')
			{
				bDamageLoopPlaying = true;
				PlayAkEvent(AkEvent'Objects.Play_FX_PowerCube_Damage_Loop');
			}
		}
	}
	//return;	
}

function HandleDestruction(Vector Momentum)
{
	local float HP;

	HP = GetHealthPercentage();
	UpdateMesh(Momentum, HP);
	J0x30:

	// End:0x73 [Loop If]
	if(DestructibleBlokSpawner.TryToThrowBloks(SkeletalMeshComponent, Momentum, HP) == true)
	{
		// [Loop Continue]
		goto J0x30;
	}
	CollectibleBlokSpawner.TryToThrowBloks(HP);
	//return;	
}

function int GetNextMeshIndex(float CurrentHP)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x9C [Loop If]
	if(I < SkeletalMeshes.Length)
	{
		// End:0x8E
		if(SkeletalMeshes[I].bHasBeenShown == false)
		{
			// End:0x8E
			if(CurrentHP <= SkeletalMeshes[I].PercentHealthToSwapToMesh)
			{
				return I;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

function UpdateMesh(Vector Momentum, float HP)
{
	local int I, CurrentIndex;

	CurrentIndex = -1;
	I = GetNextMeshIndex(HP);
	J0x2C:

	// End:0xE8 [Loop If]
	if(I != -1)
	{
		UpdateSkeletalMesh(I);
		DestructibleBlokSpawner.TryToThrowBloks(SkeletalMeshComponent, Momentum, HP);
		SkeletalMeshes[I].bHasBeenShown = true;
		CurrentIndex = I;
		I = GetNextMeshIndex(HP);
		// [Loop Continue]
		goto J0x2C;
	}
	// End:0x151
	if(CurrentIndex != -1)
	{
		UpdatePhysicsAsset(CurrentIndex);
		UpdateAnim(CurrentIndex);
		UpdateProximityMaterial();
		UpdateParticleSystem(CurrentIndex);
		UpdateAKEvents(CurrentIndex);
	}
	//return;	
}

function UpdateSkeletalMesh(int I)
{
	// End:0x72
	if(SkeletalMeshes[I].MeshToSwapTo != none)
	{
		SkeletalMeshComponent.SetSkeletalMesh(SkeletalMeshes[I].MeshToSwapTo);
	}
	//return;	
}

function UpdatePhysicsAsset(int I)
{
	// End:0x72
	if(SkeletalMeshes[I].PhysicsAsset != none)
	{
		SkeletalMeshComponent.SetPhysicsAsset(SkeletalMeshes[I].PhysicsAsset);
	}
	//return;	
}

function UpdateAnim(int I)
{
	local AnimNodeSequence Node;

	// End:0x109
	if(SkeletalMeshes[I].StageAnimName != 'None')
	{
		Node = AnimNodeSequence(SkeletalMeshComponent.Animations);
		// End:0x109
		if(Node != none)
		{
			Node.SetAnim(SkeletalMeshes[I].StageAnimName);
			Node.PlayAnim(SkeletalMeshes[I].bLooping, 1.0000000, 0.0000000);
		}
	}
	//return;	
}

function UpdateProximityMaterial()
{
	local float IntensityParam;

	ProximityMaterial = SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(0);
	// End:0xB3
	if(ProximityMaterial != none)
	{
		bProximityMaterialHasIntensity = ProximityMaterial.GetScalarParameterValue('GridIntensity', IntensityParam);
		// End:0xB3
		if(bProximityMaterialHasIntensity)
		{
			ProximityMaterial.SetScalarParameterValue('GridIntensity', ProximityIntensity);
		}
	}
	//return;	
}

function UpdateParticleSystem(int I)
{
	ParticleComponent.DeactivateSystem();
	// End:0xB0
	if(SkeletalMeshes[I].FXToActivate != none)
	{
		ParticleComponent.SetTemplate(SkeletalMeshes[I].FXToActivate);
		ParticleComponent.ActivateSystem();
	}
	//return;	
}

function UpdateAKEvents(int I)
{
	PlayOutIndexSound(I);
	PlayInIndexSound(I + 1);
	//return;	
}

function UpdateParticleComponentParams()
{
	local float FloatParam;
	local Vector VectorParam;

	// End:0x118
	if(ParticleComponent != none)
	{
		FloatParam = FClamp(1.0000000 - (float(Health) / float(HealthMax)), 0.0000000, 1.0000000);
		VectorParam.X = FloatParam;
		VectorParam.Y = FloatParam;
		VectorParam.Z = FloatParam;
		ParticleComponent.SetFloatParameter('FXLifeFloat', FloatParam);
		ParticleComponent.SetVectorParameter('FXLifeVector', VectorParam);
	}
	//return;	
}

function PlayImpactAnimation()
{
	local AnimNodeSequence Node;

	// End:0xA9
	if(ImpactAnimationName != 'None')
	{
		Node = AnimNodeSequence(SkeletalMeshComponent.Animations);
		// End:0xA9
		if(Node != none)
		{
			Node.SetAnim(ImpactAnimationName);
			Node.PlayAnim(false, 1.0000000, 0.0000000);
		}
	}
	//return;	
}

simulated function UpdateRTPCHealthValue()
{
	// End:0x2C
	if(PlayLoopEvent != none)
	{
		SetRTPCValue('Health', GetHealthPercentage());
	}
	//return;	
}

simulated function PlaySoundLoop()
{
	// End:0x28
	if(PlayLoopEvent != none)
	{
		PlayAkEvent(PlayLoopEvent);
	}
	//return;	
}

simulated function StopSoundLoop()
{
	// End:0x28
	if(StopLoopEvent != none)
	{
		PlayAkEvent(StopLoopEvent);
	}
	//return;	
}

simulated function PlayInIndexSound(int Index)
{
	// End:0x8D
	if(((Index >= 0) && Index < SkeletalMeshes.Length) && SkeletalMeshes[Index].AkEventIn != none)
	{
		PlayAkEvent(SkeletalMeshes[Index].AkEventIn);
	}
	//return;	
}

simulated function PlayOutIndexSound(int Index)
{
	// End:0x8D
	if(((Index >= 0) && Index < SkeletalMeshes.Length) && SkeletalMeshes[Index].AkEventOut != none)
	{
		PlayAkEvent(SkeletalMeshes[Index].AkEventOut);
	}
	//return;	
}

simulated function float GetHealthPercentage()
{
	local float F;

	F = (float(Health) / float(HealthMax)) * 100.0000000;
	return F;
	//return ReturnValue;	
}

event EncroachedBy(Actor Other)
{
	// End:0x41
	if(HaloVehicle(Other) != none)
	{
		HaloVehicle(Other).HandleHDACollision(self);
	}
	super(Actor).EncroachedBy(Other);
	//return;	
}

simulated event byte ScriptGetTeamNum()
{
	return TeamNum;
	//return ReturnValue;	
}

simulated event ScriptSetTeamNum(byte newTeamNum)
{
	TeamNum = newTeamNum;
	//return;	
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
	local float ColRadius, ColHeight, DamageScale, Dist, ScaledDamage;

	local Vector Dir;

	GetBoundingCylinder(ColRadius, ColHeight);
	Dir = Location - HurtOrigin;
	Dist = VSize(Dir);
	Dir = Normal(Dir);
	// End:0x8C
	if(bFullDamage)
	{
		DamageScale = 1.0000000;		
	}
	else
	{
		Dist = FMax(Dist - ColRadius, 0.0000000);
		DamageScale = FClamp(1.0000000 - (Dist / DamageRadius), 0.0000000, 1.0000000);
		DamageScale = DamageScale ** DamageFalloffExponent;
	}
	// End:0x1B2
	if(DamageScale > 0.0000000)
	{
		ScaledDamage = DamageScale * BaseDamage;
		TakeDamage(int(ScaledDamage), InstigatedBy, Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), (DamageScale * Momentum) * Dir, DamageType,, DamageCauser);
	}
	super(KAsset).TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
	//return;	
}

function TickProximityMaterial(float DeltaTime)
{
	local bool bInRange;
	local float DistSq, PrevIntensity;
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	bInRange = false;
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x134
	if(Game != none)
	{
		// End:0x133
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x132
			if((PC != none) && PC.Pawn != none)
			{
				DistSq = VSizeSq(PC.Pawn.Location - Location);
				// End:0x132
				if(DistSq <= ProximityRadiusSq)
				{
					bInRange = true;
					// [Explicit Continue]
					goto J0x133;
				}
			}			
		}
		J0x133:
		
	}
	PrevIntensity = ProximityIntensity;
	// End:0x187
	if(bInRange)
	{
		ProximityIntensity = FMin(1.0000000, ProximityIntensity + (DeltaTime / ProximityTransitionDuration));		
	}
	else
	{
		ProximityIntensity = FMax(0.0000000, ProximityIntensity - (DeltaTime / ProximityTransitionDuration));
	}
	// End:0x1FF
	if(PrevIntensity != ProximityIntensity)
	{
		ProximityMaterial.SetScalarParameterValue('GridIntensity', ProximityIntensity);
	}
	//return;	
}

auto state Active
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.RemovePostRenderedActor(self);
		SetTickIsDisabled(false);
		SkeletalMeshComponent.WakeRigidBody();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		local float deltaLoc;

		// End:0xA5
		if(ObstacleComponent != none)
		{
			deltaLoc = VSizeSq(prevLocation - Location);
			// End:0x4E
			if(deltaLoc > 0.0100000)
			{
				bWasMoving = true;
			}
			// End:0x92
			if((deltaLoc < 0.0100000) && bWasMoving == true)
			{
				ReattachComponent(ObstacleComponent);
				bWasMoving = false;
			}
			prevLocation = Location;
		}
		// End:0xE2
		if(PlayerCanSeeMe())
		{
			// End:0xCC
			if(bProximityMaterialHasIntensity)
			{
				TickProximityMaterial(DeltaTime);
			}
			super(Actor).Tick(DeltaTime);			
		}
		else
		{
			// End:0xFA
			if(PlayerCanSeeMe(true) == false)
			{
				GotoState('Dormant');
			}
		}
		// End:0x143
		if((CameraEncounterTargetableComponent != none) && ExplodeOnDeath == true)
		{
			CameraEncounterTargetableComponent.Tick(DeltaTime);
		}
		// End:0x199
		if(MyNeedleTargetComponent != none)
		{
			MyNeedleTargetComponent.Tick(DeltaTime);
			MyNeedleTargetComponent.UpdateStickyAttachments();
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
		SkeletalMeshComponent.PutRigidBodyToSleep();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x49
		if((CameraEncounterTargetableComponent != none) && ExplodeOnDeath == true)
		{
			CameraEncounterTargetableComponent.Tick(DeltaTime);
		}
		//return;		
	}

	simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
	{
		GotoState('Active');
		//return;		
	}
	stop;	
}

defaultproperties
{
	AkObjectType="UNSC_Box"
	ExplosionTemplate=ParticleSystem'V_UNSC_Warthog_FX.Effects.V_Warthog_Explosion'
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloDestructibleActor.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		InnerThreatRadius=2000.0000000
		OutterThreatRadius=5000.0000000
		fAITargetHeight=50.0000000
		AITargetType=HaloTargetType.TARGET_PASSIVE_SECONDARY
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Destructible'MegaHaloGame.Default__HaloDestructibleActor.HaloTargetableComponent'
	begin object name="HaloTargetableComponent" class=MegaHaloGame.HaloTargetableComponent_Destructible
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloDestructibleActor.NeedleTargetComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTargetComponent'
	begin object name="NeedleTargetComponent" class=MegaHaloGame.HaloNeedleTargetComponent
	end object
	MyNeedleTargetComponent=NeedleTargetComponent
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloDestructibleActor.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=25000.0000000
		CachedMaxDrawDistance=25000.0000000
	end object
	ParticleComponent=ParticleSystemComponent0
	bAutoPlay=true
	Health=100
	HealthMax=100
	ExplBaseDamage=300.0000000
	ExplDamageRadius=800.0000000
	ExplDamageType=Class'MegaHaloGame.HaloDamageType_Grenade'
	ExplMomentum=50000.0000000
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloDestructibleActor.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent" class=MegaHaloGame.HaloCollectibleBlokSpawnerComponent
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloDestructibleBlokSpawnerComponent'MegaHaloGame.Default__HaloDestructibleActor.DestructibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DestructibleBlokSpawnerComponent'
	begin object name="DestructibleBlokSpawnerComponent" class=MegaHaloGame.HaloDestructibleBlokSpawnerComponent
	end object
	DestructibleBlokSpawner=DestructibleBlokSpawnerComponent
	GwNavObstacleComponentClassPath="GwNavEngine.GwNavObstacleComponent"
	ProximityRadius=1000.0000000
	ProximityTransitionDuration=1.0000000
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloDestructibleActor.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0" class=MegaHaloGame.HaloCameraEncounterTargetableComponent
		PriorityLevel=EEncounterPriorityLevel.EPL_Medium
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloDestructibleActor.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		Animations=AnimNodeSequence'MegaHaloGame.Default__HaloDestructibleActor.SkeletalMeshAnimSequence'
		bUseHaloDestructibleActorPhysics=1
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bTickAnimNodesWhenNotRendered=false
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDestructibleActor.MyLightEnvironment'
		MaxDrawDistance=25000.0000000
		CachedMaxDrawDistance=25000.0000000
		RBChannel=ERBCollisionChannel.RBCC_Untitled3
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		RBCollideWithChannels=(Default=true,Pawn=true,Vehicle=true,Untitled3=true)
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	bBlockPawns=true
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDestructibleActor.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UDKBase.Default__UDKCover.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[0]=MyLightEnvironment
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloDestructibleActor.KAssetSkelMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'KAssetSkelMeshComponent'
	// Archetype: SkeletalMeshComponent'UDKBase.Default__UDKCover.KAssetSkelMeshComponent'
	begin object name="KAssetSkelMeshComponent"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDestructibleActor.MyLightEnvironment'
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
	CollisionType=ECollisionType.COLLIDE_BlockAll
	bNoDelete=false
	bPushedByEncroachers=false
	bHasAlternateTargetLocation=true
	bCanBeDamaged=true
	BlockRigidBody=false
	bCollideWorld=true
	bPathColliding=true
	CollisionComponent=SkeletalMeshComponent0
}