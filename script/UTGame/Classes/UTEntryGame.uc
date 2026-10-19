class UTEntryGame extends UTTeamGame
	config(Game);

function bool NeedPlayers()
{
	return false;
	//return ReturnValue;	
}

exec function AddBots(int Num)
{
	//return;	
}

function StartMatch()
{
	//return;	
}

event InitGame(string Options, out string ErrorMessage)
{
	// End:0x88
	if((ParseOption(Options, "PerformUnitTests")) ~= "1")
	{
		// End:0x60
		if(MyAutoTestManager == none)
		{
			MyAutoTestManager = Spawn(AutoTestManagerClass);
		}
		MyAutoTestManager.InitializeOptions(Options);
	}
	//return;	
}

auto state PendingMatch
{
	ignores Timer, RestartPlayer;

	function BeginState(name PreviousStateName)
	{
		bWaitingToStartMatch = true;
		UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
		StartupStage = 0;
		bQuickStart = false;
		//return;		
	}

	function EndState(name NextStateName)
	{
		UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
		//return;		
	}
	stop;	
}

defaultproperties
{
	bExportMenuData=false
	bUseClassicHUD=true
	ConsolePlayerControllerClass=Class'UTGame.UTEntryPlayerController'
	HUDType=Class'UTGame.UTEntryHUD'
	PlayerControllerClass=Class'UTGame.UTEntryPlayerController'
}