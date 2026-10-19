class McpServerTimeManager extends McpServerTimeBase
	config(Engine);

var config string TimeStampUrl;
var string LastTimeStamp;
var HttpRequestInterface HTTPRequestServerTime;

function QueryServerTime()
{
	local string URL, ErrorStr;
	local bool bPending;

	// End:0x196
	if(HTTPRequestServerTime == none)
	{
		HTTPRequestServerTime = Class'Engine.HttpFactory'.static.CreateRequest();
		// End:0x193
		if(HTTPRequestServerTime != none)
		{
			URL = ((GetBaseURL()) $ TimeStampUrl) $ (GetAppAccessURL());
			HTTPRequestServerTime.SetURL(URL);
			HTTPRequestServerTime.SetVerb("GET");
			HTTPRequestServerTime.__OnProcessRequestComplete__Delegate = OnQueryServerTimeHTTPRequestComplete;
			// End:0x11F
			if(HTTPRequestServerTime.ProcessRequest())
			{
				bPending = true;				
			}
			else
			{
				ErrorStr = "failed to start request, Url=" $ URL;
				LogInternal(((("McpServerTimeManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
			}
		}		
	}
	else
	{
		ErrorStr = "last request is still being processed";
		LogInternal(((("McpServerTimeManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	// End:0x235
	if(!bPending)
	{
		OnQueryServerTimeComplete(false, "", ErrorStr);
	}
	//return;	
}

private final function OnQueryServerTimeHTTPRequestComplete(HttpRequestInterface Request, HttpResponseInterface Response, bool bWasSuccessful)
{
	local string TimeStr, ResponseStr, ErrorStr;
	local int Idx;
	local bool bResult;

	HTTPRequestServerTime = none;
	// End:0x1C1
	if(bWasSuccessful && Response != none)
	{
		// End:0x12A
		if(Response.GetResponseCode() == 200)
		{
			ResponseStr = Response.GetContentAsString();
			Idx = InStr(ResponseStr, "Timestamp=");
			// End:0x127
			if(Idx != -1)
			{
				TimeStr = Mid(ResponseStr, Idx);
				Idx = InStr(ResponseStr, "=");
				TimeStr = Mid(TimeStr, Idx);
				LastTimeStamp = TimeStr;
				bResult = true;
			}			
		}
		else
		{
			ErrorStr = "invalid server response code, status=" $ string(Response.GetResponseCode());
			LogInternal(((("McpServerTimeManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
		}		
	}
	else
	{
		ErrorStr = "no response";
		LogInternal(((("McpServerTimeManager::" $ string(GetStateName())) $ ":") $ string(GetFuncName())) @ ErrorStr);
	}
	OnQueryServerTimeComplete(bResult, TimeStr, ErrorStr);
	//return;	
}

function string GetLastServerTime()
{
	return LastTimeStamp;
	//return ReturnValue;	
}

defaultproperties
{
	TimeStampUrl="/timestamp"
}