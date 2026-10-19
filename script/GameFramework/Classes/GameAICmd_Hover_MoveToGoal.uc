class GameAICmd_Hover_MoveToGoal extends GameAICommand within GameAIController;

var transient Actor Path;
var transient Actor Find;
var transient Actor Goal;
var float Radius;
var transient bool bWasFiring;
var float DesiredHoverHeight;
var transient float CurrentHoverHeight;
var float SubGoalReachDist;
var float GoalDistance;
var transient Vector MoveVectDest;
var transient ReachSpec CurrentSpec;

static function bool MoveToGoal(GameAIController AI, Actor InGoal, float InGoalDistance, float InHoverHeight)
{
	local GameAICmd_Hover_MoveToGoal Cmd;

	// End:0x167
	if(((AI != none) && AI.Pawn != none) && AI.Pawn.bCanFly)
	{
		Cmd = new (AI) Class'GameFramework.GameAICmd_Hover_MoveToGoal';
		// End:0x167
		if(Cmd != none)
		{
			Cmd.GoalDistance = InGoalDistance;
			Cmd.Goal = InGoal;
			Cmd.DesiredHoverHeight = InHoverHeight;
			Cmd.CurrentHoverHeight = InHoverHeight;
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
	GotoState('Moving');
	//return;	
}

function bool HandlePathObstruction(Actor BlockedBy)
{
	Outer.MoveTimer = -1.0000000;
	GotoState('MoveDown');
	return false;
	//return ReturnValue;	
}

function bool IsEnemyBasedOnInterpActor(Pawn InEnemy)
{
	return false;
	//return ReturnValue;	
}

state MoveDown extends DebugState
{
	function Vector GetMoveDest()
	{
		local float Height, RadRad;
		local NavigationPoint PtForHeight;
		local Vector Dest, HitLocation, HitNormal;
		local Actor HitActor;

		// End:0x79
		if(Outer.Pawn.Anchor != none)
		{
			PtForHeight = Outer.Pawn.Anchor;			
		}
		else
		{
			// End:0xF0
			if((Outer.RouteCache.Length > 0) && Outer.RouteCache[0] != none)
			{
				PtForHeight = Outer.RouteCache[0];
			}
		}
		// End:0x20B
		if(PtForHeight != none)
		{
			PtForHeight.GetBoundingCylinder(RadRad, Height);
			CurrentHoverHeight = float(Max(0, int(Height - (Outer.Pawn.GetCollisionHeight() * 0.5000000))));
			Dest = PtForHeight.Location;
			Dest.Z = PtForHeight.Location.Z + CurrentHoverHeight;			
		}
		else
		{
			HitActor = Outer.Trace(HitLocation, HitNormal, Outer.Pawn.Location + vect(0.0000000, 0.0000000, -4096.0000000), Outer.Pawn.Location);
			// End:0x336
			if(HitActor != none)
			{
				Dest = HitLocation;
				Dest.Z += (Outer.Pawn.GetCollisionHeight() * 1.5000000);				
			}
			else
			{
				// End:0x3C2
				if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
				{
					Outer.AILog_Internal(string(GetFuncName()) @ "Could not find good hover height!");
				}
				Dest = Outer.Pawn.Location;
			}
		}
		return Dest;
		//return ReturnValue;		
	}
Begin:

	Outer.MoveTo(GetMoveDest());
	Outer.Sleep(1.0000000);
	GotoState('Moving');
	stop;				
}

state Moving extends DebugState
{
	final function bool ReachedDest(Actor Dest)
	{
		local float latDistSq, VertDist;

		latDistSq = VSizeSq2D(Outer.Pawn.Location - Dest.Location);
		// End:0xDB
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("LatDist:" @ string(Sqrt(latDistSq)));
		}
		// End:0x25B
		if(latDistSq < (SubGoalReachDist * SubGoalReachDist))
		{
			VertDist = Abs(Outer.Pawn.Location.Z - Dest.Location.Z);
			// End:0x1F5
			if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
			{
				Outer.AILog_Internal("VertDist:" @ string(VertDist));
			}
			// End:0x25B
			if(VertDist < float(Max(int(SubGoalReachDist), int(CurrentHoverHeight + (Outer.Pawn.GetCollisionHeight() * float(2))))))
			{
				return true;
			}
		}
		return false;
		//return ReturnValue;		
	}

	protected final function bool PopNextNode(out Vector Dest)
	{
		J0x00:
		// End:0x2DA [Loop If]
		if((Outer.RouteCache.Length > 0) && Outer.RouteCache[0] != none)
		{
			// End:0x237
			if(ReachedDest(Outer.RouteCache[0]))
			{
				// End:0x111
				if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
				{
					Outer.AILog_Internal("Reached route cache 0:" @ string(Outer.RouteCache[0]));
				}
				Outer.Pawn.SetAnchor(Outer.RouteCache[0]);
				// End:0x200
				if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
				{
					Outer.AILog_Internal("Remove from route:" @ string(Outer.RouteCache[0]), 'Move');
				}
				Outer.RouteCache_RemoveIndex(0);
				CurrentHoverHeight = DesiredHoverHeight;				
			}
			else
			{
				// End:0x2D4
				if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
				{
					Outer.AILog_Internal("Did NOT reach route cache 0:" @ string(Outer.RouteCache[0]));
				}
				// [Explicit Break]
				goto J0x2DA;
			}
			// [Loop Continue]
			goto J0x00;
		}
		J0x2DA:

		// End:0x301
		if(Outer.RouteCache.Length < 1)
		{
			return false;
		}
		CurrentSpec = Outer.Pawn.Anchor.GetReachSpecTo(Outer.RouteCache[0]);
		Dest = Outer.RouteCache[0].Location;
		return true;
		//return ReturnValue;		
	}
Begin:

	// End:0x6D
	if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
	{
		Outer.AILog_Internal("BEGIN TAG" @ string(GetStateName()));
	}
	Find = Goal;
	Radius = Outer.Pawn.GetCollisionRadius() + Outer.Enemy.GetCollisionRadius();
	// End:0x16E
	if((IsEnemyBasedOnInterpActor(Outer.Enemy)) == true)
	{
		Find = Outer.Enemy.Base;
		Radius = 0.0000000;
	}
	Radius = FMax(Radius, GoalDistance);
	// End:0x2C0
	if(Outer.ActorReachable(Find))
	{
		MoveVectDest = Find.Location;
		MoveVectDest.Z += CurrentHoverHeight;
		// End:0x27C
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("Moving directly to " $ string(Find));
		}
		Outer.MoveTo(MoveVectDest, Outer.Enemy);		
	}
	GotoState('DelaySuccess');
	stop;		
}

defaultproperties
{
	SubGoalReachDist=768.0000000
}