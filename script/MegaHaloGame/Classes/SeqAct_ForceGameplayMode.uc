class SeqAct_ForceGameplayMode extends SequenceAction;

var HaloGameDefault.EGameplayMode ForcedMode;

event Activated()
{
	local HaloGameDefault HGD;

	HGD = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xCE
	if(HGD != none)
	{
		HGD.bOverrideGameplayMode = true;
		HGD.ChangeGameplayMode(ForcedMode);
		LogInternal("Forcing Gameplay Mode to: " $ string(ForcedMode));		
	}
	else
	{
		WarnInternal("Game is not of type HaloGameDefault: Gameplay Mode will not be set to " $ string(ForcedMode));
	}
	//return;	
}

defaultproperties
{
	ForcedMode=GM_InCombat
	bCallHandler=false
	VariableLinks=none
	ObjName="Force Gameplay Mode"
}