class SeqAct_IsMissionComplete extends SequenceAction;

var string missionName;

event Activated()
{
	local HaloGameDefault Game;
	local bool Completed;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xA9
	if(Game != none)
	{
		Completed = Game.HasCompletedMission(name(missionName));
		ForceActivateOutput(((Completed) ? 0 : 1));		
	}
	else
	{
		WarnInternal("Game not set in SeqAct_IsMissionComplete!");
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
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Mission Name",LinkVar="None",PropertyName="missionName",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Is Mission Complete"
}