class CCSBTShoot extends GripBTNode
	native;

var int FireBurstPerShot;
var float DelayBetweenBursts;
var float ChargedShotChance;

defaultproperties
{
	FireBurstPerShot=1
	DelayBetweenBursts=0.4000000
	NodeDescription="Shoot Selected Target. Re-orient if necessary. Succeed after given number of fire burst is taken. Fails if there is no Line of Fire to the Target."
	DefaultTitle="Shoot"
}