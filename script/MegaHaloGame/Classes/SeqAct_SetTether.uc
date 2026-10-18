class SeqAct_SetTether extends SequenceAction;

var float TetherDistance;
var array<Actor> Actors;
var Actor TetherActor;

event Activated()
{
	local Actor ActorItem;
	local HaloAIPawn haiPawn;
	local Controller Controller;
	local CCSController CCSController;
	local HaloPlayerPawnController PlayerController;
	local CCSBlackboard CCSBB;

	// End:0x226
	foreach Actors(ActorItem)
	{
		haiPawn = HaloAIPawn(ActorItem);
		// End:0x8F
		if(haiPawn == none)
		{
			Controller = Controller(ActorItem);
			haiPawn = HaloAIPawn(Controller.Pawn);
		}
		// End:0x225
		if((haiPawn != none) && haiPawn.Health > 0)
		{
			CCSController = CCSController(haiPawn.Controller);
			// End:0x14A
			if(CCSController != none)
			{
				CCSBB = CCSBlackboard(CCSController.BTInterface.Blackboard);
			}
			// End:0x1FD
			if((TetherActor != none) && CCSBB != none)
			{
				PlayerController = HaloPlayerPawnController(TetherActor);
				// End:0x1D5
				if(PlayerController != none)
				{
					CCSBB.SetCurrentTether(PlayerController.Pawn);					
				}
				else
				{
					CCSBB.SetCurrentTether(TetherActor);
				}
			}
			haiPawn.TetherDistance = TetherDistance;
		}		
	}	
	//return;	
}

defaultproperties
{
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Actors",LinkVar="None",PropertyName="Actors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Location",LinkVar="None",PropertyName="TetherActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Distance",LinkVar="None",PropertyName="TetherDistance",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Set Tether"
}