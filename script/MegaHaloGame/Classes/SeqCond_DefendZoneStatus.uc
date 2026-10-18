class SeqCond_DefendZoneStatus extends SequenceCondition;

var HaloObjective_DefendZone Objective;
var Trigger Zone;
var float Value;

event Activated()
{
	local int Index;

	// End:0x16B
	if(Objective != none)
	{
		// End:0x111
		if(Zone != none)
		{
			Index = Objective.GetZoneIndex(Zone);
			// End:0xB0
			if(Index != -1)
			{
				OutputLinks[int(Objective.GetZoneStatusAtIndex(Index))].bHasImpulse = true;				
			}
			else
			{
				WarnInternal("Error, provided condition Defend Zone Status with a trigger not assigned to this objective");
			}			
		}
		else
		{
			WarnInternal("Error, provided condition Defend Zone Status with an invalid zone (must be Trigger)");
		}		
	}
	else
	{
		WarnInternal("Error, provided condition Defend Zone Status with an invalid objective (must be DefendZone)");
	}
	//return;	
}

defaultproperties
{
	OutputLinks[0]=(Links=none,LinkDesc="Neutral",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Friendly",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[2]=(Links=none,LinkDesc="Hostile",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Zone",LinkVar="None",PropertyName="Zone",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Output Value",LinkVar="None",PropertyName="Value",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Defend Zone Status"
}