class HaloProjectile_ChargedPistolBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=TargetSearchMode_Cone
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="COV_PlasmaPistol"
	ProjFlightTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.WP_COV_PISTOLCHRG_PRT'
	ProjExplosionTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.WP_COV_PLASMAPISTOLCHRG_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'MegaHaloGame.HaloProjectile_ChargedPistolBulletLight'
	bCheckProjectileLight=true
	CheckRadius=40.0000000
	Speed=4000.0000000
	MaxSpeed=4000.0000000
	Damage=100.0000000
	DamageRadius=400.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_ChargedPistolBullet'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_ChargedPistolBullet.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=2000.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=3.0000000
	CollisionComponent=CollisionCylinder
}