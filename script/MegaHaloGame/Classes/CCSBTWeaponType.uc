class CCSBTWeaponType extends CCSBTScriptCondition;

var Class<Weapon> TargetWeaponClass;
var bool Negate;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local bool Result;
	local HaloPawn hPawn;

	hPawn = HaloPawn(Controller.Pawn);
	// End:0x73
	if((hPawn == none) || hPawn.Weapon == none)
	{
		return TargetWeaponClass == none;
	}
	Result = ClassIsChildOf(hPawn.Weapon.Class, TargetWeaponClass);
	// End:0xE1
	if(Negate)
	{
		Result = !Result;
	}
	return Result;
	//return ReturnValue;	
}

event string GetNodeTitle()
{
	local string NodeTitle;

	// End:0xA6
	if(NodeName == 'None')
	{
		NodeTitle = string(DefaultTitle);
		// End:0x55
		if(Negate)
		{			
			NodeTitle @= "!=";			
		}
		else
		{			
			NodeTitle @= "==";
		}		
		NodeTitle @= string(TargetWeaponClass.Name);		
	}
	else
	{
		NodeTitle = string(NodeName);
	}
	return NodeTitle;
	//return ReturnValue;	
}

defaultproperties
{
	NodeDescription="Returns true if the AI is using the selected weapon."
	DefaultTitle="Weapon Type"
}