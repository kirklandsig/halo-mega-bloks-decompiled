class LocalPlayer extends Player within Engine
	transient
	native
	config(Engine);

struct SynchronizedActorVisibilityHistory
{
	var Pointer State;
	var Pointer CriticalSection;

	structdefaultproperties
	{
		State=()
		CriticalSection=()
	}
};

struct native CurrentPostProcessVolumeInfo
{
	var PostProcessSettings LastSettings;
	var PostProcessVolume LastVolumeUsed;
	var float BlendStartTime;
	var float LastBlendTime;

	structdefaultproperties
	{
		LastSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
		LastVolumeUsed=none
		BlendStartTime=0.0000000
		LastBlendTime=0.0000000
	}
};

struct native PostProcessSettingsOverride
{
	var PostProcessSettings Settings;
	var bool bBlendingIn;
	var bool bBlendingOut;
	var float CurrentBlendInTime;
	var float CurrentBlendOutTime;
	var float BlendInDuration;
	var float BlendOutDuration;
	var float BlendStartTime;
	var InterpCurveFloat TimeAlphaCurve;

	structdefaultproperties
	{
		Settings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
		bBlendingIn=false
		bBlendingOut=false
		CurrentBlendInTime=0.0000000
		CurrentBlendOutTime=0.0000000
		BlendInDuration=0.0000000
		BlendOutDuration=0.0000000
		BlendStartTime=0.0000000
		TimeAlphaCurve=(Points=none,InterpMethod=EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents)
	}
};

var private native const noexport Pointer VfTable_FObserverInterface;
var int ControllerId;
var GameViewportClient ViewportClient;
var Vector2D Origin;
var Vector2D Size;
var const transient PostProcessChain PlayerPostProcess;
var const transient array<PostProcessChain> PlayerPostProcessChains;
var transient bool bForceDefaultPostProcessChain;
var bool bWantToResetToMapDefaultPP;
var const editconst transient bool bSentSplitJoin;
var bool bPendingServerAuth;
var private native const Pointer ViewState;
var private native const Pointer ViewState2;
var private native const transient SynchronizedActorVisibilityHistory ActorVisibilityHistory;
var transient Vector LastViewLocation;
var noimport const transient CurrentPostProcessVolumeInfo CurrentPPInfo;
var noimport const transient CurrentPostProcessVolumeInfo LevelPPInfo;
var protected transient array<PostProcessSettingsOverride> ActivePPOverrides;
var config Object.EAspectRatioAxisConstraint AspectRatioAxisConstraint;
var string LastMap;
var TranslationContext TagContext;
var OnlineAuthInterface CachedAuthInt;
var float ServerAuthTimestamp;
var int ServerAuthTimeout;
var int ServerAuthRetryCount;
var int MaxServerAuthRetryCount;
var UniqueNetId ServerAuthUID;

// Export ULocalPlayer::execSpawnPlayActor(FFrame&, void* const)
native final function bool SpawnPlayActor(string URL, out string OutError);

// Export ULocalPlayer::execSendSplitJoin(FFrame&, void* const)
native final function SendSplitJoin();

// Export ULocalPlayer::execGetActorVisibility(FFrame&, void* const)
native final function bool GetActorVisibility(Actor TestActor);

// Export ULocalPlayer::execOverridePostProcessSettings(FFrame&, void* const)
native simulated function OverridePostProcessSettings(PostProcessSettings OverrideSettings, optional float BlendInTime);

// Export ULocalPlayer::execOverridePostProcessSettingsCurve(FFrame&, void* const)
native simulated function OverridePostProcessSettingsCurve(PostProcessSettings OverrideSettings, const out InterpCurveFloat Curve);

// Export ULocalPlayer::execClearPostProcessSettingsOverride(FFrame&, void* const)
native simulated function ClearPostProcessSettingsOverride(optional float BlendOutTime);

final function SetControllerId(int NewControllerId)
{
	local LocalPlayer OtherPlayer;
	local int CurrentControllerId;

	// End:0x165
	if(ControllerId != NewControllerId)
	{
		LogInternal((((string(Name) @ "changing ControllerId from") @ string(ControllerId)) @ "to") @ string(NewControllerId), 'PlayerManagement');
		// End:0x99
		if(Actor != none)
		{
			Actor.PreControllerIdChange();
		}
		CurrentControllerId = ControllerId;
		ControllerId = -1;
		OtherPlayer = ViewportClient.FindPlayerByControllerId(NewControllerId);
		// End:0x124
		if(OtherPlayer != none)
		{
			OtherPlayer.super(LocalPlayer).SetControllerId(CurrentControllerId);
		}
		ControllerId = NewControllerId;
		// End:0x165
		if(Actor != none)
		{
			Actor.PostControllerIdChange();
		}
	}
	//return;	
}

// Export ULocalPlayer::execGetTranslationContext(FFrame&, void* const)
native final function TranslationContext GetTranslationContext();

// Export ULocalPlayer::execInsertPostProcessingChain(FFrame&, void* const)
native function bool InsertPostProcessingChain(PostProcessChain InChain, int InIndex, bool bInClone);

// Export ULocalPlayer::execRemovePostProcessingChain(FFrame&, void* const)
native function bool RemovePostProcessingChain(int InIndex);

// Export ULocalPlayer::execRemoveAllPostProcessingChains(FFrame&, void* const)
native function bool RemoveAllPostProcessingChains();

// Export ULocalPlayer::execGetPostProcessChain(FFrame&, void* const)
native function PostProcessChain GetPostProcessChain(int InIndex);

// Export ULocalPlayer::execTouchPlayerPostProcessChain(FFrame&, void* const)
native function TouchPlayerPostProcessChain();

// Export ULocalPlayer::execDeProject(FFrame&, void* const)
native final function DeProject(Vector2D RelativeScreenPos, out Vector WorldOrigin, out Vector WorldDirection);

// Export ULocalPlayer::execProject(FFrame&, void* const)
native final function Vector2D Project(Vector WorldLoc);

final event UniqueNetId GetUniqueNetId()
{
	local UniqueNetId Result;
	local GameEngine TheEngine;

	TheEngine = GameEngine(Outer);
	// End:0xFB
	if(((TheEngine != none) && TheEngine.OnlineSubsystem != none) && NotEqual_InterfaceInterface(TheEngine.OnlineSubsystem.PlayerInterface, OnlinePlayerInterface(none)))
	{
		TheEngine.OnlineSubsystem.PlayerInterface.GetUniquePlayerId(byte(ControllerId), Result);
	}
	return Result;
	//return ReturnValue;	
}

event string GetNickname()
{
	local GameEngine TheEngine;

	TheEngine = GameEngine(Outer);
	// End:0xF6
	if(((TheEngine != none) && TheEngine.OnlineSubsystem != none) && NotEqual_InterfaceInterface(TheEngine.OnlineSubsystem.PlayerInterface, OnlinePlayerInterface(none)))
	{
		return TheEngine.OnlineSubsystem.PlayerInterface.GetPlayerNickname(byte(ControllerId));		
	}
	else
	{
		return "";
	}
	//return ReturnValue;	
}

event NotifyServerConnectionOpen()
{
	local WorldInfo WI;

	// End:0x1F7
	if(Outer.GamePlayers[0] == self)
	{
		CachedAuthInt = Class'Engine.GameEngine'.static.GetOnlineSubsystem().AuthInterface;
		// End:0x179
		if(NotEqual_InterfaceInterface(CachedAuthInt, OnlineAuthInterface(none)))
		{
			CachedAuthInt.AddClientAuthRequestDelegate(ProcessClientAuthRequest);
			CachedAuthInt.AddServerAuthResponseDelegate(ProcessServerAuthResponse);
			CachedAuthInt.AddServerAuthCompleteDelegate(OnServerAuthComplete);
			CachedAuthInt.AddClientAuthEndSessionRequestDelegate(ProcessClientAuthEndSessionRequest);
			CachedAuthInt.AddServerConnectionCloseDelegate(OnServerConnectionClose);
		}
		bPendingServerAuth = true;
		WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
		// End:0x1E8
		if(WI != none)
		{
			ServerAuthTimestamp = WI.RealTimeSeconds;			
		}
		else
		{
			ServerAuthTimestamp = 10.0000000;
		}
	}
	//return;	
}

function ProcessClientAuthRequest(UniqueNetId ServerUID, int ServerIP, int ServerPort, bool bSecure)
{
	local UniqueNetId NullId;
	local int AuthTicketUID;

	// End:0x156
	if(ServerUID != NullId)
	{
		// End:0xFB
		if(CachedAuthInt.CreateClientAuthSession(ServerUID, ServerIP, ServerPort, bSecure, AuthTicketUID))
		{
			// End:0xF8
			if(!CachedAuthInt.SendClientAuthResponse(AuthTicketUID))
			{
				LogInternal("LocalPlayer::ProcessClientAuthRequest: WARNING!!! Failed to send auth ticket to server");
			}			
		}
		else
		{
			LogInternal("LocalPlayer::ProcessClientAuthRequest: WARNING!!! Failed to create client auth session");
		}
	}
	//return;	
}

function ProcessClientAuthEndSessionRequest(Player ServerConnection)
{
	local LocalAuthSession CurClientSession;
	local AuthSession CurServerSession;

	// End:0xAC
	if(CachedAuthInt.FindLocalClientAuthSession(ServerConnection, CurClientSession))
	{
		CachedAuthInt.EndLocalClientAuthSession(CurClientSession.EndPointUID, CurClientSession.EndPointIP, CurClientSession.EndPointPort);		
	}
	else
	{
		LogInternal("LocalPlayer::ProcessClientAuthEndSessionRequest: Couldn't find local client auth session");
	}
	// End:0x199
	if(CachedAuthInt.FindServerAuthSession(ServerConnection, CurServerSession))
	{
		CachedAuthInt.EndRemoteServerAuthSession(CurServerSession.EndPointUID, CurServerSession.EndPointIP);		
	}
	else
	{
		LogInternal("LocalPlayer::ProcessClientAuthEndSessionRequest: Couldn't find server auth session");
	}
	//return;	
}

function ProcessServerAuthResponse(UniqueNetId ServerUID, int ServerIP, int AuthTicketUID)
{
	local WorldInfo WI;

	// End:0xF2
	if(CachedAuthInt.VerifyServerAuthSession(ServerUID, ServerIP, AuthTicketUID))
	{
		bPendingServerAuth = true;
		ServerAuthUID = ServerUID;
		WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
		// End:0xC0
		if(WI != none)
		{
			ServerAuthTimestamp = WI.RealTimeSeconds;			
		}
		else
		{
			ServerAuthTimestamp = 10.0000000;
		}
		LogInternal("Kicked off game server auth");		
	}
	else
	{
		LogInternal("Failed to kickoff game server auth");
	}
	//return;	
}

function OnServerAuthComplete(bool bSuccess, UniqueNetId ServerUID, Player ServerConnection, string ExtraInfo)
{
	// End:0x34
	if(bSuccess)
	{
		LogInternal("Server auth success");
		bPendingServerAuth = false;		
	}
	else
	{
		ServerAuthTimedOut();
	}
	//return;	
}

event ServerAuthTimedOut()
{
	local WorldInfo WI;
	local AuthSession CurServerSession;

	// End:0x1C1
	if(NotEqual_InterfaceInterface(CachedAuthInt, OnlineAuthInterface(none)))
	{
		// End:0x1B7
		if(ServerAuthRetryCount < MaxServerAuthRetryCount)
		{
			// End:0xF0
			foreach CachedAuthInt.AllServerAuthSessions(CurServerSession)
			{
				// End:0xEF
				if(CurServerSession.EndPointUID == ServerAuthUID)
				{
					CachedAuthInt.EndRemoteServerAuthSession(CurServerSession.EndPointUID, CurServerSession.EndPointIP);
					// End:0xF0
					break;
				}				
			}			
			LogInternal("Sending server auth retry request");
			CachedAuthInt.SendServerAuthRetryRequest();
			ServerAuthRetryCount++;
			WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
			// End:0x1A5
			if(WI != none)
			{
				ServerAuthTimestamp = WI.RealTimeSeconds;				
			}
			else
			{
				ServerAuthTimestamp = 10.0000000;
			}			
		}
		else
		{
			ServerAuthFailure();
		}
	}
	//return;	
}

function ServerAuthFailure()
{
	LogInternal(("Server authentication failed after" @ string(MaxServerAuthRetryCount)) @ "tries");
	//return;	
}

function OnServerConnectionClose(Player ServerConnection)
{
	StaticOnServerConnectionClose(ServerConnection);
	//return;	
}

static final function StaticOnServerConnectionClose(Player ServerConnection)
{
	local OnlineAuthInterface CurAuthInt;
	local LocalAuthSession CurClientSession;
	local AuthSession CurServerSession;

	CurAuthInt = Class'Engine.GameEngine'.static.GetOnlineSubsystem().AuthInterface;
	// End:0x244
	if(NotEqual_InterfaceInterface(CurAuthInt, OnlineAuthInterface(none)))
	{
		// End:0x10A
		if(CurAuthInt.FindLocalClientAuthSession(ServerConnection, CurClientSession))
		{
			CurAuthInt.EndLocalClientAuthSession(CurClientSession.EndPointUID, CurClientSession.EndPointIP, CurClientSession.EndPointPort);			
		}
		else
		{
			LogInternal("LocalPlayer::StaticOnServerConnectionClose: Couldn't find local client auth session");
		}
		// End:0x1F2
		if(CurAuthInt.FindServerAuthSession(ServerConnection, CurServerSession))
		{
			CurAuthInt.EndRemoteServerAuthSession(CurServerSession.EndPointUID, CurServerSession.EndPointIP);			
		}
		else
		{
			LogInternal("LocalPlayer::StaticOnServerConnectionClose: Couldn't find server auth session");
		}
	}
	//return;	
}

event ViewportClosed()
{
	Cleanup(true);
	//return;	
}

event NotifyServerConnectionClose()
{
	Cleanup();
	//return;	
}

event Exit()
{
	Cleanup(true);
	//return;	
}

function Cleanup(optional bool bExit)
{
	// End:0x1A0
	if(Outer.GamePlayers[0] == self)
	{
		// End:0x189
		if(NotEqual_InterfaceInterface(CachedAuthInt, OnlineAuthInterface(none)))
		{
			CachedAuthInt.ClearClientAuthRequestDelegate(ProcessClientAuthRequest);
			CachedAuthInt.ClearServerAuthResponseDelegate(ProcessServerAuthResponse);
			CachedAuthInt.ClearServerAuthCompleteDelegate(OnServerAuthComplete);
			CachedAuthInt.ClearClientAuthEndSessionRequestDelegate(ProcessClientAuthEndSessionRequest);
			CachedAuthInt.ClearServerConnectionCloseDelegate(OnServerConnectionClose);
			// End:0x189
			if(bExit)
			{
				CachedAuthInt.EndAllLocalClientAuthSessions();
				CachedAuthInt.EndAllRemoteServerAuthSessions();
			}
		}
		CachedAuthInt = none;
		bPendingServerAuth = false;
	}
	//return;	
}

defaultproperties
{
	bWantToResetToMapDefaultPP=true
	CurrentPPInfo=(LastSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000)),LastVolumeUsed=none,BlendStartTime=0.0000000,LastBlendTime=0.0000000)
	LevelPPInfo=(LastSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000)),LastVolumeUsed=none,BlendStartTime=0.0000000,LastBlendTime=0.0000000)
	AspectRatioAxisConstraint=EAspectRatioAxisConstraint.AspectRatio_MaintainXFOV
	ServerAuthTimeout=10
	MaxServerAuthRetryCount=3
}