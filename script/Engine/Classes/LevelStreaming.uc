class LevelStreaming extends Object
	abstract
	native
	editinlinenew;

var const editconst name PackageName;
var const transient Level LoadedLevel;
var const Vector Offset;
var const Matrix LevelTransform;
var const Vector OldOffset;
var const transient Box ApproximateBoundsBox;
var const transient bool bIsVisible;
var const transient bool bHasLoadRequestPending;
var const transient bool bHasUnloadRequestPending;
var editoronly const bool bShouldBeVisibleInEditor;
var const bool bBoundingBoxVisible;
var const bool bLocked;
var const bool bIsFullyStatic;
var const transient bool bShouldBeLoaded;
var const transient bool bShouldBeVisible;
var transient bool bShouldBlockOnLoad;
var bool bDrawOnLevelStatusMap;
var const transient bool bIsRequestingUnloadAndRemoval;
var const Color DrawColor;
var const editconst array<editconst LevelStreamingVolume> EditorStreamingVolumes;
var float MinTimeBetweenVolumeUnloadRequests;
var const transient float LastVolumeUnloadRequestTime;
var const editconst LevelGridVolume EditorGridVolume;
var const editconst int GridPosition[3];

// Export ULevelStreaming::execGetLevelBounds(FFrame&, void* const)
native function Box GetLevelBounds();

defaultproperties
{
	bDrawOnLevelStatusMap=true
	DrawColor=(R=255,G=255,B=255,A=255)
	MinTimeBetweenVolumeUnloadRequests=2.0000000
}