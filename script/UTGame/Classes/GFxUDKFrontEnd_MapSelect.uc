class GFxUDKFrontEnd_MapSelect extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
	config(UI);

var GFxClikWidget ListMC;
var GFxObject ListDataProvider;
var GFxClikWidget ImgScrollerMC;
var GFxObject MenuMC;
var array<UTUIDataProvider_MapInfo> MapList;
var int LastSelectedItem;

function OnViewLoaded()
{
	super(GFxUDKFrontEnd_View).OnViewLoaded();
	//return;	
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	super(GFxUDKFrontEnd_View).OnTopMostView();
	// End:0x67
	if(bPlayOpenAnimation)
	{
		MenuMC.GotoAndPlay("open");
		FooterMC.GotoAndPlay("next");
	}
	MenuManager.SetSelectionFocus(ListMC);
	UpdateListDataProvider();
	//return;	
}

function DisableSubComponents(bool bDisableComponents)
{
	ListMC.SetBool("disabled", bDisableComponents);
	BackBtn.SetBool("disabled", bDisableComponents);
	//return;	
}

function OnMapList_ValueChanged(string InMapSelected, optional string InMapImageSelected = "UDKFrontEnd.gm_map_none")
{
	local UIDataStore_Registry Registry;

	Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
	Registry.SetData("SelectedMap", InMapSelected);
	Registry.SetData("SelectedMapImage", InMapImageSelected);
	//return;	
}

function SetList(GFxObject List)
{
	ActionScriptVoid("setList");
	//return;	
}

function OnListItemPress(EventData ev)
{
	local int SelectedIndex;
	local string SelectedMapName, SelectedMapImage;

	SelectedIndex = ev.Index;
	SelectedMapName = MapList[SelectedIndex].MapName;
	SelectedMapImage = MapList[SelectedIndex].PreviewImageMarkup;
	OnMapList_ValueChanged(SelectedMapName, SelectedMapImage);
	MenuManager.PopView();
	//return;	
}

function UpdateListDataProvider()
{
	local int I, ListCounter;
	local GFxObject DataProvider, TempObj;
	local array<UDKUIResourceDataProvider> ProviderList;
	local array<UTUIDataProvider_MapInfo> LocalMapList;

	MapList.Length = 0;
	LocalMapList.Length = 0;
	Class'UTGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTGame.UTUIDataProvider_MapInfo', ProviderList);
	I = 0;
	J0x54:

	// End:0xA3 [Loop If]
	if(I < ProviderList.Length)
	{
		LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));
		I++;
		// [Loop Continue]
		goto J0x54;
	}
	// End:0xB5
	if(LocalMapList.Length == 0)
	{
		return;
	}
	ListCounter = 0;
	DataProvider = Outer.CreateArray();
	I = 0;
	J0xF4:

	// End:0x34F [Loop If]
	if(I < LocalMapList.Length)
	{
		// End:0x341
		if(!LocalMapList[I].ShouldBeFiltered())
		{
			TempObj = Outer.CreateObject("Object");
			TempObj.SetString("label", Caps(GetMapFriendlyName(LocalMapList[I].MapName)));
			TempObj.SetString("players", LocalMapList[I].NumPlayers);
			// End:0x2A4
			if(LocalMapList[I].PreviewImageMarkup != "")
			{
				TempObj.SetString("image", "img://" $ LocalMapList[I].PreviewImageMarkup);				
			}
			else
			{
				TempObj.SetString("image", "img://" $ "UDKFrontEnd.gm_map_none");
			}
			DataProvider.SetElementObject(ListCounter++, TempObj);
			MapList.AddItem(LocalMapList[I]);
		}
		I++;
		// [Loop Continue]
		goto J0xF4;
	}
	ListMC.SetObject("dataProvider", DataProvider);
	ListDataProvider = ListMC.GetObject("dataProvider");
	ImgScrollerMC.SetObject("dataProvider", DataProvider);
	ImgScrollerMC.SetFloat("selectedIndex", ListMC.GetFloat("selectedIndex"));
	//return;	
}

final function SetImgScroller(GFxClikWidget InImgScroller)
{
	ActionScriptVoid("setImgScroller");
	//return;	
}

static final function string GetImageMarkupByMapName(string InMapName)
{
	local int I;
	local string bResult;
	local array<UDKUIResourceDataProvider> ProviderList;
	local array<UTUIDataProvider_MapInfo> LocalMapList;

	LogInternal(("GetImageMarkupByName(" @ InMapName) @ ")");
	bResult = "UDKFrontEnd.gm_map_none";
	Class'UTGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTGame.UTUIDataProvider_MapInfo', ProviderList);
	I = 0;
	J0x89:

	// End:0xD8 [Loop If]
	if(I < ProviderList.Length)
	{
		LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));
		I++;
		// [Loop Continue]
		goto J0x89;
	}
	I = 0;
	J0xE3:

	// End:0x1A4 [Loop If]
	if(I < LocalMapList.Length)
	{
		// End:0x196
		if(Locs(LocalMapList[I].MapName) == Locs(InMapName))
		{
			// End:0x196
			if(LocalMapList[I].PreviewImageMarkup != "")
			{
				bResult = LocalMapList[I].PreviewImageMarkup;
			}
		}
		I++;
		// [Loop Continue]
		goto J0xE3;
	}
	return bResult;
	//return ReturnValue;	
}

final function name GetCurrentGameMode()
{
	local string GameMode;
	local UIDataStore_Registry Registry;

	Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
	Registry.GetData("SelectedGameMode", GameMode);
	return name(Right(GameMode, (Len(GameMode) - InStr(GameMode, ".")) - 1));
	//return ReturnValue;	
}

final function SetupMapCycle(string SelectedMap)
{
	local int CycleIdx;
	local name GameMode;
	local GameMapCycle MapCycle;

	GameMode = GetCurrentGameMode();
	MapCycle.GameClassName = GameMode;
	MapCycle.Maps.Length = 1;
	MapCycle.Maps[0] = SelectedMap;
	CycleIdx = Class'UTGame.UTGame'.default.GameSpecificMapCycles.Find('GameClassName', GameMode);
	// End:0xFB
	if(CycleIdx == -1)
	{
		CycleIdx = Class'UTGame.UTGame'.default.GameSpecificMapCycles.Length;
	}
	Class'UTGame.UTGame'.default.GameSpecificMapCycles[CycleIdx] = MapCycle;
	Class'UTGame.UTGame'.static.StaticSaveConfig();
	//return;	
}

final function string GetSelectedMap()
{
	local float SelectedItem;
	local string MapName;

	SelectedItem = ListMC.GetFloat("selectedIndex");
	MapName = MapList[int(SelectedItem)].MapName;
	SetupMapCycle(MapName);
	return MapName;
	//return ReturnValue;	
}

final function string GetMapFriendlyName(string Map)
{
	local int I, P, StartIndex, EndIndex;
	local array<string> LocPieces;

	I = 0;
	J0x0B:

	// End:0x211 [Loop If]
	if(I < MapList.Length)
	{
		// End:0x203
		if(MapList[I].MapName ComplementEqual Map)
		{
			StartIndex = InStr(Caps(MapList[I].FriendlyName), "<STRINGS:");
			// End:0xD9
			if(StartIndex == -1)
			{
				return MapList[I].FriendlyName;
			}
			Map = Right(MapList[I].FriendlyName, (Len(MapList[I].FriendlyName) - StartIndex) - 9);
			EndIndex = InStr(Map, ">");
			// End:0x1F9
			if(EndIndex != -1)
			{
				Map = Left(Map, EndIndex);
				ParseStringIntoArray(Map, LocPieces, ".", true);
				// End:0x1F9
				if(LocPieces.Length >= 3)
				{
					Map = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
				}
			}
			return Map;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	P = InStr(Map, "-");
	// End:0x26D
	if(P > -1)
	{
		Map = Right(Map, (Len(Map) - P) - 1);
	}
	return Map;
	//return ReturnValue;	
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	bWasHandled = false;
	switch(WidgetName)
	{
		// End:0x104
		case 'List':
			// End:0x101
			if(ListMC == none)
			{
				ListMC = GFxClikWidget(Widget);
				SetList(ListMC);
				UpdateListDataProvider();
				ListMC.AddEventListener('CLIK_itemPress', OnListItemPress);
				ListMC.SetFloat("selectedIndex", 0.0000000);
				SetImgScroller(ImgScrollerMC);
				bWasHandled = true;
			}
			// End:0x1C0
			break;
		// End:0x141
		case 'menu':
			// End:0x13E
			if(MenuMC == none)
			{
				MenuMC = Widget;
				bWasHandled = true;
			}
			// End:0x1C0
			break;
		// End:0x1BA
		case 'imgScroller':
			// End:0x1B7
			if(ImgScrollerMC == none)
			{
				ImgScrollerMC = GFxClikWidget(Widget);
				ImgScrollerMC.SetFloat("selectedIndex", 0.0000000);
				bWasHandled = true;
			}
			// End:0x1C0
			break;
		// End:0xFFFF
		default:
			// End:0x1C0
			break;
			break;
	}
	// End:0x1FF
	if(!bWasHandled)
	{
		bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	}
	return bWasHandled;
	//return ReturnValue;	
}

defaultproperties
{
	ViewTitle="MAP SELECT"
	CancelButtonHelpText="CANCEL"
	SubWidgetBindings[0]=(WidgetName="List",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[1]=(WidgetName="back",WidgetClass=Class'GFxUI.GFxClikWidget')
	SubWidgetBindings[2]=(WidgetName="imgScroller",WidgetClass=Class'GFxUI.GFxClikWidget')
}