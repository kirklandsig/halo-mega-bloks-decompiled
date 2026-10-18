class CCSBTEncircleTarget extends GripBTNode
	native;

var bool CanCircle_Left;
var bool CanCircle_Right;
var bool ForceFire;
var float ShootChance;
var int FireBurstPerShot;
var float DelayBetweenBursts;

defaultproperties
{
	CanCircle_Left=true
	CanCircle_Right=true
	ForceFire=true
	ShootChance=0.2500000
	FireBurstPerShot=3
	DelayBetweenBursts=0.4000000
	NodeDescription="Circle the target with a chance to fire at them."
	DefaultTitle="Encircle Target"
}