class SeqAct_PlayFaceFXAnim extends SequenceAction
	native;

var FaceFXAnimSet FaceFXAnimSetRef;
var string FaceFXGroupName;
var string FaceFXAnimName;
var SoundCue SoundCueToPlay;
var AkEvent AkEventToPlay;

defaultproperties
{
	InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Play FaceFX Anim"
}