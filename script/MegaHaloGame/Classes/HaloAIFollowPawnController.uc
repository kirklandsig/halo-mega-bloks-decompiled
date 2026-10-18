class HaloAIFollowPawnController extends AIController;

var float FollowDistance;
var float FollowDistanceMax;
var float FollowDistanceMin;
var Pawn FollowPawn;

event Possess(Pawn the_pawn, bool is_vehicle_transition)
{
	super(Controller).Possess(the_pawn, is_vehicle_transition);
	the_pawn.SetMovementPhysics();
	//return;	
}

function PostBeginPlay()
{
	super(Controller).PostBeginPlay();
	FollowDistance = (FRand() * (FollowDistanceMax - FollowDistanceMin)) + FollowDistanceMin;
	//return;	
}

auto state Idle
{
	event SeePlayer(Pawn the_player)
	{
		super(Controller).SeePlayer(the_player);
		// End:0x43
		if(the_player != none)
		{
			FollowPawn = the_player;
			GotoState('Following');
		}
		//return;		
	}
Begin:

	stop;				
}

state Following
{Begin:

	MoveToward(FollowPawn, FollowPawn, FollowDistance);
	goto 'Begin';
	stop;		
}

defaultproperties
{
	FollowDistanceMax=900.0000000
	FollowDistanceMin=300.0000000
}