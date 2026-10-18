class CCSBTDecAccuracy extends CCSBTScriptBehavior;

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
	// End:0xB9
	if(BurstsBeforeRecalculation > 0)
	{
		Controller.BurstsBeforeRecalc -= BurstsBeforeRecalculation;
		// End:0x7C
		if(Controller.BurstsBeforeRecalc <= 0)
		{
			Controller.BurstsBeforeRecalc = 1;
		}
		Controller.AccuracyRecalcBurstCount = Controller.BurstsBeforeRecalc;
	}
	// End:0x13F
	if(AccurateChance > float(0))
	{
		Controller.AccurateChance -= AccurateChance;
		// End:0x13F
		if(Controller.AccurateChance < 0.0000000)
		{
			Controller.AccurateChance = 0.0000000;
		}
	}
	// End:0x1C5
	if(HorizontalInaccuracy > float(0))
	{
		Controller.HorizontalInaccuracy -= HorizontalInaccuracy;
		// End:0x1C5
		if(Controller.HorizontalInaccuracy < 0.0000000)
		{
			Controller.HorizontalInaccuracy = 0.0000000;
		}
	}
	// End:0x24B
	if(VerticalInaccuracy > float(0))
	{
		Controller.VerticalInaccuracy -= VerticalInaccuracy;
		// End:0x24B
		if(Controller.VerticalInaccuracy < 0.0000000)
		{
			Controller.VerticalInaccuracy = 0.0000000;
		}
	}
	// End:0x2D1
	if(HorizontalAccurateZone > float(0))
	{
		Controller.HorizontalAccurateZone -= HorizontalAccurateZone;
		// End:0x2D1
		if(Controller.HorizontalAccurateZone < 0.0000000)
		{
			Controller.HorizontalAccurateZone = 0.0000000;
		}
	}
	// End:0x357
	if(VerticalAccurateZone > float(0))
	{
		Controller.VerticalAccurateZone -= VerticalAccurateZone;
		// End:0x357
		if(Controller.VerticalAccurateZone < 0.0000000)
		{
			Controller.VerticalAccurateZone = 0.0000000;
		}
	}
	// End:0x376
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
	NodeDescription="Decrements the variables required for accuracy by the given values."
	DefaultTitle="Decrement Accuracy"
}