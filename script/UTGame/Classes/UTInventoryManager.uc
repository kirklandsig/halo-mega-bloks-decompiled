class UTInventoryManager extends InventoryManager;

struct native AmmoStore
{
	var int Amount;
	var Class<UTWeapon> WeaponClass;

	structdefaultproperties
	{
		Amount=0
		WeaponClass=none
	}
};

var bool bInfiniteAmmo;
var array<AmmoStore> AmmoStorage;
var Weapon PreviousWeapon;
var UTWeapon PendingSwitchWeapon;
var float LastAdjustWeaponTime;

replication
{
	// Pos:0x000
	if(bNetDirty)
		bInfiniteAmmo;
}

reliable client simulated function ClientSyncWeapon(Weapon NewWeapon)
{
	local Weapon OldWeapon;

	// End:0x98
	if(NewWeapon == Instigator.Weapon)
	{
		LogInternal(((((string(self) @ "(Owned by") @ string(Owner)) @ ") is trying to Sync to the currently active weapon (") $ string(NewWeapon)) $ ")");
		return;
	}
	LogInternal(((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Forcing weapon:") @ string(NewWeapon)) @ "from:") @ string(Instigator.Weapon), 'Inventory');
	OldWeapon = Instigator.Weapon;
	Instigator.Weapon = NewWeapon;
	Instigator.PlayWeaponSwitch(OldWeapon, NewWeapon);
	// End:0x254
	if(NewWeapon != none)
	{
		Instigator.Weapon.Instigator = Instigator;
		Instigator.Weapon.Activate();
	}
	// End:0x2D3
	if(Instigator.Controller != none)
	{
		Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
	}
	//return;	
}

simulated function OwnerEvent(name EventName)
{
	local UTInventory Inv;

	// End:0x6A
	foreach InventoryActors(Class'UTGame.UTInventory', Inv)
	{
		// End:0x69
		if(Inv.bReceiveOwnerEvents)
		{
			Inv.OwnerEvent(EventName);
		}		
	}	
	//return;	
}

simulated function GetWeaponList(out array<UTWeapon> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
	local UTWeapon Weap;
	local int I;

	// End:0x1C9
	foreach InventoryActors(Class'UTGame.UTWeapon', Weap)
	{
		// End:0x1C8
		if((!bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo())
		{
			// End:0x1A7
			if(WeaponList.Length > 0)
			{
				I = 0;
				J0xB1:

				// End:0x157 [Loop If]
				if(I < WeaponList.Length)
				{
					// End:0x149
					if(WeaponList[I].InventoryWeight > Weap.InventoryWeight)
					{
						WeaponList.Insert(I, 1);
						WeaponList[I] = Weap;
						// [Explicit Break]
						goto J0x157;
					}
					I++;
					// [Loop Continue]
					goto J0xB1;
				}
				J0x157:

				// End:0x1A4
				if(I == WeaponList.Length)
				{
					WeaponList.Length = WeaponList.Length + 1;
					WeaponList[I] = Weap;
				}
				// End:0x1C8
				continue;
			}
			WeaponList.Length = 1;
			WeaponList[0] = Weap;
		}		
	}	
	//return;	
}

simulated function SwitchWeapon(byte NewGroup)
{
	local UTWeapon CurrentWeapon;
	local array<UTWeapon> WeaponList;
	local int NewIndex;

	GetWeaponList(WeaponList, true, int(NewGroup));
	// End:0x32
	if(WeaponList.Length <= 0)
	{
		return;
	}
	CurrentWeapon = UTWeapon(PendingWeapon);
	// End:0x8E
	if(CurrentWeapon == none)
	{
		CurrentWeapon = UTWeapon(Instigator.Weapon);
	}
	// End:0xDD
	if((CurrentWeapon == none) || int(CurrentWeapon.InventoryGroup) != int(NewGroup))
	{
		NewIndex = 0;		
	}
	else
	{
		NewIndex = 0;
		J0xE8:

		// End:0x132 [Loop If]
		if(NewIndex < WeaponList.Length)
		{
			// End:0x124
			if(WeaponList[NewIndex] == CurrentWeapon)
			{
				// [Explicit Break]
				goto J0x132;
			}
			NewIndex++;
			// [Loop Continue]
			goto J0xE8;
		}
		J0x132:

		NewIndex++;
		// End:0x160
		if(NewIndex >= WeaponList.Length)
		{
			NewIndex = 0;
		}
	}
	// End:0x1A9
	if(WeaponList[NewIndex].HasAnyAmmo())
	{
		SetCurrentWeapon(WeaponList[NewIndex]);
	}
	//return;	
}

simulated function AdjustWeapon(int NewOffset)
{
	local Weapon CurrentWeapon;
	local array<UTWeapon> WeaponList;
	local int I, Index;

	// End:0x35
	if((WorldInfo.TimeSeconds - LastAdjustWeaponTime) < 0.0500000)
	{
		return;
	}
	LastAdjustWeaponTime = WorldInfo.TimeSeconds;
	CurrentWeapon = UTWeapon(PendingWeapon);
	// End:0xB9
	if(CurrentWeapon == none)
	{
		CurrentWeapon = UTWeapon(Instigator.Weapon);
	}
	GetWeaponList(WeaponList,,, true);
	// End:0xE1
	if(WeaponList.Length == 0)
	{
		return;
	}
	I = 0;
	J0xEC:

	// End:0x149 [Loop If]
	if(I < WeaponList.Length)
	{
		// End:0x13B
		if(WeaponList[I] == CurrentWeapon)
		{
			Index = I;
			// [Explicit Break]
			goto J0x149;
		}
		I++;
		// [Loop Continue]
		goto J0xEC;
	}
	J0x149:

	Index += NewOffset;
	// End:0x186
	if(Index < 0)
	{
		Index = WeaponList.Length - 1;		
	}
	else
	{
		// End:0x1A9
		if(Index >= WeaponList.Length)
		{
			Index = 0;
		}
	}
	// End:0x1D5
	if(Index >= 0)
	{
		SetCurrentWeapon(WeaponList[Index]);
	}
	//return;	
}

simulated function PrevWeapon()
{
	// End:0x83
	if((UTWeapon(Pawn(Owner).Weapon) != none) && UTWeapon(Pawn(Owner).Weapon).DoOverridePrevWeapon())
	{
		return;
	}
	AdjustWeapon(-1);
	//return;	
}

simulated function NextWeapon()
{
	// End:0x83
	if((UTWeapon(Pawn(Owner).Weapon) != none) && UTWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon())
	{
		return;
	}
	AdjustWeapon(1);
	//return;	
}

function AllAmmo(optional bool bAmmoForSuperWeapons)
{
	local Inventory Inv;

	Inv = InventoryChain;
	J0x14:

	// End:0xCD [Loop If]
	if(Inv != none)
	{
		// End:0xA2
		if((UTWeapon(Inv) != none) && bAmmoForSuperWeapons || !UTWeapon(Inv).bSuperWeapon)
		{
			UTWeapon(Inv).Loaded(true);
		}
		Inv = Inv.Inventory;
		// [Loop Continue]
		goto J0x14;
	}
	//return;	
}

reliable client simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
	SetPendingWeapon(DesiredWeapon);
	// End:0x3A
	if(int(Role) < int(ROLE_Authority))
	{
		ServerSetCurrentWeapon(DesiredWeapon);
	}
	//return;	
}

reliable client simulated function ClientSetCurrentWeapon(Weapon DesiredWeapon)
{
	SetPendingWeapon(DesiredWeapon);
	//return;	
}

reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
	SetPendingWeapon(DesiredWeapon);
	//return;	
}

simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
	local UTWeapon PrevWeapon, CurrentPending;
	local UTPawn UTP;

	// End:0x11
	if(Instigator == none)
	{
		return;
	}
	PrevWeapon = UTWeapon(Instigator.Weapon);
	CurrentPending = UTWeapon(PendingWeapon);
	// End:0x36B
	if(((PrevWeapon == none) || PrevWeapon.AllowSwitchTo(DesiredWeapon)) && (CurrentPending == none) || CurrentPending.AllowSwitchTo(DesiredWeapon))
	{
		// End:0x1BB
		if((DesiredWeapon != none) && DesiredWeapon == Instigator.Weapon)
		{
			// End:0x132
			if(PendingWeapon != none)
			{
				PendingWeapon = none;				
			}
			else
			{
				PrevWeapon.ServerReselectWeapon();
			}
			// End:0x197
			if(!PrevWeapon.bReadyToFire())
			{
				PrevWeapon.Activate();				
			}
			else
			{
				PrevWeapon.bWeaponPutDown = false;
			}			
		}
		else
		{
			// End:0x2CE
			if(Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
			{
				// End:0x26D
				if(UTWeapon(Instigator.Weapon) != none)
				{
					UTWeapon(Instigator.Weapon).PreloadTextures(false);
				}
				// End:0x2A5
				if(PendingWeapon != none)
				{
					UTWeapon(PendingWeapon).PreloadTextures(false);
				}
				UTWeapon(DesiredWeapon).PreloadTextures(true);
			}
			PendingWeapon = DesiredWeapon;
			// End:0x361
			if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive'))
			{
				PrevWeapon.TryPutDown();				
			}
			else
			{
				ChangedWeapon();
			}
		}
	}
	UTP = UTPawn(Instigator);
	// End:0x3C1
	if(UTP != none)
	{
		UTP.SetPuttingDownWeapon(PendingWeapon != none);
	}
	//return;	
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
	local Weapon OldWeapon;

	OldWeapon = Instigator.Weapon;
	// End:0x98
	if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
	{
		SetCurrentWeapon(NewWeapon);
		return;
	}
	// End:0xB1
	if(OldWeapon == NewWeapon)
	{
		return;
	}
	// End:0xD5
	if(!bOptionalSet)
	{
		SetCurrentWeapon(NewWeapon);
		return;
	}
	// End:0x15F
	if(Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
	{
		NewWeapon.GotoState('Inactive');
		return;
	}
	// End:0x200
	if(OldWeapon.IsFiring() || OldWeapon.DenyClientWeaponSet() && UTWeapon(NewWeapon) != none)
	{
		NewWeapon.GotoState('Inactive');
		RetrySwitchTo(UTWeapon(NewWeapon));
		return;
	}
	// End:0x324
	if((((PendingWeapon == none) || !PendingWeapon.HasAnyAmmo()) || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating()) && !Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
	{
		SetCurrentWeapon(NewWeapon);
		return;
	}
	NewWeapon.GotoState('Inactive');
	//return;	
}

simulated function Inventory CreateInventory(Class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	// End:0x33
	if(int(Role) == int(ROLE_Authority))
	{
		return super.CreateInventory(NewInventoryItemClass, bDoNotActivate);
	}
	return none;
	//return ReturnValue;	
}

simulated function ProcessRetrySwitch()
{
	local UTWeapon NewWeapon;

	NewWeapon = PendingSwitchWeapon;
	PendingSwitchWeapon = none;
	// End:0x40
	if(NewWeapon != none)
	{
		CheckSwitchTo(NewWeapon);
	}
	//return;	
}

simulated function RetrySwitchTo(UTWeapon NewWeapon)
{
	PendingSwitchWeapon = NewWeapon;
	SetTimer(0.1000000, false, 'ProcessRetrySwitch');
	//return;	
}

simulated function CheckSwitchTo(UTWeapon NewWeapon)
{
	// End:0xD9
	if((UTWeapon(Instigator.Weapon) == none) || ((Instigator != none) && PlayerController(Instigator.Controller) != none) && UTWeapon(Instigator.Weapon).ShouldSwitchTo(NewWeapon))
	{
		NewWeapon.ClientWeaponSet(true);
	}
	//return;	
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
	local bool bResult;
	local int I;

	// End:0x16F
	if(int(Role) == int(ROLE_Authority))
	{
		bResult = super.AddInventory(NewItem, bDoNotActivate);
		// End:0x16F
		if(bResult && UTWeapon(NewItem) != none)
		{
			I = 0;
			J0x6F:

			// End:0x144 [Loop If]
			if(I < AmmoStorage.Length)
			{
				// End:0x136
				if(AmmoStorage[I].WeaponClass == NewItem.Class)
				{
					UTWeapon(NewItem).AddAmmo(AmmoStorage[I].Amount);
					AmmoStorage.Remove(I, 1);
					// [Explicit Break]
					goto J0x144;
				}
				I++;
				// [Loop Continue]
				goto J0x6F;
			}
			J0x144:

			// End:0x16F
			if(!bDoNotActivate)
			{
				CheckSwitchTo(UTWeapon(NewItem));
			}
		}
	}
	return bResult;
	//return ReturnValue;	
}

simulated function DiscardInventory()
{
	local Vehicle V;

	// End:0xF3
	if(int(Role) == int(ROLE_Authority))
	{
		super.DiscardInventory();
		V = Vehicle(Owner);
		// End:0xF3
		if(((V != none) && V.Driver != none) && V.Driver.InvManager != none)
		{
			V.Driver.InvManager.DiscardInventory();
		}
	}
	//return;	
}

simulated event ClearInventory()
{
	local Vehicle V;

	// End:0xF3
	if(int(Role) == int(ROLE_Authority))
	{
		super.ClearInventory();
		V = Vehicle(Owner);
		// End:0xF3
		if(((V != none) && V.Driver != none) && V.Driver.InvManager != none)
		{
			V.Driver.InvManager.ClearInventory();
		}
	}
	//return;	
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
	// End:0x5D
	if(int(Role) == int(ROLE_Authority))
	{
		super.RemoveFromInventory(ItemToRemove);
		// End:0x5D
		if(PendingSwitchWeapon == ItemToRemove)
		{
			PendingSwitchWeapon = none;
			ClearTimer('ProcessRetrySwitch');
		}
	}
	//return;	
}

function bool NeedsAmmo(Class<UTWeapon> TestWeapon)
{
	local array<UTWeapon> WeaponList;
	local int I;

	GetWeaponList(WeaponList);
	I = 0;
	J0x21:

	// End:0xDA [Loop If]
	if(I < WeaponList.Length)
	{
		// End:0xCC
		if(ClassIsChildOf(WeaponList[I].Class, TestWeapon))
		{
			// End:0xCA
			if(WeaponList[I].AmmoCount < WeaponList[I].MaxAmmoCount)
			{
				return true;				
			}
			else
			{
				return false;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x21;
	}
	I = 0;
	J0xE5:

	// End:0x192 [Loop If]
	if(I < AmmoStorage.Length)
	{
		// End:0x184
		if(ClassIsChildOf(WeaponList[I].Class, TestWeapon))
		{
			// End:0x182
			if(AmmoStorage[I].Amount < TestWeapon.default.MaxAmmoCount)
			{
				return true;				
			}
			else
			{
				return false;
			}
		}
		I++;
		// [Loop Continue]
		goto J0xE5;
	}
	return true;
	//return ReturnValue;	
}

function AddAmmoToWeapon(int AmountToAdd, Class<UTWeapon> WeaponClassToAddTo)
{
	local array<UTWeapon> WeaponList;
	local int I;

	GetWeaponList(WeaponList);
	I = 0;
	J0x21:

	// End:0xB2 [Loop If]
	if(I < WeaponList.Length)
	{
		// End:0xA4
		if(ClassIsChildOf(WeaponList[I].Class, WeaponClassToAddTo))
		{
			WeaponList[I].AddAmmo(AmountToAdd);
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x21;
	}
	I = 0;
	J0xBD:

	// End:0x14A [Loop If]
	if(I < AmmoStorage.Length)
	{
		// End:0x13C
		if(AmmoStorage[I].WeaponClass == WeaponClassToAddTo)
		{
			AmmoStorage[I].Amount += AmountToAdd;
			return;
		}
		I++;
		// [Loop Continue]
		goto J0xBD;
	}
	I = AmmoStorage.Length;
	AmmoStorage.Length = AmmoStorage.Length + 1;
	AmmoStorage[I].Amount = AmountToAdd;
	AmmoStorage[I].WeaponClass = WeaponClassToAddTo;
	//return;	
}

function Inventory HasInventoryOfClass(Class<Inventory> InvClass)
{
	local Inventory Inv;

	Inv = InventoryChain;
	J0x13:

	// End:0x83 [Loop If]
	if(Inv != none)
	{
		// End:0x58
		if(Inv.Class == InvClass)
		{
			return Inv;
		}
		Inv = Inv.Inventory;
		// [Loop Continue]
		goto J0x13;
	}
	return none;
	//return ReturnValue;	
}

simulated function ChangedWeapon()
{
	local UTWeapon Wep;
	local UTPawn UTP;

	PreviousWeapon = Instigator.Weapon;
	super.ChangedWeapon();
	Wep = UTWeapon(Instigator.Weapon);
	// End:0xA9
	if((Wep != none) && Wep.bNeverForwardPendingFire)
	{
		ClearAllPendingFire(Wep);
	}
	UTP = UTPawn(Instigator);
	// End:0xFF
	if(UTP != none)
	{
		UTP.SetPuttingDownWeapon(PendingWeapon != none);
	}
	//return;	
}

simulated function SwitchToPreviousWeapon()
{
	// End:0x67
	if((PreviousWeapon != none) && PreviousWeapon != Pawn(Owner).Weapon)
	{
		PreviousWeapon.ClientWeaponSet(false);
	}
	//return;	
}

simulated function DrawHUD(HUD H)
{
	// End:0x73
	if(UTWeapon(Instigator.Weapon) != none)
	{
		UTWeapon(Instigator.Weapon).ActiveRenderOverlays(H);
	}
	//return;	
}

simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
	local Weapon BestWeapon;

	// End:0x14A
	if(Instigator.IsLocallyControlled())
	{
		// End:0x128
		if((bForceADifferentWeapon || PendingWeapon == none) || AIController(Instigator.Controller) != none)
		{
			BestWeapon = GetBestWeapon(bForceADifferentWeapon);
			// End:0x128
			if(BestWeapon == Instigator.Weapon)
			{
				BestWeapon = none;
				PendingWeapon = none;
				// End:0x128
				if(Instigator.Weapon != none)
				{
					Instigator.Weapon.Activate();
				}
			}
		}
		// End:0x14A
		if(BestWeapon != none)
		{
			SetCurrentWeapon(BestWeapon);
		}
	}
	//return;	
}

defaultproperties
{
	bMustHoldWeapon=true
	PendingFire[0]=0
	PendingFire[1]=0
}