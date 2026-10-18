class SeqAct_CameraOrbitSettings extends SequenceAction;

var name ConfigName;
var OrbitStruct OrbitParams;
var Actor TargetActor;

event Activated()
{
	local HaloPlayerPawnController PC;

	OrbitParams.Name = Name;
	PC = HaloPlayerPawnController(GetController(TargetActor));
	// End:0x16A
	if(PC != none)
	{
		// End:0xED
		if(InputLinks[0].bHasImpulse == true)
		{
			// End:0xC2
			if(ConfigName == 'None')
			{
				PC.CameraSetOrbitSettings(OrbitParams);				
			}
			else
			{
				PC.CameraSetOrbitSettingsByName(ConfigName);
			}			
		}
		else
		{
			// End:0x142
			if(ConfigName == 'None')
			{
				PC.CameraRemoveOrbitSettings(OrbitParams.Name);				
			}
			else
			{
				PC.CameraRemoveOrbitSettings(ConfigName);
			}
		}
	}
	//return;	
}

defaultproperties
{
	OrbitParams=(Name="None",Distance=900.0000000,Pitch=10.0000000,FOV=90.0000000,AimYawSpeed=120.0000000,AimPitchSpeed=60.0000000,FocusOffset=(X=150.0000000,Y=0.0000000,Z=0.0000000),RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),LocationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),FOVBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),Priority=-10)
	bCallHandler=false
	InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Remove",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target Actor",LinkVar="None",PropertyName="TargetActor",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Orbit Settings"
}