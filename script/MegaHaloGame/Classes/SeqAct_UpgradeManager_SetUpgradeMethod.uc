class SeqAct_UpgradeManager_SetUpgradeMethod extends SequenceAction;

event Activated()
{
	local HaloUpgradeManager upgradeManager;

	// End:0xA0
	if(HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none)
	{
		upgradeManager = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetUpgradeManager();
	}
	// End:0x16D
	if(upgradeManager != none)
	{
		upgradeManager.bAllowXPBasedUpgrades = InputLinks[0].bHasImpulse;
		upgradeManager.bAllowActionableUpgrades = InputLinks[1].bHasImpulse;
		upgradeManager.bAllowGlobalUpgrades = InputLinks[2].bHasImpulse;
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	InputLinks[0]=(LinkDesc="Allow XP",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Allow Individual",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[2]=(LinkDesc="Allow Global",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks=none
	ObjName="Set Upgrade Method"
}