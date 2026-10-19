class GameCrowdBehavior_PlayAnimation extends GameCrowdAgentBehavior
	native
	dependson(GameCrowdAgent);

var array<name> AnimationList;
var float BlendInTime;
var float BlendOutTime;
var bool bUseRootMotion;
var bool bLookAtPlayer;
var bool bLooping;
var bool bBlendBetweenAnims;
var Actor CustomActionTarget;
var int LoopIndex;
var float LoopTime;
var SeqAct_PlayAgentAnimation AnimSequence;
var int AnimationIndex;

function InitBehavior(GameCrowdAgent Agent)
{
	local PlayerController PC, ClosestPC;
	local float ClosestDist, newdist;
	local GameCrowdAgentSkeletal SkAgent;

	super.InitBehavior(Agent);
	// End:0x38
	if(CustomActionTarget != none)
	{
		ActionTarget = CustomActionTarget;		
	}
	else
	{
		// End:0x181
		if(bLookAtPlayer)
		{
			ClosestDist = 1000000.0000000;
			// End:0x149
			foreach Agent.LocalPlayerControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x148
				if(PC.Pawn != none)
				{
					newdist = VSize(PC.Pawn.Location - Agent.Location);
					// End:0x148
					if(newdist < ClosestDist)
					{
						ClosestDist = newdist;
						ClosestPC = PC;
					}
				}				
			}			
			// End:0x181
			if(ClosestPC != none)
			{
				ActionTarget = ClosestPC.Pawn;
			}
		}
	}
	SkAgent = GameCrowdAgentSkeletal(Agent);
	// End:0x1FD
	if(SkAgent == none)
	{
		WarnInternal((("PlayAnimation behavior " $ string(self)) $ " called on non-skeletal agent ") $ string(Agent));
		return;
	}
	AnimationIndex = 0;
	// End:0x221
	if(!bFaceActionTargetFirst)
	{
		PlayAgentAnimationNow();
	}
	//return;	
}

event FinishedTargetRotation()
{
	PlayAgentAnimationNow();
	//return;	
}

// Export UGameCrowdBehavior_PlayAnimation::execSetSequenceOutput(FFrame&, void* const)
native function SetSequenceOutput();

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	AnimationIndex++;
	// End:0x30
	if(AnimationList.Length > AnimationIndex)
	{
		PlayAgentAnimationNow();		
	}
	else
	{
		// End:0xCF
		if((AnimSequence != none) && AnimSequence.OutputLinks[0].Links.Length > 0)
		{
			SetSequenceOutput();
			MyAgent.ClearLatentAction(Class'GameFramework.SeqAct_PlayAgentAnimation', false);
			AnimSequence.ActivateOutputLink(0);
		}
		MyAgent.StopBehavior();
	}
	//return;	
}

function PlayAgentAnimationNow()
{
	local float CurrentBlendInTime, CurrentBlendOutTime;
	local GameCrowdAgentSkeletal MySkAgent;

	MySkAgent = GameCrowdAgentSkeletal(MyAgent);
	bFaceActionTargetFirst = false;
	MySkAgent.SetRootMotion(bUseRootMotion);
	CurrentBlendInTime = 0.0000000;
	CurrentBlendOutTime = 0.0000000;
	// End:0x173
	if(bLooping && AnimationIndex == LoopIndex)
	{
		// End:0xC6
		if(bBlendBetweenAnims || AnimationIndex == 0)
		{
			CurrentBlendInTime = BlendInTime;
		}
		MySkAgent.FullBodySlot.PlayCustomAnim(AnimationList[AnimationIndex], 1.0000000, CurrentBlendInTime, CurrentBlendOutTime, bLooping, true);
		// End:0x170
		if(LoopTime > 0.0000000)
		{
			MySkAgent.SetTimer(LoopTime, false, 'OnAnimEnd');
		}		
	}
	else
	{
		// End:0x1A9
		if(bBlendBetweenAnims)
		{
			CurrentBlendInTime = BlendInTime;
			CurrentBlendOutTime = BlendOutTime;			
		}
		else
		{
			// End:0x1CB
			if(AnimationIndex == 0)
			{
				CurrentBlendInTime = BlendInTime;
			}
		}
		MySkAgent.FullBodySlot.PlayCustomAnim(AnimationList[AnimationIndex], 1.0000000, CurrentBlendInTime, CurrentBlendOutTime, false, true);
		MySkAgent.FullBodySlot.SetActorAnimEndNotification(true);
	}
	// End:0x292
	if(AnimSequence != none)
	{
		AnimSequence.ActivateOutputLink(2);
	}
	//return;	
}

function StopBehavior()
{
	GameCrowdAgentSkeletal(MyAgent).FullBodySlot.StopCustomAnim(BlendOutTime);
	GameCrowdAgentSkeletal(MyAgent).SetRootMotion(false);
	super.StopBehavior();
	//return;	
}

function string GetBehaviorString()
{
	local string BehaviorString;

	BehaviorString = "Behavior: " $ string(self);
	// End:0x5E
	if(bFaceActionTargetFirst)
	{
		BehaviorString = (BehaviorString @ "Turning toward ") $ string(ActionTarget);		
	}
	else
	{
		// End:0xC4
		if((AnimationList.Length <= AnimationIndex) || AnimationList[AnimationIndex] == 'None')
		{
			BehaviorString = BehaviorString @ "MISSING ANIMATION";			
		}
		else
		{
			BehaviorString = (BehaviorString @ "Playing ") $ string(AnimationList[AnimationIndex]);
		}
	}
	return BehaviorString;
	//return ReturnValue;	
}

defaultproperties
{
	BlendInTime=0.2000000
	BlendOutTime=0.2000000
	LoopTime=-1.0000000
	bIdleBehavior=true
}