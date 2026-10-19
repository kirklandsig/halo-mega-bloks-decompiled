class GameAIController extends GwNavAIController
	abstract
	native
	config(Game)
	dependson(GameTypes);

var const editinline transient GameAICommand CommandList;
var transient bool bHasRunawayCommandList;
var config bool bAILogging;
var config bool bAILogToWindow;
var config bool bFlushAILogEachLine;
var config bool bMapBasedLogName;
var config bool bAIDrawDebug;
var transient bool bAIBroken;
var transient FileLog AILogFile;
var float DebugTextMaxLen;
var const transient array<AICmdHistoryItem> CommandHistory;
var config int CommandHistoryNum;
var config array<config name> AILogFilter;
var string DemoActionString;

replication
{
	// Pos:0x000
	if(bDemoRecording)
		DemoActionString;
}

// Export UGameAIController::execAllCommands(FFrame&, void* const)
native final iterator function AllCommands(Class<GameAICommand> BaseClass, out GameAICommand Cmd);

// Export UGameAIController::execPushCommand(FFrame&, void* const)
native function PushCommand(GameAICommand NewCommand);

// Export UGameAIController::execPopCommand(FFrame&, void* const)
native function PopCommand(GameAICommand ToBePoppedCommand);

// Export UGameAIController::execAbortCommand(FFrame&, void* const)
native function bool AbortCommand(GameAICommand AbortCmd, optional Class<GameAICommand> AbortClass);

// Export UGameAIController::execGetActiveCommand(FFrame&, void* const)
native final function GameAICommand GetActiveCommand();

// Export UGameAIController::execCheckCommandCount(FFrame&, void* const)
native final function CheckCommandCount();

// Export UGameAIController::execDumpCommandStack(FFrame&, void* const)
native final function DumpCommandStack();

// Export UGameAIController::execFindCommandOfClass(FFrame&, void* const)
native final function coerce GameAICommand FindCommandOfClass(Class<GameAICommand> SearchClass);

// Export UGameAIController::execGetAICommandInStack(FFrame&, void* const)
native function GameAICommand GetAICommandInStack(const Class<GameAICommand> InClass);

function float GetDestinationOffset()
{
	//return ReturnValue;	
}

function ReachedMoveGoal()
{
	//return;	
}

function ReachedIntermediateMoveGoal()
{
	//return;	
}

event Destroyed()
{
	super(Controller).Destroyed();
	// End:0x31
	if(AILogFile != none)
	{
		AILogFile.Destroy();
	}
	// End:0x54
	if(CommandList != none)
	{
		AbortCommand(CommandList);
	}
	//return;	
}

protected function RecordDemoAILog(coerce string LogText)
{
	//return;	
}

event AILog_Internal(coerce string LogText, optional name LogCategory, optional bool bForce)
{
	local int Idx;
	local string ActionStr, FinalStr, Filename;
	local GameAICommand ActiveCommand;
	local int FileNameLength;
	local Engine Eng;

	Eng = Class'Engine.Engine'.static.GetEngine();
	// End:0x4F
	if(Eng.bDisableAILogging)
	{
		return;
	}
	// End:0x71
	if(!bForce && !bAILogging)
	{
		return;
	}
	// End:0x97
	if(WorldInfo.IsConsoleBuild(2))
	{
		return;
	}
	// End:0xFA
	if(!bForce)
	{
		Idx = 0;
		J0xB1:

		// End:0xFA [Loop If]
		if(Idx < AILogFilter.Length)
		{
			// End:0xEC
			if(AILogFilter[Idx] == LogCategory)
			{
				return;
			}
			Idx++;
			// [Loop Continue]
			goto J0xB1;
		}
	}
	// End:0x2BF
	if(AILogFile == none)
	{
		AILogFile = Spawn(Class'Engine.FileLog');
		// End:0x18E
		if(bMapBasedLogName)
		{
			Filename = (WorldInfo.GetMapName() $ "_") $ string(self);
			Filename = Repl(Filename, "ai_", "", false);			
		}
		else
		{
			Filename = string(self);
		}
		// End:0x217
		if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild() == true)
		{
			FileNameLength = Len(Filename) + 6;
			// End:0x217
			if(FileNameLength > 40)
			{
				Filename = Right(Filename, 34);
			}
		}
		AILogFile.bKillDuringLevelTransition = true;
		AILogFile.bFlushEachWrite = bFlushAILogEachLine;
		AILogFile.bWantsAsyncWrites = !bFlushAILogEachLine;
		AILogFile.OpenLog(Filename, ".ailog");
	}
	ActionStr = string(GetStateName());
	ActiveCommand = GetActiveCommand();
	// End:0x33C
	if(ActiveCommand != none)
	{
		ActionStr = (string(ActiveCommand.Class) $ ":") $ string(ActiveCommand.GetStateName());
	}
	FinalStr = (((("[" $ string(WorldInfo.TimeSeconds)) $ "]") @ ActionStr) $ ":") @ LogText;
	AILogFile.Logf(FinalStr);
	// End:0x3E8
	if(WorldInfo.IsRecordingDemo())
	{
		RecordDemoAILog(FinalStr);
	}
	// End:0x44A
	if(bAILogToWindow)
	{
		LogInternal((((((string(Pawn) @ "[") $ string(WorldInfo.TimeSeconds)) $ "]") @ ActionStr) $ ":") @ LogText);
	}
	//return;	
}

function SetDesiredRotation(Rotator TargetDesiredRotation, optional bool InLockDesiredRotation = false, optional bool InUnlockWhenReached = false, optional float InterpolationTime = -1.0000000)
{
	// End:0x68
	if(Pawn != none)
	{
		Pawn.SetDesiredRotation(TargetDesiredRotation, InLockDesiredRotation, InUnlockWhenReached, InterpolationTime);
	}
	//return;	
}

final simulated event string GetActionString()
{
	local string ActionStr;
	local GameAICommand ActiveCmd;

	// End:0x2F
	if(WorldInfo.IsPlayingDemo())
	{
		return DemoActionString;		
	}
	else
	{
		ActiveCmd = GetActiveCommand();
		// End:0xA0
		if(ActiveCmd != none)
		{
			ActionStr = (string(ActiveCmd.Class) $ ":") $ string(ActiveCmd.GetStateName());			
		}
		else
		{
			ActionStr = (string(default.Class) $ ":") $ string(GetStateName());
		}
		return ActionStr;
	}
	//return ReturnValue;	
}

state DebugState
{
	function BeginState(name PreviousStateName)
	{
		// End:0x67
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			AILog_Internal("BEGINSTATE" @ string(PreviousStateName), 'State');
		}
		//return;		
	}

	function EndState(name NextStateName)
	{
		// End:0x65
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			AILog_Internal("ENDSTATE" @ string(NextStateName), 'State');
		}
		//return;		
	}

	function PushedState()
	{
		// End:0x56
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			AILog_Internal("PUSHED", 'State');
		}
		//return;		
	}

	function PoppedState()
	{
		// End:0x56
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			AILog_Internal("POPPED", 'State');
		}
		//return;		
	}

	function ContinuedState()
	{
		// End:0x59
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			AILog_Internal("CONTINUED", 'State');
		}
		//return;		
	}

	function PausedState()
	{
		// End:0x56
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			AILog_Internal("PAUSED", 'State');
		}
		//return;		
	}
	stop;	
}
