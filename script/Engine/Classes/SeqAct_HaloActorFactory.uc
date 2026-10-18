class SeqAct_HaloActorFactory extends SeqAct_Latent
	native;

struct native HaloActorFactoryLaunchpoint
{
	var export editinline ActorFactory Factory;
	var int SpawnCount;
	var bool bStartHidden;
	var Actor.EPhysics StartingPhysics;
	var bool bCheckSpawnCollision;
	var int SpawnedCount;

	structdefaultproperties
	{
		Factory=none
		SpawnCount=1
		bStartHidden=false
		StartingPhysics=EPhysics.PHYS_Falling
		bCheckSpawnCollision=true
		SpawnedCount=0
	}
};

var export editinline array<export editinline HaloActorFactoryLaunchpoint> FactoryArray;
var bool bEnabled;
var bool bIsSpawning;
var SeqAct_ActorFactory.EPointSelection PointSelection;
var array<Actor> SpawnPoints;
var float SpawnDelay;
var float RemainingDelay;
var int LastSpawnIdx;
var int CurrentSpawnIdx;
var int TotalSpawnedCount;

static event int GetObjClassVersion()
{
	return super(SequenceObject).GetObjClassVersion() + 0;
	//return ReturnValue;	
}

defaultproperties
{
	bEnabled=true
	SpawnDelay=0.5000000
	LastSpawnIdx=-1
	CurrentSpawnIdx=-1
	InputLinks[0]=(LinkDesc="Spawn Actors",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[2]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[3]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[2]=(Links=none,LinkDesc="Finished All",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawn Point",LinkVar="None",PropertyName="SpawnPoints",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Halo Actor Factory"
}