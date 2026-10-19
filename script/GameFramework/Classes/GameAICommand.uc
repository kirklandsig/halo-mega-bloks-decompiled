class GameAICommand extends AICommandBase within GameAIController
	abstract
	native;

var const editinline transient GameAICommand ChildCommand;
var const transient name ChildStatus;
var transient GameAIController GameAIOwner;
var transient name Status;
var bool bAllowNewSameClassInstance;
var bool bReplaceActiveSameClassInstance;
var private transient bool bAborted;
var bool bIgnoreNotifies;
var bool bIgnoreStepAside;
var private transient bool bPendingPop;

static function bool InitCommandUserActor(GameAIController AI, Actor UserActor)
{
	return InitCommand(AI);
	//return ReturnValue;	
}

static function bool InitCommand(GameAIController AI)
{
	local GameAICommand Cmd;

	// End:0x68
	if(AI != none)
	{
		Cmd = new (AI) default.Class;
		// End:0x68
		if(Cmd != none)
		{
			AI.PushCommand(Cmd);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

final event InternalPrePushed(GameAIController AI)
{
	GameAIOwner = AI;
	PrePushed(AI);
	//return;	
}

final event InternalPushed()
{
	GotoState('Auto');
	Pushed();
	//return;	
}

event InternalPopped()
{
	Popped();
	GameAIOwner = none;
	PostPopped();
	//return;	
}

final event InternalPaused(GameAICommand NewCommand)
{
	Paused(NewCommand);
	//return;	
}

final event InternalResumed(name OldCommandName)
{
	Resumed(OldCommandName);
	//return;	
}

final event InternalTick(float DeltaTime)
{
	Tick(DeltaTime);
	//return;	
}

// Export UGameAICommand::execShouldIgnoreNotifies(FFrame&, void* const)
native final function bool ShouldIgnoreNotifies();

function Tick(float DeltaTime)
{
	//return;	
}

function bool AllowTransitionTo(Class<GameAICommand> AttemptCommand)
{
	return (ChildCommand == none) || ChildCommand.AllowTransitionTo(AttemptCommand);
	//return ReturnValue;	
}

function bool AllowStateTransitionTo(name StateName)
{
	return (ChildCommand == none) || ChildCommand.AllowStateTransitionTo(StateName);
	//return ReturnValue;	
}

function PrePushed(GameAIController AI)
{
	//return;	
}

function PostPopped()
{
	//return;	
}

function Pushed()
{
	// End:0x71
	if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
	{
		Outer.AILog_Internal("COMMAND PUSHED:" @ string(self));
	}
	//return;	
}

function Popped()
{
	// End:0x86
	if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
	{
		Outer.AILog_Internal((("COMMAND POPPED:" @ string(self)) @ "with") @ string(Status));
	}
	//return;	
}

function Paused(GameAICommand NewCommand)
{
	// End:0x84
	if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
	{
		Outer.AILog_Internal((("COMMAND PAUSED:" @ string(self)) @ "by") @ string(NewCommand));
	}
	//return;	
}

function Resumed(name OldCommandName)
{
	// End:0x9C
	if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
	{
		Outer.AILog_Internal((((("COMMAND RESUMED:" @ string(self)) @ "from") @ string(OldCommandName)) @ "with") @ string(ChildStatus));
	}
	//return;	
}

event string GetDumpString()
{
	return string(self);
	//return ReturnValue;	
}

event DrawDebug(HUD H, name Category)
{
	//return;	
}

function GetDebugOverheadText(PlayerController PC, out array<string> OutText)
{
	//return;	
}

event string GetDebugVerboseText()
{
	//return ReturnValue;	
}

function NotifyNeedRepath()
{
	//return;	
}

function bool MoveUnreachable(Vector AttemptedDest, Actor AttemptedTarget)
{
	//return ReturnValue;	
}

function bool HandlePathObstruction(Actor BlockedBy)
{
	// End:0x38
	if(ChildCommand != none)
	{
		return ChildCommand.HandlePathObstruction(BlockedBy);
	}
	return false;
	//return ReturnValue;	
}

state DebugState
{
	function BeginState(name PreviousStateName)
	{
		// End:0x7C
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("BEGINSTATE" @ string(PreviousStateName), 'State');
		}
		//return;		
	}

	function EndState(name NextStateName)
	{
		// End:0x7A
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("ENDSTATE" @ string(NextStateName), 'State');
		}
		//return;		
	}

	function PushedState()
	{
		// End:0x6B
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("PUSHED", 'State');
		}
		//return;		
	}

	function PoppedState()
	{
		// End:0x6B
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("POPPED", 'State');
		}
		//return;		
	}

	function ContinuedState()
	{
		// End:0x6E
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("CONTINUED", 'State');
		}
		//return;		
	}

	function PausedState()
	{
		// End:0x6B
		if(!Class'Engine.Engine'.static.GetEngine().bDisableAILogging)
		{
			Outer.AILog_Internal("PAUSED", 'State');
		}
		//return;		
	}
	stop;	
}

state DelayFailure extends DebugState
{Begin:

	Outer.Sleep(0.5000000);
	Status = 'Failure';
	Outer.PopCommand(self);
	stop;				
}

state DelaySuccess extends DebugState
{Begin:

	Outer.Sleep(0.1000000);
	Status = 'Success';
	Outer.PopCommand(self);
	stop;				
}
