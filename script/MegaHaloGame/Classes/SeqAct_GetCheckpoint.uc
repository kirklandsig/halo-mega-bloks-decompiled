class SeqAct_GetCheckpoint extends SequenceAction;

var float CheckpointId;

event Activated()
{
	local HaloGameConquest Game;

	Game = HaloGameConquest(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x81
	if(Game != none)
	{
		CheckpointId = Game.CheckpointId;		
	}
	else
	{
		CheckpointId = -1.0000000;
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Checkpoint",LinkVar="None",PropertyName="CheckpointId",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Get Checkpoint"
}