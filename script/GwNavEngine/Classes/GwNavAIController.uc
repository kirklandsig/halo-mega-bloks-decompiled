class GwNavAIController extends AIController
	native;

function MoveToPosition(Vector vTargetPosition)
{
	local GwNavPawn navPawn;

	navPawn = GwNavPawn(Pawn);
	navPawn.MoveToPosition(vTargetPosition);
	// End:0x6A
	if(IsInState('Walk')!)
	{
		PushState('Walk');
	}
	//return;	
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
	local Actor destActor;
	local SeqVar_Object ObjVar;

	ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true, Action);
	destActor = Action.PickDestination(Pawn);
	// End:0x117
	if(destActor != none)
	{
		MoveToPosition(destActor.Location);
		ScriptedFocus = none;
		// End:0x113
		foreach Action.LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Look At")
		{
			ScriptedFocus = Actor(ObjVar.GetObjectValue());
			// End:0x112
			if(ScriptedFocus != none)
			{
				// End:0x113
				break;
			}			
		}				
	}
	else
	{
		WarnInternal("Invalid destination for scripted move");
	}
	//return;	
}

state Walk
{
	event PushedState()
	{
		// End:0x53
		if(int(Physics) == int(2))
		{
			ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true);
			Pawn.ZeroMovementVariables();
			PopState();
		}
		//return;		
	}

	event PoppedState()
	{
		ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', false);
		Pawn.ZeroMovementVariables();
		//return;		
	}

	event Tick(float DeltaTime)
	{
		local GwNavPawn navPawn;

		navPawn = GwNavPawn(Pawn);
		// End:0x49
		if(navPawn.IsArrived())
		{
			PopState();
		}
		//return;		
	}
	stop;	
}
