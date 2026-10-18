class SeqAct_SetHaloTriggerEnabled extends SequenceAction;

var HaloTrigger TargetActor;
var bool Enabled;

event Activated()
{
	TargetActor.Enabled = Enabled;
	LogInternal((((string(self) $ ": SETTING ") $ string(TargetActor)) $ " to ") $ string(Enabled));
	//return;	
}

defaultproperties
{
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="Enabled",LinkVar="None",PropertyName="Enabled",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Trigger",LinkVar="None",PropertyName="TargetActor",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Halo Trigger"
}