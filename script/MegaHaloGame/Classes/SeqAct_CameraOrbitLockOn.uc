class SeqAct_CameraOrbitLockOn extends SequenceAction;

var OrbitLockOnStruct LockOnParams;
var Actor TargetActor;
var Actor LockOnActor;

event Activated()
{
	local HaloPlayerPawnController PC;

	LockOnParams.Name = Name;
	PC = HaloPlayerPawnController(GetController(TargetActor));
	// End:0x11B
	if(PC != none)
	{
		// End:0x90
		if(LockOnActor != none)
		{
			LockOnParams.Target = LockOnActor;
		}
		// End:0xE0
		if(InputLinks[0].bHasImpulse == true)
		{
			PC.CameraSetOrbitLockOn(LockOnParams);			
		}
		else
		{
			PC.CameraRemoveOrbitLockOn(LockOnParams.Name);
		}
	}
	//return;	
}

defaultproperties
{
	LockOnParams=(Name="None",Target=none,ReverseDirection=false,EnablePitch=false,RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),Priority=0,EnableDuringPlayerTargetDesignatorMode=false)
	bCallHandler=false
	InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Remove",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Actor",LinkVar="None",PropertyName="TargetActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Lock-On Actor",LinkVar="None",PropertyName="LockOnActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Orbit Lock On"
}