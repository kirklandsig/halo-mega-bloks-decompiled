class CCSBTScriptCover extends CCSBTScriptBehavior
	native
	dependson(CCSCover, CCSTarget);

enum ScriptCoverState
{
	EnterCover,                     // 0
	GetOutCover,                    // 1
	ShootFromCover,                 // 2
	ExitCover,                      // 3
	ScriptCoverState_MAX            // 4
};

var GripAFActionHandle CurrHandle;
var CCSAFEnterCover EnterHandle;
var CCSAFGetOutCover GetOutHandle;
var CCSAFFireBurst FireHandle;
var CCSAFExitCover ExitHandle;
var CCSCoverData Cover;
var CCSBTScriptCover.ScriptCoverState CoverState;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagCoversAsUsed();
	CCSBB.FlagTargetsAsUsed();
	//return;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	local bool bSuccess;
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	bSuccess = false;
	Cover = FindClosestValidCover(BTInterface.Blackboard);
	// End:0x1EF
	if(Cover.CoverLink != none)
	{
		Class'UDKBase.CCSCover'.static.LockCover(Cover, Controller.Pawn);
		EnterHandle = new Class'UDKBase.CCSAFEnterCover';
		EnterHandle.CoverLink = Cover.CoverLink;
		EnterHandle.Target = CCSBB.GetCurrentTarget().Pawn;
		CurrHandle = EnterHandle;
		bSuccess = BTInterface.ActionFramework.Execute(EnterHandle);
		// End:0x1EF
		if(bSuccess)
		{
			CoverState = 0;
		}
	}
	return bSuccess;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripAFActionHandle.GripAFActionStatus Status;
	local CCSTargetData Target;
	local CCSBlackboard CCSBB;

	// End:0x2D
	if(PushToFinish)
	{
		// End:0x2D
		if(int(CoverState) != int(3))
		{
			CoverState = 3;
		}
	}
	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	Status = BTInterface.ActionFramework.GetStatus(CurrHandle);
	// End:0x379
	if(int(Status) == int(0))
	{
		switch(CoverState)
		{
			// End:0x1D4
			case 0:
				GetOutHandle = new Class'UDKBase.CCSAFGetOutCover';
				GetOutHandle.CoverLink = Cover.CoverLink;
				GetOutHandle.Target = CCSBB.GetCurrentTarget().Pawn;
				CurrHandle = GetOutHandle;
				BTInterface.ActionFramework.Execute(GetOutHandle);
				CoverState = 1;
				// End:0x376
				break;
			// End:0x2D9
			case 1:
				Target = CCSBB.GetCurrentTarget();
				// End:0x227
				if(Target.Pawn == none)
				{
					return 1;
				}
				FireHandle = new Class'UDKBase.CCSAFFireBurst';
				FireHandle.Target = Target.Pawn;
				CurrHandle = FireHandle;
				BTInterface.ActionFramework.Execute(FireHandle);
				CoverState = 2;
				// End:0x376
				break;
			// End:0x355
			case 2:
				ExitHandle = new Class'UDKBase.CCSAFExitCover';
				CurrHandle = ExitHandle;
				BTInterface.ActionFramework.Execute(ExitHandle);
				CoverState = 3;
				// End:0x376
				break;
			// End:0x373
			case 3:
				// End:0x36D
				if(PushToFinish)
				{
					return 4;					
				}
				else
				{
					return 0;
				}
				// End:0x376
				break;
			// End:0xFFFF
			default:
				break;
		}		
	}
	else
	{
		// End:0x390
		if(int(Status) == int(1))
		{
			return 1;
		}
	}
	return 2;
	//return ReturnValue;	
}

function ExecutePost(GripBTInterface BTInterface)
{
	// End:0x68
	if(Cover.CoverLink != none)
	{
		Class'UDKBase.CCSCover'.static.UnlockCover(Cover, Controller.Pawn);
	}
	//return;	
}

function CCSCoverData FindClosestValidCover(GripBlackboard BB)
{
	local array<CCSCoverData> CoverDatas;
	local CCSCoverData ClosestCover;
	local int I, ClosestDist;
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BB);
	// End:0x35
	if(CCSBB == none)
	{
		return ClosestCover;
	}
	ClosestDist = 2147483647;
	CCSBB.GetCovers(CoverDatas);
	I = 0;
	J0x77:

	// End:0x151 [Loop If]
	if(I < CoverDatas.Length)
	{
		// End:0xBE
		if(!CoverDatas[I].IsValid)
		{			
		}
		else
		{
			// End:0x143
			if(CoverDatas[I].DirectDistance < float(ClosestDist))
			{
				ClosestCover = CoverDatas[I];
				ClosestDist = int(CoverDatas[I].DirectDistance);
			}
		}
		++I;
		// [Loop Continue]
		goto J0x77;
	}
	return ClosestCover;
	//return ReturnValue;	
}

defaultproperties
{
	DefaultTitle="ScriptShootFromCover"
}