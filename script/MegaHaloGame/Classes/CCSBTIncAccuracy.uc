class CCSBTIncAccuracy extends CCSBTScriptBehavior;

var float AccurateChance;
var float HorizontalInaccuracy;
var float VerticalInaccuracy;
var float HorizontalAccurateZone;
var float VerticalAccurateZone;
var int BurstsBeforeRecalculation;
var bool FirstFrame;

function bool ExecutePre(GripBTInterface BTInterface)
{
	FirstFrame = true;
	return (Controller != none) && Controller.Pawn != none;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	// End:0x75
	if(BurstsBeforeRecalculation > 0)
	{
		Controller.BurstsBeforeRecalc += BurstsBeforeRecalculation;
		Controller.AccuracyRecalcBurstCount = Controller.BurstsBeforeRecalc;
	}
	// End:0xFB
	if(AccurateChance > float(0))
	{
		Controller.AccurateChance += AccurateChance;
		// End:0xFB
		if(Controller.AccurateChance > 1.0000000)
		{
			Controller.AccurateChance = 1.0000000;
		}
	}
	// End:0x135
	if(HorizontalInaccuracy > float(0))
	{
		Controller.HorizontalInaccuracy += HorizontalInaccuracy;
	}
	// End:0x16F
	if(VerticalInaccuracy > float(0))
	{
		Controller.VerticalInaccuracy += VerticalInaccuracy;
	}
	// End:0x1A9
	if(HorizontalAccurateZone > float(0))
	{
		Controller.HorizontalAccurateZone += HorizontalAccurateZone;
	}
	// End:0x1E3
	if(VerticalAccurateZone > float(0))
	{
		Controller.VerticalAccurateZone += VerticalAccurateZone;
	}
	// End:0x202
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
	NodeDescription="Increments the variables required for accuracy by the given values."
	DefaultTitle="Increment Accuracy"
}