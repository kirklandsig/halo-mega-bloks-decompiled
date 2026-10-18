class HaloTargetableComponent_Destructible extends HaloTargetableComponent;

var HaloDestructibleActor Destructible;

simulated function PostBeginPlay()
{
	Destructible = HaloDestructibleActor(Owner);
	//return;	
}

simulated function bool IsDead()
{
	return Destructible.Health <= 0;
	//return ReturnValue;	
}

simulated function byte GetTeamNum()
{
	return Destructible.TeamNum;
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	return Destructible.MyNeedleTargetComponent;
	//return ReturnValue;	
}

simulated function SkeletalMeshComponent GetSkeletalMesh()
{
	return Destructible.SkeletalMeshComponent;
	//return ReturnValue;	
}
