class HaloTargetableComponent_Pawn extends HaloTargetableComponent;

var HaloPawn Pawn;

simulated function PostBeginPlay()
{
	Pawn = HaloPawn(Owner);
	//return;	
}

simulated function bool IsDead()
{
	return Pawn.Health <= 0;
	//return ReturnValue;	
}

simulated function byte GetTeamNum()
{
	return Pawn.TeamNum;
	//return ReturnValue;	
}

simulated function Vector GetAimLocation(Vector FromLoc)
{
	local int I;
	local Vector testLoc, BestLoc;
	local float testDistSq, BestDistSq;

	// End:0x1B4
	if(Pawn.TargetNodes.Length > 0)
	{
		BestDistSq = 1000000000.0000000;
		I = 0;
		J0x3F:

		// End:0x1AA [Loop If]
		if(I < Pawn.TargetNodes.Length)
		{
			// End:0x13F
			if(!Pawn.Mesh.GetSocketWorldLocationAndRotation(Pawn.TargetNodes[I], testLoc))
			{
				testLoc = Pawn.Mesh.GetBoneLocation(Pawn.TargetNodes[I]);
			}
			testDistSq = VSizeSq(testLoc - FromLoc);
			// End:0x19C
			if(testDistSq < BestDistSq)
			{
				BestLoc = testLoc;
				BestDistSq = testDistSq;
			}
			++I;
			// [Loop Continue]
			goto J0x3F;
		}
		return BestLoc;
	}
	return super.GetAimLocation(FromLoc);
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	return Pawn.NeedleTargetComponent;
	//return ReturnValue;	
}

simulated function SkeletalMeshComponent GetSkeletalMesh()
{
	return Pawn.Mesh;
	//return ReturnValue;	
}
