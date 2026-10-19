class PylonSeed extends Actor
	native
	placeable
	implements(Interface_NavMeshPathObject);


defaultproperties
{
	// Reference: CylinderComponent'Engine.Default__PylonSeed.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=50.0000000
		CollisionRadius=50.0000000
		ReplacementPrimitive=none
	end object
	Components[0]=CollisionCylinder
	Components[1]=none
	CollisionType=COLLIDE_CustomDefault
	CollisionComponent=CollisionCylinder
}