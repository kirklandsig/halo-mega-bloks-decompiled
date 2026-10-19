class CCSBTSimpleFlee extends CCSBTScriptBehavior;

var float FleeDistance;
var Vector CachedEnemyPosition;
var Vector CachedPawnPosition;
var bool CachedResult;
var float CachedMaxDist2D;
var CCSAFMoveTo MoveToHandle;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagTargetsAsUsed();
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	local Pawn Enemy;

	Enemy = GetEnemy(BTInterface.Blackboard);
	// End:0x43
	if(Enemy == none)
	{
		return false;
	}
	// End:0xE7
	if((VSize2D(Controller.Pawn.Location - CachedPawnPosition) < CachedMaxDist2D) && VSize2D(Enemy.Location - CachedEnemyPosition) < CachedMaxDist2D)
	{
		return CachedResult;
	}
	return true;
	//return ReturnValue;	
}

event bool ExecutePre(GripBTInterface BTInterface)
{
	local Pawn Enemy;
	local Vector TargetPosition;

	Enemy = GetEnemy(BTInterface.Blackboard);
	CachedResult = PickFleePoint(Enemy.Location, TargetPosition);
	CachedPawnPosition = Controller.Pawn.Location;
	CachedEnemyPosition = Enemy.Location;
	// End:0xE4
	if(!CachedResult)
	{
		return false;
	}
	MoveToHandle = new Class'UDKBase.CCSAFMoveTo';
	MoveToHandle.Target = TargetPosition;
	MoveToHandle.MovementType = 2;
	return BTInterface.ActionFramework.Execute(MoveToHandle);
	//return ReturnValue;	
}

event GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripAFActionHandle.GripAFActionStatus Status;

	// End:0x10
	if(PushToFinish)
	{
		return 4;
	}
	Status = BTInterface.ActionFramework.GetStatus(MoveToHandle);
	// End:0x71
	if(int(Status) == int(0))
	{
		return 0;		
	}
	else
	{
		// End:0x88
		if(int(Status) == int(1))
		{
			return 1;
		}
	}
	return 2;
	//return ReturnValue;	
}

function bool PickFleePoint(Vector EnemyLocation, out Vector FleePoint)
{
	local Rotator Dir, FleeDir;
	local Vector FleePoints[5];
	local int I, factor, increment;

	Dir = Rotator(Controller.Pawn.Location - EnemyLocation);
	Dir.Pitch = 0;
	increment = 5462;
	I = 0;
	J0x82:

	// End:0x18D [Loop If]
	if(I < 5)
	{
		factor = 0;
		// End:0xC6
		if(I != 0)
		{
			factor = (I + 1) / 2;
		}
		FleeDir = Dir;
		FleeDir.Yaw += (increment * factor);
		FleePoints[I] = Controller.Pawn.Location + (Vector(FleeDir) * FleeDistance);
		increment = -increment;
		I++;
		// [Loop Continue]
		goto J0x82;
	}
	I = 0;
	J0x198:

	// End:0x1F5 [Loop If]
	if(I < 5)
	{
		// End:0x1E7
		if(ValidateFleePoint(FleePoints[I]))
		{
			FleePoint = FleePoints[I];
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x198;
	}
	return false;
	//return ReturnValue;	
}

function bool ValidateFleePoint(out Vector FleePoint)
{
	local array<Vector> ValidPositions;
	local float CollisionRadius, CollisionHeight;
	local Vector Extent;

	Controller.Pawn.GetBoundingCylinder(CollisionRadius, CollisionHeight);
	Extent.X = CollisionRadius;
	Extent.Y = CollisionRadius;
	Extent.Z = CollisionHeight;
	Controller.NavigationHandle.GetValidPositionsForBox(FleePoint, CollisionRadius * 4.0000000, Extent, false, ValidPositions, 1);
	// End:0x12D
	if(ValidPositions.Length == 0)
	{
		return false;
	}
	FleePoint = ValidPositions[0];
	// End:0x189
	if(Controller.NavigationHandle.PointReachable(FleePoint))
	{
		return true;		
	}
	else
	{
		// End:0x1B6
		if(Controller.FindNavMeshPath(FleePoint))
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function Pawn GetEnemy(GripBlackboard BB)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(BB);
	// End:0x2D
	if(CCSBB == none)
	{
		return none;
	}
	return CCSBB.GetCurrentTarget().Pawn;
	//return ReturnValue;	
}

defaultproperties
{
	FleeDistance=1000.0000000
	CachedResult=true
	CachedMaxDist2D=20.0000000
	NodeDescription="Flee away from current target. Support only UE3 navigation."
	DefaultTitle="Simple Flee"
}