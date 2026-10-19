class UTDataStore_GameSearchDM extends UDKDataStore_GameSearchBase
	transient
	config(UI);

struct PersistentLocalizedSettingValue
{
	var config int SettingId;
	var config int ValueId;

	structdefaultproperties
	{
		SettingId=0
		ValueId=0
	}
};

struct GameSearchSettingsStorage
{
	var config name GameSearchName;
	var config array<config PersistentLocalizedSettingValue> StoredValues;

	structdefaultproperties
	{
		GameSearchName="None"
		StoredValues=none
	}
};

var Class<UTDataStore_GameSearchHistory> HistoryGameSearchDataStoreClass;
var transient UTDataStore_GameSearchHistory HistoryGameSearchDataStore;
var config array<config GameSearchSettingsStorage> StoredGameSearchValues;

event Registered(LocalPlayer PlayerOwner)
{
	local DataStoreClient DSClient;

	super(UIDataStore).Registered(PlayerOwner);
	DSClient = GetDataStoreClient();
	// End:0xDB
	if(DSClient != none)
	{
		// End:0x58
		if(HistoryGameSearchDataStoreClass == none)
		{
			HistoryGameSearchDataStoreClass = Class'UTGame.UTDataStore_GameSearchHistory';
		}
		HistoryGameSearchDataStore = DSClient.CreateDataStore(HistoryGameSearchDataStoreClass);
		HistoryGameSearchDataStore.PrimaryGameSearchDataStore = self;
		DSClient.RegisterDataStore(HistoryGameSearchDataStore, PlayerOwner);
	}
	LoadGameSearchParameters();
	//return;	
}

event bool SubmitGameSearch(byte ControllerIndex, optional bool bInvalidateExistingSearchResults = true)
{
	// End:0x2D
	if(bInvalidateExistingSearchResults || !HasExistingSearchResults())
	{
		SaveGameSearchParameters();
	}
	return super.SubmitGameSearch(ControllerIndex, bInvalidateExistingSearchResults);
	//return ReturnValue;	
}

function bool HasOutstandingQueries(optional bool bRestrictCheckToSelf)
{
	local bool bResult;

	bResult = super.HasOutstandingQueries(bRestrictCheckToSelf);
	// End:0xF1
	if((!bResult && !bRestrictCheckToSelf) && HistoryGameSearchDataStore != none)
	{
		bResult = HistoryGameSearchDataStore.HasOutstandingQueries(true);
		// End:0xF1
		if(!bResult && HistoryGameSearchDataStore.FavoritesGameSearchDataStore != none)
		{
			bResult = HistoryGameSearchDataStore.FavoritesGameSearchDataStore.HasOutstandingQueries(true);
		}
	}
	return bResult;
	//return ReturnValue;	
}

function int FindStoredSearchIndex(name GameSearchName)
{
	local int I, Result;

	Result = -1;
	I = 0;
	J0x1A:

	// End:0x8A [Loop If]
	if(I < StoredGameSearchValues.Length)
	{
		// End:0x7C
		if(StoredGameSearchValues[I].GameSearchName == GameSearchName)
		{
			Result = I;
			// [Explicit Break]
			goto J0x8A;
		}
		I++;
		// [Loop Continue]
		goto J0x1A;
	}
	J0x8A:

	return Result;
	//return ReturnValue;	
}

function int FindStoredSettingValueIndex(int StoredGameSearchIndex, int LocalizedSettingId, optional bool bAddIfNecessary)
{
	local int I, Result;

	Result = -1;
	// End:0x1C2
	if((StoredGameSearchIndex >= 0) && StoredGameSearchIndex < StoredGameSearchValues.Length)
	{
		I = 0;
		J0x44:

		// End:0xEE [Loop If]
		if(I < StoredGameSearchValues[StoredGameSearchIndex].StoredValues.Length)
		{
			// End:0xE0
			if(StoredGameSearchValues[StoredGameSearchIndex].StoredValues[I].SettingId == LocalizedSettingId)
			{
				Result = I;
				// [Explicit Break]
				goto J0xEE;
			}
			I++;
			// [Loop Continue]
			goto J0x44;
		}
		J0xEE:

		// End:0x1C2
		if((Result == -1) && bAddIfNecessary)
		{
			Result = StoredGameSearchValues[StoredGameSearchIndex].StoredValues.Length;
			StoredGameSearchValues[StoredGameSearchIndex].StoredValues.Length = Result + 1;
			StoredGameSearchValues[StoredGameSearchIndex].StoredValues[Result].SettingId = LocalizedSettingId;
		}
	}
	return Result;
	//return ReturnValue;	
}

function LoadGameSearchParameters()
{
	local OnlineGameSearch Search;
	local int GameIndex, SettingIndex, SettingId, StoredSearchIndex, SettingValueIndex, SettingValueId;

	GameIndex = 0;
	J0x0B:

	// End:0x247 [Loop If]
	if(GameIndex < GameSearchCfgList.Length)
	{
		Search = GameSearchCfgList[GameIndex].Search;
		// End:0x239
		if(Search != none)
		{
			StoredSearchIndex = FindStoredSearchIndex(GameSearchCfgList[GameIndex].SearchName);
			// End:0x239
			if(StoredSearchIndex != -1)
			{
				SettingIndex = 0;
				J0xBA:

				// End:0x239 [Loop If]
				if(SettingIndex < Search.LocalizedSettings.Length)
				{
					SettingId = Search.LocalizedSettings[SettingIndex].Id;
					// End:0x22B
					if(SettingId != 32779)
					{
						SettingValueIndex = FindStoredSettingValueIndex(StoredSearchIndex, SettingId);
						// End:0x22B
						if((SettingValueIndex >= 0) && SettingValueIndex < StoredGameSearchValues[StoredSearchIndex].StoredValues.Length)
						{
							SettingValueId = StoredGameSearchValues[StoredSearchIndex].StoredValues[SettingValueIndex].ValueId;
							Search.SetStringSettingValue(SettingId, SettingValueId, false);
						}
					}
					SettingIndex++;
					// [Loop Continue]
					goto J0xBA;
				}
			}
		}
		GameIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SaveGameSearchParameters()
{
	local OnlineGameSearch Search;
	local int GameIndex, SettingIndex, SettingId, StoredSearchIndex, SettingValueIndex;

	local bool bDirty;

	GameIndex = 0;
	J0x0B:

	// End:0x31F [Loop If]
	if(GameIndex < GameSearchCfgList.Length)
	{
		Search = GameSearchCfgList[GameIndex].Search;
		// End:0x311
		if(Search != none)
		{
			StoredSearchIndex = FindStoredSearchIndex(GameSearchCfgList[GameIndex].SearchName);
			// End:0x133
			if(StoredSearchIndex == -1)
			{
				StoredSearchIndex = StoredGameSearchValues.Length;
				StoredGameSearchValues.Length = StoredSearchIndex + 1;
				StoredGameSearchValues[StoredSearchIndex].GameSearchName = GameSearchCfgList[GameIndex].SearchName;
				bDirty = true;
			}
			SettingIndex = 0;
			J0x13E:

			// End:0x311 [Loop If]
			if(SettingIndex < Search.LocalizedSettings.Length)
			{
				SettingId = Search.LocalizedSettings[SettingIndex].Id;
				// End:0x303
				if(SettingId != 32779)
				{
					SettingValueIndex = FindStoredSettingValueIndex(StoredSearchIndex, SettingId, true);
					bDirty = bDirty || StoredGameSearchValues[StoredSearchIndex].StoredValues[SettingValueIndex].ValueId != Search.LocalizedSettings[SettingIndex].ValueIndex;
					StoredGameSearchValues[StoredSearchIndex].StoredValues[SettingValueIndex].ValueId = Search.LocalizedSettings[SettingIndex].ValueIndex;
				}
				SettingIndex++;
				// [Loop Continue]
				goto J0x13E;
			}
		}
		GameIndex++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x32F
	if(bDirty)
	{
		SaveConfig();
	}
	//return;	
}

defaultproperties
{
	HistoryGameSearchDataStoreClass=Class'UTGame.UTDataStore_GameSearchHistory'
	GameSearchCfgList[0]=(GameSearchClass=Class'UTGame.UTGameSearchDM',DefaultGameSettingsClass=Class'UTGame.UTGameSettingsDM',SearchResultsProviderClass=Class'UTGame.UTUIDataProvider_SearchResult',DesiredSettingsProvider=none,Search=none,SearchName="UTGameSearchDM")
	GameSearchCfgList[1]=(GameSearchClass=Class'UTGame.UTGameSearchTDM',DefaultGameSettingsClass=Class'UTGame.UTGameSettingsTDM',SearchResultsProviderClass=Class'UTGame.UTUIDataProvider_SearchResult',DesiredSettingsProvider=none,Search=none,SearchName="UTGameSearchTDM")
	GameSearchCfgList[2]=(GameSearchClass=Class'UTGame.UTGameSearchCTF',DefaultGameSettingsClass=Class'UTGame.UTGameSettingsCTF',SearchResultsProviderClass=Class'UTGame.UTUIDataProvider_SearchResult',DesiredSettingsProvider=none,Search=none,SearchName="UTGameSearchCTF")
	GameSearchCfgList[3]=(GameSearchClass=Class'UTGame.UTGameSearchVCTF',DefaultGameSettingsClass=Class'UTGame.UTGameSettingsVCTF',SearchResultsProviderClass=Class'UTGame.UTUIDataProvider_SearchResult',DesiredSettingsProvider=none,Search=none,SearchName="UTGameSearchVCTF")
	GameSearchCfgList[4]=(GameSearchClass=Class'UTGame.UTGameSearchCustom',DefaultGameSettingsClass=Class'UTGame.UTGameSettingsDM',SearchResultsProviderClass=Class'UTGame.UTUIDataProvider_SearchResult',DesiredSettingsProvider=none,Search=none,SearchName="UTGameSearchCustom")
	Tag="UTGameSearch"
}