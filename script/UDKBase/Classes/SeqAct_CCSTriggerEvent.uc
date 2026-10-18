class SeqAct_CCSTriggerEvent extends SequenceAction;

var string EventType;

defaultproperties
{
	EventType="GlobalEvent"
	InputLinks[0]=(LinkDesc="Trigger",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Trigger Event"
}