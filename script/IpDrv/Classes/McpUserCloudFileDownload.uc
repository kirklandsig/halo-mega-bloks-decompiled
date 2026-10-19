class McpUserCloudFileDownload extends McpServiceBase
	native
	config(Engine)
	implements(UserCloudFileInterface)
	dependson(OnlineSubsystem);

struct native McpUserCloudFileInfo extends EmsFile
{
	var string CreationDate;
	var string LastUpdateDate;
	var string CompressionType;
};

struct native McpUserCloudFilesEntry
{
	var string UserId;
	var array<TitleFileWeb> DownloadedFiles;
	var array<McpUserCloudFileInfo> EnumeratedFiles;
	var HttpRequestInterface HTTPRequestEnumerateFiles;

	structdefaultproperties
	{
		UserId=""
		DownloadedFiles=none
		EnumeratedFiles=none
		HTTPRequestEnumerateFiles=none
	}
};

var config string EnumerateCloudFilesUrl;
var config string ReadCloudFileUrl;
var config string WriteCloudFileUrl;
var config string DeleteCloudFileUrl;
var private array<McpUserCloudFilesEntry> UserCloudFileRequests;
var private array< delegate<OnEnumerateUserFilesComplete> > EnumerateUserFilesCompleteDelegates;
var private array< delegate<OnReadUserFileComplete> > ReadUserFileCompleteDelegates;
var private array< delegate<OnWriteUserFileComplete> > WriteUserFileCompleteDelegates;
var private array< delegate<OnDeleteUserFileComplete> > DeleteUserFileCompleteDelegates;
//var delegate<OnEnumerateUserFilesComplete> __OnEnumerateUserFilesComplete__Delegate;
//var delegate<OnReadUserFileComplete> __OnReadUserFileComplete__Delegate;
//var delegate<OnWriteUserFileComplete> __OnWriteUserFileComplete__Delegate;
//var delegate<OnDeleteUserFileComplete> __OnDeleteUserFileComplete__Delegate;

function bool GetFileContents(string UserId, string Filename, out array<byte> FileContents)
{
	local bool bResult;
	local int EntryIdx, FileIdx;

	EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
	// End:0x13E
	if(EntryIdx != -1)
	{
		FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Find('Filename', Filename);
		// End:0x13E
		if((FileIdx != -1) && int(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState) == int(2))
		{
			FileContents = UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Data;
			bResult = true;
		}
	}
	return bResult;
	//return ReturnValue;	
}

function bool ClearFiles(string UserId)
{
	local bool bResult;
	local int EntryIdx, FileIdx;

	EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
	// End:0x10F
	if(EntryIdx != -1)
	{
		FileIdx = 0;
		J0x47:

		// End:0xDA [Loop If]
		if(FileIdx < UserCloudFileRequests[EntryIdx].DownloadedFiles.Length)
		{
			// End:0xCC
			if(int(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState) == int(1))
			{
				return false;
			}
			FileIdx++;
			// [Loop Continue]
			goto J0x47;
		}
		UserCloudFileRequests[EntryIdx].DownloadedFiles.Length = 0;
		bResult = true;
	}
	return bResult;
	//return ReturnValue;	
}

function bool ClearFile(string UserId, string Filename)
{
	local bool bResult;
	local int EntryIdx, FileIdx;

	EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
	// End:0x123
	if(EntryIdx != -1)
	{
		FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Find('Filename', Filename);
		// End:0x123
		if((FileIdx != -1) && int(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState) != int(1))
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles.Remove(FileIdx, 1);
			bResult = true;
		}
	}
	return bResult;
	//return ReturnValue;	
}

function EnumerateUserFiles(string UserId)
{
	local int EntryIdx;
	local string URL;
	local bool bPending;

	EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
	// End:0x97
	if(EntryIdx == -1)
	{
		EntryIdx = UserCloudFileRequests.Length;
		UserCloudFileRequests.Length = EntryIdx + 1;
		UserCloudFileRequests[EntryIdx].UserId = UserId;
	}
	// End:0x29B
	if(UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles == none)
	{
		UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x298
		if(UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles != none)
		{
			URL = ((((GetBaseURL()) $ EnumerateCloudFilesUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UserId;
			UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles.SetURL(URL);
			UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles.SetVerb("GET");
			UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles.__OnProcessRequestComplete__Delegate = OnHTTPRequestEnumerateUserFilesComplete;
			UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles.ProcessRequest();
			bPending = true;
		}		
	}
	else
	{
		LogInternal(((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "User files already being enumerated for") $ " UserId=") $ UserId);
	}
	// End:0x34D
	if(!bPending)
	{
		CallEnumerateUserFileCompleteDelegates(false, UserId);
	}
	//return;	
}

private final function OnHTTPRequestEnumerateUserFilesComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local int EntryIdx, JsonIdx;
	local string JsonString, UserId;
	local JsonObject ParsedJson;
	local bool bResult;

	EntryIdx = UserCloudFileRequests.Find('HTTPRequestEnumerateFiles', Request);
	// End:0x693
	if(EntryIdx != -1)
	{
		UserId = UserCloudFileRequests[EntryIdx].UserId;
		// End:0x59F
		if(bWasSuccessful && Response.GetResponseCode() == 200)
		{
			UserCloudFileRequests[EntryIdx].EnumeratedFiles.Length = 0;
			JsonString = Response.GetContentAsString();
			// End:0x590
			if(JsonString != "")
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "") $ " JsonString=") $ JsonString);
				ParsedJson = Class'Engine.JsonObject'.static.DecodeJson(JsonString);
				UserCloudFileRequests[EntryIdx].EnumeratedFiles.Length = ParsedJson.ObjectArray.Length;
				JsonIdx = 0;
				J0x1F3:

				// End:0x590 [Loop If]
				if(JsonIdx < ParsedJson.ObjectArray.Length)
				{
					UserCloudFileRequests[EntryIdx].EnumeratedFiles[JsonIdx].Filename = ParsedJson.ObjectArray[JsonIdx].GetStringValue("file_name");
					UserCloudFileRequests[EntryIdx].EnumeratedFiles[JsonIdx].FileSize = int(ParsedJson.ObjectArray[JsonIdx].GetStringValue("file_size"));
					UserCloudFileRequests[EntryIdx].EnumeratedFiles[JsonIdx].DLName = ParsedJson.ObjectArray[JsonIdx].GetStringValue("file_name");
					UserCloudFileRequests[EntryIdx].EnumeratedFiles[JsonIdx].CreationDate = ParsedJson.ObjectArray[JsonIdx].GetStringValue("creation_date");
					UserCloudFileRequests[EntryIdx].EnumeratedFiles[JsonIdx].LastUpdateDate = ParsedJson.ObjectArray[JsonIdx].GetStringValue("last_update_time");
					UserCloudFileRequests[EntryIdx].EnumeratedFiles[JsonIdx].CompressionType = ParsedJson.ObjectArray[JsonIdx].GetStringValue("compression_type");
					JsonIdx++;
					// [Loop Continue]
					goto J0x1F3;
				}
			}
			bResult = true;			
		}
		else
		{
			LogInternal(((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to enumerate files for") $ " UserId=") $ UserCloudFileRequests[EntryIdx].UserId) $ " URL=") $ Request.GetURL());
		}
		UserCloudFileRequests[EntryIdx].HTTPRequestEnumerateFiles = none;
	}
	CallEnumerateUserFileCompleteDelegates(bResult, UserId);
	//return;	
}

delegate OnEnumerateUserFilesComplete(bool bWasSuccessful, string UserId)
{
	//return;	
}

private final function CallEnumerateUserFileCompleteDelegates(bool bWasSuccessful, string UserId)
{
	local int Index;
	local delegate<OnEnumerateUserFilesComplete> CallDelegate;

	Index = 0;
	J0x0B:

	// End:0x83 [Loop If]
	if(Index < EnumerateUserFilesCompleteDelegates.Length)
	{
		CallDelegate = EnumerateUserFilesCompleteDelegates[Index];
		// End:0x75
		if(CallDelegate != none)
		{
			OnEnumerateUserFilesComplete(bWasSuccessful, UserId);
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function AddEnumerateUserFileCompleteDelegate(delegate<OnEnumerateUserFilesComplete> EnumerateUserFileCompleteDelegate)
{
	// End:0x36
	if(EnumerateUserFilesCompleteDelegates.Find(EnumerateUserFileCompleteDelegate) == -1)
	{
		EnumerateUserFilesCompleteDelegates.AddItem(EnumerateUserFileCompleteDelegate);
	}
	//return;	
}

function ClearEnumerateUserFileCompleteDelegate(delegate<OnEnumerateUserFilesComplete> EnumerateUserFileCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = EnumerateUserFilesCompleteDelegates.Find(EnumerateUserFileCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		EnumerateUserFilesCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function GetUserFileList(string UserId, out array<EmsFile> UserFiles)
{
	local int EntryIdx, FileIdx;

	EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
	// End:0x1FD
	if(EntryIdx != -1)
	{
		UserFiles.Length = UserCloudFileRequests[EntryIdx].EnumeratedFiles.Length;
		FileIdx = 0;
		J0x79:

		// End:0x1FA [Loop If]
		if(FileIdx < UserCloudFileRequests[EntryIdx].EnumeratedFiles.Length)
		{
			UserFiles[FileIdx].DLName = UserCloudFileRequests[EntryIdx].EnumeratedFiles[FileIdx].DLName;
			UserFiles[FileIdx].Filename = UserCloudFileRequests[EntryIdx].EnumeratedFiles[FileIdx].Filename;
			UserFiles[FileIdx].FileSize = UserCloudFileRequests[EntryIdx].EnumeratedFiles[FileIdx].FileSize;
			FileIdx++;
			// [Loop Continue]
			goto J0x79;
		}		
	}
	else
	{
		UserFiles.Length = 0;
	}
	//return;	
}

function bool ReadUserFile(string UserId, string Filename)
{
	local int EntryIdx, FileIdx;
	local string URL;
	local bool bPending;

	// End:0x630
	if((Len(UserId) > 0) && Len(Filename) > 0)
	{
		EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
		// End:0xBB
		if(EntryIdx == -1)
		{
			EntryIdx = UserCloudFileRequests.Length;
			UserCloudFileRequests.Length = EntryIdx + 1;
			UserCloudFileRequests[EntryIdx].UserId = UserId;
		}
		FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Find('Filename', Filename);
		// End:0x1C6
		if(FileIdx == -1)
		{
			FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Length;
			UserCloudFileRequests[EntryIdx].DownloadedFiles.Length = FileIdx + 1;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Filename = Filename;
		}
		// End:0x58A
		if((int(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState) != int(1)) && UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest == none)
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 1;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Data.Length = 0;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest = Class'Engine.HttpFactory'.static.CreateRequest();
			// End:0x587
			if(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest != none)
			{
				URL = ((((((GetBaseURL()) $ ReadCloudFileUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UserId) $ "&fileName=") $ Filename;
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetURL(URL);
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetVerb("GET");
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.__OnProcessRequestComplete__Delegate = OnHTTPRequestReadUserFileComplete;
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.ProcessRequest();
				bPending = true;
			}			
		}
		else
		{
			LogInternal(((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "File operation already in progress") $ " UserId=") $ UserId) $ " FileName=") $ Filename);
		}		
	}
	else
	{
		LogInternal(((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Invalid parameters") $ " UserId=") $ UserId) $ " FileName=") $ Filename);
	}
	// End:0x6EF
	if(!bPending)
	{
		CallReadUserFileCompleteDelegates(false, UserId, Filename);
	}
	return bPending;
	//return ReturnValue;	
}

private final function OnHTTPRequestReadUserFileComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local int EntryIdx, FileIdx;
	local string Filename, UserId;
	local bool bResult;
	local array<byte> FileContents;

	GetUserFileIndexForRequest(Request, EntryIdx, FileIdx);
	// End:0x268
	if((EntryIdx != -1) && FileIdx != -1)
	{
		UserId = UserCloudFileRequests[EntryIdx].UserId;
		Filename = UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Filename;
		// End:0x1DA
		if((bWasSuccessful && Response != none) && Response.GetResponseCode() == 200)
		{
			Response.GetContent(FileContents);
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Data = FileContents;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 2;
			bResult = true;			
		}
		else
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 3;
		}
		UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest = none;		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find entry index");
	}
	CallReadUserFileCompleteDelegates(bResult, UserId, Filename);
	//return;	
}

delegate OnReadUserFileComplete(bool bWasSuccessful, string UserId, string Filename)
{
	//return;	
}

private final function CallReadUserFileCompleteDelegates(bool bWasSuccessful, string UserId, string Filename)
{
	local int Index;
	local delegate<OnReadUserFileComplete> CallDelegate;

	Index = 0;
	J0x0B:

	// End:0x8C [Loop If]
	if(Index < ReadUserFileCompleteDelegates.Length)
	{
		CallDelegate = ReadUserFileCompleteDelegates[Index];
		// End:0x7E
		if(CallDelegate != none)
		{
			OnReadUserFileComplete(bWasSuccessful, UserId, Filename);
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function AddReadUserFileCompleteDelegate(delegate<OnReadUserFileComplete> ReadUserFileCompleteDelegate)
{
	// End:0x36
	if(ReadUserFileCompleteDelegates.Find(ReadUserFileCompleteDelegate) == -1)
	{
		ReadUserFileCompleteDelegates.AddItem(ReadUserFileCompleteDelegate);
	}
	//return;	
}

function ClearReadUserFileCompleteDelegate(delegate<OnReadUserFileComplete> ReadUserFileCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = ReadUserFileCompleteDelegates.Find(ReadUserFileCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		ReadUserFileCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function bool WriteUserFile(string UserId, string Filename, const out array<byte> FileContents)
{
	local int EntryIdx, FileIdx;
	local string URL;
	local bool bPending;

	// End:0x728
	if(((Len(UserId) > 0) && Len(Filename) > 0) && FileContents.Length > 0)
	{
		EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
		// End:0xCD
		if(EntryIdx == -1)
		{
			EntryIdx = UserCloudFileRequests.Length;
			UserCloudFileRequests.Length = EntryIdx + 1;
			UserCloudFileRequests[EntryIdx].UserId = UserId;
		}
		FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Find('Filename', Filename);
		// End:0x1D8
		if(FileIdx == -1)
		{
			FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Length;
			UserCloudFileRequests[EntryIdx].DownloadedFiles.Length = FileIdx + 1;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Filename = Filename;
		}
		// End:0x682
		if((int(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState) != int(1)) && UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest == none)
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 1;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Data = FileContents;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest = Class'Engine.HttpFactory'.static.CreateRequest();
			// End:0x67F
			if(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest != none)
			{
				URL = ((((((GetBaseURL()) $ WriteCloudFileUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UserId) $ "&fileName=") $ Filename;
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetURL(URL);
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetVerb("POST");
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetHeader("Content-Type", "multipart/form-data");
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetContent(FileContents);
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.__OnProcessRequestComplete__Delegate = OnHTTPRequestWriteUserFileComplete;
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.ProcessRequest();
				bPending = true;
			}			
		}
		else
		{
			LogInternal(((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "File operation already in progress") $ " UserId=") $ UserId) $ " FileName=") $ Filename);
		}		
	}
	else
	{
		LogInternal(((((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Invalid parameters") $ " UserId=") $ UserId) $ " FileName=") $ Filename) $ " FileContents=") $ string(FileContents.Length));
	}
	// End:0x807
	if(!bPending)
	{
		CallWriteUserFileCompleteDelegates(false, UserId, Filename);
	}
	return bPending;
	//return ReturnValue;	
}

private final function GetUserFileIndexForRequest(HttpRequestInterface Request, out int UserIdx, out int FileIdx)
{
	UserIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(UserIdx < UserCloudFileRequests.Length)
	{
		FileIdx = UserCloudFileRequests[UserIdx].DownloadedFiles.Find('HTTPRequest', Request);
		// End:0x7F
		if(FileIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		UserIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0xAF
	if(FileIdx == -1)
	{
		UserIdx = -1;
	}
	//return;	
}

private final function OnHTTPRequestWriteUserFileComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local int EntryIdx, FileIdx;
	local string Filename, UserId;
	local bool bResult;

	GetUserFileIndexForRequest(Request, EntryIdx, FileIdx);
	// End:0x1F3
	if((EntryIdx != -1) && FileIdx != -1)
	{
		UserId = UserCloudFileRequests[EntryIdx].UserId;
		Filename = UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Filename;
		// End:0x165
		if((bWasSuccessful && Response != none) && Response.GetResponseCode() == 200)
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 2;
			bResult = true;			
		}
		else
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 3;
		}
		UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest = none;		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find entry index");
	}
	CallWriteUserFileCompleteDelegates(bResult, UserId, Filename);
	//return;	
}

delegate OnWriteUserFileComplete(bool bWasSuccessful, string UserId, string Filename)
{
	//return;	
}

private final function CallWriteUserFileCompleteDelegates(bool bWasSuccessful, string UserId, string Filename)
{
	local int Index;
	local delegate<OnWriteUserFileComplete> CallDelegate;

	Index = 0;
	J0x0B:

	// End:0x8C [Loop If]
	if(Index < WriteUserFileCompleteDelegates.Length)
	{
		CallDelegate = WriteUserFileCompleteDelegates[Index];
		// End:0x7E
		if(CallDelegate != none)
		{
			OnWriteUserFileComplete(bWasSuccessful, UserId, Filename);
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function AddWriteUserFileCompleteDelegate(delegate<OnWriteUserFileComplete> WriteUserFileCompleteDelegate)
{
	// End:0x36
	if(WriteUserFileCompleteDelegates.Find(WriteUserFileCompleteDelegate) == -1)
	{
		WriteUserFileCompleteDelegates.AddItem(WriteUserFileCompleteDelegate);
	}
	//return;	
}

function ClearWriteUserFileCompleteDelegate(delegate<OnWriteUserFileComplete> WriteUserFileCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = WriteUserFileCompleteDelegates.Find(WriteUserFileCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		WriteUserFileCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function bool DeleteUserFile(string UserId, string Filename, bool bShouldCloudDelete, bool bShouldLocallyDelete)
{
	local int EntryIdx, FileIdx;
	local string URL;
	local bool bPending;

	// End:0x642
	if(((Len(UserId) > 0) && Len(Filename) > 0) && bShouldCloudDelete)
	{
		EntryIdx = UserCloudFileRequests.Find('UserId', UserId);
		// End:0xCA
		if(EntryIdx == -1)
		{
			EntryIdx = UserCloudFileRequests.Length;
			UserCloudFileRequests.Length = EntryIdx + 1;
			UserCloudFileRequests[EntryIdx].UserId = UserId;
		}
		FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Find('Filename', Filename);
		// End:0x1D5
		if(FileIdx == -1)
		{
			FileIdx = UserCloudFileRequests[EntryIdx].DownloadedFiles.Length;
			UserCloudFileRequests[EntryIdx].DownloadedFiles.Length = FileIdx + 1;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Filename = Filename;
		}
		// End:0x59C
		if((int(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState) != int(1)) && UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest == none)
		{
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].AsyncState = 1;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Data.Length = 0;
			UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest = Class'Engine.HttpFactory'.static.CreateRequest();
			// End:0x599
			if(UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest != none)
			{
				URL = ((((((GetBaseURL()) $ DeleteCloudFileUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UserId) $ "&fileName=") $ Filename;
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetURL(URL);
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.SetVerb("DELETE");
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.__OnProcessRequestComplete__Delegate = OnHTTPRequestDeleteUserFileComplete;
				UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].HTTPRequest.ProcessRequest();
				bPending = true;
			}			
		}
		else
		{
			LogInternal(((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "File operation already in progress") $ " UserId=") $ UserId) $ " FileName=") $ Filename);
		}		
	}
	else
	{
		LogInternal(((((((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Invalid parameters") $ " UserId=") $ UserId) $ " FileName=") $ Filename);
	}
	// End:0x73B
	if(!bPending)
	{
		// End:0x711
		if(bShouldCloudDelete)
		{
			CallDeleteUserFileCompleteDelegates(false, UserId, Filename);			
		}
		else
		{
			// End:0x73B
			if(bShouldLocallyDelete)
			{
				CallDeleteUserFileCompleteDelegates(true, UserId, Filename);
			}
		}
	}
	return bPending;
	//return ReturnValue;	
}

private final function OnHTTPRequestDeleteUserFileComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local int EntryIdx, FileIdx;
	local string Filename, UserId;
	local bool bResult;

	GetUserFileIndexForRequest(Request, EntryIdx, FileIdx);
	// End:0x151
	if((EntryIdx != -1) && FileIdx != -1)
	{
		UserId = UserCloudFileRequests[EntryIdx].UserId;
		Filename = UserCloudFileRequests[EntryIdx].DownloadedFiles[FileIdx].Filename;
		// End:0x11C
		if((bWasSuccessful && Response != none) && Response.GetResponseCode() == 200)
		{
			bResult = true;
		}
		UserCloudFileRequests[EntryIdx].DownloadedFiles.Remove(FileIdx, 1);		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") McpUserCloudFileDownload::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find entry index");
	}
	CallDeleteUserFileCompleteDelegates(bResult, UserId, Filename);
	//return;	
}

delegate OnDeleteUserFileComplete(bool bWasSuccessful, string UserId, string Filename)
{
	//return;	
}

private final function CallDeleteUserFileCompleteDelegates(bool bWasSuccessful, string UserId, string Filename)
{
	local int Index;
	local delegate<OnDeleteUserFileComplete> CallDelegate;

	Index = 0;
	J0x0B:

	// End:0x8C [Loop If]
	if(Index < DeleteUserFileCompleteDelegates.Length)
	{
		CallDelegate = DeleteUserFileCompleteDelegates[Index];
		// End:0x7E
		if(CallDelegate != none)
		{
			OnDeleteUserFileComplete(bWasSuccessful, UserId, Filename);
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function AddDeleteUserFileCompleteDelegate(delegate<OnDeleteUserFileComplete> DeleteUserFileCompleteDelegate)
{
	// End:0x36
	if(DeleteUserFileCompleteDelegates.Find(DeleteUserFileCompleteDelegate) == -1)
	{
		DeleteUserFileCompleteDelegates.AddItem(DeleteUserFileCompleteDelegate);
	}
	//return;	
}

function ClearDeleteUserFileCompleteDelegate(delegate<OnDeleteUserFileComplete> DeleteUserFileCompleteDelegate)
{
	local int RemoveIndex;

	RemoveIndex = DeleteUserFileCompleteDelegates.Find(DeleteUserFileCompleteDelegate);
	// End:0x48
	if(RemoveIndex != -1)
	{
		DeleteUserFileCompleteDelegates.Remove(RemoveIndex, 1);
	}
	//return;	
}

function ClearAllDelegates()
{
	EnumerateUserFilesCompleteDelegates.Length = 0;
	ReadUserFileCompleteDelegates.Length = 0;
	WriteUserFileCompleteDelegates.Length = 0;
	DeleteUserFileCompleteDelegates.Length = 0;
	//return;	
}

defaultproperties
{
	EnumerateCloudFilesUrl="/cloudstoragelist"
	ReadCloudFileUrl="/cloudstoragecontents"
	WriteCloudFileUrl="/cloudstoragesave"
	DeleteCloudFileUrl="/cloudstoragedelete"
}