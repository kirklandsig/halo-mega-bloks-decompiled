class SeqAct_AkSetState extends SequenceAction
	native;

var string StateGroup;
var string State;

defaultproperties
{
	InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks=none
	ObjName="AkSetState"
}