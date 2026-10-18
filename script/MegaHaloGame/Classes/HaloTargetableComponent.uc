class HaloTargetableComponent extends ActorComponent;

simulated function bool IsDead()
{
	return false;
	//return ReturnValue;	
}

simulated function byte GetTeamNum()
{
	return 0;
	//return ReturnValue;	
}

simulated function Vector GetAimLocation(Vector FromLoc)
{
	// End:0x6B
	if(Owner.CollisionComponent != none)
	{
		return Owner.CollisionComponent.Bounds.Origin;
	}
	return Owner.Location;
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	return none;
	//return ReturnValue;	
}

simulated function SkeletalMeshComponent GetSkeletalMesh()
{
	return none;
	//return ReturnValue;	
}
