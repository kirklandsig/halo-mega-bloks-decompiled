class GameCheatManager extends CheatManager within GamePlayerController
	native
	config(Game);

var DebugCameraController DebugCameraControllerRef;
var Class<DebugCameraController> DebugCameraControllerClass;
var config string DebugCameraControllerClassName;

function PatchDebugCameraController()
{
	local Class<DebugCameraController> TempCameraControllerClass;

	// End:0x62
	if(DebugCameraControllerClassName != "")
	{
		TempCameraControllerClass = Class<DebugCameraController>(DynamicLoadObject(DebugCameraControllerClassName, Class'Core.Class'));
		// End:0x62
		if(TempCameraControllerClass != none)
		{
			DebugCameraControllerClass = TempCameraControllerClass;
		}
	}
	//return;	
}

exec function ToggleDebugCamera(optional bool bDrawDebugText = true)
{
	local PlayerController PC;
	local DebugCameraController DCC;

	// End:0xED
	foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xEC
		if(PC.bIsPlayer && PC.IsLocalPlayerController())
		{
			DCC = DebugCameraController(PC);
			// End:0xE9
			if((DCC != none) && DCC.OriginalControllerRef == none)
			{
				continue;				
			}
			// End:0xED
			break;
		}		
	}	
	// End:0x168
	if((DCC != none) && DCC.OriginalControllerRef != none)
	{
		DCC.DisableDebugCamera();
		DCC.Destroy();
		DCC = none;		
	}
	else
	{
		// End:0x18B
		if(PC != none)
		{
			EnableDebugCamera(bDrawDebugText);
		}
	}
	//return;	
}

exec function TeleportPawnToCamera(optional bool bToggleDebugCameraOff = true)
{
	local PlayerController PC;
	local DebugCameraController DCC;
	local Vector ViewLocation;
	local Rotator ViewRotation;

	// End:0xED
	foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xEC
		if(PC.bIsPlayer && PC.IsLocalPlayerController())
		{
			DCC = DebugCameraController(PC);
			// End:0xE9
			if((DCC != none) && DCC.OriginalControllerRef == none)
			{
				continue;				
			}
			// End:0xED
			break;
		}		
	}	
	// End:0x23E
	if((DCC != none) && DCC.OriginalControllerRef != none)
	{
		// End:0x223
		if(DCC.OriginalControllerRef.Pawn != none)
		{
			Outer.GetPlayerViewPoint(ViewLocation, ViewRotation);
			DCC.OriginalControllerRef.Pawn.SetLocation(ViewLocation);
			DCC.OriginalControllerRef.Pawn.SetRotation(ViewRotation);
		}
		// End:0x23B
		if(bToggleDebugCameraOff)
		{
			ToggleDebugCamera();
		}		
	}
	else
	{
		Outer.ClientMessage("TeleportPawnToCamera should be used in conjunction with the ToggleDebugCamera command.   Failed.");
	}
	//return;	
}

function EnableDebugCamera(bool bEnableDebugText)
{
	local Player P;
	local Vector eyeLoc;
	local Rotator eyeRot;
	local float CameraFOVAngle;

	P = Outer.Player;
	// End:0x367
	if(((P != none) && Outer.Pawn != none) && Outer.IsLocalPlayerController())
	{
		PatchDebugCameraController();
		// End:0xB2
		if(DebugCameraControllerRef != none)
		{
			DebugCameraControllerRef.Destroy();
		}
		CameraFOVAngle = Outer.GetFOVAngle();
		DebugCameraControllerRef = Outer.Spawn(DebugCameraControllerClass);
		DebugCameraControllerRef.PlayerInput = none;
		DebugCameraControllerRef.OriginalPlayer = P;
		DebugCameraControllerRef.OriginalControllerRef = Outer;
		Outer.GetPlayerViewPoint(eyeLoc, eyeRot);
		DebugCameraControllerRef.SetLocation(eyeLoc);
		DebugCameraControllerRef.SetRotation(eyeRot);
		DebugCameraControllerRef.bDrawDebugText = bEnableDebugText;
		P.SwitchController(DebugCameraControllerRef);
		DebugCameraControllerRef.OnActivate(Outer);
		DebugCameraControllerRef.GetPlayerViewPoint(eyeLoc, eyeRot);
		// End:0x33F
		if(DebugCameraControllerRef.PlayerCamera != none)
		{
			DebugCameraControllerRef.PlayerCamera.SetFOV(CameraFOVAngle);
			DebugCameraControllerRef.PlayerCamera.UpdateCamera(0.0000000);			
		}
		else
		{
			DebugCameraControllerRef.FOVAngle = CameraFOVAngle;
		}
	}
	//return;	
}

exec function TestHttp(string Verb, string Payload, string URL, optional bool bSendParallelRequest)
{
	local HttpRequestInterface R;

	R = Class'Engine.HttpFactory'.static.CreateRequest();
	R.__OnProcessRequestComplete__Delegate = OnRequestComplete;
	LogInternal("Created request");
	R.SetURL(URL);
	// End:0xD2
	if(Len(Verb) > 0)
	{
		R.SetVerb(Verb);		
	}
	else
	{
		LogInternal("No Verb given, using the defaults.");
	}
	// End:0x135
	if(Len(Payload) > 0)
	{
		R.SetContentAsString(Payload);		
	}
	else
	{
		LogInternal("No payload given.");
	}
	LogInternal("Creating request for URL:" @ URL);
	LogInternal("Key1 =" @ R.GetURLParameter("Key1"));
	LogInternal("Key2 =" @ R.GetURLParameter("Key2"));
	LogInternal("Key3NoValue =" @ R.GetURLParameter("Key3NoValue"));
	LogInternal("NonexistentKey =" @ R.GetURLParameter("NonexistentKey"));
	LogInternal("NonExistentHeader =" @ R.GetHeader("NonExistentHeader"));
	LogInternal("CustomHeaderName =" @ R.GetHeader("CustomHeaderName"));
	LogInternal("ContentType =" @ R.GetContentType());
	LogInternal("ContentLength =" @ string(R.GetContentLength()));
	LogInternal("URL =" @ R.GetURL());
	LogInternal("Verb =" @ R.GetVerb());
	// End:0x426
	if(R.ProcessRequest()!)
	{
		LogInternal("ProcessRequest failed. Unsuppress DevHttpRequest to see more details.");		
	}
	else
	{
		LogInternal("Request sent");
	}
	// End:0x58F
	if(bSendParallelRequest)
	{
		// End:0x575
		if(Class'Engine.HttpFactory'.static.CreateRequest().SetURL("http://www.epicgames.com").SetVerb("GET").SetHeader("Test", "Value").SetProcessRequestCompleteDelegate(OnRequestComplete).ProcessRequest()!)
		{
			LogInternal("ProcessRequest for parallel request failed. Unsuppress DevHttpRequest to see more details.");			
		}
		else
		{
			LogInternal("Parallel Request sent");
		}
	}
	//return;	
}

function OnRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface Response, bool bDidSucceed)
{
	local array<string> Headers;
	local string Header, Payload;
	local int PayloadIndex;

	LogInternal("Got response!!!!!!! Succeeded=" @ string(bDidSucceed));
	LogInternal("URL=" @ OriginalRequest.GetURL());
	// End:0x1F6
	if(Response != none)
	{
		LogInternal("ResponseURL=" @ Response.GetURL());
		LogInternal("Response Code=" @ string(Response.GetResponseCode()));
		Headers = Response.GetHeaders();
		// End:0x12A
		foreach Headers(Header)
		{
			LogInternal("Header:" @ Header);			
		}		
		Payload = Response.GetContentAsString();
		// End:0x1DE
		if(Len(Payload) > 1024)
		{
			PayloadIndex = 0;
			LogInternal("Payload:");
			J0x181:

			// End:0x1DB [Loop If]
			if(PayloadIndex < Len(Payload))
			{
				LogInternal("    " @ Mid(Payload, PayloadIndex, 1024));
				PayloadIndex = PayloadIndex + 1024;
				// [Loop Continue]
				goto J0x181;
			}			
		}
		else
		{
			LogInternal("Payload:" @ Payload);
		}
	}
	//return;	
}

defaultproperties
{
	DebugCameraControllerClassName="GameFramework.DebugCameraController"
}