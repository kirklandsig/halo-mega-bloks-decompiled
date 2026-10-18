class GwNavTagVolume extends GwNavVolume
	native;

var Material Material;
var int NavTagValue;

defaultproperties
{
	NavTagValue=-1
	BrushColor=(R=135,G=255,B=255,A=85)
	bColored=true
	// Reference: BrushComponent'GwNavEngine.Default__GwNavTagVolume.BrushComponent0'
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