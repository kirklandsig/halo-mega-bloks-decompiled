class McpClashMobManager extends McpClashMobBase
	config(Engine);

struct McpChallengeRequest
{
	var string UniqueChallengeId;
	var HttpRequestInterface HTTPRequest;

	structdefaultproperties
	{
		UniqueChallengeId=""
		HTTPRequest=none
	}
};

struct McpChallengeUserRequest
{
	var string UniqueUserId;
	var array<McpChallengeRequest> ChallengeStatusRequests;
	var array<McpChallengeRequest> ChallengeAcceptRequests;
	var array<McpChallengeRequest> ChallengeUpdateProgressRequests;
	var array<McpChallengeRequest> ChallengeUpdateRewardRequests;

	structdefaultproperties
	{
		UniqueUserId=""
		ChallengeStatusRequests=none
		ChallengeAcceptRequests=none
		ChallengeUpdateProgressRequests=none
		ChallengeUpdateRewardRequests=none
	}
};

var config string ChallengeListUrl;
var config string ChallengeStatusUrl;
var config string ChallengeMultiStatusUrl;
var config string AcceptChallengeUrl;
var config string UpdateChallengeProgressUrl;
var config string UpdateRewardProgressUrl;
var HttpRequestInterface HTTPRequestChallengeList;
var array<McpChallengeUserRequest> ChallengeUserRequests;
var array<McpClashMobChallengeEvent> ChallengeEvents;
var array<McpClashMobChallengeUserStatus> ChallengeUserStatus;
var McpClashMobChallengeUserStatus TempChallengeUserStatus;
var array<McpClashMobChallengeUserStatus> TempChallengeUserStatusArray;
var OnlineTitleFileCacheInterface FileCache;
var McpClashMobFileDownload FileDownloader;

function Init()
{
	super(McpServiceBase).Init();
	// End:0x9C
	if(EqualEqual_InterfaceInterface(FileCache, OnlineTitleFileCacheInterface(none)))
	{
		FileCache = OnlineTitleFileCacheInterface(new Class'IpDrv.TitleFileDownloadCache');
		// End:0x9C
		if(NotEqual_InterfaceInterface(FileCache, OnlineTitleFileCacheInterface(none)))
		{
			FileCache.AddLoadTitleFileCompleteDelegate(OnLoadCachedFileComplete);
		}
	}
	// End:0x121
	if(FileDownloader == none)
	{
		FileDownloader = new Class'IpDrv.McpClashMobFileDownload';
		FileDownloader.Init();
		// End:0x121
		if(FileDownloader != none)
		{
			FileDownloader.AddReadTitleFileCompleteDelegate(OnDownloadMcpFileComplete);
		}
	}
	//return;	
}

function QueryChallengeList()
{
	local string URL, ErrorStr;
	local bool bPending;

	// End:0x156
	if(HTTPRequestChallengeList == none)
	{
		HTTPRequestChallengeList = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x153
		if(HTTPRequestChallengeList != none)
		{
			URL = ((GetBaseURL()) $ ChallengeListUrl) $ (GetAppAccessURL());
			HTTPRequestChallengeList.SetURL(URL);
			HTTPRequestChallengeList.SetVerb("GET");
			HTTPRequestChallengeList.__OnProcessRequestComplete__Delegate = OnQueryChallengeListHTTPRequestComplete;
			// End:0x11F
			if(HTTPRequestChallengeList.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
	}
	// End:0x1D6
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x202
	if(!bPending)
	{
		OnQueryChallengeListComplete(false, ErrorStr);
	}
	//return;	
}

private final function OnQueryChallengeListHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string JSONStr, ErrorStr;
	local bool bResult;

	HTTPRequestChallengeList = none;
	// End:0x102
	if(bWasSuccessful && Response != none)
	{
		// End:0xAB
		if(Response.GetResponseCode() == 200)
		{
			JSONStr = Response.GetContentAsString();
			ImportJSON("ChallengeEvents", JSONStr);
			bResult = true;			
		}
		else
		{
			ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
		}		
	}
	else
	{
		ErrorStr = "no response";
	}
	// End:0x168
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnQueryChallengeListComplete(bResult, ErrorStr);
	//return;	
}

function GetChallengeList(out array<McpClashMobChallengeEvent> OutChallengeEvents)
{
	OutChallengeEvents = ChallengeEvents;
	//return;	
}

function GetChallengeFileList(string UniqueChallengeId, out array<McpClashMobChallengeFile> OutChallengeFiles)
{
	local int ChallengeEventIdx;

	OutChallengeFiles.Length = 0;
	ChallengeEventIdx = ChallengeEvents.Find('unique_challenge_id', UniqueChallengeId);
	// End:0x7B
	if(ChallengeEventIdx != -1)
	{
		OutChallengeFiles = ChallengeEvents[ChallengeEventIdx].file_list;		
	}
	else
	{
		LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find event entry for") $ " UniqueChallengeId=") $ UniqueChallengeId);
	}
	//return;	
}

function DownloadChallengeFile(string UniqueChallengeId, string DLName)
{
	local string ErrorStr;
	local int ChallengeIdx, FileIdx;
	local bool bPending;

	ChallengeIdx = ChallengeEvents.Find('unique_challenge_id', UniqueChallengeId);
	// End:0x1A0
	if(ChallengeIdx != -1)
	{
		FileIdx = ChallengeEvents[ChallengeIdx].file_list.Find('dl_name', DLName);
		// End:0x13C
		if(FileIdx != -1)
		{
			ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status = 1;
			FileCache.ClearCachedFile(DLName);
			FileCache.LoadTitleFile(DLName);
			bPending = true;			
		}
		else
		{
			ErrorStr = ((("Couldn't find file entry for" $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DlName=") $ UniqueChallengeId;
		}		
	}
	else
	{
		ErrorStr = ("Couldn't find event entry for" $ " UniqueChallengeId=") $ UniqueChallengeId;
	}
	// End:0x23A
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x27A
	if(!bPending)
	{
		OnDownloadChallengeFileComplete(false, UniqueChallengeId, DLName, "", ErrorStr);
	}
	//return;	
}

private final function OnLoadCachedFileComplete(bool bWasSuccessful, string DLName)
{
	local bool bRequiresDownload;
	local string FileHashCache, FileHashChallenge, Filename;
	local int ChallengeIdx, FileIdx;
	local array<byte> FileContents;

	ChallengeIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(ChallengeIdx < ChallengeEvents.Length)
	{
		FileIdx = ChallengeEvents[ChallengeIdx].file_list.Find('dl_name', DLName);
		// End:0x7F
		if(FileIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		ChallengeIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x4CF
	if(FileIdx != -1)
	{
		ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status = 3;
		Filename = ChallengeEvents[ChallengeIdx].file_list[FileIdx].file_name;
		bRequiresDownload = true;
		// End:0x366
		if(bWasSuccessful)
		{
			FileHashChallenge = ChallengeEvents[ChallengeIdx].file_list[FileIdx].hash_code;
			// End:0x366
			if(Len(FileHashChallenge) > 0)
			{
				FileHashCache = FileCache.GetTitleFileHash(DLName);
				// End:0x366
				if((FileHashCache == FileHashChallenge) && FileCache.GetTitleFileContents(DLName, FileContents))
				{
					LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Found challenge file in cache with valid hash. DLName=") $ DLName) @ "in file cache. Not downloading.");
					ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status = 2;
					OnDownloadChallengeFileComplete(true, ChallengeEvents[ChallengeIdx].unique_challenge_id, DLName, Filename, "");
					bRequiresDownload = false;
				}
			}
		}
		// End:0x4CC
		if(bRequiresDownload)
		{
			LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Did not find challenge file DLName=") $ DLName) @ "in file cache with valid hash. Starting download.");
			ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status = 1;
			FileCache.DeleteTitleFile(DLName);
			FileDownloader.ClearDownloadedFile(DLName);
			FileDownloader.ReadTitleFile(DLName);
		}		
	}
	else
	{
		LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Could not find DLName=") $ DLName) @ "for challenge");
	}
	//return;	
}

function OnDownloadMcpFileComplete(bool bWasSuccessful, string DLName)
{
	local array<byte> FileContents;
	local int ChallengeIdx, FileIdx;
	local string Filename;

	ChallengeIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(ChallengeIdx < ChallengeEvents.Length)
	{
		FileIdx = ChallengeEvents[ChallengeIdx].file_list.Find('dl_name', DLName);
		// End:0x7F
		if(FileIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		ChallengeIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x387
	if(FileIdx != -1)
	{
		// End:0x2E4
		if(bWasSuccessful && FileDownloader.GetTitleFileContents(DLName, FileContents))
		{
			LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Downloaded challenge file. DLName=") $ DLName) @ ". Copying to file cache.");
			ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status = 2;
			Filename = ChallengeEvents[ChallengeIdx].file_list[FileIdx].file_name;
			FileCache.SaveTitleFile(DLName, ChallengeEvents[ChallengeIdx].file_list[FileIdx].file_name, FileContents);
			FileDownloader.ClearDownloadedFile(DLName);
			OnDownloadChallengeFileComplete(true, ChallengeEvents[ChallengeIdx].unique_challenge_id, DLName, Filename, "");			
		}
		else
		{
			ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status = 3;
			OnDownloadChallengeFileComplete(false, ChallengeEvents[ChallengeIdx].unique_challenge_id, DLName, Filename, "FileNotFound");
		}		
	}
	else
	{
		LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Could not find DLName=") $ DLName) @ "for challenge");
	}
	//return;	
}

function GetChallengeFileContents(string UniqueChallengeId, string DLName, out array<byte> OutFileContents)
{
	local int ChallengeIdx, FileIdx;

	OutFileContents.Length = 0;
	ChallengeIdx = ChallengeEvents.Find('unique_challenge_id', UniqueChallengeId);
	// End:0x245
	if(ChallengeIdx != -1)
	{
		FileIdx = ChallengeEvents[ChallengeIdx].file_list.Find('dl_name', DLName);
		// End:0x1B9
		if(FileIdx != -1)
		{
			// End:0x1B6
			if((int(ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status) != int(2)) || !FileCache.GetTitleFileContents(DLName, OutFileContents))
			{
				LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "No data loaded for file entry.") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DLName=") $ DLName);
			}			
		}
		else
		{
			LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find file entry.") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DLName=") $ DLName);
		}		
	}
	else
	{
		LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find event entry.") $ " UniqueChallengeId=") $ UniqueChallengeId);
	}
	//return;	
}

function ClearCachedChallengeFile(string UniqueChallengeId, string DLName)
{
	local int ChallengeIdx, FileIdx;

	ChallengeIdx = ChallengeEvents.Find('unique_challenge_id', UniqueChallengeId);
	// End:0x231
	if(ChallengeIdx != -1)
	{
		FileIdx = ChallengeEvents[ChallengeIdx].file_list.Find('dl_name', DLName);
		// End:0x1A5
		if(FileIdx != -1)
		{
			// End:0x10F
			if(int(ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status) != int(1))
			{
				FileCache.ClearCachedFile(DLName);				
			}
			else
			{
				LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Can't clear. File download pending.") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DLName=") $ DLName);
			}			
		}
		else
		{
			LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find file entry.") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DLName=") $ DLName);
		}		
	}
	else
	{
		LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find event entry.") $ " UniqueChallengeId=") $ UniqueChallengeId);
	}
	//return;	
}

function DeleteCachedChallengeFile(string UniqueChallengeId, string DLName)
{
	local int ChallengeIdx, FileIdx;

	ChallengeIdx = ChallengeEvents.Find('unique_challenge_id', UniqueChallengeId);
	// End:0x232
	if(ChallengeIdx != -1)
	{
		FileIdx = ChallengeEvents[ChallengeIdx].file_list.Find('dl_name', DLName);
		// End:0x1A6
		if(FileIdx != -1)
		{
			// End:0x10F
			if(int(ChallengeEvents[ChallengeIdx].file_list[FileIdx].Status) != int(1))
			{
				FileCache.DeleteTitleFile(DLName);				
			}
			else
			{
				LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Can't delete. File download pending.") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DLName=") $ DLName);
			}			
		}
		else
		{
			LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find file entry.") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " DLName=") $ DLName);
		}		
	}
	else
	{
		LogInternal(((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find event entry.") $ " UniqueChallengeId=") $ UniqueChallengeId);
	}
	//return;	
}

function AcceptChallenge(string UniqueChallengeId, string UniqueUserId)
{
	local string URL, ErrorStr;
	local int ChallengeQueryIdx, UserQueryIdx;
	local bool bPending;
	local HttpRequestInterface Request;

	UserQueryIdx = ChallengeUserRequests.Find('UniqueUserId', UniqueUserId);
	// End:0x98
	if(UserQueryIdx == -1)
	{
		UserQueryIdx = ChallengeUserRequests.Length;
		ChallengeUserRequests.Length = ChallengeUserRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].UniqueUserId = UniqueUserId;
	}
	ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests.Find('UniqueChallengeId', UniqueChallengeId);
	// End:0x1C1
	if(ChallengeQueryIdx == -1)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests.Length;
		ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests.Length = ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests[ChallengeQueryIdx].UniqueChallengeId = UniqueChallengeId;
	}
	// End:0x420
	if(ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests[ChallengeQueryIdx].HTTPRequest == none)
	{
		Request = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x41D
		if(Request != none)
		{
			ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests[ChallengeQueryIdx].HTTPRequest = Request;
			URL = ((((((GetBaseURL()) $ AcceptChallengeUrl) $ (GetAppAccessURL())) $ "&uniqueChallengeId=") $ UniqueChallengeId) $ "&uniqueUserId=") $ UniqueUserId;
			Request.SetURL(URL);
			Request.SetVerb("POST");
			Request.SetHeader("Content-Type", "multipart/form-data");
			Request.__OnProcessRequestComplete__Delegate = OnAcceptChallengeHTTPRequestComplete;
			// End:0x3E9
			if(Request.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
	}
	// End:0x4A0
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x4DE
	if(!bPending)
	{
		OnAcceptChallengeComplete(false, UniqueChallengeId, UniqueUserId, ErrorStr);
	}
	//return;	
}

private final function OnAcceptChallengeHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string UniqueChallengeId, UniqueUserId, ErrorStr;
	local bool bResult;
	local int UserQueryIdx, ChallengeQueryIdx;

	UserQueryIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(UserQueryIdx < ChallengeUserRequests.Length)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests.Find('HTTPRequest', Request);
		// End:0x7F
		if(ChallengeQueryIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		UserQueryIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x23B
	if((UserQueryIdx != -1) && ChallengeQueryIdx != -1)
	{
		ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests[ChallengeQueryIdx].HTTPRequest = none;
		UniqueUserId = ChallengeUserRequests[UserQueryIdx].UniqueUserId;
		UniqueChallengeId = ChallengeUserRequests[UserQueryIdx].ChallengeAcceptRequests[ChallengeQueryIdx].UniqueChallengeId;
		// End:0x221
		if(bWasSuccessful && Response != none)
		{
			// End:0x1CA
			if(Response.GetResponseCode() == 200)
			{
				bResult = true;				
			}
			else
			{
				ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
			}			
		}
		else
		{
			ErrorStr = "no response";
		}		
	}
	else
	{
		ErrorStr = "couldn't find user/challenge entry for request";
	}
	// End:0x2C4
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnAcceptChallengeComplete(bResult, UniqueChallengeId, UniqueUserId, ErrorStr);
	//return;	
}

function QueryChallengeUserStatus(string UniqueChallengeId, string UniqueUserId)
{
	local string URL, ErrorStr;
	local int ChallengeQueryIdx, UserQueryIdx;
	local bool bPending;
	local HttpRequestInterface Request;

	UserQueryIdx = ChallengeUserRequests.Find('UniqueUserId', UniqueUserId);
	// End:0x98
	if(UserQueryIdx == -1)
	{
		UserQueryIdx = ChallengeUserRequests.Length;
		ChallengeUserRequests.Length = ChallengeUserRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].UniqueUserId = UniqueUserId;
	}
	ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Find('UniqueChallengeId', UniqueChallengeId);
	// End:0x1C1
	if(ChallengeQueryIdx == -1)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Length;
		ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Length = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].UniqueChallengeId = UniqueChallengeId;
	}
	// End:0x420
	if(ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].HTTPRequest == none)
	{
		Request = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x41D
		if(Request != none)
		{
			ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].HTTPRequest = Request;
			URL = ((((((GetBaseURL()) $ ChallengeStatusUrl) $ (GetAppAccessURL())) $ "&uniqueChallengeId=") $ UniqueChallengeId) $ "&uniqueUserId=") $ UniqueUserId;
			Request.SetURL(URL);
			Request.SetVerb("POST");
			Request.SetHeader("Content-Type", "multipart/form-data");
			Request.__OnProcessRequestComplete__Delegate = OnQueryChallengeStatusHTTPRequestComplete;
			// End:0x3E9
			if(Request.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
	}
	// End:0x4A0
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x4DE
	if(!bPending)
	{
		OnQueryChallengeUserStatusComplete(false, UniqueChallengeId, UniqueUserId, ErrorStr);
	}
	//return;	
}

private final function OnQueryChallengeStatusHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string JSONStr, UniqueChallengeId, UniqueUserId, ErrorStr;
	local bool bResult;
	local int UserQueryIdx, ChallengeQueryIdx, UserStatusIdx;

	UserQueryIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(UserQueryIdx < ChallengeUserRequests.Length)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Find('HTTPRequest', Request);
		// End:0x7F
		if(ChallengeQueryIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		UserQueryIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x3D4
	if((UserQueryIdx < ChallengeUserRequests.Length) && ChallengeQueryIdx != -1)
	{
		ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].HTTPRequest = none;
		UniqueUserId = ChallengeUserRequests[UserQueryIdx].UniqueUserId;
		UniqueChallengeId = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].UniqueChallengeId;
		// End:0x3BA
		if(bWasSuccessful && Response != none)
		{
			// End:0x363
			if(Response.GetResponseCode() == 200)
			{
				JSONStr = Response.GetContentAsString();
				// End:0x344
				if(Len(JSONStr) > 0)
				{
					ImportJSON("TempChallengeUserStatus", JSONStr);
					// End:0x335
					if(Len(TempChallengeUserStatus.unique_challenge_id) > 0)
					{
						UserStatusIdx = 0;
						J0x255:

						// End:0x2E8 [Loop If]
						if(UserStatusIdx < ChallengeUserStatus.Length)
						{
							// End:0x2DA
							if((ChallengeUserStatus[UserStatusIdx].unique_challenge_id == UniqueChallengeId) && ChallengeUserStatus[UserStatusIdx].unique_user_id == UniqueUserId)
							{
								// [Explicit Break]
								goto J0x2E8;
							}
							UserStatusIdx++;
							// [Loop Continue]
							goto J0x255;
						}
						J0x2E8:

						// End:0x318
						if(UserStatusIdx == ChallengeUserStatus.Length)
						{
							ChallengeUserStatus.Length = ChallengeUserStatus.Length + 1;
						}
						ChallengeUserStatus[UserStatusIdx] = TempChallengeUserStatus;
					}
					bResult = true;					
				}
				else
				{
					ErrorStr = "no JSON response";
				}				
			}
			else
			{
				ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
			}			
		}
		else
		{
			ErrorStr = "no response";
		}		
	}
	else
	{
		ErrorStr = "couldn't find user/challenge entry for request";
	}
	// End:0x45D
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnQueryChallengeUserStatusComplete(bResult, UniqueChallengeId, UniqueUserId, ErrorStr);
	//return;	
}

function QueryChallengeMultiUserStatus(string UniqueChallengeId, string UniqueUserId, const out array<string> UserIdsToRead)
{
	local string URL, ErrorStr, JSONStr;
	local int ChallengeQueryIdx, UserQueryIdx, UserIdIdx;
	local bool bPending;
	local HttpRequestInterface Request;

	UserQueryIdx = ChallengeUserRequests.Find('UniqueUserId', UniqueUserId);
	// End:0x98
	if(UserQueryIdx == -1)
	{
		UserQueryIdx = ChallengeUserRequests.Length;
		ChallengeUserRequests.Length = ChallengeUserRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].UniqueUserId = UniqueUserId;
	}
	ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Find('UniqueChallengeId', UniqueChallengeId);
	// End:0x1C1
	if(ChallengeQueryIdx == -1)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Length;
		ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Length = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].UniqueChallengeId = UniqueChallengeId;
	}
	// End:0x505
	if(ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].HTTPRequest == none)
	{
		Request = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x502
		if(Request != none)
		{
			ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].HTTPRequest = Request;
			JSONStr = "[ ";
			UserIdIdx = 0;
			J0x2A8:

			// End:0x333 [Loop If]
			if(UserIdIdx < UserIdsToRead.Length)
			{				
				JSONStr $= (("\"" $ UserIdsToRead[UserIdIdx]) $ "\"");
				// End:0x325
				if((UserIdIdx + 1) < UserIdsToRead.Length)
				{					
					JSONStr $= ",";
				}
				UserIdIdx++;
				// [Loop Continue]
				goto J0x2A8;
			}			
			JSONStr $= " ]";
			Request.SetContentAsString(JSONStr);
			URL = ((((((GetBaseURL()) $ ChallengeMultiStatusUrl) $ (GetAppAccessURL())) $ "&uniqueChallengeId=") $ UniqueChallengeId) $ "&uniqueUserId=") $ UniqueUserId;
			Request.SetURL(URL);
			Request.SetVerb("POST");
			Request.SetHeader("Content-Type", "multipart/form-data");
			Request.__OnProcessRequestComplete__Delegate = OnQueryChallengeMultiStatusHTTPRequestComplete;
			// End:0x4CE
			if(Request.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
	}
	// End:0x585
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x5C3
	if(!bPending)
	{
		OnQueryChallengeUserStatusComplete(false, UniqueChallengeId, UniqueUserId, ErrorStr);
	}
	//return;	
}

private final function OnQueryChallengeMultiStatusHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string JSONStr, UniqueChallengeId, UniqueUserId, ErrorStr;
	local bool bResult;
	local int UserQueryIdx, ChallengeQueryIdx, UserStatusIdx, TempUserStatusIdx;

	UserQueryIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(UserQueryIdx < ChallengeUserRequests.Length)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests.Find('HTTPRequest', Request);
		// End:0x7F
		if(ChallengeQueryIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		UserQueryIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x446
	if((UserQueryIdx < ChallengeUserRequests.Length) && ChallengeQueryIdx != -1)
	{
		ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].HTTPRequest = none;
		UniqueUserId = ChallengeUserRequests[UserQueryIdx].UniqueUserId;
		UniqueChallengeId = ChallengeUserRequests[UserQueryIdx].ChallengeStatusRequests[ChallengeQueryIdx].UniqueChallengeId;
		// End:0x42C
		if(bWasSuccessful && Response != none)
		{
			// End:0x3D5
			if(Response.GetResponseCode() == 200)
			{
				JSONStr = Response.GetContentAsString();
				// End:0x3B6
				if(Len(JSONStr) > 0)
				{
					TempChallengeUserStatusArray.Length = 0;
					ImportJSON("TempChallengeUserStatusArray", JSONStr);
					// End:0x3A7
					if(TempChallengeUserStatusArray.Length > 0)
					{
						TempUserStatusIdx = 0;
						J0x252:

						// End:0x3A7 [Loop If]
						if(TempUserStatusIdx < TempChallengeUserStatusArray.Length)
						{
							UserStatusIdx = 0;
							J0x275:

							// End:0x342 [Loop If]
							if(UserStatusIdx < ChallengeUserStatus.Length)
							{
								// End:0x334
								if((ChallengeUserStatus[UserStatusIdx].unique_challenge_id == TempChallengeUserStatusArray[TempUserStatusIdx].unique_challenge_id) && ChallengeUserStatus[UserStatusIdx].unique_user_id == TempChallengeUserStatusArray[TempUserStatusIdx].unique_user_id)
								{
									// [Explicit Break]
									goto J0x342;
								}
								UserStatusIdx++;
								// [Loop Continue]
								goto J0x275;
							}
							J0x342:

							// End:0x372
							if(UserStatusIdx == ChallengeUserStatus.Length)
							{
								ChallengeUserStatus.Length = ChallengeUserStatus.Length + 1;
							}
							ChallengeUserStatus[UserStatusIdx] = TempChallengeUserStatusArray[TempUserStatusIdx];
							TempUserStatusIdx++;
							// [Loop Continue]
							goto J0x252;
						}
					}
					bResult = true;					
				}
				else
				{
					ErrorStr = "no JSON response";
				}				
			}
			else
			{
				ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
			}			
		}
		else
		{
			ErrorStr = "no response";
		}		
	}
	else
	{
		ErrorStr = "couldn't find user/challenge entry for request";
	}
	// End:0x4CF
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnQueryChallengeUserStatusComplete(bResult, UniqueChallengeId, UniqueUserId, ErrorStr);
	//return;	
}

function GetChallengeUserStatus(string UniqueChallengeId, string UniqueUserId, out McpClashMobChallengeUserStatus OutChallengeUserStatus)
{
	local int UserStatusIdx;
	local McpClashMobChallengeUserStatus DefaultStatus;

	UserStatusIdx = 0;
	J0x0B:

	// End:0x9E [Loop If]
	if(UserStatusIdx < ChallengeUserStatus.Length)
	{
		// End:0x90
		if((ChallengeUserStatus[UserStatusIdx].unique_challenge_id == UniqueChallengeId) && ChallengeUserStatus[UserStatusIdx].unique_user_id == UniqueUserId)
		{
			// [Explicit Break]
			goto J0x9E;
		}
		UserStatusIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x9E:

	// End:0xD6
	if(UserStatusIdx < ChallengeUserStatus.Length)
	{
		OutChallengeUserStatus = ChallengeUserStatus[UserStatusIdx];		
	}
	else
	{
		OutChallengeUserStatus = DefaultStatus;
		OutChallengeUserStatus.unique_challenge_id = UniqueChallengeId;
		OutChallengeUserStatus.unique_user_id = UniqueUserId;
		LogInternal(((((((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Couldn't find user status for") $ " UniqueChallengeId=") $ UniqueChallengeId) $ " UniqueUserId=") $ UniqueUserId);
	}
	//return;	
}

function UpdateChallengeUserProgress(string UniqueChallengeId, string UniqueUserId, bool bDidComplete, int GoalProgress)
{
	local string URL, ErrorStr;
	local int ChallengeQueryIdx, UserQueryIdx;
	local bool bPending;
	local HttpRequestInterface Request;

	UserQueryIdx = ChallengeUserRequests.Find('UniqueUserId', UniqueUserId);
	// End:0x98
	if(UserQueryIdx == -1)
	{
		UserQueryIdx = ChallengeUserRequests.Length;
		ChallengeUserRequests.Length = ChallengeUserRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].UniqueUserId = UniqueUserId;
	}
	ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests.Find('UniqueChallengeId', UniqueChallengeId);
	// End:0x1C1
	if(ChallengeQueryIdx == -1)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests.Length;
		ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests.Length = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests[ChallengeQueryIdx].UniqueChallengeId = UniqueChallengeId;
	}
	// End:0x45E
	if(ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests[ChallengeQueryIdx].HTTPRequest == none)
	{
		Request = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x45B
		if(Request != none)
		{
			ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests[ChallengeQueryIdx].HTTPRequest = Request;
			URL = ((((((((((GetBaseURL()) $ UpdateChallengeProgressUrl) $ (GetAppAccessURL())) $ "&uniqueChallengeId=") $ UniqueChallengeId) $ "&uniqueUserId=") $ UniqueUserId) $ "&didComplete=") $ string(bDidComplete)) $ "&goalProgress=") $ string(GoalProgress);
			Request.SetURL(URL);
			Request.SetVerb("POST");
			Request.SetHeader("Content-Type", "multipart/form-data");
			Request.__OnProcessRequestComplete__Delegate = OnUpdateChallengeUserProgressHTTPRequestComplete;
			// End:0x427
			if(Request.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
	}
	// End:0x4DE
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x51C
	if(!bPending)
	{
		OnUpdateChallengeUserProgressComplete(false, UniqueChallengeId, UniqueUserId, ErrorStr);
	}
	//return;	
}

private final function OnUpdateChallengeUserProgressHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string UniqueChallengeId, UniqueUserId, ErrorStr;
	local bool bResult;
	local int UserQueryIdx, ChallengeQueryIdx;

	UserQueryIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(UserQueryIdx < ChallengeUserRequests.Length)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests.Find('HTTPRequest', Request);
		// End:0x7F
		if(ChallengeQueryIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		UserQueryIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x23B
	if((UserQueryIdx != -1) && ChallengeQueryIdx != -1)
	{
		ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests[ChallengeQueryIdx].HTTPRequest = none;
		UniqueUserId = ChallengeUserRequests[UserQueryIdx].UniqueUserId;
		UniqueChallengeId = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateProgressRequests[ChallengeQueryIdx].UniqueChallengeId;
		// End:0x221
		if(bWasSuccessful && Response != none)
		{
			// End:0x1CA
			if(Response.GetResponseCode() == 200)
			{
				bResult = true;				
			}
			else
			{
				ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
			}			
		}
		else
		{
			ErrorStr = "no response";
		}		
	}
	else
	{
		ErrorStr = "couldn't find user/challenge entry for request";
	}
	// End:0x2C4
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnUpdateChallengeUserProgressComplete(bResult, UniqueChallengeId, UniqueUserId, ErrorStr);
	//return;	
}

function UpdateChallengeUserReward(string UniqueChallengeId, string UniqueUserId, int UserReward)
{
	local string URL, ErrorStr;
	local int ChallengeQueryIdx, UserQueryIdx;
	local bool bPending;
	local HttpRequestInterface Request;

	UserQueryIdx = ChallengeUserRequests.Find('UniqueUserId', UniqueUserId);
	// End:0x98
	if(UserQueryIdx == -1)
	{
		UserQueryIdx = ChallengeUserRequests.Length;
		ChallengeUserRequests.Length = ChallengeUserRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].UniqueUserId = UniqueUserId;
	}
	ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests.Find('UniqueChallengeId', UniqueChallengeId);
	// End:0x1C1
	if(ChallengeQueryIdx == -1)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests.Length;
		ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests.Length = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests.Length + 1;
		ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests[ChallengeQueryIdx].UniqueChallengeId = UniqueChallengeId;
	}
	// End:0x441
	if(ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests[ChallengeQueryIdx].HTTPRequest == none)
	{
		Request = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x43E
		if(Request != none)
		{
			ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests[ChallengeQueryIdx].HTTPRequest = Request;
			URL = ((((((((GetBaseURL()) $ UpdateRewardProgressUrl) $ (GetAppAccessURL())) $ "&uniqueChallengeId=") $ UniqueChallengeId) $ "&uniqueUserId=") $ UniqueUserId) $ "&userAwardGiven=") $ string(UserReward);
			Request.SetURL(URL);
			Request.SetVerb("POST");
			Request.SetHeader("Content-Type", "multipart/form-data");
			Request.__OnProcessRequestComplete__Delegate = OnUpdateChallengeUserRewardHTTPRequestComplete;
			// End:0x40A
			if(Request.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
	}
	// End:0x4C1
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x4FF
	if(!bPending)
	{
		OnUpdateChallengeUserRewardComplete(false, UniqueChallengeId, UniqueUserId, ErrorStr);
	}
	//return;	
}

private final function OnUpdateChallengeUserRewardHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string UniqueChallengeId, UniqueUserId, ErrorStr;
	local bool bResult;
	local int UserQueryIdx, ChallengeQueryIdx;

	UserQueryIdx = 0;
	J0x0B:

	// End:0x8D [Loop If]
	if(UserQueryIdx < ChallengeUserRequests.Length)
	{
		ChallengeQueryIdx = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests.Find('HTTPRequest', Request);
		// End:0x7F
		if(ChallengeQueryIdx != -1)
		{
			// [Explicit Break]
			goto J0x8D;
		}
		UserQueryIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x8D:

	// End:0x23B
	if((UserQueryIdx != -1) && ChallengeQueryIdx != -1)
	{
		ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests[ChallengeQueryIdx].HTTPRequest = none;
		UniqueUserId = ChallengeUserRequests[UserQueryIdx].UniqueUserId;
		UniqueChallengeId = ChallengeUserRequests[UserQueryIdx].ChallengeUpdateRewardRequests[ChallengeQueryIdx].UniqueChallengeId;
		// End:0x221
		if(bWasSuccessful && Response != none)
		{
			// End:0x1CA
			if(Response.GetResponseCode() == 200)
			{
				bResult = true;				
			}
			else
			{
				ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
			}			
		}
		else
		{
			ErrorStr = "no response";
		}		
	}
	else
	{
		ErrorStr = "couldn't find user/challenge entry for request";
	}
	// End:0x2C4
	if(Len(ErrorStr) > 0)
	{
		LogInternal(((("McpClashMobManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnUpdateChallengeUserRewardComplete(bResult, UniqueChallengeId, UniqueUserId, ErrorStr);
	//return;	
}

defaultproperties
{
	ChallengeListUrl="/challengelist"
	ChallengeStatusUrl="/challengestatus"
	ChallengeMultiStatusUrl="/challengemultiplestatus"
	AcceptChallengeUrl="/acceptchallenge"
	UpdateChallengeProgressUrl="/updatechallenge"
	UpdateRewardProgressUrl="/updatereward"
}