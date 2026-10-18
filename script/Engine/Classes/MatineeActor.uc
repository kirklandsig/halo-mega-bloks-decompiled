class MatineeActor extends Actor
	native
	nativereplication
	notplaceable;

const MAX_AIGROUP_NUMBER = 10;

var const SeqAct_Interp InterpAction;
var bool bIsPlaying;
var bool bReversePlayback;
var bool bPaused;
var transient bool AllAIGroupsInitialized;
var float PlayRate;
var float Position;
var name AIGroupNames[10];
var Pawn AIGroupPawns[10];
var transient int AIGroupInitStage[10];
var float ClientSidePositionErrorTolerance;

replication
{
	// Pos:0x000
	if(bNetInitial && int(Role) == int(ROLE_Authority))
		InterpAction;

	// Pos:0x020
	if(bNetDirty && int(Role) == int(ROLE_Authority))
		AIGroupNames, AIGroupPawns, 
		PlayRate, Position, 
		bIsPlaying, bPaused, 
		bReversePlayback;
}

// Export UMatineeActor::execAddAIGroupActor(FFrame&, void* const)
native function AddAIGroupActor(InterpGroupInstAI AIGroupInst);

event Update()
{
	local InterpGroupInstAI AIGroupInst;
	local int GroupID;

	bIsPlaying = InterpAction.bIsPlaying;
	bReversePlayback = InterpAction.bReversePlayback;
	bPaused = InterpAction.bPaused;
	PlayRate = InterpAction.PlayRate;
	Position = InterpAction.Position;
	bForceNetUpdate = true;
	// End:0xFD
	if(bIsPlaying)
	{
		SetTimer(1.0000000, true, 'CheckPriorityRefresh');		
	}
	else
	{
		ClearTimer('CheckPriorityRefresh');
	}
	// End:0x1C3
	if(InterpAction != none)
	{
		GroupID = 0;
		J0x12B:

		// End:0x1C3 [Loop If]
		if(GroupID < InterpAction.GroupInst.Length)
		{
			AIGroupInst = InterpGroupInstAI(InterpAction.GroupInst[GroupID]);
			// End:0x1B5
			if(AIGroupInst != none)
			{
				AddAIGroupActor(AIGroupInst);
			}
			GroupID++;
			// [Loop Continue]
			goto J0x12B;
		}
	}
	//return;	
}

function CheckPriorityRefresh()
{
	local Controller C;
	local int I;

	// End:0x227
	if(InterpAction != none)
	{
		I = 0;
		J0x1A:

		// End:0xA6 [Loop If]
		if(I < InterpAction.GroupInst.Length)
		{
			// End:0x98
			if(InterpGroupInstDirector(InterpAction.GroupInst[I]) != none)
			{
				bNetDirty = true;
				bForceNetUpdate = true;
				return;
			}
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
		// End:0x226
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			// End:0x225
			if((C.bIsPlayer && C.Pawn != none) && (InterpAction.LatentActors.Find(C.Pawn) != -1) || (C.Pawn.Base != none) && InterpAction.LatentActors.Find(C.Pawn.Base) != -1)
			{
				bNetDirty = true;
				bForceNetUpdate = true;				
				return;
			}			
		}		
	}
	//return;	
}

defaultproperties
{
	PlayRate=1.0000000
	Position=-1.0000000
	ClientSidePositionErrorTolerance=0.1000000
	Components[0]=none
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bAlwaysRelevant=true
	bReplicateMovement=false
	bSkipActorPropertyReplication=true
	bOnlyDirtyReplication=true
	NetUpdateFrequency=1.0000000
	NetPriority=2.7000000
}