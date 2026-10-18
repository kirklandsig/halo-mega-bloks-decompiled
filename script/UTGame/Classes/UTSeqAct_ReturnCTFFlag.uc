class UTSeqAct_ReturnCTFFlag extends SequenceAction;

var int TeamIndex;

event Activated()
{
	local UTCarriedObject Flag;
	local UTCTFGame Game;

	// End:0xB7
	if(TeamIndex < 2)
	{
		Game = UTCTFGame(GetWorldInfo().Game);
		Flag = Game.Teams[TeamIndex].TeamFlag;
		// End:0xB7
		if(Flag != none)
		{
			Flag.KismetSendHome();
		}
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	VariableLinks=none
	ObjName="Return CTF Flag"
}