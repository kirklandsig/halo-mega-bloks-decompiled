class SeqAct_ChangeActorThreatLevel extends SequenceAction;

var array<Actor> Actors;
var int NewBaseThreat;
var float NewInnerThreatRadius;
var float NewOutterThreatRadius;
var int NewMaxHeat;

event Activated()
{
	local Actor Act;
	local editinline UDKTargetableComponent targetableComponent;

	// End:0x32C
	foreach Actors(Act)
	{
		// End:0x6B
		if(Act.IsA('Controller'))
		{
			Act = Controller(Act).Pawn;
		}
		// End:0x2CE
		if(Act != none)
		{
			targetableComponent = UDKTargetableComponent(Act.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
			// End:0x2CB
			if(targetableComponent != none)
			{
				// End:0x13A
				if(NewBaseThreat > -1)
				{
					targetableComponent.BaseThreatVal = NewBaseThreat;
					LogInternal((("Actor: " $ string(Act)) $ " -- Base Threat: ") $ string(NewBaseThreat));
				}
				// End:0x1BA
				if(NewInnerThreatRadius > float(-1))
				{
					targetableComponent.InnerThreatRadius = NewInnerThreatRadius;
					LogInternal((("Actor: " $ string(Act)) $ " -- Inner Threat Radius: ") $ string(NewInnerThreatRadius));
				}
				// End:0x23B
				if(NewOutterThreatRadius > float(-1))
				{
					targetableComponent.OutterThreatRadius = NewOutterThreatRadius;
					LogInternal((("Actor: " $ string(Act)) $ " -- Outter Threat Radius: ") $ string(NewOutterThreatRadius));
				}
				// End:0x2CB
				if(NewMaxHeat > -1)
				{
					targetableComponent.MaxAIHeat = float(NewMaxHeat);
					LogInternal((("Actor: " $ string(Act)) $ " -- Max Heat Value: ") $ string(targetableComponent.MaxAIHeat));
				}
			}			
		}
		else
		{
			WarnInternal("Error, got a null actor in SeqAct_ChangeActorThreatLevel");
			OutputLinks[1].bHasImpulse = true;
		}		
	}	
	// End:0x372
	if(OutputLinks[1].bHasImpulse!)
	{
		OutputLinks[0].bHasImpulse = true;
	}
	//return;	
}

defaultproperties
{
	NewBaseThreat=-1
	NewInnerThreatRadius=-1.0000000
	NewOutterThreatRadius=-1.0000000
	NewMaxHeat=-1
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Succeeded",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Actors",LinkVar="None",PropertyName="Actors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Change Actor Threat Level"
}