class GripBTScriptBehavior extends GripBTScriptNode
	abstract
	native;

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return true;
	//return ReturnValue;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	//return ReturnValue;	
}

function ExecutePost(GripBTInterface BTInterface)
{
	//return;	
}

event GripBTNode.BTExecutionResult ExecutePass(GripBTInterface BTInterface, bool FirstExecution, bool PushToFinish)
{
	local GripBTNode.BTExecutionResult ExecRes;
	local bool PreSuccess;

	ExecRes = 1;
	PreSuccess = true;
	// End:0x43
	if(FirstExecution)
	{
		PreSuccess = ExecutePre(BTInterface);
	}
	// End:0x7A
	if(PreSuccess == true)
	{
		ExecRes = Execute(BTInterface, PushToFinish);
	}
	// End:0xA1
	if(int(ExecRes) != int(2))
	{
		ExecutePost(BTInterface);
	}
	return ExecRes;
	//return ReturnValue;	
}
