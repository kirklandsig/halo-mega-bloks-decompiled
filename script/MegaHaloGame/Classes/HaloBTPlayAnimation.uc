class HaloBTPlayAnimation extends CCSBTScriptBehavior;

var name AnimationName;
var float BlendInTime;
var float BlendOutTime;
var float MinimumRate;
var float MaximumRate;
var bool Looping;
var bool Interruptible;
var const AnimNodeSequence.ERootBoneAxis RootBoneOption[3];
var const AnimNodeSequence.ERootRotationOption RootRotationOption[3];
var HaloPawn HaloPawn;
var float TimeBlendingStarts;
var WorldInfo WorldInfo;

function bool ExecutePre(GripBTInterface BTInterface)
{
	local float Rate, Duration;

	HaloPawn = HaloPawn(Controller.Pawn);
	// End:0x42
	if(HaloPawn == none)
	{
		return false;
	}
	WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
	Rate = MinimumRate + (FRand() * (MaximumRate - MinimumRate));
	Duration = HaloPawn.PlayCustomAnimation(AnimationName,, Looping,,, BlendInTime, BlendOutTime, Rate);
	TimeBlendingStarts = (WorldInfo.TimeSeconds + Duration) - BlendOutTime;
	// End:0x24F
	if(((HaloPawn.Mesh != none) && HaloPawn.FullBodyAnimSlot != none) && ((int(RootBoneOption[0]) == int(2)) || int(RootBoneOption[1]) == int(2)) || int(RootBoneOption[2]) == int(2))
	{
		HaloPawn.FullBodyAnimSlot.SetRootBoneAxisOption(RootBoneOption[0], RootBoneOption[1], RootBoneOption[2]);
		HaloPawn.Mesh.RootMotionMode = 3;
	}
	// End:0x3B0
	if(((HaloPawn.Mesh != none) && HaloPawn.FullBodyAnimSlot != none) && ((int(RootRotationOption[0]) == int(2)) || int(RootRotationOption[1]) == int(2)) || int(RootRotationOption[2]) == int(2))
	{
		HaloPawn.FullBodyAnimSlot.SetRootBoneRotationOption(RootRotationOption[0], RootRotationOption[1], RootRotationOption[2]);
		HaloPawn.Mesh.RootMotionRotationMode = 1;
		HaloPawn.Controller.SetFocalPoint(vect(0.0000000, 0.0000000, 0.0000000));
	}
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripBTNode.BTExecutionResult ExecRes;

	ExecRes = 2;
	// End:0x89
	if(!HaloPawn.IsPlayingCustomAnimation() || WorldInfo.TimeSeconds >= TimeBlendingStarts)
	{
		// End:0x7A
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
		// End:0xD8
		if(PushToFinish)
		{
			ExecRes = 2;
			// End:0xD8
			if(Interruptible)
			{
				HaloPawn.StopCustomAnimation(,, BlendOutTime);
			}
		}
	}
	return ExecRes;
	//return ReturnValue;	
}

function ExecutePost(GripBTInterface BTInterface)
{
	// End:0xCD
	if((HaloPawn != none) && HaloPawn.Mesh != none)
	{
		HaloPawn.Mesh.RootMotionMode = 2;
		HaloPawn.Mesh.RootMotionRotationMode = 0;
		HaloPawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	}
	//return;	
}

defaultproperties
{
	BlendInTime=0.2500000
	BlendOutTime=0.2500000
	MinimumRate=0.8000000
	MaximumRate=1.2000000
	Interruptible=true
	NodeDescription="Force the NPC to play an animation."
	DefaultTitle="Play Animation"
}