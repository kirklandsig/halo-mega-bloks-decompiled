class GFxUIFrontEnd_TitleScreen extends GFxMoviePlayer
	config(UI);

enum MenuButtonsType
{
	MENU_BTN_CAMPAIGN,              // 0
	MENU_BTN_INSTANTACTION,         // 1
	MENU_BTN_MULTIPLAYER,           // 2
	MENU_BTN_COMMUNITY,             // 3
	MENU_BTN_SETTINGS,              // 4
	MENU_BTN_EXIT,                  // 5
	MENU_BTN_LOGOUT,                // 6
	MENU_BTN_SELECT,                // 7
	MENU_BTN_MAX                    // 8
};

var GFxObject TitleScreenMC;
var GFxObject MainMenuMC;
var GFxObject MenuButtonsMC;
var GFxObject BlackMC;
var GFxClikWidget MenuBtn1MC;
var GFxClikWidget MenuBtn2MC;
var GFxClikWidget MenuBtn3MC;
var GFxClikWidget MenuBtn4MC;
var GFxClikWidget MenuBtn5MC;
var GFxClikWidget MenuBtn6MC;
var string InstantActionMap;
var string CampaignMap;
var byte Selection;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0.0000000);
	TitleScreenMC = GetVariableObject("_root");
	MainMenuMC = TitleScreenMC.GetObject("mainMenu");
	BlackMC = TitleScreenMC.GetObject("black");
	MenuButtonsMC = MainMenuMC.GetObject("menu");
	MenuBtn1MC = GFxClikWidget(MenuButtonsMC.GetObject("menubtn1").GetObject("menuBtn1", Class'GFxUI.GFxClikWidget'));
	MenuBtn1MC.SetFloat("data", float(0));
	MenuBtn2MC = GFxClikWidget(MenuButtonsMC.GetObject("menubtn2").GetObject("menuBtn2", Class'GFxUI.GFxClikWidget'));
	MenuBtn2MC.SetFloat("data", float(1));
	MenuBtn3MC = GFxClikWidget(MenuButtonsMC.GetObject("menubtn3").GetObject("menuBtn3", Class'GFxUI.GFxClikWidget'));
	MenuBtn3MC.SetFloat("data", float(2));
	MenuBtn4MC = GFxClikWidget(MenuButtonsMC.GetObject("menubtn4").GetObject("menuBtn4", Class'GFxUI.GFxClikWidget'));
	MenuBtn4MC.SetFloat("data", float(3));
	MenuBtn5MC = GFxClikWidget(MenuButtonsMC.GetObject("menubtn5").GetObject("menuBtn5", Class'GFxUI.GFxClikWidget'));
	MenuBtn5MC.SetFloat("data", float(4));
	MenuBtn6MC = GFxClikWidget(MenuButtonsMC.GetObject("menubtn6").GetObject("menuBtn6", Class'GFxUI.GFxClikWidget'));
	MenuBtn6MC.SetFloat("data", float(5));
	MenuBtn1MC.AddEventListener('CLIK_press', OnMenuButtonPress);
	MenuBtn2MC.AddEventListener('CLIK_press', OnMenuButtonPress);
	MenuBtn6MC.AddEventListener('CLIK_press', OnMenuButtonPress);
	return true;
	//return ReturnValue;	
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
	return false;
	//return ReturnValue;	
}

function OnMenuButtonPress(EventData ev)
{
	Selection = byte(ev.Target.GetFloat("data"));
	PlayCloseAnimation();
	//return;	
}

function PlayCloseAnimation()
{
	BlackMC.GotoAndPlay("open");
	//return;	
}

function OnCloseAnimationComplete()
{
	switch(Selection)
	{
		// End:0x68
		case 0:
			UT_ConsoleCommand(("open " $ CampaignMap) $ "?game=UTGameContent.UTVehicleCTFGame_Content", true);
			// End:0xC7
			break;
		// End:0xA8
		case 1:
			UT_ConsoleCommand(("open " $ InstantActionMap) $ "?game=UTGame.UTTeamGame", true);
			// End:0xC7
			break;
		// End:0xC1
		case 5:
			UT_ConsoleCommand("quit", true);
			// End:0xC7
			break;
		// End:0xFFFF
		default:
			// End:0xC7
			break;
			break;
	}
	//return;	
}

final function UT_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
	GetPC().Player.Actor.ConsoleCommand(Cmd, bWriteToLog);
	//return;	
}

defaultproperties
{
	InstantActionMap="DM-Deck.udk"
	CampaignMap="VCTF-Sandstorm.udk"
}