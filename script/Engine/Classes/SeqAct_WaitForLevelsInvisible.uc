class SeqAct_WaitForLevelsInvisible extends SeqAct_Latent
	native;

var array<name> LevelNames;

// Export USeqAct_WaitForLevelsInvisible::execAreAllLevelsInvisible(FFrame&, void* const)
native final function bool AreAllLevelsInvisible();

defaultproperties
{
	InputLinks[0]=(LinkDesc="Wait",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks=none
	ObjName="Wait for Levels to become invisible"
}