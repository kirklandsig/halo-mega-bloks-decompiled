class SeqAct_AbortObjective extends SequenceAction;

var HaloObjective Objective;

event Activated()
{
	// End:0x39
	if(Objective != none)
	{
		Objective.Term();
		Objective = none;
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Abort Objective"
}