class HaloProjectile_UnscRocket_Content extends HaloProjectile_UnscRocket;

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'WP_UNSC_ROCKETLAUNCHER.Effects.WP_UNSC_ROCKTLAUCH_One_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_UNSC_ROCKETLAUNCHER.Effects.WP_UNSC_ROCKTLAUNCH_XPLD'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_UnscRocket_Content.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile_UnscRocket.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}