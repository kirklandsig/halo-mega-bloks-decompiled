class SeqAct_BeginMissionSequence extends SequenceAction;

event Activated()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(GetWorldInfo().Game);
	// End:0x82
	if(Game != none)
	{
		OutputLinks[0].bHasImpulse = !Game.JumpToMission();
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	bAutoActivateOutputLinks=false
	VariableLinks=none
	ObjName="Begin Mission Sequence"
}