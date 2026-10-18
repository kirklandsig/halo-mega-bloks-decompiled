class GFxUI_PauseMenu extends UTGFxTweenableMoviePlayer
	config(UI);

var const localized string ResumeString;
var const localized string ExitString;

function bool Start(optional bool StartPaused = false)
{
	super(GFxMoviePlayer).Start();
	Advance(0.0000000);
	return true;
	//return ReturnValue;	
}

function OnPressResumeButton(EventData ev)
{
	PlayCloseAnimation();
	//return;	
}

function OnPressExitButton(EventData ev)
{
	UTPlayerController(GetPC()).QuitToMainMenu();
	//return;	
}

function PlayOpenAnimation()
{
	//return;	
}

function PlayCloseAnimation()
{
	//return;	
}

function OnPlayAnimationComplete()
{
	//return;	
}

function OnCloseAnimationComplete()
{
	UTHUDBase(GetPC().myHUD).CompletePauseMenuClose();
	//return;	
}

final function UT_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
	GetPC().Player.Actor.ConsoleCommand(Cmd, bWriteToLog);
	//return;	
}

defaultproperties
{
	ResumeString="RESUME"
	ExitString="EXIT"
	bPauseGameWhileActive=true
	bCaptureInput=true
}