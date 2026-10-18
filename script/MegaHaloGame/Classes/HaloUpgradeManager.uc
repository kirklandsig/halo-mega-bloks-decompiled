class HaloUpgradeManager extends Actor
	config(UpgradeSystem)
	notplaceable;

struct UpgradeLevel
{
	var string BaseClassName;
	var Class<Actor> BaseClass;
	var HaloUpgrade BaseArchetype;

	structdefaultproperties
	{
		BaseClassName=""
		BaseClass=none
		BaseArchetype=none
	}
};

var config bool bAllowXPBasedUpgrades;
var config bool bAllowActionableUpgrades;
var config bool bAllowGlobalUpgrades;
var config array<config UpgradeLevel> UpgradeLevels;
var array<UpgradeLevel> GlobalUpgradeLevels;
var array<Actor> AllUpgradables;
var config float UpgradeRadius;

event PostBeginPlay()
{
	local int I;

	ResolveClassReferences();
	super.PostBeginPlay();
	GlobalUpgradeLevels.Length = UpgradeLevels.Length;
	I = 0;
	J0x34:

	// End:0x81 [Loop If]
	if(I < UpgradeLevels.Length)
	{
		GlobalUpgradeLevels[I] = UpgradeLevels[I];
		I++;
		// [Loop Continue]
		goto J0x34;
	}
	LogContents();
	//return;	
}

event Destroyed()
{
	super.Destroyed();
	//return;	
}

simulated function ResolveClassReferences()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xC7 [Loop If]
	if(I < UpgradeLevels.Length)
	{
		// End:0xB9
		if(UpgradeLevels[I].BaseClassName != "")
		{
			UpgradeLevels[I].BaseClass = Class<Actor>(FindObject(UpgradeLevels[I].BaseClassName, Class'Core.Class'));
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function LogContents()
{
	local int I;

	LogInternal("UpgradeLevels.length = " $ string(UpgradeLevels.Length));
	I = 0;
	J0x35:

	// End:0xD7 [Loop If]
	if(I < UpgradeLevels.Length)
	{
		LogInternal((("    > BASE CLASS: " $ string(UpgradeLevels[I].BaseClass)) $ ", ARCHETYPE: ") $ string(UpgradeLevels[I].BaseArchetype));
		I++;
		// [Loop Continue]
		goto J0x35;
	}
	//return;	
}

function AddUpgradable(Actor aActor)
{
	// End:0xDF
	if(NotEqual_InterfaceInterface(HaloUpgradableInterface(aActor), HaloUpgradableInterface(none)))
	{
		// End:0xDF
		if(AllUpgradables.Find(aActor) == -1)
		{
			AllUpgradables.AddItem(aActor);
			// End:0xDF
			if(HaloUpgradableInterface(aActor).GetUpgrade() == none)
			{
				HaloUpgradableInterface(aActor).SetUpgrade(GetBaseUpgrade(aActor.Class));
			}
		}
	}
	//return;	
}

function RemoveUpgradable(Actor aActor)
{
	AllUpgradables.RemoveItem(aActor);
	//return;	
}

simulated function bool VerifySanity(UpgradeLevel upgradeData, HaloUpgradableInterface TargetObj)
{
	// End:0x22
	if(EqualEqual_InterfaceInterface(TargetObj, HaloUpgradableInterface(none)))
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

simulated function bool AttemptUpgradesFromXP(HaloUpgradableInterface TargetObj, int prevXP, int newXP)
{
	local bool anyUpgradesPerformed;
	local HaloUpgrade aUpgrade;

	anyUpgradesPerformed = false;
	// End:0x1E6
	if(bAllowXPBasedUpgrades)
	{
		aUpgrade = TargetObj.GetUpgrade();
		J0x43:

		// End:0x128 [Loop If]
		if((((aUpgrade != none) && aUpgrade.NextUpgrades.Length > 0) && aUpgrade.NextUpgrades[0].XPRequired > 0) && newXP >= aUpgrade.NextUpgrades[0].XPRequired)
		{
			aUpgrade = aUpgrade.NextUpgrades[0];
			// [Loop Continue]
			goto J0x43;
		}
		// End:0x1E6
		if(aUpgrade != TargetObj.GetUpgrade())
		{
			TargetObj.SetUpgrade(aUpgrade);
			anyUpgradesPerformed = true;
			LogInternal((((("WENT FROM " $ string(prevXP)) $ " to ") $ string(newXP)) $ " so we're upgrading with ") $ string(aUpgrade));
		}
	}
	return anyUpgradesPerformed;
	//return ReturnValue;	
}

simulated function ApplyUpgradeToAll(const Class<Actor> BaseClass, HaloUpgrade newUpgrade)
{
	local int LevelIdx;
	local Actor upgradeCandidate;

	// End:0x170
	if(bAllowGlobalUpgrades)
	{
		LevelIdx = 0;
		J0x18:

		// End:0x76 [Loop If]
		if(LevelIdx < GlobalUpgradeLevels.Length)
		{
			// End:0x68
			if(ClassIsChildOf(GlobalUpgradeLevels[LevelIdx].BaseClass, BaseClass))
			{
				// [Explicit Break]
				goto J0x76;
			}
			LevelIdx++;
			// [Loop Continue]
			goto J0x18;
		}
		J0x76:

		// End:0x170
		if(LevelIdx < GlobalUpgradeLevels.Length)
		{
			// End:0x13D
			foreach AllUpgradables(upgradeCandidate)
			{
				// End:0x13C
				if((upgradeCandidate != none) && GlobalUpgradeLevels[LevelIdx].BaseArchetype == HaloUpgradableInterface(upgradeCandidate).GetUpgrade())
				{
					HaloUpgradableInterface(upgradeCandidate).SetUpgrade(newUpgrade);
				}				
			}			
			GlobalUpgradeLevels[LevelIdx].BaseArchetype = newUpgrade;
			return;
		}
	}
	WarnInternal(((("INVALID class or index passed to ApplyUpgradeLevelToAll. (" $ string(BaseClass)) $ ", ") $ string(LevelIdx)) $ ") - check config files!");
	//return;	
}

function HaloUpgrade GetBaseUpgrade(const Class<Actor> aClass)
{
	local int LevelIdx;

	// End:0x24
	if(bAllowGlobalUpgrades == true)
	{
		return GetGlobalUpgrade(aClass);
	}
	LevelIdx = 0;
	J0x2F:

	// End:0xB4 [Loop If]
	if(LevelIdx < UpgradeLevels.Length)
	{
		// End:0xA6
		if(ClassIsChildOf(UpgradeLevels[LevelIdx].BaseClass, aClass) == true)
		{
			return UpgradeLevels[LevelIdx].BaseArchetype;
		}
		LevelIdx++;
		// [Loop Continue]
		goto J0x2F;
	}
	return none;
	//return ReturnValue;	
}

function HaloUpgrade GetGlobalUpgrade(const Class<Actor> aClass)
{
	local int LevelIdx;

	// End:0xA0
	if(bAllowGlobalUpgrades == true)
	{
		LevelIdx = 0;
		J0x1B:

		// End:0xA0 [Loop If]
		if(LevelIdx < GlobalUpgradeLevels.Length)
		{
			// End:0x92
			if(ClassIsChildOf(GlobalUpgradeLevels[LevelIdx].BaseClass, aClass) == true)
			{
				return GlobalUpgradeLevels[LevelIdx].BaseArchetype;
			}
			LevelIdx++;
			// [Loop Continue]
			goto J0x1B;
		}
	}
	return none;
	//return ReturnValue;	
}

function bool FindUpgradeNearby(out Actor nearbyActor, HaloPlayerPawnController aController)
{
	local Actor aActor, bestActor;
	local Vector ViewDir, PawnLoc2D, VLoc2D;
	local float NewDot, BestDot, checkDistanceSq;
	local int Bank, I;
	local HaloUpgrade aUpgrade;

	// End:0x11
	if(aController == none)
	{
		return false;
	}
	Bank = aController.BlokCollector.GetBankCount();
	PawnLoc2D = aController.Pawn.Location;
	PawnLoc2D.Z = 0.0000000;
	ViewDir = Vector(aController.Pawn.Rotation);
	checkDistanceSq = UpgradeRadius * UpgradeRadius;
	// End:0x419
	foreach AllUpgradables(aActor)
	{
		// End:0x19A
		if((aActor == none) || VSizeSq(aActor.Location - aController.Pawn.Location) > checkDistanceSq)
		{
			continue;			
		}
		else
		{
			aUpgrade = HaloUpgradableInterface(aActor).GetUpgrade();
			// End:0x1E0
			if(aUpgrade == none)
			{
				continue;				
			}
			else
			{
				I = 0;
				J0x1EB:

				// End:0x324 [Loop If]
				if(I < aUpgrade.NextUpgrades.Length)
				{
					// End:0x270
					if((bAllowGlobalUpgrades == true) && aUpgrade.NextUpgrades[I].GlobalBloksRequired > 0)
					{						
					}
					else
					{
						// End:0x2C8
						if((bAllowXPBasedUpgrades == true) && aUpgrade.NextUpgrades[I].XPRequired > 0)
						{							
						}
						else
						{
							// End:0x316
							if(aUpgrade.NextUpgrades[I].BloksRequired <= Bank)
							{
								// [Explicit Break]
								goto J0x324;
							}
						}
					}
					I++;
					// [Loop Continue]
					goto J0x1EB;
				}
				J0x324:

				// End:0x355
				if(I == aUpgrade.NextUpgrades.Length)
				{
					continue;					
				}
				else
				{
					VLoc2D = aActor.Location;
					VLoc2D.Z = 0.0000000;
					NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
					// End:0x418
					if((bestActor == none) || NewDot > BestDot)
					{
						bestActor = aActor;
						BestDot = NewDot;
					}					
				}
			}
		}
	}	
	// End:0x43E
	if(bestActor != none)
	{
		nearbyActor = bestActor;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToUpgradeNearby(HaloPlayerPawnController aController, optional int aIndex = 0)
{
	local Actor aActor;
	local HaloUpgrade aUpgrade;

	// End:0x15C
	if((FindUpgradeNearby(aActor, aController)) == true)
	{
		aUpgrade = HaloUpgradableInterface(aActor).GetUpgrade();
		// End:0x15C
		if((aUpgrade != none) && aIndex < aUpgrade.NextUpgrades.Length)
		{
			aController.BlokCollector.RemoveFromBank(aUpgrade.NextUpgrades[aIndex].BloksRequired);
			HaloUpgradableInterface(aActor).SetUpgrade(aUpgrade.NextUpgrades[aIndex]);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	bAllowActionableUpgrades=true
	UpgradeLevels[0]=(BaseClassName="MegaHaloGameContent.HaloTurret_MachineGun_Content",BaseClass=none,BaseArchetype=HaloUpgrade_Turret'HaloUpgradeArchetypes.Turret.Turret_Upgrade0')
	UpgradeLevels[1]=(BaseClassName="MegaHaloGameContent.HaloTurret_Mortar_Content",BaseClass=none,BaseArchetype=HaloUpgrade_Mortar'HaloUpgradeArchetypes.Mortar.Mortar_Upgrade0')
	UpgradeRadius=400.0000000
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}