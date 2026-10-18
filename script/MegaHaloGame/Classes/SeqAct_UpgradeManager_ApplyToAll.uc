class SeqAct_UpgradeManager_ApplyToAll extends SequenceAction;

enum EUpgradeGroup
{
	UG_Turret_MachineGun,           // 0
	UG_Turret_Mortar,               // 1
	UG_Turret_MAX                   // 2
};

var SeqAct_UpgradeManager_ApplyToAll.EUpgradeGroup UpgradeGroup;
var Actor TargetActor;

event Activated()
{
	local HaloPlayerPawnController aController;
	local HaloUpgradeManager upgradeManager;
	local HaloUpgrade aUpgrade;
	local int aIndex;
	local bool isSuccess;
	local Class<Actor> upgradeClass;

	switch(UpgradeGroup)
	{
		// End:0x75
		case 0:
			upgradeClass = Class<Actor>(DynamicLoadObject("MegaHaloGameContent.HaloTurret_MachineGun_Content", Class'Core.Class'));
			// End:0xD6
			break;
		// End:0xD3
		case 1:
			upgradeClass = Class<Actor>(DynamicLoadObject("MegaHaloGameContent.HaloTurret_Mortar_Content", Class'Core.Class'));
			// End:0xD6
			break;
		// End:0xFFFF
		default:
			break;
	}
	// End:0x434
	if(upgradeClass != none)
	{
		// End:0x185
		if(HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none)
		{
			upgradeManager = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetUpgradeManager();
		}
		// End:0x434
		if(upgradeManager != none)
		{
			aIndex = 0;
			aUpgrade = upgradeManager.GetGlobalUpgrade(upgradeClass);
			// End:0x25B
			if((HaloPawn(TargetActor) != none) && HaloPlayerPawnController(HaloPawn(TargetActor).Controller) != none)
			{
				aController = HaloPlayerPawnController(HaloPawn(TargetActor).Controller);
			}
			// End:0x434
			if(((((aUpgrade != none) && aController != none) && aUpgrade.NextUpgrades.Length > aIndex) && aUpgrade.NextUpgrades[aIndex].BloksRequired > 0) && aController.BlokCollector.GetBankCount() >= aUpgrade.NextUpgrades[aIndex].BloksRequired)
			{
				aController.BlokCollector.RemoveFromBank(aUpgrade.NextUpgrades[aIndex].BloksRequired);
				upgradeManager.ApplyUpgradeToAll(upgradeClass, aUpgrade.NextUpgrades[aIndex]);
				isSuccess = true;
			}
		}
	}
	OutputLinks[0].bHasImpulse = isSuccess == true;
	OutputLinks[1].bHasImpulse = isSuccess == false;
	//return;	
}

defaultproperties
{
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="TargetActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Upgrade All"
}