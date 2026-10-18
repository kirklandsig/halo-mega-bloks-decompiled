class SeqAct_IsObjectiveComplete extends SequenceAction;

var string ObjectiveName;

event Activated()
{
	local HaloGameDefault Game;
	local bool Completed;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xA9
	if(Game != none)
	{
		Completed = Game.HasCompletedObjective(name(ObjectiveName));
		ForceActivateOutput(((Completed) ? 0 : 1));		
	}
	else
	{
		WarnInternal("Game not set in SeqAct_IsObjectiveComplete!");
		ForceActivateOutput(0);
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Yes",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="No",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Objective Name",LinkVar="None",PropertyName="ObjectiveName",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Is Objective Complete"
}