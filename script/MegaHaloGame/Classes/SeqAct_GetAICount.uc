class SeqAct_GetAICount extends SequenceAction;

var int LastAICount;

event Activated()
{
	local int aiTally;
	local CCSController AIController;
	local HaloPawn thisPawn;
	local bool requireTeamCheck;
	local byte TeamNum;

	// End:0x2E
	if(Targets.Length > 0)
	{
		thisPawn = HaloPawn(Targets[0]);
	}
	// End:0x87
	if((Targets.Length == 1) && thisPawn != none)
	{
		requireTeamCheck = true;
		TeamNum = thisPawn.GetTeamNum();		
	}
	else
	{
		// End:0xE0
		if(Targets.Length > 0)
		{
			WarnInternal("SeqAct_GetAICount has too many input targets - getting all AI instead");
		}
		requireTeamCheck = false;
	}
	aiTally = 0;
	// End:0x1E4
	foreach GetWorldInfo().AllControllers(Class'UDKBase.CCSController', AIController)
	{
		// End:0x1E3
		if(((AIController.Pawn != none) && HaloPawn(AIController.Pawn) != none) && requireTeamCheck! || int(AIController.Pawn.GetTeamNum()) == int(TeamNum))
		{
			aiTally++;
		}		
	}	
	LastAICount = aiTally;
	//return;	
}

defaultproperties
{
	bCallHandler=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="AI Count",LinkVar="None",PropertyName="LastAICount",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Get AI Count"
}