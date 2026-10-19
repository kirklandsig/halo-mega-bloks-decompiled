class GwNavNavdata extends Actor
	native
	collapsecategories
	placeable;

struct native LocalNavdata
{
	var GwNavNavdataFamily Family;
	var init array<init byte> NavDataAggregate;

	structdefaultproperties
	{
		Family=none
		NavDataAggregate=none
	}
};

var editinlineuse array<editinlineuse LocalNavdata> LocalData;
var native transient Pointer NavDataList;
var editinlineuse array<editinlineuse string> MergedLevelNamesForGeneration;

defaultproperties
{
	LocalData[0]=(Family=GwNavNavdataFamily'EngineGwNav.DefaultFamily',NavDataAggregate=none)
	Components[0]=none
	Components[1]=none
	CollisionType=COLLIDE_CustomDefault
	bMovable=false
	bNoEncroachCheck=true
}