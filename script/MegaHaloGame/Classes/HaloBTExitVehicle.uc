class HaloBTExitVehicle extends CCSBTScriptBehavior;

var HaloWeaponPawn WeaponPawn;
var UDKVehicleBase Vehicle;
var bool FirstFrame;

function bool ExecutePre(GripBTInterface BTInterface)
{
	WeaponPawn = HaloWeaponPawn(Controller.Pawn);
	Vehicle = UDKVehicleBase(Controller.Pawn);
	FirstFrame = true;
	// End:0x90
	if((WeaponPawn == none) && Vehicle == none)
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	// End:0x97
	if(FirstFrame)
	{
		// End:0x5C
		if(WeaponPawn != none)
		{
			WeaponPawn.MyVehicle.GwNavBotExitVehicle(WeaponPawn);			
		}
		else
		{
			// End:0x8B
			if(Vehicle != none)
			{
				Vehicle.GwNavBotExitVehicle(none);
			}
		}
		FirstFrame = false;
	}
	return 2;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Make the driver exit if they're in a vehicle."
	DefaultTitle="Exit Vehicle"
}