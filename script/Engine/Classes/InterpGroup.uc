class InterpGroup extends Object
	native
	collapsecategories;

struct InterpEdSelKey
{
	var InterpGroup Group;
	var InterpTrack Track;
	var int KeyIndex;
	var float UnsnappedPosition;

	structdefaultproperties
	{
		Group=none
		Track=none
		KeyIndex=0
		UnsnappedPosition=0.0000000
	}
};

var private native const noexport Pointer VfTable_FInterpEdInputInterface;
var export array<export InterpTrack> InterpTracks;
var name GroupName;
var Color GroupColor;
var array<AnimSet> GroupAnimSets;
var bool bCollapsed;
var transient bool bVisible;
var bool bIsFolder;
var bool bIsParented;
var transient bool bIsSelected;

defaultproperties
{
	GroupName="InterpGroup"
	GroupColor=(R=80,G=100,B=255,A=200)
	bVisible=true
}