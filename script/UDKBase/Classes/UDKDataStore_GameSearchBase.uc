class UDKDataStore_GameSearchBase extends UIDataStore_OnlineGameSearch
	abstract
	transient
	native
	config(Engine);

var transient UDKUIDataProvider_ServerDetails ServerDetailsProvider;

event Init()
{
	super.Init();
	// End:0x5B
	if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
	{
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
	}
	//return;	
}

event bool SubmitGameSearch(byte ControllerIndex, optional bool bInvalidateExistingSearchResults = true)
{
	local bool bResult;

	GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
	bResult = super.SubmitGameSearch(ControllerIndex, bInvalidateExistingSearchResults);
	// End:0x9E
	if(bResult!)
	{
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
	}
	return bResult;
	//return ReturnValue;	
}

function OnSearchComplete(bool bWasSuccessful)
{
	// End:0x41
	if(HasOutstandingQueries(true)!)
	{
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
	}
	super.OnSearchComplete(bWasSuccessful);
	//return;	
}

function bool HasOutstandingQueries(optional bool bRestrictCheckToSelf)
{
	local bool bResult;
	local int I;

	I = 0;
	J0x0C:

	// End:0xAE [Loop If]
	if(I < GameSearchCfgList.Length)
	{
		// End:0xA0
		if((GameSearchCfgList[I].Search != none) && GameSearchCfgList[I].Search.bIsSearchInProgress)
		{
			bResult = true;
			// [Explicit Break]
			goto J0xAE;
		}
		I++;
		// [Loop Continue]
		goto J0x0C;
	}
	J0xAE:

	return bResult;
	//return ReturnValue;	
}

function bool HasExistingSearchResults()
{
	local bool bQueryCompleted;

	// End:0x73
	if((SelectedIndex >= 0) && SelectedIndex < GameSearchCfgList.Length)
	{
		bQueryCompleted = GameSearchCfgList[SelectedIndex].Search.Results.Length > 0;
	}
	return bQueryCompleted;
	//return ReturnValue;	
}
