class PartyBeacon extends Object
	native
	config(Engine);

enum EReservationPacketType
{
	RPT_UnknownPacketType,          // 0
	RPT_ClientReservationRequest,   // 1
	RPT_ClientReservationUpdateRequest,// 2
	RPT_ClientCancellationRequest,  // 3
	RPT_HostReservationResponse,    // 4
	RPT_HostReservationCountUpdate, // 5
	RPT_HostTravelRequest,          // 6
	RPT_HostIsReady,                // 7
	RPT_HostHasCancelled,           // 8
	RPT_Heartbeat,                  // 9
	RPT_MAX                         // 10
};

enum EPartyReservationResult
{
	PRR_GeneralError,               // 0
	PRR_PartyLimitReached,          // 1
	PRR_IncorrectPlayerCount,       // 2
	PRR_RequestTimedOut,            // 3
	PRR_ReservationDuplicate,       // 4
	PRR_ReservationNotFound,        // 5
	PRR_ReservationAccepted,        // 6
	PRR_ReservationDenied,          // 7
	PRR_MAX                         // 8
};

struct native PlayerReservation
{
	var UniqueNetId NetId;
	var int Skill;
	var int XpLevel;
	var Double Mu;
	var Double Sigma;
	var float ElapsedSessionTime;

	structdefaultproperties
	{
		NetId=(Uid=())
		Skill=0
		XpLevel=0
		Mu=()
		Sigma=()
		ElapsedSessionTime=0.0000000
	}
};

struct native PartyReservation
{
	var int TeamNum;
	var UniqueNetId PartyLeader;
	var array<PlayerReservation> PartyMembers;

	structdefaultproperties
	{
		TeamNum=0
		PartyLeader=(Uid=())
		PartyMembers=none
	}
};

var private native const noexport Pointer VfTable_FTickableObject;
var config int PartyBeaconPort;
var native transient Pointer Socket;
var bool bIsInTick;
var bool bWantsDeferredDestroy;
var bool bShouldTick;
var config float HeartbeatTimeout;
var float ElapsedHeartbeatTime;
var name BeaconName;
//var delegate<OnDestroyComplete> __OnDestroyComplete__Delegate;

// Export UPartyBeacon::execDestroyBeacon(FFrame&, void* const)
native event DestroyBeacon();

delegate OnDestroyComplete()
{
	//return;	
}

defaultproperties
{
	bShouldTick=true
}