class McpGroupsManager extends McpGroupsBase
	config(Engine);

var config string CreateGroupUrl;
var config string DeleteGroupUrl;
var config string QueryGroupsUrl;
var config string QueryGroupMembersUrl;
var config string AddGroupMembersUrl;
var config string RemoveGroupMembersUrl;
var config string DeleteAllGroupsUrl;
var config string AcceptGroupInviteUrl;
var config string RejectGroupInviteUrl;
//var delegate<OnQueryGroupsRequestComplete> __OnQueryGroupsRequestComplete__Delegate;
//var delegate<OnQueryGroupMembersRequestComplete> __OnQueryGroupMembersRequestComplete__Delegate;
//var delegate<OnAddGroupMembersRequestComplete> __OnAddGroupMembersRequestComplete__Delegate;
//var delegate<OnAcceptGroupInviteRequestComplete> __OnAcceptGroupInviteRequestComplete__Delegate;

function CreateGroup(string UniqueUserId, string GroupName)
{
	local string URL;
	local HttpRequestInterface CreateGroupRequest;
	local McpGroup FailedGroup;

	// End:0x297
	if((Len(UniqueUserId) > 0) && Len(GroupName) > 0)
	{
		CreateGroupRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x257
		if(CreateGroupRequest != none)
		{
			URL = ((((((((GetBaseURL()) $ CreateGroupUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UniqueUserId) $ "&groupName=") $ GroupName) $ "&accessLevel=") $ "OWNER";
			CreateGroupRequest.SetURL(URL);
			CreateGroupRequest.SetVerb("POST");
			CreateGroupRequest.__OnProcessRequestComplete__Delegate = OnCreateGroupRequestComplete;
			// End:0x1F8
			if(!CreateGroupRequest.ProcessRequest())
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}
			LogInternal((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ " URL is ") $ URL);			
		}
		else
		{
			OnCreateGroupComplete(FailedGroup, false, "HttpRequest was not be created");
		}		
	}
	else
	{
		OnCreateGroupComplete(FailedGroup, false, "UserId or GroupName wasn't specified");
	}
	//return;	
}

function OnCreateGroupRequestComplete(HttpRequestInterface CreateGroupRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content;
	local McpGroup CreatedGroup;
	local string JsonString;
	local JsonObject ParsedJson;

	ResponseCode = 500;
	// End:0x34F
	if((HttpResponse != none) && CreateGroupRequest != none)
	{
		ResponseCode = HttpResponse.GetResponseCode();
		bWasSuccessful = bWasSuccessful && ResponseCode == 201;
		Content = HttpResponse.GetContentAsString();
		CreatedGroup.OwnerId = CreateGroupRequest.GetURLParameter("uniqueUserId");
		CreatedGroup.GroupName = CreateGroupRequest.GetURLParameter("groupName");
		JsonString = HttpResponse.GetContentAsString();
		// End:0x2DC
		if((JsonString != "") && bWasSuccessful)
		{
			ParsedJson = Class'Engine.JsonObject'.static.DecodeJson(JsonString);
			CreatedGroup.GroupID = ParsedJson.GetStringValue("group_id");
			CreatedGroup.OwnerId = ParsedJson.GetStringValue("unique_user_id");
			CreatedGroup.GroupName = ParsedJson.GetStringValue("group_name");
			CreatedGroup.AccessLevel = byte(ParsedJson.GetIntValue("access_level"));			
		}
		else
		{
			LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ " CreateGroup query did not return a group.");
		}
	}
	OnCreateGroupComplete(CreatedGroup, bWasSuccessful, Content);
	//return;	
}

function DeleteGroup(string UniqueUserId, string GroupID)
{
	local string URL;
	local HttpRequestInterface DeleteGroupRequest;

	// End:0x280
	if((Len(UniqueUserId) > 0) && Len(GroupID) > 0)
	{
		DeleteGroupRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x23C
		if(DeleteGroupRequest != none)
		{
			URL = ((((((GetBaseURL()) $ DeleteGroupUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UniqueUserId) $ "&groupId=") $ GroupID;
			DeleteGroupRequest.SetVerb("DELETE");
			DeleteGroupRequest.SetURL(URL);
			DeleteGroupRequest.__OnProcessRequestComplete__Delegate = OnDeleteGroupRequestComplete;
			// End:0x1DE
			if(!DeleteGroupRequest.ProcessRequest())
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}
			LogInternal((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ "URL is ") $ URL);			
		}
		else
		{
			OnDeleteGroupComplete(GroupID, false, "HttpRequest could not be completed");
		}		
	}
	else
	{
		OnDeleteGroupComplete(GroupID, false, "UniqueUserId and/or GroupId was not specified");
	}
	//return;	
}

function OnDeleteGroupRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content, GroupID;

	ResponseCode = 500;
	// End:0xCB
	if(HttpResponse != none)
	{
		ResponseCode = HttpResponse.GetResponseCode();
		GroupID = HttpResponse.GetURLParameter("GroupId");
		ResponseCode = HttpResponse.GetResponseCode();
		Content = HttpResponse.GetContentAsString();
	}
	bWasSuccessful = bWasSuccessful && ResponseCode == 200;
	OnDeleteGroupComplete(GroupID, bWasSuccessful, Content);
	//return;	
}

function QueryGroups(string RequesterId)
{
	local string URL;
	local HttpRequestInterface QueryGroupsRequest;

	// End:0x1FC
	if(Len(RequesterId) > 0)
	{
		QueryGroupsRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x1B9
		if(QueryGroupsRequest != none)
		{
			URL = ((((GetBaseURL()) $ QueryGroupsUrl) $ (GetAppAccessURL())) $ "&memberUniqueUserId=") $ RequesterId;
			QueryGroupsRequest.SetURL(URL);
			QueryGroupsRequest.SetVerb("GET");
			QueryGroupsRequest.__OnProcessRequestComplete__Delegate = OnQueryGroupsRequestComplete;
			// End:0x1B6
			if(!QueryGroupsRequest.ProcessRequest())
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}			
		}
		else
		{
			OnQueryGroupsComplete(RequesterId, false, "Http Request could not be created");
		}		
	}
	else
	{
		OnQueryGroupsComplete(RequesterId, false, "RequesterId was not specified");
	}
	//return;	
}

delegate OnQueryGroupsRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Error;
	local McpGroup Group;
	local string JsonString;
	local JsonObject ParsedJson;
	local int JsonIndex;
	local string RequesterId;

	ResponseCode = 500;
	// End:0x3F5
	if((HttpResponse != none) && OriginalRequest != none)
	{
		RequesterId = OriginalRequest.GetURLParameter("memberUniqueUserId");
		ResponseCode = HttpResponse.GetResponseCode();
		bWasSuccessful = bWasSuccessful && ResponseCode == 200;
		// End:0x3CC
		if(bWasSuccessful)
		{
			JsonString = HttpResponse.GetContentAsString();
			// End:0x33B
			if(JsonString != "")
			{
				ParsedJson = Class'Engine.JsonObject'.static.DecodeJson(JsonString);
				JsonIndex = 0;
				J0x13F:

				// End:0x338 [Loop If]
				if(JsonIndex < ParsedJson.ObjectArray.Length)
				{
					Group.OwnerId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("unique_user_id");
					Group.GroupID = ParsedJson.ObjectArray[JsonIndex].GetStringValue("group_id");
					Group.GroupName = ParsedJson.ObjectArray[JsonIndex].GetStringValue("group_name");
					Group.AccessLevel = byte(ParsedJson.ObjectArray[JsonIndex].GetIntValue("access_level"));
					CacheGroup(RequesterId, Group);
					JsonIndex++;
					// [Loop Continue]
					goto J0x13F;
				}				
			}
			else
			{
				Error = "Query did not return any content in it's response.";
				LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ Error);
			}			
		}
		else
		{
			Error = HttpResponse.GetContentAsString();
		}
	}
	OnQueryGroupsComplete(RequesterId, bWasSuccessful, Error);
	//return;	
}

function GetGroupList(string UserId, out McpGroupList GroupList)
{
	local int GroupListIndex;

	// End:0x102
	if(Len(UserId) > 0)
	{
		GroupListIndex = GroupLists.Find('RequesterId', UserId);
		// End:0x6D
		if(GroupListIndex != -1)
		{
			GroupList = GroupLists[GroupListIndex];			
		}
		else
		{
			LogInternal((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ " Requester Id not found or GroupLists is empty. Using UserId: ") $ UserId);
		}		
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ "UserId not specified");
	}
	//return;	
}

function QueryGroupMembers(string UniqueUserId, string GroupID)
{
	local string URL;
	local HttpRequestInterface QueryGroupMembersRequest;

	// End:0x1FA
	if((Len(UniqueUserId) > 0) && Len(GroupID) > 0)
	{
		QueryGroupMembersRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x1C1
		if(QueryGroupMembersRequest != none)
		{
			URL = ((((GetBaseURL()) $ QueryGroupMembersUrl) $ (GetAppAccessURL())) $ "&groupId=") $ GroupID;
			QueryGroupMembersRequest.SetURL(URL);
			QueryGroupMembersRequest.SetVerb("GET");
			QueryGroupMembersRequest.__OnProcessRequestComplete__Delegate = OnQueryGroupMembersRequestComplete;
			// End:0x1BE
			if(!QueryGroupMembersRequest.ProcessRequest())
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}			
		}
		else
		{
			OnQueryGroupMembersComplete(GroupID, false, "HttpRequest not created");
		}		
	}
	else
	{
		OnQueryGroupMembersComplete(GroupID, false, "UserId and/or GroupId not specified");
	}
	//return;	
}

delegate OnQueryGroupMembersRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Error, JsonString;
	local JsonObject ParsedJson;
	local int JsonIndex;
	local McpGroupsBase.EMcpGroupAcceptState AcceptState;
	local string MemberId, GroupID;

	ResponseCode = 500;
	// End:0x31B
	if((HttpResponse != none) && OriginalRequest != none)
	{
		ResponseCode = HttpResponse.GetResponseCode();
		bWasSuccessful = bWasSuccessful && ResponseCode == 200;
		// End:0x2F2
		if(bWasSuccessful)
		{
			JsonString = HttpResponse.GetContentAsString();
			// End:0x261
			if(JsonString != "")
			{
				ParsedJson = Class'Engine.JsonObject'.static.DecodeJson(JsonString);
				JsonIndex = 0;
				J0x102:

				// End:0x25E [Loop If]
				if(JsonIndex < ParsedJson.ObjectArray.Length)
				{
					MemberId = ParsedJson.ObjectArray[JsonIndex].GetStringValue("unique_user_id");
					GroupID = ParsedJson.ObjectArray[JsonIndex].GetStringValue("group_id");
					AcceptState = byte(ParsedJson.ObjectArray[JsonIndex].GetIntValue("status"));
					CacheGroupMember(MemberId, GroupID, AcceptState);
					JsonIndex++;
					// [Loop Continue]
					goto J0x102;
				}				
			}
			else
			{
				Error = "Query did not return any content in it's response.";
				LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ Error);
			}			
		}
		else
		{
			Error = HttpResponse.GetContentAsString();
		}
	}
	OnQueryGroupMembersComplete(GroupID, bWasSuccessful, Error);
	//return;	
}

function GetGroupMembers(string GroupID, out array<McpGroupMember> GroupMembers)
{
	local int GroupIndex;
	local McpGroupList GroupList;
	local McpGroup GroupTemp;

	// End:0x9C
	foreach GroupLists(GroupList)
	{
		// End:0x9A
		foreach GroupList.Groups(GroupTemp, GroupIndex)
		{
			// End:0x99
			if(GroupTemp.GroupID == GroupID)
			{
				GroupMembers = GroupTemp.Members;
			}			
		}				
	}	
	//return;	
}

function AddGroupMembers(string UniqueUserId, string GroupID, const out array<string> MemberIds, bool bRequiresAcceptance)
{
	local string URL;
	local HttpRequestInterface AddGroupMembersRequest;
	local string JsonPayload;
	local int Index;

	// End:0x404
	if((Len(UniqueUserId) > 0) && Len(GroupID) > 0)
	{
		AddGroupMembersRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		AddGroupMembersRequest.__OnProcessRequestComplete__Delegate = OnAddGroupMembersRequestComplete;
		// End:0x3C7
		if(AddGroupMembersRequest != none)
		{
			URL = ((((((((GetBaseURL()) $ AddGroupMembersUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UniqueUserId) $ "&groupId=") $ GroupID) $ "&requiresAcceptance=") $ ((bRequiresAcceptance) ? "true" : "false");
			// End:0x367
			if(MemberIds.Length > 0)
			{
				JsonPayload = "[ ";
				Index = 0;
				J0x14B:

				// End:0x1D6 [Loop If]
				if(Index < MemberIds.Length)
				{					
					JsonPayload $= (("\"" $ MemberIds[Index]) $ "\"");
					// End:0x1C8
					if((Index + 1) < MemberIds.Length)
					{						
						JsonPayload $= ",";
					}
					Index++;
					// [Loop Continue]
					goto J0x14B;
				}				
				JsonPayload $= " ]";
				AddGroupMembersRequest.SetVerb("POST");
				AddGroupMembersRequest.SetContentAsString(JsonPayload);
				AddGroupMembersRequest.SetURL(URL);
				// End:0x307
				if(!AddGroupMembersRequest.ProcessRequest())
				{
					LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
				}
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "URL(") $ URL) $ ")");				
			}
			else
			{
				LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ " No MemberIds given.");
			}			
		}
		else
		{
			OnAddGroupMembersComplete(GroupID, false, "HttpRequest was not created");
		}		
	}
	else
	{
		OnAddGroupMembersComplete(GroupID, false, "UserId and/or GroupId not specified");
	}
	//return;	
}

delegate OnAddGroupMembersRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content, GroupID;

	ResponseCode = 500;
	// End:0xA2
	if(HttpResponse != none)
	{
		GroupID = HttpResponse.GetURLParameter("GroupId");
		ResponseCode = HttpResponse.GetResponseCode();
		Content = HttpResponse.GetContentAsString();
	}
	bWasSuccessful = bWasSuccessful && ResponseCode == 200;
	OnAddGroupMembersComplete(GroupID, bWasSuccessful, Content);
	//return;	
}

function RemoveGroupMembers(string UniqueUserId, string GroupID, const out array<string> MemberIds)
{
	local string URL;
	local HttpRequestInterface RemoveGroupMembersRequest;
	local string JsonPayload;
	local int Index;

	// End:0x357
	if((Len(UniqueUserId) > 0) && Len(GroupID) > 0)
	{
		RemoveGroupMembersRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x319
		if(RemoveGroupMembersRequest != none)
		{
			URL = ((((GetBaseURL()) $ RemoveGroupMembersUrl) $ (GetAppAccessURL())) $ "&groupId=") $ GroupID;
			// End:0x2B9
			if(MemberIds.Length > 0)
			{
				JsonPayload = "[ ";
				Index = 0;
				J0xC8:

				// End:0x153 [Loop If]
				if(Index < MemberIds.Length)
				{					
					JsonPayload $= (("\"" $ MemberIds[Index]) $ "\"");
					// End:0x145
					if((Index + 1) < MemberIds.Length)
					{						
						JsonPayload $= ",";
					}
					Index++;
					// [Loop Continue]
					goto J0xC8;
				}				
				JsonPayload $= " ]";
				RemoveGroupMembersRequest.SetURL(URL);
				RemoveGroupMembersRequest.SetContentAsString(JsonPayload);
				RemoveGroupMembersRequest.SetVerb("DELETE");
				RemoveGroupMembersRequest.__OnProcessRequestComplete__Delegate = OnRemoveGroupMembersRequestComplete;
				// End:0x2B6
				if(!RemoveGroupMembersRequest.ProcessRequest())
				{
					LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
				}				
			}
			else
			{
				LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ " No MemberIds given.");
			}			
		}
		else
		{
			OnRemoveGroupMembersComplete(GroupID, false, "Http request was not created");
		}		
	}
	else
	{
		OnRemoveGroupMembersComplete(GroupID, false, "UniqueUserId and/or GroupId was not specified");
	}
	//return;	
}

function OnRemoveGroupMembersRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content, GroupID;

	ResponseCode = 500;
	// End:0xA2
	if(HttpResponse != none)
	{
		GroupID = HttpResponse.GetURLParameter("GroupId");
		ResponseCode = HttpResponse.GetResponseCode();
		Content = HttpResponse.GetContentAsString();
	}
	bWasSuccessful = bWasSuccessful && ResponseCode == 200;
	OnRemoveGroupMembersComplete(GroupID, bWasSuccessful, Content);
	//return;	
}

function DeleteAllGroups(string UniqueUserId)
{
	local string URL;
	local HttpRequestInterface DeleteGroupRequest;

	// End:0x21D
	if(Len(UniqueUserId) > 0)
	{
		DeleteGroupRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x1E0
		if(DeleteGroupRequest != none)
		{
			DeleteGroupRequest.SetVerb("DELETE");
			URL = ((((GetBaseURL()) $ DeleteAllGroupsUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UniqueUserId;
			DeleteGroupRequest.SetURL(URL);
			LogInternal("URL=" @ DeleteGroupRequest.GetURL());
			DeleteGroupRequest.__OnProcessRequestComplete__Delegate = OnDeleteGroupRequestComplete;
			// End:0x1DD
			if(!DeleteGroupRequest.ProcessRequest())
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}			
		}
		else
		{
			OnDeleteAllGroupsComplete(UniqueUserId, false, "HttpRequest was not created");
		}		
	}
	else
	{
		OnDeleteAllGroupsComplete(UniqueUserId, false, "UniqueUserId was not specified");
	}
	//return;	
}

function OnDeleteAllGroupsRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content, RequesterId;

	ResponseCode = 500;
	// End:0xB8
	if((HttpResponse != none) && OriginalRequest != none)
	{
		RequesterId = OriginalRequest.GetURLParameter("uniqueUserId");
		ResponseCode = HttpResponse.GetResponseCode();
		Content = HttpResponse.GetContentAsString();
	}
	bWasSuccessful = bWasSuccessful && ResponseCode == 200;
	OnDeleteAllGroupsComplete(RequesterId, bWasSuccessful, Content);
	//return;	
}

function AcceptGroupInvite(string UniqueUserId, string GroupID, bool bShouldAccept)
{
	local string URL;
	local HttpRequestInterface AcceptGroupInviteRequest;

	// End:0x265
	if((Len(UniqueUserId) > 0) && Len(GroupID) > 0)
	{
		AcceptGroupInviteRequest = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x22C
		if(AcceptGroupInviteRequest != none)
		{
			URL = ((((((((GetBaseURL()) $ AcceptGroupInviteUrl) $ (GetAppAccessURL())) $ "&uniqueUserId=") $ UniqueUserId) $ "&groupId=") $ GroupID) $ "&status=") $ ((bShouldAccept) ? "accepted" : "rejected");
			AcceptGroupInviteRequest.SetVerb("POST");
			AcceptGroupInviteRequest.SetURL(URL);
			AcceptGroupInviteRequest.__OnProcessRequestComplete__Delegate = OnAcceptGroupInviteRequestComplete;
			LogInternal("Calling Process Request");
			// End:0x229
			if(!AcceptGroupInviteRequest.ProcessRequest())
			{
				LogInternal(((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ "Failed to process web request for URL(") $ URL) $ ")");
			}			
		}
		else
		{
			OnAcceptGroupInviteComplete(GroupID, false, "HttpRequest not created");
		}		
	}
	else
	{
		OnAcceptGroupInviteComplete(GroupID, false, "UniqueUserId or GroupId was not specified");
	}
	//return;	
}

delegate OnAcceptGroupInviteRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface HttpResponse, bool bWasSuccessful)
{
	local int ResponseCode;
	local string Content, GroupID;

	ResponseCode = 500;
	// End:0xA2
	if(HttpResponse != none)
	{
		GroupID = HttpResponse.GetURLParameter("GroupId");
		ResponseCode = HttpResponse.GetResponseCode();
		Content = HttpResponse.GetContentAsString();
	}
	bWasSuccessful = bWasSuccessful && ResponseCode == 200;
	OnAcceptGroupInviteComplete(GroupID, bWasSuccessful, Content);
	//return;	
}

function CacheGroup(string RequesterId, McpGroup Group)
{
	local int AddAt, GroupIndex, GroupListIndex;
	local McpGroupList UserGroupList;
	local bool bWasFound;

	bWasFound = false;
	GroupListIndex = GroupLists.Find('RequesterId', RequesterId);
	// End:0x25C
	if(GroupListIndex != -1)
	{
		UserGroupList = GroupLists[GroupListIndex];
		GroupIndex = 0;
		J0x70:

		// End:0x11C [Loop If]
		if((GroupIndex < UserGroupList.Groups.Length) && !bWasFound)
		{
			bWasFound = Group.GroupID == UserGroupList.Groups[GroupIndex].GroupID;
			GroupIndex++;
			// [Loop Continue]
			goto J0x70;
		}
		// End:0x1C9
		if(!bWasFound)
		{
			AddAt = UserGroupList.Groups.Length;
			UserGroupList.Groups.Length = AddAt + 1;
			UserGroupList.Groups[AddAt] = Group;
			GroupLists[GroupListIndex] = UserGroupList;
		}
		LogInternal((((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) $ " GroupName: ") $ UserGroupList.Groups[AddAt].GroupName);		
	}
	else
	{
		AddAt = GroupLists.Length;
		GroupLists.Length = AddAt + 1;
		GroupLists[AddAt].RequesterId = Group.OwnerId;
		GroupLists[AddAt].Groups[0] = Group;
	}
	//return;	
}

function CacheGroupMember(string MemberId, string GroupID, McpGroupsBase.EMcpGroupAcceptState AcceptState)
{
	local int MemberIndex;
	local McpGroupList GroupList;
	local int GroupListIndex;
	local McpGroup GroupTemp;
	local int GroupIndex, AddAt;

	// End:0x2BF
	if(((Len(MemberId) > 0) && Len(GroupID) > 0) && Len(string(AcceptState)) > 0)
	{
		// End:0x2BB
		foreach GroupLists(GroupList, GroupListIndex)
		{
			// End:0x29C
			foreach GroupList.Groups(GroupTemp, GroupIndex)
			{
				// End:0x29B
				if(GroupTemp.GroupID == GroupID)
				{
					MemberIndex = GroupTemp.Members.Find('MemberId', MemberId);
					// End:0x1DD
					if(MemberIndex == -1)
					{
						AddAt = GroupTemp.Members.Length;
						GroupTemp.Members.Length = AddAt + 1;
						GroupTemp.Members[AddAt].MemberId = MemberId;
						GroupTemp.Members[AddAt].AcceptState = AcceptState;						
					}
					else
					{
						// End:0x26B
						if(int(GroupTemp.Members[MemberIndex].AcceptState) != int(AcceptState))
						{
							GroupTemp.Members[MemberIndex].AcceptState = AcceptState;
						}
					}
					GroupList.Groups[GroupIndex] = GroupTemp;
				}				
			}			
			GroupLists[GroupListIndex] = GroupList;			
		}				
	}
	else
	{
		LogInternal(((((("(" $ string(Name)) $ ") McpGroupsManager::") $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ " Either the MemberId, GroupId, or AcceptState was not Specified.");
	}
	//return;	
}

defaultproperties
{
	CreateGroupUrl="/groupcreate"
	DeleteGroupUrl="/groupdelete"
	QueryGroupsUrl="/grouplist"
	QueryGroupMembersUrl="/groupmembers"
	AddGroupMembersUrl="/groupmembers"
	RemoveGroupMembersUrl="/groupmembers"
	DeleteAllGroupsUrl="/groupdeletebyownerid"
	AcceptGroupInviteUrl="/groupinvite"
	RejectGroupInviteUrl="/groupinvite"
}