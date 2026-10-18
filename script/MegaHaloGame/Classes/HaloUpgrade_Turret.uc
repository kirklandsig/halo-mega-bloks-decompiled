class HaloUpgrade_Turret extends HaloUpgrade
	notplaceable;

var int Health;
var float AttackRange;
var float Spread;
var float FireRate;
var float BurstTime;
var float BurstCooldown;
var float TargetInterpTime;
var LinearColor MeshColor;
var Projectile ProjectileArchetype;

defaultproperties
{
	MeshColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
}