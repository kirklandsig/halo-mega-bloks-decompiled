class HaloPlayerSpawnPoint extends PlayerStart;

var name missionName;

defaultproperties
{
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloPlayerSpawnPoint.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__PlayerStart.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=none
	Components[3]=CollisionCylinder
	Components[4]=none
	CollisionComponent=CollisionCylinder
}