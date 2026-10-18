class McpMessageManager extends McpMessageBase
	native
	config(Engine);

struct native McpCompressMessageRequest
{
	var array<byte> SourceBuffer;
	var array<byte> DestBuffer;
	var int OutCompressedSize;
	var HttpRequestInterface Request;
	var native Pointer CompressionWorker;

	structdefaultproperties
	{
		SourceBuffer=none
		DestBuffer=none
		OutCompressedSize=0
		Request=none
	}
};

struct native McpUncompressMessageRequest
{
	var string MessageId;
	var array<byte> SourceBuffer;
	var array<byte> DestBuffer;
	var int OutUncompressedSize;
	var native Pointer UncompressionWorker;

	structdefaultproperties
	{
		MessageId=""
		SourceBuffer=none
		DestBuffer=none
		OutUncompressedSize=0
	}
};

var private native const noexport Pointer VfTable_FTickableObject;
var config string CreateMessageUrl;
var config string DeleteMessageUrl;
var config string QueryMessagesUrl;
var config string QueryMessageContentsUrl;
var config string DeleteAllMessagesUrl;
var native array<McpCompressMessageRequest> CompressMessageRequests;
var native array<McpUncompressMessageRequest> UncompressMessageRequests;

// Export UMcpMessageManager::execStartAsyncCompression(FFrame&, void* const)
native function bool StartAsyncCompression(McpMessageBase.EMcpMessageCompressionType MessageCompressionType, const out array<byte> MessageContent, HttpRequestInterface Request);

// Export UMcpMessageManager::execStartAsyncUncompression(FFrame&, void* const)
native function bool StartAsyncUncompression(string MessageId, McpMessageBase.EMcpMessageCompressionType MessageCompressionType, const out array<byte> MessageContent);

event FinishedAsyncUncompression(bool bWasSuccessful, const out array<byte> UncompressedMessageContents, string MessageId)
{
	// End:0x67
	if(CacheMessageContents(UncompressedMessageContents, MessageId)!)
	{
		LogInternal((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName()));
	}
	OnQueryMessageContentsComplete(MessageId, bWasSuccessful, "");
	//return;	
}

function CreateMessage(const out array<string> ToUniqueUserIds, string FromUniqueUserId, string FromFriendlyName, string MessageType, string TitleId, string PushMessage, string ValidUntil, const out array<byte> MessageContents)
{
	local string URL;
	local HttpRequestInterface CreateMessageRequest;
	local McpMessage Message;
	local string ToUniqueUserIdsStr;
	local int Idx;

	CreateMessageRequest = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x44D
	if(CreateMessageRequest != none)
	{
		Idx = 0;
		J0x43:

		// End:0xC4 [Loop If]
		if(Idx < ToUniqueUserIds.Length)
		{			
			ToUniqueUserIdsStr $= ToUniqueUserIds[Idx];
			// End:0xB6
			if((ToUniqueUserIds.Length - Idx) > 1)
			{				
				ToUniqueUserIdsStr $= ",";
			}
			Idx++;
			// [Loop Continue]
			goto J0x43;
		}
		URL = ((((((((((((((((GetBaseURL()) $ CreateMessageUrl) $ (GetAppAccessURL())) $ "&toUniqueUserIds=") $ ToUniqueUserIdsStr) $ "&fromUniqueUserId=") $ FromUniqueUserId) $ "&fromFriendlyName=") $ FromFriendlyName) $ "&messageType=") $ MessageType) $ "&pushMessage=") $ PushMessage) $ "&messageCompressionType=") $ string(CompressionType)) $ "&validUntil=") $ ValidUntil;
		CreateMessageRequest.SetURL(URL);
		CreateMessageRequest.SetHeader("Content-Type", "multipart/form-data");
		CreateMessageRequest.SetVerb("POST");
		CreateMessageRequest.__OnProcessRequestComplete__Delegate = OnCreateMessageRequestComplete;
		// End:0x324
		if((int(CompressionType) == int(1)) || int(CompressionType) == int(2))
		{
			// End:0x321
			if(StartAsyncCompression(CompressionType, MessageContents, CreateMessageRequest)!)
			{
				OnCreateMessageComplete(Message, false, "Failed to Start Async Compression.");
			}			
		}
		else
		{
			CreateMessageRequest.SetContent(MessageContents);
			// End:0x3F0
			if(CreateMessageRequest.ProcessRequest()!)
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}
			LogInternal((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ " URL is ") $ URL);
		}
	}
	//return;	
}

function OnCreateMessageRequestComplete(HttpRequestInterface CreateMessageRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content;
	local McpMessage CreatedMessage;

	ResponseCode = 500;
	// End:0x18A
	if((HttpResponse != none) && CreateMessageRequest != none)
	{
		ResponseCode = HttpResponse.GetResponseCode();
		bWasSuccessful = bWasSuccessful && ResponseCode == 201;
		Content = HttpResponse.GetContentAsString();
		// End:0x112
		if(bWasSuccessful)
		{
			LogInternal(((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Message created.");			
		}
		else
		{
			LogInternal(((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ " CreateMessage query did not return a message.");
		}
	}
	OnCreateMessageComplete(CreatedMessage, bWasSuccessful, Content);
	//return;	
}

function DeleteMessage(string MessageId)
{
	local string URL;
	local HttpRequestInterface DeleteMessageRequest;

	DeleteMessageRequest = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x1FC
	if(DeleteMessageRequest != none)
	{
		URL = ((((GetBaseURL()) $ DeleteMessageUrl) $ (GetAppAccessURL())) $ "&messageId=") $ MessageId;
		DeleteMessageRequest.SetVerb("DELETE");
		DeleteMessageRequest.SetURL(URL);
		DeleteMessageRequest.__OnProcessRequestComplete__Delegate = OnDeleteMessageRequestComplete;
		// End:0x1A0
		if(DeleteMessageRequest.ProcessRequest()!)
		{
			LogInternal(((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
		}
		LogInternal((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ "URL is ") $ URL);
	}
	//return;	
}

function OnDeleteMessageRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content, MessageId;

	ResponseCode = 500;
	// End:0xCD
	if(HttpResponse != none)
	{
		ResponseCode = HttpResponse.GetResponseCode();
		MessageId = HttpResponse.GetURLParameter("MessageId");
		ResponseCode = HttpResponse.GetResponseCode();
		Content = HttpResponse.GetContentAsString();
	}
	bWasSuccessful = bWasSuccessful && ResponseCode == 200;
	OnDeleteMessageComplete(MessageId, bWasSuccessful, Content);
	//return;	
}

function QueryMessages(string ToUniqueUserId, string TitleId)
{
	local string URL;
	local HttpRequestInterface QueryMessagesRequest;

	QueryMessagesRequest = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x212
	if(QueryMessagesRequest != none)
	{
		URL = ((((((GetBaseURL()) $ QueryMessagesUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ ToUniqueUserId) $ "&titleId=") $ TitleId;
		QueryMessagesRequest.SetURL(URL);
		QueryMessagesRequest.SetVerb("GET");
		QueryMessagesRequest.__OnProcessRequestComplete__Delegate = OnQueryMessagesRequestComplete;
		LogInternal((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "URL: ") $ URL);
		// End:0x212
		if(QueryMessagesRequest.ProcessRequest()!)
		{
			LogInternal(((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
		}
	}
	//return;	
}

private final function OnQueryMessagesRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Error, JsonString;
	local JsonObject ParsedJson;
	local int JsonIndex;
	local McpMessage Message;
	local string MessageCompressionTypeString;

	ResponseCode = 500;
	// End:0x589
	if((HttpResponse != none) && OriginalRequest != none)
	{
		ResponseCode = HttpResponse.GetResponseCode();
		bWasSuccessful = bWasSuccessful && ResponseCode == 200;
		// End:0x560
		if(bWasSuccessful)
		{
			JsonString = HttpResponse.GetContentAsString();
			// End:0x4CE
			if(JsonString != "")
			{
				ParsedJson = Class'Engine.JsonObject'.static.DecodeJson(JsonString);
				JsonIndex = 0;
				J0x102:

				// End:0x4CB [Loop If]
				if(JsonIndex < ParsedJson.ObjectArray.Length)
				{
					Message.MessageId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("message_id");
					Message.ToUniqueUserId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("to_unique_user_id");
					Message.FromUniqueUserId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("from_unique_user_id");
					Message.FromFriendlyName = ParsedJson.ObjectArray[JsonIndex].GetStringValue("from_friendly_name");
					Message.MessageType = ParsedJson.ObjectArray[JsonIndex].GetStringValue("message_type");
					MessageCompressionTypeString = ParsedJson.ObjectArray[JsonIndex].GetStringValue("message_compression_type");
					Message.ValidUntil = ParsedJson.ObjectArray[JsonIndex].GetStringValue("valid_until");
					switch(MessageCompressionTypeString)
					{
						// End:0x458
						case "MMCT_LZO":
							Message.MessageCompressionType = 1;
							// End:0x4AA
							break;
						// End:0x488
						case "MMCT_ZLIB":
							Message.MessageCompressionType = 2;
							// End:0x4AA
							break;
						// End:0xFFFF
						default:
							Message.MessageCompressionType = 0;
							break;
					}
					CacheMessage(Message);
					JsonIndex++;
					// [Loop Continue]
					goto J0x102;
				}				
			}
			else
			{
				Error = "Query did not return any content in it's response.";
				LogInternal(((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ Error);
			}			
		}
		else
		{
			Error = HttpResponse.GetContentAsString();
		}
	}
	OnQueryMessagesComplete(Message.ToUniqueUserId, bWasSuccessful, Error);
	//return;	
}

function GetMessageList(string ToUniqueUserId, out McpMessageList MessageList)
{
	local int MessageListIndex;

	MessageListIndex = MessageLists.Find('ToUniqueUserId', ToUniqueUserId);
	// End:0x5C
	if(MessageListIndex != -1)
	{
		MessageList = MessageLists[MessageListIndex];		
	}
	else
	{
		LogInternal((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ " Requester Id not found or MessageLists is empty. Using ToUniqueUserId: ") $ ToUniqueUserId);
	}
	//return;	
}

function QueryMessageContents(string MessageId)
{
	local string URL;
	local HttpRequestInterface QueryMessageContentsRequest;

	QueryMessageContentsRequest = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x1F7
	if(QueryMessageContentsRequest != none)
	{
		URL = ((((GetBaseURL()) $ QueryMessageContentsUrl) $ (GetAppAccessURL())) $ "&messageId=") $ MessageId;
		QueryMessageContentsRequest.SetURL(URL);
		QueryMessageContentsRequest.SetVerb("GET");
		QueryMessageContentsRequest.__OnProcessRequestComplete__Delegate = OnQueryMessageContentsRequestComplete;
		LogInternal((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "URL: ") $ URL);
		// End:0x1F7
		if(QueryMessageContentsRequest.ProcessRequest()!)
		{
			LogInternal(((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
		}
	}
	//return;	
}

private final function OnQueryMessageContentsRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local array<byte> MessageContents;
	local string MessageId;
	local McpMessage Message;

	ResponseCode = 500;
	// End:0x316
	if((HttpResponse != none) && OriginalRequest != none)
	{
		MessageId = OriginalRequest.GetURLParameter("messageId");
		ResponseCode = HttpResponse.GetResponseCode();
		bWasSuccessful = bWasSuccessful && ResponseCode == 200;
		// End:0x2D7
		if(bWasSuccessful && Len(MessageId) > 0)
		{
			HttpResponse.GetContent(MessageContents);
			LogInternal((("MessageId:" $ MessageId) $ " Compressed Message Contents Length:") $ string(MessageContents.Length));
			// End:0x283
			if(MessageContents.Length > 0)
			{
				GetMessageById(MessageId, Message);
				// End:0x202
				if(int(Message.MessageCompressionType) == int(0))
				{
					CacheMessageContents(MessageContents, MessageId);
					OnQueryMessageContentsComplete(MessageId, bWasSuccessful, HttpResponse.GetContentAsString());					
				}
				else
				{
					// End:0x280
					if(StartAsyncUncompression(MessageId, Message.MessageCompressionType, MessageContents)!)
					{
						OnQueryMessageContentsComplete(MessageId, false, "Could not Start AsyncDecompression");
					}
				}				
			}
			else
			{
				OnQueryMessageContentsComplete(MessageId, false, "Query did not return any content in it's response.");
			}			
		}
		else
		{
			OnQueryMessageContentsComplete(MessageId, false, HttpResponse.GetContentAsString());
		}		
	}
	else
	{
		OnQueryMessageContentsComplete(MessageId, false, "There was No HttpResponse or Request");
	}
	//return;	
}

function bool GetMessageContents(string MessageId, out array<byte> MessageContents)
{
	local bool bWasSuccessful;
	local int MessageContentsIndex;

	MessageContentsIndex = MessageContentsList.Find('MessageId', MessageId);
	// End:0x7B
	if(MessageContentsIndex != -1)
	{
		MessageContents = MessageContentsList[MessageContentsIndex].MessageContents;
		bWasSuccessful = true;		
	}
	else
	{
		bWasSuccessful = false;
	}
	return bWasSuccessful;
	//return ReturnValue;	
}

function CacheMessage(McpMessage Message)
{
	local int AddAt, MessageIndex, MessageListIndex;
	local McpMessageList UserMessageList;
	local bool bWasFound;

	bWasFound = false;
	MessageListIndex = MessageLists.Find('ToUniqueUserId', Message.ToUniqueUserId);
	// End:0x270
	if(MessageListIndex != -1)
	{
		UserMessageList = MessageLists[MessageListIndex];
		MessageIndex = 0;
		J0x83:

		// End:0x12F [Loop If]
		if((MessageIndex < UserMessageList.Messages.Length) && bWasFound!)
		{
			bWasFound = Message.MessageId == UserMessageList.Messages[MessageIndex].MessageId;
			MessageIndex++;
			// [Loop Continue]
			goto J0x83;
		}
		// End:0x1DC
		if(bWasFound!)
		{
			AddAt = UserMessageList.Messages.Length;
			UserMessageList.Messages.Length = AddAt + 1;
			UserMessageList.Messages[AddAt] = Message;
			MessageLists[MessageListIndex] = UserMessageList;
		}
		LogInternal((((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ " MessageId: ") $ UserMessageList.Messages[AddAt].MessageId);		
	}
	else
	{
		AddAt = MessageLists.Length;
		MessageLists.Length = AddAt + 1;
		MessageLists[AddAt].ToUniqueUserId = Message.ToUniqueUserId;
		MessageLists[AddAt].Messages[0] = Message;
	}
	//return;	
}

function bool GetMessageById(string MessageId, out McpMessage Message)
{
	local int MessageListsSize, MessageListsItr, MessageItr;

	MessageListsSize = MessageLists.Length;
	MessageListsItr = 0;
	J0x1F:

	// End:0x11F [Loop If]
	if(MessageListsItr < MessageListsSize)
	{
		MessageItr = 0;
		J0x41:

		// End:0x111 [Loop If]
		if(MessageItr < MessageLists[MessageListsItr].Messages.Length)
		{
			// End:0x103
			if(MessageLists[MessageListsItr].Messages[MessageItr].MessageId == MessageId)
			{
				Message = MessageLists[MessageListsItr].Messages[MessageItr];
				return true;
			}
			MessageItr++;
			// [Loop Continue]
			goto J0x41;
		}
		MessageListsItr++;
		// [Loop Continue]
		goto J0x1F;
	}
	return false;
	//return ReturnValue;	
}

function bool CacheMessageContents(const out array<byte> MessageContents, string MessageId)
{
	local int MessageContentsIndex;
	local bool bWasSuccessful;

	bWasSuccessful = false;
	// End:0x145
	if((MessageContents.Length > 0) && Len(MessageId) > 0)
	{
		MessageContentsIndex = MessageContentsList.Find('MessageId', MessageId);
		// End:0xAA
		if(MessageContentsIndex != -1)
		{
			MessageContentsList[MessageContentsIndex].MessageContents = MessageContents;
			bWasSuccessful = true;			
		}
		else
		{
			MessageContentsIndex = MessageContentsList.Length;
			MessageContentsList.Length = MessageContentsList.Length + 1;
			MessageContentsList[MessageContentsIndex].MessageId = MessageId;
			MessageContentsList[MessageContentsIndex].MessageContents = MessageContents;
			bWasSuccessful = true;
		}		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") McpMessageManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ " Either the MessageContents or MessageId were not Specified.");
	}
	return bWasSuccessful;
	//return ReturnValue;	
}

defaultproperties
{
	CreateMessageUrl="/messagecreate"
	DeleteMessageUrl="/messagedelete"
	QueryMessagesUrl="/messagelist"
	QueryMessageContentsUrl="/messagecontents"
	CompressionType=EMcpMessageCompressionType.MMCT_LZO
}