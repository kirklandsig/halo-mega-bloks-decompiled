class HaloPlayerInventoryManager extends UTInventoryManager
	implements(HaloSaveInterface);

var int DroppableWeaponCountMax;
var byte FragGrenadeCount;
var byte PlasmaGrenadeCount;
var int FragGrenadeCountMax;
var int PlasmaGrenadeCountMax;
var bool bDropGrenadesOnDeath;

replication
{
	// Pos:0x000
	if(bNetDirty)
		FragGrenadeCount, PlasmaGrenadeCount;
}

function int GetWeaponCountForGroup(int GroupID)
{
	local Inventory Item;
	local UTWeapon Weap;
	local int weapCount;

	Item = InventoryChain;
	J0x13:

	// End:0xB3 [Loop If]
	if(Item != none)
	{
		Weap = UTWeapon(Item);
		// End:0x88
		if((Weap != none) && int(Weap.InventoryGroup) == GroupID)
		{
			weapCount++;
		}
		Item = Item.Inventory;
		// [Loop Continue]
		goto J0x13;
	}
	return weapCount;
	//return ReturnValue;	
}

function bool IsDroppableWeapon(Inventory Item)
{
	local UTWeapon Weap;

	Weap = UTWeapon(Item);
	// End:0x52
	if(Weap != none)
	{
		return int(Weap.InventoryGroup) == int(1);
	}
	return false;
	//return ReturnValue;	
}

function int GetDroppableWeaponCount()
{
	return GetWeaponCountForGroup(1);
	//return ReturnValue;	
}

simulated function GetDroppableWeaponList(out array<UTWeapon> weapList, bool bNoEmpty)
{
	GetWeaponList(weapList, true, 1, bNoEmpty);
	//return;	
}

function AddDroppedPickup(HaloDroppedPickup Pickup)
{
	local HaloWeapon pickupWeapon;

	// End:0x22
	if((Pickup == none) || Instigator == none)
	{
		return;
	}
	// End:0x62
	if((Weapon(Pickup.Inventory) != none) && PendingWeapon != none)
	{
		return;
	}
	// End:0xDF
	if(IsDroppableWeapon(Pickup.Inventory))
	{
		// End:0xDF
		if((GetDroppableWeaponCount()) >= DroppableWeaponCountMax)
		{
			// End:0xDD
			if(IsDroppableWeapon(Instigator.Weapon))
			{
				DropCurrentWeapon();				
			}
			else
			{
				return;
			}
		}
	}
	pickupWeapon = HaloWeapon(Pickup.Inventory);
	Pickup.GiveTo(HaloPawn(Instigator));
	// End:0x208
	if(pickupWeapon != none)
	{
		pickupWeapon.SetSwitch('Local_Player', 'Yes');
		pickupWeapon.SetSwitch('Weapon_Type', pickupWeapon.akWeaponType);
		pickupWeapon.PlayAkEvent(AkEvent'Weapons.Play_Weapon_Pickup');
		QuickWeaponSwap(pickupWeapon);
	}
	//return;	
}

reliable client simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
	local HaloWeapon hw;
	local bool HadWeapon;

	HadWeapon = (Instigator != none) && Instigator.Weapon != none;
	super.SetCurrentWeapon(DesiredWeapon);
	hw = HaloWeapon(DesiredWeapon);
	// End:0x133
	if(hw != none)
	{
		Instigator.SetSwitch('Weapon_Type', hw.akWeaponType);
		hw.SetSwitch('Weapon_Type', hw.akWeaponType);
		// End:0x133
		if(HadWeapon)
		{
			hw.PlaySwitchToSound();
		}
	}
	//return;	
}

function CancelWeaponSwap()
{
	// End:0xF0
	if(PendingWeapon != none)
	{
		PendingWeapon.bWeaponPutDown = false;
		PendingWeapon.GotoState('Inactive');
		PendingWeapon = none;
		// End:0xF0
		if(Instigator.Weapon != none)
		{
			Instigator.Weapon.bWeaponPutDown = false;
			Instigator.Weapon.GotoState('Active');
		}
	}
	//return;	
}

simulated function bool RefillWeapon(Class<HaloWeapon> WeaponType)
{
	local HaloWeapon HWeapon;

	HWeapon = HaloWeapon(HasInventoryOfClass(WeaponType));
	// End:0x154
	if(HWeapon != none)
	{
		// End:0x152
		if((HWeapon.AmmoCount < HWeapon.MaxAmmoCount) || HWeapon.ExtraAmmoCount < HWeapon.MaxExtraAmmoCount)
		{
			HWeapon.AmmoCount = HWeapon.MaxAmmoCount;
			HWeapon.ExtraAmmoCount = HWeapon.MaxExtraAmmoCount;
			HWeapon.PlayReloadSound();
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function HaloWeapon PickUpWeaponByClass(Class<HaloWeapon> WeaponType, bool bAllowWeaponDrop)
{
	local HaloWeapon HWeapon, WeaponToRemove;

	// End:0x146
	if((HasInventoryOfClass(WeaponType)) == none)
	{
		// End:0xB7
		if((GetDroppableWeaponCount()) >= DroppableWeaponCountMax)
		{
			// End:0x90
			if(IsDroppableWeapon(Instigator.Weapon))
			{
				WeaponToRemove = HaloWeapon(Instigator.Weapon);				
			}
			else
			{
				WeaponToRemove = HaloWeapon(FindInventoryType(Class'MegaHaloGame.HaloWeapon', true));
			}
		}
		HWeapon = HaloWeapon(CreateInventory(WeaponType));
		// End:0x146
		if(HWeapon != none)
		{
			// End:0x129
			if(WeaponToRemove != none)
			{
				// End:0x116
				if(bAllowWeaponDrop)
				{
					DropCurrentWeapon();					
				}
				else
				{
					RemoveFromInventory(WeaponToRemove);
				}
			}
			QuickWeaponSwap(HWeapon);
			return HWeapon;
		}
	}
	return none;
	//return ReturnValue;	
}

function QuickWeaponSwap(Weapon W)
{
	// End:0x90
	if(Instigator.Weapon != none)
	{
		Instigator.Weapon.DetachWeapon();
		Instigator.Weapon.GotoState('Inactive');
	}
	PendingWeapon = W;
	ChangedWeapon();
	//return;	
}

function DropCurrentWeapon()
{
	// End:0x83
	if(Instigator.Weapon != none)
	{
		Instigator.Weapon.DropFrom(Instigator.Location, vect(0.0000000, 0.0000000, 1.0000000));
	}
	//return;	
}

simulated function DiscardInventory()
{
	local int I;

	super.DiscardInventory();
	// End:0xAC
	if(bDropGrenadesOnDeath)
	{
		I = 0;
		J0x22:

		// End:0x54 [Loop If]
		if(I < int(PlasmaGrenadeCount))
		{
			DropGrenade(true);
			I++;
			// [Loop Continue]
			goto J0x22;
		}
		PlasmaGrenadeCount = 0;
		I = 0;
		J0x6B:

		// End:0x9D [Loop If]
		if(I < int(FragGrenadeCount))
		{
			DropGrenade(false);
			I++;
			// [Loop Continue]
			goto J0x6B;
		}
		FragGrenadeCount = 0;		
	}
	else
	{
		PlasmaGrenadeCount = 0;
		FragGrenadeCount = 0;
	}
	//return;	
}

simulated function ClearInventory()
{
	super.ClearInventory();
	PlasmaGrenadeCount = 0;
	FragGrenadeCount = 0;
	//return;	
}

function DropGrenade(bool isPlasma)
{
	local HaloDroppedGrenade P;
	local Vector DropLoc, DropVec;

	// End:0xD0
	if(Instigator != none)
	{
		DropLoc = Instigator.Location + vect(0.0000000, 0.0000000, 50.0000000);
		DropVec = Vector(Instigator.GetViewRotation());
		DropVec = ((DropVec * ((Instigator.Velocity Dot DropVec) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
	}
	P = Spawn(Class'MegaHaloGame.HaloDroppedGrenade', self,, DropLoc);
	// End:0x10D
	if(P == none)
	{
		return;
	}
	P.Velocity = DropVec;
	P.Instigator = Instigator;
	P.Init(isPlasma);
	//return;	
}

function JsonObject Serialize()
{
	local JsonObject Data;
	local array<UTWeapon> WeaponList;
	local int I;

	Data = new Class'Engine.JsonObject';
	// End:0x2FA
	if(Data != none)
	{
		GetWeaponList(WeaponList);
		I = 0;
		J0x48:

		// End:0x24A [Loop If]
		if(I < WeaponList.Length)
		{
			Data.SetStringValue("WeaponArchetype_" $ string(I), PathName(WeaponList[I].ObjectArchetype));
			Data.SetIntValue("WeaponAmmo_" $ string(I), WeaponList[I].AmmoCount);
			// End:0x1C2
			if(HaloWeapon(WeaponList[I]) != none)
			{
				Data.SetIntValue("WeaponExtraAmmo_" $ string(I), HaloWeapon(WeaponList[I]).ExtraAmmoCount);
			}
			Data.SetBoolValue("WeaponIsCurrent_" $ string(I), WeaponList[I] == Pawn(Owner).Weapon);
			I++;
			// [Loop Continue]
			goto J0x48;
		}
		Data.SetIntValue("WeaponCount", WeaponList.Length);
		Data.SetIntValue("FragGrenadeCount", int(FragGrenadeCount));
		Data.SetIntValue("PlasmaGrenadeCount", int(PlasmaGrenadeCount));
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	local Inventory Inv;
	local int I, weaponLength;
	local Object Archetype;

	ClearInventory();
	weaponLength = Data.GetIntValue("WeaponCount");
	I = 0;
	J0x4B:

	// End:0x276 [Loop If]
	if(I < weaponLength)
	{
		Archetype = Class'MegaHaloGame.HaloSaveGame'.static.GetArchetypeFromName(Data.GetStringValue("WeaponArchetype_" $ string(I)));
		// End:0x268
		if(Archetype != none)
		{
			Inv = CreateInventory(Inventory(Archetype).Class, false);
			// End:0x1EA
			if(UDKWeapon(Inv) != none)
			{
				UDKWeapon(Inv).AmmoCount = Data.GetIntValue("WeaponAmmo_" $ string(I));
				// End:0x1EA
				if(Data.GetBoolValue("WeaponIsCurrent_" $ string(I)))
				{
					SetCurrentWeapon(UDKWeapon(Inv));
				}
			}
			// End:0x268
			if(HaloWeapon(Inv) != none)
			{
				HaloWeapon(Inv).ExtraAmmoCount = Data.GetIntValue("WeaponExtraAmmo_" $ string(I));
			}
		}
		I++;
		// [Loop Continue]
		goto J0x4B;
	}
	FragGrenadeCount = byte(Data.GetIntValue("FragGrenadeCount"));
	PlasmaGrenadeCount = byte(Data.GetIntValue("PlasmaGrenadeCount"));
	//return;	
}

defaultproperties
{
	DroppableWeaponCountMax=2
	FragGrenadeCountMax=2
	PlasmaGrenadeCountMax=2
	bMustHoldWeapon=false
}