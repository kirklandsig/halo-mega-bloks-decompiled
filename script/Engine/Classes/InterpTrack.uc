class InterpTrack extends Object
	abstract
	native
	collapsecategories
	noexport;

enum ETrackActiveCondition
{
	ETAC_Always,                    // 0
	ETAC_GoreEnabled,               // 1
	ETAC_GoreDisabled,              // 2
	ETAC_MAX                        // 3
};

struct native SupportedSubTrackInfo
{
	var Class<InterpTrack> SupportedClass;
	var string SubTrackName;
	var int GroupIndex;

	structdefaultproperties
	{
		SupportedClass=none
		SubTrackName=""
		GroupIndex=0
	}
};

struct native SubTrackGroup
{
	var string GroupName;
	var array<int> TrackIndices;
	var bool bIsCollapsed;
	var transient bool bIsSelected;

	structdefaultproperties
	{
		GroupName=""
		TrackIndices=none
		bIsCollapsed=false
		bIsSelected=false
	}
};

var private native const noexport Pointer VfTable_FInterpEdInputInterface;
var private native noexport Pointer CurveEdVTable;
var array<InterpTrack> SubTracks;
var Class<InterpTrackInst> TrackInstClass;
var InterpTrack.ETrackActiveCondition ActiveCondition;
var string TrackTitle;
var bool bOnePerGroup;
var bool bDirGroupOnly;
var bool bDisableTrack;
var bool bIsAnimControlTrack;
var bool bSubTrackOnly;
var transient bool bVisible;
var transient bool bIsSelected;
var transient bool bIsRecording;
var bool bIsCollapsed;

defaultproperties
{
	TrackInstClass=Class'Engine.InterpTrackInst'
	TrackTitle="Track"
	bVisible=true
}