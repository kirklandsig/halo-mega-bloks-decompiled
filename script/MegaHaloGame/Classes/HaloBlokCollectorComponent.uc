class HaloBlokCollectorComponent extends ActorComponent;

var int Bank;
var float PercentageToThrowOnDeath;
var float AttractionScalar;
var float CorrectionScalar;
var float OnFootAttractionRadius;
var float InVehicleAttractionRadius;
var float CollectionRadius;
var HaloPlayerPawnController MyController;

function AddToBank(int Amount)
{
	// End:0x39
	if(MyController != none)
	{
		MyController.ClientAddToBank(byte(Amount));
	}
	//return;	
}

function RemoveFromBank(int Amount)
{
	// End:0x39
	if(MyController != none)
	{
		MyController.ClientRemoveFromBank(byte(Amount));
	}
	//return;	
}

function int GetBankCount()
{
	return Bank;
	//return ReturnValue;	
}

function ThrowBloks(HaloPawn Pawn)
{
	local int amountToThrow;

	// End:0xA6
	if(Pawn.CollectibleBlokSpawner != none)
	{
		amountToThrow = Clamp(int(float(Bank) * (PercentageToThrowOnDeath / 100.0000000)), 0, 500);
		Pawn.CollectibleBlokSpawner.ThrowBloks(amountToThrow);
		Bank -= amountToThrow;
	}
	//return;	
}

defaultproperties
{
	PercentageToThrowOnDeath=10.0000000
	AttractionScalar=10.0000000
	CorrectionScalar=0.2500000
	OnFootAttractionRadius=600.0000000
	InVehicleAttractionRadius=900.0000000
	CollectionRadius=200.0000000
}