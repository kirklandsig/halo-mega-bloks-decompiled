class AutoTestManager extends Info
	native
	config(Game)
	notplaceable;

var bool bAutomatedPerfTesting;
var bool bAutoContinueToNextRound;
var bool bUsingAutomatedTestingMapList;
var bool bAutomatedTestingWithOpen;
var globalconfig bool bExitOnCyclesComplete;
var bool bCheckingForFragmentation;
var bool bCheckingForMemLeaks;
var bool bDoingASentinelRun;
var transient bool bSentinelStreamingLevelStillLoading;
var int AutomatedPerfRemainingTime;
var int AutomatedTestingMapIndex;
var globalconfig array<config string> AutomatedMapTestingList;
var globalconfig int NumAutomatedMapTestingCycles;
var int NumberOfMatchesPlayed;
var int NumMapListCyclesDone;
var string AutomatedTestingExecCommandToRunAtStartMatch;
var string AutomatedMapTestingTransitionMap;
var string SentinelTaskDescription;
var string SentinelTaskParameter;
var string SentinelTagDesc;
var transient PlayerController SentinelPC;
var transient array<Vector> SentinelTravelArray;
var transient int SentinelNavigationIdx;
var transient int SentinelIdx;
var transient int NumRotationsIncrement;
var transient int TravelPointsIncrement;
var config int NumMinutesPerMap;
var config array<config string> CommandsToRunAtEachTravelTheWorldNode;
var transient string CommandStringToExec;

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	SetTimer(1.0000000, true);
	//return;	
}

event Timer()
{
	// End:0x63
	if((bAutomatedPerfTesting && AutomatedPerfRemainingTime > 0) && !bAutoContinueToNextRound)
	{
		AutomatedPerfRemainingTime--;
		// End:0x63
		if(AutomatedPerfRemainingTime <= 0)
		{			
			ConsoleCommand("EXIT");
		}
	}
	//return;	
}

function InitializeOptions(string Options)
{
	local string InOpt;

	AutomatedPerfRemainingTime = 60 * WorldInfo.Game.TimeLimit;
	bAutomatedPerfTesting = (WorldInfo.Game.ParseOption(Options, "AutomatedPerfTesting") ComplementEqual "1") || WorldInfo.Game.ParseOption(Options, "gAPT") ComplementEqual "1";
	bCheckingForFragmentation = (WorldInfo.Game.ParseOption(Options, "CheckingForFragmentation") ComplementEqual "1") || WorldInfo.Game.ParseOption(Options, "gCFF") ComplementEqual "1";
	bCheckingForMemLeaks = (WorldInfo.Game.ParseOption(Options, "CheckingForMemLeaks") ComplementEqual "1") || WorldInfo.Game.ParseOption(Options, "gCFML") ComplementEqual "1";
	bDoingASentinelRun = (WorldInfo.Game.ParseOption(Options, "DoingASentinelRun") ComplementEqual "1") || WorldInfo.Game.ParseOption(Options, "gDASR") ComplementEqual "1";
	SentinelTaskDescription = WorldInfo.Game.ParseOption(Options, "SentinelTaskDescription");
	// End:0x3C0
	if(SentinelTaskDescription == "")
	{
		SentinelTaskDescription = WorldInfo.Game.ParseOption(Options, "gSTD");
	}
	SentinelTaskParameter = WorldInfo.Game.ParseOption(Options, "SentinelTaskParameter");
	// End:0x47B
	if(SentinelTaskParameter == "")
	{
		SentinelTaskParameter = WorldInfo.Game.ParseOption(Options, "gSTP");
	}
	SentinelTagDesc = WorldInfo.Game.ParseOption(Options, "SentinelTagDesc");
	// End:0x531
	if(SentinelTagDesc == "")
	{
		SentinelTagDesc = WorldInfo.Game.ParseOption(Options, "gSTDD");
	}
	InOpt = WorldInfo.Game.ParseOption(Options, "AutoContinueToNextRound");
	// End:0x5E4
	if(InOpt != "")
	{
		LogInternal("AutoContinueToNextRound: " $ string(bool(InOpt)));
		bAutoContinueToNextRound = bool(InOpt);
	}
	InOpt = WorldInfo.Game.ParseOption(Options, "bUsingAutomatedTestingMapList");
	// End:0x6A3
	if(InOpt != "")
	{
		LogInternal("bUsingAutomatedTestingMapList: " $ string(bool(InOpt)));
		bUsingAutomatedTestingMapList = bool(InOpt);
	}
	// End:0x722
	if(bUsingAutomatedTestingMapList)
	{
		// End:0x722
		if(AutomatedMapTestingList.Length == 0)
		{
			LogInternal("*** No maps in automated test map list... Disabling bUsingAutomatedTestingMapList");
			bUsingAutomatedTestingMapList = false;
		}
	}
	InOpt = WorldInfo.Game.ParseOption(Options, "bAutomatedTestingWithOpen");
	// End:0x7D9
	if(InOpt != "")
	{
		LogInternal("bAutomatedTestingWithOpen: " $ string(bool(InOpt)));
		bAutomatedTestingWithOpen = bool(InOpt);
	}
	AutomatedTestingExecCommandToRunAtStartMatch = WorldInfo.Game.ParseOption(Options, "AutomatedTestingExecCommandToRunAtStartMatch");
	LogInternal("AutomatedTestingExecCommandToRunAtStartMatch: " $ AutomatedTestingExecCommandToRunAtStartMatch);
	AutomatedMapTestingTransitionMap = WorldInfo.Game.ParseOption(Options, "AutomatedMapTestingTransitionMap");
	LogInternal("AutomatedMapTestingTransitionMap: " $ AutomatedMapTestingTransitionMap);
	InOpt = WorldInfo.Game.ParseOption(Options, "AutomatedTestingMapIndex");
	// End:0x9DB
	if(InOpt != "")
	{
		LogInternal("AutomatedTestingMapIndex: " $ string(int(InOpt)));
		AutomatedTestingMapIndex = int(InOpt);
	}
	// End:0xB45
	if(bAutomatedTestingWithOpen)
	{
		InOpt = WorldInfo.Game.ParseOption(Options, "NumberOfMatchesPlayed");
		// End:0xA96
		if(InOpt != "")
		{
			LogInternal("NumberOfMatchesPlayed: " $ string(int(InOpt)));
			NumberOfMatchesPlayed = int(InOpt);
		}
		InOpt = WorldInfo.Game.ParseOption(Options, "NumMapListCyclesDone");
		// End:0xB42
		if(InOpt != "")
		{
			LogInternal("NumMapListCyclesDone: " $ string(int(InOpt)));
			NumMapListCyclesDone = int(InOpt);
		}		
	}
	else
	{
		LogInternal("*** Disabling automated transition map for ServerTravel");
		AutomatedMapTestingTransitionMap = "";
	}
	//return;	
}

// Export UAutoTestManager::execBeginSentinelRun(FFrame&, void* const)
native function BeginSentinelRun(const string TaskDescription, const string TaskParameter, const string TagDesc);

// Export UAutoTestManager::execAddSentinelPerTimePeriodStats(FFrame&, void* const)
native function AddSentinelPerTimePeriodStats(const Vector InLocation, const Rotator InRotation);

// Export UAutoTestManager::execEndSentinelRun(FFrame&, void* const)
native function EndSentinelRun(Object.EAutomatedRunResult RunResult);

function DoTravelTheWorld()
{
	GotoState('TravelTheWorld');
	//return;	
}

// Export UAutoTestManager::execDoSentinelActionPerLoadedMap(FFrame&, void* const)
native function DoSentinelActionPerLoadedMap();

// Export UAutoTestManager::execHandlePerLoadedMapAudioStats(FFrame&, void* const)
native function HandlePerLoadedMapAudioStats();

// Export UAutoTestManager::execGetTravelLocations(FFrame&, void* const)
native function GetTravelLocations(name LevelName, PlayerController PC, out array<Vector> TravelPoints);

// Export UAutoTestManager::execDoSentinel_MemoryAtSpecificLocation(FFrame&, void* const)
native function DoSentinel_MemoryAtSpecificLocation(const Vector InLocation, const Rotator InRotation);

// Export UAutoTestManager::execDoSentinel_PerfAtSpecificLocation(FFrame&, void* const)
native function DoSentinel_PerfAtSpecificLocation(const out Vector InLocation, const out Rotator InRotation);

// Export UAutoTestManager::execDoSentinel_ViewDependentMemoryAtSpecificLocation(FFrame&, void* const)
native function DoSentinel_ViewDependentMemoryAtSpecificLocation(const out Vector InLocation, const out Rotator InRotation);

function DoTimeBasedSentinelStatGathering()
{
	local PlayerController PC;
	local Vector ViewLocation;
	local Rotator ViewRotation;

	// End:0x23
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x23
		break;		
	}	
	PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
	// End:0xF7
	if((SentinelTaskDescription != "FlyThrough") && SentinelTaskDescription != "FlyThroughSplitScreen")
	{
		// End:0xF7
		if(PC.Pawn != none)
		{
			ViewLocation = PC.Pawn.Location;
		}
	}
	AddSentinelPerTimePeriodStats(ViewLocation, ViewRotation);
	//return;	
}

// Export UAutoTestManager::execDoMemoryTracking(FFrame&, void* const)
native function DoMemoryTracking();

event StartAutomatedMapTestTimer()
{
	SetTimer(5.0000000, true, 'StartAutomatedMapTestTimerWorker');
	//return;	
}

function StartAutomatedMapTestTimerWorker()
{
	local int LevelIdx;

	// End:0xDD
	if(WorldInfo != none)
	{
		LevelIdx = 0;
		J0x1A:

		// End:0xC6 [Loop If]
		if(LevelIdx < WorldInfo.StreamingLevels.Length)
		{
			// End:0xB8
			if(WorldInfo.StreamingLevels[LevelIdx].bHasLoadRequestPending == true)
			{
				LogInternal("levels not streamed in yet sleeping 5s");
				return;
			}
			++LevelIdx;
			// [Loop Continue]
			goto J0x1A;
		}
		// End:0xDD
		if(bCheckingForMemLeaks)
		{
			DoMemoryTracking();
		}
	}
	ClearTimer('StartAutomatedMapTestTimerWorker');
	SetTimer(15.0000000, false, 'CloseAutomatedMapTestTimer');
	//return;	
}

function CloseAutomatedMapTestTimer()
{
	// End:0x57
	if(Len(AutomatedMapTestingTransitionMap) > 0)
	{
		// End:0x54
		if(AutomatedTestingMapIndex < 0)
		{
			WorldInfo.Game.RestartGame();
		}		
	}
	else
	{
		WorldInfo.Game.RestartGame();
	}
	//return;	
}

function IncrementAutomatedTestingMapIndex()
{
	// End:0xCB
	if(bUsingAutomatedTestingMapList == true)
	{
		// End:0x61
		if(bAutomatedTestingWithOpen == true)
		{
			LogInternal((("  NumMapListCyclesDone: " $ string(NumMapListCyclesDone)) $ " / ") $ string(NumAutomatedMapTestingCycles));			
		}
		else
		{
			// End:0x7B
			if(AutomatedTestingMapIndex >= 0)
			{
				AutomatedTestingMapIndex++;
			}
		}
		LogInternal((("  NextIncrementAutomatedTestingMapIndex: " $ string(AutomatedTestingMapIndex)) $ " / ") $ string(AutomatedMapTestingList.Length));
	}
	//return;	
}

function IncrementNumberOfMatchesPlayed()
{
	LogInternal("  Num Matches Played: " $ string(NumberOfMatchesPlayed));
	NumberOfMatchesPlayed++;
	//return;	
}

function string GetNextAutomatedTestingMap()
{
	local string MapName;
	local PlayerController PC;
	local bool bResetMapIndex;

	// End:0x310
	if(bUsingAutomatedTestingMapList)
	{
		// End:0x62
		if((AutomatedTestingMapIndex >= 0) && Len(AutomatedMapTestingTransitionMap) > 0)
		{
			AutomatedTestingMapIndex++;
			AutomatedTestingMapIndex *= float(-1);
			MapName = AutomatedMapTestingTransitionMap;			
		}
		else
		{
			// End:0x85
			if(Len(AutomatedMapTestingTransitionMap) > 0)
			{
				AutomatedTestingMapIndex *= float(-1);
			}
			// End:0xBF
			if(AutomatedTestingMapIndex >= AutomatedMapTestingList.Length)
			{
				AutomatedTestingMapIndex = 0;
				NumMapListCyclesDone++;
				bResetMapIndex = true;
			}
			MapName = AutomatedMapTestingList[AutomatedTestingMapIndex];
		}
		// End:0x182
		if(bAutomatedTestingWithOpen == true)
		{
			// End:0x17F
			if((NumMapListCyclesDone >= NumAutomatedMapTestingCycles) && NumAutomatedMapTestingCycles != 0)
			{
				// End:0x158
				if(bCheckingForMemLeaks)
				{					
					ConsoleCommand("DEFERRED_STOPMEMTRACKING_AND_DUMP");
				}
				// End:0x17F
				if(bExitOnCyclesComplete)
				{					
					ConsoleCommand("EXIT");
				}
			}			
		}
		else
		{
			// End:0x2DC
			foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x20B
				if(bResetMapIndex)
				{
					PC.PlayerReplicationInfo.AutomatedTestingData.NumMapListCyclesDone++;
				}
				// End:0x2DB
				if((PC.PlayerReplicationInfo.AutomatedTestingData.NumMapListCyclesDone >= NumAutomatedMapTestingCycles) && NumAutomatedMapTestingCycles != 0)
				{
					// End:0x2B4
					if(bCheckingForMemLeaks)
					{						
						ConsoleCommand("DEFERRED_STOPMEMTRACKING_AND_DUMP");
					}
					// End:0x2DB
					if(bExitOnCyclesComplete)
					{						
						ConsoleCommand("EXIT");
					}
				}				
			}			
		}
		LogInternal("NextAutomatedTestingMap: " $ MapName);
		return MapName;
	}
	return "";
	//return ReturnValue;	
}

function StartMatch()
{
	local PlayerController PC;

	// End:0x1A
	if(bAutomatedTestingWithOpen)
	{
		IncrementNumberOfMatchesPlayed();		
	}
	else
	{
		// End:0x71
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
		{
			PC.IncrementNumberOfMatchesPlayed();
			// End:0x71
			break;			
		}		
	}
	IncrementAutomatedTestingMapIndex();
	// End:0xAB
	if(bCheckingForFragmentation)
	{		
		ConsoleCommand("MemFragCheck");
	}
	// End:0x116
	if(AutomatedTestingExecCommandToRunAtStartMatch != "")
	{
		LogInternal("AutomatedTestingExecCommandToRunAtStartMatch: " $ AutomatedTestingExecCommandToRunAtStartMatch);		
		ConsoleCommand(AutomatedTestingExecCommandToRunAtStartMatch);
	}
	//return;	
}

function bool CheckForSentinelRun()
{
	// End:0xC4
	if(bDoingASentinelRun)
	{
		LogInternal("DoingASentinelRun! task " $ SentinelTaskDescription);
		// End:0x8C
		if(SentinelTaskDescription ComplementEqual "TravelTheWorld")
		{
			WorldInfo.Game.DoTravelTheWorld();
			return true;			
		}
		else
		{
			BeginSentinelRun(SentinelTaskDescription, SentinelTaskParameter, SentinelTagDesc);
			SetTimer(3.0000000, true, 'DoTimeBasedSentinelStatGathering');
		}
	}
	return false;
	//return ReturnValue;	
}

state TravelTheWorld
{
	function BeginState(name PreviousStateName)
	{
		local PlayerController PC;

		LogInternal("BeginState TravelTheWorld");
		super(Object).BeginState(PreviousStateName);
		// End:0x86
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			SentinelPC = PC;
			SentinelPC.Sentinel_SetupForGamebasedTravelTheWorld();
			// End:0x86
			break;			
		}		
		SentinelPC.bIsUsingStreamingVolumes = false;
		BeginSentinelRun(SentinelTaskDescription, SentinelTaskParameter, SentinelTagDesc);
		//return;		
	}

	function float CalcTravelTheWorldTime(const int NumTravelLocations, const int NumRotations)
	{
		local float TotalTimeInSeconds, PerTravelLocTime;

		TotalTimeInSeconds += (float(WorldInfo.StreamingLevels.Length) * 2.0000000);
		TotalTimeInSeconds += 10.0000000;
		TotalTimeInSeconds += (float(WorldInfo.StreamingLevels.Length) * 10.0000000);
		TotalTimeInSeconds += 10.0000000;
		TotalTimeInSeconds += 10.0000000;
		PerTravelLocTime = (((((0.5000000 + 4.0000000) + 1.0000000) + 0.5000000) + 1.0000000) + (float(NumRotations) * 1.5000000)) + (float(NumRotations) * 1.5000000);
		TotalTimeInSeconds += (PerTravelLocTime * float(NumTravelLocations));
		return TotalTimeInSeconds;
		//return ReturnValue;		
	}

	function PrintOutTravelWorldTimes(const int TotalTimeInSeconds)
	{
		local int Hours, Minutes, Seconds;

		Hours = TotalTimeInSeconds / (60 * 60);
		Minutes = (TotalTimeInSeconds - ((Hours * 60) * 60)) / 60;
		Seconds = (TotalTimeInSeconds - (Minutes * 60)) - ((Hours * 60) * 60);
		LogInternal((((((((WorldInfo.GetMapName() $ ": Traveling this map will take approx TotalSeconds: ") $ string(TotalTimeInSeconds)) $ "   Hours: ") $ string(Hours)) $ "  Minutes: ") $ string(Minutes)) $ "  Seconds: ") $ string(Seconds));
		//return;		
	}

	function SetIncrementsForLoops(const float NumTravelLocations)
	{
		local float TimeWeGetInSeconds;

		TimeWeGetInSeconds = float(NumMinutesPerMap * 60);
		// End:0x130
		if((CalcTravelTheWorldTime(int(NumTravelLocations), 8)) < TimeWeGetInSeconds)
		{
			TravelPointsIncrement = 1;
			NumRotationsIncrement = 1;
			LogInternal((((((WorldInfo.GetMapName() $ " SetIncrementsForLoops: TravelPointsIncrement: ") $ string(TravelPointsIncrement)) $ " NumRotationsIncrement: ") $ string(NumRotationsIncrement)) $ " for NumTravelLocations: ") $ string(NumTravelLocations));
			PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations), 8)));			
		}
		else
		{
			// End:0x248
			if((CalcTravelTheWorldTime(int(NumTravelLocations), 4)) < TimeWeGetInSeconds)
			{
				TravelPointsIncrement = 1;
				NumRotationsIncrement = 2;
				LogInternal((((((WorldInfo.GetMapName() $ " SetIncrementsForLoops: TravelPointsIncrement: ") $ string(TravelPointsIncrement)) $ " NumRotationsIncrement: ") $ string(NumRotationsIncrement)) $ " for NumTravelLocations: ") $ string(NumTravelLocations));
				PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations), 4)));				
			}
			else
			{
				TravelPointsIncrement = int((CalcTravelTheWorldTime(int(NumTravelLocations), 4)) / TimeWeGetInSeconds);
				NumRotationsIncrement = 2;
				LogInternal((((((WorldInfo.GetMapName() $ " SetIncrementsForLoops: TravelPointsIncrement: ") $ string(TravelPointsIncrement)) $ " NumRotationsIncrement: ") $ string(NumRotationsIncrement)) $ " for NumTravelLocations: ") $ string(NumTravelLocations));
				PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations / float(TravelPointsIncrement)), 4)));
			}
		}
		//return;		
	}
Begin:

	SentinelPC.Sentinel_PreAcquireTravelTheWorldPoints();
	SentinelIdx = 0;
	J0x2A:

	// End:0x11A [Loop If]
	if(SentinelIdx < WorldInfo.StreamingLevels.Length)
	{
		LogInternal("StreamLevelOut: " $ string(WorldInfo.StreamingLevels[SentinelIdx].PackageName));
		SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, false, false, true);
		++SentinelIdx;
		// [Loop Continue]
		goto J0x2A;
	}
	Sleep(10.0000000);
	WorldInfo.ForceGarbageCollection(true);
	SentinelIdx = 0;
	J0x14D:

	// End:0x421 [Loop If]
	if(SentinelIdx < WorldInfo.StreamingLevels.Length)
	{
		LogInternal("Gathering locations for: " $ string(WorldInfo.StreamingLevels[SentinelIdx].PackageName));
		SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, true, true, true);
		Sleep(7.0000000);
		GetTravelLocations(WorldInfo.StreamingLevels[SentinelIdx].PackageName, SentinelPC, SentinelTravelArray);
		DoSentinelActionPerLoadedMap();		
		SentinelPC.ConsoleCommand("FractureAllMeshesToMaximizeMemoryUsage");		
		SentinelPC.ConsoleCommand("stat memory");
		Sleep(0.5000000);
		DoSentinel_MemoryAtSpecificLocation(vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));		
		SentinelPC.ConsoleCommand("stat memory");
		SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, false, false, true);
		Sleep(3.0000000);
		WorldInfo.ForceGarbageCollection(true);
		++SentinelIdx;
		// [Loop Continue]
		goto J0x14D;
	}
	// End:0x5BA
	if(WorldInfo.StreamingLevels.Length == 0)
	{
		GetTravelLocations(WorldInfo.StreamingLevels[SentinelIdx].PackageName, SentinelPC, SentinelTravelArray);
		DoSentinelActionPerLoadedMap();		
		SentinelPC.ConsoleCommand("FractureAllMeshesToMaximizeMemoryUsage");		
		SentinelPC.ConsoleCommand("stat memory");
		Sleep(0.5000000);
		DoSentinel_MemoryAtSpecificLocation(vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));		
		SentinelPC.ConsoleCommand("stat memory");
		Sleep(3.0000000);
		WorldInfo.ForceGarbageCollection(true);
	}
	LogInternal((WorldInfo.GetMapName() $ " COMPLETED LEVEL INTEROGATION!! Total TravelPoints: ") $ string(SentinelTravelArray.Length));
	SetIncrementsForLoops(float(SentinelTravelArray.Length));
	SentinelIdx = 0;
	J0x644:

	// End:0x780 [Loop If]
	if(SentinelIdx < WorldInfo.StreamingLevels.Length)
	{
		// End:0x772
		if(LevelStreamingAlwaysLoaded(WorldInfo.StreamingLevels[SentinelIdx]) != none)
		{
			LogInternal("   Found a LevelStreamingAlwaysLoaded" @ string(WorldInfo.StreamingLevels[SentinelIdx].PackageName));
			SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, true, true, true);
		}
		++SentinelIdx;
		// [Loop Continue]
		goto J0x644;
	}
	SentinelPC.bIsUsingStreamingVolumes = true;
	Sleep(10.0000000);
	SentinelPC.Sentinel_PostAcquireTravelTheWorldPoints();
	Sleep(10.0000000);
	SentinelTravelArray.AddItem(SentinelTravelArray[0]);
	LogInternal("Starting Traversal");
	LogInternal("   SentinelTravelArray.length " $ string(SentinelTravelArray.Length));
	SentinelNavigationIdx = 0;
	J0x83B:

	// End:0xDA5 [Loop If]
	if(SentinelNavigationIdx < SentinelTravelArray.Length)
	{
		LogInternal(((("Going to:" @ string(SentinelTravelArray[SentinelNavigationIdx])) @ string(SentinelNavigationIdx)) $ " of ") $ string(SentinelTravelArray.Length));
		SentinelPC.SetLocation(SentinelTravelArray[SentinelNavigationIdx]);
		SentinelPC.SetRotation(rot(0, 0, 0));
		Sleep(0.5000000);
		J0x8F3:

		bSentinelStreamingLevelStillLoading = false;
		SentinelIdx = 0;
		J0x90A:

		// End:0x9CB [Loop If]
		if(SentinelIdx < WorldInfo.StreamingLevels.Length)
		{
			// End:0x9BD
			if(WorldInfo.StreamingLevels[SentinelIdx].bHasLoadRequestPending == true)
			{
				LogInternal("levels not streamed in yet sleeping 1s");
				bSentinelStreamingLevelStillLoading = true;
				Sleep(1.0000000);
				// [Explicit Break]
				goto J0x9CB;
			}
			++SentinelIdx;
			// [Loop Continue]
			goto J0x90A;
		}
		J0x9CB:

		// End:0x8F3
		if(!(bSentinelStreamingLevelStillLoading == false))
			goto J0x8F3;
		WorldInfo.ForceGarbageCollection(true);
		Sleep(1.0000000);
		// End:0xA34
		if(SentinelNavigationIdx == 0)
		{			
			ConsoleCommand("MemLeakCheck");
		}		
		SentinelPC.ConsoleCommand("stat memory");
		Sleep(0.5000000);
		DoSentinel_MemoryAtSpecificLocation(SentinelPC.Location, SentinelPC.Rotation);		
		SentinelPC.ConsoleCommand("stat memory");		
		SentinelPC.ConsoleCommand("stat scenerendering");		
		SentinelPC.ConsoleCommand("stat streaming");
		Sleep(1.0000000);
		SentinelIdx = 0;
		J0xB78:

		// End:0xC27 [Loop If]
		if(SentinelIdx < 8)
		{
			SentinelPC.SetRotation(rot(0, 1, 0) * float(8192 * SentinelIdx));
			Sleep(1.5000000);
			DoSentinel_ViewDependentMemoryAtSpecificLocation(SentinelPC.Location, SentinelPC.Rotation);
			SentinelIdx += NumRotationsIncrement;
			// [Loop Continue]
			goto J0xB78;
		}		
		SentinelPC.ConsoleCommand("stat scenerendering");		
		SentinelPC.ConsoleCommand("stat streaming");
		SentinelIdx = 0;
		J0xCA9:

		// End:0xD58 [Loop If]
		if(SentinelIdx < 8)
		{
			SentinelPC.SetRotation(rot(0, 1, 0) * float(8192 * SentinelIdx));
			Sleep(1.5000000);
			DoSentinel_PerfAtSpecificLocation(SentinelPC.Location, SentinelPC.Rotation);
			SentinelIdx += NumRotationsIncrement;
			// [Loop Continue]
			goto J0xCA9;
		}
		// End:0xD8D
		foreach CommandsToRunAtEachTravelTheWorldNode(CommandStringToExec)
		{			
			ConsoleCommand(CommandStringToExec);			
		}		
		SentinelNavigationIdx += TravelPointsIncrement;
		// [Loop Continue]
		goto J0x83B;
	}	
	ConsoleCommand("MemLeakCheck");
	LogInternal("COMPLETED!!!!!!!");	
	ConsoleCommand("exit");
	stop;		
}

state SentinelHandleCauseEventCommand
{	J0x00:
	bSentinelStreamingLevelStillLoading = false;
	SentinelIdx = 0;
	J0x17:

	// End:0xD8 [Loop If]
	if(SentinelIdx < WorldInfo.StreamingLevels.Length)
	{
		// End:0xCA
		if(WorldInfo.StreamingLevels[SentinelIdx].bHasLoadRequestPending == true)
		{
			LogInternal("levels not streamed in yet sleeping 1s");
			bSentinelStreamingLevelStillLoading = true;
			Sleep(1.0000000);
			// [Explicit Break]
			goto J0xD8;
		}
		++SentinelIdx;
		// [Loop Continue]
		goto J0x17;
	}
	J0xD8:

	// End:0x00
	if(!(bSentinelStreamingLevelStillLoading == false))
		goto J0x00;
	// End:0x1BE
	if(WorldInfo.Game.CauseEventCommand != "")
	{
		// End:0x1BD
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', SentinelPC)
		{			
			SentinelPC.ConsoleCommand("ce " $ WorldInfo.Game.CauseEventCommand);
			// End:0x1BD
			break;			
		}		
	}
	// End:0x212
	if((SentinelTaskDescription == "FlyThrough") || SentinelTaskDescription == "FlyThroughSplitScreen")
	{
		SetTimer(0.5000000, true, 'DoTimeBasedSentinelStatGathering');
	}
	stop;		
}

defaultproperties
{
	NumMinutesPerMap=50
}