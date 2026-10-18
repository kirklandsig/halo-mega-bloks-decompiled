class HaloObjBase extends Object;

enum CompletionStatus
{
	CS_Inactive,                    // 0
	CS_InProgress,                  // 1
	CS_Complete,                    // 2
	CS_Failed,                      // 3
	CS_MAX                          // 4
};

var name Title;
var string Description;
var HaloObjBase.CompletionStatus Status;
var Object UITag;
var bool bAvailableOnStart;
var bool bTickOnCompletion;
var bool bTickOnFailure;
var bool bImpulse;
var bool bImpulseLastFrame;

simulated function Tick(float DeltaTime)
{
	// End:0x35
	if(bImpulse)
	{
		// End:0x29
		if(bImpulseLastFrame)
		{
			bImpulseLastFrame = false;			
		}
		else
		{
			bImpulse = false;
		}
	}
	//return;	
}

simulated function SetStatus(HaloObjBase.CompletionStatus NewStatus)
{
	Status = NewStatus;
	//return;	
}

simulated function SetImpulse()
{
	bImpulse = true;
	bImpulseLastFrame = true;
	//return;	
}

defaultproperties
{
	Title="Title"
	Description="Description"
	bAvailableOnStart=true
}