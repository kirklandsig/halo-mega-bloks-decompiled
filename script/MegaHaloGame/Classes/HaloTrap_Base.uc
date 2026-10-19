class HaloTrap_Base extends Actor
	abstract
	notplaceable
	implements(HaloUpgradableInterface,IHaloDeployable);

enum HaloTrap_Type
{
	TRAP_Ground_Mine,               // 0
	TRAP_Ground_Slow,               // 1
	TRAP_Wall_Projectile,           // 2
	TRAP_Wall_Hammer,               // 3
	TRAP_MAX                        // 4
};

var protected HaloTrap_Base.HaloTrap_Type TrapType;
var private byte TeamNum;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
var protected export editinline MeshComponent BaseMeshComponent;
var protected array<HaloPawn> TargetPawns;
var private float broadcastDistance;
var protected float LineOfSightRecheckTime;
var protected float ActivateDelay;
var protected AkEvent ActivateSound;
var protected MaterialInstance ActivateMaterialTemplate;
var protected float ExecuteDelay;
var protected AkEvent ExecuteSound;
var protected MaterialInstance ExecuteMaterialTemplate;
var protected float CooldownTime;
var protected AkEvent ResetSound;
var protected MaterialInstance CooldownMaterialTemplate;
var name DeployableName;
var Actor DeployableBase;
var int UpgradeXP;
var HaloUpgrade Upgrade;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	self.Entered(Other);
	self.CheckForActivation(HaloPawn(Other));
	//return;	
}

simulated event UnTouch(Actor Other)
{
	self.Exited(Other);
	//return;	
}

function Entered(Actor Actor)
{
	local HaloPawn Pawn;

	Pawn = HaloPawn(Actor);
	// End:0x66
	if(IsValidTarget(Pawn))
	{
		TargetPawns.AddItem(Pawn);
		NotifyPawn(Pawn, TrapType, true);
	}
	//return;	
}

function Exited(Actor Actor)
{
	local HaloPawn Pawn;

	Pawn = HaloPawn(Actor);
	// End:0x70
	if(TargetPawns.Find(Pawn) != -1)
	{
		TargetPawns.RemoveItem(Pawn);
		NotifyPawn(Pawn, TrapType, false);
	}
	//return;	
}

function bool CheckForActivation(HaloPawn Pawn)
{
	// End:0x38
	if((IsValidTarget(Pawn)) && IsInState('Ready'))
	{
		GotoState('Activate');
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool IsValidTarget(HaloPawn Pawn)
{
	return (((Pawn != none) && int(self.GetTeamNum()) != int(Pawn.GetTeamNum())) && Pawn.IsAliveAndWell()) && HasLOS(Pawn);
	//return ReturnValue;	
}

function bool HasLOS(HaloPawn Pawn)
{
	return true;
	//return ReturnValue;	
}

function RecheckLOS()
{
	local HaloPawn Pawn;

	// End:0x32
	foreach TouchingActors(Class'MegaHaloGame.HaloPawn', Pawn)
	{
		// End:0x31
		if(CheckForActivation(Pawn))
		{			
			return;
		}		
	}	
	//return;	
}

function SetMeshMaterial(MaterialInstance materialTemplate)
{
	local int I;
	local MaterialInstanceConstant Material;

	// End:0x100
	if((BaseMeshComponent != none) && materialTemplate != none)
	{
		I = 0;
		J0x2B:

		// End:0x100 [Loop If]
		if(I < BaseMeshComponent.GetNumElements())
		{
			Material = BaseMeshComponent.CreateAndSetMaterialInstanceConstant(I);
			// End:0xF2
			if(Material != none)
			{
				Material.SetParent(materialTemplate);
				BaseMeshComponent.SetMaterial(I, Material);
			}
			I++;
			// [Loop Continue]
			goto J0x2B;
		}
	}
	//return;	
}

simulated function NotifyPawn(Pawn Pawn, HaloTrap_Base.HaloTrap_Type Type, bool bEntered, optional bool bBroadcast = false)
{
	// End:0x5B
	if(Pawn != none)
	{
		Pawn.NotifyTrap(int(Type), bEntered, bBroadcast, broadcastDistance);
	}
	//return;	
}

simulated event byte ScriptGetTeamNum()
{
	return TeamNum;
	//return ReturnValue;	
}

simulated event ScriptSetTeamNum(byte newTeamNum)
{
	TeamNum = newTeamNum;
	//return;	
}

function SetMeshColor(LinearColor newColor)
{
	local int M;
	local MaterialInterface Mat;
	local MaterialInstanceConstant MIC;

	M = 0;
	J0x0B:

	// End:0x115 [Loop If]
	if(M < BaseMeshComponent.Materials.Length)
	{
		Mat = BaseMeshComponent.GetMaterial(M);
		MIC = MaterialInstanceConstant(Mat);
		// End:0xC7
		if(MIC == none)
		{
			MIC = BaseMeshComponent.CreateAndSetMaterialInstanceConstant(M);
		}
		// End:0x107
		if(MIC != none)
		{
			MIC.SetVectorParameterValue('CLR_Tinting', newColor);
		}
		++M;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	return DeployableCategory;
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	DeployableCategory = newCategory;
	//return;	
}

function name GetDeployableName()
{
	return DeployableName;
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	DeployableName = NewName;
	//return;	
}

function Actor GetDeployableBase()
{
	return DeployableBase;
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	DeployableBase = NewBase;
	//return;	
}

function Actor GetDeployable()
{
	return self;
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	local array< Class<HaloVCustomizationComponent> > returnArr;

	returnArr.Length = 0;
	return returnArr;
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	//return;	
}

function AddUpgradeXP(int xp)
{
	local HaloGameDefault curHaloGameType;
	local HaloUpgradeManager upgradeMan;
	local int prevXP;

	curHaloGameType = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x117
	if(curHaloGameType != none)
	{
		upgradeMan = curHaloGameType.GetUpgradeManager();
		// End:0x117
		if((upgradeMan != none) && upgradeMan.bAllowXPBasedUpgrades == true)
		{
			prevXP = UpgradeXP;
			UpgradeXP += xp;
			upgradeMan.AttemptUpgradesFromXP(HaloUpgradableInterface(self), prevXP, UpgradeXP);
		}
	}
	//return;	
}

function SetUpgradeXP(int xp, optional bool checkUpgrades = false)
{
	// End:0x36
	if(checkUpgrades == true)
	{
		AddUpgradeXP(xp - UpgradeXP);		
	}
	else
	{
		UpgradeXP = xp;
	}
	//return;	
}

function SetUpgrade(HaloUpgrade aUpgrade)
{
	Upgrade = aUpgrade;
	//return;	
}

function HaloUpgrade GetUpgrade()
{
	return Upgrade;
	//return ReturnValue;	
}

auto state Ready
{
	ignores ExitState;

	event EndState(name NextStateName)
	{
		ExitState();
		//return;		
	}

	function EnterState()
	{
		local int I;

		// End:0xA5
		if(BaseMeshComponent != none)
		{
			I = 0;
			J0x1A:

			// End:0xA5 [Loop If]
			if(I < BaseMeshComponent.GetNumElements())
			{
				BaseMeshComponent.SetMaterial(I, default.BaseMeshComponent.GetMaterial(I));
				I++;
				// [Loop Continue]
				goto J0x1A;
			}
		}
		//return;		
	}
Begin:

	EnterState();
	stop;		
}

state Activate
{
	ignores ExitState;

	event EndState(name NextStateName)
	{
		ExitState();
		//return;		
	}

	function EnterState()
	{
		PlayAkEvent(ActivateSound);
		SetMeshMaterial(ActivateMaterialTemplate);
		GotoState('Execute');
		//return;		
	}
Begin:

	Sleep(ActivateDelay);
	EnterState();
	stop;		
}

state Execute
{
	ignores ExitState;

	event EndState(name NextStateName)
	{
		ExitState();
		//return;		
	}

	function EnterState()
	{
		GotoState('Cooldown');
		//return;		
	}
Begin:

	Sleep(ExecuteDelay);
	EnterState();
	stop;		
}

state Cooldown
{
	event EndState(name NextStateName)
	{
		ExitState();
		//return;		
	}

	function EnterState()
	{
		SetMeshMaterial(CooldownMaterialTemplate);
		//return;		
	}

	function ExitState()
	{
		local int I;

		// End:0xA5
		if(BaseMeshComponent != none)
		{
			I = 0;
			J0x1A:

			// End:0xA5 [Loop If]
			if(I < BaseMeshComponent.GetNumElements())
			{
				BaseMeshComponent.SetMaterial(I, default.BaseMeshComponent.GetMaterial(I));
				I++;
				// [Loop Continue]
				goto J0x1A;
			}
		}
		//return;		
	}

	function Reactivate()
	{
		local HaloPawn Pawn;

		// End:0x40
		foreach TouchingActors(Class'MegaHaloGame.HaloPawn', Pawn)
		{
			// End:0x3F
			if(IsValidTarget(Pawn))
			{
				GotoState('Activate');				
				return;
			}			
		}		
		PlayAkEvent(ResetSound);
		GotoState('Ready');
		//return;		
	}
Begin:

	EnterState();
	Sleep(CooldownTime);
	Reactivate();
	stop;				
}

defaultproperties
{
	broadcastDistance=5000.0000000
	LineOfSightRecheckTime=0.2500000
}