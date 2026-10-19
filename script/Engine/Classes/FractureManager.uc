class FractureManager extends Actor
	native
	notplaceable;

const FSM_DEFAULTRECYCLETIME = 0.2;

var int FSMPartPoolSize;
var bool bEnableAntiVibration;
var bool bEnableSpawnChunkEffectForRadialDamage;
var float DestroyVibrationLevel;
var float DestroyMinAngVel;
var float ExplosionVelScale;
var array<FracturedStaticMeshPart> PartPool;
var array<int> FreeParts;
var transient array<FracturedStaticMeshActor> ActorsWithDeferredPartsToSpawn;

simulated event SpawnChunkDestroyEffect(ParticleSystem Effect, Box ChunkBox, Vector ChunkDir, float Scale)
{
	local Vector ChunkMiddle;
	local editinline ParticleSystemComponent EffectComp;

	ChunkMiddle = 0.5000000 * (ChunkBox.Min + ChunkBox.Max);
	EffectComp = WorldInfo.MyEmitterPool.SpawnEmitter(Effect, ChunkMiddle, Rotator(ChunkDir));
	EffectComp.SetScale(Scale);
	//return;	
}

// Export UFractureManager::execGetNumFSMPartsScale(FFrame&, void* const)
native function float GetNumFSMPartsScale();

// Export UFractureManager::execGetFSMDirectSpawnChanceScale(FFrame&, void* const)
native function float GetFSMDirectSpawnChanceScale();

// Export UFractureManager::execGetFSMRadialSpawnChanceScale(FFrame&, void* const)
native function float GetFSMRadialSpawnChanceScale();

// Export UFractureManager::execGetFSMFractureCullDistanceScale(FFrame&, void* const)
native function float GetFSMFractureCullDistanceScale();

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
	CreateFSMParts();
	//return;	
}

simulated event Destroyed()
{
	super.Destroyed();
	CleanUpFSMParts();
	//return;	
}

final simulated function CleanUpFSMParts()
{
	local int Idx;

	Idx = 0;
	J0x0B:

	// End:0x68 [Loop If]
	if(Idx < PartPool.Length)
	{
		PartPool[Idx].Destroy();
		PartPool[Idx] = none;
		Idx++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

// Export UFractureManager::execCreateFSMParts(FFrame&, void* const)
native function CreateFSMParts();

// Export UFractureManager::execResetPoolVisibility(FFrame&, void* const)
native simulated function ResetPoolVisibility();

// Export UFractureManager::execGetFSMPart(FFrame&, void* const)
native function FracturedStaticMeshPart GetFSMPart(FracturedStaticMeshActor Parent, Vector SpawnLocation, Rotator SpawnRotation);

simulated event FracturedStaticMeshPart SpawnPartActor(FracturedStaticMeshActor Parent, Vector SpawnLocation, Rotator SpawnRotation)
{
	local FracturedStaticMeshPart NewPart;

	NewPart = GetFSMPart(Parent, SpawnLocation, SpawnRotation);
	// End:0x66
	if(NewPart != none)
	{
		NewPart.SetTimer(10.0000000, false, 'TryToCleanUp');
	}
	return NewPart;
	//return ReturnValue;	
}

simulated event ReturnPartActor(FracturedStaticMeshPart Part)
{
	FreeParts.AddItem(Part.PartPoolIndex);
	//return;	
}

simulated function Tick(float DeltaTime)
{
	local int CurActorIndex;

	// End:0x8D
	if(ActorsWithDeferredPartsToSpawn.Length > 0)
	{
		CurActorIndex = 0;
		J0x1B:

		// End:0x8D [Loop If]
		if(CurActorIndex < ActorsWithDeferredPartsToSpawn.Length)
		{
			// End:0x7F
			if(ActorsWithDeferredPartsToSpawn[CurActorIndex].SpawnDeferredParts())
			{
				ActorsWithDeferredPartsToSpawn.Remove(CurActorIndex, 1);
				--CurActorIndex;
			}
			++CurActorIndex;
			// [Loop Continue]
			goto J0x1B;
		}
	}
	//return;	
}

defaultproperties
{
	FSMPartPoolSize=50
	DestroyVibrationLevel=3.0000000
	DestroyMinAngVel=2.5000000
	ExplosionVelScale=1.0000000
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}