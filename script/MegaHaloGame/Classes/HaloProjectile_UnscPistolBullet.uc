class HaloProjectile_UnscPistolBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=TargetSearchMode_Trace
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="UNSC_Pistol"
	ProjFlightTemplate=ParticleSystem'WP_UNSC_M6D_Pistol.Effects.WP_M6D_Pistol_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_UNSC_M6D_Pistol.Effects.WP_M6D_Pistol_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Speed=5500.0000000
	MaxSpeed=6000.0000000
	Damage=15.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_UnscPistolBullet'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_UnscPistolBullet.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=5500.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=2.0000000
	CollisionComponent=CollisionCylinder
}