class CCSBTSetAccuracy extends CCSBTScriptBehavior;

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
	Controller.BurstsBeforeRecalc = BurstsBeforeRecalculation;
	Controller.AccuracyRecalcBurstCount = BurstsBeforeRecalculation;
	Controller.AccurateChance = AccurateChance;
	Controller.HorizontalInaccuracy = HorizontalInaccuracy;
	Controller.VerticalInaccuracy = VerticalInaccuracy;
	Controller.HorizontalAccurateZone = HorizontalAccurateZone;
	Controller.VerticalAccurateZone = VerticalAccurateZone;
	// End:0x137
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
	AccurateChance=1.0000000
	HorizontalInaccuracy=2.0000000
	VerticalInaccuracy=2.0000000
	HorizontalAccurateZone=0.5000000
	VerticalAccurateZone=0.5000000
	BurstsBeforeRecalculation=5
	NodeDescription="Sets the variables required for accuracy."
	DefaultTitle="SetAccuracy"
}