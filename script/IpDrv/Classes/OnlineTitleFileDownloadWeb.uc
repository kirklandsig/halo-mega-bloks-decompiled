class OnlineTitleFileDownloadWeb extends OnlineTitleFileDownloadBase
	native
	config(Engine);

var private array<TitleFileWeb> TitleFiles;

// Export UOnlineTitleFileDownloadWeb::execUncompressTitleFileContents(FFrame&, void* const)
native function bool UncompressTitleFileContents(OnlineTitleFileDownloadBase.EMcpFileCompressionType FileCompressionType, const out array<byte> CompressedFileContents, out array<byte> UncompressedFileContents);

function bool ReadTitleFile(string FileToRead)
{
	local int FileIndex, Idx;
	local string URL;

	FileIndex = -1;
	Idx = 0;
	J0x1A:

	// End:0x94 [Loop If]
	if(Idx < TitleFiles.Length)
	{
		// End:0x86
		if(InStr(TitleFiles[Idx].Filename, FileToRead, true, false) != -1)
		{
			FileIndex = Idx;
			// [Explicit Break]
			goto J0x94;
		}
		Idx++;
		// [Loop Continue]
		goto J0x1A;
	}
	J0x94:

	// End:0x12C
	if(FileIndex == -1)
	{
		FileIndex = TitleFiles.Length;
		TitleFiles.Length = TitleFiles.Length + 1;
		TitleFiles[FileIndex].Filename = FileToRead;
		TitleFiles[FileIndex].AsyncState = 0;
	}
	// End:0x174
	if(int(TitleFiles[FileIndex].AsyncState) == int(2))
	{
		TriggerDelegates(true, FileToRead);		
	}
	else
	{
		// End:0x1BE
		if(int(TitleFiles[FileIndex].AsyncState) == int(3))
		{
			TriggerDelegates(false, FileToRead);
			return false;			
		}
		else
		{
			// End:0x443
			if(int(TitleFiles[FileIndex].AsyncState) != int(1))
			{
				TitleFiles[FileIndex].AsyncState = 1;
				URL = (GetUrlForFile(FileToRead)) $ FileToRead;
				LogInternal(((((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "starting read for title file") @ "url=") $ URL);
				TitleFiles[FileIndex].HTTPRequest = Class'Engine.HttpFactory'.static.CreateRequest();
				// End:0x443
				if(TitleFiles[FileIndex].HTTPRequest != none)
				{
					TitleFiles[FileIndex].HTTPRequest.__OnProcessRequestComplete__Delegate = OnFileDownloadComplete;
					TitleFiles[FileIndex].HTTPRequest.SetVerb("GET");
					TitleFiles[FileIndex].HTTPRequest.SetURL(URL);
					TitleFiles[FileIndex].HTTPRequest.ProcessRequest();
				}
			}
		}
	}
	return true;
	//return ReturnValue;	
}

private final function OnFileDownloadComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bDidSucceed)
{
	local bool bSuccess;
	local int FileIndex, Idx;
	local string Filename;
	local array<byte> BinaryData;
	local string FileCompressionTypeString;

	// End:0x475
	if(bDidSucceed)
	{
		FileIndex = -1;
		Idx = 0;
		J0x27:

		// End:0x97 [Loop If]
		if(Idx < TitleFiles.Length)
		{
			// End:0x89
			if(TitleFiles[Idx].HTTPRequest == Request)
			{
				FileIndex = Idx;
				// [Explicit Break]
				goto J0x97;
			}
			Idx++;
			// [Loop Continue]
			goto J0x27;
		}
		J0x97:

		LogInternal(((((((((((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "") @ "FileIndex=") $ string(FileIndex)) @ "OriginalURL=") $ Request.GetURL()) @ "ResponseCode=") $ string(Response.GetResponseCode())) @ "ContentLength=") $ string(Response.GetContentLength()));
		// End:0x3F2
		if(FileIndex != -1)
		{
			Filename = TitleFiles[FileIndex].Filename;
			TitleFiles[FileIndex].HTTPRequest = none;
			TitleFiles[FileIndex].AsyncState = 3;
			// End:0x39D
			if(Response.GetResponseCode() == 200)
			{
				bSuccess = true;
				Response.GetContent(BinaryData);
				TitleFiles[FileIndex].Data = BinaryData;
				FileCompressionTypeString = Response.GetHeader("Content-Encoding");
				switch(FileCompressionTypeString)
				{
					// End:0x345
					case "MFCT_ZLIB":
						TitleFiles[FileIndex].FileCompressionType = 1;
						// End:0x371
						break;
					// End:0xFFFF
					default:
						TitleFiles[FileIndex].FileCompressionType = 0;
						break;
				}
				TitleFiles[FileIndex].AsyncState = 2;				
			}
			else
			{
				TitleFiles[FileIndex].AsyncState = 3;
				TitleFiles[FileIndex].Data.Length = 0;
			}			
		}
		else
		{
			LogInternal(((((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "No entry found for") @ "FileIndex=") $ string(FileIndex));
		}		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "web request for file download failed");
	}
	TriggerDelegates(bSuccess, Filename);
	//return;	
}

// Export UOnlineTitleFileDownloadWeb::execTriggerDelegates(FFrame&, void* const)
private native final function TriggerDelegates(bool bSuccess, string FileRead);

// Export UOnlineTitleFileDownloadWeb::execGetTitleFileContents(FFrame&, void* const)
native function bool GetTitleFileContents(string Filename, out array<byte> FileContents);

function OnlineSubsystem.EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
	local int FileIndex;

	FileIndex = TitleFiles.Find('Filename', Filename);
	// End:0x63
	if(FileIndex != -1)
	{
		return TitleFiles[FileIndex].AsyncState;
	}
	return 3;
	//return ReturnValue;	
}

// Export UOnlineTitleFileDownloadWeb::execClearDownloadedFiles(FFrame&, void* const)
native function bool ClearDownloadedFiles();

// Export UOnlineTitleFileDownloadWeb::execClearDownloadedFile(FFrame&, void* const)
native function bool ClearDownloadedFile(string Filename);

function RequestTitleFileList()
{
	local HttpRequestInterface HTTPRequest;
	local string URL;

	HTTPRequest = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x101
	if(HTTPRequest != none)
	{
		URL = ((GetBaseURL()) $ RequestFileListURL) $ (GetAppAccessURL());
		HTTPRequest.__OnProcessRequestComplete__Delegate = OnFileListReceived;
		HTTPRequest.SetVerb("GET");
		HTTPRequest.SetURL(URL);
		HTTPRequest.ProcessRequest();		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "HTTPRequest object missing");
	}
	//return;	
}

function OnFileListReceived(HttpRequestInterface Request, HttpResponseInterface Response, bool bDidSucceed)
{
	local int Index;
	local delegate<OnRequestTitleFileListComplete> RequestTitleFileListDelegate;
	local string ResponseStr;
	local bool bSuccess;

	// End:0x15A
	if(bDidSucceed)
	{
		// End:0x7C
		if((Response != none) && Response.GetResponseCode() == 200)
		{
			ResponseStr = Response.GetContentAsString();
			bSuccess = true;			
		}
		else
		{
			LogInternal(((((((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Download of file list failed. Bad response.") @ "ResponseCode=") $ string(Response.GetResponseCode())) @ "URL=") $ Request.GetURL());
		}		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") OnlineTitleFileDownloadWeb::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Download of file list failed.");
	}
	Index = 0;
	J0x1D5:

	// End:0x24D [Loop If]
	if(Index < RequestTitleFileListCompleteDelegates.Length)
	{
		RequestTitleFileListDelegate = RequestTitleFileListCompleteDelegates[Index];
		// End:0x23F
		if(RequestTitleFileListDelegate != none)
		{
			OnRequestTitleFileListComplete(bSuccess, ResponseStr);
		}
		Index++;
		// [Loop Continue]
		goto J0x1D5;
	}
	//return;	
}

function string GetUrlForFile(string Filename)
{
	local string URL;

	URL = (((GetBaseURL()) $ RequestFileURL) $ (GetAppAccessURL())) $ "&dlName=";
	return URL;
	//return ReturnValue;	
}

defaultproperties
{
	RequestFileListURL="/listfiles"
	RequestFileURL="/downloadfile"
	TimeOut=10.0000000
}