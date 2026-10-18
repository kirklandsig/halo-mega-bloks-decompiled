class InventoryManager extends Actor
	native
	notplaceable;

var Inventory InventoryChain;
var Weapon PendingWeapon;
var Weapon LastAttemptedSwitchToWeapon;
var bool bMustHoldWeapon;
var private array<int> PendingFire;

replication
{
	// Pos:0x000
	if((((bSkipActorPropertyReplication! || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty) && bNetOwner)
		InventoryChain;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	Instigator = Pawn(Owner);
	//return;	
}

simulated function int GetPendingFireLength(Weapon InWeapon)
{
	return PendingFire.Length;
	//return ReturnValue;	
}

simulated function SetPendingFire(Weapon InWeapon, int InFiringMode)
{
	// End:0x2D
	if(InFiringMode < PendingFire.Length)
	{
		PendingFire[InFiringMode] = 1;
	}
	//return;	
}

simulated function ClearPendingFire(Weapon InWeapon, int InFiringMode)
{
	// End:0x2D
	if(InFiringMode < PendingFire.Length)
	{
		PendingFire[InFiringMode] = 0;
	}
	//return;	
}

final simulated function bool IsPendingFire(Weapon InWeapon, int InFiringMode)
{
	return bool(PendingFire[InFiringMode]);
	//return ReturnValue;	
}

simulated function ClearAllPendingFire(Weapon InWeapon)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x46 [Loop If]
	if(I < PendingFire.Length)
	{
		PendingFire[I] = 0;
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

// Export UInventoryManager::execInventoryActors(FFrame&, void* const)
native final iterator function InventoryActors(Class<Inventory> BaseClass, out Inventory Inv);

function SetupFor(Pawn P)
{
	Instigator = P;
	SetOwner(P);
	//return;	
}

event Destroyed()
{
	DiscardInventory();
	//return;	
}

function bool HandlePickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
	local Inventory Inv;

	// End:0x11
	if(InventoryChain == none)
	{
		return true;
	}
	// End:0x68
	foreach InventoryActors(Class'Engine.Inventory', Inv)
	{
		// End:0x67
		if(Inv.DenyPickupQuery(ItemClass, Pickup))
		{			
			return false;
		}		
	}	
	return true;
	//return ReturnValue;	
}

simulated event Inventory FindInventoryType(Class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
	local Inventory Inv;

	// End:0x67
	foreach InventoryActors(DesiredClass, Inv)
	{
		// End:0x66
		if(bAllowSubclass || Inv.Class == DesiredClass)
		{			
			return Inv;
		}		
	}	
	return none;
	//return ReturnValue;	
}

simulated function Inventory CreateInventory(Class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	local Inventory Inv;

	// End:0x139
	if(NewInventoryItemClass != none)
	{
		Inv = Spawn(NewInventoryItemClass, Owner);
		// End:0xEC
		if(Inv != none)
		{
			// End:0xE9
			if(AddInventory(Inv, bDoNotActivate)!)
			{
				WarnInternal("InventoryManager::CreateInventory - Couldn't Add newly created inventory" @ string(Inv));
				Inv.Destroy();
				Inv = none;
			}			
		}
		else
		{
			WarnInternal("InventoryManager::CreateInventory - Couldn't spawn inventory" @ string(NewInventoryItemClass));
		}
	}
	return Inv;
	//return ReturnValue;	
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
	local Inventory Item, LastItem;

	// End:0x275
	if((NewItem != none) && NewItem.bDeleteMe!)
	{
		// End:0x5B
		if(InventoryChain == none)
		{
			InventoryChain = NewItem;			
		}
		else
		{
			Item = InventoryChain;
			J0x6E:

			// End:0xD4 [Loop If]
			if(Item != none)
			{
				// End:0x96
				if(Item == NewItem)
				{
					return false;
				}
				LastItem = Item;
				Item = Item.Inventory;
				// [Loop Continue]
				goto J0x6E;
			}
			LastItem.Inventory = NewItem;
		}
		LogInternal(((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "adding") @ string(NewItem)) @ "bDoNotActivate:") @ string(bDoNotActivate), 'Inventory');
		NewItem.SetOwner(Instigator);
		NewItem.Instigator = Instigator;
		NewItem.InvManager = self;
		NewItem.GivenTo(Instigator, bDoNotActivate);
		Instigator.TriggerEventClass(Class'Engine.SeqEvent_GetInventory', NewItem);
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
	local Inventory Item;
	local bool bFound;

	// End:0x4A0
	if(ItemToRemove != none)
	{
		// End:0x5D
		if(InventoryChain == ItemToRemove)
		{
			bFound = true;
			InventoryChain = ItemToRemove.Inventory;			
		}
		else
		{
			Item = InventoryChain;
			J0x70:

			// End:0x122 [Loop If]
			if(Item != none)
			{
				// End:0xF7
				if(Item.Inventory == ItemToRemove)
				{
					bFound = true;
					Item.Inventory = ItemToRemove.Inventory;
					// [Explicit Break]
					goto J0x122;
				}
				Item = Item.Inventory;
				// [Loop Continue]
				goto J0x70;
			}
		}
		J0x122:

		// End:0x20F
		if(bFound)
		{
			LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "removed") @ string(ItemToRemove), 'Inventory');
			ItemToRemove.ItemRemovedFromInvManager();
			ItemToRemove.SetOwner(none);
			ItemToRemove.Inventory = none;
		}
		// End:0x25B
		if(ItemToRemove == Instigator.Weapon)
		{
			Instigator.Weapon = none;
		}
		// End:0x4A0
		if((Instigator.Health > 0) && Instigator.Weapon == none)
		{
			// End:0x38F
			if((PendingWeapon != none) && PendingWeapon != ItemToRemove)
			{
				LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Removed current weapon while changing weapons, call ChangedWeapon", 'Inventory');
				ChangedWeapon();				
			}
			else
			{
				// End:0x4A0
				if(Instigator.Controller != none)
				{
					LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Calling ClientSwitchToBestWeapon to make sure a weapon is brought up", 'Inventory');
					Instigator.Controller.ClientSwitchToBestWeapon(true);
				}
			}
		}
	}
	//return;	
}

simulated event DiscardInventory()
{
	local Inventory Inv;
	local Vector TossVelocity;
	local bool bBelowKillZ;

	LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
	bBelowKillZ = (Instigator == none) || Instigator.Location.Z < WorldInfo.KillZ;
	// End:0x21F
	foreach InventoryActors(Class'Engine.Inventory', Inv)
	{
		// End:0x206
		if(Inv.bDropOnDeath && bBelowKillZ!)
		{
			TossVelocity = Vector(Instigator.GetViewRotation());
			TossVelocity = ((TossVelocity * ((Instigator.Velocity Dot TossVelocity) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
			Inv.DropFrom(Instigator.Location, TossVelocity);
			// End:0x21E
			continue;
		}
		Inv.Destroy();		
	}	
	Instigator.Weapon = none;
	PendingWeapon = none;
	//return;	
}

simulated event ClearInventory()
{
	local Inventory Inv;

	// End:0x38
	foreach InventoryActors(Class'Engine.Inventory', Inv)
	{
		Inv.Destroy();		
	}	
	Instigator.Weapon = none;
	PendingWeapon = none;
	//return;	
}

function OwnerDied()
{
	Destroy();
	// End:0x47
	if(Instigator.InvManager == self)
	{
		Instigator.InvManager = none;
	}
	//return;	
}

simulated function DrawHUD(HUD H)
{
	//return;	
}

simulated function float GetWeaponRatingFor(Weapon W)
{
	local float Rating;

	// End:0x2A
	if(W.HasAnyAmmo()!)
	{
		return -1.0000000;
	}
	// End:0x118
	if(Instigator.IsHumanControlled()!)
	{
		Rating = W.GetAIRating();
		// End:0x115
		if(((W == Instigator.Weapon) && Instigator.Controller != none) && Instigator.Controller.Enemy != none)
		{
			Rating += 0.2100000;
		}		
	}
	else
	{
		Rating = 1.0000000;
	}
	return Rating;
	//return ReturnValue;	
}

simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
	local Weapon W, BestWeapon;
	local float Rating, BestRating;

	// End:0x1B3
	foreach InventoryActors(Class'Engine.Weapon', W)
	{
		// End:0x1B2
		if((W.HasAnyAmmo() || BestWeapon == none) || BestWeapon.HasAnyAmmo()!)
		{
			Rating = W.GetWeaponRating();
			// End:0x11A
			if((W.HasAnyAmmo() && Rating < 0.0000000) || bForceADifferentWeapon && W == Instigator.Weapon)
			{
				continue;				
			}
			// End:0x1B2
			if(((BestWeapon == none) || W.HasAnyAmmo() && BestWeapon.HasAnyAmmo()!) || Rating > BestRating)
			{
				BestWeapon = W;
				BestRating = Rating;
			}
		}		
	}	
	return BestWeapon;
	//return ReturnValue;	
}

simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
	local Weapon BestWeapon;

	LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "bForceADifferentWeapon:") @ string(bForceADifferentWeapon), 'Inventory');
	// End:0x18C
	if((bForceADifferentWeapon || PendingWeapon == none) || AIController(Instigator.Controller) != none)
	{
		BestWeapon = GetBestWeapon(bForceADifferentWeapon);
		// End:0x116
		if(BestWeapon == none)
		{
			return;
		}
		// End:0x18C
		if(BestWeapon == Instigator.Weapon)
		{
			BestWeapon = none;
			PendingWeapon = none;
			Instigator.Weapon.Activate();
		}
	}
	Instigator.Controller.StopFiring();
	SetCurrentWeapon(BestWeapon);
	//return;	
}

simulated function PrevWeapon()
{
	local Weapon CandidateWeapon, StartWeapon, W;

	StartWeapon = Instigator.Weapon;
	// End:0x4A
	if(PendingWeapon != none)
	{
		StartWeapon = PendingWeapon;
	}
	// End:0x97
	foreach InventoryActors(Class'Engine.Weapon', W)
	{
		// End:0x83
		if(W == StartWeapon)
		{
			// End:0x97
			break;
		}
		CandidateWeapon = W;		
	}	
	// End:0xDB
	if(CandidateWeapon == none)
	{
		// End:0xDA
		foreach InventoryActors(Class'Engine.Weapon', W)
		{
			CandidateWeapon = W;			
		}		
	}
	// End:0x109
	if(CandidateWeapon == Instigator.Weapon)
	{
		return;
	}
	SetCurrentWeapon(CandidateWeapon);
	//return;	
}

simulated function NextWeapon()
{
	local Weapon StartWeapon, CandidateWeapon, W;
	local bool bBreakNext;

	StartWeapon = Instigator.Weapon;
	// End:0x4A
	if(PendingWeapon != none)
	{
		StartWeapon = PendingWeapon;
	}
	// End:0xC1
	foreach InventoryActors(Class'Engine.Weapon', W)
	{
		// End:0x9D
		if(bBreakNext || StartWeapon == none)
		{
			CandidateWeapon = W;
			// End:0xC1
			break;
		}
		// End:0xC0
		if(W == StartWeapon)
		{
			bBreakNext = true;
		}		
	}	
	// End:0x108
	if(CandidateWeapon == none)
	{
		// End:0x107
		foreach InventoryActors(Class'Engine.Weapon', W)
		{
			CandidateWeapon = W;
			// End:0x107
			break;			
		}		
	}
	// End:0x136
	if(CandidateWeapon == Instigator.Weapon)
	{
		return;
	}
	SetCurrentWeapon(CandidateWeapon);
	//return;	
}

reliable client simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
	InternalSetCurrentWeapon(DesiredWeapon);
	// End:0x3A
	if(int(Role) < int(ROLE_Authority))
	{
		ServerSetCurrentWeapon(DesiredWeapon);
	}
	//return;	
}

reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
	InternalSetCurrentWeapon(DesiredWeapon);
	//return;	
}

private final simulated function InternalSetCurrentWeapon(Weapon DesiredWeapon)
{
	local Weapon PrevWeapon;

	PrevWeapon = Instigator.Weapon;
	LogInternal(((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "PrevWeapon:") @ string(PrevWeapon)) @ "DesiredWeapon:") @ string(DesiredWeapon), 'Inventory');
	// End:0x229
	if(((PrevWeapon != none) && DesiredWeapon == PrevWeapon) && PrevWeapon.IsInState('WeaponPuttingDown')!)
	{
		// End:0x229
		if(DesiredWeapon.IsInState('Inactive')! && DesiredWeapon.IsInState('PendingClientWeaponSet')!)
		{
			LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "DesiredWeapon == PrevWeapon - abort") @ string(DesiredWeapon.GetStateName()), 'Inventory');
			return;
		}
	}
	SetPendingWeapon(DesiredWeapon);
	// End:0x36F
	if((((PrevWeapon != none) && PrevWeapon != DesiredWeapon) && PrevWeapon.bDeleteMe!) && PrevWeapon.IsInState('Inactive')!)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Try to put down previous weapon first.", 'Inventory');
		PrevWeapon.TryPutDown();		
	}
	else
	{
		ChangedWeapon();
	}
	//return;	
}

simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
	LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "SetPendingWeapon to") @ string(DesiredWeapon), 'Inventory');
	PendingWeapon = DesiredWeapon;
	//return;	
}

simulated function bool CancelWeaponChange()
{
	LogInternal((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "PendingWeapon:'") $ string(PendingWeapon)) $ "'", 'Inventory');
	// End:0xDB
	if((PendingWeapon == none) && bMustHoldWeapon)
	{
		PendingWeapon = Instigator.Weapon;
	}
	return false;
	//return ReturnValue;	
}

simulated function ClearPendingWeapon()
{
	LogInternal((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "PendingWeapon:'") $ string(PendingWeapon)) $ "'", 'Inventory');
	// End:0xD2
	if(PendingWeapon != none)
	{
		PendingWeapon.GotoState('Inactive');
		PendingWeapon = none;
	}
	//return;	
}

simulated function ChangedWeapon()
{
	local Weapon OldWeapon;

	OldWeapon = Instigator.Weapon;
	LogInternal(((((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "PendingWeapon:'") $ string(PendingWeapon)) $ "'") @ "bMustHoldWeapon:'") $ string(bMustHoldWeapon)) $ "'", 'Inventory');
	// End:0x144
	if((PendingWeapon == none) && bMustHoldWeapon)
	{
		// End:0x144
		if(OldWeapon != none)
		{
			OldWeapon.Activate();
			PendingWeapon = OldWeapon;
		}
	}
	LogInternal(((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "switch from") @ string(OldWeapon)) @ "to") @ string(PendingWeapon), 'Inventory');
	Instigator.Weapon = PendingWeapon;
	Instigator.PlayWeaponSwitch(OldWeapon, PendingWeapon);
	// End:0x29D
	if(PendingWeapon != none)
	{
		PendingWeapon.Instigator = Instigator;
		PendingWeapon.Activate();
		PendingWeapon = none;
	}
	// End:0x31C
	if(Instigator.Controller != none)
	{
		Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
	}
	//return;	
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
	local Weapon OldWeapon;

	LogInternal(((((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "NewWeapon:") @ string(NewWeapon)) @ "bOptionalSet:") @ string(bOptionalSet)) @ "bDoNotActivate:") @ string(bDoNotActivate), 'Inventory');
	// End:0x70C
	if(bDoNotActivate!)
	{
		OldWeapon = Instigator.Weapon;
		// End:0x22C
		if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
		{
			LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "OldWeapon == None or Inactive - Set new weapon right away") @ string(NewWeapon), 'Inventory');
			SetCurrentWeapon(NewWeapon);
			return;
		}
		// End:0x3E1
		if(OldWeapon == NewWeapon)
		{
			// End:0x340
			if(NewWeapon.IsInState('PendingClientWeaponSet'))
			{
				LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "OldWeapon == NewWeapon - but in PendingClientWeaponSet, so reset.") @ string(NewWeapon), 'Inventory');
				SetCurrentWeapon(NewWeapon);				
			}
			else
			{
				LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "OldWeapon == NewWeapon - abort") @ string(NewWeapon), 'Inventory');
			}
			return;
		}
		// End:0x554
		if(bOptionalSet)
		{
			// End:0x554
			if(OldWeapon.DenyClientWeaponSet() || Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
			{
				LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "bOptionalSet && (DenyClientWeaponSet() || bNeverSwitchOnPickup) - abort") @ string(NewWeapon), 'Inventory');
				LastAttemptedSwitchToWeapon = NewWeapon;
				return;
			}
		}
		// End:0x70C
		if(((PendingWeapon == none) || PendingWeapon.HasAnyAmmo()!) || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
		{
			// End:0x70C
			if(Instigator.Weapon.HasAnyAmmo()! || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
			{
				LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Switch to new weapon:") @ string(NewWeapon), 'Inventory');
				SetCurrentWeapon(NewWeapon);
				return;
			}
		}
	}
	LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Send to inactive state") @ string(NewWeapon), 'Inventory');
	NewWeapon.GotoState('Inactive');
	//return;	
}

simulated function UpdateController()
{
	local Inventory Item;
	local Weapon Weap;

	Item = InventoryChain;
	J0x13:

	// End:0x97 [Loop If]
	if(Item != none)
	{
		Weap = Weapon(Item);
		// End:0x6C
		if(Weap != none)
		{
			Weap.CacheAIController();
		}
		Item = Item.Inventory;
		// [Loop Continue]
		goto J0x13;
	}
	//return;	
}

defaultproperties
{
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	TickGroup=ETickingGroup.TG_DuringAsyncWork
	bHidden=true
	bOnlyRelevantToOwner=true
	bReplicateInstigator=true
	bReplicateMovement=false
	bOnlyDirtyReplication=true
	NetPriority=1.4000000
}