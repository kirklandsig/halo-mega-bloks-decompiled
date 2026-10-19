class FracturedStaticMeshActor extends Actor
	native
	placeable;

struct native DeferredPartToSpawn
{
	var int ChunkIndex;
	var Vector InitialVel;
	var Vector InitialAngVel;
	var float RelativeScale;
	var bool bExplosion;

	structdefaultproperties
	{
		ChunkIndex=0
		InitialVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		InitialAngVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		RelativeScale=0.0000000
		bExplosion=false
	}
};

struct CheckpointRecord
{
	var bool bIsShutdown;
	var array<byte> FragmentVis;

	structdefaultproperties
	{
		bIsShutdown=false
		FragmentVis=none
	}
};

var int MaxPartsToSpawnAtOnce;
var const editconst export editinline FracturedStaticMeshComponent FracturedStaticMeshComponent;
var const export editinline FracturedSkinnedMeshComponent SkinnedComponent;
var array<int> ChunkHealth;
var transient bool bHasShownMissingSoundWarning;
var bool bBreakChunksOnActorTouch;
var bool bShouldSaveForCheckpoint;
var array< Class<DamageType> > FracturedByDamageType;
var float ChunkHealthScale;
var array<ParticleSystem> OverrideFragmentDestroyEffects;
var float FractureCullMinDistance;
var float FractureCullMaxDistance;
var transient array<DeferredPartToSpawn> DeferredPartsToSpawn;
var PhysEffectInfo PartImpactEffect;
var SoundCue ExplosionFractureSound;
var SoundCue SingleChunkFractureSound;
var transient MaterialInterface MI_LoseChunkPreviousMaterial;
var string GwNavObstacleComponentClassPath;

// Export UFracturedStaticMeshActor::execSpawnPart(FFrame&, void* const)
native final simulated function FracturedStaticMeshPart SpawnPart(int ChunkIndex, Vector InitialVel, Vector InitialAngVel, float RelativeScale, bool bExplosion);

// Export UFracturedStaticMeshActor::execSpawnPartMulti(FFrame&, void* const)
native final simulated function FracturedStaticMeshPart SpawnPartMulti(array<int> ChunkIndices, Vector InitialVel, Vector InitialAngVel, float RelativeScale, bool bExplosion);

simulated event PostBeginPlay()
{
	local PhysicalMaterial PhysMat;
	local Class<ActorComponent> GwNavObstacleComponentClass;
	local editinline ActorComponent GwNavObstacleComponent;

	super.PostBeginPlay();
	ResetHealth();
	// End:0x2E
	if(!bBreakChunksOnActorTouch)
	{
		SetTickIsDisabled(true);
	}
	PhysMat = FracturedStaticMeshComponent.GetFracturedMeshPhysMaterial();
	PartImpactEffect = PhysMat.FindPhysEffectInfo(0);
	PhysMat.FindFractureSounds(ExplosionFractureSound, SingleChunkFractureSound);
	ResetVisibility();
	// End:0x137
	if(GwNavObstacleComponentClassPath != "")
	{
		GwNavObstacleComponentClass = Class<ActorComponent>(DynamicLoadObject(GwNavObstacleComponentClassPath, Class'Core.Class'));
		// End:0x137
		if(GwNavObstacleComponentClass != none)
		{
			GwNavObstacleComponent = new (self) GwNavObstacleComponentClass;
			AttachComponent(GwNavObstacleComponent);
		}
	}
	//return;	
}

// Export UFracturedStaticMeshActor::execResetHealth(FFrame&, void* const)
native final simulated function ResetHealth();

function bool ShouldSaveForCheckpoint()
{
	return bShouldSaveForCheckpoint;
	//return ReturnValue;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	// End:0x45
	if((int(Physics) == int(0)) && bHidden)
	{
		Record.bIsShutdown = true;		
	}
	else
	{
		Record.FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
	}
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	// End:0x2D
	if(Record.bIsShutdown)
	{
		ShutDown();		
	}
	else
	{
		FracturedStaticMeshComponent.SetVisibleFragments(Record.FragmentVis);
	}
	//return;	
}

// Export UFracturedStaticMeshActor::execBreakOffIsolatedIslands(FFrame&, void* const)
native simulated event BreakOffIsolatedIslands(out array<byte> FragmentVis, array<int> IgnoreFrags, Vector ChunkDir, array<FracturedStaticMeshPart> DisableCollWithPart, bool bWantPhysChunks);

// Export UFracturedStaticMeshActor::execSpawnDeferredParts(FFrame&, void* const)
native simulated event bool SpawnDeferredParts();

simulated function bool IsFracturedByDamageType(Class<DamageType> dmgType)
{
	local int I;

	// End:0x12
	if(FracturedByDamageType.Length == 0)
	{
		return true;
	}
	I = 0;
	J0x1D:

	// End:0x66 [Loop If]
	if(I < FracturedByDamageType.Length)
	{
		// End:0x58
		if(dmgType == FracturedByDamageType[I])
		{
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x1D;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool FractureEffectIsRelevant(bool bForceDedicated, Pawn EffectInstigator, out byte bWantPhysChunksAndParticles)
{
	local bool bResult;
	local PlayerController P;
	local float FinalMinDistance, FinalCullDistance, DistSq;
	local Vector CameraLoc;
	local Rotator CameraRot;

	bResult = true;
	bWantPhysChunksAndParticles = 1;
	// End:0x2C
	if(EffectInstigator == none)
	{
		return true;		
	}
	else
	{
		// End:0x60
		if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
		{
			return bForceDedicated;
		}
		// End:0x130
		if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && WorldInfo.Game.NumPlayers > 1)
		{
			// End:0xD3
			if(bForceDedicated)
			{
				return true;
			}
			// End:0x12D
			if(((EffectInstigator != none) && EffectInstigator.IsHumanControlled()) && EffectInstigator.IsLocallyControlled())
			{
				return true;
			}			
		}
		else
		{
			// End:0x166
			if((EffectInstigator != none) && EffectInstigator.IsHumanControlled())
			{
				return true;
			}
		}
		FinalMinDistance = FractureCullMinDistance * WorldInfo.MyFractureManager.GetFSMFractureCullDistanceScale();
		FinalCullDistance = FractureCullMaxDistance * WorldInfo.MyFractureManager.GetFSMFractureCullDistanceScale();
		DistSq = 10000000000.0000000;
		// End:0x283
		foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
		{
			P.GetPlayerViewPoint(CameraLoc, CameraRot);
			DistSq = FMin(DistSq, VSizeSq(Location - CameraLoc));			
		}		
		// End:0x2B5
		if(DistSq > (FinalCullDistance * FinalCullDistance))
		{
			bResult = false;			
		}
		else
		{
			// End:0x2D9
			if(DistSq < (FinalMinDistance * FinalMinDistance))
			{
				return true;
			}
		}
		// End:0x32F
		if(bResult)
		{
			// End:0x31E
			if((WorldInfo.TimeSeconds - LastRenderTime) < 0.5000000)
			{
				return true;				
			}
			else
			{
				bWantPhysChunksAndParticles = 0;
				return true;
			}			
		}
		else
		{
			bWantPhysChunksAndParticles = 0;
			return false;
		}
	}
	//return ReturnValue;	
}

// Export UFracturedStaticMeshActor::execRemoveDecals(FFrame&, void* const)
protected native final simulated function RemoveDecals(int IndexToRemoveDecalsFrom);

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local array<byte> FragmentVis;
	local Vector ChunkDir, MomentumDir;
	local FracturedStaticMesh FracMesh;
	local FracturedStaticMeshPart FracPart;
	local array<FracturedStaticMeshPart> NoCollParts;
	local int TotalVisible;
	local array<int> IgnoreFrags;
	local Box ChunkBox;
	local ParticleSystem EffectPSys;
	local float PhysChance, PartScale;
	local byte bWantPhysChunksAndParticles;
	local Pawn InstigatorPawn;
	local WorldFractureSettings FractureSettings;
	local Vector NewHitLocation, HitNormal;

	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	// End:0x9C
	if(((DamageType != none) && !DamageType.default.bCausesFracture) || !IsFracturedByDamageType(DamageType))
	{
		return;
	}
	// End:0x14C
	if(HitInfo.HitComponent == none)
	{
		// End:0xF7
		if(Momentum == vect(0.0000000, 0.0000000, 0.0000000))
		{
			Momentum = Location - HitLocation;
		}
		TraceComponent(NewHitLocation, HitNormal, FracturedStaticMeshComponent, HitLocation + (float(100) * Normal(Momentum)), HitLocation,, HitInfo, true);
	}
	// End:0x212
	if(((HitInfo.Item == FracturedStaticMeshComponent.GetCoreFragmentIndex()) || !FracturedStaticMeshComponent.IsFragmentVisible(HitInfo.Item)) || !FracturedStaticMeshComponent.IsFragmentDestroyable(HitInfo.Item))
	{
		return;
	}
	// End:0x24C
	if(EventInstigator != none)
	{
		InstigatorPawn = EventInstigator.Pawn;		
	}
	else
	{
		// End:0x283
		if(DamageCauser != none)
		{
			InstigatorPawn = DamageCauser.Instigator;
		}
	}
	// End:0x2A7
	if(!FractureEffectIsRelevant(false, InstigatorPawn, bWantPhysChunksAndParticles))
	{
		return;
	}
	// End:0x2EA
	if(RB_LineImpulseActor(DamageCauser) != none)
	{
		ChunkHealth[HitInfo.Item] = 0;		
	}
	else
	{
		// End:0x364
		if(DamageType != none)
		{
			ChunkHealth[HitInfo.Item] -= int(WorldInfo.FracturedMeshWeaponDamage * DamageType.default.FracturedMeshDamage);			
		}
		else
		{
			ChunkHealth[HitInfo.Item] -= int(WorldInfo.FracturedMeshWeaponDamage);
		}
	}
	// End:0xBC8
	if(ChunkHealth[HitInfo.Item] <= 0)
	{
		FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
		FractureSettings = WorldInfo.GetWorldFractureSettings();
		FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
		TotalVisible = FracturedStaticMeshComponent.GetNumVisibleFragments();
		// End:0x4A9
		if(int(Physics) == int(10))
		{
			// End:0x4A9
			if(TotalVisible == 1)
			{
				return;
			}
		}
		// End:0x4CB
		if(TotalVisible == FragmentVis.Length)
		{
			SetLoseChunkReplacementMaterial();
		}
		FragmentVis[HitInfo.Item] = 0;
		ChunkDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(HitInfo.Item);
		MomentumDir = Normal(Momentum);
		// End:0x597
		if((VSize(ChunkDir) < 0.0100000) || (MomentumDir Dot ChunkDir) > -0.2000000)
		{
			ChunkDir += MomentumDir;
		}
		ChunkDir.Z = float(Max(int(ChunkDir.Z), 0));
		ChunkDir.Z /= FracMesh.ChunkLinHorizontalScale;
		ChunkDir = Normal(ChunkDir);
		// End:0xA68
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			PhysChance = ((FractureSettings.bEnableChanceOfPhysicsChunkOverride) ? FractureSettings.ChanceOfPhysicsChunkOverride : FracMesh.ChanceOfPhysicsChunk);
			PhysChance *= WorldInfo.MyFractureManager.GetFSMDirectSpawnChanceScale();
			// End:0x8CB
			if((((int(bWantPhysChunksAndParticles) == int(1)) && FracMesh.bSpawnPhysicsChunks) && FRand() < PhysChance) && !FracturedStaticMeshComponent.IsNoPhysFragment(HitInfo.Item))
			{
				PartScale = FracMesh.NormalPhysicsChunkScaleMin + (FRand() * (FracMesh.NormalPhysicsChunkScaleMax - FracMesh.NormalPhysicsChunkScaleMin));
				FracPart = SpawnPart(HitInfo.Item, (ChunkDir * FracMesh.ChunkLinVel) + Velocity, VRand() * FracMesh.ChunkAngVel, PartScale, false);
				// End:0x8CB
				if(FracPart != none)
				{
					FracPart.FracturedStaticMeshComponent.DisableRBCollisionWithSMC(FracturedStaticMeshComponent, true);
				}
			}
			// End:0xA68
			if(int(bWantPhysChunksAndParticles) == int(1))
			{
				// End:0x912
				if(OverrideFragmentDestroyEffects.Length > 0)
				{
					EffectPSys = OverrideFragmentDestroyEffects[Rand(OverrideFragmentDestroyEffects.Length)];					
				}
				else
				{
					// End:0x981
					if(FracMesh.FragmentDestroyEffects.Length > 0)
					{
						EffectPSys = FracMesh.FragmentDestroyEffects[Rand(FracMesh.FragmentDestroyEffects.Length)];
					}
				}
				// End:0xA68
				if((EffectPSys != none) && WorldInfo.MyFractureManager != none)
				{
					ChunkBox = FracturedStaticMeshComponent.GetFragmentBox(HitInfo.Item);
					WorldInfo.MyFractureManager.SpawnChunkDestroyEffect(EffectPSys, ChunkBox, ChunkDir, FracMesh.FragmentDestroyEffectScale);
				}
			}
		}
		// End:0xB6D
		if((FracMesh.bAlwaysBreakOffIsolatedIslands || FracturedStaticMeshComponent.GetCoreFragmentIndex() == -1) && !FracMesh.bFixIsolatedChunks)
		{
			IgnoreFrags[0] = HitInfo.Item;
			// End:0xB27
			if(FracPart != none)
			{
				NoCollParts[0] = FracPart;
			}
			BreakOffIsolatedIslands(FragmentVis, IgnoreFrags, ChunkDir, NoCollParts, ((int(bWantPhysChunksAndParticles) == int(1)) ? true : false));
		}
		FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
		// End:0xBC8
		if(int(Physics) == int(10))
		{
			FracturedStaticMeshComponent.RecreatePhysState();
		}
	}
	//return;	
}

simulated event Explode()
{
	local array<byte> FragmentVis;
	local int I;
	local Vector SpawnDir;
	local FracturedStaticMesh FracMesh;
	local FracturedStaticMeshPart FracPart;
	local float PartScale;

	FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
	FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
	I = 0;
	J0x65:

	// End:0x25D [Loop If]
	if(I < FragmentVis.Length)
	{
		// End:0x24F
		if((int(FragmentVis[I]) != int(0)) && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
		{
			SpawnDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(I);
			PartScale = FracMesh.ExplosionPhysicsChunkScaleMin + (FRand() * (FracMesh.ExplosionPhysicsChunkScaleMax - FracMesh.ExplosionPhysicsChunkScaleMin));
			FracPart = SpawnPart(I, ((0.5000000 * SpawnDir) * FracMesh.ChunkLinVel) + Velocity, (0.5000000 * VRand()) * FracMesh.ChunkAngVel, PartScale, true);
			// End:0x239
			if(FracPart != none)
			{
				FracPart.FracturedStaticMeshComponent.SetRBCollidesWithChannel(14, false);
			}
			FragmentVis[I] = 0;
		}
		I++;
		// [Loop Continue]
		goto J0x65;
	}
	FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
	//return;	
}

// Export UFracturedStaticMeshActor::execBreakOffPartsInRadius(FFrame&, void* const)
native simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles);

// Export UFracturedStaticMeshActor::execResetVisibility(FFrame&, void* const)
native simulated event ResetVisibility();

simulated event HideOneFragment()
{
	local array<byte> FragmentVis;
	local int I;

	FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
	I = 0;
	J0x34:

	// End:0xE7 [Loop If]
	if(I < FragmentVis.Length)
	{
		// End:0xD9
		if((int(FragmentVis[I]) != int(0)) && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
		{
			FragmentVis[I] = 0;
			FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x34;
	}
	//return;	
}

simulated event HideFragmentsToMaximizeMemoryUsage()
{
	local array<byte> FragmentVis;
	local int I, Incr;

	Incr = 4;
	FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
	I = 0;
	J0x40:

	// End:0xD2 [Loop If]
	if(I < FragmentVis.Length)
	{
		// End:0xBB
		if((int(FragmentVis[I]) != int(0)) && I != FracturedStaticMeshComponent.GetCoreFragmentIndex())
		{
			FragmentVis[I] = 0;
		}
		I += Incr;
		// [Loop Continue]
		goto J0x40;
	}
	FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);
	//return;	
}

simulated event SetLoseChunkReplacementMaterial()
{
	local MaterialInterface LoseChunkOutsideMat;
	local FracturedStaticMesh FracMesh;

	// End:0x11
	if(MI_LoseChunkPreviousMaterial != none)
	{
		return;
	}
	FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
	// End:0x91
	if(FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride != none)
	{
		LoseChunkOutsideMat = FracturedStaticMeshComponent.LoseChunkOutsideMaterialOverride;		
	}
	else
	{
		LoseChunkOutsideMat = FracMesh.LoseChunkOutsideMaterial;
	}
	// End:0x16B
	if(LoseChunkOutsideMat != none)
	{
		MI_LoseChunkPreviousMaterial = FracturedStaticMeshComponent.GetMaterial(FracMesh.OutsideMaterialIndex).GetMaterial();
		FracturedStaticMeshComponent.SetMaterial(FracMesh.OutsideMaterialIndex, LoseChunkOutsideMat);
	}
	//return;	
}

simulated function NotifyHitByExplosion(Controller InstigatorController, float DamageAmount, Class<DamageType> dmgType)
{
	local int Idx;
	local SeqEvent_TakeDamage dmgEvent;

	Idx = 0;
	J0x0B:

	// End:0xA3 [Loop If]
	if(Idx < GeneratedEvents.Length)
	{
		dmgEvent = SeqEvent_TakeDamage(GeneratedEvents[Idx]);
		// End:0x95
		if(dmgEvent != none)
		{
			dmgEvent.HandleDamage(self, InstigatorController, dmgType, int(DamageAmount));
		}
		Idx++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

defaultproperties
{
	MaxPartsToSpawnAtOnce=6
	// Reference: FracturedStaticMeshComponent'Engine.Default__FracturedStaticMeshActor.FracturedStaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FracturedStaticMeshComponent0'
	begin object name="FracturedStaticMeshComponent0" class=Engine.FracturedStaticMeshComponent
		bUseDynamicIBWithHiddenFragments=true
		WireframeColor=(R=128,G=0,B=255,A=255)
		ReplacementPrimitive=none
		bAllowApproximateOcclusion=true
		bForceDirectLightMap=true
	end object
	FracturedStaticMeshComponent=FracturedStaticMeshComponent0
	// Reference: FracturedSkinnedMeshComponent'Engine.Default__FracturedStaticMeshActor.FracturedSkinnedComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FracturedSkinnedComponent0'
	begin object name="FracturedSkinnedComponent0" class=Engine.FracturedSkinnedMeshComponent
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'Engine.Default__FracturedStaticMeshActor.LightEnvironment0'
		bDisableAllRigidBody=true
	end object
	SkinnedComponent=FracturedSkinnedComponent0
	ChunkHealthScale=1.0000000
	FractureCullMinDistance=512.0000000
	FractureCullMaxDistance=4096.0000000
	GwNavObstacleComponentClassPath="GwNavEngine.GwNavObstacleComponent"
	// Reference: DynamicLightEnvironmentComponent'Engine.Default__FracturedStaticMeshActor.LightEnvironment0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'LightEnvironment0'
	begin object name="LightEnvironment0" class=Engine.DynamicLightEnvironmentComponent
		bDynamic=false
		bEnabled=false
		bForceNonCompositeDynamicLights=true
	end object
	Components[0]=LightEnvironment0
	Components[1]=FracturedSkinnedComponent0
	Components[2]=FracturedStaticMeshComponent0
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bNoDelete=true
	bWorldGeometry=true
	bRouteBeginPlayEvenIfStatic=false
	bGameRelevant=true
	bMovable=false
	bCanBeDamaged=true
	bCollideActors=true
	bBlockActors=true
	bProjTarget=true
	bEdShouldSnap=true
	bPathColliding=true
	CollisionComponent=FracturedStaticMeshComponent0
}