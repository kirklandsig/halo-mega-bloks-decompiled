class CCSBTExitPhantom extends CCSBTScriptBehavior;

var float BlendOutTime;
var name ExitBlendName;
var name ExitSequenceName;
var name FallBlendName;
var AnimNodeBlendList ExitBlend;
var AnimNodeBlendList FallBlend;
var AnimNodeSequence ExitSequence;
var bool startedFalling;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	//return;	
}

function Initialize()
{
	super.Initialize();
	ExitBlend = AnimNodeBlendList(Controller.Pawn.Mesh.FindAnimNode(ExitBlendName));
	FallBlend = AnimNodeBlendList(Controller.Pawn.Mesh.FindAnimNode(FallBlendName));
	ExitSequence = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(ExitSequenceName));
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return ((ExitBlend != none) && ExitSequence != none) && FallBlend != none;
	//return ReturnValue;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	ExitBlend.SetActiveChild(1, 0.0000000);
	ExitSequence.PlayAnim();
	startedFalling = false;
	Controller.Pawn.SetHidden(false);
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripBTNode.BTExecutionResult ExecRes;

	ExecRes = 2;
	// End:0x131
	if(!ExitSequence.bPlaying)
	{
		// End:0x7A
		if(!startedFalling)
		{
			startedFalling = true;
			Controller.Pawn.SetPhysics(2);
		}
		ExitBlend.SetActiveChild(0, BlendOutTime);
		FallBlend.SetActiveChild(1, 0.0000000);
		// End:0x12E
		if(int(Controller.Pawn.Physics) != int(2))
		{
			// End:0x122
			if(PushToFinish)
			{
				ExecRes = 4;				
			}
			else
			{
				ExecRes = 0;
			}
		}		
	}
	else
	{
		Controller.Pawn.Velocity.Z = 0.0000000;
		// End:0x196
		if(PushToFinish)
		{
			ExecRes = 3;
		}
	}
	return ExecRes;
	//return ReturnValue;	
}

function ExecutePost(GripBTInterface BTInterface)
{
	ExitBlend.SetActiveChild(0, BlendOutTime);
	FallBlend.SetActiveChild(0, 0.0000000);
	//return;	
}

defaultproperties
{
	BlendOutTime=1.0000000
	ExitBlendName="ExitVehicleBlend"
	ExitSequenceName="ExitPhantom"
	FallBlendName="SpecialFallBlender"
	NodeDescription="Force the NPC to play the animation to get out of the phantom. Succeeds after exit animation is completed. Not interruptible."
	DefaultTitle="Exit Phantom"
}