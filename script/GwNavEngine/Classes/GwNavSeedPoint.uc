class GwNavSeedPoint extends Actor
	native
	placeable;

var editinlineuse array<editinlineuse GwNavNavdataFamily> NavdataFamilies;

defaultproperties
{
	NavdataFamilies[0]=GwNavNavdataFamily'EngineGwNav.DefaultFamily'
	Components[0]=none
	CollisionType=COLLIDE_CustomDefault
}