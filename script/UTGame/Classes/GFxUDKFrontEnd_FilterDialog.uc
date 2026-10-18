class GFxUDKFrontEnd_FilterDialog extends GFxUDKFrontEnd_Dialog within GFxMoviePlayer
	config(UI);

struct Option
{
	var string OptionName;
	var string OptionLabel;
	var array<string> OptionData;

	structdefaultproperties
	{
		OptionName=""
		OptionLabel=""
		OptionData=none
	}
};

var transient UTUIDataStore_StringList StringListDataStore;
var UTDataStore_GameSearchDM SearchDataStore;
var GFxClikWidget FilterListMC;
var bool bFiltersHaveChanged;
var GFxObject DataProvider;
var GFxObject NetworkTypeOptionItem;
var GFxObject GameTypeOptionItem;
var config array<config Option> ListOptions;
//var transient delegate<OnSwitchedGameType> __OnSwitchedGameType__Delegate;

delegate OnSwitchedGameType()
{
	//return;	
}

function OnViewLoaded()
{
	StringListDataStore = UTUIDataStore_StringList(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTStringList'));
	SearchDataStore = UTDataStore_GameSearchDM(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTGameSearch'));
	//return;	
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	bFiltersHaveChanged = false;
	TitleTxt.SetText("SEARCH FILTER");
	BackBtn.SetString("label", "BACK");
	BackBtn.RemoveAllEventListeners("CLIK_press");
	BackBtn.RemoveAllEventListeners("press");
	BackBtn.AddEventListener('CLIK_press', Select_Back);
	SetupListDataProvider();
	MenuManager.ASSetSelectionFocus(FilterListMC);
	ValidateServerType();
	//return;	
}

function OnViewClosed()
{
	super.OnViewClosed();
	DisableSubComponents(false);
	//return;	
}

function DisableSubComponents(bool bEnableComponents)
{
	FilterListMC.SetBool("disabled", bEnableComponents);
	BackBtn.SetBool("disabled", bEnableComponents);
	//return;	
}

function SetBackButtonListener(delegate<EventListener> DelegateListener)
{
	BackBtn.SetString("label", "BACK");
	BackBtn.RemoveAllEventListeners("CLIK_press");
	BackBtn.RemoveAllEventListeners("press");
	BackBtn.AddEventListener('CLIK_press', DelegateListener);
	BackBtn.AddEventListener('CLIK_press', Select_Back);
	//return;	
}

function ValidateServerType()
{
	local int PlayerIndex, PlayerControllerId, ValueIndex;
	local name MatchTypeName;

	PlayerIndex = GetPlayerIndex();
	PlayerControllerId = GetPlayerControllerId(PlayerIndex);
	// End:0xDC
	if(IsLoggedIn(PlayerControllerId, true)! || Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
	{
		// End:0xD9
		if((MenuManager != none) && MenuManager.JoinGameView != none)
		{
			MenuManager.JoinGameView.ForceLANOption();
		}		
	}
	else
	{
		MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'MatchType360' : 'MatchType');
		ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
		SetFilterNetworkType(ValueIndex == 0);
	}
	//return;	
}

function string GetGameClassByFriendlyName(string FriendlyName)
{
	// End:0x33
	if(FriendlyName ComplementEqual "Deathmatch")
	{
		return "UTGame.UTDeathmatch";		
	}
	else
	{
		// End:0x69
		if(FriendlyName ComplementEqual "Team Deathmatch")
		{
			return "UTGame.UTTeamGame";			
		}
		else
		{
			// End:0xB2
			if(FriendlyName ComplementEqual "Capture the Flag")
			{
				return "UTGameContent.UTVehicleCTFGame_Content";
			}
		}
	}
	return FriendlyName;
	//return ReturnValue;	
}

function OnFilterList_OptionChanged(EventData ev)
{
	local GFxObject Data;
	local byte SelectedIndex;
	local string OptionName, OptionValue, GameClassName;
	local UIDataStore_OnlineGameSettings SettingsDataStore;
	local UTGameSettingsCommon GameSettings;
	local bool bIsLAN;

	bFiltersHaveChanged = true;
	OptionName = ListOptions[ev.Index].OptionName;
	Data = FilterListMC.GetObject("dataProvider").GetElementObject(ev.Index);
	SelectedIndex = byte(Data.GetFloat("optIndex"));
	OptionValue = ListOptions[ev.Index].OptionData[int(SelectedIndex)];
	// End:0x224
	if(OptionName ComplementEqual "Mode")
	{
		GameClassName = GetGameClassByFriendlyName(OptionValue);
		SettingsDataStore = UIDataStore_OnlineGameSettings(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTGameSettings'));
		GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
		GameSettings.SetPropertyFromStringByName('CustomGameMode', GameClassName);
		OnSwitchedGameType();		
	}
	else
	{
		// End:0x28E
		if(OptionName ComplementEqual "Type")
		{
			bIsLAN = (OptionValue ComplementEqual "LAN") || Class'Engine.WorldInfo'.static.IsConsoleBuild(2);
			SetFilterNetworkType(bIsLAN, false);
		}
	}
	//return;	
}

function SetFilterNetworkType(bool bLAN, optional bool bSkipUIUpdate)
{
	local name MatchTypeName;
	local int I, J;
	local UTGameSearchCustom CustomSearch;

	MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'MatchType360' : 'MatchType');
	StringListDataStore.SetCurrentValueIndex(MatchTypeName, ((bLAN) ? 0 : 1));
	GameTypeOptionItem.SetBool("controlDisabled", bLAN);
	I = SearchDataStore.FindSearchConfigurationIndex('UTGameSearchCustom');
	// End:0x191
	if(I != -1)
	{
		CustomSearch = UTGameSearchCustom(SearchDataStore.GameSearchCfgList[I].Search);
		CustomSearch.ResetFilters();
		SearchDataStore.SetCurrentByName('UTGameSearchCustom', true);
	}
	// End:0x31F
	if(bSkipUIUpdate!)
	{
		I = 0;
		J0x1AB:

		// End:0x205 [Loop If]
		if(I < ListOptions.Length)
		{
			// End:0x1F7
			if(ListOptions[I].OptionName ComplementEqual "Type")
			{
				// [Explicit Break]
				goto J0x205;
			}
			I++;
			// [Loop Continue]
			goto J0x1AB;
		}
		J0x205:

		// End:0x31F
		if(I < ListOptions.Length)
		{
			J = 0;
			J0x228:

			// End:0x2B6 [Loop If]
			if(J < ListOptions[I].OptionData.Length)
			{
				// End:0x2A8
				if((ListOptions[I].OptionData[J] ComplementEqual "LAN") ^^ bLAN!)
				{
					// [Explicit Break]
					goto J0x2B6;
				}
				J++;
				// [Loop Continue]
				goto J0x228;
			}
			J0x2B6:

			// End:0x31F
			if(J < ListOptions[I].OptionData.Length)
			{
				NetworkTypeOptionItem.SetFloat("optIndex", float(J));
			}
		}
	}
	PushFilterListUpdate();
	//return;	
}

function SetupListDataProvider()
{
	local byte J;
	local string ControlType;
	local GFxObject RendererDataProvider, TempData;
	local array<ASValue> args;
	local ASValue asval;

	// End:0x764
	if(DataProvider == none)
	{
		DataProvider = Outer.CreateArray();
		ControlType = "stepper";
		NetworkTypeOptionItem = Outer.CreateObject("Object");
		NetworkTypeOptionItem.SetString("name", ListOptions[0].OptionName);
		NetworkTypeOptionItem.SetString("label", Caps(ListOptions[0].OptionLabel));
		NetworkTypeOptionItem.SetString("control", ControlType);
		RendererDataProvider = Outer.CreateArray();
		J = 0;
		J0x170:

		// End:0x2B5 [Loop If]
		if(int(J) < ListOptions[0].OptionData.Length)
		{
			TempData = Outer.CreateObject("Object");
			TempData.SetString("label", ListOptions[0].OptionData[int(J)]);
			TempData.SetString("value", ListOptions[0].OptionData[int(J)]);
			RendererDataProvider.SetElementObject(int(J), TempData);
			J++;
			// [Loop Continue]
			goto J0x170;
		}
		NetworkTypeOptionItem.SetObject("dataProvider", RendererDataProvider);
		NetworkTypeOptionItem.SetFloat("optIndex", 0.0000000);
		DataProvider.SetElementObject(0, NetworkTypeOptionItem);
		GameTypeOptionItem = Outer.CreateObject("Object");
		GameTypeOptionItem.SetString("name", ListOptions[1].OptionName);
		GameTypeOptionItem.SetString("label", Caps(ListOptions[1].OptionLabel));
		GameTypeOptionItem.SetString("control", ControlType);
		RendererDataProvider = Outer.CreateArray();
		J = 0;
		J0x467:

		// End:0x5AC [Loop If]
		if(int(J) < ListOptions[1].OptionData.Length)
		{
			TempData = Outer.CreateObject("Object");
			TempData.SetString("label", ListOptions[1].OptionData[int(J)]);
			TempData.SetString("value", ListOptions[1].OptionData[int(J)]);
			RendererDataProvider.SetElementObject(int(J), TempData);
			J++;
			// [Loop Continue]
			goto J0x467;
		}
		GameTypeOptionItem.SetObject("dataProvider", RendererDataProvider);
		GameTypeOptionItem.SetBool("controlDisabled", true);
		GameTypeOptionItem.SetFloat("optIndex", 0.0000000);
		DataProvider.SetElementObject(1, GameTypeOptionItem);
		FilterListMC.SetObject("dataProvider", DataProvider);
		asval.Type = 4;
		asval.S = "";
		args[0] = asval;		
		FilterListMC.Invoke("validateNow", args);
		FilterListMC.SetFloat("selectedIndex", 0.0000000);
	}
	//return;	
}

function PushFilterListUpdate()
{
	FilterListMC.ActionScriptVoid("validateNow");
	//return;	
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	bWasHandled = false;
	switch(WidgetName)
	{
		// End:0xA1
		case 'List':
			// End:0x9E
			if(FilterListMC == none)
			{
				FilterListMC = GFxClikWidget(Widget);
				FilterListMC.AddEventListener('CLIK_itemChange', OnFilterList_OptionChanged);
				bWasHandled = true;
			}
			// End:0x133
			break;
		// End:0x12D
		case 'popup_title':
			TitleTxt = Widget;
			TitleTxt.SetText("SEARCH FILTER");
			TitleTxt.SetString("label", "FILTER");
			bWasHandled = true;
			// End:0x133
			break;
		// End:0xFFFF
		default:
			// End:0x133
			break;
			break;
	}
	// End:0x172
	if(bWasHandled!)
	{
		bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	}
	return bWasHandled;
	//return ReturnValue;	
}

defaultproperties
{
	ListOptions[0]=(OptionName="Type",OptionLabel="MATCH TYPE",OptionData=("LAN","Internet"))
	ListOptions[1]=(OptionName="Mode",OptionLabel="GAME MODE",OptionData=("Deathmatch","Team Deathmatch","Capture the Flag","All Gametypes","Unlisted Gametypes"))
}