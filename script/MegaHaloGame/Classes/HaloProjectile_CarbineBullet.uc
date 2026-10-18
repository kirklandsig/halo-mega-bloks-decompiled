class HaloProjectile_CarbineBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=ETargetSearchMode.TargetSearchMode_Cone
	TargetSearchRange=4000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=20000.0000000
	akWeaponType="COV_Carbine"
	ProjFlightTemplate=ParticleSystem'WP_COV_CARBINE.Effects.WP_COV_CARBINE_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_COV_CARBINE.Effects.WP_COV_CARBINE_HIT'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Speed=5000.0000000
	MaxSpeed=5000.0000000
	Damage=55.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_CarbineBullet'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_CarbineBullet.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=3500.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=1.2500000
	CollisionComponent=CollisionCylinder
}