class UTWeaponLocker extends UTPickupFactory
	abstract;

struct native WeaponEntry
{
	var Class<UTWeapon> WeaponClass;
	var export editinline PrimitiveComponent PickupMesh;

	structdefaultproperties
	{
		WeaponClass=none
		PickupMesh=none
	}
};

struct native ReplacementWeaponEntry
{
	var bool bReplaced;
	var Class<UTWeapon> WeaponClass;

	structdefaultproperties
	{
		bReplaced=false
		WeaponClass=none
	}
};

struct native PawnToucher
{
	var Pawn P;
	var float NextTouchTime;

	structdefaultproperties
	{
		P=none
		NextTouchTime=0.0000000
	}
};

var array<WeaponEntry> Weapons;
var repnotify ReplacementWeaponEntry ReplacementWeapons[6];
var array<Vector> LockerPositions;
var const localized string LockerString;
var array<PawnToucher> Customers;
var bool bIsActive;
var bool bPlayerNearby;
var bool bScalingUp;
var float CurrentWeaponScaleX;
var float ProximityDistanceSquared;
var export editinline ParticleSystemComponent AmbientEffect;
var export editinline ParticleSystemComponent ProximityEffect;
var ParticleSystem InactiveEffectTemplate;
var ParticleSystem ActiveEffectTemplate;
var ParticleSystem WeaponSpawnEffectTemplate;
var float ScaleRate;
var float NextProximityCheckTime;

replication
{
	// Pos:0x000
	if(bNetInitial)
		ReplacementWeapons;
}

simulated event SetInitialState()
{
	// End:0x1E
	if(bIsDisabled)
	{
		GotoState('Disabled');		
	}
	else
	{
		super(Actor).SetInitialState();
	}
	//return;	
}

function bool ShouldCamp(UTBot B, float MaxWait)
{
	return false;
	//return ReturnValue;	
}

function bool AddCustomer(Pawn P)
{
	local int I;
	local PawnToucher Pt;

	// End:0x2F
	if(UTInventoryManager(P.InvManager) == none)
	{
		return false;
	}
	// End:0x193
	if(Customers.Length > 0)
	{
		I = 0;
		J0x4A:

		// End:0x193 [Loop If]
		if(I < Customers.Length)
		{
			// End:0x14F
			if(Customers[I].NextTouchTime < WorldInfo.TimeSeconds)
			{
				// End:0x12C
				if(Customers[I].P == P)
				{
					Customers[I].NextTouchTime = WorldInfo.TimeSeconds + float(30);
					return true;
				}
				Customers.Remove(I, 1);
				I--;				
			}
			else
			{
				// End:0x185
				if(Customers[I].P == P)
				{
					return false;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x4A;
		}
	}
	Pt.P = P;
	Pt.NextTouchTime = WorldInfo.TimeSeconds + float(30);
	Customers[Customers.Length] = Pt;
	return true;
	//return ReturnValue;	
}

function bool HasCustomer(Pawn P)
{
	local int I;

	// End:0x119
	if(Customers.Length > 0)
	{
		I = 0;
		J0x1B:

		// End:0x119 [Loop If]
		if(I < Customers.Length)
		{
			// End:0xD5
			if(Customers[I].NextTouchTime < WorldInfo.TimeSeconds)
			{
				// End:0xB2
				if(Customers[I].P == P)
				{
					return false;
				}
				Customers.Remove(I, 1);
				I--;				
			}
			else
			{
				// End:0x10B
				if(Customers[I].P == P)
				{
					return true;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x1B;
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function PostBeginPlay()
{
	// End:0x0F
	if(bIsDisabled)
	{
		return;
	}
	super.PostBeginPlay();
	InitializeWeapons();
	//return;	
}

simulated function InitializeWeapons()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x97 [Loop If]
	if((I < Weapons.Length) && I < LockerPositions.Length)
	{
		// End:0x89
		if(Weapons[I].WeaponClass == none)
		{
			Weapons.Remove(I, 1);
			I--;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	MaxDesireability = 0.0000000;
	I = 0;
	J0xB1:

	// End:0x11D [Loop If]
	if(I < Weapons.Length)
	{
		MaxDesireability += Weapons[I].WeaponClass.default.AIRating;
		I++;
		// [Loop Continue]
		goto J0xB1;
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	local int I;

	// End:0x177
	if(VarName == 'ReplacementWeapons')
	{
		I = 0;
		J0x22:

		// End:0x16A [Loop If]
		if(I < 6)
		{
			// End:0x15C
			if(ReplacementWeapons[I].bReplaced)
			{
				// End:0x8B
				if(I >= Weapons.Length)
				{
					Weapons.Length = I + 1;
				}
				Weapons[I].WeaponClass = ReplacementWeapons[I].WeaponClass;
				// End:0x15C
				if(Weapons[I].PickupMesh != none)
				{
					DetachComponent(Weapons[I].PickupMesh);
					Weapons[I].PickupMesh = none;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x22;
		}
		InitializeWeapons();		
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
	//return;	
}

function ReplaceWeapon(int Index, Class<UTWeapon> NewWeaponClass)
{
	// End:0xD7
	if(Index >= 0)
	{
		// End:0x3E
		if(Index >= Weapons.Length)
		{
			Weapons.Length = Index + 1;
		}
		Weapons[Index].WeaponClass = NewWeaponClass;
		// End:0xD7
		if(Index < 6)
		{
			ReplacementWeapons[Index].bReplaced = true;
			ReplacementWeapons[Index].WeaponClass = NewWeaponClass;
		}
	}
	//return;	
}

function Reset()
{
	super(Actor).Reset();
	//return;	
}

simulated function string GetHumanReadableName()
{
	return LockerString;
	//return ReturnValue;	
}

function float BotDesireability(Pawn Bot, Controller C)
{
	local UTWeapon AlreadyHas;
	local float desire;
	local int I;

	// End:0x2B
	if(bHidden || HasCustomer(Bot))
	{
		return 0.0000000;
	}
	I = 0;
	J0x36:

	// End:0x16B [Loop If]
	if(I < Weapons.Length)
	{
		// End:0x15D
		if(Weapons[I].WeaponClass != none)
		{
			AlreadyHas = UTWeapon(Bot.FindInventoryType(Weapons[I].WeaponClass));
			// End:0x12B
			if(AlreadyHas == none)
			{
				desire += Weapons[I].WeaponClass.default.AIRating;				
			}
			else
			{
				// End:0x15D
				if(AlreadyHas.NeedAmmo())
				{
					desire += 0.1500000;
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x36;
	}
	// End:0x1ED
	if(UTBot(C).bHuntPlayer && (desire * 0.8330000) < (Bot.Weapon.AIRating - 0.1000000))
	{
		return 0.0000000;
	}
	// End:0x261
	if((Bot.Weapon == none) || Bot.Weapon.AIRating < 0.5000000)
	{
		return 2.0000000 * desire;
	}
	return desire;
	//return ReturnValue;	
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	local UTWeapon AlreadyHas;
	local float desire;
	local int I;

	// End:0x2B
	if(bHidden || HasCustomer(Other))
	{
		return 0.0000000;
	}
	I = 0;
	J0x36:

	// End:0x13F [Loop If]
	if(I < Weapons.Length)
	{
		AlreadyHas = UTWeapon(Other.FindInventoryType(Weapons[I].WeaponClass));
		// End:0xFF
		if(AlreadyHas == none)
		{
			desire += Weapons[I].WeaponClass.default.AIRating;			
		}
		else
		{
			// End:0x131
			if(AlreadyHas.NeedAmmo())
			{
				desire += 0.1500000;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x36;
	}
	// End:0x1E6
	if(UTBot(Other.Controller).PriorityObjective() && (Other.Weapon.AIRating > 0.5000000) || PathWeight > float(400))
	{
		return 0.2000000 / PathWeight;
	}
	return desire / PathWeight;
	//return ReturnValue;	
}

simulated function InitializePickup()
{
	//return;	
}

simulated function ShowActive()
{
	//return;	
}

simulated function NotifyLocalPlayerDead(PlayerController PC)
{
	//return;	
}

simulated event SetPlayerNearby(PlayerController PC, bool bNewPlayerNearby, bool bPlayEffects)
{
	local int I;
	local Vector NewScale;
	local editinline PrimitiveComponent DefaultMesh;
	local UTInventoryManager InvManager;

	// End:0x8EE
	if(bNewPlayerNearby != bPlayerNearby)
	{
		bPlayerNearby = bNewPlayerNearby;
		// End:0x59
		if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
		{
			return;
		}
		// End:0x73A
		if(bPlayerNearby)
		{
			LightEnvironment.bDynamic = true;
			bScalingUp = true;
			CurrentWeaponScaleX = 0.1000000;
			// End:0x1DE
			if((PC != none) && PC.Pawn != none)
			{
				// End:0x14D
				if(UTPawn(PC.Pawn) != none)
				{
					InvManager = UTInventoryManager(PC.Pawn.InvManager);					
				}
				else
				{
					// End:0x1DE
					if(UTVehicle(PC.Pawn) != none)
					{
						InvManager = UTInventoryManager(UTVehicle(PC.Pawn).Driver.InvManager);
					}
				}
			}
			// End:0x702
			if(InvManager != none)
			{
				I = 0;
				J0x1F8:

				// End:0x702 [Loop If]
				if(I < Weapons.Length)
				{
					// End:0x6F4
					if((Weapons[I].WeaponClass.default.PickupFactoryMesh != none) && InvManager.HasInventoryOfClass(Weapons[I].WeaponClass) == none)
					{
						// End:0x5D0
						if(Weapons[I].PickupMesh == none)
						{
							DefaultMesh = Weapons[I].WeaponClass.default.PickupFactoryMesh;
							Weapons[I].PickupMesh = new (self) DefaultMesh.Class (DefaultMesh);
							Weapons[I].PickupMesh.SetTranslation(LockerPositions[I] + Weapons[I].WeaponClass.default.LockerOffset);
							Weapons[I].PickupMesh.SetRotation(Weapons[I].WeaponClass.default.LockerRotation);
							Weapons[I].PickupMesh.SetLightEnvironment(LightEnvironment);
							// End:0x524
							if(SkeletalMeshComponent(Weapons[I].PickupMesh) != none)
							{
								SkeletalMeshComponent(Weapons[I].PickupMesh).bForceRefpose = 1;
							}
							NewScale = Weapons[I].PickupMesh.Scale3D;
							NewScale.X = 0.1000000;
							Weapons[I].PickupMesh.SetScale3D(NewScale);
						}
						// End:0x6F4
						if(Weapons[I].PickupMesh != none)
						{
							Weapons[I].PickupMesh.SetHidden(false);
							AttachComponent(Weapons[I].PickupMesh);
							// End:0x6F4
							if(bPlayEffects)
							{
								WorldInfo.MyEmitterPool.SpawnEmitter(WeaponSpawnEffectTemplate, Weapons[I].PickupMesh.GetPosition());
							}
						}
					}
					I++;
					// [Loop Continue]
					goto J0x1F8;
				}
			}
			ProximityEffect.SetActive(true);
			ClearTimer('DestroyWeapons');			
		}
		else
		{
			LightEnvironment.bDynamic = false;
			bPlayEffects = bPlayEffects && EffectIsRelevant(Location, false);
			bScalingUp = false;
			I = 0;
			J0x7A2:

			// End:0x8BC [Loop If]
			if(I < Weapons.Length)
			{
				// End:0x8AE
				if(Weapons[I].PickupMesh != none)
				{
					Weapons[I].PickupMesh.SetHidden(true);
					// End:0x8AE
					if(bPlayEffects)
					{
						WorldInfo.MyEmitterPool.SpawnEmitter(WeaponSpawnEffectTemplate, Weapons[I].PickupMesh.GetPosition());
					}
				}
				I++;
				// [Loop Continue]
				goto J0x7A2;
			}
			ProximityEffect.DeactivateSystem();
			SetTimer(5.0000000, false, 'DestroyWeapons');
		}
	}
	//return;	
}

simulated function DestroyWeapons()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xB5 [Loop If]
	if(I < Weapons.Length)
	{
		// End:0xA7
		if(Weapons[I].PickupMesh != none)
		{
			DetachComponent(Weapons[I].PickupMesh);
			Weapons[I].PickupMesh = none;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function ShowHidden()
{
	bIsActive = false;
	AmbientEffect.SetTemplate(InactiveEffectTemplate);
	SetPlayerNearby(none, false, false);
	//return;	
}

auto state LockerPickup
{
	simulated event Tick(float DeltaTime)
	{
		local bool bNewPlayerNearby;
		local PlayerController NearbyPC, PC;

		// End:0x37
		if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
		{
			Disable('Tick');			
		}
		else
		{
			// End:0x198
			if(bIsActive)
			{
				// End:0x198
				if(WorldInfo.TimeSeconds > NextProximityCheckTime)
				{
					NextProximityCheckTime = (WorldInfo.TimeSeconds + 0.2000000) + (0.1000000 * FRand());
					// End:0x160
					foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
					{
						// End:0x15F
						if((PC.Pawn != none) && VSizeSq(Location - PC.Pawn.Location) < ProximityDistanceSquared)
						{
							bNewPlayerNearby = true;
							NearbyPC = PC;
							// End:0x160
							break;
						}						
					}					
					// End:0x198
					if(bNewPlayerNearby != bPlayerNearby)
					{
						SetPlayerNearby(NearbyPC, bNewPlayerNearby, true);
					}
				}
			}
		}
		//return;		
	}

	function bool ReadyToPickup(float MaxWait)
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool ValidTouch(Actor Other)
	{
		// End:0x4C
		if((Pawn(Other) == none) || !Pawn(Other).bCanPickupInventory)
		{
			return false;			
		}
		else
		{
			// End:0x91
			if(Pawn(Other).Controller == none)
			{
				SetTimer(0.2000000, false, 'RecheckValidTouch');
				return false;				
			}
			else
			{
				// End:0xD7
				if(!FastTrace(Other.Location, Location))
				{
					SetTimer(0.5000000, false, 'RecheckValidTouch');
					return false;
				}
			}
		}
		return true;
		//return ReturnValue;		
	}

	function RecheckValidTouch()
	{
		CheckTouching();
		//return;		
	}

	function CheckTouching()
	{
		local Pawn P;

		// End:0x61
		foreach TouchingActors(Class'Engine.Pawn', P)
		{
			Touch(P, none, Location, Normal(Location - P.Location));			
		}		
		//return;		
	}

	simulated function ShowActive()
	{
		bIsActive = true;
		AmbientEffect.SetTemplate(ActiveEffectTemplate);
		NextProximityCheckTime = 0.0000000;
		//return;		
	}

	simulated function NotifyLocalPlayerDead(PlayerController PC)
	{
		ShowActive();
		//return;		
	}

	simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
	{
		local int I;
		local UTWeapon Copy;
		local Pawn Recipient;

		// End:0x4CF
		if(ValidTouch(Other))
		{
			Recipient = Pawn(Other);
			// End:0x168
			if(((Recipient.Controller != none) && Recipient.Controller.IsLocalPlayerController()) || ((Recipient.DrivenVehicle != none) && Recipient.DrivenVehicle.Controller != none) && Recipient.DrivenVehicle.Controller.IsLocalPlayerController())
			{
				// End:0x168
				if(bIsActive)
				{
					ShowHidden();
					SetTimer(30.0000000, false, 'ShowActive');
				}
			}
			// End:0x17E
			if(int(Role) < int(ROLE_Authority))
			{
				return;
			}
			// End:0x198
			if(!AddCustomer(Recipient))
			{
				return;
			}
			I = 0;
			J0x1A3:

			// End:0x4CF [Loop If]
			if(I < Weapons.Length)
			{
				InventoryType = Weapons[I].WeaponClass;
				Copy = UTWeapon(UTInventoryManager(Recipient.InvManager).HasInventoryOfClass(InventoryType));
				// End:0x31F
				if(Copy != none)
				{
					// End:0x2F4
					if((Copy.LockerAmmoCount - Copy.AmmoCount) > 0)
					{
						Copy.AddAmmo(Copy.LockerAmmoCount - Copy.AmmoCount);
					}
					Copy.AnnouncePickup(Recipient);					
				}
				else
				{
					// End:0x4C1
					if(WorldInfo.Game.PickupQuery(Recipient, InventoryType, self))
					{
						Copy = UTWeapon(Spawn(InventoryType));
						// End:0x499
						if(Copy != none)
						{
							Copy.GiveTo(Recipient);
							Copy.AnnouncePickup(Recipient);
							// End:0x496
							if((Copy.LockerAmmoCount - Copy.default.AmmoCount) > 0)
							{
								Copy.AddAmmo(Copy.LockerAmmoCount - Copy.default.AmmoCount);
							}							
						}
						else
						{
							LogInternal((string(self) $ " failed to spawn ") $ string(InventoryType));
						}
					}
				}
				I++;
				// [Loop Continue]
				goto J0x1A3;
			}
		}
		//return;		
	}

	simulated event BeginState(name PreviousStateName)
	{
		super(Object).BeginState(PreviousStateName);
		ShowActive();
		//return;		
	}
	stop;	
}

state Disabled
{
	simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		ShowHidden();
		//return;		
	}
	stop;	
}

defaultproperties
{
	LockerPositions=/* ERROR: System.ArgumentOutOfRangeException */
	LockerString="Weapon Locker"
	ProximityDistanceSquared=600000.0000000
	ScaleRate=2.0000000
	// Reference: DynamicLightEnvironmentComponent'UTGame.Default__UTWeaponLocker.PickupLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTPickupFactory.PickupLightEnvironment'
	begin object name="PickupLightEnvironment"
	end object
	LightEnvironment=PickupLightEnvironment
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTWeaponLocker.ForceFeedbackWaveformPickUp'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTPickupFactory.ForceFeedbackWaveformPickUp'
	begin object name="ForceFeedbackWaveformPickUp"
	end object
	PickUpWaveForm=ForceFeedbackWaveformPickUp
	// Reference: StaticMeshComponent'UTGame.Default__UTWeaponLocker.BaseMeshComp'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BaseMeshComp'
	// Archetype: StaticMeshComponent'UTGame.Default__UTPickupFactory.BaseMeshComp'
	begin object name="BaseMeshComp"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'UTGame.Default__UTWeaponLocker.PickupLightEnvironment'
	end object
	BaseMesh=BaseMeshComp
	// Reference: CylinderComponent'UTGame.Default__UTWeaponLocker.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTPickupFactory.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=50.0000000
		CollisionRadius=80.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=PickupLightEnvironment
	Components[3]=BaseMeshComp
	CollisionComponent=CollisionCylinder
}