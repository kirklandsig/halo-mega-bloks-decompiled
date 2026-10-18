class SeqAct_CompleteMission extends SequenceAction;

var HaloMission mission;

event Activated()
{
	// End:0x39
	if(mission != none)
	{
		mission.Complete();
		mission = none;
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Mission",LinkVar="None",PropertyName="mission",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Complete Mission"
}