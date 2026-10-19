class WebServer extends TcpLink
	transient
	config(Web);

var config string ServerName;
var config string Applications[10];
var config string ApplicationPaths[10];
var config bool bEnabled;
var config int ListenPort;
var config int MaxConnections;
var config int DefaultApplication;
var config int ExpirationSeconds;
var string ServerURL;
var WebApplication ApplicationObjects[10];
var int ConnectionCount;
var int ConnID;

function PostBeginPlay()
{
	local int I;
	local Class<WebApplication> ApplicationClass;
	local IpAddr L;
	local string S;

	// End:0x59
	if((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_Client))
	{
		Destroy();
		return;
	}
	// End:0xB6
	if(!bEnabled)
	{
		LogInternal("Webserver is not enabled.  Set bEnabled to True in Advanced Options.");
		Destroy();
		return;
	}
	super(Actor).PostBeginPlay();
	// End:0x16D
	if(ServerName == "")
	{
		GetLocalIP(L);
		S = IpAddrToString(L);
		I = InStr(S, ":");
		// End:0x14C
		if(I != -1)
		{
			S = Left(S, I);
		}
		ServerURL = "http://" $ S;		
	}
	else
	{
		ServerURL = "http://" $ ServerName;
	}
	// End:0x1C0
	if(ListenPort != 80)
	{
		ServerURL = (ServerURL $ ":") $ string(ListenPort);
	}
	// End:0x43C
	if((BindPort(ListenPort)) > 0)
	{
		// End:0x413
		if((Listen()) == true)
		{
			LogInternal((((((((("Web Server Created" @ ServerURL) @ "Port:") @ string(ListenPort)) @ "MaxCon") @ string(MaxConnections)) @ "ExpirationSecs") @ string(ExpirationSeconds)) @ "Enabled") @ string(bEnabled));
			I = 0;
			J0x27C:

			// End:0x40E [Loop If]
			if(I < 10)
			{
				// End:0x2A9
				if(Applications[I] == "")
				{
					// [Explicit Break]
					goto J0x40E;
				}
				ApplicationClass = Class<WebApplication>(DynamicLoadObject(Applications[I], Class'Core.Class'));
				// End:0x3D8
				if(ApplicationClass != none)
				{
					ApplicationObjects[I] = new (none) ApplicationClass;
					ApplicationObjects[I].WorldInfo = WorldInfo;
					ApplicationObjects[I].WebServer = self;
					ApplicationObjects[I].Path = ApplicationPaths[I];
					ApplicationObjects[I].Init();					
				}
				else
				{
					LogInternal("Failed to load" @ Applications[I]);
				}
				I++;
				// [Loop Continue]
				goto J0x27C;
			}
			J0x40E:

			return;			
		}
		else
		{
			LogInternal("Unable to setup server for listen");
		}		
	}
	else
	{
		LogInternal("Unable to bind webserver to a port");
	}
	Destroy();
	//return;	
}

event Destroyed()
{
	local int I;

	LogInternal("Destroying WebServer");
	I = 0;
	J0x24:

	// End:0x84 [Loop If]
	if(I < 10)
	{
		// End:0x76
		if(ApplicationObjects[I] != none)
		{
			ApplicationObjects[I].CleanupApp();
		}
		I++;
		// [Loop Continue]
		goto J0x24;
	}
	super(Actor).Destroyed();
	//return;	
}

event GainedChild(Actor C)
{
	super(Actor).GainedChild(C);
	ConnectionCount++;
	// End:0xA1
	if(((MaxConnections > 0) && ConnectionCount > MaxConnections) && int(LinkState) == int(2))
	{
		LogInternal("WebServer: Too many connections - closing down Listen.");
		Close();
	}
	//return;	
}

event LostChild(Actor C)
{
	super(Actor).LostChild(C);
	ConnectionCount--;
	// End:0x94
	if((ConnectionCount <= MaxConnections) && int(LinkState) != int(2))
	{
		LogInternal("WebServer: Listening again - connections have been closed.");
		Listen();
	}
	//return;	
}

function WebApplication GetApplication(string URI, out string SubURI)
{
	local int I, L;

	SubURI = "";
	I = 0;
	J0x17:

	// End:0x107 [Loop If]
	if(I < 10)
	{
		// End:0xF9
		if(ApplicationPaths[I] != "")
		{
			L = Len(ApplicationPaths[I]);
			// End:0xF9
			if((Left(URI, L) ~= ApplicationPaths[I]) && (Len(URI) == L) || Mid(URI, L, 1) == "/")
			{
				SubURI = Mid(URI, L);
				return ApplicationObjects[I];
			}
		}
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	LogInternal("No application found to handle request" @ URI);
	return none;
	//return ReturnValue;	
}

defaultproperties
{
	AcceptClass=Class'IpDrv.WebConnection'
}