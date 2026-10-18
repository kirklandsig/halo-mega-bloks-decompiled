class SeqAct_CameraLockView extends SequenceAction;

var LockViewStruct LockParams;
var Actor TargetView;
var Actor TargetActor;

event Activated()
{
	local HaloPlayerPawnController PC;

	LockParams.Name = Name;
	// End:0x107
	if(TargetView != none)
	{
		LockParams.Rotation = TargetView.Rotation;
		LockParams.Location = TargetView.Location;
		// End:0x107
		if(CameraActor(TargetView) != none)
		{
			LockParams.FOV = CameraActor(TargetView).FOVAngle;
		}
	}
	PC = HaloPlayerPawnController(GetController(TargetActor));
	// End:0x1C7
	if(PC != none)
	{
		// End:0x18C
		if(InputLinks[0].bHasImpulse == true)
		{
			PC.CameraSetLockView(LockParams);			
		}
		else
		{
			PC.CameraRemoveLockView(LockParams.Name);
		}
	}
	//return;	
}

defaultproperties
{
	LockParams=(Name="None",Target=none,LockRotation=false,LockLocation=false,LockFOV=false,Rotation=(Pitch=0,Yaw=0,Roll=0),Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),FOV=90.0000000,RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),LocationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),FOVBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),Priority=0)
	bCallHandler=false
	InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Remove",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Actor",LinkVar="None",PropertyName="TargetActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target View",LinkVar="None",PropertyName="TargetView",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Lock View"
}