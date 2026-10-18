class SeqAct_SetPawnSpeed extends SequenceAction;

var float GroundSpeed;
var array<Actor> Actors;

event Activated()
{
	local Actor ActorItem;
	local Pawn Pawn;
	local Controller Controller;

	// End:0xBE
	foreach Actors(ActorItem)
	{
		Pawn = Pawn(ActorItem);
		// End:0x86
		if(Pawn == none)
		{
			Controller = Controller(ActorItem);
			Pawn = Controller.Pawn;
		}
		// End:0xBD
		if(Pawn != none)
		{
			Pawn.GroundSpeed = GroundSpeed;
		}		
	}	
	//return;	
}

defaultproperties
{
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Actors",LinkVar="None",PropertyName="Actors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Set Pawn Speed"
}