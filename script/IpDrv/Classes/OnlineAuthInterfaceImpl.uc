class OnlineAuthInterfaceImpl extends Object within OnlineSubsystemCommonImpl
	native
	implements(OnlineAuthInterface);

var private native const noexport Pointer VfTable_IOnlineAuthInterface;
var OnlineSubsystemCommonImpl OwningSubsystem;
var const bool bAuthReady;
var native const SparseArray_Mirror ClientAuthSessions;
var native const SparseArray_Mirror ServerAuthSessions;
var native const SparseArray_Mirror PeerAuthSessions;
var native const SparseArray_Mirror LocalClientAuthSessions;
var native const SparseArray_Mirror LocalServerAuthSessions;
var native const SparseArray_Mirror LocalPeerAuthSessions;
var array< delegate<OnAuthReady> > AuthReadyDelegates;
var array< delegate<OnClientAuthRequest> > ClientAuthRequestDelegates;
var array< delegate<OnServerAuthRequest> > ServerAuthRequestDelegates;
var array< delegate<OnClientAuthResponse> > ClientAuthResponseDelegates;
var array< delegate<OnServerAuthResponse> > ServerAuthResponseDelegates;
var array< delegate<OnClientAuthComplete> > ClientAuthCompleteDelegates;
var array< delegate<OnServerAuthComplete> > ServerAuthCompleteDelegates;
var array< delegate<OnClientAuthEndSessionRequest> > ClientAuthEndSessionRequestDelegates;
var array< delegate<OnServerAuthRetryRequest> > ServerAuthRetryRequestDelegates;
var array< delegate<OnClientConnectionClose> > ClientConnectionCloseDelegates;
var array< delegate<OnServerConnectionClose> > ServerConnectionCloseDelegates;
//var delegate<OnAuthReady> __OnAuthReady__Delegate;
//var delegate<OnClientAuthRequest> __OnClientAuthRequest__Delegate;
//var delegate<OnServerAuthRequest> __OnServerAuthRequest__Delegate;
//var delegate<OnClientAuthResponse> __OnClientAuthResponse__Delegate;
//var delegate<OnServerAuthResponse> __OnServerAuthResponse__Delegate;
//var delegate<OnClientAuthComplete> __OnClientAuthComplete__Delegate;
//var delegate<OnServerAuthComplete> __OnServerAuthComplete__Delegate;
//var delegate<OnClientAuthEndSessionRequest> __OnClientAuthEndSessionRequest__Delegate;
//var delegate<OnServerAuthRetryRequest> __OnServerAuthRetryRequest__Delegate;
//var delegate<OnClientConnectionClose> __OnClientConnectionClose__Delegate;
//var delegate<OnServerConnectionClose> __OnServerConnectionClose__Delegate;

function bool IsReady()
{
	return bAuthReady;
	//return ReturnValue;	
}

delegate OnAuthReady()
{
	//return;	
}

function AddAuthReadyDelegate(delegate<OnAuthReady> AuthReadyDelegate)
{
	// End:0x3E
	if(AuthReadyDelegates.Find(AuthReadyDelegate) == -1)
	{
		AuthReadyDelegates[AuthReadyDelegates.Length] = AuthReadyDelegate;
	}
	//return;	
}

function ClearAuthReadyDelegate(delegate<OnAuthReady> AuthReadyDelegate)
{
	local int I;

	I = AuthReadyDelegates.Find(AuthReadyDelegate);
	// End:0x48
	if(I != -1)
	{
		AuthReadyDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnClientAuthRequest(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure)
{
	//return;	
}

function AddClientAuthRequestDelegate(delegate<OnClientAuthRequest> ClientAuthRequestDelegate)
{
	// End:0x3E
	if(ClientAuthRequestDelegates.Find(ClientAuthRequestDelegate) == -1)
	{
		ClientAuthRequestDelegates[ClientAuthRequestDelegates.Length] = ClientAuthRequestDelegate;
	}
	//return;	
}

function ClearClientAuthRequestDelegate(delegate<OnClientAuthRequest> ClientAuthRequestDelegate)
{
	local int I;

	I = ClientAuthRequestDelegates.Find(ClientAuthRequestDelegate);
	// End:0x48
	if(I != -1)
	{
		ClientAuthRequestDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnServerAuthRequest(Player ClientConnection, UniqueNetId ClientUID, int ClientIP, int ClientPort)
{
	//return;	
}

function AddServerAuthRequestDelegate(delegate<OnServerAuthRequest> ServerAuthRequestDelegate)
{
	// End:0x3E
	if(ServerAuthRequestDelegates.Find(ServerAuthRequestDelegate) == -1)
	{
		ServerAuthRequestDelegates[ServerAuthRequestDelegates.Length] = ServerAuthRequestDelegate;
	}
	//return;	
}

function ClearServerAuthRequestDelegate(delegate<OnServerAuthRequest> ServerAuthRequestDelegate)
{
	local int I;

	I = ServerAuthRequestDelegates.Find(ServerAuthRequestDelegate);
	// End:0x48
	if(I != -1)
	{
		ServerAuthRequestDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnClientAuthResponse(UniqueNetId ClientUID, int ClientIP, int AuthTicketUID)
{
	//return;	
}

function AddClientAuthResponseDelegate(delegate<OnClientAuthResponse> ClientAuthResponseDelegate)
{
	// End:0x3E
	if(ClientAuthResponseDelegates.Find(ClientAuthResponseDelegate) == -1)
	{
		ClientAuthResponseDelegates[ClientAuthResponseDelegates.Length] = ClientAuthResponseDelegate;
	}
	//return;	
}

function ClearClientAuthResponseDelegate(delegate<OnClientAuthResponse> ClientAuthResponseDelegate)
{
	local int I;

	I = ClientAuthResponseDelegates.Find(ClientAuthResponseDelegate);
	// End:0x48
	if(I != -1)
	{
		ClientAuthResponseDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnServerAuthResponse(UniqueNetId ServerUID, int ServerIP, int AuthTicketUID)
{
	//return;	
}

function AddServerAuthResponseDelegate(delegate<OnServerAuthResponse> ServerAuthResponseDelegate)
{
	// End:0x3E
	if(ServerAuthResponseDelegates.Find(ServerAuthResponseDelegate) == -1)
	{
		ServerAuthResponseDelegates[ServerAuthResponseDelegates.Length] = ServerAuthResponseDelegate;
	}
	//return;	
}

function ClearServerAuthResponseDelegate(delegate<OnServerAuthResponse> ServerAuthResponseDelegate)
{
	local int I;

	I = ServerAuthResponseDelegates.Find(ServerAuthResponseDelegate);
	// End:0x48
	if(I != -1)
	{
		ServerAuthResponseDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnClientAuthComplete(bool bSuccess, UniqueNetId ClientUID, Player ClientConnection, string ExtraInfo)
{
	//return;	
}

function AddClientAuthCompleteDelegate(delegate<OnClientAuthComplete> ClientAuthCompleteDelegate)
{
	// End:0x3E
	if(ClientAuthCompleteDelegates.Find(ClientAuthCompleteDelegate) == -1)
	{
		ClientAuthCompleteDelegates[ClientAuthCompleteDelegates.Length] = ClientAuthCompleteDelegate;
	}
	//return;	
}

function ClearClientAuthCompleteDelegate(delegate<OnClientAuthComplete> ClientAuthCompleteDelegate)
{
	local int I;

	I = ClientAuthCompleteDelegates.Find(ClientAuthCompleteDelegate);
	// End:0x48
	if(I != -1)
	{
		ClientAuthCompleteDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnServerAuthComplete(bool bSuccess, UniqueNetId ServerUID, Player ServerConnection, string ExtraInfo)
{
	//return;	
}

function AddServerAuthCompleteDelegate(delegate<OnServerAuthComplete> ServerAuthCompleteDelegate)
{
	// End:0x3E
	if(ServerAuthCompleteDelegates.Find(ServerAuthCompleteDelegate) == -1)
	{
		ServerAuthCompleteDelegates[ServerAuthCompleteDelegates.Length] = ServerAuthCompleteDelegate;
	}
	//return;	
}

function ClearServerAuthCompleteDelegate(delegate<OnServerAuthComplete> ServerAuthCompleteDelegate)
{
	local int I;

	I = ServerAuthCompleteDelegates.Find(ServerAuthCompleteDelegate);
	// End:0x48
	if(I != -1)
	{
		ServerAuthCompleteDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnClientAuthEndSessionRequest(Player ServerConnection)
{
	//return;	
}

function AddClientAuthEndSessionRequestDelegate(delegate<OnClientAuthEndSessionRequest> ClientAuthEndSessionRequestDelegate)
{
	// End:0x3E
	if(ClientAuthEndSessionRequestDelegates.Find(ClientAuthEndSessionRequestDelegate) == -1)
	{
		ClientAuthEndSessionRequestDelegates[ClientAuthEndSessionRequestDelegates.Length] = ClientAuthEndSessionRequestDelegate;
	}
	//return;	
}

function ClearClientAuthEndSessionRequestDelegate(delegate<OnClientAuthEndSessionRequest> ClientAuthEndSessionRequestDelegate)
{
	local int I;

	I = ClientAuthEndSessionRequestDelegates.Find(ClientAuthEndSessionRequestDelegate);
	// End:0x48
	if(I != -1)
	{
		ClientAuthEndSessionRequestDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnServerAuthRetryRequest(Player ClientConnection)
{
	//return;	
}

function AddServerAuthRetryRequestDelegate(delegate<OnServerAuthRetryRequest> ServerAuthRetryRequestDelegate)
{
	// End:0x3E
	if(ServerAuthRetryRequestDelegates.Find(ServerAuthRetryRequestDelegate) == -1)
	{
		ServerAuthRetryRequestDelegates[ServerAuthRetryRequestDelegates.Length] = ServerAuthRetryRequestDelegate;
	}
	//return;	
}

function ClearServerAuthRetryRequestDelegate(delegate<OnServerAuthRetryRequest> ServerAuthRetryRequestDelegate)
{
	local int I;

	I = ServerAuthRetryRequestDelegates.Find(ServerAuthRetryRequestDelegate);
	// End:0x48
	if(I != -1)
	{
		ServerAuthRetryRequestDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnClientConnectionClose(Player ClientConnection)
{
	//return;	
}

function AddClientConnectionCloseDelegate(delegate<OnClientConnectionClose> ClientConnectionCloseDelegate)
{
	// End:0x3E
	if(ClientConnectionCloseDelegates.Find(ClientConnectionCloseDelegate) == -1)
	{
		ClientConnectionCloseDelegates[ClientConnectionCloseDelegates.Length] = ClientConnectionCloseDelegate;
	}
	//return;	
}

function ClearClientConnectionCloseDelegate(delegate<OnClientConnectionClose> ClientConnectionCloseDelegate)
{
	local int I;

	I = ClientConnectionCloseDelegates.Find(ClientConnectionCloseDelegate);
	// End:0x48
	if(I != -1)
	{
		ClientConnectionCloseDelegates.Remove(I, 1);
	}
	//return;	
}

delegate OnServerConnectionClose(Player ServerConnection)
{
	//return;	
}

function AddServerConnectionCloseDelegate(delegate<OnServerConnectionClose> ServerConnectionCloseDelegate)
{
	// End:0x3E
	if(ServerConnectionCloseDelegates.Find(ServerConnectionCloseDelegate) == -1)
	{
		ServerConnectionCloseDelegates[ServerConnectionCloseDelegates.Length] = ServerConnectionCloseDelegate;
	}
	//return;	
}

function ClearServerConnectionCloseDelegate(delegate<OnServerConnectionClose> ServerConnectionCloseDelegate)
{
	local int I;

	I = ServerConnectionCloseDelegates.Find(ServerConnectionCloseDelegate);
	// End:0x48
	if(I != -1)
	{
		ServerConnectionCloseDelegates.Remove(I, 1);
	}
	//return;	
}

function bool SendClientAuthRequest(Player ClientConnection, UniqueNetId ClientUID)
{
	//return ReturnValue;	
}

function bool SendServerAuthRequest(UniqueNetId ServerUID)
{
	//return ReturnValue;	
}

// Export UOnlineAuthInterfaceImpl::execSendClientAuthResponse(FFrame&, void* const)
native function bool SendClientAuthResponse(int AuthTicketUID);

// Export UOnlineAuthInterfaceImpl::execSendServerAuthResponse(FFrame&, void* const)
native function bool SendServerAuthResponse(Player ClientConnection, int AuthTicketUID);

// Export UOnlineAuthInterfaceImpl::execSendClientAuthEndSessionRequest(FFrame&, void* const)
native function bool SendClientAuthEndSessionRequest(Player ClientConnection);

// Export UOnlineAuthInterfaceImpl::execSendServerAuthRetryRequest(FFrame&, void* const)
native function bool SendServerAuthRetryRequest();

function bool CreateClientAuthSession(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure, out int OutAuthTicketUID)
{
	//return ReturnValue;	
}

function bool VerifyClientAuthSession(UniqueNetId ClientUID, int ClientIP, int ClientPort, int AuthTicketUID)
{
	//return ReturnValue;	
}

// Export UOnlineAuthInterfaceImpl::execEndLocalClientAuthSession(FFrame&, void* const)
native final function EndLocalClientAuthSession(UniqueNetId ServerUID, int ServerIP, int ServerPort);

// Export UOnlineAuthInterfaceImpl::execEndRemoteClientAuthSession(FFrame&, void* const)
native final function EndRemoteClientAuthSession(UniqueNetId ClientUID, int ClientIP);

// Export UOnlineAuthInterfaceImpl::execEndAllLocalClientAuthSessions(FFrame&, void* const)
native function EndAllLocalClientAuthSessions();

// Export UOnlineAuthInterfaceImpl::execEndAllRemoteClientAuthSessions(FFrame&, void* const)
native function EndAllRemoteClientAuthSessions();

function bool CreateServerAuthSession(UniqueNetId ClientUID, int ClientIP, int ClientPort, out int OutAuthTicketUID)
{
	//return ReturnValue;	
}

function bool VerifyServerAuthSession(UniqueNetId ServerUID, int ServerIP, int AuthTicketUID)
{
	//return ReturnValue;	
}

// Export UOnlineAuthInterfaceImpl::execEndLocalServerAuthSession(FFrame&, void* const)
native final function EndLocalServerAuthSession(UniqueNetId ClientUID, int ClientIP);

// Export UOnlineAuthInterfaceImpl::execEndRemoteServerAuthSession(FFrame&, void* const)
native final function EndRemoteServerAuthSession(UniqueNetId ServerUID, int ServerIP);

// Export UOnlineAuthInterfaceImpl::execEndAllLocalServerAuthSessions(FFrame&, void* const)
native function EndAllLocalServerAuthSessions();

// Export UOnlineAuthInterfaceImpl::execEndAllRemoteServerAuthSessions(FFrame&, void* const)
native function EndAllRemoteServerAuthSessions();

// Export UOnlineAuthInterfaceImpl::execAllClientAuthSessions(FFrame&, void* const)
native iterator function AllClientAuthSessions(out AuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execAllLocalClientAuthSessions(FFrame&, void* const)
native iterator function AllLocalClientAuthSessions(out LocalAuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execAllServerAuthSessions(FFrame&, void* const)
native iterator function AllServerAuthSessions(out AuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execAllLocalServerAuthSessions(FFrame&, void* const)
native iterator function AllLocalServerAuthSessions(out LocalAuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execFindClientAuthSession(FFrame&, void* const)
native function bool FindClientAuthSession(Player ClientConnection, out AuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execFindLocalClientAuthSession(FFrame&, void* const)
native function bool FindLocalClientAuthSession(Player ServerConnection, out LocalAuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execFindServerAuthSession(FFrame&, void* const)
native function bool FindServerAuthSession(Player ServerConnection, out AuthSession OutSessionInfo);

// Export UOnlineAuthInterfaceImpl::execFindLocalServerAuthSession(FFrame&, void* const)
native function bool FindLocalServerAuthSession(Player ClientConnection, out LocalAuthSession OutSessionInfo);

function bool GetServerUniqueId(out UniqueNetId OutServerUID)
{
	//return ReturnValue;	
}

function bool GetServerAddr(out int OutServerIP, out int OutServerPort)
{
	//return ReturnValue;	
}
