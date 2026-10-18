class HaloGameBesieged extends HaloGameDefault
	config(Game);

event InitGame(string Options, out string ErrorMessage)
{
	LogInternal(string(self) $ ": HaloGameBesieged::InitGame");
	super.InitGame(Options, ErrorMessage);
	// End:0x110
	if((ParseOption(Options, "StartingPawnClass")) != "")
	{
		LogInternal("Setting DefaultPawnClass to " $ (ParseOption(Options, "StartingPawnClass")));
		DefaultPawnClass = Class<Pawn>(Class'MegaHaloGame.HaloSaveGame'.static.GetArchetypeFromName(ParseOption(Options, "StartingPawnClass")));
	}
	//return;	
}
