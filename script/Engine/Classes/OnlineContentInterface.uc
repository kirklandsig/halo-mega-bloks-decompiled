interface OnlineContentInterface extends Interface
	abstract;

delegate OnContentChange()
{
	//return;	
}

function AddContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255)
{
	//return;	
}

function ClearContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255)
{
	//return;	
}

delegate OnReadContentComplete(bool bWasSuccessful)
{
	//return;	
}

function AddReadContentComplete(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadContentComplete> ReadContentCompleteDelegate)
{
	//return;	
}

function ClearReadContentComplete(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadContentComplete> ReadContentCompleteDelegate)
{
	//return;	
}

function bool ReadContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, optional int DeviceID = -1)
{
	//return ReturnValue;	
}

function ClearContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType)
{
	//return;	
}

function OnlineSubsystem.EOnlineEnumerationReadState GetContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, out array<OnlineContent> ContentList)
{
	//return ReturnValue;	
}

function bool ReadCrossTitleContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, optional int TitleId = 0, optional int DeviceID = -1)
{
	//return ReturnValue;	
}

function ClearCrossTitleContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType)
{
	//return;	
}

function OnlineSubsystem.EOnlineEnumerationReadState GetCrossTitleContentList(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, out array<OnlineCrossTitleContent> ContentList)
{
	//return ReturnValue;	
}

delegate OnReadCrossTitleContentComplete(bool bWasSuccessful)
{
	//return;	
}

function AddReadCrossTitleContentCompleteDelegate(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadCrossTitleContentComplete> ReadContentCompleteDelegate)
{
	//return;	
}

function ClearReadCrossTitleContentCompleteDelegate(byte LocalUserNum, OnlineSubsystem.EOnlineContentType ContentType, delegate<OnReadCrossTitleContentComplete> ReadContentCompleteDelegate)
{
	//return;	
}

function bool ReadCrossTitleSaveGameData(byte LocalUserNum, int DeviceID, int TitleId, string FriendlyName, string Filename, string SaveFileName)
{
	//return ReturnValue;	
}

function bool GetCrossTitleSaveGameData(byte LocalUserNum, int DeviceID, int TitleId, string FriendlyName, string Filename, string SaveFileName, out byte bIsValid, out array<byte> SaveGameData)
{
	//return ReturnValue;	
}

delegate OnReadCrossTitleSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, int TitleId, string FriendlyName, string Filename, string SaveFileName)
{
	//return;	
}

function AddReadCrossTitleSaveGameDataComplete(byte LocalUserNum, delegate<OnReadCrossTitleSaveGameDataComplete> ReadSaveGameDataCompleteDelegate)
{
	//return;	
}

function ClearReadCrossTitleSaveGameDataComplete(byte LocalUserNum, delegate<OnReadCrossTitleSaveGameDataComplete> ReadSaveGameDataCompleteDelegate)
{
	//return;	
}

function bool ClearCrossTitleSaveGames(byte LocalUserNum)
{
	//return ReturnValue;	
}

function bool QueryAvailableDownloads(byte LocalUserNum, optional int CategoryMask = -1)
{
	//return ReturnValue;	
}

delegate OnQueryAvailableDownloadsComplete(bool bWasSuccessful)
{
	//return;	
}

function AddQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate)
{
	//return;	
}

function ClearQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate)
{
	//return;	
}

function GetAvailableDownloadCounts(byte LocalUserNum, out int NewDownloads, out int TotalDownloads)
{
	//return;	
}

function bool ReadSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	//return ReturnValue;	
}

function bool GetSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName, out byte bIsValid, out array<byte> SaveGameData)
{
	//return ReturnValue;	
}

delegate OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	//return;	
}

function AddReadSaveGameDataComplete(byte LocalUserNum, delegate<OnReadSaveGameDataComplete> ReadSaveGameDataCompleteDelegate)
{
	//return;	
}

function ClearReadSaveGameDataComplete(byte LocalUserNum, delegate<OnReadSaveGameDataComplete> ReadSaveGameDataCompleteDelegate)
{
	//return;	
}

function bool WriteSaveGameData(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName, const out array<byte> SaveGameData)
{
	//return ReturnValue;	
}

delegate OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	//return;	
}

function AddWriteSaveGameDataComplete(byte LocalUserNum, delegate<OnWriteSaveGameDataComplete> WriteSaveGameDataCompleteDelegate)
{
	//return;	
}

function ClearWriteSaveGameDataComplete(byte LocalUserNum, delegate<OnWriteSaveGameDataComplete> WriteSaveGameDataCompleteDelegate)
{
	//return;	
}

function bool DeleteSaveGame(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename)
{
	//return ReturnValue;	
}

function bool SaveGameExists(byte LocalUserNum, int DeviceID, string FriendlyName, string Filename)
{
	//return ReturnValue;	
}

function bool ClearSaveGames(byte LocalUserNum)
{
	//return ReturnValue;	
}
