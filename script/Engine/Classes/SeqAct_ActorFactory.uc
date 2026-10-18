class SeqAct_ActorFactory extends SeqAct_Latent
	native;

enum EPointSelection
{
	PS_Normal,                      // 0
	PS_Random,                      // 1
	PS_Reverse,                     // 2
	PS_MAX                          // 3
};

var bool bEnabled;
var bool bIsSpawning;
var bool bCheckSpawnCollision;
var bool bStartHidden;
var export editinline ActorFactory Factory;
var SeqAct_ActorFactory.EPointSelection PointSelection;
var Actor.EPhysics StartingPhysics;
var array<Actor> SpawnPoints;
var array<Vector> SpawnLocations;
var array<Vector> SpawnOrientations;
var int SpawnCount;
var float SpawnDelay;
var int LastSpawnIdx;
var int CurrentSpawnIdx;
var int SpawnedCount;
var float RemainingDelay;

static event int GetObjClassVersion()
{
	return super(SequenceObject).GetObjClassVersion() + 0;
	//return ReturnValue;	
}

defaultproperties
{
	bEnabled=true
	bCheckSpawnCollision=true
	StartingPhysics=EPhysics.PHYS_Falling
	SpawnCount=1
	SpawnDelay=0.5000000
	LastSpawnIdx=-1
	CurrentSpawnIdx=-1
	InputLinks[0]=(LinkDesc="Spawn Actor",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[2]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[3]=(LinkDesc="Toggle",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawn Point",LinkVar="None",PropertyName="SpawnPoints",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawned",LinkVar="None",PropertyName="None",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Spawn Count",LinkVar="None",PropertyName="SpawnCount",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Spawn Location",LinkVar="None",PropertyName="SpawnLocations",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Spawn Direction",LinkVar="None",PropertyName="SpawnOrientations",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Actor Factory"
}