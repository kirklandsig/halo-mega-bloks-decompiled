class HaloProjectile_ShotgunPellet extends HaloProjectile;

var float NearDamage;
var float NearDamageRange;
var float FarDamage;
var float FarDamageRange;
var Vector SpawnLocation;

function Init(Vector Direction)
{
	SpawnLocation = Location;
	super.Init(Direction);
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local float Dist, T;

	Dist = VSize(Location - SpawnLocation);
	// End:0x49
	if(Dist <= NearDamageRange)
	{
		T = 0.0000000;		
	}
	else
	{
		// End:0x72
		if(Dist >= FarDamageRange)
		{
			T = 1.0000000;			
		}
		else
		{
			T = (Dist - NearDamageRange) / (FarDamageRange - NearDamageRange);
		}
	}
	Damage = Lerp(NearDamage, FarDamage, T);
	super.ProcessTouch(Other, HitLocation, HitNormal);
	//return;	
}

defaultproperties
{
	NearDamage=15.0000000
	NearDamageRange=250.0000000
	FarDamage=5.0000000
	FarDamageRange=2500.0000000
	TargetSearchMode=TargetSearchMode_Trace
	TargetSearchRange=3000.0000000
	TargetAngularSearchRange=10.0000000
	SeekingTurnRate=32767.0000000
	akWeaponType="UNSC_Shotgun"
	ProjFlightTemplate=ParticleSystem'wp_unsc_m90_shgun.Effects.WP_UNSC_M90_SHGUN_PRT'
	ProjExplosionTemplate=ParticleSystem'wp_unsc_m90_shgun.Effects.WP_UNSC_M90_SHGUN_Hit'
	MaxEffectDistance=3500.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=60.0000000
	Speed=5800.0000000
	MaxSpeed=6000.0000000
	Damage=15.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_ShotgunPellet'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_ShotgunPellet.CollisionCylinder'
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
	LifeSpan=1.0000000
	CollisionComponent=CollisionCylinder
}