class GwNavExplorationVolume extends GwNavVolume
	native;

var editinlineuse array<editinlineuse GwNavNavdataFamily> NavdataFamilies;

defaultproperties
{
	NavdataFamilies[0]=GwNavNavdataFamily'EngineGwNav.DefaultFamily'
	BrushColor=(R=255,G=150,B=255,A=200)
	bColored=true
	// Reference: BrushComponent'GwNavEngine.Default__GwNavExplorationVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'GwNavEngine.Default__GwNavVolume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	CollisionComponent=BrushComponent0
}