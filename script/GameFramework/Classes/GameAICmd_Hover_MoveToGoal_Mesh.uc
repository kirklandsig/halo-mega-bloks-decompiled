class GameAICmd_Hover_MoveToGoal_Mesh extends GameAICommand within GameAIController;

var transient Actor Find;
var float Radius;
var transient bool bWasFiring;
var bool bFinalApproach;
var bool bFallbackMoveToMesh;
var float DesiredHoverHeight;
var transient float CurrentHoverHeight;
var float SubGoalReachDist;
var transient float GoalDistance;
var transient Vector IntermediatePoint;
var transient Vector LastMovePoint;
var transient int NumMovePointFails;
var int MaxMovePointFails;
var transient Vector FallbackDest;
var transient Actor MoveToActor;
var BasedPosition LastMoveTargetPathLocation;
var transient Vector InitialFinalDestination;

static function bool HoverToGoal(GameAIController AI, Actor InGoal, float InGoalDistance, float InHoverHeight)
{
	local GameAICmd_Hover_MoveToGoal_Mesh Cmd;

	// End:0x1AE
	if(((AI != none) && AI.Pawn != none) && AI.Pawn.bCanFly)
	{
		Cmd = new (AI) Class'GameFramework.GameAICmd_Hover_MoveToGoal_Mesh';
		// End:0x1AE
		if(Cmd != none)
		{
			Cmd.GoalDistance = InGoalDistance;
			Cmd.MoveToActor = InGoal;
			Cmd.InitialFinalDestination = InGoal.GetDestination(AI);
			Cmd.DesiredHoverHeight = InHoverHeight;
			Cmd.CurrentHoverHeight = InHoverHeight;
			AI.PushCommand(Cmd);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

static function bool HoverToPoint(GameAIController AI, Vector InPoint, float InGoalDistance, float InHoverHeight)
{
	local GameAICmd_Hover_MoveToGoal_Mesh Cmd;

	// End:0x187
	if(((AI != none) && AI.Pawn != none) && AI.Pawn.bCanFly)
	{
		Cmd = new (AI) Class'GameFramework.GameAICmd_Hover_MoveToGoal_Mesh';
		// End:0x187
		if(Cmd != none)
		{
			Cmd.GoalDistance = InGoalDistance;
			Cmd.MoveToActor = none;
			Cmd.InitialFinalDestination = InPoint;
			Cmd.DesiredHoverHeight = InHoverHeight;
			Cmd.CurrentHoverHeight = InHoverHeight;
			AI.PushCommand(Cmd);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

static function bool HoverBackToMesh(GameAIController AI)
{
	local GameAICmd_Hover_MoveToGoal_Mesh Cmd;

	// End:0xE8
	if(((AI != none) && AI.Pawn != none) && AI.Pawn.bCanFly)
	{
		Cmd = new (AI) Class'GameFramework.GameAICmd_Hover_MoveToGoal_Mesh';
		// End:0xE8
		if(Cmd != none)
		{
			Cmd.bFallbackMoveToMesh = true;
			AI.PushCommand(Cmd);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function Pushed()
{
	super.Pushed();
	// End:0x100
	if(bFallbackMoveToMesh)
	{
		// End:0xF0
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal("Going into breadcrumb fallback state to get back onto navmesh CurLoc:" @ string(Outer.Pawn.Location));
		}
		GotoState('Fallback_Breadcrumbs');
		return;
	}
	// End:0x21B
	if(Outer.NavigationHandle.ComputeValidFinalDestination(InitialFinalDestination)!)
	{
		// End:0x20A
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal(("ABORTING! Final destination" @ string(InitialFinalDestination)) @ "is not reachable! (ComputeValidFinalDestination returned FALSE)");
		}
		GotoState('DelayFailure');		
	}
	else
	{
		// End:0x32D
		if(Outer.NavigationHandle.SetFinalDestination(InitialFinalDestination)!)
		{
			// End:0x31C
			if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
			{
				Outer.AILog_Internal(("ABORTING! Final destination" @ string(InitialFinalDestination)) @ "is not reachable! (SetFinalDestination returned FALSE)");
			}
			GotoState('DelayFailure');			
		}
		else
		{
			GotoState('Moving');
		}
	}
	//return;	
}

function Popped()
{
	super.Popped();
	Outer.ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', Status != 'Success');
	Outer.NavigationHandle.PathCache_Empty();
	// End:0x10C
	if(Outer.Pawn != none)
	{
		Outer.Pawn.ZeroMovementVariables();
		Outer.Pawn.DestinationOffset = 0.0000000;
	}
	Outer.ReachedMoveGoal();
	//return;	
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	// End:0x87
	if(ShouldUpdateBreadCrumbs())
	{
		Outer.NavigationHandle.UpdateBreadCrumbs(Outer.Pawn.Location);
	}
	Outer.NavigationHandle.DrawBreadCrumbs();
	//return;	
}

function bool HandlePathObstruction(Actor BlockedBy)
{
	Outer.MoveTimer = -1.0000000;
	GotoState('Fallback_Breadcrumbs');
	return false;
	//return ReturnValue;	
}

function ReEvaluatePath()
{
	//return;	
}

function bool HasReachedGoal()
{
	// End:0x26
	if(Outer.Pawn == none)
	{
		return true;
	}
	// End:0xA8
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal((string(GetFuncName()) @ string(bFinalApproach)) @ string(MoveToActor));
	}
	// End:0x104
	if(bFinalApproach && MoveToActor != none)
	{
		return Outer.Pawn.ReachedDestination(MoveToActor);
	}
	// End:0x289
	if(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination) != vect(0.0000000, 0.0000000, 0.0000000))
	{
		// End:0x201
		if(VSize(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination) - Outer.Pawn.Location) < GoalDistance)
		{
			return true;
		}
		return Outer.Pawn.ReachedPoint(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination), none);
	}
	return false;
	//return ReturnValue;	
}

function bool ShouldUpdateBreadCrumbs()
{
	return true;
	//return ReturnValue;	
}

function bool IsEnemyBasedOnInterpActor(Pawn InEnemy)
{
	return false;
	//return ReturnValue;	
}

event DrawDebug(HUD H, name Category)
{
	super.DrawDebug(H, Category);
	// End:0x35
	if(Category != 'Pathing')
	{
		return;
	}
	Outer.DrawDebugLine(Outer.Pawn.Location, Outer.GetDestinationPosition(), 0, 0, 255);
	Outer.DrawDebugLine(Outer.Pawn.Location, Outer.BP2Vect(Outer.NavigationHandle.FinalDestination), 0, 255, 0);
	Outer.NavigationHandle.DrawPathCache(vect(0.0000000, 0.0000000, 15.0000000));
	//return;	
}

state DelayFailure
{
	ignores HandlePathObstruction;
Begin:

	Outer.Sleep(0.5000000);
	Status = 'Failure';
	Outer.PopCommand(self);
	stop;				
}

state MoveDown extends DebugState
{
	function Vector GetMoveDest()
	{
		local Vector HitLocation, HitNormal, Dest;
		local Actor HitActor;

		// End:0x251
		if(Outer.NavigationHandle.LineCheck(Outer.Pawn.Location, Outer.Pawn.Location + vect(0.0000000, 0.0000000, -4096.0000000), vect(5.0000000, 5.0000000, 5.0000000), HitLocation, HitNormal))
		{
			HitActor = Outer.Trace(HitLocation, HitNormal, Outer.Pawn.Location + vect(0.0000000, 0.0000000, -4096.0000000), Outer.Pawn.Location);
			// End:0x251
			if(HitActor == none)
			{
				// End:0x21D
				if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
				{
					Outer.AILog_Internal(string(GetFuncName()) @ "Could not find surface to adjust height to!");
				}
				return Outer.Pawn.Location;
			}
		}
		Dest = HitLocation;
		Dest.Z += (Outer.Pawn.GetCollisionHeight() * 1.5000000);
		return Dest;
		//return ReturnValue;		
	}
Begin:

	// End:0x69
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("Moving down!");
	}
	Outer.MoveTo(GetMoveDest());
	Outer.Sleep(1.0000000);
	GotoState('Moving');
	stop;			
}

state Moving extends DebugState
{
	final function float GetMoveDestinationOffset()
	{
		// End:0x1A
		if(bFinalApproach)
		{
			return GoalDistance;			
		}
		else
		{
			return SubGoalReachDist - Outer.Pawn.GetCollisionRadius();
		}
		//return ReturnValue;		
	}
CheckMove:

	// End:0x6A
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("CHECKMOVE TAG");
	}
	// End:0x81
	if(HasReachedGoal())
	{
		goto 'ReachedGoal';
	}
Begin:


	// End:0xEE
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("BEGIN TAG" @ string(GetStateName()));
	}
	// End:0x186
	if(Outer.Enemy != none)
	{
		Radius = Outer.Pawn.GetCollisionRadius() + Outer.Enemy.GetCollisionRadius();
	}
	Radius = FMax(Radius, GoalDistance);
	Outer.NavigationHandle.SetFinalDestination(InitialFinalDestination);
	// End:0x2CB
	if(Outer.NavigationHandle.PointReachable(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination)))
	{
		IntermediatePoint = Outer.BP2Vect(Outer.NavigationHandle.FinalDestination);		
	}
	else
	{
		// End:0x404
		if(MoveToActor != none)
		{
			// End:0x404
			if(Outer.NavigationHandle.SetFinalDestination(MoveToActor.GetDestination(Outer))!)
			{
				// End:0x3FA
				if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
				{
					Outer.AILog_Internal(("ABORTING! Final destination" @ string(InitialFinalDestination)) @ "is not reachable! (SetFinalDestination returned FALSE)");
				}
				goto 'FailedMove';
			}
		}
		// End:0x5A6
		if(Outer.GeneratePathToLocation(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination), GoalDistance, true)!)
		{
			// End:0x598
			if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
			{
				Outer.AILog_Internal((("Couldn't generate path to location" @ string(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination))) @ "from") @ string(Outer.Pawn.Location));
			}
			GotoState('Fallback_Breadcrumbs');
		}
		// End:0x614
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal("Generated path...");
		}
		// End:0x70F
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal((("Found path!" @ "BP2Vect(NavigationHandle.FinalDestination):'") $ string(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination))) $ "'", 'Move');
		}
		// End:0x7FA
		if(Outer.NavigationHandle.GetNextMoveLocation(IntermediatePoint, SubGoalReachDist)!)
		{
			// End:0x7F0
			if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
			{
				Outer.AILog_Internal("Generated path, but couldn't retrieve next move location?");
			}
			goto 'FailedMove';
		}
	}
	// End:0x85A
	if(MoveToActor != none)
	{
		Outer.Vect2BP(LastMoveTargetPathLocation, MoveToActor.GetDestination(Outer));
	}
	J0x85A:

	// End:0x14EB [Loop If]
	if(true)
	{
		// End:0x8DF
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal("Still moving to" @ string(IntermediatePoint), 'Loop');
		}
		bFinalApproach = VSizeSq(IntermediatePoint - Outer.BP2Vect(Outer.NavigationHandle.FinalDestination)) < 1.0000000;
		// End:0x9CC
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal("Calling MoveTo -- " @ string(IntermediatePoint));
		}
		// End:0xB7B
		if(bFinalApproach && MoveToActor != none)
		{
			// End:0xA80
			if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
			{
				Outer.AILog_Internal((" - Final approach to" @ string(MoveToActor)) $ ", using MoveToward()");
			}
			Outer.Vect2BP(LastMoveTargetPathLocation, MoveToActor.GetDestination(Outer));
			Outer.NavigationHandle.SetFinalDestination(MoveToActor.GetDestination(Outer));
			Outer.MoveToward(MoveToActor, Outer.Enemy, GetMoveDestinationOffset(), false);			
		}
		else
		{
			// End:0xBC8
			if(Outer.Enemy == none)
			{
				Outer.SetFocalPoint(IntermediatePoint);
			}
			Outer.MoveTo(IntermediatePoint, Outer.Enemy, GetMoveDestinationOffset());
		}
		// End:0xC8F
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal("MoveTo Finished -- " @ string(IntermediatePoint));
		}
		// End:0xCA9
		if(HasReachedGoal())
		{
			goto 'CheckMove';			
		}
		else
		{
			// End:0xDFF
			if((MoveToActor != none) && VSize(MoveToActor.GetDestination(Outer) - Outer.BP2Vect(LastMoveTargetPathLocation)) > 512.0000000)
			{
				Outer.Vect2BP(LastMoveTargetPathLocation, MoveToActor.GetDestination(Outer));
				// End:0xDF2
				if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
				{
					Outer.AILog_Internal("Repathing because target moved:" @ string(MoveToActor));
				}
				goto 'CheckMove';				
			}
			else
			{
				// End:0x1196
				if(Outer.NavigationHandle.GetNextMoveLocation(IntermediatePoint, SubGoalReachDist)!)
				{
					// End:0xEC6
					if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
					{
						Outer.AILog_Internal("Couldn't get next move location");
					}
					// End:0x10C4
					if(bFinalApproach! && ((MoveToActor != none) ? Outer.ActorReachable(MoveToActor) : Outer.PointReachable(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination))))
					{
						// End:0x1000
						if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
						{
							Outer.AILog_Internal("Target is directly reachable; try direct move");
						}
						IntermediatePoint = ((MoveToActor != none) ? MoveToActor.GetDestination(Outer) : Outer.BP2Vect(Outer.NavigationHandle.FinalDestination));
						Outer.Sleep(RandRange(0.1000000, 0.1750000));						
					}
					else
					{
						Outer.Sleep(0.1000000);
						// End:0x1189
						if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
						{
							Outer.AILog_Internal("GetNextMoveLocation returned false, and finaldest is not directly reachable");
						}
						goto 'FailedMove';
					}					
				}
				else
				{
					// End:0x1348
					if(VSize(IntermediatePoint - LastMovePoint) < (Outer.Pawn.GetCollisionRadius() * 0.1000000))
					{
						NumMovePointFails++;
						// End:0x1345
						if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
						{
							Outer.AILog_Internal(((((((((("WARNING: Got same move location... something's wrong?!" @ "LastMovePoint:'") $ string(LastMovePoint)) $ "'") @ "IntermediatePoint:'") $ string(IntermediatePoint)) $ "'") @ "Delta") @ string(VSize(LastMovePoint - IntermediatePoint))) @ "ChkDist") @ string(Outer.Pawn.GetCollisionRadius() * 0.1000000));
						}						
					}
					else
					{
						NumMovePointFails = 0;
					}
					LastMovePoint = IntermediatePoint;
					// End:0x144D
					if((NumMovePointFails >= MaxMovePointFails) && MaxMovePointFails >= 0)
					{
						// End:0x1440
						if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
						{
							Outer.AILog_Internal("ERROR: Got same move location 5x in a row.. something's wrong! bailing from this move");
						}
						goto 'FailedMove';						
					}
					else
					{
						// End:0x14E8
						if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
						{
							Outer.AILog_Internal(((("NextMove" @ string(IntermediatePoint)) @ "NumMovePointFails:'") $ string(NumMovePointFails)) $ "'");
						}
					}
				}
			}
		}
		// [Loop Continue]
		goto J0x85A;
	}
	// End:0x1562
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("Reached end of move loop??");
	}
	goto 'CheckMove';
FailedMove:


	// End:0x15F0
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("Failed move.  Now ZeroMovementVariables");
	}
	Outer.MoveTo(Outer.Pawn.Location);
	Outer.Pawn.ZeroMovementVariables();
	GotoState('DelayFailure');
ReachedGoal:


	// End:0x17D3
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal(("Reached move point:" @ string(Outer.BP2Vect(Outer.NavigationHandle.FinalDestination))) @ string(VSize(Outer.Pawn.Location - Outer.BP2Vect(Outer.NavigationHandle.FinalDestination))));
	}
	Status = 'Success';
	Outer.PopCommand(self);
	stop;		
}

state Fallback_Breadcrumbs extends DebugState
{
	function bool ShouldUpdateBreadCrumbs()
	{
		return false;
		//return ReturnValue;		
	}

	function bool HandlePathObstruction(Actor BlockedBy)
	{
		Outer.Pawn.SetLocation(IntermediatePoint);
		Outer.MoveTimer = -1.0000000;
		GotoState('Fallback_Breadcrumbs', 'Begin');
		return true;
		//return ReturnValue;		
	}
Begin:

	// End:0x86
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("trying to move back along breadcrumb path");
	}
	// End:0x1E5
	if(Outer.NavigationHandle.GetNextBreadCrumb(IntermediatePoint))
	{
		// End:0x149
		if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
		{
			Outer.AILog_Internal("Moving to breadcrumb pos:" $ string(IntermediatePoint));
		}
		Outer.MoveToDirectNonPathPos(IntermediatePoint);
		// End:0x1BB
		if(Outer.NavigationHandle.IsAnchorInescapable()!)
		{
			GotoState('Moving');
		}
		Outer.Sleep(0.1000000);
		goto 'Begin';		
	}
	else
	{
		// End:0x237
		if(Outer.NavigationHandle.IsAnchorInescapable()!)
		{
			GotoState('Moving', 'Begin');			
		}
		else
		{
			GotoState('Fallback_FindNearbyMeshPoint');
		}
	}
	stop;			
}

state Fallback_FindNearbyMeshPoint extends DebugState
{
	function bool FindAPointWhereICanHoverTo(out Vector out_FallbackDest, float Inradius, optional float MinRadius = 0.0000000, optional float entityRadius = 32.0000000, optional bool bDirectOnly = true, optional int MaxPoints = -1, optional float ValidHitBoxSize)
	{
		local Vector Retval;
		local array<Vector> poses;
		local Vector Extent, validhitbox;

		Extent.X = entityRadius;
		Extent.Y = entityRadius;
		Extent.Z = entityRadius;
		validhitbox = vect(1.0000000, 1.0000000, 1.0000000) * ValidHitBoxSize;
		Outer.NavigationHandle.GetValidPositionsForBox(Outer.Pawn.Location, Inradius, Extent, bDirectOnly, poses, MaxPoints, MinRadius, validhitbox);
		// End:0x246
		if(poses.Length > 0)
		{
			Retval = poses[Rand(poses.Length)];
			// End:0x1BA
			if(VSize(Retval) == 0.0000000)
			{
				out_FallbackDest = vect(0.0000000, 0.0000000, 0.0000000);
				return false;
			}
			// End:0x231
			if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
			{
				Outer.AILog_Internal(("Retval:'" $ string(Retval)) $ "'");
			}
			out_FallbackDest = Retval;
			return true;
		}
		out_FallbackDest = vect(0.0000000, 0.0000000, 0.0000000);
		return false;
		//return ReturnValue;		
	}

	function bool ShouldUpdateBreadCrumbs()
	{
		return false;
		//return ReturnValue;		
	}
Begin:

	// End:0xA0
	if(Class'Engine.Engine'.static.GetEngine().bDisableAILogging!)
	{
		Outer.AILog_Internal("Fallback! We now try MoveTo directly to a point that is avail to us");
	}
	// End:0xD3
	if(FindAPointWhereICanHoverTo(FallbackDest, 2048.0000000)!)
	{
		GotoState('MoveDown');		
	}
	else
	{
		Outer.MoveToDirectNonPathPos(FallbackDest,, SubGoalReachDist);
		Outer.Sleep(0.5000000);
		// End:0x141
		if(bFallbackMoveToMesh)
		{
			GotoState('DelaySuccess');			
		}
		else
		{
			GotoState('Moving', 'Begin');
		}
	}
	stop;					
}

defaultproperties
{
	SubGoalReachDist=128.0000000
	MaxMovePointFails=5
}