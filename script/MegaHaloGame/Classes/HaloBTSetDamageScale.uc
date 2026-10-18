class HaloBTSetDamageScale extends CCSBTScriptBehavior;

var float DamageScale;

function bool ExecutePre(GripBTInterface BTInterface)
{
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local HaloAIPawn haiPawn;

	haiPawn = HaloAIPawn(Controller.Pawn);
	// End:0x43
	if(haiPawn == none)
	{
		return 1;
	}
	haiPawn.DamageScale = DamageScale;
	return 0;
	//return ReturnValue;	
}

defaultproperties
{
	DamageScale=1.0000000
	NodeDescription="Sets the scalar to multiply damage by."
	DefaultTitle="Set Damage Scale"
}