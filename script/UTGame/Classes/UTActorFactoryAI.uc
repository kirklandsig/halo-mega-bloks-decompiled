class UTActorFactoryAI extends GwNavActorFactoryAI
	config(Editor)
	editinlinenew
	collapsecategories;

var bool bForceDeathmatchAI;
var bool bUseCompartment;

simulated event PostCreateActor(Actor NewActor, optional SeqAct_ActorFactory ActorFactoryData)
{
	local UTBot Bot;
	local Pawn NewPawn;
	local int Idx;

	NewPawn = Pawn(NewActor);
	// End:0x3C9
	if(NewPawn != none)
	{
		Bot = NewPawn.Spawn(Class'UTGame.UTBot',,, NewPawn.Location, NewPawn.Rotation);
		// End:0x2CB
		if(Bot != none)
		{
			Bot.SetTeam(TeamIndex);
			Bot.Possess(NewPawn, false);
			// End:0x258
			if(bForceDeathmatchAI)
			{
				Bot.Squad = Bot.Spawn(Class'UTGame.UTSquadAI');
				// End:0x258
				if(Bot.Squad != none)
				{
					// End:0x212
					if(Bot.PlayerReplicationInfo != none)
					{
						Bot.Squad.Team = UTTeamInfo(Bot.PlayerReplicationInfo.Team);
					}
					UTSquadAI(Bot.Squad).SetLeader(Bot);
				}
			}
			// End:0x2CB
			if((Bot.PlayerReplicationInfo != none) && PawnName != "")
			{
				Bot.PlayerReplicationInfo.SetPlayerName(PawnName);
			}
		}
		// End:0x365
		if(bGiveDefaultInventory && NewPawn.WorldInfo.Game != none)
		{
			NewPawn.WorldInfo.Game.AddDefaultInventory(NewPawn);
		}
		Idx = 0;
		J0x370:

		// End:0x3C9 [Loop If]
		if(Idx < InventoryList.Length)
		{
			NewPawn.CreateInventory(InventoryList[Idx], false);
			Idx++;
			// [Loop Continue]
			goto J0x370;
		}
	}
	//return;	
}

defaultproperties
{
	ControllerClass=none
}