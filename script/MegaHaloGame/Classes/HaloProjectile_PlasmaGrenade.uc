class HaloProjectile_PlasmaGrenade extends HaloProjectile_Grenade;

defaultproperties
{
	ExplodeFromTouchDelay=1.5000000
	ExplodeFromLateTouchDelay=2.0000000
	ExplodeFromStickyTouchDelay=1.0000000
	bSticksToPawns=true
	AkExplosionType="Explosion_Plasma"
	akWeaponType="COV_Grenade"
	AkObjectType="COV_Grenade"
	ProjFlightTemplate=ParticleSystem'WP_COV_GRENADE.Effects.WP_COV_GRENADE_TRAIL'
	ProjExplosionTemplate=ParticleSystem'WP_COV_GRENADE.Effects.WP_COV_GRENADE_XPLD'
	MyDamageType=Class'MegaHaloGame.HaloDamageType_PlasmaGrenade'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_PlasmaGrenade.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile_Grenade.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}