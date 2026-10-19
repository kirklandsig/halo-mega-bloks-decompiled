class HaloDeploymentMonitor extends Object;

struct DeployableInfo
{
	var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
	var name DeployableName;
	var array< Class<HaloVCustomizationComponent> > OptionalCustomizations;
	var Actor Location;
	var bool bRequiresLocation;
	var bool bLocationIsBase;

	structdefaultproperties
	{
		DeployableCategory=TDC_None
		DeployableName="None"
		OptionalCustomizations=none
		Location=none
		bRequiresLocation=false
		bLocationIsBase=false
	}
};

var DeployableInfo DeployableItem;
var bool bHasBeenDeployed;
var SeqAct_WaitForDeployable ParentSeq;
var HaloObjective_DeployItem ParentObj;

function bool NotifyOfDeployment(IHaloDeployable deployable)
{
	// End:0xA3
	if(bHasBeenDeployed == false)
	{
		// End:0xA3
		if(NotEqual_InterfaceInterface(deployable, IHaloDeployable(none)))
		{
			// End:0xA3
			if((IsGoodDeploy(deployable)) == true)
			{
				bHasBeenDeployed = true;
				// End:0xA3
				if(ParentSeq != none)
				{
					ParentSeq.HasBeenDeployed(deployable.GetDeployable());
				}
			}
		}
	}
	return bHasBeenDeployed;
	//return ReturnValue;	
}

function bool IsGoodDeploy(IHaloDeployable DeployedItem)
{
	local bool bCheckLocation, bIsGoodDeploy, bCurrentCustomizationFound;
	local array< Class<HaloVCustomizationComponent> > DeployedCustomizations;
	local int DeployableCustomizationIdx, DeployedCustomizationIdx;

	bCheckLocation = false;
	bIsGoodDeploy = false;
	// End:0x8F
	if(int(DeployableItem.DeployableCategory) == int(0))
	{
		// End:0x8C
		if(DeployableItem.DeployableName == DeployedItem.GetDeployableName())
		{
			bCheckLocation = true;
		}		
	}
	else
	{
		// End:0xE0
		if(int(DeployableItem.DeployableCategory) == int(DeployedItem.GetDeployableCategory()))
		{
			bCheckLocation = true;
		}
	}
	// End:0x1F7
	if(bCheckLocation)
	{
		// End:0x1EB
		if(DeployableItem.bRequiresLocation)
		{
			// End:0x17D
			if(DeployableItem.bLocationIsBase)
			{
				// End:0x17A
				if(DeployableItem.Location == DeployedItem.GetDeployableBase())
				{
					bIsGoodDeploy = true;
				}				
			}
			else
			{
				// End:0x1E8
				if(DeployableItem.Location.Touching.Find(DeployedItem.GetDeployable()) != -1)
				{
					bIsGoodDeploy = true;
				}
			}			
		}
		else
		{
			bIsGoodDeploy = true;
		}
	}
	// End:0x35E
	if(bIsGoodDeploy && DeployableItem.OptionalCustomizations.Length > 0)
	{
		DeployedCustomizations = DeployedItem.GetCustomizations();
		// End:0x352
		if(DeployedCustomizations.Length > 0)
		{
			DeployableCustomizationIdx = 0;
			J0x26E:

			// End:0x34F [Loop If]
			if(DeployableCustomizationIdx < DeployableItem.OptionalCustomizations.Length)
			{
				bCurrentCustomizationFound = false;
				DeployedCustomizationIdx = 0;
				J0x2B0:

				// End:0x323 [Loop If]
				if(DeployedCustomizationIdx < DeployedCustomizations.Length)
				{
					// End:0x315
					if(DeployedCustomizations[DeployedCustomizationIdx] == DeployableItem.OptionalCustomizations[DeployableCustomizationIdx])
					{
						bCurrentCustomizationFound = true;
						// [Explicit Break]
						goto J0x323;
					}
					DeployedCustomizationIdx++;
					// [Loop Continue]
					goto J0x2B0;
				}
				J0x323:

				// End:0x341
				if(!bCurrentCustomizationFound)
				{
					bIsGoodDeploy = false;
					// [Explicit Break]
					goto J0x34F;
				}
				DeployableCustomizationIdx++;
				// [Loop Continue]
				goto J0x26E;
			}
			J0x34F:
			
		}
		else
		{
			bIsGoodDeploy = false;
		}
	}
	return bIsGoodDeploy;
	//return ReturnValue;	
}
