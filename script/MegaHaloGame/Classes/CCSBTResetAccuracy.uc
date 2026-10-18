class CCSBTResetAccuracy extends CCSBTScriptBehavior;

var bool FirstFrame;

function bool ExecutePre(GripBTInterface BTInterface)
{
	FirstFrame = true;
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	Controller.BurstsBeforeRecalc = Class'UDKBase.CCSController'.default.BurstsBeforeRecalc;
	Controller.AccuracyRecalcBurstCount = Controller.BurstsBeforeRecalc;
	Controller.AccurateChance = Class'UDKBase.CCSController'.default.AccurateChance;
	Controller.HorizontalInaccuracy = Class'UDKBase.CCSController'.default.HorizontalInaccuracy;
	Controller.VerticalInaccuracy = Class'UDKBase.CCSController'.default.VerticalInaccuracy;
	Controller.HorizontalAccurateZone = Class'UDKBase.CCSController'.default.HorizontalAccurateZone;
	Controller.VerticalAccurateZone = Class'UDKBase.CCSController'.default.VerticalAccurateZone;
	// End:0x1CA
	if(FirstFrame)
	{
		FirstFrame = false;
		return 2;		
	}
	else
	{
		return 0;
	}
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Sets the variables required for accuracy to the default values set in CCSController."
	DefaultTitle="ResetAccuracy"
}