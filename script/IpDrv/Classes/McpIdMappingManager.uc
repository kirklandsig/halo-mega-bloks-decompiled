class McpIdMappingManager extends McpIdMappingBase
	config(Engine);

struct AddMappingRequest
{
	var string McpId;
	var string ExternalId;
	var string ExternalType;
	var HttpRequestInterface Request;

	structdefaultproperties
	{
		McpId=""
		ExternalId=""
		ExternalType=""
		Request=none
	}
};

struct QueryMappingRequest
{
	var string ExternalType;
	var HttpRequestInterface Request;

	structdefaultproperties
	{
		ExternalType=""
		Request=none
	}
};

var array<McpIdMapping> AccountMappings;
var config string AddMappingUrl;
var config string QueryMappingUrl;
var array<AddMappingRequest> AddMappingRequests;
var array<QueryMappingRequest> QueryMappingRequests;

function AddMapping(string McpId, string ExternalId, string ExternalType)
{
	local string URL;
	local HttpRequestInterface Request;
	local int AddAt;

	Request = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x2AD
	if(Request != none)
	{
		URL = ((((((((GetBaseURL()) $ AddMappingUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ McpId) $ "&externalAccountId=") $ ExternalId) $ "&externalAccountType=") $ ExternalType;
		Request.SetURL(URL);
		Request.SetVerb("POST");
		Request.__OnProcessRequestComplete__Delegate = OnAddMappingRequestComplete;
		AddAt = AddMappingRequests.Length;
		AddMappingRequests.Length = AddAt + 1;
		AddMappingRequests[AddAt].McpId = McpId;
		AddMappingRequests[AddAt].ExternalId = ExternalId;
		AddMappingRequests[AddAt].ExternalType = ExternalType;
		AddMappingRequests[AddAt].Request = Request;
		// End:0x296
		if(Request.ProcessRequest()!)
		{
			LogInternal(("Failed to start AddMapping web request for URL(" $ URL) $ ")");
		}
		LogInternal("URL is " $ URL);
	}
	//return;	
}

function OnAddMappingRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local int Index, AddAt, ResponseCode;

	Index = AddMappingRequests.Find('Request', Request);
	// End:0x391
	if(Index != -1)
	{
		ResponseCode = 500;
		// End:0x83
		if(Response != none)
		{
			ResponseCode = Response.GetResponseCode();
		}
		bWasSuccessful = bWasSuccessful && ResponseCode == 200;
		LogInternal(((((((((("Account mapping McpId(" $ AddMappingRequests[Index].McpId) $ "), ExternalId(") $ AddMappingRequests[Index].ExternalId) $ "), ExternalType(") $ AddMappingRequests[Index].ExternalType) $ ") was successful ") $ string(bWasSuccessful)) $ " with ResponseCode(") $ string(ResponseCode)) $ ")");
		// End:0x2CE
		if(bWasSuccessful)
		{
			AddAt = AccountMappings.Length;
			AccountMappings.Length = AddAt + 1;
			AccountMappings[AddAt].McpId = AddMappingRequests[Index].McpId;
			AccountMappings[AddAt].ExternalId = AddMappingRequests[Index].ExternalId;
			AccountMappings[AddAt].ExternalType = AddMappingRequests[Index].ExternalType;
		}
		OnAddMappingComplete(AddMappingRequests[Index].McpId, AddMappingRequests[Index].ExternalId, AddMappingRequests[Index].ExternalType, bWasSuccessful, Response.GetContentAsString());
		AddMappingRequests.Remove(Index, 1);
	}
	//return;	
}

function QueryMappings(const out array<string> ExternalIds, string ExternalType)
{
	local string URL;
	local HttpRequestInterface Request;
	local int AddAt;
	local string JsonPayload;
	local int Index;
	local bool bFirst;

	Request = Class'Engine.HttpFactory'.static.CreateRequest();
	// End:0x373
	if(Request != none)
	{
		URL = ((((GetBaseURL()) $ QueryMappingUrl) $ (GetAppAccessURL())) $ "&externalAccountType=") $ ExternalType;
		JsonPayload = "[ ";
		bFirst = true;
		Index = 0;
		J0xAC:

		// End:0x152 [Loop If]
		if(Index < ExternalIds.Length)
		{
			// End:0x144
			if(Len(ExternalIds[Index]) > 0)
			{
				// End:0x106
				if(bFirst!)
				{					
					JsonPayload $= ",";
				}
				bFirst = false;				
				JsonPayload $= (("\"" $ ExternalIds[Index]) $ "\"");
			}
			Index++;
			// [Loop Continue]
			goto J0xAC;
		}		
		JsonPayload $= " ]";
		LogInternal("QueryMappings.JsonPayload:\n" $ JsonPayload);
		Request.SetURL(URL);
		Request.SetContentAsString(JsonPayload);
		Request.SetVerb("POST");
		Request.SetHeader("Content-Type", "multipart/form-data");
		Request.__OnProcessRequestComplete__Delegate = OnQueryMappingsRequestComplete;
		AddAt = QueryMappingRequests.Length;
		QueryMappingRequests.Length = AddAt + 1;
		QueryMappingRequests[AddAt].ExternalType = ExternalType;
		QueryMappingRequests[AddAt].Request = Request;
		// End:0x373
		if(Request.ProcessRequest()!)
		{
			LogInternal(("Failed to start QueryMappings web request for URL(" $ URL) $ ")");
		}
	}
	//return;	
}

function OnQueryMappingsRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local int Index, AddAt, ResponseCode;
	local string JsonString;
	local JsonObject ParsedJson;
	local int JsonIndex, AccountIndex;
	local bool bWasFound;
	local string McpId, ExternalId, ExternalType;

	Index = QueryMappingRequests.Find('Request', Request);
	// End:0x57E
	if(Index != -1)
	{
		ResponseCode = 500;
		// End:0x83
		if(Response != none)
		{
			ResponseCode = Response.GetResponseCode();
		}
		bWasSuccessful = bWasSuccessful && ResponseCode == 200;
		LogInternal(((((("Account mapping query for ExternalType(" $ QueryMappingRequests[Index].ExternalType) $ ") was successful ") $ string(bWasSuccessful)) $ " with ResponseCode(") $ string(ResponseCode)) $ ")");
		// End:0x507
		if(bWasSuccessful)
		{
			JsonString = Response.GetContentAsString();
			// End:0x507
			if(JsonString != "")
			{
				LogInternal("JSON for account query = r\n" $ JsonString);
				ParsedJson = Class'Engine.JsonObject'.static.DecodeJson(JsonString);
				JsonIndex = 0;
				J0x1F8:

				// End:0x507 [Loop If]
				if(JsonIndex < ParsedJson.ObjectArray.Length)
				{
					McpId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("unique_user_id");
					ExternalId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("external_account_id");
					ExternalType = ParsedJson.ObjectArray[JsonIndex].GetStringValue("external_account_type");
					bWasFound = false;
					AccountIndex = 0;
					J0x350:

					// End:0x42F [Loop If]
					if((AccountIndex < AccountMappings.Length) && bWasFound!)
					{
						bWasFound = ((McpId == AccountMappings[AccountIndex].McpId) && ExternalId == AccountMappings[AccountIndex].ExternalId) && ExternalType == AccountMappings[AccountIndex].ExternalType;
						AccountIndex++;
						// [Loop Continue]
						goto J0x350;
					}
					// End:0x4F9
					if(bWasFound!)
					{
						AddAt = AccountMappings.Length;
						AccountMappings.Length = AddAt + 1;
						AccountMappings[AddAt].McpId = McpId;
						AccountMappings[AddAt].ExternalId = ExternalId;
						AccountMappings[AddAt].ExternalType = ExternalType;
					}
					JsonIndex++;
					// [Loop Continue]
					goto J0x1F8;
				}
			}
		}
		OnQueryMappingsComplete(QueryMappingRequests[Index].ExternalType, bWasSuccessful, Response.GetContentAsString());
		QueryMappingRequests.Remove(Index, 1);
	}
	//return;	
}

function GetIdMappings(string ExternalType, out array<McpIdMapping> IDMappings)
{
	local int Index, AddAt;

	IDMappings.Length = 0;
	Index = 0;
	J0x17:

	// End:0xC3 [Loop If]
	if(Index < AccountMappings.Length)
	{
		// End:0xB5
		if(AccountMappings[Index].ExternalType == ExternalType)
		{
			AddAt = IDMappings.Length;
			IDMappings.Length = AddAt + 1;
			IDMappings[AddAt] = AccountMappings[Index];
		}
		Index++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

defaultproperties
{
	AddMappingUrl="/useraddaccountmapping"
	QueryMappingUrl="/userresolveaccountmappings"
}