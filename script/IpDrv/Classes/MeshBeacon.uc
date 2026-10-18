class MeshBeacon extends Object
	native
	config(Engine);

enum EMeshBeaconPacketType
{
	MB_Packet_UnknownType,          // 0
	MB_Packet_ClientNewConnectionRequest,// 1
	MB_Packet_ClientBeginBandwidthTest,// 2
	MB_Packet_ClientCreateNewSessionResponse,// 3
	MB_Packet_HostNewConnectionResponse,// 4
	MB_Packet_HostBandwidthTestRequest,// 5
	MB_Packet_HostCompletedBandwidthTest,// 6
	MB_Packet_HostTravelRequest,    // 7
	MB_Packet_HostCreateNewSessionRequest,// 8
	MB_Packet_DummyData,            // 9
	MB_Packet_Heartbeat,            // 10
	MB_Packet_MAX                   // 11
};

enum EMeshBeaconConnectionResult
{
	MB_ConnectionResult_Succeeded,  // 0
	MB_ConnectionResult_Duplicate,  // 1
	MB_ConnectionResult_Timeout,    // 2
	MB_ConnectionResult_Error,      // 3
	MB_ConnectionResult_MAX         // 4
};

enum EMeshBeaconBandwidthTestState
{
	MB_BandwidthTestState_NotStarted,// 0
	MB_BandwidthTestState_RequestPending,// 1
	MB_BandwidthTestState_StartPending,// 2
	MB_BandwidthTestState_InProgress,// 3
	MB_BandwidthTestState_Completed,// 4
	MB_BandwidthTestState_Incomplete,// 5
	MB_BandwidthTestState_Timeout,  // 6
	MB_BandwidthTestState_Error,    // 7
	MB_BandwidthTestState_MAX       // 8
};

enum EMeshBeaconBandwidthTestResult
{
	MB_BandwidthTestResult_Succeeded,// 0
	MB_BandwidthTestResult_Timeout, // 1
	MB_BandwidthTestResult_Error,   // 2
	MB_BandwidthTestResult_MAX      // 3
};

enum EMeshBeaconBandwidthTestType
{
	MB_BandwidthTestType_Upstream,  // 0
	MB_BandwidthTestType_Downstream,// 1
	MB_BandwidthTestType_RoundtripLatency,// 2
	MB_BandwidthTestType_MAX        // 3
};

struct native ConnectionBandwidthStats
{
	var int UpstreamRate;
	var int DownstreamRate;
	var int RoundtripLatency;

	structdefaultproperties
	{
		UpstreamRate=0
		DownstreamRate=0
		RoundtripLatency=0
	}
};

struct native PlayerMember
{
	var int TeamNum;
	var int Skill;
	var UniqueNetId NetId;

	structdefaultproperties
	{
		TeamNum=0
		Skill=0
		NetId=(Uid=())
	}
};

var private native const noexport Pointer VfTable_FTickableObject;
var config int MeshBeaconPort;
var native transient Pointer Socket;
var transient bool bIsInTick;
var transient bool bWantsDeferredDestroy;
var bool bShouldTick;
var config float HeartbeatTimeout;
var float ElapsedHeartbeatTime;
var name BeaconName;
var config int SocketSendBufferSize;
var config int SocketReceiveBufferSize;
var config int MaxBandwidthTestBufferSize;
var config int MinBandwidthTestBufferSize;
var config float MaxBandwidthTestSendTime;
var config float MaxBandwidthTestReceiveTime;
var config int MaxBandwidthHistoryEntries;

// Export UMeshBeacon::execDestroyBeacon(FFrame&, void* const)
native event DestroyBeacon();

defaultproperties
{
	bShouldTick=true
}