class EnvironmentVolume extends Volume
	native
	placeable
	implements(Interface_NavMeshPathObstacle,Interface_NavMeshPathObject);

var private native const noexport Pointer VfTable_IInterface_NavMeshPathObstacle;
var private native const noexport Pointer VfTable_IInterface_NavMeshPathObject;
var const transient bool bSplitNavMesh;

// Export UEnvironmentVolume::execSetSplitNavMesh(FFrame&, void* const)
native final function SetSplitNavMesh(bool bNewValue);

defaultproperties
{
	// Reference: BrushComponent'Engine.Default__EnvironmentVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__Volume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	CollisionComponent=BrushComponent0
}