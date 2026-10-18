class HaloProjectile_StormRifleBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=ETargetSearchMode.TargetSearchMode_Trace
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="COV_PlasmaRifle"
	ProjFlightTemplate=ParticleSystem'WP_COV_STORM.Effects.WP_COV_STORM_Tracer'
	ProjExplosionTemplate=ParticleSystem'WP_COV_STORM.Effects.WP_COV_STORM_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Speed=4000.0000000
	MaxSpeed=4200.0000000
	Damage=20.0000000
	DamageRadius=1.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_StormRifle'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_StormRifleBullet.CollisionCylinder'
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