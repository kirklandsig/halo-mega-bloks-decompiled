class HaloProjectile_AssaultRifleBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=ETargetSearchMode.TargetSearchMode_Trace
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="UNSC_AssaultRifle"
	ProjFlightTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_ASSAULT_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Speed=6000.0000000
	MaxSpeed=6000.0000000
	Damage=15.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_AssaultRifle'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_AssaultRifleBullet.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=6000.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=1.6700000
	CollisionComponent=CollisionCylinder
}