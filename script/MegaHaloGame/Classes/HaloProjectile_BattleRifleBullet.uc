class HaloProjectile_BattleRifleBullet extends HaloProjectile;

defaultproperties
{
	TargetSearchMode=ETargetSearchMode.TargetSearchMode_Trace
	TargetSearchRange=4000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="UNSC_BattleRifle"
	ProjFlightTemplate=ParticleSystem'WP_UNSC_BR85.Effects.WP_UNSC_BR85_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_UNSC_BR85.Effects.WP_UNSC_BR85_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Speed=7000.0000000
	MaxSpeed=7000.0000000
	Damage=20.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_BattleRifle'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_BattleRifleBullet.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=7000.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=1.4299999
	CollisionComponent=CollisionCylinder
}