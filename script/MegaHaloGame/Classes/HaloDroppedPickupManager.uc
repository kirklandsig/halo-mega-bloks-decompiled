class HaloDroppedPickupManager extends Actor
	notplaceable;

struct PickupTracker
{
	var Class<Inventory> InvClass;
	var int Rank;
	var int MaxCount;
	var array<HaloDroppedPickup> Pickups;

	structdefaultproperties
	{
		InvClass=none
		Rank=0
		MaxCount=3
		Pickups=none
	}
};

struct HaloDroppedPickupWithDistSq
{
	var HaloDroppedPickup Pickup;
	var float DistSq;

	structdefaultproperties
	{
		Pickup=none
		DistSq=0.0000000
	}
};

var array<PickupTracker> Trackers;
var int TotalPickupCount;
var int MaxPickupCount;

function Register(HaloDroppedPickup Pickup)
{
	local int I;

	// End:0x6B
	if(Pickup.Inventory == none)
	{
		WarnInternal(("Pickup '" $ string(Pickup)) $ "' has no inventory!  Unable to register.");
		return;
	}
	I = GetTrackerIndexByClass(Pickup.Inventory.Class, true);
	// End:0x107
	if(I < 0)
	{
		WarnInternal(("Pickup '" $ string(Pickup)) $ "' has no tracker!  Unable to register.");
		return;
	}
	Trackers[I].Pickups.AddItem(Pickup);
	TotalPickupCount += 1;
	// End:0x1AB
	if(Trackers[I].Pickups.Length > Trackers[I].MaxCount)
	{
		DestroyOldestPickupByTrackerIndex(I);
	}
	// End:0x1CC
	if(TotalPickupCount > MaxPickupCount)
	{
		DestroyLeastDesirablePickup();
	}
	//return;	
}

function Unregister(HaloDroppedPickup Pickup)
{
	local int I;

	// End:0xDA
	if(Pickup.Inventory == none)
	{
		WarnInternal(("Pickup '" $ string(Pickup)) $ "' has no inventory!  May not be able to unregister.");
		I = 0;
		J0x7F:

		// End:0xD8 [Loop If]
		if(I < Trackers.Length)
		{
			Trackers[I].Pickups.RemoveItem(Pickup);
			++I;
			// [Loop Continue]
			goto J0x7F;
		}
		return;
	}
	I = GetTrackerIndexByClass(Pickup.Inventory.Class, false);
	// End:0x178
	if(I < 0)
	{
		WarnInternal(("Pickup '" $ string(Pickup)) $ "' has no tracker!  Unable to unregister.");
		return;
	}
	Trackers[I].Pickups.RemoveItem(Pickup);
	TotalPickupCount -= 1;
	//return;	
}

function FindPickupsInRange(out array<HaloDroppedPickupWithDistSq> List, Vector Loc, float Radius, Class<Inventory> InvClass)
{
	local int I;
	local float radiusSq;
	local HaloDroppedPickup Pickup;
	local Vector toPickup;
	local HaloDroppedPickupWithDistSq toAdd;

	List.Length = 0;
	I = GetTrackerIndexByClass(InvClass, false);
	// End:0x3B
	if(I < 0)
	{
		return;
	}
	radiusSq = Radius * Radius;
	// End:0x166
	foreach Trackers[I].Pickups(Pickup)
	{
		toPickup = Pickup.Location - Loc;
		toAdd.DistSq = VSizeSq(toPickup);
		// End:0x129
		if((Radius >= float(0)) && toAdd.DistSq > radiusSq)
		{
			continue;			
		}
		else
		{
			toAdd.Pickup = Pickup;
			List.AddItem(toAdd);			
		}
	}	
	List.Sort(HaloDroppedPickupWithDistSq_LessThan);
	//return;	
}

static function int HaloDroppedPickupWithDistSq_LessThan(HaloDroppedPickupWithDistSq A, HaloDroppedPickupWithDistSq B)
{
	// End:0x3F
	if(A.DistSq < B.DistSq)
	{
		return 1;
	}
	// End:0x82
	if(A.DistSq > B.DistSq)
	{
		return -1;
	}
	return 0;
	//return ReturnValue;	
}

function int GetTrackerIndexByClass(Class<Inventory> InvClass, bool bCreateIfNotFound)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x6F [Loop If]
	if(I < Trackers.Length)
	{
		// End:0x61
		if(Trackers[I].InvClass == InvClass)
		{
			return I;
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x123
	if(bCreateIfNotFound)
	{
		I = Trackers.Length;
		Trackers.Add(1);
		Trackers[I].InvClass = InvClass;
		WarnInternal(("Inventory class '" $ string(InvClass)) $ "' had no pickup tracker!  Creating one.");
		return I;
	}
	return -1;
	//return ReturnValue;	
}

function DestroyOldestPickupByTrackerIndex(int X)
{
	// End:0x64
	if(Trackers[X].Pickups.Length > 0)
	{
		Trackers[X].Pickups[0].Destroy();
	}
	//return;	
}

function DestroyLeastDesirablePickup()
{
	local int I, indexToDestroyFrom;

	indexToDestroyFrom = 0;
	I = 1;
	J0x16:

	// End:0x6E [Loop If]
	if(I < Trackers.Length)
	{
		// End:0x60
		if(TrackerLessThan(I, indexToDestroyFrom))
		{
			indexToDestroyFrom = I;
		}
		++I;
		// [Loop Continue]
		goto J0x16;
	}
	DestroyOldestPickupByTrackerIndex(indexToDestroyFrom);
	//return;	
}

function bool TrackerLessThan(int A, int B)
{
	// End:0x55
	if(Trackers[A].Pickups.Length > Trackers[B].Pickups.Length)
	{
		return true;
	}
	// End:0xAA
	if(Trackers[A].Pickups.Length < Trackers[B].Pickups.Length)
	{
		return false;
	}
	// End:0xFD
	if(Trackers[A].Rank > Trackers[B].Rank)
	{
		return true;
	}
	// End:0x150
	if(Trackers[A].Rank < Trackers[B].Rank)
	{
		return false;
	}
	// End:0x1FA
	if(Trackers[A].Pickups.Length > 0)
	{
		return Trackers[A].Pickups[0].SpawnTime < Trackers[B].Pickups[0].SpawnTime;
	}
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	Trackers[0]=(InvClass=Class'MegaHaloGame.HaloWeapon_AssaultRifle',Rank=5,MaxCount=3,Pickups=none)
	Trackers[1]=(InvClass=Class'MegaHaloGame.HaloWeapon_BattleRifle',Rank=8,MaxCount=3,Pickups=none)
	Trackers[2]=(InvClass=Class'MegaHaloGame.HaloWeapon_Carbine',Rank=10,MaxCount=3,Pickups=none)
	Trackers[3]=(InvClass=Class'MegaHaloGame.HaloWeapon_EnergySword_Content',Rank=10,MaxCount=3,Pickups=none)
	Trackers[4]=(InvClass=Class'MegaHaloGame.HaloWeapon_FuelRodCannon',Rank=10,MaxCount=3,Pickups=none)
	Trackers[5]=(InvClass=Class'MegaHaloGame.HaloWeapon_Needler',Rank=5,MaxCount=3,Pickups=none)
	Trackers[6]=(InvClass=Class'MegaHaloGame.HaloWeapon_Pistol',Rank=1,MaxCount=3,Pickups=none)
	Trackers[7]=(InvClass=Class'MegaHaloGame.HaloWeapon_Shotgun',Rank=8,MaxCount=3,Pickups=none)
	Trackers[8]=(InvClass=Class'MegaHaloGame.HaloWeapon_StormRifle',Rank=5,MaxCount=3,Pickups=none)
	Trackers[9]=(InvClass=Class'MegaHaloGame.HaloWeapon_UnscPistol',Rank=1,MaxCount=3,Pickups=none)
	Trackers[10]=(InvClass=Class'MegaHaloGame.HaloWeapon_UnscRocketLauncher_Content',Rank=10,MaxCount=3,Pickups=none)
	MaxPickupCount=10
	CollisionType=COLLIDE_CustomDefault
}