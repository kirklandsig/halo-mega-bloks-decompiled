class GameCrowdReplicationActor extends Actor
	native
	notplaceable;

var repnotify SeqAct_GameCrowdSpawner Spawner;
var repnotify bool bSpawningActive;
var repnotify int DestroyAllCount;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		DestroyAllCount, Spawner, 
		bSpawningActive;
}

simulated event ReplicatedEvent(name VarName)
{
	//return;	
}

auto state ReceivingReplication
{
	ignores Tick;
	stop;	
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	CollisionType=COLLIDE_CustomDefault
	TickGroup=TG_DuringAsyncWork
	bAlwaysRelevant=true
	bReplicateMovement=false
	bSkipActorPropertyReplication=true
	bOnlyDirtyReplication=true
	NetUpdateFrequency=1.0000000
	NetPriority=2.7000000
}