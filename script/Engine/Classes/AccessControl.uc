class AccessControl extends Info
	config(Game)
	notplaceable
	dependson(OnlineSubsystem, OnlineAuthInterface);

struct PendingClientAuth
{
	var Player ClientConnection;
	var UniqueNetId ClientUID;
	var float AuthTimestamp;
	var int AuthRetryCount;

	structdefaultproperties
	{
		ClientConnection=none
		ClientUID=(Uid=())
		AuthTimestamp=0.0000000
		AuthRetryCount=0
	}
};

struct ServerAuthRetry
{
	var UniqueNetId ClientUID;
	var int AuthRetryCount;

	structdefaultproperties
	{
		ClientUID=(Uid=())
		AuthRetryCount=0
	}
};

var globalconfig array<config string> IPPolicies;
var globalconfig array<config UniqueNetId> BannedIDs;
var const localized string IPBanned;
var const localized string WrongPassword;
var const localized string NeedPassword;
var const localized string SessionBanned;
var const localized string KickedMsg;
var const localized string DefaultKickReason;
var const localized string IdleKickReason;
var Class<Admin> AdminClass;
var private globalconfig string AdminPassword;
var private globalconfig string GamePassword;
var const localized string ACDisplayText[3];
var const localized string ACDescText[3];
var bool bDontAddDefaultAdmin;
var globalconfig bool bAuthenticateClients;
var globalconfig bool bAuthenticateServer;
var globalconfig bool bAuthenticateListenHost;
var bool bAuthDelegatesRegistered;
var bool bPendingListenAuth;
var globalconfig int MaxAuthRetryCount;
var globalconfig int AuthRetryDelay;
var OnlineSubsystem OnlineSub;
var OnlineAuthInterface CachedAuthInt;
var array<PendingClientAuth> ClientsPendingAuth;
var array<ServerAuthRetry> ServerAuthRetries;
var int ListenAuthTicketUID;
var int ListenAuthRetryCount;

function PostBeginPlay()
{
	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	InitAuthHooks();
	//return;	
}

function Destroyed()
{
	Cleanup();
	//return;	
}

function bool IsAdmin(PlayerController P)
{
	// End:0x88
	if(P != none)
	{
		// End:0x29
		if(Admin(P) != none)
		{
			return true;
		}
		// End:0x88
		if((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.bAdmin)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool SetAdminPassword(string P)
{
	AdminPassword = P;
	return true;
	//return ReturnValue;	
}

function SetGamePassword(string P)
{
	GamePassword = P;
	WorldInfo.Game.UpdateGameSettings();
	//return;	
}

function bool RequiresPassword()
{
	return GamePassword != "";
	//return ReturnValue;	
}

function Controller GetControllerFromString(string Target)
{
	local Controller C, FinalC;
	local int I;

	FinalC = none;
	// End:0x100
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		// End:0xFF
		if((C.PlayerReplicationInfo != none) && (C.PlayerReplicationInfo.PlayerName ~= Target) || C.PlayerReplicationInfo.PlayerName ~= Target)
		{
			FinalC = C;
			// End:0x100
			break;
		}		
	}	
	// End:0x26C
	if(((C == none) && WorldInfo != none) && WorldInfo.GRI != none)
	{
		I = 0;
		J0x152:

		// End:0x26C [Loop If]
		if(I < WorldInfo.GRI.PRIArray.Length)
		{
			// End:0x25E
			if(string(WorldInfo.GRI.PRIArray[I].PlayerID) == Target)
			{
				FinalC = Controller(WorldInfo.GRI.PRIArray[I].Owner);
				// [Explicit Break]
				goto J0x26C;
			}
			I++;
			// [Loop Continue]
			goto J0x152;
		}
	}
	J0x26C:

	return FinalC;
	//return ReturnValue;	
}

function Kick(string Target)
{
	local Controller C;

	C = GetControllerFromString(Target);
	// End:0x12E
	if((C != none) && C.PlayerReplicationInfo != none)
	{
		// End:0x92
		if(PlayerController(C) != none)
		{
			KickPlayer(PlayerController(C), DefaultKickReason);			
		}
		else
		{
			// End:0x12E
			if(C.PlayerReplicationInfo != none)
			{
				// End:0x107
				if(C.Pawn != none)
				{
					C.Pawn.Destroy();
				}
				// End:0x12E
				if(C != none)
				{
					C.Destroy();
				}
			}
		}
	}
	//return;	
}

function KickBan(string Target)
{
	local PlayerController P;
	local string IP;

	P = PlayerController(GetControllerFromString(Target));
	// End:0x241
	if(NetConnection(P.Player) != none)
	{
		// End:0x12A
		if(!WorldInfo.IsConsoleBuild())
		{
			IP = P.GetPlayerNetworkAddress();
			// End:0x12A
			if(CheckIPPolicy(IP))
			{
				IP = Left(IP, InStr(IP, ":"));
				LogInternal("Adding IP Ban for: " $ IP);
				IPPolicies[IPPolicies.Length] = "DENY," $ IP;
				SaveConfig();
			}
		}
		// End:0x223
		if(P.PlayerReplicationInfo.UniqueId != P.PlayerReplicationInfo.default.UniqueId && !IsIDBanned(P.PlayerReplicationInfo.UniqueId))
		{
			BannedIDs.AddItem(P.PlayerReplicationInfo.UniqueId);
			SaveConfig();
		}
		KickPlayer(P, DefaultKickReason);
		return;
	}
	//return;	
}

function bool ForceKickPlayer(PlayerController C, string KickReason)
{
	// End:0xDE
	if((C != none) && NetConnection(C.Player) != none)
	{
		// End:0x96
		if(C.Pawn != none)
		{
			C.Pawn.Suicide();
		}
		C.ClientWasKicked();
		// End:0xDC
		if(C != none)
		{
			C.Destroy();
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool KickPlayer(PlayerController C, string KickReason)
{
	// End:0x75
	if(((C != none) && !IsAdmin(C)) && NetConnection(C.Player) != none)
	{
		return ForceKickPlayer(C, KickReason);
	}
	return false;
	//return ReturnValue;	
}

function bool AdminLogin(PlayerController P, string Password)
{
	// End:0x12
	if(AdminPassword == "")
	{
		return false;
	}
	// End:0x61
	if(Password == AdminPassword)
	{
		P.PlayerReplicationInfo.bAdmin = true;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool AdminLogout(PlayerController P)
{
	// End:0xAF
	if(P.PlayerReplicationInfo.bAdmin)
	{
		P.PlayerReplicationInfo.bAdmin = false;
		P.bGodMode = false;
		P.Suicide();
		return true;
	}
	return false;
	//return ReturnValue;	
}

function AdminEntered(PlayerController P)
{
	local string LoginString;

	LoginString = P.PlayerReplicationInfo.PlayerName @ "logged in as a server administrator.";
	LogInternal(LoginString);
	WorldInfo.Game.Broadcast(P, LoginString);
	//return;	
}

function AdminExited(PlayerController P)
{
	local string LogoutString;

	LogoutString = P.PlayerReplicationInfo.PlayerName $ "is no longer logged in as a server administrator.";
	LogInternal(LogoutString);
	WorldInfo.Game.Broadcast(P, LogoutString);
	//return;	
}

function bool ParseAdminOptions(string Options)
{
	local string InAdminName, InPassword;

	InPassword = Class'Engine.GameInfo'.static.ParseOption(Options, "Password");
	InAdminName = Class'Engine.GameInfo'.static.ParseOption(Options, "AdminName");
	return ValidLogin(InAdminName, InPassword);
	//return ReturnValue;	
}

function bool ValidLogin(string UserName, string Password)
{
	return (AdminPassword != "") && Password == AdminPassword;
	//return ReturnValue;	
}

function bool CheckIPPolicy(string Address)
{
	local int I, J, LastMatchingPolicy;
	local string Policy, Mask;
	local bool bAcceptAddress, bAcceptPolicy;

	J = InStr(Address, ":");
	// End:0x4C
	if(J != -1)
	{
		Address = Left(Address, J);
	}
	bAcceptAddress = true;
	I = 0;
	J0x63:

	// End:0x228 [Loop If]
	if(I < IPPolicies.Length)
	{
		J = InStr(IPPolicies[I], ",");
		// End:0xB6
		if(J == -1)
		{			
		}
		else
		{
			Policy = Left(IPPolicies[I], J);
			Mask = Mid(IPPolicies[I], J + 1);
			// End:0x12F
			if(Policy ~= "ACCEPT")
			{
				bAcceptPolicy = true;				
			}
			else
			{
				// End:0x152
				if(Policy ~= "DENY")
				{
					bAcceptPolicy = false;					
				}
				else
				{
					goto J0x21A;
				}
			}
			J = InStr(Mask, "*");
			// End:0x1DB
			if(J != -1)
			{
				// End:0x1D8
				if(Left(Mask, J) == Left(Address, J))
				{
					bAcceptAddress = bAcceptPolicy;
					LastMatchingPolicy = I;
				}				
			}
			else
			{
				// End:0x21A
				if(Mask == Address)
				{
					bAcceptAddress = bAcceptPolicy;
					LastMatchingPolicy = I;
				}
			}
		}
		J0x21A:

		I++;
		// [Loop Continue]
		goto J0x63;
	}
	// End:0x286
	if(!bAcceptAddress)
	{
		LogInternal((("Denied connection for " $ Address) $ " with IP policy ") $ IPPolicies[LastMatchingPolicy]);
	}
	return bAcceptAddress;
	//return ReturnValue;	
}

function bool IsIDBanned(const out UniqueNetId NetId)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x5B [Loop If]
	if(I < BannedIDs.Length)
	{
		// End:0x4D
		if(BannedIDs[I] == NetId)
		{
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

function InitAuthHooks()
{
	local OnlineGameSettings GameSettings;
	local bool bIsLanMatch;

	// End:0x1DF
	if(OnlineSub != none)
	{
		CachedAuthInt = OnlineSub.AuthInterface;
		// End:0xF3
		if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
		{
			GameSettings = OnlineSub.GameInterface.GetGameSettings(WorldInfo.Game.PlayerReplicationInfoClass.default.SessionName);
		}
		// End:0x1DC
		if((((WorldInfo.NetMode == NM_DedicatedServer) || WorldInfo.NetMode == NM_ListenServer) && GameSettings != none) && GameSettings.bIsLanMatch)
		{
			// End:0x1D0
			if(bAuthenticateClients)
			{
				LogInternal("Disabling all authentication, due to bIsLanMatch being set to true");
			}
			bIsLanMatch = true;
		}		
	}
	else
	{
		bIsLanMatch = true;
	}
	// End:0x213
	if(!bIsLanMatch && bAuthenticateClients)
	{
		RegisterAuthDelegates();
	}
	//return;	
}

function RegisterAuthDelegates()
{
	// End:0x23B
	if(NotEqual_InterfaceInterface(CachedAuthInt, none))
	{
		// End:0x76
		if(!CachedAuthInt.IsReady())
		{
			CachedAuthInt.AddAuthReadyDelegate(OnAuthReady);
		}
		CachedAuthInt.AddServerAuthRequestDelegate(ProcessServerAuthRequest);
		CachedAuthInt.AddClientAuthResponseDelegate(ProcessClientAuthResponse);
		CachedAuthInt.AddClientAuthCompleteDelegate(OnClientAuthComplete);
		CachedAuthInt.AddClientConnectionCloseDelegate(OnClientConnectionClose);
		CachedAuthInt.AddServerAuthRetryRequestDelegate(ProcessServerAuthRetryRequest);
		CachedAuthInt.ClearClientConnectionCloseDelegate(Class'Engine.AccessControl'.static.StaticOnClientConnectionClose);
		// End:0x22C
		if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
		{
			OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
		}
		bAuthDelegatesRegistered = true;		
	}
	else
	{
		// End:0x2F9
		if(OnlineSub.Class.Name != 'OnlineSubsystemSteamworks')
		{
			LogInternal("AccessControl: Trying to register authentication delegates with an online subsystem that does not support authentication");
		}
		bAuthDelegatesRegistered = false;
	}
	//return;	
}

function ClearAuthDelegates(bool bExiting)
{
	// End:0x22A
	if(NotEqual_InterfaceInterface(CachedAuthInt, none))
	{
		CachedAuthInt.ClearAuthReadyDelegate(OnAuthReady);
		CachedAuthInt.ClearServerAuthRequestDelegate(ProcessServerAuthRequest);
		CachedAuthInt.ClearClientAuthResponseDelegate(ProcessClientAuthResponse);
		CachedAuthInt.ClearClientAuthCompleteDelegate(OnClientAuthComplete);
		CachedAuthInt.ClearClientConnectionCloseDelegate(OnClientConnectionClose);
		CachedAuthInt.ClearServerAuthRetryRequestDelegate(ProcessServerAuthRetryRequest);
		// End:0x19B
		if(!bExiting)
		{
			CachedAuthInt.AddClientConnectionCloseDelegate(Class'Engine.AccessControl'.static.StaticOnClientConnectionClose);
		}
		// End:0x227
		if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
		{
			OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
		}		
	}
	else
	{
		LogInternal("AccessControl: Trying to clear authentication delegates with an online subsystem that does not support authentication");
	}
	bAuthDelegatesRegistered = false;
	//return;	
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string OutError, bool bSpectator)
{
	local string InPassword;
	local int I, CurIP, CurPort, ClientIP, LingeringPort;

	local bool bFound, bSuccess;
	local UniqueNetId NullId, HostUID;
	local Player ClientConn, CurConn;
	local AuthSession CurClientSession;
	local OnlineGameSettings GameSettings;

	OutError = "";
	InPassword = WorldInfo.Game.ParseOption(Options, "Password");
	// End:0x127
	if((WorldInfo.NetMode != NM_Standalone) && WorldInfo.Game.AtCapacity(bSpectator))
	{
		OutError = PathName(WorldInfo.Game.GameMessageClass) $ ".MaxedOutMessage";		
	}
	else
	{
		// End:0x1E2
		if(((GamePassword != "") && !(InPassword == GamePassword)) && (AdminPassword == "") || !(InPassword == AdminPassword))
		{
			OutError = ((InPassword == "") ? "Engine.AccessControl.NeedPassword" : "Engine.AccessControl.WrongPassword");
		}
	}
	// End:0x223
	if(!CheckIPPolicy(Address))
	{
		OutError = "Engine.AccessControl.IPBanned";
	}
	// End:0xBB6
	if(((bAuthenticateClients && OutError == "") && NotEqual_InterfaceInterface(CachedAuthInt, none)) && bAuthDelegatesRegistered)
	{
		// End:0xBB6
		if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
		{
			GameSettings = OnlineSub.GameInterface.GetGameSettings(WorldInfo.Game.PlayerReplicationInfoClass.default.SessionName);
			// End:0xBB6
			if((((WorldInfo.NetMode == NM_DedicatedServer) || WorldInfo.NetMode == NM_ListenServer) && GameSettings != none) && !GameSettings.bIsLanMatch)
			{
				// End:0x475
				if(!bSupportsAuth)
				{
					// End:0x44B
					if(OnlineSub.Class.Name == 'OnlineSubsystemSteamworks')
					{
						OutError = "Engine.Errors.SteamClientRequired";						
					}
					else
					{
						OutError = "Server requires authentication";
					}
				}
				// End:0x4C3
				if(OutError == "")
				{
					ClientConn = WorldInfo.Game.PauseLogin();
				}
				// End:0xB7A
				if(ClientConn != none)
				{
					// End:0x53D
					foreach WorldInfo.AllClientConnections(CurConn, CurIP, CurPort)
					{
						// End:0x53C
						if(CurConn == ClientConn)
						{
							ClientIP = CurIP;
							// End:0x53D
							break;
						}						
					}					
					LingeringPort = 0;
					// End:0x5FC
					foreach CachedAuthInt.AllClientAuthSessions(CurClientSession)
					{
						// End:0x5FB
						if((CurClientSession.EndPointIP == ClientIP) && CurClientSession.EndPointUID == UniqueId)
						{
							LingeringPort = CurClientSession.EndPointPort;
							// End:0x5FC
							break;
						}						
					}					
					// End:0x75A
					if(LingeringPort != 0)
					{
						// End:0x759
						foreach WorldInfo.AllClientConnections(CurConn, CurIP, CurPort)
						{
							// End:0x758
							if(((CurConn != ClientConn) && CurIP == ClientIP) && CurPort == LingeringPort)
							{
								LogInternal(((("Closing old connection with duplicate IP (" $ Address) $ ") and SteamId (") $ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(UniqueId)) $ ")", 'DevNet');
								WorldInfo.Game.RejectLogin(CurConn, "");
								// End:0x759
								break;
							}							
						}						
					}
					I = 0;
					J0x765:

					// End:0x7D5 [Loop If]
					if(I < ClientsPendingAuth.Length)
					{
						// End:0x7C7
						if(ClientsPendingAuth[I].ClientUID == UniqueId)
						{
							bFound = true;
							// [Explicit Break]
							goto J0x7D5;
						}
						I++;
						// [Loop Continue]
						goto J0x765;
					}
					J0x7D5:

					// End:0x87E
					if(!bFound)
					{
						// End:0x87D
						foreach CachedAuthInt.AllClientAuthSessions(CurClientSession)
						{
							// End:0x87C
							if(CurClientSession.EndPointUID == UniqueId && CurClientSession.EndPointIP != ClientIP)
							{
								bFound = true;
								// End:0x87D
								break;
							}							
						}						
					}
					// End:0x94F
					if((((WorldInfo.NetMode == NM_ListenServer) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none)) && OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID)) && UniqueId == HostUID)
					{
						bFound = true;
					}
					// End:0xB37
					if(!bFound && UniqueId != NullId)
					{
						// End:0xA1C
						if(CachedAuthInt.IsReady())
						{
							bSuccess = CachedAuthInt.SendClientAuthRequest(ClientConn, UniqueId);
							// End:0xA19
							if(bSuccess && !IsTimerActive('PendingAuthTimer'))
							{
								SetTimer(3.0000000, true, 'PendingAuthTimer');
							}							
						}
						else
						{
							bSuccess = true;
						}
						// End:0xB08
						if(bSuccess)
						{
							I = ClientsPendingAuth.Length;
							ClientsPendingAuth.Length = I + 1;
							ClientsPendingAuth[I].ClientConnection = ClientConn;
							ClientsPendingAuth[I].ClientUID = UniqueId;
							ClientsPendingAuth[I].AuthTimestamp = WorldInfo.RealTimeSeconds;							
						}
						else
						{
							OutError = "Failed to kickoff authentication";
						}						
					}
					else
					{
						// End:0xB60
						if(bFound)
						{
							OutError = "Duplicate UID";							
						}
						else
						{
							OutError = "Invalid UID";
						}
					}					
				}
				else
				{
					// End:0xBB6
					if(OutError == "")
					{
						OutError = "Failed to kickoff authentication";
					}
				}
			}
		}
	}
	//return;	
}

function PendingAuthTimer()
{
	local int I, OldLength;
	local bool bFailed;
	local AuthSession CurClientSession;

	I = 0;
	J0x0B:

	// End:0x48D [Loop If]
	if(I < ClientsPendingAuth.Length)
	{
		// End:0x72
		if(ClientsPendingAuth[I].ClientConnection == none)
		{
			ClientsPendingAuth.Remove(I, 1);
			I--;			
		}
		else
		{
			// End:0x103
			if(WorldInfo.RealTimeSeconds < ClientsPendingAuth[I].AuthTimestamp)
			{
				ClientsPendingAuth[I].AuthTimestamp = WorldInfo.RealTimeSeconds;				
			}
			else
			{
				// End:0x47F
				if((WorldInfo.RealTimeSeconds - ClientsPendingAuth[I].AuthTimestamp) >= float(AuthRetryDelay))
				{
					// End:0x47F
					if(CachedAuthInt.FindClientAuthSession(ClientsPendingAuth[I].ClientConnection, CurClientSession))
					{
						// End:0x361
						if(ClientsPendingAuth[I].AuthRetryCount < MaxAuthRetryCount)
						{
							CachedAuthInt.EndRemoteClientAuthSession(CurClientSession.EndPointUID, CurClientSession.EndPointIP);
							CachedAuthInt.SendClientAuthEndSessionRequest(ClientsPendingAuth[I].ClientConnection);
							// End:0x352
							if(CachedAuthInt.SendClientAuthRequest(ClientsPendingAuth[I].ClientConnection, CurClientSession.EndPointUID))
							{
								ClientsPendingAuth[I].AuthTimestamp = WorldInfo.RealTimeSeconds;
								ClientsPendingAuth[I].AuthRetryCount++;								
							}
							else
							{
								bFailed = true;
							}							
						}
						else
						{
							bFailed = true;
						}
						// End:0x47F
						if(bFailed)
						{
							LogInternal(("Client authentication timed out after" @ string(MaxAuthRetryCount)) @ "tries", 'DevOnline');
							OldLength = ClientsPendingAuth.Length;
							WorldInfo.Game.RejectLogin(ClientsPendingAuth[I].ClientConnection, "Authentication failed");
							// End:0x474
							if(OldLength == ClientsPendingAuth.Length)
							{
								ClientsPendingAuth.Remove(I, 1);
							}
							I--;
						}
					}
				}
			}
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x4B1
	if(ClientsPendingAuth.Length == 0)
	{
		ClearTimer('PendingAuthTimer');
	}
	//return;	
}

function OnAuthReady()
{
	local int I, OldLength;

	// End:0x2AF
	if(bAuthDelegatesRegistered)
	{
		I = 0;
		J0x18:

		// End:0x204 [Loop If]
		if(I < ClientsPendingAuth.Length)
		{
			// End:0x7F
			if(ClientsPendingAuth[I].ClientConnection == none)
			{
				ClientsPendingAuth.Remove(I, 1);
				I--;				
			}
			else
			{
				// End:0x136
				if(CachedAuthInt.SendClientAuthRequest(ClientsPendingAuth[I].ClientConnection, ClientsPendingAuth[I].ClientUID))
				{
					ClientsPendingAuth[I].AuthTimestamp = WorldInfo.RealTimeSeconds;					
				}
				else
				{
					OldLength = ClientsPendingAuth.Length;
					WorldInfo.Game.RejectLogin(ClientsPendingAuth[I].ClientConnection, "Authentication failed");
					// End:0x1E8
					if(OldLength == ClientsPendingAuth.Length)
					{
						ClientsPendingAuth.Remove(I, 1);
					}
					I--;					
				}
			}
			++I;
			// [Loop Continue]
			goto J0x18;
		}
		// End:0x25D
		if(ClientsPendingAuth.Length > 0)
		{
			LogInternal("OnAuthReady: Kicking off delayed auth for clients");
			SetTimer(3.0000000, true, 'PendingAuthTimer');
		}
		// End:0x2AF
		if((bAuthenticateListenHost && WorldInfo.NetMode == NM_ListenServer) && bPendingListenAuth)
		{
			BeginListenHostAuth();
		}
	}
	//return;	
}

function ProcessClientAuthResponse(UniqueNetId ClientUID, int ClientIP, int AuthTicketUID)
{
	local bool bSuccess;
	local int I, PendingIdx, OldLength;

	PendingIdx = -1;
	I = 0;
	J0x1A:

	// End:0x91 [Loop If]
	if(I < ClientsPendingAuth.Length)
	{
		// End:0x83
		if(ClientsPendingAuth[I].ClientUID == ClientUID)
		{
			PendingIdx = I;
			// [Explicit Break]
			goto J0x91;
		}
		I++;
		// [Loop Continue]
		goto J0x1A;
	}
	J0x91:

	// End:0x1AF
	if(PendingIdx != -1)
	{
		bSuccess = CachedAuthInt.VerifyClientAuthSession(ClientUID, ClientIP, 0, AuthTicketUID);
		// End:0x1AC
		if(!bSuccess)
		{
			OldLength = ClientsPendingAuth.Length;
			WorldInfo.Game.RejectLogin(ClientsPendingAuth[I].ClientConnection, "Authentication failed");
			// End:0x1AC
			if(OldLength == ClientsPendingAuth.Length)
			{
				ClientsPendingAuth.Remove(PendingIdx, 1);
			}
		}		
	}
	else
	{
		LogInternal("AccessControl::ProcessClientAuthResponse: Received unexpected auth ticket from client", 'DevOnline');
	}
	//return;	
}

function OnClientAuthComplete(bool bSuccess, UniqueNetId ClientUID, Player ClientConnection, string ExtraInfo)
{
	local UniqueNetId HostUID;
	local int I, PendingLen, PendingIdx;
	local PlayerController P;
	local PlayerReplicationInfo PRI;
	local bool bResumeLogin;
	local AuthSession CurClientSession;

	// End:0x127
	if((((WorldInfo.NetMode == NM_ListenServer) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none)) && OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID)) && HostUID == ClientUID)
	{
		// End:0x125
		if(bSuccess)
		{
			LogInternal("Listen host successfully authenticated");
			ClearTimer('ListenHostAuthTimeout');
			ClearTimer('ContinueListenHostAuth');
		}
		return;
	}
	PendingLen = ClientsPendingAuth.Length;
	PendingIdx = -1;
	I = 0;
	J0x155:

	// End:0x223 [Loop If]
	if(I < PendingLen)
	{
		// End:0x215
		if(((ClientConnection != none) && ClientsPendingAuth[I].ClientConnection == ClientConnection) || (ClientConnection == none) && ClientsPendingAuth[I].ClientUID == ClientUID)
		{
			PendingIdx = I;
			// [Explicit Break]
			goto J0x223;
		}
		I++;
		// [Loop Continue]
		goto J0x155;
	}
	J0x223:

	// End:0x5DB
	if(PendingIdx != -1)
	{
		// End:0x5AB
		if(ClientConnection != none)
		{
			// End:0x4E8
			if(bSuccess)
			{
				// End:0x2DE
				foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
				{
					// End:0x2DD
					if(P.Player == ClientConnection)
					{
						PRI = P.PlayerReplicationInfo;
						// End:0x2DE
						break;
					}					
				}				
				// End:0x3A5
				if(PRI != none)
				{
					P.PlayerReplicationInfo.SetUniqueId(ClientUID);
					LogInternal((("Client '" $ PRI.PlayerName) $ "'passed authentication, UID:") @ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(ClientUID));					
				}
				else
				{
					LogInternal("Client passed authentication, UID:" @ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(ClientUID));
				}
				bResumeLogin = true;
				// End:0x4E5
				if(bAuthenticateServer)
				{
					// End:0x49B
					if(CachedAuthInt.FindClientAuthSession(ClientConnection, CurClientSession))
					{
						ProcessServerAuthRequest(ClientConnection, ClientUID, CurClientSession.EndPointIP, CurClientSession.EndPointPort);						
					}
					else
					{
						LogInternal("Failed to kickoff server auth; could not find matching client session");
					}
				}				
			}
			else
			{
				LogInternal(("Client failed authentication (unauthenticated UID:" @ Class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(ClientUID)) $ "), kicking");
				WorldInfo.Game.RejectLogin(ClientConnection, "Authentication failed");
			}
		}
		// End:0x5D8
		if(ClientsPendingAuth.Length == PendingLen)
		{
			ClientsPendingAuth.Remove(PendingIdx, 1);
		}		
	}
	else
	{
		LogInternal("AccessControl::OnClientAuthComplete: Received unexpected auth result for client", 'DevOnline');
	}
	// End:0x681
	if(bResumeLogin)
	{
		WorldInfo.Game.ResumeLogin(ClientConnection);
	}
	//return;	
}

function ProcessServerAuthRequest(Player ClientConnection, UniqueNetId ClientUID, int ClientIP, int ClientPort)
{
	local int AuthTicketUID;
	local LocalAuthSession CurServerSession;
	local bool bFound;

	// End:0x192
	if(bAuthenticateServer)
	{
		// End:0xA3
		foreach CachedAuthInt.AllLocalServerAuthSessions(CurServerSession)
		{
			// End:0xA2
			if(CurServerSession.EndPointUID == ClientUID && CurServerSession.EndPointIP == ClientIP)
			{
				bFound = true;
			}			
		}		
		// End:0x192
		if(!bFound)
		{
			// End:0x168
			if(CachedAuthInt.CreateServerAuthSession(ClientUID, ClientIP, ClientPort, AuthTicketUID))
			{
				// End:0x165
				if(!CachedAuthInt.SendServerAuthResponse(ClientConnection, AuthTicketUID))
				{
					LogInternal("WARNING!!! Failed to send auth ticket to client");
				}				
			}
			else
			{
				LogInternal("Failed to kickoff server auth", 'DevOnline');
			}
		}
	}
	//return;	
}

function ProcessServerAuthRetryRequest(Player ClientConnection)
{
	local bool bFoundAndAuthenticated;
	local int ClientIP, ClientPort, I, CurRetryIdx;
	local UniqueNetId ClientUID;
	local AuthSession CurClientSession;
	local LocalAuthSession CurServerSession;

	// End:0x3DD
	if(bAuthenticateServer && ClientConnection != none)
	{
		bFoundAndAuthenticated = CachedAuthInt.FindClientAuthSession(ClientConnection, CurClientSession) && int(CurClientSession.AuthStatus) == 2;
		// End:0x3DD
		if(bFoundAndAuthenticated)
		{
			ClientUID = CurClientSession.EndPointUID;
			ClientIP = CurClientSession.EndPointIP;
			ClientPort = CurClientSession.EndPointPort;
			CurRetryIdx = -1;
			I = 0;
			J0x11D:

			// End:0x194 [Loop If]
			if(I < ServerAuthRetries.Length)
			{
				// End:0x186
				if(ServerAuthRetries[I].ClientUID == ClientUID)
				{
					CurRetryIdx = I;
					// [Explicit Break]
					goto J0x194;
				}
				++I;
				// [Loop Continue]
				goto J0x11D;
			}
			J0x194:

			// End:0x202
			if(CurRetryIdx == -1)
			{
				CurRetryIdx = ServerAuthRetries.Length;
				ServerAuthRetries.Length = CurRetryIdx + 1;
				ServerAuthRetries[CurRetryIdx].ClientUID = ClientUID;
			}
			// End:0x323
			if(ServerAuthRetries[CurRetryIdx].AuthRetryCount < MaxAuthRetryCount)
			{
				// End:0x2C9
				foreach CachedAuthInt.AllLocalServerAuthSessions(CurServerSession)
				{
					// End:0x2C8
					if(CurServerSession.EndPointUID == ClientUID)
					{
						CachedAuthInt.EndLocalServerAuthSession(ClientUID, ClientIP);
						// End:0x2C9
						break;
					}					
				}				
				ProcessServerAuthRequest(ClientConnection, ClientUID, ClientIP, ClientPort);
				ServerAuthRetries[CurRetryIdx].AuthRetryCount++;				
			}
			else
			{
				// End:0x3B5
				if(ServerAuthRetries[CurRetryIdx].AuthRetryCount > Max(30, MaxAuthRetryCount + 20))
				{
					WorldInfo.Game.RejectLogin(ClientConnection, "Spamming server auth");					
				}
				else
				{
					ServerAuthRetries[CurRetryIdx].AuthRetryCount++;
				}
			}
		}
	}
	//return;	
}

function NotifyStartOnlineGame()
{
	// End:0xA6
	if(((bAuthDelegatesRegistered && bAuthenticateListenHost) && WorldInfo.NetMode == NM_ListenServer) && NotEqual_InterfaceInterface(CachedAuthInt, none))
	{
		// End:0x9A
		if(CachedAuthInt.IsReady())
		{
			BeginListenHostAuth();			
		}
		else
		{
			bPendingListenAuth = true;
		}
	}
	//return;	
}

function BeginListenHostAuth(optional bool bRetry)
{
	local UniqueNetId ServerUID, HostUID;
	local int ServerIP, ServerPort;
	local OnlineGameSettings GameSettings;
	local bool bGotHostInfo, bFound, bSecure;
	local AuthSession CurClientSession, ListenSession;

	bPendingListenAuth = false;
	// End:0xE0
	if(CachedAuthInt.IsReady())
	{
		bGotHostInfo = (CachedAuthInt.GetServerUniqueId(ServerUID) && CachedAuthInt.GetServerAddr(ServerIP, ServerPort)) && OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID);
	}
	// End:0x41D
	if(bGotHostInfo)
	{
		// End:0x199
		foreach CachedAuthInt.AllClientAuthSessions(CurClientSession)
		{
			// End:0x198
			if(CurClientSession.EndPointUID == HostUID && CurClientSession.EndPointIP == ServerIP)
			{
				ListenSession = CurClientSession;
				bFound = true;
				// End:0x199
				break;
			}			
		}		
		// End:0x351
		if(!bFound || bRetry)
		{
			LogInternal("Kicking off listen auth session");
			// End:0x298
			if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, none))
			{
				GameSettings = OnlineSub.GameInterface.GetGameSettings(WorldInfo.Game.PlayerReplicationInfoClass.default.SessionName);
			}
			// End:0x2D1
			if(GameSettings != none)
			{
				bSecure = GameSettings.bAntiCheatProtected;
			}
			// End:0x335
			if(CachedAuthInt.CreateClientAuthSession(ServerUID, ServerIP, ServerPort, bSecure, ListenAuthTicketUID))
			{
				SetTimer(1.0000000, false, 'ContinueListenHostAuth');
			}
			SetTimer(float(AuthRetryDelay), false, 'ListenHostAuthTimeout');			
		}
		else
		{
			// End:0x41A
			if((int(ListenSession.AuthStatus) != 2) && !IsTimerActive('ListenHostAuthTimeout'))
			{
				LogInternal("BeginListenHostAuth was called when there is already a listen auth session, but the timeout is not active");
				SetTimer(float(AuthRetryDelay), false, 'ListenHostAuthTimeout');
			}
		}		
	}
	else
	{
		LogInternal("Failed to kickoff listen host authentication");
		OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID);
		OnClientAuthComplete(false, HostUID, none, "Failed to kickoff listen host authentication");
	}
	//return;	
}

function ContinueListenHostAuth()
{
	local bool bGotHostInfo;
	local UniqueNetId HostUID;
	local int ServerIP, ServerPort;

	// End:0xB7
	if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
	{
		bGotHostInfo = OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID) && CachedAuthInt.GetServerAddr(ServerIP, ServerPort);
	}
	// End:0x1C9
	if(!bGotHostInfo || !CachedAuthInt.VerifyClientAuthSession(HostUID, ServerIP, ServerPort, ListenAuthTicketUID))
	{
		LogInternal("VerifyClientAuthSession failed for listen host");
		OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID);
		OnClientAuthComplete(false, HostUID, none, "VerifyClientAuthSession failed for listen host");
	}
	//return;	
}

function EndListenHostAuth()
{
	local bool bGotHostInfo;
	local UniqueNetId ServerUID, HostUID;
	local int ServerIP, ServerPort;

	// End:0xE5
	if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, none))
	{
		bGotHostInfo = (CachedAuthInt.GetServerUniqueId(ServerUID) && CachedAuthInt.GetServerAddr(ServerIP, ServerPort)) && OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID);
	}
	// End:0x162
	if(bGotHostInfo)
	{
		CachedAuthInt.EndLocalClientAuthSession(ServerUID, ServerIP, ServerPort);
		CachedAuthInt.EndRemoteClientAuthSession(HostUID, ServerIP);		
	}
	else
	{
		LogInternal("Failed to end listen host auth session");
	}
	//return;	
}

function ListenHostAuthTimeout()
{
	local UniqueNetId HostUID;

	ClearTimer('ListenHostAuthTimeout');
	ClearTimer('ContinueListenHostAuth');
	// End:0x58
	if(ListenAuthRetryCount < MaxAuthRetryCount)
	{
		ListenAuthRetryCount++;
		BeginListenHostAuth(true);		
	}
	else
	{
		LogInternal(("Listen host authentication failed after" @ string(MaxAuthRetryCount)) @ "attempts");
		OnlineSub.PlayerInterface.GetUniquePlayerId(0, HostUID);
		OnClientAuthComplete(false, HostUID, none, "VerifyClientAuthSession failed for listen host");
		EndListenHostAuth();
	}
	//return;	
}

function OnClientConnectionClose(Player ClientConnection)
{
	local int I;

	// End:0xB0
	if(ClientConnection != none)
	{
		StaticOnClientConnectionClose(ClientConnection);
		I = 0;
		J0x2D:

		// End:0xB0 [Loop If]
		if(I < ClientsPendingAuth.Length)
		{
			// End:0xA2
			if((ClientConnection != none) && ClientsPendingAuth[I].ClientConnection == ClientConnection)
			{
				ClientsPendingAuth.Remove(I, 1);
				// [Explicit Break]
				goto J0xB0;
			}
			++I;
			// [Loop Continue]
			goto J0x2D;
		}
	}
	J0xB0:

	//return;	
}

static final function StaticOnClientConnectionClose(Player ClientConnection)
{
	local OnlineSubsystem CurOnlineSub;
	local OnlineAuthInterface CurAuthInt;
	local int I;
	local WorldInfo WI;
	local AuthSession CurClientSession;
	local LocalAuthSession CurServerSession;

	CurOnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x60
	if(CurOnlineSub != none)
	{
		CurAuthInt = CurOnlineSub.AuthInterface;
	}
	// End:0x3C1
	if(NotEqual_InterfaceInterface(CurAuthInt, none) && ClientConnection != none)
	{
		// End:0x147
		if(CurAuthInt.FindClientAuthSession(ClientConnection, CurClientSession) && int(CurClientSession.AuthStatus) == 2)
		{
			CurAuthInt.EndRemoteClientAuthSession(CurClientSession.EndPointUID, CurClientSession.EndPointIP);
		}
		// End:0x3C1
		if(CurAuthInt.FindLocalServerAuthSession(ClientConnection, CurServerSession))
		{
			CurAuthInt.EndLocalServerAuthSession(CurServerSession.EndPointUID, CurServerSession.EndPointIP);
			WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
			// End:0x3C1
			if(((WI != none) && WI.Game != none) && WI.Game.AccessControl != none)
			{
				I = 0;
				J0x278:

				// End:0x3C1 [Loop If]
				if(I < WI.Game.AccessControl.ServerAuthRetries.Length)
				{
					// End:0x3B3
					if(WI.Game.AccessControl.ServerAuthRetries[I].ClientUID == CurServerSession.EndPointUID)
					{
						WI.Game.AccessControl.ServerAuthRetries.Remove(I, 1);
						// [Explicit Break]
						goto J0x3C1;
					}
					++I;
					// [Loop Continue]
					goto J0x278;
				}
			}
		}
	}
	J0x3C1:

	//return;	
}

function OnDestroyOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	local int CurIP, CurPort;
	local Player ClientConn, CurConn;
	local AuthSession CurClientSession;

	// End:0x33
	if(WorldInfo.NetMode == NM_ListenServer)
	{
		EndListenHostAuth();
	}
	// End:0x244
	foreach CachedAuthInt.AllClientAuthSessions(CurClientSession)
	{
		// End:0x243
		if(int(CurClientSession.AuthStatus) == 2)
		{
			CachedAuthInt.EndRemoteClientAuthSession(CurClientSession.EndPointUID, CurClientSession.EndPointIP);
			// End:0x188
			foreach WorldInfo.AllClientConnections(CurConn, CurIP, CurPort)
			{
				// End:0x187
				if((CurIP == CurClientSession.EndPointIP) && CurPort == CurClientSession.EndPointPort)
				{
					ClientConn = CurConn;
					// End:0x188
					break;
				}				
			}			
			// End:0x1F5
			if(ClientConn != none)
			{
				// End:0x1F2
				if(!CachedAuthInt.SendClientAuthEndSessionRequest(ClientConn))
				{
					LogInternal("Failed to send client kill auth request");
				}
				// End:0x243
				continue;
			}
			LogInternal("WARNING!!! Came across client auth session with no matching NetConnection");
		}		
	}	
	CachedAuthInt.EndAllLocalServerAuthSessions();
	ServerAuthRetries.Length = 0;
	//return;	
}

function NotifyServerTravel(bool bSeamless)
{
	// End:0x1A
	if(!bSeamless)
	{
		Cleanup();
	}
	//return;	
}

function NotifyGameEnding()
{
	local GameEngine Engine;

	Engine = GameEngine(Class'Engine.Engine'.static.GetEngine());
	// End:0x8C
	if((WorldInfo.NextURL != "") || Engine.TravelURL != "")
	{
		Cleanup();		
	}
	else
	{
		NotifyExit();
	}
	//return;	
}

function NotifyExit()
{
	Cleanup(true);
	//return;	
}

function Cleanup(optional bool bExit)
{
	// End:0x8E
	if(NotEqual_InterfaceInterface(CachedAuthInt, none))
	{
		ClearAuthDelegates(bExit);
		// End:0x8E
		if(bExit)
		{
			CachedAuthInt.EndAllRemoteClientAuthSessions();
			CachedAuthInt.EndAllLocalServerAuthSessions();
			ServerAuthRetries.Length = 0;
		}
	}
	CachedAuthInt = none;
	OnlineSub = none;
	//return;	
}

function bool IsPendingAuth(UniqueNetId PlayerUID)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x6E [Loop If]
	if(I < ClientsPendingAuth.Length)
	{
		// End:0x60
		if(ClientsPendingAuth[I].ClientUID == PlayerUID)
		{
			return true;
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	IPPolicies[0]="ACCEPT;*"
	IPBanned="Your IP address has been banned on this server."
	WrongPassword="The password you entered is incorrect."
	NeedPassword="You need to enter a password to join this game."
	SessionBanned="Your IP address has been banned from the current game session."
	KickedMsg="You have been forcibly removed from the game."
	DefaultKickReason="None specified"
	IdleKickReason="Kicked for idling."
	AdminClass=Class'Engine.Admin'
	ACDisplayText[0]="Game Password"
	ACDisplayText[1]="Access Policies"
	ACDisplayText[2]="Admin Password"
	ACDescText[0]="If this password is set, players will have to enter it to join this server."
	ACDescText[1]="Specifies IP addresses or address ranges which have been banned."
	ACDescText[2]="Password required to login with administrator privileges on this server."
	bAuthenticateClients=true
	bAuthenticateServer=true
	bAuthenticateListenHost=true
	MaxAuthRetryCount=3
	AuthRetryDelay=5
	bAlwaysTick=true
}