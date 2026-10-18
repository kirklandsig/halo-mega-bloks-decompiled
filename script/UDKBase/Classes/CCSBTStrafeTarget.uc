class CCSBTStrafeTarget extends GripBTNode
	native;

var bool CanStrafe_Left;
var bool CanStrafe_Right;
var bool CanStrafe_Back;
var bool CanStrafe_Forward;
var float ShootChance;
var float ChargedShotChance;
var int FireBurstPerShot;
var float DelayBetweenBursts;

defaultproperties
{
	CanStrafe_Left=true
	CanStrafe_Right=true
	ShootChance=0.2500000
	FireBurstPerShot=3
	DelayBetweenBursts=0.4000000
	NodeDescription="Perform evasive strafing."
	DefaultTitle="Strafe Target"
}