class CCSBTMelee extends CCSBTScriptBehavior;

var float BlendInTime;
var float BlendOutTime;
var name MeleeBlendName;
var name MeleeSequenceName;
var AnimNodeBlend MeleeBlend;
var AnimNodeSequence MeleeSequence;

function Initialize()
{
	local editinline SkeletalMeshComponent SkelMesh;

	super.Initialize();
	SkelMesh = Controller.Pawn.Mesh;
	MeleeBlend = AnimNodeBlend(SkelMesh.FindAnimNode(MeleeBlendName));
	MeleeSequence = AnimNodeSequence(SkelMesh.FindAnimNode(MeleeSequenceName));
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return (MeleeBlend != none) && MeleeSequence != none;
	//return ReturnValue;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	MeleeBlend.SetBlendTarget(1.0000000, BlendInTime);
	MeleeSequence.PlayAnim();
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripBTNode.BTExecutionResult ExecRes;

	ExecRes = 2;
	// End:0x5B
	if(!MeleeSequence.bPlaying)
	{
		// End:0x4C
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
		// End:0x74
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
	MeleeBlend.SetBlendTarget(0.0000000, BlendOutTime);
	//return;	
}

defaultproperties
{
	BlendInTime=0.1000000
	BlendOutTime=0.1000000
	MeleeBlendName="MeleeBlend"
	MeleeSequenceName="Melee"
	NodeDescription="Force the NPC to Melee. Succeeds after Melee animation is completed. Not interruptible."
	DefaultTitle="Melee"
}