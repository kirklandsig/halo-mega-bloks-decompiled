class SeqAct_ProfileGameCheck extends SequenceAction
	config(AutomateLevels);

var config bool ProfileGame;

event Activated()
{
	// End:0x31
	if(ProfileGame)
	{
		OutputLinks[0].bHasImpulse = true;		
	}
	else
	{
		OutputLinks[1].bHasImpulse = true;
	}
	//return;	
}

defaultproperties
{
	ProfileGame=true
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Succeeded",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	ObjName="ProfileGameCheck"
}