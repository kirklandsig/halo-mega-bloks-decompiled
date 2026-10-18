class UTTeamGame extends UTDeathmatch
	config(Game);

var globalconfig bool bPlayersBalanceTeams;
var config bool bAllowNonTeamChat;
var bool bScoreTeamKills;
var bool bSpawnInTeamArea;
var bool bScoreVictimsTarget;
var bool bForceAllRed;
var float FriendlyFireScale;
var float TeammateBoost;
var UTTeamInfo Teams[2];
var Class<UTTeamAI> TeamAIType[2];
var string TeamFactions[2];
var Class<LocalMessage> TeamScoreMessageClass;
var PlayerController PendingTeamSwap;
var float SwapRequestTime;
var name FlagKillMessageName;

function PreBeginPlay()
{
	super(GameInfo).PreBeginPlay();
	CreateTeam(0);
	CreateTeam(1);
	Teams[0].AI.EnemyTeam = Teams[1];
	Teams[1].AI.EnemyTeam = Teams[0];
	//return;	
}

event PostLogin(PlayerController NewPlayer)
{
	local Actor A;

	super(UTGame).PostLogin(NewPlayer);
	// End:0x42
	if(LocalPlayer(NewPlayer.Player) == none)
	{
		return;
	}
	// End:0x7B
	foreach AllActors(Class'Engine.Actor', A)
	{
		A.NotifyLocalPlayerTeamReceived();		
	}	
	//return;	
}

function FindNewObjectives(UTGameObjective DisabledObjective)
{
	Teams[0].AI.FindNewObjectives(DisabledObjective);
	Teams[1].AI.FindNewObjectives(DisabledObjective);
	//return;	
}

function CreateTeam(int TeamIndex)
{
	Teams[TeamIndex] = Spawn(Class'UTGame.UTTeamInfo');
	Teams[TeamIndex].Faction = TeamFactions[TeamIndex];
	Teams[TeamIndex].Initialize(TeamIndex);
	Teams[TeamIndex].AI = Spawn(TeamAIType[TeamIndex]);
	Teams[TeamIndex].AI.Team = Teams[TeamIndex];
	GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
	Teams[TeamIndex].AI.SetObjectiveLists();
	//return;	
}

exec function AddRedBots(int Num)
{
	bCustomBots = true;
	DesiredPlayerCount = Clamp(DesiredPlayerCount + Num, 1, 32);
	J0x2F:

	// End:0x7B [Loop If]
	if(((NumPlayers + NumBots) < DesiredPlayerCount) && (AddBot(,, true, 0)) != none)
	{
		LogInternal("added red bot");
		// [Loop Continue]
		goto J0x2F;
	}
	//return;	
}

exec function AddBlueBots(int Num)
{
	bCustomBots = true;
	DesiredPlayerCount = Clamp(DesiredPlayerCount + Num, 1, 32);
	J0x2F:

	// End:0x7C [Loop If]
	if(((NumPlayers + NumBots) < DesiredPlayerCount) && (AddBot(,, true, 1)) != none)
	{
		LogInternal("added blue bot");
		// [Loop Continue]
		goto J0x2F;
	}
	//return;	
}

function int GetHandicapNeed(Pawn Other)
{
	local int ScoreDiff;

	// End:0x61
	if((Other.PlayerReplicationInfo == none) || Other.PlayerReplicationInfo.Team == none)
	{
		return 0;
	}
	ScoreDiff = int(Teams[1 - Other.PlayerReplicationInfo.Team.TeamIndex].Score - Other.PlayerReplicationInfo.Team.Score);
	// End:0x133
	if(ScoreDiff < 5)
	{
		return 0;
	}
	return ScoreDiff / 5;
	//return ReturnValue;	
}

function UTTeamInfo GetBotTeam(optional int TeamBots, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local int first, second;
	local PlayerController PC;

	// End:0x24
	if(bUseTeamIndex)
	{
		return Teams[TeamIndex];
	}
	// End:0x3D
	if(bForceAllRed)
	{
		return Teams[0];
	}
	// End:0x81
	if(bPlayersVsBots && int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		return Teams[1];
	}
	// End:0x133
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		// End:0x103
		if(Teams[0].AllBotsSpawned())
		{
			// End:0x100
			if(Teams[1].AllBotsSpawned()!)
			{
				return Teams[1];
			}			
		}
		else
		{
			// End:0x133
			if(Teams[1].AllBotsSpawned())
			{
				return Teams[0];
			}
		}
	}
	second = 1;
	// End:0x22A
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		// End:0x229
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x225
			if((PC.PlayerReplicationInfo.Team != none) && PC.PlayerReplicationInfo.Team.TeamIndex == 1)
			{
				first = 1;
				second = 0;
			}
			// End:0x229
			break;			
		}		
	}
	// End:0x296
	if(Teams[first].Size < Teams[second].Size)
	{
		return Teams[first];		
	}
	else
	{
		return Teams[second];
	}
	//return ReturnValue;	
}

function int LevelRecommendedPlayers()
{
	local UTMapInfo MapInfo;
	local int Num;

	MapInfo = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0xB2
	if(MapInfo != none)
	{
		Num = Min(16, (MapInfo.RecommendedPlayersMax + MapInfo.RecommendedPlayersMin) / 2);
		// End:0xAF
		if((Num % 2) != 0)
		{
			Num++;
		}		
	}
	else
	{
		Num = 1;
	}
	return Num;
	//return ReturnValue;	
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
	local Controller C;
	local PlayerReplicationInfo Living;
	local bool bNoneLeft;

	// End:0x27D
	if(MaxLives > 0)
	{
		// End:0x57
		if((Scorer != none) && Scorer.bOutOfLives!)
		{
			Living = Scorer;
		}
		bNoneLeft = true;
		// End:0x223
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			// End:0x222
			if((((C.PlayerReplicationInfo != none) && C.bIsPlayer) && C.PlayerReplicationInfo.bOutOfLives!) && C.PlayerReplicationInfo.bOnlySpectator!)
			{
				// End:0x18F
				if(Living == none)
				{
					Living = C.PlayerReplicationInfo;
					// End:0x222
					continue;
				}
				// End:0x222
				if((C.PlayerReplicationInfo != Living) && C.PlayerReplicationInfo.Team != Living.Team)
				{
					bNoneLeft = false;
					// End:0x223
					break;
				}
			}			
		}		
		// End:0x27D
		if(bNoneLeft)
		{
			// End:0x25F
			if(Living != none)
			{
				EndGame(Living, "LastMan");				
			}
			else
			{
				EndGame(Scorer, "LastMan");
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

event InitGame(string Options, out string ErrorMessage)
{
	local string InOpt;
	local Class<UTTeamAI> InType;

	super(UTGame).InitGame(Options, ErrorMessage);
	InOpt = ParseOption(Options, "RedAI");
	// End:0xA4
	if(InOpt != "")
	{
		InType = Class<UTTeamAI>(DynamicLoadObject(InOpt, Class'Core.Class'));
		// End:0xA4
		if(InType != none)
		{
			TeamAIType[0] = InType;
		}
	}
	InOpt = ParseOption(Options, "BlueAI");
	// End:0x12D
	if(InOpt != "")
	{
		InType = Class<UTTeamAI>(DynamicLoadObject(InOpt, Class'Core.Class'));
		// End:0x12D
		if(InType != none)
		{
			TeamAIType[1] = InType;
		}
	}
	InOpt = ParseOption(Options, "AllRed");
	// End:0x16E
	if(InOpt != "")
	{
		bForceAllRed = true;
	}
	InOpt = ParseOption(Options, "BalanceTeams");
	// End:0x1BF
	if(InOpt != "")
	{
		bPlayersBalanceTeams = bool(InOpt);
	}
	TeamFactions[0] = ParseOption(Options, "RedFaction");
	TeamFactions[1] = ParseOption(Options, "BlueFaction");
	//return;	
}

function bool TooManyBots(Controller botToRemove)
{
	local TeamInfo BotTeam, OtherTeam;

	// End:0x0F
	if(bForceAllRed)
	{
		return false;
	}
	// End:0x1D8
	if((((bPlayersVsBots! || int(WorldInfo.NetMode) == int(NM_Standalone)) && UTBot(botToRemove) != none) && bCustomBots! || int(WorldInfo.NetMode) != int(NM_Standalone)) && botToRemove.PlayerReplicationInfo.Team != none)
	{
		BotTeam = botToRemove.PlayerReplicationInfo.Team;
		OtherTeam = Teams[1 - BotTeam.TeamIndex];
		// End:0x195
		if(OtherTeam.Size < (BotTeam.Size - 1))
		{
			return true;			
		}
		else
		{
			// End:0x1D8
			if(OtherTeam.Size > BotTeam.Size)
			{
				return false;
			}
		}
	}
	// End:0x238
	if((int(WorldInfo.NetMode) != int(NM_Standalone)) && bPlayersVsBots)
	{
		return NumBots > Min(16, int(BotRatio * float(NumPlayers)));
	}
	// End:0x253
	if(bPlayerBecameActive)
	{
		bPlayerBecameActive = false;
		return true;
	}
	return (NumBots + NumPlayers) > DesiredPlayerCount;
	//return ReturnValue;	
}

function NotifyKilled(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, Class<DamageType> DamageType)
{
	Teams[0].AI.NotifyKilled(Killer, KilledPlayer, KilledPawn, DamageType);
	Teams[1].AI.NotifyKilled(Killer, KilledPlayer, KilledPawn, DamageType);
	//return;	
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
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
	// End:0x139
	if(bLastMan! && CheckModifiedEndGame(Winner, Reason))
	{
		return false;
	}
	// End:0x1C6
	if(bTeamScoreRounds)
	{
		// End:0x1C3
		if(Winner != none)
		{
			Winner.Team.Score += float(1);
			Winner.Team.bForceNetUpdate = true;
		}		
	}
	else
	{
		// End:0x24F
		if(bLastMan! && Teams[1].Score == Teams[0].Score)
		{
			// End:0x24D
			if(bOverTimeBroadcast!)
			{
				StartupStage = 7;
				PlayStartupMessage();
				bOverTimeBroadcast = true;
			}
			return false;
		}
	}
	// End:0x29C
	if(bLastMan)
	{
		GameReplicationInfo.Winner = Winner.Team;		
	}
	else
	{
		// End:0x30E
		if(Teams[1].Score > Teams[0].Score)
		{
			GameReplicationInfo.Winner = Teams[1];			
		}
		else
		{
			GameReplicationInfo.Winner = Teams[0];
		}
	}
	// End:0x48A
	if(Winner == none)
	{
		// End:0x489
		foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
		{
			// End:0x488
			if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) && (Winner == none) || P.PlayerReplicationInfo.Score > Winner.Score)
			{
				Winner = P.PlayerReplicationInfo;
			}			
		}		
	}
	EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
	SetEndGameFocus(Winner);
	return true;
	//return ReturnValue;	
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;

	// End:0x55
	if(Winner != none)
	{
		EndGameFocus = Controller(Winner.Owner).Pawn;
	}
	// End:0x85
	if(EndGameFocus != none)
	{
		EndGameFocus.bAlwaysRelevant = true;
	}
	// End:0x15B
	foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
	{
		P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);		
	}	
	//return;	
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
	// End:0x35
	if((ViewTarget == none) || ViewTarget.bOnlySpectator)
	{
		return false;
	}
	return Viewer.PlayerReplicationInfo.bOnlySpectator || ViewTarget.Team == Viewer.PlayerReplicationInfo.Team;
	//return ReturnValue;	
}

function RestartGame()
{
	local PlayerController PC;
	local int RedCount, BlueCount, MoveCount, I;
	local array<PlayerController> RedPlayers, BluePlayers;

	// End:0x31D
	if((bPlayersVsBots! && bPlayersBalanceTeams) && int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		// End:0x1CE
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x1CD
			if((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.Team != none)
			{
				// End:0x156
				if(PC.PlayerReplicationInfo.Team.TeamIndex == 0)
				{
					RedCount++;
					RedPlayers[RedPlayers.Length] = PC;
					// End:0x1CD
					continue;
				}
				// End:0x1CD
				if(PC.PlayerReplicationInfo.Team.TeamIndex == 1)
				{
					BlueCount++;
					BluePlayers[BluePlayers.Length] = PC;
				}
			}			
		}		
		// End:0x31D
		if(Abs(float(RedCount - BlueCount)) > float(1))
		{
			// End:0x293
			if(RedCount > BlueCount)
			{
				MoveCount = (RedCount - BlueCount) / 2;
				I = 0;
				J0x233:

				// End:0x290 [Loop If]
				if(I < MoveCount)
				{
					SetTeam(RedPlayers[(RedPlayers.Length - I) - 1], Teams[1], false);
					I++;
					// [Loop Continue]
					goto J0x233;
				}				
			}
			else
			{
				MoveCount = (BlueCount - RedCount) / 2;
				I = 0;
				J0x2C0:

				// End:0x31D [Loop If]
				if(I < MoveCount)
				{
					SetTeam(BluePlayers[(BluePlayers.Length - I) - 1], Teams[0], false);
					I++;
					// [Loop Continue]
					goto J0x2C0;
				}
			}
		}
	}
	super(UTGame).RestartGame();
	//return;	
}

function byte PickTeam(byte Num, Controller C)
{
	local UTTeamInfo SmallTeam, BigTeam, NewTeam;
	local Controller B;
	local int BigTeamBots, SmallTeamBots;

	// End:0x10
	if(bForceAllRed)
	{
		return 0;
	}
	// End:0x66
	if(bPlayersVsBots && int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		// End:0x63
		if(PlayerController(C) != none)
		{
			return 0;
		}
		return 1;
	}
	SmallTeam = Teams[0];
	BigTeam = Teams[1];
	// End:0xFB
	if(SmallTeam.Size > BigTeam.Size)
	{
		SmallTeam = Teams[1];
		BigTeam = Teams[0];
	}
	// End:0x12E
	if(int(Num) < int(2))
	{
		NewTeam = Teams[int(Num)];
	}
	// End:0x153
	if(NewTeam == none)
	{
		NewTeam = SmallTeam;		
	}
	else
	{
		// End:0x502
		if((bPlayersBalanceTeams && int(WorldInfo.NetMode) != int(NM_Standalone)) && PlayerController(C) != none)
		{
			// End:0x1FC
			if(SmallTeam.Size < BigTeam.Size)
			{
				NewTeam = SmallTeam;				
			}
			else
			{
				// End:0x329
				foreach WorldInfo.AllControllers(Class'Engine.Controller', B)
				{
					// End:0x328
					if((B.PlayerReplicationInfo != none) && B.PlayerReplicationInfo.bBot)
					{
						// End:0x2DC
						if(B.PlayerReplicationInfo.Team == BigTeam)
						{
							BigTeamBots++;
							// End:0x328
							continue;
						}
						// End:0x328
						if(B.PlayerReplicationInfo.Team == SmallTeam)
						{
							SmallTeamBots++;
						}
					}					
				}				
				// End:0x438
				if(BigTeamBots > 0)
				{
					// End:0x3A6
					if((SmallTeam.Size - SmallTeamBots) < (BigTeam.Size - BigTeamBots))
					{
						NewTeam = SmallTeam;						
					}
					else
					{
						// End:0x413
						if((BigTeam.Size - BigTeamBots) < (SmallTeam.Size - SmallTeamBots))
						{
							NewTeam = BigTeam;							
						}
						else
						{
							// End:0x435
							if(SmallTeamBots == 0)
							{
								NewTeam = BigTeam;
							}
						}
					}					
				}
				else
				{
					// End:0x45D
					if(SmallTeamBots > 0)
					{
						NewTeam = SmallTeam;						
					}
					else
					{
						// End:0x502
						if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.Team != none)
						{
							NewTeam = UTTeamInfo(C.PlayerReplicationInfo.Team);
						}
					}
				}
			}
		}
	}
	return byte(NewTeam.TeamIndex);
	//return ReturnValue;	
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
	local UTTeamInfo NewTeam, PendingTeam;

	// End:0x33
	if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
	{
		return false;
	}
	// End:0xC6
	if(Other.IsA('PlayerController') && Other.PlayerReplicationInfo.bOnlySpectator)
	{
		Other.PlayerReplicationInfo.Team = none;
		return true;
	}
	NewTeam = ((Num < 255) ? Teams[int(PickTeam(byte(Num), Other))] : none);
	// End:0x46F
	if(Other.PlayerReplicationInfo.Team == NewTeam)
	{
		// End:0x46D
		if(((((Num < 2) && Num != NewTeam.TeamIndex) && bPlayersVsBots!) && PlayerController(Other) != none) && UTTeamInfo(Other.PlayerReplicationInfo.Team) != none)
		{
			// End:0x3F5
			if(PendingTeamSwap != none)
			{
				// End:0x26F
				if(PendingTeamSwap.bDeleteMe || (WorldInfo.TimeSeconds - SwapRequestTime) > 8.0000000)
				{
					PendingTeamSwap = none;					
				}
				else
				{
					// End:0x3F5
					if(PendingTeamSwap.PlayerReplicationInfo.Team.TeamIndex == Num)
					{
						PendingTeam = UTTeamInfo(PendingTeamSwap.PlayerReplicationInfo.Team);
						// End:0x3F5
						if(PendingTeam != none)
						{
							SetTeam(PendingTeamSwap, UTTeamInfo(Other.PlayerReplicationInfo.Team), true);
							// End:0x3C2
							if(PendingTeamSwap.Pawn != none)
							{
								PendingTeamSwap.Pawn.PlayerChangedTeam();
							}
							PendingTeamSwap = none;
							SetTeam(Other, PendingTeam, bNewTeam);
							return true;
						}
					}
				}
			}
			PendingTeamSwap = PlayerController(Other);
			SwapRequestTime = WorldInfo.TimeSeconds;
			BroadcastLocalizedMessage(Class'UTGame.UTTeamGameMessage', 0, PendingTeamSwap.PlayerReplicationInfo);
		}
		return false;
	}
	SetTeam(Other, NewTeam, bNewTeam);
	return true;
	//return ReturnValue;	
}

function SetTeam(Controller Other, UTTeamInfo NewTeam, bool bNewTeam)
{
	local Actor A;

	// End:0x26
	if(Other.PlayerReplicationInfo == none)
	{
		return;
	}
	// End:0x99
	if((Other.PlayerReplicationInfo.Team != none) || ShouldSpawnAtStartSpot(Other)!)
	{
		Other.StartSpot = none;
	}
	// End:0x159
	if(Other.PlayerReplicationInfo.Team != none)
	{
		Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
		Other.PlayerReplicationInfo.Team = none;
	}
	// End:0x266
	if((NewTeam == none) || (NewTeam != none) && NewTeam.AddToTeam(Other))
	{
		// End:0x266
		if((NewTeam != none) && ((int(WorldInfo.NetMode) != int(NM_Standalone)) || PlayerController(Other) == none) || PlayerController(Other).Player != none)
		{
			BroadcastLocalizedMessage(GameMessageClass, 3, Other.PlayerReplicationInfo, none, NewTeam);
		}
	}
	// End:0x2F0
	if((PlayerController(Other) != none) && LocalPlayer(PlayerController(Other).Player) != none)
	{
		// End:0x2EF
		foreach AllActors(Class'Engine.Actor', A)
		{
			A.NotifyLocalPlayerTeamReceived();			
		}		
	}
	//return;	
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	// End:0x96
	if(bSpawnInTeamArea)
	{
		// End:0x57
		if(UTTeamPlayerStart(P) == none)
		{
			WarnInternal(string(P) $ " is not a team playerstart!");
			return -9.0000000;
		}
		// End:0x96
		if(int(Team) != int(UTTeamPlayerStart(P).TeamNumber))
		{
			return -9.0000000;
		}
	}
	return super(UTGame).RatePlayerStart(P, Team, Player);
	//return ReturnValue;	
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	// End:0x1B
	if(CheckMaxLives(Scorer))
	{
		return false;		
	}
	else
	{
		// End:0x51
		if((bOverTime! && GoalScore == 0) || Scorer == none)
		{
			return false;			
		}
		else
		{
			// End:0xE2
			if((Scorer.Team != none) && Scorer.Team.Score >= float(GoalScore))
			{
				EndGame(Scorer, "teamscorelimit");
				return true;				
			}
			else
			{
				// End:0x112
				if(bOverTime)
				{
					EndGame(Scorer, "timelimit");
					return true;					
				}
				else
				{
					// End:0x471
					if(bScoreDeaths && GoalScore > 0)
					{
						// End:0x24C
						if(Scorer.Team.Score == float(GoalScore - 10))
						{
							// End:0x249
							if(bPlayedTenKills! && GoalScore > 19)
							{
								// End:0x249
								if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
								{
									bPlayedTenKills = true;
									BroadcastLocalized(self, Class'UTGame.UTKillsRemainingMessage', 0);
								}
							}							
						}
						else
						{
							// End:0x368
							if(Scorer.Team.Score == float(GoalScore - 5))
							{
								// End:0x365
								if(bPlayedFiveKills! && GoalScore > 9)
								{
									// End:0x365
									if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
									{
										bPlayedFiveKills = true;
										BroadcastLocalized(self, Class'UTGame.UTKillsRemainingMessage', 1);
									}
								}								
							}
							else
							{
								// End:0x471
								if((Scorer.Team.Score == float(GoalScore - 1)) && bPlayedOneKill!)
								{
									// End:0x471
									if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
									{
										bPlayedOneKill = true;
										BroadcastLocalized(self, Class'UTGame.UTKillsRemainingMessage', 2);
									}
								}
							}
						}
					}
					return false;
				}
			}
		}
	}
	//return ReturnValue;	
}

function Pawn FindVictimsTarget(Controller Other)
{
	local Vector Start, X, Y, Z;
	local float Dist, Aim;
	local Actor Target;

	// End:0x72
	if(((Other == none) || Other.Pawn == none) || Other.Pawn.Weapon == none)
	{
		return none;
	}
	GetAxes(Other.Pawn.GetViewRotation(), X, Y, Z);
	Start = Other.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Other.Pawn.BaseEyeHeight);
	Aim = 0.9700000;
	Target = Other.PickTarget(Class'Engine.Pawn', Aim, Dist, X, Start, 4000.0000000);
	return Pawn(Target);
	//return ReturnValue;	
}

function bool NearGoal(Controller C)
{
	return false;
	//return ReturnValue;	
}

function ScoreKill(Controller Killer, Controller Other)
{
	local Pawn Target;
	local UTPlayerReplicationInfo KillerPRI, OtherPRI, TargetPRI;
	local UTBot B;

	// End:0x11C
	if(Other.bIsPlayer! || (Killer != none) && Killer.bIsPlayer! || Killer.PlayerReplicationInfo == none)
	{
		super(UTGame).ScoreKill(Killer, Other);
		// End:0x11A
		if(((bScoreTeamKills! && Killer != none) && Killer.bIsPlayer) && MaxLives > 0)
		{
			CheckScore(Killer.PlayerReplicationInfo);
		}
		return;
	}
	// End:0x6F2
	if(((Killer == none) || Killer == Other) || Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team)
	{
		// End:0x6D3
		if(Killer != none)
		{
			KillerPRI = UTPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			OtherPRI = UTPlayerReplicationInfo(Other.PlayerReplicationInfo);
			// End:0x6D3
			if(KillerPRI.Team != OtherPRI.Team)
			{
				// End:0x2CE
				if(OtherPRI.bHasFlag)
				{
					OtherPRI.GetFlag().bLastSecondSave = NearGoal(Other);
				}
				// End:0x56D
				if(OtherPRI.bHasFlag)
				{
					// End:0x33D
					if(NearGoal(Other))
					{
						OtherPRI.GetFlag().bLastSecondSave = true;
					}
					// End:0x56D
					if(OtherPRI != none)
					{
						KillerPRI.Score += float(2);
						KillerPRI.bForceNetUpdate = true;
						KillerPRI.IncrementEventStat('EVENT_KILLEDFLAGCARRIER');
						// End:0x551
						if(UTPlayerController(Killer) != none)
						{
							UTPlayerController(Killer).ClientMusicEvent(6);
							// End:0x551
							if((WorldInfo.TimeSeconds - LastEncouragementTime) > float(10))
							{
								// End:0x550
								foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
								{
									// End:0x54F
									if(((B.PlayerReplicationInfo != none) && B.PlayerReplicationInfo.Team == Killer.PlayerReplicationInfo.Team) && FRand() < 0.4000000)
									{
										B.SendMessage(Killer.PlayerReplicationInfo, 'ENCOURAGEMENT', 0.0000000, none);
										// End:0x550
										break;
									}									
								}								
							}
						}
						SendFlagKillMessage(Killer, KillerPRI);
					}
				}
				// End:0x6D3
				if(bScoreVictimsTarget)
				{
					Target = FindVictimsTarget(Other);
					TargetPRI = ((Target != none) ? UTPlayerReplicationInfo(Target.PlayerReplicationInfo) : none);
					// End:0x6D3
					if(((TargetPRI != none) && TargetPRI.bHasFlag) && TargetPRI.Team == Killer.PlayerReplicationInfo.Team)
					{
						Killer.PlayerReplicationInfo.Score += float(1);
						Killer.PlayerReplicationInfo.bForceNetUpdate = true;
					}
				}
			}
		}
		super(UTGame).ScoreKill(Killer, Other);		
	}
	else
	{
		ModifyScoreKill(Killer, Other);
	}
	// End:0x8D8
	if(bScoreTeamKills!)
	{
		// End:0x88E
		if(((((Other.bIsPlayer && Killer != none) && Killer.bIsPlayer) && Killer != Other) && Killer.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
		{
			Killer.PlayerReplicationInfo.Score -= float(1);
			Killer.PlayerReplicationInfo.bForceNetUpdate = true;
		}
		// End:0x8D6
		if((MaxLives > 0) && Killer != none)
		{
			CheckScore(Killer.PlayerReplicationInfo);
		}
		return;
	}
	// End:0xCC7
	if(Other.bIsPlayer)
	{
		// End:0x9BD
		if((Killer == none) || Killer == Other)
		{
			Other.PlayerReplicationInfo.Team.Score -= float(1);
			Other.PlayerReplicationInfo.Team.bForceNetUpdate = true;			
		}
		else
		{
			// End:0xAC3
			if(Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team)
			{
				Killer.PlayerReplicationInfo.Team.Score += float(1);
				Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;				
			}
			else
			{
				// End:0xBDA
				if(FriendlyFireScale > float(0))
				{
					Killer.PlayerReplicationInfo.bForceNetUpdate = true;
					Killer.PlayerReplicationInfo.Score -= float(1);
					Killer.PlayerReplicationInfo.Team.Score -= float(1);
					Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;
				}
			}
		}
		// End:0xCC7
		if(UTGameReplicationInfo(GameReplicationInfo).bStoryMode && (PlayerController(Killer) != none) || PlayerController(Other) != none)
		{
			// End:0xC80
			if(AIController(Killer) != none)
			{
				AdjustSkill(AIController(Killer), PlayerController(Other), false);
			}
			// End:0xCC7
			if(AIController(Other) != none)
			{
				AdjustSkill(AIController(Other), PlayerController(Killer), true);
			}
		}
	}
	// End:0xD0D
	if((Killer != none) && bScoreTeamKills)
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
	//return;	
}

function CampaignSkillAdjust(UTBot aBot)
{
	// End:0x294
	if((aBot.PlayerReplicationInfo.Team.TeamIndex == 1) || AdjustedDifficulty < GameDifficulty)
	{
		aBot.Skill = AdjustedDifficulty;
		// End:0x291
		if(aBot.PlayerReplicationInfo.Team.TeamIndex == 1)
		{
			// End:0x14A
			if(Teams[1].Size > Teams[0].Size)
			{
				aBot.Skill -= 0.5000000;				
			}
			else
			{
				// End:0x1C5
				if((Teams[1].Size < Teams[0].Size) && NumPlayers > 1)
				{
					aBot.Skill += 0.7500000;
				}
			}
			// End:0x22D
			if(aBot.PlayerReplicationInfo.PlayerName ComplementEqual "Akasha")
			{
				aBot.Skill += 1.5000000;				
			}
			else
			{
				// End:0x291
				if(aBot.PlayerReplicationInfo.PlayerName ComplementEqual "Loque")
				{
					aBot.Skill += 0.7500000;
				}
			}
		}		
	}
	else
	{
		aBot.Skill = 0.5000000 * (AdjustedDifficulty + GameDifficulty);
	}
	//return;	
}

function AdjustSkill(AIController B, PlayerController P, bool bWinner)
{
	local float AdjustmentFactor;

	AdjustmentFactor = 0.1500000;
	// End:0x19F
	if(bWinner)
	{
		PlayerKills += 1;
		// End:0x177
		if((Teams[1 - P.PlayerReplicationInfo.Team.TeamIndex].Score > (Teams[P.PlayerReplicationInfo.Team.TeamIndex].Score + float(1))) && Teams[1 - P.PlayerReplicationInfo.Team.TeamIndex].Size > 1)
		{
			return;
		}
		AdjustedDifficulty = FMin(7.0000000, AdjustedDifficulty + AdjustmentFactor);		
	}
	else
	{
		PlayerDeaths += 1;
		// End:0x283
		if(Teams[1 - P.PlayerReplicationInfo.Team.TeamIndex].Score <= Teams[P.PlayerReplicationInfo.Team.TeamIndex].Score)
		{
			return;
		}
		AdjustedDifficulty = FMax(0.0000000, AdjustedDifficulty - AdjustmentFactor);
	}
	AdjustedDifficulty = FClamp(AdjustedDifficulty, GameDifficulty - 1.2500000, GameDifficulty + 1.2500000);
	// End:0x359
	if(bWinner == (B.Skill < AdjustedDifficulty))
	{
		CampaignSkillAdjust(UTBot(B));
		UTBot(B).ResetSkill();
	}
	//return;	
}

function SendFlagKillMessage(Controller Killer, UTPlayerReplicationInfo KillerPRI)
{
	// End:0x49
	if((UTPlayerController(Killer) != none) && UTPlayerController(Killer).bAutoTaunt!)
	{
		return;
	}
	Killer.SendMessage(none, FlagKillMessageName, 10.0000000, none);
	//return;	
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
	local int InjuredTeam, InstigatorTeam;
	local Class<UTDamageType> UTDamageType;
	local UTPlayerController PC;

	// End:0x5A
	if(InstigatedBy == none)
	{
		super(UTGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
		return;
	}
	InjuredTeam = int(injured.GetTeamNum());
	InstigatorTeam = int(InstigatedBy.GetTeamNum());
	// End:0x6AD
	if((InstigatedBy != injured.Controller) && (injured.DrivenVehicle == none) || InstigatedBy.Pawn != injured.DrivenVehicle)
	{
		// End:0x6AD
		if((InjuredTeam != 255) && InstigatorTeam != 255)
		{
			// End:0x5AD
			if(InjuredTeam == InstigatorTeam)
			{
				Momentum *= TeammateBoost;
				// End:0x52D
				if(InstigatedBy.PlayerReplicationInfo != none)
				{
					PC = UTPlayerController(InstigatedBy);
					// End:0x52D
					if(((PC != none) && PC.Pawn != none) && (WorldInfo.TimeSeconds - PC.LastFriendlyFireTime) > float(5))
					{
						// End:0x52D
						if((Vector(PC.Rotation) Dot Normal(injured.Location - PC.Pawn.Location)) > 0.9000000)
						{
							// End:0x52D
							if(((PC.ShotTarget == injured) || PC.ShotTarget == none) || WorldInfo.GRI.OnSameTeam(PC.ShotTarget, PC))
							{
								UTDamageType = Class<UTDamageType>(DamageType);
								// End:0x52D
								if((UTDamageType != none) && UTDamageType.default.bComplainFriendlyFire)
								{
									// End:0x45D
									if(UTBot(injured.Controller) != none)
									{
										UTBot(injured.Controller).YellAt(InstigatedBy.PlayerReplicationInfo);										
									}
									else
									{
										// End:0x52D
										if((UTPlayerController(injured.Controller) != none) && UTPlayerController(injured.Controller).bAutoTaunt)
										{
											injured.Controller.SendMessage(InstigatedBy.PlayerReplicationInfo, 'FRIENDLYFIRE', 12.0000000);
										}
									}
								}
							}
						}
					}
				}
				// End:0x596
				if(FriendlyFireScale == 0.0000000)
				{
					Damage = 0;
					super(UTGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
					return;
				}
				Damage *= FriendlyFireScale;				
			}
			else
			{
				// End:0x6AD
				if(((injured.IsHumanControlled()! && injured.Controller != none) && UTPlayerReplicationInfo(injured.PlayerReplicationInfo) != none) && UTPlayerReplicationInfo(injured.PlayerReplicationInfo).bHasFlag)
				{
					injured.Controller.SendMessage(none, 'injured', 15.0000000);
				}
			}
		}
	}
	super(UTGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	//return;	
}

function bool DominatingVictory()
{
	return ((Teams[0].Score == float(0)) || Teams[1].Score == float(0)) && (Teams[0].Score + Teams[1].Score) >= float(3);
	//return ReturnValue;	
}

function bool IsAWinner(PlayerController C)
{
	// End:0x26
	if(C.PlayerReplicationInfo == none)
	{
		return false;
	}
	return C.PlayerReplicationInfo.bOnlySpectator || IsWinningTeam(C.PlayerReplicationInfo.Team);
	//return ReturnValue;	
}

function bool IsWinningTeam(TeamInfo T)
{
	// End:0x5F
	if(Teams[0].Score > Teams[1].Score)
	{
		return T == Teams[0];		
	}
	else
	{
		return T == Teams[1];
	}
	//return ReturnValue;	
}

function PlayRegularEndOfMatchMessage()
{
	local UTPlayerController PC;
	local int Index;

	// End:0x54
	if(Teams[0].Score > Teams[1].Score)
	{
		Index = 4;		
	}
	else
	{
		Index = 5;
	}
	// End:0xC8
	foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
	{
		PC.ClientPlayAnnouncement(VictoryMessageClass, Index);		
	}	
	//return;	
}

function AnnounceScore(int ScoringTeam)
{
	local UTPlayerController PC;
	local int OtherTeam, MessageIndex;

	// End:0x11
	if(TeamScoreMessageClass == none)
	{
		return;
	}
	OtherTeam = 1 - ScoringTeam;
	// End:0x9B
	if(Teams[ScoringTeam].Score == (Teams[OtherTeam].Score + float(1)))
	{
		MessageIndex = 4 + ScoringTeam;		
	}
	else
	{
		// End:0x110
		if(Teams[ScoringTeam].Score == (Teams[OtherTeam].Score + float(2)))
		{
			MessageIndex = 2 + ScoringTeam;			
		}
		else
		{
			MessageIndex = ScoringTeam;
		}
	}
	// End:0x18C
	foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
	{
		PC.ReceiveLocalizedMessage(TeamScoreMessageClass, MessageIndex);		
	}	
	//return;	
}

function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
	local UTTeamInfo DesiredTeam;
	local int ActualTeamIndex;

	DesiredTeam = UTTeamInfo(PC.PlayerReplicationInfo.Team);
	PC.PlayerReplicationInfo.OverrideWith(OldPRI);
	// End:0x186
	if((DesiredTeam != PC.PlayerReplicationInfo.Team) && DesiredTeam != none)
	{
		ActualTeamIndex = int(PickTeam(byte(DesiredTeam.TeamIndex), PC));
		// End:0x186
		if(PC.PlayerReplicationInfo.Team != Teams[ActualTeamIndex])
		{
			SetTeam(PC, Teams[ActualTeamIndex], true);
		}
	}
	//return;	
}

function bool AllowClientToTeleport(UTPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
	return GameReplicationInfo.OnSameTeam(ClientPRI, DestinationActor);
	//return ReturnValue;	
}

function ShowPathTo(PlayerController P, int TeamNum)
{
	local UTGameObjective G, Best;

	Best = none;
	G = Teams[0].AI.Objectives;
	J0x4A:

	// End:0x117 [Loop If]
	if(G != none)
	{
		// End:0xEC
		if(G.BetterObjectiveThan(Best, byte(TeamNum), byte(P.PlayerReplicationInfo.Team.TeamIndex)))
		{
			Best = G;
		}
		G = G.NextObjective;
		// [Loop Continue]
		goto J0x4A;
	}
	// End:0x1A6
	if((Best != none) && P.FindPathToward(Best, false) != none)
	{
		Spawn(Class'UTGame.UTWillowWhisp', P,, P.Pawn.Location);
	}
	//return;	
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	local int I;

	super(UTGame).GetSeamlessTravelActorList(bToEntry, ActorList);
	I = 0;
	J0x28:

	// End:0x176 [Loop If]
	if(I < WorldInfo.GRI.Teams.Length)
	{
		// End:0x168
		if((WorldInfo.GRI.Teams[I] != none) && bToEntry || WorldInfo.GRI.Teams[I].Size > 0)
		{
			ActorList[ActorList.Length] = WorldInfo.GRI.Teams[I];
		}
		I++;
		// [Loop Continue]
		goto J0x28;
	}
	//return;	
}

function Logout(Controller Exiting)
{
	local TeamInfo OldTeam;
	local int I;
	local bool bFound;

	// End:0x9A
	if(WorldInfo.IsInSeamlessTravel()! && Exiting.PlayerReplicationInfo.bFromPreviousLevel)
	{
		OldTeam = Exiting.PlayerReplicationInfo.Team;
	}
	super(UTGame).Logout(Exiting);
	// End:0x162
	if((OldTeam != none) && OldTeam.Size <= 1)
	{
		I = 0;
		J0xED:

		// End:0x13B [Loop If]
		if(I < 2)
		{
			// End:0x12D
			if(Teams[I] == OldTeam)
			{
				bFound = true;
				// [Explicit Break]
				goto J0x13B;
			}
			I++;
			// [Loop Continue]
			goto J0xED;
		}
		J0x13B:

		// End:0x162
		if(bFound!)
		{
			OldTeam.Destroy();
		}
	}
	//return;	
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local TeamInfo NewTeam;

	// End:0x38E
	if(C.PlayerReplicationInfo != none)
	{
		// End:0x326
		if((C.PlayerReplicationInfo.Team != none) && C.PlayerReplicationInfo.Team.TeamIndex < 2)
		{
			// End:0x323
			if(Teams[C.PlayerReplicationInfo.Team.TeamIndex] != C.PlayerReplicationInfo.Team)
			{
				NewTeam = Teams[C.PlayerReplicationInfo.Team.TeamIndex];
				// End:0x227
				if(C.PlayerReplicationInfo.Team.Size <= 1)
				{
					C.PlayerReplicationInfo.Team.Destroy();					
				}
				else
				{
					C.PlayerReplicationInfo.Team.RemoveFromTeam(C);
				}
				NewTeam.AddToTeam(C);
				// End:0x323
				if(C.IsA('UTBot') && NewTeam.IsA('UTTeamInfo'))
				{
					UTTeamInfo(NewTeam).SetBotOrders(UTBot(C));
				}
			}			
		}
		else
		{
			// End:0x38E
			if(C.PlayerReplicationInfo.bOnlySpectator! && AIController(C) == none)
			{
				ChangeTeam(C, 0, false);
			}
		}
	}
	super(UTGame).HandleSeamlessTravelPlayer(C);
	//return;	
}

function ParseSpeechRecipients(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words, out array<UTBot> Recipients)
{
	local int I;
	local UTBot B;
	local bool bEntireTeam;
	local UTPlayerReplicationInfo PRI;

	bEntireTeam = ((Words[0].WordText ComplementEqual "Team") || Words[0].WordText ComplementEqual "everyone") || Words[0].WordText ComplementEqual "all";
	I = 0;
	J0x95:

	// End:0x268 [Loop If]
	if(I < GameReplicationInfo.PRIArray.Length)
	{
		PRI = UTPlayerReplicationInfo(GameReplicationInfo.PRIArray[I]);
		// End:0x25A
		if((((PRI != none) && PRI.Team != none) && PRI.Team == Speaker.PlayerReplicationInfo.Team) && bEntireTeam || PRI.GetCallSign() ComplementEqual Words[0].WordText)
		{
			B = UTBot(GameReplicationInfo.PRIArray[I].Owner);
			// End:0x25A
			if(B != none)
			{
				Recipients[Recipients.Length] = B;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x95;
	}
	//return;	
}

function ProcessSpeechOrders(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words, const out array<UTBot> Recipients)
{
	local name Orders;
	local int I;
	local Vehicle V;
	local bool bShouldAck;

	switch(Caps(Words[1].WordText))
	{
		// End:0x35
		case "ATTACK":
		// End:0x40
		case "DEFEND":
		// End:0x4E
		case "FREELANCE":
		// End:0x57
		case "HOLD":
		// End:0x8F
		case "FOLLOW":
			Orders = name(Words[1].WordText);
			// End:0x468
			break;
		// End:0xAF
		case "COVER":
			Orders = 'Follow';
			// End:0x468
			break;
		// End:0x126
		case "TAUNT":
			I = 0;
			J0xC4:

			// End:0x123 [Loop If]
			if(I < Recipients.Length)
			{
				Recipients[I].SendMessage(none, 'Taunt', 0.0000000);
				I++;
				// [Loop Continue]
				goto J0xC4;
			}
			// End:0x468
			break;
		// End:0x1D2
		case "SUICIDE":
			I = 0;
			J0x13D:

			// End:0x1CF [Loop If]
			if(I < Recipients.Length)
			{
				// End:0x1C1
				if(Recipients[I].Pawn != none)
				{
					Recipients[I].Pawn.Suicide();
				}
				I++;
				// [Loop Continue]
				goto J0x13D;
			}
			// End:0x468
			break;
		// End:0x267
		case "STATUS":
			I = 0;
			J0x1E8:

			// End:0x264 [Loop If]
			if(I < Recipients.Length)
			{
				Recipients[I].SendMessage(Speaker.PlayerReplicationInfo, 'Status', 0.0000000);
				I++;
				// [Loop Continue]
				goto J0x1E8;
			}
			// End:0x468
			break;
		// End:0x351
		case "JUMP":
			I = 0;
			J0x27B:

			// End:0x34E [Loop If]
			if(I < Recipients.Length)
			{
				// End:0x340
				if(Recipients[I].Pawn != none)
				{
					Recipients[I].Pawn.bWantsToCrouch = false;
					Recipients[I].Pawn.DoJump(false);
				}
				I++;
				// [Loop Continue]
				goto J0x27B;
			}
			// End:0x468
			break;
		// End:0x3B8
		case "GIMME":
			I = 0;
			J0x366:

			// End:0x3B5 [Loop If]
			if(I < Recipients.Length)
			{
				Recipients[I].ForceGiveWeapon();
				I++;
				// [Loop Continue]
				goto J0x366;
			}
			// End:0x468
			break;
		// End:0x462
		case "GET OUT":
			I = 0;
			J0x3CF:

			// End:0x45F [Loop If]
			if(I < Recipients.Length)
			{
				V = Vehicle(Recipients[I].Pawn);
				// End:0x451
				if(V != none)
				{
					V.DriverLeave(false);
				}
				I++;
				// [Loop Continue]
				goto J0x3CF;
			}
			// End:0x468
			break;
		// End:0xFFFF
		default:
			// End:0x468
			break;
			break;
	}
	// End:0x50D
	if(Orders != 'None')
	{
		bShouldAck = true;
		I = 0;
		J0x496:

		// End:0x50D [Loop If]
		if(I < Recipients.Length)
		{
			Recipients[I].SetBotOrders(Orders, Speaker, bShouldAck);
			bShouldAck = false;
			I++;
			// [Loop Continue]
			goto J0x496;
		}
	}
	//return;	
}

function ProcessSpeechRecognition(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words)
{
	local array<UTBot> Recipients;

	super(UTGame).ProcessSpeechRecognition(Speaker, Words);
	ParseSpeechRecipients(Speaker, Words, Recipients);
	ProcessSpeechOrders(Speaker, Words, Recipients);
	//return;	
}

defaultproperties
{
	bPlayersBalanceTeams=true
	bScoreTeamKills=true
	TeammateBoost=0.3000000
	TeamAIType[0]=Class'UTGame.UTTeamAI'
	TeamAIType[1]=Class'UTGame.UTTeamAI'
	FlagKillMessageName="Taunt"
	bMustHaveMultiplePlayers=true
	bIgnoreTeamForVoiceChat=false
	Acronym="TDM"
	Description="Two teams duke it out in a quest for battlefield supremacy.  The team with the most total frags wins."
	EndOfMatchRulesTemplateStr_Scoring="First team to frag `g times wins"
	EndOfMatchRulesTemplateStr_Time="Team with most frags in `t mins. wins"
	MidgameScorePanelTag="TDMPanel"
	bTeamGame=true
	HUDType=Class'UTGame.UTTeamHUD'
	GameName="Team DeathMatch"
	GoalScore=60
	OnlineStatsWriteClass=Class'UTGame.UTStatsWriteTDM'
	OnlineGameSettingsClass=Class'UTGame.UTGameSettingsTDM'
}