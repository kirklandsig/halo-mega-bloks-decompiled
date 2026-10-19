class HaloProjectile_PistolBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=TargetSearchMode_Trace
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="COV_PlasmaPistol"
	ProjFlightTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.WP_COV_PISTOL_PRT'
	ProjExplosionTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.WP_COV_PLASMAPISTOL_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'MegaHaloGame.HaloProjectile_PistolBulletLight'
	CheckRadius=40.0000000
	Speed=4000.0000000
	MaxSpeed=4200.0000000
	Damage=25.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_PistolBullet'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_PistolBullet.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=2500.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=3.0000000
	CollisionComponent=CollisionCylinder
}