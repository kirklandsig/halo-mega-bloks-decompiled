class GripBTCutoff extends GripBTNumericCondition
	native;

var int Cutoff;

function SetCutoff(int newCutoff)
{
	Cutoff = newCutoff;
	//return;	
}

function GripBTObject.BTNodeFamily GetFamily()
{
	return 1;
	//return ReturnValue;	
}

defaultproperties
{
	Cutoff=1
	NodeDescription="Cap the number of times child node may run."
	DefaultTitle="Cutoff"
}