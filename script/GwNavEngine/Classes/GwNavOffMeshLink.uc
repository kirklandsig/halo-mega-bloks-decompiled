class GwNavOffMeshLink extends Actor
	native
	placeable;

var editinlineuse array<editinlineuse GwNavNavdataFamily> NavdataFamilies;
var Actor Start;
var Actor End;
var bool IsBidirectional;
var native transient Pointer GraphDataList;
var native transient Pointer SmartObject;

defaultproperties
{
	NavdataFamilies[0]=GwNavNavdataFamily'EngineGwNav.DefaultFamily'
	IsBidirectional=true
	Components[0]=none
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}