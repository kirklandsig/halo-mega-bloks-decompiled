interface IHaloDeployable extends Interface
	abstract;

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	//return;	
}

function name GetDeployableName()
{
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	//return;	
}

function Actor GetDeployableBase()
{
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	//return;	
}

function Actor GetDeployable()
{
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	//return;	
}
