class GFxHaloTeamHUD extends GFxHaloHUD
	transient
	config(Game);

simulated function Timer()
{
	local UTPlayerReplicationInfo PawnOwnerPRI;

	super(UTHUDBase).Timer();
	// End:0x39
	if(Pawn(PlayerOwner.ViewTarget) == none)
	{
		return;
	}
	PawnOwnerPRI = UTPlayerReplicationInfo(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);
	// End:0xE1
	if((PawnOwnerPRI == none) || PlayerOwner.IsSpectating() && UTPlayerOwner.bBehindView)
	{
		return;
	}
	// End:0x1EE
	if(((UTGRI != none) && PawnOwnerPRI.Team != none) && UTGRI.FlagIsHeldEnemy(PawnOwnerPRI.Team.TeamIndex))
	{
		// End:0x1BF
		if(PawnOwnerPRI.bHasFlag)
		{
			PlayerOwner.ReceiveLocalizedMessage(Class'UTGame.UTCTFHUDMessage', 2);			
		}
		else
		{
			PlayerOwner.ReceiveLocalizedMessage(Class'UTGame.UTCTFHUDMessage', 1);
		}		
	}
	else
	{
		// End:0x23C
		if(PawnOwnerPRI.bHasFlag)
		{
			PlayerOwner.ReceiveLocalizedMessage(Class'UTGame.UTCTFHUDMessage', 0);
		}
	}
	//return;	
}

defaultproperties
{
	MinimapHUDClass=Class'MegaHaloGame.GFxHaloTeamMinimapHUD'
}