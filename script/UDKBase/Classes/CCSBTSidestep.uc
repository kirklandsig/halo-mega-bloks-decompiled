class CCSBTSidestep extends CCSBTScriptBehavior;

var float BlendInTime;
var float BlendOutTime;
var name SidestepBlendName;
var name SidestepSequenceNames[2];
var AnimNodeBlendList SidestepBlend;
var AnimNodeSequence SidestepSequences[2];
var Rotator InitialRotation;
var int activeAnimIndex;
var float initialDistFromFloor;

function Initialize()
{
	super.Initialize();
	SidestepBlend = AnimNodeBlendList(Controller.Pawn.Mesh.FindAnimNode(SidestepBlendName));
	SidestepSequences[0] = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(SidestepSequenceNames[0]));
	SidestepSequences[1] = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(SidestepSequenceNames[1]));
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return ((SidestepBlend != none) && SidestepSequences[0] != none) && SidestepSequences[1] != none;
	//return ReturnValue;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	local Vector directions[2], junk;
	local CCSBlackboard CCSBB;
	local int I, numValid, bestIndex;
	local Actor TraceHitActor;

	directions[0] = vect(0.0000000, -1.0000000, 0.0000000);
	directions[1] = vect(0.0000000, 1.0000000, 0.0000000);
	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0x74
	if(CCSBB == none)
	{
		return false;
	}
	bestIndex = -1;
	numValid = 0;
	I = 0;
	J0x99:

	// End:0x1E9 [Loop If]
	if(I < 2)
	{
		TraceHitActor = Controller.Pawn.Trace(junk, junk, Controller.Pawn.Location + ((directions[I] >> Controller.Pawn.Rotation) * 500.0000000), Controller.Pawn.Location, false);
		// End:0x1DB
		if(TraceHitActor == none)
		{
			++numValid;
			bestIndex = I;
		}
		++I;
		// [Loop Continue]
		goto J0x99;
	}
	// End:0x1FD
	if(numValid == 0)
	{
		return false;		
	}
	else
	{
		// End:0x21B
		if(numValid == 2)
		{
			bestIndex = Rand(2);
		}
	}
	activeAnimIndex = bestIndex;
	InitialRotation = Controller.Pawn.Rotation;
	Controller.Pawn.Mesh.RootMotionMode = 0;
	SidestepBlend.SetActiveChild(activeAnimIndex + 1, BlendInTime);
	SidestepSequences[activeAnimIndex].PlayAnim();
	initialDistFromFloor = Controller.Pawn.Location.Z - Controller.Pawn.WalkableFloorZ;
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripBTNode.BTExecutionResult ExecRes;

	ExecRes = 2;
	Controller.Pawn.SetRotation(InitialRotation);
	Controller.Pawn.SetPhysics(2);
	// End:0xF9
	if(!SidestepSequences[activeAnimIndex].bPlaying)
	{
		Controller.Pawn.SetPhysics(1);
		// End:0xEA
		if(PushToFinish)
		{
			ExecRes = 4;			
		}
		else
		{
			ExecRes = 0;
		}		
	}
	else
	{
		// End:0x112
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
	SidestepSequences[activeAnimIndex].StopAnim();
	SidestepBlend.SetActiveChild(0, BlendOutTime);
	Controller.Pawn.Mesh.RootMotionMode = 2;
	//return;	
}

defaultproperties
{
	BlendInTime=0.1000000
	BlendOutTime=0.1000000
	SidestepBlendName="SidestepBlend"
	SidestepSequenceNames[0]="SideStepLeft"
	SidestepSequenceNames[1]="SideStepRight"
	NodeDescription="Force the NPC to Sidestep. Succeeds after Sidestep animation is completed. Not interruptible."
	DefaultTitle="Sidestep"
}