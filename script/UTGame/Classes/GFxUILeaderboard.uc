class GFxUILeaderboard extends UTGFxTweenableMoviePlayer
	config(UI);

struct ListRow
{
	var GFxObject MovieClip;
	var GFxObject InnerMovieClip;
	var GFxObject RankTF;
	var GFxObject ScoreTF;
	var GFxObject NameTF;

	structdefaultproperties
	{
		MovieClip=none
		InnerMovieClip=none
		RankTF=none
		ScoreTF=none
		NameTF=none
	}
};

struct UILeaderboardEntry
{
	var string PlayerName;
	var int Score;
	var int Rank;
	var bool bLocalPlayer;

	structdefaultproperties
	{
		PlayerName=""
		Score=0
		Rank=0
		bLocalPlayer=false
	}
};

var GFxObject RootMC;
var GFxObject LeaderboardMC;
var GFxObject OverlayMC;
var GFxObject TitleMC;
var GFxObject ListMC;
var GFxObject CountMC;
var GFxObject CountTF;
var GFxObject Title_TitleGMC;
var GFxObject TitleTF;
var GFxObject TitleGMC;
var GFxObject ListHeaderMC;
var GFxObject ListScoreTF;
var GFxObject ListTitleTF;
var GFxObject FooterMC;
var GFxObject FooterItemMC;
var GFxObject PlayerRow;
var bool bPlayerRowTween;
var bool bInitialized;
var bool bResolvingLocalPlayer;
var GFxObject Footer_NameTF;
var GFxObject Footer_ScoreLabelTF;
var GFxObject Footer_ScoreTF;
var GFxObject Footer_RankLabelTF;
var GFxObject Footer_RankTF;
var array<ListRow> ListItems;
var int LeaderboardReadCount;
var array<UILeaderboardEntry> LeaderboardData;
var OnlineStatsInterface OSI;
var UTLeaderboardRead LeaderboardStatsRead;
var float LastInitialReadAttempt;
var int ReadAttemptCount;

function bool Start(optional bool StartPaused = false)
{
	OnlineInit();
	super(GFxMoviePlayer).Start();
	Advance(0.0000000);
	// End:0x42
	if(!bInitialized)
	{
		ConfigLeaderboard();
	}
	Draw();
	return true;
	//return ReturnValue;	
}

function PlayOpenAnimation()
{
	TitleMC.GotoAndPlay("open");
	FooterMC.GotoAndPlay("open");
	OverlayMC.GotoAndPlay("open");
	//return;	
}

function PlayCloseAnimation()
{
	TitleMC.GotoAndPlay("close");
	FooterMC.GotoAndPlay("close");
	OverlayMC.GotoAndPlay("close");
	//return;	
}

function ConfigLeaderboard()
{
	RootMC = GetVariableObject("_root");
	LeaderboardMC = RootMC.GetObject("scoreboard");
	RootMC.SetFloat("_xscale", 95.0000000);
	RootMC.SetFloat("_yscale", 95.0000000);
	RootMC.SetFloat("_y", RootMC.GetFloat("_y") + float(25));
	LeaderboardMC.GotoAndStop("dm");
	OverlayMC = LeaderboardMC.GetObject("dm");
	ListMC = LeaderboardMC.GetObject("dm");
	TitleMC = LeaderboardMC.GetObject("title");
	Title_TitleGMC = TitleMC.GetObject("title_g");
	TitleTF = Title_TitleGMC.GetObject("textField");
	CountMC = TitleMC.GetObject("time");
	CountTF = CountMC.GetObject("textField");
	FooterMC = LeaderboardMC.GetObject("footer");
	FooterItemMC = FooterMC.GetObject("footer_item");
	Footer_NameTF = FooterItemMC.GetObject("name");
	Footer_ScoreLabelTF = FooterItemMC.GetObject("tscore");
	Footer_ScoreTF = FooterItemMC.GetObject("score");
	Footer_RankLabelTF = FooterItemMC.GetObject("tdeaths");
	Footer_RankTF = FooterItemMC.GetObject("deaths");
	Footer_ScoreLabelTF.SetText("SCORE");
	Footer_RankLabelTF.SetText("RANK");
	SetupList();
	FloatLeaderboardAnimationX(true);
	FloatLeaderboardAnimationY(true);
	bInitialized = true;
	//return;	
}

function SetupList()
{
	local byte I;
	local ListRow NullRow;
	local ASDisplayInfo DI;
	local GFxObject TempObj;

	I = 0;
	J0x0C:

	// End:0x3AA [Loop If]
	if(int(I) < int(12))
	{
		ListItems[int(I)] = NullRow;
		TempObj = ListMC.GetObject("item" $ string(int(I) + int(1)));
		ListItems[int(I)].MovieClip = TempObj;
		// End:0x1BD
		if(TempObj != none)
		{
			ListItems[int(I)].MovieClip.SetFloat("_z", 200.0000000);
			DI = ListItems[int(I)].MovieClip.GetDisplayInfo();
			DI.Alpha = 50.0000000;
			ListItems[int(I)].MovieClip.SetDisplayInfo(DI);
		}
		TempObj = ListItems[int(I)].MovieClip.GetObject("item_g");
		ListItems[int(I)].InnerMovieClip = TempObj;
		// End:0x39C
		if(TempObj != none)
		{
			ListItems[int(I)].RankTF = ListItems[int(I)].InnerMovieClip.GetObject("deaths");
			ListItems[int(I)].ScoreTF = ListItems[int(I)].InnerMovieClip.GetObject("score");
			ListItems[int(I)].NameTF = ListItems[int(I)].InnerMovieClip.GetObject("name");
		}
		I++;
		// [Loop Continue]
		goto J0x0C;
	}
	ListHeaderMC = ListMC.GetObject("header");
	TempObj = ListHeaderMC.GetObject("header1");
	// End:0x446
	if(TempObj != none)
	{
		TempObj.SetFloat("_z", 200.0000000);
	}
	TempObj = ListHeaderMC.GetObject("score");
	// End:0x4BB
	if(TempObj != none)
	{
		ListScoreTF = TempObj.GetObject("textField");
	}
	TempObj = ListHeaderMC.GetObject("title");
	// End:0x530
	if(TempObj != none)
	{
		ListTitleTF = TempObj.GetObject("textField");
	}
	//return;	
}

function Draw()
{
	TitleTF.SetText(static.GetPC().WorldInfo.GetGameClass().default.GameName);
	UpdateLeaderboardLists();
	UpdateHeaders();
	//return;	
}

function UpdateLeaderboardLists()
{
	local int I;
	local UILeaderboardEntry NullEntry;

	I = 0;
	J0x0B:

	// End:0x119 [Loop If]
	if(I < ListItems.Length)
	{
		// End:0xE5
		if(LeaderboardData.Length > I)
		{
			UpdateRow(ListItems[I], LeaderboardData[I]);
			// End:0xE2
			if(LeaderboardData[I].bLocalPlayer)
			{
				SetPlayerRow(ListItems[I].MovieClip);
				UpdateFooter(LeaderboardData[I]);
			}			
		}
		else
		{
			UpdateRow(ListItems[I], NullEntry);
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function UpdateRow(ListRow CurRow, UILeaderboardEntry CurData)
{
	local ASDisplayInfo DI;
	local array<ASValue> args;
	local UILeaderboardEntry NullEntry;
	local bool bNullEntry;

	bNullEntry = CurData == NullEntry;
	DI = CurRow.MovieClip.GetDisplayInfo();
	DI.Alpha = 100.0000000;
	CurRow.MovieClip.SetDisplayInfo(DI);
	// End:0x139
	if(bNullEntry)
	{
		CurRow.ScoreTF.SetText("");
		CurRow.RankTF.SetText("");		
	}
	else
	{
		CurRow.ScoreTF.SetText(string(CurData.Score));
		CurRow.RankTF.SetText(string(CurData.Rank));
	}
	CurRow.InnerMovieClip.SetString("PlayerName", CurData.PlayerName);
	// End:0x2CB
	if(bNullEntry)
	{
		CurRow.InnerMovieClip.SetString("PlayerScore", "");
		CurRow.InnerMovieClip.SetString("PlayerDeaths", "");		
	}
	else
	{
		CurRow.InnerMovieClip.SetString("PlayerScore", string(CurData.Score));
		CurRow.InnerMovieClip.SetString("PlayerDeaths", string(CurData.Rank));
	}
	args.Length = 0;	
	CurRow.InnerMovieClip.Invoke("UpdateAfterStateChange", args);
	//return;	
}

function SetPlayerRow(GFxObject UpdatedPlayerRow)
{
	// End:0x92
	if(PlayerRow != none)
	{
		ClearsTweensOnMovieClip(PlayerRow);
		PlayerRow.SetFloat("_z", 200.0000000);
		PlayerRow.GetObject("item_g").GotoAndStop("default");
	}
	PlayerRow = UpdatedPlayerRow;
	// End:0x10D
	if(PlayerRow != none)
	{
		TweenPlayerRow(UpdatedPlayerRow);
		PlayerRow.GetObject("item_g").GotoAndStop("player");
	}
	//return;	
}

function UpdateHeaders()
{
	local int LeaderboardCount;

	LeaderboardCount = -1;
	// End:0xA6
	if(LeaderboardCount != -1)
	{
		// End:0x78
		if(LeaderboardData.Length != 0)
		{
			CountTF.SetText((("1-" $ string(LeaderboardReadCount)) $ "/") $ string(LeaderboardCount));			
		}
		else
		{
			CountTF.SetText(string(LeaderboardCount));
		}		
	}
	else
	{
		CountTF.SetText("");
	}
	//return;	
}

function UpdateFooter(UILeaderboardEntry FooterData)
{
	Footer_ScoreTF.SetText(string(FooterData.Score));
	Footer_NameTF.SetText(FooterData.PlayerName);
	Footer_RankTF.SetText(string(FooterData.Rank));
	//return;	
}

function FloatLeaderboardAnimationX(bool Direction)
{
	// End:0x4D
	if(Direction)
	{
		TweenTo(LeaderboardMC, 5.0000000, "_xrotation", 4.0000000, 2, "FloatScoreboard1");		
	}
	else
	{
		TweenTo(LeaderboardMC, 5.0000000, "_xrotation", -4.0000000, 2, "FloatScoreboard2");
	}
	//return;	
}

function FloatLeaderboardAnimationY(bool Direction)
{
	// End:0x4D
	if(Direction)
	{
		TweenTo(LeaderboardMC, 7.0000000, "_yrotation", 7.0000000, 2, "FloatScoreboard3");		
	}
	else
	{
		TweenTo(LeaderboardMC, 7.0000000, "_yrotation", -7.0000000, 2, "FloatScoreboard4");
	}
	//return;	
}

function TweenPlayerRow(GFxObject RowMC)
{
	// End:0x43
	if(bPlayerRowTween)
	{
		TweenTo(RowMC, 1.5000000, "_z", -450.0000000, 2, "TweenPlayerRow");		
	}
	else
	{
		TweenTo(RowMC, 1.5000000, "_z", 0.0000000, 2, "TweenPlayerRow");
	}
	bPlayerRowTween = !bPlayerRowTween;
	//return;	
}

function ProcessTweenCallback(string Callback, GFxObject TargetMC)
{
	switch(Callback)
	{
		// End:0x3C
		case "TweenPlayerRow":
			TweenPlayerRow(TargetMC);
			// End:0xCE
			break;
		// End:0x5F
		case "FloatScoreboard1":
			FloatLeaderboardAnimationX(false);
			// End:0xCE
			break;
		// End:0x82
		case "FloatScoreboard2":
			FloatLeaderboardAnimationX(true);
			// End:0xCE
			break;
		// End:0xA5
		case "FloatScoreboard3":
			FloatLeaderboardAnimationY(false);
			// End:0xCE
			break;
		// End:0xC8
		case "FloatScoreboard4":
			FloatLeaderboardAnimationY(true);
			// End:0xCE
			break;
		// End:0xFFFF
		default:
			// End:0xCE
			break;
			break;
	}
	//return;	
}

function OnCloseAnimComplete()
{
	OnlineCleanup();
	Close(false);
	//return;	
}

function OnOpenAnimComplete()
{
	//return;	
}

function OnlineInit()
{
	local Class<OnlineStatsWrite> CurWriteClass;

	OSI = Class'Engine.GameEngine'.static.GetOnlineSubsystem().StatsInterface;
	// End:0x16B
	if(NotEqual_InterfaceInterface(OSI, OnlineStatsInterface(none)))
	{
		CurWriteClass = static.GetPC().WorldInfo.GetGameClass().default.OnlineStatsWriteClass;
		// End:0x125
		if(CurWriteClass != none)
		{
			LeaderboardStatsRead = new Class'UTGame.UTLeaderboardRead';
			LeaderboardStatsRead.ViewId = CurWriteClass.default.ViewIds[0];
			DoInitialLeaderboardRead();			
		}
		else
		{
			LogInternal("Failed to read leaderboard data, OnlineStatsWriteClass is not set");
		}
	}
	//return;	
}

function DoInitialLeaderboardRead()
{
	OSI.AddReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
	// End:0x15B
	if(!OSI.ReadOnlineStatsByRank(LeaderboardStatsRead, 1, LeaderboardReadCount))
	{
		OSI.ClearReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
		// End:0xF6
		if(ReadAttemptCount < 15)
		{
			ReadAttemptCount++;
			LastInitialReadAttempt = GetPC().WorldInfo.RealTimeSeconds;			
		}
		else
		{
			LogInternal("Call to 'ReadOnlineStatsByRank' failed; can't read leaderboard data");
			ReadAttemptCount = 0;
			LastInitialReadAttempt = -1.0000000;
		}		
	}
	else
	{
		ReadAttemptCount = 0;
		LastInitialReadAttempt = -1.0000000;
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local float CurTimeStamp;

	// End:0x9B
	if((LastInitialReadAttempt != -1.0000000) && NotEqual_InterfaceInterface(OSI, OnlineStatsInterface(none)))
	{
		CurTimeStamp = GetPC().WorldInfo.RealTimeSeconds;
		// End:0x9B
		if((CurTimeStamp - LastInitialReadAttempt) > 1.0000000)
		{
			DoInitialLeaderboardRead();
		}
	}
	super.Tick(DeltaTime);
	//return;	
}

function OnlineCleanup()
{
	// End:0x5C
	if(NotEqual_InterfaceInterface(OSI, OnlineStatsInterface(none)))
	{
		OSI.ClearReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
		OSI = none;
	}
	LeaderboardStatsRead = none;
	//return;	
}

function ReadOnlineStatsComplete(bool bWasSuccessful)
{
	local int I;
	local UniqueNetId CurID;
	local UILeaderboardEntry CurEntry;
	local bool bKickoffLocalQuery;
	local SettingsData RankData;

	// End:0x5F0
	if(bWasSuccessful)
	{
		// End:0x2D7
		if(bResolvingLocalPlayer)
		{
			I = 0;
			J0x25:

			// End:0x2C8 [Loop If]
			if(I < LeaderboardStatsRead.Rows.Length)
			{
				CurID = LeaderboardStatsRead.Rows[I].PlayerID;
				// End:0x2BA
				if(CurID == GetPC().PlayerReplicationInfo.UniqueId)
				{
					CurEntry.PlayerName = LeaderboardStatsRead.Rows[I].NickName;
					CurEntry.Score = LeaderboardStatsRead.GetScore(CurID);
					RankData = LeaderboardStatsRead.Rows[I].Rank;
					// End:0x263
					if(int(LeaderboardStatsRead.Rows[I].Rank.Type) == int(1))
					{
						CurEntry.Rank = Class'Engine.Settings'.static.GetSettingsDataInt(RankData);						
					}
					else
					{
						CurEntry.Rank = -1;
					}
					CurEntry.bLocalPlayer = true;
					UpdateFooter(CurEntry);
					// [Explicit Break]
					goto J0x2C8;
				}
				++I;
				// [Loop Continue]
				goto J0x25;
			}
			J0x2C8:

			bResolvingLocalPlayer = false;			
		}
		else
		{
			bKickoffLocalQuery = true;
			LeaderboardData.Length = LeaderboardStatsRead.Rows.Length;
			I = 0;
			J0x318:

			// End:0x5E3 [Loop If]
			if(I < LeaderboardStatsRead.Rows.Length)
			{
				CurID = LeaderboardStatsRead.Rows[I].PlayerID;
				LeaderboardData[I].PlayerName = LeaderboardStatsRead.Rows[I].NickName;
				LeaderboardData[I].Score = LeaderboardStatsRead.GetScore(CurID);
				RankData = LeaderboardStatsRead.Rows[I].Rank;
				// End:0x52B
				if(int(LeaderboardStatsRead.Rows[I].Rank.Type) == int(1))
				{
					LeaderboardData[I].Rank = Class'Engine.Settings'.static.GetSettingsDataInt(RankData);					
				}
				else
				{
					LeaderboardData[I].Rank = -1;
				}
				// End:0x5D5
				if(CurID == GetPC().PlayerReplicationInfo.UniqueId)
				{
					LeaderboardData[I].bLocalPlayer = true;
					bKickoffLocalQuery = false;
				}
				++I;
				// [Loop Continue]
				goto J0x318;
			}
		}
		Draw();		
	}
	else
	{
		// End:0x63C
		if(!bResolvingLocalPlayer)
		{
			LogInternal("ReadOnlineStatsComplete: Failed to read leaderboard data");
		}
		bResolvingLocalPlayer = false;
	}
	// End:0x6DC
	if(bKickoffLocalQuery)
	{
		bResolvingLocalPlayer = true;
		// End:0x6D9
		if(!OSI.ReadOnlineStatsByRankAroundPlayer(0, LeaderboardStatsRead, 0))
		{
			LeaderboardStatsRead = none;
			OSI.ClearReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
			OSI = none;
		}		
	}
	else
	{
		// End:0x743
		if(NotEqual_InterfaceInterface(OSI, OnlineStatsInterface(none)))
		{
			LeaderboardStatsRead = none;
			OSI.ClearReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
			OSI = none;
		}
	}
	//return;	
}

defaultproperties
{
	LeaderboardReadCount=10
	LastInitialReadAttempt=-1.0000000
	MovieInfo=SwfMovie'UDKHUD.udk_scoreboard'
}