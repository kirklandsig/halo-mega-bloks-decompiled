class HaloProjectile_FuelRodCannonBall extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=ETargetSearchMode.TargetSearchMode_Trace
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="COV_FuelRod"
	ProjFlightTemplate=ParticleSystem'WP_COV_HUNTER.Effects.WP_COV_HUNTER_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_COV_HUNTER.Effects.WP_COV_HUNTER_HIT'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Damage=50.0000000
	DamageRadius=450.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_FuelRodCannonBall'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_FuelRodCannonBall.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=1.0000000
		CollisionRadius=100.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=2000.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=2.0000000
	CollisionComponent=CollisionCylinder
}