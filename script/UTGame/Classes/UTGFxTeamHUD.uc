class UTGFxTeamHUD extends GFxMinimapHud
	config(UI);

function UpdateGameHUD(UTPlayerReplicationInfo PRI)
{
	local UTPlayerReplicationInfo MaxPRI;
	local int J, CurScores[2];
	local ASDisplayInfo DI;
	local UTTeamInfo Team;

	CurScores[0] = int(GRI.Teams[0].Score);
	CurScores[1] = int(GRI.Teams[1].Score);
	J = 0;
	J0x91:

	// End:0x481 [Loop If]
	if(J < 2)
	{
		// End:0x231
		if(LastScore[J] != CurScores[J])
		{
			LastScore[J] = CurScores[J];
			// End:0x152
			if(CurScores[J] > -100000)
			{
				ScoreTF[J].SetText(string(CurScores[J]));				
			}
			else
			{
				ScoreTF[J].SetText("");
			}
			DI.hasXScale = true;
			DI.XScale = FMax(0.0000000, (100.0000000 * float(LastScore[J])) / float(GRI.GoalScore));
			ScoreBarMC[J].SetDisplayInfo(DI);
		}
		Team = UTTeamInfo(GRI.Teams[J]);
		// End:0x449
		if(Team.TeamFlag != none)
		{
			MaxPRI = Team.TeamFlag.HolderPRI;
			// End:0x366
			if(LastFlagCarrier[J] != MaxPRI)
			{
				LastFlagCarrier[J] = MaxPRI;
				FlagCarrierTF[J].SetText(((MaxPRI != none) ? MaxPRI.PlayerName : ""));
			}
			// End:0x446
			if(int(LastFlagHome[J]) != int(byte(Team.TeamFlag.bHome)))
			{
				LastFlagHome[J] = byte(Team.TeamFlag.bHome);
				FlagCarrierMC[J].SetVisible(int(LastFlagHome[J]) == int(0));
			}			
		}
		else
		{
			FlagCarrierMC[J].SetVisible(false);
		}
		J++;
		// [Loop Continue]
		goto J0x91;
	}
	//return;	
}

function string GetRank(PlayerReplicationInfo PRI)
{
	return "";
	//return ReturnValue;	
}

defaultproperties
{
	bIsTeamHUD=true
}