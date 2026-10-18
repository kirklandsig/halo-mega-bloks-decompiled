class SeqAct_ReleaseGameplayMode extends SequenceAction;

event Activated()
{
	local HaloGameDefault HGD;

	HGD = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xB5
	if(HGD != none)
	{
		HGD.bOverrideGameplayMode = false;
		HGD.CheckForGameplayModeChange();
		LogInternal("Releasing Gameplay Mode");		
	}
	else
	{
		WarnInternal("Game is not of type HaloGameDefault: Gameplay Mode will not be released");
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	VariableLinks=none
	ObjName="Release Gameplay Mode"
}