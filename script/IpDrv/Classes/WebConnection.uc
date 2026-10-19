class WebConnection extends TcpLink
	transient
	config(Web);

var WebServer WebServer;
var string ReceivedData;
var WebRequest Request;
var WebResponse Response;
var WebApplication Application;
var bool bDelayCleanup;
var int RawBytesExpecting;
var config int MaxValueLength;
var config int MaxLineLength;
var int ConnID;

event Accepted()
{
	WebServer = WebServer(Owner);
	SetTimer(30.0000000, false);
	ConnID = WebServer.ConnID++;
	//return;	
}

event Closed()
{
	Destroy();
	//return;	
}

event Timer()
{
	bDelayCleanup = false;
	Cleanup();
	//return;	
}

event ReceivedText(string Text)
{
	local int I;
	local string S;

	ReceivedData $= Text;
	// End:0x4F
	if(RawBytesExpecting > 0)
	{
		RawBytesExpecting -= Len(Text);
		CheckRawBytes();
		return;
	}
	// End:0x7B
	if(Left(ReceivedData, 1) == Chr(10))
	{
		ReceivedData = Mid(ReceivedData, 1);
	}
	I = InStr(ReceivedData, Chr(13));
	J0x97:

	// End:0x17E [Loop If]
	if(I != -1)
	{
		S = Left(ReceivedData, I);
		I++;
		// End:0xFC
		if(Mid(ReceivedData, I, 1) == Chr(10))
		{
			I++;
		}
		ReceivedData = Mid(ReceivedData, I);
		ReceivedLine(S);
		// End:0x144
		if(int(LinkState) != int(4))
		{
			return;
		}
		// End:0x15F
		if(RawBytesExpecting > 0)
		{
			CheckRawBytes();
			return;
		}
		I = InStr(ReceivedData, Chr(13));
		// [Loop Continue]
		goto J0x97;
	}
	//return;	
}

function ReceivedLine(string S)
{
	// End:0x1D
	if(S == "")
	{
		EndOfHeaders();		
	}
	else
	{
		// End:0x4B
		if(Left(S, 4) ~= "GET ")
		{
			ProcessGet(S);			
		}
		else
		{
			// End:0x7A
			if(Left(S, 5) ~= "POST ")
			{
				ProcessPost(S);				
			}
			else
			{
				// End:0xA9
				if(Left(S, 5) ~= "HEAD ")
				{
					ProcessHead(S);					
				}
				else
				{
					// End:0xE0
					if(Request != none)
					{
						Request.ProcessHeaderString(S);
					}
				}
			}
		}
	}
	//return;	
}

function ProcessHead(string S)
{
	//return;	
}

function ProcessGet(string S)
{
	local int I;

	// End:0x19
	if(Request == none)
	{
		CreateResponseObject();
	}
	Request.RequestType = 0;
	S = Mid(S, 4);
	J0x52:

	// End:0x80 [Loop If]
	if(Left(S, 1) == " ")
	{
		S = Mid(S, 1);
		// [Loop Continue]
		goto J0x52;
	}
	I = InStr(S, " ");
	// End:0xCC
	if(I != -1)
	{
		S = Left(S, I);
	}
	I = InStr(S, "?");
	// End:0x14F
	if(I != -1)
	{
		Request.DecodeFormData(Mid(S, I + 1));
		S = Left(S, I);
	}
	Application = WebServer.GetApplication(S, Request.URI);
	// End:0x20F
	if((Application != none) && Request.URI == "")
	{
		Response.Redirect(S $ "/");
		Cleanup();		
	}
	else
	{
		// End:0x2B3
		if((Application == none) && WebServer.DefaultApplication != -1)
		{
			Response.Redirect(WebServer.ApplicationPaths[WebServer.DefaultApplication] $ "/");
			Cleanup();
		}
	}
	//return;	
}

function ProcessPost(string S)
{
	local int I;

	// End:0x19
	if(Request == none)
	{
		CreateResponseObject();
	}
	Request.RequestType = 1;
	S = Mid(S, 5);
	J0x52:

	// End:0x80 [Loop If]
	if(Left(S, 1) == " ")
	{
		S = Mid(S, 1);
		// [Loop Continue]
		goto J0x52;
	}
	I = InStr(S, " ");
	// End:0xCC
	if(I != -1)
	{
		S = Left(S, I);
	}
	I = InStr(S, "?");
	// End:0x14F
	if(I != -1)
	{
		Request.DecodeFormData(Mid(S, I + 1));
		S = Left(S, I);
	}
	Application = WebServer.GetApplication(S, Request.URI);
	// End:0x20C
	if((Application != none) && Request.URI == "")
	{
		Response.Redirect(S $ "/");
		Cleanup();
	}
	//return;	
}

function CreateResponseObject()
{
	local int I;

	Request = new (none) Class'IpDrv.WebRequest';
	Request.RemoteAddr = IpAddrToString(RemoteAddr);
	I = InStr(Request.RemoteAddr, ":");
	// End:0xD5
	if(I > -1)
	{
		Request.RemoteAddr = Left(Request.RemoteAddr, I);
	}
	Response = new (none) Class'IpDrv.WebResponse';
	Response.Connection = self;
	//return;	
}

function EndOfHeaders()
{
	// End:0x4A
	if(Response == none)
	{
		CreateResponseObject();
		Response.HTTPError(400);
		Cleanup();
		return;
	}
	// End:0x8A
	if(Application == none)
	{
		Response.HTTPError(404);
		Cleanup();
		return;
	}
	// End:0x124
	if((Request.ContentLength != 0) && int(Request.RequestType) == int(1))
	{
		RawBytesExpecting = Request.ContentLength;
		RawBytesExpecting -= Len(ReceivedData);
		CheckRawBytes();		
	}
	else
	{
		// End:0x1BA
		if(Application.PreQuery(Request, Response))
		{
			Application.Query(Request, Response);
			Application.PostQuery(Request, Response);
		}
		Cleanup();
	}
	//return;	
}

function CheckRawBytes()
{
	// End:0x1AD
	if(RawBytesExpecting <= 0)
	{
		// End:0xD9
		if(InStr(Locs(Request.ContentType), "application/x-www-form-urlencoded") != 0)
		{
			LogInternal("WebConnection: Unknown form data content-type: " $ Request.ContentType);
			Response.HTTPError(400);			
		}
		else
		{
			Request.DecodeFormData(ReceivedData);
			// End:0x197
			if(Application.PreQuery(Request, Response))
			{
				Application.Query(Request, Response);
				Application.PostQuery(Request, Response);
			}
			ReceivedData = "";
		}
		Cleanup();
	}
	//return;	
}

function Cleanup()
{
	// End:0x0F
	if(bDelayCleanup)
	{
		return;
	}
	// End:0x29
	if(Request != none)
	{
		Request = none;
	}
	// End:0x63
	if(Response != none)
	{
		Response.Connection = none;
		Response = none;
	}
	// End:0x7D
	if(Application != none)
	{
		Application = none;
	}
	Close();
	//return;	
}

final function bool IsHanging()
{
	return bDelayCleanup;
	//return ReturnValue;	
}
