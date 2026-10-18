class UTCTFGame extends UTTeamGame
	abstract
	config(Game);

var UTCTFFlag Flags[2];
var Class<UTLocalMessage> AnnouncerMessageClass;

function PostBeginPlay()
{
	local int I;

	super(UTGame).PostBeginPlay();
	I = 0;
	J0x15:

	// End:0x1BC [Loop If]
	if(I < 2)
	{
		Flags[I].Team = Teams[I];
		Teams[I].HomeBase = UTGameObjective(Flags[I].HomeBase);
		Teams[I].TeamFlag = Flags[I];
		UTCTFTeamAI(Teams[I].AI).FriendlyFlag = Flags[I];
		UTCTFTeamAI(Teams[I].AI).EnemyFlag = Flags[1 - I];
		I++;
		// [Loop Continue]
		goto J0x15;
	}
	//return;	
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;

	// End:0x9F
	if(Winner != none)
	{
		// End:0x75
		if(Winner.Team.TeamIndex == 0)
		{
			EndGameFocus = Flags[0].HomeBase;			
		}
		else
		{
			EndGameFocus = Flags[1].HomeBase;
		}
	}
	// End:0xCF
	if(EndGameFocus != none)
	{
		EndGameFocus.bAlwaysRelevant = true;
	}
	// End:0x1A5
	foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
	{
		P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);		
	}	
	//return;	
}

function int GetHandicapNeed(Pawn Other)
{
	// End:0x61
	if((Other.PlayerReplicationInfo == none) || Other.PlayerReplicationInfo.Team == none)
	{
		return 0;
	}
	return int(Teams[1 - Other.PlayerReplicationInfo.Team.TeamIndex].Score - Other.PlayerReplicationInfo.Team.Score);
	//return ReturnValue;	
}

function bool GetLocationFor(Pawn StatusPawn, out Actor LocationObject, out int MessageIndex, int LocationSpeechOffset)
{
	local UTPickupFactory F;
	local UDKGameObjective Best;
	local UTBot B;

	B = UTBot(StatusPawn.Controller);
	// End:0xD9
	if(B != none)
	{
		F = UTPickupFactory(StatusPawn.Controller.RouteGoal);
		// End:0xD9
		if((F != none) && F.bHasLocationSpeech)
		{
			MessageIndex = 0;
			LocationObject = F;
			return true;
		}
	}
	// End:0x27F
	if((Flags[0].HomeBase != none) && Flags[1].HomeBase != none)
	{
		Best = ((VSizeSq(StatusPawn.Location - Flags[0].HomeBase.Location) < VSizeSq(StatusPawn.Location - Flags[1].HomeBase.Location)) ? Flags[0].HomeBase : Flags[1].HomeBase);
		MessageIndex = UTGameObjective(Best).GetLocationMessageIndex(B, StatusPawn);
		LocationObject = Best;
		return true;
	}
	MessageIndex = 10;
	return true;
	//return ReturnValue;	
}

function RegisterFlag(UTCTFFlag F, int TeamIndex)
{
	Flags[TeamIndex] = F;
	//return;	
}

function bool NearGoal(Controller C)
{
	local UTGameObjective B;

	B = UTTeamInfo(C.PlayerReplicationInfo.Team).HomeBase;
	return UTCTFBase(B).myFlag.bHome && VSize(C.Pawn.Location - B.Location) < float(1000);
	//return ReturnValue;	
}

function bool WantFastSpawnFor(AIController B)
{
	// End:0x12
	if(NumBots < 6)
	{
		return true;
	}
	// End:0x24
	if(NumBots > 16)
	{
		return false;
	}
	return UTCTFSquadAI(UTBot(B).Squad).FriendlyFlag.bHome!;
	//return ReturnValue;	
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local UTCTFFlag BestFlag;
	local Controller P;
	local bool bLastMan;

	// End:0xE8
	if(bOverTime)
	{
		// End:0x29
		if((NumBots + NumPlayers) == 0)
		{
			return true;
		}
		bLastMan = true;
		// End:0xD8
		foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
		{
			// End:0xD7
			if((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.bOutOfLives!)
			{
				bLastMan = false;
				// End:0xD8
				break;
			}			
		}		
		// End:0xE8
		if(bLastMan)
		{
			return true;
		}
	}
	bLastMan = Reason ComplementEqual "LastMan";
	// End:0x128
	if(CheckModifiedEndGame(Winner, Reason))
	{
		return false;
	}
	// End:0x175
	if(bLastMan)
	{
		GameReplicationInfo.Winner = Winner.Team;		
	}
	else
	{
		// End:0x22A
		if(Teams[1].Score == Teams[0].Score)
		{
			// End:0x1F4
			if(IsAutomatedPerfTesting())
			{
				GameReplicationInfo.Winner = Teams[0];				
			}
			else
			{
				// End:0x225
				if(bOverTimeBroadcast!)
				{
					StartupStage = 7;
					PlayStartupMessage();
					bOverTimeBroadcast = true;
				}
				return false;
			}			
		}
		else
		{
			// End:0x29C
			if(Teams[1].Score > Teams[0].Score)
			{
				GameReplicationInfo.Winner = Teams[1];				
			}
			else
			{
				GameReplicationInfo.Winner = Teams[0];
			}
		}
	}
	BestFlag = UTCTFTeamAI(UTTeamInfo(GameReplicationInfo.Winner).AI).FriendlyFlag;
	// End:0x37F
	if(Winner != none)
	{
		EndGameFocus = Controller(Winner.Owner).Pawn;
	}
	// End:0x3B6
	if(EndGameFocus == none)
	{
		EndGameFocus = BestFlag.HomeBase;
	}
	EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
	// End:0x4BF
	foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
	{
		P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);		
	}	
	BestFlag.HomeBase.SetHidden(false);
	return true;
	//return ReturnValue;	
}

function ScoreFlag(Controller Scorer, UTCTFFlag theFlag)
{
	local float Dist, oppDist;
	local int I, GoalsScored;
	local float ppp, numtouch;
	local Vector FlagLoc;
	local UTPlayerReplicationInfo ScorerPRI;
	local UTPlayerController PC;

	ScorerPRI = UTPlayerReplicationInfo(Scorer.PlayerReplicationInfo);
	// End:0x2CA
	if(ScorerPRI.Team == theFlag.Team)
	{
		FlagLoc = theFlag.Position().Location;
		Dist = VSize(FlagLoc - theFlag.HomeBase.Location);
		oppDist = VSize(FlagLoc - Teams[1 - theFlag.Team.TeamIndex].HomeBase.Location);
		BroadcastLocalizedMessage(AnnouncerMessageClass, 1 + (7 * theFlag.Team.TeamIndex), ScorerPRI, none, theFlag.Team);
		ScorerPRI.IncrementEventStat('EVENT_RETURNEDFLAG');
		// End:0x2C8
		if(Dist > float(1024))
		{
			// End:0x26B
			if(Dist <= oppDist)
			{
				ScorerPRI.Score += float(3);				
			}
			else
			{
				ScorerPRI.Score += float(5);
				// End:0x2C8
				if(oppDist <= float(1024))
				{
					ScorerPRI.Score += float(7);
				}
			}
		}
		return;
	}
	// End:0x387
	if(theFlag.FirstTouch != none)
	{
		theFlag.FirstTouch.PlayerReplicationInfo.Score += float(5);
		theFlag.FirstTouch.PlayerReplicationInfo.bForceNetUpdate = true;
	}
	ScorerPRI.bForceNetUpdate = true;
	ScorerPRI.Score += float(5);
	GoalsScored = ScorerPRI.IncrementEventStat('EVENT_SCOREDFLAG');
	PC = UTPlayerController(Scorer);
	// End:0x499
	if(GoalsScored == 3)
	{
		ScorerPRI.IncrementEventStat('EVENT_HATTRICK');
		// End:0x496
		if(PC != none)
		{
			PC.ReceiveLocalizedMessage(TeamScoreMessageClass, 6, ScorerPRI);
		}		
	}
	else
	{
		// End:0x4DD
		if(PC != none)
		{
			PC.ReceiveLocalizedMessage(TeamScoreMessageClass, 7, ScorerPRI);
		}
	}
	// End:0x6AB
	if(theFlag.Assists.Length > 0)
	{
		numtouch = 0.0000000;
		I = 0;
		J0x51C:

		// End:0x59F [Loop If]
		if(I < theFlag.Assists.Length)
		{
			// End:0x591
			if(theFlag.Assists[I] != none)
			{
				numtouch = numtouch + 1.0000000;
			}
			I++;
			// [Loop Continue]
			goto J0x51C;
		}
		// End:0x6AB
		if(numtouch > float(0))
		{
			ppp = FClamp(20.0000000 / numtouch, 1.0000000, 5.0000000);
			I = 0;
			J0x5E1:

			// End:0x6AB [Loop If]
			if(I < theFlag.Assists.Length)
			{
				// End:0x69D
				if(theFlag.Assists[I] != none)
				{
					theFlag.Assists[I].PlayerReplicationInfo.Score += float(int(ppp));
				}
				I++;
				// [Loop Continue]
				goto J0x5E1;
			}
		}
	}
	ScorerPRI.Team.Score += 1.0000000;
	ScorerPRI.Team.bForceNetUpdate = true;
	CheckScore(ScorerPRI);
	// End:0x75C
	if(bOverTime)
	{
		EndGame(ScorerPRI, "timelimit");		
	}
	else
	{
		// End:0x83A
		if(UTGameReplicationInfo(GameReplicationInfo).bStoryMode)
		{
			// End:0x7E4
			if(ScorerPRI.Team.TeamIndex == 0)
			{
				AdjustedDifficulty = FMin(7.0000000, AdjustedDifficulty + 0.5000000);				
			}
			else
			{
				AdjustedDifficulty = FMax(0.0000000, AdjustedDifficulty - 0.5000000);
			}
			AdjustedDifficulty = FClamp(AdjustedDifficulty, GameDifficulty - 1.2500000, GameDifficulty + 1.2500000);
		}
	}
	AnnounceScore(ScorerPRI.Team.TeamIndex);
	//return;	
}

function ViewObjective(PlayerController PC)
{
	local Actor A;

	// End:0x18B
	if((PC.ViewTarget != none) && ((PC.ViewTarget == Flags[0]) || PC.ViewTarget == Flags[0].Holder) || PC.ViewTarget == Flags[0].HomeBase)
	{
		A = Flags[1].HomeBase.GetBestViewTarget();
		PC.SetViewTarget(A);
		// End:0x188
		if(UTPlayerController(PC) != none)
		{
			UTPlayerController(PC).ClientSetBehindView(true);
		}		
	}
	else
	{
		A = Flags[0].HomeBase.GetBestViewTarget();
		PC.SetViewTarget(A);
		// End:0x235
		if(UTPlayerController(PC) != none)
		{
			UTPlayerController(PC).ClientSetBehindView(true);
		}
	}
	//return;	
}

function Actor GetAutoObjectiveFor(UTPlayerController PC)
{
	// End:0x145
	if(UTTeamInfo(PC.PlayerReplicationInfo.Team) != none)
	{
		// End:0xD7
		if(UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag)
		{
			return UTTeamInfo(PC.PlayerReplicationInfo.Team).HomeBase;			
		}
		else
		{
			return Teams[1 - PC.PlayerReplicationInfo.Team.TeamIndex].HomeBase;
		}		
	}
	else
	{
		return none;
	}
	//return ReturnValue;	
}

state MatchOver
{
	ignores ScoreFlag, AnnounceScore;
	stop;	
}

defaultproperties
{
	bScoreTeamKills=false
	bSpawnInTeamArea=true
	bScoreVictimsTarget=true
	TeamAIType[0]=Class'UTGame.UTCTFTeamAI'
	TeamAIType[1]=Class'UTGame.UTCTFTeamAI'
	FlagKillMessageName="FLAGKILL"
	bUndrivenVehicleDamage=true
	bScoreDeaths=false
	Acronym="CTF"
	Description="Your team must capture the enemy flag by taking it from the enemy base and returning it to their own.  If the flag carrier is killed, the flag drops to the ground for anyone to pick up.  If your team's flag is taken, it must be returned (by touching it after it is dropped) before your team can score a flag capture."
	MapPrefixes[0]="CTF"
	EndOfMatchRulesTemplateStr_Scoring="First team to score `g times wins"
	EndOfMatchRulesTemplateStr_Time="Team with most scores in `t mins. wins"
	MidgameScorePanelTag="CTFPanel"
	GameName="Capture the Flag"
	GoalScore=3
	DeathMessageClass=Class'UTGame.UTTeamDeathMessage'
	OnlineStatsWriteClass=Class'UTGame.UTStatsWriteCTF'
	OnlineGameSettingsClass=Class'UTGame.UTGameSettingsCTF'
}