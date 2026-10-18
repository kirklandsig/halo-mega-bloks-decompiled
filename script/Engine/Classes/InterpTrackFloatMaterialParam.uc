class InterpTrackFloatMaterialParam extends InterpTrackFloatBase
	native
	collapsecategories;

var const array<MaterialReferenceList> Materials;
var const deprecated MaterialInterface Material;
var name ParamName;
var bool bShouldCreateMaterialInstances;
var transient bool bNeedsMaterialRefsUpdate;

defaultproperties
{
	TrackInstClass=Class'Engine.InterpTrackInstFloatMaterialParam'
	TrackTitle="Float Material Param"
}