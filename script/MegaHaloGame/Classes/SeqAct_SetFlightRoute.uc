class SeqAct_SetFlightRoute extends SequenceAction;

var Actor TargetActor;
var Route newRoute;
var HaloAIFlightNode newSpline;

event Activated()
{
	local HaloVehicleFactory_BansheeAI Factory;

	Factory = HaloVehicleFactory_BansheeAI(TargetActor);
	// End:0x9C
	if(Factory != none)
	{
		// End:0x65
		if(newRoute != none)
		{
			Factory.SetFlightRoute(newRoute);			
		}
		else
		{
			// End:0x9C
			if(newSpline != none)
			{
				Factory.SetFlightSpline(newSpline);
			}
		}
	}
	//return;	
}

defaultproperties
{
	OutputLinks=none
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Vehicle Factory",LinkVar="None",PropertyName="TargetActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Route",LinkVar="None",PropertyName="newRoute",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spline Start",LinkVar="None",PropertyName="newSpline",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Set Flight Route"
}