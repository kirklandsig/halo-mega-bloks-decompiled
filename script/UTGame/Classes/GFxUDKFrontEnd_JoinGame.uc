class GFxUDKFrontEnd_JoinGame extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
	config(UI);

const SERVERBROWSER_SERVERTYPE_LAN = 0;
const SERVERBROWSER_SERVERTYPE_UNRANKED = 1;
const SERVERBROWSER_SERVERTYPE_RANKED = 2;

enum EQueryCompletionAction
{
	QUERYACTION_None,               // 0
	QUERYACTION_Default,            // 1
	QUERYACTION_CloseScene,         // 2
	QUERYACTION_JoinServer,         // 3
	QUERYACTION_RefreshAll,         // 4
	QUERYACTION_MAX                 // 5
};

var transient UDKDataStore_GameSearchBase SearchDataStore;
var transient UTUIDataStore_StringList StringListDataStore;
var transient UTDataStore_GameSearchDM SearchDMDataStore;
var transient array<OnlineGameSearchResult> ServerInfoList;
var transient OnlineSubsystem OnlineSub;
var transient OnlineGameInterface GameInterface;
var private transient bool bGametypeOutdated;
var private transient bool bSpectate;
var private transient bool bIssuedInitialQuery;
var private transient bool bQueryDialogShowing;
var private transient bool bJoinDialogShowing;
var private transient bool bProcessingJoin;
var bool bCtrlPressed;
var protected const transient name SearchDSName;
var private transient GFxUDKFrontEnd_PasswordDialog PasswordDialog;
var private transient GFxUDKFrontEnd_JoinDialog JoinDialogMC;
var private transient GFxUDKFrontEnd_JoinGame.EQueryCompletionAction QueryCompletionAction;
var private transient string ServerPassword;
var private int LastServerAdded;
var GFxObject MenuMC;
var GFxClikWidget ServerListMC;
var GFxClikWidget RefreshBtn;
var GFxObject HeaderBarMC;
var GFxClikWidget FlagsHeaderBtn;
var GFxClikWidget ServerHeaderBtn;
var GFxClikWidget MapHeaderBtn;
var GFxClikWidget PlayersHeaderBtn;
var GFxClikWidget PingHeaderBtn;
var GFxObject FilterMatchTypeTxt;
var GFxObject FilterGameModeTxt;
var GFxObject StatusTxt;
var GFxObject LoadingTickerMC;
var GFxObject ServerCountTxt;
var GFxClikWidget FilterBtn;
var int SelectedIndex;

function OnViewLoaded()
{
	local DataStoreClient DSClient;
	local UTPlayerController PC;

	super(GFxUDKFrontEnd_View).OnViewLoaded();
	DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
	// End:0xBA
	if(DSClient != none)
	{
		SearchDataStore = UDKDataStore_GameSearchBase(DSClient.FindDataStore(SearchDSName));
		StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
	}
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x11A
	if(OnlineSub != none)
	{
		GameInterface = OnlineSub.GameInterface;
	}
	PC = UTPlayerController(Outer.GetPC());
	// End:0x17B
	if(PC != none)
	{
		PC.JoinGameMenu = self;
	}
	//return;	
}

function OnViewActivated()
{
	local UIDataStore_Registry Registry;

	Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
	Registry.SetData("LanClient", "1");
	FlagsHeaderBtn.SetString("label", "FLAGS");
	ServerHeaderBtn.SetString("label", "SERVER NAME");
	MapHeaderBtn.SetString("label", "MAP");
	PlayersHeaderBtn.SetString("label", "PLAYERS");
	PingHeaderBtn.SetString("label", "PING");
	FlagsHeaderBtn.SetBool("disabled", true);
	ServerHeaderBtn.SetBool("disabled", true);
	MapHeaderBtn.SetBool("disabled", true);
	PlayersHeaderBtn.SetBool("disabled", true);
	PingHeaderBtn.SetBool("disabled", true);
	ValidateServerType();
	// End:0x253
	if(bGametypeOutdated)
	{
		NotifyGameTypeChanged();
		bGametypeOutdated = false;
	}
	OnGameTypeChanged();
	// End:0x285
	if(!bIssuedInitialQuery)
	{
		bIssuedInitialQuery = true;
		RefreshServerList(0);
	}
	UpdateFilterButton();
	UpdateListDataProvider();
	UpdateServerCount();
	//return;	
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	super(GFxUDKFrontEnd_View).OnTopMostView(bPlayOpenAnimation);
	MenuManager.SetSelectionFocus(RefreshBtn);
	UpdateFilterButton();
	//return;	
}

function OnViewClosed()
{
	Cleanup();
	//return;	
}

function DisableSubComponents(bool bDisableComponents)
{
	ServerListMC.SetBool("disabled", bDisableComponents);
	BackBtn.SetBool("disabled", bDisableComponents);
	RefreshBtn.SetBool("disabled", bDisableComponents);
	//return;	
}

function ValidateServerType()
{
	local int PlayerIndex, PlayerControllerId;

	PlayerIndex = GetPlayerIndex();
	PlayerControllerId = GetPlayerControllerId(PlayerIndex);
	// End:0x7A
	if(!IsLoggedIn(PlayerControllerId, true) || Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
	{
		ForceLANOption();
	}
	//return;	
}

function Cleanup()
{
	local UTPlayerController PC;

	// DebugMode: 0
	assert(int(QueryCompletionAction) == int(0));
	// End:0x97
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
	}
	// End:0xC5
	if(SearchDataStore != none)
	{
		SearchDataStore.ClearAllSearchResults();
	}
	PC = UTPlayerController(Outer.GetPC());
	// End:0x126
	if(PC != none)
	{
		PC.JoinGameMenu = none;
	}
	//return;	
}

final function UpdateFilterButton()
{
	local int DesiredMatchType;
	local string FilterMatchType, FilterGameMode;
	local UTGameSettingsCommon GameSettings;
	local UIDataStore_OnlineGameSettings SettingsDataStore;

	DesiredMatchType = GetDesiredMatchType();
	switch(DesiredMatchType)
	{
		// End:0x3D
		case 0:
			FilterMatchType = "LAN";
			// End:0x8B
			break;
		// End:0x58
		case 1:
			FilterMatchType = "Internet";
			// End:0x8B
			break;
		// End:0x72
		case 2:
			FilterMatchType = "Ranked";
			// End:0x8B
			break;
		// End:0xFFFF
		default:
			FilterMatchType = "Unknown";
			// End:0x8B
			break;
			break;
	}
	FilterMatchTypeTxt.SetText(FilterMatchType);
	SettingsDataStore = UIDataStore_OnlineGameSettings(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTGameSettings'));
	GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
	FilterGameMode = GameSettings.GetPropertyAsStringByName('CustomGameMode');
	FilterGameMode = Class'UTGame.GFxUDKFrontEnd_LaunchGame'.static.GetGameModeFriendlyString(FilterGameMode);
	FilterGameModeTxt.SetText(FilterGameMode);
	//return;	
}

function ConditionalRefreshServerList(int PlayerIndex)
{
	local bool bHasExistingResults, bHasOutstandingQueries;

	bHasExistingResults = SearchDataStore.HasExistingSearchResults();
	bHasOutstandingQueries = SearchDataStore.HasOutstandingQueries();
	// End:0x8C
	if(!bHasExistingResults && !bHasOutstandingQueries)
	{
		RefreshServerList(PlayerIndex);		
	}
	else
	{
		// End:0xA3
		if(bHasExistingResults)
		{
			UpdateListDataProvider();
		}
		UpdateServerCount();
	}
	//return;	
}

function UpdateButtonStates()
{
	local bool bHasPendingSearches;

	bHasPendingSearches = SearchDataStore.HasOutstandingQueries();
	RefreshBtn.SetBool("toggled", bHasPendingSearches);
	RefreshBtn.SetBool("disabled", bHasPendingSearches);
	//return;	
}

private final function PromptForServerPassword()
{
	// End:0x8A
	if(MenuManager != none)
	{
		PasswordDialog = GFxUDKFrontEnd_PasswordDialog(MenuManager.SpawnDialog('PasswordDialog'));
		// End:0x8A
		if(PasswordDialog != none)
		{
			PasswordDialog.SetOKButtonListener(OnPasswordDialog_OK);
		}
	}
	//return;	
}

static function string StripInvalidPasswordCharacters(string PasswordString, optional string InvalidChars = " \"/:?,=")
{
	local int I;

	I = 0;
	J0x18:

	// End:0x6C [Loop If]
	if(I < Len(InvalidChars))
	{
		PasswordString = Repl(PasswordString, Mid(InvalidChars, I, 1), "");
		I++;
		// [Loop Continue]
		goto J0x18;
	}
	return PasswordString;
	//return ReturnValue;	
}

private final function OnPasswordDialog_OK(EventData ev)
{
	local string Password;

	Password = PasswordDialog.GetPassword();
	// End:0x64
	if(Password != "")
	{
		ServerPassword = StripInvalidPasswordCharacters(Password);
		ProcessJoin();		
	}
	else
	{
		ServerPassword = "";
	}
	//return;	
}

function UpdateServerCount()
{
	local int ServerCount;
	local OnlineGameSearch CurrentSearch;

	// End:0x70
	if(SearchDataStore != none)
	{
		CurrentSearch = SearchDataStore.GetCurrentGameSearch();
		// End:0x70
		if(CurrentSearch != none)
		{
			ServerCount = CurrentSearch.Results.Length;
		}
	}
	StatusTxt.SetText("SERVERS RECEIVED:");
	ServerCountTxt.SetText(string(ServerCount));
	//return;	
}

function string BuildJoinURL(string ResolvedConnectionURL)
{
	local string ConnectURL;

	ConnectURL = "open " $ ResolvedConnectionURL;
	// End:0x58
	if(ServerPassword != "")
	{		
		ConnectURL $= ("?Password=" $ ServerPassword);
	}
	// End:0x8C
	if(bSpectate)
	{		
		ConnectURL $= "?SpectatorOnly=1";
	}
	return ConnectURL;
	//return ReturnValue;	
}

function RefreshServerList(int InPlayerIndex, optional int MaxResults = 1000)
{
	local OnlineGameSearch GameSearch;
	local int ValueIndex;

	LogInternal(((("GFx: RefreshServerList(" @ string(InPlayerIndex)) $ ", ") $ string(MaxResults)) @ ")");
	// End:0x362
	if(!SearchDataStore.HasOutstandingQueries())
	{
		GameSearch = SearchDataStore.GetCurrentGameSearch();
		GameSearch.MaxSearchResults = MaxResults;
		ValueIndex = GetDesiredMatchType();
		switch(ValueIndex)
		{
			// End:0x1A4
			case 0:
				LogInternal(((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Searching for a LAN match.", 'DevOnline');
				GameSearch.bIsLanQuery = true;
				GameSearch.bUsesArbitration = false;
				// End:0x34F
				break;
			// End:0x289
			case 2:
				// End:0x289
				if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
				{
					LogInternal(((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Searching for a ranked match.", 'DevOnline');
					GameSearch.bIsLanQuery = false;
					GameSearch.bUsesArbitration = true;
					// End:0x34F
					break;
				}
			// End:0x34C
			case 1:
				LogInternal(((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Searching for an unranked match.", 'DevOnline');
				GameSearch.bIsLanQuery = false;
				GameSearch.bUsesArbitration = false;
				// End:0x34F
				break;
			// End:0xFFFF
			default:
				break;
		}
		SubmitServerListQuery(InPlayerIndex);
	}
	//return;	
}

function SubmitServerListQuery(int PlayerIndex)
{
	LogInternal((((((((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "QueryActive:'") $ string(SearchDataStore.HasOutstandingQueries())) $ "'") @ "ExistingResults:'") $ string(SearchDataStore.HasExistingSearchResults())) $ "'", 'DevOnline');
	SetRefreshing(true);
	GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
	// End:0x161
	if(!SearchDataStore.SubmitGameSearch(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex)), false))
	{
		SetRefreshing(false);
	}
	UpdateServerCount();
	UpdateButtonStates();
	//return;	
}

function OnFindOnlineGamesCompleteDelegate(bool bWasSuccessful)
{
	local bool bSearchCompleted;

	bSearchCompleted = !SearchDataStore.HasOutstandingQueries();
	LogInternal((((((((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "bWasSuccessful:'") $ string(bWasSuccessful)) $ "'") @ "bSearchCompleted:'") $ string(bSearchCompleted)) $ "'", 'DevOnline');
	SetRefreshing(false);
	UpdateServerCount();
	// End:0x138
	if(bSearchCompleted)
	{
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
		OnFindOnlineGamesComplete(bWasSuccessful);
	}
	UpdateButtonStates();
	UpdateListDataProvider();
	//return;	
}

function OnFindOnlineGamesComplete(bool bWasSuccessful)
{
	// End:0x5A
	if(int(QueryCompletionAction) != int(0))
	{
		// End:0x4F
		if(bQueryDialogShowing)
		{
			MenuManager.PopView();
			bQueryDialogShowing = false;			
		}
		else
		{
			OnCancelSearchComplete(true);
		}
	}
	UpdateListDataProvider();
	//return;	
}

function int GetDesiredMatchType()
{
	return ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? StringListDataStore.GetCurrentValueIndex('MatchType360') : StringListDataStore.GetCurrentValueIndex('MatchType'));
	//return ReturnValue;	
}

function OnRefreshButtonPress(EventData ev)
{
	RefreshServerList(0);
	UpdateListDataProvider();
	//return;	
}

function OnFilterButtonPress(EventData ev)
{
	local GFxUDKFrontEnd_FilterDialog FilterDialog;

	FilterDialog = GFxUDKFrontEnd_FilterDialog(MenuManager.SpawnDialog('FilterDialog', self));
	FilterDialog.SetBackButtonListener(OnRefreshButtonPress);
	FilterDialog.__OnSwitchedGameType__Delegate = ServerFilterChangedGameType;
	//return;	
}

function ServerFilterChangedGameType()
{
	OnGameTypeChanged();
	NotifyGameTypeChanged();
	//return;	
}

function UpdateListDataProvider()
{
	local byte I;
	local GFxObject DataProvider, TempObj;
	local OnlineGameSearch LatestGameSearch;
	local array<ASValue> args;
	local ASValue asval;
	local int Ping;

	ServerInfoList.Length = 0;
	LatestGameSearch = SearchDataStore.GetActiveGameSearch();
	// End:0x5CA
	if(LatestGameSearch != none)
	{
		// End:0xEA
		if(LatestGameSearch.Results.Length == 0)
		{
			HeaderBarMC.SetBool("focusable", false);
			ServerListMC.SetBool("focusable", false);
			MenuManager.SetSelectionFocus(BackBtn);			
		}
		else
		{
			HeaderBarMC.SetBool("focusable", true);
			ServerListMC.SetBool("focusable", true);
		}
		DataProvider = Outer.CreateArray();
		I = 0;
		J0x175:

		// End:0x503 [Loop If]
		if(int(I) < LatestGameSearch.Results.Length)
		{
			TempObj = Outer.CreateObject("Object");
			TempObj.SetString("ServerName", LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName);
			TempObj.SetFloat("Players", float(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections));
			TempObj.SetFloat("MaxPlayers", float(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections));
			Ping = LatestGameSearch.Results[int(I)].GameSettings.PingInMs;
			TempObj.SetString("Ping", ((Ping < 0) ? "-" : string(Ping)));
			TempObj.SetString("Map", LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsString(1073741825));
			DataProvider.SetElementObject(int(I), TempObj);
			I++;
			// [Loop Continue]
			goto J0x175;
		}
		ServerListMC.SetObject("dataProvider", DataProvider);
		asval.Type = 4;
		asval.S = "";
		args[0] = asval;		
		ServerListMC.Invoke("validateNow", args);
	}
	//return;	
}

function OnServerHeaderPress(EventData ev)
{
	//return;	
}

function OnMapHeaderPress(EventData ev)
{
	//return;	
}

function OnPlayersHeaderPress(EventData ev)
{
	//return;	
}

function OnPingHeaderPress(EventData ev)
{
	//return;	
}

function OnServerListItemPress(EventData ev)
{
	local OnlineGameSearch LatestGameSearch;
	local OnlineGameSettings SelectedGameSettings;

	SelectedIndex = ev.Index;
	JoinDialogMC = GFxUDKFrontEnd_JoinDialog(MenuManager.SpawnDialog('JoinDialog'));
	LatestGameSearch = SearchDataStore.GetActiveGameSearch();
	SelectedGameSettings = LatestGameSearch.Results[ev.Index].GameSettings;
	JoinDialogMC.PopulateServerInfo(SelectedGameSettings);
	JoinDialogMC.SetJoinButtonPress(JoinServerClikListener);
	JoinDialogMC.SetSpectateButtonPress(SpectateServer);
	bJoinDialogShowing = true;
	//return;	
}

function SpectateServer(EventData ev)
{
	bSpectate = true;
	JoinServer();
	//return;	
}

function JoinServerClikListener(EventData ev)
{
	// End:0x4C
	if(SearchDataStore != none)
	{
		SearchDataStore.ServerDetailsProvider.SearchResultsRow = SelectedIndex;
	}
	JoinServer();
	//return;	
}

function JoinServer()
{
	local int CurrentSelection;

	// End:0x39
	if(AllowJoinServer())
	{
		CurrentSelection = SelectedIndex;
		// End:0x39
		if(CurrentSelection >= 0)
		{
			ProcessJoin();
		}
	}
	//return;	
}

private final function ProcessJoin()
{
	local OnlineGameSearchResult GameToJoin;
	local int ControllerId, CurrentSelection;

	LogInternal("ProcessJoin()");
	// End:0x309
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		CurrentSelection = SelectedIndex;
		// End:0x269
		if(SearchDataStore.GetSearchResultFromIndex(CurrentSelection, GameToJoin))
		{
			LogInternal((((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Joining Search Result ") $ string(CurrentSelection), 'DevGFxUI');
			// End:0x1B1
			if(GameToJoin.GameSettings != none)
			{
				bProcessingJoin = true;
				GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
				ControllerId = 0;
				// End:0x1AE
				if(!GameInterface.JoinOnlineGame(byte(ControllerId), 'Game', GameToJoin))
				{
					bProcessingJoin = false;
				}				
			}
			else
			{
				LogInternal(((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Failed to join game because of a NULL GameSettings object in the search result.");
				OnJoinGameComplete('Game', false);
			}			
		}
		else
		{
			bSpectate = false;
			ServerPassword = "";
			LogInternal((((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Unable to get search result for index ") $ string(CurrentSelection));
		}		
	}
	else
	{
		bSpectate = false;
		ServerPassword = "";
		LogInternal(((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Unable to join game, GameInterface is NULL!");
	}
	//return;	
}

function OnJoinGameComplete(name SessionName, bool bSuccessful)
{
	local string URL;
	local GFxUDKFrontEnd_ErrorDialog DialogMC;
	local UTGameSettingsCommon CurGameSettings;

	bProcessingJoin = false;
	LogInternal((("OnJoinGameComplete(" @ string(SessionName)) @ ",") @ string(bSuccessful));
	// End:0x3EF
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		// End:0x255
		if(bSuccessful)
		{
			Cleanup();
			// End:0x252
			if(GameInterface.GetResolvedConnectString('Game', URL))
			{
				// End:0x106
				if(OnlineGameInterfaceImpl(GameInterface) != none)
				{
					CurGameSettings = UTGameSettingsCommon(OnlineGameInterfaceImpl(GameInterface).GameSettings);
				}
				// End:0x16E
				if((CurGameSettings != none) && CurGameSettings.SteamServerId != "")
				{
					URL = "steam." $ CurGameSettings.SteamServerId;
				}
				URL = BuildJoinURL(URL);				
				URL $= ("?name=" $ (GetPlayerName()));
				LogInternal(((((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Join Game Successful, Traveling: ") $ URL) $ "", 'DevUI');
				ConsoleCommand(URL);
			}			
		}
		else
		{
			GameInterface.DestroyOnlineGame('Game');
			// End:0x3BE
			if(MenuManager != none)
			{
				DialogMC = GFxUDKFrontEnd_ErrorDialog(MenuManager.SpawnDialog('ErrorDialog'));
				DialogMC.SetTitle("<Strings:UTGameUI.Errors.ConnectionLost_Title>");
				DialogMC.SetInfo("<Strings:UTGameUI.Errors.ConnectionLost_Message>");
				DialogMC.SetButtonLabel("BACK");
				DialogMC.SetBackButton_OnPress(Select_Back);
			}
		}
		GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
	}
	bSpectate = false;
	ServerPassword = "";
	//return;	
}

function bool AllowJoinServer()
{
	local bool bResult;

	// End:0xA6
	if(!bProcessingJoin)
	{
		bResult = true;
		// End:0xA6
		if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
		{
			// End:0xA6
			if((SearchDataStore != none) && SearchDataStore.HasOutstandingQueries())
			{
				LogInternal("Searches are still pending");
				bResult = false;
				CancelQuery(3);
			}
		}
	}
	return bResult;
	//return ReturnValue;	
}

function CancelQuery(optional GFxUDKFrontEnd_JoinGame.EQueryCompletionAction DesiredCancelAction = 1)
{
	// End:0xF4
	if(int(QueryCompletionAction) == int(0))
	{
		QueryCompletionAction = DesiredCancelAction;
		// End:0xB5
		if((SearchDataStore == none) || SearchDataStore.HasOutstandingQueries())
		{
			GameInterface.AddCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
			GameInterface.CancelFindOnlineGames();			
		}
		else
		{
			// End:0xE5
			if(SearchDataStore.HasExistingSearchResults())
			{
				OnCancelSearchComplete(true);				
			}
			else
			{
				QueryCompletionAction = 0;
			}
		}		
	}
	else
	{
		LogInternal("Could not cancel query because query cancel already in progress:" @ string(GetEnum(Enum'UTGame.GFxUDKFrontEnd_JoinGame.EQueryCompletionAction', int(QueryCompletionAction))));
	}
	//return;	
}

function SetRefreshing(bool IsRefreshing)
{
	// End:0x97
	if(IsRefreshing)
	{
		StatusTxt.SetText("<Strings:UTGameUI.Generic.Refreshing>");
		LoadingTickerMC.SetVisible(true);
		LoadingTickerMC.GotoAndStopI(1);		
	}
	else
	{
		LoadingTickerMC.SetVisible(false);
		LoadingTickerMC.GotoAndStopI(1);
	}
	//return;	
}

function OnCancelSearchComplete(bool bWasSuccessful)
{
	local GFxUDKFrontEnd_JoinGame.EQueryCompletionAction CurrentAction;
	local GFxUDKFrontEnd_ErrorDialog Dialog;

	GameInterface.ClearCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
	// End:0x133
	if(bWasSuccessful)
	{
		CurrentAction = QueryCompletionAction;
		QueryCompletionAction = 0;
		switch(CurrentAction)
		{
			// End:0x97
			case 2:
				MenuManager.PopView();
				// End:0x130
				break;
			// End:0xBE
			case 3:
				JoinServer();
				UpdateButtonStates();
				SetRefreshing(false);
				// End:0x130
				break;
			// End:0x115
			case 4:
				// End:0xF1
				if(SearchDataStore != none)
				{
					SearchDataStore.ClearAllSearchResults();
				}
				UpdateButtonStates();
				SetRefreshing(false);
				RefreshServerList(0);
				// End:0x130
				break;
			// End:0xFFFF
			default:
				UpdateButtonStates();
				SetRefreshing(false);
				// End:0x130
				break;
				break;
		}		
	}
	else
	{
		// End:0x241
		if(int(QueryCompletionAction) != int(0))
		{
			// End:0x237
			if(MenuManager != none)
			{
				Dialog = GFxUDKFrontEnd_ErrorDialog(MenuManager.SpawnDialog('ErrorDialog'));
				Dialog.SetTitle("<Strings:UTGameUI.Errors.Error_Title>");
				Dialog.SetInfo("<Strings:UTGameUI.MessageBox.QueryPending_Message>");
				bQueryDialogShowing = true;
			}
			UpdateButtonStates();
		}
	}
	//return;	
}

function NotifyGameTypeChanged()
{
	UpdateFilterButton();
	bGametypeOutdated = true;
	//return;	
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	bWasHandled = false;
	switch(WidgetName)
	{
		// End:0xAB
		case 'List':
			// End:0xA8
			if(ServerListMC == none)
			{
				ServerListMC = GFxClikWidget(Widget);
				UpdateListDataProvider();
				ServerListMC.AddEventListener('CLIK_itemPress', OnServerListItemPress);
				bWasHandled = true;
			}
			// End:0x6A1
			break;
		// End:0xE8
		case 'menu':
			// End:0xE5
			if(MenuMC == none)
			{
				MenuMC = Widget;
				bWasHandled = true;
			}
			// End:0x6A1
			break;
		// End:0x369
		case 'headerbar':
			// End:0x366
			if(HeaderBarMC == none)
			{
				HeaderBarMC = Widget;
				FlagsHeaderBtn = GFxClikWidget(Widget.GetObject("header1", Class'GFxUI.GFxClikWidget'));
				ServerHeaderBtn = GFxClikWidget(Widget.GetObject("header2", Class'GFxUI.GFxClikWidget'));
				ServerHeaderBtn.AddEventListener('CLIK_press', OnServerHeaderPress);
				MapHeaderBtn = GFxClikWidget(Widget.GetObject("header3", Class'GFxUI.GFxClikWidget'));
				MapHeaderBtn.AddEventListener('CLIK_press', OnMapHeaderPress);
				PlayersHeaderBtn = GFxClikWidget(Widget.GetObject("header4", Class'GFxUI.GFxClikWidget'));
				PlayersHeaderBtn.AddEventListener('CLIK_press', OnPlayersHeaderPress);
				PingHeaderBtn = GFxClikWidget(Widget.GetObject("header5", Class'GFxUI.GFxClikWidget'));
				PingHeaderBtn.AddEventListener('CLIK_press', OnPingHeaderPress);
				bWasHandled = true;
			}
			// End:0x6A1
			break;
		// End:0x3ED
		case 'browsertext':
			FilterMatchTypeTxt = Widget.GetObject("matchtype");
			FilterGameModeTxt = Widget.GetObject("gamemode");
			bWasHandled = true;
			// End:0x6A1
			break;
		// End:0x46F
		case 'browserbtn_fliter':
			// End:0x46C
			if(FilterBtn == none)
			{
				FilterBtn = GFxClikWidget(Widget);
				FilterBtn.AddEventListener('CLIK_press', OnFilterButtonPress);
				bWasHandled = true;
			}
			// End:0x6A1
			break;
		// End:0x50D
		case 'browserbtn_refresh':
			RefreshBtn = GFxClikWidget(Widget);
			RefreshBtn.RemoveAllEventListeners("CLIK_press");
			RefreshBtn.AddEventListener('CLIK_press', OnRefreshButtonPress);
			bWasHandled = true;
			// End:0x6A1
			break;
		// End:0x5E0
		case 'btn_back':
			// End:0x5DD
			if(BackBtn == none)
			{
				BackBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
				BackBtn.AddEventListener('CLIK_press', Select_Back);
				BackBtn.SetString("label", "BACK");
				bWasHandled = true;
			}
			// End:0x6A1
			break;
		// End:0x69B
		case 'servers_received':
			LoadingTickerMC = Widget.GetObject("loading_ticker");
			StatusTxt = Widget.GetObject("label");
			ServerCountTxt = Widget.GetObject("textField");
			bWasHandled = true;
			// End:0x6A1
			break;
		// End:0xFFFF
		default:
			// End:0x6A1
			break;
			break;
	}
	// End:0x6E0
	if(!bWasHandled)
	{
		bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	}
	return bWasHandled;
	//return ReturnValue;	
}

function bool OnFilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
	// End:0x8C
	if((ButtonName == 'LeftControl') || ButtonName == 'RightControl')
	{
		// End:0x69
		if((int(InputEvent) == int(0)) || int(InputEvent) == int(2))
		{
			bCtrlPressed = true;			
		}
		else
		{
			// End:0x89
			if(int(InputEvent) == int(1))
			{
				bCtrlPressed = false;
			}
		}		
	}
	else
	{
		// End:0x152
		if(int(InputEvent) == int(0))
		{
			// End:0xD4
			if(ButtonName == 'C')
			{
				// End:0xD1
				if(bCtrlPressed)
				{
					CancelQuery();
					return true;
				}				
			}
			else
			{
				// End:0xFB
				if(ButtonName == 'F10')
				{
					CancelQuery();
					return true;					
				}
				else
				{
					// End:0x152
					if(ButtonName == 'F5')
					{
						// End:0x144
						if(SearchDataStore.HasOutstandingQueries())
						{
							CancelQuery(4);							
						}
						else
						{
							RefreshServerList(0);
						}
						return true;
					}
				}
			}
		}
	}
	return false;
	//return ReturnValue;	
}

final function ForceLANOption()
{
	local int ValueIndex, I;
	local name MatchTypeName;
	local UTGameSearchCustom CustomSearch;
	local array<UDKUIResourceDataProvider> Providers;
	local UTUIDataProvider_GameModeInfo Provider;

	MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'MatchType360' : 'MatchType');
	ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
	// End:0xB6
	if(ValueIndex != 0)
	{
		StringListDataStore.SetCurrentValueIndex(MatchTypeName, 0);
		UpdateFilterButton();
	}
	Class'UTGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTGame.UTUIDataProvider_GameModeInfo', Providers);
	ValueIndex = -1;
	I = 0;
	J0x101:

	// End:0x1AB [Loop If]
	if(I < Providers.Length)
	{
		Provider = UTUIDataProvider_GameModeInfo(Providers[I]);
		// End:0x19D
		if((Provider != none) && Provider.GameSearchClass == "UTGameSearchCustom")
		{
			ValueIndex = I;
			// [Explicit Break]
			goto J0x1AB;
		}
		++I;
		// [Loop Continue]
		goto J0x101;
	}
	J0x1AB:

	// End:0x299
	if(ValueIndex != -1)
	{
		ValueIndex = SearchDataStore.FindSearchConfigurationIndex('UTGameSearchCustom');
		// End:0x299
		if(ValueIndex != -1)
		{
			CustomSearch = UTGameSearchCustom(SearchDataStore.GameSearchCfgList[ValueIndex].Search);
			CustomSearch.ResetFilters();
			SearchDataStore.SetCurrentByName('UTGameSearchCustom', true);
		}
	}
	//return;	
}

function OnGameTypeChanged(optional int PlayerIndex)
{
	local int ProviderIdx, I;
	local string GameTypeClassName;
	local UTGameSettingsCommon GameSettings;
	local UIDataStore_OnlineGameSettings SettingsDataStore;
	local UTGameSearchCustom CustomSearch;
	local UTGameSearchCommon CommonSearch;
	local array<UDKUIResourceDataProvider> Providers;
	local UTUIDataProvider_GameModeInfo Provider;

	SettingsDataStore = UIDataStore_OnlineGameSettings(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTGameSettings'));
	GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
	GameTypeClassName = GameSettings.GetPropertyAsStringByName('CustomGameMode');
	// End:0x187
	if(GameTypeClassName == "")
	{
		CommonSearch = UTGameSearchCommon(SearchDataStore.GetCurrentGameSearch());
		// End:0x187
		if((CommonSearch != none) && CommonSearch.GameClass != "")
		{
			GameSettings.SetPropertyFromStringByName('CustomGameMode', CommonSearch.GameClass);
			GameTypeClassName = CommonSearch.GameClass;
		}
	}
	// End:0x89E
	if(GameTypeClassName != "")
	{
		// End:0x5DC
		if((GameTypeClassName ComplementEqual "All Gametypes") || GameTypeClassName ComplementEqual "Unlisted Gametypes")
		{
			I = SearchDataStore.FindSearchConfigurationIndex('UTGameSearchCustom');
			// End:0x59B
			if(I != -1)
			{
				CustomSearch = UTGameSearchCustom(SearchDataStore.GameSearchCfgList[I].Search);
				CustomSearch.ResetFilters();
				// End:0x56F
				if(GameTypeClassName ComplementEqual "Unlisted Gametypes")
				{
					// End:0x521
					if(Class'Engine.GameEngine'.static.GetOnlineSubsystem().Class.Name == 'OnlineSubsystemSteamworks')
					{
						CustomSearch.ResetFilters();
						CustomSearch.AddANDFilter('DM');
						CustomSearch.AddORFilter('DM', string(1073741826), 0, 1, "UTGame.UTDeathmatch");
						CustomSearch.AddANDFilter('TDM');
						CustomSearch.AddORFilter('TDM', string(1073741826), 0, 1, "UTGame.UTTeamGame");
						CustomSearch.AddANDFilter('CTF');
						CustomSearch.AddORFilter('CTF', string(1073741826), 0, 1, "UTGameContent.UTCTFGame_Content");
						CustomSearch.AddANDFilter('VCTF');
						CustomSearch.AddORFilter('VCTF', string(1073741826), 0, 1, "UTGameContent.UTVehicleCTFGame_Content");
						CustomSearch.CommitFilters();						
					}
					else
					{
						LogInternal("The 'Unlisted Gametypes' search only works with OnlineSubsystemSteamworks");
					}
				}
				SearchDataStore.SetCurrentByName('UTGameSearchCustom', true);				
			}
			else
			{
				LogInternal("Error, UTGameSearchCustom is not set in GameSearchCfgList");
			}			
		}
		else
		{
			Class'UTGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTGame.UTUIDataProvider_GameModeInfo', Providers);
			I = 0;
			J0x618:

			// End:0x714 [Loop If]
			if(I < Providers.Length)
			{
				Provider = UTUIDataProvider_GameModeInfo(Providers[I]);
				// End:0x706
				if(((Provider != none) && Provider.GameMode == GameTypeClassName) && Provider.GameSearchClass != "")
				{
					ProviderIdx = SearchDataStore.FindSearchConfigurationIndex(name(Provider.GameSearchClass));
					// [Explicit Break]
					goto J0x714;
				}
				I++;
				// [Loop Continue]
				goto J0x618;
			}
			J0x714:

			LogInternal(((((((((("(" $ string(Name)) $ ") GFxUDKFrontEnd_JoinGame::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "- Game mode filter class set to") @ GameTypeClassName) @ "(") $ string(ProviderIdx)) $ ")");
			// End:0x85D
			if(ProviderIdx != -1)
			{
				SearchDataStore.SetCurrentByIndex(ProviderIdx, false);
				CommonSearch = UTGameSearchCommon(SearchDataStore.GameSearchCfgList[ProviderIdx].Search);
				// End:0x85D
				if(CommonSearch != none)
				{
					CommonSearch.InitFilters();
				}
			}
		}
		// End:0x88F
		if(SearchDataStore.HasOutstandingQueries())
		{
			CancelQuery(4);			
		}
		else
		{
			RefreshServerList(0);
		}		
	}
	else
	{
		LogInternal("OnGameTypeChanged: GameTypeClassName not set");
	}
	//return;	
}

defaultproperties
{
	SearchDSName="UTGameSearch"
	SubWidgetBindings[0]=(WidgetName="List",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[1]=(WidgetName="back",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[2]=(WidgetName="header1",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[3]=(WidgetName="header2",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[4]=(WidgetName="header3",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[5]=(WidgetName="header4",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[6]=(WidgetName="header5",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[7]=(WidgetName="browserbtn_fliter",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[8]=(WidgetName="browserbtn_refresh",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[9]=(WidgetName="btn_back",WidgetClass=Class'GFxUI.GFxClikWidget')
}