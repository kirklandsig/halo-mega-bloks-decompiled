class CCSBTCrouch extends CCSBTScriptBehavior;

event bool ExecutePre(GripBTInterface BTInterface)
{
	return true;
	//return ReturnValue;	
}

event GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	// End:0x70
	if(!Controller.CCSPawn.IsCrouched())
	{
		Controller.CCSPawn.SetCrouched(true);
	}
	// End:0x80
	if(PushToFinish)
	{
		return 4;
	}
	return 2;
	//return ReturnValue;	
}

event ExecutePost(GripBTInterface BTInterface)
{
	Controller.CCSPawn.SetPostureDefault();
	//return;	
}

defaultproperties
{
	NodeDescription="Force the NPC to crouch. Uncrouch on exit. Perpetual behavior. "
	DefaultTitle="Crouch"
}