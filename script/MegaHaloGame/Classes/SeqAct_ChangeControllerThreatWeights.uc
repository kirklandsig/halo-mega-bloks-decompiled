class SeqAct_ChangeControllerThreatWeights extends SequenceAction;

var array<Pawn> Pawns;
var float NewPassiveObjectiveWeight;
var float NewPassiveSecondaryWeight;
var float NewAggressiveMobileWeight;
var float NewAggressiveStationaryWeight;

event Activated()
{
	local Pawn AI;
	local CCSController AIController;

	// End:0x36C
	foreach Pawns(AI)
	{
		// End:0x301
		if((AI != none) && CCSController(AI.Controller) != none)
		{
			AIController = CCSController(AI.Controller);
			// End:0x123
			if(NewPassiveObjectiveWeight >= 0.0000000)
			{
				AIController.SystemConfig.PassiveObjectiveWeight = NewPassiveObjectiveWeight;
				LogInternal((("AIController: " $ string(AIController)) $ " -- Passive Objective Weight: ") $ string(NewPassiveObjectiveWeight));
			}
			// End:0x1C0
			if(NewPassiveSecondaryWeight >= 0.0000000)
			{
				AIController.SystemConfig.PassiveSecondaryWeight = NewPassiveSecondaryWeight;
				LogInternal((("AIController: " $ string(AIController)) $ " -- Passive Secondary Weight: ") $ string(NewPassiveSecondaryWeight));
			}
			// End:0x25D
			if(NewAggressiveMobileWeight >= 0.0000000)
			{
				AIController.SystemConfig.AggressiveMobileWeight = NewAggressiveMobileWeight;
				LogInternal((("AIController: " $ string(AIController)) $ " -- Aggressive Mobile Weight: ") $ string(NewAggressiveMobileWeight));
			}
			// End:0x2FE
			if(NewAggressiveStationaryWeight >= 0.0000000)
			{
				AIController.SystemConfig.AggressiveStationaryWeight = NewAggressiveStationaryWeight;
				LogInternal((("AIController: " $ string(AIController)) $ " -- Aggressive Stationary Weight: ") $ string(NewAggressiveStationaryWeight));
			}			
		}
		else
		{
			WarnInternal("Error, got a null AIController in SeqAct_ChangeControllerThreatWeight");
			OutputLinks[1].bHasImpulse = true;
		}		
	}	
	// End:0x3B2
	if(!OutputLinks[1].bHasImpulse)
	{
		OutputLinks[0].bHasImpulse = true;
	}
	//return;	
}

defaultproperties
{
	NewPassiveObjectiveWeight=-1.0000000
	NewPassiveSecondaryWeight=-1.0000000
	NewAggressiveMobileWeight=-1.0000000
	NewAggressiveStationaryWeight=-1.0000000
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Succeeded",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="AI Pawns",LinkVar="None",PropertyName="Pawns",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Change Actor Threat Level"
}